# 附录 3-Ansible-1.1 源码概览

Ansible 是一个非常典型的开源项目，其项目结构、代码风格及注释的书写等十分规范。

Ansible 的创始人 Michael DeHanan 更是在 IT 圈内家喻户晓，以至于 Ansible 一经发布就能在各国的运维人员之间迅速流行。

本节将介绍 Ansible 1.1 的大部分源码文件，让读者对 Ansible 的源码有一个初步的了解，为后续的源码分析做好准备。

## 源码文件

Ansible 项目的代码均位于 lib/ansible 目录下，下面大致浏览一下 Ansible 1.1 的源码目录结构，

```sh
(ansible1.1) [root@master python]# tree -L 4 ansible-1.1
ansible-1.1
├── bin
│   ├── ansible
│   ├── ansible-doc
│   ├── ansible-playbook
│   └── ansible-pull
├── COPYING
├── docs
# ....
├── examples
# ....
├── lib
│   └── ansible
│       ├── callback_plugins
│       │   ├── __init__.py
│       │   └── noop.py
│       ├── callbacks.py
│       ├── color.py
│       ├── constants.py
│       ├── errors.py
│       ├── __init__.py
│       ├── inventory
│       │   ├── dir.py
│       │   ├── expand_hosts.py
│       │   ├── group.py
│       │   ├── host.py
│       │   ├── ini.py
│       │   ├── __init__.py
│       │   ├── script.py
│       │   └── vars_plugins
│       ├── module_common.py
│       ├── playbook
│       │   ├── __init__.py
│       │   ├── play.py
│       │   └── task.py
│       ├── runner
│       │   ├── action_plugins
│       │   ├── connection_plugins
│       │   ├── connection.py
│       │   ├── filter_plugins
│       │   ├── __init__.py
│       │   ├── lookup_plugins
│       │   ├── poller.py
│       │   └── return_data.py
│       └── utils
│           ├── __init__.py
│           ├── module_docs.py
│           ├── plugins.py
│           └── template.py
├── library
│   ├── add_host
# ....
# ....
├── Makefile
├── packaging
│   └── rpm
│       └── ansible.spec
├── PKG-INFO
├── README.md
└── setup.py
```

下面对一些非常重要的文件或者目录进行说明。

### 1.module_common.py

module_common.py 文件在 1.2.2 节中提到过，其中包含 Ansible 模块的公共代码部分，这些内容会在后续和 Ansible 中的模块代码合并，组成一个完整可运行的 Python 文件，最后被传送到远端主机上执行。

### 2.errors.py

errors.py 文件中定义了 Ansible 的全局异常，这些异常继承自 Exception 类，并没有其他额外操作。

### 3.constants.py

constants.py 文件比较关键，下面会针对该文件的代码内容进行说明。请看如下的代码片段：

```python
# 源码位置：lib/ansible/constants.py

# 忽略一些模块导入
# ...

def get_config(p, section, key, env_var, default):
    if env_var is not None:
        value = os.environ.get(env_var, None) # 获取环境变量
        if value is not None:
            return value
    if p is not None:
        try:
            return p.get(section, key) # 从配置文件中获取section对应的key的值
        except:
            return default
    # 异常或者其他情况返回默认值
return default
```

get_config()方法比较简单，即从配置文件（ansible.cfg）中获取相应 section 中的 key 对应的值。如果环境变量中存在该 key 变量，则优先取环境变量的值；如果环境变量和配置文件中都取不到，则返回默认值（default）。

再来看如下代码片段：

```python
# 源码位置：lib/ansible/constants.py
# ...

def load_config_file():
    # Python 2中的写法，在Python 3中会有所变化
    p = ConfigParser.ConfigParser()
    path1 = os.path.expanduser(os.environ.get('ANSIBLE_CONFIG', "~/.ansible.cfg"))
    path2 = os.getcwd() + "/ansible.cfg"
    path3 = "/etc/ansible/ansible.cfg"

    if os.path.exists(path1):
        p.read(path1)
    elif os.path.exists(path2):
        p.read(path2)
    elif os.path.exists(path3):
        p.read(path3)
    else:
        return None
    return p

def shell_expand_path(path):
# 如果os.path.expanduser()方法无效，则需要使用shell_expand_path()方法
# 如果传入的path为None，则默认为ANSIBLE_PRIVATE_KEY_FILE常量值
    if path:
        path = os.path.expanduser(path)
return path

```

