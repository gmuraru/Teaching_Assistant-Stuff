#! /bin/bash

if [ $# -ne 2 ]; then
    echo -e "Usage: course-elf homework"
    exit -1
fi

COURSE=$1
HW=$2

SSH_ADDR="$COURSE@elf.cs.pub.ro"
HOMEWORK_DIR="~/vmchecker-storer/repo/$HW/*"

OUTPUT_DIR="output"

rm -rf $OUTPUT_DIR
mkdir $OUTPUT_DIR

# This will take some time
scp -r "$SSH_ADDR:$HOMEWORK_DIR" "$OUTPUT_DIR"
