#!/bin/bash

echo -e "\n\033[1;95mPUSH SWAP TESTER\033[0m"

if [ ! -e $0 ];
then 
	echo -e "\n\033[1;91m./checker_linux binary not found.\033[0m";
	exit;
elif [ ! -e "./push_swap" ];
then
	make
fi

if [[ $1 -lt 0 ]] && ! [[ $1 =~ '^[0-9]+$' ]]
then
	echo -e "\033[1;97m$0 <valor>\n$0 100\033[0m";
	exit;
fi

if [ ! -e "./push_swap" ];
then
    echo -e "\n\033[1;91m./push_swap binary not found.\033[0m"
    exit 1
fi

if [ $1 -a !SIZE ];
then
	SIZE=$1;
else
	SIZE=0;
fi

if [ $4 -a !BIGGER ];
then
	BIGGER=$4;
else
	BIGGER=0;
fi

if [ $5 -a !SMALLER ];
then
	SMALLER=$5;
else
	SMALLER=2147483647;
fi

export VAR="$(seq -100000 100000 | shuf -n $SIZE | tr '\n' ' ')"
#export VAR="$(shuf -i 1-$SIZE | tr '\n' ' ')"

./push_swap $VAR > tmp.log

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
#echo -e ""

print 'MOVES' $TOTAL

if [ -z "$MEDIAN" ];
then
	export MEDIAN=$TOTAL
else
	export MEDIAN=$(expr $TOTAL + $MEDIAN)
fi

if [ $TOTAL -gt $BIGGER ];
then
	BIGGER=$TOTAL;
fi

if [ $TOTAL -lt $SMALLER ];
then
	SMALLER=$TOTAL
fi

print 'SMALLER' $SMALLER
print 'BIGGER' $BIGGER

STATUS=$(./push_swap $VAR | ./checker_linux $VAR)
#STATUS=$(./push_swap $VAR | ./checker $VAR)

echo -ne "\033[1mSTATUS: "

if [[ $STATUS == "OK" || $STATUS == "" ]];
then
	echo -e "\033[1;92mOK\033[1m";
else
	echo -e "\033[1;91mKO\033[1m";
fi

if [ $SIZE -lt 101 ];
then
	if [ $TOTAL -lt 701 ];
	then
		echo -e "\033[1;92mSUCCESS\033[1m";
	else
		echo -e "\033[1;91mFAIL\033[1m";
		echo -e $VAR >> fail.log;
	fi
elif [ $SIZE -lt 501 ];
then
	if [ $TOTAL -lt 5501 ]
	then
		echo -e "\033[1;92mSUCCESS\033[1m";
	else
		echo -e "\033[1;91mFAIL\033[1m";
		echo -e $VAR >> fail.log;
	fi
fi

if [ -z "$TIMES" ];
then
	export TIMES=1;
else
	export TIMES=$(expr $TIMES + 1)
fi

print 'MEDIAN' $(expr $MEDIAN / $TIMES)

sleep 1

echo -e ""

if [ $SIZE -gt 1 ];
then
	$0 $SIZE $MEDIAN $TIMES $BIGGER $SMALLER
else
	echo -e "\n\033[1;97m$0 <valor>\n$0 100\033[0m"
fi
