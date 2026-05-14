#!/bin/bash

DIR=divdel_no_mig

cd $DIR

../pooling_divdel.sh

cd ..

DIR=divdel_mig

cd $DIR

../pooling_divdel.sh

cd ..

