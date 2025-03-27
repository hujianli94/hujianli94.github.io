# 附-模仿 OpenStack 写自己的 RPC


## 最佳实践

### 创建项目

项目名称 neza

```shell
cookiecutter https://git.openstack.org/openstack-dev/cookiecutter.git
You've downloaded /root/.cookiecutters/cookiecutter before. Is it okay to delete and re-download it? [y/n] (y): y
  [1/7] module_name (replace with the name of the python module): neza
  [2/7] service (replace with the service it implements): neza
  [3/7] repo_group (openstack): stackforge
  [4/7] repo_name (replace with the name for the git repo): neza
  [5/7] Select bug_tracker
    1 - Launchpad
    2 - Storyboard
    Choose from [1/2] (1): 1
  [6/7] bug_project (replace with the name of the project on Launchpad or the ID from Storyboard):
  [7/7] project_short_description (OpenStack Boilerplate contains all the boilerplate you need to create an OpenStack package.):
Initialized empty Git repository in /mnt/e/coder/python/openstack-dependent-module/neza/.git/
[master (root-commit) 8107c64] Initial Cookiecutter Commit.
 Committer: root <root@SZ-hujl-586.wangsu.com>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly. Run the
following command and follow the instructions in your editor to edit
your configuration file:

    git config --global --edit

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

# 初始化git代码库
cd neza/
git init
# Initialized empty Git repository in /tmp/abc/.git/

git config --global user.name "建力"
git config --global user.email "1879324764@qq.com"

# 提交代码
git add .
git commit -a

# 基于 pbr 的打包，指定 tag 版本会显示为软件包的版本，示例：
# git 打 tag
git tag v1.0.0
git checkout v1.0.0
```





































## 参考文献


从 0 到 1：全面理解 RPC 远程调用

- https://www.cnblogs.com/wongbingming/p/11086773.html


模仿 OpenStack 写自己的 RPC

- https://www.bmabk.com/index.php/post/194295.html

- https://www.cnblogs.com/luohaixian/p/11084279.html


Openstack 学习笔记总目录

- https://www.cnblogs.com/LeisureZhao/p/11181452.html
