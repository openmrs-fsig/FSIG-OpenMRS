# Restoring from a database backup

The steps to restore a database from a backup file are below. This should only need to be done if we are upgrading to a new version of OpenMRS or Amazon Linux. 

### Obtaining the database backup file

To restore the database from a backup, you will need to obtain a copy of the database backup file. You can do this using the secure copy command, but first we need to know the name of the file you are trying to copy. 

SSH to the server that has the backup, navigate to the backups directory and list the files in that directory:

```xml
cd /var/backups
ls
```

This command will return a list of backup files in this format: `openmrs-DD-MM-YYYY_05-00-10.zip` example:  **`openmrs-12-12-2024_05-00-10.zip` .** Find the most recent backup and make note of the file name. Update the below command to insert that file name, and then run the command to update the file permissions

```xml
sudo chmod 777 <FILE NAME>
```

Now switch back to your local terminal, making sure you are in the directory where your .pem key is stored, and run the secure copy command to transfer the file to your local computer. Make sure to insert the correct file name and EC2 instance name into the command. 

```xml
scp -i "OpenMRS instance key.pem" ec2-user@<EC2 INSTANCE NAME>:/var/backups/<FILE NAME> .

example command: scp -i "OpenMRS instance key.pem" ec2-user@ec2-13-59-102-88.us-east-2.compute.amazonaws.com:/var/backups/openmrs-2024-10-25_05-30-01.zip .
```

You should now have that file on your local computer. To upload it to a new server, you will again use the secure copy command. Before you can do that, you need to SSH to the new server and create the backups directory to store the file

SSH to new server

```xml
cd /var 
sudo mkdir backups
sudo chmod 777 backups
```

Go back to your local terminal and run the secure copy command. Make sure to insert the correct file name and ec2 instance name

```xml
scp -i "OpenMRS instance key.pem" <FILE NAME> ec2-user@<EC2 INSTANCE NAME>:/var/backups

example command: scp -i "OpenMRS instance key.pem" openmrs-2024-10-25_05-30-01.zip ec2-user@ec2-18-188-138-124.us-east-2.compute.amazonaws.com:/var/backups
```

Now that the file is on the new server, run the below commands to unzip it and move it to the correct place. 

```xml
cd /var/backups
sudo mv <FILE NAME> /
cd /
unzip <FILE NAME>
```

The file will now be stored under `/var/backups` as a sql file. So instead of `openmrs-2024-10-25_05-30-01.zip` it will now be named `openmrs-2024-10-25_05-30-01.sql`

## Restoring the database

Now that the database backup file is on the new server, we can run the steps to restore the database. This should be done after the dependency and TLS configuration, but before the application configuration as we will be using this new database when going through the installation wizard. 

From the new server, run the below commands to connect to MySQL and execute the data restoration:

```xml
mysql -u root -p
CREATE DATABASE openmrs CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE openmrs;
SOURCE /var/backups/<SQL FILE NAME>
```

This may take a few minutes to run as it is restoring all of our data into a new database. Once it is complete, you can proceed to the steps outlined in the Application Configuration page, specifying in the prompts that you will be connecting to an existing database and entering the credentials as needed.