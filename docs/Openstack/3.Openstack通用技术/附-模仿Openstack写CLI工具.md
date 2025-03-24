# 附-模仿Openstack写CLI工具


## docker-registry-client 工具

为了设计一个类似于 OpenStack 命令行工具架构的 docker-registry-cli 工具，我们可以按以下结构进行设计和实现。这个设计将包含以下关键功能：

简单的实现，后面可以继续完善。


### 1.项目目录结构
```shell
docker-registry-cli/
│
├── cli.py                # 主程序入口
├── commands/             # 存放命令模块的目录
│   ├── __init__.py
│   ├── list.py           # 列出镜像
├── config/               # 配置文件目录
│   └── config.json       # CLI 配置文件
├── utils/                # 工具函数目录
│   ├── __init__.py
    ├── output.py
    └── rest_client.py
└── requirements.txt      # 依赖文件
```

### 2.编码实现

` config.json`

```json
{
    "registry": "http://127.0.0.1:5000"
}
```

`utils/output.py`

```python
#!/usr/bin/env python3
# -*- coding:utf8 -*-
import json
import prettytable
import six


def print_json(data):
    """ 以 JSON 格式打印数据 """
    print(json.dumps(data, indent=4))


def pretty_choice_list(l):
    return ', '.join("'%s'" % i for i in l)


def _print(pt, order):
    print(pt.get_string(sortby=order))


def print_list(objs, fields, formatters={}, order_by=None):
    """
    Print a list of objects as a table.
    """
    mixed_case_fields = ['serverId']
    pt = prettytable.PrettyTable([f for f in fields], caching=False)
    pt.aligns = ['l' for f in fields]

    for o in objs:
        row = []
        for field in fields:
            if field in formatters:
                row.append(formatters[field](o))
            else:
                if field in mixed_case_fields:
                    field_name = field.replace(' ', '_')
                else:
                    field_name = field.lower().replace(' ', '_')
                if type(o) == dict and field in o:
                    data = o[field]
                else:
                    data = getattr(o, field_name, '')
                row.append(data)
        pt.add_row(row)

    if order_by is None:
        order_by = fields[0]
    _print(pt, order_by)


def print_dict(d, property="Property"):
    """
    Print a dictionary as a table.
    """
    pt = prettytable.PrettyTable([property, 'Value'], caching=False)
    pt.aligns = ['l', 'l']
    [pt.add_row(list(r)) for r in six.iteritems(d)]
    _print(pt, property)
```


`utils/rest_client.py`

```python
import requests
from requests.auth import HTTPBasicAuth


class RestClient:
    def __init__(self, base_url, username=None, password=None, token=None, headers=None):
        """
        初始化 REST 客户端
        :param base_url: API 基础 URL
        :param username: 用户名（如果需要基本认证）
        :param password: 密码（如果需要基本认证）
        :param token: Bearer token（如果使用 token 认证）
        :param headers: 请求头
        """
        self.base_url = base_url
        self.username = username
        self.password = password
        self.token = token
        self.headers = headers if headers else {}

        if self.token:
            self.headers['Authorization'] = f'Bearer {self.token}'
        elif self.username and self.password:
            self.auth = HTTPBasicAuth(self.username, self.password)
        else:
            self.auth = None

    def _make_request(self, method, endpoint, params=None, data=None, json_data=None):
        """
        执行 HTTP 请求
        """
        url = self.base_url + endpoint
        try:
            response = requests.request(
                method,
                url,
                headers=self.headers,
                auth=self.auth,
                params=params,
                data=data,
                json=json_data
            )
            response.raise_for_status()
            return response.json()  # 返回 JSON 格式的响应
        except requests.exceptions.HTTPError as err:
            print(f"HTTP Error: {err}")
            raise
        except requests.exceptions.RequestException as err:
            print(f"Request Error: {err}")
            raise

    def get(self, endpoint, params=None):
        """ 执行 GET 请求 """
        return self._make_request('GET', endpoint, params=params)

    def post(self, endpoint, json_data=None, data=None):
        """ 执行 POST 请求 """
        return self._make_request('POST', endpoint, json_data=json_data, data=data)

    def put(self, endpoint, json_data=None):
        """ 执行 PUT 请求 """
        return self._make_request('PUT', endpoint, json_data=json_data)

    def delete(self, endpoint, params=None):
        """ 执行 DELETE 请求 """
        return self._make_request('DELETE', endpoint, params=params)
```

