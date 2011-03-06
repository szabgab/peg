package PEG;
use Dancer ':syntax';
use Encode qw(decode);
use XML::RSS;

our $VERSION = '0.1';

my %content = (
    data => {},
    src  => {
        news   => 'news.yml',
        events => 'events.yml',
        earlier_events => 'earlier_events.yml',
    },
);

sub _read_file {
    my $name = shift;
    my $file = path config->{appdir}, 'data', $content{src}{$name};
    my $current_stamp = (stat($file))[9];

    my $sub = $name eq 'news' ? 'news' : 'events';
    if (not $content{data}{$name} or $content{stamp}{$name} < $current_stamp) {
        my $data = YAML::LoadFile($file);
        if ($name eq 'news') {
            $content{data}{$name}{$sub} = $data;
        } elsif ($name eq 'events') {
            $content{data}{$name}{$sub} = $data;
        } elsif ($name eq 'earlier_events') {
            $content{data}{$name}{$sub} = [ reverse @$data ];
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
    what why who sponsors members events contact
    membership benefits about news earlier_events mailing_lists
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

# for historical reasons:
get '/rss' => sub {
    return _rss('news');
};

get '/rss/news' => sub {
    return _rss('news');
};

sub _rss {
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

    foreach my $n (@{ _content()->{news}{news} }) {
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
