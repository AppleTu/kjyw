#!/bin/bash
database_host=$1
database_username=$2
database_password=$3
database_port=$4
dbname=$5
tempalteId=$6
taskId=$7

cmd="select count(*) from mysql.proc where db='${dbname}' and type='PROCEDURE' and name='baselineCheck'"
cnt=$(mysql -h$database_host -u$database_username -p$database_password -P$database_port $dbname -s -e "${cmd}")
if [[ $cnt == 0 ]]; then
mysql -h$database_host -u$database_username -p$database_password -P$database_port <<EOF
	use $dbname
	source ./baselineCheck/func_get_split_string.sql
	source ./baselineCheck/func_get_split_string_total.sql
	source ./baselineCheck/func_build_qualification_filter.sql
	source ./baselineCheck/func_build_recommended_filter.sql
	source ./baselineCheck/baselineCheck.sql
	source ./baselineCheck/autoBaselineCheck.sql
EOF
fi
if [[ $tempalteId == '' ]]; then
	mysql -h$database_host -u$database_username -p$database_password -P$database_port $dbname -e "call autoBaselineCheck('$dbname')"
else
	mysql -h$database_host -u$database_username -p$database_password -P$database_port $dbname -e "call baselineCheck('$dbname','$tempalteId','$taskId')"
fi
