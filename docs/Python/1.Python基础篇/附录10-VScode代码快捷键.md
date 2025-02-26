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
  "ansible_group_var_all_task1": {
    "prefix": "asb_group_var_all_task1",
    "body": [
      "ceph_origin: repository",
      "ceph_repository: community",
      "ceph_mirror: https://mirrors.aliyun.com/ceph/",
      "ceph_stable_release: nautilus",
      "ceph_stable_repo: \"{{ ceph_mirror }}/debian-{{ ceph_stable_release }}\"",
      "ceph_stable_distro_source: bionic",
      "public_network: 192.168.26.0/24",
      "",
      "monitor_interface: ens33",
      "configure_firewall: False",
      "osd_objectstore: bluestore",
      "devices:",
      "  - /dev/sdb",
    ],
    "description": "asb_group_var_all_task1",
  },
  "ansible_playbook_snippets_task1": {
    "prefix": "asb_playbook_snippets_task1",
    "body": [
      "---",
      "- hosts:  $1",
      "  gather_facts: false",
      "  become: true",
      "  any_errors_fatal: true",
      "  tasks:",
      "    - name: Install packages",
      "      yum:",
      "        name: \"{{ item }}\"",
      "        state: latest",
      "      loop:",
      "        - python3",
      "        - python3-pip",
      "        - python3-setuptools",
      "        - python3-wheel",
      "        - python3-devel",
      "        - gcc",
      "        - libffi-devel",
      "    ",
      "    - name: copy files",
      "      copy:",
      "        src: \"{{ item.src }}\"",
      "        dest: \"{{ item.dest }}\"",
      "      loop:",
      "        - { src: 'requirements.txt', dest: '/tmp/requirements.txt' }",
      "        - { src: 'main.py', dest: '/tmp/main.py' }",
      "    ",
      "    - name: exec shell",
      "      shell: \"pip3 install -r /tmp/requirements.txt\"",
      "  "
    ],
    "description": "ansible_playbook_snippets_task1"
  },
  "ansible_playbook_snippets_task2": {
    "prefix": "asb_playbook_snippets_task2",
    "body": [
      "---",
      "- hosts: $1",
      "  gather_facts: false",
      "  become: true",
      "  serial: 1  # 一般情况下, ansible 会同时在所有服务器上执行用户定义的操作，因此可以通过设置 serial 来控制并发执行的任务数。",
      "  any_errors_fatal: true",
      "  tasks:",
      "    - import_role:",
      "        name: ceph-defaults",
      "    - name: get ceph status from the first monitor",
      "      command: ceph --cluster {{ cluster }} -s",
      "      register: ceph_status",
      "      changed_when: false",
      "      delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "      run_once: true",
      "",
      "    - name: \"show ceph status for cluster {{ cluster }}\"",
      "      debug:",
      "        msg: \"{{ ceph_status.stdout_lines }}\"",
      "      delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "      run_once: true",
    ],
    "description": "asb_playbook_snippets_task2",
  },
  "ansible_playbook_snippets_task3": {
    "prefix": "asb_playbook_snippets_task3",
    "body": [
      "- name: Switching from non-containerized to containerized ceph mon",
      "  vars:",
      "    containerized_deployment: true",
      "    switch_to_containers: true",
      "    mon_group_name: mons",
      "  hosts: \"{{ mon_group_name|default(''mons'') }}\"",
      "  serial: 1",
      "  become: true",
      "  any_errors_fatal: true",
      "  pre_tasks:",
      "    - name: Select a running monitor",
      "      ansible.builtin.set_fact:",
      "        mon_host: \"{{ item }}\"",
      "      with_items: \"{{ groups[mon_group_name] }}\"",
      "      when: item != inventory_hostname",
      "",
      "    - name: Rename leveldb extension from ldb to sst",
      "      ansible.builtin.shell: rename -v .ldb .sst /var/lib/ceph/mon/*/store.db/*.ldb",
      "      changed_when: false",
      "      failed_when: false",
      "      when: ldb_files.rc == 0",
      "",
      "  tasks:",
      "    - name: Import ceph-handler role",
      "      ansible.builtin.import_role:",
      "        name: ceph-handler",
      "",
      "  post_tasks:",
      "    - name: Waiting for the monitor to join the quorum...",
      "      ansible.builtin.command: \"{{ container_binary }} run --rm  -v /etc/ceph:/etc/ceph:z --entrypoint=ceph {{ ceph_docker_registry }}/{{ ceph_docker_image }}:{{ ceph_docker_image_tag }} --cluster {{ cluster }} quorum_status --format json\"",
      "      register: ceph_health_raw",
      "      until: ansible_facts['hostname'] in (ceph_health_raw.stdout | trim | from_json)[\"quorum_names\"]",
      "      changed_when: false",
      "      retries: \"{{ health_mon_check_retries }}\"",
      "      delay: \"{{ health_mon_check_delay }}\"",
    ],
    "description": "asb_playbook_snippets_task3",
  },
  "ansible_include_role_task1": {
    "prefix": "asb_include_role_tsak1",
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
      "      shell: echo \"/bin/bash /usr/local/bin/serviceshost.sh\" >> /etc/rc.local && chmod +x /etc/rc.local && chmod +x /etc/rc.d/rc.local",
      "      become: yes",
      "      become_method: sudo",
    ],
    "description": "asb_include_role_tsak1",
  },
  "ansible_include_role_task2": {
    "prefix": "asb_include_role_tsak2",
    "body": [
      "---",
      "",
      "- include: redis.yml",
      "- include: db.yml",
      "- include: license-gitignore.yml",
    ],
    "description": "asb_include_role_tsak2",
  },
  "ansible_include_role_task3": {
    "prefix": "asb_include_role_tsak3",
    "body": [
      "---",
      "- hosts: mons",
      "  gather_facts: false",
      "",
      "  tasks:",
      "    - name: include common.yml",
      "      include_tasks: common.yml",
      "",
      "    - name: include facts.yml",
      "      include_tasks: facts.yml",
      "",
      "    - name: include config.yml",
      "      include_tasks: config.yml",
      "",
      "    - name: include mon.yml",
      "      include_tasks: mon.yml",
      "",
      "    - name: include mgr.yml",
      "      include_tasks: mgr.yml",
    ],
    "description": "asb_include_role_tsak3",
  },
  "ansible_add_task1": {
    "prefix": "asb_add_task1",
    "body": [
      "- name: $1",
      "  $2"
    ],
    "description": "asb_add_task1",
  },
  "ansible_set_fact_task1": {
    "prefix": "asb_set_fact_task1",
    "body": [
      "- name: set_fact fsid",
      "  set_fact:",
      "    fsid: \"{{ cluster_uuid.stdout }}\"",
      "  when: cluster_uuid.stdout is defined",
    ],
    "description": "ansible_set_fact_task1",
  },
  "ansible_set_fact_task2": {
    "prefix": "asb_set_fact_task2",
    "body": [
      "- name: set ntp service name depending on OS family",
      "  block:",
      "  - name: set ntp service name for Debian family",
      "    set_fact:",
      "      ntp_service_name: ntp",
      "    when: ansible_os_family == 'Debian'",
      "",
      "  - name: set ntp service name for Red Hat family",
      "    set_fact:",
      "      ntp_service_name: ntpd",
      "    when: ansible_os_family in ['RedHat', 'Suse']",
    ],
    "description": "asb_set_fact_task2",
  },
  "ansible_set_fact_task3": {
    "prefix": "asb_set_fact_task3",
    "body": [
      "- name: set_fact _monitor_address to monitor_interface - ipv4",
      "  set_fact:",
      "    monitor_addresses: \"{{ _monitor_addresses | default([]) + [{ ''name'': item, ''addr'': hostvars[item][''monitor_ipv4''] }] }}\"",
      "  with_items: \"{{ groups.get(mon_group_name, []) }}\"",
    ],
    "description": "asb_set_fact_task3",
  },
  "ansible_set_fact_task4": {
    "prefix": "asb_set_fact_task4",
    "body": [
      "- name: get ceph version",
      "  command: ceph --version",
      "  changed_when: false",
      "  check_mode: no",
      "  register: ceph_version",
      "",
      "- name: set_fact ceph_version",
      "  set_fact:",
      "    ceph_version: \"{{ ceph_version.stdout.split('' '')[2] }}\"",
    ],
    "description": "asb_set_fact_task4",
  },
  "ansible_common_modules_command_task1": {
    "prefix": "asb_common_modules_command_task1",
    "body": [
      "---",
      "- name: generate cluster fsid",
      "  command: \"/bin/python -c ''import uuid; print(str(uuid.uuid4()))''\"",
      "  #command: \"{{ hostvars[groups[mon_group_name][0]][''discovered_interpreter_python''] }} -c ''import uuid; print(str(uuid.uuid4()))''\"",
      "  register: cluster_uuid",
      "  delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true",
    ],
    "description": "asb_common_modules_command_task1",
  },
  "ansible_common_modules_command_task2": {
    "prefix": "asb_common_modules_command_task2",
    "body": [
      "- name: generate monitor initial keyring",
      "  command: >",
      "    {{ hostvars[groups[mon_group_name][0] if running_mon is undefined else running_mon][''discovered_interpreter_python''] }} -c \"import os ; import struct ;\"",
      "    import time; import base64 ; key = os.urandom(16) ;",
      "    header = struct.pack('<hiih',1,int(time.time()),0,len(key)) ;",
      "    print(base64.b64encode(header + key).decode())\"",
      "  register: monitor_keyring",
      "  run_once: True",
      "  delegate_to: \"{{ groups[mon_group_name][0] if running_mon is undefined else running_mon }}\"",
      "  when:",
      "    - initial_mon_key.skipped is defined",
      "    - ceph_current_status.fsid is undefined",
    ],
    "description": "asb_common_modules_command_task2",
  },
  "ansible_common_modules_shell_task1": {
    "prefix": "asb_common_modules_shell_task1",
    "body": [
      "- name: Configure timezone",
      "  shell: ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone",
      "",
    ],
    "description": "asb_common_modules_shell_task1",
  },
  "ansible_common_modules_shell_task2": {
    "prefix": "asb_common_modules_shell_task2",
    "body": [
      "- name: exec shell ",
      "  shell: echo \"Hello, World\" > /tmp/hello.txt",
      "  args:",
      "    chdir: /path/to/directory",
      "    creates: /path/to/somefile",
      "    #args 用于指定额外的参数：",
      "    #chdir: 指定命令执行的目录。",
      "    #creates: 如果指定的文件存在，则不执行命令。",
    ],
    "description": "asb_common_modules_shell_task2",
  },
  "ansible_common_modules_shell_task3": {
    "prefix": "asb_common_modules_shell_task3",
    "body": [
      "- name: get monitor ipv4 address",
      "  shell: \"cat /etc/hosts | grep {{ inventory_hostname }} | awk '{print \\$1}'\"",
      "  register: shell_out",
      "",
    ],
    "description": "asb_common_modules_shell_task3",
  },
  "ansible_common_modules_shell_task4": {
    "prefix": "asb_common_modules_shell_task4",
    "body": [
      "- name: control plane 初始化成功,添加用户连接集群配置",
      "  shell: mkdir -p \\$HOME/.kube && cp /etc/kubernetes/admin.conf \\${HOME}/.kube/config && chown \\$(id -u):\\$(id -g) \\$HOME/.kube/config",
      "  become: yes",
      "  when:",
      "    - opriation == \"create\"",
      "    - rc_result.rc == 0",
      "",
    ],
    "description": "asb_common_modules_shell_task4",
  },
  "ansible_common_modules_shell_task5": {
    "prefix": "asb_common_modules_shell_task5",
    "body": [
      "- name: 初始化数据库 1",
      "  shell: \"chdir=/app/gitee bundle exec rake db:migrate RAILS_ENV=production\"",
      "  run_once: true",
      "  delegate_to: backend1",
    ],
    "description": "asb_common_modules_shell_task5",
  },
  "ansible_common_modules_debug_task1": {
    "prefix": "asb_common_modules_debug_task1",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\"",
    ],
    "description": "asb_common_modules_debug_task1",
  },
  "ansible_common_modules_debug_task2": {
    "prefix": "asb_common_modules_debug_task2",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\"",
      "    delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true",
    ],
    "description": "asb_common_modules_debug_task2",
  },
  "ansible_common_modules_copy_task1": {
    "prefix": "asb_common_modules_copy_task1",
    "body": [
      "- name: Configure online sources",
      "  copy:",
      "    src: sources.list",
      "    dest: /etc/apt/",
      "    backup: yes",
    ],
    "description": "asb_common_modules_copy_task1",
  },
  "ansible_common_modules_copy_task2": {
    "prefix": "asb_common_modules_copy_task2",
    "body": [
      "- name: 优化用户所能打开的最大文件描述符数&加载ipvs模块&优化内核参数",
      "  copy:",
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
      "",
    ],
    "description": "asb_common_modules_copy_task2",
  },
  "ansible_common_modules_copy_task3": {
    "prefix": "asb_common_modules_copy_task3",
    "body": [
      "- name: Copy grafana SSL certificate file",
      "  copy:",
      "    src: \"{{ grafana_crt }}\"",
      "    dest: \"/etc/grafana/ceph-dashboard.crt\"",
      "    owner: \"{{ grafana_uid }}\"",
      "    group: \"{{ grafana_uid }}\"",
      "    mode: \"0640\"",
      "    remote_src: \"{{ dashboard_tls_external | bool }}\"",
      "  when:",
      "    - grafana_crt | length > 0",
      "    - dashboard_protocol == \"https\"",
    ],
    "description": "asb_common_modules_copy_task3",
  },
  "ansible_common_modules_template_task1": {
    "prefix": "asb_common_modules_template_task1",
    "body": [
      "- name: 配置 keepalived",
      "  template:",
      "    src: keepalived/frontend/keepalived.conf",
      "    dest: /etc/keepalived/keepalived.conf",
      "  become: yes",
      "  become_method: sudo",
    ],
    "description": "asb_common_modules_template_task1",
  },
  "ansible_common_modules_template_task2": {
    "prefix": "asb_common_modules_template_task2",
    "body": [
      "- name: Write datasources provisioning config file",
      "  template:",
      "    src: datasources-ceph-dashboard.yml.j2",
      "    dest: /etc/grafana/provisioning/datasources/ceph-dashboard.yml",
      "    owner: \"{{ grafana_uid }}\"",
      "    group: \"{{ grafana_uid }}\"",
      "    mode: \"0640\"",
      "    become: yes",
      "    notify:",
      "      - Restart ceph mdss"
    ],
    "description": "asb_common_modules_template_task2"
  },
  "ansible_common_modules_template_task3": {
    "prefix": "asb_common_modules_template_task3",
    "body": [
      "- name: 复制启动脚本",
      "  template:",
      "    src: \"keepalived/frontend/{{item}}\"",
      "    dest: \"/usr/local/bin/{{item}}\"",
      "    mode: \"0755\"",
      "  with_items:",
      "    - frontendhost.sh",
      "    - check_server.sh",
      "  become: yes",
      "  become_method: sudo",
    ],
    "description": "asb_common_modules_template_task3",
  },
  "ansible_common_modules_unarchive_task1": {
    "prefix": "asb_common_modules_unarchive_task1",
    "body": [
      "- name: Unarchive containerd-{{ containerd_version }}-linux-amd64.tar.gz",
      "  unarchive:",
      "    src: /tmp/containerd-{{ containerd_version }}-linux-amd64.tar.gz",
      "    dest: /usr/local",
      "    copy: no",
      "  when:",
      "    - containerd_version is defined",
      "    - containerd_version != \"\"",
    ],
    "description": "asb_common_modules_unarchive_task1",
  },
  "ansible_common_modules_apt_tsak1": {
    "prefix": "asb_common_modules_apt_tsak1",
    "body": [
      "- name: Install required packages",
      "  apt:",
      "    name: \"{{item}}\"",
      "    state: present",
      "    update_cache: yes",
      "  become: yes",
      "  become_method: sudo",
      "  with_items:",
      "    - apt-transport-https",
      "    - ca-certificates",
      "    - curl",
      ""
    ],
    "description": "asb_common_modules_apt_tsak1"
  },
  "ansible_common_modules_yum_tsak1": {
    "prefix": "asb_common_modules_yum_tsak1",
    "body": [
      "- name: yum install require packages",
      "  yum:",
      "    name: \"{{ require_packages }}\"",
      "  vars:",
      "    require_packages:",
      "      - libselinux-python",
      "      - ceph-common",
      "      - ceph-mon",
      "      - ceph-mgr",
      "  become: true",
    ],
    "description": "asb_common_modules_yum_tsak1",
  },
  "ansible_common_modules_package_tsak1": {
    "prefix": "asb_common_modules_package_tsak1",
    "body": [
      "- name: install redhat ceph packages",
      "  package:",
      "    name: \"{{ redhat_ceph_pkgs | unique }}\"",
      "    state: \"{{ (upgrade_ceph_packages|bool) | ternary(''latest'',''present'') }}\"",
      "  register: result",
      "  until: result is succeeded",
    ],
    "description": "asb_common_modules_package_tsak1",
  },
  "ansible_common_modules_package_tsak2": {
    "prefix": "asb_common_modules_package_tsak2",
    "body": [
      "- name: install redhat dependencies",
      "  package:",
      "    name: \"{{ redhat_package_dependencies }}\"",
      "    state: present",
      "  register: result",
      "  until: result is succeeded",
      "  when: ansible_distribution == 'RedHat'",
    ],
    "description": "ansible_apb_task_package1",
  },
  "ansible_common_modules_cron_tsak1": {
    "prefix": "asb_common_modules_cron_tsak1",
    "body": [
      "- name: Configure crontab Time sync",
      "  cron:",
      "    name: \"Cron time sync\"",
      "    minute: \"*/5\"",
      "    job: /usr/sbin/ntpdate {{ ntp_server }} &>/dev/null",
      "  when: ntp_server is defined",
      "  become: yes",
    ],
    "description": "asb_common_modules_cron_tsak1",
  },
  "ansible_common_modules_user_task1": {
    "prefix": "asb_common_modules_user_task1",
    "body": [
      "- name: add git user",
      "  user:",
      "    name: git",
      "    password: \"{{ item | password_hash(''sha512'') }}\"",
      "    groups:",
      "      - wheel",
      "    append: yes",
      "    state: present",
      "  with_items:",
      "    - \"admin#123\"",
      "  become: yes",
      "  become_method: sudo",
    ],
    "description": "asb_common_modules_user_task1",
  },
  "ansible_common_modules_file_task1": {
    "prefix": "asb_common_modules_file_task1",
    "body": [
      "- name: Create /etc/containerd",
      "  file:",
      "    path: /etc/containerd",
      "    state: directory",
      "",
    ],
    "description": "asb_common_modules_file_task1",
  },
  "ansible_common_modules_file_task2": {
    "prefix": "asb_common_modules_file_task2",
    "body": [
      "# 创建Ceph配置目录",
      "- name: create ceph conf directory",
      "  file:",
      "   path: \"/etc/ceph\"",
      "   state: directory",
      "   owner: \"ceph\"",
      "   group: \"ceph\"",
      "   mode: \"{{ ceph_directories_mode | default(''0755'') }}\"",
    ],
    "description": "asb_common_modules_file_task2",
  },
  "ansible_common_modules_file_task3": {
    "prefix": "asb_common_modules_file_task3",
    "body": [
      "- name: ensure systemd service override directory exists",
      "  file:",
      "    state: directory",
      "    path: \"/etc/systemd/system/ceph-mon@.service.d/\"",
      "  when:",
      "    - not containerized_deployment | bool",
      "    # 默认ceph_mon_systemd_overrides没有设置，所以该任务不会执行",
      "    - ceph_mon_systemd_overrides is defined",
      "    - ansible_service_mgr == 'systemd'",
    ],
    "description": "asb_common_modules_file_task3",
  },
  "ansible_common_modules_file_task4": {
    "prefix": "asb_common_modules_file_task4",
    "body": [
      "- name: 建立软链接 archive",
      "  file:",
      "    src: /data/archive",
      "    dest: /app/gitee/tmp/repositories",
      "    state: link",
    ],
    "description": "asb_common_modules_file_task4",
  },
  "ansible_common_modules_file_task5": {
    "prefix": "asb_common_modules_file_task5",
    "body": [
      "- name: 修改 production.log 权限",
      "  file:",
      "    path: /app/gitee/log/production.log",
      "    state: touch",
      "    mode: \"0666\"",
      "    owner: \"root\"",
      "    group: \"root\"",
    ],
    "description": "asb_common_modules_file_task5",
  },
  "ansible_common_modules_service_task1": {
    "prefix": "asb_common_modules_service_task1",
    "body": [
      "- name: Start kubelet",
      "   service:",
      "    name: kubelet.service",
      "    state: started",
      "    enabled: yes",
    ],
    "description": "asb_common_modules_service_task1",
  },
  "ansible_common_modules_system_task1": {
    "prefix": "asb_common_modules_system_task1",
    "body": [
      "- name: start the monitor service",
      "  systemd:",
      "    name: ceph-mon@{{ inventory_hostname }}",
      "    state: started",
      "    enabled: yes",
      "    masked: no",
      "    daemon_reload: yes",
    ],
    "description": "asb_common_modules_system_task1",
  },
  "ansible_common_modules_system_task2": {
    "prefix": "asb_common_modules_system_task2",
    "body": [
      "- name: Start containerd.service",
      "  systemd:",
      "    name: containerd.service",
      "    state: started",
      "    daemon_reload: yes",
      "    enabled: yes",
    ],
    "description": "asb_common_modules_system_task2",
  },
  "ansible_common_modules_get_url_task1": {
    "prefix": "asb_common_modules_get_url_task1",
    "body": [
      "- name: Download kubenetes packages crictl",
      "  get_url:",
      "    url: http://{{ download_address }}/kubeadm-install/{{ crictl }}/crictl-v{{ crictl }}-linux-amd64.tar.gz",
      "    dest: /tmp",
      "    mode: 0755",
      "    force: yes ",
      "",
    ],
    "description": "asb_common_modules_get_url_task1",
  },
  "ansible_common_modules_get_url_task2": {
    "prefix": "asb_common_modules_get_url_task2",
    "body": [
      "- name: Download kubenetes packages kubeadm&kubelet",
      "  get_url:",
      "    url: \"{{ item }}\"",
      "    dest: /usr/local/bin",
      "    mode: 0755",
      "    force: yes #是否覆盖本地",
      "  with_items:",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubeadm }}/kubeadm",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubelet }}/kubelet",
      "    - http://{{ download_address }}/kubeadm-install/{{ kubectl }}/kubectl",
    ],
    "description": "asb_common_modules_get_url_task2",
  },
  "ansible_common_modules_synchronize_task1": {
    "prefix": "asb_common_modules_synchronize_task1",
    "body": [
      "- name: Synchronization of src on the inventory host to the dest on the localhost in pull mode",
      "  synchronize:",
      "    mode: pull",
      "    src: some/relative/path",
      "    dest: /some/absolute/path"
    ],
    "description": "asb_common_modules_synchronize_task1"
  },
  "ansible_common_modules_synchronize_task2": {
    "prefix": "asb_common_modules_synchronize_task2",
    "body": [
      "- name: Synchronization of src on delegate host to dest on the current inventory host.",
      "  ansible.posix.synchronize:",
      "    src: /first/absolute/path",
      "    dest: /second/absolute/path",
      "  delegate_to: delegate.host"
    ],
    "description": "asb_common_modules_synchronize_task2"
  },
  "ansible_modules_mysql_db_task1": {
    "prefix": "asb_modules_mysql_db_task1",
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
      "  delegate_to: backend1",
    ],
    "description": "asb_modules_mysql_db_task1",
  },
  "ansible_modules_mysql_user_task1": {
    "prefix": "asb_modules_mysql_user_task1",
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
      "  delegate_to: backend1",
    ],
    "description": "asb_modules_mysql_user_task1",
  },
  "ansible_when_task1": {
    "prefix": "asb_when_task1",
    "body": [
      "- name: include_tasks ceph_keys.yml",
      "  include_tasks: ceph_keys.yml",
      "  when: not switch_to_containers | default(False) | bool",
      "",
      "- name: include secure_cluster.yml",
      "  include_tasks: secure_cluster.yml",
      "  when:",
      "    - secure_cluster | bool",
      "    - inventory_hostname == groups[mon_group_name] | first",
    ],
    "description": "asb_when_task1",
  },
  "ansible_when_task2": {
    "prefix": "asb_when_task2",
    "body": [
      "- name: include configure_memory_allocator.yml",
      "  include_tasks: configure_memory_allocator.yml",
      "  when:",
      "    - (ceph_tcmalloc_max_total_thread_cache | int) > 0",
      "    - osd_objectstore == 'filestore'",
      "    - (ceph_origin == 'repository' or ceph_origin == 'distro')",
    ],
    "description": "asb_when_task2",
  },
  "ansible_when_task3": {
    "prefix": "asb_when_task3",
    "body": [
      "- name: include release-rhcs.yml",
      "  include_tasks: release-rhcs.yml",
      "  when: ceph_repository in ['rhcs', 'dev'] or ceph_origin == 'distro'",
      "  tags: always",
    ],
    "description": "asb_when_task3",
  },
  "ansible_common_modules_lineinfile_task1": {
    "prefix": "asb_common_modules_lineinfile_task1",
    "body": [
      "- name: Ensure the default Apache port is 8080",
      "  lineinfile:",
      "    path: /etc/httpd/conf/httpd.conf",
      "    regexp: '^Listen '",
      "    insertafter: '^#Listen '",
      "    line: Listen 8080"
    ],
    "description": "asb_common_modules_lineinfile_task1"
  },
  "ansible_common_modules_lineinfile_task2": {
    "prefix": "asb_common_modules_lineinfile_task2",
    "body": [
      "- name: Ensure we have our own comment added to /etc/services",
      "  lineinfile:",
      "    path: /etc/services",
      "    regexp: '^# port for http'",
      "    insertbefore: '^www.*80/tcp'",
      "    line: '# port for http by default'"
    ],
    "description": "asb_common_modules_lineinfile_task2"
  },
  "ansible_common_modules_tempfile_task1": {
    "prefix": "asb_common_modules_tempfile_task1",
    "body": [
      "- name: Create a temporary file with a specific prefix",
      "  tempfile:",
      "     state: file",
      "     suffix: txt",
      "     prefix: myfile_"
    ],
    "description": "asb_common_modules_tempfile_task1"
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
