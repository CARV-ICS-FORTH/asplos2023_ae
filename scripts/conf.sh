#!/usr/bin/env bash

###################################################
#
# file: conf.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Parameters for the artifact evaluation execution
#
###################################################

ARTIFACT_EVALUATION_REPO=/opt/kolokasis/asplos23_ae
DEV="/mnt/fmap/file.txt"
JAVA_8_PATH="/usr/lib/jvm/java-1.8.0-openjdk"
JAVA_11_PATH="/usr/lib/jvm/java-11-openjdk/"
JAVA_17_PATH="/usr/java/jdk-17.0.4.1/"
CC=gcc
CXX=g++

##########################################################
########### PARAMETERS FOR SPARK BENCHMARKS ##############
##########################################################
DATA_HDFS="file:///mnt/datasets/SparkBench"
# Spark master host name
SPARK_MASTER=sith4-fast
# Spark slave host name
SPARK_SLAVE=sith4-fast
# Number of garbage collection threads
GC_THREADS=16
# Device for shuffle
DEV_SHFL=nvme0n1
# Mount point for shuffle directory
MNT_SHFL=/mnt/spark
# Device for H2
DEV_H2=nvme1n1
# Mount point for H2 TeraHeap directory
MNT_H2=/mnt/fmap
# Iteration
ITER=1

##########################################################
############## DO NOT TOUCH THESE VARIABLES ##############
##########################################################
TERAHEAP="teraheap"
TERAHEAP_REPO="git@github.com:jackkolokasis/teraheap.git"
TERAHEAP_PATH="$ARTIFACT_EVALUATION_REPO/$TERAHEAP"
ALLOCATOR_PATH="$TERAHEAP_PATH/allocator"
COMPILE_LOG="${ARTIFACT_EVALUATION_REPO}/scripts/build_jvm/compile.out"

DEV_SIZE="(900*1024LU*1024*1024)"
REGION_SIZE="(256*1024LU*1024)"

ENABLE_SPARK_POLICY="#define SPARK_POLICY"
DISABLE_SPARK_POLICY="//#define SPARK_POLICY"

ENABLE_HIGH_LOW_WATERMARK="#define HINT_HIGH_LOW_WATERMARK"
DISABLE_HIGH_LOW_WATERMARK="//#define HINT_HIGH_LOW_WATERMARK"
