````markdown
# Practical41 – Task 1  
## Timestamp Microservice Deployment on Kubernetes (Kind)

This document provides a complete walkthrough for **Task 1 of Practical41**, covering the setup, deployment, and verification of a **Timestamp Microservice** on a Kubernetes cluster using **Kind**, **Docker**, and **kubectl**.

The objective of this task is to demonstrate:

- Containerization best practices  
- Secure Kubernetes deployment  
- Namespace isolation  
- Service exposure using NodePort  
- Verification from outside the cluster  

---

## Overview

The **Timestamp Microservice** is a simple Node.js application that returns:

- The **current timestamp**
- The **client IPv4 address**

This repository includes:

- Application source code  
- A secure Dockerfile  
- Kubernetes Deployment & Service manifests  
- Kind cluster configuration  
- Supporting documentation  

---

## Repository Structure

```text

├── app.js
├── package.json
├── Dockerfile
├── microservice.yaml
└── kind-cluster.yaml
````

---

## Prerequisites

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

![Prerequisites Verification](images/step-2-prerequisites.png)

---

## Getting Started

### 1️⃣ Clone the Repository

```bash
git clone <repository-url>
cd <repository-name>
```

![Repository Cloned](images/step-1-clone.png)

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

![Configuration Review](images/step-5-deployment.png)

---

## Environment Setup

### Create a Kind Cluster

```bash
kind create cluster --config kind-cluster.yaml
```

![Kind Cluster Creation](images/step-3-kind-cluster.png)

---

### Verify Cluster Creation

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

![Cluster Verification](images/step-3-kind-cluster.png)

---

## Namespace Setup

### Create a Dedicated Namespace

```bash
kubectl create namespace simple-timestamp
kubectl get namespaces
```

![Namespace Verification](images/step-4-namespace.png)

---

## Deploy the Timestamp Service

### Apply the Kubernetes Manifest

```bash
kubectl apply -f microservice.yaml -n simple-timestamp
```

![Deployment Applied](images/step-5-deployment.png)

---

### Verify Deployed Resources

```bash
kubectl get all -n simple-timestamp
kubectl get pods -n simple-timestamp
```

Ensure all pods are in the **Running** state.

![Pods Running](images/step-6-pods.png)

---

## Access the Service

### Get Node IP Address

```bash
kubectl get nodes -o wide
```

![Node IP Details](images/step-7-node-ip.png)

---

### Access the Service from Outside the Cluster

```bash
curl http://<NODE_IP>:32000
```

![Curl Output](images/step-8-curl.png)

#### Sample Response

```json
{
  "timestamp": "2025-12-22T13:14:02.593Z",
  "ip": "172.17.0.1"
}
```

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

```