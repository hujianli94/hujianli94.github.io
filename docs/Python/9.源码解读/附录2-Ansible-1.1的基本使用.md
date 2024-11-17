# 附录 2-Ansible 1.1 的基本使用

## Ansible 1.1 模块说明

Ansible 1.1 的模块文件均在源码的 library 目录下，但这些都是不完整的 Python 代码，无法直接运行。

在 ansible 命令执行过程中，会将对应模块文件中的 Python 代码和一个公共的代码合并，最后形成可执行的 Python 代码并上传到远端主机执行。

通过阅读 library 目录下的模块代码，可以很清楚地了解相应 Ansible 模块所支持的参数及该模块在远端主机上的执行动作，这是掌握该模块用法的最佳途径。

在后续 Ansible 2 的模块学习中，也将沿着这一模式进行。

## Ansible 1.1 的常用模块

Ansible 1.1 源码中一共提供了 79 个模块，其中的许多模块名称沿用至今，例如常用的 ping 模块、shell/command 模块、copy 模块、cron 模块、file 模块和 user 模块等。

这些模块的基本功能和使用方法与 Ansible 2.8 并没有太大区别，只不过后者的内置模块更多，模块功能更为强大，且支持更多的参数控制。

下面简单介绍一些常用的基础模块及这些模块的使用。

### 1.ping 模块

ping 模块用于测试远端主机是否能正常进行 SSH 通信，使用方法也比较简单，只有一个 data 参数，用于填充返回 ping 字段的结果。

```sh
(ansible1.1) [root@master ~]# cat hosts
[nodes]
ceph-[1:3]

[nodes:vars]
ansible_ssh_user=root
ansible_ssh_pass=xxxx
ansible_ssh_port=22

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m ping
ceph-1 | success >> {
    "changed": false,
    "ping": "pong"
}

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m ping -a "data='hello, ansible'"
ceph-1 | success >> {
    "changed": false,
    "ping": "hello, ansible"
}
```

ansible 命令的使用非常简单。

```sh
ansible <目标主机> [-i 指定目标主机的文件] [-m 模块] [-a 参数] [其他选项]
```

以下是 ping 模块的代码，该部分代码位于源码目录的 library 下的 ping 文件中。

```python
def main():
    module = AnsibleModule(
        # 定义模块支持的参数, 该模块支持 data 参数
        argument_spec = dict(
            data=dict(required=False, default=None),
        ),
        supports_check_mode = True
    )
    # 初始化返回结果
    result = dict(ping='pong')
    if module.params['data']:
        result['ping'] = module.params['data']
    # 带上结果，退出
    module.exit_json(**result)

# this is magic, see lib/ansible/module_common.py
#<<INCLUDE_ANSIBLE_MODULE_COMMON>>
main()
```

ping 模块在远端主机上的执行动作为：从 ping 模块中取出 data 参数的值（如果存在）并放到结果的 ping 字段中，最后再将结果返回。

ping 模块代码中涉及的 AnsibleModule 类将由 Ansible 1.1 中的公共代码（module_common.py）提供，这里不用过于深究。

### 2.shell 模块

shell 模块可以说是 Ansible 中最常用的模块了，也是 Ansible 中不可缺少的模块。

它用于对远端主机批量执行 shell 命令，支持管道写法。shell 模块提供的重要参数如下：

- creates：该参数值需要传入一个文件路径，如果指定的文件存在，则不执行 shell 模块；否则执行 shell 模块。

- removes：和 creates 参数正好相反，如果指定的文件存在，则执行 shell 模块；否则不执行 shell 模块。

- chdir：先进入该目录然后再执行 shell 命令。

- executable：选择执行 shell 命令的解释器，如/bin/sh 等。一般不用指定，使用默认值即可。

以下是关于 shell 模块的若干使用案例：

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "hostname"
ceph-1 | success | rc=0 >>
ceph-1

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "hostname creates=/etc/hosts"
ceph-1 | skipped
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "hostname creates=/etc/not-exists"
ceph-1 | success | rc=0 >>
ceph-1

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "hostname removes=/etc/hosts"
ceph-1 | success | rc=0 >>
ceph-1

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "hostname removes=/etc/not-exist"
ceph-1 | skipped

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "pwd"
ceph-1 | success | rc=0 >>
/root

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "pwd chdir=/tmp"
ceph-1 | success | rc=0 >>
/tmp
```

#### 2.1 command 模块

Ansible 中还有一个 command 模块，它和 shell 模块类似但不如 shell 模块的功能强大。

command 模块在远程主机上执行命令时不会经过远程主机的 shell 处理，即在使用 command 模块时，如果待执行的命令中出现管道符（|）或重定向操作等，都会导致命令运行失败。

例如以下操作：

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m command -a "ps -ef | grep sshd"
ceph-1 | FAILED | rc=1 >>
error: garbage option

Usage:
 ps [options]

 Try 'ps --help <simple|list|output|threads|misc|all>'
  or 'ps --help <s|l|o|t|m|a>'
 for additional help text.

For more details see ps(1).
```

那究竟是什么原因造成 shell 和 command 模块的运行差别呢？

