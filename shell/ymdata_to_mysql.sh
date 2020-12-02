#!/bin/bash 
#Author:	Torrey
#Date:		2019/11/11
#Describe	Insert Data TO Mysql

database_host=xxxx
database_username='xxxx'
database_password='xxxx'
daname="xxxxxx"

#dateId=`date +%Y%m%d -d '-1 hours' `
dateId=`date +%Y%m%d`
day_hour_common=`date +%Y%m%d%H -d '-1 hours'`
datapath="/u01/ymdata/"$dateId

t_dev="t_dev_"$day_hour_common
t_device_em="t_device_em_"$day_hour_common
ym_auto_lock_log="ym_auto_lock_log_"$day_hour_common
ym_dev_fault="ym_dev_fault_"$day_hour_common
ym_device_log="ym_device_log_"$day_hour_common
ym_finance_record="ym_finance_record_"$day_hour_common
ym_order="ym_order_"$day_hour_common
ym_user="ym_user_"$day_hour_common

localdir=`ls $datapath`


for file in $localdir
do
if [[ $file == $t_dev* ]]
then
    echo "t_dev  type file .........1"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    truncate table t_dev;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE t_dev  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $t_device_em* ]]
then
    echo "t_device_em  type file..........2"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    truncate table t_device_em;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE t_device_em  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_auto_lock_log* ]]
then
    echo "ym_auto_lock_log  type file........3"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_auto_lock_log  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_dev_fault* ]]
then
    echo "ym_dev_fault  type file................4"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_dev_fault  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_device_log* ]]
then
    echo "ym_device_log  type file...................5"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_device_log  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_finance_record* ]]
then
    echo "ym_finance_record  type file...................6"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_finance_record  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_order* ]]
then
    echo "ym_order  type file................................7"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_order  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF

elif [[ $file == $ym_user* ]]
then
    echo "ym_user  type file.....................................8"
    echo $file
    mysql -h$database_host -u$database_username -p$database_password <<EOF
    use charging_analyze2;
    LOAD DATA LOCAL INFILE '$datapath/$file' INTO TABLE ym_user  charset utf8 FIELDS TERMINATED BY ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;
EOF
# else
#     echo "没有符合的条件的文件需要入库"
fi
done