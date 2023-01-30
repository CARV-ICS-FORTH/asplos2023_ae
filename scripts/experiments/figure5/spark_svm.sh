#!/usr/bin/env bash

###################################################
#
# file: spark_lr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark SVM workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(54 108)
native_total_dram=(70 124)
teraheap_heap_size=(22 24)
teraheap_total_dram=(28 30)

generate_spark_datasets SVM

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" SVM
  ./parse_result.sh "${ARTIFACT_EVALUATION_REPO}/results/svm" \
    "${native_heap_size[$i]}" true svm spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" SVM
  parse_results "${ARTIFACT_EVALUATION_REPO}/results/svm" \
    "${teraheap_heap_size[$i]}" false svm spark
done

calc_norm_results "${ARTIFACT_EVALUATION_REPO}/results/svm" svm spark