通过查找 shell 模块的代码发现，shell 模块文件中仅有相关的模块说明而没有相关代码。

通过后续的学习可知：shell 模块复用了 command 模块中的代码，但 Ansible 会在 shell 模块的参数中添加一个#USE_SHELL 标识，用于标明本次执行的是 shell 模块；如果没有该标识，则会被认为是 command 模块。command 模块中的代码内容如下：

```python
def main():

    # command模块的参数提取比较特殊，不能直接通过AnsibleModule对象获取
    module = CommandModule(argument_spec=dict())

    # 判断是shell还是command模块
    shell = module.params['shell']
    chdir = module.params['chdir']
    executable = module.params['executable']
    args  = module.params['args']
    creates  = module.params['creates']
    removes  = module.params['removes']

    if args.strip() == '':
        module.fail_json(rc=256, msg="no command given")

    if chdir:
        # 如果存在该参数，则调用os.chdir()方法进入该目录
        os.chdir(os.path.expanduser(chdir))

    if creates:
        v = os.path.expanduser(creates)
        # 如果文件存在，则模块不执行，直接退出
        if os.path.exists(v):
            module.exit_json(
                cmd=args,
                stdout="skipped, since %s exists" % v,
                skipped=True,
                changed=False,
                stderr=False,
                rc=0
            )

    if removes:
        v = os.path.expanduser(removes)
        # 如果文件不存在，则模块不执行，直接退出
        if not os.path.exists(v):
            module.exit_json(
                cmd=args,
                stdout="skipped, since %s does not exist" % v,
                skipped=True,
                changed=False,
                stderr=False,
                rc=0
            )
    # shell和command的区别：shell信息会保存在args中并被传递到module.run_command()方法
    if not shell:
        args = shlex.split(args)
    startd = datetime.datetime.now()

    rc, out, err = module.run_command(args, executable=executable)

    endd = datetime.datetime.now()
    delta = endd - startd

    if out is None:
        out = ''
    if err is None:
        err = ''

    module.exit_json(
        cmd     = args,
        stdout  = out.rstrip("\r\n"),
        stderr  = err.rstrip("\r\n"),
        rc      = rc,
        start   = str(startd),
        end     = str(endd),
        delta   = str(delta),
        changed = True
    )

# 只有command模块的参数需要这样单独处理，其他模块参数必须是key=value的形式
class CommandModule(AnsibleModule):
# ....
    def _load_params(self):
        # 读取输入，返回字典信息及参数字符串
        args = MODULE_ARGS
        params = {}
        params['chdir'] = None
        params['creates'] = None
        params['removes'] = None
        params['shell'] = False
        params['executable'] = None

        if args.find("#USE_SHELL") != -1:
            args = args.replace("#USE_SHELL", "")
            params['shell'] = True
        #....
```

从这里可以看到 chdir、creates 和 removes 三个参数的作用，具体可参考注释，这里不再说明。

至于模块中得到的 shell 和 executable 参数，有如下关键代码：

```python

if not shell:
    args = shlex.split(args)
rc, out, err = module.run_command(args, executable=executable)
```

上面的 args 就是模块参数中的 shell 命令。

对于 command 模块，如`hostname -s`命令，会被 Python 内置的 shlex 模块切割处理，得到['hostname','-s']这样的数组形式；

而对于 shell 模块而言，输入的命令可以看作一个长字符串，如 `"ps-ef|grep sshd"`。

最后，args 值连同 executable 参数值一起传给 AnsibleModule 对象的 run_command()方法，并在当前主机上执行。

下面继续深入学习 run_command()方法，它位于源码的 lib/ansible/module_common.py 中，具体代码如下：

```python
# 源码路径：lib/ansible/module_common.py
# ...

MODULE_COMMON = """

# 忽略部分代码

class AnsibleModule(object):

    # ...

    def run_command(self, args, check_rc=False, close_fds=False, executable=None, data=None):
        # 处理args参数类型
        if isinstance(args, list):
            shell = False
        elif isinstance(args, basestring):
            shell = True
        else:
            msg = "Argument 'args' to run_command must be list or string"
            self.fail_json(rc=257, cmd=args, msg=msg)
        rc = 0
        msg = None
        st_in = None
        if data:
            st_in = subprocess.PIPE
        try:
            # 调用Python内置的subprocess模块去执行shell命令
            cmd = subprocess.Popen(args,
                                   executable=executable, # 执行shell命令的解释器
                                   shell=shell,           # shell命令
                                   close_fds=close_fds,
                                   stdin=st_in,               # 输入
                                   stdout=subprocess.PIPE, # 输出
                                   stderr=subprocess.PIPE) # 错误输出
            if data:
                # 如果有data数据，则通过stdin写入
                cmd.stdin.write(data)
                cmd.stdin.write('\\n')
            # 执行命令并获取结果，rc为本次命令执行返回的状态码
            out, err = cmd.communicate()
            rc = cmd.returncode
        except (OSError, IOError), e:
            self.fail_json(rc=e.errno, msg=str(e), cmd=args)
        except:
            self.fail_json(rc=257, msg=traceback.format_exc(), cmd=args)
        if rc != 0 and check_rc:
            msg = err.rstrip()
            self.fail_json(cmd=args, rc=rc, stdout=out, stderr=err, msg=msg)
        return (rc, out, err)
    # ...

"""
```

