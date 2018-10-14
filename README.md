# Geo::IPinfo

Official ipinfo.io Perl library
Running into Non official docker container

## REQUIREMENTS

* ipinfo token, you can get from https://ipinfo.io/account

## LOCAL RUNNING IN DOCKER

1. clone project 
2. create file ipinfo.token contains token as described above
```
    $ cat ipinfo.token
    1234567890abcd
```
3. build test image and run
   * `docker build --build-arg RELEASE_TESTING=yes . -t gkirok/ipinfo:test`
   * `docker run -it gkirok/ipinfo:test`
4. build image
   * `docker build . -t gkirok/ipinfo:latest`
5. run container
   * run as web service
     * `docker run -d -v ipinfo.token:/opt/ipinfo.token -p 80:8080 --name ipinfo gkirok/ipinfo:latest`
     * `curl localhost/IP_YOU_WANT_TO_DESCRIBE`

   OR
   * run single request
     * `docker run -d -v ipinfo.token:/opt/ipinfo.token -p 80:8080 --name ipinfo gkirok/ipinfo:latest IP_YOU_WANT_TO_DESCRIBE`

## DEPLOY IPINFO TO AWS EC2 USING JENKINS PIPELINE

### HOW IT WORKS
By default ipinfo web server will be deployed as docker container to t2.micro ec2 instance, has access by http to all, and ssh access from jenkins server and user 'access' server. 

### REQUIREMENTS
1. aws credentials with full ec2 premissions
2. installed Jenkins Pipeline server with configured docker, terraform and ansible

### HOW TO START
1. ssh connect to your jenkins server and generate private/public keys have been using to connect to ec2 server.
   and save it as `~/.ssh/tikal` and `~/.ssh/tikal.pub`
2. add these credentials parameters to your jenkins server
   * AWS_ACCESS_KEY_ID
   * AWS_SECRET_ACCESS_KEY
   * JENKINS_IP
   * ACCESS_IP
   * ipinfo_token
   * private key using to connect to ec2 server by ansible from step 1 ('3276ccf3-13bc-4408-b815-7b07bfd4e972' in Jenkinsfile)
4. fork project
5. edit Jenkinsfile, commit and push changes
   * replace ids of credentials have been configured in step 2.
6. create new pipeline with forked project and run it
   
## LOCAL RUNNING BY PERL
### EXAMPLE

    use Geo::IPinfo;

    my $token = "1234567";

    # if you have a valid token, use it
    my $ipinfo = Geo::IPinfo->new($token);

    # or, if you don't have a token, use this:
    # my $ipinfo = Geo::IPinfo->new();

    # return a hash reference containing all IP related information
    my $data = $ipinfo->info("8.8.8.8");

    if (defined $data)   # valid data returned
    {
      print "Information about IP 8.8.8.8:\n";
      for my $key (sort keys %$data )
      {
        printf "%10s : %s\n", $key, $data->{$key};
      }
      print "\n";
    }
    else   # invalid data obtained, show error message
    {
      print $ipinfo->error_msg . "\n";
    }

    # retrieve only city information of the IP address
    my $city = $ipinfo->field("8.8.8.8", "city");

    print "The city of 8.8.8.8 is $city\n";

#### OUTPUT
    Information about IP 8.8.8.8:
          city : Mountain View
       country : US
      hostname : google-public-dns-a.google.com
            ip : 8.8.8.8
           loc : 37.3860,-122.0840
           org : AS15169 Google LLC
         phone : 650
        postal : 94035
        region : California

    The city of 8.8.8.8 is Mountain View

### RUNNING TEST
* `export RELEASE_TESTING=yes && for i in *.t; do /bin/perl -T $i; done`

### USAGE

For details about how to use the library, install it and then run:

    perldoc Geo::IPinfo


### Before submitting to CPAN

Make sure ALL tests executed without errors; to do this, run:

    $ cd Geo-IPinfo/
    $ perl Makefile.PL
    $ RELEASE_TESTING=1 make test

In particular, pay attention to the result of the execution of 't/01-usage.t'; to see
more detailed information about the execution of this test, run:

    $ RELEASE_TESTING=1 prove -bv t/01-usage.t