从上面的代码逻辑中可以看到，Ansible 导入配置文件（ansible.cfg）的优先顺序为：

- ~/.ansible.cfg
- 当前命令执行目录下的 ansible.cfg
- /etc/ansible/ansible.cfg。

在这个配置文件中可以定义很多用于控制 Ansible 运行方式的参数，如控制 ansible 命令执行时启动的进程数（forks）、SSH 远程连接的方式（是基于 paramiko 模块、SSH 命令，还是本地操作）等。此外，shell_expand_path()方法的作用只是根据用户展开 path 值。

再来看如下代码片段：

```python

# 源码位置：lib/ansible/constants.py
# ...

# 导入ansible.cfg配置文件
p = load_config_file()

# 获取当前用户
active_user   = pwd.getpwuid(os.geteuid())[0]

# 设置Ansible模块的位置
if getattr(sys, "real_prefix", None):
    DIST_MODULE_PATH = os.path.join(sys.prefix, 'share/ansible/')
else:
    DIST_MODULE_PATH = '/usr/share/ansible/'
```

上述代码主要是导入 ansible.cfg 配置文件并获取当前活跃用户及 Ansible 模块路径。

下面在 Python 交互模式下演示上述代码的执行结果，具体操作如下：

```sh

(ansible1.1) [root@master ~]# python
Python 2.7.18 (default, Oct 13 2020, 23:55:15)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import pwd
>>> import os
>>> pwd.getpwuid(os.geteuid())[0]
'root'
>>> import sys
>>> getattr(sys, "real_prefix", None)
'/root/.pyenv/versions/2.7.18'
>>> os.path.join(sys.prefix, 'share/ansible/')
'/root/.pyenv/versions/ansible1.1/share/ansible/'
```

通过上述操作可以很清楚地看到之前源码中每一步的执行结果。下面继续看 constants.py 中的后续代码：

```python
# 源码位置：lib/ansible/constants.py
# ...

# 配置文件中的默认section
DEFAULTS='defaults'

# 定义的常量值
# configurable things
DEFAULT_HOST_LIST         = shell_expand_path(get_config(p, DEFAULTS, 'hostfile',         'ANSIBLE_HOSTS',            '/etc/ansible/hosts'))
DEFAULT_MODULE_PATH       = shell_expand_path(get_config(p, DEFAULTS, 'library',          'ANSIBLE_LIBRARY',          DIST_MODULE_PATH))
DEFAULT_REMOTE_TMP        = shell_expand_path(get_config(p, DEFAULTS, 'remote_tmp',       'ANSIBLE_REMOTE_TEMP',      '$HOME/.ansible/tmp'))
DEFAULT_MODULE_NAME       = get_config(p, DEFAULTS, 'module_name',      None,                       'command')
DEFAULT_PATTERN           = get_config(p, DEFAULTS, 'pattern',          None,                       '*')
DEFAULT_FORKS             = get_config(p, DEFAULTS, 'forks',            'ANSIBLE_FORKS',            5)
DEFAULT_MODULE_ARGS       = get_config(p, DEFAULTS, 'module_args',      'ANSIBLE_MODULE_ARGS',      '')
DEFAULT_MODULE_LANG       = get_config(p, DEFAULTS, 'module_lang',      'ANSIBLE_MODULE_LANG',      'C')
DEFAULT_TIMEOUT           = get_config(p, DEFAULTS, 'timeout',          'ANSIBLE_TIMEOUT',          10)
DEFAULT_POLL_INTERVAL     = get_config(p, DEFAULTS, 'poll_interval',    'ANSIBLE_POLL_INTERVAL',    15)
DEFAULT_REMOTE_USER       = get_config(p, DEFAULTS, 'remote_user',      'ANSIBLE_REMOTE_USER',      active_user)
# ...
# ...
# non-configurable things
DEFAULT_SUDO_PASS         = None
DEFAULT_REMOTE_PASS       = None
DEFAULT_SUBSET            = None

ANSIBLE_SSH_ARGS          = get_config(p, 'ssh_connection', 'ssh_args', 'ANSIBLE_SSH_ARGS', None)
ZEROMQ_PORT               = int(get_config(p, 'fireball', 'zeromq_port', 'ANSIBLE_ZEROMQ_PORT', 5099))
```

