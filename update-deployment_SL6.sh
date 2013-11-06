#!/bin/bash

# This script execute a clean deployment of StoRM

trap "exit 1" TERM
set -ex

# install emi-release
wget http://emisoft.web.cern.ch/emisoft/dist/EMI/3/sl6/x86_64/base/emi-release-3.0.0-2.el6.noarch.rpm
yum localinstall --nogpgcheck -y emi-release-3.0.0-2.el6.noarch.rpm

# install
yum clean all
yum install -y emi-storm-backend-mp emi-storm-frontend-mp emi-storm-globus-gridftp-mp emi-storm-gridhttps-mp

# add some users
adduser -r storm
adduser -r gridhttps
usermod -a -G storm gridhttps

# download siteinfo file
mkdir -p /etc/storm/siteinfo
wget https://raw.github.com/italiangrid/storm-deployment-test/master/siteinfo/storm.def -O /etc/storm/siteinfo/storm.def
wget https://raw.github.com/italiangrid/storm-deployment-test/master/siteinfo/vo.d/testers.eu-emi.eu -O /etc/storm/siteinfo/vo.d/testers.eu-emi.eu
wget https://raw.github.com/italiangrid/storm-deployment-test/master/siteinfo/storm-users.conf -O /etc/storm/siteinfo/storm-users.conf
wget https://raw.github.com/italiangrid/storm-deployment-test/master/siteinfo/storm-groups.conf -O /etc/storm/siteinfo/storm-groups.conf
wget https://raw.github.com/italiangrid/storm-deployment-test/master/siteinfo/storm-wn-list.conf -O /etc/storm/siteinfo/storm-wn-list.conf

# do yaim
/opt/glite/yaim/bin/yaim -c -d 6 -s /etc/storm/siteinfo/storm.def -n se_storm_backend -n se_storm_frontend -n se_storm_gridftp -n se_storm_gridhttps

# install the storm repo
wget http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_storm_develop_SL6/lastSuccessfulBuild/artifact/storm_develop_sl6.repo -O /etc/yum.repos.d/storm_develop_sl6.repo

# update
yum clean all
yum update

# do yaim
/opt/glite/yaim/bin/yaim -c -d 6 -s /etc/storm/siteinfo/storm.def -n se_storm_backend -n se_storm_frontend -n se_storm_gridftp -n se_storm_gridhttps