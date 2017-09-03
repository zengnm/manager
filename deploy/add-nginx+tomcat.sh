#!/bin/bash

if [[ $1 == "" ]];then
        echo "Usage: $0 ***.com"
        exit 0
fi
DOMAIN=$1
PRE_DOMAIN=${DOMAIN%.*}
################# GET TOMCAT SERVER DOWNPORT && HTTPPORT && ADDRESS ############################
if [[ ! -d ${INSTANCE} || `ls -l ${INSTANCE}/|wc -l` == 0 ]];then
	DOWNPORT="9001"
	HTTPPORT="8001"
	ADDRESS="10001"
else
	DOWNPORT=$[`cat ${INSTANCE}/*/*/conf/server.xml |grep "Server port" |awk -F = '{print $2}'|awk '{print $1}' |sed 's/\"//g'|awk 'BEGIN{x=$1;} {for(i=1;i<=NF;i++)if($i>x)x=$i;} END{print x}'`+1]
	HTTPPORT=$[`cat ${INSTANCE}/*/*/conf/server.xml |grep "HTTP" |awk '{print $2}'|grep "port"|awk -F "=" '{print $2}' |sed 's/\"//g'|awk 'BEGIN{x=$1;} {for(i=1;i<=NF;i++)if($i>x)x=$i;} END{print x}'`+1]
	ADDRESS=$[`cat ${INSTANCE}/*/*/bin/start.sh |grep "address="|awk -F address= '{print $2}'|sed 's/\"//g'|awk 'BEGIN{x=$1;if(x<1)x=10000;} {for(i=1;i<=NF;i++)if($i>x)x=$i;} END{print x}'`+1]
