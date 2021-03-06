#
#===============================================================================
#
#         FILE: Mcf.pm
#
#  DESCRIPTION: Mcf File
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

package ScosDecom::Db::Mcf;

use warnings;
use strict;

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvHash';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/mcf.dat",
        keys     => $fields{mcf},
        index    => "mcf_ident"
    );
};

1;

