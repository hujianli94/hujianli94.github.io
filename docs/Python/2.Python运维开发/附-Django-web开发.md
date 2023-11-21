# 附-Django-web开发




## 1. 用Django REST framework实现豆瓣API应用


在Python的Web业内广为流传一句话“使用Python进行Web全栈开发者必会Django，使用Django开发前后端分离项目者必会Django REST framework”。

使用Python进行Web全栈开发的框架，主流的就有4个，但是大家除了使用Django以外，其他的都很少使用。

Django本身也拥有一些模块，可以用于完成前后端分离项目的需求，但是大家除了使用Django REST framework以外，也很少使用其他模块。


可以毫不夸张地说，如果可以将Django REST framework的10个常用组件融会贯通，那么使用Django开发前后端分离的项目中有可能遇到的绝大部分需求，都能得到高效的解决。

Django REST framework的10个常用组件如下：

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


Django REST framework官方文档的地址是  https://www.django-rest-framework.org/ 。

新建一个Django项目，命名为book，作为贯穿本书的演示项目。

选择PyCharm作为开发工具，在新建目录时，新建App命名为users。






### 1.1 豆瓣API功能介绍


豆瓣图书的API功能原理是用户通过输入图书的ISBN号（书号）、书名、作者、出版社等部分信息，就可获取到该图书在豆瓣上的所有信息。

当然，API中除了要包含检索信息之外，还要包含开发者的apikey，用来记录开发者访问API的次数，以此向开发者收费。

目前豆瓣图书的API是0.3元/100次。



### 1.2 Django REST framework序列化


序列化（Serialization）是指将对象的状态信息转换为可以存储或传输形式的过程。在客户端与服务端传输的数据形式主要分为两种：XML和JSON。

在Django中的序列化就是指将对象状态的信息转换为JSON数据，以达到将数据信息传送给前端的目的。

序列化是开发API不可缺少的一个环节，Django本身也有一套做序列化的方案，这个方案可以说已经做得很好了，但是若跟Django REST framework相比，还是不够极致，速度不够快。




#### 1.2.1 Postman的使用

Postman是一款非常流行的API调试工具，其使用简单、方便，而且功能强大。

通过Postman可以便捷地向API发送GET、POST、PUT和DELETE请求，几乎是资深或者伪资深开发人员调试API的首选。

当然，这并不是Postman在开发领域如此受欢迎的唯一理由。

Postman最早是以Chrome浏览器插件的形式存在，可以从Chrome应用商店搜索、下载并安装，后来因为一些原因，Chrome应用商店在国内无法访问，2018年Postman停止了对Chrome浏览器的支持，提供了独立安装包，不再依赖Chrome，同时支持Linux、Windows和Mac OS系统。

测试人员做接口测试会有更多选择，例如Jmeter和soapUI等，因为测试人员就是完成产品的测试，而开发人员不需要有更多的选择，毕竟开发人员是创新者、创造者。

Postman的下载地址是 https://www.getpostman.com/apps 。



#### 1.2.2 用serializers.Serializer方式序列化


（1）打开项目book。

（2）安装Django REST framework及其依赖包markdown和django-filter。命令如下：

```sh
pip install djangorestframework markdown django-filter
```

（3）在settings中注册，代码如下：

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



（4）设计users的models.py，重构用户表UserProfile，增加字段APIkey和money。当然，为了演示核心功能，可以建立一张最简单的表，大家可以根据个人喜好增加一些业务字段来丰富项目功能。

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

（5）在settings中配置用户表的继承代码：

```python
AUTH_USER_MODEL='users.UserProfile'
```


（6）在users的models.py文件中新建书籍信息表book，为了演示方便，我们姑且将作者字段并入书籍信息表，读者在实际项目中可根据业务模式灵活设计数据表model：


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

（8）建立一个超级用户，用户名为admin，邮箱为 1@1.com ，密码为admin1234。

```sh
python manage.py createsuperuser

Username: admin

邮箱: 1@1.com

Password:

Password (again):
```

（9）通过PyCharm的Databases操作面板，直接在book表内增加一条记录，title为三国演义，isbn为777777，author为罗贯中，publish为一个出版社，rate为6.6，add_time为154087130331。



（10）准备工作已经完成，接下来是我们的“正片”开始啦。在users目录下新建py文件serializers，将序列化的类代码写入其中：

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


（11）在users/views中编写视图代码：

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


（12）在urls中配置路由如下：


```python
from django.contrib import admin
from django.urls import path
from users.views import BookAPIView1

urlpatterns = [
    path('admin/', admin.site.urls),
    path('apibook1/', BookAPIView1.as_view(), name='book1'),
]
```

至此，我们可以运行book项目，使用Postman访问API来测试一下啦。我们用Postman的GET方式访问API：


http://127.0.0.1:8000/apibook1/?apikey=abcdefghigklmn&isbn=777777


我们获得了想要的JSON数据：

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

然后到数据库中查看一下，发现用户admin的money被减去了1，变成了9。当我们用Postman故意填错apikey时，访问：





当我们连续访问10次：

http://127.0.0.1:8000/apibook1/?apikey=abcdefghigklmn&isbn=777777



