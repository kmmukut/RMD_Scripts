#!/bin/zsh

# Usage: ./restart.sh <DUMP_File>

last_location=$(tail -n 10000 $1 | grep -n TIME | tail -n 1 | cut -d : -f 1)
last_time=$(tail -n 10000 $1 | head -n $(($last_location + 1)) | tail -n 1)
last_time_ns="$((${last_time} / 10000000.0))"_ns
# last_time_ns=$(printf "%.3f" $last_time_ns)

echo $last_time_ns

mkdir $last_time_ns

mv $(find ./ -type f) $last_time_ns

cd $last_time_ns

cp in.in *.rst *.reax *.param *.control run* *.sh ../
cd ..

# very important
# if the simulation crashed or intentionally closed do not remove the *1.rst and *2.rst files.
# if the simulation completed for the desired time then it is okay to remove the *1.rst and *2.rst files.
# rm *1.rst *2.rst
