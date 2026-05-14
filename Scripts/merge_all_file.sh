#!/bin/bash

cd divdel_mig
tag="divdel"
# Get the list of slim input files in folder 
# i.e. files that have tag and end in .s
FILES=`ls ${tag}*.s`

# create one script per file and per run to run SLIM and launch it on the cluster
for file in ${FILES}; 
do
	filename=$(basename "$file") # this one is useful in case there is a path
    prefix="${filename%.*}" # get the prefix, i.e., without ".s"
    #reco="${prefix%_*}" # to extract directly the recombination rate
    #reco="${reco##*_}" # to extract directly the recombination rate
    #reco="${reco:1}" # to extract directly the recombination rate
    
    #mkdir $prefix
	
    outputfile=Rstate_${prefix}_\${task}\${TASK_ID}.txt

	cd $prefix
		cat Rstate* >> ./../Rstate_mig_all_vCorrect.txt
    cd ..
done
echo "mig done"

cd ../divdel_no_mig

# Get the list of slim input files in folder 
# i.e. files that have tag and end in .s
FILES=`ls ${tag}*.s`

# create one script per file and per run to run SLIM and launch it on the cluster
for file in ${FILES}; 
do
	filename=$(basename "$file") # this one is useful in case there is a path
    prefix="${filename%.*}" # get the prefix, i.e., without ".s"
    #reco="${prefix%_*}" # to extract directly the recombination rate
    #reco="${reco##*_}" # to extract directly the recombination rate
    #reco="${reco:1}" # to extract directly the recombination rate
    
    #mkdir $prefix
	
    outputfile=Rstate_${prefix}_\${task}\${TASK_ID}.txt

	cd $prefix
		cat Rstate* >> ./../Rstate_nomig_all_vCorrect.txt
    cd ..
done
