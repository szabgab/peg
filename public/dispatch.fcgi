#!/usr/bin/env perl
use Plack::Handler::FCGI;
use Dancer ':syntax';

my $psgi = path(dirname(__FILE__), '..', 'PEG.pl');
my $app = do($psgi);
my $server = Plack::Handler::FCGI->new(nproc  => 5, detach => 1);
$server->run($app);
