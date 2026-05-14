#!/bin/bash

# computing genotype-based stats from ms output
./R_mig.sh
./R_no_mig.sh


# Pooling stats from gene tree - based statistics
DIR=divdel_no_mig

cd $DIR

../pooling_divdel.sh

cd ..

DIR=divdel_mig

cd $DIR

../pooling_divdel.sh

cd ..

