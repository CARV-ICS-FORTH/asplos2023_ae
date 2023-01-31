#!/usr/bin/env bash

###################################################
#
# file: gen_fig5.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Generate all the plots for Figure5
#
###################################################

. ./funcs.sh

# Generate Spark plots
./spark_pr.sh
./spark_cc.sh
./spark_sssp.sh
./spark_svd.sh
./spark_tr.sh
./spark_lr.sh
./spark_lgr.sh
./spark_svm.sh
./spark_bc.sh
./spark_sql.sh

# Generate Giraph plots

## Recompile JVM to run for Giraph
compile_jvm

# Generate datasets for Giraph workloads
generate_giraph_datasets "datagen-9_0-fb"

workloads=( "pr" "cdlp" "wcc" "bfs" "sssp" )
h1_size=(70 70 70 48 75)
mem_budget=(85 85 85 65 90)

for ((i=0; i<"${#workloads[@]}"; i++))
do
  run_giraph_experiments true "${h1_size[$i]}" "${mem_budget[$i]}" \
    "${workloads[$i]}" "datagen-9_0-fb" "nat" "${FIG5_RESULTS}"
  parse_giraph_results "${FIG5_RESULTS}"/"${workloads[$i]}" "${h1_size[$i]}" \
    true "${workloads[$i]}" "giraph" "nat"
done

h1_size=(60 60 50 35 60)
mem_budget=(75 75 75 57 80)
for ((i=0; i<"${#workloads[@]}"; i++))
do
  run_giraph_experiments false "${h1_size[$i]}" "${mem_budget[$i]}" \
    "${workloads[$i]}" "datagen-9_0-fb" "th2" "${FIG5_RESULTS}"
  parse_giraph_results "${FIG5_RESULTS}"/"${workloads[$i]}" "${h1_size[$i]}" \
    true "${workloads[$i]}" "giraph" "th2"
done

h1_size=(50 60 60 35 50)
mem_budget=(85 85 85 65 90)
for ((i=0; i<"${#workloads[@]}"; i++))
do
  run_giraph_experiments false "${h1_size[$i]}" "${mem_budget[$i]}" \
    "${workloads[$i]}" "datagen-9_0-fb" "th1" "${FIG5_RESULTS}"
  parse_giraph_results "${FIG5_RESULTS}"/"${workloads[$i]}" "${h1_size[$i]}" \
    true "${workloads[$i]}" "giraph" "th1"
  calc_norm_results "${FIG5_RESULTS}"/"${workloads[$i]}" \
    "${workloads[$i]}" giraph
  sed -i '1i\nat-74,0,0,0' "${FIG5_RESULTS}"/"${workloads[$i]}"/giraph_"${workloads[$i]}"_norm.csv
done
