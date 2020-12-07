#!/bin/bash
############################
#2020-03-05                #
#auto config tomcat web    #
#author zcoder             #
############################
#JDK Variable
JDK_Ver="1.8.0_131"
JDK_Dir="/usr/java"
JDK_Soft="jdk${JDK_Ver}.tar.gz"
JDK_Src=$(echo $JDK_Soft|sed 's/.tar.gz//g')
#Tomcat Web Variable
Tomcat_Ver1="8.5.51"
Tomcat_Ver2="tomcat-$(echo $Tomcat_Ver1|awk -F"." '{print $1}')"
Tomcat_Vhost="$1"
Tomcat_Dir="/usr/local/${Tomcat_Ver2}_${Tomcat_Vhost}"
Tomcat_Soft="apache-tomcat-${Tomcat_Ver1}.tar.gz"
Tomcat_Src=$(echo $Tomcat_Soft|sed 's/.tar.gz//g')

#Judge user parameters
if [ $# -eq 0 ]; then
	echo -e "\033[32m------------------------------\033[0m"
	echo -e "\033[32mUsage:{/bin/bash $0 WebName}\033[0m"
	echo -e "\033[32m------------------------------\033[0m"
	exit 2
fi

#Stop firewalld/selinux(Interactive)
while :
do
	read -p "Whether to turn off the firewall and selinux,input [yes/no]: " turn
	case "$turn" in
	Y|YES|Yes|y|yes|yES|YEs|yEs|YeS)
		systemctl stop firewalld.service;systemctl disable firewalld.service
		setenforce 0;sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config
		echo -e '\033[32;40;1mTurn off the firewall and selinux successful!\033[0m'
		break
		;;
	N|NO|No|n|no|nO)
		echo -e '\033[32;40;1mNothing to do!\033[0m'
		break
		;;
	"")
		echo -e '\033[31;40;1mTyping error, please try again!\033[0m'
		;;
	*)
		echo -e '\033[31;40;1mTyping error, please try again!\033[0m'
		;;
	esac
done

#Install commond package
Check_num1=$(rpm -qa net-tools wget |grep -wcE "net-tools|wget")
if [ $Check_num1 -lt 2 ]; then
	yum install -y net-tools wget
fi

#Install Tomcat package if the current directory does not have Tomcat_Soft package
if [ ! -e $Tomcat_Soft ]; then
	wget http://mirror.bit.edu.cn/apache/tomcat/$Tomcat_Ver2/v$Tomcat_Ver1/bin/$Tomcat_Soft
fi

#Install JDK
JAVA_Work=$JDK_Dir/$JDK_Src
$JAVA_HOME/bin/java -version
if [ $? -ne 0 ]; then
	mkdir -p $JDK_Dir
	tar -zxf $JDK_Soft -C $JDK_Dir
	cat >> /etc/profile <<-EOF
	export JAVA_HOME=$JAVA_Work
	export CLASSPATH=\$CLASSPATH:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib
	EOF
	source /etc/profile
	$JAVA_HOME/bin/java -version
fi


#Install multiple instantiation Tomcat Web
for Tomcat_Vhost in $(echo $Tomcat_Vhost)
do
	#Find http port
	Max_Port=$(for i in `find /usr/local/ -name server.xml`; do grep "port" $i| grep -v "\!"; done| sed 's/ /\n/g'| grep "port="| sed 's/"//g;s/port=//g'| grep -vE "8080|8443"| sort -n| tail -1)
	if [ -z $Max_Port ]; then
		mkdir -p $Tomcat_Dir
		tar -zxf $Tomcat_Soft -C $Tomcat_Dir &> /dev/null
		$Tomcat_Dir/$Tomcat_Src/bin/startup.sh
		netstat -tnlp|grep -wE "8005|8080|8009"
	else	
		#Setting shutdown port | http port | https port
		Port1=$(expr $Max_Port - 2000 + 1)
		Port2=$(expr $Max_Port - 1000 + 1)
		Port3=$(expr $Max_Port + 1)
		
			#Install Tomcat web
			mkdir -p $Tomcat_Dir
			tar -zxf $Tomcat_Soft -C $Tomcat_Dir &> /dev/null
		
		#Replace shutdown port | http port | https port
		sed -i "s/8005/${Port1}/g" $Tomcat_Dir/$Tomcat_Src/conf/server.xml
		sed -i "s/8080/${Port2}/g" $Tomcat_Dir/$Tomcat_Src/conf/server.xml
		sed -i "s/8009/${Port3}/g" $Tomcat_Dir/$Tomcat_Src/conf/server.xml
			$Tomcat_Dir/$Tomcat_Src/bin/startup.sh 

			#Wait 10s and watch Tomcat server port
			sleep 10s
			netstat -tnlp|grep -wE "${Port1}|${Port2}|${Port3}"
	fi
done

