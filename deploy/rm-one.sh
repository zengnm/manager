#!/bin/bash


cd ${INSTANCE}/${DOMAIN} && ls |grep "^server"|tail -1|xargs rm -rf


LINE_NUM=`cat -n ${NGINX}/conf/domains/${DOMAIN} |grep "server 127"|tail -n 1|awk '{print $1}'`
sed -i "${LINE_NUM}d" ${NGINX}/conf/domains/${DOMAIN}

