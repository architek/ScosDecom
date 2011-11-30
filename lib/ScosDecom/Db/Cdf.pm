#
#===============================================================================
#
#         FILE: Cdf.pm
#
#  DESCRIPTION: Cdf File
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

package ScosDecom::Db::Cdf;

use warnings;
use strict;

use Moo;
use ScosDecom::Db::FieldsDef;
extends 'ScosDecom::Db::CsvArray';

has 'tree' => ( 
    is=>'rw',   #its should actually be ro
    lazy=>1,
    builder=>'_new_tree',
);

around BUILDARGS => sub {
      my $orig  = shift;
      my $class = shift;
      $class->$orig( filename=>"MIB/cdf.dat", keys=>$fields{cdf}, index=>"cdf_name");
};

sub _new_tree {
    my $self = shift;
    my %cdf_tree;

    for ( keys %{$self->fields()} ) { 
        $cdf_tree{$_}=[]; 
        $self->_build_cdf_tree($_,0,scalar @{$self->fields()->{$_}},$cdf_tree{$_});
    }
    return \%cdf_tree;
}

sub _build_cdf_tree {
    my ($self,$cdf,$pos_from,$pos_len,$head)=@_;
    my $pkt=$self->fields()->{$cdf};
    for(my $i=$pos_from;$i<$pos_len;$i++) {
       push @{$head},$pkt->[$i];
       my $grpsize=$pkt->[$i]->{cdf_grpsize};
       if ($grpsize) {
           $pkt->[$i]->{cdf_tree}=[];
           $self->_build_cdf_tree( $cdf, $i+1, $i+1+$grpsize, $pkt->[$i]->{cdf_tree} );
           $i+=$grpsize;
       }
    }
}


1; 

