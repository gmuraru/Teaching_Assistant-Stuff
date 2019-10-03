#!/bin/bash

# This script needs to be run after ssh-ing to vmchecker

if [ $# -ne 1 ]; then
    echo -e "Need to be run on the elf machine\n"\
            "Usage: $0 homework_name\n"\
            "Ex: tema1-haskell"
	exit -1
fi

HW=$1
COURSE=$(whoami)

# check to see if the homework directory exists
DIR=$HOME/vmchecker-storer/repo/$HW
if ! [ -d "$DIR" ]; then
	echo "ERR: homework directory $DIR does not exist"
	exit -1
fi

# find all the "current" links
LINKS=$(find $DIR -type l -name current)

TMPDIR=$(mktemp -d /tmp/.so.dir.XXXXXXX)

IFS=$'\n'
for l in $LINKS; do
	# get the hw name
	hw=$(echo "$l" | awk -F'/' '{print $(NF-2)}')

	# resolve the link
	hw_student_name=$(echo "$l" | awk -F'/' '{print $(NF-1)}')
	hw_dir=$(readlink $l)

	if ! [ "$hw_dir" ]; then
		echo "homework dir for $hw does not exist!: $hw_dir"
		continue
	fi
	if ! [ "$hw_dir/archive.zip" ]; then
		echo "homework for $hw does not exist!: $hw_dir/archive.zip"
		continue
	fi

	# copy to the temporary dir
	zip_name=$hw_$hw_student_name.zip
	cp $hw_dir/archive.zip $TMPDIR/$zip_name
done

cd $TMPDIR

# zip everything in the current directory
zip -r $COURSE-assignments.zip *
cd -
mv $TMPDIR/$COURSE-assignments.zip .
