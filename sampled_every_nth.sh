#!/bin/zsh

# use of zsh is necessary for the arithmetic operations (floating points)

# Usage: ./sampled_every_01ns.sh <sample_interval> <dump_file> <bonds_file>

# select a order of magnitude higher value than the total number of atoms
large_number=10000
time_ns=$((${1} / 10000000.0))
time_ns=$(printf "%.3f" $time_ns)
if [ "$2" ]; then
    if test -f $2; then
        # for the dump file:
        echo "Writing the latest iteration to a dump file"
        head -n $large_number $2 | grep -n TIME | head -n 2 | cut -d : -f 1 >lines
        first_occurance=$(head -n 1 lines)
        first_timestep=$(head -n $(($first_occurance + 1)) $2 | tail -n 1)
        second_occurance=$(tail -n 1 lines)
        second_timestep=$(head -n $(($second_occurance + 1)) $2 | tail -n 1)
        period=$(($second_timestep - $first_timestep))
        period_line=$(($second_occurance - $first_occurance))
        last_occurance=$(tail -n $large_number $2 | grep -n TIME | tail -n 1 | cut -d : -f 1)
        last_timestep=$(tail -n $large_number $2 | head -n $(($last_occurance + 1)) | tail -n 1)
        difference=$(($last_timestep - $first_timestep))
        number_of_timestep=$((1 + $difference / $period))
        count=0
        rm sampled_every_$1.dump
        for i in {$first_timestep..$last_timestep..$period}; do
            if [ $(($i % $1)) -eq 0 ]; then
                tail -n +$(($first_occurance + $period_line * $count)) $2 | head -n $period_line >>sampled_every_$1.dump
            fi
            count=$(($count + 1))
        done
        rm lines
        echo "Done"
    else
        echo "Invalid DUMP file"
    fi
else
    echo "no file name given.\nExiting..."
    exit 1
fi

if [ "$3" ]; then
    if test -f $3; then
        # for the bonds file:
        echo "Writing the latest iteration to a bonds file"
        head -n $large_number $3 | grep -n Time | head -n 2 | cut -d : -f 1 >lines
        head -n $large_number $3 | grep -n Time | head -n 2 | cut -d p -f 2 >times
        first_occurance=$(head -n 1 lines)
        first_timestep=$(head -n 1 times)
        second_occurance=$(tail -n 1 lines)
        second_timestep=$(tail -n 1 times)
        period=$(($second_timestep - $first_timestep))
        period_line=$(($second_occurance - $first_occurance))
        last_timestep=$(tail -n $large_number $3 | grep -n Time | tail -n 1 | cut -d p -f 2)
        difference=$(($last_timestep - $first_timestep))
        number_of_timestep=$((1 + $difference / $period))
        count=0
        rm sampled_every_$1.bonds

        for i in {$(($first_timestep))..$(($last_timestep))..$(($period))}; do
            if [ "$(($i % $1))" -eq 0 ]; then
                tail -n +$(($first_occurance + $period_line * $count)) $3 | head -n $period_line >>sampled_every_$1.bonds
            fi
            count=$(($count + 1))
        done
        echo "Done"
        rm lines times
    else
        echo "Invalid BONDS file"
    fi

else
    echo "no file name given.\nExiting..."
    exit 1
fi
