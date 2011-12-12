package ScosDecom;

use warnings;
use strict;

=head1 NAME

ScosDecom - Module used to decode Ccsds TM/TC based on SCOS Database

=cut

our $VERSION = '0.2';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw($VERSION);

=head1 SYNOPSIS
 
 This library allows decoding TM/TC packet based on SCOS Database
 
 Here's an example on how to decode frame binary logfile. The pure CCSDS part is using ccsds-standalone library.
 
 #!/usr/bin/perl
 use strict; use warnings;
 # Ccsds customization based on your project, see ccsds-standalone library for details
 BEGIN { require "custo.pm" }
 use ScosDecom::Db::Db;
 use ScosDecom::Db::Decoder;
 
 #ccsds-standalone for frame level decoding. you don't need this library if your logfile are packets
 use Ccsds::Utils;
 use Ccsds::TM::File;
 use Ccsds::TC::File;
 use Ccsds::StdTime;
 
 use Data::Dumper;
 
 my ( $bench_init_time, $bench_time, $sim_time, $channel, $cadu_size );
 my $MIB_dir = "MIB/";
 my $nf      = 0;
 my $argtm   = $ARGV[0] ;
 
 my $mib = ScosDecom::Db::Db->new( dir => $MIB_dir );
 print "Mib loaded\n";
 
 my $mibdec = ScosDecom::Db::Decoder->new( mib => $mib );
 print "Decoder loaded\n";
 
 #ccsds-standalone auto configuration to describe your logfiles and where to find frames in them
 #for more details, see ccsds-standalone documentation
 my $config_tm = {
     record_len => 32 + 4 + 1115 + 160,   
     offset_data => 32 + 4,    
     frame_len   => 1115,      
     debug       => 0,         
     has_sync    => 1,         
 
     coderefs_packet => [ \&scos_tm_decode ],
 };
 
 $nf = Ccsds::TM::File::read_frames( $argtm, $config_tm );
 warn "Read $nf frames\n";
 
 #Call back called from ccsds-standalone library for every packet found
 sub scos_tm_decode {
     my ( $tm, $raw ) = @_;
     return if is_idle $tm ;
 
 #Decode 
     my $res = $mibdec->decode( $tm, $raw );
 # print results
     print Dumper($res);
 }

This will result in packets dumped like this one: (this one is a variable packet)

 {
   'header' => {
                 'type' => 6,
                 'subtype' => 6
               },
   'packet' => 'TM_PM_DUMP_PM_PROM_MEMORY',
   'params' => {
                 'GPA2200E' => {
                                 'descr' => 'REP MEM ID 6_6',
                                 'e_val' => 'MEMPMPROM',
                                 'unit' => '',
                                 'val' => 1
                               },
                 'GPA2201X' => {
                                 'descr' => 'REP START AD 6_6',
                                 'e_val' => '0x0',
                                 'unit' => '',
                                 'val' => 0
                               },
                 'GPA22P0U' => {
                                 'descr' => 'PM PROM NB SAU',
                                 'e_val' => '0x8',
                                 'unit' => '',
                                 'val' => 8,
                                 'grp' => [
                                            #0
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0xCA',
                                                              'unit' => '',
                                                              'val' => 160
                                                            }
                                            },
                                            #1
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0xFE',
                                                              'unit' => '',
                                                              'val' => 16
                                                            }
                                            },
                                            #2
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0xFA',
                                                              'unit' => '',
                                                              'val' => 0
                                                            }
                                            },
                                            #3
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0xDA',
                                                              'unit' => '',
                                                              'val' => 0
                                                            }
                                            },
                                            #4
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0xFF',
                                                              'unit' => '',
                                                              'val' => 41
                                                            }
                                            },
                                            #5
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0x0',
                                                              'unit' => '',
                                                              'val' => 0
                                                            }
                                            },
                                            #6
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0x0',
                                                              'unit' => '',
                                                              'val' => 0
                                                            }
                                            },
                                            #7
                                            {
                                              'GPA22P0L' => {
                                                              'descr' => 'PM PROM DATA',
                                                              'e_val' => '0x8',
                                                              'unit' => '',
                                                              'val' => 8
                                                            }
                                            }
                                          ]
                               },
                 'GPA2203X' => {
                                 'descr' => 'REP CHECKSUM 6_6',
                                 'e_val' => '0xFB22',
                                 'unit' => '',
                                 'val' => 64290
                               }
               }
 }
 
 
 Here's another simplistic example for looking up at a TM Parameter:
 
 use ScosDecom::Db::Db;
 use Data::Dumper;
 
 my $MIB_dir = "MIB/";
 my $p=$ARGV[0];
 
 my $mib = ScosDecom::Db::Db->new( dir => $MIB_dir );
 print "Mib loaded\n";
 
 #Print TM information from pcf ( column name and value)
 print Dumper $mib->Pcf->fields->{$p};
 my $cur=$mib->Pcf->fields->{$p}->{pcf_curtx};
 if ($cur) {
     if (exists $mib->Mcf->fields->{$cur}) {
         #Print Polynomial Calibration curve definition if any
         print Dumper $mib->Mcf->fields->{$cur};
     }
 }
 
=head1 AUTHOR

Laurent KISLAIRE, C<< <teebeenator at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<teebeenator at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScosDecom


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Laurent KISLAIRE.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of ScosDecom
