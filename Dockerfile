FROM        perl:latest
MAINTAINER  gkirok

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm JSON
RUN cpanm LWP::UserAgent
RUN cpanm LWP::Protocol::https
COPY ./Geo-IPinfo /opt/Geo-IPinfo
WORKDIR /opt/Geo-IPinfo
RUN perl Makefile.PL
RUN make && make install
COPY example.pl /opt/example.pl
ENTRYPOINT "/bin/bash"
