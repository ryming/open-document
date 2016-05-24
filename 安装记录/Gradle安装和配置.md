
# Gradle安装和配置

首先需要下载相关的 gradle 程序安装包并存放到 /usr/local/src/gradle 下面。

下载参考:

    mkdir -p /usr/local/src/gradle
    cd /usr/local/src/gradle
    #2.7
    wget https://services.gradle.org/distributions/gradle-2.7-bin.zip
    #2.9
    wget https://services.gradle.org/distributions/gradle-2.9-bin.zip
    #2.12
    wget https://services.gradle.org/distributions/gradle-2.12-bin.zip

## gradle-2.7-bin.zip

	mkdir -p /usr/local/etc/gradle
	cd /usr/local/src/gradle
	unzip gradle-2.7-bin.zip -d /usr/local/etc/gradle
	cd /usr/local/etc/gradle
	mv ./gradle-2.7 ./2.7

## gradle-2.9-bin.zip

	mkdir -p /usr/local/etc/gradle
	cd /usr/local/src/gradle
	unzip gradle-2.9-bin.zip -d /usr/local/etc/gradle
	cd /usr/local/etc/gradle
	mv ./gradle-2.9 ./2.9

## gradle-2.12-bin.zip

	mkdir -p /usr/local/etc/gradle
	cd /usr/local/src/gradle
	unzip gradle-2.12-bin.zip -d /usr/local/etc/gradle
	cd /usr/local/etc/gradle
	mv ./gradle-2.12 ./2.12

## 配置gradle环境变量

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Gradle环境变量
	export GRADLE_2_7=/usr/local/etc/gradle/2.7
	export GRADLE_2_9=/usr/local/etc/gradle/2.9
	export GRADLE_2_12=/usr/local/etc/gradle/2.12
	export GRADLE_HOME=$GRADLE_2_7
	export PATH=$PATH:$GRADLE_HOME/bin

保存退出

	source /etc/profile
	gradle -v
