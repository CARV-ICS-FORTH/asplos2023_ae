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

function figure1 {
  # PR
	./figure10.py \
		-i ../../results/reference/figure5/spark_pr.csv \
		-n 6 \
		-c 1 \
		-o ./spark_pr.eps \
		-l "32" -l "48" -l "80" -l "144" -l "Spark-SD" -l "32" -l "TH" -l "80"

	epstopdf ./spark_pr.eps
	
  # CC
	./figure10.py \
		-i ../../results/reference/figure5/spark_cr.csv \
		-n 6 \
		-c 1 \
		-o ./spark_cc.eps \
		-l "33" -l "50" -l "84" -l "152" -l "Spark-SD" -l "33" -l "TH" -l "84"

	epstopdf ./spark_cc.eps
	
	# -l 21 -l 42 -l 84 -l "TC-21"
	# SSSP
	./figure10a.py \
		-i ../../results/reference/figure5/spark_sp.csv \
		-n 6 \
		-c 1 \
		-o ./spark_sp.eps \
		-l "27" -l "37" -l "58" -l "100" -l "Spark-SD" -l "37" -l "TH" -l "58"

	epstopdf ./spark_sp.eps
	
	# -l 12 -l 24 -l 48 -l "TC-12"
	# SVD
	./figure10a.py \
		-i ../../results/reference/figure5/spark_svd.csv \
		-n 6 \
		-c 1 \
		-o ./spark_svd.eps \
		-l "22" -l "28" -l "40" -l "64" -l "Spark-SD" -l "28" -l "TH" -l "40"

	epstopdf ./spark_svd.eps
	
	# -l 44 -l 54 -l 64 -l "TC-44"
	# TR
	./figure10b.py \
		-i ../../results/reference/figure5/spark_tr.csv \
		-n 5 \
		-c 1 \
		-o ./spark_tr.eps \
		-l "59" -l "70" -l "80" -l "Spark-SD" -l "59" -l "TH" -l "80" \
		-t ./fig23_legend.eps

	epstopdf ./fig23_legend.eps
	epstopdf ./spark_tr.eps
	
	# LR
	./figure10a.py \
		-i ../../results/reference/figure5/spark_lr.csv \
		-n 6 \
		-c 1 \
		-o ./spark_lr.eps \
		-l "29" -l "43" -l "70" -l "124" -l "Spark-SD" -l "43" -l "TH" -l "70"

	epstopdf ./spark_lr.eps

	# LgR
	./figure10a.py \
		-i ../../results/reference/figure5/spark_lgr.csv \
		-n 6 \
		-c 1 \
		-o ./spark_lgr.eps \
		-l "29" -l "43" -l "70" -l "124" -l "Spark-SD" -l "43" -l "TH" -l "70"

	epstopdf ./spark_lgr.eps
	
	# SVM
	./figure10f.py \
    -i ../../results/reference/figure5/spark_svm.csv \
		-n 6 \
		-c 1 \
		-o ./spark_svm.eps \
		-l "28" -l "32" -l "36" -l "48" -l "Spark-SD" -l "36" -l "TH" -l "48"

	epstopdf ./spark_svm.eps
	
	# -l 12 -l 24 -l 48 -l "TC-12"
	# BC
  ./figure10e.py \
    -i ../../results/reference/figure5/spark_bc.csv \
    -n 6 \
    -c 1 \
    -o ./spark_bc.eps \
    -l "53" -l "57" -l "98" -l "180" -l "Spark-SD" -l "57" -l "TH" -l "98"

  epstopdf ./spark_bc.eps
	
	# -l 44 -l 54 -l 64 -l "TC-44"
	# SQL
	./figure10c.py \
    -i ../../results/reference/figure5/spark_sql.csv \
		-n 5 \
		-c 1 \
		-o ./spark_sql.eps \
		-l "24" -l "37" -l "63" -l "Spark-SD" -l "37" -l "TH" -l "63"

	epstopdf ./spark_sql.eps
}

# Giraph with same or less DRAM
function figure2 {
	# PR
	./figure10d.py \
    -i ../../results/reference/figure5/giraph_pr.csv \
		-n 3 \
		-c 1 \
		-o giraph_pr.eps \
		-l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

	epstopdf giraph_pr.eps
	
  # CDLP
	./figure10d.py \
    -i ../../results/reference/figure5/giraph_cdlp.csv \
		-n 3 \
		-c 1 \
		-o ./giraph_cdlp.eps \
		-l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

	epstopdf ./giraph_cdlp.eps
  
  # WCC
	./figure10d.py \
    -i ../../results/reference/figure5/giraph_wcc.csv \
		-n 3 \
		-c 1 \
		-o ./giraph_wcc.eps \
		-l "74" -l "85" -l "Giraph-OOC" -l "74" -l "TH" -l "85"

	epstopdf ./giraph_wcc.eps
  
  # BFS
	./figure10d.py \
    -i ../../results/reference/figure5/giraph_bfs.csv \
		-n 3 \
		-c 1 \
		-o ./giraph_bfs.eps \
		-l "57" -l "65" -l "Giraph-OOC" -l "57" -l "TH" -l "65"

	epstopdf ./giraph_bfs.eps
  
  # SSSP
	./figure10d.py \
    -i ../../results/reference/figure5/giraph_sssp.csv \
		-n 3 \
		-c 1 \
		-o ./giraph_sssp.eps \
		-l "78" -l "90" -l "Giraph-OOC" -l "78" -l "TH" -l "90"

	epstopdf ./giraph_sssp.eps
}

function figure3() {
  ./jvm17.py \
		-i ./../../results/reference/figure7/java17norm2.csv \
		-n 10 \
		-c 3 \
		-o ./../../plots/reference/jvm17.eps
	
	epstopdf ../../fig/jvm17.eps
}
