#!/usr/bin/env bash

print_tabs() {
	count=$1
	while [[ $count > 0 ]]; do
		echo -en "\t-"

		count=$(expr $count - 1)
	done
}

if [[ $# == 0 ]]; then
	sourceDir=.
else
	sourceDir=$1
fi

if [[ $# == 1 ]]; then
	echo ${sourceDir}:

	ls -dQ ${sourceDir/ /\\ }/*/ 2> /dev/null | xargs -I {} "$0" {} 1
elif [[ $# == 2 ]]; then
	print_tabs $2; echo " ${1}:"

	ls -dQ ${1/ /\\ }*/ 2> /dev/null | xargs -I {} "$0" {} $(expr $2 + 1)
fi
	

