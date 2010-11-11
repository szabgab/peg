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
		date => '2010.11.06',
		text => '<a href="http://www.dijkmat.nl/">Dijkmat BV</a> becomes the first Bronze <a href="/members">member</a> of the Perl Ecosystem Group.',
	},
	{
		date => '2010.11.06',
		text => 'Gabor Szabo from the Perl Ecosystem Group together with several members of the <a href="http://www.sppn.nl/">Dutch Perl Mongers</a> participate at <a href="http://www.t-dose.org/">T-Dose</a></h3> in Eindhoven, The Netherlands with a Perl booth.',
	},
	{
		date => '2010.11.02',
		text => '<a href="http://www.raz.co.il/">Raz Information Systems</a></h3> became a <a href="/members">member</a>.',
	},
	{
		date => '2010.10.26',
		text => '<a href="http://www.columbusprogroup.com">Columbus Pro Group</a> was added as a <a href="/members">member</a>.',
	},
	{
		date => '2010.10.21',
		text => '<a href="http://bruck.co.il/">Uri Bruck</a> added as the first <a href="/members">member</a>.',
	},
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
