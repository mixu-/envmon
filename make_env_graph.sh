#!/bin/bash
rrdtool graph env.png \
-w 800 -h 250 -a PNG \
--start -84600 --end now \
--font DEFAULT:9: \
--title "Home environment monitor" \
--watermark "`date`" \
--vertical-label "Temp C" \
--right-axis-label "RH%" \
--right-axis 0.5:0 \
--x-grid MINUTE:10:HOUR:1:MINUTE:120:0:%R \
--alt-y-grid \
--rigid \
DEF:Temperature=env.rrd:Temperature:AVERAGE \
LINE3:Temperature#0000FF:"Indoor temp, C\t" \
GPRINT:Temperature:LAST:"Cur\: %5.2lfC\t" \
GPRINT:Temperature:AVERAGE:"Avg\: %5.2lfC\t" \
GPRINT:Temperature:MAX:"Max\: %5.2lfC\t" \
GPRINT:Temperature:MIN:"Min\: %5.2lfC\n" \
DEF:RelativeHumidity=env.rrd:RelativeHumidity:AVERAGE \
LINE3:RelativeHumidity#00FF00:"RH%\t" \
GPRINT:RelativeHumidity:LAST:"Cur\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:AVERAGE:"Avg\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:MAX:"Max\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:MIN:"Min\: %5.2lf%%\n" \
DEF:OutdoorTemp=weather.rrd:Temperature:AVERAGE \
LINE3:OutdoorTemp#000000:"Outdoor temp, C\t" \
GPRINT:OutdoorTemp:LAST:"Cur\: %5.2lfC\t" \
GPRINT:OutdoorTemp:AVERAGE:"Avg\: %5.2lfC\t" \
GPRINT:OutdoorTemp:MAX:"Max\: %5.2lfC\t" \
GPRINT:OutdoorTemp:MIN:"Min\: %5.2lfC\n" \


cp env.png /var/www/public/
