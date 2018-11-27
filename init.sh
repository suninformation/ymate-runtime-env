#/bin/sh
cd `dirname $0`
CURRENT_DIR=`pwd`

echo "Unpacking JDK..."
cat jdk.*|tar -zx
tar zxf jdk-8u151-linux-x64.tar.gz

echo "Unpacking Maven..."
tar zxf apache-maven-3.1.1-bin.tar.gz

echo "Unpacking Tomcat..."
tar zxf apache-tomcat-7.0.82.tar.gz

echo "Unpacking MySQL..."
cat mysql.*|tar -zx
tar xf MySQL-5.6.27-1.linux_glibc2.5.x86_64.rpm-bundle.tar

ln -s -b apache-tomcat-7.0.82 apache-tomcat-7.x

echo "-----------------------------------------------------"
echo "Please add the following in the ~/.bash_profile file:"
echo "-----------------------------------------------------"

echo "JAVA_HOME=$CURRENT_DIR/jdk1.8.0_151"
echo "MAVEN_HOME=$CURRENT_DIR/apache-maven-3.1.1"
echo "CATALINA_HOME=$CURRENT_DIR/apache-tomcat-7.x"
echo ""
echo "PATH=\$PATH:\$HOME/.local/bin:\$HOME/bin:\$JAVA_HOME/bin:\$MAVEN_HOME/bin"
echo ""
echo "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar"
echo "export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8"
echo "export MAVEN_OPTS=-Dfile.encoding=UTF-8"
echo ""
echo "export JAVA_HOME"
echo "export MAVEN_HOME"
echo "export CATALINA_HOME"
echo ""
echo "export PATH"
echo "-----------------------------------------------------"

echo "OK"