API返回的数据为：


```json
"兄弟，又到了需要充钱的时候！好开心啊！"
```



至此，一个简单的模仿豆瓣图书API的功能就实现了。在实际的项目中，这样的实现方式虽然原理很清晰，但是存在着很明显的短板，比如被查询的表的字段不可能只有几个，我们在真正调用豆瓣图书API的时候就会发现，即使只查询一本书的信息，由于有很多的字段和外键字段，返回的数据量也会非常大。如果使用Serializer进行序列化，那么工作量实在太大，严重影响了开发效率。

所以，这里使用Serializer进行序列化，目的是让大家通过这种序列化方式更加轻松地理解Django REST framework的序列化原理。在实际生产环境中，更加被广泛应用的序列化方式是采用了Django REST framework的ModelSerializer。


#### 1.2.3 用serializers.ModelSerializer方式序列化

我们将要使用Django REST framework的ModelSerializer来实现这个功能。因为都是在book项目中，所以上一节中介绍的很多步骤我们没有必要重复。

我们现在要做的，首先是到数据库中的UserProfile表中，将用户admin的money从0修改回10，不然API只能返回提醒充值的数据。

在 users/Serializer.py 中，写book的ModelSerializer序列化类：

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



在 users/views.py 中，编写基于 BookModelSerializer 的图书API视图类：

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


> 注意： 使用ModelSerializer序列化对应的视图类与使用Serializer进行序列化对应的视图类，除了序列化的方式不同，其他的代码都是相同的。

在urls中配置路由代码：

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

使用Postman对API进行测试，用GET的方式访问：


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

> 注意： 这里的add_time字段为null，是因为这个项目使用了Django默认的db.sqlite3数据库。由于db.sqlite3在存储时间字段的时候，是以时间戳的格式保存的，
> 所以直接使用Django REST framework的Serializer进行序列化失败。在实际项目中，我们会选择MySQL等主流数据库，就不会出现这种情况了


可以看出，对于一条有很多字段的数据记录来说，使用ModelSerializer的序列化方式，可以一句话将所有字段序列化，非常方便。

当然，ModelSerializer也可以像Serializer一样对某几个特定字段进行序列化，写法也很简单，只需要对原本的BookModelSerializer修改一行代码：


```python
class BookModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        # fields = "__all__"  # 将整个表的所有字段都序列化
        fields = ('title', 'isbn', 'author')  # 指定序列化某些字段
```



使用Postman对API进行测试，用GET的方式访问：

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




#### 1.2.4 Serializer和ModelSerializer序列化选择

我们对Django REST framework的两种序列化方式做一个总结：

Serializer和ModelSerializer两种序列化方式中，前者比较容易理解，适用于新手；后者则在商业项目中被使用的更多，在实际开发中建议大家多使用后者。

许多教材中都将Django REST framework的Serializer和ModelSerializer,与Django的Form和ModelForm做对比，虽然二者相似，在优劣选择上却是不同的。Form虽然没有ModelForm效率高，但是ModelForm的使用增加了项目的耦合度，不符合项目解耦原则，所以Form比ModelForm更优（除了字段量过大的情况）；

而ModelSerializer有Serializer所有的优点，同时并没有比Serializer明显的不足之外，所以ModelSerializer比Serializer更优。

ModelSerializer与常规的Serializer相同，但提供了：


- 自动推断需要序列化的字段及类型
- 提供对字段数据的验证器的默认实现
- 提供了修改数据需要用到的 `.create()` 、 `.update()` 方法的默认实现

另外我们还可以在 fileds 列表里挑选出需要的数据，以便减小数据的体积。




#### 1.2.5 HyperlinkedModelSerializer序列化方式

HyperlinkedModelSerializer 基本上与之前用的 ModelSerializer 差不多，区别是它自动提供了外键字段的超链接，并且默认不包含模型对象的 id 字段。

HyperlinkedModelSerializer与ModelSerializer有以下区别：

- 默认情况下不包括id字段。
- 它包含一个url字段，使用HyperlinkedIdentityField。
- 关联关系使用HyperlinkedRelatedField，而不是PrimaryKeyRelatedField。



参考文献：

https://q1mi.github.io/Django-REST-framework-documentation/api-guide/serializers_zh/#hyperlinkedmodelserializer


#### 1.2.6 总结

ModelSerializer比Serializer好用是模型序列化的首选方案!

参考文献：

https://www.cnblogs.com/gengfenglog/p/14658470.html#_lab2_0_4

https://www.cuiliangblog.cn/detail/article/13




### 1.3 Django REST framework视图三层封装
































[Django REST Framework](https://www.yuque.com/wslynn/python/ouh3zo)


[DRF知识点总结](https://www.yuque.com/cuiliang0302/python/enqmvp)


[DRF](http://www.sunrisenan.com/docs/drf/drf-1do8mau479ha8)


[Django-Vue搭建个人博客](https://www.dusaiphoto.com/article/77/)


[Django REST Framework教程](https://pythondjango.cn/django/rest-framework-tutorials)


[Django drf 从入门到精通](https://www.cnblogs.com/bladecheng/p/11565336.html)