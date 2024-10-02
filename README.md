# **AKS Application Deployment using Terraform and GitHub Actions**

## **Overview**
This guide walks through the steps of deploying an application to **Azure Kubernetes Service (AKS)**. We’ll use **Terraform** to build the infrastructure and **GitHub Actions** to automate the deployment process.

## **Prerequisites**
Ensure the following are in place:

- **Azure Account**: Create one at [Azure](https://azure.microsoft.com/en-us/free/).
- **Azure CLI**: [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- **Terraform**: [Install Terraform](https://www.terraform.io/downloads).
- **GitHub Account**: Ensure your source code is hosted on GitHub.
- **Kubernetes CLI (`kubectl`)**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
- **GitHub Actions**: Set up in your repository.

## **1. Infrastructure Setup Using Terraform**

### **1.1 Terraform Directory Structure**
My Terraform project has the following structure:

```bash
├── aks
    ├── cluster.tf
    ├── outputs.tf
    ├── registry.tf
    ├── variables.tf
├── network
    ├── appgateway.tf
    ├── nsg.tf
    ├── variables.tf
    ├── vnet.tf
├── storage
    ├── storage_account.tf
    ├── variables.tf
├── backend.tf
├── main.tf
├── providers.tf
└── variables.tf
```
---

### **1.2 Running Terraform and deploying the application with GitHub Actions**
Create a GitHub Actions workflow to run Terraform and deploy the application.

1. In your GitHub repository, create a file: `.github/workflows/main.yaml`.

```yaml
name: CI/CD Pipeline for Python App on Azure

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    # Step 1: Checkout the code
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Set Azure Credentials
      run: |
        echo "Setting Azure environment variables"
        echo "ARM_CLIENT_ID=${{ secrets.ARM_CLIENT_ID }}" >> $GITHUB_ENV
        echo "ARM_CLIENT_SECRET=${{ secrets.ARM_CLIENT_SECRET }}" >> $GITHUB_ENV
        echo "ARM_SUBSCRIPTION_ID=${{ secrets.ARM_SUBSCRIPTION_ID }}" >> $GITHUB_ENV
        echo "ARM_TENANT_ID=${{ secrets.ARM_TENANT_ID }}" >> $GITHUB_ENV

    # Step 2: Set up Azure CLI
    - name: Azure CLI Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    # Step 3: Initialize Terraform and apply the infrastructure only (ACR, AKS)
    - name: Initialize Terraform
      working-directory: ./terraform
      run: terraform init

    - name: Apply Terraform (Infrastructure Only)
      working-directory: ./terraform
      run: terraform apply -auto-approve 

    # Step 4: Build Docker image for Python app
    - name: Build image
      working-directory: ./my-app
      run: |
        docker build -t saadudeenregistry247.azurecr.io/python-app1:latest .

    # Step 5: Log in to Azure Container Registry (ACR)
    - name: ACR Login
      run: |
        az acr login --name ${{ secrets.ACR_NAME }}

    # Step 6: Push Docker image to ACR
    - name: Push Docker Image
      run: docker push saadudeenregistry247.azurecr.io/python-app1:latest  

    # Step 7: Get External IP of the service (LoadBalancer service)
    - name: Get AKS Credentials
      run: |
        az aks get-credentials --resource-group aksRG --name aks-istio-cluster --overwrite-existing

    # - name: Verify Kubernetes Context
    #   run: kubectl config current-context
    - name: Deploy to AKS
      run: kubectl apply -f ./deployment.yaml  

 

    - name: Get External IP
      run: |
        sleep 30  # Wait for service IP to be provisioned
        # kubectl create namespace my-python-app || echo "Namespace already exists"
        kubectl get service python-app-service1
```

### **2. Secrets Configuration**
In your GitHub repository, go to **Settings** → **Secrets** and add the following secrets:

- `AZURE_CREDENTIALS`: Azure Service Principal credentials.
- `AKS_RESOURCE_GROUP`: The resource group where your AKS cluster is deployed.
- `AKS_CLUSTER_NAME`: Your AKS cluster name.

### **2.1 Application Manifests **
Your Kubernetes manifest files can be located in the `TERRAFORM-AKS` directory.

Example deployment file (`TERRAFORM-AKS/deployment.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-application
spec:
  replicas: 2
  selector:
    matchLabels:
      app: python-app1
  template:
    metadata:
      labels:
        app: python-app1
    spec:
      containers:
      - name: python-app1
        image: saadudeenregistry247.azurecr.io/python-app1:latest
        ports:
        - containerPort: 8000


---
apiVersion: v1
kind: Service
metadata:
  name: python-app-service1
spec:
  selector:
    app: python-app1
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 8000
  type: LoadBalancer
```

---

## **3. Testing and Verifying the Deployment**

1. Push your changes to the `main` branch.
2. GitHub Actions will automatically trigger the deployment pipeline. You can monitor it in the **Actions** tab of your repository.
3. To verify the deployment:
   - Connect to your AKS cluster:
   
     ```bash
     az aks get-credentials --resource-group <Resource Group Name> --name <AKS Cluster Name>
     ```

   - Check the running pods:
   
     ```bash
     kubectl get pods
     ```

4. Access your application via the service’s public IP or configured load balancer.

NB: I INCLUDED ALL THESE IN MY WORKFLOW, YOU CAN CHOOSE TO DO ALL OF THESE AFTER RUNNING YOUR PIPELINE SUCCESFULLY

---

## **4. Cleanup**
To destroy the infrastructure and clean up resources, run:

```bash
terraform destroy
```

---

## **Conclusion**
This documentation provides step-by-step instructions to deploy an application to Azure Kubernetes Service (AKS) using GitHub Actions to run Terraform for provisioning the infrastructure and the deployment of the applicaton. Adjust and modify the configurations based on your project requirements.

---