FROM ubuntu
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential autoconf automake libtool zlib1g-dev libjpeg-dev libncurses-dev libssl-dev libcurl4-openssl-dev python-dev libexpat-dev libtiff-dev libx11-dev wget git
RUN apt-get install sqlite3 libsqlite3-dev
RUN apt-get install libpcre3 libpcre3-dev
RUN apt-get install libspeexdsp-dev -y
RUN apt-get install libldns-dev -y
RUN apt-get install libedit-dev -y
RUN apt-get install -y supervisor
RUN apt-get install -y openssh-server
RUN apt-get install -y wget

RUN env GIT_SSL_NO_VERIFY=true git clone https://stash.freeswitch.org/scm/fs/freeswitch.git /usr/local/src/freeswitch
RUN cd /usr/local/src/freeswitch; ./bootstrap.sh -j
RUN rm -rf /usr/local/src/freeswitch/modules.conf
WORKDIR /usr/local/src/freeswitch
RUN wget https://www.dropbox.com/s/r6k6xbrwswvy3bt/modules.conf?dl=0
#ADD ./modules.conf /usr/local/src/freeswitch/modules.conf
RUN cd /usr/local/src/freeswitch; ./configure #--prefix=/opt/freeswitch
RUN cd /usr/local/src/freeswitch; make; make install
RUN cd /usr/local/src/freeswitch; make all cd-sounds-install cd-moh-install

RUN rm -rf /usr/local/src/freeswitch/conf/dialplan/default/01_example.com.xml
WORKDIR /usr/local/src/freeswitch/conf/dialplan/default
RUN wget https://www.dropbox.com/s/sq1nl9ulmg1vncd/01_example.com.xml?dl=0
RUN mv 01_example.com.xml?dl=0 01_example.com.xml
#ADD ./01_example.com.xml /opt/freeswitch/conf/dialplan/default/01_example.com.xml

WORKDIR /usr/local/src/freeswitch/scripts
RUN env GIT_SSL_NO_VERIFY=true git clone https://manhhd6058:Abc%40123@github.com/jpijeff/Vo-RXSS-IP.git
WORKDIR /usr/local/src/freeswitch/scripts/Vo-RXSS-IP
RUN wget https://www.dropbox.com/s/1dnvdrnqrjkwjpo/Dusty1-break1.wav?dl=0
RUN mv Dusty1-break1.wav?dl=0 Dusty1-break1.wav

RUN mkdir /var/www/
RUN mkdir /var/www/html/
RUN mkdir /var/www/html/seta

RUN mkdir /var/run/sshd
RUN echo 'root:neo' |chpasswd
EXPOSE 22
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
