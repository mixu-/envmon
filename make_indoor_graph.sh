#!/bin/bash
title=$1
age=$2
png=$3
rrdtool graph $png \
-w 800 -h 250 -a PNG \
--start $age --end now \
--font DEFAULT:9: \
--title "$title Indoor Temp" \
--watermark "`date`" \
--vertical-label "Temp C" \
--left-axis-format "%5.1lf" \
--right-axis-format "%5.1lf" \
--right-axis-label "Temp C" \
--right-axis 1:0 \
--rigid \
DEF:temp=env.rrd:Temperature:AVERAGE \
DEF:orh=weather.rrd:RelativeHumidity:AVERAGE \
DEF:rh=env.rrd:RelativeHumidity:AVERAGE \
DEF:otemp=weather.rrd:Temperature:AVERAGE \
LINE2:temp#0000FF:"Indoor temp\t\t" \
GPRINT:temp:LAST:"Cur\:%5.2lf C\t" \
GPRINT:temp:AVERAGE:"Avg\:%5.2lf C\t" \
GPRINT:temp:MAX:"Max\:%5.2lf C\t" \
GPRINT:temp:MIN:"Min\:%5.2lf C\n" \
#LINE2:rh#00FF00:"Indoor RH%\t\t" \
#GPRINT:rh:LAST:"Cur\:%5.2lf%%\t" \
#GPRINT:rh:AVERAGE:"Avg\:%5.2lf%%\t" \
#GPRINT:rh:MAX:"Max\:%5.2lf%%\t" \
#GPRINT:rh:MIN:"Min\:%5.2lf%%\n" \

cp *.png /var/www/public/
