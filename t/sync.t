#!/usr/bin/perl
use strict;
use warnings;

use WWW::xkcd;
use Test::More tests => 9;

my $x = WWW::xkcd->new;
isa_ok( $x, 'WWW::xkcd' );
can_ok( $x, 'fetch'     );

{
    # without comic number
    my $data = $x->fetch();
    ok( $data, 'Successful fetch' );
    is( ref $data, 'HASH', 'Correct data from fetch' );
    ok( exists $data->{'title'}, 'Got title in data' );
}

{
    # with comic number
    my $data = $x->fetch(20);
    ok( $data, 'Successful fetch' );
    is( ref $data, 'HASH', 'Correct data from fetch' );
    ok( exists $data->{'title'}, 'Got title in data' );
    is( $data->{'title'}, 'Ferret', 'Fetched correct comic' );
}

