# ELK Stack on Kubernetes (MicroK8s)

This project sets up the **ELK Stack** (Elasticsearch, Logstash, Kibana) on **MicroK8s** to collect, process, and visualize logs — including Nginx logs — for real-time observability and monitoring.

---

## 📦 Stack Components

| Component     | Role                                      |
|---------------|-------------------------------------------|
| Elasticsearch | Indexes and stores log data               |
| Logstash      | Parses and transforms incoming logs       |
| Kibana        | Provides dashboards and log visualization |
| Filebeat      | (Optional) Lightweight log shipper        |

---

## 🚀 Features

- Deploy ELK stack on local Kubernetes (MicroK8s)
- Centralized log collection from Kubernetes pods
- Nginx access log monitoring
- Kibana dashboards for top URLs, status codes, and client IPs
- Custom Logstash pipeline for parsing logs
- NodePort or port-forward access to Kibana

---

## 🧰 Prerequisites

- MicroK8s installed and running
- Basic knowledge of Kubernetes
- Helm 3 (enabled via MicroK8s: `microk8s enable helm3`)
- At least 4GB of free system memory


---

## 🛠️ Setup Instructions

### 1. Enable MicroK8s Add-ons

```bash
microk8s enable dns storage helm3
```

### 2. Clone the Repository

```bash
git clone https://github.com/your-username/ELK-stack.git
cd ELK-stack
```

### 3. Run the Setup Script

```bash
chmod +x elk.sh
./elk.sh
```

### 4. Access Kibana

```bash
microk8s kubectl get svc -n logging
```

```bash
http://<node-ip>:<nodeport>
```

login:

Username: elastic
Passwork :
```bash
microk8s kubectl get secret elasticsearch-master-credentials -n logging -o jsonpath="{.data.password}" | base64 -d
```

#### @aj1naz

