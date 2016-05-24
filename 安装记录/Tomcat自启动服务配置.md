
# Tomcat自启动服务配置

配置tomcat自启动服务，需要jsvc支持，还有可能根据防火墙配置相关端口转发。

## 防火墙配置[可选]

[可选]安装防火墙
	
	yum -y install firewalld

[可选]启动防火墙
	
	systemctl start firewalld

[可选]自启动防火墙
	
	systemctl enable firewalld

[可选]为防火墙添加HTTP,HTTPS访问权限

	firewall-cmd --permanent --add-service=http
	firewall-cmd --permanent --add-service=https
	firewall-cmd --reload
	firewall-cmd --list-all

[可选]配置端口转发

	firewall-cmd --permanent --add-forward-port=port=80:proto=tcp:toport=8080
	firewall-cmd --reload
	firewall-cmd --list-all

[可选]删除不使用的服务
	
	firewall-cmd --permanent --remove-service=dhcpv6-client
	firewall-cmd --reload
	firewall-cmd --list-all

## 编译与安装jsvc

安装相关编译依赖库

	yum install gcc\* glibc\* glibc-\*

编译与安装

	cd $CATALINA_HOME/bin
	tar xvfz commons-daemon-native.tar.gz
	cd commons-daemon-1.0.15-native-src/unix
	./configure
	make
	cp jsvc ../..
	cd ../..
	./jsvc --help

创建tomcat用户与授权

	useradd tomcat -M -d /home/tomcat -s /bin/false -r
	id tomcat
	
授权tomcat运行相关目录

	chown -R tomcat:tomcat $TOMCAT_HOME

## 配置自启动服务

备份默认配置

	cd $TOMCAT_HOME/bin
	cp ./daemon.sh ./daemon.sh.backup

编辑daemon.sh文件，在开始增加一行，支持chkconfig，增加后的样子如下：

	#!/bin/sh
	#
	# chkconfig: - 80 20
	#

编辑daemon.sh文件，添加相关运行环境变量

	JAVA_HOME="/usr/local/etc/java/jdk/1.8.0_92"
	JAVA_OPTS="-server -Xms128m -Xmx2g -Xss256k -XX:NewSize=128m -XX:MaxNewSize=256m -XX:+UseConcMarkSweepGC"
	CLASSPATH="$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar"
	TOMCAT_USER="tomcat"

编辑完成后，删除在编辑可能字符错误

	sed -i 's/\r$//' $TOMCAT_HOME/bin/daemon.sh
	cat -A $TOMCAT_HOME/bin/daemon.sh

添加链接到启动加载中

	ln -s $TOMCAT_HOME/bin/daemon.sh /etc/init.d/tomcat

设置自启动

	chkconfig --add tomcat
	chkconfig --level 2345 tomcat on

配置测试启动

	service tomcat start
	ps -ef | grep tomcat

配置测试停止

	service tomcat stop
	ps -ef | grep tomcat

重启配置测试

	reboot


