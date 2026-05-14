#!/bin/bash

# Vitor Sousa, 13/02/2022
# Script to run slim and perform simulations of all slim input files files in folder (starting with anc_*.s)
# Simulates the evolution of an ancestral population, subjected to deleterious mutations.
# Outputs a file with the state of the population at the end of the simulation.
# This output file can be used to start other scenarios from a population at equilibrium.

# Modificaton by Pierre Lesturgie, 27/05/25 to adapt to DEUCALION
# Strucure: 
# 1. this script first creates a directory for each set of parameters ($prefix)
# 2. In each directory, it writes 2 scripts: $prefix/${file}_for_loop.sh  and  $prefix/${file}.sh
# $prefix/${file}_for_loop.sh --> this is a simple bash file where I run slim and estimate stats for a single simulation.
# $prefix/${file}.sh --> This script "loops" the script $prefix/${file}_for_loop.sh over all 128 cpus of each of the 8 nodes (array mode)
# 3. This scripts launches $prefix/${file}.sh
### In the end, each output file will have a number corresponding to the number of the cpu used concatenated to the number of the node. 
### For example: the simulation run on the 17th CPU of the 3rd node will have the tag 173.


# SETTINGS
################################################
folder="divdel_no_mig" # name of the folder where all results are saved
tag="divdel" # tag added to beggining of each file

###############################################
# MAIN - Do not change script below this line
###############################################
# current folder
currentfolder="${PWD}";
echo ${currentfolder};

# Go to the folders and copy the template file
cd "${folder}"

# Get the list of slim input files in folder 
# i.e. files that have tag and end in .s
FILES=`ls ${tag}*.s`

# create one script per file and per run to run SLIM and launch it on the cluster
for file in ${FILES}; 
do
	filename=$(basename "$file") # this one is useful in case there is a path
    prefix="${filename%.*}" # get the prefix, i.e., without ".s"
    reco="${prefix%_*}" # to extract directly the recombination rate
    reco="${reco##*_}" # to extract directly the recombination rate
    reco="${reco:1}" # to extract directly the recombination rate
    
    mkdir $prefix

    cp $file $prefix/

		echo "creating bash script for ${file}"

cat > $prefix/${file}_for_loop.sh << EOF
#!/bin/bash

TASK_ID=\$SLURM_ARRAY_TASK_ID
tpernode=128
task=\$1

slim -l 0 -s 9\${TASK_ID}42\${task}2 -d rep=\${task}\${TASK_ID} ${file} 

#here for G20000
#gts stats -t ${prefix}_\${task}\${TASK_ID}_G20000 -Nanc 1000 -r 10 -R ${reco} -D ../../scenario_island.txt -G ../../genome.txt
#gts summary --tag ${prefix}_\${task}\${TASK_ID}_G20000 -r 10 -G ../../genome.txt 

#here for G11000
#gts stats -t ${prefix}_\${task}\${TASK_ID}_G11000 -Nanc 1000 -r 10 -R ${reco} -D ../../scenario_island.txt -G ../../genome.txt
#gts summary --tag ${prefix}_\${task}\${TASK_ID}_G11000 -r 10 -G ../../genome.txt 

#here for G12000
#gts stats -t ${prefix}_\${task}\${TASK_ID}_G12000 -Nanc 1000 -r 10 -R ${reco} -D ../../scenario_island.txt -G ../../genome.txt
#gts summary --tag ${prefix}_\${task}\${TASK_ID}_G12000 -r 10 -G ../../genome.txt 

#here for G10100
#gts stats -t ${prefix}_\${task}\${TASK_ID}_G10100 -Nanc 1000 -r 10 -R ${reco} -D ../../scenario_island.txt -G ../../genome.txt
#gts summary --tag ${prefix}_\${task}\${TASK_ID}_G10100 -r 10 -G ../../genome.txt



EOF


cat > $prefix/${file}.sh << EOF
#!/bin/bash
#SBATCH --job-name=simdivdel_${prefix}_run
#SBATCH --array=1-8%1  # Run jobs with index 1 to 8, with a maximum of 4 concurrent jobs
#SBATCH --output=output_%a.out
#SBATCH --error=error_%a.err
#SBATCH --time=0-05:30:00  # Maximum runtime of 30 minutes per task
#SBATCH -p normal-x86        #x86 partition
#SBATCH -A F202500293CPCAA2X #x86 account
#SBATCH --nodes=1
#SBATCH --tasks=128
#SBATCH --cpus-per-task=1

# This script works for a single set of parameters. 
# Need to create a "higher" level script to launch this one
# for all the different combinations of parameters. 
# In this case, still use the "Crea[...].sh" to create all *.s files
# This script replaces the "{set_parameters}.s.sh"
# So need a "sim[...].sh" script

# Access the array index using the SLURM_ARRAY_TASK_ID environment variable
TASK_ID=\$SLURM_ARRAY_TASK_ID

module load Miniconda3/23.5.2-0
source ~/.bashrc 
conda activate /projects/F202500293CPCAA2/ablanckaert/slim  ### This is an environment with slim v5 and GTS

tpernode=128

for task in \$(seq 1 \$tpernode)
do
	. ${file}_for_loop.sh \${task} &
done
wait

EOF
cd $prefix
    sbatch ${file}.sh
    cd ..
done
