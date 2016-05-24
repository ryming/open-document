
# Redis安装和配置

首先需要下载相关的 redis 程序安装包并存放到 /usr/local/src/redis 下面。

下载参考:

    mkdir -p /usr/local/src/redis
    cd /usr/local/src/redis
    #3.2.0
    wget http://download.redis.io/releases/redis-3.2.0.tar.gz

下载相关依赖库

	yum -y install gcc gcc-c++ 
	yum -y install tcl

可选

	yum -y install autoconf automake
	yum -y install openssl openssl-devel

## redis-3.2.0.tar.gz
	
	cd /usr/local/src/redis
	tar -zxvf redis-3.2.0.tar.gz
	cd ./redis-3.2.0
	mkdir /usr/local/etc/redis/3.2.0
	mkdir /usr/local/etc/redis/3.2.0/conf
	cp ./redis.conf /usr/local/etc/redis/3.2.0/conf/redis.conf
	cp ./sentinel.conf /usr/local/etc/redis/3.2.0/conf/sentinel.conf
	make MALLOC=libc && make test && make PREFIX=/usr/local/etc/redis/3.2.0 install

## 配置redis环境变量


编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Redis环境变量
	export REDIS_3_2_0=/usr/local/etc/redis/3.2.0
	export REDIS_HOME=$REDIS_3_2_0
	export PATH=$PATH:$REDIS_HOME/bin

保存退出

	source /etc/profile
	redis-cli -v

## 修改配置
	
添加相关数据和日记目录

	mkdir -p /usr/local/data/redis
	mkdir -p /var/log/redis	

在$REDIS_HOME/conf/redis.conf中修改其中参数
	
	daemonize yes
	
	logfile /var/log/redis/redis.log

	dir /usr/local/data/redis/

## 内核参数overcommit_memory 

	echo 1 > /proc/sys/vm/overcommit_memory
	echo "vm.overcommit_memory=1" > /etc/sysctl.conf
	sysctl -p
	echo 511 > /proc/sys/net/core/somaxconn
	echo never > /sys/kernel/mm/transparent_hugepage/enabled

## 测试

启动服务端

	redis-server $REDIS_HOME/conf/redis.conf
	ps -ef |grep redis

启动客户端

	redis-cli

测试数据
	
	keys *
	set key "hello world"
	get key

