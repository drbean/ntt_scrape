# ntt_scrape

 Scraping webcaster ntt-setup web page API to get ADSL IP addrsss
-----------------------------------------------------------------

## =head1 NAME

ntt_scrape.pl - "scrape webcaster for ADSL IP" 

## =head1 SYNOPSIS

ntt_scrape adsl -u router_user -p password -r 'http://ntt.setup/cgi-bin/main.cgi?mbg_webname=status' -d ADSL\\x{A0}IP -i http://ipv4.mydns.jp/directip.html -m mydns111111 -w password

## =head1 DESCRIPTION

Scraping webcaster ntt-setup web page API to get ADSL IP addrsss and uploading to mydns.org.

Takes router id, password, page with the ADSL IP on the router/access point/webcaster.

In the Webcaster 3100SV web page, the ADSL IP address is in the table data element following  $' ADSL\xa0IP'. If in your case it's not, you're going to have to investigate the perl module L<Web::Scraper|http://search.cpan.org/dist/Web-Scraper/> to find out how to determine where it is.

Also the web page at the dynamic DNS service, mydns.jp, and the user id, and password on the service.

## =head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

## =head1 COPYRIGHT & LICENSE

Copyright 2016 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

