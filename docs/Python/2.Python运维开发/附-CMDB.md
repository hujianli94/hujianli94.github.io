# 附-CMDB

## 1.功能

CMDB 需要的主要功能有：

- 用户管理：记录测试、开发、运维的用户表
- 事件管理：事故管理负责记录、归类和安排专家处理事故并监督整个处理过程直至事故得到解决和终止。
- 业务线管理：记录业务的详情
- 项目管理：记录项目详情以及属于哪个业务线
- 应用管理：指定此应用的开发人员，属于哪个项目，和代码地址，部署目录，部署集群，依赖的应用，软件等信息
- 主机管理：包括云主机，物理机，主机属于哪个集群，运行着哪些软件，主机管理员，连接哪些网络设备，云主机的资源池，存储等相关信息
- 主机变更管理：主机的一些信息变更，例如管理员，所属集群等信息更改，连接的网络变更等
- 网络设备管理：主要记录网络设备的详细信息，及网络设备连接的上级设备
- IP 管理：IP 属于哪个主机，哪个网段，是否被占用等

## 2.采集方式

CMDB 最主要的一环节就是采集资源，有了资源后续的所有功能实现起来就方便很多，目前资源采集的方式主要有 4 种，它们分别为：

1. agent 方式
2. ssh 类方式
3. slat-stack 方式
4. puppet 方式

### 2.1 agent 方式

其整体思路如下：

1. 在每台待采集的服务器上装上一个 agent
2. 该 agent 定时向 api 发送数据
3. api 接收到数据对数据进行清洗、存档
4. 对数据进行展示、处理等

架构如下：

![1698306580302](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1698306580302.78cb9lk16ls0.webp){: .zoom}

伪代码如下：

```python
# 执行linux命令，得到结果
import subprocess
res = subprocess.getoutput("hostname")

# 将结果返回给api
import request
import json
request.post("http://127.0.0.1:8000/api/",data=json.dumps(res))
```

优缺点：

- 优点为采集速度快，适合服务器较多的情况
- 缺点为需要在每个待采集的服务器上部署一个 agent

#### python 实现

Linux 远程主机及进程状态监测系统 - 客户端

- https://github.com/Watch-Dogs-HIT/Watch_Dogs-Client.git

CMDB 客户端组件，采集服务器信息

- https://github.com/hanqianops/agentd.git

cmdb 客户端部分待更新

- https://github.com/shaoxiaUdropUUNshort/cmdb_clinent.git

agent520

- https://gitee.com/k8s-devops/agent520

参考开源项目：

- https://github.com/plesk/agent360
- https://github.com/NIXStats/nixstatsagent

#### golang 实现

cmdb 客户端 Agent 采集信息 agent

- https://github.com/kevin19890/cmdb_agent.git

主机信息监控客户端，用来向服务端推送当前主机信息

- https://github.com/Hopetree/GoMonitor.git

### 2.2 ssh 类方式

其核心思路通过一台中控机登录到待采集的服务端去执行采集命令，得到结果。

其思路如下：

1. 部署一台中控机，可以是通过 paramiko 自实现的，也可以使用 ansible 工具
2. 通过维护的主机列表，依次登录主机去执行命令采集
3. 中控机收到采集结果后发送给 api
4. api 接收到数据对数据进行清洗、存档
5. 对数据进行展示、处理等

架构如下：

![1698306776599](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1698306776599.5nj47suqkj00.webp){: .zoom}

伪代码如下：

```python
import paramiko
import requests

# 创建SSH对象
ssh = paramiko.SSHClient()

# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# 连接服务器
ssh.connect(hostname='192.168.11.xx', port=8888, username='root', password='密码')

# 执行命令
stdin, stdout, stderr = ssh.exec_command('ls')
# 获取命令输出结果
result = stdout.read()

# 关闭连接
ssh.close()

print(result.decode())  # 把字节数据转换

# 发送给API
url = 'http://127.0.0.1:8000/asset.html'
response = requests.post(url, data={'k1': result})  # 使用request模块进行post进行访问
print(response.text)
```

优缺点：

- 优点为不需要单独在每个待采集的服务器上装 agent
- 缺点为采集速度慢，特别是在服务器较多的情况下

### 2.3 salt-stack 方式

该方式和 ssh 类方式类似，不过这里是使用了 salt-stack 工具，该工具主要有两个组件：salt-master,salt-minion。

架构如下：

![1698306978748](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1698306978748.534rt9u987c0.webp){: .zoom}

