# AKS Deployment Template

This project shows a full CI/CD + Infrastructure deployment setup for Azure AKS.

## Features
- Bicep-based infrastructure provisioning
- Helm-based deployment to AKS
- CI/CD pipelines using GitHub Actions

## Structure
- `/infra` – Bicep files for AKS cluster
- `/charts` – Helm chart to deploy Node app
- `/src` – Sample Node.js app
- `.github/workflows` – CI/CD pipelines

## Diagram
[Insert Architecture Diagram]

## How to Run
1. Deploy infra with Bicep
2. Push to GitHub → triggers CI/CD → deploys to AKS