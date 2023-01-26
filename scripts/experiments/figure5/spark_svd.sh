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

native_heap_size=(24 48)
native_total_dram=(40 64)
teraheap_heap_size=(12 24)
teraheap_total_dram=(28 40)

generate_spark_datasets SVDPlusPlus

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" SVDPlusPlus
  ./parse_result.sh "${ARTIFACT_EVALUATION_REPO}/results/svdplusplus" \
    "${native_heap_size[$i]}" true svd spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" SVDPlusPlus
  parse_results "${ARTIFACT_EVALUATION_REPO}/results/svdplusplus" \
    "${teraheap_heap_size[$i]}" false svd spark
done

calc_norm_results "${ARTIFACT_EVALUATION_REPO}/results/svdplusplus" svd spark
