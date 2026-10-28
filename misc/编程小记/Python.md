## Python查漏补缺
---

### 错误和异常语句
[官方文档链接](https://docs.python.org/zh-cn/3/tutorial/errors.html#errors-and-exceptions)

#### 两种错误：
> + 语法错误 `SyntaxError`
> + 异常 
>

**异常：**<font style="color:rgb(0, 0, 0);">即使语句或表达式使用了正确的语法，执行时仍可能触发错误。</font>

---

#### [<font style="color:rgb(0, 0, 0);">内置异常</font>](https://docs.python.org/zh-cn/3/library/exceptions.html#bltin-exceptions) (eg. ZeroDivisionError、NameError、TypeError...）
```python
10 * (1/0)

=====>
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ZeroDivisionError: division by zero

4 + spam*3

=====>
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'spam' is not defined

'2' + 2

=====> 
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can only concatenate str (not "int") to str
```

<font style="color:rgb(0, 0, 0);">作为异常类型打印的字符串是发生的内置异常的名称</font>

#### 异常的处理 try except
```python
while True:
    try:
        x = int(input("Please enter a number: "))
        break
    except ValueError: 
        '''会要求用户输入有效的整数'''
        print("Oops!  That was no valid number.  Try again...")
```

#### try语句的工作原理
> [try](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#try)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">语句的工作原理如下：</font>
>
> + <font style="color:rgb(0, 0, 0);">首先，执行</font><font style="color:rgb(0, 0, 0);"> </font>_<font style="color:rgb(0, 0, 0);">try 子句</font>_<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">（</font>[try](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#try)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">和</font><font style="color:rgb(0, 0, 0);"> </font>[except](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#except)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">关键字之间的（多行）语句）。</font>
> + <font style="color:rgb(0, 0, 0);">如果没有触发异常，则跳过</font><font style="color:rgb(0, 0, 0);"> </font>_<font style="color:rgb(0, 0, 0);">except 子句</font>_<font style="color:rgb(0, 0, 0);">，</font>[try](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#try)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">语句执行完毕。</font>
> + <font style="color:rgb(0, 0, 0);">如果在执行</font><font style="color:rgb(0, 0, 0);"> </font>[try](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#try)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">子句时发生了异常，则跳过该子句中剩下的部分。 如果异常的类型与</font><font style="color:rgb(0, 0, 0);"> </font>[except](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#except)<font style="color:rgb(0, 0, 0);"> </font><font style="color:rgb(0, 0, 0);">关键字后指定的异常相匹配，则会执行</font><font style="color:rgb(0, 0, 0);"> </font>_<font style="color:rgb(0, 0, 0);">except 子句</font>_<font style="color:rgb(0, 0, 0);">，然后跳到 try/except 代码块之后继续执行。</font>
> + <font style="color:rgb(0, 0, 0);">如果发生的异常与 </font>_<font style="color:rgb(0, 0, 0);">except 子句</font>_<font style="color:rgb(0, 0, 0);"> 中指定的异常不匹配，则它会被传递到外层的 </font>[try](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#try)<font style="color:rgb(0, 0, 0);"> 语句中；如果没有找到处理句柄，则它是一个 </font>_<font style="color:rgb(0, 0, 0);">未处理异常</font>_<font style="color:rgb(0, 0, 0);"> 且执行将停止并输出一条错误消息。</font>
>

#### <font style="color:rgb(0, 0, 0);">try&execpt语句可选else子句</font>
```python
for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()
```

#### 触发异常 raise
[raise](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#raise)<font style="color:rgb(0, 0, 0);"> 语句支持强制触发指定的异常。例如：</font>

```python
raise NameError('HiThere')
'''
@param: 异常实例 | 异常类（派生自BaseException类)
```

:::info
raise NameError('HiThere')  
Traceback (most recent call last):  
  File "<stdin>", line 1, in <module>  
NameError: HiThere

:::

#### 异常链
```python
except * as **:
    # experssion
    raise 
```

> + 如果一个未处理的异常发生在	`execpt`部分内，<font style="background-color:#FBDE28;">将会有被处理的异常附在它上面</font>，并包括在错误信息中。
> + 为了表明一个异常是另一个异常的直接后果，`rasie`语句允许一个可选的`from`子句
> + <font style="color:rgb(0, 0, 0);">使用 </font>`<font style="color:rgb(0, 0, 0);background-color:rgb(236, 240, 243);">from None</font>`<font style="color:rgb(0, 0, 0);background-color:rgb(236, 240, 243);"></font><font style="color:rgb(0, 0, 0);"> 表达禁用自动</font><font style="color:rgb(0, 0, 0);background-color:rgb(251, 229, 78);">异常链</font><font style="color:rgb(0, 0, 0);">:</font>
>

```python
def func():
    raise ConnectionError

try:
    func()
except ConnectionError as exc:
    '''
    @description: 未被处理的异常附到exc上
                  再使用rasie抛出对应的异常。
    @requirement: exc 必须是异常实例或 None
     '''
    raise RuntimeError('Failed to open database') from exc
=========================================================>
```

:::info
Traceback (most recent call last):

  File "<stdin>", line 2, in <module>

  File "<stdin>", line 2, in func

ConnectionError



The above exception was the direct cause of the following exception:



Traceback (most recent call last):

  File "<stdin>", line 4, in <module>

RuntimeError: Failed to open database

:::

#### 用户自定义异常
> 程序可以通过创建新的异常类命名自己的异常（Python 类的内容详见 [类](https://docs.python.org/zh-cn/3/tutorial/classes.html#tut-classes)）。不论是以直接还是间接的方式，异常都应从 [Exception](https://docs.python.org/zh-cn/3/library/exceptions.html#Exception) 类派生。
>
> 异常类可以被定义成能做其他类所能做的任何事，但通常应当保持简单，它往往只提供一些属性，允许相应的异常处理程序提取有关错误的信息。
>
> 大多数异常命名都以 “Error” 结尾，类似标准异常的命名。
>
> 许多标准模块定义了自己的异常，以报告他们定义的函数中可能出现的错误。
>

```python
class MyException(Exception):
    def __init__(self, code, message):
        self.code = code
        self.message = message

    def __str__(self):
        return f"MyError:{self.code}: {self.message}"


def divide(a, b):
    if b == 0:
        raise MyException(400, "Division by zero")
    return a / b


try:
    result = divide(4, 0)
except MyException as e:
    print(e)
```

  


---

### 复合语句
[官方文档链接](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#the-with-statement)

---

#### with语句
[详细文件读取例子链接](https://www.runoob.com/python3/python-with.html)

`with`语句是Python中用于管理资源的一种语法结构。它通常在那些需要一段代码执行前后进行资源分配和清理，比如文件操作、线程锁的获取和释放等。

```python
with expression as variable:
    # 代码块
```

<font style="color:rgb(13, 13, 13);">在这个结构中，</font>`expression`<font style="color:rgb(13, 13, 13);">通常是一个上下文管理器对象，它会返回一个实现了上下文管理协议的对象。</font>`<font style="color:rgb(13, 13, 13);">v</font>ariable`<font style="color:rgb(13, 13, 13);">是可选的，用来将上下文管理器对象绑定到一个变量上，以便在</font>`with`<font style="color:rgb(13, 13, 13);">语句块内使用。</font>

`with`<font style="color:rgb(13, 13, 13);">语句执行的步骤如下：</font>

> 1. <font style="color:rgb(13, 13, 13);">调用上下文管理器对象的</font>__enter__()<font style="color:rgb(13, 13, 13);">方法，这个方法负责分配资源或者进行一些准备工作，并将返回的对象（如果有的话）绑定到</font>as<font style="color:rgb(13, 13, 13);">后面指定的变量上。</font>
> 2. <font style="color:rgb(13, 13, 13);">执行</font>with<font style="color:rgb(13, 13, 13);">语句块中的代码。</font>
> 3. <font style="color:rgb(13, 13, 13);">不论</font>with<font style="color:rgb(13, 13, 13);">语句块中是否发生异常，都会调用上下文管理器对象的</font>__exit__()<font style="color:rgb(13, 13, 13);">方法，这个方法负责清理资源或者处理异常。</font>
>

with<font style="color:rgb(13, 13, 13);">语句的一个主要优点是它可以确保资源在使用完毕后被正确释放，即使在处理异常的情况下也不会忘记释放资源，因为</font>__exit__()<font style="color:rgb(13, 13, 13);">方法会在任何情况下都被调用。这使得代码更加健壮和清晰。</font>

<font style="color:rgb(13, 13, 13);">常见的使用场景包括</font>**<font style="color:rgb(13, 13, 13);">文件操作中的文件打开</font>**<font style="color:rgb(13, 13, 13);">、</font>**<font style="color:rgb(13, 13, 13);">网络连接的建立和关闭</font>**<font style="color:rgb(13, 13, 13);">、</font>**<font style="color:rgb(13, 13, 13);">数据库连接的获取和释放</font>**<font style="color:rgb(13, 13, 13);">等。</font>

---



## multiprocessing
> 基于进程的并行
>
> Lib/multiprocessing/
>



## Python导包
> [参考链接](https://joy9191.github.io/16196181446571.html)
>
> [官方文档链接](https://docs.python.org/zh-cn/3/reference/import.html#packages)
>

### 同级导包：
```bash
/test
  a.py
  b.py
```

```python
# a.py
import b
b.func()
```

```bash
# sys.path /test目录下
python a.py
```

---

### 嵌套导包：
```bash
test/
    step/
        c.py
        d.py
    a.py
    b.py
```

```python
# sys.path /test目录下
python a.py
```

#### 1.绝对导包
```python
#c.py
from . import d
# 这里要指定d.py 为相对路径
# 否则将会在sys.path（绝对路径）中寻找了
```

```python
from . import module_name
# 导入和自己同目录下的模块。
from .package_name import module_name
# 导入和自己同目录的包的模块。
from .. import module_name
# 导入上级目录的模块。
from ..package_name import module_name
# 导入位于上级目录下的包的模块。
```

#### 2.相对导包
```python
# c.py
import b
# 这里c.py 自动导入（相对路径）的 b.py
```

---



这里仅涉及简单的导包实践，更多参考

[10.1 构建一个模块的层级包 — python3-cookbook 3.0.0 文档](https://python3-cookbook.readthedocs.io/zh-cn/latest/c10/p01_make_hierarchical_package_of_modules.html)



### 构建层级包：
#### __init__.py
```python
graphics/
    __init__.py
    primitive/
        __init__.py
        line.py
        fill.py
        text.py
    formats/
        __init__.py
        png.py
        jpg.py
```

+ 确保每一个目录都定义了一个__init__.py
+ 一般来说，先空着，系统将会自动导入对应目录文件下的包。
+ 可以用来<font style="color:rgb(64, 64, 64);background-color:rgb(252, 252, 252);">自动加载子模块</font>

```python
# graphics/formats/__init__.py
from . import jpg
from . import png
```



---

## pytest测试
1. 一个简单的例子

```python
# content of test_sample.py
def inc(x):
    return x + 1


def test_answer():
    assert inc(3) == 5
```

---

2. 功能

> + 无需记住`self.assert*name`的名称，就可以显示assert语句的详细信息。
> + <font style="color:rgb(62, 67, 73);">自动发现测试模块和功能</font>
> + <font style="color:rgb(62, 67, 73);">用于管理小型或参数化长期测试资源的模块化夹具</font>
> + <font style="color:rgb(62, 67, 73);">可以开箱即用地运行unittest（包括trial）和nose测试套件</font>
>





---

### 1.开始使用
1. 安装

> + python 3.8+
> + `pip install -U pytest`
> + `$ pytest --version`
>

---

2. 创建你的第一个test

```python
def func(x) 
    '''被测函数'''
    return x + 1

def test_answer():
     '''测试用例'''
    assert func(3) ===5
```

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711522206196-535317f2-9cca-43ff-b525-6b01b25c4f62.png)

[100%]指的是总的进度

test_answer下将会显示错误的原因

> ‼️ pytest先进的断言自我检查将会智能的报告表达式中的值，因此你可以使用`assert`断言语句，兼容了Python的一些方法。
>

---

3. 一次运行多个测试

> 如: 使用`pytest`+`test_*.py`和`*_test.py`
>

---

4.**Assert引发某个异常**

```python
# content of test_sysexit.py
import pytest


def f():
    '''
    @description:该函数引发了一个退出代码为1的SystemExit异常用
    测试的目的是确保调f()时确实会引发SysteExit异常
    '''
    raise SystemExit(1)


def test_mytest():
    with pytest.raises(SystemExit):
        f()

```



#### 测试分组
+ <font style="color:rgb(51, 51, 51);">测试配置</font>
+ <font style="color:rgb(51, 51, 51);">仅在该特定类中共享用于测试的固定装置</font>
+ <font style="color:rgb(51, 51, 51);">在类级别应用标记，并将它们隐式应用于所有测试</font>



