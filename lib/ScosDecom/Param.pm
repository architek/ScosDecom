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

#returns undef if value could not be extracted due to boundary error
#or unknown ptc,pfc
sub get_param_val {
    my ( $self, $raw, $offby, $offbi ) = @_;
    my $val;

    my ( $ptc, $pfc ) = $self->get_size();

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
    elsif ( $ptc == 5 and $pfc == 2) {    # double precision real
        $val = extract_bitstream( $raw, $offby * 8 + $offbi, $len);
        $val = unpack('d<',pack('Q',$val)) if defined($val);
    }
    elsif ( $ptc == 9 ) {                 # Time
        die "Not handled" unless ( $offbi == 0 && $pfc == 18 );
        my $t = CUC( 4, 3 );
        if (length($raw)>=($offby+7)) {
            my $decoded = $t->parse( substr( $raw, $offby, 7 ) );
            $val = $decoded->{OBT} . "s";
        } else {
            mlog "Not enough bytes to decode CUC time\n";
        }
    }
    else {
        die "unknown Ptc $ptc for ". $self->pcf->{pcf_descr} . "\n";
    }

    return $val if defined($val);
    #Raise and alarm and return 0 if undefined (out of bounds)
    mlog "get_param_val() was not computed for Parameter ". $self->pcf->{pcf_descr}. ", returning 0\n";
    return 0;
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

