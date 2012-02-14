use strict;
use warnings;
package WWW::xkcd;

use Carp;
use JSON;
use Try::Tiny;
use HTTP::Tiny;

sub new {
    my $class = shift;
    my %args  = (
        baseurl => 'http://xkcd.com',
        file    => 'info.0.json',
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

