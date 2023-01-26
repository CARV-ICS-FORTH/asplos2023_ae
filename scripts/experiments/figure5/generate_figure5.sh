#!/usr/bin/env bash

###################################################
#
# file: funcs.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  24-01-2023 
# @email:    kolokasis@ics.forth.gr
#
# Generate all the plots for Figure5
#
###################################################

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