上述代码定义了较多的常量值，这些常量值将从 ansible.cfg 中获取，如果取不到则会有一个默认值，而这些常量值会直接影响 ansible 命令的执行。以下是一些重要的常量值及其说明。

- DEFAULT_HOST_LIST：指定 Ansible 文件中 inventory 文件（即 host 文件）的路径，该值可在 Ansible 的配置文件（ansible.cfg）中由 hostfile 变量指定，默认值为/etc/ansible/hosts。

- DEFAULT_MODULE_PATH：Ansible 自定义模块的代码目录。

- DEFAULT_REMOTE_TMP：Ansible 远程执行时会新建一个临时目录，用于存放一些代码文件和上传的文件等，默认值为$HOME/.ansible/tmp。

- DEFAULT_MODULE_NAME：当执行 ansible 命令时，如果不指定执行模块，则执行默认模块 command。

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -a "pwd"
ceph-1 | success | rc=0 >>
/root
shell=False, args=['pwd']
```

- DEFAULT_FORKS：Ansible 运行时启动的进程数，默认最多启动 5 个进程任务。

- DEFAULT_TIMEOUT：SSH 连接超时时间。

- DEFAULT_TRANSPORT：SSH 连接方式。

在 1.4 节中将看到 Ansible 提供的 5 种连接插件，其中比较重要的两个插件为 paramiko 插件和 ssh 插件。

前者基于 paramiko 模块封装了远程连接和操作的接口，而后者使用 SSH 命令本身完成远程连接和操作的接口。

Ansible 1.1 中默认使用 paramiko 插件远程操作节点，而之后的版本则默认使用 ssh 插件（即 ssh.py 文件中的代码）

### 4.color.py

color.py 文件提供了一个 stringc()方法，可以实现在控制台上打印不同颜色的文本信息。请看下面的示例代码：

```sh
(ansible1.1) [root@master ~]# python
Python 2.7.18 (default, Oct 13 2020, 23:55:15)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> from ansible.color import stringc
>>> print(stringc('这是红色', 'red'))
这是红色
>>> print(stringc('这是蓝色', 'blue'))
这是蓝色
```

读者可以在自己的 Linux 系统上测试这几行语句，看是否有颜色变化。支持的颜色如下：

```python
# 源码位置: lib/ansible/color.py
# ...

codeCodes = {
    'black':     '0;30', 'bright gray':    '0;37',
    'blue':      '0;34', 'white':          '1;37',
    'green':     '0;32', 'bright blue':    '1;34',
    'cyan':      '0;36', 'bright green':   '1;32',
    'red':       '0;31', 'bright cyan':    '1;36',
    'purple':    '0;35', 'bright red':     '1;31',
    'yellow':    '0;33', 'bright purple':  '1;35',
    'dark gray': '1;30', 'bright yellow':  '1;33',
    'normal':    '0'
}

# ...

# 源码位置: lib/ansible/color.py
# ...

def stringc(text, color):
    """打印带颜色的字符串"""

    if ANSIBLE_COLOR:
        return "\033["+codeCodes[color]+"m"+text+"\033[0m"
    else:
        return text
```

其实现原理也非常简单，只需要在文本前后分别加上 `“\033[颜色编号m”和“\033[0m”`（参考 stringc()方法的源码），就可以在 Linux 终端打印不同的颜色。

其实将\033 替换成\e 也是没有问题的，可以手动在 Linux 的终端执行命令 `echo -e "\e[0;34mhello,world\e[0m"`
