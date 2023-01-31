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
		-i ./../out/java17norm2.csv \
		-n 10 \
		-c 3 \
		-o ../../fig/jvm17.eps
	
	epstopdf ../../fig/jvm17.eps
	pdfcrop ../../fig/jvm17.pdf

  rm ../../fig/jvm17.eps ../../fig/jvm17.pdf
}

function figure4() {
  ./figure20.py \
		-i ../out/figure47norm.csv \
		-n 5 \
		-c 2 \
    -f ../../fig/fig47legend.eps \
		-o ../../fig/fig47.eps
	
	epstopdf ../../fig/fig47.eps
	pdfcrop ../../fig/fig47.pdf
	
  epstopdf ../../fig/fig47legend.eps
	pdfcrop ../../fig/fig47legend.pdf
	
	rm ../../fig/fig47.eps ../../fig/fig47.pdf
	rm ../../fig/fig47legend.eps ../../fig/fig47legend.pdf

  ./figure21.py \
		-i ../out/figure48norm.csv \
		-n 2 \
		-c 2 \
		-o ../../fig/fig48.eps
	
  epstopdf ../../fig/fig48.eps
	pdfcrop ../../fig/fig48.pdf
	
  rm ../../fig/fig48.eps ../../fig/fig48.pdf
}

function figure5() {
  workloads=( "pr" "cdlp" "wcc" "bfs" "sssp" )
  region_size=( 16 256 )
  for w in "${workloads[@]}"
  do
    for r in "${region_size[@]}"
    do
      ./parser.sh \
        ../out/parsed_files/"$w"_"$r"_parsed.txt \
        ./"$w"_"$r"_live.txt \
        ./"$w"_"$r"_use.txt \
        ../out/cdf_files/"$w"_"$r"_cdf_live.csv \
        ../out/cdf_files/"$w"_"$r"_cdf_use.csv
      done
    done

  ./allocator_hist.py \
    -i ../out/cdf_files/pr_16_cdf_live.csv -i ../out/cdf_files/cdlp_16_cdf_live.csv \
    -i ../out/cdf_files/wcc_16_cdf_live.csv -i ../out/cdf_files/bfs_16_cdf_live.csv \
    -i ../out/cdf_files/sssp_16_cdf_live.csv \
    -o ../../fig/allocator_live_cdf_16.eps \
    -l  "PR" -l "CDLP" -l "WCC" -l "BFS" -l "SSSP" \
    -y "Live Objects Per Region (%)"

  epstopdf ../../fig/allocator_live_cdf_16.eps
  pdfcrop ../../fig/allocator_live_cdf_16.pdf

  rm ../../fig/allocator_live_cdf_16.eps ../../fig/allocator_live_cdf_16.pdf
  
  ./allocator_hist.py \
    -i ../out/cdf_files/pr_256_cdf_live.csv -i ../out/cdf_files/cdlp_256_cdf_live.csv \
    -i ../out/cdf_files/wcc_256_cdf_live.csv -i ../out/cdf_files/bfs_256_cdf_live.csv \
    -i ../out/cdf_files/sssp_256_cdf_live.csv \
    -o ../../fig/allocator_live_cdf_256.eps \
    -l  "PR" -l "CDLP" -l "WCC" -l "BFS" -l "SSSP" \
    -y "Live Objects Per Region (%)"

  epstopdf ../../fig/allocator_live_cdf_256.eps
  pdfcrop ../../fig/allocator_live_cdf_256.pdf

  rm ../../fig/allocator_live_cdf_256.eps ../../fig/allocator_live_cdf_256.pdf
  
  ./allocator_hist.py \
    -i ../out/cdf_files/pr_16_cdf_use.csv -i ../out/cdf_files/cdlp_16_cdf_use.csv \
    -i ../out/cdf_files/wcc_16_cdf_use.csv -i ../out/cdf_files/bfs_16_cdf_use.csv \
    -i ../out/cdf_files/sssp_16_cdf_use.csv \
    -o ../../fig/allocator_use_cdf_16.eps \
    -l  "PR" -l "CDLP" -l "WCC" -l "BFS" -l "SSSP" \
    -y "Live Objects Space Usage (%)"

  epstopdf ../../fig/allocator_use_cdf_16.eps
  pdfcrop ../../fig/allocator_use_cdf_16.pdf

  rm ../../fig/allocator_use_cdf_16.eps ../../fig/allocator_use_cdf_16.pdf
  
  ./allocator_hist.py \
    -i ../out/cdf_files/pr_256_cdf_use.csv -i ../out/cdf_files/cdlp_256_cdf_use.csv \
    -i ../out/cdf_files/wcc_256_cdf_use.csv -i ../out/cdf_files/bfs_256_cdf_use.csv \
    -i ../out/cdf_files/sssp_256_cdf_use.csv \
    -o ../../fig/allocator_use_cdf_256.eps \
    -l  "PR" -l "CDLP" -l "WCC" -l "BFS" -l "SSSP" \
    -y "Live Objects Space Usage (%)" \
    -e "enable" \
    -f "../../fig/allocator_legend.eps"

  epstopdf ../../fig/allocator_use_cdf_256.eps
  pdfcrop  ../../fig/allocator_use_cdf_256.pdf
  
  epstopdf ../../fig/allocator_legend.eps
  pdfcrop  ../../fig/allocator_legend.pdf

  rm ../../fig/allocator_use_cdf_256.eps ../../fig/allocator_use_cdf_256.pdf
  rm ../../fig/allocator_legend.eps ../../fig/allocator_legend.pdf
}

