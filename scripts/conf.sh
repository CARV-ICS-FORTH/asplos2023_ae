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

# Path to the artifact evaluation directory
ARTIFACT_EVALUATION_REPO=/opt/kolokasis/asplos23_ae
# Path to the file for H2
DEV="/mnt/fmap/file.txt"
# Set the path to java8
JAVA_8_PATH="/usr/lib/jvm/java-1.8.0-openjdk"
# Set the path to java11
JAVA_11_PATH="/usr/lib/jvm/java-11-openjdk/"
# Set the path to java17 
JAVA_17_PATH="/usr/java/jdk-17.0.4.1/"
# Set gcc compiler
CC=gcc
# Set g++ compiler
CXX=g++
# Iteration
ITER=1

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

##########################################################
########### PARAMETERS FOR GIRAPH BENCHMARKS #############
##########################################################
# Hadoop slave host name
HADOOP_SLAVE=sith4-fast
# HDFS path
HDFS_DIR="/mnt/datasets"
# Device for HDFS
DEV_HDFS=md1
# Device for Zookeeper
DEV_ZK=md0
# Device for TeraHeap or SD
DEV_TH=md0
# TeraHeap file size in GB e.g. 900 -> 900GB
TH_FILE_SZ=700
# Number of compute threads
COMPUTE_THREADS=8

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

ENABLE_NOHINT_HIGH_LOW_WATERMARK="#define NOHINT_HIGH_LOW_WATERMARK"
DISABLE_NOHINT_HIGH_LOW_WATERMARK="//#define NOHINT_HIGH_LOW_WATERMARK"

ENABLE_NOHINT_HIGH_WATERMARK="#define NOHINT_HIGH_WATERMARK"
DISABLE_NOHINT_HIGH_WATERMARK="//#define NOHINT_HIGH_WATERMARK"

FIG5_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure5"
FIG6_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure6"
FIG7_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure7"
FIG8A_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure8/figure8a"
FIG8B_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure8/figure8b"
FIG9_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure9"
FIG10_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure10"
FIG11_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure11"
FIG12_RESULTS="${ARTIFACT_EVALUATION_REPO}/results/figure12"
