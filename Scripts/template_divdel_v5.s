// set up a simple neutral simulation
initialize()
{
	// define variables that can vary from sim to sim
	murate = MUTRATE;
	smutdel = SELMUTDEL;
	sr = SEXRATIO;
	XorA = CHR;
	popsize = POPSIZEANC;
	nbot = POPSIZEBOT;
	ndesc = POPSIZEDESC;
	migrate = MIGRATE;
	recrate = RECRATE;

	// define constant parameters
	defineConstant("Npop", popsize);
	defineConstant("Nbot", nbot);
	defineConstant("Ndesc", ndesc);
	defineConstant("MigRate", migrate);
		
	// print the constant parameters
	cat(format("Npop=%i\t", Npop));
	cat(format("Nbot=%i\t", Nbot));
	cat(format("Ndesc=%i\t", Ndesc));
	cat(format("MigRate=%6.5f\t", MigRate));
	
	// MUTATION RATE
	// set the overall mutation rate
	initializeMutationRate(murate);
	
	// Initalize tree-seq model
	initializeTreeSeq();	
	
	// MUTATION TYPES
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
        // specify that we are looking at X chromosome
        initializeSex(XorA);
}

// Read the state of the ancestral population at the time of split
1 late() {
	// Name of file with ancestral slim pop info
	ancfilename_tag = "ANCFILE";	
	ancfilename = "../../Ancestral/" + ancfilename_tag + "/" + ancfilename_tag +  "_" + rep + "_ancestralTreeSeq.trees";
	cat("FileName=" + ancfilename);
	// Read data from file
	sim.readFromPopulationFile(ancfilename);
	// start a newly seeded run by incrementing the previous seed
	setSeed(getSeed());
	sim.cycle=1;
	community.tick=ancestral_time_generation;
	cat("\nLoaded ancestral population file!\n");
}

// Simulate the fouding of population 2 with size Nbot (this could be used to mimic a founder event)
(ancestral_time_generation + 1) early () { 
    // population split with sex ratio SEXRATIO
    sim.addSubpopSplit("p2", Nbot, p1, SEXRATIO); 
    // Set new size for population p1
    p1.setSubpopulationSize(Nbot);

}

// After some time, populations can change effective size to Ndesc and experience migration
(ancestral_time_generation + 2):ENDGEN early (){ 
    // Set new size for population p1
    p1.setSubpopulationSize(Ndesc); 
    p2.setSubpopulationSize(Ndesc); 
    // set migration rate to MigRate
    p1.setMigrationRates(c(p2), c(MigRate));
    p2.setMigrationRates(c(p1), c(MigRate));
}

10100 late()
{
        // Output ms file with sample from populations
        filename = TAGFILEEND;
        //sim.outputFull(filename + "_" + rep + ".slim");
        // get a sample of genomes from p1 are not null (only X chromosome sampled)
        // save the final tree of the simulation
        sim.treeSeqOutput(filename + "_" + rep + "_G10100.trees");

}

// sample 20 genomes from each pop at SAVEGEN
10100 late()
{
	// Output ms file with sample from populations
	filenamems = TAGFILEEND;

	// get a sample of genomes from p1 and p2 that are not null (only X chromosome sampled)
	//gp1 = p1.genomes;
	//gp2 = p2.genomes;

	// get number of individuals and index of firt male index (genomes are sorted)
	// Note that the index can be used to distinguish males and females, but in this case
	// we sample genomes irrespective of males or females since we use index from 0 to ((p1.individualCount*2)-1)
	//gp1male = gp1[0:((p1.individualCount*2)-1)]; 
	// sample 20 genomes from pop1 (discarding the null genomes)
        //sg1 = sample(gp1male[!gp1male.isNullGenome], 20, F);        
        // repeat for pop2
	//gp2male = gp2[0:((p2.individualCount*2)-1)]; // sample all
        // sample 20 genomes from pop2
        //sg2 = sample(gp2male[!gp2male.isNullGenome], 20, F);
        // Print ms output with genomes from pop1 first followed by genomes of pop2
        //sg = c(sg1, sg2); 
        //sg.outputMS("ms_" + filenamems + "_" + rep + "_G10100.ms", append=F);
	p1.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G10100.ms",append=F);
	p2.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G10100.ms",append=T);

}

11000 late()
{
        // Output ms file with sample from populations
        filename = TAGFILEEND;
        //sim.outputFull(filename + "_" + rep + ".slim");
        // get a sample of genomes from p1 are not null (only X chromosome sampled)
        // save the final tree of the simulation
        sim.treeSeqOutput(filename + "_" + rep + "_G11000.trees");

}

// sample 20 genomes from each pop at SAVEGEN
11000 late()
{
	// Output ms file with sample from populations
	filenamems = TAGFILEEND;

	// get a sample of genomes from p1 and p2 that are not null (only X chromosome sampled)
	//gp1 = p1.genomes;
	//gp2 = p2.genomes;

	// get number of individuals and index of firt male index (genomes are sorted)
	// Note that the index can be used to distinguish males and females, but in this case
	// we sample genomes irrespective of males or females since we use index from 0 to ((p1.individualCount*2)-1)
	//gp1male = gp1[0:((p1.individualCount*2)-1)]; 
	// sample 20 genomes from pop1 (discarding the null genomes)
        //sg1 = sample(gp1male[!gp1male.isNullGenome], 20, F);        
        // repeat for pop2
	//gp2male = gp2[0:((p2.individualCount*2)-1)]; // sample all
        // sample 20 genomes from pop2
        //sg2 = sample(gp2male[!gp2male.isNullGenome], 20, F);
        // Print ms output with genomes from pop1 first followed by genomes of pop2
        //sg = c(sg1, sg2); 
        //sg.outputMS("ms_" + filenamems + "_" + rep + "_G11000.ms", append=F);
	p1.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G11000.ms",append=F);
	p2.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G11000.ms",append=T);

}

12000 late()
{
        // Output ms file with sample from populations
        filename = TAGFILEEND;
        //sim.outputFull(filename + "_" + rep + ".slim");
        // get a sample of genomes from p1 are not null (only X chromosome sampled)
        // save the final tree of the simulation
        sim.treeSeqOutput(filename + "_" + rep + "_G12000.trees");

}

// sample 20 genomes from each pop at SAVEGEN
12000 late()
{
	// Output ms file with sample from populations
	filenamems = TAGFILEEND;

	// get a sample of genomes from p1 and p2 that are not null (only X chromosome sampled)
	//gp1 = p1.genomes;
	//gp2 = p2.genomes;

	// get number of individuals and index of firt male index (genomes are sorted)
	// Note that the index can be used to distinguish males and females, but in this case
	// we sample genomes irrespective of males or females since we use index from 0 to ((p1.individualCount*2)-1)
	//gp1male = gp1[0:((p1.individualCount*2)-1)]; 
	// sample 20 genomes from pop1 (discarding the null genomes)
        //sg1 = sample(gp1male[!gp1male.isNullGenome], 20, F);        
        // repeat for pop2
	//gp2male = gp2[0:((p2.individualCount*2)-1)]; // sample all
        // sample 20 genomes from pop2
        //sg2 = sample(gp2male[!gp2male.isNullGenome], 20, F);
        // Print ms output with genomes from pop1 first followed by genomes of pop2
        //sg = c(sg1, sg2); 
        //sg.outputMS("ms_" + filenamems + "_" + rep + "_G12000.ms", append=F);
	p1.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G12000.ms",append=F);
	p2.outputMSSample(20,replace=F,filePath="ms_" + filenamems + "_" + rep + "_G12000.ms",append=T);

}
