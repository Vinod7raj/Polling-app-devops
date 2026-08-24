# End-to-End DevOps Implementation for Polling Application on Kubernetes

## Project Overview

This project demonstrates a complete end-to-end DevOps implementation for a Polling Application using modern DevOps practices and cloud-native technologies. The objective of the project was to automate the software delivery lifecycle from code commit to production deployment while implementing security, scalability, monitoring, and Kubernetes best practices.

The application consists of:

- React Frontend Application
- Spring Boot Backend Application
- MySQL Database

The project implements:

- Source Code Management using GitHub
- Continuous Integration using Jenkins
- Static Code Analysis using SonarQube
- Multi-Stage Docker Builds
- Docker Compose Orchestration
- Container Registry using Amazon Elastic Container Registry (ECR)
- Kubernetes Deployment using Kops
- Kubernetes Services and Ingress
- Stateful Database Deployment
- Persistent Storage using PVC
- Secure Configuration using ConfigMaps and Secrets
- Network Security using Kubernetes Network Policies
- Monitoring using Prometheus and Grafana
- Automated Deployment Verification

## Project Highlights

- Implemented a complete CI/CD pipeline using Jenkins Declarative Pipeline.
- Integrated SonarQube for frontend and backend code quality analysis.
- Built optimized multi-stage Docker images for React and Spring Boot applications.
- Automated image publishing to Amazon Elastic Container Registry (ECR).
- Deployed a multi-tier application on Kubernetes using Kops.
- Implemented NGINX Ingress Controller with path-based routing.
- Secured workloads using ConfigMaps, Secrets, and Network Policies.
- Deployed MySQL as a StatefulSet with Persistent Volume Claims.
- Configured Prometheus and Grafana for Kubernetes monitoring.
- Implemented readiness and liveness probes for application reliability.
- Automated rolling deployments and rollout verification.
- Diagnosed and resolved real-world Kubernetes networking issues involving Network Policies and Ingress traffic routing.# Architecture

## High-Level Architecture

```text
Developer
    │
    ▼
 GitHub Repository
    │
    ▼
 Jenkins Pipeline
    │
 ┌──┴─────────────┐
 │                │
 ▼                ▼
SonarQube     Docker Build
                 │
                 ▼
          Amazon ECR
                 │
                 ▼
          Kubernetes
                 │
          NGINX Ingress
                 │
       ┌─────────┴──────────┐
       │                    │
       ▼                    ▼
 Frontend Pods        Backend Pods
                            │
                            ▼
                    MySQL StatefulSet
                            │
                            ▼
                        PVC Storage

Monitoring:
Prometheus + Grafana
```

---

# Technology Stack

## Cloud

- AWS EC2
- Amazon ECR

## Source Control

- GitHub

## CI/CD

- Jenkins

## Code Quality

- SonarQube

## Containerization

- Docker
- Docker Compose

## Container Registry

- Amazon Elastic Container Registry (ECR)

## Orchestration

- Kubernetes (Kops)

## Networking

- NGINX Ingress Controller
- Kubernetes Services
- Network Policies

## Monitoring

- Prometheus
- Grafana
- Node Exporter
- kube-state-metrics

## Deployment Workflow

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
Jenkins Pipeline
    │
    ▼
Maven Build
    │
    ▼
SonarQube Analysis
    │
    ▼
Docker Multi-Stage Build
    │
    ▼
Amazon ECR
    │
    ▼
Kubernetes Cluster
    │
    ▼
NGINX Ingress Controller
    │
    ▼
End Users

```
## Application Stack

### Frontend

- React

### Backend

- Spring Boot
- Java 11

### Database

- MySQL

---

# Repository Structure

```text
polling-devops-k8s
│
├── application_code
│   ├── polling-app-client
│   ├── polling-app-server
│   └── docker-compose.yml
│
├── k8s
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   ├── mysql-statefulset.yaml
│   ├── services
│   ├── ingress
│   ├── configmaps
│   ├── secrets
│   ├── pvc
│   └── network-policies
│
├── monitoring
│
├── screenshots
│
├── Jenkinsfile
│
└── README.md
```

---

# Containerization Strategy

The application was containerized using Docker and follows a multi-stage build strategy to produce optimized, lightweight, and production-ready container images.

The solution consists of:

```text
Frontend  → React + NGINX

