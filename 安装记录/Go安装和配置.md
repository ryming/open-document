
# Go安装和配置

首先需要下载相关的 go 程序安装包并存放到 /usr/local/src/go 下面。

下载参考:

    mkdir -p /usr/local/src/go
    cd /usr/local/src/go
    #1.6.2
    wget http://www.golangtc.com/static/go/1.6.2/go1.6.2.linux-amd64.tar.gz
    #1.5.3
    wget http://www.golangtc.com/static/go/1.5.3/go1.5.3.linux-amd64.tar.gz
    #1.5.4
    wget http://www.golangtc.com/static/go/1.5.4/go1.5.4.linux-amd64.tar.gz
    #1.4.2
    wget http://www.golangtc.com/static/go/1.4.2/go1.4.2.linux-amd64.tar.gz

## go1.4.2.linux-amd64.tar.gz

	mkdir -p /usr/local/etc/go
	cd /usr/local/src/go
	tar -zxvf go1.4.2.linux-amd64.tar.gz -C /usr/local/etc/go
	cd /usr/local/etc/go
	mv ./go ./1.4.2

## go1.5.3.linux-amd64.tar.gz

	mkdir -p /usr/local/etc/go
	cd /usr/local/src/go
	tar -zxvf go1.5.3.linux-amd64.tar.gz -C /usr/local/etc/go
	cd /usr/local/etc/go
	mv ./go ./1.5.3

## go1.5.4.linux-amd64.tar.gz

	mkdir -p /usr/local/etc/go
	cd /usr/local/src/go
	tar -zxvf go1.5.4.linux-amd64.tar.gz -C /usr/local/etc/go
	cd /usr/local/etc/go
	mv ./go ./1.5.4

## go1.6.2.linux-amd64.tar.gz

	mkdir -p /usr/local/etc/go
	cd /usr/local/src/go
	tar -zxvf go1.6.2.linux-amd64.tar.gz -C /usr/local/etc/go
	cd /usr/local/etc/go
	mv ./go ./1.6.2

## 配置go环境变量

创建go数据值目录

	mkdir -p /usr/local/data/go

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#Go环境变量
	export GO_1_4_2=/usr/local/etc/go/1.4.2
	export GO_1_5_3=/usr/local/etc/go/1.5.3
	export GO_1_5_4=/usr/local/etc/go/1.5.4
	export GO_1_6_2=/usr/local/etc/go/1.6.2
	export GOROOT=$GO_1_6_2
	export PATH=$PATH:$GOROOT/bin
	#Go数据值变量
	export GOPATH=/usr/local/data/go

保存退出

	source /etc/profile
	go version
	go env