`commands/list.py`

```python
#!/usr/bin/env python3
# -*- coding:utf8 -*-
from utils.rest_client import RestClient
from utils.output import print_json, print_dict, print_list

# 获取镜像仓库列表
# curl -u username:password https://your-registry-url/v2/_catalog
# 获取某个仓库的所有镜像标签
# curl -u username:password https://your-registry-url/v2/your-repository-name/tags/list
# 获取镜像的 manifest
# curl -u username:password -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://your-registry-url/v2/your-repository-name/manifests/your-tag
def list_images(config_data, output_format):
    try:
        registry_url = config_data.get("registry", "http://127.0.0.1:5000")
        client = RestClient(base_url=registry_url)

        # 获取所有镜像列表
        catalog_endpoint = "/v2/_catalog"
        catalog_response = client.get(catalog_endpoint)
        repositories = catalog_response.get("repositories", [])

        # 存储每个镜像及其对应的标签
        images_with_tags = []
        for repo in repositories:
            # 针对每个镜像获取其对应的标签列表
            tags_endpoint = f"/v2/{repo}/tags/list"
            tags_response = client.get(tags_endpoint)
            tags = tags_response.get("tags", [])
            images_with_tags.append({
                "repository": repo,
                "tags": tags
            })

        if output_format == 'json':
            print_json(images_with_tags)
        else:
            print_list(images_with_tags, fields=["repository", "tags"])
    except Exception as e:
        print(f"Error: {str(e)}")
```


`cli.py`
```python
#!/usr/bin/env python3
# -*- coding:utf8 -*-
import argparse
import json
from commands import image


def load_config_file():
    with open('config/config.json') as config_file:
        return json.load(config_file)


def main():
    config_data = load_config_file()

    parser = argparse.ArgumentParser(prog='docker-registry')
    parser.add_argument('--config', help='Configuration file', default='config/config.json')
    parser.add_argument('--output', help='Output format (json/table)', default='table')

    subparsers = parser.add_subparsers(dest='command')

    # Image subcommand
    image_parser = subparsers.add_parser('image', help='Manage images')
    image_subparsers = image_parser.add_subparsers(dest='image_command')

    list_parser = image_subparsers.add_parser('list', help='List images')
    # 继承顶级参数
    list_parser.add_argument('--output', help='Output format (json/table)', default='table')

    args = parser.parse_args()

    # Handle image list command
    if args.command == 'image' and args.image_command == 'list':
        image.list_images(config_data, args.output)
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
```


`requirements.txt`

```shell
requests
prettytable
```







## Harborclient

Harbor通过Web界面可以方便地管理用户、租户以及镜像仓库等资源，但是缺乏开发人员更喜爱的命令行管理工具，Harborclient是Harbor的第三方扩展开源工具，正弥补Harbor不足，它适合开发和运维人员管理镜像仓库、项目等资源，包含的特性如下：

- harborclient参考了OpenStack命令行工具的优秀架构和设计模式，使用也和OpenStack命令行非常类似。
- harborclient通过子命令划分不同的功能，并且所有功能是可扩展的，增加功能只需要在client下增加do_xxx方法即可。主模块会自动发现并注册子命令。
- 相比OpenStack的命令行工具，精简了部分复杂功能，重新设计了大多数接口，暴露的API更直观和易用。
- 支持DEBUG模式查看Harbor API调用过程，便于调试追踪。
- 支持timings选项，能够报告API请求响应时间，便于测试Harbor API性能。
- 支持https。


项目地址: https://github.com/int32bit/python-harborclient.git
