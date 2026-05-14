#!/bin/bash
#SBATCH --job-name=createfolder
#SBATCH --time=0:10:0
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=normal-x86
#SBATCH --account=f202414300cpcaa3x
  
# Vitor Sousa, 13/02/2022
# Script to create folders to run slim and perform simulations with several combinations of parameters

################################################
# SETTINGS
################################################
templatefile="template_ancestral.s" # name of file with template of model
folder="Ancestral" # name of the folder where all results are saved
tag="anc" # tag added to beggining of each file

# All the parameter values defined here (these are vectors, and we will test combinations of these values)
mutrate=2.5e-7 # mutation rate per site per generation
popsize=1000; # Ne population size of ancestral pop 
# NOTE: all these end with "v" because they are vectors of values
recratev=( 2.5e-8 2.5e-7 2.5e-6) # recombination rate
chrmv=( A ) # chromosome (A-autosome, X-x chromosome)
sexratiov=( 0.5 ) # sex-ratio
selmutdelv=( 0.000 0.00001 0.00005 0.0001 0.0005 0.001 0.005 0.01 0.05 0.1 0.5 1 ) # selective coefficient of deleterious mutations
dominancedelv=( 0.01 0.5) # dominance of deleterious mutations
timeendv=( 10000 ) # number of generations to reach equilibrium in ancestral population (10x larger than Ne)

###############################################
# MAIN - Do not change script below this line
###############################################
# current folder
currentfolder="${PWD}";
echo ${currentfolder};

# check that folder exists and create folder in current directory
if [ -d ${folder} ]; then
	echo "Folder ${folder} already exists.";
else 
	mkdir ${folder};
fi

# Go to the folders and copy the template file
cd "${folder}"
cp "${currentfolder}"/"${templatefile}" .

# Loop through all combination of parameters
for recrate in ${recratev[@]} # recombination rate
do
	for selmutdel in ${selmutdelv[@]} # selective coefficient of deleterious mutations
	do
		for dominancedel in ${dominancedelv[@]} # dominance of deleterious mutations
		do
			for chrm in ${chrmv[@]} # chromosome (A-autosome, X-x chromosome)
			do
				for sexratio in ${sexratiov[@]} # sex-ratio
				do
					for timeend in ${timeendv[@]} # time of end of simulations (split time)
					do						
						# name of output file defined with info about the relevant parameters
						outfile="${tag}_${chrm}_hd${dominancedel}_sr${sexratio}_sd${selmutdel}_r${recrate}_${timeend}"
						echo "Running ${outfile}"

						# check that templatefile exists
						if [ -e $templatefile ]; then
						# check if this is the first run or other files are present
							if [ `ls -1 ${outfile}* 2>/dev/null | wc -l ` -eq 0 ]; then
							    echo "First run. Not deleting pre-existing files!"
							else
							    echo "Deleting existing files..."
							    rm $outfile*;							  
							fi

							# Replace parameter values in template file
							sed "s/TAGFILE/\"${outfile}\"/g" $templatefile > $outfile.s;
							sed -i "s/DOMINANCEDEL/${dominancedel}/g" $outfile.s;
							sed -i "s/SELMUTDEL/${selmutdel}/g" $outfile.s;
							sed -i "s/CHR/\"${chrm}\"/g" $outfile.s;
							sed -i "s/SEXRATIO/${sexratio}/g" $outfile.s;
							sed -i "s/MUTRATE/${mutrate}/g" $outfile.s;
							sed -i "s/RECRATE/${recrate}/g" $outfile.s;
							sed -i "s/POPSIZEANC/${popsize}/g" $outfile.s;
							sed -i "s/ENDGEN/${timeend}/g" $outfile.s;
						fi
					done
				done
			done
		done
	done
done
