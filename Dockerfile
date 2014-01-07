FROM ubuntu:12.04

MAINTAINER liangsuilong@gmail.com

RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install python-software-properties python-setuptools python-dev python-pip
RUN add-apt-repository -y ppa:coolwanglu/pdf2htmlex 
RUN add-apt-repository -y ppa:rwky/redis 
RUN add-apt-repository -y ppa:guilhem-fr/swftools

RUN apt-get -y update
RUN apt-get -y install build-essential python-dev zlib1g-dev libjpeg62-dev libtiff-tools python-imaging unrtf pstotext source-highlight gsfonts ttf-wqy-zenhei ffmpeg ffmpegthumbnailer lame unrar libungif4-dev libfreetype6-dev poppler-utils nginx fontconfig libxslt1-dev wget xlhtml pdf2htmlex swftools && apt-get -y clean all

RUN wget http://mirrors.ustc.edu.cn/tdf/libreoffice/stable/4.1.4/deb/x86_64/LibreOffice_4.1.4_Linux_x86-64_deb.tar.gz
RUN tar xvf LibreOffice_4.1.4_Linux_x86-64_deb.tar.gz && dpkg -i LibreOffice_4.1.4.2_Linux_x86-64_deb/DEBS/*.deb && rm -rf /LibreOffice_4.1.4.2_Linux_x86-64_deb
RUN pip install uwsgi

WORKDIR /opt
RUN mkdir -p /opt/edo_cloudviewer/app/fts_app
RUN mkdir -p /opt/edo_cloudviewer/app/fts_worker
RUN mkdir -p /opt/edo_cloudviewer/app/fts_web

RUN mkdir -p /opt/edo_cloudviewer/data/fts_web/files
RUN mkdir -p /opt/edo_cloudviewer/data/fts_web/frscache/files
RUN mkdir -p /opt/edo_cloudviewer/data/redis
RUN mkdir -p /opt/edo_cloudviewer/data/var/log
RUN mkdir -p /opt/edo_cloudviewer/buildout-cache/eggs


WORKDIR /opt/edo_cloudviewer
RUN wget http://download.zopen.cn/releases/cloudviewer_test4.tar.gz && tar xvf cloudviewer_test4.tar.gz && rm -f cloudviewer_test4.tar.gz

RUN pip install --upgrade setuptools
RUN cp /opt/edo_cloudviewer/cloudviewer/edo_cloudviewer/ubuntu.cfg /opt/edo_cloudviewer
RUN cp /opt/edo_cloudviewer/cloudviewer/edo_cloudviewer/base.cfg /opt/edo_cloudviewer
RUN cp /opt/edo_cloudviewer/cloudviewer/edo_cloudviewer/buildout.cfg /opt/edo_cloudviewer
RUN cp /opt/edo_cloudviewer/cloudviewer/edo_cloudviewer/bootstrap.py /opt/edo_cloudviewer
RUN python bootstrap.py
RUN bin/buildout install supervisor

WORKDIR /opt/edo_cloudviewer/app/fts_web
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_web/uwsgi.ini .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_web/app.ini .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_web/bootstrap.py .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_web/buildout.cfg .
RUN python bootstrap.py
RUN bin/buildout install app wsgi

WORKDIR /opt/edo_cloudviewer/app/fts_app
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_app/app.ini .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_app/bootstrap.py .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_app/buildout.cfg .
RUN python bootstrap.py
RUN bin/buildout install app

WORKDIR /opt/edo_cloudviewer/app/fts_worker
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_worker/buildout.cfg .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_worker/bootstrap.py .
RUN cp /opt/edo_cloudviewer/cloudviewer/fts_worker/config.ini .
RUN python bootstrap.py
RUN bin/buildout install app

WORKDIR /opt/edo_cloudviewer/
RUN cp -r /opt/edo_cloudviewer/cloudviewer/edo_cloudviewer/etc .

CMD /sbin/sysctl -w net.core.somaxconn=32768 && /opt/edo_cloudviewer/bin/supervisord

EXPOSE 22 9000 8080

WORKDIR /opt/edo_cloudviewer
