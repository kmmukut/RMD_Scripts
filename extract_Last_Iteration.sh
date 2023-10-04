#!/bin/zsh

# use of zsh is necessary for the arithmetic operations (floating points)

# Usage: ./extract_Last_Iteration.sh <dump_file> <bonds_file>

# select a order of magnitude higher value than the total number of atoms
large_number=10000

if [ "$1" ]; then
    if test -f $1; then
        # for the dump file:
        echo "Writing the latest iteration to a dump file"

        tail -n $large_number $1 | grep -n TIMESTEP | cut -d : -f 1 | tail -n 2 >lines

        start=$(head -n 1 lines)
        end=$(tail -n 1 lines)
        diff=$(($end - $start))

        tail -n $large_number $1 | tail -n +$start | head -n $diff >last_iteration

        time=$(head -n 2 last_iteration | tail -n 1)
        time_ns=$((${time} / 10000000.0))
        time_ns=$(printf "%.3f" $time_ns)

        mv last_iteration last_iteration_${time_ns}ns.dump

        rm lines

        echo "Done"
    else
        echo "Invalid DUMP file"
    fi
else
    echo "no file name given.\nExiting..."
    exit 1
fi

if [ "$2" ]; then
    if test -f $2; then
        # for the bonds file:
        echo "Writing the latest iteration to a bonds file"
        tail -n $large_number last_60000.bonds | grep -n Timestep | cut -d : -f 1 | tail -n 2 >lines
        start=$(head -n 1 lines)
        end=$(tail -n 1 lines)
        diff=$(($end - $start))
        tail -n $large_number $2 | tail -n +$start | head -n $diff >last_iteration

        time=$(head -n 1 last_iteration | cut -d p -f 2)
        time_ns=$((${time} / 10000000.0))
        time_ns=$(printf "%.3f" $time_ns)

        mv last_iteration last_iteration_${time_ns}ns.bonds

        rm lines

        echo "Done"
    else
        echo "Invalid BONDS file"
    fi

else
    echo "no file name given.\nExiting..."
    exit 1
fi
