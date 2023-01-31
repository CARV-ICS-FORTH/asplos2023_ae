#!/usr/bin/env bash

###################################################
#
# file: spark_sql.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Run Spark SQL workload
#
###################################################

. ../../conf.sh
. ./funcs.sh

native_heap_size=(40)
native_total_dram=(59)
teraheap_heap_size=(43)
teraheap_total_dram=(59)

generate_spark_datasets SQL false true

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" "${native_total_dram[i]}" SQL
  ./parse_result.sh "${FIG5_RESULTS}/sql" \
    "${native_heap_size[$i]}" true sql spark
done

for ((i=0; i<"${#teraheap_heap_size[@]}"; i++))
do
  run_spark_experiments false "${teraheap_heap_size[$i]}" "${teraheap_total_dram[i]}" SQL
  parse_results "${FIG5_RESULTS}/sql" \
    "${teraheap_heap_size[$i]}" false sql spark
done

calc_norm_results "${FIG5_RESULTS}/sql" sql spark

sed -i $'3 a th,0,0,0,0\n' "${FIG5_RESULTS}/sql/spark_sql_norm.csv"
