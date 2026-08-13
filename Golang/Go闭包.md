# Go闭包

## 命名

英文：closure，中文“闭包”是从英文直译过来的，其实它实际的含义是

> a **closure** is a record storing **a function** together with **an environment**.
>
> **闭包**是由**函数**和与其相关的引用**环境**组合而成的实体 

----



## 闭包的产生

###  前言

C\C++是不支持闭包的，在一些回调场景下会存在不便，需要通过C\C++实现闭包的一些特性，所以我们通过C\C++的语言不支持闭包的写法VS支持闭包的Go语言的写法，从而分析闭包的来龙去脉，彻底搞懂！

### C回调函数

Callback是C语言中常用的一种编程手法，尤其在异步处理、设计库API时，必不可少。
现通过C语言假设实现了一个事件的异步处理功能：

```C
// 定义回调函数的类型callback_t(函数指针)
typedef void (*callback_t)(int event);
```

```C
// 定义事件注册接口 register_callback
void register_callback(int event,callback_t callback);
```

```C
// 然后使用这个接口注册事件EVENT——RECV（比如是TCP的数据接收事件），其处理函数为recv
#define EVENT_RECV 1
void recv(int evetn){
	pritnf("event: %d\n",event);
}
register_callback(EVENT_RECV,recv);
```

上面的实现有一个问题，在回调函数中无法访问调用者的数据（比如当前状态等），这样在实际使用中，显然是不可行的。

所以需要修改，首先修改回调函数的类型callback_t,增加一个参数user_data,类型为通用指针（可以传递任何数据）。

```c
typedef void(*callback_t)(int event,void *user_data);
```

事件注册接口register_callback,也同样增加一个参数user_data

```c
void register_callback(int event, callback_t callback, void *user_data);
```

然后注册事件回调时，传入user_data

```c
#define EVENT_RECV 1
user_t *user = create_user(...); // 此处表示创建一个用户，代码其他代码省略

void recv(int event, void *user_data){
	user_t *user = (user_t *)user_data; //把通用指针转化为user_t类型
    printf("event: %d,from user:%p\n",user);
}

register_callback(EVENT_RECV,recv,user)
```

以上就是c语言使用回调的正常做法，通过回调函数和注册回调接口都会增加一个通用指针类型参数，把外部数据传入回调，从而使得回调函数内部可以访问外部数据，这样做可以正常工作，但是仍然存在几个问题：

- 回调函数和注册回调函数的接口需要增加参数user_data，并且需要显示传递它
- 为了通用性，user_data只能使用通用指针void，使用不方便且编译器无法做类型检查

----



### C++函数对象

> 注意：此处的函数对象不是函数，因为C++与一切皆对象的语言不同，C++函数不是一等公民，也就是函数不是对象，不能有成员变量。

C++是兼容C的，所以以上C的做法在C++上也能实现。但C++增加了对面向对象的支持，因此可以有一些不一样的写法：

----



#### C+++面向对象常规写法

```C++
class A
{
	void handle(int event){
		printf("event: %d\n", event);
    }
}

A.a;
a.handle(event);
```

#### C++重载（）

```C++
class A
{
    void operator()(int event) //重载括号运算符
    {
        printf("event: %d\n", event);
	}
}

A.a;
a(event);// 让()变成像调用函数一样
```

通过重载（），从而让对新啊可以像函数一样直接调用，这样的对象就叫做函数对象(functor)。函数对象除了可以像函数一样直接调用，还有一个最大的好处，就是函数对象可以有成员变量，因此可以保存数据，如果用来替代C的回调将会非常方便。

比如：

```C++
class Functor
{
    user_t user_data; //成员变量，可以保存数据，比如状态
    
    Functor(data) //构造函数
    {
        user_data_data;
	}
    
    void operator()(int event) //重载括号运算符
    {
        printf("event: %d, from user: %\n", user_data);
        //此处可以直接访问user_data
    }
}
```

事件注册接口register_callback，回调callback类型变为函数对象，

```C
void register_callback(int event,Functor callback);
```

使用函数对象来重新实现：

```C++
#define EVENT_RECV 1

callback = new Functor(data); // 构造对象

register_callback(EVENT_RECV, callback);
```

可以看到，通过使用函数对象，可以避免C回调写法的问题，对于类型检查以及通用性有很大提升。但实际上函数对象在C++的标准库中被大量使用，但是C++的这种写法也不就是完美的。

- 首先需要定义函数对象
- 然后每次注册回调函数时，都需要生成函数对象

---



## Go中的闭包

闭包是由函数及其相关引用环境组合而成的实体(即：闭包=函数+引用环境)。

闭包是函数式语言中的概念，没有研究过函数式语言的用户可能很难理解闭包的强大，相关的概念超出了本书的范围。Go语言是支持闭包的，这里只是简单地讲一下在Go语言中闭包是如何实现的。

```go
func f(i int) func() int {
    return func() int {
        i++
        return i
    }
}
```

函数f返回了一个函数，返回的这个函数，返回的这个函数就是一个闭包。这个函数中本身是没有定义变量i的，而是引用了它所在的环境（函数f）中的变量i。

```go
c1 := f(0)
c2 := f(0)
c1()    // reference to i, i = 0, return 1
c2()    // reference to another i, i = 0, return 1
```

