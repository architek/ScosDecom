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

use Mouse;
extends 'ScosDecom::Packet';

has 'tm' => ( is => 'ro' );
sub decode { print "Wrong decode called: TMPacket"; }

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

