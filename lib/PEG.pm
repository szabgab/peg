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

get '/members' => sub {
    template 'members', { 
      title       => 'Members',
      subtitle    => 'Members',
      description => 'Members of the Perl Ecosystem Group.',
    };
};

get '/events' => sub {
    template 'events', { 
      title        => 'List of upcoming events',
      subtitle     => 'Events',
      description  => 'Events where the The Perl Ecosystem Group will organize Perl related talks and will setup a Perl themed booth.',
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

get '/events/:name' => sub {
    template 'events/' . params->{name} , {
        title       => 'Testevent',
        subtitle    => 'Subtitle',
        description => 'Description of Testevent',
    }
};

get '/earlier_events/:name' => sub {
    template 'earlier_events/' . params->{name}, {
        title       => 'Testevent',
        subtitle    => 'Subtitle',
        description => 'Description of Testevent',
    }
};

my @news = (
	{
		date => '2010.11.10',
		text => '<a href="http://www.oqapi.com/en">Oqapi</a> agrees to become member of the Perl Ecosystem Group',
		title => 'Oqapi joins the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.11.09',
		text => 'PEG announces it will support the Perl teams participating on the <a href="http://www.plat-forms.org/">Plat_Forms contest</a>. See the <a href="http://szabgab.com/blog/2010/11/sponsoring-plat-forms-contest-teams.html">blog</a> about it.',
		title => 'The Perl Ecosystem Group and the Plat_Forms competition',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.11.06',
		text => '<a href="http://www.dijkmat.nl/">Dijkmat BV</a> becomes the first Bronze <a href="/members">member</a> of the Perl Ecosystem Group.',
		title => 'Dijkmat joins the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.11.06',
		text => 'Gabor Szabo from the Perl Ecosystem Group together with several members of the <a href="http://www.sppn.nl/">Dutch Perl Mongers</a> participate at <a href="http://www.t-dose.org/">T-Dose</a></h3> in Eindhoven, The Netherlands with a Perl booth.',
		title => 'Perl Ecosystem Group at T-Dose',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.11.05',
		text => 'Blog entries announcing the establishment of the Perl Ecosystem Group in <a href="http://szabgab.com/blog/2010/11/perl-ecosystem-group.html">English</a> and in <a href="http://reneeb-perlblog.blogspot.com/2010/11/perl-ecosystem-group.html">German</a>.',
		title => 'Blogs about the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.11.02',
		text => '<a href="http://www.raz.co.il/">Raz Information Systems</a></h3> became a <a href="/members">member</a>.',
		title => 'Raz joins the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.10.26',
		text => '<a href="http://www.columbusprogroup.com">Columbus Pro Group</a> was added as a <a href="/members">member</a>.',
		title => 'Columbus Pro Group joins the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.10.21',
		text => '<a href="http://bruck.co.il/">Uri Bruck</a> added as the first <a href="/members">member</a>.',
		title => 'Uri Bruck joins the Perl Ecosystem Group',
		author => 'Gabor Szabo',
	},
	{
		date => '2010.10.20',
		text => 'The web site of the Perl Ecosystem Group was opened to public. We started to contact companies to sponsor our activities.',
		title => 'Perl Ecosystem Group website is open.',
		author => 'Gabor Szabo',
        },
);

get '/news' => sub {
    template 'news', { 
      title        => 'News',
      subtitle     => 'News',
      description  => 'News about the Perl Ecosystem Group',
      news         => \@news,
    };
};

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
    foreach my $n (@news) {
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
