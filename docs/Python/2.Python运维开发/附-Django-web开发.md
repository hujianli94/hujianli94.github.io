# 附-Django-web 开发

## 1. MVC/MTV

### 1.1 MVC 框架

- controllers:处理用户请求
- views：放置 html 模板
- modals：操作数据库

### 1.2 MTV 框架

- views：处理用户请求
- template：放置 html 模板
- modals：操作数据库

## 2. 模型与数据库

Django 提供了完善的模型(model)层来创建和存取数据，它包含你所储存数据的必要字段和行为。通常，每个模型对应数据库中唯一的一张表。所以，模型避免了我们直接对数据库操作。

Django 模型基础知识：

- 每个模型是一个 Python 类，继承 django.db.models.Model 类。
- 该模型的每个属性表示一个数据库表字段。
- 所有这一切，己经给了你一个自动生成的数据库访问的 API。

Django 对各种数据库提供了很好的支持，包括：PostgreSQL、MySQL、SQLite 和 Oracle，而且为这些数据库提供了统一的调用 API，这些 API 统称为 ORM 框架。

通过使用 Django 内置的 ORM 框架可以实现数据库连接和读写操作。

### 2.1 django-配置 mysql

1.安装 pymysql

```sh
pip install pymysql
```

2.修改 settings.py

```sh
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django_test',
        'USER': 'root',
        'PASSWORD': '123456',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

> 更多参数: https://docs.djangoproject.com/zh-hans/4.2/ref/settings/

3.修改项目的`__init__.py` (和 `settings.py` 同级目录)

```python
from pymysql import install_as_MySQLdb
install_as_MySQLdb()
```

### 2.2 构建模型

ORM 框架是一种程序技术，用于实现面向对象编程语言中不同类型系统的数据之间的转换。从效果上说，其实是创建了一个可在编程语言中使用的"虚拟对象数据库"，通过对虚拟对象数据库操作从而实现对目标数控的操作，虚拟对象数据库与模板数据库是相互对应的。在 Django 中，虚拟对象数据库也成为模型。通过模型先对模板数据库的读写操作，实现如下：

1. 配置模板数据库信息，主要在 setting.py 中设置数据库信息
2. 构建虚拟对象数据库，在 App 的 models.py 文件中以类的形式定义模型。
3. 通过模型在模板数据库中创建相应的数据表
4. 在视图函数中通过对模型操作实现目标数据库的读写操作。

以 MyDjango 项目为例，创建项目并配置

=== "python2"

    ```sh
    pip install virtualenv
    cd MyDjango
    virtualenv venv
    source ./venv/bin/activate

    # 创建项目
    (venv)# pip install django==4.2.7
    (venv)# django-admin startproject MyDjango
    # 创建app
    (venv)# python manage.py startapp index
    ```

=== "python3"

    ```sh
    #创建虚拟环境
    python -m venv MyDjango
    cd MyDjango

    # 激活虚拟环境
    source bin/activite
    # 此时就可以在虚拟环境中使用pip install <package_name>来安装python包了

    # 创建项目
    (venv)# pip install django==4.2.7
    (venv)# django-admin startproject MyDjango
    # 创建app
    (venv)# python manage.py startapp index

    # 退出虚拟环境
    deactivate
    ```

settings.py 文件里面的 INSTALLED_APPS。注册你的 app

```python

# 设置时区
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'
USE_I18N = True
USE_L10N = True
USE_TZ = False


INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'index.apps.IndexConfig',   # 注册app
]
```

不注册它，你的数据库就不知道该给哪个 app 创建表。

若想将模型转为 mysql 数据库中的表，需要在 settings 中配置：

```python

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',   # 数据库引擎mysql
        'NAME': 'mydjango',       # 你要存储数据的库名，事先要创建之
        'USER': 'root',      # 数据库用户名
        'PASSWORD': 'oschina',      # 密码
        'HOST': '127.0.0.1', # 主机
        'PORT': '3306',      # 数据库使用的端口
    }
}
```

由于 ORM 不能创建数据库，需要手动创建 mydjango 数据库。

```sql
CREATE DATABASE mydjango CHARACTER SET utf8;
```

django 连接 MySQL，使用的是 pymysql 模块，必须得安装 pymysql 模块。否则后面会创建表不成功！

```sh
pip install pymysql
```

在 `book/user/__init__.py` 文件中加入代码：

```python
from pymysql import install_as_MySQLdb

install_as_MySQLdb()
```

在项目 index 的 models.py 文件中定义模型如下：

```python
from django.db import models


# Create your models here.
# 创建产品分类表
class Type(models.Model):
    id = models.AutoField(primary_key=True)
    type_name = models.CharField(max_length=20)


# 创建产品信息表
class Product(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=50)
    weight = models.CharField(max_length=20)
    size = models.CharField(max_length=20)
    type = models.ForeignKey(Type, on_delete=models.CASCADE)
```

接下来要在 pycharm 的 teminal 中通过命令创建数据库的表了。有 2 条命令，分别是：

```sh
python manage.py makemigrations
python manage.py migrate
```

#### 表字段数据类型及说明

| 字段类型          | 用途             | 示例                                                                |
| ----------------- | ---------------- | ------------------------------------------------------------------- |
| `AutoField`       | 自增长整数字段   | `id = models.AutoField(primary_key=True)`                           |
| `CharField`       | 字符串字段       | `title = models.CharField(max_length=100)`                          |
| `BooleanField`    | 布尔类型字段     | `is_published = models.BooleanField(default=False)`                 |
| `DateField`       | 日期字段         | `published_date = models.DateField()`                               |
| `DateTimeField`   | 日期时间字段     | `created_at = models.DateTimeField(auto_now_add=True)`              |
| `DecimalField`    | 十进制数值字段   | `price = models.DecimalField(max_digits=6, decimal_places=2)`       |
| `EmailField`      | 电子邮件地址字段 | `email = models.EmailField()`                                       |
| `FileField`       | 文件上传字段     | `photo = models.FileField(upload_to='photos/')`                     |
| `FloatField`      | 浮点数字段       | `rating = models.FloatField()`                                      |
| `ForeignKey`      | 外键字段         | `author = models.ForeignKey(User, on_delete=models.CASCADE)`        |
| `ImageField`      | 图片上传字段     | `avatar = models.ImageField(upload_to='avatars/')`                  |
| `IntegerField`    | 整数字段         | `views = models.IntegerField(default=0)`                            |
| `ManyToManyField` | 多对多关系字段   | `tags = models.ManyToManyField(Tag)`                                |
| `OneToOneField`   | 一对一关系字段   | `profile = models.OneToOneField(Profile, on_delete=models.CASCADE)` |
| `TextField`       | 大文本字段       | `content = models.TextField()`                                      |
| `TimeField`       | 时间字段         | `published_time = models.TimeField()`                               |

```python
from django.db import models

class UserGroup(models.Model):
    uid = models.AutoField(primary_key=True)

    name = models.CharField(max_length=32,null=True, blank=True)
    email = models.EmailField(max_length=32)
    text = models.TextField()

    ctime = models.DateTimeField(auto_now_add=True)      # 只有添加时才会更新时间
    uptime = models.DateTimeField(auto_now=True)         # 只要修改就会更新时间

    ip1 = models.IPAddressField()                  # 字符串类型，Django Admin以及ModelForm中提供验证 IPV4 机制
    ip2 = models.GenericIPAddressField()           # 字符串类型，Django Admin以及ModelForm中提供验证 Ipv4和Ipv6

    active = models.BooleanField(default=True)

    data01 = models.DateTimeField()              # 日期+时间格式 YYYY-MM-DD HH:MM[:ss[.uuuuuu]][TZ
    data02 = models.DateField()                 # 日期格式      YYYY-MM-DD
    data03 = models.TimeField()                 # 时间格式      HH:MM[:ss[.uuuuuu]]

    age = models.PositiveIntegerField()           # 正小整数 0 ～ 32767
    balance = models.SmallIntegerField()          # 小整数 -32768 ～ 32767
    money = models.PositiveIntegerField()         # 正整数 0 ～ 2147483647
    bignum = models.BigIntegerField()           # 长整型(有符号的) -9223372036854775808 ～ 9223372036854775807

    user_type_choices = (
        (1, "超级用户"),
        (2, "普通用户"),
        (3, "普普通用户"),
    )
    user_type_id = models.IntegerField(choices=user_type_choices, default=1)
```

#### 表字段参数及说明

| 字段属性          | 用途                     | 示例                                                                               |
| ----------------- | ------------------------ | ---------------------------------------------------------------------------------- |
| `null`            | 是否可以为空             | `name = models.CharField(max_length=100, null=True)`                               |
| `blank`           | 是否可以为空白           | `description = models.TextField(blank=True)`                                       |
| `default`         | 默认值                   | `is_published = models.BooleanField(default=False)`                                |
| `primary_key`     | 是否为主键               | `id = models.AutoField(primary_key=True)`                                          |
| `db_column`       | 字段在数据库中的列名     | `first_name = models.CharField(max_length=50, db_column='first')`                  |
| `unique`          | 是否唯一                 | `email = models.EmailField(unique=True)`                                           |
| `db_index`        | 是否在数据库中创建索引   | `name = models.CharField(max_length=100, db_index=True)`                           |
| `verbose_name`    | 字段的可读名称           | `title = models.CharField(max_length=100, verbose_name='文章标题')`                |
| `related_name`    | 关联模型的反向引用名称   | `author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts')` |
| `max_length`      | 最大长度限制             | `title = models.CharField(max_length=100)`                                         |
| `choices`         | 选项列表                 | `status = models.CharField(choices=STATUS_CHOICES, max_length=20)`                 |
| `on_delete`       | 级联删除行为             | `author = models.ForeignKey(User, on_delete=models.CASCADE)`                       |
| `upload_to`       | 上传文件保存路径         | `photo = models.FileField(upload_to='photos/')`                                    |
| `auto_now`        | 自动更新为当前时间       | `modified_at = models.DateTimeField(auto_now=True)`                                |
| `auto_now_add`    | 创建时自动设置为当前时间 | `created_at = models.DateTimeField(auto_now_add=True)`                             |
| `editable`        | 是否可编辑               | `views = models.IntegerField(default=0, editable=False)`                           |
| `help_text`       | 字段的帮助文本           | `content = models.TextField(help_text='请输入文章内容')`                           |
| `db_table`        | 指定表名                 | `class Meta: db_table = 'my_table'`                                                |
| `unique_together` | 多个字段组合唯一         | `class Meta: unique_together = [['field1', 'field2']]`                             |
| `db_constraint`   | 是否在数据库中创建约束   | `author = models.ForeignKey(User, on_delete=models.CASCADE, db_constraint=False)`  |

> 参考官方文档：https://docs.djangoproject.com/zh-hans/4.2/ref/models/fields/。

### 2.3 数据表的关系

一个模型对应目标数据库的一个数据表，但我们知道，每个数据表之间是可以存在关联的，表与表之间有三种关系：

- 一对一
- 一对多
- 多对多

#### 一对一

一对一的关系，就很简单了，彼此唯一。

##### 如何建立关联

**一对一的关系 ： 创建关联字段(任意一张表创建都可以), 一般情况下，在重要的表创建关联字段**

一对一存在于在两个数据表中，第一个表的某一行数据只与第二个表的某一行数据相关，同时第二个表的某一行数据也只与第一个表的某一行数据相关，这种表关系被称为一对一关系，以下列为例：

比如 Performer 和 Performer_info 是一对一的关系。

```python
from django.db import models


# 一对一关系
class Performer(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20)
    nationality = models.CharField(max_length=20)
    masterpiece = models.CharField(max_length=50)


class Performer_info(models.Model):
    id = models.IntegerField(primary_key=True)
    performer = models.OneToOneField(to=Performer,to_field="id", on_delete=models.CASCADE)
    birth = models.CharField(max_length=20)
    elapse = models.CharField(max_length=20)
```

- OneToOneField 表示创建一对一关系。
- to 表示需要和哪张表创建关系
- to_field 表示关联字段
- on_delete=models.CASCADE 表示级联删除。假设 a 表删除了一条记录，b 表也还会删除对应的记录。

performer 表示关联字段，但是 ORM 创建表的时候，会自动添加\_id 后缀。那么关联字段为 performer_id

> 注意：创建一对一关系，会将关联字添加唯一属性。比如：performer_id

使用 DJango 的管理工具 manage.py 创建数据表 Performer 和 Performer_info,创建数据表前最好先删除 0001_initial.py 文件并清空数据库里的数据表。

然后重新执行数据迁移。如下

```sh
python manage.py makemigrations --empty index
python manage.py makemigrations
python manage.py migrate
```

#### 一对多

比如 book 和 publish 。一本书不能对应多个出版社(常规是这样的,否则就盗版了),那么不成立。

一个出版社可以对应多本书，关系线成立。所以 book 和 publish 表的关系是一对多的关系。

##### 如何建立关联

**一对多：一旦确定一对多的关系：在多的表中创建关联字段**

示例：

