# 附录 1-Ansible 核心源码剖析-1

由于 Ansible 1.1 形成于 2013 年年中，只支持 Python 2，为了后续能更好地学习其他版本的 Ansible，

我们使用虚拟环境来安装 Ansible 的各个版本。

额外环境

- 一台安装 CentOS 7 桌面版的虚拟主机，

- VSCode

> ansible 所有版本均已开源，下载地址： https://releases.ansible.com/ansible

> python 版本下载地址：https://mirrors.huaweicloud.com/python

## 1.1.1 Ansible 1.1 测试环境搭建

VMware 软件创建了 4 台装有 CentOS 7 系统的虚拟主机，并配置好了相应的静态 IP 以及网络，确保能正常连通外网。4 台主机的 IP 及其设定的主机名如下：

```shell

[root@master ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6


192.168.0.108 master
192.168.0.109 ceph-1
192.168.0.110 ceph-2
192.168.0.112 ceph-3
```

基础环境配置

```sh
# 由于官网的yum源太慢，下面使用阿里云的Yum源进行安装
mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/CentOS-* /etc/yum.repos.d/bak
#CentOS 7 安装yum源:Base,Extras
curl http://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
curl http://mirrors.aliyun.com/repo/epel-7.repo -o /etc/yum.repos.d/epel.repo
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache fast

yum -y install vim wget net-tools


# 配置ip地址
cat >/etc/sysconfig/network-scripts/ifcfg-enp0s3<<-EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO=static
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="enp0s3"
#UUID="f6b1ad63-f5cf-4d81-ac97-91faf1da94fa"
IPADDR=192.168.0.110
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=114.114.114.114
DEVICE="enp0s3"
ONBOOT="yes"
EOF

systemctl restart network


# 设置主机名，在各自服务器上执行
hostnamectl set-hostname master && exec $BASH
hostnamectl set-hostname ceph-1 && exec $BASH
hostnamectl set-hostname ceph-2 && exec $BASH
hostnamectl set-hostname ceph-3 && exec $BASH


# 配置hosts,在各自服务器上执行
cat >/etc/hosts<<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6


192.168.0.108 master
192.168.0.113 ceph-1
192.168.0.110 ceph-2
192.168.0.112 ceph-3
EOF
```

然后安装一个好用的虚拟环境管理工具——pyenv。其手工安装过程非常简单，保证网络畅通即可，具体操作命令如下：

```sh
[root@master ~]# yum install git -y
[root@master ~]# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
[root@master ~]# git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
```

直接从 GitHub 上下载 pyenv 项目源码及创建虚拟环境的插件（pyenv-virtualenv）并将其放到对应的目录下，接着在~/.bashrc 文件中配置 pyenv 的命令路径即可使用 pyenv 工具。具体配置命令如下：

```sh
[root@master ~]# cat ~/.bashrc
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
. /etc/bashrc
fi

# 添加pyenv命令路径
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[root@master ~]# source ~/.bashrc
[root@master ~]# pyenv --version
pyenv 2.4.11
```

此时便可以使用 pyenv 来创建相应的虚拟环境。在使用 pyenv install 命令安装 Python 版本时，默认从 python.org 网站上下载指定的版本，国内用户访问速度通常非常慢。

此时可以先从国内的 Python 镜像源中下载指定的 Python 版本到 pyenv 的插件缓存目录中，然后再执行安装命令。具体操作如下：

```sh
[root@master ~]# yum install gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

[root@master ~]#v=2.7.18;wget https://mirrors.huaweicloud.com/python/$v/Python-$v.tar.xz -P ~/.pyenv/cache/;pyenv install $v
```

以上安装的是 Python 2 的最新版本，在此之前需要安装一些依赖库。由于 Python 2 在 2020 年之后不再进行维护，许多大型 Python 项目也不再支持 Python 2，例如 Django 项目从 Django 2 开始就不再支持 Python 2，因此对于刚开始接触 Python 语言的读者，建议直接使用 Python 3 进行学习。

