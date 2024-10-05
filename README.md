# Misconfig Cloud Terraform Modules

This repository contains Terraform modules designed for **Misconfig Cloud** services. These modules help automate the setup of roles, policies, and configurations across customer AWS accounts, ensuring secure and efficient management of cloud resources.

## Table of Contents
1. [Introduction](#introduction)
2. [Available Modules](#available-modules)
3. [Usage](#usage)
   1. [Terraform Init](#terraform-init)
   2. [Terraform Apply](#terraform-apply)
4. [Security and Secrets](#security-and-secrets)

## Introduction

Welcome to the **Misconfig Cloud Terraform Modules** repository. The goal of this repository is to provide reusable, modular, and secure Terraform configurations for setting up and managing customer AWS accounts, policies, and roles.

This repository will grow with additional modules that can be used to manage specific parts of your cloud infrastructure, with a focus on security and compliance.

## Available Modules

### 1. EventBridge Ingestion
- **Purpose**: Allows Misconfig Cloud to assume roles in customer AWS accounts for onboarding the customers via CloudFormation to create the necessary EventBridge resources.
- **Path**: `./eventbridge-ingestion/`

## Usage

### Terraform Init

Before applying any module, make sure to initialize the Terraform working directory:

```bash
terraform init
```

This will download the necessary provider plugins and prepare your environment.

### Terraform Apply

Once initialized, you can apply any module from this repository by running:

```bash
terraform apply
```

## Security and Secrets

**External ID:** This is a critical secret used for role assumption and must be treated securely. 

Store it in an appropriate secret management service such as AWS Secrets Manager or HashiCorp Vault.

Do not hardcode sensitive information in your Terraform configurations or within the repository. Keep the `terraform.tfstate` file safe.