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

jvm_version=$1

native_heap_size=(40)
native_total_dram=(59)

generate_spark_datasets SQL false true

for ((i=0; i<"${#native_heap_size[@]}"; i++))
do
  run_spark_experiments true "${native_heap_size[$i]}" \
    "${native_total_dram[i]}" SQL false "$jvm_version"

  ./parse_result.sh "${FIG7_RESULTS}/sql" \
    "${native_heap_size[$i]}" true sql spark "${jvm_version}"
done