fi
################################## NEW PROJECT_BASE WORKS ######################################
NEW_BASE_WORKS ()
{
    mkdir -p ${WORK}
    mkdir -p ${SHELL}/${DOMAIN}
    mkdir -p ${INSTANCE}/${DOMAIN}
    mkdir -p ${NGINX}/logs/${DOMAIN}
    mkdir -p ${NGINX}/conf/domains
    cp tomcat ${SHELL}/${DOMAIN}/
}
############### SET TOMCAT SERVER ##################################
TOMCAT_NEW ()
{
    NEW_SERVER="server1"
    cp -r server100  ${NEW_SERVER}
    if [[ `${CATALINA_HOME}/bin/version.sh|grep "Server number"|awk '{print $3}'|grep "^6"|wc -w` == 0 ]];then
        mv ${NEW_SERVER}/conf/server.xml.7 ${NEW_SERVER}/conf/server.xml
    fi
    SH_FILE="${SHELL}/${DOMAIN}/tomcat"

    sed -i "s#domain#${DOMAIN}#g" ${SH_FILE}
    sed -i "s#catalina_base#${INSTANCE}/${DOMAIN}/${NEW_SERVER}#g" ${SH_FILE}

    sed -i "s#catalina_base#${INSTANCE}/${DOMAIN}/${NEW_SERVER}#g" 	${NEW_SERVER}/bin/*
    sed -i "s#9001#${DOWNPORT}#g"	${NEW_SERVER}/conf/server.xml
    sed -i "s#8001#${HTTPPORT}#g"	${NEW_SERVER}/conf/server.xml
    sed -i "s#10001#${ADDRESS}#g"	${NEW_SERVER}/bin/start.sh
    sed -i "s#/workspace/work#${WORK}/${DOMAIN}#g" 	${NEW_SERVER}/conf/Catalina/localhost/ROOT.xml
    mv ${NEW_SERVER} ${INSTANCE}/${DOMAIN}/
    chmod u+x ${SH_FILE}
    echo "Tomcat Config Complete...."
}
TOMCAT_ADD ()
{
    ADD_SERVER=server$[`ls -l ${INSTANCE}/${DOMAIN}|grep server|wc -l`+1]
    cp -r server100  ${ADD_SERVER}
    if [[ `${CATALINA_HOME}/bin/version.sh|grep "Server number"|awk '{print $3}'|grep "^6"|wc -w` == 0 ]];then
        mv ${ADD_SERVER}/conf/server.xml.7 ${ADD_SERVER}/conf/server.xml
    fi
    SH_FILE="${SHELL}/${DOMAIN}/tomcat"
    NEW_CATALINA_NUM=$[`cat ${SH_FILE}|grep "CATALINA_BASE.="|wc -l`+1]
    TOMCAT_LINE_NUM=`cat -n ${SH_FILE}|grep "CATALINA_BASE.="|tail -n 1 |awk '{print $1}'`

    sed -i "${TOMCAT_LINE_NUM}aexport CATALINA_BASE${NEW_CATALINA_NUM}=${INSTANCE}\/${DOMAIN}\/${ADD_SERVER}" ${SH_FILE}
    sed -i "/^for.*$/s//&  \$CATALINA\_BASE${NEW_CATALINA_NUM}/g" ${SH_FILE}
    sed -i "s#catalina_base#${INSTANCE}/${DOMAIN}/${ADD_SERVER}#g" ${SH_FILE}

    sed -i "s#catalina_base#${INSTANCE}/${DOMAIN}/${ADD_SERVER}#g" ${ADD_SERVER}/bin/*
    sed -i "s#9001#${DOWNPORT}#g"	${ADD_SERVER}/conf/server.xml
    sed -i "s#8001#${HTTPPORT}#g"	${ADD_SERVER}/conf/server.xml
    sed -i "s#10001#${ADDRESS}#g"	${ADD_SERVER}/bin/start.sh
    sed -i "s#/workspace/work#${WORK}/${DOMAIN}#g"	${ADD_SERVER}/conf/Catalina/localhost/ROOT.xml
    mv ${ADD_SERVER} ${INSTANCE}/${DOMAIN}/
    chmod u+x ${SH_FILE}
    echo "Tomcat Config Complete...."
}
################### SET NGINX SERVER ################################ 
NGINX_NEW ()
{
    CONF="${NGINX}/conf/nginx.conf"
    if [[ ! -f ${CONF} ]];then
        cp nginx.conf ${NGINX}/conf
        sed -i "s#username#${USERNAME}#g" ${CONF}
        sed -i "s#nginx_home#${NGINX}#g" ${CONF}
    fi
    NEW_NGINX_FILE="${NGINX}/conf/domains/${DOMAIN}"
    cp xxx.com  ${NEW_NGINX_FILE}
    sed -i "s#xxx.com#${DOMAIN}#g" ${NEW_NGINX_FILE}
    sed -i "s#tomcat_xxx#tomcat_${DOMAIN}#g" ${NEW_NGINX_FILE}
    sed -i "s#8001#${HTTPPORT}#g" ${NEW_NGINX_FILE}
    sed -i "s#nginx_home#${NGINX}#g" ${NEW_NGINX_FILE}
    sed -i "s#work#${WORK}#g" ${NEW_NGINX_FILE}
    sed -i "/server_name/s#;# ${PRE_DOMAIN}\.local;#g" ${NEW_NGINX_FILE}
    echo "Nginx Config Complete...."
}
#配置文件中添加一行：server 127.0.0.1:{httpport}  weight=10 max_fails=2 fail_timeout=30s;
NGINX_ADD ()
{
    NGINX_FILE="${NGINX}/conf/domains/${DOMAIN}"
    LINE_NUM=`cat -n ${NGINX_FILE} |grep "server 127"|tail -n 1|awk '{print $1}'`
    sed -i "${LINE_NUM}a\\\tserver\ 127.0.0.1\:${HTTPPORT}\ \ weight\=10\ max_fails\=2\ fail_timeout\=30s\;" ${NGINX_FILE}
    echo "Nginx Config Complete...."
}
################## FOR REAL ###############################
cd `dirname $0`
source ../env.sh #仅用到catalina_home
if [ -d ${INSTANCE}/${DOMAIN} ];then
	read -p "已有同域名应用,是否再新建一个?(yes/no)" YES
	case $YES in
		y|yes|Y|YES)
			TOMCAT_ADD 
			NGINX_ADD
	esac
else
	NEW_BASE_WORKS
	TOMCAT_NEW
	NGINX_NEW
fi
######################### END ##########################