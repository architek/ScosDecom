#
#===============================================================================
#
#         FILE: TMPacketVPD.pm
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

package ScosDecom::TMPacketVPD;

use warnings;
use strict;

=head1 NAME

TMPacketVPD

=cut

use Mouse;
extends 'ScosDecom::TMPacket';
use Tie::IxHash;

use ScosDecom::TMParam;
use ScosDecom::Utils;

has 'vpd'         => ( is => 'ro' );
has 'spid'        => ( is => 'ro' );
has 'vpd_off_bin' => ( is => 'rw' );

sub decode {
    my ( $self, $res ) = @_;

    #first parameter is to be found after the dfh
    $self->vpd_off_bin( 8 * $self->mib->Pid->fields->{ $self->spid }->{pid_dfhsize} );

    #Start recursive decoding beginning with head of the tree
    $self->vpd_decode( $self->vpd, $res );
}

#Recursive sub
sub vpd_decode {
    my ( $self, $vpd, $res ) = @_;

    for my $vpdl (@$vpd) {
        my $pname = $vpdl->{vpd_name};
        die "VPD was not found" unless $pname;

        my $p = ScosDecom::TMParam->new(
            mib   => $self->mib,
            pcf   => $self->mib->Pcf->fields->{$pname},
            mnemo => $pname
        );
        %{ $res->{$pname} } = ();
        $self->{vpd_off_bin}+=$vpdl->{vpd_offset};

        my $val = $p->decode( $self->raw, int( $self->{vpd_off_bin} / 8 ), $self->{vpd_off_bin} % 8, $res->{$pname} );
        $self->{vpd_off_bin} += ScosType2BitLen( $self->mib->Pcf->fields->{$pname}->{ptc}, $self->mib->Pcf->fields->{$pname}->{pfc} );

        if ( $vpdl->{vpd_grpsize} > 0 ) {

            #As repeated parameters might have the same name, we need an array
            $res->{$pname}->{params} = [];
            for ( 0 .. ( $val - 1 ) ) {
                tie %{ $res->{$pname}->{params}->[$_] } , 'Tie::IxHash';
                $self->vpd_decode( $vpdl->{vpd_tree}, $res->{$pname}->{params}->[$_] );
            }
        }
    }
}

=head1 SYNOPSIS

This library allows decoding Packet with Variable size

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::TMPacketVPD


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