这里的 run_command()方法是通过 subprocess 模块执行 shell 命令的，该方法通过传入的命令参数（args）判断是否需要 shell。

如果 args 为数组形式，则为 command 模块，设置 shell 参数为 False；否则为 shell 模块，设置 shell 参数为 True。

subprocess 模块能否支持 `ps-ef|grep sshd`这样带管道或重定向符的命令，依赖于 `subprocess.Popen()`方法中输入的 shell 参数。

关于这些参数的更详细的介绍，可以直接参考 Python 的官方文档，因为 subprocess 模块是 Python 内置的标准模块。

此外，可以在 command 模块的 main()方法的最后一个 module.exit_json()中添加额外的输出信息，用于检验上面分析过程的正确性，具体代码如下：

```python
# 源码位置：library/command
# ...

def main():
    # ...

    module.exit_json(
        cmd     = args,
        # 修改这里了
        stdout   = out.rstrip("\r\n") + "\nshell={}, args={}".format(shell,args),
        #stdout  = out.rstrip("\r\n"),
        stderr   = err.rstrip("\r\n"),
        rc      = rc,
        start    = str(startd),
        end     = str(endd),
        delta    = str(delta),
        changed = True
    )
```

对应修改 `/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/command` 中的相应代码，然后再次运行 ansible 命令，具体代码如下：

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m command -a "hostname -s  removes=/etc/hosts"
ceph-1 | success | rc=0 >>
ceph-1
shell=False, args=['hostname', '-s']

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m shell -a "ps -ef | grep ssh  removes=/etc/hosts"
ceph-1 | success | rc=0 >>
root 1155 1 0 04:37 ? 00:00:00 /usr/sbin/sshd -D
root 10728 1155 0 15:33 ? 00:00:00 sshd: store [priv]
store 10735 10728 0 15:33 ? 00:00:00 sshd: store@pts/0
root 15087 1155 0 20:39 ? 00:00:00 sshd: root@notty
root 15099 15087 0 20:39 ? 00:00:00 /usr/libexec/openssh/sftp-server
root 15118 15117 0 20:39 ? 00:00:00 /bin/sh -c ps -ef | grep ssh
root 15120 15118 0 20:39 ? 00:00:00 grep ssh
shell=True, args=ps -ef | grep ssh
```

从上面的打印结果中可以看到 command 模块与 shell 模块代码中有关 shell 参数的值，该参数决定了这两个模块的不同之处。

### 3.copy 模块

copy 模块也是 Ansible 中的一个常用模块，使用频率仅次于 shell 模块。

通常，copy 模块用于向多个远端主机下发文件，支持强制覆盖、文件备份、修改文件权限及属主等。

下面是 copy 模块的一些使用案例。

```python
# 使用copy模块之前的ceph-1主机
[root@ceph-1 ~]# ls
anaconda-ks.cfg

# 在master主机上新建一个测试文件
(ansible1.1) [root@master ~]# cat test_copy.txt
测试Ansible的copy模块，上传

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a "src=test_copy.txt dest=~/test_copy.txt"
ceph-1 | success >> {
    "changed": true,
    "dest": "/root/test_copy.txt",
    "group": "root",
    "md5sum": "8b8437beb7107dee441dbb9cb4ca9520",
    "mode": "0644",
    "owner": "root",
    "size": 36,
    "src": "/root/.ansible/tmp/ansible-1602680244.85-189392735288190/source",
    "state": "file"
}

# 执行copy模块后，再次查看ceph-1主机
[root@ceph-1 ~]# ls
anaconda-ks.cfg  test_copy.txt

[root@ceph-1 ~]# cat test_copy.txt
测试Ansible的copy模块，上传
```

在 copy 模块中，src 参数表示本地文件路径，dest 参数表示上传文件到目标主机的位置，该值可以是文件全路径，也可以是目录。

如果 dest 是目录，此时上传的文件名默认为 src 中的文件名。

另外，backup 和 force 参数则表示是否进行文件备份和是否强制覆盖原文件。

下面是关于 force 参数的一个示例。

```sh
# 目标主机上存在test_copy.txt文件
[root@ceph-1 ~]# ls
anaconda-ks.cfg  test_copy.txt
[root@ceph-1 ~]#

# master节点
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a "src=test_copy.txt dest=~ force=no"
ceph-1 | success >> {
    "changed": false,
    "dest": "/root",
    "group": "root",
    "mode": "0550",
    "msg": "file already exists",
    "owner": "root",
    "size": 220,
    "src": "/root/.ansible/tmp/ansible-1602682077.88-25716069795499/source","state": "directory"
}
```

在 Ansible 的公共代码中有如下设置：

```python

