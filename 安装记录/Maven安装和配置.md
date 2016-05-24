
# Maven安装和配置

首先需要下载相关的 maven 程序安装包并存放到 /usr/local/src/maven 下面。

下载参考:

    mkdir -p /usr/local/src/maven
    cd /usr/local/src/maven
    #3.0.5
    wget http://mirrors.aliyun.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
    #3.2.5
    wget http://mirrors.aliyun.com/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
    #3.3.9
    wget http://mirrors.aliyun.com/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

## apache-maven-3.0.5-bin.tar.gz

	mkdir -p /usr/local/etc/maven
	cd /usr/local/src/maven
	tar -zxvf apache-maven-3.0.5-bin.tar.gz -C /usr/local/etc/maven
	cd /usr/local/etc/maven
	mv ./apache-maven-3.0.5 ./3.0.5

## apache-maven-3.2.5-bin.tar.gz

	mkdir -p /usr/local/etc/maven
	cd /usr/local/src/maven
	tar -zxvf apache-maven-3.2.5-bin.tar.gz -C /usr/local/etc/maven
	cd /usr/local/etc/maven
	mv ./apache-maven-3.2.5 ./3.2.5

## apache-maven-3.3.9-bin.tar.gz

	mkdir -p /usr/local/etc/maven
	cd /usr/local/src/maven
	tar -zxvf apache-maven-3.3.9-bin.tar.gz -C /usr/local/etc/maven
	cd /usr/local/etc/maven
	mv ./apache-maven-3.3.9 ./3.3.9

## 配置maven环境变量

创建maven数据值目录

	mkdir -p /usr/local/data/maven

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Maven环境变量
	export MAVEN_3_0_5=/usr/local/etc/maven/3.0.5
	export MAVEN_3_2_5=/usr/local/etc/maven/3.2.5
	export MAVEN_3_3_9=/usr/local/etc/maven/3.3.9
	export M2_HOME=$MAVEN_3_0_5
	export MAVEN_HOME=$M2_HOME
	export PATH=$PATH:$MAVEN_HOME/bin
	#Maven值环境变量
	export MAVEN_DATA_PATH=/usr/local/data/maven

保存退出

	source /etc/profile
	mvn -v