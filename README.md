# Practical41  
## Timestamp Microservice Deployment on Kubernetes (Kind) – Task 1

The objective of this task is to demonstrate:

- Containerization best practices  
- Secure Kubernetes deployment  
- Namespace isolation  
- Service exposure using NodePort  
- Verification from outside the cluster  

---

### Overview

The **Timestamp Microservice** is a simple Node.js application that returns:

- The **current timestamp**
- The **client IPv4 address**

This repository includes:

- Application source code  
- A secure Dockerfile  
- Kubernetes Deployment & Service manifests  
- Kind cluster configuration  
- Supporting documentation  

### Repository Structure

```text

├── app.js
├── package.json
├── Dockerfile
├── microservice.yaml
└── kind-cluster.yaml
````

### Prerequisites

Ensure the following software is installed with suitable versions:

* Docker
* kubectl
* Kind (Kubernetes in Docker)

### Verify Installation

```bash
docker --version
kubectl version --client
kind --version
```

<img width="1062" height="205" alt="image" src="https://github.com/user-attachments/assets/06c044d2-cef0-4297-9c95-2138c580980e" />


## Getting Started

### Clone the Repository

```bash
git clone https://github.com/HARNESHA/Particle41-Practical.git
cd Particle41-Practical
```
---

## Review Configuration Files

### Dockerfile

* Uses a minimal base image
* Runs the application as a non-root user
* Optimized for security and production usage

### microservice.yaml

**Deployment**

* Minimal required permissions
* Secure `securityContext`
* Runs containers as non-root

**Service**

* NodePort service
* Exposes application on port `32000`
* Accessible from outside the cluster

---

## Environment Setup

### Create a Kind Cluster

```bash
kind create cluster --config kind-cluster.yaml
```

<img width="1195" height="341" alt="image" src="https://github.com/user-attachments/assets/21f195f2-0ea0-4814-8a3b-d42728897cf3" />

---

### Verify Cluster Creation

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

<img width="1482" height="567" alt="image" src="https://github.com/user-attachments/assets/24b3f5dc-d040-40ec-925e-c3ba27be07bb" />

---

## Namespace Setup

### Create a Dedicated Namespace

```bash
kubectl create namespace simple-timestamp
kubectl get namespaces
```

<img width="993" height="267" alt="image" src="https://github.com/user-attachments/assets/711e8edc-4c07-4d89-8be1-6b43241d991f" />

---

## Deploy the Timestamp Service

### Apply the Kubernetes Manifest & Verify Deployed Resources
Ensure all pods are in the **Running** state.

```bash
kubectl apply -f microservice.yaml -n simple-timestamp
```
<img width="1106" height="522" alt="image" src="https://github.com/user-attachments/assets/1828d0cd-4ac6-40e1-91f2-121f43e19561" />

## Access the Service

### Get Node IP Address & Access the Service from Outside the Cluster

```bash
for i in {1..5}; do
  for ip in $(kubectl get nodes -o wide --no-headers | awk '{print $6}'); do
    curl -s --connect-timeout 3 http://$ip:32000 | jq .
    echo "--------------------------------------------"
  done
done
```
<img width="591" height="582" alt="image" src="https://github.com/user-attachments/assets/f683d10a-bc74-4fa3-a66f-f6261f14456e" />

---

## Verification Checklist

* Kind cluster created successfully
* Namespace `simple-timestamp` created
* Deployment running with secure context
* NodePort service exposed on port `32000`
* Service accessible from outside the cluster

---

## Best Practices Followed

* Non-root container execution
* Minimal Docker base image
* Kubernetes `securityContext` enforcement
* Namespace isolation
* Logs written to stdout
* Separation of Deployment and Service

---

## Notes

This setup is intended for development and demonstration purposes.

For production environments, consider:

* Ingress instead of NodePort
* TLS termination
* Resource limits and autoscaling
* Centralized logging and monitoring
