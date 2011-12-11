#
#===============================================================================
#
#         FILE: Cpc.pm
#
#  DESCRIPTION: Cpc File
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

package ScosDecom::Db::Cpc;

use warnings;
use strict;

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvHash';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/cpc.dat",
        keys     => $fields{cpc},
        index    => "cpc_pname"
    );
};

1;

