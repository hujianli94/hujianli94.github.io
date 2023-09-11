# 附-Flask数据模型

**使用SQLAlchemy创建数据模型**


## 项目结构

```shell
├── app
│     ├── __init__.py
│     └── models.py
├── config.py
├── data-test.sqlite
├── ext.py
├── main.py
├── migrations
│     ├── alembic.ini
│     ├── env.py
│     ├── README
│     ├── script.py.mako
│     └── versions
│         └── ee06d6fc8256_.py
├── README.md
├── requirements.txt
├── static
├── templates
└── venv
```


## 安装依赖

使用pip安装Flask SQLAlchemy,运行如下命令：

```shell
pip install flask-sqlalchemy
pip install flask-migrate
```

我们还需要安装一些特定的包，作为SQLAlchemy与你所选择的数据库之间的连接器。

SQLite用户可以跳过这一步：
```shell
# MySQL
pip install PyMySoL

# Postgres
pip install psycopg2

# MSSOL
pip install pyodbc

# Oracle
pip install cx_Oracle
```


## 初始化迁移数据

Linux 和 macOS 用户这样做：
```shell


(venv) $ export FLASK_APP=main.py
(venv) $ export FLASK_DEBUG=1
````

微软 Windows 用户这样做：

```shell
(venv) $ set FLASK_APP=main.py
(venv) $ set FLASK_DEBUG=1
```


创建数据
```shell
# init 子命令添加数据库迁移支持
(venv) $ flask db init
#flask db migrate 子命令用于自动创建迁移脚本：
(venv) $ flask db migrate
# 或者
#(venv) $ flask db migrate -m "initial migration"

# 可使用下述命令创建数据表或者升级到最新修订版本
(venv) $ flask db upgrade
```

初始化数据库命令
```shell
# 此命令会删除数据重新创建数据库
(venv) $ flask initdb --drop
This operation will delete the database, do you want to continue? [y/N]: y
```


## 数据库操作

创建表

```shell
(venv) D:\flask-demo\chapter2>set FLASK_APP=main.py
(venv) D:\flask-demo\chapter2>set FLASK_DEBUG=1
(venv) D:\flask-demo\chapter2>flask shell
>>> from main import db
>>> db.create_all()
```


删除表
```shell
>>> db.drop_all()
```


## CRUD

### 新增数据

```shell
>>> from main import User,db
>>> user1 = User(username='hujianli1')
>>> user2 = User(username='hujianli2')
>>> db.session.add(user1)
>>> db.session.add(user2)
>>> db.session.commit()
```


### 读取数据

```shell
# 使用a11()获取数据库中的所有行，并作为列表返回。
>>> from main import User
>>> users = User.query.all()
>>> users
[<User hujianli>]

# SOLAlchemy里，我们可以使用limit函数来指定希望返回的总行数：
>>> users = User.query.limit(10).all()
>>> users
[<User hujianli>]

## SOLAlchemy里默认会根据主键排序并返回记录，我们可以使用order_by函数，使用方式如下：
# 正向排序
>>> users = User.query.order_by(User.username).all()
# 逆向排序
>>> users = User.query.order_by(User.username.desc()).all()

# 如果想只返回一行数据，则可以使用first()来替代a11():
>>> user = User.query.first()
>>> user.username
'hujianli'

# 要通过主键取得一行数据，可使用query.get():
>> user = User.query.get(1)
>>> user.username
'hujianli'

# 所有的这些函数都是可以链式调用的，也就是说，可以把它们追加在一起，来修改最终的返回结果。我们如果精通JavaScript,则会对这样的语法非常熟悉。
>>> users = User.query.order_by(User.username.desc()).limit(10).first()
>>> users.username
'hujianli'
# first()和a11()方法会返回结果，并且终止链式调用。
```

SOLAlchemy的专有方法-分页pagination

```shell
>>> from main import User,Post
>>> Post.query.paginate(1,10)
<flask sqlalchemy.Pagination at 0x105118f50>

# 这个对象有几个有用的属性：
>>> page = User.query.paginate(1,10)

