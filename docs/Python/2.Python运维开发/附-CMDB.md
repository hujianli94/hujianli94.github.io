# 附-CMDB

## 1.功能

CMDB需要的主要功能有：

- 用户管理：记录测试、开发、运维的用户表
- 业务线管理：记录业务的详情
- 项目管理：记录项目详情以及属于哪个业务线
- 应用管理：指定此应用的开发人员，属于哪个项目，和代码地址，部署目录，部署集群，依赖的应用，软件等信息
- 主机管理：包括云主机，物理机，主机属于哪个集群，运行着哪些软件，主机管理员，连接哪些网络设备，云主机的资源池，存储等相关信息
- 主机变更管理：主机的一些信息变更，例如管理员，所属集群等信息更改，连接的网络变更等
- 网络设备管理：主要记录网络设备的详细信息，及网络设备连接的上级设备
- IP管理：IP属于哪个主机，哪个网段，是否被占用等




## 2.采集方式

CMDB最主要的一环节就是采集资源，有了资源后续的所有功能实现起来就方便很多，目前资源采集的方式主要有4种，它们分别为：
1. agent方式
2. ssh类方式
3. slat-stack方式
4. puppet方式



### 2.1 agent方式

其整体思路如下：

1. 在每台待采集的服务器上装上一个agent
2. 该agent定时向api发送数据
3. api接收到数据对数据进行清洗、存档
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
- 缺点为需要在每个待采集的服务器上部署一个agent


### 2.2 ssh类方式

其核心思路通过一台中控机登录到待采集的服务端去执行采集命令，得到结果。

其思路如下：

1. 部署一台中控机，可以是通过paramiko自实现的，也可以使用ansible工具
2. 通过维护的主机列表，依次登录主机去执行命令采集
3. 中控机收到采集结果后发送给api
4. api接收到数据对数据进行清洗、存档
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
ssh.connect(hostname='192.168.11.126', port=8888, username='root', password='密码')
 
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

- 优点为不需要单独在每个待采集的服务器上装agent
- 缺点为采集速度慢，特别是在服务器较多的情况下




### 2.3 salt-stack方式


该方式和ssh类方式类似，不过这里是使用了salt-stack工具，该工具主要有两个组件：salt-master,salt-minion。


架构如下：

![1698306978748](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1698306978748.534rt9u987c0.webp){: .zoom}


**salt-stack安装如下**

master端：

```sh
# 1.安装salt-master
yum install salt-master

# 2.修改配置文件：/etc/salt/master
interface:0.0.0.0#表示Master的IP

# 3.启动
service salt-master start
```

slave端：
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

在python3中，我们还是使用subprocess来执行命令。


也可以使用Python中的salt-api模块。下面是一个使用salt-api模块调用SaltStack API的示例代码：

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


### 2.4 puppet方式

该方式目前很少使用，主要是使用puppet的企业不多。

使用facter收集服务器系统信息。

每隔30分钟，通过RPC消息队列将执行的结果返回给用户

不常用，不做解释



## 3.小结

- 采集资产信息有四种不同的形式（但puppet是基于ruby开发的）
- API提供相关处理的接口
- 管理平台为用户提供可视化操作
 

前三种是用Python开发的，目标是兼容三种采集方式的软件