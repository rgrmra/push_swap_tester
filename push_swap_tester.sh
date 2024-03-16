#!/bin/bash

export DIR=$(dirname $0);

blue() { echo -ne "\033[1;94m$1\033[0m"; }
green() { echo -ne "\033[1;92m$1\033[0m"; }
red() { echo -ne "\033[1;91m$1\033[0m"; }
purple() { echo -ne "\033[1;95m$1\033[0m"; }

if  ! [[ $1 =~ ^[0-9]+$ ]] || ! [[ $2 =~ ^[0-9]+$ ]];
then
	red "$0 <valor> <repetitions>\n$0 100 2\n";
	exit 1;
elif [ ! -e $0 ];
then
	red './checker_linux binary not found.';
	exit 1;
elif [ ! -e "$DIR/../push_swap" ];
then
	make -C $DIR/../ --no-print-directory;
	if [ ! -e "$DIR/../push_swap" ];
	then
		red './push_swap binary not found.';
		exit 1;
	fi
else
	purple "PUSH SWAP TESTER\n";
	
	if [ $1 -a !SIZE ];
	then
		SIZE=$1;
	else
		SIZE=0;
	fi
	
	if [ $2 -a !REPEAT ];
	then
		REPEAT=$2;
	else
		REPEAT=0;
	fi
	
	if [ $5 -a !LARGEST ];
	then
		LARGEST=$5;
	else
		LARGEST=0;
	fi
	
	if [ $6 -a !SMALLEST ];
	then
		SMALLEST=$6;
	else
		SMALLEST=2147483647;
	fi
	
	export VAR="$(seq -10000 10000 | shuf -n $SIZE | tr '\n' ' ')"
	
	$DIR/../push_swap $VAR > $DIR/tmp.log
	
	print() {
		if [[ $2 != "" ]] && [ $2 -gt 0 ];
		then
			echo -ne "\033[1m$1: \033[1;93m$2  \033[0m"
		fi
	}

	title() { echo -ne "\033[1m$1: \033[0m"; }
	move() { echo -n $(cat $DIR/tmp.log | grep -w $1 | wc -l); }

	TOTAL=$(cat $DIR/tmp.log | wc -l)
	
	print 'SA' $(move 'sa');
	print 'SB' $(move 'sb');
	print 'SS' $(move 'ss');
	print 'PA' $(move 'pa');
	print 'PB' $(move 'pb');
	print 'RA' $(move 'ra');
	print 'RB' $(move 'rb');
	print 'RR' $(move 'rr');
	print 'RRA' $(move 'rra');
	print 'RRB' $(move 'rrb');
	print 'RRR' $(move 'rrr');
	
	echo -e ""
	print 'SIZE' $SIZE
	print 'MOVES' $TOTAL
	
	if [ -z $MEDIAN ];
	then
		export MEDIAN=$TOTAL
	else
		export MEDIAN=$(expr $TOTAL + $MEDIAN)
	fi
	
	if [ $TOTAL -gt $LARGEST ];
	then
		LARGEST=$TOTAL;
	fi
	
	if [ $TOTAL -lt $SMALLEST ];
	then
		SMALLEST=$TOTAL
	fi
	
	print 'SMALLEST' $SMALLEST
	print 'LARGEST' $LARGEST
	
	title 'CHECKER';
	STATUS=$($DIR/../push_swap $VAR | $DIR/checker_linux $VAR)
	if [[ $STATUS == "OK" || $STATUS == "" ]];
	then
		green 'OK ';
	else
		red 'KO ';
	fi
	
	title 'AVALIATION';
	if ([ $SIZE -lt 101 ] && [ $TOTAL -lt 701 ]) || ([ $SIZE -lt 501 ] && [ $TOTAL -lt 5500 ]);
	then
		green 'SUCCESS';
	else 
		if [ $SIZE -lt 501 ];
		then
			red 'FAIL';
			echo -e $VAR >> $DIR/fail.log;
		else
			blue 'NOT INFORMED';
		fi
	fi
	echo "";
	
	if [ -z $TIMES ];
	then
		export TIMES=1;
	else
		export TIMES=$(expr $TIMES + 1)
	fi
	
	print 'MEDIAN' $(expr $MEDIAN / $TIMES);
	echo "";
	
	if [ $REPEAT -gt 1 ];
	then
		REPEAT=$(expr $REPEAT - 1);
		sleep 1;
	elif [ $REPEAT -gt 0 ];
	then
		rm $DIR/tmp.log;
		exit 0;
	else
		sleep 1;
	fi
	
	$0 $SIZE $REPEAT $MEDIAN $TIMES $LARGEST $SMALLEST
fi
