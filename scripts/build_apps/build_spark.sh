#!/usr/bin/env bash

###################################################
#
# file: build_spark.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Build Spark and SparkBench suite
#
###################################################

. ../conf.sh

clone_tera_apps() {
  git clone git@github.com:jackkolokasis/tera_applications.git  >> "$COMPILE_LOG" 2>&1

  mv tera_applications "${ARTIFACT_EVALUATION_REPO}"/
}

compile_spark() {
  CUR_DIR=$(pwd)
  cd "${ARTIFACT_EVALUATION_REPO}"/tera_applications/spark || exit

  command="\"${TERAHEAP_PATH}\""
  sed '/TERAHEAP_REPO=/c\TERAHEAP_REPO='"${command}" config.sh

  command="export JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
  sed -i '/export JAVA_HOME/c\'"${command}" config.sh

  command="TERA_APPS_REPO=\"${ARTIFACT_EVALUATION_REPO}/tera_applications\""
  sed -i '/TERA_APPS_REPO=/c\'"${command}" config.sh

  ./build.sh -a

  cd "$CUR_DIR" || exit
}

clone_tera_apps
compile_spark
