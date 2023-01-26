#!/usr/bin/env bash
. ../conf.sh

compile_spark() {
  CUR_DIR=$(pwd)
  cd ../../tera_applications/spark || exit

  command="\"${TERAHEAP_PATH}\""
  sed '/TERAHEAP_REPO=/c\TERAHEAP_REPO='"${command}" config.sh

  command="export JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
  sed -i '/export JAVA_HOME/c\'"${command}" config.sh

  command="TERA_APPS_REPO=\"${ARTIFACT_EVALUATION_REPO}/tera_applications\""
  sed -i '/TERA_APPS_REPO=/c\'"${command}" config.sh

  ./build.sh -a

  cd "$CUR_DIR" || exit
}

compile_spark
