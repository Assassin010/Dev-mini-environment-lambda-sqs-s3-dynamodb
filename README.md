

*Steps

Setup AWS Provider
Setup S3 bucket and Dynamodb table
Setup a (Backend) for the remote state
Setup a lambda role
Setup a Lambda function
Setup SQS queues
Setup Lambda Event Trigger
Setup Workspaces (for environments)
Setup Variables
Setup Terraform.tfvars
 




*Note:
CI\CD Pipeline:  - We can use Jenkins 


${terraform.workspace}" = This information is used to tell Terraform which workspace (Environment) we are in but first you must create the workspace: terraform workspace new dev and terraform workspace new prod for instance. Then switch to dev as exmaple (terraform workspace select dev) and all the infrastructure will be created in the region we specified for dev in our variable (aws region).

To create a Test event action we can do it manually via the trigger under lambda function resource, add test event, save and test.
But we can also setup an automate way.