#!/bin/sh

# check for crashed events in production:

# Usage: ./check-crashes.sh [folder_with_err]

for i in $(seq 0 99)
do
  file=$(ls $1/3err/$1_$i.* | tail -n1)
  echo $file >> check_crashes_$1.txt
  cat $file | grep -B 1 Closed | grep Begin >> check_crashes_$1.txt
done
