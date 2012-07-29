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
use Tie::IxHash;

use ScosDecom::TMPacketFix;
use ScosDecom::TMPacketVPD;
use ScosDecom::Utils;

has 'mib' => ( is => 'ro' );

sub decode {
    my ( $self, $tm, $raw ) = @_;
    my $packet;

    my $res;
    clrlog();

    #detect tm/tc based on tm->{Packet Header}->{'Packet Id'}->{Apid}->{Pcat}
    if ( $tm->{'Packet Header'}->{'Packet Id'}->{Type} == 0 ) {
        my $spid = $self->identify( $tm, $raw );
        return { log=>"Unknown Spid \n" } unless $spid;
        if ( exists $self->mib->Plf->fields->{$spid} ) {
            $packet = ScosDecom::TMPacketFix->new(
                tm  => $tm,
                raw => $raw,
                plf => $self->mib->Plf->fields->{$spid},
                mib => $self->mib
            );
        }
        elsif ( exists $self->mib->Vpd->fields->{$spid} ) {
            $packet = ScosDecom::TMPacketVPD->new(
                tm   => $tm,
                raw  => $raw,
                spid => $spid,
                vpd  => $self->mib->Vpd->tree->{$spid},
                mib  => $self->mib
            );
        }
        else {
            return { log=>"Neither in Plf nor in Vpd file . This can happen for packet with no data field\n" . mlog() };
        }
        $res->{packet} = $self->encode_res_pid( $self->mib->Pid->fields->{$spid} );
        tie %{ $res->{params} }, 'Tie::IxHash';
        $packet->decode( $res->{params} );
        $res->{log}=mlog() if mlog();
        return $res;
    } elsif ($tm->{'Packet Header'}->{'Packet Id'}->{Type} = 1) {
    }
}

sub identify {
    my $self = shift;
    my ( $tm, $raw ) = @_;

    my ( $type, $stype, $sh, $pm );
    my $h    = $tm->{'Packet Header'};
    my $apid = $h->{'Packet Id'}->{vApid};
    my $tree = $self->mib->Pid->tree;

    if (! exists ($tree->{$apid}) ) {
        mlog "Unknown apid $apid\n" ;
        return ;
    }

    #no datafield header
    unless ( $h->{'Packet Id'}->{'DFH Flag'} ) {

        #finds first spid in pid FIXME
        my ($pid_type)  = keys %{ $tree->{$apid} };
        my ($pid_stype) = keys %{ $tree->{$apid}->{$pid_type} };

        #return spid of the first pid that match
        return $tree->{$apid}->{$pid_type}->{$pid_stype}->[0]->[0];
    }

    $sh    = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
    $type  = $sh->{'Service Type'};
    $stype = $sh->{'Service Subtype'};
    $pm    = $self->mib->Pic->get_pic( $type, $stype, $apid );

    for ( @{ $tree->{$apid}->{$type}->{$stype} } ) {

        if ( !defined($pm) ) {
            return $_->[0] if $_->[1] == 0 and $_->[2] == 0;
        }
        else { if ( $pm->[0] == -1 ) {
                return $_->[0];
            }
            elsif ( $_->[1] == hex unpack('H*',ext_bit( $raw, 8 * $pm->[0], $pm->[1] ) ) )
            {
                if ( $pm->[2] == -1 ) {
                    return $_->[0];
                }
                elsif ( $_->[2] == hex unpack('H*',ext_bit( $raw, 8 * $pm->[2], $pm->[3] ) ))
                {
                    return $_->[0];
                }
            }
        }
    }
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

