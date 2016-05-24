
# MySQL安装和配置

首先需要下载相关的 mysql 程序安装包并存放到 /usr/local/src/mysql 下面。

# ----------------------------------- 华丽丽的分割线 -----------------------------------

## 安装 glibc 版本一些总结

修改默认配置文件位置，就算是怎么修改自启动还是不会生效，就算是修改了默认配置还是不会生效，所以只好按规定的路径来,另外默认配置还是删除好，centos7中默认存在着。

	/etc/my.cnf
	基本目录/my.cnf
	~/my.cnf
	自定义目录总是有问题，如：基本目录/conf/my.cnf

还有对应 SELiunx 一定需要先关闭后才安装，如果安装了，首先需要把初始化的数据库删除，不然会出现各种脚本启动不了的问题。

# ----------------------------------- 华丽丽的分割线 -----------------------------------

## 注意必须首先关闭 SELiunx 

很多都是默认开启的，由于授权或者一些不会使用 SELinux 会导致某些权限以及进程之间访问会存在一些问题，为了方便还是关闭 SELinux 。

参考链接
	
	http://bguncle.blog.51cto.com/3184079/957315
	http://roclinux.cn/?p=2264

首先查看现有的状态

	sestatus

如果输出结果存在

	SELinux status: enabled

人工修改 /etc/selinux/ 目录下面的 config 配置，然后重启 reboot

编辑文件

	vi /etc/selinux/config

修改内容
	
	#注释默认的配置
	#SELINUX=enforcing
	
	#禁用 SELinux , 下次启动自动生效
	SELINUX=disabled

重启
	
	reboot

对于 SELINUX 开启目前还没有解决方法，不懂这个 SELINUX  。

# ----------------------------------- 华丽丽的分割线 -----------------------------------

## mysql-5.7.12-linux-glibc2.5-x86_64.tar


删除默认可存在一些不需要的
	
	rm -rf /etc/my.cnf.d
	rm -rf /etc/my.cnf

下载相关glibc版本依赖
	
	yum -y install libaio

创建MySQL程序目录和数据目录
	
	#主程序目录
	mkdir -p /usr/local/etc/mysql/5.7.12
	#MySQL日记目录
	mkdir -p /usr/local/etc/mysql/5.7.12/logs
	#MySQL自启动目录
	mkdir -p /usr/local/etc/mysql/5.7.12/init.d
	#MySQL数据目录
	mkdir -p /usr/local/data/mysql/5.7.12

解压MySQL压缩包到指定目录

	cd /usr/local/src/mysql
	tar -xvf mysql-5.7.12-linux-glibc2.5-x86_64.tar
	tar -zxvf mysql-5.7.12-linux-glibc2.5-x86_64.tar.gz -C /usr/local/etc/mysql/5.7.12
	cd /usr/local/etc/mysql/5.7.12/mysql-5.7.12-linux-glibc2.5-x86_64
	mv * ../
	cd ../
	rm -rf mysql-5.7.12-linux-glibc2.5-x86_64/
	cd /usr/local/etc/mysql/5.7.12/bin
	ls

### 配置MySQL环境变量

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#MySQL环境变量
	export MYSQL_5_7_12=/usr/local/etc/mysql/5.7.12
	export MYSQL_HOME=$MYSQL_5_7_12
	export PATH=$PATH:$MYSQL_HOME/bin

	#MySQL数据变量
	export MYSQL_DATA_PATH=/usr/local/data/mysql/5.7.12

保存退出

	source /etc/profile
	echo $MYSQL_HOME
	echo $MYSQL_DATA_PATH

### 配置MySQL运行用户

添加mysql用户

	useradd mysql -M -d /home/mysql -s /bin/false -r
	id mysql

授权mysql运行相关目录
	
	chown -R mysql:mysql $MYSQL_HOME
	chown -R mysql:mysql $MYSQL_DATA_PATH

查看相关目录权限

	cd $MYSQL_HOME
	ll
	cd $MYSQL_DATA_PATH
	ll

### 安装MySQL数据库

	mysqld --initialize --user=mysql --basedir=$MYSQL_HOME --datadir=$MYSQL_DATA_PATH

人工记录初始化MySQL密码
	
	mysql_ssl_rsa_setup --user=mysql --basedir=$MYSQL_HOME --datadir=$MYSQL_DATA_PATH

一些网上找到的资料说明

