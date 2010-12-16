package PEG;
use Dancer ':syntax';
use Encode qw(decode);

our $VERSION = '0.1';

sub _read_news {
    YAML::LoadFile(path config->{appdir}, 'data', 'news.yml');
}

my $upcoming_events = YAML::LoadFile(path config->{appdir}, 'data', 'events.yml');
my $earlier_events  = YAML::LoadFile(path config->{appdir}, 'data', 'earlier_events.yml');
my $news            = _read_news();

# this will be refactored out into the templates later
# will use auto pages for this
my %content = (
    index => {
        title       => 'Perl Ecosystem Group',
        subtitle    => 'Welcome',
        description => 'The Perl Ecosystem Group is bridging the gap between business using Perl and the open source Perl community',
    },

    what => {
        title       => 'What does the Perl Ecosystem Group do?',
        subtitle    => 'What?',
        description => 'Promoting Perl outside the Perl echo-chamber, at non-Perl events, via journals etc.',
    },

    why => {
        title       => 'Why is it important to be a member of the Perl Ecosystem Group?',
        subtitle    => 'Why?',
        description => '',
    },

    who => {
        title       => 'About us',
        subtitle    => 'Who?',
        description => 'The people organizing the Perl related talks and the Perl themed development rooms.',
    },

    sponsors => {
        title       => 'Sponsors',
        subtitle    => 'Sponsors',
        description => 'Sponsors of the Perl Ecosystem Group.',
    },

    members => {
        title       => 'Members',
        subtitle    => 'Members',
        description => 'Members of the Perl Ecosystem Group.',
    },

    events => {
        title        => 'List of upcoming events',
        subtitle     => 'Events',
        description  => 'Events where the The Perl Ecosystem Group will organize Perl related talks and will setup a Perl themed booth.',
        events       => $upcoming_events,
    },

    contact => {
        title        => 'Contact Us',
        subtitle     => 'Contact',
        description  => 'The Perl Ecosystem Group is bridging the gap between business using Perl and the open source Perl community',
    },

    membership => {
        title        => 'Membership',
        subtitle     => 'Membership',
        description  => 'Information about the membership levels of the Perl Ecosystem Group',
    },

    benefits => {
        title        => 'Benefits',
        subtitle     => 'Benefits',
        description  => 'Information about the benefitst of being a member in the Perl Ecosystem Group',
    },

    about => {
        title        => 'About',
        subtitle     => 'About',
        description  => 'About the Perl Ecosystem Group and its technical background',
    },

    news => {
        title        => 'News',
        subtitle     => 'News',
        description  => 'News about the Perl Ecosystem Group',
        news         => $news,
    },

    earlier_events => {
        title        => 'Earlier events',
        subtitle     => 'Earlier events',
        description  => 'A list of events we participated at. Even before the Perl Ecosystem Group was setup',
        events       => $earlier_events,
    },
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
    grep { $page eq $_ } @pages or pass;

    # render it
    template $page => $content{$page};
};

get '/rss' => sub {
    require XML::RSS;

    my $rss = XML::RSS->new( version => '1.0' );
    my $year = 1900 + (localtime)[5];
    my $url = 'http://perl-ecosystem.org';
    $rss->channel(
        title       => "Perl Ecosystem Group",
        link        => "$url/",
        description => 'Bridging the gap between business and the open source Perl community',
        dc => {
            language  => 'en-us',
            publisher => 'gabor@perl-ecosystem.org',
            rights    => "Copyright 2010-$year, Perl Ecosystem Group",
        },
        syn => {
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
            title => decode('utf-8', $n->{title}),
            link  => $url . ($n->{permalink} || '/news'), 
            description => decode('utf-8', $text),
            dc => {
                creator => $n->{author},
                date    => $n->{date},
                subject => ($n->{tags} and ref($n->{tags}) eq 'ARRAY' 
                                ?   join(', ', @{ $n->{tags} })
                                :   ''),
            },
        );
    }
  
    return $rss->as_string;
};

true;
