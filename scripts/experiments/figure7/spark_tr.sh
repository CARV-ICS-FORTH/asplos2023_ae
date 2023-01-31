#!/usr/bin/env bash

###################################################
#
# file: spark_tr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Triangle count workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

jvm_version=$1

native_heap_size=(64)
native_total_dram=(80)

generate_spark_datasets TriangleCount

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" TriangleCount false "${jvm_version}"

  ./parse_result.sh "${FIG7_RESULTS}/trianglecount" \
    "${native_heap_size[$i]}" true tr spark "${jvm_version}"
done
