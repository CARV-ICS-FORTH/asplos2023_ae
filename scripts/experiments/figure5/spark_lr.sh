#!/usr/bin/env bash

###################################################
#
# file: spark_lr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Linear Regression workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(54 108)
native_total_dram=(70 124)
teraheap_heap_size=(27 27)
teraheap_total_dram=(43 70)

generate_spark_datasets LinearRegression

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" LinearRegression
  ./parse_result.sh "${ARTIFACT_EVALUATION_REPO}/results/linearregression" \
    "${native_heap_size[$i]}" true lr spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" LinearRegression
  parse_results "${ARTIFACT_EVALUATION_REPO}/results/linearregression" \
    "${teraheap_heap_size[$i]}" false lr spark
done

calc_norm_results "${ARTIFACT_EVALUATION_REPO}/results/linearregression" lr spark
