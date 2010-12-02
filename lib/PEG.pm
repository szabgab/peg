package PEG;
use Dancer ':syntax';

our $VERSION = '0.1';


get '/(index.html)?' => sub {
    template 'index', { 
        title       => 'Perl Ecosystem Group',
        subtitle    => 'Welcome',
        description => 'The Perl Ecosystem Group is bridging the gap between business using Perl and the open source Perl community',
    };
};

get '/what' => sub {
    template 'what', { 
        title       => 'What does the Perl Ecosystem Group do?',
        subtitle    => 'What?',
        description => 'Promoting Perl outside the Perl echo-chamber, at non-Perl events, via journals etc.',
    };
};

get '/why' => sub {
    template 'why', { 
        title       => 'Why is it important to be a member of the Perl Ecosystem Group?',
        subtitle    => 'Why?',
        description => '',
    };
};

get '/who' => sub {
    template 'who', { 
        title       => 'About us',
        subtitle    => 'Who?',
        description => 'The people organizing the Perl related talks and the Perl themed development rooms.',
    };
};

get '/sponsors' => sub {
    template 'sponsors', { 
      title       => 'Sponsors',
      subtitle    => 'Sponsors',
      description => 'Sponsors of the Perl Ecosystem Group.',
    };
};

get '/members' => sub {
    template 'members', { 
      title       => 'Members',
      subtitle    => 'Members',
      description => 'Members of the Perl Ecosystem Group.',
    };
};

get '/events' => sub {
    my $events = YAML::LoadFile(path config->{appdir}, 'data', 'events.yml');
    template 'events', { 
      title        => 'List of upcoming events',
      subtitle     => 'Events',
      description  => 'Events where the The Perl Ecosystem Group will organize Perl related talks and will setup a Perl themed booth.',
      events       => $events,
    };
};

get '/contact' => sub {
    template 'contact', { 
      title        => 'Contact Us',
      subtitle     => 'Contact',
      description  => 'The Perl Ecosystem Group is bridging the gap between business using Perl and the open source Perl community',
    };
};


get '/membership' => sub {
    template 'membership', { 
      title        => 'Membership',
      subtitle     => 'Membership',
      description  => 'Information about the membership levels of the Perl Ecosystem Group',
    };
};

get '/benefits' => sub {
    template 'benefits', { 
      title        => 'Benefits',
      subtitle     => 'Benefits',
      description  => 'Information about the benefitst of being a member in the Perl Ecosystem Group',
    };
};


get '/news' => sub {
    my $news = _read_news();
    template 'news', { 
      title        => 'News',
      subtitle     => 'News',
      description  => 'News about the Perl Ecosystem Group',
      news         => $news,
    };
};

sub _read_news {
    YAML::LoadFile(path config->{appdir}, 'data', 'news.yml');
}

get '/rss' => sub {

    require XML::RSS;
    use Encode qw(decode);

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


get '/earlier_events' => sub {
    template 'earlier_events', { 
      title        => 'Earlier events',
      subtitle     => 'Earlier events',
      description  => 'A list of events we participated at. Even before the Perl Ecosystem Group was setup',
    };
};

true;
