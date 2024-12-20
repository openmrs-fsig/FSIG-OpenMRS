# System Maintenance

# Manual

There are occasionally server level updates that can be made when packages used by the server can be upgraded. Every 3 months you can SSH to the server and run these with the command:

```xml
sudo dnf update -y
```

This will update the software libraries and packages used by Amazon Linux to their latest versions. 

# Automatic

There is also some OpenMRS system maintenance that is configured to run on auto-pilot. 

Each day our server makes a database backup that is stored to the filesystem. For more information on that, see the Database backup configuration page. Additionally, every month a scheduled job runs to renew the TLS certificate for our domain. This happens on the first of every month, for more information on this job see the TLS configuration page.