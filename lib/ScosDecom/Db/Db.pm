#
#===============================================================================
#
#         FILE: Db.pm
#
#  DESCRIPTION: Loads MIB files into objects
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
#      COMPANY:
#      VERSION: 1.0
#      CREATED: 01/12/2011 23:50:19
#     REVISION: ---
#===============================================================================

package ScosDecom::Db::Db;

use warnings;
use strict;

=head1 NAME

Ccsds - Module used to load MIB files into objects

=cut

use Mouse;
use ScosDecom::Db::Caf;
use ScosDecom::Db::Ccf;
use ScosDecom::Db::Cdf;
use ScosDecom::Db::Cpc;
use ScosDecom::Db::Cur;
use ScosDecom::Db::Mcf;
use ScosDecom::Db::Pcf;
use ScosDecom::Db::Pic;
use ScosDecom::Db::Pid;
use ScosDecom::Db::Plf;
use ScosDecom::Db::Tpcf;
use ScosDecom::Db::Txf;
use ScosDecom::Db::Txp;
use ScosDecom::Db::Vpd;

has 'Caf'  => ( is => 'rw', builder => '_build_Caf' );
has 'Ccf'  => ( is => 'rw', builder => '_build_Ccf' );
has 'Cdf'  => ( is => 'rw', builder => '_build_Cdf' );
has 'Cpc'  => ( is => 'rw', builder => '_build_Cpc' );
has 'Cur'  => ( is => 'rw', builder => '_build_Cur' );
has 'Mcf'  => ( is => 'rw', builder => '_build_Mcf' );
has 'Pcf'  => ( is => 'rw', builder => '_build_Pcf' );
has 'Pic'  => ( is => 'rw', builder => '_build_Pic' );
has 'Pid'  => ( is => 'rw', builder => '_build_Pid' );
has 'Plf'  => ( is => 'rw', builder => '_build_Plf' );
has 'Tpcf' => ( is => 'rw', builder => '_build_Tpcf' );
has 'Txf'  => ( is => 'rw', builder => '_build_Txf' );
has 'Txp'  => ( is => 'rw', builder => '_build_Txp' );
has 'Vpd'  => ( is => 'rw', builder => '_build_Vpd' );

sub _build_Caf  { ScosDecom::Db::Caf->new }
sub _build_Ccf  { ScosDecom::Db::Ccf->new }
sub _build_Cdf  { ScosDecom::Db::Cdf->new }
sub _build_Cpc  { ScosDecom::Db::Cpc->new }
sub _build_Cur  { ScosDecom::Db::Cur->new }
sub _build_Mcf  { ScosDecom::Db::Mcf->new }
sub _build_Pcf  { ScosDecom::Db::Pcf->new }
sub _build_Pic  { ScosDecom::Db::Pic->new }
sub _build_Pid  { ScosDecom::Db::Pid->new }
sub _build_Plf  { ScosDecom::Db::Plf->new }
sub _build_Tpcf { ScosDecom::Db::Tpcf->new }
sub _build_Txf  { ScosDecom::Db::Txf->new }
sub _build_Txp  { ScosDecom::Db::Txp->new }
sub _build_Vpd  { ScosDecom::Db::Vpd->new }

has 'tm_ignored' => ( is => 'rw' );
has 'packet_ignored' => ( is => 'rw' );

sub is_tm_ignored {
    my ($self,$name)=@_;
    return (defined ($self->tm_ignored()) and exists $self->tm_ignored()->{$name} and $self->tm_ignored()->{$name} == 1 );
}

sub is_packet_ignored {
    my ($self,$name)=@_;
    return exists $self->packet_ignored()->{$name};
}

=head1 SYNOPSIS

This library needs to be called to initialized objects from MIB files. The object can then be used while decoding TM/TC traffic

=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom::Db::Db


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;

