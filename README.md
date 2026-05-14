# Pipeline-Slim-BGS-AOD

### Pipeline SLiM to simulate deleterious mutations under an Isolation with Migration model and to compute summary statistics and gene tree based statistics. 

For manuscript: 

### The Joint Impact of Deleterious Mutations, Dominance, and Gene Flow on Linked Neutral Variation in Structured Populations

### By Pierre Lesturgie, Alexandre Blanckaert and Vitor C. Sousa


**Software requirement:**
* Slim4
* GTS 
  
***All loaded from conda environment***

### STEP 0 (Preliminary requirements)
* Create environment conda (Python >= 3.12)
* Install required software (slim-4.2.2 and GTS-0.1.1, see https://github.com/PierreLesturgie/GTS). 
* Set up parameters of simulations in *CreateFolderAncestral_trees.sh* and *createFilesDivFromAnc_trees.sh*
* Set up settings and location of python script in *sim_divdel_loop_TreeSumstat.sh* and *sim_anc_loop_TreeSumstat.sh* including required arguments for gts (number of runs, Nanc, etc.)
* Set up Slim4 templates *template_ancestral.s* and *template_divdel.s*
* Set up *scenario.txt* and *genome.txt* accordingly to the templates (warning: scenario is different between ancestral and divdel).

#### Setting up command lines of ```gts ``` [two subprograms: stats and summary]

**stat** usage: ```gts stats -t <treefile> -Nanc <ancestral_effective_size> -r <number_of_sampling_runs> -R <number_of_runs> -D <demographic_scenario> -G <genomic_structure> ```

**summary** usage: ```gts summary --tag <treefile> -r <number_of_sampling_runs> -G <genomic_structure> ```

Detailed options: see https://github.com/PierreLesturgie/GTS

### STEP 1
**Runs CreateFolderAncestral_trees.sh and then sim_anc_loop_TreeSumstat.sh**

Usage: ```sbatch step_1.sh```

* The first one creates an Ancestral folder and generate one .s file per set of parameters.
* The second one runs the simulations obtaining one tree per set of parameters and per simulation, and computes statistics. 

### STEP 2
**Post analysis ancestral**

Usage: ```sbatch step_2.sh```

* Sort output files and extract the summary statistics for each set of parameters (pooling of all runs) 

### STEP 3
**Runs createFilesDivFromAnc_trees.sh and then sim_divdel_loop_TreeSumstat.sh**

Usage: ```sbatch step_3.sh```

* The first one creates a Divdel folder and generate one .s file per set of parameters from the Ancestral simulations. 
* The second one runs the simulations obtaining one tree per set of parameters and per simulation, and computes statistics. 

### STEP 4
**Post analysis divdel**

Usage: ```sbatch step_4.sh```

* Sort output files and extract the summary statistics for each set of parameters (pooling of all runs) 
