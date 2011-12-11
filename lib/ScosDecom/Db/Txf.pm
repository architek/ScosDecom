#
#===============================================================================
#
#         FILE: Txf.pm
#
#  DESCRIPTION: Txf File
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

package ScosDecom::Db::Txf;

use warnings;
use strict;

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvHash';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/txf.dat",
        keys     => $fields{txf},
        index    => "txf_numbr"
    );
};

1;

