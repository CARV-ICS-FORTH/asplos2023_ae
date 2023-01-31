#!/usr/bin/env bash

###################################################
#
# file: spark_pr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Pagerank workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(32 64 128)
native_total_dram=(48 80 144)
teraheap_heap_size=(16 64)
teraheap_total_dram=(32 80)

generate_spark_datasets PageRank

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" PageRank
  ./parse_result.sh "${FIG5_RESULTS}/pagerank" \
    "${native_heap_size[$i]}" true pr spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" PageRank
  parse_results "${FIG5_RESULTS}/pagerank" \
    "${teraheap_heap_size[$i]}" false pr spark
done

calc_norm_results "${FIG5_RESULTS}/pagerank" pr spark
