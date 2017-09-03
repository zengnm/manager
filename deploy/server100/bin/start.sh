#!/bin/bash
export CATALINA_BASE=catalina_base
#export CATALINA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=10001"

${CATALINA_HOME}/bin/startup.sh -config ${CATALINA_BASE}/conf/server.xml
