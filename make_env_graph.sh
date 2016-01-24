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
CDEF:n_rh=orh,var1,*,var2,/ \
LINE2:temp#0000FF:"Indoor temp\t\t\t" \
GPRINT:temp:LAST:"Cur\:%5.2lf C\t" \
GPRINT:temp:AVERAGE:"Avg\:%5.2lf C\t" \
GPRINT:temp:MAX:"Max\:%5.2lf C\t" \
GPRINT:temp:MIN:"Min\:%5.2lf C\n" \
LINE2:rh#00FF00:"Indoor RH%\t\t\t\t" \
GPRINT:rh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:rh:MIN:"Min\:%5.2lf%%\n" \
LINE3:n_rh#FF0000:"Theoretical Indoor RH%\t" \
GPRINT:n_rh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:n_rh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:n_rh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:n_rh:MIN:"Min\:%5.2lf%%\n" \
LINE3:otemp#000000:"Outdoor temp\t\t\t" \
GPRINT:otemp:LAST:"Cur\:%5.2lfC\t" \
GPRINT:otemp:AVERAGE:"Avg\:%5.2lfC\t" \
GPRINT:otemp:MAX:"Max\:%5.2lfC\t" \
GPRINT:otemp:MIN:"Min\:%5.2lfC\n" \
LINE3:orh#FF0000:"Outdoor RH%\t\t\t" \
GPRINT:orh:LAST:"Cur\:%5.2lf%%\t" \
GPRINT:orh:AVERAGE:"Avg\:%5.2lf%%\t" \
GPRINT:orh:MAX:"Max\:%5.2lf%%\t" \
GPRINT:orh:MIN:"Min\:%5.2lf%%\n"

cp *.png /var/www/public/
#CDEF:natural_rh=orh,0.42,*,exp,otemp,10,*,0.006235398,*,*,10,/,10,0.42,exp,temp,10,*,0.006235398,*,*,/,*