```python
class Publish(models.Model):
    name=models.CharField(max_length=32)
    email=models.CharField(max_length=32)
    addr=models.CharField(max_length=32)

class Book(models.Model):
    title=models.CharField(max_length=32,unique=True)
    price=models.DecimalField(max_digits=8,decimal_places=2,null=True)
    pub_date=models.DateField()
    # 与Publish建立一对多的关系,外键字段建立在多的一方
    publish=models.ForeignKey(to="Publish",to_field="id",on_delete=models.CASCADE)
    # 与Author表建立多对多的关系,ManyToManyField可以建在两个模型中的任意一个，自动创建关系表book_authors
    authors=models.ManyToManyField(to="Author")
```

- ForeignKey 表示建立外键
- to 表示需要和哪张表创建关系
- to_field 表示关联字段
- on_delete=models.CASCADE 表示级联删除。使用 ForeignKey 必须要加 on_delete。否则报错。这是 2.x 规

一对多存在于两个或两个以上的数据表中，第一个表的数据可以与第二个表的一道多行数据进行关联，但是第二个表的每一行数据只能与第一个表的某一行进行管理，以下列表为例：

```python
#一对多关系
class Performer(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20)
    nationality = models.CharField(max_length=20)
    masterpiece = models.CharField(max_length=50)

class Program(models.Model):
    id = models.IntegerField(primary_key=True)
    performer = models.ForeignKey(Performer,on_delete=models.CASCADE)
    name = models.CharField(max_length=20)
```

使用 Django 的管理工具 manage.py 创建数据表 Performer 和 Program，创建数据表前最好先删除 0001_initial.py 文件并清空数据库里的数据表。数据表的表关系如图：

然后重新执行数据迁移。如下

```sh
python manage.py makemigrations --empty index
python manage.py makemigrations
python manage.py migrate
```

#### 多对多

多对多存在于两个或两个以上的数据表中，第一个表的某一行数据可以与第二个表的一到多行数据进行关联，同时在第二个表中的某一行数据也可以与第一个表的一到多行数据进行关联。

多对多关系会在两张表的基础之上，新增一个映射表。

##### 如何建立关联

**多对多：一旦确定多对多的关系：创建第三张关系表**

```python
#多对多
class Performer(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20)
    nationality = models.CharField(max_length=20)
    masterpiece = models.CharField(max_length=50)

class Manytomany(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20)
    performer = models.ManyToManyField(Performer)
```

```python
from django.db import models

# Create your models here.

class Book(models.Model):
    title=models.CharField(max_length=32,unique=True)
    price=models.DecimalField(max_digits=8,decimal_places=2,null=True)
    pub_date=models.DateField()
    # 与Publish建立一对多的关系,外键字段建立在多的一方
    publish=models.ForeignKey(to="Publish",to_field="id",on_delete=models.CASCADE)
    # 与Author表建立多对多的关系,ManyToManyField可以建在两个模型中的任意一个，自动创建关系表book_authors
    authors=models.ManyToManyField(to="Author")

class Publish(models.Model):
    name=models.CharField(max_length=32)
    email=models.CharField(max_length=32)
    addr=models.CharField(max_length=32)


class Author(models.Model):
    name=models.CharField(max_length=32)
    age=models.IntegerField()
    # 与AuthorDetail建立一对一的关系
    # ad=models.ForeignKey(to="AuthorDetail",to_field="id",on_delete=models.CASCADE,unique=True)
    ad=models.OneToOneField(to="AuthorDetail",to_field="id",on_delete=models.CASCADE,)


class AuthorDetail(models.Model):
    gf=models.CharField(max_length=32)
    tel=models.CharField(max_length=32)
```

### 2.4 数据表的 CRUD

index 的 models.py 文件中定义模型如下：

```python
from django.db import models


# Create your models here.
# 创建产品分类表
class Type(models.Model):
    id = models.AutoField(primary_key=True)
    type_name = models.CharField(max_length=20)


# 创建产品信息表
class Product(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50)
    weight = models.CharField(max_length=20)
    size = models.CharField(max_length=20)
    type = models.ForeignKey(Type, on_delete=models.CASCADE)
```

首先插入测试数据

```sql
INSERT INTO `index_type` VALUES (1, '手机');
INSERT INTO `index_type` VALUES (2, '平板电脑');
INSERT INTO `index_type` VALUES (3, '智能穿戴');
INSERT INTO `index_type` VALUES (4, '其他配置');

INSERT INTO `index_product` VALUES (1, 'Pluots', 'g', 'M', 3);
INSERT INTO `index_product` VALUES (2, 'Huawei v1', 'g', 'XXL', 2);
INSERT INTO `index_product` VALUES (3, 'Khwi plus', 'g', 'XL', 2);
INSERT INTO `index_product` VALUES (4, 'omni-Mango', 'g', 'S', 1);
INSERT INTO `index_product` VALUES (5, 'Apfle', 'g', 'XXL', 2);
INSERT INTO `index_product` VALUES (6, 'aluots plus', 'g', 'XXL', 3);
INSERT INTO `index_product` VALUES (7, 'Orange', 'g', 'XS', 3);
INSERT INTO `index_product` VALUES (8, 'Rhspberry', 'g', 'XS', 3);
INSERT INTO `index_product` VALUES (9, '华为荣耀 v9', 'g', 'XS', 3);
INSERT INTO `index_product` VALUES (10, 'Cheory', 'g', 'XL', 3);
INSERT INTO `index_product` VALUES (11, '荣耀V9', '111g', '120*75*7mm', 1);
INSERT INTO `index_product` VALUES (13, '荣耀V9', '111g', '120*75*7mm', 1);
```

在 MyDjango 项目中使用 shell 模式(启动命令行和执行脚本)进行讲述，该模式主要为方便开发人员开发和调式程序。在 PyCharm 的 Terminal 下开启 shell 模式，输入 python manage.py shell 指令即可开启。

```sh
(venv) PS D:\coder\python-project\MyDjango> python manage.py shell
>>> from index.models import *
>>> p = Product()
>>> p.name = "荣耀V9"
>>> p.weight = "111g"
>>> p.size = "120*75*7mm"
>>> p.type_id = 1
>>> p.save()
```

#### create

```sh
#方法一
#通过Django的ORM框架提供的API实现，使用create方法实现数据插入
from index.models import *
Product.objects.create(name='荣耀V9',weight='119g',size='120*75*7mm',type_id=1)


#方法二
#在实例化时直接设置属性值
p = Product(name='荣耀V9',weight='111g',size='120*75*7mm',type_id=1)
p.save()
```

#### update

```sh
p = Product.objects.get(id=9)
p.name = "华为荣耀 v9"
p.save()
```

除此之外，还可以使用 update 方法实现单条和多条数据的更新，使用方法如下：

```sh
#通过Django的ORM框架提供的API实现
#更新单条数据，查询条件filter使用于查询单条数据
Product.objects.filter(id=9).update(name='华为荣耀V10')
#更新多条数据，查询条件filter以列表格式返回，查询结果可能是一条或多条数据
Product.objects.filter(name='荣耀V9').update(name='华为荣耀V9')
#全表数据更新，不使用查询条件，默认对全表的数据进行更新
Product.objects.update(name='华为荣耀V9')
```

#### delete

删除一条数据

```sh
# 删除一条id为1的数据
p = Product.objects.get(id=1)
p.delete()
```

```sh
# 删除一条id为1的数据
Product.objects.get(id=1).delete()
```

删除多条数据

```sh
Product.objects.filter(weight='119g').delete()
```

删除表中全部数据

```sh
Product.objects.all().delete()
```

数据删除有 ORM 框架的 delete 方法实现。

从数据的删除和更新可以看到这两种数据操作都使用查询条件 get 和 filter，查询条件 get 和 filter 的区别如下：

| 方法   | 说明                                                                                                                                           |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| get    | 查询字段必须是主键或者唯一约束的字段，并且查询的数据必须存在，如果查询的字段有重复值或者查询的数据不存在，程序都会抛出异常信息。               |
| filter | 查询字段没有限制，只要该字段是数据表的某一字段即可。查询结果以列表的形式返回，如果查询结果为空（查询的数据在数据库中找不到），就返回空列表[]。 |

#### Read

数据查询是数据库操作中最为复杂并且内容最多的部分，我们以代码的形式来讲述如何通过 ORM 框架提供的 API 实现数据查询，代码如下：

```sh
In [39]: from index.models import *
#全表查询，等同于SQL语句Select * from index_product,数据以类不形式返回
In [40]: p = Product.objects.all()

In [41]: p[1].name
Out[41]: '华为荣耀V9'

#查询前5条数据，等同于SQL语句Select * from index_product LIMIT 5
#SQL语句里面的LIMIT方法，在Django中使用Python的列表截取分解即可实现
In [43]: p = Product.objects.all()[:5]

In [44]: p


#查询某个字段，等同于SQL语句Select  name from index_product
#values方法，以列表形式返回数据，列表元素以字典格式表示
In [45]: p = Product.objects.values('name')

In [46]: p[1]['name']
Out[46]: '华为荣耀V9'

#values_list方法，以列表表示返回数据，列表元素以元组格式表示
In [47]: p = Product.objects.values_list('name')[:3]

In [48]: p
Out[48]: <QuerySet [('华为荣耀V9',), ('华为荣耀V9',), ('华为荣耀V9',)]>

#使用get方法查询数据，等于同SQL语句Select * from index_product where id=2
In [49]: p = Product.objects.get(id = 2)

In [50]: p.name
Out[50]: '华为荣耀V9'

#使用filter方法查询数据，注意区分get和filter的差异
In [51]: p = Product.objects.filter(id = 2)

In [52]: p[0].name
Out[52]: '华为荣耀V9'


#SQL的 and查询主要在filter里面添加多个查询条件
In [53]: p = Product.objects.filter(name='华为荣耀V9',id=9)

In [54]: p
Out[54]: <QuerySet [<Product: Product object (9)>]>


#SQL的or查询，需要引入Q，编写格式Q(field=value)|Q(field=value)
#等同于SQL语句Select * from index_product where name='华为荣耀V9‘ or id=9
In [55]: from django.db.models import Q

In [57]: p = Product.objects.filter(Q(name='华为荣耀V')|Q(id=9))

In [58]: p
Out[58]: <QuerySet [<Product: Product object (9)>]>

#使用count方法统计查询数据的数据量
In [63]: p = Product.objects.filter(name='华为荣耀V9').count()

In [64]: p
Out[64]: 8

#去重查询，distinct方法无需设置参数，去重方式根据values设置的字段执行
#等同SQL语句Select DISTINCT name from index_product where name='华为荣耀V9’
In [65]: p = Product.objects.values('name').filter(name='华为荣耀V9').distinct()

In [66]: p
Out[66]: <QuerySet [{'name': '华为荣耀V9'}]>


#根据字段id降序排列，降序只要在order_by里面的字段前面加"-即可"
#order_by可设置多字段排序，如Product.objects.order_by('-id', 'name')
In [67]: p = Product.objects.order_by('-id')

In [68]: p
Out[68]: <QuerySet [<Product: Product object (11)>, <Product: Product object (9)>, <Product: Product object (8)>, <Product: Product object (7)>, <Product: Product object (5)>, <Product: Product object (4)>, <Product: Product object (3)>, <Product: Product object (2)>]>

#聚合查询，实现对数据值求和、求平均值等。Django提供annotate和aggregate方法实现
#annotate类似于SQL里面的GROUP BY方法，如果不设置values，就会默认对主键进行GROUP BY分组
#等同于SQL语句Select name,SUM(id) AS 'id_sum' from index_product GROUP BY NAME ORDER BY NULL
In [69]: from django.db.models import Sum, Count

In [70]: p = Product.objects.values('name').annotate(Sum('id'))
In [71]: print(p.query)
SELECT "index_product"."name", SUM("index_product"."id") AS "id__sum" FROM "index_product" GROUP BY "index_product"."name"

#aggregate是将某个字段的值进行计算并置返回技术结果
#等同于SQL语句Select COUNT(id) AS 'id_count' from index_product
In [72]: from django.db.models import Count

In [73]: p = Product.objects.aggregate(id_count=Count('id'))

In [74]: p
Out[74]: {'id_count': 8}
```

上述代码将是了日常开发中常用的数据查询方法，但又时候需要设置不同的查询条件来满足多方面的查询要求。上述例子中，查询条件 filter 和 get 使用等值的方法来匹配结果。若想使用大于、不等于和模糊查询的匹配方法，则可以使用如下表所以的匹配附实现：

| 匹配符          | 使用                               | 说明                              |
| --------------- | ---------------------------------- | --------------------------------- |
| `__exact`       | `filter(name__exact='荣耀')`       | 精确等于，如 SQL 的 like ‘荣耀’   |
| `__iexact`      | `filter(name__iexact='荣耀')`      | 精确等于并忽略大小写              |
| `__contains`    | `filter(name__contains='荣耀')`    | 模糊匹配，如 SQL 的 like '%荣耀%' |
| `__icontains`   | `filter(name__icontains='荣耀')`   | 模糊匹配，忽略大小写              |
| `__gt`          | `filter(id__gt=5)`                 | 大于                              |
| `__gte`         | `filter(id__gte=5)`                | 大于等于                          |
| `__lt`          | `filter(id__lt=5)`                 | 小于                              |
| `__lte`         | `filter(id__lte=5)`                | 小于等于                          |
| `__in`          | `filter(id__in=[1,2,3])`           | 判断是否在列表内                  |
| `__startswith`  | `filter(name__startswith='荣耀')`  | 以...开头                         |
| `__istartswith` | `filter(name__istartswith='荣耀')` | 以...开头并忽略大小写             |
| `__endswith`    | `filter(name__endswith='荣耀')`    | 以...结尾                         |
| `__iendswith`   | `filter(name__iendswith='荣耀')`   | 以...结尾并忽略大小写             |
| `__range`       | `filter(name__range='荣耀')`       | 在...范围内                       |
| `__year`        | `filter(date__year=2018)`          | 日期字段的年份                    |
| `__month`       | `filter(date__month=12)`           | 日期字段的月份                    |
| `__day`         | `filter(date__day='')`             | 日期字段的天数                    |
| `__isnull`      | `filter(name__isnull=True/False)`  | 判断是否为空                      |

