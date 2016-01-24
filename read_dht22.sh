#!/bin/bash
start=0
start_weather=0
stty -F /dev/ttyACM0 speed 115200
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
    echo "Seconds since last db write: $waited"
    echo "Seconds since last weather update: $waited_weather"
    echo ${temp}C / ${rh}%
    rrdtool update env.rrd N:${rh}:${temp}
    ./make_env_graph.sh "Just now" -7200 "env_now.png"
    ./make_env_graph.sh "Today" -86200 "env_today.png"
    ./make_env_graph.sh "Past 7 days" -604800 "env_7d.png"
    ./make_env_graph.sh "Past year" -31536000 "env_365d.png"
    now=`date +%s`
    start=$now
    if [[ $waited_weather -ge 300 ]]; then
      outdoor_temp=`curl http://saa.knuutilat.net/ | grep -oP '<TD>.{5}<TD>\K.{1,5}' | sed 's/°//'`
      outdoor_rh=`curl http://saa.knuutilat.net/ | grep -oP 'RIGHT>\K\d*'`
      rrdtool update weather.rrd N:${outdoor_rh}:${outdoor_temp}
      start_weather=`date +%s`
    fi
  fi
done < /dev/ttyACM0
