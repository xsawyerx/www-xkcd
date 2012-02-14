SYNOPSIS
        use WWW::xkcd;
        my $xkcd  = WWW::xkcd->new;
        my $comic = $xkcd->fetch; # provides latest data
        say "Today's comic is titled: ", $comic->{'title'};

        # or in async mode
        $xkcd->fetch( sub {
            my $comic = shift;
            say "Today's comic is titled: ", $comic->{'title'};
        } );

DESCRIPTION
    This module allows you to access xkcd comics (<http://www.xkcd.com/>)
    using the official API in synchronous mode (what people are used to) or
    in asynchronous mode.

    The asynchronous mode requires you have AnyEvent and AnyEvent::HTTP
    available. However, since it's just *supported* and not *crucial*, it is
    not declared as a prerequisite.

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
    Fetch the metadata of the comic. This method will probably be renamed,
    stay tuned.

        # fetching the latest
        my $comic = $xkcd->fetch;

        # fetching a specific one
        my $comic = $xkcd->fetch(20);

        # using callbacks for async mode
        $xkcd->fetch( sub { my $comic = shift; ... } );

        # using callbacks for a specific one
        $xkcd->fetch( 20, sub { my $comic = shift; ... } );

NAMING
    Why would you call *xkcd* with all lower cases? Simply because that's
    what Randall Munroe who writes xkcd prefers.

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

