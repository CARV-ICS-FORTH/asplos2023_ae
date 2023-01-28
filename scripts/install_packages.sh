#!/usr/bin/env bash

###################################################
#
# file: install_packages.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Parameters for the artifact evaluation execution
#
###################################################

sudo mkdir -p /opt/asplos_ae

# Install JAVA 8
sudo yum -y install java-1.8.0-openjdk

# Install JAVA 11
sudo yum -y install java-11-openjdk-devel

# Install JAVA 17
sudo yum -y install wget curl
wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz
sudo mv jdk-17.0.2/ /opt/asplos_ae/jdk-17/

# Install eps to pdf
sudo yum -y install texlive-epstopdf

# Install cgroups
sudo yum -y install libcgroup libcgroup-tools

# Install maven
wget https://downloads.apache.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
sudo tar xf apache-maven-3.6.0-bin.tar.gz -C /opt/asplos_ae

# Install Python3
sudo yum -y install python3
sudo yum -y install python3-pip
sudo python3 -m pip install -U matplotlib
sudo pip3 install matplotlib