Ansible 在兼容性方面很不错，即使到了如今的 Ansible 2.9，也依然支持 Python 2。

目前 CentOS 的 Minimal 版本中只有 Python 2，Python 3 通常需要额外安装。

许多旧的生产系统上依旧运行着各种 Python 2 脚本，多种自动化工具依旧是基于 Python 2 开发的，预计这一现象会在 3 ～ 5 年后有所改变。

完成 Python 2.7 的安装后，就可以使用 pyenv virtualenv 命令创建对应 Python 版本的虚拟环境了。具体操作如下：

```sh
[root@master ~]# pyenv versions
* system (set by /root/.pyenv/version)
  2.7.18

[root@master ~]# pyenv virtualenv 2.7.18 ansible1.1

[root@master ~]# pyenv versions
* system (set by /root/.pyenv/version)
  2.7.18
  2.7.18/envs/ansible1.1
  ansible1.1
```

以上操作创建了一个名为 ansible1.1 的虚拟环境，使用 pyenv activate ansible1.1 命令就可以激活该虚拟环境：

```sh
[root@master ~]# pyenv activate ansible1.1
(ansible1.1) [root@master ~]#
```

接下来在虚拟环境中安装 Ansible 1.1 工具，直接使用 pip 命令安装 Ansible 并指定 1.1 的版本即可。如果下载速度过慢，可以指定使用清华源或者阿里源。

```sh

(ansible1.1) [root@master ~]# pip list
Package    Version
---------- -------
pip        20.2.3
setuptools 44.1.1
wheel      0.35.1

(ansible1.1) [root@master ~]# pip install ansible==1.1 -i https://pypi.tuna.tsinghua.edu.cn/simple
(ansible1.1) [root@master ~]# ansible --version
ansible 1.1

(ansible1.1) [root@master ~]# pip list
Package      Version
------------ -------
ansible      1.1
bcrypt       3.1.7
cffi         1.15.1
cryptography 3.3.2
enum34       1.1.10
ipaddress    1.0.23
Jinja2       2.11.3
MarkupSafe   1.1.1
paramiko     2.12.0
pip          20.3.4
pycparser    2.21
PyNaCl       1.4.0
PyYAML       5.4.1
setuptools   44.1.1
six          1.16.0
wheel        0.37.1
```

这样就在虚拟环境 ansible1.1 中成功安装了 Ansible 1.1 工具。对比安装前后的 pip list 命令结果可知，Ansible 依赖众多的 Python 第三方模块。如 paramiko 模块用于远程 SSH 通信（通信方式可选）、PyYAML 模块用于解析 YAML 文件、Jinja2 模块用于实现 Ansible 中模板文件或者模板变量的渲染工作等。

此外，还需要对刚刚安装好的 Ansible 工具进行测试，确保能正常使用。

所有服务器开启 root 访问和设置 root 密码,这里以 msater 为例，其他节点也一样

```sh
[root@master ~]# sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
[root@master ~]# sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
[root@master ~]# sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
[root@master ~]# sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
[root@master ~]# systemctl restart sshd.service
[root@master ~]# echo "@hjl19940722"|passwd root --stdin
```

首先准备一个 hosts 文件并按照组归类 Ansible 目标主机，同时给组变量添加主机的 SSH 登录账号、密码及端口（用户和端口均有默认值，可以忽略），具体操作命令如下：

```sh
(ansible1.1) [root@master ~]# cat hosts
[nodes]
ceph-[1:3]

[nodes:vars]
ansible_ssh_user=root
ansible_ssh_pass=@hjl19940722
ansible_ssh_port=22

(ansible1.1) [root@master ~]# ansible all -i hosts -m ping
ceph-1 | FAILED => module ping not found in /root/library:/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/
ceph-2 | FAILED => module ping not found in /root/library:/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/
ceph-3 | FAILED => module ping not found in /root/library:/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/

```

上面的结果显示，当前环境中没有找到 Ansible 的 ping 模块，查找的路径有两个：

- /root/library

