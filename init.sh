#/bin/sh

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

echo "OK"
