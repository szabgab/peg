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
        title       => 'What does The Perl Ecosystem Group do?',
        subtitle    => 'What?',
        description => 'Promoting Perl outside the Perl echo-chamber, at non-Perl events, via journals etc.',
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

my @news = (
	{
		date => '2010.10.20',
		text => 'The web site of the Perl Ecosystem Group was opened to public. We started to contact companies to sponsor our activities.',
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


get '/earlier_events' => sub {
    template 'earlier_events', { 
      title        => 'Earlier events',
      subtitle     => 'Earlier events',
      description  => 'A list of events we participated at. Even before the Perl Ecosystem Group was setup',
    };
};

true;
