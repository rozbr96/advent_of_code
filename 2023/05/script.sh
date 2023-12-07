#!/bin/zsh

# lines=("${(f)$(cat samples/part_one.txt)}")
lines=("${(f)$(cat input.txt)}")

seeds=(`echo $lines[1] | awk -F ': ' '{ print $2 }' | awk '{ print $0 }'`)

for seed in $seeds; do
  for line_index in {2..${#lines}}; do
    line=$lines[$line_index]

    if [[ $line = *"map:" ]]; then
      check_map="yes"
    else
      [[ $check_map = "no" ]] && continue

      items=(`echo $line`)

      destination=$items[1]
      source=$items[2]
      length=$items[3]

      lower_limit=$source
      upper_limit=$(( lower_limit + length - 1 ))

      [[ $seed -gt $upper_limit || $seed -lt $lower_limit ]] && continue

      seed=$(( seed + destination - source ))
      check_map="no"
    fi
  done

  [[ -z $lowest_location || $seed -lt $lowest_location ]] && lowest_location=$seed
done

echo $lowest_location
