#
#===============================================================================
#
#         FILE: TMPacket.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 23/11/2011 23:00:23
#     REVISION: ---
#===============================================================================

package ScosDecom::TMPacket;

use warnings;
use strict;

=head1 NAME

TMPacket 

=cut

use Moo;
extends 'ScosDecom::Packet';

#use ScosDecom::TMPacketVPD;
#use ScosDecom::TMPacketFixed;
use ScosDecom::Utils;

has 'tm'  => ( is => 'ro' );

sub get_packet {
    my $self=shift;
    my $spid=$self->_find_spid($self->tm,$self->raw);
    return $spid;
}

sub _find_spid {
    my $self=shift;
    my $res_pic=$self->_find_pic();
    my $spid=$self->_find_pid($res_pic);
    return $spid;
}

sub _find_pic {
    my $self=shift;
    my ($s,$ss)=(0,0);
    my $h=$self->tm->{'Packet Header'};
    if ($h->{'Packet Id'}->{'DFH Flag'} != 0) { 
        my $sh=$self->tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'}; 
        $s =$sh->{'Service Type'};
        $ss=$sh->{'Service Subtype'};
    }
    my $apid=$h->{'Packet Id'}->{vApid};
    #that's where the data begins Header + optionnaly data Header 
    for my $pic ( @{$self->mib->Pic->fields} ) {
        if ( $pic->{pic_type}==$s && $pic->{pic_stype}==$ss ) {
            if (defined($pic->{pic_apid}) && $pic->{pic_apid} ne $apid) {
                return 0;
            } else {
                #Return reference to the hash in pic table
                return $pic;
            }
        }
    }
}

sub _find_pid {
    my ($self,$pic_info)=@_;
    my ($s,$ss)=(0,0);
    my $h=$self->tm->{'Packet Header'};
    my $apid=$h->{'Packet Id'}->{vApid};
    if ($h->{'Packet Id'}->{'DFH Flag'} != 0) {
        my $sh=$self->tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'}; 
        $s =$sh->{'Service Type'};
        $ss=$sh->{'Service Subtype'};
    }
    for my $spid ( keys %{$self->mib->Pid->fields} ) {
        my $pid_entry=$self->mib->Pid->fields->{$spid}; 
        if ( $s == $pid_entry->{pid_type} && $ss == $pid_entry->{pid_stype} && $apid == $pid_entry->{pid_apid} ) {
            #remains 2 fields about offset PI1 PI2
            return $spid if (!$pic_info || pic_match($self->raw,$pic_info,$pid_entry));
        }
        #Specific case for broken 9_2 def
        if ( $h->{'Packet Id'}->{'DFH Flag'} == 0 &&  $pid_entry->{pid_apid}==0 ) { 
            return $spid 
        }
    }
    return 0; #No spid found (0 is not an allowed scos pid)
}

#We found a spid (type,subtype,apid match) , cross check if pic offsets match pids val
sub pic_match {
    my ($raw,$pic,$pid) = @_;
    
    #return true if no criteria
    return 1 if $pic->{pic_pi1_off} == -1 ;
    #return false if off1 is wrong
    return 0 unless extract_bitstream($raw,8*$pic->{pic_pi1_off},$pic->{pic_pi1_wid} ) == $pid->{pid_pi1_val};
    #return true if no criteria for off2
    return 1 if $pic->{pic_pi2_off} == -1 ;
    #return comparison for off2
    return extract_bitstream($raw,8*$pic->{pic_pi2_off},$pic->{pic_pi2_wid} ) == $pid->{pid_pi2_val};
}

=head1 SYNOPSIS

This library is a TMPacket Factory Class, it returns a proper VPD or Fixed Packet based on first analysis

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::TMPacket


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 

