
# Nginx自启动服务配置

配置nginx自启动服务，还有可能根据防火墙配置相关端口转发。

## 防火墙配置[可选]

[可选]安装防火墙
	
	yum -y install firewalld

[可选]启动防火墙
	
	systemctl start firewalld

[可选]自启动防火墙
	
	systemctl enable firewalld

[可选]为防火墙添加HTTP,HTTPS访问权限

	firewall-cmd --permanent --add-service=http
	firewall-cmd --permanent --add-service=https
	firewall-cmd --reload
	firewall-cmd --list-all

[可选]配置端口转发

	firewall-cmd --permanent --add-forward-port=port=80:proto=tcp:toport=8080
	firewall-cmd --reload
	firewall-cmd --list-all

[可选]删除不使用的服务
	
	firewall-cmd --permanent --remove-service=dhcpv6-client
	firewall-cmd --reload
	firewall-cmd --list-all

## 配置nginx自启动服务

链接脚本并测试

人工上传 nginx.sh 配置

    mkdir -p $NGINX_HOME/init.d/
    
重新授权以及链接
    
	sed -i 's/\r$//' $NGINX_HOME/init.d/nginx.sh
	cat -A $NGINX_HOME/init.d/nginx.sh

	chmod 775 $NGINX_HOME/init.d/nginx.sh
	rm -rf /etc/init.d/nginx
	ln -s $NGINX_HOME/init.d/nginx.sh /etc/init.d/nginx
	/etc/init.d/nginx verify

设置自启动

	chkconfig --add nginx
	chkconfig --level 2345 nginx on

配置测试启动

	service nginx start
	ps -ef | grep nginx

配置测试停止

	service nginx stop
	ps -ef | grep nginx

重启配置测试

	reboot

## nginx.sh自启动服务脚本

	#!/bin/sh
	#
	# nginx - this script starts and stops the nginx daemin
	#
	# chkconfig:   - 85 15
	# description:  Nginx is an HTTP(S) server, HTTP(S) reverse proxy and IMAP/POP3 proxy server
	
	. /etc/rc.d/init.d/functions
	
	. /etc/sysconfig/network
	
	[ "$NETWORKING" = "no" ] && exit 0
	
	NGINX_HOME="/usr/local/etc/nginx/1.10.0"
	NGINX_SBIN="$NGINX_HOME/sbin/nginx"
	NGINX_CONF="$NGINX_HOME/conf/nginx.conf"
	NGINX_PID="$NGINX_HOME/nginx.pid"
	NGINX_LOCK="$NGINX_HOME/nginx.lock"
	NGINX_PROG=$(basename $NGINX_SBIN)
	
	start() {
	    [ -x $NGINX_SBIN ] || exit 5
	    [ -f $NGINX_CONF ] || exit 6
	    echo -n $"Starting $NGINX_PROG: "
	    daemon $NGINX_SBIN -c $NGINX_CONF
	    retval=$?
	    echo
	    [ $retval -eq 0 ] && touch $NGINX_LOCK
	    return $retval
	}
	
	stop() {
	    echo -n $"Stopping $NGINX_PROG: "
	    killproc $NGINX_PROG -QUIT
	    retval=$?
	    echo
	    [ $retval -eq 0 ] && rm -f $NGINX_LOCK
	    return $retval
	}
	
	restart() {
	    verify || return $?
	    stop
	    start
	}
	
	reload() {
	    verify || return $?
	    echo -n $"Reloading $NGINX_PROG: "
	    killproc $NGINX_SBIN -HUP
	    RETVAL=$?
	    echo
	}
	
	force_reload() {
	    restart
	}
	
	verify() {
	  $NGINX_SBIN -t -c $NGINX_CONF
	}
	
	rh_status() {
	    status $NGINX_PROG
	}
	
	rh_status_q() {
	    rh_status >/dev/null 2>&1
	}
	
	case "$1" in
	    start)
	        rh_status_q && exit 0
	        $1
	        ;;
	    stop)
	        rh_status_q || exit 0
	        $1
	        ;;
	    restart|verify)
	        $1
	        ;;
	    reload)
	        rh_status_q || exit 7
	        $1
	        ;;
	    force-reload)
	        force_reload
	        ;;
	    status)
	        rh_status
	        ;;
	    condrestart|try-restart)
	        rh_status_q || exit 0
	            ;;
	    *)
	        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|verify}"
	        exit 2
	esac