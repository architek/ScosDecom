#
#===============================================================================
#
#         FILE: NumCal.pm
#
#  DESCRIPTION: Numerical Calibration
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 04/12/2011 01:24:21
#     REVISION: ---
#===============================================================================

package ScosDecom::Cal::NumCal;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to return numeric interpolated values out of raw param

=cut
use Mouse;
use Math::Interpolate;

has 'caf' => (is=>'ro');

sub calc {
    my ($self,$val)=@_;
    #FIXME always extrapolating
    return (Math::Interpolate::linear_interpolate($val,$self->caf->{xvals},$self->caf->{yvals}))[0];
}

=head1 SYNOPSIS

This library allows manipulation of textual representation for parameters

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

