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
#   Check if the last command executed succesfully
#   if executed succesfully, print SUCCEED
#   if executed with failures, print FAIL and exit
#
# Arguments:
#   $1 - Command return result
#   $2 - Print message
#
check () {
    if [ "$1" -ne 0 ]
    then
        echo -e "  $2 \e[40G [\e[31;1mFAIL\e[0m]"
        exit
    else
        echo -e "  $2 \e[40G [\e[32;1mSUCCED\e[0m]"
    fi
}

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

  if [ "$is_native" == true ]
  then
    command="MY_JAVA_HOME=\"${ARTIFACT_EVALUATION_REPO}/native_jvm/build/linux-x86_64-normal-server-release/jdk\""
    sed -i 'MY_JAVA_HOME=/c\'"$MY_JAVA_HOME" conf.sh
  else
    command="MY_JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
    sed -i 'MY_JAVA_HOME=/c\'"$MY_JAVA_HOME" conf.sh
  fi

  command="DATA_HDFS=\"$DATA_HDFS\""
  sed -i 'DATA_HDFS=/c\'"$command" conf.sh

  command="BENCH_DIR=\"$ARTIFACT_EVALUATION_REPO/tera_applications\""
  sed -i 'BENCH_DIR=/c\'"$command" conf.sh

  command="SPARK_MASTER=$SPARK_MASTER"
  sed -i 'SPARK_MASTER=/c\'"$command" conf.sh

  command="SPARK_SLAVE=$SPARK_SLAVE"
  sed -i 'SPARK_SLAVE=/c\'"$command" conf.sh

  command="GC_THREADS=$GC_THREADS"
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

  cur_dir=$(pwd)

  cd "${ARTIFACT_EVALUATION_REPO}"/tera_applications/spark/scripts || exit

  if [ "${is_sql}" == "true" ]
  then
    ./sql_gen_data.sh
  elif [ "$is_custom" == "true" ]
  then
    word_to_remove="file:\/\/"
    dataset_path="${DATA_HDFS//${word_to_remove}/}"
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
  local workload_lower
  local cur_dir

  cur_dir=$(pwd)
  
  # Transform workload name to lower case
  workload_lower=$(echo "${workload}" | awk '{print tolower($1)}')

  cd "${ARTIFACT_EVALUATION_REPO}/tera_applications/spark/scripts" || exit

  setup_spark_conf "$is_native" "$h1_size" "$mem_budget" "$workload"

  if [ "$is_native" == "true" ]
  then
    # Run workload with native JVM
    if [ "${is_custom}" == "false" ]
    then
      ./run.sh -n 1 -o "${FIG5_RESULTS}/${workload_lower}/nat_${h1_size}_${mem_budget}" -s
    else
      ./run.sh -n 1 -o "${FIG5_RESULTS}/${workload_lower}/nat_${h1_size}_${mem_budget}" -s -b
    fi
  else
    # Run workload with JVM that supports TeraHeap
    if [ "${is_custom}" == "false" ]
    then
      ./run.sh -n 1 -o "${FIG5_RESULTS}/${workload_lower}/th_${h1_size}_${mem_budget}" -t
    else
      ./run.sh -n 1 -o "${FIG5_RESULTS}/${workload_lower}/th_${h1_size}_${mem_budget}" -t -b
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

  local prefix=nat
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
    >> "${directory}"/"${platform}"_"${workload}".csv
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

  divider=$(head -n 1 "${directory}"/"${platform}"_"${workload}".csv \
    | awk -F',' '{print $2}')

  awk -v div=${divider} -F ',' '{print $1,$2/div,$3/div,$4/div,$5/div}' \
    "${directory}/${platform}_${workload}.csv" \
    >> "${directory}/${platform}_${workload}_norm.csv"
}

