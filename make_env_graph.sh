#!/bin/bash
rrdtool graph env.png \
-w 800 -h 200 -a PNG \
--slope-mode \
--start -3600 --end now \
--font DEFAULT:9: \
--title "Home environment monitor" \
--watermark "`date`" \
--vertical-label "Temperature" \
--upper-limit 30 \
--lower-limit 10 \
--right-axis-label "RH%" \
--right-axis 2:0 \
--x-grid MINUTE:10:HOUR:1:MINUTE:120:0:%R \
--alt-y-grid --rigid \
DEF:Temperature=env.rrd:Temperature:MAX \
DEF:RelativeHumidity=env.rrd:RelativeHumidity:MAX \
LINE1:Temperature#0000FF:"C°" \
LINE2:RelativeHumidity#00FF00:"RH%\n" \
GPRINT:Temperature:LAST:"Cur\: %5.2lfC°\t" \
GPRINT:Temperature:AVERAGE:"Avg\: %5.2lfC°\t" \
GPRINT:Temperature:MAX:"Max\: %5.2lfC°\t" \
GPRINT:Temperature:MIN:"Min\: %5.2lfC°\n" \
GPRINT:RelativeHumidity:LAST:"Cur\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:AVERAGE:"Avg\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:MAX:"Max\: %5.2lf%%\t" \
GPRINT:RelativeHumidity:MIN:"Min\: %5.2lf%%\n" \

cp env.png /var/www/public/
