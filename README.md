
# Azure Web App Infrastructure Deployment - Technical Assessment

This repository contains a demonstration of an Azure cloud infrastructure solution to support a web-based application, designed as part of a technical assessment. It showcases the use of Bicep templates and a YAML pipeline for Azure DevOps to deploy and manage the resources. The solution meets the requirements outlined in the attached **Technical Assessment PDF** and includes the accompanying **architecture diagram**.

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture Overview](#architecture-overview)
- [Repository Structure](#repository-structure)
- [Key Features](#key-features)
- [How to Use](#how-to-use)
- [References](#references)

---

## Project Overview

The goal of this project is to demonstrate:
- The ability to design secure, scalable, and maintainable cloud infrastructure using Azure services.
- Proficiency in Infrastructure-as-Code (IaC) with **Bicep**.
- Automation of deployments using **Azure DevOps pipelines**.
- Adherence to best practices for security, compliance, and high availability.

The requirements, as outlined in the attached [Technical Assessment PDF](Technical%20Assessment.pdf), include:
- A web application for patients and healthcare professionals.
- A backend API with its own SQL database.
- Storage for binary data like images and PDFs.
- Secure configuration management.
- Protection of all public-facing endpoints.
- Private and secure connectivity between components.

---

## Architecture Overview

![Architecture Diagram](Web%20App.drawio.png)

The solution follows a **Hub and Spoke** architecture with the following key features:
- **Azure Front Door Premium** for global traffic distribution and Web Application Firewall (WAF) protection.
- **App Services** for hosting the web application and APIs, integrated into private subnets via Private Endpoints.
- **Azure SQL** with Private Endpoints for secure database connectivity.
- **Key Vault** for secure management of secrets and configuration.
- **Storage Accounts** for binary data storage with lifecycle policies to meet compliance requirements.
- Centralized **logging and telemetry** with Log Analytics and Application Insights.

Refer to the [Technical Assessment PDF](Technical%20Assessment.pdf) for detailed requirements and design decisions.

---

## Repository Structure

```
.
├── bicep/
│   ├── app-service.bicep             # Bicep template for App Services
│   ├── sql.bicep                     # Bicep template for Azure SQL
│   ├── storage.bicep                 # Bicep template for Storage Account
│   ├── key-vault.bicep               # Bicep template for Key Vault
│   └── network.bicep                 # Bicep template for networking resources
├── pipeline/
│   └── cicd.yml                      # Azure DevOps YAML pipeline
├── Web App.drawio.png                # Architecture diagram
├── Technical Assessment.pdf          # Problem statement and solution details
└── README.md                         # Project documentation
```

Note: Some templates are placeholders and not fully implemented as this is a conceptual demonstration, not a complete working solution.

---

## Key Features

- **Separation of Concerns**: Frontend and backend are deployed as separate App Services, with isolated access and private connectivity.
- **Security First**:
  - End-to-end HTTPS enforced for all traffic.
  - Use of Private Endpoints for all critical resources (SQL, Key Vault, Storage).
  - Managed identities for secret-less authentication.
  - WAF policies to protect against common threats.
- **Compliance**:
  - Storage lifecycle policies to delete binary data after 180 days.
  - Logs and telemetry retained for 90 days.
- **Scalable Design**:
  - Supports deployment to multiple regions (e.g., UK South, UK West) and environments (e.g., Dev, Test).

---

## How to Use

### Prerequisites
1. **Azure Subscription**: Ensure you have sufficient permissions to deploy resources.
2. **Azure DevOps**: Set up a project with a pipeline using the provided YAML file.
3. **Self-Hosted Agents**: Configure agents with access to the deployment environment.

### Deployment Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/nickcherrill/demo-webapp.git
   cd demo-webapp
   ```
2. Review and customize Bicep templates under the `bicep/` directory as needed.
3. Configure the Azure DevOps pipeline using `pipeline/cicd.yml`.
4. Execute the pipeline to deploy resources to your environment.

---

## References

- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/)
- [Technical Assessment PDF](Technical%20Assessment.pdf)
- [Architecture Diagram](Web%20App.drawio.png)

---

Feel free to extend the repository by completing the placeholder templates, adding application code, or implementing enhancements such as monitoring dashboards, cost management, or additional security layers.
