#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 year student"
	exit -1
fi

# check to see if the homework directory exists
DIR=$HOME/vmchecker-storer-$1/repo/
if ! [ -d "$DIR" ]; then
	echo "ERR: homework directory $DIR does not exist"
	exit -1
fi

# find all the "current" links, that have to point to homeworks
LINKS=$(find $DIR/*/$2 -type l -name current)

TMPDIR=$(mktemp -d /tmp/.so.dir.XXXXXXX)
#trap 'rm -rf "$TMPDIR"' EXIT

for l in $LINKS; do
	# get the hw name
	hw=$(echo "$l" | awk -F'/' '{print $(NF-2)}')
	# resolve the link
	hw_dir=$(readlink $l | sed -e "s/vmchecker-storer/vmchecker-storer-$1/g")
	if ! [ "$hw_dir" ]; then
		echo "homework dir for $hw does not exist!: $hw_dir"
		continue
	fi
	if ! [ "$hw_dir/archive.zip" ]; then
		echo "homework for $hw does not exist!: $hw_dir/archive.zip"
		continue
	fi
	# copy to the temporary dir
	cp $hw_dir/archive.zip $TMPDIR/$hw.zip
done

cd $TMPDIR
# zip everything in the current directory
zip -r so-assignments-$2.zip *
cd -
mv $TMPDIR/so-assignments-$2.zip .

