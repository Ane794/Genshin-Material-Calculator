#!/usr/bin/env bash
read -p "Enter the number of rarity types (3): " rarities
rarities=$(( rarities ? rarities : 3 ))

# Sets targets.
read -p "Enter the hasTargets amount of each rarity type (0): " inputs
i=0
for input in $inputs; do
  (( targets[i++] = input ))
done
unset input i inputs

# Verifies targets.
hasTargets=0
for i in `seq 0 $(( rarities - 1 ))`; do
  if (( targets[i] )); then
    hasTargets=1
    break
  fi
done
unset i

until (( hasTargets && reached )); do
  # Adds inputs to the array.
	read -p "Enter the amount of each rarity type: " inputs
	i=0
	for input in $inputs; do
		if (( i >= rarities )); then
			break
		fi
		(( amounts[i++] += input ))
	done
	unset input i inputs

  # Reduces.
	c=0
	for i in `seq $(( rarities - 1 )) -1 1`; do
		(( amounts[i] += c ))
		if (( amounts[i] > targets[i] )); then
		  (( c = (amounts[i] - targets[i]) / 3 ))
		  (( amounts[i] = targets[i] + (amounts[i] - targets[i]) % 3 ))
		else
		  (( c = 0 ))
		fi
	done
	unset i
	(( amounts[0] += c ))
	unset c

  # Outputs.
	output={${amounts[0]}
	for i in `seq 1 $(( rarities - 1 ))`; do
		output="${output}, ${amounts[$i]}"
	done
	unset i
	output=$output}
	echo $output
	unset output

  # Verifies.
  reached=1
  for i in `seq 0 $(( rarities - 1 ))`; do
    if (( amounts[i] < targets[i] )); then
      reached=0
      break
    fi
  done
  unset i
done
unset reached

echo Reached the targets.
