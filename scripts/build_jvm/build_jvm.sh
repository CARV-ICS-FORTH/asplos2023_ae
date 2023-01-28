#! /usr/bin/env bash

###################################################
#
# file: build_jvm.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Clone and build OpenJDK8,11,17, and TeraHeap
#
###################################################

. ./../conf.sh

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
#   Clone the repository of TeraHeap which contains the JVM and the
#   TeraHeap allocator
#
clone_teraheap() {
  git clone "$TERAHEAP_REPO" > "$COMPILE_LOG" 2>&1
  retValue=$?
  message="Clone TeraHeap repository" 
  check ${retValue} "${message}"

  mv "$TERAHEAP" "${ARTIFACT_EVALUATION_REPO}"/
}

##
# Description: 
#   Build H2 allocator
#
build_allocator() {
  cd "${ALLOCATOR_PATH}" || exit

  command="#define DEV \"${DEV}\""
  sed -i '/DEV /c\'"${command}" include/sharedDefines.h
  command="#define DEV_SIZE ${DEV_SIZE}"
  sed -i '/DEV_SIZE /c\'"${command}" include/sharedDefines.h
  command="#define REGION_SIZE ${REGION_SIZE}"
  sed -i '/REGION_SIZE /c\'"${command}" include/sharedDefines.h
  command="#define STATISTICS 0"
  sed -i '/STATISTICS/c\'"${command}" include/sharedDefines.h

  ./build.sh  >> "$COMPILE_LOG" 2>&1
  retValue=$?
  message="Build H2 allocator" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit 
}

##
# Description: 
#   Build JVM (Java 8) that support TeraHeap
#
build_teraheap_jvm() {
  cd "$TERAHEAP_PATH"/jdk8u345/ || exit

  sed  -i '/SPARK_POLICY/c\'"${ENABLE_SPARK_POLICY}" hotspot/src/share/vm/memory/sharedDefines.h
  sed  -i '/ HINT_HIGH_LOW_WATERMARK/c\'"${DISABLE_HIGH_LOW_WATERMARK}" hotspot/src/share/vm/memory/sharedDefines.h

  command="export JAVA_HOME=\"${JAVA_8_PATH}\""
  sed -i '/JAVA_HOME/c\'"${command}" compile.sh

  sed -i '/CC=gcc/c\CC='"$CC" compile.sh
  sed -i '/CXX=g++/c\CXX='"$CXX" compile.sh
  command="export JAVA_HOME=\"${JAVA_8_PATH}\""
  sed -i '/JAVA_HOME/c\'"${command}" compile.sh

  ./compile.sh -a >> "${COMPILE_LOG}" 2>&1

  retValue=$?
  message="Build TeraHeap" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit
}

# Build native JVM (do not support TeraHeap)
build_native_jvm() {
  git clone --depth=1 --branch jdk8u345-b01 \
    git@github.com:openjdk/jdk8u.git >> "$COMPILE_LOG" 2>&1

  mv jdk8u "${ARTIFACT_EVALUATION_REPO}"/

  cd "$ARTIFACT_EVALUATION_REPO"/jdk8u/ || exit

  export JAVA_HOME="${JAVA_8_PATH}"
  {
    make dist-clean
    CC=$CC CXX=$CXX \
      bash ./configure \
      --with-jobs=32 \
      --disable-debug-symbols \
      --with-extra-cflags='-O3' \
      --with-extra-cxxflags='-O3' \
      --with-target-bits=64
          make
  } >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Build native OpenJDK8" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit
}

##
# Description: 
#   Build native JVM Java11 (do not support TeraHeap)
#
build_native_jvm11() {
  git clone --depth=1 --branch jdk-11.0.17+6 \
    git@github.com:openjdk/jdk11u.git >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Clone OpenJDK11" 
  check ${retValue} "${message}"

  mv jdk11u "${ARTIFACT_EVALUATION_REPO}"/

  cd "$ARTIFACT_EVALUATION_REPO"/jdk11u/ || exit
  {
    make dist-clean
    CC=$CC CXX=$CXX \
      bash ./configure \
      --with-jobs=32 \
      --disable-debug-symbols \
      --with-extra-cflags='-O3' \
      --with-extra-cxxflags='-O3' \
      --with-target-bits=64 \
      --with-boot-jdk="${JAVA_11_PATH}"
    make
  } >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Build native OpenJDK11" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit
}

##
# Description: 
#   Build native JVM Java17 (do not support TeraHeap)
#
build_native_jvm17() {
  git clone --depth=1 --branch jdk-17.0.4.1+0 \
    git@github.com:openjdk/jdk17u.git >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Clone OpenJDK17" 
  check ${retValue} "${message}"

  mv jdk17u "${ARTIFACT_EVALUATION_REPO}"/

  cd "$ARTIFACT_EVALUATION_REPO"/jdk17u/ || exit

	export JAVA_HOME="$JAVA_17_PATH"
  {
    make dist-clean
    CC=$CC CXX=$CXX \
      bash ./configure \
      --with-jobs=32 \
      --with-extra-cflags='-O3' \
      --with-extra-cxxflags='-O3' \
      --with-target-bits=64
    make
  } >> "$COMPILE_LOG" 2>&1
  
  retValue=$?
  message="Build native OpenJDK17" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit
}

##
# Description: 
#   Print paths that you have to export in the .bashrc
#
print_msg() {
  echo
  echo "-----------------------------------"
  echo "Add the following commands in your .bashrc"
  echo "-----------------------------------"
  echo 
  echo "export LIBRARY_PATH=${ARTIFACT_EVALUATION_REPO}/teraheap/allocator/lib/:\$LIBRARY_PATH"
  echo "export LD_LIBRARY_PATH=${ARTIFACT_EVALUATION_REPO}/teraheap/allocator/lib/:\$LD_LIBRARY_PATH"
  echo "export PATH=${ARTIFACT_EVALUATION_REPO}/teraheap/allocator/include/:\$PATH"
  echo "export C_INCLUDE_PATH=${ARTIFACT_EVALUATION_REPO}/teraheap/allocator/include/:\$C_INCLUDE_PATH" 
  echo "export CPLUS_INCLUDE_PATH=${ARTIFACT_EVALUATION_REPO}/teraheap/allocator/include/:\$CPLUS_INCLUDE_PATH"
}

echo "-----------------------------------"
echo "Compilation output messages are here: ${COMPILE_LOG}"
echo "-----------------------------------"
echo 

clone_teraheap
build_allocator
build_teraheap_jvm
build_native_jvm
build_native_jvm11
build_native_jvm17
print_msg
