FROM perl:latest
MAINTAINER  gkirok
ARG RELEASE_TESTING

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm --force URI JSON LWP::UserAgent LWP::Protocol::https
RUN test -z "$RELEASE_TESTING" || cpanm Test::CheckManifest Test::Pod Test::Pod::Coverage
COPY ./Geo-IPinfo /opt/Geo-IPinfo
WORKDIR /opt/Geo-IPinfo
RUN perl Makefile.PL
#COPY output.pl /opt/Geo-IPinfo/none/Geo::IPinfo.3pm
RUN test -z "$RELEASE_TESTING" || RELEASE_TESTING=1 make test && make install
#RUN make && make install
COPY output.pl /opt/output.pl
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN test -z "$RELEASE_TESTING" || echo 'export RELEASE_TESTING=1 && for i in /opt/Geo-IPinfo/t/*.t; do /usr/local/bin/perl -T $i; done;' > /opt/test.sh;
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
