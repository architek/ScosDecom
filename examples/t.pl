#!/usr/bin/perl
use strict;
use warnings;

BEGIN { require "custo.pm" }
use Ccsds::Utils;
use Ccsds::TM::File;
use Ccsds::StdTime;
use ScosDecom::Db::Db;
use ScosDecom::Db::Decoder;
use Data::Dumper;

#TODO  Filter on TM Description ex: MM01
#TODO         or on regexp MM[0-9][0-9]
#TODO  Plugins, callbacks
#TODO   on combined=> map TM(1,x) to their TCs
#TODO   on tm flow => SSC gaps, PM reset, tm reset, tm switchover, mfc gaps, apid distribution for last xxs, bandwidth of all vcs, vc distribution on last xxs, idle packets distribution, idle frames distribution
#TODO   on tc flow => Catch DefHK to map on tm 3,25 decoding, authentication, encryption, cop1

my ( $bench_init_time, $bench_time, $sim_time, $channel, $cadu_size );
my $vals;
my $hide_ana = 1;
my ( $nf, $np ) = ( 0, 0 );

my $filename = $ARGV[0] // "tmr.result_data";
my $db_dir   = $ARGV[1] // "MIB/";

open( FILE, "${db_dir}ignored.txt" ) or die $!;
my @iglines = grep /NODE/, <FILE>;
my %ignored = map { ( split "	", $_ )[2] => 1 } @iglines;

#HPTM OBT, WDTG
$ignored{$_} = 1 for qw/GMU0009X GMU0033X GMU023FZ GMU047FZ/;

#SID and RID and EventID(?)
$ignored{$_} = 1
  for
  qw/AAS01ZYX AAS01ZZX GPA05ZYX GPA05ZZX GPF01ZYX GPF01ZZX GTC01ZYX GTC01ZZX GTM01ZYX GTM01ZZX PSS01ZYX PSS01ZZX AAS00Z1X AAS00Z2X AAS00Z3X AAS00Z4X GPA00Z0X GPA00Z1X GPA00Z2X GPA00Z3X GPF00Z0X GPF00Z1X GPF00Z2X GPF00Z3X GPL00Z0X GPL00Z1X GPL00Z2X GPT00Z0X GPT00Z1X GPT00Z2X GPT00Z3X GTC00Z0X GTM11Z0X GTM11Z1X GTM11Z2X HBA00Z0X HBT00Z0X PSS00Z1X PSS00Z2X PSS00Z3X PSS00Z4X HUA38AAE HUA39AAE HUA39JAE HUA39RAE HUT39AAE HUT39JAE HUT39RAE/;
close FILE;

my $mib = ScosDecom::Db::Db->new( dir => "MIB/", tm_ignored => \%ignored );
warn "Mib loaded\n";

my $mibdec = ScosDecom::Db::Decoder->new( mib => $mib );
warn "Decoder loaded\n";

my $config_tm = {
    record_len      => 32 + 4 + 1115 + 160,
    offset_data     => 32 + 4,
    frame_len       => 1115,
    has_sync        => 1,
    coderefs_packet => [ \&scos_tm_decode ],
    coderefs_frame  => [ \&extract_tmfe_record ],
};

$nf = Ccsds::TM::File::read_frames( $filename, $config_tm );
warn "Read $nf frames, $np packets";

sub scos_tm_decode {
    my ( $tm, $raw ) = @_;
    my $res;

    $np++;
    if ( ( $res = $mibdec->decode( $tm, $raw ) ) ) {
        print_pkt( $res, $tm, 1 );
    }
    else {
        print_pkt_head($tm);
        print " Undecoded Packet, Source Data:\n";
        printf "%s\n", hdump( $tm->{'Packet Data Field'}->{'Source Data'} );
    }
}

sub extract_tmfe_record {
    my ( undef, undef, $rec_head ) = @_;
    ( $bench_time, $sim_time, $channel, undef, $cadu_size, undef ) =
      unpack( 'ddVVVV', $rec_head );
    $bench_init_time = $bench_time unless $bench_init_time;
}

sub print_pkt_head {
    my $pk = shift;
    printf "t=%.2fs\t", ${bench_time};
    my $pkh  = $pk->{'Packet Header'};
    my $pkid = $pkh->{'Packet Id'};
    my ( $dfh, $apid, $pid, $pcat ) = (
        $pkid->{'DFH Flag'},  $pkid->{vApid},
        $pkid->{Apid}->{PID}, $pkid->{Apid}->{Pcat}
    );

    if ($dfh) {
        my $sech = $pk->{'Packet Data Field'}->{TMSourceSecondaryHeader};
        my ( $type, $stype, $obt ) = (
            $sech->{'Service Type'},
            $sech->{'Service Subtype'},
            $sech->{Sat_Time}->{OBT}
        );
        print "OBT=${obt}s : TM($type,$stype) ";
    }
    else {
        print "No DFH ";
    }
    print "Apid $apid [Pid $pid,Pcat $pcat]";
}

#print packet diff
sub print_pkt {
    my ( $p, $tm, $diff ) = @_;
    my $pkh_print = 0;

    for my $mnemo ( keys %{ $p->{params} } ) {
        my $par = $p->{params}->{$mnemo};
        next if ( $par->{e_val} =~ m/[0-9]+\.[0-9]+/ and $hide_ana );
        next
          if (
            $diff
            and ( $tm->{'Packet Header'}->{'Packet Id'}->{'DFH Flag'} == 0
                or (
                    $tm->{'Packet Data Field'}->{TMSourceSecondaryHeader}
                    ->{'Service Type'} == 3
                    and ( $tm->{'Packet Data Field'}->{TMSourceSecondaryHeader}
                        ->{'Service Subtype'} == 25
                        or $tm->{'Packet Data Field'}->{TMSourceSecondaryHeader}
                        ->{'Service Subtype'} == 26 )
                )
            )
            and ( exists $vals->{$mnemo} )
            and ( $vals->{$mnemo} eq $par->{val} )
          );

        unless ($pkh_print) {
            print_pkt_head $tm ;
            print " $p->{packet}\n";
            $pkh_print++;
        }
        printf "\t%-65s=%s", "$mnemo [$par->{descr}]",
          "$par->{e_val}$par->{unit}";
        print " ($par->{val})" if $par->{val} ne $par->{e_val};
        print " (was $vals->{$mnemo})" if exists $vals->{$mnemo} and $diff;
        print "\n";
        $vals->{$mnemo} = $par->{val};
    }
}
