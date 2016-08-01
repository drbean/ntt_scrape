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
		process 'tr td', "tdlist[]" => scraper {
			process 'td', text => 'TEXT';
		};
	};

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => 'http://ntt.setup/cgi-bin/main.cgi?mbg_webname=status');
	$req->authorization_basic('user', '3dogs');

	my $res = $tables->scrape( $ua->request( $req ) );

$DB::single=1;

	my $tdlist = $res->{tdlist};
	my $prompt = " ADSL\x{a0}IP";
	for my $n ( 0 .. $#$tdlist) {
		next unless $tdlist->[$n]->{text} eq $prompt;
		my $ip = substr $tdlist->[++$n]->{text}, 2;
		print Encode::encode("utf8", $ip);
		last;
	}
}

1;