- /root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/

这个问题也容易解决，只需要把 Ansible 1.1 内置的模块代码放到提示的任意一个目录下即可，这些模块文件在 Ansible 的源码中可以找到。

首先从官方的 Ansible 代码库中下载 Ansible 1.1 源码包，然后复制源码包下的模块并存放到指定位置即可。具体操作命令如下：

```sh
(ansible1.1) [root@master opt]# cd /opt/
(ansible1.1) [root@master opt]# wget https://releases.ansible.com/ansible/ansible-1.1.tar.gz
(ansible1.1) [root@master opt]# tar -xf ansible-1.1.tar.gz
(ansible1.1) [root@master opt]# mkdir -p /root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/
(ansible1.1) [root@master opt]# cp -rf ansible-1.1/library/* /root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/

# 最后，再次运行前面的测试命令，运行结果如下：
(ansible1.1) [root@master ~]# ansible all -i hosts -m ping
ceph-2 | success >> {
    "changed": false,
    "ping": "pong"
}

ceph-1 | success >> {
    "changed": false,
    "ping": "pong"
}

ceph-3 | success >> {
    "changed": false,
    "ping": "pong"
}
```

至此，Ansible 工具已经在虚拟机上安装完毕并且能正常使用了。
在后面的章节中会简单使用 Ansible 1.1 的其他模块并编写 Playbook 进行测试。

Ansible 1.1 源码全部位于 `~/.pyenv/versions/ansible1.1/lib/python2.7/site-packages/ansible` 目录下

## 1.1.2 Ansible 1.1 调试环境搭建

这里不再使用虚拟环境，而是直接使用 CentOS 7 自带的 Python 2.7。

为了能运行和调试 Ansible 1.1 源码，需要先安装 Ansible 1.1 依赖包。
在虚拟环境中安装 Ansible 1.1 时可以看到 Ansible 所依赖的第三方模块，首先将其全部模块导出得到 requirements.txt 文件如下：

```sh
(ansible1.1) [root@master ~]# pip freeze > requirements.txt
(ansible1.1) [root@master ~]# cat requirements.txt
ansible==1.1
bcrypt==3.1.7
cffi==1.15.1
cryptography==3.3.2
enum34==1.1.10
ipaddress==1.0.23
Jinja2==2.11.3
MarkupSafe==1.1.1
paramiko==2.12.0
pycparser==2.21
PyNaCl==1.4.0
PyYAML==5.4.1
six==1.16.0
```

上面的 ansible==1.1 需要去掉，在调试环境下不要通过 pip 安装 Ansible，而是通过源码方式来安装。

将依赖包内容（删除了第一行）复制到 CentOS 桌面版的虚拟机中，然后执行如下命令：

```sh
[root@master ~]# cat requirements.txt
bcrypt==3.1.7
cffi==1.14.3
cryptography==3.1.1
enum34==1.1.10
ipaddress==1.0.23
Jinja2==2.11.2
MarkupSafe==1.1.1
paramiko==2.7.2
pycparser==2.20
PyNaCl==1.4.0
PyYAML==5.3.1
six==1.15.0

[root@master ~]# yum -y install python-pip
[root@master ~]# sudo yum install python-devel.x86_64
[root@master ~]# pip install --ignore-installed -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

安装好上述依赖的第三方模块后，就可以下载 Ansible 1.1 源码并用 Pychram 远程的方式 打开，命令如下：

```sh
[root@master centos]# mkdir /home/centos/hujianli/code/python -p
[shen@localhost python]$ pwd
/home/centos/hujianli/code/python
[shen@localhost python]$ wget https://releases.ansible.com/ansible/ansible-1.1.tar.gz
[shen@localhost python]$ tar -xzf ansible-1.1.tar.gz
```

在 Pychram 远程的方式 中导入 Ansible 1.1 源码。

详细步骤参考

- https://ansible.leops.cn/dev/pycharm-remote-development/

- https://ansible.leops.cn/dev/debug/pycharm/

虚拟机保存快照
