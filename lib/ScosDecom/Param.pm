#
#===============================================================================
#
#         FILE: Param.pm
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

package ScosDecom::Param;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to handle generic parameters

=cut

use Mouse;
use Ccsds::StdTime;
use ScosDecom::Utils;

has 'mib' => ( is => 'ro' );
has 'mnemo' => ( is => 'ro' );

#returns val as extracted from raw stream 
#if not enough bytes or unknown type, returns 0 and logs a warning
sub get_param_val {
    my ( $self, $raw, $offby, $offbi ) = @_;

    my ( $ptc, $pfc ) = $self->get_size();

    my $len = ScosType2BitLen( $ptc, $pfc );
    my $val = ext_bit( $raw, $offby * 8 + $offbi, $len );

    if (! defined($val) ) { #Raise and alarm and return 0 if undefined (out of bounds)
        mlog "get_param_val() was not computed for Parameter ". $self->pcf->{pcf_descr}. ", not enough bytes. Returning 0\n";
        return 0;
    }

    if ( $ptc == 2 or $ptc == 3 or $ptc == 4) {    # enum or unsigned or signed
        $val = hex unpack( 'H*' , $val );
        #C2 representation for signed
        $val = -(2**$len - $val) if ( $ptc == 4 and $val&1<<$len-1 );
    }
    elsif ( $ptc == 5 and $pfc == 1) {    # simple precision float
        $val = unpack('f',$val);
        #mlog "raw:" . substr(unpack('H*',$raw),$offby*2,$len/8*2). ", val=$val\n" ;
    }
    elsif ( $ptc == 5 and $pfc == 2) {    # double precision real
        $val = unpack('d',$val);
        #mlog "raw:" . substr(unpack('H*',$raw),$offby*2,$len/8*2). ", val=$val\n" ;
    }
    elsif ( $ptc == 7 ) {    # Octet String
        $val = unpack( 'H*', substr( $raw, $offby, $pfc ) );
    }
    elsif ( $ptc == 8 ) {    # Ascii String
        $val = unpack( 'A*', substr( $raw, $offby, $pfc ) );
    }
    elsif ( $ptc == 9 and $offbi == 0 and $pfc == 18 ) {  # CUC(4,3) time
        my $t = CUC( 4, 3 );
        my $decoded = $t->parse( substr( $raw, $offby, 7 ) );
        $val = $decoded->{OBT} . "s";
    }
    else {
        mlog "Unknown Ptc,Pfc $ptc,$pfc for parameter ". $self->pcf->{pcf_descr} . "\n";
    }

    if (! defined($val) ) { #Raise and alarm and return 0 if undefined (unpack/pack failed)
        mlog "get_param_val() was not computed for Parameter ". $self->pcf->{pcf_descr}. ". (un)pack failure. Returning 0\n";
        return 0;
    }

    $val;
}

=head1 SYNOPSIS

This library allows handling generic parameters: tc paramers and tm parameters

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Param


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

