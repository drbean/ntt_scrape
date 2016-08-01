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
	my $rows = scraper {
		process 'tr td', "tdlist[]" => scraper {
			process 'td', text => 'TEXT';
		};
	};

	my $ua = LWP::UserAgent->new;
	my $caster = HTTP::Request->new(GET => 'http://ntt.setup/cgi-bin/main.cgi?mbg_webname=status');
	$caster->authorization_basic('', '');

	my $ntt_response = $rows->scrape( $ua->request( $caster ) );

	my $tdlist = $ntt_response->{tdlist};
	my $prompt = " ADSL\x{a0}IP";
	my $address;
	for my $n ( 0 .. $#$tdlist) {
		next unless $tdlist->[$n]->{text} eq $prompt;
		my $ip = substr $tdlist->[++$n]->{text}, 1;
		$address = Encode::encode("utf8", $ip);
		last;
	}

	my $dns = HTTP::Request->new(POST =>
"http://ipv4.mydns.jp/directip.html?MID=''&PWD=''&IPV4ADDR=$address");
	my $dns_response = $ua->request( $dns );
	print $dns_response->as_string;

}

1;