<p>
	这里特别说明一下，根据官方文档说法，从 5.7.6 版本开始，MySQL 初始化使用 mysqld --initialize 命令，不再使用 mysql_install_db 命令了。但是官方文档给出的 mysqld --initialize 命令并没有给出 --basedir 以及 --datadir 参数，因为它默认使用 /etc/my.cnf 配置文件。有些 Linux 发行版在安装过程中可能会默认生成这个 mysql 配置文件并保存在 /etc 目录下，而默认配置文件中的 basedir、datadir 是被注释的，没有实际内容，这样 mysqld 实际上还是不知道当前的 basedir、datadir 具体是哪个目录。所以这里就通过命令行参数指定我们的自定义目录。包括 mysql_ssl_rsa_setup 命令也要指定 datadir 目录，因为数据库需要的密钥文件也都和数据文件保存在一起，都位于 datadir 目录内。
</p>

<p>
	先不慌启动数据库服务，这时还要创建 MySQL 服务的配置文件 my.cnf。这个文件可以从 $MYSQL_HOME/support-files 子目录下找到一个叫 my-default.cnf 的配置样例文件，然后复制一个出来，改名为 my.cnf 并放到 $MYSQL_HOME 下即可。根据 MySQL 的规则，它的配置文件必须以 my.cnf 命名，读取的顺序是先尝试读取 /etc/my.cnf，如果不存在则再读取 basedir 目录下的 my.cnf，如果系统环境变量没有 basedir，则尝试读取服务启动所在当前目录下的 my.cnf，这里就是$MYSQL_HOME/my.cnf 这种情况，如果还是不存在，则读取当前用户家目录下的 .mysql/my.cnf（需要看官方文档确认一下，记不清了）。所以，我们这里只需保证在 $MYSQL_HOME/mysql 下有一个 my.cnf
</p>

### 配置MySQL my.cnf 文件
	
	cp $MYSQL_HOME/support-files/my-default.cnf $MYSQL_HOME/my.cnf

一些简单的配置

	[client]

	socket = /usr/local/etc/mysql/5.7.12/mysql.sock

	[mysqld]

	basedir = /usr/local/etc/mysql/5.7.12

	datadir = /usr/local/data/mysql/5.7.12

	pid-file = /usr/local/etc/mysql/5.7.12/mysql.pid

	socket = /usr/local/etc/mysql/5.7.12/mysql.sock

	log-error = /usr/local/etc/mysql/5.7.12/logs/error.log

	user = mysql

	sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

	#详细查看 ： http://jingyan.baidu.com/article/95c9d20d582334ec4e7561cb.html
	early-plugin-load=""

### MySQL自启动服务配置

复制服务配置支持配置文件
	
	cp $MYSQL_HOME/support-files/mysql.server $MYSQL_HOME/init.d/mysql.server

人工修改 $MYSQL_HOME/bin/mysql.server 配置参数，创建MySQL服务连接


修改配置

	basedir=/usr/local/etc/mysql/5.7.12
	datadir=/usr/local/data/mysql/5.7.12
	
	lockdir=/usr/local/etc/mysql/5.7.12
	lock_file_path=$lockdir/mysql.lock
	
	mysqld_pid_file_path=/usr/local/etc/mysql/5.7.11/mysql.pid

	service_startup_timeout=1000

编辑完成后，删除在编辑可能字符错误

	sed -i 's/\r$//' $MYSQL_HOME/init.d/mysql.server
	cat -A $MYSQL_HOME/init.d/mysql.server

建立连接
	
	rm -rf /etc/rc.d/init.d/mysql
	ln -s $MYSQL_HOME/init.d/mysql.server /etc/rc.d/init.d/mysql

MySQL服务相关命令
	
	#查看MySQL服务状态
	service mysql status

	#停止运行MySQL服务
	service mysql stop

	#启动运行MySQL服务
	service mysql start

	#重启运行MySQL服务
	service mysql restart
	
	#重新加载MySQL服务
	service mysql reload

	#强制重新加载MySQL服务
	service mysql force-reload

查看MySQL运行进程

	ps -ef | grep mysql

添加MySQL自启动服务

	chkconfig --add mysql
	chkconfig --level 2345 mysql on

### 修改MySQL默认密码和开发远程访问

连接MySQL客户端

	$MYSQL_HOME/bin/mysql --defaults-file=$MYSQL_HOME/my.cnf --user=root -p

