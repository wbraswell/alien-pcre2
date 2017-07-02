# DEV NOTE, CORRELATION #ap011: must `make install` before `make test` to avoid 'error while loading shared libraries: libpcre2-8.so.0: cannot open shared object file: No such file or directory'
# this script simply forces `make install` to be called at the very beginning of `make test`

use strict;
use warnings;
our $VERSION = 0.003_000;

use Test::More tests => 1;
use IPC::Cmd qw(can_run);
use English qw(-no_match_vars);  # for $OSNAME
use Data::Dumper;  # DEBUG

# NEED ADD: Alien::gmake support
#use Alien::gmake;
#use Env qw( @PATH );
# add bin_dir() to @PATH...

# NEED ADD: actual tests
ok(1, 'Must force `make install` before `pcre2grep` command will operate, no actual tests run');

if ($OSNAME eq 'MSWin32') {
    my $dmake_path = can_run('dmake');
    my $gmake_path = can_run('gmake');
    my $make_path = can_run('make');
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS, have $dmake_path = '}, $dmake_path, q{'}, "\n\n";
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS, have $gmake_path = '}, $gmake_path, q{'}, "\n\n";
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS, have $make_path = '}, $make_path, q{'}, "\n\n";
    if (defined $dmake_path) { 
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS dmake, about to call system '}, $dmake_path, q{ install'...}, "\n\n";
        system $dmake_path . ' install';
    }
    elsif (defined $gmake_path) {
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS gmake, about to call system '}, $gmake_path, q{ install'...}, "\n\n";
        system $gmake_path . ' install';
    }
    elsif (defined $make_path) {
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, MS Windows OS make, about to call system '}, $make_path, q{ install'...}, "\n\n";
        system $make_path . ' install';
    }
    else { die 'No dmake or gmake or make found, dying'; }
}
else {
print {*STDERR} "\n\n", q{<<< DEBUG >>> in test.pl, real OS, about to call system 'make install'...}, "\n\n";
    system 'make install';
}