MODULE_COMMON = """
# ...

BOOLEANS_TRUE = ['yes', 'on', '1', 'true', 1]
BOOLEANS_FALSE = ['no', 'off', '0', 'fyesalse', 0]

# ...

"""
```

即字面值'yes'、'on'、'1'、'true'、1 都会被解析成 Python 中的 True，
而'no'、'off'、'0'、'fyesalse'、0 则都会被解析成 Python 中的 False，这些技巧在编写 Playbook 文件时非常有用。

再回到 copy 模块，当 force 值设置为字面值的 False 后，copy 模块会返回文件已经存在的信息且不会强制替换。
force 参数默认为 yes。以下是关于 backup 参数的一个例子。

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a "src=test_copy.txt dest=/root/test_copy.txt backup=yes"
ceph-1 | success >> {
    "changed": false,
    "group": "root",
    "mode": "0644",
    "owner": "root",
    "path": "/root/test_copy.txt",
    "size": 36,
    "state": "file"
}

# 主机ceph-1上并没有备份文件
[root@ceph-1 ~]# ls
anaconda-ks.cfg  test_copy.txt
```

可以看到上面的 backup 参数并没有生效，这是什么原因呢？修改 test_copy.txt 文件中的内容再试一次：

```sh
(ansible1.1) [root@master ~]# cat test_copy.txt
测试Ansible的copy模块，上传新的版本

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a "src=test_copy.txt dest=/root/test_copy.txt backup=yes"
ceph-1 | success >> {
    "backup_file": "/root/test_copy.txt.2020-10-20@23:24~",
    "changed": true,
    "dest": "/root/test_copy.txt",
    "group": "root",
    "md5sum": "b98cff05b477c23067bf6eb2c2ddab4f",
    "mode": "0644",
    "owner": "root",
    "size": 50,
    "src": "/root/.ansible/tmp/ansible-1602682811.7-79801427392161/source",
    "state": "file"
}

# 查看ceph-1主机，备份文件已经生成
[root@ceph-1 ~]# ls
anaconda-ks.cfg  test_copy.txt  test_copy.txt.2020-10-20@23:24~
```

从上面的演示结果中可以看到，修改源文件后再执行 copy 模块，backup 参数生效。

这一现象说明，Ansible 会对比本地文件和远端文件，如果文件相同，则不会做任何操作便直接返回。

后面在 copy 模块的源码中可以清楚地看到这个比较过程。

接下来看 copy 的另一个参数 content，该参数和 src 参数是互斥的。content 参数的内容将写入 dest 参数指定的文件中，请看如下示例代码：

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a "dest=/tmp/test_content.txt content=xxxxxxx"
ceph-1 | success >> {
    "changed": true,
    "dest": "/tmp/test_content.txt",
    "group": "root",
    "md5sum": "04adb4e2f055c978c9bb101ee1bc5cd4",
    "mode": "0644",
    "owner": "root",
    "size": 7,
    "src": "/root/.ansible/tmp/ansible-1602681193.07-232005738125574/source",
    "state": "file"
}

# 在ceph-1主机上查看上传文件结果
[root@ceph-1 ~]# ls /tmp/
test_content.txt  test_copy.txt
[root@ceph-1 ~]# cat /tmp/test_content.txt
xxxxxxx[root@ceph-1 ~]#
```

接下来看 content 参数的另一个例子，此时的 copy 模块中隐藏着一个不能满足需求的情况，具体代码如下：

```sh
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a 'dest=/tmp/test_content.txt content="xxxxxxx\n"'
ceph-1 | success >> {
    "changed": false,
    "group": "root",
    "mode": "0644",
    "owner": "root",
    "path": "/tmp/test_content.txt",
    "size": 9,
    "state": "file"
}

# 在目标主机上发现换行符没有生效，这算不算Ansible 1.1的一个Bug?
[root@ceph-1 ~]# cat /tmp/test_content.txt
xxxxxxx\n[root@ceph-1 ~]#
```

从上面的例子中可以看到，当 content 参数值中包含转义符如\n 时，Ansible 的 copy 模块无法对其进行转义，而是原封不动地输出。

那么如何才能得到想要的结果呢？

接下来将分析 copy 模块的代码，厘清该模块的执行逻辑。copy 模块的代码位于源码目录下的 library/copy 文件中，具体代码如下：

```python
# 代码位置: library/copy
import os
import shutil
import time

