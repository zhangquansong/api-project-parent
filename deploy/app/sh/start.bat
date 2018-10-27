echo off
set APP_NAME=api-web-1.0.0-SNAPSHOT.jar
:--server.port=8185
set DEBUG_OPTS=
if ""%1"" == ""debug"" (
  set DEBUG_OPTS= -Xloggc:../logs/gc.log -verbose:gc -XX:+PrintGCDetails -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=../logs 
  goto debug
)
set JMX_OPTS=
if ""%1"" == ""jmx"" (
  set JMX_OPTS= -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9888 -Dcom.sun.management.jmxremote.ssl=FALSE -Dcom.sun.management.jmxremote.authenticate=FALSE 
  goto jmx
)
echo "Starting the %APP_NAME%"
:#java -Xms512m -Xmx512m -server %DEBUG_OPTS% %JMX_OPTS% %CONFIG% -jar ../lib/%APP_NAME%
java -Xms512m -Xmx512m -server -jar %JMX_OPTS% ../lib/%APP_NAME%
goto end
:debug
echo "debug"
java -Xms512m -Xmx512m -server -jar ../lib/%APP_NAME%
goto end
:jmx
java -Xms512m -Xmx512m -server -jar ../lib/%APP_NAME%
goto end
:end
pause