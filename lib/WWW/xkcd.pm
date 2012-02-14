use strict;
use warnings;
package WWW::xkcd;
# ABSTRACT: Synchronous and asynchronous interfaces to xkcd comics

use Carp;
use JSON;
use Try::Tiny;
use HTTP::Tiny;

sub new {
    my $class = shift;
    my %args  = (
        baseurl => 'http://xkcd.com',
        file    => 'info.0.json', # FIXME: rename this
        @_,
    );

    return bless { %args }, $class;
}

sub fetch {
    my $self = shift;
    my $base = $self->{'baseurl'};
    my $file = $self->{'file'};
    my ( $comic, $cb );

    # @_ = $num, $cb
    # @_ = $num
    # @_ = $cb
    if ( @_ == 2 ) {
        ( $comic, $cb ) = @_;
    } elsif ( @_ == 1 ) {
        if ( ref $_[0] ) {
            $cb = $_[0];
        } else {
            $comic = $_[0];
        }
    }

    my $url = defined $comic ?  "$base/$comic/$file" : "$base/$file";

    $self->_http_get( $url, $cb );
}

sub _http_get {
    my $self         = shift;
    my ( $url, $cb ) = @_;

    if ($cb) {
        # this is async
        eval "use AnyEvent";
        $@ and croak 'AnyEvent is required for async mode';

        eval 'use AnyEvent::HTTP';
        $@ and croak 'AnyEvent::HTTP is required for async mode';

        AnyEvent::HTTP::http_get( $url, sub {
            my $body = shift;
            my $data = $self->_decode_json($body);

            return $cb->($data);
        } );

        return 0;
    } else {
        # this is sync
        my $result = HTTP::Tiny->new->get($url);

        $result->{'success'} or croak "Can't fetch $url: " .
            $result->{'reason'};

        my $data = $self->_decode_json( $result->{'content'} );

        return $data;
    }

    return 1;
}

sub _decode_json {
    my $self = shift;
    my $json = shift;
    my $data = try   { decode_json $json                }
               catch { croak "Can't decode '$json': $_" };

    return $data;
}

1;

__END__

=head1 SYNOPSIS

    use WWW::xkcd;
    my $xkcd  = WWW::xkcd->new;
    my $comic = $xkcd->fetch; # provides latest data
    say "Today's comic is titled: ", $comic->{'title'};

    # or in async mode
    $xkcd->fetch( sub {
        my $comic = shift;
        say "Today's comic is titled: ", $comic->{'title'};
    } );

=head1 DESCRIPTION

This module allows you to access xkcd comics (L<http://www.xkcd.com/>) using
the official API in synchronous mode (what people are used to) or in
asynchronous mode.

The asynchronous mode requires you have L<AnyEvent> and L<AnyEvent::HTTP>
available. However, since it's just I<supported> and not I<crucial>, it is not
declared as a prerequisite.

Currently it retrieves the metadata of each comic, but it will probalby also
fetch the actual comic in the next release.

This module still hasn't materialized so some things might change, but probably
not a lot, if at all.

=head1 METHODS

=head2 new

Create a new L<WWW::xkcd> object.

    # 'file' will probably be renamed
    my $xkcd = WWW::xkcd->new(
        base_url => 'http://www.xkcd.com',
        file     => 'info.0.json',
    );

=head2 fetch

Fetch the metadata of the comic. This method will probably be renamed, stay
tuned.

    # fetching the latest
    my $comic = $xkcd->fetch;

    # fetching a specific one
    my $comic = $xkcd->fetch(20);

    # using callbacks for async mode
    $xkcd->fetch( sub { my $comic = shift; ... } );

    # using callbacks for a specific one
    $xkcd->fetch( 20, sub { my $comic = shift; ... } );

=head1 DEPENDENCIES

=over 4

=item * Try::Tiny

=item * HTTP::Tiny

=item * JSON

=item * Carp

=back

