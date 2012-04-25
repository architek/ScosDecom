#
#===============================================================================
#
#         FILE: Cur.pm
#
#  DESCRIPTION: Cur File
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

package ScosDecom::Db::Cur;

use warnings;
use strict;

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvArray';

#TODO : sort by cur_pos

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/cur.dat",
        keys     => $fields{cur},
        index    => "cur_pname"
    );
};

1;

