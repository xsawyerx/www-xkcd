SYNOPSIS
        use WWW::xkcd;
        my $xkcd  = WWW::xkcd->new;
        my ( $img, $comic ) = $xkcd->fetch; # provides latest comic
        say "Today's comic is titled: ", $comic->{'title'};

        # and now to write it to file
        use IO::All;
        use File::Basename;
        $img > io( basename $comic->{'img'} );

        # or in async mode
        $xkcd->fetch( sub {
            my ( $img, $comic ) = @_;
            say "Today's comic is titled: ", $comic->{'title'};

            ...
        } );

DESCRIPTION
    This module allows you to access xkcd comics (http://www.xkcd.com/)
    using the official API in synchronous mode (what people are used to) or
    in asynchronous mode.

    The asynchronous mode requires you have AnyEvent and AnyEvent::HTTP
    available. However, since it's just *supported* and not *necessary*, it
    is not declared as a prerequisite.

METHODS
  new
    Create a new WWW::xkcd object.

        # typical usage
        my $xkcd = WWW::xkcd->new;

        # it would be pointless to change these, but it's possible
        my $xkcd = WWW::xkcd->new(
            base_url => 'http://www.xkcd.com',
            infopath => 'info.0.json',
        );

  fetch
    Fetch both the metadata and image of a comic.

        # fetching the latest
        my ( $comic, $meta ) = $xkcd->fetch;

        # fetching a specific one
        my ( $comic, $meta ) = $xkcd->fetch(20);

        # using callbacks for async mode
        $xkcd->fetch( sub { my ( $comic, $meta ) = @_; ... } );

        # using callbacks for a specific one
        $xkcd->fetch( 20, sub { my ( $comic, $meta ) = @_; ... } );

    This runs two requests: one to get the metadata using the API and the
    second to get the image itself. If you don't need the image, it would be
    better (and faster) for you to use the "fetch_metadata" method below.

  fetch_metadata
    Fetch just the metadata of the comic.

        my $meta = $xkcd->fetch_metadata;

        # using callbacks for async mode
        $xkcd->fetch_metadata( sub { my $meta = shift; ... } );

NAMING
    Why would you call it WWW::*xkcd* with all lower cases? Simply because
    that's what Randall Munroe who writes xkcd prefers.

    Taken verbatim from <http://www.xkcd.com/about>:

        How do I write "xkcd"? There's nothing in Strunk and White about this.

        For those of us pedantic enough to want a rule, here it is: The preferred
        form is "xkcd", all lower-case. In formal contexts where a lowercase word
        shouldn't start a sentence, "XKCD" is an okay alternative. "Xkcd" is
        frowned upon.

DEPENDENCIES
    *   Try::Tiny

    *   HTTP::Tiny

    *   JSON

    *   Carp

OPTIONAL DEPENDENCIES
    *   AnyEvent

    *   AnyEvent::HTTP

