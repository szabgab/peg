package PEG;
use Dancer ':syntax';
use Encode qw(decode);
use XML::RSS;

our $VERSION = '0.1';

sub _read_news {
    YAML::LoadFile(path config->{appdir}, 'data', 'news.yml');
}

my $upcoming_events = YAML::LoadFile(
    path( config->{appdir}, 'data', 'events.yml' )
);
my $earlier_events  = YAML::LoadFile(
    path( config->{appdir}, 'data', 'earlier_events.yml' )
);
my $news            = _read_news();

# this will be refactored out into the templates later
# will use auto pages for this
my %content = (
    earlier_events => { events => $earlier_events  },
    events         => { events => $upcoming_events },
    news           => { news   => $news            },
);

get qr{^ / (?: index \. html )? $}x => sub {
    template 'index' => $content{'index'};
};

my @pages = qw/
    what why who sponsors members events contact
    membership benefits about news earlier_events
/;

get qr{^ / (\w+) $ }x => sub {
    # get page
    my ($page) = splat;

    # we have the page or we pass up on it
    grep { $page eq $_ } @pages or return pass;

    # render it
    template $page => $content{$page};
};

get '/rss' => sub {
    my $rss  = XML::RSS->new( version => '1.0' );
    my $year = 1900 + (localtime)[5];
    my $url  = 'http://perl-ecosystem.org';

    $rss->channel(
        title       => "Perl Ecosystem Group",
        link        => "$url/",
        description => 'Bridging the gap between business and the open source Perl community',
        dc          => {
            language  => 'en-us',
            publisher => 'gabor@perl-ecosystem.org',
            rights    => "Copyright 2010-$year, Perl Ecosystem Group",
        },

        syn         => {
            updatePeriod     => "hourly",
            updateFrequency  => "1",
            updateBase       => "1901-01-01T00:00+00:00",
        }
    );

    my $news = _read_news();

    foreach my $n (@$news) {
        my $text = $n->{text};
        $text =~ s{"/}{"$url/}g;

        $rss->add_item(
            title       => decode( 'utf-8', $n->{title} ),
            link        => $url . ( $n->{permalink} || '/news' ),
            description => decode( 'utf-8', $text ),
            dc          => {
                creator  => $n->{author},
                date     => $n->{date},
                subject  => (
                    $n->{tags} and ref( $n->{tags} ) eq 'ARRAY'  ?
                                   join( ', ', @{ $n->{tags} } ) :
                                   ''
                ),
            },
        );
    }
  
    return $rss->as_string;
};

true;
