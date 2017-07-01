use strict;
use warnings;
our $VERSION = 0.001_000;

use Test::More tests => 12;
use File::Spec;
use Env qw( @PATH );
use IPC::Cmd qw(can_run);
use English qw(-no_match_vars);  # for $OSNAME

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
ok(defined $pcre2_path, '`pcre2-config` binary path is defined');
isnt($pcre2_path, q{}, '`pcre2-config` binary path is not empty');

# split pcre2-config executable file from directory containing it
(my $pcre2_volume, my $pcre2_directories, my $pcre2_file) = File::Spec->splitpath($pcre2_path);
my $pcre2_directory = File::Spec->catpath($pcre2_volume, $pcre2_directories, q{});

# test pcre2 directory permissions
ok(defined $pcre2_directory, 'Alien::PCRE2->bin_dir() is defined');
isnt($pcre2_directory, q{}, 'Alien::PCRE2->bin_dir() is not empty');
ok(-e $pcre2_directory, 'Alien::PCRE2->bin_dir() exists');
ok(-r $pcre2_directory, 'Alien::PCRE2->bin_dir() is readable');
ok(-d $pcre2_directory, 'Alien::PCRE2->bin_dir() is a directory');

# test pcre2 executable permissions
ok(-e $pcre2_path, 'pcre2-config exists');
ok(-r $pcre2_path, 'pcre2-config is readable');
ok(-f $pcre2_path, 'pcre2-config is a file');
ok(-x $pcre2_path, 'pcre2-config is executable');
