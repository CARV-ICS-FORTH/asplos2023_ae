#!/usr/bin/env bash

###################################################
#
# file: build_spark.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Build Spark and Giraph frameworks and benchmark 
# applications
#
###################################################

. ../conf.sh

##
# Description: 
#   Check if the last command executed succesfully
#   if executed succesfully, print SUCCEED
#   if executed with failures, print FAIL and exit
#
# Arguments:
#   $1 - Command return result
#   $2 - Print message
#
check () {
    if [ "$1" -ne 0 ]
    then
        echo -e "  $2 \e[40G [\e[31;1mFAIL\e[0m]"
        exit
    else
        echo -e "  $2 \e[40G [\e[32;1mSUCCED\e[0m]"
    fi
}

##
# Description: 
#   Clone the repo with applications that support TeraHeap
#
clone_tera_apps() {
  git clone git@github.com:jackkolokasis/tera_applications.git  >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Clone repository with applications" 
  check ${retValue} "${message}"

  mv tera_applications "${ARTIFACT_EVALUATION_REPO}"/
  
}

##
# Description: 
#   Compile Spark and SparkBench suite
#
compile_spark() {
  local CUR_DIR
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

##
# Description: 
#   Compile Giraph and LDBC graphalytics benchmark suite
#
compile_giraph() {
  local CUR_DIR
  CUR_DIR=$(pwd)

  cd "${ARTIFACT_EVALUATION_REPO}"/tera_applications/giraph || exit
  
  command="export JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
  sed -i '/export JAVA_HOME/c\'"${command}" config.sh
  
  command="TERA_APPS_REPO=\"${ARTIFACT_EVALUATION_REPO}/tera_applications\""
  sed -i '/TERA_APPS_REPO=/c\'"${command}" config.sh
  
  ./build.sh -a

  cd "$CUR_DIR" || exit

}

##
# Description: 
#   Print paths that you have to export in the .bashrc
#
print_msg() {
  echo
  echo "-----------------------------------"
  echo "Add the following commands in your ~/.bashrc"
  echo "Then execute 'source ~/.bashrc'"
  echo "-----------------------------------"
  echo 
  echo "export ZOOKEEPER_HOME=${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/zookeeper-3.4.1"
  echo "export PATH=\$ZOOKEEPER_HOME/bin:\$PATH"
  echo "export HADOOP_HOME=${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/hadoop-2.4.0"
  echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native"
  echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib -Djava.library.path=\$HADOOP_HOME/lib/native\""
  echo "export HADOOP_OPTS=\"-Djava.library.path=\$LD_LIBRARY_PATH\""
  echo "export HADOOP_PREFIX=${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/hadoop-2.4.0"
  echo "export PATH=\$HADOOP_PREFIX/bin:\$PATH"
  echo "export PATH=\$HADOOP_PREFIX/sbin:\$PATH"
  echo "export HADOOP_MAPRED_HOME=\${HADOOP_PREFIX}"
  echo "export HADOOP_COMMON_HOME=\${HADOOP_PREFIX}"
  echo "export HADOOP_HDFS_HOME=\${HADOOP_PREFIX}"
  echo "export YARN_HOME=\${HADOOP_PREFIX}"
}

clone_tera_apps
compile_spark
compile_giraph
print_msg

