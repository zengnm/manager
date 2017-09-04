#!/bin/bash
export CATALINA_BASE=catalina_base

${CATALINA_HOME}/bin/shutdown.sh -config ${CATALINA_BASE}/conf/server.xml
DOWNPORT=`ps -aef | grep java|grep ${CATALINA_BASE}| grep -v grep | sed 's/ [ ]*/:/g' |cut -d: -f2`
if [ -z ${DOWNPORT} ];then
    kill -9 ${DOWNPORT}
fi
