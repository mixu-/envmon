#!/bin/bash
title=$1
age=$2
png=$3
rrdtool graph $png \
-w 800 -h 250 -a PNG \
--start $age --end now \
--font DEFAULT:9: \
--title "$title" \
--watermark "`date`" \
--vertical-label "RH%" \
--right-axis-label "Temp C" \
--right-axis 1:0 \
--rigid \
DEF:temp=env.rrd:Temperature:MAX \
LINE2:temp#0000FF:"Indoor temp\t" \
GPRINT:temp:LAST:"Cur\:%5.2lf C\t" \
GPRINT:temp:AVERAGE:"Avg\:%5.2lf C\t" \
GPRINT:temp:MAX:"Max\:%5.2lf C\t" \
GPRINT:temp:MIN:"Min\:%5.2lf C\n" \
DEF:rh=env.rrd:RelativeHumidity:MAX \
LINE2:rh#00FF00:"RH%\t\t" \
GPRINT:rh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:rh:MIN:"Min\:%5.2lf%%\n" \
DEF:otemp=weather.rrd:Temperature:MAX \
LINE3:otemp#000000:"Outdoor temp\t" \
GPRINT:otemp:LAST:"Cur\:%5.2lfC\t" \
GPRINT:otemp:AVERAGE:"Avg\:%5.2lfC\t" \
GPRINT:otemp:MAX:"Max\:%5.2lfC\t" \
GPRINT:otemp:MIN:"Min\:%5.2lfC\n"

cp *.png /var/www/public/
