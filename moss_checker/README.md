### Check plagiarism

##### How to use
* Use the **download_homeworks.sh** to download all the source folders for a specific homework
  * This will take some time depending on the number of homeworks
  * Need to edit the script to specify the directory where the homework is located (on vmchecker)
* Use the **process_homeworks.sh** to bring all the source code into a single file for each student
* Run **./moss -l c processed_output/*.c** and check the link
  * Depending on what language you want to check, you can change it using the **-l** parameter (currently is set for C)
