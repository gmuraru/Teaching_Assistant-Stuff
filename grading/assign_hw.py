#!/usr/bin/python

# assign homework submissions to TAs and build the grading files
# SO, 2015
# Remade for all courseworks - 2019

import sys
import string
from os import path
from os.path import expanduser
from glob import glob
from collections import defaultdict

if len(sys.argv) != 2:
	print("usage: python " + sys.argv[0] + " <assignment_name>")
	exit(1)

# assignment name
hw_name = sys.argv[1]

# submissions directory
submissions_dir = expanduser("~/vmchecker-storer/repo/")

# list of TAs -- NEED TO CHANGE
ta_list = ["TC", "GM"]

# set of submissions to be skipped (usernames of TAs) -- NEED TO CHANGE
submissions_to_skip = set(["george.muraru", "ioan_tudor.cebere"])
ta_list_size = len(ta_list)

# assign submissions to TAs
def assign_submissions():
	assignment_map = defaultdict(list)

	# get all submissions
	submissions = [path.basename(entry) \
		for entry in glob(submissions_dir + hw_name + "/*")]
	submissions = set(submissions) - submissions_to_skip

	# assign both platforms submissions
	for i, submission in enumerate(submissions):
		idx = i % ta_list_size
		assignment_map[ta_list[idx]].append(submission)

	return assignment_map


# build a grading file, for a specific TA and a specific platform
def build_ta_grading_file(ta, student_list, final_score_string, total_score, bonus_score):
	delim = 41 * "#"

	filename = ta + "-" + hw_name + ".grade.vmr"
	f = open(filename, "w")
	grade_submission_dir = submissions_dir + hw_name + "/"

	for student in student_list:
		bonus = None
		student_results_dir = grade_submission_dir + student + \
				"/current/results/"
		try:
			student_results_file = student_results_dir + \
					"run-stdout.vmr"

			with open(student_results_file, "r") as results_f:
				lineList = results_f.readlines()
			last = lineList[len(lineList)-1]
			parsed = string.split(string.strip(last), ":")
			penalty = 0

			if len(parsed) == 2 and parsed[0] == final_score_string:
				score = float(parsed[1])
				penalty = total_score - score
				if (score > total_score):
					bonus = total_score - score + bonus_score
				error_score = None
			else:
				error_score = "# TODO: verifica output-ul"
		except Exception as e:
			error_score = "# TODO: verifica submisia"

		print(ta + ":" + student)
                f.write("\n".join([delim, student, delim]))

		if error_score:
			f.write(error_score)

		elif penalty > 0:
			f.write("-" + str(penalty) + \
					": teste picate\n")
		if bonus:
			f.write("+" + str(bonus) + \
					": bonus\n")
		f.write("\n")

	f.close()

# build all grading files for a specific platform
def build_grading_files(assignment_map):
	for ta in assignment_map:
		student_list = list(assignment_map[ta])
		student_list.sort()

                ### NEED TO CHANGE
                # final_score_string
                # total_score
                # bonus_score
		build_ta_grading_file(ta, student_list, \
                        final_score_string="Final grade", total_score=100, bonus_score=20)


if __name__ == "__main__":
	# assign all submissions to TAs
	assignments = assign_submissions()

	# build all grading files
	build_grading_files(assignments)
