# AzureBatchCICD

A complete boilerplate for an Azure Batch job with CI/CD.

The needs setup, so don't expect a clone and run esxperince.


## Azure resources provisioning
Provision of Azure resources is done with Terraform.
Configurations of VM Sizes and count, can be done in the tfvar file: https://github.com/ChristianHenrikReich/AzureBatchCICD/blob/main/terraform/terraform.tfvars

## Code
It is an example of how to write the code in Go. Feel free to use any language, Go was chosen because
it compiles to one binary file.

To build an Application Package, create a zip file and use az cli, Python or C# to deploy it.

Disclaimer, All is under own responsibilities. Note that the job is not closed down.