# 返回这一页包含的数据对象
>>> page.items

# 返回这一页的页数
>>page.page
1
#返回总页数
>>page.pages
1
#上一页和下一页是否有对象可以显示
>>page.has_prev,page.has_next
(False,False)
#返回上一页和下一页的pagination对象
#如果不存在的话则返回当前页
>>page.prev(),page.next()
(<flask sqlalchemy.Pagination at 0x10812da50>,
<flask sqlalchemy.Pagination at 0x1081985d0>)
```


### 条件查询

```shell
>>> users = User.query.filter_by(username='hujianli').all()

>>> users = User.query.order_by(User.username.desc()).filter_by(username='hujianli').limit(2).all()

>>> user = User.query.filter(User.id > 1).all()
```


一些复杂的SQL查询也可以转为用SQLAlchemy的函数来表示。例如，可以像 下面这样实现SQL中IN、OR和NOT的比较操作。
```shell
>>> from sqlalchemy.sql.expression import not_, or_

>>> user = User.query.filter(User.username.in_(['hujianli']), User.password == None ).first()

# 找出拥有密码的用户
>>> user = User.query.filter(not_(User.password == None)).first()

# 这些方法都可以被组合起来
>>> user = User.query.filter(or_(not_(User.password == None),User.id >= 1)).first()
>>> user = User.query.filter(or_(not_(User.password == None),User.id >= 1)).all()
```

在SQLAlchemy中，与None的比较会被翻译成与NULL的比较。



### 修改数据

在使用first()或者all()等方法返回数据之前，调用update方法可以修改已存 在的数据的值。

```shell
>>> User.query.filter_by(username='hujianli2').update({ 'password':'test' })

# 对数据模型的修改已被自动加入session中
>>> db.session.commit()
```


### 删除数据

```shell
#如果我们要从数据库中删除一行数据，则可以：
>>> user = User.query.filter_by(username='hujianli2').first()
>>> db.session.delete(user)
>>> db.session.commit()
```


## 数据模型之间的关联

### 一对多

现在让我们来创建第1个关联关系。在我们的博客网站上会有一些博客文章，每篇文章都有一个特定的作者。
通过把每个作者的文章跟这个作者建立关联，可以方便地获取这个作者的所有文章，这显然是合理的做法。这就是一对多关系的一个范例。

```python
from ext import db
class User(db.Model):
    """
    作者表
    """
    id = db.Column(db.Integer(), primary_key=True)
    username = db.Column(db.String(255))
    password = db.Column(db.String(255))
    # db.relationship函数在SQLAlchemy中创建了一个虚拟的列，它会和我们的Post对象中的db.ForeignKey建立联系。
    # dynamic关联对象会在被使用的时候再加载，并且在返回前进行过滤，如果数据多，变化多久采用这种方式。
    posts = db.relationship("Post", backref='user', lazy='dynamic')

    def __init__(self, username):
        self.username = username

    def __repr__(self):
        # formats what is shown in the shell when print is
        # called on it
        return '<User {}>'.format(self.username)


class Post(db.Model):
    """
    博客文章表
    """
    id = db.Column(db.Integer(), primary_key=True)
    title = db.Column(db.String(255))
    text = db.Column(db.Text())
    publish_date = db.Column(db.DateTime())
    # 外健约束，保证每个Post对象都会对应一个已有的user
    user_id = db.Column(db.Integer(), db.ForeignKey('user.id'))

    def __init__(self, title):
        self.title = title

    def __repr__(self):
        return "<Post '{}'>".format(self.title)
```




```shell
>>> from main import User
>>> user = User.query.get(1)
>>> new_post = Post('Post Title')
>>> new_post.user_id = user.id
>>> posts = user.posts.all()
>>> posts
[]
>>> db.session.add(new_post)
>>> db.session.commit()
>>> posts = user.posts.all()
>>> posts
[<Post 'Post Title'>]
```

可以从上面的例子中注意到，在把新增变更提交进数据库之前，是无法通过关联对象获取新的Post对象的。




backref参数则可以使我们通过Post.user属性对User对象进行读取和修改。例如：

```shell
>>> second_post = Post('Second Title')
>>> second_post.user = user
>>> db.session.add(second_post)
>>> db.session.commit()

