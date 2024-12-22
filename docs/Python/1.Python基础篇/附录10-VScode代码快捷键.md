# 附录 10-VScode 代码快捷键

## VS Code 代码片段完全入门指南

如果你更喜欢使用 GUI 界面来编写代码片段，你可以尝试以下 [snippet generator web app](https://snippet-generator.app/?description=&tabtrigger=&snippet=&mode=vscode)。

## Shell snippet

创建自定义代码片段

- 同样按下 Ctrl+Shift+P（或 Cmd+Shift+P 在 Mac 上）打开命令面板。

- 输入 “Configure User Snippets” 并选择 “Shell” 选项，这将打开一个名为 shell.json 的文件。

```json
{
  "Create and enter directory": {
    "prefix": "mkcd",
    "body": ["mkdir -p ${1:directory_name}", "cd ${1}"],
    "description": "Create a directory and enter it"
  },
  "Create and enter directory with git init": {
    "prefix": "mkcdgit",
    "body": ["mkdir -p ${1:directory_name}", "cd ${1}", "git init"],
    "description": "Create a directory, enter it, and initialize a git repository"
  },
  "Create and enter directory with git init and README.md": {
    "prefix": "mkcdgitreadme",
    "body": [
      "mkdir -p ${1:directory_name}",
      "cd ${1}",
      "git init",
      "echo '# ${1}' >> README.md",
      "git add .",
      "git commit -m 'Initial commit'"
    ],
    "description": "Create a directory, enter it, initialize a git repository, and create a README.md"
  },

  "Print variable": {
    "prefix": "pv",
    "body": ["echo \"${1:variable_name}=${!1}\""],
    "description": "Print a variable with its value"
  },

  "Print variable with quotes": {
    "prefix": "pvq",
    "body": ["echo \"${1:variable_name}='${!1}'\""],
    "description": "Print a variable with its value in single quotes"
  },

  // 字符串截取
  "Extract substring": {
    "prefix": "substr",
    "body": [
      "${1:variable_name}=${2:original_string:0:${3:index}}",
      "echo \"${1}\""
    ],
    "description": "Extract a substring from a string"
  },

  // 字符串替换
  "String replacement": {
    "prefix": "strrep",
    "body": [
      "${1:new_string}=${2:original_string//${3:search_pattern}/${4:replacement_pattern}}",
      "echo \"${1}\""
    ],
    "description": "Replace a pattern in a string"
  },

  // 检查文件
  "Check file existence": {
    "prefix": "chkfile",
    "body": [
      "if [ -f \"${1:file_name}\" ]; then",
      "    echo \"File exists.\"",
      "else",
      "    echo \"File does not exist.\"",
      "fi"
    ],
    "description": "Check if a file exists"
  },

  // 检查目录
  "Check directory existence": {
    "prefix": "chkdir",
    "body": [
      "if [ -d \"${1:directory_name}\" ]; then",
      "    echo \"Directory exists.\"",
      "else",
      "    echo \"Directory does not exist.\"",
      "fi"
    ],
    "description": "Check if a directory exists"
  },

  // 读取文件
  "Read file content": {
    "prefix": "readfile",
    "body": ["file_content=$(cat ${1:file_path})", "echo \"$file_content\""],
    "description": "Read and print the content of a file"
  },

  // 读取文件行
  "Read file line by line": {
    "prefix": "readfilelines",
    "body": [
      "while IFS= read -r line",
      "do",
      "    echo \"$line\"",
      "done < ${1:file_path}"
    ],
    "description": "Read and print each line of a file"
  },

  // 读取数组
  "Read file into array": {
    "prefix": "readfilearray",
    "body": [
      "mapfile -t file_lines < ${1:file_path}",
      "for line in \"${file_lines[@]}\"",
      "do",
      "    echo \"$line\"",
      "done"
    ],
    "description": "Read and print each line of a file into an array"
  },

  // 多行注释
  "multiline_comments": {
    "prefix": "meof",
    "body": [": '", "This is a", "multi line", "comment", "'", ""],
    "description": "multiline_comments"
  }
}
```

## Python snippet

创建自定义代码片段

- 同样按下 Ctrl+Shift+P（或 Cmd+Shift+P 在 Mac 上）打开命令面板。

- 输入 “Configure User Snippets” 并选择 “Shell” 选项，这将打开一个名为 python.json 的文件。

```json
{
  "Get current directory": {
    "prefix": "cdir",
    "body": [
      "import os",
      "current_directory = os.path.dirname(os.path.abspath(__file__))",
      "print(f'Current directory: {current_directory}')"
    ],
    "description": "Get the current directory"
  },

  "Get current file name": {
    "prefix": "cfile",
    "body": [
      "import os",
      "current_file_name = os.path.basename(__file__)",
      "print(f'Current file name: {current_file_name}')"
    ],
    "description": "Get the current file name"
  },

  "Get current time": {
    "prefix": "ctime",
    "body": [
      "from datetime import datetime",
      "current_time = datetime.now()",
      "print(f'Current time: {current_time}')"
    ],
    "description": "Get the current time"
  },

  "Loop through list": {
    "prefix": "listloop",
    "body": [
      "my_list = [${1:item1}, ${2:item2}, ${3:item3}]",
      "for item in my_list:",
      "    print(item)"
    ],
    "description": "Loop through a list and print items"
  }
}
```

## Ansible snippet

```json
{
  "ansible_common_modules_apt1": {
    "prefix": "asb_apt1",
    "body": [
      "- name: Install required packages",
      "  ansible.builtin.apt:",
      "    name: \"{{item}}\"",
      "    state: present",
      "    update_cache: yes",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_apt1"
  },
  "ansible_include_role1": {
    "prefix": "asb_include_role1",
    "body": [
      "---",
      "- hosts: services",
      "  remote_user: \"{{ansible_user}}\"",
      "",
      "  pre_tasks:",
      "",
      "  roles:",
      "    - installpack",
      "    - common",
      "    - esrtf",
      "    - sonarworker",
      "    - fdfs",
      "",
      "  post_tasks:",
      "    - name: 设置服务开机自启动",
      "      shell: echo \"/bin/bash /usr/local/bin/serviceshost.sh\" >> /etc/rc.local && chmod +x /etc/rc.local && chmod +x /etc/rc.d/rc.local\"",
      "      become: yes",
      "      become_method: sudo"
    ],
    "description": "ansible_include_role1"
  },
  "ansible_include_role2": {
    "prefix": "asb_include_role2",
    "body": [
      "---",
      "",
      "- include: redis.yml",
      "- include: db.yml",
      "- include: license-gitignore.yml"
    ],
    "description": "ansible_include_role2"
  },
  "ansible_common_modules_shell1": {
    "prefix": "asb_shell1",
    "body": [
      "- name: Configure timezone",
      "  ansible.builtin.shell: ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone",
      ""
    ],
    "description": "ansible_common_modules_shell1"
  },
  "ansible_common_modules_shell2": {
    "prefix": "asb_shell2",
    "body": [
      "- name: control plane初始化成功,添加用户连接集群配置",
      "  ansible.builtin.shell: mkdir -p \\$HOME/.kube && cp /etc/kubernetes/admin.conf \\${HOME}/.kube/config && chown \\$(id -u):\\$(id -g) \\$HOME/.kube/config",
      "  become: yes",
      "  when:",
      "    - opriation == \"create\"",
      "    - rc_result.rc == 0",
      ""
    ],
    "description": "ansible_common_modules_shell2"
  },
  "ansible_common_modules_shell3": {
    "prefix": "asb_shell3",
    "body": [
      "- name: 初始化数据库 1",
      "  ansible.builtin.shell: \"chdir=/app/gitee bundle exec rake db:migrate RAILS_ENV=production\"",
      "  run_once: true",
      "  delegate_to: backend1"
    ],
    "description": "ansible_common_modules_shell3"
  },
  "ansible_common_modules_copy1": {
    "prefix": "asb_copy1",
    "body": [
      "- name: Configure online sources",
      "  ansible.builtin.copy:",
      "    src: sources.list",
      "    dest: /etc/apt/",
      "    backup: yes"
    ],
    "description": "ansible_common_modules_copy1"
  },
  "ansible_common_modules_copy2": {
    "prefix": "asb_copy2",
    "body": [
      "- name: 优化用户所能打开的最大文件描述符数&加载ipvs模块&优化内核参数",
      "  ansible.builtin.copy:",
      "    src: \"{{ item.src }}\"",
      "    dest: \"{{ item.dest }}\"",
      "    backup: yes",
      "  with_items:",
      "    - {src: 'limits.conf', dest: '/etc/security/limits.conf'}",
      "    - {src: 'limits.conf', dest: '/etc/security/limits.d/20-nproc.conf'}",
      "    - {src: 'ipvs.conf', dest: '/etc/modules-load.d/ipvs.conf'}",
      "    - {src: 'k8s.conf', dest: '/etc/sysctl.d/k8s.conf'}",
      "  notify:",
      "    - Start systemd-modules-load.service",
      "    - Reboot OS",
      ""
    ],
    "description": "ansible_common_modules_copy2"
  },
  "ansible_common_modules_template1": {
    "prefix": "asb_template1",
    "body": [
      "- name: 配置 keepalived",
      "  ansible.builtin.template:",
      "    src: keepalived/frontend/keepalived.conf",
      "    dest: /etc/keepalived/keepalived.conf",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_template1"
  },
  "ansible_common_modules_template2": {
    "prefix": "asb_template2",
    "body": [
      "- name: 复制启动脚本",
      "  ansible.builtin.template:",
      "    src: \"keepalived/frontend/{{item}}\"",
      "    dest: \"/usr/local/bin/{{item}}\"",
      "    mode: \"0755\"",
      "  with_items:",
      "    - frontendhost.sh",
      "    - check_server.sh",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_template2"
  },
  "ansible_common_modules_unarchive1": {
    "prefix": "asb_unarchive1",
    "body": [
      "- name: Unarchive containerd-{{ containerd_version }}-linux-amd64.tar.gz",
      "  ansible.builtin.unarchive:",
      "    src: /tmp/containerd-{{ containerd_version }}-linux-amd64.tar.gz",
      "    dest: /usr/local",
      "    copy: no"
    ],
    "description": "ansible_common_modules_unarchive1"
  },
  "ansible_common_modules_unarchive2": {
    "prefix": "asb_unarchive2",
    "body": [
      "- name: Unarchive nerdctl-{{ nerdctl }}-linux-amd64.tar.gz",
      "   ansible.builtin.unarchive:",
      "    src: /tmp/nerdctl-{{ nerdctl }}-linux-amd64.tar.gz",
      "    dest: /tmp/",
      "    copy: no"
    ],
    "description": "ansible_common_modules_unarchive2"
  },
  "ansible_common_modules_cron1": {
    "prefix": "asb_cron1",
    "body": [
      "- name: Configure crontab Time sync",
      "  ansible.builtin.cron:",
      "    name: \"Cron time sync\"",
      "    minute: \"*/5\"",
      "    job: /usr/sbin/ntpdate {{ ntp_server }} &>/dev/null",
      "  when: ntp_server is defined"
    ],
    "description": "ansible_common_modules_cron1"
  },
  "ansible_common_modules_user1": {
    "prefix": "asb_user1",
    "body": [
      "- name: add git user",
      "  ansible.builtin.user:",
      "    name: git",
      "    password: \"{{ item | password_hash('sha512') }}\"",
      "    groups:",
      "      - wheel",
      "    append: yes",
      "    state: present",
      "  with_items:",
      "    - \"admin#123\"",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_user1"
  },
  "ansible_common_modules_file1": {
    "prefix": "asb_file1",
    "body": [
      "- name: Create /etc/containerd",
      "  ansible.builtin.file:",
      "    path: /etc/containerd",
      "    state: directory",
      ""
    ],
    "description": "ansible_common_modules_file1"
  },
  "ansible_common_modules_file2": {
    "prefix": "asb_file2",
    "body": [
      "- name: 创建 /app 目录",
      "   ansible.builtin.file:",
      "    path: '/app/{{item}}'",
      "    state: directory",
      "    owner: git",
      "    group: git",
      "  with_items:",
      "    - oscsrc",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_file2"
  },
  "ansible_common_modules_file3": {
    "prefix": "asb_file3",
    "body": [
      "- name: 建立软链接 archive",
      "  ansible.builtin.file:",
      "    src: /data/archive",
      "    dest: /app/gitee/tmp/repositories",
      "    state: link"
    ],
    "description": "ansible_common_modules_file3"
  },
  "ansible_common_modules_file4": {
    "prefix": "asb_file4",
    "body": [
      "- name: 修改 production.log 权限",
      "  ansible.builtin.file:",
      "    path: /app/gitee/log/production.log",
      "    state: touch",
      "    mode: '0666'",
      "    mode: '0666'"
    ],
    "description": "ansible_common_modules_file4"
  },
  "ansible_common_modules_yum1": {
    "prefix": "asb_yum1",
    "body": [
      "- name: 安装 keepalived",
      "  ansible.builtin.yum:",
      "    name: \"{{item}}\"",
      "    state: present",
      "  with_items:",
      "    - keepalived",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "ansible_common_modules_yum1"
  },
  "ansible_common_modules_service1": {
    "prefix": "asb_service1",
    "body": [
      "- name: Start kubelet",
      "   ansible.builtin.service:",
      "    name: kubelet.service",
      "    state: started",
      "    enabled: yes"
    ],
    "description": "ansible_common_modules_service1"
  },
  "ansible_common_modules_systemd1": {
    "prefix": "asb_systemd1",
    "body": [
      "- name: Start containerd.service",
      "  ansible.builtin.systemd:",
      "    name: containerd.service",
      "    state: started",
      "    daemon_reload: yes",
      "    enabled: yes"
    ],
    "description": "ansible_common_modules_systemd1"
  },
  "ansible_common_modules_get_url1": {
    "prefix": "asb_get_url1",
    "body": [
      "- name: Download kubenetes packages crictl",
      "  ansible.builtin.get_url:",
      "    url: http://{{ download_address }}/kubeadm-install/{{ crictl }}/crictl-v{{ crictl }}-linux-amd64.tar.gz",
      "    dest: /tmp",
      "    mode: 0755",
      "    force: yes ",
      ""
    ],
    "description": "ansible_common_modules_get_url1"
  },
  "ansible_common_modules_get_url2": {
    "prefix": "asb_get_url2",
    "body": [
      "- name: Download kubenetes packages kubeadm&kubelet",
      "  ansible.builtin.get_url:",
      "    url: \"{{ item }}\"",
      "    dest: /usr/local/bin",
      "    mode: 0755",
      "    force: yes #是否覆盖本地",
      "  with_items:",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubeadm }}/kubeadm",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubelet }}/kubelet",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubectl }}/kubectl"
    ],
    "description": "ansible_common_modules_get_url2"
  },
  "ansible_common_modules_mysql_db": {
    "prefix": "asb_mysql_db",
    "body": [
      "- name: 创建数据库",
      "  mysql_db:",
      "    name: \"{{mysql_db_name}}\"",
      "    state: present",
      "    collation: utf8mb4_unicode_ci",
      "    encoding: utf8mb4",
      "    login_host: \"{{mysql_host}}\"",
      "    login_port: \"{{mysql_port}}\"",
      "    login_user: root",
      "    login_password: \"{{mysql_root_password}}\"",
      "  run_once: true",
      "  delegate_to: backend1"
    ],
    "description": "ansible_common_modules_mysql_db"
  },
  "ansible_common_modules_mysql_user": {
    "prefix": "asb_mysql_user",
    "body": [
      "- name: 创建数据库用户",
      "  mysql_user:",
      "    name: \"{{mysql_user_name}}\"",
      "    host: \"%\"",
      "    password: \"{{ mysql_user_password }}\"",
      "    priv: \"{{mysql_db_name}}.*:ALL\"",
      "    state: present",
      "    login_host: \"{{mysql_host}}\"",
      "    login_port: \"{{mysql_port}}\"",
      "    login_user: root",
      "    login_password: \"{{mysql_root_password}}\"",
      "  run_once: true",
      "  delegate_to: backend1"
    ],
    "description": "ansible_common_modules_mysql_user"
  }
}
```

github 上的示例

- https://github.com/IronTooch/AnsibleSnippets-VSCode/tree/main
- https://github.com/stephrobert/ansible-snippets

参考文献：

- https://www.freecodecamp.org/chinese/news/definitive-guide-to-snippets-visual-studio-code/

使用 VsCode 中的代码片段快速输入常用代码

- https://shiblog.top/blog/22/
