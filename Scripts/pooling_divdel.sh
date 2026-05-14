#!/bin/bash

rm template_*.s 
FILES=`ls *.s`

divergence=( 11000 ) 

# create one script per file and per run to run SLIM and launch it on the cluster
for file in ${FILES};
do	
	#echo "pooling stats from ${file}"
	filename=$(basename "$file") # this one is useful in case there is a path
	prefix="${filename%.*}" # get the prefix, i.e., without ".s"
	cd $prefix
	for div in ${divergence[@]}; 
	do 
		echo "pooling stats from ${div} in $prefix"
		#echo *${div}.sumstat
		#echo ${prefix}_${div}.all
		cat *${div}.rawsumstat >> ${prefix}_${div}.all
		#echo *_11_G11000.sumstat
		head -n 1 *_11_G11000.sumstat > ${prefix}_${div}.final
		cat ${prefix}_${div}.all >> ${prefix}_${div}.final
		#rm *_${div}.sumstat  *_${div}.rawsumstat *_"${div}".all *_${div}.detailed
		rm *_${div}.all
		mv "${prefix}"_"${div}".final ../
	done
	cd ..
done
