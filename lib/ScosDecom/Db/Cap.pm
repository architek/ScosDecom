#
#===============================================================================
#
#         FILE: Cap.pm
#
#  DESCRIPTION: Cap File
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

package ScosDecom::Db::Cap;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvArray';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/cap.dat",
        keys     => $fields{cap},
        index    => "cap_numbr"
    );
};

1;

