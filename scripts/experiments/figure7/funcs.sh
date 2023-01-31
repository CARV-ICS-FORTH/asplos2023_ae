#!/usr/bin/env bash

###################################################
#
# file: funcs.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Functions library that is used by multiple scripts
#
###################################################

. ../../conf.sh

##
# Description: 
#   Setup the spark configuration for the specific workload
#
# Arguments:
#   $1 - Flag indicate if the run is with native jvm or TeraHeap
#   $2 - Size of the heap
#   $3 - Total size of DRAM
##
setup_spark_conf() {
  local is_native=$1
  local h1_size=$2
  local mem_budget=$3
  local workload=$4
  local jvm_version="${5:-8}"

  if [ "$is_native" == true ]
  then
    case "$jvm_version" in
      8)
        command="MY_JAVA_HOME=\"${ARTIFACT_EVALUATION_REPO}/jdk8u/build/linux-x86_64-normal-server-release/jdk\""
        ;;
      11)
        command="MY_JAVA_HOME=\"${ARTIFACT_EVALUATION_REPO}/jdk11u/build/linux-x86_64-normal-server-release/jdk\""
        ;;
      17)
        command="MY_JAVA_HOME=\"${ARTIFACT_EVALUATION_REPO}/jdk17u/build/linux-x86_64-normal-server-release/jdk\""
        ;;
    esac

    sed -i 'MY_JAVA_HOME=/c\'"$command" conf.sh
  else
    command="MY_JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
    sed -i 'MY_JAVA_HOME=/c\'"$command" conf.sh
  fi

  command="DATA_HDFS=\"$DATA_HDFS\""
  sed -i 'DATA_HDFS=/c\'"$command" conf.sh

  command="BENCH_DIR=\"$ARTIFACT_EVALUATION_REPO/tera_applications\""
  sed -i 'BENCH_DIR=/c\'"$command" conf.sh

  command="SPARK_MASTER=$SPARK_MASTER"
  sed -i 'SPARK_MASTER=/c\'"$command" conf.sh

  command="SPARK_SLAVE=$SPARK_SLAVE"
  sed -i 'SPARK_SLAVE=/c\'"$command" conf.sh

  if [ "$jvm_version" == 17 ]
  then
    command="GC_THREADS=8"
  else
    command="GC_THREADS=$GC_THREADS"
  fi
  sed -i 'GC_THREADS=/c\'"$command" conf.sh

  command="DEV_SHFL=$DEV_SHFL"
  sed -i 'DEV_SHFL=/c\'"$command" conf.sh
  
  command="MNT_SHFL=$MNT_SHFL"
  sed -i 'MNT_SHFL=/c\'"$command" conf.sh
  
  command="DEV_H2=$DEV_H2"
  sed -i 'DEV_H2=/c\'"$command" conf.sh
  
  command="MNT_H2=$MNT_H2"
  sed -i 'MNT_H2=/c\'"$command" conf.sh
  
  command="H1_SIZE=($h1_size)"
  sed -i 'H1_SIZE=/c\'"$command" conf.sh
  
  command="MEM_BUDGET=$mem_budget"
  sed -i 'MEM_BUDGET=/c\'"$command" conf.sh
  
  if [ "$is_native" == "true" ]
  then
    command="S_LEVEL=(MEMORY_AND_DISK)"
    sed -i 'S_LEVEL=/c\'"$command" conf.sh
  else
    command="S_LEVEL=(MEMORY_ONLY)"
    sed -i 'S_LEVEL=/c\'"$command" conf.sh
  fi
  
  command="BENCHMARKS=(${workload})"
  sed -i 'BENCHMARKS=/c\'"$command" conf.sh
}

##
# Description: 
#   Generate the dataset for the specific Spark application
#
# Arguments:
#  $1 - Name of the workload 
#  $2 - Depict if the benchmark is custom (Default value: false)
#  $3 - Depict if the benchmark is sql (Default value: false)
##
generate_spark_datasets() {
  local workload=$1
  local is_custom="${2:-false}"
  local is_sql="${3:-false}"
  local cur_dir
  local word_to_remove
  local dataset_path
    
  word_to_remove="file:\/\/"
  dataset_path="${DATA_HDFS//${word_to_remove}/}"

  if [ -d "${dataset_path}/${workload}/Input" ]
  then
    if [ "$(ls -A "${dataset_path}/${workload}/Input/")" ]
    then
      return
    fi
  fi

  cur_dir=$(pwd)

  cd "${ARTIFACT_EVALUATION_REPO}/tera_applications/spark/scripts" || exit

  if [ "${is_sql}" == "true" ]
  then
    ./sql_gen_data.sh
  elif [ "$is_custom" == "true" ]
  then
    ./download_dataset.sh "${dataset_path}"
  else
    setup_spark_conf true 80 120 "$workload"
    ./gen_dataset.sh
  fi

  cd "${cur_dir}" || exit
}

