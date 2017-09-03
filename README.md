## 一、使用说明
#### 功能特点:
    功能丰富,包括自动配置、构建、部署、实例管理、日志管理
    交互式命令操作,简单方便
    jdk、tomcat多版本兼容
    可拆分成构建系统、部署系统
    支持单台机器集群部署
    
另外，用户所有操作只需与manager交互
## 二、使用前准备
#### 1.安装好必要的软件软件：
    a.安装subversion或git,使得svn和git在当前用户可执行.并配置好账号密码
        在centos中使用sudo yum install -y subversion git 安装;
        在ubuntu中使用sudo apt-get install -y subversion git 安装;
        安装完成后保存好密码（如git 在$HOME/.netrc配置），方便后续使用。
    b.构建时，需安装jdk,maven
        
    c.部署时，需安装jdk,tomcat,nginx

#### 2.初始化配置
    a.下载脚本，地址:https://github.com/zengnm/manager/archive/master.zip ,解压。
        
    b.选择或新建一个用户账号如admin(脚本将以该用户执行,并使用该用户创建相关文档),并设置为manager中USERNAME的值;
      调整manager中的WORKSPACE,WORK,INSTANCE等变量值，设置存放位置。
       
    c.切换到普通用户如admin,在脚本主目录下执行:
        su admin (可能需要输入密码)
        chmod u+x bin/manager
        bin/manager -m init （初始化完成后，会在$HOME/.bashrc文件配置PATH和自动补齐脚本等。）
    d.验证。在任意目录下，执行manager，打印出帮助信息即说明配置完成。
#### 3.环境变量配置
    将jdk、maven、tomcat相关环境变量修改至env.sh

## 三、开始使用
#### 1.搭建构建系统、部署系统
    使用以下命令来初始化应用:
        manager -m create
    在交换式命令中：
        搭建构建系统时，选择add-build选项的id
        搭建部署系统时，选择add-tomcat+nginx选项的id
        搭建构建、部署系统时，选择add-build+tomcat+nginx选项的id
        home目录生成，选择add-home选项的id
#### 2.删除构建部署系统
    使用以下命令来初始化应用:
        manager -m delete
    与搭建类似，选择对应id即可删除相应配置、目录。
#### 3.系统管理
    使用以下命令，管理自动部署、tomcat 启停、日志查看、日志删除等:
        manager [help|build|deploy|tomcat|logs|cleanlogs|...]
