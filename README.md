## Table of Contents

- [Prerequisites](#Prerequisites)
- [Overview](#Overview)
- [Purpose](#Purpose)
- [Authors](#Authors)

## Prerequisites

- Terraform: [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Ansible: [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Overview

This repositroy contains two completed optional tasks:
* Deploy a wordpress platform using Ansible
* Create a custom VPC using Terraform

## Purpose

The first automation script is responsible for deploying wordpress using Ansible to the remote host. It installs all required packages, set mysql users and database, downloads wordpress and unarchives it to /var/www/html/

The second automation script is responsible for creating custom VPC in AWS. It creates security group, creates public and private subnets, provides internet acccess to VPC

## Authors
* Daniil Jenotov [@dann-dann](https://www.github.com/dann-dann)
* Eriks Masinskis [@skilet16](https://www.github.com/skilet16)
* Batyrlan Bakytbekov [@BatyrlanBakytbekov](https://www.github.com/BatyrlanBakytbekov)
