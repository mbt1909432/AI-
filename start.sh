#!/bin/bash

# 显示欢迎信息
echo "====================================="
echo "     AI投降装置 - 一键启动脚本       "
echo "====================================="

# 构建Docker镜像
echo "正在构建Docker镜像..."
docker build -t ai-surrender-app .

# 检查是否有容器正在运行在9001端口，如果有则停止
CONTAINER_ID=$(docker ps -q --filter "publish=9001")
if [ ! -z "$CONTAINER_ID" ]; then
    echo "发现端口9001上有容器正在运行，正在停止..."
    docker stop $CONTAINER_ID
fi

# 检查是否存在同名容器，如果有则删除
EXISTING_CONTAINER=$(docker ps -a -q --filter "name=ai-surrender-container")
if [ ! -z "$EXISTING_CONTAINER" ]; then
    echo "发现名为'ai-surrender-container'的容器，正在删除..."
    docker rm $EXISTING_CONTAINER
fi

# 启动新容器
echo "正在启动网站服务..."
docker run -d -p 9001:9001 --name ai-surrender-container ai-surrender-app

# 等待几秒让容器有时间启动
sleep 3

# 检查容器是否运行
CONTAINER_RUNNING=$(docker ps -q --filter "name=ai-surrender-container")
if [ -z "$CONTAINER_RUNNING" ]; then
    echo "警告: 容器似乎没有正常运行!"
    echo "查看容器日志:"
    docker logs ai-surrender-container
    
    echo "查看所有容器状态(包括已停止的):"
    docker ps -a | grep ai-surrender-container
    
    # 尝试使用主机网络模式重新启动容器
    echo "尝试使用host网络模式重启容器..."
    docker rm ai-surrender-container
    docker run -d --network host --name ai-surrender-container ai-surrender-app
    
    echo "再次检查容器状态:"
    docker ps | grep ai-surrender-container
else
    echo "容器成功启动！"
    echo "查看容器详情:"
    docker ps | grep ai-surrender-container
fi

echo "====================================="
echo "如果容器正常运行，请访问: http://localhost:9001"
echo "=====================================" 