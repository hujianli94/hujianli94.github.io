# 附录-Nginx 完整配置样例

```conf
user nobody;
worker_processes 1;
events {
  worker_connections 1024;
}
http {
 include mime.types;
 default_type application/octet-stream;
 sendfile on;
 keepalive_timeout 65;
 gzip on;
 server {
 listen 80;
 server_name 10.168.1.100;
 charset utf-8;
 access_log logs/host.access.log main;

 root /data/web; # Web 前端编译后的静态文件目录路径
 location / {
    index index.html index.htm;
 }

 location /api/ { # 用户登录、todo、iAPI、iData 等服务
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:9528;
 }

 location /api/hproxy/ { # 转发到 HProxy 服务
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://10.168.1.101:80/api/;
 }

 location /api/imock/ { # 转发到 iMock 服务
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://10.168.1.102:80/api/;
 }
 error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    root html;
  }
 }
}
```
