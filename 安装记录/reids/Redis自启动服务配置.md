
# Redis自启动服务配置

添加redis运行用户

useradd redis -m -d /home/redis
id redis


授权相关运行的目录

	#redis安装目录
	chmod -R 775 /usr/local/etc/redis
	chown -v -R redis:redis /usr/local/etc/redis
	
	#redis数据目录
	chmod -R 775 /usr/local/data/redis
	chown -v -R redis:redis /usr/local/data/redis

人工编写redis启动脚本 [redis.sh](redis.sh) 并上传到 $REDIS_HOME/bin中。

	sed -i 's/\r$//' $REDIS_HOME/bin/redis.sh
	cat -A $REDIS_HOME/bin/redis.sh
	
	chmod 775 $REDIS_HOME/bin/redis.sh
	rm -rf /etc/init.d/redis
	ln -s $REDIS_HOME/bin/redis.sh /etc/init.d/redis

测试
	
	#刷新守护进程
	systemctl daemon-reload
	service redis status
	ps -ef | grep redis
