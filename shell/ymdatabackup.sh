#!/bin/bash 

#stime=`date +%Y%m%d%H`
filedate=$(date -d " -1 hour"  +%Y%m%d%H)
dirtime=$(date -d "-1 hour" +%Y%m%d%H |awk '{print substr($1,1,8)}')
#dirtime=`date +%Y%m%d -d '-1 hours' `
echo $dirtime
remote=/home/cgdsj/ftp/cdz/${dirtime}
localdir=/u01/ymdata/$dirtime
if [ ! -d "$localdir" ]; then
    mkdir $localdir
fi

#文件名公共字段
datetime=${filedate}.csv
echo  $datetime
#文件名 
filename1=t_dev_${datetime}
filename2=ym_auto_lock_log_${datetime}
filename3=ym_dev_fault_${datetime}
filename4=ym_device_log_${datetime}
filename5=ym_finance_record_${datetime}
filename6=ym_user_${datetime}
filename7=t_device_em_${datetime}
filename8=ym_order_${datetime}

expect << EOF
set timeout 5
cd $localdir
spawn sftp xxxx@xxxxx
expect "password:"
send "xxxxx\r"    
expect "sfpt>\r"
send "cd $remote\r"
expect "sftp>\r"
send "get $filename1\r" 
sleep 3
expect "sftp>\r"
send "get $filename2\r" 
sleep 3
expect "sftp>\r"
send "get $filename3\r" 
sleep 3
expect "sftp>"
send "get $filename4\r" 
sleep 3
expect "sftp>"
send "get $filename5\r" 
sleep 3
expect "sftp>"
send "get $filename6\r" 
sleep 3
expect "sftp>"
send "get $filename7\r" 
sleep 3
send "get $filename8\r"
sleep 3
EOF