def main():

    # 获取通用的Ansible模块对象，简化写法
    module = AnsibleModule(...)

    # 提取相关参数
    src    = os.path.expanduser(module.params['src'])
    dest   = os.path.expanduser(module.params['dest'])
    backup = module.params['backup']
    force  = module.params['force']
    original_basename = module.params.get('original_basename',None)

    # 如果src文件不存在或者不可读，则直接返回错误信息
    if not os.path.exists(src):
        module.fail_json(msg="Source %s failed to transfer" % (src))
    if not os.access(src, os.R_OK):
        module.fail_json(msg="Source %s not readable" % (src))

    # 计算源文件的MD5值
    md5sum_src = module.md5(src)
    md5sum_dest = None

    if os.path.exists(dest):
        # 如果dest存在，则开始考虑force参数，如果force设置为no，则直接退出，同时提示文件存在
        if not force:
            module.exit_json(msg="file already exists", src=src, dest=dest,changed=False)
        # 对于目录情况，可以配合original_basename参数，生成最后的目标文件路径
        if (os.path.isdir(dest)):
            basename = os.path.basename(src)
            if original_basename:
                basename = original_basename
            dest = os.path.join(dest, basename)
        # 如果可读，计算原目标文件的MD5值
        if os.access(dest, os.R_OK):
            md5sum_dest = module.md5(dest)
    else:
        # 对于目标文件所在目录也不存在的情况，直接返回错误信息
        if not os.path.exists(os.path.dirname(dest)):
            module.fail_json(msg="Destination directory %s does not exist" % (os.path.dirname(dest)))
    # 对于目标文件所在目录不可写的情况，直接返回错误信息
    if not os.access(os.path.dirname(dest), os.W_OK):
        module.fail_json(msg="Destination %s not writable" % (os.path.dirname(dest)))

    backup_file = None
    if md5sum_src != md5sum_dest or os.path.islink(dest):
        # 如果源文件和目标文件的MD5值不同，才执行后续的动作
        try:
            if backup:
                # 如果设置了备份项并且目标文件存在，则先备份目标文件
                if os.path.exists(dest):
                    backup_file = module.backup_local(dest)
            # allow for conversion from symlink.
            if os.path.islink(dest):
                os.unlink(dest)
                open(dest, 'w').close()
            # TODO:pid + epoch should avoid most collisions, hostname/mac for
              those using nfs?
            # might be an issue with exceeding path length
            dest_tmp = "%s.%s.%s.tmp" % (dest,os.getpid(),time.time())
            # 最后的核心操作就是使用shutil.copyfile()方法将源文件复制一份，得到临时文件
            shutil.copyfile(src, dest_tmp)
            # 将生成的临时文件替换成最终的目标文件，原子替换方式
            module.atomic_replace(dest_tmp, dest)
        except shutil.Error:
            module.fail_json(msg="failed to copy: %s and %s are the same" %(src, dest))
        except IOError:
            module.fail_json(msg="failed to copy: %s to %s" % (src, dest))
        changed = True
    else:
        # 如果源文件和目标文件是同一个文件，设置changed=False后直接返回
        changed = False

    # 最后的返回结果
    res_args = dict(dest = dest, src = src, md5sum = md5sum_src, changed = changed)
    # 如果有备份文件，则写入备份的文件名
    if backup_file:
        res_args['backup_file'] = backup_file

    module.params['dest'] = dest
    # 获取文件信息
    file_args = module.load_file_common_arguments(module.params)
    res_args['changed'] = module.set_file_attributes_if_different(file_args, res_args['changed'])
    module.exit_json(**res_args)

# this is magic, see lib/ansible/module_common.py
#<<INCLUDE_ANSIBLE_MODULE_COMMON>>
main()
```

上面的代码中给出了详细的注释，整个 copy 模块的代码清晰、明了，并且实现过程对新手非常友好，没有任何复杂的写法。

copy 模块中的代码主要是将源文件移动到目的路径上，即在 copy 模块代码执行之前，本地的文件就已经被上传到了目标主机的某个临时目录下。

因此，如果 content 参数中出现无法正确转义的情况，便不能在 copy 模块中修改了，只能在生成该源文件的地方进行修改。

为此，可以在获取 src 值的代码后面加上调试信息，打印源文件位置及源文件内容，方便进行查看与分析，具体如下：

```python

# 代码位置: library/copy
# ...

def main():

    # ...

    # 提取相关参数
    src    = os.path.expanduser(module.params['src'])

    # 打印调试信息
    debug_data = {
      'src': src,
      'content': open(src, 'rb').read()
    }
    # 直接返回，不进行后面的操作
    module.exit_json(**debug_data)

    # ...
```

修改测试环境的路径为 `/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/copy`，然后再来看 content 参数的示例，具体如下：

```sh
# 先删除ceph-1上的目标文件，再执行改动的copy模块
[root@ceph-1 ~]# rm -f /tmp/test_content.txt

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m copy -a 'dest=/tmp/test_content.txt content="xxxxxxx\n"'
ceph-1 | success >> {
    "changed": false,
    "content": "xxxxxxx\\n",
    "src": "/root/.ansible/tmp/ansible-1602686551.95-120685118068937/source"
}
```

说明：在执行上述指令之前，应先将原先生成的/tmp/test_content.txt 文件删掉，否则 copy 模块代码不会执行。

从上面的结果中可以看到，在执行 copy 模块之前，内容为 content 参数值的源文件已经生成且内容中的转义字符前被添加了一个斜线。

### 4.file 模块

file 模块也是一个常用的模块，它能帮助使用者设置远端文件、系统链接、目录的属性，也可以创建和删除系统链接或目录，但是该模块无法创建 Linux 上的普通文件。

file 模块支持的参数如下：

- path：操作的文件对象，可以是文件或者目录。如果对象是系统链接（state=link），还需要设置 src 参数后才能创建该系统链接。

- state：有 4 个选项值，分别为 file、link、directory 和 absent，默认为 file。当该值为 absent 时，表示删除 path 对应的文件。

- mode：设置文件或者目录的权限值，如 0644。

- owner/group：设置操作文件的所有者和所属组。

- src：只有在 state=link 时才有效，用于设置系统链接。

- seuser/serole/setype/selevel/context：和 selinux 设置相关，一般较少用到。

- recurse：递归操作，主要在 state=directory 时有效。

下面是关于 file 模块的一个简单示例，结果表明 file 模块能创建目录，但是无法创建普通文件。

```sh
# 操作ceph-1节点，清空目录下的文件
[root@ceph-1 ~]# ls
[root@ceph-1 ~]#

