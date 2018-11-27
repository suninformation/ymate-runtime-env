# ymate-runtime-env
YMP运行环境搭建所需软件包

**安装说明：**

- 下载或克隆`ymate-runtime-env`到本地

```
# git clone https://github.com/suninformation/ymate-runtime-env.git
```

- 执行初始化命令：

```sh
# cd ymate-runtime-env
# ./init.sh
Unpacking JDK...
Unpacking Maven...
Unpacking Tomcat...
Unpacking MySQL...
-----------------------------------------------------
Please add the following in the ~/.bash_profile file:
-----------------------------------------------------
JAVA_HOME=/root/ymate-runtime-env-master/jdk1.8.0_151
MAVEN_HOME=/root/ymate-runtime-env-master/apache-maven-3.1.1
CATALINA_HOME=/root/ymate-runtime-env-master/apache-tomcat-7.x

PATH=$PATH:$HOME/.local/bin:$HOME/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin

export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
export MAVEN_OPTS=-Dfile.encoding=UTF-8

export JAVA_HOME
export MAVEN_HOME
export CATALINA_HOME

export PATH
-----------------------------------------------------
OK
```

- 编辑`~/.bash_profile`文件替换环境变量并使其生效

```
# vi ~/.bash_profile
# source ~/.bash_profile
```

- 测试

```
# mvn -version
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Apache Maven 3.1.1 (0728685237757ffbf44136acec0402957f723d9a; 2013-09-17 15:22:22+0000)
Maven home: /root/ymate-runtime-env-master/apache-maven-3.1.1
Java version: 1.8.0_151, vendor: Oracle Corporation
Java home: /root/ymate-runtime-env-master/jdk1.8.0_151/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-862.14.4.el7.x86_64", arch: "amd64", family: "unix"
```

OK，安装成功！


**背景：**

最近一段时间公司的Windows服务器频频中招，实在无法忍受，于是乎决定改用Linux系统！
趁现在服务器正在扫描病毒，把今天购买的阿里云服务器的配置过程整理一下，写个快速搭建环境的手册，与小伙伴们分享！


**目标：**

本文将描述在CentOS 7操作系统中安装以下服务：
- Git
- Maven
- Tomcat
- Java
- MySQL
- Nginx



**安装GIT**

阿里云的CentOS镜像中默认已经安装了Git v1.8.3.1，若未安装请执行以下命令：

```
// 通过yum安装
yum install git
// 查看Git版本
git --version
```

**安装Maven**

```
// 下载Maven安装包
wget https://archive.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
// 解压
tar zxvf apache-maven-3.1.1-bin.tar.gz
// 
```

**安装Tomcat**

```
// 下载Tomcat安装包
wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.82/bin/apache-tomcat-7.0.82.tar.gz
// 解压
tar zxvf apache-tomcat-7.0.82.tar.gz
```

**安装Java**

```
// 访问官网 http://www.oracle.com/technetwork/java/javase/downloads/index.html
// 下载Java安装包（先在本机开始下载后，再复制下载链接地址）
wget http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz?AuthParam=1445393430_77c75c42039e71d236a2a146b48c185c
// 解压
tar zxvf jdk-8u65-linux-x64.tar.gz\?AuthParam\=1445393430_77c75c42039e71d236a2a146b48c185c

```

以上操作已将Git、Maven、Tomcat和Java都准备好了，接下来配置环境变量：

```
// 编辑.bash_profile文件
vi ~/.bash_profile
```
修改后文件内容如下：

```
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME=/root/jdk1.8.0_65
MAVEN_HOME=/root/apache-maven-3.1.1

PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin

export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
export MAVEN_OPTS=-Dfile.encoding=UTF-8

export JAVA_HOME
export MAVEN_HOME

export PATH
```

保存文件后别忘记执行一下才能生效

```
// 执行source
source .bash_profile
```

环境变量配置完毕，可以验证一下：

```
// 执行命令
java -version
// 输出
java version "1.8.0_65"
Java(TM) SE Runtime Environment (build 1.8.0_65-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.65-b01, mixed mode)

// 执行命令
mvn -version
// 输出
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Apache Maven 3.3.3 (7994120775791599e205a5524ec3e0dfe41d4a06; 2015-04-22T19:57:37+08:00)
Maven home: /root/apache-maven-3.1.1
Java version: 1.8.0_65, vendor: Oracle Corporation
Java home: /root/jdk1.8.0_65/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-123.9.3.el7.x86_64", arch: "amd64", family: "unix"
```

好了，到此为止我们已经配置好了Java、Maven环境，接下来我们开始搭建Tomcat服务，大家可以会想到，下载安装包再解压就可以了，No！