# Plot: TeraCache Minor Collection  - different card tables size
function figure6 {
	./figure4.py \
		-i ../out/figure4_h2_minor.csv \
		-o ../../fig/fig4.eps

	epstopdf ../../fig/fig4.eps
	pdfcrop ../../fig/fig4.pdf

	# Delete temporary files
	rm ../../fig/fig4.eps ../../fig/fig4.pdf
}

# Plot: TeraCache Major Collection
function figure7 {
  ./figure5.py \
		-i ../out/figure5.csv \
		-n 5 \
		-c 2 \
		-s "enable" \
		-o ../../fig/fig5.eps
	
	epstopdf ../../fig/fig5.eps
	pdfcrop ../../fig/fig5.pdf
	
	rm ../../fig/fig5.eps ../../fig/fig5.pdf
}

# PMEM
function figure8 {
	./figure9.py \
		-i ../out/figure9norm.csv \
		-n 10 \
		-c 2 \
		-s "enable" \
		-o ../../fig/fig9.eps

	./figure9.py \
		-i ../out/figure9bnorm.csv \
		-n 10 \
		-c 2 \
		-l "enable" \
		-f ../../fig/fig9legend.eps \
		-o ../../fig/fig9b.eps

	epstopdf ../../fig/fig9.eps
	pdfcrop ../../fig/fig9.pdf
	
	epstopdf ../../fig/fig9b.eps
	pdfcrop ../../fig/fig9b.pdf
	
	epstopdf ../../fig/fig9legend.eps
	pdfcrop ../../fig/fig9legend.pdf
	
	rm ../../fig/fig9b.eps ../../fig/fig9b.pdf
	rm ../../fig/fig9.eps ../../fig/fig9.pdf
	rm ../../fig/fig9legend.eps ../../fig/fig9legend.pdf
}

function figure9 {
	./figure18.py \
		-i ../out/figure25norm.csv \
		-n 9 \
		-c 2 \
		-s "enable" \
		-o ../../fig/fig25.eps
	
	epstopdf ../../fig/fig25.eps
	pdfcrop ../../fig/fig25.pdf
	
	rm ../../fig/fig25.eps ../../fig/fig25.pdf
}
  
function figure10 {
  ./figure19c.py \
    -i ../out/figure46norm.csv \
    -n 6 \
    -c 2 \
    -o ../../fig/fig46.eps

  epstopdf ../../fig/fig46.eps
  pdfcrop ../../fig/fig46.pdf

  rm ../../fig/fig46.eps ../../fig/fig46.pdf

  ./figure19d.py \
    -i ../out/figure49norm.csv\
    -n 6 \
    -c 3 \
    -o ../../fig/fig49.eps

  epstopdf ../../fig/fig49.eps
  pdfcrop ../../fig/fig49.pdf

  rm ../../fig/fig49.eps ../../fig/fig49.pdf
}

function figure11 {
	./jstat.py \
		-i ../out/pr/pr_sd_jstat.txt \
		-s "enable" \
		-o ../../fig/pr_sd_jstat.eps
	
	./jstat.py \
		-i ../out/pr/pr_tc_jstat.txt \
		-s "disable" \
		-o ../../fig/pr_tc_jstat.eps

	epstopdf ../../fig/pr_sd_jstat.eps
	pdfcrop ../../fig/pr_sd_jstat.pdf
	
	epstopdf ../../fig/pr_tc_jstat.eps
	pdfcrop ../../fig/pr_tc_jstat.pdf

	# Delete temporary files
	rm ../../fig/pr_sd_jstat.eps ../../fig/pr_sd_jstat.pdf
	rm ../../fig/pr_tc_jstat.eps ../../fig/pr_tc_jstat.pdf
}

case $1 in
  "0")
    echo "Plot all graphs in the paper"
    figure1
    figure2
    figure3
    figure4
    figure5
    figure6
    figure7
    figure8
    figure9
    figure10
    ;;

  "1")
    echo "Plot: Spark DRAM Usage"
    figure1
    ;;

  "2")
    echo "Plot: Giraph DRAM Usage"
    figure2
    ;;
  
  "3")
    echo "Plot: JDK17 G1"
    figure3
    ;;

  "4")
    echo "Plot: Hint performance"
    figure4
    ;;

  "5")
    echo "Plot: Allocator statistics"
    figure5
    ;;

  "6")
    echo "Plot: GC statistics"
    figure6
    figure7
    ;;
  
  "7")
    echo "Plot: NVM results"
    figure8
    figure9
    ;;
  
  "8")
    echo "Plot: Scalability"
    figure10
    ;;
  
  "9")
    echo "Plot: Jstat"
    figure11
    ;;

  *)
    echo "./run_all.sh <#>"
    ;;
esac
