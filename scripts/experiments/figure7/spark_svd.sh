#!/usr/bin/env bash

###################################################
#
# file: spark_svd.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark SVD Plus Plus workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

jvm_version=$1

native_heap_size=(24)
native_total_dram=(40)

generate_spark_datasets SVDPlusPlus

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" SVDPlusPlus false "${jvm_version}"

  ./parse_result.sh "${FIG7_RESULTS}/svdplusplus" \
    "${native_heap_size[$i]}" true svd spark "${jvm_version}"
done
