FROM nginx:alpine

# 复制网站文件到Nginx的默认目录
COPY index.html /usr/share/nginx/html/
COPY README.md /usr/share/nginx/html/

# 配置Nginx监听9001端口
RUN echo 'server {\n\
    listen 9001;\n\
    server_name localhost;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# 暴露9001端口
EXPOSE 9001

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"] 