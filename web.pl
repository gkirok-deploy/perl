#!/usr/bin/perl
{
package MyWebServer;
 
use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);

use lib "Geo-IPinfo/lib";
use Geo::IPinfo;

use Data::Validate::IP;

use lib "Geo-IPinfo/lib";
use Geo::IPinfo;

sub handle_request {
  my $self = shift;
  my $cgi  = shift;

  my $path = $cgi->path_info();
  $path =~ s/\///gi;

  my $ip=(split /:/,$path)[0];

  my $validator=Data::Validate::IP->new;

  if($validator->is_ipv4($ip)) {
    my $ipinfo = Geo::IPinfo->new($token);
    my $data = $ipinfo->info($ip);
    my $result = "";

    if (defined $data) {  # valid data returned
      $result .= "Information about IP $ip:\n";
      for my $key (sort keys %$data ) {
        $result .= sprintf("%10s : %s\n", $key, $data->{$key});
      }
    } else {  # invalid data obtained, show error message
      $result = $ipinfo->error_msg;
    }

    print "HTTP/1.0 200 OK\r\n";
    print $cgi->header,
          $cgi->start_html("IPinfo"),
          $cgi->h1("IPinfo $path"),
          $cgi->pre($result),
          $cgi->end_html;
  } else {
    print "HTTP/1.0 400 Bad Request\r\n";
    print $cgi->header,
          $cgi->start_html('Bad Request'),
          $cgi->h1("'$ip' is not a valid IPv4 address"),
          $cgi->end_html;
  }
}
 
} 


my $token_filename = "ipinfo.token";

open(my $fh, '<:encoding(UTF-8)', $token_filename)
  or die "Could not open file '$token_filename' $!";

my $token = <$fh>;
chomp $token;
 
# start the server on port 8080
my $pid = MyWebServer->new(8080)->background();
print "Use 'kill $pid' to stop server.\n";t
