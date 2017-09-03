#!/bin/bash

##### 删除指定文件或文件夹,并删除空的父目录及无用的env.sh###########
RMDIR_SMART()
{
    dir=$1
    key=$2
    if [ -d ${dir} ];then
        /bin/rm -rf ${dir}/${key}
        echo "直接删除${dir}/${key}"
        if [[ -f ${dir}/env.sh && `ls ${dir}|wc -l` == 1 ]]; then
            /bin/rm -rf ${dir}/env.sh
            echo "删除env ${dir}/${key}"
        fi
        cd ${dir}
        until [ `pwd` -ef / ]; do
            if [[ `ls|wc -l` > 0 ]];then
                break;
            fi
            rmdir `pwd`
            echo "删除目录`pwd`"
            cd ../
        done
    fi
}

if [[ $1 == "" ]];then
    echo "使用命令格式: $0 域名"
    exit 0
fi
DOMAIN=$1

read -p "删除后不可恢复，确认删除?(yes/no)" YES
case $YES in
    y|yes|Y|YES)
        RMDIR_SMART ${WORK} ${DOMAIN}
        RMDIR_SMART ${LOGS} ${DOMAIN}
        RMDIR_SMART ${INSTANCE} ${DOMAIN}
        RMDIR_SMART ${NGINX}/logs ${DOMAIN}
        RMDIR_SMART ${NGINX}/conf/domains ${DOMAIN}
        RMDIR_SMART ${SHELL}/${DOMAIN} tomcat
        echo "==== 已全部清除!!! ===="
        ;;
esac
