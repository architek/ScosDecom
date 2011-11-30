#
#===============================================================================
#
#         FILE: Pid.pm
#
#  DESCRIPTION: Pid File
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

package ScosDecom::Db::Pid;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvHash';

around BUILDARGS => sub {
      my $orig  = shift;
      my $class = shift;

      return $class->$orig( filename=>"MIB/pid.dat", keys=>$fields{pid}, index=>"pid_spid");
};

1; 