输入密码后并更改密码

	set password=password('5201314');

重新授权 root 账号，开放远程访问 MySQL 服务器

	grant all privileges on *.* to 'root'@'%' identified by '5201314' with grant option ;
	flush privileges;

查看授权情况

	use mysql;
	select host,user from user;

退出登录，再次登录测试
	
	$MYSQL_HOME/bin/mysql --defaults-file=$MYSQL_HOME/my.cnf --user=root --password=5201314



### 手动方式运行MySQL

	$MYSQL_HOME/bin/mysqld --defaults-file=$MYSQL_HOME/my.cnf &

查看启动的MySQL进程

	ps -ef | grep mysql	

### cnetos7 防火墙

添加MySQL服务

	firewall-cmd --permanent --add-service=mysql
	firewall-cmd --reload
	firewall-cmd --list-all


# ----------------------------------- 华丽丽的分割线 -----------------------------------

## mysql-5.7.11-linux-glibc2.5-x86_64.tar

删除默认可存在一些不需要的
	
	rm -rf /etc/my.cnf.d
	rm -rf /etc/my.cnf

下载相关glibc版本依赖
	
	yum -y install libaio

创建MySQL程序目录和数据目录
	
	#主程序目录
	mkdir -p /usr/local/etc/mysql/5.7.11
	#MySQL日记目录
	mkdir -p /usr/local/etc/mysql/5.7.11/logs
	#MySQL自启动目录
	mkdir -p /usr/local/etc/mysql/5.7.11/init.d
	#MySQL数据目录
	mkdir -p /usr/local/data/mysql/5.7.11

解压MySQL压缩包到指定目录

	cd /usr/local/src/mysql
	tar -xvf mysql-5.7.11-linux-glibc2.5-x86_64.tar
	tar -zxvf mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz -C /usr/local/etc/mysql/5.7.11
	cd /usr/local/etc/mysql/5.7.11/mysql-5.7.11-linux-glibc2.5-x86_64
	mv * ../
	cd ../
	rm -rf mysql-5.7.11-linux-glibc2.5-x86_64/
	cd /usr/local/etc/mysql/5.7.11/bin
	ls

### 配置MySQL环境变量

编辑全局环境变量配置

	vi /etc/profile

添加内容

	#MySQL环境变量
	export MYSQL_5_7_11=/usr/local/etc/mysql/5.7.11
	export MYSQL_HOME=$MYSQL_5_7_11
	export PATH=$PATH:$MYSQL_HOME/bin

	#MySQL数据变量
	export MYSQL_DATA_PATH=/usr/local/data/mysql/5.7.11

保存退出

	source /etc/profile
	echo $MYSQL_HOME
	echo $MYSQL_DATA_PATH

### 配置MySQL运行用户

添加mysql用户

	useradd mysql -M -d /home/mysql -s /bin/false -r
	id mysql

授权mysql运行相关目录
	
	chown -R mysql:mysql $MYSQL_HOME
	chown -R mysql:mysql $MYSQL_DATA_PATH

查看相关目录权限

	cd $MYSQL_HOME
	ll
	cd $MYSQL_DATA_PATH
	ll

### 安装MySQL数据库

	mysqld --initialize --user=mysql --basedir=$MYSQL_HOME --datadir=$MYSQL_DATA_PATH

人工记录初始化MySQL密码
	
	mysql_ssl_rsa_setup --user=mysql --basedir=$MYSQL_HOME --datadir=$MYSQL_DATA_PATH

一些网上找到的资料说明

<p>
	这里特别说明一下，根据官方文档说法，从 5.7.6 版本开始，MySQL 初始化使用 mysqld --initialize 命令，不再使用 mysql_install_db 命令了。但是官方文档给出的 mysqld --initialize 命令并没有给出 --basedir 以及 --datadir 参数，因为它默认使用 /etc/my.cnf 配置文件。有些 Linux 发行版在安装过程中可能会默认生成这个 mysql 配置文件并保存在 /etc 目录下，而默认配置文件中的 basedir、datadir 是被注释的，没有实际内容，这样 mysqld 实际上还是不知道当前的 basedir、datadir 具体是哪个目录。所以这里就通过命令行参数指定我们的自定义目录。包括 mysql_ssl_rsa_setup 命令也要指定 datadir 目录，因为数据库需要的密钥文件也都和数据文件保存在一起，都位于 datadir 目录内。
