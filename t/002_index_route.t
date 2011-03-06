use Test::More;
use strict;
use warnings;
use Test::NoWarnings;

my @pages = qw(
	/ /rss /rss/news /about /what /who /why 
	/events /earlier_events /news 
	/members /membership /sponsors 
	/benefits /contact /about);

plan tests => 1 + 2 * @pages;

# the order is important
use PEG;
use Dancer::Test;

Dancer::set("log" => "warning");

foreach my $p (@pages) {
	route_exists [GET => $p], "a route handler is defined for $p";
	response_status_is ['GET' => $p], 200, "response status is 200 for $p";
}
