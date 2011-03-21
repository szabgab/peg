package PEG;
use Dancer ':syntax';

use Encode qw(decode);
use XML::RSS;
use Data::Dumper qw(Dumper);
use DateTime;
use Data::ICal;
use Data::ICal::Entry::Event;
use DateTime::Format::ICal;

our $VERSION = '0.1';

my %content = (
    data => {},
    src  => {
        news   => 'news.yml',
        events => 'events.yml',
        earlier_events => 'events.yml',
    },
);

sub _read_file {
    my $name = shift;

    my $now = DateTime->now->ymd;  # YYYY-MM-DD
    $now =~ s/-/./g;

    my $file = path config->{appdir}, 'data', $content{src}{$name};
    my $current_stamp = (stat($file))[9];

    my $sub = $name eq 'news' ? 'news' : 'events';
    if (not $content{data}{$name} or $content{stamp}{$name} < $current_stamp) {
        my $data = eval { YAML::LoadFile($file) };
        if ($@) {
            warn "could not load '$file' $@";
        }
        if ($name eq 'news') {
            $content{data}{$name}{$sub} = $data;
        } elsif ($name eq 'events') {
            $content{data}{$name}{$sub} = [ grep {$_->{date} ge $now} @$data ];
        } elsif ($name eq 'earlier_events') {
            $content{data}{$name}{$sub} = [ reverse grep {$_->{date} lt $now } @$data ];
        }
        $content{stamp}{$name} = $current_stamp;
    }
    return;
}


sub _content {
    foreach my $src (keys %{$content{src}}) {
        _read_file($src);
    }

    return $content{data};
}

get qr{^ / (?: index \. html )? $}x => sub {
    template 'index' => _content()->{'index'};
};

my @pages = qw{
    what why who sponsors members contact
    membership benefits about earlier_events mailing_lists

    news
    news/grants-to-invite-speakers-to-non-perl-events
    news/announcement-and-public-discussion-lists
    events/fosdem_2011
    events/plat_forms_2011
};

get qr{^ / ([\w/-]+) $ }x => sub {
    # get page
    my ($page) = splat;

    # we have the page or we pass up on it
    grep { $page eq $_ } @pages or return pass;

    # render it
    template $page => _content->{$page};
};

get '/events' => sub {
    my @events = map {$_->{text} = _event_text($_); $_} @{ _content->{events}{events} };

    template 'events' => {events => \@events};
};

get '/events/table' => sub {
    my $html = "<h2>Events</h2>\n";
    $html .= qq(<table border="1" style="border-collapse:collapse" options="" class="formatter_table">\n);
    foreach my $e (@{ _content()->{events}{events} }) {
         my $wiki = '&nbsp;';
         if ($e->{wiki}) {
             $e->{wiki} =~ s/ /_/g;
             #$wiki = "http://perlfoundation.org/perl5/$e->{wiki}";
             $wiki = qq(<a target="_top" href="https://www.socialtext.net/perl5/$e->{wiki}">$e->{wiki}</a>);
         }
         my ($year, $month, $day) = split /\./, $e->{date};
         my $dt = DateTime->new(year => $year, month => $month, day => $day);
         my $duration = DateTime::Duration->new(days => $e->{days});
         my $date = $e->{date};
         if ($e->{days} > 1) {
		$dt->add_duration($duration);
                my @date;
                push @date, $dt->year if $dt->year ne $year;
                push @date, $dt->month if $dt->month ne $month;
                push @date, $dt->day if $dt->day ne $day;
                #$date .= '-' . join('.', $dt->year, $dt->month, $dt->day);
                $date .= '-' . join('.', @date);
         }
         $html .= qq(<tr><td>$date</td><td><a href="$e-{>url}">$e->{title}</a></td><td>$e->{address}</td><td>$wiki</td></tr>\n);
    }
    $html .= "</table>\n";

    return $html;
};


get '/calendar' => sub {

    my $calendar = Data::ICal->new();

    foreach my $n (@{ _content()->{events}{events} }) {
        my $url = '';
        if ($n->{url}) {
            $url = $n->{url};
        }
        my $wiki = '';
        if ($n->{wiki}) {
             $n->{wiki} =~ s/ /_/g;
             $wiki = "http://perlfoundation.org/perl5/$n->{wiki}";
        }
        my ($year, $month, $day) = split /\./, $n->{date};
        my $dt = DateTime->new(year => $year, month => $month, day => $day);
        my $duration = DateTime::Duration->new(days => $n->{days});
        my $vevent = Data::ICal::Entry::Event->new();
        $vevent->add_properties(
            summary => decode( 'utf-8', $n->{title} ),
            description => "",
            dtstart   => DateTime::Format::ICal->format_datetime($dt),
            location => ($n->{address} || ''),
            url => ($wiki || $url || ''),
            duration => DateTime::Format::ICal->format_duration($duration),
        );

        $calendar->add_entry($vevent);
    }

    return $calendar->as_string;
};



# for historical reasons:
get '/rss' => sub {
    return _rss('news');
};

get '/rss/news' => sub {
    return _rss('news');
};

get '/rss/events' => sub {
    return _rss('events');
};

sub _rss {
    my $name = shift;

    my $rss  = XML::RSS->new( version => '1.0' );
    my $year = 1900 + (localtime)[5];
    my $base = "http://perl-ecosystem.org";
    my $url  = "$base/$name";

    $rss->channel(
        title       => "Perl Ecosystem Group $name",
        link        => $url,
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

    foreach my $n (@{ _content()->{$name}{$name} }) {
        my $text = $n->{text} || '';
        $text =~ s{"/}{"$base/}g;

        my $link = $url . ( $n->{permalink} || '' );

        if ($name eq 'events') {
            $text = _event_text($n);
            my $wiki;
            if ($n->{wiki}) {
                $n->{wiki} =~ s/ /_/g;
                $wiki = "http://perlfoundation.org/perl5/$n->{wiki}";
            }
            $link = $wiki || $n->{url} || $url || '';
        }

        $rss->add_item(
            title       => decode( 'utf-8', $n->{title} ),
            link        => $link,
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

sub _event_text {
    my ($n) = @_;

    my $text = '';
    if ($n->{days} == 1) {
        $text = "On $n->{date}";
    } else {
        $text = "starting on $n->{date} for $n->{days} days";
    }

    $text .= "<br />";
    if ($n->{url}) {
        if (not defined $n->{title}) {
             warn "title is missing " . Dumper $n;
             $n->{title} = 'NA';
        }
        $text .= qq{ <a href="$n->{url}">$n->{title}</a><br /> };
    }
    if ($n->{wiki}) {
        $n->{wiki} =~ s/ /_/g;
        my $wiki = "http://perlfoundation.org/perl5/$n->{wiki}";
        $text .= qq{ Presence is being organized on the <a href="$wiki">wiki</a><br /> };
    }
    if (not defined $n->{address}) {
       warn "address is missing " . Dumper $n;
    }
    $text .= " Location: $n->{address}<br />";
    return $text;
}


true;