c1跟c2引用的是不同的环境，在调用i++时修改的不是同一个i，因此两次的输出都是1。函数f每进入一次，就形成了一个新的环境，对应的闭包中，函数都是同一个函数，环境却是引用不同的环境。

变量i是函数f中的局部变量，假设这个变量是在函数f的栈中分配的，是不可以的。因为函数f返回以后，对应的栈就失效了，f返回的那个函数中变量i就引用一个失效的位置了。所以闭包的环境中引用的变量不能够在栈上分配。

----



## 转义分析escape analyze

在继续研究闭包的实现之前，先看一看Go的一个语言特性：

```go
func f() *Cursor {
    var c Cursor
    c.X = 500
    noinline()
    return &c
}
```

Cursor是一个结构体，这种写法在C语言中是不允许的，因为变量c是在栈上分配的，当函数f返回后c的空间就失效了。但是，在Go语言规范中有说明，这种写法在Go语言中合法的。语言会自动地识别出这种情况并在堆上分配c的内存，而不是函数f的栈上。

为了验证这一点，可以观察函数f生成的汇编代码：

```assembly
MOVQ    $type."".Cursor+0(SB),(SP)    // 取变量c的类型，也就是Cursor
PCDATA    $0,$16
PCDATA    $1,$0
CALL    ,runtime.new(SB)    // 调用new函数，相当于new(Cursor)
PCDATA    $0,$-1
MOVQ    8(SP),AX    // 取c.X的地址放到AX寄存器
MOVQ    $500,(AX)    // 将AX存放的内存地址的值赋为500
MOVQ    AX,"".~r0+24(FP)
ADDQ    $16,SP
```

识别出变量需要在堆上分配，是由编译器的一种叫escape analyze的技术实现的。如果输入命令：

```bash
go build --gcflags=-m main.go
```

可以看到输出：

```bash
./main.go:20: moved to heap: c
./main.go:23: &c escapes to heap
```

表示c逃逸了，被移到堆中。escape analyze可以分析出变量的作用范围，这是对垃圾回收很重要的一项技术。

-----



## 闭包结构体

回到闭包的实现来，前面说过，闭包是函数和它所引用的环境。那么是不是可以表示为一个结构体呢：

```go
type Closure struct {
    F func()() 
    i *int
}
```

事实上，Go在底层确实就是这样表示一个闭包的。让我们看一下汇编代码：

```assembly
func f(i int) func() int {
    return func() int {
        i++
        return i
    }
}


MOVQ    $type.int+0(SB),(SP)
PCDATA    $0,$16
PCDATA    $1,$0
CALL    ,runtime.new(SB)    // 是不是很熟悉，这一段就是i = new(int)    
...    
MOVQ    $type.struct { F uintptr; A0 *int }+0(SB),(SP)    // 这个结构体就是闭包的类型
...
CALL    ,runtime.new(SB)    // 接下来相当于 new(Closure)
PCDATA    $0,$-1
MOVQ    8(SP),AX
NOP    ,
MOVQ    $"".func·001+0(SB),BP
MOVQ    BP,(AX)                // 函数地址赋值给Closure的F部分
NOP    ,
MOVQ    "".&i+16(SP),BP        // 将堆中new的变量i的地址赋值给Closure的值部分
MOVQ    BP,8(AX)
MOVQ    AX,"".~r1+40(FP)
ADDQ    $24,SP
RET    ,
```

其中func·001是另一个函数的函数地址，也就是f返回的那个函数。

-----



## 小结

1. Go语言支持闭包
2. Go语言能通过escape analyze识别出变量的作用域，自动将变量在堆上分配。将闭包环境变量在堆上分配是Go实现闭包的基础。
3. 返回闭包时并不是单纯返回一个函数，而是返回了一个结构体，记录下函数返回地址和引用的环境中的变量地址。

-----



## 闭包包误用导致 goroutine 读到相同值（经典陷阱）

#### 示例：

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	for i := 0; i < 3; i++ {
		go func() {
			fmt.Println("i:", i)
		}()
	}
	time.Sleep(time.Second)
}
```

你以为输出是：

```bash
i: 0
i: 1
i: 2
```

实际输出可能是：

```bash
i: 3
i: 3
i: 3
```

或者三个 `i: 2`，甚至随机顺序（取决于调度），**但基本不会是 0、1、2 各一次**。

------

### ❓ 为什么？

因为：

- 你写的是 `go func() { fmt.Println(i) }()`。
- 匿名函数**没有接收参数**，**使用了闭包引用外部变量 `i`**。
- 但是 `goroutine` 是异步的，等它执行时，`i` 已经变成 `3`。

------

####✅ 正确写法：**把 `i` 显式传进去**

```go
for i := 0; i < 3; i++ {
	go func(id int) {
		fmt.Println("i:", id)
	}(i)
}
```

输出更有可能是：

```
i: 0
i: 1
i: 2
```

（注意仍然是**无序的**，但每个值是准确的）

------

### ✅ 结论

| 写法                        | 是否安全 | 说明                 |
| --------------------------- | -------- | -------------------- |
| `go func() { use(i) }()`    | ❌        | 捕获循环变量，值会变 |
| `go func(i int) { ... }(i)` | ✅        | 显式传参，值固定     |
