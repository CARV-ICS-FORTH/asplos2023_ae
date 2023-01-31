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

native_heap_size=(34 68 136)
native_total_dram=(50 84 152)
teraheap_heap_size=(17 68)
teraheap_total_dram=(33 84)

generate_spark_datasets ConnectedComponent

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" ConnectedComponent
  ./parse_result.sh "${FIG5_RESULTS}/connectedcomponent" \
    "${native_heap_size[$i]}" true cc spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" ConnectedComponent
  parse_results "${FIG5_RESULTS}/connectedcomponent" \
    "${teraheap_heap_size[$i]}" false cc spark
done

calc_norm_results "${FIG5_RESULTS}/connectedcomponent" cc spark