>> user.posts.all()
[<Post 'Post Title'>,<Post 'Second Title'>]

# 由于user.posts是一个列表，所以我们也可以通过把Post对象直接添加进这个列表，来自动保存它：
>>> second_post = Post('Second Title')
>>> user.posts.append(second_post)
>>> db.session.add(user)
>>> db.session.commit()
>>> user.posts.all()
[<Post 'Post Title'>, <Post 'Second Title'>, <Post 'Second Title'>]

# 由于backref选项被设置为动态方式，所以我们既可以把这个关联字段看作列表，也可以把它看作一个查询对象：
>>> user.posts.all()
[<Post 'Post Title'>,<Post 'Second Title'>]

>>> user.posts.order_by(Post.publish_date.desc()).all()
[<Post 'Post Title'>, <Post 'Second Title'>, <Post 'Second Title'>]
```

在开始学习下一种关联类型之前，我们再创建一个数据模型，用来实现用户评论，并加上一对多的关联



```python
from ext import db
class Post(db.Model):
    """
    博客文章表
    """
    id = db.Column(db.Integer(), primary_key=True)
    title = db.Column(db.String(255))
    text = db.Column(db.Text())
    publish_date = db.Column(db.DateTime())
    # db.relationship函数在SQLAlchemy中创建了一个虚拟的列，它会和我们的Post对象中的db.ForeignKey建立联系。
    # backref 在关系的另一个模型中添加反向引用
    # dynamic关联对象会在被使用的时候再加载，并且在返回前进行过滤，如果数据多，变化多久采用这种方式。
    comments = db.relationship("Comment", backref="post", lazy="dynamic")
    # 外健约束，保证每个Post对象都会对应一个已有的user
    user_id = db.Column(db.Integer(), db.ForeignKey('user.id'))

    def __init__(self, title):
        self.title = title

    def __repr__(self):
        return "<Post '{}'>".format(self.title)


class Comment(db.Model):
    """
    用户评论表
    """
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(255))
    text = db.Column(db.Text())
    date = db.Column(db.DateTime())
    post_id = db.Column(db.Integer(), db.ForeignKey('post.id'))

    def __repr__(self):
        return "<Comment '{}'>".format(self.text[:15])
