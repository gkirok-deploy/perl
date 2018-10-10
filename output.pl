#!/usr/bin/perl
#
use strict;
use warnings;

use lib "Geo-IPinfo/lib";

use Geo::IPinfo;

my ($ip) = @ARGV;
my $token = "14ceeb3ed116cb";

# if you have a valid token, use it
my $ipinfo = Geo::IPinfo->new($token);

# or, if you don't have a token, use this:
# my $ipinfo = Geo::IPinfo->new();

# return a hash reference containing all IP related information
my $data = $ipinfo->info($ip);

if (defined $data)   # valid data returned
{
  print "Information about IP $ip:\n";
  for my $key (sort keys %$data )
  {
    printf "%10s : %s\n", $key, $data->{$key};
  }
  print "\n"
}
else   # invalid data obtained, show error message
{
  print $ipinfo->error_msg . "\n";
}

# retrieve only city information of the IP address
my $city = $ipinfo->field($ip, "city");

print "The city of $ip is $city\n";

