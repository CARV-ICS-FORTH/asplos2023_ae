#!/usr/bin/env bash

###################################################
#
# file: spark_cc.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark ConnectedComponent workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(42 84)
native_total_dram=(58 100)
teraheap_heap_size=(21 42)
teraheap_total_dram=(37 58)

generate_spark_datasets ShortestPaths

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" ShortestPaths
  ./parse_result.sh "${FIG5_RESULTS}/shortestpaths" \
    "${native_heap_size[$i]}" true sp spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" ShortestPaths
  parse_results "${FIG5_RESULTS}/shortestpaths" \
    "${teraheap_heap_size[$i]}" false sp spark
done

calc_norm_results "${FIG5_RESULTS}/shortestpaths" sp spark
