#!/bin/bash

### THIS IS THE FIRST STEP FOR ANCESTRAL

chmod 777 *.sh

### Here, I separated the two migration rates. This is because it was easier to get the exact number of the ancestral simulation, 
# as it depends on the number of the cpu and the number of the node. 
./createFilesDivFromAnc_trees_no_mig.sh
./createFilesDivFromAnc_trees_mig.sh

./sim_divdel_loop_TreeSumstat_no_mig.sh
./sim_divdel_loop_TreeSumstat_mig.sh
