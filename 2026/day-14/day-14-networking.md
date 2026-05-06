# 📘 Day 14 – Networking Fundamentals & Hands-on Checks

## 🎯 Objective
Understand core networking concepts and practice real-world troubleshooting commands to analyze connectivity, routing, ports, and services.

---

## 🧠 Concepts Overview

### 🔹 OSI vs TCP/IP Models

| OSI Model (7 Layers) | TCP/IP Model (4 Layers) |
|---------------------|------------------------|
| Application         | Application            |
| Presentation        | Application            |
| Session             | Application            |
| Transport           | Transport              |
| Network             | Internet               |
| Data Link           | Link                   |
| Physical            | Link                   |

- **OSI Model:** Conceptual framework for understanding networking  
- **TCP/IP Model:** Practical implementation used in real systems  

---

### 🔹 Protocol Placement

| Protocol | Layer (TCP/IP) | Purpose |
|----------|---------------|---------|
| IP       | Internet      | Addressing & routing |
| TCP/UDP  | Transport     | Data transmission |
| HTTP/HTTPS | Application | Web communication |
| DNS      | Application   | Domain resolution |

---

### 🔹 Example Flow

```bash
curl https://example.com
Application → HTTP
Transport → TCP
Internet → IP


🧰 Commands Used
Command	Purpose
hostname -I	Get system IP address
ip addr show	Detailed network interfaces info
ping <host>	Check connectivity & latency
traceroute <host> / tracepath <host>	Show network path
ss -tulpn	List listening ports & services
netstat -tulpn	Alternative to ss
dig <domain>	DNS lookup
nslookup <domain>	Alternative DNS lookup
curl -I <url>	Check HTTP response headers
netstat -an	View active connections
nc -zv <host> <port>	Test port connectivity