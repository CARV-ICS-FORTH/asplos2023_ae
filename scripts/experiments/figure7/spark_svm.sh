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

jvm_version=$1

native_heap_size=(54)
native_total_dram=(70)

generate_spark_datasets SVM

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" SVM false "${jvm_version}"

  ./parse_result.sh "${FIG7_RESULTS}/results/svm" \
    "${native_heap_size[$i]}" true svm spark "${jvm_version}"
done
