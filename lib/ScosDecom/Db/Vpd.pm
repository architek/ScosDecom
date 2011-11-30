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
extends 'ScosDecom::Db::CsvHash';

my %fields;

@{$fields{pid}} = qw { pid_type pid_stype pid_apid pid_pi1_val pid_pi2_val pid_spid pid_descr pid_unit pid_tpsd pid_dfhsize pid_time pid_inter pid_valid pid_check pid_event pid_evid };

around BUILDARGS => sub {
      my $orig  = shift;
      my $class = shift;

      return $class->$orig( filename=>"MIB/pid.dat", keys=>$fields{pid}, index=>"pid_spid");
};

1; 

