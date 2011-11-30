#
#===============================================================================
#
#         FILE: CsvHash.pm
#
#  DESCRIPTION: Used to read csv file to store it into a hash of hash
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 28/11/2011 00:44:20
#     REVISION: ---
#===============================================================================

package ScosDecom::Db::CsvHash;

use warnings;
use strict;

=head1 NAME

CsvHash - Module used to store csv file into a hash

=cut

use Moo;
extends 'ScosDecom::Db::Csv';

#self, table, indexval, $fields
sub _add_elt {
    $_[1]->{ $_[2] } = $_[3];
}

=head1 SYNOPSIS

This library allows reading csv files and store them in a hash, indexed by one of the column. Typically for 1-1 relations.

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Db::CsvHash 


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

