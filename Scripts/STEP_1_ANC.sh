#!/bin/bash

### THIS IS THE FIRST STEP FOR ANCESTRAL

chmod 777 *.sh

./CreateFolderAncestral.sh ### THis creates one *.s silm file per set of parameter in a folder 

./sim_anc_loop_TreeSumstat_deuc.sh
