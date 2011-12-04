#
#===============================================================================
#
#         FILE: TMParam.pm
#
#  DESCRIPTION:
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 21/11/2011 23:35:42
#     REVISION: ---
#===============================================================================

package ScosDecom::TMParam;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to implement TM Parameters 

=cut

use ScosDecom::Utils;
use Ccsds::StdTime;
use Scalar::Util "looks_like_number";
use ScosDecom::Cal::StatCal;
use ScosDecom::Cal::NumCal;
use ScosDecom::Cal::PolCal;

use Moo;
extends 'ScosDecom::Param';

has 'pcf' => ( is => 'ro' );

#res is to output results to the caller
#return val is used for repetition counters to make it easier
sub decode {
    my ( $self, $raw, $offby, $offbi, $res ) = @_;

    my $val = $self->get_param_val( $raw, $offby, $offbi );
    my $e_val = $self->to_eng($val);

    $res->{descr}=$self->pcf->{pcf_descr};
    $res->{e_val}=$e_val;
    $res->{unit}=$self->pcf->{pcf_unit};
    $res->{val}=$val;
    $val;
}

sub get_param_val {
    my ( $self, $raw, $offby, $offbi ) = @_;
    my $val;

    my ( $ptc, $pfc ) = ( $self->pcf->{ptc}, $self->pcf->{pfc} );
    my $len = ScosType2BitLen( $ptc, $pfc );

    if ( $ptc == 7 ) {    # Octet String
        $val = unpack( 'H*', substr( $raw, $offby, $pfc ) );
    }
    elsif ( $ptc == 2 || $ptc == 3 ) {    # unsigned
        $val = extract_bitstream( $raw, $offby * 8 + $offbi, $len );
    }
    elsif ( $ptc == 4 ) {                 # signed
        $val = extract_bitstream( $raw, $offby * 8 + $offbi, $len, 1 );
    }
    elsif ( $ptc == 9 ) {                 # Time
        die "Not handled" unless ( $offbi == 0 && $pfc == 18 );
        my $t = CUC( 4, 3 );
        my $decoded = $t->parse( substr( $raw, $offby, 7 ) );
        $val = $decoded->{OBT} . "s";
    }
    else {
        die "unknown ptc $ptc for $self->plf->{plf_name}\n";
    }
    $val;
}

sub to_eng {
    my ( $self, $val ) = @_;

    my $eng = $val;
    $eng = sprintf( "0x%X", $val ) if looks_like_number($val);

    my $cur = $self->pcf->{pcf_curtx};
    if ( $self->pcf->{pcf_categ} eq 'S' ) {

        #index is in txf, cal must exist
        my $cal=ScosDecom::Cal::StatCal->new(txp=>$self->mib->Txp->fields->{$cur});
        $eng=$cal->calc($val);

    }
    elsif ( $self->pcf->{pcf_categ} eq 'N' ) {

        #index is in caf, mcf or lgf or empty or pcf 6,7,9,10
        #for 7,9,10: no curtx should be found
        unless ($self->pcf->{ptc} == 7 or $self->pcf->{ptc} == 9 or $self->pcf->{ptc} == 10) {
            if (exists $self->mib->Caf->fields->{$cur}) {
                my $cal=ScosDecom::Cal::NumCal->new(caf=>$self->mib->Caf->fields->{$cur});
                $eng=$cal->calc($val);
            } elsif (exists $self->mib->Mcf->fields->{$cur}) {
                my $cal=ScosDecom::Cal::PolCal->new(mcf=>$self->mib->Mcf->fields->{$cur});
                $eng=$cal->calc($val);
            }
        }
    }
    elsif ( $self->pcf->{pcf_categ} eq 'T' ) {

        #index must be empty, must correspond to pcf = 8
        #no curtx should be found
    }

    #curtx must be emtpy for param found in cur.dat
    return $eng;

}

=head1 SYNOPSIS

This library allows handling TM Parameters

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::TMParam


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

