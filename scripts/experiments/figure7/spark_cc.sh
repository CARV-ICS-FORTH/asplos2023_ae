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

native_heap_size=(68)
native_total_dram=(84)

generate_spark_datasets ConnectedComponent

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" ConnectedComponent false "$jvm_version"

  ./parse_result.sh "${FIG7_RESULTS}/connectedcomponent" \
    "${native_heap_size[$i]}" true cc spark "$jvm_version"
done
