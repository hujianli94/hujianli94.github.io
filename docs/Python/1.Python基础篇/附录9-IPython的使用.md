# 附录 9-IPython 的使用

## 使用?获取文档

```sh
(py38) root@hujianli722:/home/hujianli# ipython3

In [1]: help(len)


In [2]: len?
Signature: len(obj, /)
Docstring: Return the number of items in a container.
Type:      builtin_function_or_method

In [3]: L = [1, 2, 3]

In [4]: L.insert?
Signature: L.insert(index, object, /)
Docstring: Insert object before index.
Type:      builtin_function_or_method

In [5]: L?
Type:        list
String form: [1, 2, 3]
Length:      3
Docstring:
Built-in mutable sequence.

If no argument is given, the constructor creates a new empty list.
The argument must be an iterable if specified.

# 这个符号还能应用在你自己创建的对象和其他对象上
In [6]: def square(a):
   ...:     """Return the square of a."""
   ...:     return a ** 2
   ...:

In [7]: square?
Signature: square(a)
Docstring: Return the square of a.
File:      /home/hujianli/<ipython-input-6-6791e4c7289d>
Type:      function

```

## 使用??获取源代码

```sh
In [8]: square??
Signature: square(a)
Source:
def square(a):
    """Return the square of a."""
    return a ** 2
File:      /home/hujianli/<ipython-input-6-6791e4c7289d>
Type:      function
```

## 使用 Tab 补全来探索模块

### 对象内容的 Tab 补全

```sh
In [9]: L.append
           append()  count()   insert()  reverse()
           clear()   extend()  pop()     sort()
           copy()    index()   remove()
           function(object)

In [9]: L.c<tab>
            clear()
            copy()
            count()

In [9]: L.co<tab>
             copy()
             count()

In [9]: L.__<tab>
             __add__             __doc__             __gt__              __iter__            __new__()           __setattr__
             __class__           __eq__              __hash__            __le__              __reduce__()        __setitem__
             __contains__        __format__()        __iadd__            __len__             __reduce_ex__()     __sizeof__()
             __delattr__         __ge__              __imul__            __lt__              __repr__            __str__
             __delitem__         __getattribute__    __init__            __mul__             __reversed__()      __subclasshook__()
             __dir__()           __getitem__()       __init_subclass__() __ne__              __rmul__
```

### 当载入模块是使用 tab 补全

```sh
In [10]: from itertools import co<TAB>
combinations                   compress
combinations_with_replacement  count

In [10]: import h<TAB>
hashlib             hmac                http
heapq               html                husl
```

### Tab 补全进阶：通配符匹配

这里的\*号能匹配任何字符串，包括空字符串。

```sh
# 如果我们希望找到所有名称中含有find字符串的对象内容，我们可以这样做：

In [9]: str.*find*?
str.find
str.rfind
```

## history 历史命令

在 IPython 中，执行 %history 或 %hist 命令能够查看历史输入。

```sh
In [10]: %history
help(len)
len?
L = [1, 2, 3]
L.insert?
L?
def square(a):
    """Return the square of a."""
    return a ** 2
square?
square??
str.*find*?
%history

In [11]: %hist
help(len)
len?
L = [1, 2, 3]
L.insert?
L?
def square(a):
    """Return the square of a."""
    return a ** 2
square?
square??
str.*find*?
%history
%hist


# 下面例子展示了如何使用它打印出输入历史中头四个指令：
In [16]: %history -n 1-4
   1: import math
   2: math.sin(2)
   3: math.cos(2)
   4: print(In)
```

## `! shell_command` 执行 shell 命令

shell （windows 里叫作 cmd）表示使用文本与计算机进行交互的方式，在 IPython 中，shell 命令前加上感叹号!（英文输入法）就可以直接执行。

```sh
In [12]: !ping www.baidu.com
PING www.baidu.com (183.240.98.198) 56(84) bytes of data.
64 bytes from 183.240.98.198 (183.240.98.198): icmp_seq=1 ttl=52 time=14.6 ms
64 bytes from 183.240.98.198 (183.240.98.198): icmp_seq=2 ttl=52 time=15.9 ms
```

## 魔法命令%和%%区别

### %run

魔法命令分为两种，一种是 line magics，另外一种 cell magics。Line magic 是通过在前面加%，表示 magic 只在本行有效。

Cell magic 是通过在前面加%%，表示 magic 在整个 cell 单元有效。

例如，你创建了一个 myscript.py 文件，里面的内容是：