今天我要阐述的是如何通过一个Tomcat搭建多个独立JVM的的Tomcat服务，让我们开始吧！

```
// 首先下载YMP框架的Maven插件工程
git clone https://github.com/suninformation/ymate-maven-extension.git
// 进入插件工程目录
cd ymate-maven-extension
// 执行Maven编译安装命令
mvn clean install
//
cd ..
// 通过Git下载可执行YMP插件命令的空工程并命名为"servers"
git clone https://github.com/suninformation/ymate-empty.git servers
```

接下来上正菜，创建我们的第一个Tomcat服务，命令参数列表：

|参数名称|必须|说明|
|---|---|---|
|serviceName|是|服务名称（若在`Windows`环境下同时为注册服务名称）|
|catalinaHome|是|Tomcat软件包安装路径，默认值：`${CATALINA_HOME}`|
|catalinaBase|否|生成的服务存放的位置，默认值：`当前路径`|
|hostName|否|主机名称，默认值：`localhost`|
|hostAlias|否|别名，默认值：`空`|
|tomcatVersion|否|指定Tomcat软件包的版本，默认值：`7`，目前支持：`6`，`7`，`8`，（必须与`catalinaHome`指定的版本匹配）|
|servicePort|否|服务端口（Tomcat服务的Server端口），默认值：`8005`|
|connectorPort|否|容器端口（Tomcat服务的Connector端口），默认值：`8088`|
|ajp|否|是否启用AJP配置，默认值：`false`|
|ajpHost|否|AJP主机名称，默认值：`localhost`|
|ajpPort|否|AJP端口，默认值：`8009`|

执行命令：

```
mvn ymate:tomcat -DserviceName=DemoServer -DcatalinaHome=/Users/.../apache-tomcat-7.0.82 -DcatalinaBase=/Users/.../Temp
```

控制台输出：

```
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building ympDemo 1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:tomcat (default-cli) @ ympDemo ---
[INFO] Tomcat Service:DemoServer
[INFO] 	|--CatalinaHome:/Users/.../apache-tomcat-7.0.82
[INFO] 	|--CatalinaBase:/Users/.../Temp
[INFO] 	|--HostName:localhost
[INFO] 	|--HostAlias:
[INFO] 	|--TomcatVersion:7
[INFO] 	|--ServerPort:8005
[INFO] 	|--ConnectorPort:8080
[INFO] 	|--RedirectPort:8443
[INFO] 	|--Ajp:false
[INFO] Output file: /Users/.../Temp/DemoServer/conf/server.xml
[INFO] Output file: /Users/.../Temp/DemoServer/vhost.conf
[INFO] Output file: /Users/.../Temp/DemoServer/bin/install.bat
[INFO] Output file: /Users/.../Temp/DemoServer/bin/manager.bat
[INFO] Output file: /Users/.../Temp/DemoServer/bin/shutdown.bat
[INFO] Output file: /Users/.../Temp/DemoServer/bin/startup.bat
[INFO] Output file: /Users/.../Temp/DemoServer/bin/uninstall.bat
[INFO] Output file: /Users/.../Temp/DemoServer/bin/manager.sh
[INFO] Output file: /Users/.../Temp/DemoServer/webapps/ROOT/index.jsp
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 0.498s
[INFO] Finished at: Thu Nov 02 10:05:47 CST 2017
[INFO] Final Memory: 11M/309M
[INFO] ------------------------------------------------------------------------
```

生成的文件说明：

|文件名称|说明|
|---|---|
|`conf/server.xml`|`Tomcat`服务配置文件|
|`vhost.conf`|与`Nginx`和`Apache Server`整合所需配置|
|`bin/install.bat`|`Windows`环境下服务安装|
|`bin/manager.bat`|`Windows`环境下打开`Tomcat`服务管理|
|`bin/shutdown.bat`|`Windows`环境下服务停止|
|`bin/startup.bat`|`Windows`环境下服务启动|
|`bin/uninstall.bat`|`Windows`环境下服务卸载|
|`bin/manager.sh`|`Linux`或`Unix`环境下控制服务的启动或停止等操作|
|`webapps/ROOT/index.jsp`|默认JSP首页文件|

Linux下服务的启动和停止：
    
- 需要为`manager.sh`添加执行权限：

    执行命令：

    ```
    chmod +x manager.sh
    ```

