# Monitoring Setup

## Overview

This project uses the Kubernetes monitoring stack based on:

- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- kube-state-metrics

The monitoring stack was deployed using the Prometheus Community Helm Chart (`kube-prometheus-stack`).

---

# Create Monitoring Namespace

```bash
kubectl create namespace monitoring
```

---

# Install Monitoring Stack

Add the Prometheus Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Update Helm repositories:

```bash
helm repo update
```

Install kube-prometheus-stack:

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring
```

---

# Verify Monitoring Components

Check pods:

```bash
kubectl get pods -n monitoring
```

Expected components:

- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- kube-state-metrics
- Prometheus Operator

---

# Verify Services

```bash
kubectl get svc -n monitoring
```

---

# Grafana Access

Convert Grafana service from ClusterIP to NodePort.

```bash
kubectl patch svc monitoring-grafana \
-n monitoring \
-p '{"spec":{"type":"NodePort"}}'
```

Verify:

```bash
kubectl get svc monitoring-grafana -n monitoring
```

Example output:

```text
monitoring-grafana   NodePort   100.x.x.x   80:31605/TCP
```

Access Grafana:

```text
http://<NODE_PUBLIC_IP>:<NODEPORT>
```

Example:

```text
http://54.x.x.x:31605
```

---

# Get Grafana Credentials

Get username:

```bash
kubectl get secret monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-user}" | base64 -d
```

Get password:

```bash
kubectl get secret monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-password}" | base64 -d
```

Default username:

```text
admin
```

---

# Verify Prometheus Targets

Open Grafana.

Navigate to:

```text
Explore
→ Prometheus
```

Run:

```promql
up
```

Expected result:

```text
Multiple targets with value 1
```

This confirms Prometheus is successfully scraping monitoring targets.

---

# Verify kube-state-metrics

Total Pods:

```promql
count(kube_pod_info)
```

Pods in polling namespace:

```promql
count(kube_pod_info{namespace="polling"})
```

Total Nodes:

```promql
count(kube_node_info)
```

Deployment Replicas:

```promql
kube_deployment_status_replicas
```

StatefulSet Replicas:

```promql
kube_statefulset_status_replicas
```

---

# Verify Node Exporter

Available Memory:

```promql
node_memory_MemAvailable_bytes
```

Total Memory:

```promql
node_memory_MemTotal_bytes
```

CPU Usage:

```promql
100 - (
avg by(instance)(
rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
)
```

Disk Space:

```promql
node_filesystem_avail_bytes
```

---

# Dashboard Validation

The following metrics were verified through Grafana dashboards:

## Kubernetes Metrics

- Total Nodes
- Total Pods
- Polling Namespace Pods
- Deployment Replicas
- StatefulSet Replicas

Source:

```text
kube-state-metrics
```

## Node Health Metrics

- CPU Usage
- Memory Usage
- Disk Usage

Source:

```text
Node Exporter
```

---

# Monitoring Architecture

```text
Node Exporter --------\
                        \
kube-state-metrics -----> Prometheus -----> Grafana
                        /
Kubernetes Cluster ----/
```

---

# Troubleshooting Notes

## Grafana Not Accessible

Check service:

```bash
kubectl get svc monitoring-grafana -n monitoring
```

Check endpoints:

```bash
kubectl get endpoints monitoring-grafana -n monitoring
```

Verify NodePort:

```bash
curl http://<NODE_PRIVATE_IP>:<NODEPORT>
```

---

## No Endpoints Found

```bash
kubectl get endpoints -n monitoring
```

Verify:

- Service selectors
- Pod labels

---

## Verify Prometheus Targets

Run:

```promql
up
```

Targets should return:

```text
1
```

indicating healthy targets.