```python
#-------------------------------------
# file: myscript.py
def square(x):
    """square a number"""
    return x ** 2

for N in range(1, 4):
    print(N, "squared is", square(N))
```

你可以在你的 IPython shell 中这样执行这个 Python 代码文件：

```sh
In [6]: %run myscript.py
1 squared is 1
2 squared is 4
3 squared is 9

# 当你执行完这个脚本文件之后，任何定义了的函数也可以在你当前的IPython会话中使用了。
In [15]: square(2)
Out[15]: 4

# 如果你想查看这个脚本文件的内容，你可以使用%load魔法命令：
In [16]: %load myscript.py
```

### %load 加载代码

%load 命令用于将脚本代码加载到当前 cell。

## \_打印前输出结果

使用一个下划线 \_ 获取前一个输出结果，它是个变量，实时更新的。

使用两个下划线 **可以获取倒数第二个输出，使用三个下划线 \_** 获取倒数第三个输出（没有输出的命令行不计入在内，只支持前三个输出结果）。

```sh
In [1]: a=1

In [2]: b=2

In [3]: a
Out[3]: 1

In [4]: b
Out[4]: 2

In [5]: _
Out[5]: 2

In [6]: ___
Out[6]: 1

```

## 取消输出

在语句后面加上;，不显示输出结果。

```sh
In [5]: def f():
   ...:     return 'hello'
   ...:

In [6]: f()
Out[6]: 'hello'

In [7]: f();
```

## 代码执行计时：%timeit

### %timeit 来测量单行代码的运行时间

下面介绍的魔术命令是%timeit，它会自动测试统计紧跟之后的单行 Python 语句的执行性能（时间）。例如我们需要测试列表解析的性能：

```sh
In [22]:  %timeit L = [n ** 2 for n in range(1000)]
1000 loops, best of 3: 325 µs per loop
```

使用%timeit 的时候，它会自动执行多次，以获取更有效的结果。

### %%timeit 来测量多行代码的运行时间

对于多行的代码来说，增加一个%号，会将本魔术命令变成单元格模式，因此它能测试多行输入的性能。例如，下面是一段相同功能的列表初始化，使用的 for 循环：

```sh
In [9]: %%timeit
   ...: L = []
   ...: for n in range(1000):
   ...:     L.append(n ** 2)
   ...:
1000 loops, best of 3: 373 µs per loop
```

## %pip 安装第三方库

```sh
In [25]: %pip install requests
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Requirement already satisfied: requests in /usr/lib/python3/dist-packages (2.22.0)
Note: you may need to restart the kernel to use updated packages.
```

## %quickref 查看参考

%quickref 用来查看 IPython 的特定语法和魔法命令参考。

```sh
In [27]: %quickref
obj?, obj??      : Get help, or more help for object (also works as
                   ?obj, ??obj).
?foo.*abc*       : List names in 'foo' containing 'abc' in them.
%magic           : Information about IPython's 'magic' % functions.
# ...

Example magic function calls:

%alias d ls -F   : 'd' is now an alias for 'ls -F'
alias d ls -F    : Works if 'alias' not a python name
alist = %alias   : Get list of aliases to 'alist'
cd /usr/share    : Obvious. cd -<tab> to choose from visited dirs.
%cd??            : See help AND source for magic %cd
%timeit x=10     : time the 'x=10' statement with high precision.
%%timeit x=2**100
x**100           : time 'x**100' with a setup of 'x=2**100'; setup code is not
                   counted.  This is an example of a cell magic.

System commands:

!cp a.txt b/     : System command escape, calls os.system()
cp a.txt b/      : after %rehashx, most system commands work without !
cp ${f}.txt $bar : Variable expansion in magics and system commands
files = !ls /usr : Capture system command output
files.s, files.l, files.n: "a b c", ['a','b','c'], 'a\nb\nc'

History:

_i, _ii, _iii    : Previous, next previous, next next previous input
_i4, _ih[2:5]    : Input history line 4, lines 2-4
exec _i81        : Execute input history line #81 again
%rep 81          : Edit input history line #81
# ...
```

## 魔术命令帮助：?、%magic 和 %lsmagic

就像普通的 Python 对象，IPython 魔术命令也有 docstring，这些文档可以按照我们之前的方式简单的获取到。举个例子，想要查阅%timeit 的文档，仅需输入：

```sh
In [10]: %timeit?
```

其他魔术命令和文档也可以类似获得。要获得魔术命令的通用描述以及它们的例子，你可以输入：

```sh
In [11]: %magic
```

如果想要快速简单地列出所有可用的魔术命令，输入：

