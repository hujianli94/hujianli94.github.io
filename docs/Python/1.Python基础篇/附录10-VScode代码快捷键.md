# 附录 10-VScode 代码快捷键

## VS Code 代码片段完全入门指南

如果你更喜欢使用 GUI 界面来编写代码片段，你可以尝试以下 [snippet generator web app](https://snippet-generator.app/?description=&tabtrigger=&snippet=&mode=vscode)。

## Shell snippet

创建自定义代码片段

- 同样按下 Ctrl+Shift+P（或 Cmd+Shift+P 在 Mac 上）打开命令面板。

- 输入 “Configure User Snippets” 并选择 “Shell” 选项，这将打开一个名为 shell.json 的文件。

```json
{
  // 创建 shebang
  "shebang": {
    "prefix": "shebang",
    "body": [
      "#!/bin/bash",
      "# ${1:filename}: ",
      "# ${2:description}: ",
      "# ${3:author}: ",
      "# ${4:version}: "
    ],
    "description": "Shebang"
  },
  // 获取当前时间
  "Get current time": {
    "prefix": "gettime",
    "body": ["TIME=\"$(date +%Y-%m-%d_%H:%M:%S)\"", "echo $TIME"],
    "description": "Get the current time"
  },
  // 获取脚本目录
  "get script directory": {
    "prefix": "getscriptdir",
    "body": [
      "SCRIPT_DIR=\"$( cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd )\"",
      "echo $SCRIPT_DIR"
    ],
    "description": "get the directory of the script"
  },
  // 创建临时目录
  "Create temporary directory": {
    "prefix": "mktempdir",
    "body": ["TMP_DIR=\"$(mktemp -d)\"", "echo $TMP_DIR"],
    "description": "Create a temporary directory"
  },
  // 创建临时文件
  "Create temporary file": {
    "prefix": "mktempfile",
    "body": ["TMP_FILE=\"$(mktemp)\"", "echo $TMP_FILE"],
    "description": "Create a temporary file"
  },
  // 创建随机字符串
  "Create random string": {
    "prefix": "randstr",
    "body": ["RAND_STR=\"$(openssl rand -hex ${1:16})\"", "echo $RAND_STR"],
    "description": "Create a random string"
  },
  // 创建目录并进入
  "Create and enter directory": {
    "prefix": "mkcd",
    "body": ["mkdir -p ${1:directory_name}", "cd ${1}"],
    "description": "Create a directory and enter it"
  },
  // 创建文件并写入内容
  "Create file and write content": {
    "prefix": "cat",
    "body": ["cat <<-EOF ${1:>/path/to/file}", "\t$2", "EOF"],
    "description": "cat... EOF"
  },
  // 打印变量
  "Print variable": {
    "prefix": "pv",
    "body": ["echo \"${1:variable_name}=${!1}\""],
    "description": "Print a variable with its value"
  },
  // 打印变量带双引号
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
  // 字符串拼接
  "String concatenation": {
    "prefix": "strcat",
    "body": [
      "${1:new_string}=${2:original_string}${3:additional_string}",
      "echo \"${1}\""
    ],
    "description": "Concatenate two strings"
  },
  // 字符串长度
  "String length": {
    "prefix": "strlen",
    "body": ["${1:variable_name}=${#${2:original_string}}", "echo \"${1}\""],
    "description": "Get the length of a string"
  },
  // 字符串分割
  "String split": {
    "prefix": "strsplit",
    "body": [
      "IFS='${1:delimiter}' read -ra ${2:array_name} <<< \"${3:original_string}\"",
      "for item in \"${${2}[@]}\"",
      "do",
      "    echo \"$item\"",
      "done"
    ],
    "description": "Split a string into an array"
  },
  // 字符串转小写
  "String to lowercase": {
    "prefix": "strtolower",
    "body": ["${1:new_string}=${2:original_string,,}", "echo \"${1}\""],
    "description": "Convert a string to lowercase"
  },
  // 字符串转大写
  "String to uppercase": {
    "prefix": "strtoupper",
    "body": ["${1:new_string}=${2:original_string^^}", "echo \"${1}\""],
    "description": "Convert a string to uppercase"
  },
  // 字符串去空格
  "String trim": {
    "prefix": "strtrim",
    "body": [
      "${1:new_string}=${2:original_string}",
      "${1:new_string}=${1// /}",
      "echo \"${1}\""
    ],
    "description": "Trim whitespace from a string"
  },
  // 字符串反转
  "String reverse": {
    "prefix": "strrev",
    "body": [
      "${1:new_string}=${2:original_string}",
      "${1:new_string}=${1: -1:1}${1:0:-1}",
      "echo \"${1}\""
    ],
    "description": "Reverse a string"
  },
  // 字符串转为数组
  "String to array": {
    "prefix": "strtoarray",
    "body": [
      "IFS='${1:delimiter}' read -ra ${2:array_name} <<< \"${3:original_string}\"",
      "for item in \"${${2}[@]}\"",
      "do",
      "    echo \"$item\"",
      "done"
    ],
    "description": "Convert a string to an array"
  },
  // 检查字符串是否包含子串
  "check if a string contains a substring": {
    "prefix": "ifsubstring",
    "body": ["if [[ ${1:string} == *${2:substring}* ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string contains a substring"
  },
  // 检查字符串是否相等
  "check if a string is equal to another string": {
    "prefix": "ifequal",
    "body": ["if [[ ${1:string} == ${2:other_string} ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is equal to another string"
  },
  // 检查字符串是否为空
  "check if a string is empty": {
    "prefix": "ifempty",
    "body": ["if [[ -z ${1:string} ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is empty"
  },
  // 检查字符串是否为数字
  "check if a string is a number": {
    "prefix": "ifnumber",
    "body": ["if [[ ${1:string} =~ ^[0-9]+$ ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is a number"
  },
  // 检查字符串是否为字母
  "check if a string is a letter": {
    "prefix": "ifletter",
    "body": ["if [[ ${1:string} =~ ^[a-zA-Z]+$ ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is a letter"
  },
  // 检查字符串是否为字母或数字
  "check if a string is a letter or number": {
    "prefix": "ifletterornumber",
    "body": ["if [[ ${1:string} =~ ^[a-zA-Z0-9]+$ ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is a letter or number"
  },
  // 检查字符串是否为字母或数字或下划线
  "check if a string is a letter, number, or underscore": {
    "prefix": "ifletterornumberorunderscore",
    "body": ["if [[ ${1:string} =~ ^[a-zA-Z0-9_]+$ ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string is a letter, number, or underscore"
  },
  // 检查字符串 是否以某个前缀开头
  "check if a string starts with a prefix": {
    "prefix": "ifstartswith",
    "body": ["if [[ ${1:string} == ${2:prefix}* ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string starts with a prefix"
  },
  // 检查字符串 是否以某个后缀结尾
  "check if a string ends with a suffix": {
    "prefix": "ifendswith",
    "body": ["if [[ ${1:string} == *${2:suffix} ]]; then", "\t$0", "fi"],
    "description": "if statement for checking if a string ends with a suffix"
  },
  // 检查是否有命令
  "check if a command exists": {
    "prefix": "chkcmd",
    "body": [
      "if command -v ${1:command_name} >/dev/null 2>&1; then",
      "    echo \"Command exists.\"",
      "else",
      "    echo \"Command does not exist.\"",
      "fi"
    ],
    "description": "check if a command exists"
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
  "while read < file": {
    "prefix": "while_read_file",
    "body": [
      "while read -r line; do",
      "\techo \"\\$line\"",
      "done < ${1:/path/to/file}"
    ],
    "description": "While loop to read file"
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
  },
  // 函数带参数
  "function with parameters": {
    "prefix": "fnparam",
    "body": [
      "function ${1:function_name}() {",
      "\tlocal ${2:param1}=${3:-default_value}",
      "\tlocal ${4:param2}=${5:-default_value}",
      "\t$0",
      "}"
    ],
    "description": "function with parameters and default values"
  },
  // 初始化git仓库
  "Create and enter directory with git init": {
    "prefix": "mkcdgit",
    "body": ["mkdir -p ${1:directory_name}", "cd ${1}", "git init"],
    "description": "Create a directory, enter it, and initialize a git repository"
  },
  // 创建git仓库并创建README.md
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
  // 简单的while getopts
  "Getopts simple": {
    "prefix": "getopts",
    "body": [
      "while getopts :${1:?}h arg",
      "do",
      "\tcase \\$arg in",
      "\t\t${1})",
      "\t\t\t${0:: #statements}",
      "\t\t\t;;",
      "\t\t:|?|h)",
      "\t\t\t[[ \\$arg == \\? ]] && print_error \"L'option -\\$OPTARG n'est pas prise en charge !\"",
      "\t\t\t[[ \\$arg == : ]] && print_error \"L'option -\\$OPTARG requiert un argument !\"",
      "\t\t\tusage",
      "\t\t\texit \\$([[ \\$arg == h ]] && echo 0 || echo 2)",
      "\t\t\t;;",
      "\tesac",
      "done"
    ],
    "description": "while getopts … done (simple)"
  },
  // 完整的while getopts
  "Getopts full": {
    "prefix": "getopts",
    "body": [
      "while getopts :${1:?}a-:fqvh arg",
      "do",
      "\tcase \\$arg in",
      "\t\t-)",
      "\t\t\tif [[ \\${!OPTIND} == -* ]]; then",
      "\t\t\t\tunset -v value",
      "\t\t\telse",
      "\t\t\t\tvalue=\"\\${!OPTIND}\"",
      "\t\t\t\t((OPTIND++))",
      "\t\t\tfi",
      "\t\t\tcase \\$OPTARG in",
      "\t\t\t\thost)",
      "\t\t\t\t\tHOST=\\$value",
      "\t\t\t\t\t;;",
      "\t\t\t\tport)",
      "\t\t\t\t\tif [[ ! \\$value =~ ^[0-9]+\\$ ]]; then",
      "\t\t\t\t\t\tprint_error \"L'option --\\$OPTARG a besoin d'un entier en parametre. \\\"\\$value\\\" n'est pas un entier.\"",
      "\t\t\t\t\t\tusage",
      "\t\t\t\t\t\texit 2",
      "\t\t\t\t\tfi",
      "\t\t\t\t\t;;",
      "\t\t\t\t*)",
      "\t\t\t\t\tprint_error \"Le parametre '--\\$OPTARG' n'est pas reconnu !\"",
      "\t\t\t\t\tusage",
      "\t\t\t\t\texit 2",
      "\t\t\t\t\t;;",
      "\t\t\t\tesac",
      "\t\t\t;;",
      "\t\ta)",
      "\t\t\t[[ \\$OPTARG == -* ]] && print_error \"L'option -\\$arg requiert un argument !\" && usage && exit 2",
      "\t\t\t;;",
      "\t\t${1})",
      "\t\t\t${0:: #statements}",
      "\t\t\t;;",
      "\t\tf) FORCE=1 ;;",
      "\t\tq) QUIET=1 ;;",
      "\t\tv) VERBOSE=1 ;;",
      "\t\t:|?|h)",
      "\t\t\t[[ \\$arg == \\? ]] && print_error \"L'option -\\$OPTARG n'est pas prise en charge !\"",
      "\t\t\t[[ \\$arg == : ]] && print_error \"L'option -\\$OPTARG requiert un argument !\"",
      "\t\t\tusage",
      "\t\t\texit \\$([[ \\$arg == h ]] && echo 0 || echo 2)",
      "\t\t\t;;",
      "\tesac",
      "done"
    ],
    "description": "while getopts … done"
  },
  "Usage function": {
    "prefix": "usage",
    "body": [
      "function usage() {",
      "\tcat <<-EOF",
      "\tUsage: pgihadmin ${1:tache} <CIBLE> [-f] [-q] [-h]",
      "\tCette tache permet de ${2:bla bla}",
      "\tPARAMETRES:",
      "\t===========",
      "\t    CIBLE    Serveur cible : <vide> ou all, aps, ts, lb, ord, apsN, tsN, lbN, ordN (avec N un nombre)",
      "\tOPTIONS:",
      "\t========",
      "\t    -f    Mode force",
      "\t    -q    Mode silencieux",
      "\t    -h    Affiche ce message",
      "EOF",
      "}"
    ],
    "description": "Usage fonction template"
  },
  "New task": {
    "prefix": "newtask",
    "body": [
      "#!/bin/bash",
      "#",
      "# @version \t\t14.4.0-SNAPSHOT",
      "# @script\t\tt_${1:TODO}.sh",
      "# @description\t${2:TODO : Description detaillee du script}",
      "#",
      "##",
      "source p_common.sh",
      "function usage() {",
      "\tcat <<-EOF",
      "\tUsage: pgihadmin ${1} <CIBLE> [-f] [-q] [-h]",
      "\tCette tache permet de ${2}",
      "\tPARAMETRES:",
      "\t===========",
      "\t    CIBLE    Serveur cible : <vide> ou all, aps, ts, lb, ord, apsN, tsN, lbN, ordN (avec N un nombre)",
      "\tOPTIONS:",
      "\t========",
      "\t    -f    Mode force",
      "\t    -q    Mode silencieux",
      "\t    -h    Affiche ce message",
      "EOF",
      "}",
      "#   __             _   _",
      "#  / _|___ _ _  __| |_(_)___ _ _  ___",
      "# |  _/ _ \\ ' \\/ _|  _| / _ \\ ' \\(_-<",
      "# |_| \\___/_||_\\__|\\__|_\\___/_||_/__/",
      "#",
      "#",
      "# TODO Function '${5}' description",
      "# @param\tTODO The first parameter",
      "# @return\tTODO",
      "#",
      "${5:function_name}() {",
      "\tlocal firstParam=\\$1; shift",
      "\tlocal secondParam=\\$1; shift",
      "\t${6:echo \"Function '${5}' not yet implemented!\" # TODO}",
      "}",
      "#             _",
      "#  _ __  __ _(_)_ _",
      "# | '  \\/ _` | | ' \\",
      "# |_|_|_\\__,_|_|_||_|",
      "#",
      "main() {",
      "\twhile getopts :${3:?}a-:fqvh arg",
      "\tdo",
      "\t\tcase \\$arg in",
      "\t\t\t-)",
      "\t\t\t\tif [[ \\${!OPTIND} == -* ]]; then",
      "\t\t\t\t\tunset -v value",
      "\t\t\t\telse",
      "\t\t\t\t\tvalue=\"\\${!OPTIND}\"",
      "\t\t\t\t\t((OPTIND++))",
      "\t\t\t\tfi",
      "\t\t\t\tcase \\$OPTARG in",
      "\t\t\t\t\thost)",
      "\t\t\t\t\t\tHOST=\\$value",
      "\t\t\t\t\t\t;;",
      "\t\t\t\t\tport)",
      "\t\t\t\t\t\tif [[ ! \\$value =~ ^[0-9]+\\$ ]]; then",
      "\t\t\t\t\t\t\tprint_error \"L'option --\\$OPTARG a besoin d'un entier en parametre. \\\"\\$value\\\" n'est pas un entier.\"",
      "\t\t\t\t\t\t\tusage",
      "\t\t\t\t\t\t\texit 2",
      "\t\t\t\t\t\tfi",
      "\t\t\t\t\t\t;;",
      "\t\t\t\t\t*)",
      "\t\t\t\t\t\tprint_error \"Le parametre '--\\$OPTARG' n'est pas reconnu !\"",
      "\t\t\t\t\t\tusage",
      "\t\t\t\t\t\texit 2",
      "\t\t\t\t\t\t;;",
      "\t\t\t\t\tesac",
      "\t\t\t\t;;",
      "\t\t\ta)",
      "\t\t\t\t[[ \\$OPTARG == -* ]] && print_error \"L'option -\\$arg requiert un argument !\" && usage && exit 2",
      "\t\t\t\t;;",
      "\t\t\t${3})",
      "\t\t\t\t${4:: #statements}",
      "\t\t\t\t;;",
      "\t\t\tf) FORCE=1 ;;",
      "\t\t\tq) QUIET=1 ;;",
      "\t\t\tv) VERBOSE=1 ;;",
      "\t\t\t:|?|h)",
      "\t\t\t\t[[ \\$arg == \\? ]] && print_error \"L'option -\\$OPTARG n'est pas prise en charge !\"",
      "\t\t\t\t[[ \\$arg == : ]] && print_error \"L'option -\\$OPTARG requiert un argument !\"",
      "\t\t\t\tusage",
      "\t\t\t\texit \\$([[ \\$arg == h ]] && echo 0 || echo 2)",
      "\t\t\t\t;;",
      "\t\tesac",
      "\tdone",
      "\t$7",
      "}",
      "main \"\\$@\""
    ],
    "description": "New task template"
  }
  // 添加更多代码片段
}
```

## Python snippet

创建自定义代码片段

- 同样按下 Ctrl+Shift+P（或 Cmd+Shift+P 在 Mac 上）打开命令面板。

- 输入 “Configure User Snippets” 并选择 “Shell” 选项，这将打开一个名为 python.json 的文件。

```json
{
  "#!/usr/bin/env python 2": {
    "prefix": "env",
    "body": ["#!/usr/bin/env python2", "# -*- coding: utf-8 -*-\n$0"],
    "description": "Adds shebang line for default python 2 interpreter."
  },
  "#!/usr/bin/env python3": {
    "prefix": "env3",
    "body": ["#!/usr/bin/env python3", "# -*- coding: utf-8 -*-\n$0"],
    "description": "Adds shebang line for default python 3 interpreter."
  },
  "from future import ...": {
    "prefix": "fenc",
    "body": [
      "from __future__ import absolute_import, division, print_function, unicode_literals"
    ],
    "description": "Import future statement definitions for python2.x scripts using utf-8 as encoding."
  },
  "Python 2": {
    "prefix": "py2base",
    "body": [
      "#!/usr/bin/env python",
      "# -*- coding: utf-8 -*-",
      "",
      "import sys",
      "",
      "def main():",
      "    pass",
      "",
      "if __name__ == '__main__':"
    ]
  },
  "Python 3": {
    "prefix": "py3base",
    "body": [
      "#!/usr/bin/env python3",
      "# -*- coding: utf-8 -*-",
      "",
      "import sys",
      "",
      "def main():",
      "    pass",
      "",
      "if __name__ == '__main__':",
      "    main()"
    ]
  },
  "import": {
    "prefix": "im",
    "body": "import ${1:package/module}$0",
    "description": "Import a package or module"
  },
  "from ... import ...": {
    "prefix": "fim",
    "body": "from ${1:package/module} import ${2:names}$0",
    "description": "Import statement that allows individual objects from the module to be imported directly into the caller’s symbol table."
  },
  "Get current file path": {
    "prefix": "cpath",
    "body": [
      "import os",
      "current_file_path = os.path.abspath(__file__)",
      "print('Current file path: {}'.format(current_file_path))"
    ],
    "description": "Get the current file path"
  },
  "Get current time": {
    "prefix": "ctime",
    "body": [
      "from datetime import datetime",
      "current_time = datetime.now()",
      "print('Current time: {}'.format(current_time))"
    ],
    "description": "Get the current time"
  },
  "Get current date and time": {
    "prefix": "cdatetime",
    "body": [
      "from datetime import datetime",
      "current_date_and_time = datetime.now()",
      "print('Current date and time: {}'.format(current_date_and_time))"
    ],
    "description": "Get the current date and time"
  },
  "Loop through list": {
    "prefix": "listloop",
    "body": [
      "my_list = [${1:item1}, ${2:item2}, ${3:item3}]",
      "for item in my_list:",
      "    print(item)"
    ],
    "description": "Loop through a list and print items"
  },
  "lambda": {
    "prefix": "lam",
    "body": "lambda ${1:args}: ${2:expr}",
    "description": "Create template for lambda function"
  },
  "PDB set trace": {
    "prefix": "pdb",
    "body": "import pdb; pdb.set_trace()$0"
  },
  "iPDB set trace": {
    "prefix": "ipdb",
    "body": "import ipdb; ipdb.set_trace()$0"
  },
  "rPDB set trace": {
    "prefix": "rpdb",
    "body": "import rpdb2; rpdb2.start_embedded_debugger('${1:debug_password}')$0"
  },
  "PuDB set trace": {
    "prefix": "pudb",
    "body": "import pudb; pudb.set_trace()$0"
  },
  "IPython set trace": {
    "prefix": "ipydb",
    "body": "from IPython import embed; embed()$0"
  },
  // file
  "Get current directory": {
    "prefix": "cdir",
    "body": [
      "import os",
      "current_directory = os.path.dirname(os.path.abspath(__file__))",
      "print('Current directory: {}'.format(current_directory))"
    ],
    "description": "Get the current directory"
  },
  "Get current file name": {
    "prefix": "cfile",
    "body": [
      "import os",
      "current_file_name = os.path.basename(__file__)",
      "print('Current file name: {}'.format(current_file_name))"
    ],
    "description": "Get the current file name"
  },
  "file.listFiles": {
    "prefix": "withFile-listFiles",
    "body": "for item in os.listdir(\"${1:path/*.py}\"):  # import os\n\t# Comment: $0\n\tprint(item)\n# end file item",
    "description": "List files in that path"
  },
  "file.listFilesWithPath": {
    "prefix": "withFile-listFilesWithPath",
    "body": "for item in glob.glob(\"${1:path\\*.py}\"):  # import glob\n\t# Comment: $0\n\tprint(item)\n# end file item with path",
    "description": "List files with path"
  },
  "file.openFile": {
    "prefix": "withFile-openFile",
    "body": "with open('${1:pyfile.txt}', '${2:r}') as f:\n\t# Comment: $0\n\tprint(f.read())\n# end open file",
    "description": "open a file"
  },
  "file.openFileReadLine": {
    "prefix": "withFile-openFileReadLine",
    "body": "with open('${1:pyfile.txt}', '${2:r}') as f:\n\t# Comment: $1\n\tfor line in f:\n\t\t# process each line here, remove \\n using strip\n\t\tline = line.replace(\"    \", \"\\t\").strip()\n\t\tprint(line, end=\",\\n\")$0\n\t# end for\n# end readline file",
    "description": "Read one line of the file"
  },
  "file.openFileReadSingleLine": {
    "prefix": "withFile-openFileReadSingleLine",
    "body": "with open('${1:pyfile.txt}', '${2:r}') as f:\n\t# Comment: $0\n\tprint(f.readline())\n# end readline file",
    "description": "Read one line of the file"
  },
  "file.appendFile": {
    "prefix": "withFile-appendFile",
    "body": "with open('${1:pyfile.txt}', '${2:a}') as f:\n\t# Comment: $0\n\tf.write(${2:\"text here\"})\n# end append file",
    "description": "Write to an Existing File"
  },
  "file.overwriteFile": {
    "prefix": "withFile-overwriteFile - can clear",
    "body": "with open('${1:pyfile.txt}', '${2:w}') as f:\n\t# Comment: $0\n\tf.write(${2:\"new text\"})\n# end overwrite file",
    "description": "Open a file and overwrite the content"
  },
  "file.deleteFile": {
    "prefix": "withFile-deleteFile - need check exist",
    "body": "if os.path.isfile('${1:pyfile.txt}'):\n\t# Comment: $0\n\tos.remove('${1:pyfile.txt}')  # import os\n# end del-file",
    "description": "delete a file"
  }
}
```

## Ansible snippet

```json
{
  // Place your ansible 工作区 snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and
  // description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope
  // is left empty or omitted, the snippet gets applied to all languages. The prefix is what is
  // used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
  // $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders.
  // Placeholders with the same ids are connected.
  // Example:
  // "Print to console": {
  // 	"scope": "javascript,typescript",
  // 	"prefix": "log",
  // 	"body": [
  // 		"console.log('$1');",
  // 		"$2"
  // 	],
  // 	"description": "Log output to console"
  // }
  "ansible_playbook_snippets_base": {
    "prefix": "asb_playbook_snippets_base",
    "body": [
      "---",
      "- hosts: all",
      "  become: true",
      "  roles:",
      "    - role: role_name",
      "  tasks:",
      "    - name: this is simple shell task",
      "      shell: |",
      "        echo \"$1\""
    ],
    "description": "asb_playbook_snippets_base"
  },
  "ansible_playbook_snippets_base_serial": {
    "prefix": "asb_playbook_snippets_base_serial",
    "body": [
      "---",
      "- hosts: all",
      "  become: true",
      "  # 通过设置 serial 来控制并发执行的任务数",
      "  strategy: linear",
      "  serial: 1",
      "  roles:",
      "    - role: role_name",
      "  tasks:",
      "    - name: this is sample task",
      "      ping:",
      "    $0"
    ],
    "description": "asb_playbook_snippets_base_serial"
  },
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
      "  - /dev/sdb"
    ],
    "description": "asb_group_var_all_task1"
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
      "  serial: 1  # 一般情况下, ansible 会同时在所有服务器上执行用户定义的操作,因此可以通过设置 serial 来控制并发执行的任务数。",
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
    "description": "asb_playbook_snippets_task2"
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
      "      delay: \"{{ health_mon_check_delay }}\""
    ],
    "description": "asb_playbook_snippets_task3"
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
      "      become_method: sudo"
    ],
    "description": "asb_include_role_tsak1"
  },
  "ansible_include_role_task2": {
    "prefix": "asb_include_role_tsak2",
    "body": [
      "---",
      "",
      "- include: redis.yml",
      "- include: db.yml",
      "- include: license-gitignore.yml"
    ],
    "description": "asb_include_role_tsak2"
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
      "      include_tasks: mgr.yml"
    ],
    "description": "asb_include_role_tsak3"
  },
  "ansible_add_task1": {
    "prefix": "asb_add_task1",
    "body": ["- name: $1", "  $2"],
    "description": "asb_add_task1"
  },
  "ansible_set_fact_task1": {
    "prefix": "asb_set_fact_task1",
    "body": [
      "- name: set_fact fsid",
      "  set_fact:",
      "    fsid: \"{{ cluster_uuid.stdout }}\"",
      "  when: cluster_uuid.stdout is defined"
    ],
    "description": "ansible_set_fact_task1"
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
      "    when: ansible_os_family in ['RedHat', 'Suse']"
    ],
    "description": "asb_set_fact_task2"
  },
  "ansible_set_fact_task3": {
    "prefix": "asb_set_fact_task3",
    "body": [
      "- name: set_fact _monitor_address to monitor_interface - ipv4",
      "  set_fact:",
      "    monitor_addresses: \"{{ _monitor_addresses | default([]) + [{ ''name'': item, ''addr'': hostvars[item][''monitor_ipv4''] }] }}\"",
      "  with_items: \"{{ groups.get(mon_group_name, []) }}\""
    ],
    "description": "asb_set_fact_task3"
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
      "    ceph_version: \"{{ ceph_version.stdout.split('' '')[2] }}\""
    ],
    "description": "asb_set_fact_task4"
  },
  "ansible_set_fact_task5": {
    "prefix": "asb_set_fact_task5",
    "body": [
      "- set_fact: ipaddress=\"{{ hostvars[groups['webservers'][0]]['ansible_eth0']['ipv4']['address'] }}\"",
      "- set_fact: headnode=\"{{ groups[['webservers'][0]] }}\"",
      "",
      "- debug: msg={{ headnode }}",
      "- debug: msg={{ ipaddress }}"
    ],
    "description": "asb_set_fact_task5"
  },
  "ansible_common_modules_command_task1": {
    "prefix": "asb_common_modules_command_task1",
    "body": [
      "- name: Checking docker SDK version",
      "  command: \"/usr/bin/python -c \"import docker; print docker.__version__\"\"",
      "  # 将执行的结果赋值给 result 变量",
      "  register: result",
      "  # 因为这个模块不会更改目标主机上的任何设置,所以change_when是false,无论执行结果如何,都不会去改变这个当然任务的changed属性",
      "  # 我们可以通过changed_when来手动更改changed响应状态。",
      "  changed_when: false",
      "  # 判断目标主机inventory_hostname是否属于主机清单中的baremetal组",
      "  when: inventory_hostname in groups['baremetal']",
      "  # 将result变量传递给failed函数,判断命令是否执行成功",
      "  # 如果命令执行成功,将result中的输出结果,传递给version_compare函数,判断版本是否符合要求",
      "  # 如果failed_when判断结果为失败,则设置任务状态为失败,停止执行此playbook",
      "  # 复杂判断",
      "  failed_when: result | failed or",
      "               result.stdout | version_compare(docker_py_version_min, '<')"
    ],
    "description": "asb_common_modules_command_task1"
  },
  "ansible_common_modules_command_task2": {
    "prefix": "asb_common_modules_command_task2",
    "body": [
      "---",
      "- name: generate cluster fsid",
      "  command: \"/bin/python -c ''import uuid; print(str(uuid.uuid4()))''\"",
      "  #command: \"{{ hostvars[groups[mon_group_name][0]][''discovered_interpreter_python''] }} -c ''import uuid; print(str(uuid.uuid4()))''\"",
      "  register: cluster_uuid",
      "  delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true"
    ],
    "description": "asb_common_modules_command_task2"
  },
  "ansible_common_modules_command_task3": {
    "prefix": "asb_common_modules_command_task3",
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
      "    - ceph_current_status.fsid is undefined"
    ],
    "description": "asb_common_modules_command_task3"
  },
  "ansible_common_modules_shell_task1": {
    "prefix": "asb_common_modules_shell_task1",
    "body": [
      "- name: Configure timezone",
      "  shell: |",
      "    set -eux; set -o pipefail",
      "    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone",
      ""
    ],
    "description": "asb_common_modules_shell_task1"
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
      "    #creates: 如果指定的文件存在,则不执行命令。"
    ],
    "description": "asb_common_modules_shell_task2"
  },
  "ansible_common_modules_shell_task3": {
    "prefix": "asb_common_modules_shell_task3",
    "body": [
      "- name: get monitor ipv4 address",
      "  shell: \"cat /etc/hosts | grep {{ inventory_hostname }} | awk '{print \\$1}'\"",
      "  register: shell_out",
      ""
    ],
    "description": "asb_common_modules_shell_task3"
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
      ""
    ],
    "description": "asb_common_modules_shell_task4"
  },
  "ansible_common_modules_shell_task5": {
    "prefix": "asb_common_modules_shell_task5",
    "body": [
      "- name: 初始化数据库 1",
      "  shell: \"chdir=/app/gitee bundle exec rake db:migrate RAILS_ENV=production\"",
      "  run_once: true",
      "  delegate_to: backend1"
    ],
    "description": "asb_common_modules_shell_task5"
  },
  "ansible_common_modules_shell_task6": {
    "prefix": "asb_common_modules_shell_task6",
    "body": [
      "- name: find running processes",
      "  ignore_errors: yes",
      "  shell: \"ps -ef | grep -v grep | grep sshd | awk '{print $2}'\"",
      "  register: running_processes",
      "",
      "- name: Kill running processes",
      "  ignore_errors: yes",
      "  shell: \"kill {{ item }}\"",
      "  with_items: \"{{ running_processes.stdout_lines }}\""
    ],
    "description": "asb_common_modules_shell_task6"
  },
  "ansible_common_modules_debug_task1": {
    "prefix": "asb_common_modules_debug_task1",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\""
    ],
    "description": "asb_common_modules_debug_task1"
  },
  "ansible_common_modules_debug_task2": {
    "prefix": "asb_common_modules_debug_task2",
    "body": [
      "",
      "- name: \"show ceph status for cluster {{ cluster }}\"",
      "  debug:",
      "    msg: \"{{ ceph_status.stdout_lines }}\"",
      "    delegate_to: \"{{ groups[mon_group_name][0] }}\"",
      "  run_once: true"
    ],
    "description": "asb_common_modules_debug_task2"
  },
  "ansible_common_modules_debug_task3": {
    "prefix": "asb_common_modules_debug_task3",
    "body": [
      "- name: debug inventory_hostname",
      "  debug:",
      "    var: inventory_hostname",
      "",
      "- name: debug groups[hosts_src_ctl][0]",
      "  debug:",
      "    var: groups[hosts_src_ctl][0]"
    ],
    "description": "asb_common_modules_debug_task3"
  },
  "ansible_common_modules_copy_task1": {
    "prefix": "asb_common_modules_copy_task1",
    "body": [
      "- name: Configure online sources",
      "  copy:",
      "    src: sources.list",
      "    dest: /etc/apt/",
      "    backup: yes"
    ],
    "description": "asb_common_modules_copy_task1"
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
      ""
    ],
    "description": "asb_common_modules_copy_task2"
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
      "    - dashboard_protocol == \"https\""
    ],
    "description": "asb_common_modules_copy_task3"
  },
  "ansible_common_modules_template_task1": {
    "prefix": "asb_common_modules_template_task1",
    "body": [
      "- name: 配置 keepalived",
      "  template:",
      "    src: keepalived/frontend/keepalived.conf",
      "    dest: /etc/keepalived/keepalived.conf",
      "  become: yes",
      "  become_method: sudo"
    ],
    "description": "asb_common_modules_template_task1"
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
      "  become_method: sudo"
    ],
    "description": "asb_common_modules_template_task3"
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
      "    - containerd_version != \"\""
    ],
    "description": "asb_common_modules_unarchive_task1"
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
      "  become: true"
    ],
    "description": "asb_common_modules_yum_tsak1"
  },
  "ansible_common_modules_package_tsak1": {
    "prefix": "asb_common_modules_package_tsak1",
    "body": [
      "- name: install redhat ceph packages",
      "  package:",
      "    name: \"{{ redhat_ceph_pkgs | unique }}\"",
      "    state: \"{{ (upgrade_ceph_packages|bool) | ternary(''latest'',''present'') }}\"",
      "  register: result",
      "  until: result is succeeded"
    ],
    "description": "asb_common_modules_package_tsak1"
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
      "  when: ansible_distribution == 'RedHat'"
    ],
    "description": "ansible_apb_task_package1"
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
      "  become: yes"
    ],
    "description": "asb_common_modules_cron_tsak1"
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
      "  become_method: sudo"
    ],
    "description": "asb_common_modules_user_task1"
  },
  "ansible_common_modules_file_task1": {
    "prefix": "asb_common_modules_file_task1",
    "body": [
      "- name: Create /etc/containerd",
      "  file:",
      "    path: /etc/containerd",
      "    state: directory",
      ""
    ],
    "description": "asb_common_modules_file_task1"
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
      "   mode: \"{{ ceph_directories_mode | default(''0755'') }}\""
    ],
    "description": "asb_common_modules_file_task2"
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
      "    # 默认ceph_mon_systemd_overrides没有设置,所以该任务不会执行",
      "    - ceph_mon_systemd_overrides is defined",
      "    - ansible_service_mgr == 'systemd'"
    ],
    "description": "asb_common_modules_file_task3"
  },
  "ansible_common_modules_file_task4": {
    "prefix": "asb_common_modules_file_task4",
    "body": [
      "- name: 建立软链接 archive",
      "  file:",
      "    src: /data/archive",
      "    dest: /app/gitee/tmp/repositories",
      "    state: link"
    ],
    "description": "asb_common_modules_file_task4"
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
      "    group: \"root\""
    ],
    "description": "asb_common_modules_file_task5"
  },
  "ansible_common_modules_file_task6": {
    "prefix": "asb_common_modules_file_task6",
    "body": [
      "- name: absent logs",
      "  file:",
      "    path: \"{{ item }}\"",
      "    state: absent",
      "  with_items:",
      "    - /tmp/log1.log",
      "    - /tmp/log1.log"
    ],
    "description": "asb_common_modules_file_task6"
  },
  "ansible_common_modules_stat_task1": {
    "prefix": "asb_common_modules_stat_task1",
    "body": [
      "- name: Get stats of the FS object",
      "  stat:",
      "    path: /path/to/something",
      "  register: p",
      "- name: Print a debug message",
      "  debug:",
      "    msg: \"Path exists and is a directory\"",
      "  when: p.stat.isdir is defined and p.stat.isdir"
    ],
    "description": "asb_common_modules_stat_task1"
  },
  "ansible_common_modules_stat_task2": {
    "prefix": "asb_common_modules_stat_task2",
    "body": [
      "- name: Get stats of the FS object",
      "  stat:",
      "    path: /path/to/something",
      "  register: sym",
      "",
      "- name: Print a debug message",
      "  debug:",
      "    msg: \"islnk isn't defined (path doesn't exist)\"",
      "  when: sym.stat.islnk is not defined",
      "",
      "- name: Print a debug message",
      "  debug:",
      "    msg: \"islnk is defined (path must exist)\"",
      "  when: sym.stat.islnk is defined"
    ],
    "description": "asb_common_modules_stat_task2"
  },
  "ansible_common_modules_service_task1": {
    "prefix": "asb_common_modules_service_task1",
    "body": [
      "- name: Start kubelet",
      "   service:",
      "    name: kubelet.service",
      "    state: started",
      "    enabled: yes"
    ],
    "description": "asb_common_modules_service_task1"
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
      "    daemon_reload: yes"
    ],
    "description": "asb_common_modules_system_task1"
  },
  "ansible_common_modules_system_task2": {
    "prefix": "asb_common_modules_system_task2",
    "body": [
      "- name: Start containerd.service",
      "  systemd:",
      "    name: containerd.service",
      "    state: started",
      "    daemon_reload: yes",
      "    enabled: yes"
    ],
    "description": "asb_common_modules_system_task2"
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
      ""
    ],
    "description": "asb_common_modules_get_url_task1"
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
      "    - http://{{ download_address }}/kubeadm-install/{{ kubectl }}/kubectl"
    ],
    "description": "asb_common_modules_get_url_task2"
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
  "ansible_common_modules_synchronize_task3": {
    "prefix": "asb_common_modules_synchronize_task3",
    "body": [
      "#只同步远程目录没有的文件",
      "- name: sync the upsync config",
      "  synchronize:",
      "    src: /data/.jenkins/jobs/ops-prod/jobs/ops-nginx-config/workspace/prod-nginx/upsync/",
      "    dest: /etc/nginx/upsync/",
      "    mode: push",
      "    rsync_opts: \"--ignore-existing\"",
      "    delete: yes",
      "    rsync_timeout: 30",
      "  tags:",
      "    - prod-nginx"
    ],
    "description": "asb_common_modules_synchronize_task3"
  },
  "ansible_common_modules_fetch_task1": {
    "prefix": "asb_common_modules_fetch_task1",
    "body": [
      "- name: get files in /path/",
      "  shell: ls /path/*",
      "  register: path_files",
      "",
      "- name: fetch these back to the local Ansible host for backup purposes",
      "  fetch:",
      "    src: /path/\"{{item}}\"",
      "    dest: /path/to/backups/",
      "  with_items: \"{{ path_files.stdout_lines }}\""
    ],
    "description": "asb_common_modules_fetch_task1"
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
      "  delegate_to: backend1"
    ],
    "description": "asb_modules_mysql_db_task1"
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
      "  delegate_to: backend1"
    ],
    "description": "asb_modules_mysql_user_task1"
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
      "    - inventory_hostname == groups[mon_group_name] | first"
    ],
    "description": "asb_when_task1"
  },
  "ansible_when_task2": {
    "prefix": "asb_when_task2",
    "body": [
      "- name: include configure_memory_allocator.yml",
      "  include_tasks: configure_memory_allocator.yml",
      "  when:",
      "    - (ceph_tcmalloc_max_total_thread_cache | int) > 0",
      "    - osd_objectstore == 'filestore'",
      "    - (ceph_origin == 'repository' or ceph_origin == 'distro')"
    ],
    "description": "asb_when_task2"
  },
  "ansible_when_task3": {
    "prefix": "asb_when_task3",
    "body": [
      "- name: include release-rhcs.yml",
      "  include_tasks: release-rhcs.yml",
      "  when: ceph_repository in ['rhcs', 'dev'] or ceph_origin == 'distro'",
      "  tags: always"
    ],
    "description": "asb_when_task3"
  },
  "ansible_when_task4": {
    "prefix": "asb_when_task4",
    "body": [
      "- name: shut down centos8 systems",
      "  command: /sbin/shutdown -t now",
      "  when:",
      "    - ansible_facts['distribution'] == \"CentOS",
      "    - ansible_facts['distribution_major_version'] == \"8\""
    ],
    "description": "asb_when_task4"
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
  },
  "ansible_common_modules_find_task1": {
    "prefix": "asb_common_modules_find_task1",
    "body": [
      "- name: find to delete logs",
      "  find:",
      "    paths: /var/log/",
      "    patterns: *.log",
      "    # age: 3d 查找3天前的文件",
      "  register: files_to_absent"
    ],
    "description": "asb_common_modules_find_task1"
  },
  "ansible_common_modules_find_task2": {
    "prefix": "asb_common_modules_find_task2",
    "body": [
      "- name: Find /var/log files equal or greater than 10 megabytes ending with .old or .log.gz",
      "  find:",
      "    paths: /var/log",
      "    patterns: '*.old,*.log.gz'",
      "    size: 10m"
    ],
    "description": "asb_common_modules_find_task2"
  },
  "ansible_common_modules_find_task3": {
    "prefix": "asb_common_modules_find_task3",
    "body": [
      "- name: Find /var/log all directories, exclude nginx and mysql",
      "  find:",
      "    paths: /var/log",
      "    recurse: no",
      "    file_type: directory",
      "    excludes: 'nginx,mysql'"
    ],
    "description": "asb_common_modules_find_task3"
  },
  "ansible_with_items_task1": {
    "prefix": "asb_with_items_task1",
    "body": [
      "- name: test list",
      "  command: echo {{ item }}",
      "  with_items: [0, 2, 4, 6, 8, 10]",
      "  when: item > 5",
      "",
      "# 等效与上面的with_items",
      "- name: Run with items greater than 5",
      "  command: echo {{ item }}",
      "  loop: [ 0, 2, 4, 6, 8, 10 ]",
      "  when: item > 5",
      "",
      "# 迭代列表子项",
      "- name: Setting sysctl values",
      "  sysctl: name={{ item.name }} value={{ item.value }} sysctl_set=yes",
      "  with_items:",
      "    - { name: \"net.bridge.bridge-nf-call-iptables\", value: 1 }",
      "    - { name: \"net.bridge.bridge-nf-call-ip6tables\", value: 1 }",
      "    - { name: \"net.ipv4.conf.all.rp_filter\", value: 0 }",
      "    - { name: \"net.ipv4.conf.default.rp_filter\", value: 0 }",
      "  when:",
      "    - set_sysctl | bool",
      "    - inventory_hostname in groups['compute']"
    ],
    "description": "asb_with_items_task1"
  },
  "ansible_with_items_task2": {
    "prefix": "asb_with_items_task2",
    "body": [
      "- name: with_items",
      "  debug:",
      "    msg: \"{{ item }}\"",
      "  with_items: \"{{ items }}\"",
      "",
      "# with_items可以使用loop和flatten过滤器代替。",
      "- name: with_items -> loop",
      "  debug:",
      "    msg: \"{{ item }}\"",
      "  loop: \"{{ items|flatten(levels=1) }}\""
    ],
    "description": "asb_with_items_task2"
  },
  "ansible_with_items_task3": {
    "prefix": "asb_with_items_task3",
    "body": [
      "- name: with_list",
      "  debug:",
      "    msg: \"{{ item }}\"",
      "  with_list:",
      "    - one",
      "    - two",
      "",
      "# with_list可以直接使用loop代替。",
      "- name: with_list -> loop",
      "  debug:",
      "    msg: \"{{ item }}\"",
      "  loop:",
      "    - one",
      "    - two"
    ],
    "description": "asb_with_items_task3"
  },
  "ansible_with_flattened_task1": {
    "prefix": "asb_with_flattened_task1",
    "body": [
      "- name: Example with_flattened loop",
      "  hosts: localhost",
      "  gather_facts: false",
      "  # 循环还支持列表,语句实现",
      "  vars:",
      "    my_list:",
      "      - [1, 2, 3]",
      "      - [4, 5, 6]",
      "      - [7, 8, 9]",
      "  tasks:",
      "    - name: Print item",
      "      debug:",
      "        msg: \"{{ item }}\"",
      "      with_flattened:",
      "        - \"{{ my_list }}\""
    ],
    "description": "asb_with_flattened_task1"
  },
  "ansible_with_dict_task1": {
    "prefix": "asb_with_dict_task1",
    "body": [
      "- name: Print phone records",
      "  # 现在需要输出每个用户的用户名和手机号：",
      "  debug: msg=\"User {{ item.key }} is {{ item.value.name }} ({{ item.value.telephone }})\"",
      "  with_dict: \"{{ users }}\"",
      "  # 假如有如下变量内容：",
      "  vars:",
      "    users:",
      "      alice:",
      "        name: Alice Appleworth",
      "        telephone: 123-456-7890",
      "      bob:",
      "        name: Bob Bananarama",
      "        telephone: 987-654-3210"
    ],
    "description": "asb_with_dict_task1"
  },
  "ansible_with_fileglob_task1": {
    "prefix": "asb_with_fileglob_task1",
    "body": [
      "# 循环指定目录中的所有文件,支持通配符",
      "- hosts: test",
      "  tasks:",
      "    - name: Make key directory     ",
      "      file: ",
      "        path: /root/.sshkeys ",
      "        state: directory ",
      "        mode: 0700 ",
      "        owner: root ",
      "        group: root ",
      "        ",
      "    - name: Upload public keys     ",
      "      copy: ",
      "        src: \"{{ item }}\"",
      "        dest: /root/.sshkeys",
      "        mode: 0600 ",
      "        owner: root ",
      "        group: root  ",
      "      with_fileglob:",
      "        - /root/.ssh/*.pub ",
      ""
    ],
    "description": "asb_with_fileglob_task1"
  },
  "ansible_with_together_task1": {
    "prefix": "asb_with_together_task1",
    "body": [
      "# with_together迭代两个列表的元素,遍历数据并行集合",
      "- name: with_together task",
      "  debug: msg=\"{{ item.0 }} and {{ item.1 }}\"    # 输出：a and 1, b and 2, c and 3, d and 4",
      "  with_together:",
      "      - \"{{ alpha }}\"",
      "      - \"{{ numbers }}\"",
      "  vars:",
      "    alpha: [ 'a','b','c','d']",
      "    numbers: [ 1,2,3,4 ]"
    ],
    "description": "asb_with_together_task1"
  },
  "ansible_with_nested_task1": {
    "prefix": "asb_with_nested_task1",
    "body": [
      "# 嵌套循环 with_nested",
      "- name: debug loops",
      "  debug: msg=\"name is {{ item[0] }}  vaule is {{ item[1] }} num is {{ item[2] }}\" ",
      "  with_nested:",
      "    - ['alice','bob']",
      "    - ['a','b','c']",
      "    - ['1','2','3']"
    ],
    "description": "asb_with_nested_task1"
  },
  "ansible_loop_task1": {
    "prefix": "asb_loop_task1",
    "body": [
      "- name: Add several users",
      "  user:",
      "    name: \"{{ item }}\"",
      "    state: present",
      "    groups: \"wheel\"",
      "  loop:",
      "     - testuser1",
      "     - testuser2"
    ],
    "description": "asb_loop_task1"
  },
  "ansible_loop_task2": {
    "prefix": "asb_loop_task2",
    "body": [
      "# 迭代列表子项",
      "- name: Add several users",
      "  user:",
      "    name: \"{{ item.name }}\"",
      "    state: present",
      "    groups: \"{{ item.groups }}\"",
      "  loop:",
      "    - { name: 'testuser1', groups: 'wheel' }",
      "    - { name: 'testuser2', groups: 'root' }"
    ],
    "description": "asb_loop_task2"
  },
  "ansible_loop_task3": {
    "prefix": "asb_loop_task3",
    "body": [
      "# 迭代字典",
      "- name: Using dict2items",
      "  debug:",
      "    msg: \"{{ item.key }} - {{ item.value }}\"",
      "  loop: \"{{ tag_data | dict2items }}\"",
      "  vars:",
      "    tag_data:",
      "      Environment: dev",
      "      Application: payment"
    ],
    "description": "asb_loop_task3"
  },
  "ansible_loop_task4": {
    "prefix": "asb_loop_task4",
    "body": [
      "- hosts: node1",
      "  tasks:",
      "    # 在循环中注册变量",
      "    - name: Register loop output as a variable",
      "      ansible.builtin.shell: \"echo {{ item }}\"",
      "      loop:",
      "        - \"one\"",
      "        - \"two\"",
      "      register: ECHO",
      "",
      "    - name: print variable ECHO",
      "      ansible.builtin.debug:",
      "        msg: \"The ECHO value is: {{ ECHO }}\""
    ],
    "description": "asb_loop_task4"
  },
  "ansible_loop_index_task5": {
    "prefix": "asb_loop_index_task5",
    "body": [
      "- hosts: node1",
      "  tasks:",
      "    # 设置索引",
      "    - name: Count our fruit",
      "      ansible.builtin.debug:",
      "        msg: \"{{ item }} with index {{ my_idx }}\"",
      "      loop:",
      "        - apple",
      "        - banana",
      "        - pear",
      "      loop_control:",
      "        index_var: my_idx"
    ],
    "description": "asb_loop_index_task5"
  },
  "ansible_loop_item2dict_nested_task6": {
    "prefix": "asb_loop_item2dict_nested_task6",
    "body": [
      "---",
      "- hosts: all",
      "  vars:",
      "    cars:",
      "      mustang:",
      "        color: yellow",
      "        year: 2020",
      "      ferrari:",
      "        color: red",
      "        year: 2021",
      "",
      "  tasks:",
      "    - name: Iterate over dictionary",
      "      debug:",
      "        msg: \"The car is {{ item.key }}, color is {{ item.value.color }} and year is {{ item.value.year }}.\"",
      "      loop: \"{{ cars | dict2items }}\""
    ],
    "description": "asb_loop_item2dict_nested_task6"
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
