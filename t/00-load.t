#!perl -T

use Test::More tests => 33;

BEGIN {
    use_ok('ScosDecom')                || print 'Bail out!  ';
    use_ok('ScosDecom::TMPacketVPD')   || print 'Bail out!  ';
    use_ok('ScosDecom::Param')         || print 'Bail out!  ';
    use_ok('ScosDecom::TCParam')       || print 'Bail out!  ';
    use_ok('ScosDecom::Packet')        || print 'Bail out!  ';
    use_ok('ScosDecom::Cal::PolCal')   || print 'Bail out!  ';
    use_ok('ScosDecom::Cal::NumCal')   || print 'Bail out!  ';
    use_ok('ScosDecom::Cal::StatCal')  || print 'Bail out!  ';
    use_ok('ScosDecom::TMParam')       || print 'Bail out!  ';
    use_ok('ScosDecom::Utils')         || print 'Bail out!  ';
    use_ok('ScosDecom::TMPacketFix')   || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Vpd')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Cap')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Pic')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Mcf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::CsvArray')  || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Decoder')   || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Tpcf')      || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Csv')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Cpc')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Ccf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Db')        || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Txp')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Pid')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Cdf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::FieldsDef') || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Txf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::CsvHash')   || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Pcf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Plf')       || print 'Bail out!  ';
    use_ok('ScosDecom::Db::Caf')       || print 'Bail out!  ';
    use_ok('ScosDecom::TCPacket')      || print 'Bail out!  ';
    use_ok('ScosDecom::TMPacket')      || print 'Bail out!  ';
}

diag("Testing ScosDecom Library loading $ScosDecom::VERSION, Perl $], $^X");
