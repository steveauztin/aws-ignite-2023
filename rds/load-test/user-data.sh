#!/bin/sh

yum -y install git gcc make automake libtool openssl-devel ncurses-compat-libs
wget https://repo.mysql.com/mysql80-community-release-el7-7.noarch.rpm
rpm -ivh mysql80-community-release-el7-7.noarch.rpm
yum -y update
yum -y install mysql-community-devel mysql-community-client mysql-community-common
git clone https://github.com/akopytov/sysbench
cd sysbench
./autogen.sh
./configure
make
make install