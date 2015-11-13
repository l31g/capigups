#!/bin/bash

# Simple script to run test-benches
# The script creates a directory with the file name and
# compiles and runs simv within this new directory
# Author: Luis E. P.

FILE=$1
DIR="dir_${FILE%.v}"
SRC="./../.."

# Check if any command line argument was provided 
if [ $# -eq 0 ]
then
	echo "Input at least one test-bench file name"
	exit
fi

# Check if the provided argument is a file 
if [ -f $FILE ]
then
	echo
	echo "================================================================================================"
	echo "Compiling and running $FILE..."
	echo "================================================================================================"
	echo
	
	# Check if directory with the file name exists. Create if it doesn't
	if [ ! -d $DIR ]
	then
		mkdir $DIR
	fi
	# TODO needs to be fixed so it can take a "master" file
	cd ./$DIR
    vcs +v2k -F ../master ../$FILE -full64
	#vcs $SRC/lib/time $SRC/lib/lib* $SRC/libx/* $SRC/adder/*.v $SRC/ild/modrm_ild.v $SRC/ild/prefix_decoder.v $SRC/ild/prefix_3b.v $SRC/ild/len_dec2.v $SRC/ild/len_dec1.v $SRC/ild/len_bundle.v $SRC/ild/len_group.v $SRC/ild/buffer_ild.v $SRC/ild/toplevel_ild.v $SRC/barrel/bshfr_n_8.v $SRC/barrel/brotr_n_8.v $SRC/barrel/bshfl_n_8.v $SRC/barrel/brotl_n_8.v ../$FILE +v2k
	#vcs $SRC/lib/time $SRC/lib/lib* $SRC/adder/pg*.v $SRC/adder/add32.v $SRC/adder/add5.v ../$FILE +v2k
	./simv

	echo
	echo "================================================================================================"
	echo
else
	echo
	echo "File $FILE does not exist!"
	echo
fi