**salt-stack 安装如下**

master 端：

```sh
# 1.安装salt-master
yum install salt-master

# 2.修改配置文件：/etc/salt/master
interface:0.0.0.0#表示Master的IP

# 3.启动
service salt-master start
```

slave 端：

```sh
# 1.安装salt-minion
yum install salt-minion

# 2.修改配置文件/etc/salt/minion
master:10.211.55.4 #master的地址

# 或
master:
  -10.211.55.4
  -10.211.55.5
random master:True
id:c2.salt.com   #客户端在salt-master中显示的唯一ID


# 3.启动
service salt-minion start
```

授权

```sh
salt-key -L                       # 查看己授权和未授权的slave
salt-key -a salve_id              # 接受指定id的salve
salt-key -r salve_id              # 拒绝指定id的salve
salt-key -d salve_id              # 删除指定id的salve
salt-key -A                       # 授权所有
```

命令执行

```sh
salt c2.salt.com' cmd.run 'ifconfig'
```

在 python3 中，我们还是使用 subprocess 来执行命令。

也可以使用 Python 中的 salt-api 模块。下面是一个使用 salt-api 模块调用 SaltStack API 的示例代码：

```python
import salt.config
import salt.client.api

# 配置文件路径
config_path = '/etc/salt/master'

# 加载配置文件
config = salt.config.client_config(config_path)

# 创建SaltStack API客户端
api = salt.client.api.APIClient(config=config)

# 要执行的命令
cmd = 'df -h'

# 目标主机，可以是单个主机或多个主机
tgt = '*'

# 执行Salt命令
result = api.cmd(tgt, 'cmd.run', [cmd])

# 输出结果
for host, output in result.items():
    print('Host: %s' % host)
    print('Output: \n%s\n' % output)
```

### 2.4 puppet 方式（ruby 语言开发）

基于 Puppet 的 factor 和 report 功能实现

```sh
puppet中默认自带了5个report，放置在【/usr/lib/ruby/site_ruby/1.8/puppet/reports/】路径下。如果需要执行某个report，那么就在puppet的master的配置文件中做如下配置：

######################## on master ###################
/etc/puppet/puppet.conf
[main]
reports = store #默认
#report = true #默认
#pluginsync ＝ true #默认


####################### on client #####################

/etc/puppet/puppet.conf
[main]
#report = true #默认

[agent]
runinterval = 10
server = master.puppet.com
certname = c1.puppet.com

如上述设置之后，每次执行client和master同步，就会在master服务器的 【/var/lib/puppet/reports】路径下创建一个文件，主动执行：puppet agent  --test
```

1、自定义 factor 示例

```sh
在 /etc/puppet/modules 目录下创建如下文件结构：

modules
└── cmdb
    ├── lib
    │   └── puppet
    │       └── reports
    │           └── cmdb.rb
    └── manifests
        └── init.pp

################ cmdb.rb ################
# cmdb.rb
require 'puppet'
require 'fileutils'
require 'puppet/util'

SEPARATOR = [Regexp.escape(File::SEPARATOR.to_s), Regexp.escape(File::ALT_SEPARATOR.to_s)].join

Puppet::Reports.register_report(:cmdb) do
  desc "Store server info
    These files collect quickly -- one every half hour -- so it is a good idea
    to perform some maintenance on them if you use this report (it's the only
    default report)."

  def process
    certname = self.name
    now = Time.now.gmtime
    File.open("/tmp/cmdb.json",'a') do |f|
      f.write(certname)
      f.write(' | ')
      f.write(now)
      f.write("\r\n")
    end

  end
end


################ 配置 ################
/etc/puppet/puppet.conf
[main]
reports = cmdb
#report = true #默认
#pluginsync ＝ true #默认
```

该方式目前很少使用，主要是使用 puppet 的企业不多。

使用 facter 收集服务器系统信息。

每隔 30 分钟，通过 RPC 消息队列将执行的结果返回给用户

不常用，不做解释

前三种是用 Python 开发的，目标是兼容三种采集方式的软件

### 2.5 开发 cmdb 程序

开发程序设计为可插拔机制。（好处：扩展性强）

开发一套程序时，要使其有充分的扩展性。接下来可以写一些伪代码...

1、假设项目名为 AutoClient, 目录结构如下：

