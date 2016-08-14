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

sub usage_desc { "db moodle -p PORT,ie,cluster -u USER -d DATABASE - +t TABLE -f FILE -a ACTION" }

sub opt_spec  {
        return (
                ["u=s", "router_user"]
                , ["p=s", "password"]
                , ["r=s", "router_page"]
                , ["d=s", "prompt_element"]
                , ["m=s", "mydns_user"]
                , ["w=s", "mydns_password"]
                , ["i=s", "mydns_page"]
	);
}


sub execute {
	my ($self, $opt, $args) = @_;

	my $rows = scraper {
		process 'tr td', "tdlist[]" => scraper {
			process 'td', text => 'TEXT';
		};
	};

	my $ua = LWP::UserAgent->new;
	my $caster = HTTP::Request->new(GET => $opt->{r});
	$caster->authorization_basic($opt->{u}, $opt->{p});

	my $ntt_response = $rows->scrape( $ua->request( $caster ) );

	my $tdlist = $ntt_response->{tdlist};
	my $prompt = $opt->{d};
	my $address;
	for my $n ( 0 .. $#$tdlist) {
		next unless $tdlist->[$n]->{text} eq $prompt;
		my $ip = substr $tdlist->[++$n]->{text}, 1;
		$address = Encode::encode("utf8", $ip);
		last;
	}
	die "No address after '$prompt' prompt in $tdlist <TD> list"
		unless defined $address;

	my $dns = HTTP::Request->new(POST =>
"$opt->{i}?MID=$opt->{m}&PWD=$opt->{w}&IPV4ADDR=$address");
	my $dns_response = $ua->request( $dns );
	print $dns_response->as_string;

}

1;
