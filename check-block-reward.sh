#!/bin/bash

DATA=./block-reward-0.8.4.txt

if [ ! -f $DATA ]; then
  echo "$DATA not found."
  exit
fi

function usage() {
  me=`basename "$0"`
  echo "$me"
  echo "    <addr>   check reward by address"
  echo "    -l       list reward ranking"
}

if [ -z $1 ]; then
  usage
  exit
fi

function valid_block() {
  cat $DATA|grep true|grep ,1$
}

function invalid_block() {
  cat $DATA|grep false
  cat $DATA|grep true|grep ,0$
  cat $DATA|grep true|grep ,2$
}

if [ "$1" == "-l" ]; then
  FILE=./temp_reward_sum.txt
  touch $FILE
  valid_block|cut -d',' -f3|sort|uniq -c|sort -n -r | while read -r count addr; do
    c=$(($count/20))
    addr=`echo $addr`
    if [ ! "$c" -lt 1 ]; then
      echo "$addr $(($c*65)) PMEER <=> $count valid blocks => ($count/20)*65 = $c*65 = $(($c*65))" >> $FILE
    fi 
  done
  cat $FILE
  echo "The totol reward is :  `cat $FILE | awk '{ sum += $2 } END { print sum }'` PMEER"
  rm $FILE


elif [ "${1:0:2}" == "Tm" ] ; then
  addr=$1
  count_valid=`echo $(valid_block|grep $addr|wc -l)`
  echo "----------------------------------------------------------------------"
  echo "The valid blocks are txvalid=true blocks and blue blocks (isblue=1)  : "
  valid_block|grep $addr
  echo "----------------------------------------------------------------------"
  count_invalid=`echo $(invalid_block|grep $addr|wc -l)`
  echo "The invalid blocks are txvalid=false blocks or red blocks (isblue=0) :"
  invalid_block|grep $addr
  echo "-----------------------------------------------------------------"
  echo "The Block Reward for address $addr"
  echo "The valid block   : $count_valid"
  echo "The invalid block : $count_invalid"
  echo -n "The total rewards : " 
  echo "`echo "($count_valid/20)*65"|bc` PMEER = ($count_valid/20) * 65" 

elif [ "$1" == "--print-payout" ]; then
  REWARD=6500000000

  FILE=./084addPayout.txt

  valid_block|cut -d',' -f3|sort|uniq -c|sort -n -r | while read -r count addr
  do
  count=$(($count/20))
  addr=`echo $addr`
  #echo $count $addr
  if [ "$count" -gt 0 ]; then
    decode=`echo $addr|qx base58check-decode`
    #echo "$block addPayout(\""$addr"\", `echo "$REWARD*$count"|bc`, \"76a914"$decode"88ac\") "
    echo "$block addPayout(\""$addr"\", `echo "$REWARD*$count"|bc`, \"76a914"$decode"88ac\") " >> $FILE
  fi
  done
  cat $FILE
  rm $FILE
fi
