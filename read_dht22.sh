#!/bin/bash
start=0
start_weather=0
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
  waited_weather=`expr $now - $start_weather`
  if [[ $temp =~ $re ]] && [[ $rh =~ $re ]] && [[ $waited -ge 10 ]]; then
    echo ${temp}C / ${rh}%
    rrdtool update env.rrd N:${rh}:${temp}
    ./make_env_graph.sh
    start=`date +%s`
    waited=0
    if [[ $waited_weather -ge 300 ]]; then
      outdoor_temp=`curl http://www.eeki.biz/saavahti.php | grep -Po 'tila \K[-\d.]*'`
      outdoor_rh=0
      rrdtool update weather.rrd N:${outdoor_rh}:${outdoor_temp}
      waited_weather=0
    fi
  fi
done < /dev/ttyACM0