# 在master节点上开始操作，创建普通文件失败
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m file -a "path=~/test_file.txt state=file mode=600"
ceph-1 | FAILED >> {
    "failed": true,
    "msg": "file (/root/test_file.txt) does not exist, use copy or template module to create",
    "path": "/root/test_file.txt",
    "state": "absent"
}

# 创建目录成功
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m file -a "path=~/test_file state=directory mode=600"
ceph-1 | success >> {
    "changed": true,
    "group": "root",
    "mode": "0600",
    "owner": "root",
    "path": "/root/test_file",
    "size": 6,
    "state": "directory"
}

# 查看ceph-1节点，mode参数也生效了
[root@ceph-1 ~]# ls -ld test_file/
drw------- 2 root root 6 Oct 21 14:11 test_file/
```

在基本了解了 file 模块的使用后，可以继续阅读 file 模块中的代码，具体如下（笔者注释掉了与 selinux 相关的代码以方便阅读）：

```python
# 源码位置: library/file

import shutil
import stat
import grp
import pwd
try:
    # 判断是否有selinux模块
    import selinux
    HAVE_SELINUX=True
except ImportError:
    HAVE_SELINUX=False

# 模块说明，使用该模块前请仔细阅读
# ...

def main():

    # 不应该是全局变量
    global module

    # 模块的参数信息，其中state只有4个选项值，分别为file、directory、link和absent，默认为file
    module = AnsibleModule(...)

    params = module.params
    state  = params['state']
    # 这里就是可以写~/xxx.txt的原因
    params['path'] = path = os.path.expanduser(params['path'])

    # ...

    src = params.get('src', None)
    if src:
        src = os.path.expanduser(src)

    # src不为空的另一种用法是：src有值，path为目录且state不等于link时，就可以得到完整的path值
    if src is not None and os.path.isdir(path) and state != "link":
        params['path'] = path = os.path.join(path, os.path.basename(src))

    file_args = module.load_file_common_arguments(params)

    # state的值为link时，必须要有src和path，否则直接返回错误信息
    if state == 'link' and (src is None or path is None):
        module.fail_json(msg='src and dest are required for "link" state')
    # 其他情况必须要有path
    elif path is None:
        module.fail_json(msg='path is required')

    changed = False

    prev_state = 'absent'

    # 检查path文件是否存在，使用的是lexists()方法，这样即使软链接失效了，该方法也会返回True；而exists()方法对于失效的软链接返回False
    if os.path.lexists(path):
        if os.path.islink(path):
            prev_state = 'link'
        elif os.path.isdir(path):
            prev_state = 'directory'
        else:
            prev_state = 'file'

    if prev_state != 'absent' and state == 'absent':
        try:  # 删除link、directory和file三种对象
            if prev_state == 'directory':
                if os.path.islink(path):
                    os.unlink(path) # 链接文件，直接删除
                else:
                    try:
                        # shutil.rmtree()方法将递归删除文件夹下的所有子文件夹和子文件
                        shutil.rmtree(path, ignore_errors=False)
                    except:
                        module.exit_json(msg="rmtree failed")
            else:
                # 对于普通文件和链接文件，直接使用unlink()方法删除即可
                os.unlink(path)
        except Exception, e:
            module.fail_json(path=path, msg=str(e))
        module.exit_json(path=path, changed=True)

    if prev_state != 'absent' and prev_state != state:
        # 主动探测的文件类型和模块设置的state值不一致
        module.fail_json(path=path, msg='refusing to convert between %s and %s for %s' % (prev_state, state, src))

    if prev_state == 'absent' and state == 'absent':
        # 其他类型的文件不处理，直接返回
        module.exit_json(path=path, changed=False)

    if state == 'file':

        if prev_state != 'file':
            # 对于文件不存在的情况，将跳转到这里，输出相应的错误信息并返回
            module.fail_json(path=path, msg='file (%s) does not exist, use copy or template module to create' % path)

        # 设置文件信息，如所属用户、所属组及mode值等
        changed = module.set_file_attributes_if_different(file_args, changed)
        module.exit_json(path=path, changed=changed)
    # 对于目录
    elif state == 'directory':
        if prev_state == 'absent':
            # 如果目录不存在，则调用os.makedirs()方法创建，从这里的调用方法可知file模块是支持多级目录创建的
            os.makedirs(path)
            changed = True

        changed = module.set_directory_attributes_if_different(file_args, changed)
        recurse = params['recurse']
        if recurse:
            # 如果设置了递归参数，则用常规的方法来遍历目录
            for root,dirs,files in os.walk( file_args['path'] ):
                # root为本次遍历的目录，dirs为本次遍历目录下的所有目录，files为本次遍历目录下的所有文件
                for dir in dirs:
                    dirname=os.path.join(root,dir)
                    tmp_file_args = file_args.copy()
                    tmp_file_args['path']=dirname
                    # 统一修改子目录的信息，如所属用户、所属组及mode值等
                    changed = module.set_directory_attributes_if_different(tmp_file_args, changed)
                for file in files:
                    filename=os.path.join(root,file)
                    tmp_file_args = file_args.copy()
                    tmp_file_args['path']=filename
                    # 统一修改目录下的文件信息，如所属用户、所属组及mode值等
                    changed = module.set_file_attributes_if_different(tmp_file_args, changed)
        module.exit_json(path=path, changed=changed)

    elif state == 'link':

        if os.path.isabs(src):
            abs_src = src
        else:
            module.fail_json(msg="absolute paths are required")
        if not os.path.exists(abs_src):
            module.fail_json(path=path, src=src, msg='src file does not exist')

        if prev_state == 'absent':
            # 如果没有该链接则创建链接
            os.symlink(src, path)
            changed = True
        elif prev_state == 'link':
            # 获取path路径下的链接地址，然后和src进行对比，如果不一致则删除path路径下的链接并重新创建
            old_src = os.readlink(path)
            if not os.path.isabs(old_src):
                old_src = os.path.join(os.path.dirname(path), old_src)
            if old_src != src:
                os.unlink(path)
                os.symlink(src, path)
                changed = True
        else:
            module.fail_json(dest=path, src=src, msg='unexpected position reached')

        # 设置权限、属主及上下文数据，如所属用户、所属组及mode值等

        file_args = module.load_file_common_arguments(module.params)
        changed = module.set_context_if_different(path, file_args['secontext'], changed)
        changed = module.set_owner_if_different(path, file_args['owner'], changed)
        changed = module.set_group_if_different(path, file_args['group'], changed)
        changed = module.set_mode_if_different(path, file_args['mode'], changed)

        module.exit_json(dest=path, src=src, changed=changed)

    module.fail_json(path=path, msg='unexpected position reached')

