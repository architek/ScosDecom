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

use Mouse;
use ScosDecom::Db::FieldsDef;
use ScosDecom::Db::Pic;
extends 'ScosDecom::Db::CsvHash';

has 'tree' => (
    is      => 'rw',          #it should actually be ro
    lazy    => 1,
    builder => '_new_tree',
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/pid.dat",
        keys     => $fields{pid},
        index    => "pid_spid"
    );
};

#build the pid identification hash
sub _new_tree {
    my $self = shift;

    my $tree;
    for ( keys $self->fields ) {
        my $pid = $self->fields->{$_};
        my $apid  = $pid->{pid_apid};
        my $type  = $pid->{pid_type};
        my $stype = $pid->{pid_stype};
        my $pi1v  = $pid->{pid_pi1_val};
        my $pi2v  = $pid->{pid_pi2_val};

        push @{ $tree->{$apid}->{$type}->{$stype} }, [ $_, $pi1v, $pi2v ];
    }
    $tree;
}

1;

