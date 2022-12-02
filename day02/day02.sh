#!/bin/bash

touch output.txt

infile=$(cat input.txt)
list="$infile"

part1decode(){
	echo "Running part1decode"
	# # Decode (pre-process step)
	list=${list//A/1}
	list=${list//B/2}
	list=${list//C/3}
	list=${list//X/1}
	list=${list//Y/2}
	list=${list//Z/3}
	list=${list// /,}
}

part2decode(){
	echo "Running part2decode"
	# X means lose
	# Y means draw
	# Z means win
	# Since we know all the states, we do another variable swap step and re-run decode1
	list=${list//A X/A C}
	list=${list//A Y/A A}
	list=${list//A Z/A B}
	
	list=${list//B X/B A}
	list=${list//B Y/B B}
	list=${list//B Z/B C}

	list=${list//C X/C B}
	list=${list//C Y/C C}
	list=${list//C Z/C A}
}

part2decode
part1decode

# Score tabulation engine
score=0
for line in $list;do
    line=${line//,/	}
	opponent=$(cut -f1 <<< "$line")
	me=$(cut -f2 <<< "$line")
	
	(( opponent == me )) && 				 score=$(( score + me + 3 )) # Tie	
	(( opponent == 1 ))  && (( me == 2 )) && score=$(( score + me + 6 )) # Win	rock	 < paper	
	(( opponent == 1 ))  && (( me == 3 )) && score=$(( score + me + 0 )) # Lose	rock	 > scissors	
	(( opponent == 2 ))  && (( me == 1 )) && score=$(( score + me + 0 )) # Loss	paper	 > rock	
	(( opponent == 2 ))  && (( me == 3 )) && score=$(( score + me + 6 )) # Win	paper	 < scissors	
	(( opponent == 3 ))  && (( me == 1 )) && score=$(( score + me + 6 )) # Win	scissors < Rock 	
	(( opponent == 3 ))  && (( me == 2 )) && score=$(( score + me + 0 )) # Loss	scissors > paper 

    # echo "line:$line,opponent:$opponent,me:$me"

done

echo $score