- 启动服务：

    执行命令：
    
    ```
    ./manager.sh start
    ```

    控制台输出：

    ```
    Using CATALINA_BASE:   /Users/.../Temp/DemoServer
    Using CATALINA_HOME:   /Users/.../apache-tomcat-7.0.82
    Using CATALINA_TMPDIR: /Users/.../Temp/DemoServer/temp
    Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
    Using CLASSPATH:       /Users/.../apache-tomcat-7.0.82/bin/bootstrap.jar:/Users/.../apache-tomcat-7.0.82/bin/tomcat-juli.jar
    Using CATALINA_PID:    /Users/.../Temp/DemoServer/logs/catalina.pid
    Tomcat started.
    ```

- 停止服务：

    执行命令：
    
    ```
    ./manager.sh stop
    ```

    控制台输出：

    ```
    Using CATALINA_BASE:   /Users/.../Temp/DemoServer
    Using CATALINA_HOME:   /Users/.../apache-tomcat-7.0.82
    Using CATALINA_TMPDIR: /Users/.../Temp/DemoServer/temp
    Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
    Using CLASSPATH:       /Users/.../apache-tomcat-7.0.82/bin/bootstrap.jar:/Users/.../apache-tomcat-7.0.82/bin/tomcat-juli.jar
    Using CATALINA_PID:    /Users/.../Temp/DemoServer/logs/catalina.pid
    Tomcat stopped.
    ```

恭喜，我们的第一个Tomcat服务创建成功了！我们先看看生成的目录结构：

```
cd ~/server/DemoServer
ls -al
// 输出内容：
drwxr-xr-x 8 root root 4096 10月 21 10:42 .
drwxr-xr-x 5 root root 4096 10月 21 22:41 ..
drwxr-xr-x 2 root root 4096 10月 21 10:42 bin
drwxr-xr-x 3 root root 4096 10月 21 10:52 conf
drwxr-xr-x 2 root root 4096 10月 21 10:52 logs
drwxr-xr-x 2 root root 4096 10月 21 10:42 temp
-rw-r--r-- 1 root root  560 10月 21 10:42 vhost.conf
drwxr-xr-x 3 root root 4096 10月 21 10:42 webapps
drwxr-xr-x 3 root root 4096 10月 21 10:52 work
```

是不是和Tomcat本身的目录结构一样呢，没错，demoServ服务的所有文件都将在存放在这里，与Tomcat软件包完成隔离开来。
这里多了个vhost.conf文件，里面已经帮你写好了Tomcat与Apache Server集成所需要的配置，：）YMP贴心不？！

好了，让我们启动DemoServer服务看看效果吧，等等...还差一步哦！

```

// 先看一下demoServ/bin目录里的文件
cd ～/server/DemoServer/bin
ls -al
drwxr-xr-x 2 root root 4096 10月 21 10:42 .
drwxr-xr-x 8 root root 4096 10月 21 10:42 ..
-rw-r--r-- 1 root root  431 10月 21 10:42 install.bat
-rw-r--r-- 1 root root  455 10月 21 10:42 manager.bat
-rwxr--r-- 1 root root  345 10月 21 10:42 manager.sh
-rw-r--r-- 1 root root  401 10月 21 10:42 shutdown.bat
-rw-r--r-- 1 root root  401 10月 21 10:42 startup.bat
-rw-r--r-- 1 root root  432 10月 21 10:42 uninstall.bat
```

因为我们在Linux系统里，只需要manager.sh文件就够了，其它的文件都是在Windows里才会用到。
现在，需要给manager.sh文件可执行的权限：

```
chmod +x manager.sh
```

OK，让我启动DemoServer服务吧！

```
// 执行start命令
./manager.sh start
// 输出
Using CATALINA_BASE:   /root/servers/DemoServer
Using CATALINA_HOME:   /root/apache-tomcat-7.0.82
Using CATALINA_TMPDIR: /root/servers/demoServ/temp
Using JRE_HOME:        /root/jdk1.8.0_65
Using CLASSPATH:       /root/apache-tomcat-7.0.82/bin/bootstrap.jar:/root/apache-tomcat-7.0.82/bin/tomcat-juli.jar
Using CATALINA_PID:    /root/servers/demoServ/logs/catalina.pid
Tomcat started.
```

启动成功，快快打开浏览器访问网址 http://你的域名或IP地址:8080/ 试试！
创建更多的Tomcat服务，就按刚才的过程再做一遍吧！

PS：manager.sh提供的命令如下：

