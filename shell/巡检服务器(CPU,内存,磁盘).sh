#!/bin/bash
# Function: Server inspection
# Author: James Suen
# 1. 判断CPU使用率是否大于8
CPU_ID=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) 
CPU_CORES=$(grep "cores" /proc/cpuinfo | sort | uniq | awk '{print $4}')
CPU_MODE=$(grep "model name" /proc/cpuinfo | sort | uniq | awk -F: '{print $2}')
CPU_US=`top -n 1 -b |  sed -e 's/ //g' | grep "Cpu(s):" | awk -F ":" '{print $2}'|awk -F "," '{print $1}' | awk -F "%" '{print $1}'|awk -F "us" '{print $1}'`
echo -e "\033[34m CPU 数量：$CPU_ID\033[0m"
echo -e "\033[34m CPU 核心：$CPU_CORES\033[0m"
echo -e "\033[34m CPU 型号：$CPU_MODE\033[0m"
if [ `expr $CPU_US \> 8.0` -gt 0 ];then
    echo 'CPU有使用率不合规'
    echo -e "\033[34m CPU 使用率：$CPU_US\033[0m"
else
    echo 'CPU有使用率合规'
    echo -e "\033[34m CPU 使用率：$CPU_US\033[0m"
fi

# 2. 查看内存
MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}') # free 查看内存的命令
MEM_FREE=$(free -m | grep Mem | awk '{print $7}')
echo -e "\033[34m 内存总容量：${MEM_TOTAL}MB\033[0m"
echo -e "\033[34m 剩余内存容量：${MEM_FREE}MB\033[0m"
# 查看磁盘大小
DISK_SIZE=0                                                              # 初始化磁盘大小为0
SWAP_SIZE=$(free | grep Swap | awk '{print $2}')                         # 交换分区大小
PARTITION_SIZE=($(df -T | sed 1d | egrep -v "tmpfs" | awk '{print $3}')) # 以元组形式显示硬盘大小
for ((i = 0; i < $(# 计算磁盘大小
    echo ${#PARTITION_SIZE[*]}
); i++)); do
    DISK_SIZE=$(expr $DISK_SIZE + ${PARTITION_SIZE[$i]})
done
((DISK_SIZE = \($DISK_SIZE + $SWAP_SIZE\) / 1024 / 1024)) # 单位换算

DISK_FREE=0                                                              # 初始化空闲磁盘大小为0
SWAP_FREE=$(free | grep Swap | awk '{print $4}')                         # 空闲交换分区大小
PARTITION_FREE=($(df -T | sed 1d | egrep -v "tmpfs" | awk '{print $5}')) # 以元组形式显示空闲硬盘大小
for ((i = 0; i < $(# 计算空闲磁盘大小
    echo ${#PARTITION_SIZE[*]}
); i++)); do
    DISK_FREE=$(expr $DISK_FREE + ${PARTITION_FREE[$i]})
done
((DISK_FREE = \($DISK_FREE + $SWAP_FREE\) / 1024 / 1024)) # 单位换算

echo -e "\033[34m 磁盘总容量：${DISK_SIZE}GB\033[0m"
echo -e "\033[34m 磁盘剩余容量：${DISK_FREE}GB\033[0m"

