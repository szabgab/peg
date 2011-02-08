package PEG;
use Dancer ':syntax';
use Encode qw(decode);
use XML::RSS;

our $VERSION = '0.1';
my $news;

sub _read_news {
	if (not $news) {
		$news = YAML::LoadFile(path config->{appdir}, 'data', 'news.yml');
	}
	return $news;
}


my %content;

sub _content {
    if (not %content) {
        my $earlier_events  = YAML::LoadFile(
            path( config->{appdir}, 'data', 'earlier_events.yml' )
        );
        my $upcoming_events = YAML::LoadFile(
            path( config->{appdir}, 'data', 'events.yml' )
        );

        %content = (
            earlier_events => { events => $earlier_events  },
            events         => { events => $upcoming_events },
            news           => { news   => _read_news       },
        );
    }
    
    return \%content;
}

get qr{^ / (?: index \. html )? $}x => sub {
    template 'index' => _content->{'index'};
};

my @pages = qw/
    what why who sponsors members events contact
    membership benefits about news earlier_events mailing_lists
/;

get qr{^ / (\w+) $ }x => sub {
    # get page
    my ($page) = splat;

    # we have the page or we pass up on it
    grep { $page eq $_ } @pages or return pass;

    # render it
    template $page => _content->{$page};
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

    foreach my $n (@{ _read_news() }) {
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