从表中可以看到，只要在查询的字段后添加相应的匹配符，就能实现多种不同的数据查询，如`filter(id__gt=9)`用于获取字段 id 大于 9 的数据，在 shell 模式下使用该匹配符进行数据查询，代码如下：

```sh
In [75]: from index.models import *

In [76]: p = Product.objects.filter(id__gt=9)

In [77]: p
Out[77]: <QuerySet [<Product: Product object (10)>, <Product: Product object (11)>, <Product: Product object (13)>]>

>>> for product in p:
...     print(f"Product: {product.name}, {product.weight}, {product.size}")
...
Product: Cheory, g, XL
Product: 荣耀V9, 111g, 120*75*7mm
Product: 荣耀V9, 111g, 120*75*7mm
```

#### 多表查询

一对多或一对一的表关系是通过外键实现关联的，而多表查询分为正向查询和反向查询。以模型 Product 和 Type 为例：

1、如果查询对象的主体是模型 Type，要查询模型 Type 的数据，那么该查询成为正向查询。

2、如果查询对象的主体是模型 Type，要通过模型 Type 查询模型 Product 的数据，那么该查询称为反向查询。

无论是正向查询还是反向查询，两者的实现方法大致相同，代码如下：

```sh
(venv) PS D:\coder\python-project\MyDjango> python manage.py shell
>>> from index.models import *
# 正向查询
>>> t = Type.objects.filter(product__id=9)
>>> t
<QuerySet [<Type: Type object (3)>]>
>>> t[0].type_name
'智能穿戴'

# 反向查询
>>> t[0].product_set.values('name')
<QuerySet [{'name': 'Pluots'}, {'name': 'aluots plus'}, {'name': 'Orange'}, {'name': 'Rhspberry'}, {'name': '华为荣耀 v9'}, {'name': 'Cheory'}]>
```

从上面的代码分析，因为正向查询的查询对象主体和查询的数据都来自于模型 Type,因此正向查询在数据库中只执行了一次 SQL 查询。

而反向查询通过 `t[0].product_set.values('name')` 来获取模型 Product 的数据，因此反向查询执行了两次 SQL 查询，首先查询模型 Type 的数据，然后根据第一次查询的结果再查询与模型
Product 相互关联的数据。

为了减少反向查询的查询次数，我们可以使用 select_related 方法实现，该方法只执行一次 SQL 查询就能达到反向查询的效果。select_related 使用方法如下：

查询模型 Product 的字段 name 和模型 Type 的字段 type_name

```sh
# >>> p = Product.objects.select_related('type').values('name','type__type_name')
# >>> print(p.query)
# SELECT `index_product`.`name`, `index_type`.`type_name` FROM `index_product` INNER JOIN `index_type` ON (`index_product`.`type_id` = `index_type`.`id`)

>>> from index.models import *
>>> Product.objects.select_related('type').values('name','type__type_name')
<QuerySet [{'name': 'omni-Mango', 'type__type_name': '手机'}, {'name': '荣耀V9', 'type__type_name': '手机'}, {'name': '荣耀V9', 'type__type_name': '手机'}, {'name': 'Huawei v1', 'type__type_name':
 '平板电脑'}, {'name': 'Khwi plus', 'type__type_name': '平板电脑'}, {'name': 'Apfle', 'type__type_name': '平板电脑'}, {'name': 'Pluots', 'type__type_name': '智能穿戴'}, {'name': 'aluots plus', 'ty
pe__type_name': '智能穿戴'}, {'name': 'Orange', 'type__type_name': '智能穿戴'}, {'name': 'Rhspberry', 'type__type_name': '智能穿戴'}, {'name': '华为荣耀 v9', 'type__type_name': '智能穿戴'}, {'name': 'Cheory', 'type__type_name': '智能穿戴'}]>
```

查询两个模型的全部数据

```sh
# >>> p = Product.objects.select_related('type').all()
# >>> print(p.query)
# SELECT `index_product`.`id`, `index_product`.`name`, `index_product`.`weight`, `index_product`.`size`, `index_product`.`type_id`, `index_type`.`id`, `index_type`.`type_name` FROM `index_product` INNER JOIN `index_type` ON (`index_product`.`type_id` = `index_type`.`id`)
>>> from index.models import *
>>> Product.objects.select_related('type').all()
<QuerySet [<Product: Product object (4)>, <Product: Product object (11)>, <Product: Product object (13)>, <Product: Product object (2)>, <Product: Product object (3)>, <Product: Product object (5)>, <Product: Product object (1)>, <Product: Product object (6)>, <Product: Product object (7)>, <Product: Product object (8)>, <Product: Product object (9)>, <Product: Product object (10)>]>
```

获取两个模型的数据，以模型 Product 的 id 大于 8 为查询条件

```sh
# >> p = Product.objects.select_related('type').filter(id__gt=8)
# #输出SQL查询语句
# >>> print(p.query)
# SELECT `index_product`.`id`, `index_product`.`name`, `index_product`.`weight`, `index_product`.`size`, `index_product`.`type_id`, `index_type`.`id`, `index_type`.`type_name` FROM `index_product` INNER JOIN `index_type` ON (`index_product`.`type_id` = `index_type`.`id`) WHERE `index_product`.`id` > 8

>>> Product.objects.select_related('type').filter(id__gt=8)
<QuerySet [<Product: Product object (9)>, <Product: Product object (10)>, <Product: Product object (11)>, <Product: Product object (13)>]>
```

获取两模型数据，以模型 Type 的 type_name 字段等于手机为查询条件

```sh
# >>> p = Product.objects.select_related('type').filter(type__type_name='手机').all()
# >>> print(p.query)
# SELECT `index_product`.`id`, `index_product`.`name`, `index_product`.`weight`, `index_product`.`size`, `index_product`.`type_id`, `index_type`.`id`, `index_type`.`type_name` FROM `index_product` INNER JOIN `index_type` ON (`index_product`.`type_id` = `index_type`.`id`) WHERE `index_type`.`type_name` = 手机
>>> Product.objects.select_related('type').filter(type__type_name='手机').all()
<QuerySet [<Product: Product object (4)>, <Product: Product object (11)>, <Product: Product object (13)>]>
>>> p = Product.objects.select_related('type').filter(type__type_name='手机').all()
#输出模型Product信息
>>> p[0]
<Product:Product object (1)>
#输出模型Product所关联模型Type的信息
>> p[0].type
<Type:Type object (1)>
>> p[0].type.type_name
手机·
```

select related 的使用说明如下：

- 以模型 Product 作为查询对象主体，当然也可以使用模型 Type,只要两表之间有外键关联即可。
- 设置 select_related 的参数值为“type”,该参数值是模型 Product 定义的 type 字段。
- 如果在查询过程中需要使用另一个数据表的字段，可以使用 `"外键__字段名"` 来指向该表的字段。如 `type__type_name` 代表由模型 Product 的外键 type 指向模型 Type 的字段 type*name ,type 代表模型 Product 的外键 type,双下画线“*”代表连接符，type_name 是模型 Type 的字段。

除此之外，select_related 还可以支持三个或三个以上的数据表同时查询，以下面的例子进行说明。

```python
from django.db import models


# 省份信息表
class Province(models.Model):
    name = models.CharField(max_length=10)


# 城市信息表
class City(models.Model):
    name = models.CharField(max_length=5)
    province = models.ForeignKey(Province, on_delete=models.CASCADE)


# 人物信息表
class Person(models.Model):
    name = models.CharField(max_length=10)
    living = models.ForeignKey(City, on_delete=models.CASCADE)
```

然后重新执行数据迁移。如下

```sh
python manage.py makemigrations
python manage.py migrate
```

在上述模型中，模型 Person 通过外键 living 关联模型 City，模型 City 通过外键 province 关联模型 Province，从而使三个模型形成一种递进关系。

例如查询张三现在所居住的省份，首先通过模型 Person 和模型 City 查出张三所居住的城市，然后通过模型 City 和模型 Province 查询当前城市所属的省份。因此，select_related 的实现方法如下：

首先生成测试数据

```sql
INSERT INTO `mydjango`.`index_province` (`id`, `name`) VALUES (11, '湖北省');
INSERT INTO `mydjango`.`index_province` (`id`, `name`) VALUES (12, '广东省');
INSERT INTO `mydjango`.`index_city` (`id`, `name`, `province_id`) VALUES (1, '武汉', 11);
INSERT INTO `mydjango`.`index_city` (`id`, `name`, `province_id`) VALUES (2, '深圳', 12);
INSERT INTO `mydjango`.`index_person` (`id`, `name`, `living_id`) VALUES (1, '胡建力', 1);
INSERT INTO `mydjango`.`index_person` (`id`, `name`, `living_id`) VALUES (2, '胡小建', 2);
```

```sh
(venv) PS D:\coder\python-project\MyDjango> python manage.py shell
>>> from index.models import *
>>> p = Person.objects.select_related('living__province').get(name='胡建力')
>>> p.living.province
<Province: Province object (11)>
>>> p.living.province.name
'湖北省'
```

在上述例子可以发现，通过设置 select_related 的参数值即可实现三个或三个以上的多表查询。例子中的参数值为 `living__province`, 参数值说明如下：

1、living 是模型 Person 的字段，该字段指向模型 City。

2、province 是模型 City 的字段，该字段指向模型 Province

3、两个字段之间使用双下划线连接并且两个字段都是指向另一个模型的，这说明在查询过程中，模型 Person 的字段 living 指向模型 City，再从模型 City 的字段 province 指向模型 Province，从而实现两个或三个以上的多表查询。

## 3. 使用 Django 开发 REST 接口

```sh
git chekout -b "django-json"
```

我们以在 Django 框架中使用的图书英雄案例来写一套支持图书数据增删改查的 REST API 接口，来理解 REST API 的开发。

在此案例中，前后端均发送 JSON 格式数据, 使用视图基类 View 。

##### 基本配置

```sh
#创建虚拟环境
python -m venv bookv1
cd bookv1

# 激活虚拟环境
source bin/activite
# 此时就可以在虚拟环境中使用pip install <package_name>来安装python包了

# 创建项目
(venv)# pip install django==4.2.7
(venv)# django-admin startproject bookv1
# 创建app
(venv)# python manage.py startapp app
```

`bookv1/settings.py`

```python
# 设置时区
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'
USE_I18N = True
USE_L10N = True
USE_TZ = False

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app.apps.AppConfig',
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'book_demo',
        'HOST': '127.0.0.1',
        'USER': 'root',
        'PASSWORD': 'oschina',
        'PORT': '3306',
        "OPTIONS": {"init_command": "SET default_storage_engine=INNODB;"}
    }
}
```

##### 模型

`app/models.py`

```python
from django.db import models


# Create your models here.
# 定义图书模型类BookInfo
class BookInfo(models.Model):
    btitle = models.CharField(max_length=20, verbose_name='名称')
    bpub_date = models.DateField(verbose_name='发布日期')
    bread = models.IntegerField(default=0, verbose_name='阅读量')
    bcomment = models.IntegerField(default=0, verbose_name='评论量')
    is_delete = models.BooleanField(default=False, verbose_name='逻辑删除')
    # 注意,如果模型已经迁移建表并且表中如果已经有数据了,那么后新增的字段,必须给默认值或可以为空,不然迁移就报错
    # upload_to 指定上传到media_root配置项的目录中再创建booktest里面
    image = models.ImageField(upload_to='booktest', verbose_name='图片', null=True)


    class Meta:
        db_table = 'tb_books'  # 指明数据库表名
        verbose_name = '图书'  # 在admin站点中显示的名称
        verbose_name_plural = verbose_name  # 显示的复数名称

    def __str__(self):
        """定义每个数据对象的显示信息"""
        return self.btitle

    def pub_date_format(self):
        return self.bpub_date.strftime('%Y-%m-%d')
    # 修改方法名在列表界面的展示
    pub_date_format.short_description = '发布日期'
    # 指定自定义方法的排序依据
    pub_date_format.admin_order_field = 'bpub_date'


# 定义英雄模型类HeroInfo
class HeroInfo(models.Model):
    GENDER_CHOICES = (
        (0, 'female'),
        (1, 'male')
    )
    hname = models.CharField(max_length=20, verbose_name='名称')
    hgender = models.SmallIntegerField(choices=GENDER_CHOICES, default=0, verbose_name='性别')
    hcomment = models.CharField(max_length=200, null=True, verbose_name='描述信息')
    hbook = models.ForeignKey(BookInfo, on_delete=models.CASCADE, verbose_name='图书')  # 外键
    is_delete = models.BooleanField(default=False, verbose_name='逻辑删除')

    class Meta:
        db_table = 'tb_heros'
        verbose_name = '英雄'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.hname

    def read(self):
        return self.hbook.bread
    read.short_description = '阅读量'
    read.admin_order_field = 'hbook__bread'
    # HeroInfo.objects.filter(hbook__bread=xx)
```

