#
#===============================================================================
#
#         FILE: CsvHash.pm
#
#  DESCRIPTION: 
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

package ScosDecom::Db::Csv;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to 

=cut

use Moo;

has 'fields' => ( 
    is=>'ro',
    builder=>'_build_csv',
    );

sub _csv_name { 
    my $self=shift;
    my ($line,$names) = @_;
    my @val=split m/\t/, $line;
    my %hash;
    @hash{@$names}=@val;
    return \%hash;
}

=head1 SYNOPSIS

This library allows 

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

