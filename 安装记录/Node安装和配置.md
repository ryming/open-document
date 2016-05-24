
# Node安装和配置

首先需要下载相关的 node 程序安装包并存放到 /usr/local/src/node 下面。

下载参考:

    mkdir -p /usr/local/src/node
    cd /usr/local/src/node
    #6.1.0
    wget https://nodejs.org/dist/v6.1.0/node-v6.1.0-linux-x64.tar.xz
    #6.2.0
    wget https://nodejs.org/dist/v6.2.0/node-v6.2.0-linux-x64.tar.xz


## node-v6.1.0-linux-x64.tar.xz

	mkdir -p /usr/local/etc/node
	cd /usr/local/src/node
	tar -xvf node-v6.1.0-linux-x64.tar.xz -C /usr/local/etc/node
	cd /usr/local/etc/node
	mv ./node-v6.1.0-linux-x64 ./6.1.0

## node-v6.2.0-linux-x64.tar.xz

	mkdir -p /usr/local/etc/node
	cd /usr/local/src/node
	tar -xvf node-v6.2.0-linux-x64.tar.xz -C /usr/local/etc/node
	cd /usr/local/etc/node
	mv ./node-v6.2.0-linux-x64 ./6.2.0

## 配置node环境变量

创建npm数据值目录

	mkdir -p /usr/local/data/npm

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Node环境变量
	export NODE_6_1_0=/usr/local/etc/node/6.1.0
	export NODE_6_2_0=/usr/local/etc/node/6.2.0
	export NODE_HOME=$NODE_6_2_0
	export PATH=$PATH:$NODE_HOME/bin
	#Npm值环境变量
	export NPM_DATA_PATH=/usr/local/data/npm
	export PATH=$PATH:$NPM_DATA_PATH/bin

保存退出

	source /etc/profile
	node -v
	npm -v

## Npm配置

创建npm数据值和缓存目录

	mkdir -p /usr/local/data/npm
	mkdir -p /usr/local/data/npm-cache

Liunx :
	
	#可选配置指定的NPM注册地址
	npm config set registry http://repo.irgba.com/npm/


	npm config set prefix /usr/local/data/npm
	npm config set cache /usr/local/data/npm-cache
	npm config set email lanmingle@icloud.com