迁移数据库命令，如下

```sh
python manage.py makemigrations
python manage.py migrate
```

首先插入一些测试数据,如下

```sql
insert into tb_books(btitle,bpub_date,bread,bcomment,is_delete) values
('射雕英雄传','1980-05-01',12,34,0),
('天龙八部','1986-07-24',36,40,0),
('笑傲江湖','1995-12-24',20,80,0),
('雪山飞狐','1987-11-11',58,24,0);
```

```sql
insert into tb_heros(hname,hgender,hbook_id,hcomment,is_delete) values
('郭靖',1,1,'降龙十八掌',0),
('黄蓉',0,1,'打狗棍法',0),
('黄药师',1,1,'弹指神通',0),
('欧阳锋',1,1,'蛤蟆功',0),
('梅超风',0,1,'九阴白骨爪',0),
('乔峰',1,2,'降龙十八掌',0),
('段誉',1,2,'六脉神剑',0),
('虚竹',1,2,'天山六阳掌',0),
('王语嫣',0,2,'神仙姐姐',0),
('令狐冲',1,3,'独孤九剑',0),
('任盈盈',0,3,'弹琴',0),
('岳不群',1,3,'华山剑法',0),
('东方不败',0,3,'葵花宝典',0),
('胡斐',1,4,'胡家刀法',0),
('苗若兰',0,4,'黄衣',0),
('程灵素',0,4,'医术',0),
('袁紫衣',0,4,'六合拳',0);
```

##### 视图

`app/views.py`

```python
import json
from datetime import datetime
from django.http import JsonResponse, HttpResponse
from django.views import View
from .models import BookInfo, HeroInfo

"""

# 书籍信息
GET         /api/books/
POST        /api/books/
GET         /api/books/<pk>/
PUT         /api/books/<pk>/
DELETE      /api/books/<pk>/

# 人物信息
GET         /api/heros/
POST        /api/heros/
GET         /api/heros/<pk>/
PUT         /api/heros/<pk>/
DELETE      /api/heros/<pk>/


响应数据  JSON
# 列表视图: 路由后边没有 pk/ID
# 详情视图: 路由后面   pk/ID
"""


class BooksAPIVIew(View):
    """
    查询所有图书、增加图书
    """

    def get(self, request):
        """
        查询所有图书
        路由：GET /api/books/
        """
        # 1. 查询出所有图书模型
        queryset = BookInfo.objects.all()
        # 2. 遍历查询集，去除里边的每个书籍模型对象，把模型对象转换成字典
        # 定义一个列表保存所有字典
        book_list = []
        for book in queryset:
            book_dict = {
                'id': book.id,
                'btitle': book.btitle,
                'bput_date': book.bpub_date,
                'bread': book.bcomment,
                'image': book.image.url if book.image else '',
            }
            book_list.append(book_dict)  # 将转换好的字典添加到列表中
        # 3. 响应给前端
        # 如果book_list 不是一个字典的话就需要将safe设置成False.
        return JsonResponse(book_list, safe=False)

    def post(self, request):
        """
        新增图书
        路由：POST /api/books/
        """
        # 获取前端传入的请求体数据(json) request.body
        json_bytes = request.body
        # 把bytes类型的json字符串转换成json_str
        json_str = json_bytes.decode()
        # 利用json.loads将json字符串转换为json（字典/列表）
        book_dict = json.loads(json_str)

        # 此处详细的校验参数省略
        # 创建模型对象并保存（把字典转换成模型并储存）
        book = BookInfo(
            btitle=book_dict['btitle'],
            bpub_date=book_dict['bpub_date'],

        )
        book.save()

        # 把新增的模型转换成字典
        json_dict = {
            'id': book.id,
            'btitle': book.btitle,
            'bput_date': book.bpub_date,
            'bread': book.bread,
            'bcomment': book.bcomment,
            'image': book.image.url if book.image else '',
        }
        # 响应（把新增的数据再响应回去，201）
        return JsonResponse(json_dict, status=201)


class BookAPIView(View):
    """详情视图"""

    def get(self, request, pk):
        """
        获取单个图书信息
        路由： GET  /api/books/<pk>/
        """
        try:
            book = BookInfo.objects.get(id=pk)
        except BookInfo.DoesNotExist:
            return JsonResponse({'message': '查询的数据不存在'}, status=404)
        # 2. 模型对象转字典
        book_dict = {
            'id': book.id,
            'btitle': book.btitle,
            'bput_date': book.bpub_date,
            'bread': book.bread,
            'bcomment': book.bcomment,
            'image': book.image.url if book.image else '',
        }
        # 3. 响应
        return JsonResponse(book_dict)

    def put(self, request, pk):
        """
        修改图书信息
        路由： PUT  /api/books/<pk>
        """
        try:
            book = BookInfo.objects.get(id=pk)
        except BookInfo.DoesNotExist:
            return JsonResponse({'message': '修改的数据不存在'}, status=404)

        # 获取前端传入的新数据（把数据转换成字典）
        # json_str_bytes = request.body
        # json_str = json_str_bytes.decode()
        # book_dict = json.loads(json_str)

        # 此处详细的校验参数省略
        book_dict = json.loads(request.body.decode())
        # 重新给模型指定的属性赋值
        book.btitle = book_dict['btitle']
        book.bpub_date = book_dict['bpub_date']
        # 调用save方法进行修改操作
        book.save()
        # 把修改后的模型再转换成字典
        json_dict = {
            'id': book.id,
            'btitle': book.btitle,
            'bput_date': book.bpub_date,
            'bread': book.bread,
            'bcomment': book.bcomment,
            'image': book.image.url if book.image else '',
        }
        # 响应
        return JsonResponse(json_dict)

    def delete(self, request, pk):
        """
        删除图书
        路由： DELETE /api/books/<pk>/
        """
        # 获取要删除的模型对象
        try:
            book = BookInfo.objects.get(id=pk)
        except BookInfo.DoesNotExist:
            return JsonResponse({'message': '删除的数据不存在'}, status=404)
        # 删除指定模型对象
        # book.delete()  # 物理删除（真正从数据库删除）
        book.is_delete = True
        book.save()  # （逻辑删除）
        # 响应：删除时不需要有响应体但要指定状态码为 204
        return HttpResponse(status=204)


class HerosAPIVIew(View):
    """
    查询所有人物信息，新增人物
    """

    def get(self, request):
        """
        查询所有人物
        路由：GET /api/heros/
        """
        queryset = HeroInfo.objects.all()
        heros_list = []
        for hero in queryset:
            book_dict = {
                'id': hero.id,
                'hname': hero.hname,
                'hgender': hero.hgender,
                'hcomment': hero.hcomment,
                "hbookid": hero.hbook.id,
                "hbookBtitle": hero.hbook.btitle,
                "hbookBread": hero.hbook.bread
            }
            heros_list.append(book_dict)
        return JsonResponse(heros_list, safe=False)

    def post(self, request):
        """
        新增人物
        路由：POST /api/heros/
        """
        json_bytes = request.body
        json_str = json_bytes.decode()
        heros_dict = json.loads(json_str)

        # 获取关联的图书对象
        book_id = heros_dict['hbook']
        book = BookInfo.objects.get(id=book_id)

        # 创建英雄对象并保存到数据库
        hero = HeroInfo(
            hname=heros_dict['hname'],
            hgender=heros_dict['hgender'],
            hcomment=heros_dict['hcomment'],
            hbook=book,  # 将关联的图书对象赋值给外键属性
        )
        hero.save()
        json_dict = {
            'id': hero.id,
            'hname': hero.hname,
            'hgender': hero.hgender,
            'hcomment': hero.hcomment,
            'hbook': hero.hbook.btitle
        }
        return JsonResponse(json_dict, status=201)


class HeroAPIView(View):
    """详情视图"""

    def get(self, request, pk):
        """
        获取单个人物信息
        路由： GET  /api/heros/<pk>/
        """
        try:
            hero = HeroInfo.objects.get(id=pk)
        except BookInfo.DoesNotExist:
            return JsonResponse({'message': '查询的数据不存在'}, status=404)
        book_dict = {
            'id': hero.id,
            'hname': hero.hname,
            'hgender': hero.hgender,
            'hcomment': hero.hcomment,
            "hbookid": hero.hbook.id,
            "hbookBtitle": hero.hbook.btitle,
            "hbookBread": hero.hbook.bread
        }
        return JsonResponse(book_dict)

    def put(self, request, pk):
        """
        更新人物信息
        路由： PUT  /api/heros/<pk>
        """
        json_bytes = request.body
        json_str = json_bytes.decode()
        heros_dict = json.loads(json_str)

        try:
            # 获取需要更新的英雄对象
            hero = HeroInfo.objects.get(id=pk)
        except HeroInfo.DoesNotExist:
            return JsonResponse({'message': '修改的数据不存在'}, status=404)

        # 更新英雄信息
        hero.hname = heros_dict['hname']
        hero.hgender = heros_dict['hgender']
        hero.hcomment = heros_dict['hcomment']

        # 获取关联的图书对象
        book_id = heros_dict['hbook']
        book = BookInfo.objects.get(id=book_id)
        # 更新外键关联属性
        hero.hbook = book
        # 保存更新后的英雄对象
        hero.save()

        # 构造响应数据并返回
        json_dict = {
            'id': hero.id,
            'hname': hero.hname,
            'hgender': hero.hgender,
            'hcomment': hero.hcomment,
            'hbook': hero.hbook.btitle  # 将外键关联对象的名称进行序列化
        }
        return JsonResponse(json_dict, status=200)

    def delete(self, request, pk):
        """
        删除人物
        路由： DELETE /api/heros/<pk>/
        """
        try:
            hero = HeroInfo.objects.get(id=pk)
        except BookInfo.DoesNotExist:
            return JsonResponse({'message': '删除的数据不存在'}, status=404)
        # hero.delete()  # 物理删除（真正从数据库删除）
        hero.is_delete = True
        hero.save()  # （逻辑删除）
        # 响应：删除时不需要有响应体但要指定状态码为 204
        return HttpResponse(status=204)

```

##### 路由

`bookv1/urls.py`

```python
from django.contrib import admin
from django.urls import include, re_path, path
from app import urls

urlpatterns = [
    path('admin/', admin.site.urls),
    re_path('api/', include(urls)),
]
```

`app/urls.py`

```python
from django.urls import re_path
from . import views

urlpatterns = [
    # 书籍
    re_path(r'^books/$', views.BooksAPIVIew.as_view()),
    re_path(r'^books/(?P<pk>\d+)/$', views.BookAPIView.as_view()),
    # 人物
    re_path(r'^heros/$', views.HerosAPIVIew.as_view()),
    re_path(r'^heros/(?P<pk>\d+)/$', views.HeroAPIView.as_view()),

]
```

##### 启动应用

```sh
python manage.py runserver 0.0.0.0:8000
```

##### 使用 postman 测试接口

| 分类 | 方法                         | 详细                                                         | 接口是否可用         |
| ---- | ---------------------------- | ------------------------------------------------------------ | -------------------- |
| 图书 | GET<br>POST<br>PUT<br>DELETE | 获取图书列表<br>获取单个图书详细<br>修改图书信息<br>删除图书 | √<br>√<br>√<br>√<br> |
| 人物 | GET<br>POST<br>PUT<br>DELETE | 获取人物列表<br>获取单个人物详细<br>修改人物信息<br>删除人物 | √<br>√<br>√<br>√<br> |

Postman 发送请求示例

```sh
# GET 获取所有图书数据
http://127.0.0.1:8000/api/books

# GET 获取单一图书数据
http://127.0.0.1:8000/api/books/1

# POST 新增读书数据
http://127.0.0.1:8000/api/books/

# Body - raw json
{
    "btitle": "三国演义",
    "bpub_date": "1990-02-03"
}

# PUT 修改图书数据
http://127.0.0.1:8000/api/books/5/

# Body - raw json
{
    "btitle": "射雕英雄传2",
    "bpub_date": "1990-02-03"
}

# DELETE 删除图书数据
http://127.0.0.1:8000/api/books/5/

# ......
```

## 4. 明确 REST 接口开发的核心任务

分析一下上节的案例，可以发现，在开发 REST API 接口时，视图中做的最主要有三件事：

1.将请求的数据（如 JSON 格式）转换为模型类对象

2.操作数据库

3.将模型类对象转换为响应的数据（如 JSON 格式）

### 4.1 序列化

序列化 Serialization 简而言之，我们可以将序列化理解为：

将程序中的一个数据结构类型转换为其他格式（字典、JSON、XML 等），例如将 Django 中的模型类对象装换为 JSON 字符串，这个转换过程我们称为序列化。

