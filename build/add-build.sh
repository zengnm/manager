#!/bin/bash

if [[ $1 == "" ]];then
        echo "使用命令格式: $0 域名"
        exit 0
fi
cd `dirname $0`

DOMAIN=$1
SHELL_HOME=$SHELL/$DOMAIN
SHELL_FILE=$SHELL_HOME/build


#复制脚本到相应目录
COPY_BUILD()
{
    mkdir -p $SHELL_HOME
    cp ./build $SHELL_HOME
    chmod u+x $SHELL_FILE
}

#相关变量配置
CONFIG_BUILD()
{
    sed -i "s#source_home#$SOURCE/$DOMAIN#g" ${SHELL_FILE}
    sed -i "s#work4war#$WORK#g" ${SHELL_FILE}
    sed -i "s#work_home#$WORK/$DOMAIN#g" ${SHELL_FILE}
    sed -i "s#shell_home#$SHELL/$DOMAIN#g" ${SHELL_FILE}
    echo "===== 已配置build脚本 ====="
}

COPY_BUILD
CONFIG_BUILD