Backend   → Spring Boot + Java

Database  → MySQL
```

Container images are built through Jenkins and stored inside Amazon ECR before deployment to Kubernetes.

---

# Frontend Container

## Multi-Stage Build Architecture

The frontend application uses a multi-stage Docker build to separate build dependencies from runtime dependencies.

### Stage 1 – Build Stage

Base Image:

```text
node:12.4.0-alpine
```

Responsibilities:

- Installing frontend dependencies
- React application build
- Production asset generation
- Environment-specific configuration injection

Build Argument:

```dockerfile
ARG REACT_APP_API_BASE_URL
```

Environment Variable:

```dockerfile
ENV REACT_APP_API_BASE_URL=${REACT_APP_API_BASE_URL}
```

Application Build Command:

```bash
npm install
npm run build
```

Benefits:

- Faster builds
- Cached dependency installation
- Environment-specific deployments

---

### Stage 2 – Runtime Stage

Base Image:

```text
nginx:1.17.0-alpine
```

Responsibilities:

- Serve compiled React application
- Handle static files
- Act as lightweight reverse proxy

Build output is copied from Stage 1:

```dockerfile
COPY --from=build /app/build /var/www
```

Custom NGINX Configuration:

```dockerfile
COPY nginx.conf /etc/nginx/nginx.conf
```

Application Port:

```text
80
```

Benefits:

- Lightweight runtime image
- Reduced attack surface
- Faster container startup
- Production-grade web serving

---

# Backend Container

The backend application uses a multi-stage Docker build for optimized image generation.

## Stage 1 – Build Stage

Base Image:

```text
maven:3.9.6-eclipse-temurin-11
```

Responsibilities:

- Download Maven dependencies
- Build Spring Boot application
- Package executable JAR file

Dependency Caching:

```bash
mvn dependency:go-offline
```

Build Command:

```bash
mvn clean package -DskipTests
```

Generated Artifact:

```text
webapp.jar
```

---

## Stage 2 – Runtime Stage

Base Image:

```text
eclipse-temurin:11-jre-alpine
```

Only the generated JAR file is copied into the runtime image.

```dockerfile
COPY --from=builder /build/target/*.jar webapp.jar
```

### Security*Enhancement

A dedicated non-root *ser is created:

```dockerfile
RUN*addgroup -S devops && adduser -S v*nod -G devops
``*

Application execution:

```docke*file
USER vinod
```

Benefits:

- *east privilege execution
- Improve* security posture
- Reduced contai*er attack surface*
Application Port:

```text
8080
`*`

Startup Command:

```*ockerfile
ENTRYPOINT *"java","-jar","webapp.jar"]
```

-*-

# Docker Compose Implementation*
Docker Compose was used for local*orches*ration, multi-container developmen*, and CI/CD image generation.

Doc*er Compose Version:

```yaml*version: '3.8'
```

---

## Databa*e Service

Service:

```text
datab*seMysql
```

Image:

```text
mysql*5.7
```

Database:

```text
pollin*_app
```

Port Mapping:

```text
3*06:3306
```

Persistent Storage:

*``text
mysql_data
```

Features:

* Persistent storage
- Automatic in*tialization
- Environment-based co*figuration


---

## Backend Service

Service Name:

```text
pollingServer
```

Image:

```text
<ECR_REPOSITORY>/polling-app-server:${BUILD_NUMBER}
```

Port Mapping:

```text
8080:8080
```

Responsibilities:

- Expose Spring Boot APIs
- Handle business logic
- Connect to MySQL database
- Process authentication and poll management requests

Configuration:

```text
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME
SPRING_DATASOURCE_PASSWORD
```

Dependency:

```text
databaseMysql
```

Networks:

```text
frontend
backend
```

---

## Frontend Service

Service Name:

```text
pollingClient
```

Image:

```text
<ECR_REPOSITORY>/polling-app-client:${BUILD_NUMBER}
```

Port Mapping:

```text
80:80
```

Responsibilities:

- Serve React application
- Consume backend REST APIs
- Route requests through NGINX

Build Argument:

```text
REACT_APP_API_BASE_URL=/api
```

Network:

```text
frontend
```

---

## Docker Network Architecture

The application is separated into two dedicated Docker networks.

### Frontend Network

Purpose:

```text
Frontend ↔ Backend Communication
```

Connected Services:

```text
pollingClient
pollingServer
```

---

### Backend Network

Purpose:

```text
Backend ↔ MySQL Communication
```

Connected Services:

```text
pollingServer
databaseMysql
```

Benefits:

- Segregated traffic
- Improved security
- Controlled communication
- Simplified service discovery

---

## Image Versioning Strategy

Docker images are versioned using Jenkins Build Numbers.

Examples:

```text
polling-app-server:1
polling-app-server:2
polling-app-server:3

polling-app-client:1
polling-app-client:2
polling-app-client:3
```

Benefits:

- Deployment traceability
- Easy rollback
- Immutable releases
- Better CI/CD management

---

# CI/CD Pipeline

## Pipeline Workflow

```text
GitHub
   ↓
Jenkins
   ↓
Maven Build
   ↓
SonarQube Analysis
   ↓
Docker Build
   ↓
Amazon ECR Push
   ↓
Kubernetes Deployment
   ↓
Rollout Verification
```

The CI/CD pipeline is fully automated using Jenkins Declarative Pipeline.

---

## Jenkins Configuration

Configured Tools:

```text
JDK 17
Maven 3.9
Sonar Scanner 8
Docker
Kubectl
```

Managed Credentials:

```text
GitHub Credentials
SonarQube Token
AWS ECR Credentials
```

---

## Source Code Management

Source Code Repository:

```text
GitHub
```

Branch:

```text
main
```

Pipeline Stage:

```text
Fetch Code
```

Activities:

- Authenticate with GitHub
- Clone repository
- Prepare Jenkins workspace

---

## Build Stage

Backend application build:

```bash
mvn install -DskipTests
```

Pipeline Activities:

- Resolve Maven dependencies
- Compile source code
- Package JAR file
- Archive build artifacts

Generated Artifact:

```text
Spring Boot executable JAR
```

---

## SonarQube Integration

### Backend Code Analysis

Technology:

```text
Maven Sonar Plugin
```

Analysis Performed:

- Bugs
- Vulnerabilities
- Code Smells
- Technical Debt
- Maintainability

---

### Frontend Code Analysis

Technology:

```text
Sonar Scanner CLI
```

Analysis Performed:

- JavaScript Quality Checks
- React Code Validation
- Code Smell Detection
- Security Review

---

## Docker Image Build

Pipeline Stage:

```text
Docker Image Build
```

Images are built using:

```bash
docker compose build
```

Generated Images:

```text
polling-app-server
polling-app-client
```

---

## Amazon ECR Integration

Amazon Elastic Container Registry (ECR) is used as the centralized image repository.

Repositories:

```text
polling-app-server

polling-app-client
```

Pipeline Stage:

```text
Upload to ECR
```

Activities:

- AWS Authentication
- Docker Registry Login
- Image Push
- Version Management

---

## Kubernetes Deployment Automation

Images are deployed automatically after a successful build.

Pipeline Stage:

```text
Deploy Kubernetes
```

Commands:

```bash
kubectl set image deployment/backend
kubectl set image deployment/frontend
```

Updated Resources:

```text
Backend Deployment
Frontend Deployment
```

---

## Rollout Verification

Pipeline Stage:

```text
Verify Rollout
```

Commands:

```bash
kubectl rollout status deployment/backend
kubectl rollout status deployment/frontend
```

Benefits:

- Automated deployment validation
- Early failure detection
- Safe production deployment

---

# Kubernetes Deployment

## Kubernetes Cluster

The application is deployed on a Kubernetes cluster provisioned using Kops on AWS.

The deployment follows a three-tier architecture.

```text
NGINX Ingress
      │
      ▼
Frontend Pods
      │
      ▼
Backend Pods
      │
      ▼
MySQL StatefulSet
      │
      ▼
Persistent Volume Claim
```

---

## Namespace Isolation

Dedicated Namespace:

```text
polling
```

Benefits:

- Resource isolation
- Better organization
- Enhanced security
- Easier management

---

## Frontend Deployment

Configuration:

```text
Replicas: 2
Container Port: 80
```

Features:

- Readiness Probe
- Liveness Probe
- High Availability
- Rolling Updates

Resource Configuration:

```text
CPU Request : 100m
CPU Limit   : 250m

Memory Request : 128Mi
Memory Limit   : 256Mi
```

---

## Backend Deployment

Configuration:

```text
Replicas: 2
Container Port: 8080
```

Features:

- Rolling Updates
- Self-Healing
- ConfigMap Integration
- Secret Integration

Readiness Probe:

```text
/api/polls
```

Liveness Probe:

```text
/api/polls
```

Resource Configuration:

```text
CPU Request : 250m
CPU Limit   : 500m

Memory Request : 512Mi
Memory Limit   : 1Gi
```

---

## Configuration Management

Environment configuration is managed using:

```text
ConfigMaps
Secrets
```

Backend pods consume configuration through:

```yaml
envFrom:
  - configMapRef
  - secretRef
```

Benefits:

- No hardcoded configuration
- Environment separation
- Secure deployments

---

## MySQL StatefulSet

Database Type:

```text
MySQL 8
```

Workload Type:

```text
StatefulSet
```

Features:

- Stable network identity
- Persistent storage
- Predictable database behavior

Replica Count:

```text
1
```

---

## Secret Management

Database credentials are stored securely using Kubernetes Secrets.

Stored Values:

```text
MYSQL_ROOT_PASSWORD
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
```

Benefits:

- Secure credential storage
- No hardcoded passwords
- Better secret management

---

## Persistent Storage

MySQL data is stored using a Persistent Volume Claim.

Mount Path:

```text
/var/lib/mysql
```

Benefits:

- Data persistence
- Pod restart recovery
- Stateful application support

---

## Kubernetes Services

### Frontend Service

```text
Type: ClusterIP
Port: 80
```

Purpose:

```text
Expose React Frontend
```

---

### Backend Service

```text
Type: ClusterIP
Port: 80
TargetPort: 8080
```

Purpose:

```text
Expose Backend APIs
```

---

### MySQL Service

```text
Type: ClusterIP
Port: 3306
```

Purpose:

```text
Expose MySQL StatefulSet
```

---

## NGINX Ingress Controller

External traffic enters the cluster through NGINX Ingress.

Routing Rules:

### Frontend

```text
/
 ↓
frontend-service
```

### Backend

```text
/api
 ↓
backend-service
```

Benefits:

- Single entry point
- Path-based routing
- Scalable architecture

---

## Network Policies

Network Policies were implemented to restrict unnecessary pod communication.

### Backend Network Policy

Allowed Sources:

```text
Frontend Pods
Ingress-NGINX Namespace
```

Port:

```text
8080
```

---

### MySQL Network Policy

Allowed Sources:

```text
Backend Pods Only
```

Port:

```text
3306
```

Benefits:

- Restricted database access
- Zero-trust communication model
- Improved security

---

# Monitoring

The monitoring stack was implemented using Prometheus and Grafana.

Components:

```text
Prometheus
Grafana
Node Exporter
kube-state-metrics
```

Monitored Metrics:

- CPU Usage
- Memory Usage
- Disk Utilization
- Network Traffic
- Pod Health
- Node Health
- Deployment Status
- Cluster Resources

---
# Real-World Troubleshooting Experience

During implementation of the project, multiple production-style issues were encountered across CI/CD, Kubernetes networking, authentication, deployment automation, and cluster configuration. The following section describes the troubleshooting approach, root cause analysis, and resolution steps performed during the project.

# Troubleshooting & Root Cause Analysis

## Issue 1: Kubernetes Authentication Failure

### Problem

kubectl commands stopped working.

### Investigation

- Verified cluster health
- Checked AWS credentials
- Reviewed kubeconfig

### Resolution

```bash
kops export kubecfg --admin
```

### Outcome

Restored cluster administration access.

---

## Issue 2: Jenkins Deployment Not Updating

### Problem

New application changes were not visible after deployment.

### Root Cause

Static Docker image tags caused Kubernetes to reuse older images.

### Resolution

Implemented build-number-based image versioning.

Example:

```text
polling-app-server:${BUILD_NUMBER}
polling-app-client:${BUILD_NUMBER}
```

### Outcome

Each deployment used a unique image version.

---

## Issue 3: Amazon ECR Push Failure

### Problem

Jenkins failed while pushing Docker images to ECR.

### Investigation

- Verified AWS credentials
- Verified ECR repositories
- Checked Jenkins credential configuration

### Resolution

Configured Jenkins ECR credentials correctly.

### Outcome

Successful image push automation.

---

## Issue 4: SonarQube Authentication Failure

### Problem

Sonar analysis was failing during Jenkins execution.

### Root Cause

Invalid SonarQube token configuration.

### Resolution

Generated a new token and updated Jenkins credentials.

### Outcome

Successful frontend and backend scans.

---

## Issue 5: HTTP 504 Gateway Timeout During Login and Signup

### Problem

Authentication APIs returned:

```text
504 Gateway Timeout
```

### Investigation

- Verified backend pods
- Verified Services
- Verified Endpoints
- Checked MySQL connectivity
- Analyzed Ingress logs
- Tested APIs directly inside backend pod

Direct testing showed:

```text
POST /api/auth/signup  → 201 Created
POST /api/auth/signin → 401 Unauthorized
```

This proved the application was functioning correctly.

### Root Cause

Backend NetworkPolicy allowed traffic only from frontend pods.

Traffic from ingress-nginx namespace was blocked.

### Resolution

Allowed ingress-nginx namespace communication within the backend NetworkPolicy.

### Outcome

Successfully restored login and signup functionality.

---

## Issue 6: Network Policy Debugging

### Problem

Application worked internally but failed through external access.

### Investigation

Validated traffic path:

```text
Browser
 ↓
Ingress
 ↓
Service
 ↓
Pods
```

### Root Cause

Ingress controller was not explicitly permitted in backend policy rules.

### Resolution

Added namespace selector:

```yaml
namespaceSelector:
  matchLabels:
    kubernetes.io/metadata.name: ingress-nginx
```

### Outcome

Secure and functional ingress-to-backend communication.

---

# Screenshots

## Repository Structure

(Add Screenshot)

## Jenkins Pipeline

(Add Screenshot)

## SonarQube Backend Analysis

(Add Screenshot)

## SonarQube Frontend Analysis

(Add Screenshot)

## Amazon ECR Repositories

(Add Screenshot)

## Kubernetes Pods

(Add Screenshot)

## Kubernetes Services

(Add Screenshot)

## Kubernetes Ingress

(Add Screenshot)

## Application Home Page

(Add Screenshot)

---

# Key Features Implemented

- Jenkins CI/CD Pipeline
- GitHub Integration
- SonarQube Integration
- Docker Multi-Stage Builds
- Docker Compose
- Amazon ECR
- Kubernetes Deployments
- StatefulSets
- ConfigMaps
- Secrets
- Persistent Volume Claims
- NGINX Ingress
- Network Policies
- Readiness Probes
- Liveness Probes
- Resource Requests and Limits
- Prometheus Monitoring
- Grafana Monitoring
- Automated Rolling Deployments
- Real-World Kubernetes Troubleshooting

--

# Future Enhancements

- Deploy workloads using Helm Charts.
- Implement GitOps using ArgoCD.
- Provision infrastructure using Terraform.
- Migrate workloads to Amazon EKS.
- Implement centralized logging using Loki or ELK Stack.
- Configure Horizontal Pod Autoscaling using custom application metrics.
- Integrate security scanning into the CI/CD pipeline.
- Implement blue-green deployment strategy.
- Add Disaster Recovery and Backup automation.-

# Project Outcome

This project successfully demonstrates a production-style DevOps workflow from source code commit to Kubernetes deployment. It incorporates CI/CD automation, containerization, image management, Kubernetes orchestration, persistent storage, networking, security controls, monitoring, and real-world troubleshooting using AWS, Jenkins, Docker, Amazon ECR, Kubernetes, Prometheus, Grafana, SonarQube, React, Spring Boot, and MySQL.
