#!/usr/bin/env bash

###################################################
#
# file: run.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Script to run the experiments
#
###################################################

parse_results() {
  local directory=$1
  local heap_size=$2
  local is_native=$3
  local workload=$4
  local platform=$5
  local prefix=nat

  if [ "${is_native}" == "false" ]
  then
    prefix=th
  fi

    total_time=$(grep "TOTAL_TIME" "${directory}"/"${prefix}"_"${heap_size}"_*/PageRank/run0/conf0/result.csv \
      | awk -F ',' '{print $2}')
    minor_gc_time=$(grep "MINOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/PageRank/run0/conf0/result.csv \
      | awk -F ',' '{print $2}')
    major_gc_time=$(grep "MAJOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/PageRank/run0/conf0/result.csv \
      | awk -F ',' '{print $2}')
    sd_time=$(grep "SERSES" "${directory}"/"${prefix}"_"${heap_size}"_*/PageRank/run0/conf0/result.csv \
      | awk -F ',' '{print $2}')

    echo "${prefix},${heap_size},${total_time},${major_gc_time},${minor_gc_time},${sd_time}" \
      >> "${platform}"_"${workload}".csv
}

