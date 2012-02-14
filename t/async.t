#!/usr/bin/perl
use strict;
use warnings;

use WWW::xkcd;
use Test::More;

# check for AnyEvent and AnyEvent::HTTP
eval 'use AnyEvent';
$@ and plan skip_all => 'AnyEvent required for this test';

eval 'use AnyEvent::HTTP';
$@ and plan skip_all => 'AnyEvent::HTTP required for this test';

# actual test
plan tests => 9;

my $x = WWW::xkcd->new;
isa_ok( $x, 'WWW::xkcd' );
can_ok( $x, 'fetch'     );

# TODO: add timer that ends the cv so test doesn't linger when not working
my $cv = AnyEvent->condvar;
{
    # just callback
    $cv->begin;
    $x->fetch( sub {
        my $data = shift;
        ok( $data, 'Successful fetch' );
        is( ref $data, 'HASH', 'Correct data from fetch' );
        ok( exists $data->{'title'}, 'Got title in data' );
        $cv->end;
    } );
}

{
    # comic number and callback
    $cv->begin;
    $x->fetch( 20, sub {
        my $data = shift;
        ok( $data, 'Successful fetch' );
        is( ref $data, 'HASH', 'Correct data from fetch' );
        ok( exists $data->{'title'}, 'Got title in data' );
        is( $data->{'title'}, 'Ferret', 'Fetched correct comic' );
        $cv->end;
    } );
}

$cv->recv;

