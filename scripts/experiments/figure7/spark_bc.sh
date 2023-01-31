#!/usr/bin/env bash

###################################################
#
# file: spark_bc.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Naive Bayes Classifier workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

jvm_version=$1

native_heap_size=(85)
native_total_dram=(101)

generate_spark_datasets BC true

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" BC true "${jvm_version}"

  ./parse_result.sh "${FIG7_RESULTS}/bc" \
    "${native_heap_size[$i]}" true bc spark "${jvm_version}"
done
