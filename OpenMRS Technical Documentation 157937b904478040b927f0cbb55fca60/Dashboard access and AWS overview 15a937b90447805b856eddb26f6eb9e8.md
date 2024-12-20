# Dashboard access and AWS overview

# Dashboard access and setup

To access our AWS account, go to <LOGIN LINK> and use the following credentials: <root user creds>. Logging in will prompt you to complete 2-factor authentication, log into the Funsalud gmail account to do so. Now that you have access to the AWS dashboard, you can follow along this guide to check out the services we use to support OpenMRS. 

All of our services are active in the Ohio `us-east-2` AWS region. When logged in, you can verify you are in the correct region by clicking the dropdown in the upper right corner and selecting the Ohio us-east-2 region.

![Screenshot 2024-12-12 at 1.22.00 PM.png](Dashboard%20access%20and%20AWS%20overview%2015a937b90447805b856eddb26f6eb9e8/Screenshot_2024-12-12_at_1.22.00_PM.png)

## EC2

Our application runs on Amazon EC2. An EC2 instance is essentially just a server that we rent from Amazon. Type EC2 into the navigation bar to access the EC2 management page. This page shows the list of running instances as well as any stopped instances that have not yet been terminated. Clicking the instance ID will bring up a page that shows more details about that particular instance such as its IP address, hostname, instance type, networking, security and storage information.

For more information on deploying, accessing, and managing an EC2 instance please see Instance Deployment and Access page. 

# AMIs

An AMI is an Amazon Machine Image that is essentially a template use to create a server. Enter AMI into the navigation bar to see the AMI management page. The base AMI used is the Amazon Linux 2023 AMI. This is the AMI used to launch our first EC2 instance. On this instance, the server configuration steps are completed we took a new AMI snapshot is taken of our server after each important step. This allows us to launch a new EC2 instance from a certain stage of our configuration instead of having to repeat the configuration steps every time we want to make a change. 

![Screenshot 2024-12-12 at 12.28.12 PM.png](Dashboard%20access%20and%20AWS%20overview%2015a937b90447805b856eddb26f6eb9e8/Screenshot_2024-12-12_at_12.28.12_PM.png)

For example, if we want to set up a new domain for testing, such as `test.fsig-mrs.com`, we can launch the `Amazon Linux with Dependencies` AMI so that the server we start up is already configured with the application’s dependencies. If we wanted to try out a database restoration in our sandbox instance, you could use the `Amazon Linux Sandbox TLS` AMI to launch a server that has dependencies and TLS configured, ready for the application installation steps. 

## Taking an AMI snapshot

If you make a big change to the system and want to capture the state of the server as a new template to launch instances from, you can take a new AMI snapshot. This should be done after clinic hours as it does temporarily stop the instance. To do this, go to the EC2 page, select the instance you want to snapshot, go to the Actions dropdown menu and select Image and templates, then click Create Image. You can enter a name for this image and in a few minute it will be ready to use. 

![Screenshot 2024-12-12 at 12.35.10 PM.png](Dashboard%20access%20and%20AWS%20overview%2015a937b90447805b856eddb26f6eb9e8/Screenshot_2024-12-12_at_12.35.10_PM.png)

## Launching an instance from an AMI

From the EC2 page, select Launch Instance. In the Application and OS Images section, select `My AMIs` and click on the AMI dropdown to select the AMI you’d like to use. For more information on launching instances, see the Instance Access and Deployment page.

# Route 53

Route 53 is Amazon’s DNS service. We use it to create DNS records that link the IP address of our server’s to the domain name we use to access the application. To see the management page, enter Route 53 into the navigation bar, then click on Hosted Zones in the left sidebar. Select the [`fsig-mrs.com`](http://fsig-mrs.com) hosted zone to view our DNS records. It should look something like the below:

![Screenshot 2024-12-12 at 12.41.25 PM.png](Dashboard%20access%20and%20AWS%20overview%2015a937b90447805b856eddb26f6eb9e8/Screenshot_2024-12-12_at_12.41.25_PM.png)

Take note of the second column here which denotes record type. You should not have to interact with the NS and SOA type records at all. The A type records are the ones that associate IP addresses with domain names. The top record, [`fsig-mrs.com`](http://fsig-mrs.com) is the record used for our production server that is handling live clinic traffic. This record should only be updated when we are migrating the application to another server. 

The bottom record, [`sandbox.fsig-mrs.com`](http://sandbox.fsig-mrs.com) will be updated more frequently, whenever we spin up a new instance of the sandbox environment. This new instance of the sandbox will have a new IP address, so you will have to note that IP address and then delete the existing sandbox record and create a new one that routes traffic to the new instance IP. 

You can also create new records for other subdomains. If you are trying to set up TLS for a new domain `test.fsig-mrs.com`, you would first have to create that record here and associate it with the IP address of the server you are trying to configure. 

### Billing

To view and update billing information, enter Billing and Cost Management in the navigation bar. This will show you the cost breakdown information, previous bills and other cost info. 

To update payment methods, select `Payment Preferences` from the left sidebar.