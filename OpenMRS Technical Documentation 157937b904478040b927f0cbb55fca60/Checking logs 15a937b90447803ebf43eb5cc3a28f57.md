# Checking logs

One of the first places to start looking when troubleshooting is the application logs. You can find these in a few different ways. 

# OpenMRS UI

If you only want to see the most recent log entries, you can log into the OpenMRS UI and navigate to the legacy administration page and click on the view server logs option. This will bring up the latest ~500 lines of log entries from the catalina.out log file.

# View logs from server

If you need more information, you can SSH to the server and look at the logs directly from the server terminal window. See the EC2 Instance Access page for information on connecting to the instance. 

Once you have connected to the server, navigate to the logs directory and run `ls` to view the contents. 

```xml
cd /opt/tomcat/logs/
ls
```

There will be a log files for specific dates if you need to look at an issue from a certain day. To get the latest logs from the current day, you can open the catalina.out file

```xml
sudo vi catalina.out
```

# Copy logs to local machine

If you want to take a closer look at the logs you can copy them down to your local machine. This allows you to open the log file in your favorite text editor and search for specific strings or patterns. Instructions for copying logs to your local computer are in the EC2 Instance Access and File Retrieval page