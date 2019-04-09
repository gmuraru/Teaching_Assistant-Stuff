#! /bin/bash

SSH_ADDR="pc-cb@elf.cs.pub.ro"
HOMEWORK_DIR="~/vmchecker-storer-2018-2019/repo/tema1"
OUTPUT_DIR="output"

# This will take some time
scp -r "$SSH_ADDR:$HOMEWORK_DIR" "$OUTPUT_DIR"
