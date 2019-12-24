#!/bin/bash
force="false"
if [ "$1" == "-f" ]; then
  force="true"
  shift
fi

CLI=./cli.sh

if [ ! -f "$CLI" ]; then
  echo "$CLI not found!"
  exit
fi

FILE=./block-reward-0.8.4.txt

if [ "$force" == "true" ]; then
  rm -f $FILE
fi

function get_block_by_order() {
  local cli=$1
  local order=$2
  block=$($cli block $num|jq '.|"\(.order) \(.height) \(.pow.pow_name) \(.pow.proof_data.edge_bits) \(.difficulty) \(.hash) \(.confirmations) \(.txsvalid) \(.timestamp) \(.transactions[0].vout[0].amount) \(.transactions[0].vout[0].scriptPubKey.addresses[0])"' -r)
  order=`echo $block| cut -d' ' -f1`
  height=`echo $block| cut -d' ' -f2`
  pow=`echo $block| cut -d' ' -f3`
  edge=`echo $block| cut -d' ' -f4`
  diff=`echo $block| cut -d' ' -f5`
  hash=`echo $block| cut -d' ' -f6`
  confirm=`echo $block| cut -d' ' -f7`
  txsvalid=`echo $block| cut -d' ' -f8`
  timestamp=`echo $block| cut -d' ' -f9`
  amount=`echo $block| cut -d' ' -f10`
  addr=`echo $block| cut -d' ' -f11`
  isblue=$($cli isblue $hash)
  node=`echo $(basename $cli .sh)|sed 's/^.*-//g'`
  #echo "$block $isblue $node $(owner $node)"
  t=`date_to_timestamp $timestamp`
  t1=`timestamp_to_date $t`
  #t1=`timestamp_to_date $t GMT`
  #t1=`timestamp_to_date $t UTC`
  echo "$order,$height,$addr,$hash,$txsvalid,$amount,$confirm,$pow,$edge,$diff,$t,$t1,$isblue"
}

function date_to_timestamp() {
  if [ ! "${1:${#1}-1}" == "Z" ]; then
    date_to_timestamp_1 $1
  else
    date_to_timestamp_2 $1
  fi

}

function date_to_timestamp_1() {
  local time=`echo $1|sed s/:00$/00/g`
  local s=`date -j -f "%Y-%m-%dT%H:%M:%S%z" "$time"  "+%s"`
  echo $s
}

# 2019-12-22T00:22:14Z
function date_to_timestamp_2() {
  local s=`date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$1"  "+%s"`
  echo $s
}

function timestamp_to_date() {
  if [ "$2" == "GMT" ]; then
    local date=`env TZ=GMT date -j -r "$1" '+%Y-%m-%d_%H:%M:%S_%Z'`
  elif [ "$2" == "UTC" ]; then
    local date=`env TZ=UTC date -j -r "$1" '+%Y-%m-%d_%H:%M:%S_%Z'`
  else
    local date=`date -j -r "$1" '+%Y-%m-%d_%H:%M:%S_%Z'`
  fi
  echo $date
}

if [ ! -f $FILE ]; then
  for ((num=1; num<40652; num+=1))
  do
    echo $(get_block_by_order $CLI $num) >> $FILE
  done
fi
