#!/usr/bin/env bash
read -p "Enter the number of rarity types (3): " rarities
rarities=$(( rarities ? rarities : 3 ))
read -p "Enter the target amount of the highest rarity type (0): " target
target=$(( target ? target : 0 ))

until (( target && amounts[0] >= target )); do
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
		(( c = amounts[i] / 3 ))
		(( amounts[i] %= 3 ))
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
done

echo Reached the target amount.
