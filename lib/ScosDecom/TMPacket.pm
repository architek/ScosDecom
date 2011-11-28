#
#===============================================================================
#
#         FILE: TMPacket.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 23/11/2011 23:00:23
#     REVISION: ---
#===============================================================================

package ScosDecom::TMPacket;

use warnings;
use strict;

=head1 NAME

TMPacket - Polymorph class derived from Packet that can be derived in TMVpdPacket or TMFixedPacket

=cut

use Moo;

has 'raw' => (is=>'ro');
has 'tm' => (is=>'ro');

sub decode {
    my $self=shift;
    my $spid=_find_spid($self->tm,$self->$raw);
}

sub _find_spid {
    my ($tm, $raw)=@_;
    my $res_pic=pic_find($tm);
#    print Dumper($res_pic);
    my $spid=pid_find($tm,$raw,$res_pic);
    return $spid;
}

=head1 SYNOPSIS

This library allows 

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TEMPLATE


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 

