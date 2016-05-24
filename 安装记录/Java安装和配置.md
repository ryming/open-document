
# Java安装和配置

 首先需要下载相关的 JDK/JRE 等相关java程序安装包并存放到 /usr/local/src/java/jdk 下面。

## jdk-6u45-linux-x64.bin

	mkdir -p /usr/local/etc/java/jdk
	cd /usr/local/src/java/jdk
	chmod 777 jdk-6u45-linux-x64.bin
	./jdk-6u45-linux-x64.bin
	mkdir -p /usr/local/etc/java/jdk/1.6.0_45/
	mv ./jdk1.6.0_45/* /usr/local/etc/java/jdk/1.6.0_45/
	rm -rf ./jdk1.6.0_45/

## jdk-7u80-linux-x64.tar.gz

	mkdir -p /usr/local/etc/java/jdk
	cd /usr/local/src/java/jdk
	tar -zxvf jdk-7u80-linux-x64.tar.gz -C /usr/local/etc/java/jdk
	cd /usr/local/etc/java/jdk
	mv ./jdk1.7.0_80 ./1.7.0_80

## jdk-8u92-linux-x64.tar.gz

	mkdir -p /usr/local/etc/java/jdk
	cd /usr/local/src/java/jdk
	tar -zxvf jdk-8u92-linux-x64.tar.gz -C /usr/local/etc/java/jdk
	cd /usr/local/etc/java/jdk
	mv ./jdk1.8.0_92 ./1.8.0_92

## 配置JDK环境变量

    vi /etc/profile

添加内容

	#Java环境变量
	export JDK_1_6_0_45=/usr/local/etc/java/jdk/1.6.0_45
	export JDK_1_7_0_80=/usr/local/etc/java/jdk/1.7.0_80
	export JDK_1_8_0_92=/usr/local/etc/java/jdk/1.8.0_92
	export JDK_6=$JDK_1_6_0_45
	export JDK_7=$JDK_1_7_0_80
	export JDK_8=$JDK_1_8_0_92
	export JAVA_6=$JDK_6
	export JAVA_7=$JDK_7
	export JAVA_8=$JDK_8
	export JAVA_HOME=$JAVA_8
	export JRE_HOME=$JAVA_HOME/jre
	export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
	#根据需求配置JVM优化参数
	export JAVA_OPTS="-server -Xms128m -Xmx2g -Xss256k -XX:NewSize=128m -XX:MaxNewSize=256m -XX:+UseConcMarkSweepGC"
	export PATH=$PATH:$JAVA_HOME/bin

保存退出

	source /etc/profile
	java -version
	echo $JAVA_OPTS