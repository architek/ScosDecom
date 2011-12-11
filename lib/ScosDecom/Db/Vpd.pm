#
#===============================================================================
#
#         FILE: Vpd.pm
#
#  DESCRIPTION: Vpd File
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

package ScosDecom::Db::Vpd;

use warnings;
use strict;

use Mouse;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvArray';

has 'tree' => (
    is      => 'rw',          #its should actually be ro
    lazy    => 1,
    builder => '_new_tree',
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    $class->$orig(
        filename => "MIB/vpd.dat",
        keys     => $fields{vpd},
        index    => "vpd_tpsd"
    );
};

sub _new_tree {
    my $self = shift;
    my %vpd_tree;

    for ( keys %{ $self->fields() } ) {
        $vpd_tree{$_} = [];
        $self->_build_vpd_tree( $_, 0, scalar @{ $self->fields()->{$_} },
            $vpd_tree{$_} );
    }
    return \%vpd_tree;
}

sub _build_vpd_tree {
    my ( $self, $tpsd, $pos_from, $pos_len, $head ) = @_;
    my $pkt = $self->fields()->{$tpsd};
    for ( my $i = $pos_from ; $i < $pos_len ; $i++ ) {
        push @{$head}, $pkt->[$i];
        my $grpsize = $pkt->[$i]->{vpd_grpsize};
        if ($grpsize) {
            $pkt->[$i]->{vpd_tree} = [];
            $self->_build_vpd_tree(
                $tpsd, $i + 1,
                $i + 1 + $grpsize,
                $pkt->[$i]->{vpd_tree}
            );
            $i += $grpsize;
        }
    }
}

1;

