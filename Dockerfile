FROM ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends build-essential autoconf automake libtool zlib1g-dev libjpeg-dev libncurses-dev libssl-dev libcurl4-openssl-dev python-dev libexpat-dev libtiff-dev libx11-dev wget git
RUN env GIT_SSL_NO_VERIFY=true git clone https://stash.freeswitch.org/scm/fs/freeswitch.git /usr/local/src/freeswitch
RUN apt-get install sqlite3 libsqlite3-dev
RUN apt-get install libpcre3 libpcre3-dev
RUN apt-get install libspeexdsp-dev -y
RUN apt-get install libldns-dev -y
RUN apt-get install libedit-dev -y
RUN apt-get install -y supervisor
RUN apt-get install -y openssh-server

RUN cd /usr/local/src/freeswitch; ./bootstrap.sh -j
ADD ./modules.conf /usr/local/src/freeswitch/modules.conf
RUN cd /usr/local/src/freeswitch; ./configure --prefix=/opt/freeswitch
RUN cd /usr/local/src/freeswitch; make; make install
RUN cd /usr/local/src/freeswitch; make all cd-sounds-install cd-moh-install

ADD ./01_example.com.xml /opt/freeswitch/conf/dialplan/default/01_example.com.xml

WORKDIR /usr/local/src/freeswitch/scripts
RUN env GIT_SSL_NO_VERIFY=true git clone https://manhhd6058:Abc%40123@github.com/jpijeff/Vo-RXSS-IP.git

RUN mkdir /var/www/html/seta
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' |chpasswd
EXPOSE 22
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
