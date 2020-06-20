# Simple Terraform-Ansible-Docker Pipeline

This repository demonstates how a simple pipeline can be done to setup a docker-ready server on AWS using:

- CircleCI - Main executor where terraform and ansible commands will be triggered.
- Terraform - IaaS setup and triggers ansible
- Ansible - Configures EC2 instance (downloads docker and dependencies) and deploys docker container
- Docker - Pulls and serves a simple [app](https://github.com/kdblitz/docker_node_app)

The setup infrastructure(EC2 instances, security group,VPC, etc.) use AWS free tier as of writing. 

After the entire setup if completed, pipeline automatically cleans up the infrastructure (via terraform destroy) to prevent incurring costs.

## Local Execution

### Application Requirements

To run locally, `terraform` and `ansible` must have installed on your machine.

### Running locally
- prepare private and public keys (id_rsa/id_rsa.pub) on inside the root directory of your repository checkout.
- run `terraform init` to download necessary providers
- set `AWS_ACCESS_KEY_ID` on `AWS_SECRET_ACCESS_KEY` environment variables to use AWS provider
- run `terraform apply` to setup infrastructure, default [variables](./variables.tf) have been provided, but can be overriden on CLI as additional parameters

## Required CircleCI Parameters

These environment variables need to be set on CircleCI to deploy on an instance

- `AWS_ACCESS_KEY_ID` - via AWS IAM to access their API
- `AWS_SECRET_ACCESS_KEY` - via AWS IAM to access their API
- `BASE64_PEM_FILE` - base64-encoded* pem file to access via ssh the created instances
- `BASE64_PUB_KEY`- base64-encoded* public key to be attached on the launch EC2 instance

##### * Base64 Encoding files - Full instructions to encode file can be found [here](https://support.circleci.com/hc/en-us/articles/360003540393-How-to-insert-files-as-environment-variables-with-Base64).
