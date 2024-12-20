# Dependency Configuration

These are the steps ran to configure the server for the OpenMRS application. This includes setting up the application dependencies, Java, Tomcat and MySQL. 

These steps should only need be run again if we are upgrading any dependency version, or upgrading to a new version of the Amazon Linux operating system. We have saved AMIs that already have this configuration completed that you can use to launch an EC2 instance without having to redo these steps. 

In case of an upgrade, launch a fresh EC2 instance running Amazon Linux, SSH to the server, and run the below commands in the server’s terminal to configure the application dependencies. 

### install java and tomcat

These commands install Java 11 and Tomcat 9.0.31

```xml
sudo dnf update -y
sudo dnf install java-11 -y
wget [https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.31/bin/](https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/)[apache-tomcat-9.0.31.tar.gz](https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz)  
tar -xvf [apache-tomcat-9.0.31.tar.gz](https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz)

sudo mv [apache-tomcat-9.0.3](https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz)1 /opt/tomcat
sudo rm apache-tomcat-9.0.31.tar.gz
```

These commands create a user and a group on the server for Tomcat. The OpenMRS application runs as the tomcat user, so these are the permissions the application will have on the server. 

```xml
sudo groupadd --system tomcat
sudo useradd -M -d /opt/tomcat -g tomcat tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
```

Create systemd service file. This is the tomcat configuration that is called whenever the tomcat service is started, shutdown or restarted. The below command creates the file.

```xml
sudo nano /etc/systemd/system/tomcat.service
```

Write the below contents to the file and save it. 

```xml
[Unit]
Description=Apache Tomcat 9 
After=network.target syslog.target

[Service]
User=tomcat
Group=tomcat
Type=oneshot
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
RemainAfterExit=yes
ReadWritePaths=/opt/tomcat/
ReadWritePaths=/opt/tomcat/webapps/
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```

The below commands reload the daemon(needed whenever changes to the systemd service file are made), enable the tomcat service, start the tomcat service, and check on its status. 

```xml
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat
```

Now we need to create a tomcat user for the application to use. Use the below command to create a tomcat-users.xml file:

```xml
sudo nano /opt/tomcat/conf/tomcat-users.xml
```

Write the below contents to the file and save it:

```xml
<role rolename="tomcat"/>
<role rolename="admin"/>
<role rolename="manager"/>
<role rolename="manager-gui"/>
<user name="admin" password="+@99_#6Y9bZj" roles="tomcat,admin,manager,manager-gui"/>
```

Configure tomcat remote login by opening the below files and removing the following lines:

```xml
sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
```

```xml
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> 
```

Configure tomcat log rotation to delete application logs after 1 week. This is important to ensure we do not run out of server space, if this is not done then logs will accumulate indefinitely. Open the logrotate file:

```xml
sudo vi /etc/logrotate.d/tomcat
```

Insert the below contents and save the file:

```xml
/opt/tomcat/logs/catalina*.* {
    copytruncate
    daily
    rotate 7
    compress
    missingok
    size 100M
}
```

Restart tomcat:

```xml
sudo systemctl restart tomcat
```

### Install MySQL

Run the below commands to install MySQL 8

```xml
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm 
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo dnf install mysql-community-server -y
sudo systemctl start mysqld
```

Open the config file

```xml
sudo vi /etc/my.cnf
```

Add the following line to the config file and save it:

```xml
skip-grant-tables
```

restart mysql

```xml
sudo systemctl restart mysqld
```

Connect to MySQL as the root user and configure the root password. Make sure to insert the actual password where there is the <ROOT PASSWORD> placeholder. 

```xml
mysql -u root -p
FLUSH PRIVILEGES;
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '<ROOT PASSWORD>';
FLUSH PRIVILEGES;
exit
```

Restart the MySQL service and test connecting as the root user, entering the password when prompted:

```xml
sudo systemctl restart mysqld
mysql -u root -p
```

With the above commands completed, the server is now configured with the dependencies needed to run the OpenMRS application. I recommend taking an AMI snapshot of the instance in AWS to use as a new base image for the rest of the application configuration.