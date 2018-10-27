#!/bin/sh
#应用信息
API_NAME=api-web-1.0.0-SNAPSHOT
JAR_NAME=$API_NAME\.jar

#JVM参数
#JAVA_HOME='/usr/local/java/jdk1.8.0_181'
#CATALINA_HOME='/opt/tomcat_api'
#export JAVA_HOME CATALINA_HOME
#JAVA_OPTS="-Dname=$SpringBoot  -Duser.timezone=Asia/Shanghai -XX:PermSize=512M -XX:MaxPermSize=1024m -Xms2048m -Xmx2048m -Djava.awt.headless=true -Ddruid.registerToSysProperty=true"
#150JVM参数

export JAVA_HOME=/usr/local/java/jdk1.8.0_181
export CATALINA_HOME=/usr/local/java/project/api-web/
export LOG_HOME=/usr/local/java/project/api-web/logs/log.out
export JRE_HOME=$JAVA_HOME/jre
export JAVA_HOME CATALINA_HOME
#JMX监控需用到
JMX="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1091 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
#JVM参数
JAVA_OPTS="-Dname=$JAR_NAME -Duser.timezone=Asia/Shanghai -XX:PermSize=512M -XX:MaxPermSize=1024m -Xms2048m -Xmx2048m -Djava.awt.headless=true -Ddruid.registerToSysProperty=true -Dfile.encoding=UTF-8"
#PID  代表是PID文件
PID=$CATALINA_HOME\bin/$API_NAME\.pid
#使用说明，用来提示输入参数
usage() {
    echo "Usage: sh 执行脚本.sh [start|stop|restart|status]"
    exit 1
}
#检查程序是否在运行
is_exist(){
  pid=`ps -ef|grep $JAR_NAME|grep -v grep|awk '{print $2}' `
  #如果不存在返回1，存在返回0     
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}
#启动方法
start(){
  is_exist
  if [ $? -eq "0" ]; then 
    echo ">>> ${JAR_NAME} is already running PID=${pid} <<<" 
  else 
    nohup $JRE_HOME/bin/java -jar $JAVA_OPTS $CATALINA_HOME\lib/$JAR_NAME > $LOG_HOME 2>&1 &
    echo $! > $PID
    echo ">>> start $JAR_NAME successed PID=$! <<<" 
   fi
}
#停止方法
stop(){
  is_exist
  if [ $? -eq "0" ]; then 
    echo ">>> api PID = $pid begin kill -9 $pid  <<<"
    kill -9  $pid
    sleep 2
    echo ">>> $JAR_NAME process stopped <<<"  
  else
    echo ">>> ${JAR_NAME} is not running <<<"
  fi  
}
#输出运行状态
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo ">>> ${JAR_NAME} is running PID is ${pid} <<<"
  else
    echo ">>> ${JAR_NAME} is not running <<<"
  fi
}
#重启
restart(){
  stop
  sleep 3
  start
}
#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac
exit 0