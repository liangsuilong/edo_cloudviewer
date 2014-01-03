FROM ubuntu:12.04

MAINTAINER Liang Suilong <liangsuilong@gmail.com>

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
RUN apt-add-repository -y ppa:coolwanglu/pdf2htmlex ppa:rwky/redis 
RUN apt-add-repository -y ppa:rwky/redis 
RUN apt-add-repository -y ppa:guilhem-fr/swftools

RUN apt-get -y update
RUN apt-get -y install build-essential python-dev zlib1g-dev libjpeg62-dev libtiff-tools python-imaging unrtf pstotext source-highlight gsfonts ttf-wqy-zenhei ffmpeg ffmpegthumbnailer lame unrar libungif4-dev libfreetype6-dev poppler-utils nginx fontconfig libxslt1-dev wget xlhtml pdf2htmlex swftools

RUN wget http://mirrors.ustc.edu.cn/tdf/libreoffice/stable/4.1.4/deb/x86_64/LibreOffice_4.1.4_Linux_x86-64_deb.tar.gz
RUN tar xvf LibreOffice_4.1.4_Linux_x86-64_deb.tar.gz
RUN cd LibreOffice_4.1.4.2_Linux_x86-64_deb/DEBS
RUN rm -f *debian*.deb *gnome*.deb *kde*.deb
RUN dpkg -i *.deb
RUN cd /
RUN rm -rf /LibreOffice_4.1.4.2_Linux_x86-64_deb
RUN pip install uwsgi

RUN cd /opt
RUN mkdir -p edo_cloudviewer/app/fts_app
RUN mkdir -p edo_cloudviewer/app/fts_worker
RUN mkdir -p edo_cloudviewer/app/fts_web

RUN mkdir -p edo_cloudviewer/data/fts_web/files
RUN mkdir -p edo_cloudviewer/data/fts_web/frscache/files
RUN mkdir -p edo_cloudviewer/data/redis
RUN mkdir -p edo_cloudviewer/data/var/log
RUN mkdir -p edo_cloudviewer/buildout-cache/eggs


RUN cd edo_cloudviewer/
RUN wget http://download.zopen.cn/releases/cloudviewer.tar.gz
RUN tar xvf cloudviewer.tar.gz
RUN rm -f cloudviewer.tar.gz

RUN cp cloudviewer/edo_cloudviewer/{ubuntu,base,buildout}.cfg .
RUN cp cloudviewer/edo_cloudviewer/bootstrap.py .
RUN python bootstrap.py
RUN bin/buildout install supervisord

RUN cd app/fts_web
RUN cp ../cloudviewer/fts_web/{buildout.cfg,bootstrap.py,app.ini,uwsgi.ini} .
RUN python bootstrap.py
RUN bin/buildout install app wsgi
RUN cd ../../

RUN cd app/fts_app
RUN cp ../cloudviewer/fts_app/{buildout.cfg,bootstrap.py,app.ini} .
RUN python bootstrap.py
RUN bin/buildout install app
RUN cd ../../

RUN cd app/fts_worker
RUN cp ../cloudviewer/fts_worker/{buildout.cfg,bootstrap.py,config.ini} .
RUN python bootstrap.py
RUN bin/buildout install app
RUN cd ../../

RUN cp -r cloudviewer/edo_cloudviewer/etc .

CMD /sbin/sysctl -w net.core.somaxconn=32768 && /opt/edo_cloudviewer/bin/supervisord

EXPOSE 22 9000 8080

WORKDIR /opt/edo_cloudviewer
