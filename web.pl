#!/usr/bin/perl
{
package MyWebServer;
 
use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);
use lib "Geo-IPinfo/lib";
use Geo::IPinfo;
use Data::Validate::IP;


sub handle_request {
    my $self = shift;
    my $cgi  = shift;
   
    my $path = $cgi->path_info();
    $path =~ s/\///gi; 

    my $ip=(split /:/,$path)[0];

    my $validator=Data::Validate::IP->new;

    if($validator->is_ipv4($ip)) {
        print $cgi->header,
              $cgi->start_html("Hello"),
              $cgi->h1("Hello $path"),
              $cgi->end_html;

    } else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
              $cgi->start_html('Not found'),
              $cgi->h1('$ip is not a valid IPv4 address'),
              $cgi->end_html;
    }
}
 
} 
 
# start the server on port 8080
my $pid = MyWebServer->new(8080)->background();
print "Use 'kill $pid' to stop server.\n";t
