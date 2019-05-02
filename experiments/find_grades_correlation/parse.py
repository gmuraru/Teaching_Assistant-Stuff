#! /usr/bin/python

import csv
from fuzzywuzzy import fuzz

# Delimiter must be ","
csv_files = {
        "Programare": {
            "prog-CB.csv": {
                "name-cols": [0], # If the student name is split across mutiple columns
                "hw-cols": [17, 18, 19], # Three homeworks
                "skip-rows": 2 # Number of rows to skip until reach first student
                },
            "prog-CD.csv": {
                "name-cols": [0], # If the student name is split across mutiple columns
                "hw-cols": [17, 18, 19], # Three homeworks
                "skip-rows": 2 # Number of rows to skip until reach first student
                },
            },
        "Sisteme de operare": {
            "so-CA.csv": {
                "name-cols": [0], # If the student name is split across mutiple columns
                "hw-cols": [28, 29, 30, 31, 32, 33, 34, 35], # Three homeworks
                "skip-rows": 3 # Number of rows to skip until reach first student
                },
            "so-CB.csv": {
                "name-cols": [0], # If the student name is split across mutiple columns
                "hw-cols": [28, 29, 30, 31, 32, 33, 34, 35], # Three homeworks
                "skip-rows": 3 # Number of rows to skip until reach first student
                },
            "so-CC.csv": {
                "name-cols": [0], # If the student name is split across mutiple columns
                "hw-cols": [28, 29, 30, 31, 32, 33, 34, 35], # Three homeworks
                "skip-rows": 3 # Number of rows to skip until reach first student
            }
        }
    }

def compute_similarity(name1, name2):
    return fuzz.token_sort_ratio(name1, name2)

def get_students_for_course(course, csv_entries):
    students = []

    for csv_file_name, info in csv_entries[course].items():

        hw_cols = info["hw-cols"]
        skip_rows = info["skip-rows"]
        name_cols = info["name-cols"]

        with open(csv_file_name) as f_in:
            csv_reader = csv.reader(f_in, delimiter=",")
            for _ in range(skip_rows):
                next(csv_reader)

            for row in csv_reader:
                name = [row[i] for i in name_cols]
                name = " ".join(name)

                try:
                    grades = [float(row[i]) for i in hw_cols]
                except :
                    continue

                if len(name) != 0 and len(grades) != 0:
                    students.append([name, *grades])
    print(students)

RESULT_FILE = "students"

if __name__ == "__main__":
    get_students_for_course("Sisteme de operare", csv_files)
