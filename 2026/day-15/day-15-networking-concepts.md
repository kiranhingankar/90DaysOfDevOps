# Day 15 – Networking Concepts: DNS, IP, Subnets & Ports

---

## 🔹 Task 1: DNS – How Names Become IPs

### 1. What happens when you type `google.com`?
When we enter a domain in the browser, a DNS query is sent to resolve the domain name into an IP address. The request goes through DNS resolvers, root servers, TLD servers, and authoritative servers. Finally, the IP is returned, and the browser connects to that server.

### 2. DNS Record Types
- A → Maps domain to IPv4 address  
- AAAA → Maps domain to IPv6 address  
- CNAME → Alias of another domain  
- MX → Mail server record  
- NS → Name server for the domain  

---

## 🔹 Task 2: IP Addressing

### 1. What is IPv4?
IPv4 is a 32-bit address written in four octets (e.g., 192.168.1.10), used to identify devices on a network.

### 2. Public vs Private IP
- Public IP → Accessible over the internet (e.g., 8.8.8.8)  
- Private IP → Used inside local networks (e.g., 192.168.1.10)  

### 3. Private IP Ranges
- 10.0.0.0 – 10.255.255.255  
- 172.16.0.0 – 172.31.255.255  
- 192.168.0.0 – 192.168.255.255  

---

## 🔹 Task 3: CIDR & Subnetting

### 1. What does `/24` mean?
It means first 24 bits are network bits, leaving 8 bits for hosts.

### 2. Number of Hosts
- /24 → 256 total, 254 usable  
- /16 → 65,536 total, 65,534 usable  
- /28 → 16 total, 14 usable  

### 3. Why do we subnet?
Subnetting helps divide a network into smaller parts for better management, security, and efficient IP usage.

### 4. CIDR Table

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
|------|----------------|----------|--------------|
| /24  | 255.255.255.0  | 256      | 254          |
| /16  | 255.255.0.0    | 65536    | 65534        |
| /28  | 255.255.255.240| 16       | 14           |

---

## 🔹 Task 4: Ports – The Doors to Services

### 1. What is a port?
A port is a communication endpoint that allows multiple services to run on a single IP.

### 2. Common Ports

| Port | Service        |
|------|---------------|
| 22   | SSH           |
| 80   | HTTP          |
| 443  | HTTPS         |
| 53   | DNS           |
| 3306 | MySQL         |
| 6379 | Redis         |
| 27017| MongoDB       |


---

## 🔹 Task 5: Putting It Together

### 1. `curl http://54.196.155.41:80`
DNS resolves the domain to an IP, then the request is sent to port 8080 using HTTP protocol to access the service.

### 2. Cannot reach database `10.0.1.50:3306`
Check:
- Network connectivity (ping)
- Port accessibility (telnet/nc)
- Firewall rules
- DB service running

---

## 📚 What I Learned

1. DNS translates domain names into IP addresses using multiple servers  
2. CIDR and subnetting help efficiently manage IP ranges  
3. Ports allow multiple services to run on a single machine  

---

# ✅ Commands Used

```bash
dig google.com
ip addr show
ss -tulpn