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
use Data::Dumper;

use Mouse;
extends 'ScosDecom::Param';

has 'pcf' => ( is => 'ro' );

#res is to output results to the caller
#return val is used for repetition counters to make it easier
sub decode {
    my ( $self, $raw, $offby, $offbi, $res ) = @_;

    my $val = $self->get_param_val( $raw, $offby, $offbi );
    my $e_val = $self->to_eng($val);

    $res->{descr} = $self->pcf->{pcf_descr};
    $res->{e_val} = $e_val;
    $res->{unit}  = $self->pcf->{pcf_unit};
    $res->{val}   = $val;
    $val;
}

sub get_size {
    return ( $_[0]->pcf->{ptc}, $_[0]->pcf->{pfc} );
}

#Return cal curve for a TM Parameter
sub get_curve { my ( $self )=@_;

    my $curve = $self->pcf->{pcf_curtx};
    #curtx must be emtpy for param found in cur.dat
    if ( $self->mib->Cur->fields and exists $self->mib->Cur->fields->{ $self->mnemo } ) {
        if ($curve) {
            mlog $self->mnemo . " has a curtx and is defined in cur.dat, ignoring cur.dat\n";
        }
        else {

            #find calibration curve
            my ($cal_n,$rel_is_def);
            my $cal_cond = $self->mib->Cur->fields->{ $self->mnemo };

            foreach ( @{$cal_cond} ) {
                next unless defined ( ::get_tm_val( $_->{cur_rlchk} ) );
                $rel_is_def = 1;
                if ( $_->{cur_valpar} == ::get_tm_val( $_->{cur_rlchk} ) ) {
                    $cal_n = $_->{cur_select};
                    last;
                }
            }
            mlog "Conditionnal Calibration: no rlchk has a value! returning raw \n" unless $rel_is_def;
            if ($cal_n)  {
                $curve=$cal_n; 
            } else { 
                mlog "No matching conditionnal calibration curve found for " . $self->mnemo . "\n";
            }
        }
    }
    return $curve;
}

sub to_eng {
    my ( $self, $val ) = @_;

    my $eng = $val;
    $eng = sprintf( "0x%X", $val ) if looks_like_number($val);
    my $cur = $self->get_curve;
    if ( $self->pcf->{pcf_categ} eq 'S' ) {
        #index is in txf, cal must exist
        my $cal = ScosDecom::Cal::StatCal->new( txp => $self->mib->Txp->fields->{$cur} );
        $eng = $cal->calc($val);
    }
    elsif ( $self->pcf->{pcf_categ} eq 'N' ) {
        #index is in caf, mcf or lgf or empty or pcf 6,7,9,10
        #for 7,9,10: no curtx should be found
        if (    $self->pcf->{ptc} != 7 and $self->pcf->{ptc} != 9 and $self->pcf->{ptc} != 10 )
        {
            if ( exists $self->mib->Caf->fields->{$cur} ) {
                my $cal = ScosDecom::Cal::NumCal->new( caf => $self->mib->Caf->fields->{$cur} );
                $eng = $cal->calc($val);
            }
            elsif ( exists $self->mib->Mcf->fields->{$cur} ) {
                my $cal = ScosDecom::Cal::PolCal->new( mcf => $self->mib->Mcf->fields->{$cur} );
                $eng = $cal->calc($val);
            }
        }
    }
    elsif ( $self->pcf->{pcf_categ} eq 'T' ) {
        #index must be empty, must correspond to pcf = 8
        #no curtx should be found
    }

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

