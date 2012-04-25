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

use Ccsds::Utils;

=head1 NAME

Ccsds - Module containing some utilities

=cut

my $log;
#
#Gobal Log to app
sub clrlog { 
    undef $log;
}

sub mlog { 
    $log .= shift if $_[0] ;
    $log ;
}

#
#Binary to decimal converter
sub bin2dec { return unpack( "N", pack( "B32", substr( "0" x 32 . shift, -32 ) ) ); }

#
#Extract bitstream or undef if too short
sub ext_bit { my ( $raw, $off, $len , $debug) = @_;
    #Convert to byte bounded binary representation
    my $braw=unpack('B*',$raw);

    if ($len+$off>length($braw)) {
        mlog "Trying to extract outside packet: off=$off,len=$len,offbytes=" . $off/8 . ",raw is:\n" . hdump($raw) . "\n";
        return undef;
    }
    return pack( "B*", "0"x(8-$len%8) . substr $braw, $off, $len );
}


#
sub ScosType2BitLen { my ( $ptc, $pfc ) = @_;
    if    ( $ptc == 2 ) { 
        return $pfc; 
    }
    elsif ( $ptc == 3 or $ptc == 4 ) {
        if ( $pfc >=0 and $pfc <= 12 ) { return $pfc + 4; }
        elsif ( $pfc == 13 ) { return 24; }
        elsif ( $pfc == 14 ) { return 32; }
        else  { die "ptc:$ptc,pfc:$pfc not supported by Scos 2000\n"; }
    }
    elsif ( $ptc == 5 and $pfc == 1) { return 32; }
    elsif ( $ptc == 5 and $pfc == 2) { return 64; }
    elsif ( $ptc == 7 or  $ptc == 8) { return $pfc; }
    elsif ( $ptc == 9 and $pfc == 18 ) { return 56; }
    die "ptc,pfc $ptc,$pfc not done";
}

#
sub tm_get_type_stype {
    my ($tm) = shift;
    return unless ( $tm->{'Packet Header'}->{'Packet Id'}->{'DFH Flag'} );
    my $sh = $tm->{'Packet Data Field'}->{'TMSourceSecondaryHeader'};
    return [ $sh->{'Service Type'}, $sh->{'Service Subtype'} ];
}

#
sub tc_get_type_stype {
    my ($tc) = shift;
    return unless ( $tc->{'Packet Header'}->{'Packet Id'}->{'DFH Flag'} );
    my $sh = $tc->{'Packet Data Field'}->{'TCSourceSecondaryHeader'};
    return [ $sh->{'Service Type'}, $sh->{'Service Subtype'} ];
}

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT =
  qw(clrlog mlog ext_bit bin2dec ScosType2BitLen tm_get_type_stype tc_get_type_stype);

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

