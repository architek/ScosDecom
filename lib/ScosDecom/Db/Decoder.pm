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

Ccsds - Module used to identify packets based on a SpaceCraft Database

=cut

use Moo;
use ScosDecom::TMPacketFix;
use ScosDecom::TMPacketVPD;
use ScosDecom::Utils;
use Tie::IxHash;

#use ScosDecom::TMPacketVpd;
use ScosDecom::Utils;

has 'mib' => ( is => 'ro' );

sub decode {
    my $self = shift;
    my ( $tm, $raw ) = @_;
    my $packet;

    my $res;
    tie %$res, 'Tie::IxHash';

    $res->{header}=$self->encode_res_header($tm);
    
    #detect tm/tc based on tm->{Packet Header}{'Packet Id'}{Apid}{Pcat}
    my $spid = $self->_find_spid( $tm, $raw );

    if ( exists $self->mib->Plf->fields->{$spid} ) {
        $res->{packet}=$self->encode_res_pid($self->mib->Pid->fields->{$spid});
        $packet = ScosDecom::TMPacketFix->new(
            tm  => $tm,
            raw => $raw,
            plf => $self->mib->Plf->fields->{$spid},
            mib => $self->mib
        );
    }
    elsif ( exists $self->mib->Vpd->fields->{$spid} ) {
        $res->{packet}=$self->encode_res_pid($self->mib->Pid->fields->{$spid});
        $packet = ScosDecom::TMPacketVPD->new(
            tm  => $tm,
            raw => $raw,
            spid => $spid,
            vpd => $self->mib->Vpd->tree->{$spid},
            mib => $self->mib
        );
    }
    else {
        die "Did not find packet for spid $spid\n";
        return undef;
    }
    tie %{$res->{params}}, 'Tie::IxHash';
    $packet->decode($res->{params});
    return $res;
}

sub encode_res_header {
    my ($self,$tm)=@_;
    my $res;
    tie %$res, 'Tie::IxHash';

    my $t_st=tm_get_type_stype($tm);
    return "No Pus Header" unless ($t_st);
    
    $res->{type}=$t_st->[0];
    $res->{subtype}=$t_st->[1];
    return $res;
}

sub encode_res_pid{
    my ($self,$pid_entry)=@_;
    return $pid_entry->{pid_descr};
}

sub _find_spid {
    my $self = shift;
    my ( $tm, $raw ) = @_;
    my $res_pic = $self->_find_pic( $tm, $raw );
    my $spid = $self->_find_pid( $res_pic, $tm, $raw );
    return $spid;
}

sub _find_pic {
    my $self = shift;
    my ( $tm, $raw ) = @_;
    my ( $s, $ss ) = ( 0, 0 );
    my $h = $tm->{'Packet Header'};
    if ( $h->{'Packet Id'}->{'DFH Flag'} != 0 ) {
        my $sh = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
        $s  = $sh->{'Service Type'};
        $ss = $sh->{'Service Subtype'};
    }
    my $apid = $h->{'Packet Id'}->{vApid};

    #that's where the data begins Header + optionnaly data Header
    for my $pic ( @{ $self->mib->Pic->fields } ) {
        if ( $pic->{pic_type} == $s && $pic->{pic_stype} == $ss ) {
            if ( defined( $pic->{pic_apid} ) && $pic->{pic_apid} ne $apid ) {
                return 0;
            }
            else {

                #Return reference to the hash in pic table
                return $pic;
            }
        }
    }
}

sub _find_pid {
    my $self = shift;
    my ( $pic_info, $tm, $raw ) = @_;
    my ( $s, $ss ) = ( 0, 0 );
    my $h    = $tm->{'Packet Header'};
    my $apid = $h->{'Packet Id'}->{vApid};
    if ( $h->{'Packet Id'}->{'DFH Flag'} != 0 ) {
        my $sh = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
        $s  = $sh->{'Service Type'};
        $ss = $sh->{'Service Subtype'};
    }
    for my $spid ( keys %{ $self->mib->Pid->fields } ) {
        my $pid_entry = $self->mib->Pid->fields->{$spid};
        if (   $s == $pid_entry->{pid_type}
            && $ss == $pid_entry->{pid_stype}
            && $apid == $pid_entry->{pid_apid} )
        {

            #remains 2 fields about offset PI1 PI2
            return $spid
              if ( !$pic_info || pic_match( $raw, $pic_info, $pid_entry ) );
        }

        #Specific case for broken 9_2 def
        if (   $h->{'Packet Id'}->{'DFH Flag'} == 0
            && $pid_entry->{pid_apid} == 0 )
        {
            return $spid;
        }
    }
    return 0;    #No spid found (0 is not an allowed scos pid)
}

#We found a spid (type,subtype,apid match) , cross check if pic offsets match pids val
sub pic_match {
    my ( $raw, $pic, $pid ) = @_;

    #return true if no criteria
    return 1 if $pic->{pic_pi1_off} == -1;

    #return false if off1 is wrong
    return 0
      unless extract_bitstream( $raw, 8 * $pic->{pic_pi1_off},
              $pic->{pic_pi1_wid} ) == $pid->{pid_pi1_val};

    #return true if no criteria for off2
    return 1 if $pic->{pic_pi2_off} == -1;

    #return comparison for off2
    return extract_bitstream( $raw, 8 * $pic->{pic_pi2_off},
        $pic->{pic_pi2_wid} ) == $pid->{pid_pi2_val};
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

