#
#===============================================================================
#
#         FILE: Packet.pm
#
#  DESCRIPTION:
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 21/11/2011 23:28:29
#     REVISION: ---
#===============================================================================

package ScosDecom::Packet;

use warnings;
use strict;

=head1 NAME

Packet - Generic packet class

=cut

use Mouse;
has 'raw' => ( is => 'ro' );
has 'mib' => ( is => 'ro' );

=head1 SYNOPSIS

This library defines generic packet interface used for decoding TM/TC or encoding TC packets

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Packet


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

