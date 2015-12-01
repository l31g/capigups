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
    	vcs +v2k -F ../master ../$FILE #-full64
	./simv

	echo
	echo "================================================================================================"
	echo
else
	echo
	echo "File $FILE does not exist!"
	echo
fi
