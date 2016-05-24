
# Nginx配置子项配置

 在nginx/conf根目录下面的配置。

## nginx.conf


	#--------------------------------------------------------------------------------------------
	
	user  nginx;
	
	#--------------------------------------------------------------------------------------------
	
	worker_processes  auto;
	
	#--------------------------------------------------------------------------------------------
	
	#error_log logs/error.log;
	#error_log logs/error.log  notice;
	#error_log logs/error.log  info;
	
	error_log logs/error.log  error;
	
	#--------------------------------------------------------------------------------------------
	
	pid nginx.pid;
	
	#--------------------------------------------------------------------------------------------
	
	events {
	    worker_connections  1024;
	}
	
	#--------------------------------------------------------------------------------------------
	
	http {
	
	    #-----------------------------------------------------------------------------------------
	
	    include       mime.types;
	    default_type  application/octet-stream;
	
	    #-----------------------------------------------------------------------------------------
	
	    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	                      '$status $body_bytes_sent "$http_referer" '
	                      '"$http_user_agent" "$http_x_forwarded_for"';
	
	    #-----------------------------------------------------------------------------------------
	
	    access_log logs/access.log  main;
	
	    #-----------------------------------------------------------------------------------------
	
	    sendfile on;
	    tcp_nopush on;
	
	    #-----------------------------------------------------------------------------------------
	
	    #keepalive_timeout 0;
	    keepalive_timeout 65;
	
	    #-----------------------------------------------------------------------------------------
	
	    gzip on;
	    gzip_static on;
	    gzip_min_length 4k;
	    gzip_buffers 256 4k;
	    gzip_http_version 1.1;
	    gzip_comp_level 4;
	    gzip_types text/plain application/x-javascript text/css application/xml text/javascript image/jpeg image/gif image/png;
	    gzip_proxied no-cache;
	    gzip_vary on;
	
	    #-----------------------------------------------------------------------------------------
	
	    include conf.d/*.conf;
	
	    #-----------------------------------------------------------------------------------------
	
	}

## 其他子项配置模板

http_www.irgba.com.conf

	#--------------------------------------------------------------------------------------------
	
	server {
	
	    #-----------------------------------------------------------------------------------------
	
	    listen 8080 default_server;
	    server_name www.irgba.com;
	
	    #-----------------------------------------------------------------------------------------
	
	    charset utf-8;
	
	    #-----------------------------------------------------------------------------------------
	
	    access_log  logs/www.develop-irgba.com.access.http.log main;
	
	    #-----------------------------------------------------------------------------------------
	
	    if ( -d $request_filename ){
	     rewrite ^/(.*)([^/])$ $scheme://$host/$1$2/ permanent;
	    }
	
	    #-----------------------------------------------------------------------------------------
	
	    location / {
	
	     proxy_pass http://127.0.0.1:18080;
	     proxy_redirect off;
	
	     proxy_set_header X-Forwarded-Proto $scheme;
	     proxy_set_header X-Forwarded-Host $http_host;
	     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	
	     proxy_set_header Host $host;
	     proxy_set_header X-Real-IP $remote_addr;
	
	     proxy_http_version 1.1;
	     proxy_set_header Upgrade $http_upgrade;
	     proxy_set_header Connection "upgrade";
	
	    }
	
	    #-----------------------------------------------------------------------------------------
	
	}
	
	#--------------------------------------------------------------------------------------------
