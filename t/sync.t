#!/usr/bin/perl
use strict;
use warnings;

use WWW::xkcd;
use Test::More tests => 18;

my $x = WWW::xkcd->new;
isa_ok( $x, 'WWW::xkcd' );
can_ok( $x, qw/fetch fetch_metadata/ );

sub check_meta {
    my $meta = shift;
    ok( $meta, 'Successful fetch' );
    is( ref $meta, 'HASH', 'Correct type of meta' );
    ok( exists $meta->{'title'}, 'Got title in meta' );

    if ( shift ) {
        is( $meta->{'title'}, 'Ferret', 'Got correct title' );
    }
}

sub check_comic {
    my $img = shift;
    ok( $img, 'Got comic image' );
}

foreach my $param ( undef, 20 ) {
    my @params = defined $param ? ($param) : ();

    {
        # no comic number, metadata
        my $meta = $x->fetch_metadata(@params);
        check_meta( $meta, @params );
    }

    {
        my ( $img, $meta ) = $x->fetch(@params);
        check_meta( $meta, @params );
        check_comic($img);
    }
}