```python
queryset = BookInfo.objects.all()
book_list = []
# 序列化
for book in queryset:
    book_list.append({
        'id': book.id,
        'btitle': book.btitle,
        'bpub_date': book.bpub_date,
        'bread': book.bread,
        'bcomment': book.bcomment,
        'image': book.image.url if book.image else ''
    })
return JsonResponse(book_list, safe=False)
```

反之，将其他格式（字典、JSON、XML 等）转换为程序中的数据，例如将 JSON 字符串转换为 Django 中的模型类对象，这个过程我们称为反序列化。

```python
json_bytes = request.body
json_str = json_bytes.decode()
```

### 4.2 反序列化

```python
book_dict = json.loads(json_str)
book = BookInfo.objects.create(
    btitle=book_dict.get('btitle'),
    bpub_date=datetime.strptime(book_dict.get('bpub_date'), '%Y-%m-%d').date()
)
```

我们可以看到，在开发 REST API 时，视图中要频繁的进行序列化与反序列化的编写。

总结 在开发 REST API 接口时，我们在视图中需要做的最核心的事是：

- 将数据库数据序列化为前端所需要的格式，并返回；
- 将前端发送的数据反序列化为模型类对象，并保存到数据库中

## 5. Django REST framework 简介

在序列化与反序列化时，虽然操作的数据不尽相同，但是执行的过程却是相似的，也就是说这部分代码是可以复用简化编写的。

在开发 RESTAPI 的视图中，虽然每个视图具体操作的数据不同，但增、删、改、查的实现流程基本套路化，所以这部分代码也是可以复用简化编写的：

1. 增：校验请求数据 -> 执行反序列化过程 -> 保存数据库 -> 将保存的对象序列化并返回
2. 删：判断要删除的数据是否存在 ->执行数据库删除
3. 改：判断要修改的数据是否存在 -> 校验请求的数据 -> 执行反序列化过程 -> 保存数据库 -> 将保存的对象序列化并返回
4. 查：查询数据库 -> 将数据序列化并返回

Django REST framework 可以帮助我们简化上述两部分的代码编写，大大提高 REST API 的开发速度。

### 5.1 认识 Django REST framework

Django REST framework 框架是一个用于构建 Web API 的强大而又灵活的工具。

通常简称为 DRF 框架 或 REST framework。

DRF 框架是建立在 Django 框架基础之上，由 Tom Christie 大牛二次开发的开源项目。

特点

- 提供了定义序列化器 Serializer 的方法，可以快速根据 Django ORM 或者其它库自动序列化/反序列化；
- 提供了丰富的类视图、Mixin 扩展类，简化视图的编写；
- 丰富的定制层级：函数视图、类视图、视图集合到自动生成 API， 满足各种需要；
- 多种身份认证和权限认证方式的支持；
- 内置了限流系统；
- 直观的 API web 界面；
- 可扩展性，插件丰富

### 5.2 Django REST framework 常用组件

可以毫不夸张地说，如果可以将 Django REST framework 的 10 个常用组件融会贯通，那么使用 Django 开发前后端分离的项目中有可能遇到的绝大部分需求，都能得到高效的解决。

Django REST framework 的 10 个常用组件如下：

- 权限组件；
- 认证组件；
- 访问频率限制组件；
- 序列化组件；
- 路由组件；
- 视图组件；
- 分页组件；
- 解析器组件；
- 渲染器组件；
- 版本组件。

Django REST framework 官方文档的地址是 https://www.django-rest-framework.org/

## 6. 用 Django REST framework 实现豆瓣 API 应用

新建一个 Django 项目，命名为 book，作为贯穿本书的演示项目。

选择 PyCharm 作为开发工具，在新建目录时，新建 App 命名为 users。

### 6.1 豆瓣 API 功能介绍

豆瓣图书的 API 功能原理是用户通过输入图书的 ISBN 号（书号）、书名、作者、出版社等部分信息，就可获取到该图书在豆瓣上的所有信息。

当然，API 中除了要包含检索信息之外，还要包含开发者的 apikey，用来记录开发者访问 API 的次数，以此向开发者收费。

目前豆瓣图书的 API 是 0.3 元/100 次。

### 6.2 Django REST framework 序列化

序列化（Serialization）是指将对象的状态信息转换为可以存储或传输形式的过程。在客户端与服务端传输的数据形式主要分为两种：XML 和 JSON。

在 Django 中的序列化就是指将对象状态的信息转换为 JSON 数据，以达到将数据信息传送给前端的目的。

序列化是开发 API 不可缺少的一个环节，Django 本身也有一套做序列化的方案，这个方案可以说已经做得很好了，但是若跟 Django REST framework 相比，还是不够极致，速度不够快。

#### 6.2.1 Postman 的使用

Postman 是一款非常流行的 API 调试工具，其使用简单、方便，而且功能强大。

通过 Postman 可以便捷地向 API 发送 GET、POST、PUT 和 DELETE 请求，几乎是资深或者伪资深开发人员调试 API 的首选。

当然，这并不是 Postman 在开发领域如此受欢迎的唯一理由。

Postman 最早是以 Chrome 浏览器插件的形式存在，可以从 Chrome 应用商店搜索、下载并安装，后来因为一些原因，Chrome 应用商店在国内无法访问，2018 年 Postman 停止了对 Chrome 浏览器的支持，提供了独立安装包，不再依赖 Chrome，同时支持 Linux、Windows 和 Mac OS 系统。

测试人员做接口测试会有更多选择，例如 Jmeter 和 soapUI 等，因为测试人员就是完成产品的测试，而开发人员不需要有更多的选择，毕竟开发人员是创新者、创造者。

Postman 的下载地址是 https://www.getpostman.com/apps 。

同样的工具还有 httpie，使用方法如下：

http 请求命令行工具(httpie)：https://www.cnblogs.com/yoyoketang/p/11546176.html

#### 6.2.2 用 serializers.Serializer 方式序列化

（1）打开项目 book。

（2）安装 Django REST framework 及其依赖包 markdown 和 django-filter。命令如下：

```sh
pip install djangorestframework markdown django-filter
```

（3）在 settings 中注册，代码如下：

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'users.apps.UsersConfig',
    'rest_framework'
]
```

（4）设计 users 的 models.py，重构用户表 UserProfile，增加字段 APIkey 和 money。当然，为了演示核心功能，可以建立一张最简单的表，大家可以根据个人喜好增加一些业务字段来丰富项目功能。

```python
from datetime import datetime
from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class UserProfile(AbstractUser):
    """
    用户
    """
    APIkey = models.CharField(max_length=30, verbose_name='APIkey', default='abcdefghigklmn')
    money = models.IntegerField(default=10, verbose_name='余额')

    class Meta:
        verbose_name = '用户'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.username

```

（5）在 settings 中配置用户表的继承代码：

```python
AUTH_USER_MODEL='users.UserProfile'
```

（6）在 users 的 models.py 文件中新建书籍信息表 book，为了演示方便，我们姑且将作者字段并入书籍信息表，读者在实际项目中可根据业务模式灵活设计数据表 model：

```python
class Book(models.Model):
    """
    书籍信息
    """
    title = models.CharField(max_length=30, verbose_name='书名', default='')
    isbn = models.CharField(max_length=30, verbose_name='isbn', default='')
    author = models.CharField(max_length=20, verbose_name='作者', default='')
    publish = models.CharField(max_length=30, verbose_name='出版社', default='')
    rate = models.FloatField(default=0, verbose_name='豆瓣评分')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')

    class Meta:
        verbose_name = '书籍信息'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.title

```

（7）执行数据更新命令：

```sh

python manage.py makemigrations

python manage.py migrate
```

（8）建立一个超级用户，用户名为 admin，邮箱为 1@1.com ，密码为 admin1234。

```sh
python manage.py createsuperuser
Username: admin
邮箱: 1@1.com
Password:
Password (again):
```

（9）通过 PyCharm 的 Databases 操作面板，直接在 book 表内增加一条记录，title 为三国演义，isbn 为 777777，author 为罗贯中，publish 为一个出版社，rate 为 6.6，add_time 为 154087130331。

（10）准备工作已经完成，接下来是我们的“正片”开始啦。在 users 目录下新建 py 文件 serializers，将序列化的类代码写入其中：

```python
from rest_framework import serializers

from .models import UserProfile, Book


class BookSerializer(serializers.Serializer):
    title = serializers.CharField(required=True, max_length=100)
    isbn = serializers.CharField(required=True, max_length=100)
    author = serializers.CharField(required=True, max_length=100)
    publish = serializers.CharField(required=True, max_length=100)
    rate = serializers.FloatField(default=0)

```

其他 Serializer 字段与选项

[参考](https://q1mi.github.io/Django-REST-framework-documentation/api-guide/fields_zh/)

（11）在 users/views 中编写视图代码：

```python
from .serializers import BookSerializer
from rest_framework.views import APIView
from rest_framework.response import Response

# Create your views here.
from .models import UserProfile, Book


class BookAPIView1(APIView):
    """
    使用Serializer
    """

    def get(self, request, format=None):
        APIKey = self.request.query_params.get("apikey", 0)
        developer = UserProfile.objects.filter(APIkey=APIKey).first()
        if developer:
            balance = developer.money
            if balance > 0:
                isbn = self.request.query_params.get("isbn", 0)
                books = Book.objects.filter(isbn=int(isbn))
                books_serializer = BookSerializer(books, many=True)
                developer.money -= 1
                developer.save()
                return Response(books_serializer.data)
            else:
                return Response("兄弟，又到了需要充钱的时候！好开心啊！")
        else:
            return Response("查无此人啊")
```

（12）在 urls 中配置路由如下：

```python
from django.contrib import admin
from django.urls import path
from users.views import BookAPIView1

urlpatterns = [
    path('admin/', admin.site.urls),
    path('apibook1/', BookAPIView1.as_view(), name='book1'),
]
```

至此，我们可以运行 book 项目，使用 Postman 访问 API 来测试一下啦。我们用 Postman 的 GET 方式访问 API：

http://127.0.0.1:8000/apibook1/?apikey=abcdefghigklmn&isbn=777777

我们获得了想要的 JSON 数据：

```json
[
  {
    "title": "三国演义",
    "isbn": "777777",
    "author": "罗贯中",
    "publish": "人民出版社",
    "rate": 6.6
  }
]
```

然后到数据库中查看一下，发现用户 admin 的 money 被减去了 1，变成了 9。当我们用 Postman 故意填错 apikey 时，访问：

当我们连续访问 10 次：

http://127.0.0.1:8000/apibook1/?apikey=abcdefghigklmn&isbn=777777

API 返回的数据为：

```json
"兄弟，又到了需要充钱的时候！好开心啊！"
```

至此，一个简单的模仿豆瓣图书 API 的功能就实现了。在实际的项目中，这样的实现方式虽然原理很清晰，但是存在着很明显的短板，比如被查询的表的字段不可能只有几个，我们在真正调用豆瓣图书 API 的时候就会发现，即使只查询一本书的信息，由于有很多的字段和外键字段，返回的数据量也会非常大。如果使用 Serializer 进行序列化，那么工作量实在太大，严重影响了开发效率。

所以，这里使用 Serializer 进行序列化，目的是让大家通过这种序列化方式更加轻松地理解 Django REST framework 的序列化原理。在实际生产环境中，更加被广泛应用的序列化方式是采用了 Django REST framework 的 ModelSerializer。

#### 6.2.3 用 serializers.ModelSerializer 方式序列化

我们将要使用 Django REST framework 的 ModelSerializer 来实现这个功能。因为都是在 book 项目中，所以上一节中介绍的很多步骤我们没有必要重复。

我们现在要做的，首先是到数据库中的 UserProfile 表中，将用户 admin 的 money 从 0 修改回 10，不然 API 只能返回提醒充值的数据。

##### 1.定义

在 users/serializer.py 中，写 book 的 ModelSerializer 序列化类：

```python
from rest_framework import serializers
from .models import UserProfile, Book



class BookSerializer(serializers.Serializer):
    title = serializers.CharField(required=True, max_length=100)
    isbn = serializers.CharField(required=True, max_length=100)
    author = serializers.CharField(required=True, max_length=100)
    publish = serializers.CharField(required=True, max_length=100)
    rate = serializers.FloatField(default=0)


class BookModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = "__all__"  # 将整个表的所有字段都序列化
```

- model 指明参照哪个模型类

- fields 指明为模型类的哪些字段生成

在 users/views.py 中，编写基于 BookModelSerializer 的图书 API 视图类：

```python
from .serializers import BookSerializer
from .serializers import BookModelSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import UserProfile, Book


# 省略代码片段
class BookAPIView1(APIView):
    """
    使用Serializer
    """

    def get(self, request, format=None):
    # ....


# Create your views here.
class BookAPIView2(APIView):
    """
    使用ModelSerializer
    """
    def get(self, request, format=None):
        APIKey = self.request.query_params.get("apikey", 0)
        developer = UserProfile.objects.filter(APIkey=APIKey).first()

        if developer:
            balance = developer.money
            if balance > 0:
                isbn = self.request.query_params.get("isbn", 0)
                books = Book.objects.filter(isbn=int(isbn))
                books_serializer = BookModelSerializer(books, many=True)
                developer.money -= 1
                developer.save()
                return Response(books_serializer.data)
            else:
                return Response("兄弟，又到了需要充钱的时候！好开心啊！")
        else:
            return Response("查无此人啊")

