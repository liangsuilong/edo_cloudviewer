FROM ubuntu:12.04

MAINTAINER liangsuilong@gmail.com

RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list 
