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

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::Csv';

has 'tree' => (
    is      => 'rw',
    lazy    => 1,
    builder => '_new_tree',
);

#This class directly derives from csv as we want an array of lines and not an indexed table
#self, table, undef , $fields
sub _add_elt {
    push @{ $_[1] }, $_[3];
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

#build pic identification hash
sub _new_tree {
    my ($self) = @_;
    my $tree;
    for ( @{ $self->fields } ) {
        my $apid = $_->{pic_apid} // "";
        $tree->{ $_->{pic_type} }->{ $_->{pic_stype} }->{$apid} = [
            $_->{pic_pi1_off}, $_->{pic_pi1_wid},
            $_->{pic_pi2_off}, $_->{pic_pi2_wid}
        ];
    }
    $tree;
}

sub get_pic {
    my ( $self, $type, $stype, $apid ) = @_;
    return $self->tree->{$type}->{$stype}->{$apid}
      if exists( $self->tree->{$type}->{$stype}->{$apid} );
    return $self->tree->{$type}->{$stype}->{""}
      if exists( $self->tree->{$type}->{$stype}->{""} );
    #Nothing
    return;
}

1;

