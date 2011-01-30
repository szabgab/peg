use Test::More;
use strict;
use warnings;

my @pages = qw(/ /rss);

plan tests => 2 * @pages;

# the order is important
use PEG;
use Dancer::Test;

foreach my $p (@pages) {
	route_exists [GET => $p], "a route handler is defined for $p";
	response_status_is ['GET' => $p], 200, "response status is 200 for $p";
}
