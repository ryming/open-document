
# Tomcat安装和配置

首先需要下载相关的 tomcat 程序安装包并存放到 /usr/local/src/tomcat 下面。

下载参考:

    mkdir -p /usr/local/src/tomcat
    cd /usr/local/src/tomcat
    #6.0.45
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-6/v6.0.45/bin/apache-tomcat-6.0.45.tar.gz
    #7.0.69
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz
    #8.0.33
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz
    #8.0.35
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz
    #8.5.2
    wget http://mirrors.aliyun.com/apache/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz

## apache-tomcat-6.0.45.tar.gz

	mkdir -p /usr/local/etc/tomcat
	cd /usr/local/src/tomcat
	tar -zxvf apache-tomcat-6.0.45.tar.gz -C /usr/local/etc/tomcat
	cd /usr/local/etc/tomcat
	mv ./apache-tomcat-6.0.45 ./6.0.45

## apache-tomcat-7.0.68.tar.gz

	mkdir -p /usr/local/etc/tomcat
	cd /usr/local/src/tomcat
	tar -zxvf apache-tomcat-7.0.68.tar.gz -C /usr/local/etc/tomcat
	cd /usr/local/etc/tomcat
	mv ./apache-tomcat-7.0.68 ./7.0.68

## apache-tomcat-8.0.33.tar.gz

	mkdir -p /usr/local/etc/tomcat
	cd /usr/local/src/tomcat
	tar -zxvf apache-tomcat-8.0.33.tar.gz -C /usr/local/etc/tomcat
	cd /usr/local/etc/tomcat
	mv ./apache-tomcat-8.0.33 ./8.0.33

## apache-tomcat-8.0.35.tar.gz

	mkdir -p /usr/local/etc/tomcat
	cd /usr/local/src/tomcat
	tar -zxvf apache-tomcat-8.0.35.tar.gz -C /usr/local/etc/tomcat
	cd /usr/local/etc/tomcat
	mv ./apache-tomcat-8.0.35 ./8.0.35

## apache-tomcat-8.5.2.tar.gz

	mkdir -p /usr/local/etc/tomcat
	cd /usr/local/src/tomcat
	tar -zxvf apache-tomcat-8.5.2.tar.gz -C /usr/local/etc/tomcat
	cd /usr/local/etc/tomcat
	mv ./apache-tomcat-8.5.2 ./8.5.2

## 配置tomcat环境变量

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Tomcat环境变量
	export TOMCAT_6_0_45=/usr/local/etc/tomcat/6.0.45
	export TOMCAT_7_0_68=/usr/local/etc/tomcat/7.0.68
	export TOMCAT_8_0_33=/usr/local/etc/tomcat/8.0.33
	export TOMCAT_8_0_35=/usr/local/etc/tomcat/8.0.35
	export TOMCAT_8_5_2=/usr/local/etc/tomcat/8.5.2
	export TOMCAT_HOME=$TOMCAT_8_5_2
	export CATALINA_BASE=$TOMCAT_HOME
	export CATALINA_HOME=$CATALINA_BASE

保存退出

	source /etc/profile
	echo $CATALINA_HOME


### [可选]配置tomcat链接脚本

删除原先的脚本

	rm -rf /usr/local/bin/tomcat-startup
	rm -rf /usr/local/bin/tomcat-shutdown
	rm -rf /usr/local/bin/tomcat-version

创建新的脚本

	ln -s $CATALINA_HOME/bin/startup.sh /usr/local/bin/tomcat-startup
	ln -s $CATALINA_HOME/bin/shutdown.sh /usr/local/bin/tomcat-shutdown
	ln -s $CATALINA_HOME/bin/version.sh /usr/local/bin/tomcat-version

测试链接的脚本

	tomcat-version

