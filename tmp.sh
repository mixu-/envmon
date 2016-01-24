#!/bin/bash
start=0
endTime1=$(( $(date +%s) + 10 ))
endTime2=$(( $(date +%s) + 300 ))
export PATH=$PATH:/opt/rrdtool-1.5.5/bin/:/opt/rrdtool-1.5.5/bin/
while true; do
  temp=1.1
  rh=2.2
  re='^[0-9]+([.][0-9]+)?$'
  now=`date +%s`
  waited=`expr $now - $start`
  if [[ $temp =~ $re ]] && [[ $rh =~ $re ]] && [[ $waited -ge 10 ]]; then
    echo "Seconds since last db write: $waited"
    echo "Seconds since last weather update: $waited_weather"
    echo ${temp}C / ${rh}%
    sleep 2
    now=`date +%s`
    start=$now
    if [ $(date +%s) -lt $endTime2 ]; then
      outdoor_temp=`curl http://www.eeki.biz/saavahti.php | grep -Po 'tila \K[-\d.]*'`
      outdoor_rh=0
      endTime2=$(( $(date +%s) + 300 ))
    fi
  fi
done
