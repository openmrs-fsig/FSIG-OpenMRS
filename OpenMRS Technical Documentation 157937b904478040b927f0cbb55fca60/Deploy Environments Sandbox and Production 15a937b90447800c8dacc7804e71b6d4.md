# Deploy Environments: Sandbox and Production

The OpenMRS application is deployed manually through the AWS dashboard. There are two main environments used, the production environment which is the live application being used in the clinic, and the sandbox environment which is a testing space that does not handle live clinic traffic but can be provisioned for testing purposes. 

# Sandbox

The sandbox environment is used for testing new changes, troubleshooting issues, and performing validation in a non-live environment. It is recommended to use the sandbox environment to test installing new modules or troubleshooting issues and bugs that are happening in production. 

This environment is normally de-provisioned, meaning the server is shut down, in order to save on costs as we pay per hour of server utilization. To provision a sandbox environment you can either restart the existing sandbox environment or launch a new one following the steps in the section above. It is recommended to use the existing sandbox environment as it is populated with test data, but there are instance you may need to start fresh if updating dependencies or TLS domain. 

## Restarting the existing sandbox EC2 instance

1. Log into AWS dashboard and navigate to the EC2 management page. Under the Instances section, you should see one named OpenMRS Sandbox with an instance state of `Stopped`. If it is not there, make sure you are filtering instances in `All States` . 
2. Select the OpenMRS Sandbox instance checkbox, click the Instance State dropdown in the top righthand corner, and select `Start Instance` 
    1. As the instance is provisioning, it will generate a new IP address for the server. You can find this by clicking on the instance details and looking for the Public IPv4 Address. 
3. Take the new IP address found in step 2a and navigate to Route53. Under the hosted zone fsgi-mrs.com, create a new DNS record for the sandbox environment. This record should be an A type record, enter sandbox as the name and the IP address as the value
    1. if there is an existing record for sandbox, delete it
        
        ![Screenshot 2024-12-19 at 12.54.00 PM.png](Deploy%20Environments%20Sandbox%20and%20Production%2015a937b90447800c8dacc7804e71b6d4/Screenshot_2024-12-19_at_12.54.00_PM.png)
        

After these steps are completed you should be able to access the sandbox environment at [https://sandbox.fsig-mrs.com/openmrs](https://sandbox.fsig-mrs.com/openmrs). Note that it may take up to 10 minutes for the server to provision and the application to start up. 

### De-provisioning the sandbox environment

Once you are done using the sandbox environment, go to the EC2 management page, select the sandbox environment and click the Instance State dropdown in the top righthand corner and select Stop Instance. This will de provision the instance but keep it around for future use. 

# Production

This environment is actively handling traffic and requests from the clinic staff and storing actual patient data. Production is a running environment and should not need to be deployed to on a regular basis. It would need to be redeployed if we are upgrading to a new version of OpenMRS or Amazon Linux. Note that redeploying the production environment should be done after clinic hours so as to not disturb the workflow of the clinic. 

The steps below outline how to switch seamlessly from the old production environment to the new one. If you have not yet prepared the new server to the point where it is ready to handle live traffic, see the instructions on this page for launching a new EC2 instance and the Server Configuration and Database sections for the information you need to set up the application for use and populate it with a database backup. From here on, the instructions assume you have a fully configured production environment that is ready for use. 

1. In the AWS dashboard, navigate to the EC2 management page and find the EC2 instance for the new production environment. In the instance details, find the IP address of this server. 
2. Navigate to Route53 to the [fsig-mrs.com](http://fsig-mrs.com) hosted zone and delete the existing production A type record. This is the one with record name [fsig-mrs.com](http://fsig-mrs.com) and the record type A. Do not delete the production records with type NS or SOA. 
3. Create a new production A type record. The record name will be blank as we are creating the root domain record. Under Value, enter the instance IP address

After these steps are completed you should be able to access the production environment at [https://fsig-mrs.com/openmrs](https://fsig-mrs.com/openmrs). Note that it may take up to 5 minutes for the DNS record change to propagate.