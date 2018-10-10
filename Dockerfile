FROM        perl:latest
MAINTAINER  gkirok
ARG RELEASE_TESTING

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm --force URI JSON LWP::UserAgent LWP::Protocol::https
RUN test -z "$RELEASE_TESTING" || cpanm Test::CheckManifest Test::Pod Test::Pod::Coverage
COPY ./Geo-IPinfo /opt/Geo-IPinfo
WORKDIR /opt/Geo-IPinfo
RUN perl Makefile.PL
RUN make && make install
COPY output.pl /opt/output.pl
RUN test -z "$RELEASE_TESTING" || echo 'export RELEASE_TESTING=yes && for i in /opt/Geo-IPinfo/t/*.t; do /usr/local/bin/perl -T $i; done;' > /opt/test.sh; chmod 755 /opt/test.sh
ENTRYPOINT "/opt/test.sh"
