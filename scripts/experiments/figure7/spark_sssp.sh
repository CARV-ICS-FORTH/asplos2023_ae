#!/usr/bin/env bash

###################################################
#
# file: spark_cc.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark ConnectedComponent workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

jvm_version=$1

native_heap_size=(42)
native_total_dram=(58)

generate_spark_datasets ShortestPaths

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" ShortestPaths false "${jvm_version}"

  ./parse_result.sh "${FIG7_RESULTS}/shortestpaths" \
    "${native_heap_size[$i]}" true sp spark "${jvm_version}"
done
