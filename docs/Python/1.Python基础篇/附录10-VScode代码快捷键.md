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
  "ansible_apb_group_vars_all": {
    "prefix": "apbgvall",
    "body": [
      "ceph_origin: repository",
      "ceph_repository: community",
      "ceph_mirror: https://mirrors.aliyun.com/ceph/",
      "ceph_stable_key: \"{{ ceph_mirror }}/keys/release.asc\"",
      "ceph_stable_release: nautilus",
      "ceph_stable_repo: \"{{ ceph_mirror }}/debian-{{ ceph_stable_release }}\"",
      "ceph_stable_distro_source: bionic",
      "",
      "cephx: \"true\"",
      "",
      "public_network: 192.168.26.0/24",
      "cluster_network: 192.168.26.0/24",
      "",
      "monitor_interface: ens33",
      "radosgw_interface: ens33",
      "configure_firewall: False",
      "osd_objectstore: bluestore",
      "devices:",
      "  - /dev/sdb",
      "",
      "osd_pool_default_pg_num: 128",
      "dashboard_enabled: False"
    ],
    "description": "ansible_apb_group_vars_all"
  },
  "ansible_apb1": {
    "prefix": "apb1",
    "body": [
      "---",
      "- hosts: $1",
      "  gather_facts: false",
      "  become: true",
      "  any_errors_fatal: true",
      "  tasks:",
      "    - name: $2",
      "      $3"
    ],
    "description": "Ansible playbook_snippet1"
  },
  "ansible_apb2": {
    "prefix": "apb2",
    "body": [
      "---",
      "- hosts: mons",
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
      "      run_once: true"
    ],
    "description": "ansible_apb2"
  },
  "ansible_apb3": {
    "prefix": "apb3",
    "body": [
      "- name: Switching from non-containerized to containerized ceph mon",
      "  vars:",
      "    containerized_deployment: true",
      "    switch_to_containers: true",
      "    mon_group_name: mons",
      "  hosts: \"{{ mon_group_name|default('mons') }}\"",
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
      "      delay: \"{{ health_mon_check_delay }}\""
    ],
    "description": "ansible_apb3"
  },
  "ansible_apb_host1": {
    "prefix": "apb_host1",
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
      "      include_tasks: mgr.yml"
    ],
    "description": "ansible_apb_host1"
  },
  "ansible_apb_task": {
    "prefix": "at",
    "body": ["- name: $1", "  $2"],
    "description": "ansible_apb_task"
  },
  "ansible_apb_task_set_fact1": {
    "prefix": "atset_fact1",
    "body": [
      "- name: set_fact fsid",
      "  set_fact:",
      "     fsid: \"{{ cluster_uuid.stdout }}\""
    ],
    "description": "ansible_apb_task_set_fact1"
  },
  "ansible_apb_task_set_fact2": {
    "prefix": "atset_fact2",
    "body": [
      "- name: set_fact monitor_ipv4",
      "  set_fact:",
      "    monitor_ipv4: \"{{ shell_out.stdout }}\""
    ],
    "description": "ansible_apb_task_set_fact2"
  },
  "ansible_apb_task_set_fact3": {
    "prefix": "atset_fact3",
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
      "    when: ansible_os_family in ['RedHat', 'Suse']"
    ],
    "description": "ansible_apb_task_set_fact3"
  },
  "ansible_apb_task_set_fact4": {
    "prefix": "atset_fact4",
    "body": [
      "- name: set_fact _monitor_address to monitor_interface - ipv4",
      "  set_fact:",
      "    _monitor_addresses: \"{{ _monitor_addresses | default([]) + [{ 'name': item, 'addr': hostvars[item]['monitor_ipv4'] }] }}\"",
      "  with_items: \"{{ groups.get(mon_group_name, []) }}\""
    ],
    "description": "ansible_apb_task_set_fact4"
  },
  "ansible_apb_task_set_fact5": {
    "prefix": "atset_fact5",
    "body": [
      "- name: get ceph version",
      "  command: ceph --version",
      "  changed_when: false",
      "  check_mode: no",
      "  register: ceph_version",
      "",
      "- name: set_fact ceph_version",
      "  set_fact:",
      "    ceph_version: \"{{ ceph_version.stdout.split(' ')[2] }}\""
    ],
    "description": "ansible_apb_task_set_fact5"
  },
  "ansible_apb_task_command1": {
    "prefix": "atc1",
    "body": ["- name: $1", "  command: $2"],
    "description": "ansible_apb_task_command1"
  },
  "ansible_apb_task_command2": {
    "prefix": "atc2",
    "body": [
      "---",
      "- name: generate cluster fsid",
      "  command: \"/bin/python -c 'import uuid; print(str(uuid.uuid4()))'\"",
      "  register: cluster_uuid",
      "  delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true"
    ],
    "description": "ansible_apb_task_command2"
  },
  "ansible_apb_task_command3": {
    "prefix": "atc3",
    "body": [
      "- name: generate cluster fsid",
      "  command: \"{{ hostvars[groups[mon_group_name][0]]['discovered_interpreter_python'] }} -c 'import uuid; print(str(uuid.uuid4()))'\"",
      "  register: cluster_uuid",
      "  delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true"
    ],
    "description": "ansible_apb_task_command3"
  },
  "ansible_apb_task_command4": {
    "prefix": "atc4",
    "body": [
      "- name: generate monitor initial keyring",
      "  command: >",
      "    {{ hostvars[groups[mon_group_name][0] if running_mon is undefined else running_mon]['discovered_interpreter_python'] }} -c \"import os ; import struct ;",
      "    import time; import base64 ; key = os.urandom(16) ;",
      "    header = struct.pack('<hiih',1,int(time.time()),0,len(key)) ;",
      "    print(base64.b64encode(header + key).decode())\"",
      "  register: monitor_keyring",
      "  run_once: True",
      "  delegate_to: \"{{ groups[mon_group_name][0] if running_mon is undefined else running_mon }}\"",
      "  when:",
      "    - initial_mon_key.skipped is defined",
      "    - ceph_current_status.fsid is undefined"
    ],
    "description": "ansible_apb_task_command4"
  },
  "ansible_apb_task_shell1": {
    "prefix": "ats1",
    "body": ["- name: $1", "  shell: $2"],
    "description": "ansible_apb_task_shell1"
  },
  "ansible_apb_task_shell2": {
    "prefix": "ats2",
    "body": [
      "- name: exec shell ",
      "  shell: echo \"Hello, World\" > /tmp/hello.txt",
      "  args:",
      "    chdir: /path/to/directory",
      "    creates: /path/to/somefile",
      "    #args 用于指定额外的参数：",
      "    #chdir: 指定命令执行的目录。",
      "    #creates: 如果指定的文件存在，则不执行命令。"
    ],
    "description": "ansible_apb_task_shell2"
  },
  "ansible_apb_task_shell3": {
    "prefix": "ats3",
    "body": [
      "- name: get monitor ipv4 address",
      "  shell: \"cat /etc/hosts | grep {{ inventory_hostname }} | awk '{print \\$1}'\"",
      "  register: shell_out",
      ""
    ],
    "description": "ansible_apb_task_shell3"
  },
  "ansible_apb_task_copy1": {
    "prefix": "atcp1",
    "body": ["- name: $1", "  copy:", "    src: $2", "    dest: $3"],
    "description": "ansible_apb_task_copy1"
  },
  "ansible_apb_task_copy2": {
    "prefix": "atcp2",
    "body": [
      "- name: copy repo files to all hosts",
      "  copy:",
      "    src: \"{{ item }}\"",
      "    dest: \"/etc/yum.repos.d/{{ item }}\"",
      "  with_items:",
      "    - \"CentOS-Base.repo\"",
      "    - \"ceph.repo\"",
      "  become: true"
    ],
    "description": "ansible_apb_task_copy2"
  },
  "ansible_apb_task_copy3": {
    "prefix": "atcp3",
    "body": [
      "- name: Tmp copy the prometheus data",
      "  copy:",
      "    src: '{{ prometheus_data_dir }}/'",
      "    dest: /var/lib/prom_metrics",
      "    owner: 65534",
      "    group: 65534",
      "    mode: preserve",
      "    remote_src: true"
    ],
    "description": "ansible_apb_task_copy3"
  },
  "ansible_apb_task_copy4": {
    "prefix": "atcp4",
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
      "    - dashboard_protocol == \"https\""
    ],
    "description": "ansible_apb_task_copy4"
  },
  "ansible_apb_task_template1": {
    "prefix": "att1",
    "body": ["- name: $1", "  template:", "    src: $2", "    dest: $3"],
    "description": "ansible_apb_task_template1"
  },
  "ansible_apb_task_template2": {
    "prefix": "att2",
    "body": [
      "- name: Write datasources provisioning config file",
      "  template:",
      "    src: datasources-ceph-dashboard.yml.j2",
      "    dest: /etc/grafana/provisioning/datasources/ceph-dashboard.yml",
      "    owner: \"{{ grafana_uid }}\"",
      "    group: \"{{ grafana_uid }}\"",
      "    mode: \"0640\"",
      ""
    ],
    "description": "ansible_apb_task_template2"
  },
  "ansible_apb_task_template3": {
    "prefix": "att3",
    "body": [
      "- name: Generate systemd unit file",
      "  ansible.builtin.template:",
      "    src: \"{{ role_path }}/templates/ceph-mds.service.j2\"",
      "    dest: /etc/systemd/system/ceph-mds@.service",
      "    owner: \"root\"",
      "    group: \"root\"",
      "    mode: \"0644\"",
      "  notify: Restart ceph mdss"
    ],
    "description": "ansible_apb_task_template3"
  },
  "ansible_apb_task_when1": {
    "prefix": "atw1",
    "body": [
      "- name: include_tasks installs/install_on_redhat.yml",
      "  include_tasks: installs/install_on_redhat.yml",
      "  when: ansible_os_family == 'RedHat'",
      "  tags: package-install"
    ],
    "description": "ansible_apb_task_when1"
  },
  "ansible_apb_task_when2": {
    "prefix": "atw2",
    "body": [
      "- name: include release-rhcs.yml",
      "  include_tasks: release-rhcs.yml",
      "  when: ceph_repository in ['rhcs', 'dev'] or ceph_origin == 'distro'",
      "  tags: always"
    ],
    "description": "ansible_apb_task_when2"
  },
  "ansible_apb_task_when3": {
    "prefix": "atw3",
    "body": [
      "- name: include configure_memory_allocator.yml",
      "  include_tasks: configure_memory_allocator.yml",
      "  when:",
      "    - (ceph_tcmalloc_max_total_thread_cache | int) > 0",
      "    - osd_objectstore == 'filestore'",
      "    - (ceph_origin == 'repository' or ceph_origin == 'distro')"
    ],
    "description": "ansible_apb_task_when3"
  },
  "ansible_apb_task_when4": {
    "prefix": "atw4",
    "body": [
      "- name: include_tasks ceph_keys.yml",
      "  include_tasks: ceph_keys.yml",
      "  when: not switch_to_containers | default(False) | bool",
      "",
      "- name: include secure_cluster.yml",
      "  include_tasks: secure_cluster.yml",
      "  when:",
      "    - secure_cluster | bool",
      "    - inventory_hostname == groups[mon_group_name] | first"
    ],
    "description": "ansible_apb_task_when4"
  },
  "ansible_apb_task_debug1": {
    "prefix": "atdebug1",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\""
    ],
    "description": "ansible_apb_task_debug1"
  },
  "ansible_apb_task_debug2": {
    "prefix": "atdebug2",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\"",
      "  delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true"
    ],
    "description": "ansible_apb_task_debug2"
  },
  "ansible_apb_task_package1": {
    "prefix": "atpackage1",
    "body": [
      "- name: install redhat dependencies",
      "  package:",
      "    name: \"{{ redhat_package_dependencies }}\"",
      "    state: present",
      "  register: result",
      "  until: result is succeeded",
      "  when: ansible_distribution == 'RedHat'"
    ],
    "description": "ansible_apb_task_package1"
  },
  "ansible_apb_task_package2": {
    "prefix": "atpackage2",
    "body": [
      "- name: install redhat ceph packages",
      "  package:",
      "    name: \"{{ redhat_ceph_pkgs | unique }}\"",
      "    state: \"{{ (upgrade_ceph_packages|bool) | ternary('latest','present') }}\"",
      "  register: result",
      "  until: result is succeeded"
    ],
    "description": "ansible_apb_task_package2"
  },
  "ansible_apb_task_yum1": {
    "prefix": "atyum1",
    "body": [
      "- name: install centos dependencies",
      "  yum:",
      "    name: \"{{ centos_package_dependencies }}\"",
      "    state: present",
      "  register: result",
      "  until: result is succeeded",
      "  when: ansible_distribution == 'CentOS'"
    ],
    "description": "ansible_apb_task_yum1"
  },
  "ansible_apb_task_yum2": {
    "prefix": "atyum2",
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
      "  become: true"
    ],
    "description": "ansible_apb_task_yum2"
  },
  "ansible_apb_task_file1": {
    "prefix": "atfile1",
    "body": [
      "- name: create ceph conf directory",
      "  file:",
      "    path: \"/etc/ceph\"",
      "    state: directory",
      "    owner: \"ceph\"",
      "    group: \"ceph\"",
      "    mode: \"{{ ceph_directories_mode | default('0755') }}\""
    ],
    "description": "ansible_apb_task_file1"
  },
  "ansible_apb_task_file2": {
    "prefix": "atfile2",
    "body": [
      "- name: create (and fix ownership of) monitor directory",
      "  file:",
      "    path: /var/lib/ceph/mon/{{ cluster }}-{{ monitor_name }}",
      "    state: directory",
      "    owner: \"{{ ceph_uid if containerized_deployment else 'ceph' }}\"",
      "    group: \"{{ ceph_uid if containerized_deployment else 'ceph' }}\"",
      "    mode: \"{{ ceph_directories_mode | default('0755') }}\"",
      "    recurse: true"
    ],
    "description": "ansible_apb_task_file2"
  },
  "ansible_apb_task_file3": {
    "prefix": "atfile3",
    "body": [
      "- name: ensure systemd service override directory exists",
      "  file:",
      "    state: directory",
      "    path: \"/etc/systemd/system/ceph-mon@.service.d/\"",
      "  when:",
      "    - not containerized_deployment | bool",
      "    - ceph_mon_systemd_overrides is defined",
      "    - ansible_service_mgr == 'systemd'"
    ],
    "description": "ansible_apb_task_file3"
  },
  "ansible_apb_task_system1": {
    "prefix": "atsystem1",
    "body": [
      "- name: start the monitor service",
      "  systemd:",
      "    name: ceph-mon@{{ inventory_hostname }}",
      "    state: started",
      "    enabled: yes",
      "    masked: no",
      "    daemon_reload: yes"
    ],
    "description": "ansible_apb_task_system1"
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
