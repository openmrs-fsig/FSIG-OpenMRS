# EC2 instance access and file retrieval

### EC2

Our application is running on an EC2 server in the us-east-2 region. In the AWS navigation bar, type EC2 to find the management panel. You should see a list of any running EC2 instances. To view more information, click on the instance ID to see networking, storage, security, and general information about the instance. 

### SSH to instance

In order to access the server terminal, you will need a .pem key saved on your local machine. This key is saved on the Funsalud google drive as “[OpenMRS instance key.pem](https://drive.google.com/file/d/1zejBtVI427NDjI3WA4Tct-SWr-OHixig/view?usp=drive_link)”. Download this key and remember where you saved it as that directory is where you must be in your terminal to successfully connect to the server. 

In AWS management console, go to the EC2 page and select the instance you want to connect to. Click the Connect button in the top right corner. This will give you an example connection string to use, such as:

```xml
ssh -i "OpenMRS instance key.pem" root@ec2-18-217-106-116.us-east-2.compute.amazonaws.com
```

Take this string, and update it to use `ec2-user` instead of `root` . It should now look like this:

```xml
ssh -i "OpenMRS instance key.pem" ec2-user@ec2-18-217-106-116.us-east-2.compute.amazonaws.com
```

In your local terminal, navigate to the directory where you have your pem key saved and enter the above connection string command. This should open a terminal session to the server itself, it will look similar to the below. Any commands you enter from this terminal window are made on the EC2 instance. 

![Screenshot 2024-12-12 at 1.18.14 PM.png](EC2%20instance%20access%20and%20file%20retrieval%2015a937b904478007b12ce66c4686cc57/Screenshot_2024-12-12_at_1.18.14_PM.png)

To exit the EC2 terminal, enter `exit`. This will bring you back to your local computer’s terminal. If you’d like to run commands on both your local and the EC2 instance without having to exit, you can just open a separate terminal window and make sure you know which is which. 

### Copy files from EC2 instance to local computer

You can use the secure copy command to copy files to/from an ec2 instance. To do so, you must run the command from your local terminal in the directory that contains the .pem key. Make sure to enter the correct instance hostname and path to the file you are try to copy. 

```xml
scp -i "OpenMRS instance key.pem" ec2-user@<INSTANCE HOSTNAME>:<PATH TO FILE> .

example:
scp -i "OpenMRS instance key.pem" ec2-user@[ec2-18-188-51-110.us-east-2.compute.amazonaws.com](mailto:root@ec2-18-188-51-110.us-east-2.compute.amazonaws.com):/opt/tomcat/logs/catalina.out .

```

This example copies the `catalina.out` file located at `/opt/tomcat/logs/catalina.out` from the specified server to your local computer. 

### Copy files from local computer to EC2 instance

The secure copy command works the other way around as well. You must still run this command from your local terminal in the directory that contains the .pem key. Here, the <PATH TO FILE> should be replaced with the location of the file on your computer(note that if the file is within your current folder, the path will just be the file name). The <PATH ON SERVER> should be the location you want to place the file on the ec2 instance. 

```xml
scp -i "OpenMRS instance key.pem" <PATH TO FILE> ec2-user@<INSTANCE HOSTNAME>:<PATH ON SERVER>>

example: 
scp -i "OpenMRS instance key.pem" openmrs-2024-09-25_05-30-01.zip ec2-user@[ec2-18-188-51-110.us-east-2.compute.amazonaws.com](mailto:root@ec2-18-188-51-110.us-east-2.compute.amazonaws.com):/var/backups

```