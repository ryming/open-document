
# Nginx安装和配置

 首先需要下载相关的 nginx 程序安装包并存放到 /usr/local/src/nginx 下面。

下载参考:

    mkdir -p /usr/local/src/nginx
    cd /usr/local/src/nginx
    #1.10.0
    wget http://nginx.org/download/nginx-1.10.0.tar.gz



## nginx-1.10.0.tar.gz

下载相关依赖库

	yum -y install gcc gcc-c++ 
	yum -y install autoconf automake
	yum -y install zlib zlib-devel
	yum -y install openssl openssl-devel
	yum -y install perl-devel perl-ExtUtils-Embed
	yum -y install libxslt-devel

添加nginx用户

	useradd nginx -M -d /home/nginx -s /bin/false -r
	id nginx

创建相关编译依赖目录
    
    #创建nginx主程序目录
    mkdir -p /usr/local/etc/nginx/1.10.0
    #创建nginx配置目录
    mkdir -p /usr/local/etc/nginx/1.10.0/conf
    #创建nginx日记目录
    mkdir -p /usr/local/etc/nginx/1.10.0/logs
    #创建nginx缓存目录
    mkdir -p /usr/local/etc/nginx/1.10.0/cache

解压下载包

	cd /usr/local/src/nginx
	tar -zxvf nginx-1.10.0.tar.gz
	cd ./nginx-1.10.0/

编译与安装

	./configure \
	--prefix=/usr/local/etc/nginx/1.10.0 \
	--sbin-path=/usr/local/etc/nginx/1.10.0/sbin/nginx \
	--conf-path=/usr/local/etc/nginx/1.10.0/conf/nginx.conf \
	--error-log-path=/usr/local/etc/nginx/1.10.0/logs/error.log \
	--http-log-path=/usr/local/etc/nginx/1.10.0/logs/access.log \
	--pid-path=/usr/local/etc/nginx/nginx.pid \
	--lock-path=/usr/local/etc/nginx/nginx.lock \
	--http-client-body-temp-path=/usr/local/etc/nginx/1.10.0/cache/client_temp \
	--http-proxy-temp-path=/usr/local/etc/nginx/1.10.0/cache/proxy_temp \
	--http-fastcgi-temp-path=/usr/local/etc/nginx/1.10.0/cache/fastcgi_temp \
	--http-uwsgi-temp-path=/usr/local/etc/nginx/1.10.0/cache/uwsgi_temp \
	--http-scgi-temp-path=/usr/local/etc/nginx/1.10.0/cache/scgi_temp \
	--user=nginx \
	--group=nginx \
	--with-http_ssl_module \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-http_sub_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_random_index_module \
	--with-http_secure_link_module \
	--with-http_stub_status_module \
	--with-http_auth_request_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-file-aio \
	--with-ipv6 \
	--with-http_xslt_module \
	--with-http_degradation_module \
	--with-http_perl_module \
	--with-threads \
	--with-stream \
	--with-stream_ssl_module \
	--with-http_slice_module \
	--with-http_v2_module \
	&& make && make install

可选GCC编译优化参数

	--with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \	

配置nginx环境变量

    vi /root/.bash_profile

添加内容

	#Nginx环境变量
	export NGINX_1_10_0=/usr/local/etc/nginx/1.10.0
	export NGINX_HOME=$NGINX_1_10_0
	export PATH=$PATH:$NGINX_HOME/sbin

保存退出

	source /root/.bash_profile
	nginx -v
	
授权nginx运行相关目录

	chown -R nginx:nginx $NGINX_HOME