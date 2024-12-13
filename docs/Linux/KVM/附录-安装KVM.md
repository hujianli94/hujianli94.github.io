# 附录-安装 KVM

## Centos 安装 KVM

- https://www.cnblogs.com/kevingrace/p/8377645.html

- https://www.cnblogs.com/cnsre/p/15513537.html#安装前准备

- https://www.cnblogs.com/milton/p/14519787.html

## Linux 安装 QEMU-KVM

- https://notfound.cn/posts/qemu-install/

## Ubuntu 安装 KVM Cloud

KVM Cloud 是一款基于 Java 实现的轻量级私有云平台，旨在帮助中小企业快速实现计算、存储、网络等资源的管理，让企业拥有自己的云平台。

### 适用版本

Ubuntu 22.04.3 LTS,其他 Ubuntu 版本请自行查阅相关配置

### 检查 KVM 支持

```shell
egrep -c '(vmx|svm)' /proc/cpuinfo

#如果你得到的输出大于0，那么意味着KVM与系统兼容，可以安装
```

### 防火墙配置

```shell
# 放行agent端口
sudo ufw allow 8081/tcp
```

### 系统升级

```shell
sudo apt update
sudo apt upgrade
```

### 启用 IP 转发

```shell
vim /etc/sysctl.conf
net.ipv4.ip_forward=1
#保存后执行刷新
sysctl -p
```

### 编辑网桥文件

```shell
chmod 600 /etc/netplan/00-installer-config.yaml

vim /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    ens10:
      dhcp4: false
  bridges:
    br0:
      interfaces: [ ens10 ] #ens10 为实际网卡名称，根据实际情况填写
      addresses: [192.168.1.54/24]  #真实IP，根据实际情况填写
      routes:
        - to: default
          via: 192.168.1.1 #真实网关，根据实际情况填写
      openvswitch: {}
      nameservers:
        addresses: [8.8.8.8]  #dns，根据实际情况填写
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: no
```

### 安装网络组件

```shell
sudo apt install openvswitch-switch -y
sudo systemctl start ovsdb-server
sudo systemctl enable ovsdb-server
```

### 重启网络

```shell
sudo netplan apply
```

### 安装 kvm 相关组件

```shell
sudo apt install qemu-kvm libvirt-daemon-system
```

### Libvirtd 配置

```shell
#编辑/etc/libvirt/qemu.conf文件,调整如下配置:
vnc_listen = "0.0.0.0"
user = "root"
group = "root"
```

### Libvirtd 重启

```shell
sudo systemctl enable libvirtd
sudo systemctl enable start
```

### JDK 安装

```shell
sudo apt install openjdk-8-jdk -y
```

### 安装 supervisor 管理

```shell
sudo apt install supervisor
sudo systemctl start supervisor
sudo systemctl enable supervisor
```

### 安装 agent

```shell
sudo mkdir -p /usr/local/cloud
#上传 cloud-agent-1.0-SNAPSHOT.jar到/usr/local/cloud
```

### 创建 agent 配置文件

```shell
cat <<EOF >> /usr/local/cloud/client.properties
server.port=8081
app.task-thread-size=8
EOF
```

### 创建 supervisor 管理文件

```shell
cat <<EOF >> /etc/supervisor/conf.d/cloud-agent.conf
[program:Cloud-Agent]
command = java -jar cloud-agent-1.0-SNAPSHOT.jar --spring.config.location=client.properties
directory = /usr/local/cloud
autostart = true
startsecs = 5
autorestart = true
startretries = 3
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdout_logfile_backups = 10
stdout_logfile = /var/log/cloud-agent.log
EOF
```

### supervisor 加载服务

```shell
sudo supervisorctl update
```

### 查看运行日志

```shell
sudo supervisorctl
tail -f Cloud-Agent
```
