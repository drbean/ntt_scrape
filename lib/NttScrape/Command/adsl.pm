package NttScrape::Command::adsl;

use lib "lib";

use NttScrape -command;
use strict;
use warnings;

use LWP::UserAgent;
use URI;
use Web::Scraper;
use Encode;

sub abstract { "scrape webcaster for ADSL IP" }
sub description { "Scraping webcaster ntt-setup web page API to get ADSL IP addrsss" }

sub execute {
	my $tables = scraper {
		process 'head meta', "metalist[]" => scraper {
			process 'http-equiv', http => 'TEXT';
			process 'content', content => '@content';
		};
	};

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => 'http://ntt.setup/cgi-bin/main.cgi');
	$req->authorization_basic('user', '3dogs');

	my $res = $tables->scrape( $ua->request( $req ) );

$DB::single=1;

	my $n=0;
	for my $meta (@{$res->{metalist}}) {
		print Encode::encode("utf8", $n++ . "\t$meta->{http}\t$meta->{content}\n");
	}
}

1;