```sh
In [12]: %lsmagic
```

## IPython 中的 shell 命令

任何在命令行中可以使用的命令，也都可以在 IPython 中使用，只需要在前面加上!号。例如，ls、pwd 和 echo 命令：

```sh
In [1]: !ls
myproject.txt

In [2]: !pwd
/home/jake/projects/myproject

In [3]: !echo "printing from the shell"
printing from the shell

In [4]: contents = !ls

In [5]: print(contents)
['myproject.txt']

In [6]: directory = !pwd

In [7]: print(directory)
['/Users/jakevdp/notebooks/tmp/myproject']

In [9]: message = "hello from Python"

In [10]: !echo {message}
hello from Python
```

## %who 显示变量

%who 命令用于显示当前所有变量，你也可以指定显示变量的类型。

```sh
In [22]: %who
a        b       x

In [23]: %who int
a        b
```

## %rerun 执行前代码

%rerun 命令用于执行之前的代码，可以指定历史代码行，默认最后一行。

```sh
In [28]: %rerun
In [29]: %rerun 25-27
```

## %paste 粘贴代码块

当你使用 IPython 解释器时，有件事经常让你头疼，那就是粘贴多行代码块可能会导致不可预料的错误，尤其是其中包含缩进和解释符号时。
使用%paste 命令能够直接执行剪切板中的 python 代码块。

```sh
In [29]: %paste
```

## 错误和调试

### %xmode 控制异常

%xmode 命令用于控制异常输出的模式。

```sh
In [24]: %xmode Plain
In [25]: def func1(a, b):
 ...:     return a / b
 ...:

In [26]: def func2(x):
...:     a = x
...:     b = x - 1
...:     return func1(a, b)
...:
In [27]: func2(1)
Traceback (most recent call last):
  File "<ipython-input-27-7cb498ea7ed1>", line 1, in <module>
    func2(1)
  File "<ipython-input-26-25e419aa729c>", line 4, in func2
    return func1(a, b)
  File "<ipython-input-25-165aea2c932f>", line 2, in func1
    return a / b
ZeroDivisionError: division by zero

```

### %save 保存 cell

%save path n1 n2..命令用于将指定 cell 代码保存到指定的 py 文件中。

```sh
In [29]: %save myscript.py 25-27
File `myscript.py` exists. Overwrite (y/[N])?  y
The following commands were written to file `myscript.py`:
def func1(a, b):
    return a / b

def func2(x):
    a = x
    b = x - 1
    return func1(a, b)

func2(1)
```

### %pdb 交互式调试器

%pdb 同样用于启动交互式调试器，不过支持对所有的异常进行调试。你需要事先启动%pdb 命令，之后对每一个异常都会进行调试。

```sh
In [39]: %pdb on
Automatic pdb calling has been turned ON

In [40]: obj = [1,2,3]

In [41]: obj[4]
Traceback (most recent call last):
  File "<ipython-input-41-482f5555f62a>", line 1, in <module>
    obj[4]
IndexError: list index out of range

> <ipython-input-41-482f5555f62a>(1)<module>()
----> 1 obj[4]

ipdb>
```

### %run -d 交互式调试器

%run -d 用于对脚本进行调试。

```python
(py38) root@hujianli722:/home/hujianli# cat myscript.py
def f():
    obj = [1,2,3]
    obj[4]

f()
```

```sh
In [42]: %run -d myscript.py
Breakpoint 1 at /home/hujianli/myscript.py:1
NOTE: Enter 'c' at the ipdb>  prompt to continue execution.
> /home/hujianli/myscript.py(1)<module>()
1---> 1 def f():
      2     obj = [1,2,3]
      3     obj[4]
      4
      5 f()

ipdb> d
*** Newest frame
ipdb> s
> /home/hujianli/myscript.py(5)<module>()
1     1 def f():
      2     obj = [1,2,3]
      3     obj[4]
      4
----> 5 f()

ipdb> s

```

### %debug 交互式调试器

%debug 命令支持从最新的异常跟踪的底部进入交互式调试器。在 ipdb 调试模式下能访问所有的本地变量和整个栈回溯。

使用 u 和 d 向上和向下访问栈，使用 q 退出调试器。在调试器中输入?可以查看所有的可用命令列表。

以下是一些常用的 pdb 命令：

- n：单步执行代码，不进入函数内部。
- s：单步执行代码，进入函数内部。
- c：继续执行代码，直到下一个断点。
- q：退出调试模式。
- p variable：打印变量的值。
- pp expression：打印表达式的值。
