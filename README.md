# Pipeline-SLiM-BGS-AOD

**SLiM simulation and analysis pipeline for studying linked selection in structured populations**

This repository contains a pipeline to simulate deleterious mutations under an Isolation-with-Migration model and to compute summary statistics and gene-tree-based statistics.

## Associated manuscript

**The Joint Impact of Deleterious Mutations, Dominance, and Gene Flow on Linked Neutral Variation in Structured Populations**

Pierre Lesturgie, Alexandre Blanckaert, and Vitor C. Sousa

## Overview

The pipeline is designed to investigate how deleterious mutations affect linked neutral variation in structured populations

## Workflow

1. Simulate genomic data with SLiM.
2. Process tree-sequence outputs.
3. Compute genetic summary statistics.
4. Compute gene-tree-based statistics.
5. Summarize results across parameter combinations.


**Software requirement:**
* SLiM version 5.0
* GTS tool (https://github.com/PierreLesturgie/GTS)

### STEP 1
**Runs CreateFolderAncestral_trees.sh and then sim_anc_loop_TreeSumstat.sh**

Usage: ```sbatch STEP_1.sh```

* The first one creates an Ancestral folder and generate one .s file per set of parameters.
* The second one runs the simulations obtaining one tree per set of parameters and per simulation, and computes statistics. 

### STEP 2
**Runs createFilesDivFromAnc_trees.sh and then sim_divdel_loop_TreeSumstat.sh**

Usage: ```sbatch STEP_2.sh```

* The first one creates a Divdel folder and generate one .s file per set of parameters from the Ancestral simulations. 
* The second one runs the simulations obtaining one tree per set of parameters and per simulation, and computes gene-tree based statistics. 

### STEP 3
**Post analysis**

Usage: ```sbatch STEP_3.sh```

* Computes genotype-based statistics from ms output
* Sort output files and extract the summary statistics for each set of parameters (pooling of all runs) 
