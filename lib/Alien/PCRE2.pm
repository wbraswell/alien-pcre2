use strict;
use warnings;
package Alien::PCRE2;

our $VERSION = '0.004000';

use base qw( Alien::Base );

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::PCRE2 - Find or download/build/install libpcre2 in PCRE2, the new Perl Compatible Regular Expression engine

=head1 SYNOPSIS

From a Perl script

 use Alien::PCRE2;
 use Env qw(@PATH);
 unshift @PATH, Alien::PCRE2->bin_dir();
 system 'pcre2-config';
 system 'pcre2grep';

=head1 DESCRIPTION

This package can be used by other CPAN modules that require PCRE2 or libpcre2.

B<PLEASE NOTE: This distribution will automatically call C<make install> as part of the C<make test> step!>

This is necessary to avoid the following error when testing the C<pcre2grep> command:

S<C<I<error while loading shared libraries: libpcre2-8.so.0: cannot open shared object file: No such file or directory>>>.

=head1 AUTHOR

William N. Braswell, Jr. <wbraswell@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by William N. Braswell, Jr.;

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
