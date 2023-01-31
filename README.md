# TeraHeap Artifact Evaluation

## System Requirements
* Kernel: Linux Kernel 3.10+
* OS: Centos 7
* Devices: NVMe SSD, Intel Optane Persistent Memory

## Install Prerequisites
```sh
./scripts/install_packages.sh
```
Set the following variables in configuration file (./scripts/conf.sh):

|Variable       | Description | 
|:-------------:|:------------|
|ARTIFACT_EVALUATION_REPO | Path to the artifact evaluation directory |
|DEV="/mnt/fmap/file.txt" | Path to the file for H2 |
|JAVA_8_PATH | Set the path to java8 which is installed by the prerequisites packages |
|JAVA_11_PATH | Set the path to java8 which is installed by the prerequisites packages |
|JAVA_17_PATH | Set the path to java17 which is installed by the prerequisites packages|
|CC=gcc | Set gcc compiler |
|CXX=g++ | Set g++ compiler |
|ITER=1 | Iteration |
|DATA_HDFS | Path to the directory with datasets |
|SPARK_MASTER | Spark master host name |
|SPARK_SLAVE | Spark slave host name |
|GC_THREADS | Number of garbage collection threads |
|DEV_SHFL | Device name for shuffle |
|MNT_SHFL | Mount point for shuffle directory |
|DEV_H2 | Device for H2 |
|MNT_H2=/mnt/fmap | Mount point for H2 TeraHeap directory |
|HADOOP_SLAVE | Hadoop slave host name |
|HDFS_DIR | HDFS path |
|DEV_HDFS | Device for HDFS |
|DEV_ZK | Device for Zookeeper |
|DEV_TH=md0 | Device for TeraHeap or SD |
|TH_FILE_SZ=700 | TeraHeap file size in GB e.g. 900 -> 900GB |
|COMPUTE_THREADS=8 | Number of compute threads for Giraph|

## Clone JVM and Applications
Run the following scripts to build the vanilla JVMs, the JVM with
TeraHeap, Spark, Giraph, and the benchmark suits for each framework.
```sh
cd ./scripts/build_jvm
./build_jvm.sh
cd -
cd ./scripts/build_apps
./build_apps.sh
```
The repo after you download the JVMs, frameworks, and benchmarks suits
will have the following form: 

```sh
.
├── jdk11u
├── jdk17u
├── jdk8u
├── plots
├── README.md
├── results
├── scripts
├── tera_applications
└── teraheap

8 directories, 1 file
```

## Generate Figure 5
```sh
cd ./scripts/experiments/figure5
./gen_fig5.sh
```

## Generate Figure 7
```sh
cd ./scripts/experiments/figure7
./gen_fig7.sh
```

## Generate Figure 11
```sh
cd ./scripts/experiments/figure11a 
./gen_fig11a.sh

cd -

cd ./scripts/experiments/figure11b 
./gen_fig11b.sh

cd - 

cd ./scripts/experiments/figure11c 
./gen_fig11c.sh
```
