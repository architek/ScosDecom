#
#===============================================================================
#
#         FILE: Utils.pm
#
#  DESCRIPTION: Utilities
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 02/12/2011 23:09:11
#     REVISION: ---
#===============================================================================

package ScosDecom::Utils;

use warnings;
use strict;

=head1 NAME

Ccsds - Module containing several bit/bytes manipulation utilities

=cut

sub dprint {
    my $debug = 0;
    print "$_[0]\n" if ($debug);
}

sub bin2dec {
    return unpack( "N", pack( "B32", substr( "0" x 32 . shift, -32 ) ) );
}

#extract bitstream from raw, off and len are bit numbering!
#bigendian, LSB is left positionned
#0        1        2        3
#01234567 89012345 67890123 45678901
#00000000 00111111 22222222 22222233
sub extract_bitstream {
    my ( $raw, $off, $len, $sign ) = @_;

    #inclusive offset
    my $off2i = $off + $len - 1;
    my ( $from, $to ) = map { int( $_ / 8 ) } ( $off, $off2i );
    my ( $off_l, $off2_r ) = map { $_ % 8 } ( $off, $off2i );
    my $n = $to - $from + 1;
    my $val = substr( $raw, $from, $n );

    #off_ goes from 0 to 7
    #0 is ff or 01 (2^8 to 2^1)
    #7 is 01 or ff (2^1 to 2^8)

    #Trim left/right bits
    my $mask_l = pack( "b8", "1" x ( 8 - $off_l ) );
    my $mask_r = pack( "B8", "1" x ( $off2_r + 1 ) );
    substr( $val, 0,  1 ) = ( substr( $val, 0,  1 ) & $mask_l );
    substr( $val, -1, 1 ) = ( substr( $val, -1, 1 ) & $mask_r );
    dprint "val masked is => ", unpack( 'H*', $val ), "\n";
    my $num = 0;
    dprint "n=$n,Raw to decode:" . unpack( 'H*', $val ) . "\n";
    for ( my $i = 0 ; $i < $n ; $i++ ) {

        #$num = $num + 256 + unpack('C',substr($val,$i,1));
        $num = $num * 256 + unpack( 'C', substr( $val, $i, 1 ) );
    }

    #shift to right
    $num = $num >> ( 7 - $off2_r );

#nulliffy MSB - side effect: is not possible to get the max negative value. (for 8 bits: from -127 to 127)
    $num = -int( $num / 2 ) - 1 if ($sign);
    $num;
}

sub ScosType2BitLen {
    my ( $ptc, $pfc ) = @_;
    my $len;

    if ( $ptc == 2 ) {
        $len = $pfc;
    }
    elsif ( $ptc == 3 or $ptc == 4 ) {
        if ( $pfc == 13 ) {
            $len = 24;
        }
        elsif ( $pfc == 14 ) {
            $len = 32;
        }
        elsif ( $pfc <= 12 ) {
            $len = $pfc + 4;
        }
        else {
            die "ptc:$ptc,pfc:$pfc not supported by Scos 2000\n";
        }
    }
    elsif ( $ptc == 7 ) {
        $len = $pfc;
    }
    $len;
}

sub tm_get_type_stype {
    my ($tm) = @_;
    return undef unless ( $tm->{'Packet Header'}->{'Packet Id'}->{'DFH Flag'} );
    my $sh = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
    return [ $sh->{'Service Type'}, $sh->{'Service Subtype'} ];
}

sub tc_get_type_stype {
    my ($tc) = @_;
    return undef unless ( $tc->{'Packet Header'}->{'Packet Id'}->{'DFH Flag'} );
    my $sh = $tc->{'Packet Data Field'}->{'TCSourceSecondaryHeader'};
    return [ $sh->{'Service Type'}, $sh->{'Service Subtype'} ];
}

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(extract_bitstream bin2dec ScosType2BitLen tm_get_type_stype tc_get_type_stype);

=head1 SYNOPSIS

This library adds some helpers for working on bit bytes fields among other stuffs

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Utils


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

