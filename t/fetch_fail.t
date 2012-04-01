#!perl
# checks that fetch can fail

use strict;
use warnings;

use WWW::xkcd;
use Test::More tests => 5;
use Test::Fatal;

{
    no warnings qw/redefine once/;

    *HTTP::Tiny::get = sub {
        my $self = shift;
        my $img  = shift;

        isa_ok( $self, 'HTTP::Tiny' );
        is( $img, 'http://xkcd.com/100/info.0.json', 'Correct img' );

        # this is purposely missing 'success' key
        return { reason => 'bwahaha' };
    };
}

my $x = WWW::xkcd->new();
isa_ok( $x, 'WWW::xkcd' );
can_ok( $x, 'fetch'     );

like(
    exception { $x->fetch(100) },
    qr/bwahaha/,
    'Failed with good reason',
);

