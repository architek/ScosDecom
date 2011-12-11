#
#===============================================================================
#
#         FILE: Param.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 21/11/2011 23:35:42
#     REVISION: ---
#===============================================================================

package ScosDecom::Param;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to handle generic parameters

=cut

use Mouse;

has 'mib' => ( is=>'ro' );

=head1 SYNOPSIS

This library allows handling generic parameters: tc paramers and tm parameters

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Param


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 