</p>

<p>
	先不慌启动数据库服务，这时还要创建 MySQL 服务的配置文件 my.cnf。这个文件可以从 $MYSQL_HOME/support-files 子目录下找到一个叫 my-default.cnf 的配置样例文件，然后复制一个出来，改名为 my.cnf 并放到 $MYSQL_HOME 下即可。根据 MySQL 的规则，它的配置文件必须以 my.cnf 命名，读取的顺序是先尝试读取 /etc/my.cnf，如果不存在则再读取 basedir 目录下的 my.cnf，如果系统环境变量没有 basedir，则尝试读取服务启动所在当前目录下的 my.cnf，这里就是$MYSQL_HOME/my.cnf 这种情况，如果还是不存在，则读取当前用户家目录下的 .mysql/my.cnf（需要看官方文档确认一下，记不清了）。所以，我们这里只需保证在 $MYSQL_HOME/mysql 下有一个 my.cnf
</p>

### 配置MySQL my.cnf 文件
	
	cp $MYSQL_HOME/support-files/my-default.cnf $MYSQL_HOME/my.cnf

一些简单的配置

	[client]

	socket = /usr/local/etc/mysql/5.7.11/mysql.sock

	[mysqld]

	basedir = /usr/local/etc/mysql/5.7.11

	datadir = /usr/local/data/mysql/5.7.11

	pid-file = /usr/local/etc/mysql/5.7.11/mysql.pid

	socket = /usr/local/etc/mysql/5.7.11/mysql.sock

	log-error = /usr/local/etc/mysql/5.7.11/logs/error.log

	user = mysql

	sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

	#详细查看 ： http://jingyan.baidu.com/article/95c9d20d582334ec4e7561cb.html
	early-plugin-load=""

### MySQL自启动服务配置

复制服务配置支持配置文件
	
	cp $MYSQL_HOME/support-files/mysql.server $MYSQL_HOME/init.d/mysql.server

人工修改 $MYSQL_HOME/bin/mysql.server 配置参数，创建MySQL服务连接


修改配置

	basedir=/usr/local/etc/mysql/5.7.11
	datadir=/usr/local/data/mysql/5.7.11
	
	lockdir=/usr/local/etc/mysql/5.7.11
	lock_file_path=$lockdir/mysql.lock
	
	mysqld_pid_file_path=/usr/local/etc/mysql/5.7.11/mysql.pid

	service_startup_timeout=1000

编辑完成后，删除在编辑可能字符错误

	sed -i 's/\r$//' $MYSQL_HOME/init.d/mysql.server
	cat -A $MYSQL_HOME/init.d/mysql.server

建立连接
	
	rm -rf /etc/rc.d/init.d/mysql
	ln -s $MYSQL_HOME/init.d/mysql.server /etc/rc.d/init.d/mysql

MySQL服务相关命令
	
	#查看MySQL服务状态
	service mysql status

	#停止运行MySQL服务
	service mysql stop

	#启动运行MySQL服务
	service mysql start

	#重启运行MySQL服务
	service mysql restart
	
	#重新加载MySQL服务
	service mysql reload

	#强制重新加载MySQL服务
	service mysql force-reload

查看MySQL运行进程

	ps -ef | grep mysql

添加MySQL自启动服务

	chkconfig --add mysql
	chkconfig --level 2345 mysql on

### 修改MySQL默认密码和开发远程访问

连接MySQL客户端

	$MYSQL_HOME/bin/mysql --defaults-file=$MYSQL_HOME/my.cnf --user=root -p

输入密码后并更改密码

	set password=password('5201314');

重新授权 root 账号，开放远程访问 MySQL 服务器

	grant all privileges on *.* to 'root'@'%' identified by '5201314' with grant option ;
	flush privileges;

查看授权情况

	use mysql;
	select host,user from user;

退出登录，再次登录测试
	
	$MYSQL_HOME/bin/mysql --defaults-file=$MYSQL_HOME/my.cnf --user=root --password=5201314



### 手动方式运行MySQL

	$MYSQL_HOME/bin/mysqld --defaults-file=$MYSQL_HOME/my.cnf &

查看启动的MySQL进程	

	ps -ef | grep mysql	

### cnetos7 防火墙

添加MySQL服务

	firewall-cmd --permanent --add-service=mysql
	firewall-cmd --reload
	firewall-cmd --list-all