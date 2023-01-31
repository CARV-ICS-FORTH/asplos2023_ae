#!/usr/bin/env bash

###################################################
#
# file: spark_pr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Pagerank workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

jvm_version=$1

native_heap_size=(64)
native_total_dram=(80)

generate_spark_datasets PageRank

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" PageRank false "$jvm_version"

  ./parse_result.sh "${FIG7_RESULTS}/pagerank" \
    "${native_heap_size[$i]}" true pr spark "${jvm_version}"
done