## daemon.sh自启动服务脚本

	#!/bin/sh
	#
	# chkconfig: - 80 20
	#
	
	# Licensed to the Apache Software Foundation (ASF) under one or more
	# contributor license agreements.  See the NOTICE file distributed with
	# this work for additional information regarding copyright ownership.
	# The ASF licenses this file to You under the Apache License, Version 2.0
	# (the "License"); you may not use this file except in compliance with
	# the License.  You may obtain a copy of the License at
	#
	#     http://www.apache.org/licenses/LICENSE-2.0
	#
	# Unless required by applicable law or agreed to in writing, software
	# distributed under the License is distributed on an "AS IS" BASIS,
	# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	# See the License for the specific language governing permissions and
	# limitations under the License.
	#
	# -----------------------------------------------------------------------------
	# Commons Daemon wrapper script.
	# -----------------------------------------------------------------------------
	#
	# resolve links - $0 may be a softlink
	ARG0="$0"
	while [ -h "$ARG0" ]; do
	  ls=`ls -ld "$ARG0"`
	  link=`expr "$ls" : '.*-> \(.*\)$'`
	  if expr "$link" : '/.*' > /dev/null; then
	    ARG0="$link"
	  else
	    ARG0="`dirname $ARG0`/$link"
	  fi
	done
	DIRNAME="`dirname $ARG0`"
	PROGRAM="`basename $ARG0`"
	while [ ".$1" != . ]
	do
	  case "$1" in
	    --java-home )
	        JAVA_HOME="$2"
	        shift; shift;
	        continue
	    ;;
	    --catalina-home )
	        CATALINA_HOME="$2"
	        shift; shift;
	        continue
	    ;;
	    --catalina-base )
	        CATALINA_BASE="$2"
	        shift; shift;
	        continue
	    ;;
	    --catalina-pid )
	        CATALINA_PID="$2"
	        shift; shift;
	        continue
	    ;;
	    --tomcat-user )
	        TOMCAT_USER="$2"
	        shift; shift;
	        continue
	    ;;
	    --service-start-wait-time )
	        SERVICE_START_WAIT_TIME="$2"
	        shift; shift;
	        continue
	    ;;
	    * )
	        break
	    ;;
	  esac
	done
	# OS specific support (must be 'true' or 'false').
	cygwin=false;
	darwin=false;
	case "`uname`" in
	    CYGWIN*)
	        cygwin=true
	        ;;
	    Darwin*)
	        darwin=true
	        ;;
	esac
	
	# Use the maximum available, or set MAX_FD != -1 to use that
	test ".$MAX_FD" = . && MAX_FD="maximum"
	# Setup parameters for running the jsvc
	#
	test ".$TOMCAT_USER" = . && TOMCAT_USER=tomcat
	# Set JAVA_HOME to working JDK or JRE
	# JAVA_HOME=/opt/jdk-1.6.0.22
	# If not set we'll try to guess the JAVA_HOME
	# from java binary if on the PATH
	#
	if [ -z "$JAVA_HOME" ]; then
	    JAVA_BIN="`which java 2>/dev/null || type java 2>&1`"
	    test -x "$JAVA_BIN" && JAVA_HOME="`dirname $JAVA_BIN`"
	    test ".$JAVA_HOME" != . && JAVA_HOME=`cd "$JAVA_HOME/.." >/dev/null; pwd`
	else
	    JAVA_BIN="$JAVA_HOME/bin/java"
	fi
	
	# Only set CATALINA_HOME if not already set
	test ".$CATALINA_HOME" = . && CATALINA_HOME=`cd "$DIRNAME/.." >/dev/null; pwd`
	test ".$CATALINA_BASE" = . && CATALINA_BASE="$CATALINA_HOME"
	test ".$CATALINA_MAIN" = . && CATALINA_MAIN=org.apache.catalina.startup.Bootstrap
	# If not explicitly set, look for jsvc in CATALINA_BASE first then CATALINA_HOME
	if [ -z "$JSVC" ]; then
	    JSVC="$CATALINA_BASE/bin/jsvc"
	    if [ ! -x "$JSVC" ]; then
	        JSVC="$CATALINA_HOME/bin/jsvc"
	    fi
	fi
	# Set the default service-start wait time if necessary
	test ".$SERVICE_START_WAIT_TIME" = . && SERVICE_START_WAIT_TIME=10
	
	# Ensure that any user defined CLASSPATH variables are not used on startup,
	# but allow them to be specified in setenv.sh, in rare case when it is needed.
	
	JAVA_HOME="/usr/local/etc/java/jdk/1.8.0_92"
	JAVA_OPTS="-server -Xms128m -Xmx2g -Xss256k -XX:NewSize=128m -XX:MaxNewSize=256m -XX:+UseConcMarkSweepGC"
	CLASSPATH="$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar"
	TOMCAT_USER="tomcat"
	
	if [ -r "$CATALINA_BASE/bin/setenv.sh" ]; then
	  . "$CATALINA_BASE/bin/setenv.sh"
	elif [ -r "$CATALINA_HOME/bin/setenv.sh" ]; then
	  . "$CATALINA_HOME/bin/setenv.sh"
	fi
	
	# Add on extra jar files to CLASSPATH
	test ".$CLASSPATH" != . && CLASSPATH="${CLASSPATH}:"
	CLASSPATH="$CLASSPATH$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/commons-daemon.jar"
	
	test ".$CATALINA_OUT" = . && CATALINA_OUT="$CATALINA_BASE/logs/catalina-daemon.out"
	test ".$CATALINA_TMP" = . && CATALINA_TMP="$CATALINA_BASE/temp"
	
	# Add tomcat-juli.jar to classpath
	# tomcat-juli.jar can be over-ridden per instance
	if [ -r "$CATALINA_BASE/bin/tomcat-juli.jar" ] ; then
	  CLASSPATH="$CLASSPATH:$CATALINA_BASE/bin/tomcat-juli.jar"
	else
	  CLASSPATH="$CLASSPATH:$CATALINA_HOME/bin/tomcat-juli.jar"
	fi
	# Set juli LogManager config file if it is present and an override has not been issued
	if [ -z "$LOGGING_CONFIG" ]; then
	  if [ -r "$CATALINA_BASE/conf/logging.properties" ]; then
	    LOGGING_CONFIG="-Djava.util.logging.config.file=$CATALINA_BASE/conf/logging.properties"
	  else
	    # Bugzilla 45585
	    LOGGING_CONFIG="-Dnop"
	  fi
	fi
	
	test ".$LOGGING_MANAGER" = . && LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
	JAVA_OPTS="$JAVA_OPTS $LOGGING_MANAGER"
	
	# Set -pidfile
	test ".$CATALINA_PID" = . && CATALINA_PID="$CATALINA_BASE/logs/catalina-daemon.pid"
	
	# Increase the maximum file descriptors if we can
	if [ "$cygwin" = "false" ]; then
	    MAX_FD_LIMIT=`ulimit -H -n`
	    if [ "$?" -eq 0 ]; then
	        # Darwin does not allow RLIMIT_INFINITY on file soft limit
	        if [ "$darwin" = "true" -a "$MAX_FD_LIMIT" = "unlimited" ]; then
	            MAX_FD_LIMIT=`/usr/sbin/sysctl -n kern.maxfilesperproc`
	        fi
	        test ".$MAX_FD" = ".maximum" && MAX_FD="$MAX_FD_LIMIT"
	        ulimit -n $MAX_FD
	        if [ "$?" -ne 0 ]; then
	            echo "$PROGRAM: Could not set maximum file descriptor limit: $MAX_FD"
	        fi
	    else
	        echo "$PROGRAM: Could not query system maximum file descriptor limit: $MAX_FD_LIMIT"
	    fi
	fi
	
	# ----- Execute The Requested Command -----------------------------------------
	case "$1" in
	    run     )
	      shift
	      "$JSVC" $* \
	      $JSVC_OPTS \
	      -java-home "$JAVA_HOME" \
	      -pidfile "$CATALINA_PID" \
	      -wait "$SERVICE_START_WAIT_TIME" \
	      -nodetach \
	      -outfile "&1" \
	      -errfile "&2" \
	      -classpath "$CLASSPATH" \
	      "$LOGGING_CONFIG" $JAVA_OPTS $CATALINA_OPTS \
	      -Dcatalina.base="$CATALINA_BASE" \
	      -Dcatalina.home="$CATALINA_HOME" \
	      -Djava.io.tmpdir="$CATALINA_TMP" \
	      $CATALINA_MAIN
	      exit $?
	    ;;
	    start   )
	      "$JSVC" $JSVC_OPTS \
	      -java-home "$JAVA_HOME" \
	      -user $TOMCAT_USER \
	      -pidfile "$CATALINA_PID" \
	      -wait "$SERVICE_START_WAIT_TIME" \
	      -outfile "$CATALINA_OUT" \
	      -errfile "&1" \
	      -classpath "$CLASSPATH" \
	      "$LOGGING_CONFIG" $JAVA_OPTS $CATALINA_OPTS \
	      -Dcatalina.base="$CATALINA_BASE" \
	      -Dcatalina.home="$CATALINA_HOME" \
	      -Djava.io.tmpdir="$CATALINA_TMP" \
	      $CATALINA_MAIN
	      exit $?
	    ;;
	    stop    )
	      "$JSVC" $JSVC_OPTS \
	      -stop \
	      -pidfile "$CATALINA_PID" \
	      -classpath "$CLASSPATH" \
	      -Dcatalina.base="$CATALINA_BASE" \
	      -Dcatalina.home="$CATALINA_HOME" \
	      -Djava.io.tmpdir="$CATALINA_TMP" \
	      $CATALINA_MAIN
	      exit $?
	    ;;
	    version  )
	      "$JSVC" \
	      -java-home "$JAVA_HOME" \
	      -pidfile "$CATALINA_PID" \
	      -classpath "$CLASSPATH" \
	      -errfile "&2" \
	      -version \
	      -check \
	      $CATALINA_MAIN
	      if [ "$?" = 0 ]; then
	        "$JAVA_BIN" \
	        -classpath "$CATALINA_HOME/lib/catalina.jar" \
	        org.apache.catalina.util.ServerInfo
	      fi
	      exit $?
	    ;;
	    *       )
	      echo "Unknown command: \`$1'"
	      echo "Usage: $PROGRAM ( commands ... )"
	      echo "commands:"
	      echo "  run               Start Tomcat without detaching from console"
	      echo "  start             Start Tomcat"
	      echo "  stop              Stop Tomcat"
	      echo "  version           What version of commons daemon and Tomcat"
	      echo "                    are you running?"
	      exit 1
	    ;;
	esac
