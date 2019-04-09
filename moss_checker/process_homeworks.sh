#!/bin/bash

HOMEWORK_DIR="output"
OUTPUT="processed_output"

rm -rf $OUTPUT
mkdir $OUTPUT

for stud in $(ls $HOMEWORK_DIR)
do

	DIR_STUD="output/$stud/current/git/archive/"
	STUD_C_FILES=$(find $DIR_STUD -type f -name "*.c")
	STUD_H_FILES=$(find $DIR_STUD -type f -name "*.h")

	STUD_PROCESSED_FILE="$OUTPUT/$stud.c"

	for src_file in $STUD_C_FILES
	do
		cat $src_file >> $STUD_PROCESSED_FILE
	done

	for hdr_file in $STUD_H_FILES
	do
		cat $hdr_file >> $STUD_PROCESSED_FILE
	done
    echo "Proccesed $stud"
done
