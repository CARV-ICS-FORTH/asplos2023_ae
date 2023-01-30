#!/usr/bin/env bash

###################################################
#
# file: spark_lr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Logistic Regression workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(54 108)
native_total_dram=(70 124)
teraheap_heap_size=(27 27)
teraheap_total_dram=(43 70)

generate_spark_datasets LogisticRegression

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" LogisticRegression
  ./parse_result.sh "${ARTIFACT_EVALUATION_REPO}/results/logisticregression" \
    "${native_heap_size[$i]}" true lgr spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" LogisticRegression
  parse_results "${ARTIFACT_EVALUATION_REPO}/results/logisticregression" \
    "${teraheap_heap_size[$i]}" false lgr spark
done

calc_norm_results "${ARTIFACT_EVALUATION_REPO}/results/logisticregression" lgr spark
