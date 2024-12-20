# Database backup configuration

Our server runs a scheduled job every day to save a backup of the database to the server’s filesystem. These backups are saved to the /var/backups directory.

The steps to set this up are here as a reference, but do not need to be re-run unless upgrading to a new version of Amazon Linux or OpenMRS. The files needed for this setup are saved in this folder. You can copy/paste them as instructed, making sure to insert credentials as needed where you see a password placeholder in the file. 

SSH to the server and create the database backup script file:

```xml
sudo vi /usr/local/bin/mysqlbackup.sh
```

Copy the contents of the `mysqlbackup.sh script` found in the scheduledJobs folder, making sure to substitute the actual database password where you see the <PASSWORD> placeholder. Paste the contents into the file on the server and save it. 

Update the file permissions and test the script

```xml
sudo chmod 777 /usr/local/bin/mysqlbackup.sh
cd /usr/local/bin/
sudo ./mysqlbackup.sh
```

Create the mysqlbackup.timer file on the server, paste the file contents and save it

```xml
sudo vi /etc/systemd/system/mysqlbackup.timer
```

Create the mysqlbackup.service file on the server, paste the file contents and save it

```xml
sudo vi /etc/systemd/system/mysqlbackup.service
```

Reload the daemon, enable and then start the timer

```xml

sudo systemctl daemon-reload
sudo systemctl enable mysqlbackup.timer
sudo systemctl start mysqlbackup.timer
```

## Troubleshooting

If you see errors with the timer, run the below to diagnose the issue

```xml
systemd-analyze verify /etc/systemd/system/mysqlbackup.*
```

To check the timer status and job logs, run

```xml
sudo systemctl status mysqlbackup.timer
sudo journalctl -u mysqlbackup.service
```