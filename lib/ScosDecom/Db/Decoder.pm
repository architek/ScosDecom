#
#===============================================================================
#
#         FILE: Decoder.pm
#
#  DESCRIPTION: Given a Database and a packet, identify and decodes it
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 03/12/2011 17:15:53
#     REVISION: ---
#===============================================================================

package ScosDecom::Db::Decoder;

use warnings;
use strict;

=head1 NAME

Ccsds - Factory Module for building packets and identify them 

=cut

use Mouse;
use ScosDecom::TMPacketFix;
use ScosDecom::TMPacketVPD;
use ScosDecom::Utils;
use Tie::IxHash;
use Data::Dumper;

#use ScosDecom::TMPacketVpd;
use ScosDecom::Utils;

has 'mib' => ( is => 'ro' );

sub decode {
    my ( $self, $tm, $raw ) = @_;
    my $packet;

    my $res;
    tie %$res, 'Tie::IxHash';

    $res->{header} = $self->encode_res_header($tm);

    #detect tm/tc based on tm->{Packet Header}->{'Packet Id'}->{Apid}->{Pcat}
    my $spid = $self->identify( $tm, $raw );
    if ( exists $self->mib->Plf->fields->{$spid} ) {
        $res->{packet} =
          $self->encode_res_pid( $self->mib->Pid->fields->{$spid} );
        $packet = ScosDecom::TMPacketFix->new(
            tm  => $tm,
            raw => $raw,
            plf => $self->mib->Plf->fields->{$spid},
            mib => $self->mib
        );
    }
    elsif ( exists $self->mib->Vpd->fields->{$spid} ) {
        $res->{packet} =
          $self->encode_res_pid( $self->mib->Pid->fields->{$spid} );
        $packet = ScosDecom::TMPacketVPD->new(
            tm   => $tm,
            raw  => $raw,
            spid => $spid,
            vpd  => $self->mib->Vpd->tree->{$spid},
            mib  => $self->mib
        );
    }
    else {
        warn "Did not find packet for spid $spid";
        return undef;
    }
    tie %{ $res->{params} }, 'Tie::IxHash';
    $packet->decode( $res->{params} );
    return $res;
}

sub identify {
    my $self = shift;
    my ( $tm, $raw ) = @_;

    my ( $type, $stype, $sh, $pm );
    my $h    = $tm->{'Packet Header'};
    my $apid = $h->{'Packet Id'}->{vApid};
    my $tree = $self->mib->Pid->tree;

    die "No pid entry for apid $apid" unless exists( $tree->{$apid} );

    #no datafield header
    unless ( $h->{'Packet Id'}->{'DFH Flag'} ) {

        #finds first spid in pid FIXME
        my ($pid_type)  = keys $tree->{$apid};
        my ($pid_stype) = keys $tree->{$apid}->{$pid_type};

        #return spid of the first pid that match
        return $tree->{$apid}->{$pid_type}->{$pid_stype}->[0]->[0];
    }

    $sh    = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
    $type  = $sh->{'Service Type'};
    $stype = $sh->{'Service Subtype'};
    $pm    = $self->mib->Pic->get_pic( $type, $stype, $apid );

    for ( @{ $tree->{$apid}->{$type}->{$stype} } ) {

        if ( !defined($pm) ) {
            if ( $_->[1] == 0 and $_->[2] == 0 ) { return $_->[0]; }
        }
        else {

#            print "bit: ", extract_bitstream( $raw, 8 * $pm->[0], $pm->[1] ) , "\n";
            if ( $pm->[0] == -1 ) {
                return $_->[0];
            }
            elsif (
                $_->[1] == extract_bitstream( $raw, 8 * $pm->[0], $pm->[1] ) )
            {
                if ( $pm->[2] == -1 ) {
                    return $_->[0];
                }
                elsif ( $_->[2] ==
                    extract_bitstream( $raw, 8 * $pm->[2], $pm->[3] ) )
                {
                    return $_->[0];
                }
            }
        }
    }
}

sub encode_res_header {
    my ( $self, $tm ) = @_;
    my $res;
    tie %$res, 'Tie::IxHash';

    my $t_st = tm_get_type_stype($tm);
    return "No Pus Header" unless ($t_st);

    $res->{type}    = $t_st->[0];
    $res->{subtype} = $t_st->[1];
    return $res;
}

sub encode_res_pid {
    my ( $self, $pid_entry ) = @_;
    return $pid_entry->{pid_descr};
}

=head1 SYNOPSIS

This library allows to take a SpaceCraft Database in any format (currently MIB only) and identify packet and use included packet decodes and prints it content
If wanted, it can keep track of values of Telemetries to print only modified ones.

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TEMPLATE


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

