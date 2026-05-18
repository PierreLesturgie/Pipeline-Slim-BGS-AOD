# Pipeline-SLiM-BGS-AOD

**SLiM simulation and analysis pipeline for studying linked selection in structured populations**

Pipeline SLiM to simulate deleterious mutations under an Isolation with Migration model and to compute summary statistics and gene tree based statistics. 

## Associated manuscript

**The Joint Impact of Deleterious Mutations, Dominance, and Gene Flow on Linked Neutral Variation in Structured Populations**

Pierre Lesturgie, Alexandre Blanckaert, and Vitor C. Sousa 

## Workflow

1. Simulate genomic data with SLiM.
2. Process tree-sequence outputs and compute ARG-based statistics.
3. Generate output in the ms format and compute genotype-based summary statistics.
5. Summarize results across parameter combinations.
All script must be in the same directory. 


**Software requirement:**
* SLiM version 5.0
* GTS tool (https://github.com/PierreLesturgie/GTS)

### STEP 1
**Run ancestral population simulations**

Usage: ```sbatch STEP_1.sh```

* The first script run within ```STEP_1.sh``` is ```CreateFolderAncestral_trees.sh``` creates an Ancestral folder and generate one .s file per set of parameters.
* The second script is ```sim_anc_loop_TreeSumstat.sh``` which runs the simulations. 

### STEP 2
**Run the two-populations phase simulations**

Usage: ```sbatch STEP_2.sh```

* The first script within ```STEP_2.sh``` is ```createFilesDivFromAnc_trees.sh``` which creates a Divdel folder and generate one .s file per set of parameters from the Ancestral simulations files. 
* The second one is ```sim_divdel_loop_TreeSumstat.sh``` which runs the simulations obtaining one tree per set of parameters and per simulation, and computes gene-tree based statistics. 

### STEP 3
**Post analysis**

Usage: ```sbatch STEP_3.sh```

* Merge ms output files using ```merge_all_file_v2.sh``` and computes genotype-based statistics: ```R_mig.sh``` and ```R_no_mig.sh``` scripts. 
* Sort output files and extract the summary statistics for each set of parameters (pooling of all runs): ```pooling_divdel.sh``` script 
