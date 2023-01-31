#!/usr/bin/env bash

###################################################
#
# file: run_all.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  25-11-2021
# @email:    kolokasis@ics.forth.gr
#
# Run plot scripts
#
###################################################

function figure5_spark {
  if [ -f ../results/figure5/pagerank/spark_pr_norm.csv ]
  then
    # PR
    ./figure10.py \
      -i ../results/figure5/pagerank/spark_pr_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_pr.eps \
      -l "32" -l "48" -l "80" -l "144" -l "Spark-SD" -l "32" -l "TH" -l "80"

    epstopdf ./produce/figure5/spark_pr.pdf
  fi

  if [ -f "../results/figure5/connectedcomponent/spark_cc_norm.csv" ]
  then
    # CC
    ./figure10.py \
      -i ../results/figure5/connectedcomponent/spark_cc_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_cc.eps \
      -l "33" -l "50" -l "84" -l "152" -l "Spark-SD" -l "33" -l "TH" -l "84"

    epstopdf ./produce/figure5/spark_cc.eps
  fi
	
  if [ -f "../results/figure5/shortestpaths/spark_sp_norm.csv" ]
  then
    # -l 21 -l 42 -l 84 -l "TC-21"
    # SSSP
    ./figure10a.py \
      -i ../results/figure5/shortestpaths/spark_sp_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_sp.eps \
      -l "27" -l "37" -l "58" -l "100" -l "Spark-SD" -l "37" -l "TH" -l "58"

    epstopdf ./produce/figure5/spark_sp.eps
  fi
	
  if [ -f "../results/figure5/trianglecount/spark_tr_norm.csv" ]
  then
    # -l 12 -l 24 -l 48 -l "TC-12"
    # SVD
    ./figure10a.py \
      -i ../results/figure5/svdplusplus/spark_svd_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_svd.eps \
      -l "22" -l "28" -l "40" -l "64" -l "Spark-SD" -l "28" -l "TH" -l "40"

    epstopdf ./produce/figure5/spark_svd.eps
  fi
	
  if [ -f "../results/figure5/trianglecount/spark_tr_norm.csv" ]
  then
    # -l 44 -l 54 -l 64 -l "TC-44"
    # TR
    ./figure10b.py \
      -i ../results/figure5/trianglecount/spark_tr_norm.csv \
      -n 5 \
      -c 1 \
      -o ./produce/figure5/spark_tr.eps \
      -l "59" -l "70" -l "80" -l "Spark-SD" -l "59" -l "TH" -l "80" \
      -t ./produce/figure5/fig23_legend.eps

    epstopdf ./produce/figure5/spark_tr.eps
  fi
	
  if [ -f "../results/figure5/linearregression/spark_lr_norm.csv" ]
  then
    # LR
    ./figure10a.py \
      -i ../results/figure5/linearregression/spark_lr_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_lr.eps \
      -l "29" -l "43" -l "70" -l "124" -l "Spark-SD" -l "43" -l "TH" -l "70"

    epstopdf ./produce/figure5/spark_lr.eps
  fi

  if [ -f ../results/figure5/logisticregression/spark_lgr_norm.csv ]
  then
    # LgR
    ./figure10a.py \
      -i ../results/figure5/logisticregression/spark_lgr_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_lgr.eps \
      -l "29" -l "43" -l "70" -l "124" -l "Spark-SD" -l "43" -l "TH" -l "70"

    epstopdf ./produce/figure5/spark_lgr.eps
  fi
	
  if [ -f ../results/figure5/svm/spark_svm_norm.csv ]
  then
    # SVM
    ./figure10f.py \
      -i ../results/figure5/svm/spark_svm_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_svm.eps \
      -l "28" -l "32" -l "36" -l "48" -l "Spark-SD" -l "36" -l "TH" -l "48"

    epstopdf ./produce/figure5/spark_svm.eps
  fi
	
  if [ -f ../results/figure5/bc/spark_bc_norm.csv ]
  then
    # -l 12 -l 24 -l 48 -l "TC-12"
    # BC
    ./figure10e.py \
      -i ../results/figure5/bc/spark_bc_norm.csv \
      -n 6 \
      -c 1 \
      -o ./produce/figure5/spark_bc.eps \
      -l "53" -l "57" -l "98" -l "180" -l "Spark-SD" -l "57" -l "TH" -l "98"

    epstopdf ./produce/figure5/spark_bc.eps
  fi
	
  if [ -f ../results/figure5/sql/spark_sql_norm.csv ]
  then
    # -l 44 -l 54 -l 64 -l "TC-44"
    # SQL
    ./figure10c.py \
      -i ../results/figure5/sql/spark_sql_norm.csv \
      -n 5 \
      -c 1 \
      -o ./produce/figure5/spark_sql.eps \
      -l "24" -l "37" -l "63" -l "Spark-SD" -l "37" -l "TH" -l "63"

    epstopdf ./produce/figure5/spark_sql.eps
  fi
}

function figure5_giraph {

  if [ -f ../results/figure5/pr/giraph_pr_norm.csv ]
  then
    # PR
    ./figure10d.py \
      -i ../results/figure5/pr/giraph_pr_norm.csv \
      -n 3 \
      -c 1 \
      -o ./produce/figure5/giraph_pr.eps \
      -l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

    epstopdf ./produce/figure5/giraph_pr.eps
  fi
	
  if [ -f ../results/figure5/cdlp/giraph_cdlp_norm.csv ]
  then
    # CDLP
    ./figure10d.py \
      -i ../results/figure5/cdlp/giraph_cdlp_norm.csv \
      -n 3 \
      -c 1 \
      -o ./produce/figure5/giraph_cdlp.eps \
      -l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

    epstopdf ./produce/figure5/giraph_cdlp.eps
  fi
  
  if [ -f ../results/figure5/wcc/giraph_wcc_norm.csv ]
  then
    # WCC
    ./figure10d.py \
      -i ../results/figure5/wcc/giraph_wcc_norm.csv \
      -n 3 \
      -c 1 \
      -o ./produce/figure5/giraph_wcc.eps \
      -l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

    epstopdf ./produce/figure5/giraph_wcc.eps
  fi
  
  if [ -f ../results/figure5/bfs/giraph_bfs_norm.csv ]
  then
    # BFS
    ./figure10d.py \
      -i ../results/figure5/bfs/giraph_bfs_norm.csv \
      -n 3 \
      -c 1 \
      -o ./produce/figure5/giraph_bfs.eps \
      -l "57" -l "65" -l "Giraph-OOC" -l "57" -l "TH" -l "65"

    epstopdf ./produce/figure5/giraph_bfs.eps
  fi
  
  if [ -f ../results/figure5/sssp/giraph_sssp_norm.csv ]
  then
    # SSSP
    ./figure10d.py \
      -i ../results/figure5/sssp/giraph_sssp_norm.csv \
      -n 3 \
      -c 1 \
      -o ./produce/figure5/giraph_sssp.eps \
      -l "78" -l "90" -l "Giraph-OOC" -l "78" -l "TH" -l "90"

    epstopdf ./produce/figure5/giraph_sssp.eps
  fi
}

function figure3() {
  ./jvm17.py \
		-i ./../out/java17norm2.csv \
		-n 10 \
		-c 3 \
		-o ../../fig/jvm17.eps
	
	epstopdf ../../fig/jvm17.eps
	pdfcrop ../../fig/jvm17.pdf

  rm ../../fig/jvm17.eps ../../fig/jvm17.pdf
}

figure5_spark
figure5_giraph

