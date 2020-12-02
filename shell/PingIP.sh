#! /bin/bash
for i in `cat ip.txt`
do
	ping=`ping -c 1 $i|grep loss|awk '{print $6}'|awk -F "%" '{print $1}'`
	if [ $ping -eq 100  ];then
	echo ping $i fail
	else
	echo ping $i ok
	fi
done