# this is magic, see lib/ansible/module_common.py
#<<INCLUDE_ANSIBLE_MODULE_COMMON>>
main()
```

file 模块的代码并不多，整个模块的执行流程也非常清晰。

同 copy 模块一样，笔者也为该模块做了详细的注释，有 Python 基础的读者基本都能理解这些代码的含义。

从 file 模块的代码中能看到，file 模块并不支持文件创建。如果想让 file 模块支持这个功能，需要怎么调整代码呢？笔者对其进行了如下调整：

```python
    if state == 'file':

        if prev_state != 'file':
            # 注释掉没有path文件时就退出的代码
            # module.fail_json(path=path, msg='file (%s) does not exist, use copy or template module to create' % path)
            # 新增没有path文件时就创建一个空文件的代码。如果上一级目录不存在，则直接 创建上级目录
            base_dir = os.path.dirname(path) if os.path.dirname(path) else os.getcwd()
            if not os.path.exists(base_dir):
                os.makedirs(os.path.dirname(path))
            with open(path, 'a'):
                os.utime(path, None)
        changed = module.set_file_attributes_if_different(file_args, changed)
        module.exit_json(path=path, changed=changed)
```

同步上述改动后的代码到虚拟环境中，修改文件地址如下：

```sh
/root/.pyenv/versions/2.7.18/envs/ansible1.1/share/ansible/file
```

如何查看修改后的效果呢？笔者给出了如下操作示例：

```sh
# 先到ceph-1节点确认/root/test_file目录下没有相应文件
[root@ceph-1 ~]# ls test_file/
[root@ceph-1 ~]#