##
# Description: 
#   Setup the giraph configuration for the specific workload
#
# Arguments:
#   $1 - Flag indicate if the run is with native jvm or TeraHeap
#   $2 - Size of the heap
#   $3 - Total size of DRAM
##
setup_giraph_conf() {
  local is_native=$1
  local h1_size=$2
  local mem_budget=$3
  local workload=$4
  local dataset_name=$5
  local card_size="${6:-8}"
  local region_size="${7:-256}"

  command="BENCHMARK_SUITE=\"${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/graphalytics-platforms-giraph/graphalytics-1.2.0-giraph-0.2-SNAPSHOT\""
  sed -i 'BENCHMARK_SUITE=/c\'"$command" conf.sh

  command="HADOOP=\"${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/hadoop-2.4.0\""
  sed -i 'HADOOP=/c\'"$command" conf.sh

  command="ZOOKEEPER=\"${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/zookeeper-3.4.1\""
  sed -i 'ZOOKEEPER=/c\'"$command" conf.sh
  
  command="DATASET_DIR=\"${HDFS_DIR}\""
  sed -i 'DATASET_DIR=/c\'"$command" conf.sh

  command="ZOOKEEPER_DIR=\"${MNT_H2}\""
  sed -i 'ZOOKEEPER_DIR=/c\'"$command" conf.sh
  
  command="TH_DIR=\"${MNT_H2}\""
  sed -i 'TH_DIR=/c\'"$command" conf.sh
  
  command="DEV_HDFS=${DEV_HDFS}"
  sed -i 'DEV_HDFS=/c\'"$command" conf.sh
  
  command="DEV_ZK=${DEV_ZK}"
  sed -i 'DEV_ZK=/c\'"$command" conf.sh
  
  command="DEV_TH=\"${DEV_TH}\""
  sed -i 'DEV_TH=/c\'"$command" conf.sh
  
  command="TH_FILE_SZ=\"${TH_FILE_SZ}\""
  sed -i 'TH_FILE_SZ=/c\'"$command" conf.sh
  
  command="HEAP=${h1_size}"
  sed -i 'HEAP=/c\'"$command" conf.sh

  command="GC_THREADS=${GC_THREADS}"
  sed -i 'GC_THREADS=/c\'"$command" conf.sh
  
  command="COMPUTE_THREADS=${COMPUTE_THREADS}"
  sed -i 'COMPUTE_THREADS=/c\'"$command" conf.sh

  command="BENCHMARKS=( \"${workload}\" )"
  sed -i 'BENCHMARKS=/c\'"$command" conf.sh

  command="MEM_BUDGET=$mem_budget"
  sed -i 'MEM_BUDGET=/c\'"$command" conf.sh

  if [ "$card_size" == "512" ]
  then
    command="CARD_SIZE=$card_size"
  else
    command="CARD_SIZE=\$(($card_size * 1024))"
  fi
  sed -i 'CARD_SIZE=/c\'"$command" conf.sh
    
  command="REGION_SIZE=\$(($region_size * 1024 * 1024))"
  sed -i 'REGION_SIZE=/c\'"$command" conf.sh
  
  if [ "$is_native" == true ]
  then
    command="MY_JAVA_HOME=\"${ARTIFACT_EVALUATION_REPO}/jdk8u/build/linux-x86_64-normal-server-release/jdk\""
    sed -i 'MY_JAVA_HOME=/c\'"$command" conf.sh
  else
    command="MY_JAVA_HOME=\"${TERAHEAP_PATH}/jdk8u345/build/linux-x86_64-normal-server-release/jdk\""
    sed -i 'MY_JAVA_HOME=/c\'"$command" conf.sh
  fi
  
  command="DATASET_NAME=\"${dataset_name}\""
  sed -i 'DATASET_NAME=/c\'"$command" conf.sh
}

##
# Description: 
#   Generate the dataset for the giraph workloads
#
# Arguments:
#  $1 - Name of the dataset
##
generate_giraph_datasets() {
  local dataset_name=$1
  local cur_dir
    
  if [ -d "${HDFS_DIR}/graphs" ]
  then
    if [ -f "${HDFS_DIR}/graphs/${dataset_name}" ]
    then
      return
    fi
  fi

  cur_dir=$(pwd)

  cd "${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/scripts" || exit

  ./download-graphalytics-data-sets.sh "${HDFS_DIR}"

  cd "${cur_dir}" || exit
}

