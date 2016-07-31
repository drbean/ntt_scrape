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
		process 'table[border="0"] table', "table0[]" => scraper {
			process 'table[border="0"] td[nowrap]', "table1[]" => scraper {
				process '', ip => 'TEXT';
			};
		};
	};

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => 'http://ntt.setup/cgi-bin/main.cgi?mbg_webname=status');
	$req->authorization_basic('user', '3dogs');

	my $res = $tables->scrape( $ua->request( $req ) );


	for my $author (@{$res->{authors}}) {
		print Encode::encode("utf8", "$author->{fullname}\t$author->{uri}\n");
	}
}

1;
