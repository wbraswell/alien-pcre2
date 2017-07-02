use strict;
use warnings;
our $VERSION = 0.003_000;

use Test::More tests => 12;
use File::Spec;
use Capture::Tiny qw( capture_merged );
use Env qw( @PATH );
use IPC::Cmd qw(can_run);
use English qw(-no_match_vars);  # for $OSNAME
use Data::Dumper;  # DEBUG

use_ok('Alien::PCRE2');
unshift @PATH, Alien::PCRE2->bin_dir;

# check if `pcre2-config` can be run, if so get path to binary executable
my $pcre2_path = undef;
if ($OSNAME eq 'MSWin32') {
    $pcre2_path = can_run('pcre2-config.exe');  # NEED ANSWER: is this correct???
}
else {
    $pcre2_path = can_run('pcre2-config');
}
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $pcre2_path = '}, $pcre2_path, q{'}, "\n\n";
ok(defined $pcre2_path, '`pcre2-config` binary path is defined');
isnt($pcre2_path, q{}, '`pcre2-config` binary path is not empty');

# run `pcre2-config --version`, check for valid output
my $version = [ split /\r?\n/, capture_merged { system "$pcre2_path --version"; }];
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $version = }, Dumper($version), "\n\n";
cmp_ok((scalar @{$version}), '==', 1, '`pcre2-config --version` executes with 1 line of output');

my $version_0 = $version->[0];
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $version_0 = '}, $version_0, q{'}, "\n\n";
ok(defined $version_0, '`pcre2-config --version` 1 line of output is defined');
#ok($version_0 =~ m/^([\d\.]+)$/xms, '`pcre2-config --version` 1 line of output is valid');  # NEED ENABLE: stable releases only
ok($version_0 =~ m/^([\d\.]+)-DEV$/xms, '`pcre2-config --version` 1 line of output is valid');  # NEED DISABLE: unstable pre-release '-DEV' only

my $version_split = [split /[.]/, $1];
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $version_split = }, Dumper($version_split), "\n\n";
my $version_split_0 = $version_split->[0] + 0;
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $version_split_0 = '}, $version_split_0, q{'}, "\n\n";
cmp_ok($version_split_0, '>=', 10, '`pcre2-config --version` returns major version 10 or newer');
if ($version_split_0 == 10) {
    my $version_split_1 = $version_split->[1] + 0;
    cmp_ok($version_split_1, '>=', 23, '`pcre2-config --version` returns minor version 23 or newer');
}

# run `pcre2-config --cflags`, check for valid output
my $cflags = [ split /\r?\n/, capture_merged { system "$pcre2_path --cflags"; }];
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $cflags = }, Dumper($cflags), "\n\n";
cmp_ok((scalar @{$cflags}), '==', 1, '`pcre2-config --cflags` executes with 1 line of output');

my $cflags_0 = $cflags->[0];
print {*STDERR} "\n\n", q{<<< DEBUG >>> have $cflags_0 = '}, $cflags_0, q{'}, "\n\n";
ok(defined $cflags_0, '`pcre2-config --cflags` 1 line of output is defined');
is((substr $cflags_0, 0, 2), '-I', '`pcre2-config --cflags` 1 line of output starts correctly');
#ok($cflags_0 =~ m/([\w\.\-\s\\\/\:]+)$/xms, '`pcre2-config --cflags` 1 line of output is valid');  # disabled, use OS-specific matches below instead
if ($OSNAME eq 'MSWin32') {
    ok($cflags_0 =~ m/([\w\.\-\s\\\:]+)$/xms, '`pcre2-config --cflags` 1 line of output is valid');  # match -IC:\dang_windows\paths\ -ID:\drive_letters\as.well
}
else {
    ok($cflags_0 =~ m/([\w\.\-\s\/]+)$/xms, '`pcre2-config --cflags` 1 line of output is valid');  # match -I/some_path/to.somewhere/ -I/and/another
}
