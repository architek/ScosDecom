#
#===============================================================================
#
#         FILE: Plf.pm
#
#  DESCRIPTION: Plf File
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

package ScosDecom::Db::Plf;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvArray';

around BUILDARGS => sub {
      my $orig  = shift;
      my $class = shift;

      return $class->$orig( filename=>"MIB/plf.dat", keys=>$fields{plf}, index=>"plf_spid");
};

1; 

