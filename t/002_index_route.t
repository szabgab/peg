use Test::More;
use strict;
use warnings;
use Test::NoWarnings;

my @pages = qw(
	/ /rss /about /what /who /why 
	/events /earlier_events /news 
	/members /membership /sponsors 
	/benefits /contact /about);

plan tests => 1 + 2 * @pages + 1;

# the order is important
use PEG;
use Dancer::Test;

Dancer::set("log" => "warning");

foreach my $p (@pages) {
	route_exists [GET => $p], "a route handler is defined for $p";
	response_status_is ['GET' => $p], 200, "response status is 200 for $p";
}

{
	my $p = '/xyz';
	diag "testing not existing page $p";
	route_doesnt_exist [GET => $p], "a route handler is defined for $p";
	#response_status_is ['GET' => $p], 404, "response status is 404 for $p";
}
