use inc::Module::Install;

name 'ScosDecom';
all_from 'lib/ScosDecom.pm';
author q{Laurent KISLAIRE <teebeenator@gmail.com>};
license 'perl';

build_requires 'Test::More';
requires 'Math::Interpolate' => '0';
requires 'Mouse'             => '0';
requires 'Ccsds'             => '0';

test => {
    TESTS =>

      #        q[t/00-load.t t/boilerplate.t t/pod.t t/01-crc.t t/02-decode.t]
      q[t/00-load.t ]
};

auto_install;

WriteAll;