```


### 多对多

如果我们有两个数据模型，它们不但可以互相引用，而且其中的每个对象都可以引用多个对应的对象，那应该怎么做呢？
比如，我们的博客文章需要加上标签，这样用户就能轻松地把相似的文章分组。
每个标签都对应了多篇文章，而每篇文章同时对应了多个标签。

这样的关联方式叫作多对多的关联。考虑如下的例子：

```python
from ext import db
tags = db.Table(
    'post_tags',
    db.Column('post_id', db.Integer, db.ForeignKey('post.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)

class Post(db.Model):
    """
    博客文章表
    """
    id = db.Column(db.Integer(), primary_key=True)
    title = db.Column(db.String(255))
    text = db.Column(db.Text())
    publish_date = db.Column(db.DateTime())
    # db.relationship函数在SQLAlchemy中创建了一个虚拟的列，它会和我们的Post对象中的db.ForeignKey建立联系。
    # backref 在关系的另一个模型中添加反向引用
    # dynamic关联对象会在被使用的时候再加载，并且在返回前进行过滤，如果数据多，变化多久采用这种方式。
    comments = db.relationship("Comment", backref="post", lazy="dynamic")
    # 外健约束，保证每个Post对象都会对应一个已有的user
    user_id = db.Column(db.Integer(), db.ForeignKey('user.id'))
    tags = db.relationship('Tag', secondary=tags, backref='posts')

    def __init__(self, title):
        self.title = title

    def __repr__(self):
        return "<Post '{}'>".format(self.title)


class Tag(db.Model):
    """
    标签表
    """
    id = db.Column(db.Integer(), primary_key=True)
    title = db.Column(db.String(255))

    def __init__(self, title):
        self.title = title

    def __repr__(self):
        return "<Tag '{}'>".format(self.title)
```


db.Table对象对数据库的操作比db.Model更底层。

db.Mode1是基于db.Table提供的一种对象化包装方式，用来表示数据库表里的某行记录。这里之所以使用了 db.Table,正是因为我们不需要专门读取这个表的某行记录。

我们来手工造一些数据到`post_tags`表中

```sql
INSERT INTO post_tags (post_id, tag_id) VALUES(1, 1);
INSERT INTO post_tags (post_id, tag_id) VALUES(1, 3);
INSERT INTO post_tags (post_id, tag_id) VALUES(2, 3);
INSERT INTO post_tags (post_id, tag_id) VALUES(2, 4);
INSERT INTO post_tags (post_id, tag_id) VALUES(2, 5);
INSERT INTO post_tags (post_id, tag_id) VALUES(3, 1);
INSERT INTO post_tags (post_id, tag_id) VALUES(3, 2);
```

你可以把这组数据简单地理解为标签和文章的关联关系。


在上面的程序中我们又使用了db.relationship函数来设置所需的关联，但这次多传了一个secondary(次级)参数，secondary参数会告知SQLAlchemy该关联被保存在tags表里。

让我们在下面的代码中体会一下这种用法：

```shell
>>> post_one = Post.query.filter_by(title='Post Title').first()
>>> post_two = Post.query.filter_by(title='Second Title').first()
>>> tag_one = Tag('Python')
>>> tag_two = Tag('SQLAlchemy')
>>> tag_three = Tag('Flask')
>>> post_one.tags = [tag_two]
>>> post_two.tags = [tag_one,tag_two,tag_three]
>>> tag_two.posts
[<Post 'Post Title'>,<Post 'Second Title'>]
>>> db.session.add(post_one)
>>> db.session.add(post_two)
>>> db.session.commit()
```

在设置一对多的关联时，主关联字段实际上是一个列表。

现在主要的不同之处在于， backref也变成了一个列表。

由于它是个列表，所以我们也可以像这样把文章加到标签里：

```shell
>>> tag_one.posts.append(post_one)
>>> tag_one.posts
[<Post 'Second Title'>, <Post 'Post Title'>]
>>> post_one.tags
[<Tag 'SQLAlchemy'>, <Tag 'Python'>]
>>> db.session.add(tag_one)
>>> db.session.commit()
```


## 使用flask-migrate进行数据迁移

```shell
pip install flask-migrate
```


将命令加入到main.py中，如下

```python
import os
from flask_migrate import Migrate
from app import create_app
from ext import db
from app.models import User, Post
import click

app = create_app(os.getenv('FLASK_CONFIG') or 'default')
# 传入2个对象一个是flask的app对象，一个是SQLAlchemy
migrate = Migrate(app, db)


@app.shell_context_processor
def make_shell_context():
    """
    :return:
    """
    return dict(app=app, db=db, User=User, Post=Post)


@app.cli.command()
@click.option('--drop', is_flag=True, help='Create after drop.')
def initdb(drop):
    """Init databases."""
    if drop:
        click.confirm(
            'This operation will delete the database, do you want to continue?',
            abort=True)
        db.drop_all()
        click.echo('Drop tables.')
    db.create_all()
    click.echo('Initialized database.')
```


常用命令

```shell
# init 子命令添加数据库迁移支持
(venv) $ flask db init
#flask db migrate 子命令用于自动创建迁移脚本：
(venv) $ flask db migrate
# 或者
#(venv) $ flask db migrate -m "initial migration"

# 可使用下述命令创建数据表或者升级到最新修订版本
(venv) $ flask db upgrade


# 要返回以前的版本，则可以根据history命令找到版本号，然后传给downgrade命
(venv) $ flask db history 
(venv) $ flask db downgrade ee06d6fc8256
```



## demo程序

[Gitee仓库地址](https://gitee.com/Flask-devops/flask-demo/blob/master/chapter2/README.md)