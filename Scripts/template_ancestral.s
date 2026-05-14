// set up a simple neutral simulation
initialize()
{
	// convert variables
	murate = MUTRATE;
	sr = SEXRATIO;
	XorA = CHR;
	popsize = POPSIZEANC;
	recrate = RECRATE;


	defineConstant("Npop", popsize);
	defineConstant("Chr", CHR);
	cat(format("Npop=%i\t", Npop));
	cat("Chr=" + Chr);
	
	// Initalize tree-seq model
	initializeTreeSeq();

	// MUTATION RATE
	// set the overall mutation rate
	initializeMutationRate(murate);
	
	// MUTATION TYPES ******* WE DO NOT WANT TO SIMULATE/RECORD NEUTRAL MUTATIONS *******
	// m1 mutation type: neutral
	initializeMutationType("m1", 0.5, "f", 0.0);
        m1.convertToSubstitution = F;
	// we do not want mutations of different groups to stack
	m1.mutationStackGroup = -1;
        m1.mutationStackPolicy = "l";

	// m2 mutation type: deleterious (recessive)
	initializeMutationType("m2", DOMINANCEDEL, "f", -SELMUTDEL);
        m2.convertToSubstitution = F;
        m2.mutationStackGroup = -1;
        m2.mutationStackPolicy = "l";

	// GENOMIC ELEMENTS
	// g1 genomic element type: uses m1 for all mutations (neutral)	
	initializeGenomicElementType("g1", m1, 1.0);
	// g2 genomic element type: uses m2 for all mutations (deleterious)
	initializeGenomicElementType("g2", m2, 1.0);

	// GENOMIC STRUCTURE	
	// chromosome of length 100 kb, where first and last 10Kb are deleterous, all other are neutral
	initializeGenomicElement(g2, 0, 9999);
	initializeGenomicElement(g1, 10000, 89999);
	initializeGenomicElement(g2, 90000, 99999);

	// RECOMBINATION RATE    	
	// uniform recombination along the chromosome
	// Because we only simulate under sel mutation, we need to define here the length of the chromosome
	initializeRecombinationRate(recrate,100000);

	// AUTOSOME OR X-CHR
        // specify that we are looking at Autosomes or X chromosome
        initializeSex(XorA);
}

// create a population of Npop individuals
1 early()
{
        // create a sub-population with sex ratio SEXRATIO (NOTE: this is defined in terms of males)
	sim.addSubpop("p1", Npop, SEXRATIO); // tag, Ne, sex-ratio
}

// run to generation ENDGEN and save the output file
ENDGEN late()
{
	filename = TAGFILE;
	// save the final state of the simulation
	sim.outputFull(filename + "_" + rep + "_ancestralPop.slim");
	// save the final tree of the simulation
	sim.treeSeqOutput(filename + "_" + rep + "_ancestralTreeSeq.trees");
}
