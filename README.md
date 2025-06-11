# DevOps on Azure – githubdhina-devops-azure

This repository contains hands-on DevOps implementations and automation practices for deploying and managing Azure cloud infrastructure efficiently. It's a curated collection of tools, templates, and scripts used in real-world Azure DevOps workflows.

## 🚀 What’s Inside

- ✅ **Azure CLI Scripts**: Provision VMs, VNets, NSGs, Subnets, Route Tables, and more.
- ✅ **Bicep Templates**: Infrastructure as Code (IaC) to deploy scalable Azure resources.
- ✅ **ARM Templates**: Pre-Bicep examples for backward compatibility and learning.
- ✅ **GitHub Actions CI/CD**: Automate your build and deployment pipelines to Azure.
- ✅ **AKS (Azure Kubernetes Service)**: Cluster provisioning and deployment samples.
- ✅ **Cloud-init Examples**: Automate VM configuration on creation using cloud-init.
- ✅ **Azure DevOps Pipelines (YAML)**: Optional examples using Azure Pipelines.

## 📁 Folder Structure
  /azure-cli-scripts → Shell scripts for provisioning and config
  /bicep-templates → Modern IaC using Bicep
  /arm-templates → Legacy IaC with ARM JSON
  /github-actions → GitHub Actions CI/CD workflows
  /aks-deployment → Kubernetes YAML + AKS integration
  /cloud-init → Examples for VM bootstrap

## 🛠 Requirements

- Azure CLI (`az`)
- Bicep CLI (or use built-in in `az`)
- Git
- GitHub account (for CI/CD workflows)

## 🧪 Usage

Clone the repo:
```bash
git clone https://github.com/<yourusername>/githubdhina-devops-azure.git

cd azure-cli-scripts
./create-vm.ps1
```

## 🙌 Contribution:
Pull requests and feedback are welcome. Let's build better cloud-native infrastructure together!

## 📜 License:
This project is licensed under the MIT License.
