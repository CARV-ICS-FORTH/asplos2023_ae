#!/usr/bin/env bash

###################################################
#
# file: spark_tr.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark Triangle count workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(64)
native_total_dram=(80)
teraheap_heap_size=(43 64)
teraheap_total_dram=(59 80)

generate_spark_datasets TriangleCount

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" TriangleCount
  ./parse_result.sh "${FIG5_RESULTS}/trianglecount" \
    "${native_heap_size[$i]}" true tr spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" TriangleCount
  parse_results "${FIG5_RESULTS}/trianglecount" \
    "${teraheap_heap_size[$i]}" false tr spark
done

calc_norm_results "${FIG5_RESULTS}/trianglecount" tr spark
