#
#===============================================================================
#
#         FILE: Pic.pm
#
#  DESCRIPTION: Pic File
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 28/11/2011 22:36:32
#     REVISION: ---
#===============================================================================

package ScosDecom::Db::Pic;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::Csv';

#This class directly derives from csv as we want an array of lines and not an indexed table
#self, table, undef , $fields
sub _add_elt {
    push @{$_[1]}, $_[3];
}


around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/pic.dat",
        keys     => $fields{pic},
        index    => undef,
    );
};

1;