```

> 注意： 使用 ModelSerializer 序列化对应的视图类与使用 Serializer 进行序列化对应的视图类，除了序列化的方式不同，其他的代码都是相同的。

在 urls 中配置路由代码：

```python
from django.contrib import admin
from django.urls import path
from users.views import BookAPIView1,BookAPIView2

urlpatterns = [
    path('admin/', admin.site.urls),
    path('apibook1/', BookAPIView1.as_view(), name='book1'),
    path('apibook2/', BookAPIView2.as_view(), name='book2'),
]
```

使用 Postman 对 API 进行测试，用 GET 的方式访问：

http://127.0.0.1:8000/apibook2/?apikey=abcdefghigklmn&isbn=777777

返回书籍所有的字段数据：

```json
[
  {
    "id": 1,
    "title": "三国演义",
    "isbn": "777777",
    "author": "罗贯中",
    "publish": "人民出版社",
    "rate": 6.6,
    "add_time": null
  }
]
```

> 注意： 这里的 add_time 字段为 null，是因为这个项目使用了 Django 默认的 db.sqlite3 数据库。由于 db.sqlite3 在存储时间字段的时候，是以时间戳的格式保存的，
> 所以直接使用 Django REST framework 的 Serializer 进行序列化失败。在实际项目中，我们会选择 MySQL 等主流数据库，就不会出现这种情况了

可以看出，对于一条有很多字段的数据记录来说，使用 ModelSerializer 的序列化方式，可以一句话将所有字段序列化，非常方便。

##### 2.指定字段

当然，ModelSerializer 也可以像 Serializer 一样对某几个特定字段进行序列化，写法也很简单，只需要对原本的 BookModelSerializer 修改一行代码：

```python
# 1. 使用fields来明确字段，__all__表名包含所有字段，也可以写明具体哪些字段
fields = __all__


# 2. 使用exclude可以明确排除掉哪些字段
exclude = ('image',)


# 3.显示指明字段
fields = ('id', 'hname', 'hgender', 'hcomment', 'hbook')


# 4.指明只读字段
fields = ('id', 'btitle', 'bpub_date'， 'bread', 'bcomment')
read_only_fields = ('id', 'bread', 'bcomment')
```

显示指明字段

```python
class BookInfoSerializer(serializers.ModelSerializer):
    """图书数据序列化器"""
    class Meta:
        model = BookInfo
        fields = ('id', 'btitle', 'bpub_date')
```

指明只读字段

```python
class BookInfoSerializer(serializers.ModelSerializer):
    """图书数据序列化器"""
    class Meta:
        model = BookInfo
        fields = ('id', 'btitle', 'bpub_date','bread', 'bcomment')
        read_only_fields = ('id', 'bread', 'bcomment')
```

使用 Postman 对 API 进行测试，用 GET 的方式访问：

http://127.0.0.1:8000/apibook2/?apikey=abcdefghigklmn&isbn=777777

返回的数据就成了：

```json
[
  {
    "title": "三国演义",
    "isbn": "777777",
    "author": "罗贯中"
  }
]
```

##### 3.添加额外参数

我们可以使用 extra_kwargs 参数为 ModelSerializer 添加或修改原有的选项参数

```python
class BookInfoSerializer(serializers.ModelSerializer):
    """图书数据序列化器"""
    class Meta:
        model = BookInfo
        fields = ('id', 'btitle', 'bpub_date', 'bread', 'bcomment')
        extra_kwargs = {
            'bread': {'min_value': 0, 'required': True},
            'bcomment': {'min_value': 0, 'required': True},
        }

# BookInfoSerializer():
#    id = IntegerField(label='ID', read_only=True)
#    btitle = CharField(label='名称', max_length=20)
#    bpub_date = DateField(allow_null=True, label='发布日期', required=False)
#    bread = IntegerField(label='阅读量', max_value=2147483647, min_value=0, required=True)
#    bcomment = IntegerField(label='评论量', max_value=2147483647, min_value=0, required=True)
```

```python
class LeaveMessageSerializer(serializers.ModelSerializer):
    """
    留言记录序列化器
    """
    username = serializers.ReadOnlyField(source='user.username')
    photo = serializers.ReadOnlyField(source='user.photo')
    child = serializers.ListField(source='get_child', child=RecursiveField(), read_only=True)
    father_name = serializers.ReadOnlyField(source='get_father_name')

    class Meta:
        model = LeaveMessage
        fields = "__all__"
```

#### 6.2.4 Serializer 和 ModelSerializer 序列化选择

我们对 Django REST framework 的两种序列化方式做一个总结：

Serializer 和 ModelSerializer 两种序列化方式中，前者比较容易理解，适用于新手；后者则在商业项目中被使用的更多，在实际开发中建议大家多使用后者。

许多教材中都将 Django REST framework 的 Serializer 和 ModelSerializer,与 Django 的 Form 和 ModelForm 做对比，虽然二者相似，在优劣选择上却是不同的。Form 虽然没有 ModelForm 效率高，但是 ModelForm 的使用增加了项目的耦合度，不符合项目解耦原则，所以 Form 比 ModelForm 更优（除了字段量过大的情况）；

而 ModelSerializer 有 Serializer 所有的优点，同时并没有比 Serializer 明显的不足之外，**所以 ModelSerializer 比 Serializer 更优。**

ModelSerializer 与常规的 Serializer 相同，但提供了：

- 自动推断需要序列化的字段及类型
- 提供对字段数据的验证器的默认实现
- 提供了修改数据需要用到的 `.create()`、`.update()` 方法的默认实现

另外我们还可以在 fileds 列表里挑选出需要的数据，以便减小数据的体积。

#### 6.2.5 HyperlinkedModelSerializer 序列化方式

HyperlinkedModelSerializer 基本上与之前用的 ModelSerializer 差不多，区别是它自动提供了外键字段的超链接，并且默认不包含模型对象的 id 字段。

HyperlinkedModelSerializer 与 ModelSerializer 有以下区别：

- 默认情况下不包括 id 字段。
- 它包含一个 url 字段，使用 HyperlinkedIdentityField。
- 关联关系使用 HyperlinkedRelatedField，而不是 PrimaryKeyRelatedField。

参考文献：

https://q1mi.github.io/Django-REST-framework-documentation/api-guide/serializers_zh/#hyperlinkedmodelserializer

#### 6.2.6 总结

ModelSerializer 比 Serializer 好用是模型序列化的首选方案!

参考文献：

https://www.cnblogs.com/gengfenglog/p/14658470.html#_lab2_0_4

https://www.cuiliangblog.cn/detail/article/13

## 7. Django REST framework 视图

### 7.1 视图类总结

REST framework 提供了众多的通用视图基类与扩展类，以简化视图的编写。

视图的继承关系：

![1700798042427](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1700798042427.2ol9tvnog420.webp){: .zoom}

![1700648982801](https://cdn.jsdelivr.net/gh/hujianli94/Picgo-atlas@main/img/1700648982801.3vua8iq84hu0.png){: .zoom}

### 7.2 基于 api_view 函数视图示例

#### 7.2.1 Request

##### Request objects

1.REST framework 传入视图的 request 对象不再是 Django 默认的 HttpRequest 对象，而是 REST framework 提供的扩展了 HttpRequest 类的 Request 类的对象。REST framework 提供了 Parser 解析器，在接收到请求后会自动根据 Content-Type 指明的请求数据类型（如 JSON、表单等）将请求数据进行 parse 解析，解析为类字典对象保存到 Request 对象中

2.Request 对象的数据是自动根据前端发送数据的格式进行解析之后的结果。无论前端发送的哪种格式的数据，我们都可以以统一的方式读取数据。

##### 常用属性

**1.request.data**

返回解析之后的请求体数据。类似于 Django 中标准的 request.POST 和 request.FILES 属性，但提供如下特性：

- 包含了解析之后的文件和非文件数据
- 包含了对 POST、PUT、PATCH 请求方式解析后的数据
- 利用了 REST framework 的 parsers 解析器，不仅支持表单类型数据，也支持 JSON 数据

**2.request.query_params**

与 Django 标准的 request.GET 相同，只是更换了更正确的名称而已。

**3.总结**

- GET 请求：如果想获取 GET 请求的所有参数，使用 request.query_params 即可
- POST 请求：使用 request.data 就可以处理传入的 json 请求，或者其他格式请求。

#### 7.2.2 Response

##### Response objects

REST framework 提供了一个响应类 Response，使用该类构造响应对象时，响应的具体数据内容会被转换（render 渲染）成符合前端需求的类型。

REST framework 提供了 Renderer 渲染器，用来根据请求头中的 Accept（接收数据类型声明）来自动转换响应数据到对应格式。如果前端请求中未进行 Accept 声明，则会采用默认方式处理响应数据，我们可以通过配置来修改默认响应格式。

```python
REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': (  # 默认响应渲染类
        'rest_framework.renderers.JSONRenderer',  # json渲染器
        'rest_framework.renderers.BrowsableAPIRenderer',  # 浏览API渲染器
    )
}
```

##### 构造方式

```python
Response(data, status=None, template_name=None, headers=None, content_type=None)
```

参数说明:

- data: 为响应准备的序列化处理后的数据（序列化器序列化处理后的数据）
- status: 状态码，默认 200；
- template_name: 模板名称，如果使用 HTMLRenderer 时需指明；
- headers: 用于存放响应头信息的字典；
- content_type: 响应数据的 Content-Type，通常此参数无需传递，REST framework 会根据前端所需类型数据来设置该参数。

##### 常用属性

1）.data

传给 response 对象的序列化后，但尚未 render 处理的数据

2）.status_code

状态码的数字

3）.content

经过 render 处理后的响应数据

##### 状态码

为了方便设置状态码，REST framewrok 在 rest_framework.status 模块中提供了常用状态码常量。

#### 7.2.3 函数视图

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-api_view
```

`app/views.py`

```python
from app.models import BookInfo, HeroInfo
from app.serializers import BookInfoSerializer, HeroInfoSerializer, SimpleHeroInfoSerializer
from rest_framework.decorators import api_view
from rest_framework import status
# from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
# 不再需要JSONResponse类，所有响应通过response即可
from rest_framework.response import Response


# 如果没有使用rest_framework的Response方法，使用HttpResponse的话需要对基类进行改写，改写方法如下
# class JSONResponse(HttpResponse):
#     """
#     将内容渲染成JSON的HttpResponse
#     """
#
#     def __init__(self, data, **kwargs):
#         content = JSONRenderer().render(data)
#         kwargs['content_type'] = 'application/json'
#         super(JSONResponse, self).__init__(content, **kwargs)



# 使用函数修饰器修改GET和POST请求
@api_view(['GET', 'POST'])
def BookInfoView(request):
    """
    列出所有的book信息，或创建一个新book。
    """
    if request.method == 'GET':
        books = BookInfo.objects.all()
        serializer = BookInfoSerializer(books, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # book = JSONParser().parse(request)
        # serializer = BookInfoSerializer(data=book)
        # 使用request.data自动将请求内容数据部分处理
        serializer = BookInfoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def BookInfoDetailView(request, pk):
    """
    获取，更新或删除一个指定ID的book。
    """
    try:
        book = BookInfo.objects.get(pk=pk)
    except BookInfo.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = BookInfoSerializer(book)
        return Response(serializer.data)

    elif request.method == 'PUT':
        # data = JSONParser().parse(request)
        # serializer = BookInfoSerializer(book, data=data)
        # 使用request.data自动将请求内容数据部分处理
        serializer = BookInfoSerializer(book, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        book.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['GET', 'POST'])
def HeroInfoView(request):
    """
    查询所有人物信息，新增人物
    """
    if request.method == 'GET':
        heros = HeroInfo.objects.all()
        serializer = SimpleHeroInfoSerializer(heros, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # heros = JSONParser().parse(request)
        # serializer = HeroInfoSerializer(data=book)
        # 使用request.data自动将请求内容数据部分处理
        serializer = HeroInfoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def HeroInfoDetailView(request, pk):
    """
    获取，更新或删除一个指定ID的人物。
    """
    try:
        heros = HeroInfo.objects.get(pk=pk)
    except HeroInfo.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = HeroInfoSerializer(heros)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = HeroInfoSerializer(heros, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        heros.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
```

### 7.3 2 个视图基类

#### APIView

```python
from rest_framework.views import APIView
```

1.APIView 是 REST framework 提供的所有视图的基类，继承自 Django 的 View 父类。

2.APIView 与 View 的不同之处在于：

● 传入到视图方法中的是 REST framework 的 Request 对象，而不是 Django 的 HttpRequeset 对象；

● 视图方法可以返回 REST framework 的 Response 对象，视图会为响应数据设置（render）符合前端要求的格式；

● 任何 APIException 异常都会被捕获到，并且处理成合适的响应信息；

● 在进行 dispatch()分发前，会对请求进行身份认证、权限检查、流量控制。

3.支持定义的属性：

● authentication_classes 列表或元祖，身份认证类

● permissoin_classes 列表或元祖，权限检查类

● throttle_classes 列表或元祖，流量控制类

