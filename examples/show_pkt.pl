#!/usr/bin/perl
#show tm included in packet
use strict;
use warnings;
use ScosDecom::Db::Db;
use Scalar::Util "looks_like_number";
use ScosDecom::Utils qw/ScosType2BitLen spid_by_descr/;

my $pkt;
my $pre;
my $spid;

my $arg=shift or die "Need a spid or description\n";

my $mib = ScosDecom::Db::Db->new( dir => "MIB" ) or die "Could not load MIB\n";
warn "Mib loaded successfully\n";

if (looks_like_number($arg)) { 
	$spid = $arg 
} else {
	$spid = spid_by_descr($mib,$arg);
	die "Spid not found for description <$arg>\n" unless $spid;
}


warn "Spid $spid, Packet ", $mib->Pid->fields->{$spid}->{pid_descr}, "\n";

#PLF
if (exists $mib->Plf->fields->{$spid}) {
    $pkt=$mib->Plf->fields->{$spid};
    $pre="plf";
} else {
#VPD
    $pkt=$mib->Vpd->fields->{$spid};
    $pre="vpd";
}

for my $parm (@$pkt) {
	my $name=$parm->{$pre . "_name"};
	my $pcf=$mib->Pcf->fields->{$name};
	my $len=ScosType2BitLen($pcf->{ptc},$pcf->{pfc});

	printf "%10s\t%s\t%s\n",$name,$pcf->{pcf_descr},$len;
}