```sh
AutoClient/
|-- bin/
|   |-- auto_client.py
|-- config/
|   |-- settings.py
|-- lib/
|   |--
|-- log/
|   |-- error.log
|   |-- run.log
|-- src/
|   |-- plugins/
|       |-- __init__.py
|       |-- base.py
|       |-- cpu.py
|       |-- ...
|   |-- scripts.py
|-- README
```

例如，采集资产信息有三种形式，而将要做的一件事就是要让程序兼容这三种形式

实现方式如下示例：

https://www.cnblogs.com/lzc69/p/12142254.html

参考文献

[CMDB 那些事儿](https://www.cnblogs.com/dion-90/articles/8525403.html)

https://www.cnblogs.com/nulige/p/6703160.html

https://www.cnblogs.com/adamans/articles/7800412.html

https://www.cnblogs.com/liuqingzheng/p/14527292.html

## 3.小结

- 采集资产信息有四种不同的形式（但 puppet 是基于 ruby 开发的）
- API 提供相关处理的接口
- 管理平台为用户提供可视化操作

## 4. CMDB 系统

### Python 语言实现

#### 1 后端基础

1. [DRF 前奏](https://blog.51cto.com/devwanghui/5956688)
2. [DRF 入门](https://blog.51cto.com/devwanghui/5968540)
3. [DRF 进阶之 DRF 视图和常用功能](https://blog.51cto.com/devwanghui/6007984)

#### 2 前端基础

1. [Vue 前端开发-上](https://blog.51cto.com/devwanghui/6163644)
2. [Vue 前端开发-下](https://blog.51cto.com/devwanghui/6179278)
3. [Element Plus 前端组件库](https://blog.51cto.com/devwanghui/6193473)

#### 3 CMDB 后端开发

1. [CMDB 后端开发（上）](https://blog.51cto.com/devwanghui/6239143)
2. [CMDB 后端开发（下）](https://blog.51cto.com/devwanghui/6241341)

#### 4 CMDB 前端开发

1. [CMDB 前端开发(上)](https://blog.51cto.com/devwanghui/6244560)
2. [CMDB 前端开发-IDC 管理](https://blog.51cto.com/devwanghui/6317673)

### CMDB 运维平台参考

open-cmdb

- 项目地址: https://github.com/myide/open-cmdb


- 相关文献：[一款开源好用的 cmdb 资产管理平台](https://mp.weixin.qq.com/s/hKxMwEfeJS69FGwNZa5Ieg)


维易CMDB

- 项目地址：https://github.com/veops/cmdb




[PgoOps 运维平台](https://github.com/yanshicheng/pgoops)

PgoOps 运维平台部署文档: https://www.cnblogs.com/yanshicheng/p/16214938.html

以 `Python` 语言，采用 django-rest-framework 框架实现后端 API 开发

[lightning-ops](https://github.com/zhengyansheng/lightning-ops)

CMDB 配置管理系统 资产管理系统

- https://github.com/open-cmdb/cmdb.git



OPMS_v3：项目地址:

- https://github.com/goer3/OPMS_v3/tree/dev3.1




以 `Python` 语言，采用 django-rest-framework 框架实现后端 API 开发。其他代码仓库

- https://gitee.com/scajy/cmdb

- https://gitee.com/attacker/cmdb

- https://github.com/open-cmdb/cmdb-web.git

- https://github.com/hequan2017/autoops

- https://github.com/zhengyansheng/lightning-ops

- https://github.com/yanshicheng/super_ops.git

- https://gitee.com/huge-dream/django-vue3-admin

- https://gitee.com/huge-dream

- https://gitee.com/attacker/spug




## 5.工单系统

### 5.1 work_order_system

Django + Vue 开发工单系统

- https://gitee.com/scajy/work_order_system

- https://github.com/itimor/one-workflow

### 5.2 ferry

Gin + Vue + Element UI 前后端分离的工单系统

- https://github.com/lanyulei/ferry

- https://github.com/Mr-QinJiaSheng/ferry-master

## 6.next-terminal

一个简单好用安全的开源交互审计系统

- https://github.com/dushixiang/next-terminal

## 7.Cetus-GUI

基于 web 端的 Cetus 集群可视化管理系统，能有效的提升部署与管理 Cetus 集群的效率。

https://github.com/Lede-Inc/Cetus-GUI

## 8.TenSunS(原 ConsulManager)

基于 Consul 的运维平台：更优雅的 Consul 管理 UI&多云与自建 ECS/MySQL/Redis 同步

https://github.com/starsliao/TenSunS/tree/main