4.在 APIView 中仍以常规的类视图定义方法来实现 get() 、post() 或者其他请求方式的方法。

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-APIView
```

##### 基本配置

安装 Django REST framework 及其依赖包 markdown 和 django-filter。命令如下

```sh
pip install djangorestframework markdown django-filter
```

在 settings 中注册，代码如下：

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'users.apps.UsersConfig',
    'rest_framework'
]
```

##### 配置模型

`app/models.py`数据定义保持不变

```python
from django.db import models


# Create your models here.
# 定义图书模型类BookInfo
class BookInfo(models.Model):
    btitle = models.CharField(max_length=20, verbose_name='名称')
    bpub_date = models.DateField(verbose_name='发布日期')
    bread = models.IntegerField(default=0, verbose_name='阅读量')
    bcomment = models.IntegerField(default=0, verbose_name='评论量')
    is_delete = models.BooleanField(default=False, verbose_name='逻辑删除')
    # 注意,如果模型已经迁移建表并且表中如果已经有数据了,那么后新增的字段,必须给默认值或可以为空,不然迁移就报错
    # upload_to 指定上传到media_root配置项的目录中再创建booktest里面
    image = models.ImageField(upload_to='booktest', verbose_name='图片', null=True)


    class Meta:
        db_table = 'tb_books'  # 指明数据库表名
        verbose_name = '图书'  # 在admin站点中显示的名称
        verbose_name_plural = verbose_name  # 显示的复数名称

    def __str__(self):
        """定义每个数据对象的显示信息"""
        return self.btitle

    def pub_date_format(self):
        return self.bpub_date.strftime('%Y-%m-%d')
    # 修改方法名在列表界面的展示
    pub_date_format.short_description = '发布日期'
    # 指定自定义方法的排序依据
    pub_date_format.admin_order_field = 'bpub_date'


# 定义英雄模型类HeroInfo
class HeroInfo(models.Model):
    GENDER_CHOICES = (
        (0, 'female'),
        (1, 'male')
    )
    hname = models.CharField(max_length=20, verbose_name='名称')
    hgender = models.SmallIntegerField(choices=GENDER_CHOICES, default=0, verbose_name='性别')
    hcomment = models.CharField(max_length=200, null=True, verbose_name='描述信息')
    hbook = models.ForeignKey(BookInfo, on_delete=models.CASCADE, verbose_name='图书')  # 外键
    is_delete = models.BooleanField(default=False, verbose_name='逻辑删除')

    class Meta:
        db_table = 'tb_heros'
        verbose_name = '英雄'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.hname

    def read(self):
        return self.hbook.bread
    read.short_description = '阅读量'
    read.admin_order_field = 'hbook__bread'
    # HeroInfo.objects.filter(hbook__bread=xx)
```

##### 配置序列化器

app 目录下新建 py 文件 serializers，将序列化的类代码写入其中：

```python
from rest_framework import serializers

from .models import BookInfo, HeroInfo


class SimpleHeroInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HeroInfo
        fields = ['id', 'hname', 'hgender', 'hcomment']


class HeroInfoSerializer(serializers.ModelSerializer):
    hbook = serializers.PrimaryKeyRelatedField(queryset=BookInfo.objects.all())

    book_name = serializers.CharField(source='hbook.btitle', read_only=True)
    read = serializers.SerializerMethodField()
    comment = serializers.SerializerMethodField()

    class Meta:
        model = HeroInfo
        fields = ['id', 'hname', 'hgender', 'hcomment', 'hbook', 'book_name', 'read', 'comment']

    def get_read(self, obj):
        return obj.hbook.bread

    def get_comment(self, obj):
        return obj.hbook.bcomment


class BookInfoSerializer(serializers.ModelSerializer):
    # 反向关联字段，表示与BookInfo模型关联的所有HeroInfo实例
    hero_set = HeroInfoSerializer(many=True, read_only=True)

    class Meta:
        model = BookInfo
        fields = '__all__'
```

##### 配置视图

`app/views`中编写视图代码

```python
from django.http import Http404
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from app.serializers import BookInfoSerializer, HeroInfoSerializer, SimpleHeroInfoSerializer
from .models import BookInfo, HeroInfo

"""

# 书籍信息
GET         /api/books/
POST        /api/books/
GET         /api/books/<pk>/
PUT         /api/books/<pk>/
DELETE      /api/books/<pk>/

# 人物信息
GET         /api/heros/
POST        /api/heros/
GET         /api/heros/<pk>/
PUT         /api/heros/<pk>/
DELETE      /api/heros/<pk>/
"""


class BookInfoListAPIView(APIView):
    def get(self, request):
        books = BookInfo.objects.all()
        serializer = BookInfoSerializer(books, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = BookInfoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BookInfoDetailAPIView(APIView):
    def get_object(self, pk):
        try:
            return BookInfo.objects.get(pk=pk)
        except BookInfo.DoesNotExist:
            raise Http404

    def get(self, request, pk):
        book = self.get_object(pk)
        serializer = BookInfoSerializer(book)
        return Response(serializer.data)

    def put(self, request, pk):
        book = self.get_object(pk)
        serializer = BookInfoSerializer(book, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        book = self.get_object(pk)
        book.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class HeroInfoListAPIView(APIView):
    def get(self, request):
        heroes = HeroInfo.objects.all()
        serializer = SimpleHeroInfoSerializer(heroes, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = HeroInfoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class HeroInfoDetailAPIView(APIView):
    def get_object(self, pk):
        try:
            return HeroInfo.objects.get(pk=pk)
        except HeroInfo.DoesNotExist:
            raise Http404

    def get(self, request, pk):
        hero = self.get_object(pk)
        serializer = HeroInfoSerializer(hero)
        return Response(serializer.data)

    def put(self, request, pk):
        hero = self.get_object(pk)
        serializer = HeroInfoSerializer(hero, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        hero = self.get_object(pk)
        hero.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
```

##### 配置路由

`bookv1/urls.py`

```python
from django.contrib import admin
from django.urls import include, re_path, path
from app import urls

urlpatterns = [
    path('admin/', admin.site.urls),
    re_path('api/', include(urls)),
]
```

`app/urls.py`

```python
from django.urls import re_path
from . import views

urlpatterns = [
    # 书籍
    re_path(r'^books/$', views.BooksAPIVIew.as_view()),
    re_path(r'^books/(?P<pk>\d+)/$', views.BookAPIView.as_view()),
    # 人物
    re_path(r'^heros/$', views.HerosAPIVIew.as_view()),
    re_path(r'^heros/(?P<pk>\d+)/$', views.HeroAPIView.as_view()),

]
```

#### GenericAPIView

GenericAPIView - 通用视图类

继承自 APIVIew，主要增加了操作序列化器和数据库查询的方法，作用是为下面 Mixin 扩展类的执行提供方法支持。通常在使用时，可搭配一个或多个 Mixin 扩展类。

```python
from rest_framework.generics import GenericAPIView
```

GenericAPIView(APIView):做了一些封装

| 属性             | 说明                   |
| ---------------- | ---------------------- |
| queryset         | 要序列化的数据         |
| serializer_class | 指明视图使用的序列化器 |

| 方法                 | 说明                                                                                                                                           |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| get_queryset         | 获取 qs 数据(返回视图使用的查询集，主要用来提供给 Mixin 扩展类使用，是列表视图与详情视图获取数据的基础，默认返回 queryset 属性)                |
| get_object           | 获取一条数据的对象(返回详情视图所需的模型类数据对象，主要用来提供给 Mixin 扩展类使用。在试图中可以调用该方法获取详情信息的模型类对象)          |
| get_serializer       | 以后使用它来实例化得到 ser 对象(返回序列化器对象，主要用来提供给 Mixin 扩展类使用，如果我们在视图中想要获取序列化器对象，也可以直接调用此方法) |
| get_serializer_class | 获取序列化类，注意跟上面区分                                                                                                                   |

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-GenericAPIView
```

`app/views.py`

```python
from rest_framework.response import Response
from app.serializers import BookInfoSerializer, HeroInfoSerializer, SimpleHeroInfoSerializer
from .models import BookInfo, HeroInfo
from rest_framework.generics import GenericAPIView


class BookInfoListAPIView(GenericAPIView):
    """
    查询所有书籍，增加书籍
    """
    queryset = BookInfo.objects.all()  # 要序列化的数据
    serializer_class = BookInfoSerializer  # 要序列化的类

    def get(self, request):
        qs = self.get_queryset()  # 推荐用self.get_queryset来获取要序列化的数据
        ser = self.get_serializer(qs, many=True)  # 推荐使用self.get_serializer获取实例化后并且传入数据的对象
        return Response(ser.data)

    def post(self, request):
        ser = self.get_serializer(data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)

        return Response(ser.errors)


class BookInfoDetailAPIView(GenericAPIView):
    """
    查询，修改，删除单本书籍
    """
    queryset = BookInfo.objects.all()  # 要序列化的数据
    serializer_class = BookInfoSerializer  # 要序列化的类

    def get(self, request, *args, **kwargs):
        obj = self.get_object()  # 获取单条self.get_object要序列化的数据
        ser = self.get_serializer(obj)  # 第一个参数是instance=obj，可以直接写obj
        return Response(ser.data)

    def put(self, request, *args, **kwargs):
        obj = self.get_object()
        ser = self.get_serializer(instance=obj, data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)
        else:
            return Response(ser.errors)

    def delete(self, request, *args, **kwargs):
        res = self.get_object().delete()  # get_object()拿到对象直接删除了
        if res[0] > 0:
            return Response('')
        else:
            return Response('要删的不存在')


class HeroInfoListAPIView(GenericAPIView):
    """
    查询所有人物，增加人物
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer

    def get(self, request):
        qs = self.get_queryset()
        ser = self.get_serializer(qs, many=True)
        return Response(ser.data)

    def post(self, request):
        ser = self.get_serializer(data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)

        return Response(ser.errors)


class HeroInfoDetailAPIView(GenericAPIView):
    """
    查询，修改，删除人物信息
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer

    def get(self, request, *args, **kwargs):
        obj = self.get_object()  # 获取单条self.get_object要序列化的数据
        ser = self.get_serializer(obj)  # 第一个参数是instance=obj，可以直接写obj
        return Response(ser.data)

    def put(self, request, *args, **kwargs):
        obj = self.get_object()
        ser = self.get_serializer(instance=obj, data=request.data)
        if ser.is_valid():
            ser.save()
            return Response(ser.data)
        else:
            return Response(ser.errors)

    def delete(self, request, *args, **kwargs):
        res = self.get_object().delete()  # get_object()拿到对象直接删除了
        if res[0] > 0:
            return Response('')
        else:
            return Response('要删的不存在')
```

### 7.4 5 个视图扩展类

作用：

提供了几种后端视图（对数据资源进行曾删改查）处理流程的实现，如果需要编写的视图属于这五种，则视图可以通过继承相应的扩展类来复用代码，减少自己编写的代码量。

这五个扩展类需要搭配 GenericAPIView 父类，因为五个扩展类的实现需要调用 GenericAPIView 提供的序列化器与数据库查询的方法。

| 父类           | 扩展类             | 说明   | 备注                                                                                                                                                                                                                                      |
| -------------- | ------------------ | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GenericAPIView | ListModelMixin     | 查所有 | 列表视图扩展类，提供 `list(request, *args, **kwargs)`方法快速实现列表视图，返回 200 状态码。<br>该 Mixin 的 list 方法会对数据进行过滤和分页。                                                                                             |
| GenericAPIView | RetrieveModelMixin | 查一个 | 创建视图扩展类，提供 `create(request, *args, **kwargs)` 方法快速实现创建资源的视图，成功返回 201 状态码。<br>如果序列化器对前端发送的数据验证失败，返回 400 错误。                                                                        |
| GenericAPIView | CreateModelMixin   | 增一个 | 详情视图扩展类，提供 `retrieve(request, *args, **kwargs)`方法，可以快速实现返回一个存在的数据对象。<br>如果存在，返回 200， 否则返回 404                                                                                                  |
| GenericAPIView | UpdateModelMixin   | 改一个 | 更新视图扩展类，提供`update(request, *args, **kwargs)`方法，可以快速实现更新一个存在的数据对象。<br>同时也提供`partial_update(request, *args, **kwargs)`方法，可以实现局部更新。<br>成功返回 200，序列化器校验数据失败时，返回 400 错误。 |
| GenericAPIView | DestroyModelMixin  | 删一个 | 删除视图扩展类，提供`destroy(request, *args, **kwargs)`方法，可以快速实现删除一个存在的数据对象。成功返回 204，不存在返回 404。                                                                                                           |

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-GenericAPIView-5Extended_class
```

`app/views.py`

