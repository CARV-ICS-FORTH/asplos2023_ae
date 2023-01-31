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

../../conf.sh

workloads=( "pr" "cc" "sssp" "svd" "tr" "lr" "lgr" "svm" "bc" "sql" )
workloads_fname=( "pagerank" "connectedcomponent" "shortestpath" "svdplusplus"\
  "trianglecount" "linearregression" "logisticregression" "svm" "bc" "sql" )

teraheap_heap_size=(64 68 42 24 64 27 27 24 85 43)

for w in "${workloads[@]}"
do
  ./spark_"${w}".sh 11
done

# Update the spark configuration file to support G1 Garbage collector
cp ./spark-defaults.conf "${ARTIFACT_EVALUATION_REPO}"/tera_applications/spark/scripts/configs/native

for w in "${workloads[@]}"
do
  if [ "${i}" == "svm" ] || [ "${i}" == "bc" ] || [ "${i}" == "sql" ]
  then
    echo "svm,0,0,0,0" > "${FIG7_RESULTS}"/"${w}"/nat_jvm17
  else
    ./spark_"${w}".sh 17
  fi
done

for ((i=0; i<"${#workloads_fname[@]}"; i++))
do
  case "${workloads_fname[$i]}" in
    "linearregression")
      cp -r "${FIG5_RESULTS}"/"${workloads_fname[$i]}"/"th_${teraheap_heap_size[$i]}_70"* \
        "${FIG7_RESULTS}"/"${workloads_fname[$i]}"
      ;;
    "logisticregression") 
      cp -r "${FIG5_RESULTS}"/"${workloads_fname[$i]}"/"th_${teraheap_heap_size[$i]}_70"* \
        "${FIG7_RESULTS}"/"${workloads_fname[$i]}"
      ;;
    "svm")
      cp -r "${FIG5_RESULTS}"/"${workloads_fname[$i]}"/"th_${teraheap_heap_size[$i]}_30"* \
        "${FIG7_RESULTS}"/"${workloads_fname[$i]}"
      ;;
    *)
      cp -r "${FIG5_RESULTS}"/"${workloads_fname[$i]}"/"th_${teraheap_heap_size[$i]}"* \
        "${FIG7_RESULTS}"/"${workloads_fname[$i]}"
      ;;
  esac
done

# Merge the result files per configuraiton
for w in "${workloads_fname[@]}"
do
  cat "${FIG7_RESULTS}"/"${w}"/nat_jvm11_spark_*.csv >> "${FIG7_RESULTS}"/natjvm11_all.csv
  cat "${FIG7_RESULTS}"/"${w}"/nat_jvm17_spark_*.csv >> "${FIG7_RESULTS}"/natjvm17_all.csv
  cat "${FIG7_RESULTS}"/"${w}"/th_spark_*.csv >> "${FIG7_RESULTS}"/th_all.csv
done

# Calculate the normalized results

divider=$(awk -F ',' '{print $2}' "${FIG7_RESULTS}"/natjvm11_all.csv)

awk -F ',' -v VAR="${divider[*]}" \
  'BEGIN {n=1; split(VAR,arr," ")} {printf("%.2f,%.2f,%.2f,%.2f\n", $2/arr[n], $3/arr[n], $4/arr[n], $5/arr[n++])}' \
  "${FIG7_RESULTS}"/natjvm11_all.csv > "${FIG7_RESULTS}"/natjvm11_norm.csv

awk -F ',' -v VAR="${divider[*]}" \
  'BEGIN {n=1; split(VAR,arr," ")} {printf("%.2f,%.2f,%.2f,%.2f\n", $2/arr[n], $3/arr[n], $4/arr[n], $5/arr[n++])}' \
  "${FIG7_RESULTS}"/natjvm17_all.csv > "${FIG7_RESULTS}"/natjvm17_norm.csv

awk -F ',' -v VAR="${divider[*]}" \
  'BEGIN {n=1; split(VAR,arr," ")} {printf("%.2f,%.2f,%.2f,%.2f\n", $2/arr[n], $3/arr[n], $4/arr[n], $5/arr[n++])}' \
  "${FIG7_RESULTS}"/th_all.csv > "${FIG7_RESULTS}"/th_norm.csv

{
  cat "${FIG7_RESULTS}"/natjvm11_norm.csv
  cat "${FIG7_RESULTS}"/natjvm17_norm.csv
  cat "${FIG7_RESULTS}"/th_norm.csv 
} >> "${FIG7_RESULTS}"/total_norm.csv
