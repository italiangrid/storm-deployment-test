#!/bin/bash
set -ex
trap "exit 1" TERM

COMMON_PATH="../common"
WGET_OPTIONS="--no-check-certificate"

source ${COMMON_PATH}/input.env

# install UMD repositories
sh ${COMMON_PATH}/install-umd-repos.sh

# install the storm repo
wget $WGET_OPTIONS $STORM_REPO -O /etc/yum.repos.d/storm.repo

# update vm
yum clean all
yum update -y

# add some users
adduser -r storm

# install storm packages
yum install -y emi-storm-backend-mp emi-storm-frontend-mp emi-storm-globus-gridftp-mp storm-webdav

# install yaim configuration
sh ${COMMON_PATH}/install-yaim-configuration.sh "clean"

# configure with yaim
/opt/glite/yaim/bin/yaim -c -s /etc/storm/siteinfo/storm.def -n se_storm_backend -n se_storm_frontend -n se_storm_gridftp -n se_storm_webdav

# run post-installation config script
sh ${COMMON_PATH}/post-config-setup.sh "clean"

