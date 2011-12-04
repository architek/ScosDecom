#
#===============================================================================
#
#         FILE: TMPacketFix.pm
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

package ScosDecom::TMPacketFix;

use warnings;
use strict;

=head1 NAME

TMPacketFix

=cut

use Moo;
extends 'ScosDecom::TMPacket';
use ScosDecom::TMParam;
use Tie::IxHash;

has 'plf' => ( is => 'ro' );

sub decode {
    my ( $self, $res ) = @_;

    for my $param ( @{ $self->plf } ) {
        die unless $param->{plf_nbocc} == 1;

        #Skip mothers
        next if grep /$param->{plf_name}/ , @{$self->mib->{mothers}};

        my $p = ScosDecom::TMParam->new(
            mib => $self->mib,
            pcf => $self->mib->Pcf->fields->{ $param->{plf_name} }
        );
        tie %{$res->{$param->{plf_name}}}, 'Tie::IxHash';
        $p->decode( $self->raw, $param->{plf_offby}, $param->{plf_offbi},
            $res->{$param->{plf_name}});
    }
    return $res;
}

=head1 SYNOPSIS

This library allows 

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::TMPacketFix


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

