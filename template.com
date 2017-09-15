#!/bin/bash
####################################### 公共 ##########################################################
export JAVA_HOME=/export/servers/jdk1.7.0_79
export JAVA_BIN=/export/servers/jdk1.7.0_79/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_OPTS="-Djava.library.path=/usr/local/lib -server -Xms1024m -Xmx1024m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dsun.net.client.defaultConnectTimeout=60000 -Dsun.net.client.defaultReadTimeout=60000 -Djmagick.systemclassloader=no -Dnetworkaddress.cache.ttl=300 -Dsun.net.inetaddr.ttl=300"
export PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin
export PATH=.:$JAVA_BIN:$PATH

#######################################构建独有##########################################################
export M2_HOME=/export/servers/apache-maven-3.3.9
export PATH=$M2_HOME/bin:$PATH
#export MAVEN_HOME=/export/servers/apache-maven-2.2.1
#export PATH=$MAVEN_HOME/bin:$PATH

######################################################
# remote_url,exec,war_module按后面的序号分组,值越大越后执行
#必填，git:clone_url branch svn:checkout_url
REMOTE_URL1="http://source.jd.com/app/template.git"
#必填，maven打包命令mvn clean install -U -Dmaven.test.skip=true -Pdevelopment / mvn clean install -U -Dmaven.test.skip=true
EXEC1="mvn clean package -U -Dmaven.test.skip=true -Pdevelopment"
#非必填，抽包模块, 如果是作为jar包被依赖，无该参数
WAR_MODULE1=jd-hotel-web
######################################################

#######################################部署独有########################################################
INSTANCE_NUM=1  #实例个数
export CATALINA_HOME=/export/servers/tomcat7.0.70
#ADDRESS=10001 #远程调试端口，多个实例时递增
