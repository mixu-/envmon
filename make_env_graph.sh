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
DEF:temp=env.rrd:Temperature:AVERAGE \
DEF:orh=weather.rrd:RelativeHumidity:AVERAGE \
DEF:rh=env.rrd:RelativeHumidity:AVERAGE \
DEF:otemp=weather.rrd:Temperature:AVERAGE \
CDEF:var1=otemp,10,*,0.006235398,*,EXP \
CDEF:var2=temp,10,*,0.006235398,*,EXP \
CDEF:nat_rh=orh,var1,*,var2,/ \
CDEF:add_rh=rh,orh,var1,*,var2,/,- \
LINE2:temp#0000FF:"Indoor temp\t\t" \
GPRINT:temp:LAST:"Cur\:%5.2lf C\t" \
GPRINT:temp:AVERAGE:"Avg\:%5.2lf C\t" \
GPRINT:temp:MAX:"Max\:%5.2lf C\t" \
GPRINT:temp:MIN:"Min\:%5.2lf C\n" \
LINE2:rh#00FF00:"Indoor RH%\t\t" \
GPRINT:rh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:rh:MIN:"Min\:%5.2lf%%\n" \
LINE1:add_rh#AA1111:"Added humidity RH%\t" \
GPRINT:add_rh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:add_rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:add_rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:add_rh:MIN:"Min\:%5.2lf%%\n" \
LINE3:otemp#000000:"Outdoor temp\t\t" \
GPRINT:otemp:LAST:"Cur\:%5.2lfC\t" \
GPRINT:otemp:AVERAGE:"Avg\:%5.2lfC\t" \
GPRINT:otemp:MAX:"Max\:%5.2lfC\t" \
GPRINT:otemp:MIN:"Min\:%5.2lfC\n" \
GPRINT:orh:LAST:"Outdoor RH%%\t\tCur\:\t%5.2lf%%\t" \
GPRINT:orh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:orh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:orh:MIN:"Min\:%5.2lf%%\n" \
GPRINT:nat_rh:LAST:"Indoor Theor. RH%%\tCur\:\t%5.2lf%%\t" \
GPRINT:nat_rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:nat_rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:nat_rh:MIN:"Min\:%5.2lf%%\n"

cp *.png /var/www/public/
