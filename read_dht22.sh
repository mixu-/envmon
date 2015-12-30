#!/bin/bash
start=0
export PATH=$PATH:/opt/rrdtool-1.5.5/bin/:/opt/rrdtool-1.5.5/bin/
while true; do
  read -t10 -r input_from_serial_device
  temp=`echo $input_from_serial_device | grep DHT | awk -F "," '{print $4}'`
  rh=`echo $input_from_serial_device | grep DHT | awk -F "," '{print $3}'`
  temp=${temp//[[:blank:]]/}
  rh=${rh//[[:blank:]]/}
  re='^[0-9]+([.][0-9]+)?$'
  now=`date +%s`
  waited=`expr $now - $start`
  if [[ $temp =~ $re ]] && [[ $rh =~ $re ]] && [[ $waited -ge 10 ]]; then
    echo ${temp}C / ${rh}%
    rrdtool update env.rrd N:${rh}:${temp}
    ./make_env_graph.sh
    start=`date +%s`
    waited=0
  fi
done < /dev/ttyACM0
