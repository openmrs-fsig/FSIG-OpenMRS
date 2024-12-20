# Application Configuration

The application installation occurred in the TLS setup. There are a few more things to configure on the server itself for the application to start up properly. 

Create a properties file. OpenMRS uses this during startup to check for and use any custom properties. 

```xml
sudo vi /opt/tomcat/.OpenMRS/openmrs-runtime.properties
```

Insert the below line and save the file:

```xml
application_data_directory=/opt/tomcat/webapps/openmrs/
```

Now change the permissions of this file to be owned by tomcat

```xml
sudo chown -R tomcat /opt/tomcat/.OpenMRS/openmrs-runtime.properties
```

Add the ec2-user to the tomcat group. `ec2-user` is the user that you SSH into the instance as, so this is essentially giving us the same permissions as the tomcat user. This allows us to secure copy logs down to a personal machine and upload files securely as well

```xml
sudo usermod -G tomcat ec2-user
```

After running through these steps, restart tomcat

```xml
sudo systemctl restart tomcat
```

Now you should see the OpenMRS installation wizard when you go to the openmrs page(ex: https://sandbox.fsig-mrs.com/openmrs). If you are setting up a fresh instance of OpenMRS, you can go through these installation prompts however you’d like. If you are trying to restore OpenMRS data from a backup, follow the instructions <LINK>