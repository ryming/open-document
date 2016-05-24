
# Groovy安装和配置

首先需要下载相关的 groovy 程序安装包并存放到 /usr/local/src/groovy 下面。

下载参考:

 [GitHub](https://github.com/apache/groovy/releases)

    mkdir -p /usr/local/src/groovy
    cd /usr/local/src/groovy
    wget https://github.com/apache/groovy/archive/GROOVY_2_4_6.zip

## apache-groovy-sdk-2.4.6.zip

	mkdir -p /usr/local/etc/groovy
	cd /usr/local/src/groovy
	unzip apache-groovy-sdk-2.4.6.zip -d /usr/local/etc/groovy
	cd /usr/local/etc/groovy
	mv ./groovy-2.4.6 ./2.4.6

## 配置groovy环境变量

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Groovy环境变量
	export GROOVY_2_4_6=/usr/local/etc/groovy/2.4.6
	export GROOVY_HOME=$GROOVY_2_4_6
	export PATH=$PATH:$GROOVY_HOME/bin

保存退出

	source /etc/profile
	groovy -version