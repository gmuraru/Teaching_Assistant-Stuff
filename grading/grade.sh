#!/bin/sh

# Fills in vmchecker the grades for each student
#
# The grade file has to have the following structure:
# -----------------------
# | DELIMITER           |
# | student.name        |
# | DELIMITER           |
# | multi line comments |
# -----------------------
#
# Written by: Răzvan Crainea

HWDIR=$1
DELIMITER="#########################################"

if [ -z "$HWDIR" ]; then
	echo "Usage: $0 <howmework directory> [<grade file>]"
	exit
fi

if [ -n "$2" ]; then
	GRADEFILE=$2
else
	GRADEFILE=$(echo "${HWDIR}" | sed 's#/*$##').grade.vmr
fi

if ! [ -e "$HWDIR" -a -d "$HWDIR" ]; then
	echo "Invalid homework directory '$HWDIR'"
	exit
fi

if ! [ -e "$GRADEFILE" ]; then
	echo "Grade file '$GRADEFILE' does not exist"
	exit
fi


# States:
# 0 - initial state/read first delimiter
# 1 - read name
# 2 - read second delimiter
# 3 - reading comments

state=0
student=
file=
line_no=0

IFS=$'\n'
while read line; do
	case $state in
		0)
			if [ "$line" = "$DELIMITER" ]; then
				state=1
			fi
			;;
		1)
			if [ -n "$line" ]; then
				student="$line"
				file="$HWDIR/$student/current/results/grade.vmr"
				echo "Grading student '$student' ..."
				if ! [ -e "$file" ]; then
					echo "Student $student does not exist - line $line_no"
					exit
				fi
				state=2
			fi
			;;
		2)
			if [ -z "$file" -o -z "$student" ]; then
				echo "No student or file specified - line $line_no"
				exit
			fi
			if [ "$line" = "$DELIMITER" ]; then
				state=3
				> $file
			fi
			;;
		3)
			if [ -z "$file" -o -z "$student" ]; then
				echo "No student or file specified - line $line_no"
				exit
			fi
			if [ "$line" = "$DELIMITER" ]; then
				state=1
				file=
				student=
			elif [ -n "$line" ]; then
				echo "$line" >> $file
			fi
			;;
		*)
			echo "Unknown state - line $line_no"
			exit
			;;
	esac
	line_no=$(($line_no+1))
done < $GRADEFILE

if [ "$state" = "2" ]; then
	echo "Bogus state: $state Student: $student File: $file"
fi
