#!/bin/bash
#SBATCH --job-name=createfolder
#SBATCH --time=0:10:0
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=normal-x86
#SBATCH --account=F202500293CPCAA2X 

# Vitor Sousa, 13/02/2022
# Script to create files to run slim and perform simulations with several combinations of parameters
# from the state file of an ancestral population at equilibrium.
# example of usage:
#       sbatch createFilesDivFromAnc.sh

################################################
# SETTINGS
################################################
ancfolder="Ancestral" # folder with the œsims for the ancestral population
eqtimeanc=10000 # time to equilibrium used to create ancestral population (usually 10x effective size)
folder="divdel_mig" # name of the folder where all results are saved
templatefile="template_divdel_v5.s" # name of file with template of model
tag="divdel" # tag added to beggining of each file

# All the parameter values defined here (these are vectors, and we will test combinations of these values)
mutrate=2.5e-7 # mutation rate per site per generation
popsize=1000; # population size of descending populations
# NOTE: all these end with "v" because they are vectors of values
recratev=( 2.5e-8 2.5e-7 2.5e-6) # recombination rate
chrmv=( A ) # chromosome (A-autosome, X-x chromosome)
sexratiov=( 0.5 ) # sex-ratio
migratev=( 0.00125 ) # migration rates in units of probability of migration per generation
selmutdelv=( 0.000 0.00001 0.00005 0.0001 0.0005 0.001 0.005 0.01 0.05 0.1 0.5 1 ) # selective coefficient of deleterious mutations
dominancedelv=( 0.01 0.5 ) # dominance of deleterious mutations
timeendv=( 12000 ) # number of generations of divergence of the two populations after spliting from ancestral
###############################################
#ncores=4 # number of cores used in server 

###########################################################################
# MAIN - Do not change script below this line
##########################################################################

# current folder
currentfolder="${PWD}";
echo "${currentfolder}";

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
	for chrm in ${chrmv[@]} # chromosome (A-autosome, X-x chromosome)
	do
		for migrate in ${migratev[@]} # migration rate
		do 
			for selmutdel in ${selmutdelv[@]} # selective of deleterious muts
			do
				for sexratio in ${sexratiov[@]} # sex-ratio
				do				
					for dominancedel in ${dominancedelv[@]} # dominance of deleterious mutations
					do 
						for timeend in ${timeendv[@]} # time of end of simulations (split time)
						do						
							# Output file name tag with relevant info about parameter combinations
							outfile="${tag}_${chrm}_h${dominancedel}_m${migrate}_sr${sexratio}_s${selmutdel}_r${recrate}_${timeend}"
							echo "creating ${outfile}"							

							# Check that template file exists
							if [ -e $templatefile ]; then
								# check if this is the first run or other files are present
								if [ `ls -1 ${outfile}* 2>/dev/null | wc -l ` -eq 0 ]; then
								    echo "First run. Not deleting pre-existing files!"
								else
								    echo "Deleting existing files..."
								    rm $outfile*;
								    rm ms_$outfile*;
								fi

								# tag of file with ancestral data
								ancestral="anc_${chrm}_hd${dominancedel}_sr${sexratio}_sd${selmutdel}_r${recrate}_${eqtimeanc}";

								# Replace parameter values in template file
								# for linux
								sed "s/TAGFILEEND/\"${outfile}\"/g" $templatefile > $outfile.s;
								sed -i   "s/ANCESTRALFOLDER/${ancfolder}/g" $outfile.s;
								sed -i   "s/ANCFILE/${ancestral}/g" $outfile.s;
								sed -i   "s/CHR/\"${chrm}\"/g" $outfile.s;
								sed -i   "s/SEXRATIO/${sexratio}/g" $outfile.s;
								sed -i   "s/MIGRATE/${migrate}/g" $outfile.s;
								sed -i   "s/SELMUTDEL/${selmutdel}/g" $outfile.s;
								sed -i   "s/DOMINANCEDEL/${dominancedel}/g" $outfile.s;
								sed -i   "s/MUTRATE/${mutrate}/g" $outfile.s;
								sed -i   "s/RECRATE/${recrate}/g" $outfile.s;
								sed -i   "s/POPSIZEANC/${popsize}/g" $outfile.s;
								sed -i   "s/POPSIZEBOT/${popsize}/g" $outfile.s;
								sed -i   "s/POPSIZEDESC/${popsize}/g" $outfile.s;									
								sed -i   "s/ENDGEN/${timeend}/g" $outfile.s;
								sed -i   "s/ancestral_time_generation/${eqtimeanc}/g" $outfile.s;

							fi
						done
					done 
				done
			done
		done
	done
done
