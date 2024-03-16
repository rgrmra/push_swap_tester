#!/bin/bash

if  ! [[ $1 =~ ^[0-9]+$ ]];
then
	echo -e "\033[1;97m$0 <valor>\n$0 100\033[0m";
	exit 1;
fi

if [ ! -e $0 ];
then 
	echo -e "\n\033[1;91m./checker_linux binary not found.\033[0m";
	exit 1;
elif [ ! -e "../push_swap" ];
then
	make -C ../ --no-print-directory;
	if [ ! -e "../push_swap" ];
	then
		exit 1;
	fi
fi

if [ ! -e "../push_swap" ];
then
    echo -e "\n\033[1;91m./push_swap binary not found.\033[0m"
    exit 1
fi

echo -e "\n\033[1;95mPUSH SWAP TESTER\033[0m"

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

../push_swap $VAR > tmp.log

print() {
	echo -ne "\033[1;97m$1: \033[1;93m$2  \033[1;m"
}

SA=$(cat tmp.log | grep -w 'sa'| wc -l)
SB=$(cat tmp.log | grep -w 'sb'| wc -l)
SS=$(cat tmp.log | grep -w 'ss'| wc -l)
PA=$(cat tmp.log | grep -w 'pa'| wc -l)
PB=$(cat tmp.log | grep -w 'pb'| wc -l)
RA=$(cat tmp.log | grep -w 'ra'| wc -l)
RB=$(cat tmp.log | grep -w 'rb'| wc -l)
RR=$(cat tmp.log | grep -w 'rr'| wc -l)
RRA=$(cat tmp.log | grep -w 'rra'| wc -l)
RRB=$(cat tmp.log | grep -w 'rrb'| wc -l)
RRR=$(cat tmp.log | grep -w 'rrr'| wc -l)
TOTAL=$(($(cat tmp.log | wc -l)))

if [ $SA -gt 0 ];
then
	print 'SA' $SA
fi

if [ $SB -gt 0 ];
then
	print 'SB' $SB
fi

if [ $SS -gt 0 ];
then
	print 'SS' $SB
fi

if [ $PA -gt 0 ];
then
	print 'PA' $PA
fi

if [ $PB -gt 0 ];
then
	print 'PB' $PB
fi

if [ $RA -gt 0 ];
then
	print 'RA' $RA
fi

if [ $RB -gt 0 ];
then
	print 'RB' $RB
fi

if [ $RR -gt 0 ];
then
	print 'RR' $RR
fi

if [ $RRA -gt 0 ];
then
	print 'RRA' $RRA
fi

if [ $RB -gt 0 ];
then
	print 'RRB' $RRB
fi

if [ $RRR -gt 0 ];
then
	print 'RRR' $RRR
fi

echo -e ""
print 'SIZE' $SIZE

print 'MOVES' $TOTAL

if [ -z "$MEDIAN" ];
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

echo -ne "\033[1mCHECKER: \033[0m";
STATUS=$(../push_swap $VAR | ./checker_linux $VAR)
if [[ $STATUS == "OK" || $STATUS == "" ]];
then
	echo -ne "\033[1;92mOK\033[0m";
else
	echo -ne "\033[1;91mKO\033[0m";
fi

echo -ne "\033[1m AVALIATION: ";
if ([ $SIZE -lt 101 ] && [ $TOTAL -lt 701 ]) || ([ $SIZE -lt 501 ] && [ $TOTAL -lt 5500 ]);
then
	echo -ne "\033[1;92mSUCCESS\033[0m";
else 
	if [ $SIZE -lt 501 ];
	then
		echo -ne "\033[1;91mFAIL\033[0m";
		echo -e $VAR >> fail.log;
	else
		echo -ne "\033[1;94mNOT INFORMED\033[0m";
	fi
fi
echo "";

if [ -z "$TIMES" ];
then
	export TIMES=1;
else
	export TIMES=$(expr $TIMES + 1)
fi

print 'MEDIAN' $(expr $MEDIAN / $TIMES);
echo -e "";

sleep 1

if [ $SIZE -lt 2 ];
then
	exit 0;
fi

if [ $REPEAT -gt 1 ];
then
	REPEAT=$(expr $REPEAT - 1);
else
	exit 0;
fi

$0 $SIZE $REPEAT $MEDIAN $TIMES $LARGEST $SMALLEST
