FROM perl:latest
MAINTAINER  gkirok

# set RELEASE_TESTING to 1 for running unit tests
ARG RELEASE_TESTING

# installing cpan and package dependencies
RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm --force URI JSON LWP::UserAgent LWP::Protocol::https HTTP::Server::Simple::CGI use Data::Validate::IP

# installing tests dependencies
RUN test -z "$RELEASE_TESTING" || cpanm Test::CheckManifest Test::Pod Test::Pod::Coverage

# copying package into image
COPY ./Geo-IPinfo /opt/Geo-IPinfo
WORKDIR /opt/Geo-IPinfo

# compiling package
RUN perl Makefile.PL

# to check if unit test are working uncomment next line
#COPY output.pl /opt/Geo-IPinfo/none/Geo::IPinfo.3pm
RUN test -z "$RELEASE_TESTING" || RELEASE_TESTING=1 make test && make install

# creating test.sh - for shell test running
RUN test -z "$RELEASE_TESTING" || echo 'export RELEASE_TESTING=1 && for i in /opt/Geo-IPinfo/t/*.t; do /usr/local/bin/perl -T $i; done;' > /opt/test.sh;
# copying output.pl - shell interface
COPY output.pl /opt/output.pl
# copying web.pl - web interface
COPY web.pl /opt/web.pl

WORKDIR /opt/
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