##
# Description: 
#   Run Spark experiments for the specific workload
#
# Arguments:
#   $1 - Flag indicate if the run is with native jvm or TeraHeap
#   $2 - Size of the heap
#   $3 - Total size of DRAM
#   $4 - Workload name
##
run_spark_experiments() {
  local is_native=$1
  local h1_size=$2
  local mem_budget=$3
  local workload=$4
  local is_custom="${5:-false}"
  local jvm_version="${6:-8}"
  local workload_lower
  local cur_dir

  cur_dir=$(pwd)
  
  # Transform workload name to lower case
  workload_lower=$(echo "${workload}" | awk '{print tolower($1)}')

  cd "${ARTIFACT_EVALUATION_REPO}/tera_applications/spark/scripts" || exit

  setup_spark_conf "$is_native" "$h1_size" "$mem_budget" "$workload" "$jvm_version"

  if [ "$is_native" == "true" ]
  then
    # Run workload with native JVM
    if [ "${is_custom}" == "false" ]
    then
      ./run.sh -n 1 -o "${FIG7_RESULTS}/${workload_lower}/nat_jvm${jvm_version}_${h1_size}_${mem_budget}" -s
    else
      ./run.sh -n 1 -o "${FIG7_RESULTS}/${workload_lower}/nat_jvm${jvm_version}_${h1_size}_${mem_budget}" -s -b
    fi
  else
    # Run workload with JVM that supports TeraHeap
    if [ "${is_custom}" == "false" ]
    then
      ./run.sh -n 1 -o "${workload_lower}/th_${h1_size}_${mem_budget}" -t
    else
      ./run.sh -n 1 -o "${workload_lower}/th_${h1_size}_${mem_budget}" -t -b
    fi
  fi

  cd "${cur_dir}" || exit
}


##
# Description: 
#   Parse the results
#
# Arguments:
#   $1 - Input directory with the results
#   $2 - Size of the heap
#   $3 - Flag indicate if the run is with native jvm or TeraHeap
#   $4 - Workload name (e.g., pr)
#   $5 - Platform (e.g., spark/giraph)
##
parse_results() {
  local directory=$1
  local heap_size=$2
  local is_native=$3
  local workload=$4
  local platform=$5
  local jvm_version=$6

  local prefix="nat_jvm${jvm_version}"
  local total_time=0
  local minor_gc_time=0
  local major_gc_time=0
  local sd_time=0

  if [ "${is_native}" == "false" ]
  then
    prefix=th
  fi

  # Parse the results
  for ((i=0; i<ITER; i++))
  do
    num=$(grep "TOTAL_TIME" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    total_time=$(bc <<< "scale=2; ${total_time}+${num}")

    num=$(grep "MINOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    minor_gc_time=$(bc <<< "scale=2; ${minor_gc_time}+${num}")

    num=$(grep "MAJOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    major_gc_time=$(bc <<< "scale=2; ${major_gc_time}+${num}")

    num=$(grep "SERSES" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    sd_time=$(bc <<< "scale=2; ${sd_time}+${num}")
  done

  # Calculate the average
  total_time=$(bc <<< "scale=2; ${total_time}/${ITER}")
  minor_gc_time=$(bc <<< "scale=2; ${minor_gc_time}/${ITER}")
  major_gc_time=$(bc <<< "scale=2; ${major_gc_time}/${ITER}")
  sd_time=$(bc <<< "scale=2; ${sd_time}/${ITER}")

  # Write the results to the output file as csv
  echo "${prefix},${heap_size},${total_time},${major_gc_time},${minor_gc_time},${sd_time}" \
    >> "${directory}"/"${prefix}"_"${platform}"_"${workload}".csv
}

##
# Description: 
#   Print empty rows
#
# Arguments:
#   $1 - Workload name
#   $2 - Platform name
##

print_empty_rows() {
  local directory=$1
  local workload=$2
  local platform=$3
  local is_native=${4:-true}
  num_empty_lines=0

  case "${workload}" in
    "pr" | "cc")
      num_empty_lines=1
      ;;
    "sp" | "svd" | "tr" | "lr" | "lgr" | "bc" | "rl")
      num_empty_lines=2
      ;;
    "svm")
      num_empty_lines=3
      ;;
  esac

  for ((i=0; i<num_empty_lines; i++))
  do
    # Print empty lines
    echo "nat,0,0,0,0" >>"${directory}"/"${platform}"_"${workload}"_norm.csv
  done
}

##
# Description: 
#   Calculate the normalized results
#
# Arguments:
#   $1 - Input directory with the results
#   $2 - Size of the heap
#   $3 - Flag indicate if the run is with native jvm or TeraHeap
#   $4 - Workload name (e.g., pr)
#   $5 - Platform (e.g., spark/giraph)
##
calc_norm_results() {
  local directory=$1
  local workload=$2
  local platform=$3
  local divider

  print_empty_rows "$directory" "$workload" "$platform"

  divider=$(head -n 1 spark_pr.csv | awk -F',' '{print $2}')

  awk -v div=${divider} -F ',' '{print $1,$2/div,$3/div,$4/div,$5/div}' \
    "${directory}/${platform}_${workload}.csv" \
    >> "${directory}/${platform}_${workload}_norm.csv"
}
