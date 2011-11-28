#
#===============================================================================
#
#         FILE: Packet.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 21/11/2011 23:28:29
#     REVISION: ---
#===============================================================================

package ScosDecom::Packet;

use warnings;
use strict;

=head1 NAME

Packet - Polymorph class that can be derived in TMPacket and TCPacket

=cut

sub new {
    my $proto=shift;
    my $class=ref($proto)||$proto;
    my $self={};
    my $type=shift;
    my ($raw,$decoded)=@_;
    my %def_attrs = (
        raw => $raw,
        decoded => $decoded,
    );
    if ( $type ) { 
      $type= __PACKAGE__ . "::$type";
      eval " use $type; " ;
      die $@ if $@;
      $self= new $type;
      for my $key (keys %def_attrs){
        $self->{$key} = $def_attrs{$key} if not $self->{$key};
      }
      bless $self,$type;
    } else {
      bless $self,$class; 
      return $self;
    }
}
sub mdecode {
    my $self=shift;
    print "Packet::decode\n";
    &{$self->{decoder}};
}

#require Exporter;
#our @ISA = qw(Exporter);
#our @EXPORT = qw($VERSION);

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