# 回到master节点的虚拟环境中执行file模块创建文件
(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m file -a "path=~/test_file/test_create_file.txt mode=660"
ceph-1 | success >> {
    "changed": true,
    "group": "root",
    "mode": "0660",
    "owner": "root",
    "path": "/root/test_file/test_create_file.txt",
    "size": 0,
    "state": "file"
}

(ansible1.1) [root@master ~]# ansible ceph-1 -i hosts -m file -a "path=~/test_file/1/2/test_create_file.txt mode=600"
ceph-1 | success >> {
    "changed": true,
    "group": "root",
    "mode": "0600",
    "owner": "root",
    "path": "/root/test_file/1/2/test_create_file.txt",
    "size": 0,
    "state": "file"
}

# 在ceph-1节点上可以清楚地看到几个测试的文件已经创建了
[root@ceph-1 ~]# yum install tree
[root@ceph-1 ~]# tree .
.
└── test_file
    ├── 1
    │   └── 2
    │       └── test_create_file.txt
    └── test_create_file.txt

3 directories, 2 files
[root@ceph-1 ~]# ll test_file/test_create_file.txt
-rw-rw---- 1 root root 0 Oct 21 16:32 test_file/test_create_file.txt

[root@ceph-1 ~]# ll test_file/1/2/test_create_file.txt
-rw------- 1 root root 0 Oct 21 16:34 test_file/1/2/test_create_file.txt
```

可以看到，改造后的 file 模块实现了想要的功能。对于一些特殊的需求，都可以按上面的方式对 Ansible 进行改造。

另外一种途径就是编写自己的 Ansible 模块实现特定的需求，这样可以不用修改 Ansible 的内置模块。

## 编写 Ansible 1.1 的 Playbook

```yaml
(ansible1.1) [root@master ~]# cat test_playbook1.yml
# 注意，这里的hosts正常应该与下面的gather_facts对齐，在代码编辑器中显示正常，
# 但是在这里略显不齐，后续笔者不再说明相关问题
- hosts: nodes
  gather_facts: no
  tasks:
    - name: run first shell
      shell: "cat /etc/hosts | grep `hostname` | awk '{print $1}'"
      register: shell_out

    - name: debug local ip
      debug:
        msg: "hostname=${inventory_hostname}, ip=${shell_out.stdout}"

    - name: create directory
      file:
        path: /tmp/test_dir
        state: directory
```

例如上面有 3 个任务，分别调用了 Ansible 的 shell、debug 和 file 模块，

第一个任务中的 register，表示将 shell 模块执行的结果放到一个字典结果中并赋给 shell_out 变量，而后续的任务中可以通过${shell_out.stdout}得到上一个 shell 模块执行的结果。

在 Ansible 1.1 中，变量的使用是${变量名}形式，而在后续的版本中已经全部改为{{变量名}}形式了。

```sh
(ansible1.1) [root@master python]# ansible-playbook -i hosts test_playbook1.yml

PLAY [nodes] *********************

TASK: [run first shell] *********************
changed: [ceph-2]
changed: [ceph-1]
changed: [ceph-3]

TASK: [debug local ip] *********************
ok: [ceph-2]
ok: [ceph-1]
ok: [ceph-3]

TASK: [create directory] *********************
changed: [ceph-2]
changed: [ceph-1]
changed: [ceph-3]

PLAY RECAP *********************
ceph-1                         : ok=3    changed=2    unreachable=0    failed=0
ceph-2                         : ok=3    changed=2    unreachable=0    failed=0
ceph-3                         : ok=3    changed=2    unreachable=0    failed=0
```

由于 Ansible 1.1 的调试模块（debug）存在一些问题，这里本是想将第一个 shell 命令的结果打印出来，结果却没有显示。这一问题在 Ansible 1.2 中已经修复。

为了在 Ansible 1.1 中也能看到结果，可以加上-v 选项（也可以是-vv、-vvv 选项）打印出详细的执行信息，具体如下：

```sh
(ansible1.1) [root@master python]# ansible-playbook -i hosts test_playbook1.yml -v

PLAY [nodes] *********************

TASK: [run first shell] *********************
changed: [ceph-2] => {"changed": true, "cmd": "cat /etc/hosts | grep `hostname` | awk '{print $1}' ", "delta": "0:00:00.004031", "end": "2024-11-17 00:48:                 13.775776", "rc": 0, "start": "2024-11-17 00:48:13.771745", "stderr": "", "stdout": "192.168.0.110"}
changed: [ceph-1] => {"changed": true, "cmd": "cat /etc/hosts | grep `hostname` | awk '{print $1}' ", "delta": "0:00:00.032500", "end": "2024-11-17 00:48:                 14.772728", "rc": 0, "start": "2024-11-17 00:48:14.740228", "stderr": "", "stdout": "192.168.0.113"}
changed: [ceph-3] => {"changed": true, "cmd": "cat /etc/hosts | grep `hostname` | awk '{print $1}' ", "delta": "0:00:00.054582", "end": "2024-11-17 00:48:                 15.118592", "rc": 0, "start": "2024-11-17 00:48:15.064010", "stderr": "", "stdout": "192.168.0.112"}

TASK: [debug local ip] *********************
ok: [ceph-2] => {"msg": "hostname=ceph-2, ip=192.168.0.110"}
ok: [ceph-1] => {"msg": "hostname=ceph-1, ip=192.168.0.113"}
ok: [ceph-3] => {"msg": "hostname=ceph-3, ip=192.168.0.112"}

TASK: [create directory] *********************
ok: [ceph-2] => {"changed": false, "group": "root", "mode": "0755", "owner": "root", "path": "/tmp/test_dir", "secontext": "unconfined_u:object_r:user_tmp                 _t:s0", "size": 6, "state": "directory"}
ok: [ceph-1] => {"changed": false, "group": "root", "mode": "0755", "owner": "root", "path": "/tmp/test_dir", "secontext": "unconfined_u:object_r:user_tmp                 _t:s0", "size": 6, "state": "directory"}
ok: [ceph-3] => {"changed": false, "group": "root", "mode": "0755", "owner": "root", "path": "/tmp/test_dir", "secontext": "unconfined_u:object_r:user_tmp                 _t:s0", "size": 6, "state": "directory"}

PLAY RECAP *********************
ceph-1                         : ok=3    changed=1    unreachable=0    failed=0
ceph-2                         : ok=3    changed=1    unreachable=0    failed=0
ceph-3                         : ok=3    changed=1    unreachable=0    failed=0
```

可以看到，加上-v 选项，可以打印出更多的模块执行日志，方便查看和分析模块的运行过程。