```python
from app.serializers import BookInfoSerializer, HeroInfoSerializer, SimpleHeroInfoSerializer
from .models import BookInfo, HeroInfo
from rest_framework.generics import GenericAPIView
from rest_framework.mixins import CreateModelMixin, RetrieveModelMixin, UpdateModelMixin, DestroyModelMixin, \
    ListModelMixin


class BookInfoListAPIView(GenericAPIView, ListModelMixin, CreateModelMixin):
    """
    查询所有书籍，增加书籍
    """
    queryset = BookInfo.objects.all()  # 要序列化的数据
    serializer_class = BookInfoSerializer  # 要序列化的类

    def get(self, request, *args, **kwargs):  # 不管有值无值最好都把 *args, **kwargs传过来
        return self.list(request, *args, **kwargs)

    def post(self, request):
        return self.create(request)


class BookInfoDetailAPIView(GenericAPIView, RetrieveModelMixin, UpdateModelMixin, DestroyModelMixin):
    """
    查询，修改，删除单本书籍
    """
    queryset = BookInfo.objects.all()
    serializer_class = BookInfoSerializer

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)


class HeroInfoListAPIView(GenericAPIView, ListModelMixin, CreateModelMixin):
    """
    查询所有人物，增加人物
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request):
        return self.create(request)


class HeroInfoDetailAPIView(GenericAPIView, RetrieveModelMixin, UpdateModelMixin, DestroyModelMixin):
    """
    查询，修改，删除人物信息
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)
```

### 7.5 9 个视图子类

| 父类           | 扩展类                       | 说明                 | 备注                                                                                                              |
| -------------- | ---------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------- |
| GenericAPIView | ListAPIView                  | 查所有               | 提供 get 方法 继承自：GenericAPIView、ListModelMixin。                                                            |
| GenericAPIView | CreateAPIView                | 增一个               | 提供 post 方法 继承自： GenericAPIView、CreateModelMixin                                                          |
| GenericAPIView | ListCreateAPIView            | 查所有 + 增一个      | 提供 get 和 post 方法 继承自： GenericAPIView、ListModelMixin、CreateModelMixin                                   |
| GenericAPIView | RetrieveAPIView              | 查一个               | 提供 get 方法继承自: GenericAPIView、RetrieveModelMixin                                                           |
| GenericAPIView | UpdateAPIView                | 改一个               | 提供 put 和 patch 方法继承自：GenericAPIView、UpdateModelMixin                                                    |
| GenericAPIView | DestoryAPIView               | 删一个               | 提供 delete 方法 继承自：GenericAPIView、DestoryModelMixin                                                        |
| GenericAPIView | RetrieveUpdateAPIView        | 查一个+改一个        | 提供 get、put、patch 方法 继承自： GenericAPIView、RetrieveModelMixin、UpdateModelMixin                           |
| GenericAPIView | RetrieveDestroyAPIView       | 查一个+删一个        | 提供 get 和 delete 方法继承自： GenericAPIView、RetrieveModelMixin、DestoryModelMixin                             |
| GenericAPIView | RetrieveUpdateDestoryAPIView | 查一个+改一个+删一个 | 提供 get、put、patch、delete 方法 继承自：GenericAPIView、RetrieveModelMixin、UpdateModelMixin、DestoryModelMixin |

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-GenericAPIView-9view_subclass
```

`app/views.py`

```python
from app.serializers import BookInfoSerializer, HeroInfoSerializer, SimpleHeroInfoSerializer
from .models import BookInfo, HeroInfo
from rest_framework.generics import CreateAPIView, ListAPIView, ListCreateAPIView
from rest_framework.generics import RetrieveAPIView, UpdateAPIView, DestroyAPIView, RetrieveUpdateAPIView, \
    RetrieveDestroyAPIView, RetrieveUpdateDestroyAPIView


class BookInfoListAPIView(ListCreateAPIView):
    """
    查询所有书籍，增加书籍
    """

    queryset = BookInfo.objects.all()  # 要序列化的数据
    serializer_class = BookInfoSerializer  # 要序列化的类


class BookInfoDetailAPIView(RetrieveUpdateDestroyAPIView):
    """
    查询，修改，删除单本书籍
    """
    queryset = BookInfo.objects.all()
    serializer_class = BookInfoSerializer


# # 查询，删除，修改单本书籍
# class BookInfoDetailAPIView2(RetrieveAPIView, UpdateAPIView, DestroyAPIView):
#     queryset = BookInfo.objects.all()
#     serializer_class = BookInfoSerializer
#
# # 查询，删除，修改单本书籍
# class BookInfoDetailAPIView3(RetrieveDestroyAPIView, UpdateAPIView):
#     queryset = BookInfo.objects.all()
#     serializer_class = BookInfoSerializer
#
# # 查询，删除，修改单本书籍
# class BookInfoDetailAPIView4(RetrieveUpdateAPIView, DestroyAPIView):
#     queryset = BookInfo.objects.all()
#     serializer_class = BookInfoSerializer


class HeroInfoListAPIView(ListCreateAPIView):
    """
    查询所有人物，增加人物
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer


class HeroInfoDetailAPIView(RetrieveUpdateDestroyAPIView):
    """
    查询，修改，删除人物信息
    """
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer
```

### 7.6 视图集 ViewSet

使用视图集 ViewSet，可以将一系列逻辑相关的动作放到一个类中：

| 动作       | 说明         |
| ---------- | ------------ |
| list()     | 提供一组数据 |
| retrieve() | 提供单个数据 |
| create()   | 创建数据     |
| update()   | 保存数据     |
| destory()  | 删除数据     |

ViewSet 视图集类不再实现 get()、post()等方法，而是实现动作 action 如 list() 、create() 等。

视图集只在使用 as_view() 方法的时候，才会将 action 动作与具体请求方式对应上。

在视图集中，我们可以通过 action 对象属性来获取当前请求视图集时的 action 动作是哪一个。

```python
class BooksModelViewSet(ModelViewSet):
    # serializer_class = BookSerializer
    queryset = BookInfo.objects.all()

    # 对于不同的方法使用不同的序列化器
    def get_serializer_class(self):
        if self.action == "list":
            return BookSerializer
        elif self.action == "create":
            return BookSerializer1
        else:
            return BookSerializer2
```

常用的视图集父类

| 父类                           | 视图集名称           | 说明                                                                                                                                                                                                                                                                            | 备注                                                                                                                                                                                   |
| ------------------------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| APIView 与 ViewSetMixin        | ViewSet              | 与 APIView 基本类似，提供了身份认证、权限校验、流量管理等。<br>使用 ViewSet 通常并不方便，因为 list、retrieve、create、update、destory 等方法都需要自己编写，而这些方法与前面讲过的 Mixin 扩展类提供的方法同名，所以我们可以通过继承 Mixin 扩展类来复用这些方法而无需自己编写。 | ViewSet 主要通过继承 ViewSetMixin 来实现在调用 `as_view()` 时传入字典(如{‘get’:’list’})的映射处理工作。<br>在 ViewSet 中，没有提供任何动作 action 方法，需要我们自己实现 action 方法。 |
| GenericAPIView 与 ViewSetMixin | GenericViewSet       | 实现了调用`as_view()`时传入字典（如{'get':'list'}）的映射处理工作的同时，还提供了 GenericAPIView 提供的基础方法，可以直接搭配 Mixin 扩展类使用。                                                                                                                                |                                                                                                                                                                                        |
| GenericViewSet                 | ModelViewSet         | 继承自 GenericViewSet，同时包括了 ListModelMixin、RetrieveModelMixin、CreateModelMixin、UpdateModelMixin、DestoryModelMixin。                                                                                                                                                   |                                                                                                                                                                                        |
| GenericViewSet                 | ReadOnlyModelViewSet | 继承自 GenericViewSet，同时包括了 ListModelMixin、RetrieveModelMixin。                                                                                                                                                                                                          |                                                                                                                                                                                        |

```sh
ViewSetMixin：            # 重写了as_view

ViewSet：                 # 继承ViewSetMixin和APIView

GenericViewSet：          # 继承ViewSetMixin, generics.GenericAPIView

ModelViewSet：            # 继承mixins.CreateModelMixin,mixins.RetrieveModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin,mixins.ListModelMixin,GenericViewSet
```

我们来剖析视图的封装层数。要知道，我们经常说到的 Django REST framework 的“三层视图封装”，并不是仅仅封装了三层，下面解剖一个 viewsets.ModelViewSet 看一下：

```python
#源码：
class ModelViewSet(mixins.CreateModelMixin,
                   mixins.RetrieveModelMixin,
                   mixins.UpdateModelMixin,
                   mixins.DestroyModelMixin,
                   mixins.ListModelMixin,
                   GenericViewSet):
    """
    A viewset that provides default `create()`, `retrieve()`, `update()`,
    `partial_update()`, `destroy()` and `list()` actions.
    """
    pass

class GenericViewSet(ViewSetMixin, generics.GenericAPIView):
    pass

class GenericAPIView(views.APIView):
    pass
```

ReadOnlyModelViewSet：继承 mixins.RetrieveModelMixin,mixins.ListModelMixin,GenericViewSet 示例参照 ModelViewSet 代码，区别仅在于 ReadOnlyModelViewSet 仅实现封装了查询方法。

下面主要介绍 ModelViewSet，较为常用。

#### ModelViewSet

我们基于 Django 开发 REST 接口的 bookv1 项目 进行视图改造

项目地址： 存放在 gitee

[bookv1](https://gitee.com/django-devops/bookv1)

创建并切换到新分支

```sh
git checkout -b drf-ModelViewSet
```

`app/views.py`

```python
from rest_framework.viewsets import ModelViewSet
from app.serializers import BookInfoSerializer, HeroInfoSerializer
from .models import BookInfo, HeroInfo


# --------------- ModelViewSet视图类 --------------------------
class BooksInfoModelViewSet(ModelViewSet):
    """
    获取所有图书和单个图书信息的增删改查
    """
    authentication_classes = []
    permission_classes = []
    queryset = BookInfo.objects.all()
    serializer_class = BookInfoSerializer


class HeroInfoModelViewSet(ModelViewSet):
    """
    获取所有人物和单个人物信息的增删改查
    """
    authentication_classes = []
    permission_classes = []
    queryset = HeroInfo.objects.all()
    serializer_class = HeroInfoSerializer

```

`app/urls.py`

```python
from django.urls import re_path, path
from . import views

urlpatterns = [
    # 图书
    path('books/', views.BooksInfoModelViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('books/<int:pk>/',
         views.BooksInfoModelViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),

    # 人物
    path('heros/', views.HeroInfoModelViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('heros/<int:pk>/',
         views.HeroInfoModelViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
]
```

用 viewsets + Router 的方式实现视图封装

`bookv1/urls.py`

```python
from django.contrib import admin
from django.urls import include, re_path, path
from app import urls
from rest_framework.routers import DefaultRouter
from app.views import BooksInfoModelViewSet, HeroInfoModelViewSet

# 因为我们使用的是ViewSet类而不是View类，我们实际上不需要自己设计URL。
# 将资源连接到视图和url的约定可以使用Router类自动处理。
# 我们需要做的就是使用路由器注册相应的视图集，然后让它执行其余操作。
router = DefaultRouter()
router.register(r'books', BooksInfoModelViewSet, basename='books')
router.register(r'heros', HeroInfoModelViewSet, basename='heros')

urlpatterns = router.urls
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls))
    # re_path('api/', include(urls)),
]
```

#### 路由 Router

> 添加路由数据有 2 种方式

第一种方式：

```python
urlpatterns = [
# ...
]
urlpatterns += router.urls
```

第二种方式

```python
urlpatterns = [
# ...
path(r'^', include(router.urls))
]
```

### 7.7 视图如何选择?

可以说，我们在今后的项目中，只需要优先在 APIView 和 viewsets 中选择即可。至于 mixins 就好像是斐波那契数列一样，几乎永远不会缺席于应聘 Django REST framework 技术岗位的笔试题中，但在实际项目中却很少能用得上。

APIView 和 viewsets 应该怎样选择呢？

当视图要实现的功能中，存在数据运算、拼接的业务逻辑时，可以一律选择 APIView 的方式来写视图类，除此以外，优先使用 viewsets 的方式来写视图类，毕竟使用 viewsets+Router 在常规功能上效率极高。

## 8.手把手 Django+Vue 前后端分离开发入门

https://github.com/jumploop/book_demo

## 9.Python+Django+Vue 图书管理系统开发全流程

https://github.com/guosaike/dvtushu

## 10.基于 Python+Django+Vue 协同过滤电影推荐系统设计与实现

https://github.com/guosaike/dvdianying

## 11.基于 Python+Django+Vue 的旅游景区推荐系统系统设计与实现

https://github.com/guosaike/dvlvyou

## 12.基于 Python+Django+Vue 协同过滤图书推荐系统设计与实现

https://github.com/guosaike/dvbook

## 13.基于 Python+Django+Vue 的宠物领养推荐系统设计与实现

https://github.com/guosaike/dvchongwu

## 14.基于 Python+Django+Vue 的医院预约医院预定推荐系统设计与实现

https://github.com/guosaike/dvyiyuan

## 参考文献

[django rest framework 学习](https://www.cnblogs.com/Slience-me/p/14456752.html)

[restful framework](https://www.cnblogs.com/sui776265233/category/1319448.html)

[Django REST Framework](https://www.yuque.com/wslynn/python/ouh3zo)

[DRF 知识点总结](https://www.yuque.com/cuiliang0302/python/enqmvp)

[DRF](http://www.sunrisenan.com/docs/drf/drf-1do8mau479ha8)

[Django-Vue 搭建个人博客](https://www.dusaiphoto.com/article/77/)

[Django REST Framework 教程](https://pythondjango.cn/django/rest-framework-tutorials)

[Django drf 从入门到精通](https://www.cnblogs.com/bladecheng/p/11565336.html)
