#!/bin/bash

# 显示欢迎信息
echo "====================================="
echo "     AI投降装置 - 一键启动脚本       "
echo "====================================="

# 构建Docker镜像
echo "正在构建Docker镜像..."
docker build -t ai-surrender-app .

# 检查是否有容器正在运行，如果有则停止并删除
CONTAINER_ID=$(docker ps -q --filter "publish=9001")
if [ ! -z "$CONTAINER_ID" ]; then
    echo "发现端口9001上有容器正在运行，正在停止..."
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
fi

# 启动新容器
echo "正在启动网站服务..."
docker run -d -p 9001:9001 --name ai-surrender-container ai-surrender-app

echo "====================================="
echo "AI投降装置已启动！"
echo "请访问: http://localhost:9001"
echo "=====================================" 