```
Usage: manager.sh ( commands ... )
commands:
  debug             Start Catalina in a debugger
  debug -security   Debug Catalina with a security manager
  jpda start        Start Catalina under JPDA debugger
  run               Start Catalina in the current window
  run -security     Start in the current window with security manager
  start             Start Catalina in a separate window
  start -security   Start in a separate window with security manager
  stop              Stop Catalina, waiting up to 5 seconds for the process to end
  stop n            Stop Catalina, waiting up to n seconds for the process to end
  stop -force       Stop Catalina, wait up to 5 seconds and then use kill -KILL if still running
  stop n -force     Stop Catalina, wait up to n seconds and then use kill -KILL if still running
  configtest        Run a basic syntax check on server.xml - check exit code for result
  version           What version of tomcat are you running?
```

继续，还没完呢:p

**安装MySQL**

```
// 先回到老地方
cd ~
// 下载官方安装包文件
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-5.6.27-1.linux_glibc2.5.x86_64.rpm-bundle.tar
// 解压
tar xvf MySQL-5.6.27-1.linux_glibc2.5.x86_64.rpm-bundle.tar
// 开始安装文件包
rpm -ivh MySQL-client-5.6.27-1.linux_glibc2.5.x86_64.rpm
rpm -ivh MySQL-devel-5.6.27-1.linux_glibc2.5.x86_64.rpm
rpm -ivh MySQL-embedded-5.6.27-1.linux_glibc2.5.x86_64.rpm
rpm -ivh MySQL-shared-5.6.27-1.linux_glibc2.5.x86_64.rpm
rpm -ivh MySQL-shared-compat-5.6.27-1.linux_glibc2.5.x86_64.rpm
rpm -ivh MySQL-test-5.6.27-1.linux_glibc2.5.x86_64.rpm
// 由于CentOS自带的mariadb的包与MySQL的包有冲突，需要先卸载
rpm -qa |grep -i mariadb
yum remove mariadb-libs.x86_64
// 若需要则执行perl安装
yum install -y perl perl-devel
// 安装perl-Data-Dumper模组
yum install -y perl-Data-Dumper
// 继续安装
rpm -ivh MySQL-server-5.6.27-1.linux_glibc2.5.x86_64.rpm
// 安装完毕，由于我使用的是root用户，所以MySQL的用户使用的是root并生成随机密码
// 若失败则尝试执行：/usr/bin/mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/
// 查看生成的随机密码
cat /root/.mysql_secret
// 启动MySQL服务
service mysql start
// 接下来完成MySQL服务的初始化
// 执行命令：
/usr/bin/mysql_secure_installation



NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MySQL to secure it, we'll need the current
password for the root user.  If you've just installed MySQL, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

// 这里输入生成的随机密码
Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MySQL
root user without the proper authorisation.

You already have a root password set, so you can safely answer 'n'.

// 提问你是否需要修改root密码，这里回车确认并输入新密码两次，
Change the root password? [Y/n]
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MySQL installation has an anonymous user, allowing anyone
to log into MySQL without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

// 提问是否移除匿名用户访问，回车确认
Remove anonymous users? [Y/n]
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

// 提问是否禁用root帐户远程登录，回车确认
Disallow root login remotely? [Y/n]
 ... Success!

By default, MySQL comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

// 提问是否移除test数据库，回车确认
Remove test database and access to it? [Y/n]
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

// 重新加载，回车确认，配置完成！
Reload privilege tables now? [Y/n]
 ... Success!




All done!  If you've completed all of the above steps, your MySQL
installation should now be secure.

Thanks for using MySQL!

// 快快登录MySQL试试吧！
mysql -u root -p
```

**安装Nginx**

```
// 查看yum上的Nginx包的版本是1.6的比较老
yum info nginx
// 根据Nginx官方的文档，安装最新的稳定版本
// 新建配置文件，命令如下：
vi /etc/yum.repos.d/nginx.repo
// 文件内容：
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
// :wq保存
// 再次查看Nginx版本是1.8
yum info nginx
// OK，开始安装
yum install nginx
// 启动Nginx
/usr/sbin/nginx -c /etc/nginx/nginx.conf
```

Nginx服务安装配置完毕，更多的Nginx命令如下：

```
// 重新加载配置
/usr/sbin/nginx -s reload
// 停止服务
/usr/sbin/nginx -s stop
// 验证配置文件
/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
```

OK，现在我们的服务器上该有的服务都有了，生产环境快速搭建——分分钟搞定！本次内容介绍完毕，请小伙伴们自己尝试吧，欢迎交流！


### One More Thing

YMP不仅提供便捷的Web及其它Java项目的快速开发体验，也将不断提供更多丰富的项目实践经验。

感兴趣的小伙伴儿们可以加入 官方QQ群480374360，一起交流学习，帮助YMP成长！

了解更多有关YMP框架的内容，请访问官网：http://www.ymate.net/
