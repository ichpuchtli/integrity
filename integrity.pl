#!/usr/bin/perl

use strict;
use warnings;

use LWP::ConnCache;
use LWP::Simple;
use LWP::RobotUA;
use URI::URL;
use HTTP::Response;
use LWP::UserAgent;

# Webpage to be searched
# Replace this string with $ARGS[0] for use in terminal 
my $domain = "http://www.google.com/";
	
# Define User Agent
my $userAgent = LWP::RobotUA->new('Mozilla/4.0','sam@example.com');
$userAgent->delay(0.01/60); #10ms delay between requests
$userAgent->timeout(5); #timeout after 5 seconds
$userAgent->conn_cache(LWP::ConnCache->new());
$userAgent->protocols_allowed(['http']);

print $domain,'   ';
my $response = $userAgent->get($domain) or die("Fatal Error");
print "[", $response->status_line, "]\n";

if($response->is_success){

	my $html = $response->content;
	my $num = 0;
	my $errors = 0;
	local $| = 1;

	while($html =~ /<a href=\"(.*?)\"/g){
		
		$num++;
		my $link = URI->new_abs($1, $domain);
		print $link, '   ';
		my $response = $userAgent->head($link) or die("Fatal Error");
		$errors++ if($response->code != 200);
		print "[",$response->status_line, "]\n";
			
	}	

	print $num, " Found, ", $errors, " Errors, ";
	print int(($num-$errors) * 100 / $num), "%\n";

}
