use strict;
use warnings;
our $VERSION = 0.020_000;

use Test2::V0;
use Test::Alien;
use Alien::PCRE2;
use English qw(-no_match_vars);  # for $OSNAME
use Data::Dumper;  # DEBUG

plan(10);

# test version flag
alien_ok('Alien::PCRE2', 'Alien::PCRE2 loads successfully and conforms to Alien::Base specifications');
my $run_object = run_ok([ 'pcre2-config', '--version' ], 'Command `pcre2-config --version` runs');
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $run_object->out() = }, Dumper($run_object->out()), "\n";
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $run_object->err() = }, Dumper($run_object->err()), "\n";
$run_object->success('Command `pcre2-config --version` runs successfully');
ok($run_object->out() =~ m/^([\d\.]+)(?:-DEV)?$/xms, 'Command `pcre2-config --version` runs with valid output');

# test actual version numbers
my $version_split = [split /[.]/, $1];
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $version_split = }, Dumper($version_split), "\n";
my $version_split_0 = $version_split->[0] + 0;
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $version_split_0 = '}, $version_split_0, q{'}, "\n";
cmp_ok($version_split_0, '>=', 10, 'Command `pcre2-config --version` returns major version 10 or newer');
if ($version_split_0 == 10) {
    my $version_split_1 = $version_split->[1] + 0;
    cmp_ok($version_split_1, '>=', 23, 'Command `pcre2-config --version` returns minor version 23 or newer');
}

# test cflags flag
$run_object = run_ok([ 'pcre2-config', '--cflags' ], 'Command `pcre2-config --cflags` runs');
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $run_object->out() = }, Dumper($run_object->out()), "\n";
print {*STDERR} "\n", q{<<< DEBUG >>> in t/02_pcre2_config.t, have $run_object->err() = }, Dumper($run_object->err()), "\n";
$run_object->success('Command `pcre2-config --cflags` runs successfully');
$run_object->out_like(qr{^-I}, 'Command `pcre2-config --cflags` output starts correctly'); 
if ($OSNAME eq 'MSWin32') {
    # match -IC:\dang_windows\paths\ -ID:\drive_letters\as.well
    ok($run_object->out() =~ m/([\w\.\-\s\\\:]+)$/xms, 'Command `pcre2-config --cflags` output is valid on Windows OS');
}
else {
    # match -I/some_path/to.somewhere/ -I/and/another
    ok($run_object->out() =~ m/([\w\.\-\s\/]+)$/xms, 'Command `pcre2-config --cflags` output is valid on normal OS');
}
 
done_testing;
