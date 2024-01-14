#!/bin/bash

/bin/rm -f /tmp/$2.sample /tmp/$2.sample.out
timeout $1s bash -c "while true ; do ps -Ao pid,pcpu | grep $(jps|grep Launcher|awk '{ print $1 }') | cut -f5 -d' ' >> /tmp/$2.sample ; sleep 3 ; done "

spark < /tmp/$2.sample > /tmp/$2.sample.out
cat /tmp/$2.sample.out
