#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

#Install depos
apt-get install -y software-properties-common unzip git python3 build-essential python-dev autotools-dev libicu-dev libbz2-dev libboost-all-dev

add-apt-repository -y ppa:jonathonf/gcc-7.1 && apt-get update && apt-get install -y gcc-7 g++-7 


##Latest versions as of 20181001
#Install Cmake 3.12
cd /tmp && wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh && chmod +x cmake* && ./cmake-3.12.2-Linux-x86_64.sh --prefix=/usr/ --skip-license

#Remove old libboost
apt -y autoremove && apt -y remove 'libboost-.*' && apt -y remove 'libboost-.*-dev'

# Install libboost 1.68 
# https://codeyarns.com/2017/01/24/how-to-build-boost-on-linux/
cd /tmp &&  wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz && tar -zxf boost* && cd boost* && ./bootstrap.sh --prefix=/usr/ && ./b2 install -j $(nproc --all)

#Install NSLR-server
cd /tmp && wget https://github.com/rjhansen/nsrlsvr/tarball/master && tar -zxf master && cd rjhan* && cmake -DPYTHON_EXECUTABLE=`which python3` . && make && make install

#Grabs NIST NSR
cd $HOME && wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/rds_modernu.zip && unzip rds* && cd rds*

#Loads NIST WL into server database
nsrlupdate NSRLFile.txt

#Server test
nsrlsvr --dry-run

