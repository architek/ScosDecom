#
#===============================================================================
#
#         FILE: NumCal.pm
#
#  DESCRIPTION: Handing of Cal and Cap
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 30/11/2011 22:57:28
#     REVISION: ---
#===============================================================================

package NumCal;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used for cal/cap

=cut

use Moo;
use ScosDecom::Db::Cal;
use ScosDecom::Db::Caf;

#extends 'ScosDecom::Cal::Cal'; #TODO

has 'cal' => (
    is      => 'ro',          
 #   lazy    => 1,
    builder  => '_new_cal',
);

has 'caf' => (
    is      => 'ro',          
 #   lazy    => 1,
    builder  => '_new_caf',
);

sub _new_cal { ScosDecom::Db::Cal->new() }
sub _new_caf { ScosDecom::Db::Caf->new() }

sub to_eng {
    
}

=head1 SYNOPSIS

This library allows handling of cal/cap

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Cal::NumCal


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 

