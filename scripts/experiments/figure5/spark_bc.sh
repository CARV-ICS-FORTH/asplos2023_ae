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

native_heap_size=(85 160)
native_total_dram=(101 176)
teraheap_heap_size=(85)
teraheap_total_dram=(101)

generate_spark_datasets BC true

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" BC true
  ./parse_result.sh "${ARTIFACT_EVALUATION_REPO}/results/bc" \
    "${native_heap_size[$i]}" true bc spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" BC true
  parse_results "${ARTIFACT_EVALUATION_REPO}/results/bc" \
    "${teraheap_heap_size[$i]}" false bc spark
done

calc_norm_results "${ARTIFACT_EVALUATION_REPO}/results/bc" bc spark

sed -i $'4 a th,0,0,0,0\n' "${ARTIFACT_EVALUATION_REPO}/results/bc/spark_bc_norm.csv"
