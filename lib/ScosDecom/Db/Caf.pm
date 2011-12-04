#
#===============================================================================
#
#         FILE: Caf.pm
#
#  DESCRIPTION: Caf File
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

package ScosDecom::Db::Caf;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
use ScosDecom::Db::Cap;
extends 'ScosDecom::Db::CsvHash';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/caf.dat",
        keys     => $fields{caf},
        index    => "caf_numbr"
    );
};

#Merge all cap entries in caf for further Math::Interpolate
sub BUILD {
    my $self = shift;
    my $cap  = ScosDecom::Db::Cap->new;
    for my $rcaf ( keys %{$self->fields} ) {
        for my $rcap ( @{ $cap->fields->{$rcaf} } ) {
            push @{ $self->fields->{$rcaf}->{xvals} }, $rcap->{cap_xvals};
            push @{ $self->fields->{$rcaf}->{yvals} }, $rcap->{cap_yvals};
        }
    }
}

#self, table, indexval, $fields
sub _add_elt {
    $_[1]->{ $_[2] } = $_[3];
}

1;