##
# Description: 
#   Run Giraph experiments for the specific workload
#
# Arguments:
#   $1 - Flag indicate if the run is with native jvm or TeraHeap
#   $2 - Size of the heap
#   $3 - Total size of DRAM
#   $4 - Workload name (pr, cdlp, wcc, bfs, sssp)
##
run_giraph_experiments() {
  local is_native=$1
  local h1_size=$2
  local mem_budget=$3
  local workload=$4
  local dataset_name=$5
  local prefix=$6
  local result_path=$7
  local card_size="${8:-8}"
  local region_size="${9:-256}"
  local cur_dir

  cur_dir=$(pwd)
  
  cd "${ARTIFACT_EVALUATION_REPO}/tera_applications/giraph/scripts" || exit

  setup_giraph_conf "$is_native" "$h1_size" "$mem_budget" "$workload" "$dataset_name" "$card_size" "$region_size"

  if [ "$is_native" == "true" ]
  then
    ./run.sh -n 1 -o "${result_path}/${workload}/${prefix}_${h1_size}_${mem_budget}" -s
  else
    ./run.sh -n 1 -o "${result_path}/${workload}/${prefix}_${h1_size}_${mem_budget}" -t
  fi

  cd "${cur_dir}" || exit
}

##
# Description: 
#   Recompile TeraHeap - jvm for Giraph
#
compile_jvm() {
  cd "$TERAHEAP_PATH"/jdk8u345/ || exit

  sed  -i '/SPARK_POLICY/c\'"${DISABLE_SPARK_POLICY}" hotspot/src/share/vm/memory/sharedDefines.h
  sed  -i '/ HINT_HIGH_LOW_WATERMARK/c\'"${ENABLE_HIGH_LOW_WATERMARK}" hotspot/src/share/vm/memory/sharedDefines.h
  
  ./compile.sh -a > "${COMPILE_LOG}" 2>&1
  
  retValue=$?
  message="Build TeraHeap" 
  check ${retValue} "${message}"

  cd - > /dev/null || exit
}

##
# Description: 
#   Parse Giraph results
#
# Arguments:
#   $1 - Input directory with the results
#   $2 - Size of the heap
#   $3 - Flag indicate if the run is with native jvm or TeraHeap
#   $4 - Workload name (e.g., pr)
#   $5 - Platform (e.g., spark/giraph)
##
parse_giraph_results() {
  local directory=$1
  local heap_size=$2
  local is_native=$3
  local workload=$4
  local platform=$5

  local prefix=$6
  local total_time=0
  local minor_gc_time=0
  local major_gc_time=0
  local sd_time=0

  # Parse the results
  for ((i=0; i<ITER; i++))
  do
    num=$(grep "TOTAL_TIME" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    total_time=$(bc <<< "scale=2; ${total_time}+${num}")

    num=$(grep "MINOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    minor_gc_time=$(bc <<< "scale=2; ${minor_gc_time}+${num}")

    num=$(grep "MAJOR_GC" "${directory}"/"${prefix}"_"${heap_size}"_*/*/run"${i}"/conf0/result.csv | awk -F ',' '{print $2}')
    major_gc_time=$(bc <<< "scale=2; ${major_gc_time}+${num}")
  done

  # Calculate the average
  total_time=$(bc <<< "scale=2; ${total_time}/${ITER}")
  minor_gc_time=$(bc <<< "scale=2; ${minor_gc_time}/${ITER}")
  major_gc_time=$(bc <<< "scale=2; ${major_gc_time}/${ITER}")

  # Write the results to the output file as csv
  echo "${prefix},${heap_size},${total_time},${major_gc_time},${minor_gc_time},${sd_time}" \
    >> "${directory}"/"${platform}"_"${workload}".csv
}
