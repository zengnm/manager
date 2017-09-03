#!/bin/bash
#构建独有
export PROFILE="development"  #maven打包的profile参数
export M2_HOME=/export/servers/apache-maven-3.3.9
export PATH=$M2_HOME/bin:$PATH
#export MAVEN_HOME=/export/servers/apache-maven-2.2.1
#export PATH=$MAVEN_HOME/bin:$PATH

#部署独有
export CATALINA_HOME=/export/servers/tomcat7.0.70

#公共
export JAVA_HOME=/export/servers/jdk1.7.0_79
export JAVA_BIN=/export/servers/jdk1.7.0_79/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_OPTS="-Djava.library.path=/usr/local/lib -server -Xms1024m -Xmx1024m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dsun.net.client.defaultConnectTimeout=60000 -Dsun.net.client.defaultReadTimeout=60000 -Djmagick.systemclassloader=no -Dnetworkaddress.cache.ttl=300 -Dsun.net.inetaddr.ttl=300"
export PATH=.:$JAVA_BIN:$PATH
#export PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin
