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

has 'tree' => (
    is      => 'rw',          #it should actually be ro
    lazy    => 1,
    builder => '_new_tree',
);
has 'pic' => ( is => 'rw' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(
        filename => "MIB/pid.dat",
        keys     => $fields{pid},
        index    => "pid_spid"
    );
};

sub _get_pic {
    my ( $self, $type, $stype ) = @_;

    # No pic found for type subtype
    return undef;
}

#Pic optionnal selection tree
sub pic_tree {
    my ( $self, $node, $type, $subtype ) = @_;
    my $node;

    for ( $self->pic->fields ) {
        if ( $type == $_->{pic_type} and $subtype == $_->{pic_subtype} ) {

            #apid as next hybrid selector:
            my $pic_apid = "";
            $pic_apid = $_->{pic_apid} if defined( $_->{pic_apid} );
            my $anode = Tree->new($pic_apid)
              ; # we don't check if this apid already exist for this (t,st), first one is taken at decoding as specified
            $node->add_child($anode);
            $anode->add_child(
                Tree
                  ->new( # we don't check if this pi1 pi2 already exist for this apid, first one is taken at decoding as specified
                    [
                        $_->{pic_pi1_off}, $_->{pic_pi1_wid},
                        $_->{pic_pi2_off}, $_->{pic_pi2_wid}
                    ]
                  )
            );
        }
    }
}

#build the decommutation tree
#FIXME used cpan module
sub _new_tree {
    my $self = shift;
    $self->pic  = new ScosDecom::Db::Pic->new();
    $self->tree = Tree->new("root");
    my ( $parent, $node );
    for ( keys $self->fields() ) {
        my $pid   = $self->fields->{$_};
        my $apid  = $pid->{pid_apid};
        my $type  = $pid->{type};
        my $stype = $pid->{stype};
        my $pi1v  = $pid->{pid_pi1_val};
        my $pi2v  = $pid->{pid_pi2_val};
        $parent = $self->tree;

        #create apid node unless already exist
        $node = undef;
        for ( $parent->children ) {
            $node = $_ if $_->value == $apid;
        }
        unless ($node) {
            $node = Tree->new($apid);
            $parent->add_child($node);
        }

        #create type node unless already exist
        $parent = $node;
        $node   = undef;
        for ( $parent->children ) {
            $node = $_ if $_->value == $type;
        }
        unless ($node) {
            $node = Tree->new($type);
            $parent->add_child($node);
        }

        #create stype node unless already exist
        $parent = $node;
        $node   = undef;
        for ( $parent->children ) {
            $node = $_ if $_->value == $stype;
        }
        unless ($node) {
            $node = Tree->new($stype);
            $parent->add_child($node);
        }

        #Add pic optional children for t,st
        pic_tree( $node, $type, $subtype );

    }
}

1;

