#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'ScosDecom' ) || print "Bail out!  ";
    use_ok( 'ScosDecom::Packet' ) || print "Bail out!  ";
    use_ok( 'ScosDecom::Packet::TMPacket' ) || print "Bail out!  ";
}

diag( "Testing ScosDecom Library loading $ScosDecom::VERSION, Perl $], $^X" );
