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

package ScosDecom::Db::CsvHash;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to 

=cut

use Moo;
extends 'ScosDecom::Db::Csv';

has 'index' => ( is=>'ro');
has 'filename' => ( is=>'ro');
has 'keys' => ( is=>'ro');

sub _build_csv {
    my $self=shift;
    my ($filename,$key,$keys)=($self->filename,$self->index,$self->keys);

    my ($file,%table);
    open($file, '<' , $filename ) or die "can't open file $filename\n";
    while (<$file>) { 
        s/\r//g;
        chomp;
        my $fields = $self->_csv_name($_, $keys);
        my $index=$fields->{$key};
        die "$key is not a key of hash, available are:",join(',',keys %$fields) unless exists $fields->{$key};
        delete $fields->{$key};
        $table{$index}=$fields;
    }
    return \%table;
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

