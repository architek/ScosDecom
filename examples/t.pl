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

my ( $bench_init_time, $bench_time, $sim_time, $channel, $cadu_size );
my $vals;
my ( $nf, $np ) = ( 0, 0 );

my $filename=$ARGV[0] // "tmr.result_data";
my $db_dir=$ARGV[1] // "MIB/";

open( FILE, "${db_dir}ignored.txt" ) or die $!;
my @iglines=grep /NODE/, <FILE>;
my %ignored = map { (split "	", $_ )[2] => 1 } @iglines;
close FILE;

my $mib = ScosDecom::Db::Db->new( dir => "MIB/" , tm_ignored => \%ignored);
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
        print_pkt( $res, 1 );
    }
    else {
        print CcsdsDump($tm);
    }
}

sub extract_tmfe_record {
    my ( undef, undef, $rec_head ) = @_;
    ( $bench_time, $sim_time, $channel, undef, $cadu_size, undef ) =
      unpack( 'ddVVVV', $rec_head );
    $bench_init_time = $bench_time unless $bench_init_time;
}

sub print_pkt_head {
    my $p = shift;
    print "$bench_time\t";
    if ( $p->{header}->{sec} ) {
        print $p->{header}->{obt}, " : TM(", $p->{header}->{type}, ",",
          $p->{header}->{subtype}, ") ";
    }
    else {
        print "No DFH: ";
    }
    print $p->{packet}, "\n";
}

#print packet diff
sub print_pkt {
    my ( $p, $diff ) = @_;
    my $pkh_print = 0;

    print_pkt_head($p) unless ($diff);
    for my $mnemo ( keys %{$p->{params} } ) {
        my $par = $p->{params}->{$mnemo};
        next
          if (  $diff and ( exists $vals->{$mnemo} )
            and ( $vals->{$mnemo} eq $par->{val} ) );
        if ($diff and !$pkh_print ) {
                print_pkt_head($p);
                $pkh_print++;
        }
        print "\t$mnemo [$par->{descr}] = $par->{e_val} $par->{unit}";
        print " ($par->{val})" if $par->{val} ne $par->{e_val};
        print "\n";
        $vals->{$mnemo} = $par->{val};
    }
}
