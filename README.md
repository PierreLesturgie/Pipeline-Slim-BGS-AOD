# Pipeline-Slim-BGS-AOD

### Pipeline SLiM to simulate deleterious mutations under an Isolation with Migration model and to compute summary statistics and gene tree based statistics. 

For manuscript: 

### The Joint Impact of Deleterious Mutations, Dominance, and Gene Flow on Linked Neutral Variation in Structured Populations

### By Pierre Lesturgie, Alexandre Blanckaert and Vitor C. Sousa


**Software requirement:**
* SLiM version 5.0
* GTS tool (https://github.com/PierreLesturgie/GTS)

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
