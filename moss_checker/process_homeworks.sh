#!/bin/bash

HOMEWORK_DIR="output"
OUTPUT="processed_output"

rm -rf $OUTPUT
mkdir $OUTPUT

for stud in $(ls $HOMEWORK_DIR); do

	DIR_STUD="$HOMEWORK_DIR/$stud/current/git/archive/"
	STUD_SRC_FILES=$(find $DIR_STUD -type f -name "*.hs")

	STUD_PROCESSED_FILE="$OUTPUT/$stud.hs"

	for src_file in $STUD_C_FILES; do
		cat $src_file >> $STUD_PROCESSED_FILE
	done

    echo "Proccesed $stud"
done
