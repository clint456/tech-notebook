# Go 语法完整手册

> 适用版本：Go 1.26。语言规范最近的语法级变化包括 Go 1.22 的整数 `range`、Go 1.23 的迭代器函数 `range`，以及 Go 1.24 的泛型类型别名。
>
> 本文聚焦 Go 的语言语法与核心语义。标准库 API、Web 框架、GC 和 GMP 等运行时实现不属于语法，不在本文展开。

## 目录

- [1. 程序基本结构](#1-程序基本结构)
- [2. 词法元素](#2-词法元素)
- [3. 标识符、关键字与可见性](#3-标识符关键字与可见性)
- [4. 声明、作用域与初始化](#4-声明作用域与初始化)
- [5. 常量](#5-常量)
- [6. 类型系统](#6-类型系统)
- [7. 复合类型](#7-复合类型)
- [8. 表达式](#8-表达式)
- [9. 运算符](#9-运算符)
- [10. 赋值](#10-赋值)
- [11. 控制流语句](#11-控制流语句)
- [12. 函数](#12-函数)
- [13. 方法](#13-方法)
- [14. 接口](#14-接口)
- [15. 泛型](#15-泛型)
- [16. 错误、panic 与 recover](#16-错误panic-与-recover)
- [17. 并发语法](#17-并发语法)
- [18. 内置函数](#18-内置函数)
- [19. 包、导入与初始化顺序](#19-包导入与初始化顺序)
- [20. 常见语法陷阱](#20-常见语法陷阱)
- [附录：速查表](#附录速查表)

---

## 1. 程序基本结构

一个 `.go` 源文件通常由包声明、导入声明和顶层声明组成：

```go
package main

import (
	"fmt"
	"math"
)

const appName = "demo"

type Point struct {
	X, Y float64
}

func distance(p Point) float64 {
	return math.Hypot(p.X, p.Y)
}

func main() {
	fmt.Println(appName, distance(Point{X: 3, Y: 4}))
}
```

基本规则：

- 每个源文件必须以 `package 包名` 开头。
- 同一目录中参与同一次构建的非测试 Go 文件通常必须属于同一个包。
- 可执行程序的入口是 `package main` 中无参数、无返回值的 `func main()`。
- 包可以有多个 `func init()`，但不能显式调用或引用 `init`。
- Go 不要求显式写分号，词法分析器会在特定 token 后自动插入分号。
- `gofmt` 是标准格式；缩进通常使用制表符。

---

## 2. 词法元素

### 2.1 源码与注释

Go 源码是 UTF-8 文本。注释有两种：

```go
// 单行注释

/*
多行注释
不能嵌套块注释
*/
```

注释不是语法 token。惯例上，导出声明的文档注释以声明名开头。

### 2.2 标识符

标识符由 Unicode 字母、数字和下划线组成，首字符不能是数字，区分大小写：

```go
userName := "Alice"
计数 := 1
_temp := true
```

单独的 `_` 是空白标识符，用来忽略值或占位，不会创建绑定：

```go
_, err := doWork()
for _, value := range values {
	_ = value
}
```

### 2.3 整数字面量

```go
decimal := 42
binary := 0b101010
octal := 0o52       // 也允许传统形式 052
hex := 0x2A
readable := 1_000_000
```

下划线只能出现在数字之间或进制前缀之后的合法位置，用于分组，不改变数值。

### 2.4 浮点数字面量

```go
a := 3.14
b := 1e6
c := .5
d := 0x1.8p+1 // 十六进制浮点数，等于 3.0；p 表示二进制指数
```

### 2.5 复数字面量

```go
z1 := 3 + 4i
z2 := 2.5i
```

### 2.6 rune 字面量

`rune` 字面量使用单引号，值是一个 Unicode 码点，类型通常为 `rune`（即 `int32`）：

```go
a := 'A'
zhong := '中'
newline := '\n'
unicode := '\u4E2D'
```

一个 rune 字面量只能表示一个码点或一个转义字符。

常见转义：`\a`、`\b`、`\f`、`\n`、`\r`、`\t`、`\v`、`\\`、`\'`、`\"`，以及八进制、十六进制和 Unicode 转义。

### 2.7 字符串字面量

解释型字符串使用双引号并处理转义：

```go
s := "hello\nworld"
```

原始字符串使用反引号，内容基本按原样保留，可以跨行；其中不能包含反引号，回车符会被丢弃：

```go
path := `C:\Users\clint`
text := `第一行
第二行`
```

字符串是只读字节序列，不保证内容一定是合法 UTF-8。

### 2.8 自动分号

Go 会在一行末尾的下列 token 后自动插入分号：

- 标识符；
- 整数、浮点数、虚数、rune 或字符串字面量；
- `break`、`continue`、`fallthrough`、`return`；
- `++`、`--`、`)`、`]`、`}`。

因此左花括号通常不能另起一行：

```go
// 正确
if ok {
}

// 错误：ok 后会自动插入分号
// if ok
// {
// }
```

---

## 3. 标识符、关键字与可见性

### 3.1 25 个关键字

```text
break       default     func        interface   select
case        defer       go          map         struct
chan        else        goto        package     switch
const       fallthrough if          range       type
continue    for         import      return      var
```

`true`、`false`、`iota`、`nil`、`int`、`string`、`any`、`comparable` 等是预声明标识符，不是关键字；可以被遮蔽，但不建议这样做。

### 3.2 导出规则

包级标识符以 Unicode 大写字母开头时可被其他包访问：

```go
type User struct {
	Name string // 导出字段
	age  int    // 仅当前包可见
}

func NewUser() User { return User{} } // 导出函数
```

可见性由首字母决定，Go 没有 `public`、`private`、`protected`。

---

## 4. 声明、作用域与初始化

### 4.1 变量声明

```go
var age int             // 零值 0
var name string = "Go"
var enabled = true      // 推断为 bool
var x, y int = 1, 2

var (
	count int
	label = "ready"
)
```

短变量声明只能用在函数体内：

```go
n := 10
a, b := 1, "two"
```

同一词法块中，`:=` 左侧至少有一个非空白的新变量；已有变量会被赋值：

```go
x := 1
x, err := parse() // err 是新变量，因此合法
```

### 4.2 零值

未显式初始化的变量会被递归初始化为零值：

| 类型 | 零值 |
| --- | --- |
| 布尔 | `false` |
| 数值 | `0` |
| 字符串 | `""` |
| 指针、切片、map、函数、channel、接口 | `nil` |
| 数组、结构体 | 所有元素或字段各自的零值 |

零值应尽量可用，例如 `sync.Mutex` 的零值就是未加锁状态。

### 4.3 类型声明与类型别名

定义类型会创建一个新的、不同的类型：

```go
type UserID int64

var id UserID = 1
// var n int64 = id // 不可直接赋值，需要转换
var n int64 = int64(id)
```

类型别名不会创建新类型：

```go
type Byte = uint8
type IDs = []int64
```

Go 1.24 起，别名可以有类型参数：

```go
type Set[K comparable] = map[K]bool
```

### 4.4 作用域

常见作用域：

- 预声明标识符属于 universe block；
- 包级声明在整个包块内可见；
- 导入的包名只在当前源文件可见；
- 函数参数、返回参数和局部变量在相应函数或词法块内可见；
- `if`、`for`、`switch` 的初始化语句变量在该语句范围内可见；
- 内层声明可以遮蔽外层同名标识符。

```go
x := 1
if x := 2; x > 0 {
	fmt.Println(x) // 2
}
fmt.Println(x) // 1
```

### 4.5 声明分组

`const`、`var`、`type` 和 `import` 可以分组：

```go
type (
	ID   int64
	Name string
)
```

---

## 5. 常量

### 5.1 常量声明

常量只能是布尔、数字、rune 或字符串值，必须在编译期可确定：

```go
const Pi = 3.1415926
const Max int64 = 100
const Message = "hello" + " world"
```

常量不能由函数调用、切片、map 或结构体值初始化。

### 5.2 无类型常量

未显式指定类型的常量通常是无类型常量，具有较高精度，并在使用上下文中取得默认类型：

```go
const N = 1 << 100
const Ratio = 1.0 / 3.0

var f float64 = Ratio
// var i int64 = N // 超出 int64，编译错误
```

默认类型通常为 `bool`、`rune`、`int`、`float64`、`complex128` 或 `string`。

### 5.3 iota

`iota` 是当前 `const` 声明组内从 0 开始的常量索引，每个 `ConstSpec` 增加 1。省略表达式会复用前一个非空表达式及其类型：

```go
type Status uint8

const (
	StatusUnknown Status = iota // 0
	StatusReady                 // 1
	StatusRunning               // 2
)

const (
	_  = iota
	KB = 1 << (10 * iota)
	MB
	GB
)
```

---

## 6. 类型系统

### 6.1 基本类型

布尔类型：

```text
bool
```

字符串类型：

```text
string
```

整数类型：

```text
int8  int16  int32  int64
uint8 uint16 uint32 uint64
int   uint   uintptr
```

浮点和复数类型：

```text
float32 float64
complex64 complex128
```

别名：

```go
type byte = uint8
type rune = int32
```

`int`、`uint` 和 `uintptr` 的宽度与实现有关，在 32 位或 64 位平台上通常分别为 32 或 64 位。`uintptr` 是能容纳指针位模式的整数，不是可安全长期持有对象的指针。

### 6.2 命名类型、定义类型与底层类型

每个定义类型都有底层类型：

```go
type Celsius float64 // 定义类型；底层类型是 float64
```

定义类型之间即使底层类型相同，通常也不是同一类型。底层类型影响转换、赋值和泛型类型集合等规则。

### 6.3 类型相同与可赋值

“类型相同”“值可赋值”和“值可转换”是不同概念。常见可赋值情形包括：

- 两边类型相同；
- 两边底层类型相同且至少一边不是命名类型；
- 目标是接口且源值实现该接口；
- `nil` 可赋给指针、函数、切片、map、channel 或接口；
- 可表示的无类型常量可赋给对应类型。

不确定时显式转换能清楚表达意图：

```go
type Meter int
type Count int

var m Meter = 3
var c Count = Count(m)
```

### 6.4 类型转换

转换语法是 `T(x)`：

```go
i := int64(42)
f := float64(i)
s := string([]byte{'G', 'o'})
b := []byte("Go")
r := []rune("中文")
```

数值转换可能截断或溢出，不会自动检查业务范围。整数转字符串产生对应 Unicode 码点，而不是十进制文本：

```go
s := string(65) // "A"，不是 "65"
```

### 6.5 类型推断

变量初始化、短声明、泛型调用等上下文可以推断类型：

```go
x := 1             // int
y := 1.0           // float64
z := complex(1, 2) // complex128
```

Go 是静态类型语言，推断之后变量类型不会改变。

---

## 7. 复合类型

### 7.1 数组

数组长度是类型的一部分：

```go
var a [3]int
b := [3]int{1, 2, 3}
c := [...]int{1, 2, 3}       // 编译器推断长度
d := [...]string{2: "third"} // 索引 2 初始化，其余为零值
```

数组是值类型。赋值和传参会复制整个数组。若元素类型可比较，则数组也可使用 `==`、`!=`。

```go
b[0] = 9
fmt.Println(len(b))
```

### 7.2 切片

切片类型写作 `[]T`，描述一段底层数组：

```go
var nilSlice []int
s1 := []int{1, 2, 3}
s2 := make([]int, 3)     // len=3, cap=3
s3 := make([]int, 0, 10) // len=0, cap=10
```

切片表达式：

```go
a := [5]int{0, 1, 2, 3, 4}
s := a[1:4]   // [1 2 3]，下界包含，上界不包含
s = a[:3]
s = a[2:]
s = a[:]
t := a[1:3:4] // 完整切片表达式，len=2，cap=3
```

规则：

- `len(s)` 是长度，`cap(s)` 是从起点到底层数组末端的容量。
- 索引范围是 `0 <= i < len(s)`。
- `append` 可能复用原底层数组，也可能分配新数组，必须接收返回值。
- 多个切片可能共享底层数组，修改元素会互相可见。
- `nil` 切片的长度和容量都是 0，可直接 `append`。
- 切片只能与 `nil` 比较，不能彼此使用 `==`。

```go
s = append(s, 4, 5)
s = append(s, another...)

dst := make([]int, len(s))
n := copy(dst, s)
_ = n

clear(s) // 将所有元素置为零值
```

### 7.3 字符串

字符串是不可变字节序列：

```go
s := "Go语言"
fmt.Println(len(s)) // 字节数，不是 rune 数
fmt.Println(s[0])   // byte
```

对字符串使用 `range` 时，索引是 rune 起始字节位置，值是解码后的 rune；非法 UTF-8 字节会产生 `utf8.RuneError`：

```go
for index, r := range s {
	fmt.Printf("%d: %c\n", index, r)
}
```

字符串支持 `==`、`!=`、`<`、`<=`、`>`、`>=`，按字节字典序比较。

### 7.4 map

map 类型写作 `map[K]V`。键类型必须可比较：

```go
var nilMap map[string]int
m := make(map[string]int)
m2 := map[string]int{"a": 1, "b": 2}
```

读写与删除：

```go
m["a"] = 10
value := m["missing"]          // 不存在时得到 V 的零值
value, ok := m["missing"]      // ok 区分“不存在”和“值恰好为零值”
delete(m, "a")                 // 删除不存在的键也安全
clear(m)                       // 删除所有条目
```

规则：

- `nil` map 可读取、查询、删除和遍历，但写入会 panic。
- map 的迭代顺序未指定，每次遍历都不应依赖顺序。
- map 只能与 `nil` 比较。
- map 元素不可取址，因为扩容等操作可能移动元素。
- 普通 map 不保证并发读写安全。

### 7.5 结构体

```go
type User struct {
	ID      int64  `json:"id"`
	Name    string `json:"name"`
	Address        // 嵌入字段
}

type Address struct {
	City string
}
```

结构体字面量：

```go
u1 := User{ID: 1, Name: "Alice"} // 推荐：按字段名
u2 := User{1, "Bob", Address{}}  // 按顺序，必须列出全部字段
u3 := &User{Name: "Carol"}       // 得到 *User
```

字段访问和提升：

```go
u1.Address.City = "Shanghai"
fmt.Println(u1.City) // 嵌入字段的字段可被提升
```

结构体可比较的前提是所有字段均可比较。字段标签是类型身份的一部分，并可通过反射读取。

### 7.6 指针

```go
x := 10
p := &x
fmt.Println(*p)
*p = 20

var q *int // nil
```

Go 支持取址 `&x` 和解引用 `*p`，不支持指针算术。选择器会在常见情况下自动解引用：

```go
type Point struct{ X int }
p := &Point{X: 1}
p.X = 2 // 等价于 (*p).X = 2
```

### 7.7 函数类型

函数是一等值：

```go
type Operation func(int, int) int

var op Operation = func(a, b int) int { return a + b }
```

函数值只能与 `nil` 比较，不能彼此比较。

### 7.8 channel 类型

```go
chan T   // 双向 channel
chan<- T // 只发送
<-chan T // 只接收
```

创建 channel：

```go
unbuffered := make(chan int)
buffered := make(chan int, 10)
```

方向通常用于函数参数约束；双向 channel 可赋给对应单向 channel，反向不行。

---

## 8. 表达式

### 8.1 操作数

表达式可以由字面量、变量、常量、函数、类型、括号表达式等组成：

```go
x
42
(a + b)
f(1)
T(v)
```

类型名通常不是值，但会出现在转换和复合字面量等表达式中。

### 8.2 选择器

```go
x.Field
x.Method
pkg.ExportedName
```

选择器用于访问字段、方法或导入包的导出标识符。嵌入字段和方法可以被提升，但名称冲突时必须显式写完整路径。

### 8.3 索引

```go
a[i] // 数组、数组指针、切片、字符串或 map
```

- 数组、切片和字符串索引必须是整数；越界会 panic。
- 字符串索引结果是字节且不可赋值。
- map 索引可以出现在单值或双值上下文中。

### 8.4 切片表达式

简单形式：

```go
a[low:high]
```

完整形式：

```go
a[low:high:max]
```

完整形式会限制新切片容量为 `max-low`，三个索引中只有 `low` 可以省略。

数组切片要求数组可寻址；字符串只支持简单切片，结果仍为字符串。

### 8.5 函数调用

```go
result := f(a, b)
```

多返回值函数可以直接作为另一个调用的整组实参，但不能与其他实参混用：

```go
func pair() (int, int) { return 1, 2 }
func sum(a, b int) int { return a + b }

n := sum(pair())
```

### 8.6 可变参数展开

```go
func sum(nums ...int) int { return 0 }

sum(1, 2, 3)
values := []int{1, 2, 3}
sum(values...)
```

`...` 展开要求切片元素类型与可变参数元素类型匹配。

### 8.7 复合字面量

```go
[3]int{1, 2, 3}
[]int{1, 2, 3}
map[string]int{"a": 1}
Point{X: 1, Y: 2}
&Point{X: 1}
```

嵌套复合字面量中，元素类型明显时可省略：

```go
points := []Point{
	{X: 1, Y: 2},
	{X: 3, Y: 4},
}
```

多行字面量的最后一个元素后必须有逗号。

### 8.8 函数字面量与闭包

```go
factor := 2
multiply := func(x int) int {
	return x * factor
}
```

闭包捕获的是外层变量本身，不只是声明时的值；只要闭包仍可达，被捕获变量就继续存活。

### 8.9 类型断言

仅用于接口值：

```go
s := value.(string)       // 失败时 panic
s, ok := value.(string)   // 失败时 s 为零值，ok 为 false
```

`x.(T)` 判断接口值 `x` 的动态类型是否为具体类型 `T`，或是否实现接口 `T`。

### 8.10 接收表达式

```go
v := <-ch
v, ok := <-ch
```

从已关闭且已排空的 channel 接收会立即得到元素零值，`ok` 为 `false`。

---

## 9. 运算符

### 9.1 算术与位运算

```text
+    -    *    /    %
&    |    ^    &^   <<   >>
```

- 整数除法向零截断；运行时整数除数为零会 panic。浮点运行时值除以零遵循 IEEE 754，可能得到无穷或 NaN；常量除以零是编译错误。
- `%` 仅用于整数。
- `^x` 是按位取反。
- `&^` 是位清除：`x &^ y` 清除 `x` 中 `y` 为 1 的位。
- 移位次数必须是整数或可表示为无符号整数；运行时移位次数没有固定上限。

### 9.2 比较运算

```text
==   !=   <   <=   >   >=
```

可排序类型包括整数、浮点数和字符串。布尔、复数等可比较但不可排序。切片、map、函数只能与 `nil` 比较。

接口值在动态类型相同且动态值相等时相等；若比较时动态类型不可比较，会 panic。

### 9.3 逻辑运算

```text
&&   ||   !
```

`&&` 和 `||` 从左到右短路求值。

### 9.4 地址与 channel 运算

```text
&x    // 取址
*p    // 解引用
ch <- value
<-ch
```

### 9.5 字符串拼接

```go
full := "Go" + "lang"
```

### 9.6 运算符优先级

从高到低：

| 优先级 | 运算符 |
| --- | --- |
| 5 | `* / % << >> & &^` |
| 4 | `+ - \| ^` |
| 3 | `== != < <= > >=` |
| 2 | `&&` |
| 1 | `\|\|` |

一元运算符优先级最高。同级二元运算符从左向右结合。拿不准时使用括号。

### 9.7 自增与自减

```go
i++
i--
```

它们是语句，不是表达式，所以不能写 `x = i++`，也没有前置 `++i`。

---

## 10. 赋值

### 10.1 普通赋值

```go
x = 1
a, b = b, a // 右侧先求值，可直接交换
```

多重赋值分两阶段进行：先对左侧索引/间接引用和右侧表达式求值，再从左到右完成赋值。

### 10.2 复合赋值

```go
x += 2
x -= 2
x *= 2
x /= 2
x %= 2
x <<= 1
x >>= 1
x &= mask
x |= mask
x ^= mask
x &^= mask
```

复合赋值的左侧只求值一次。

### 10.3 特殊双值赋值

```go
v, ok := m[key]       // map 查询
v, ok := x.(T)        // 类型断言
v, ok := <-ch         // channel 接收
```

### 10.4 空白标识符赋值

```go
_ = value
result, _ := strconv.Atoi("42")
```

空白标识符接收的值会被丢弃，但右侧表达式仍会求值。

---

## 11. 控制流语句

### 11.1 块与空语句

块由花括号组成，并形成词法作用域：

```go
{
	x := 1
	_ = x
}
```

连续分号之间隐含空语句。日常代码通常不显式书写。

### 11.2 if

条件不需要括号，但必须是布尔表达式：

```go
if x > 0 {
	fmt.Println("positive")
} else if x < 0 {
	fmt.Println("negative")
} else {
	fmt.Println("zero")
}
```

可以带初始化语句：

```go
if value, ok := m[key]; ok {
	fmt.Println(value)
}
```

初始化变量的作用域覆盖条件、所有分支以及相应的 `else`。

### 11.3 表达式 switch

```go
switch day {
case "Sat", "Sun":
	fmt.Println("weekend")
case "Mon":
	fmt.Println("monday")
default:
	fmt.Println("weekday")
}
```

省略表达式等价于 `switch true`：

```go
switch {
case score >= 90:
	grade = "A"
case score >= 60:
	grade = "Pass"
default:
	grade = "Fail"
}
```

规则：

- 默认不会贯穿到下一个 case；匹配分支结束后自动退出。
- `fallthrough` 只能作为非最后一个表达式 case 的最后一条非空语句，无条件进入下一个 case，且不会重新检查条件。
- `switch init; expression` 可以带初始化语句。
- `default` 最多一个，位置不限。

### 11.4 类型 switch

类型 switch 只用于接口值：

```go
switch v := x.(type) {
case nil:
	fmt.Println("nil")
case int:
	fmt.Println("int", v)
case string, []byte:
	fmt.Println("text-like", v)
default:
	fmt.Printf("%T\n", v)
}
```

在只有一个具体类型的 case 中，`v` 是该具体类型；多类型 case 和 `default` 中，`v` 保持原接口类型。类型 switch 不能使用 `fallthrough`。

### 11.5 基本 for

Go 只有 `for` 一种循环关键字：

```go
for i := 0; i < 10; i++ {
}

for condition {
}

for {
	break
}
```

初始化和后置语句可以省略。后置语句不能是短变量声明。

Go 1.22 起，由 `for` 子句声明的循环变量每次迭代都有新的实例：

```go
for i := 0; i < 3; i++ {
	go func() { fmt.Println(i) }() // 分别捕获每轮的 i
}
```

如果循环变量是在循环外声明并在 `for` 中用 `=` 赋值，则仍复用同一个变量。

### 11.6 range

通用形式：

```go
for index, value := range expression {
}
```

可按需要省略变量：

```go
for index := range values {}
for _, value := range values {}
for range values {}
```

不同 range 对象产生的值：

| 对象 | 第一个值 | 第二个值 |
| --- | --- | --- |
| 数组、数组指针、切片 | 索引 `int` | 元素副本 |
| 字符串 | rune 起始字节索引 | rune |
| map | 键 | 值副本 |
| channel | 接收到的元素 | 无 |
| 整数 `n`（Go 1.22+） | `0` 到 `n-1` | 无 |
| 迭代器函数（Go 1.23+） | yield 参数 | 取决于函数签名 |

注意：

- 数组被 `range` 时通常会复制整个数组；使用 `&array` 或切片可避免该复制。
- map 顺序未指定，遍历中增删条目的可见性也不应被依赖。
- 对 `nil` 切片或 map 遍历 0 次；对 `nil` channel 遍历会永久阻塞。
- channel 的 range 一直接收，直到 channel 被关闭并排空。
- `range n` 在 `n <= 0` 时迭代 0 次。
- Go 1.22 起，用 `:=` 声明的 range 变量每轮都是新变量。

整数 range：

```go
for i := range 5 {
	fmt.Println(i) // 0, 1, 2, 3, 4
}
```

迭代器函数 range 支持以下三种签名：

```go
func(func() bool)
func(func(V) bool)
func(func(K, V) bool)
```

示例：

```go
func Backward(n int) func(func(int) bool) {
	return func(yield func(int) bool) {
		for i := n - 1; i >= 0; i-- {
			if !yield(i) {
				return
			}
		}
	}
}

for v := range Backward(3) {
	fmt.Println(v) // 2, 1, 0
}
```

循环提前退出时，语言会让 `yield` 返回 `false`，迭代器函数必须停止调用它。

### 11.7 break 与 continue

```go
for i := 0; i < 10; i++ {
	if i == 2 {
		continue
	}
	if i == 8 {
		break
	}
}
```

- 无标签 `break` 终止最内层 `for`、`switch` 或 `select`。
- 无标签 `continue` 开始最内层 `for` 的下一轮。
- 带标签形式可作用于外层语句。

```go
Outer:
for i := 0; i < 3; i++ {
	for j := 0; j < 3; j++ {
		if i+j > 2 {
			break Outer
		}
	}
}
```

### 11.8 goto 与标签

```go
if err != nil {
	goto Cleanup
}

Cleanup:
closeResources()
```

`goto` 目标必须在同一函数内，不能跳过会使变量进入作用域的声明，也不能跳入另一个词法块。标签在函数体内有独立作用域。

### 11.9 return

```go
func add(a, b int) int {
	return a + b
}

func split() (int, string) {
	return 1, "one"
}
```

命名返回值可以裸返回，但长函数中不推荐：

```go
func next(n int) (result int) {
	result = n + 1
	return
}
```

### 11.10 defer

`defer` 延迟执行函数调用，常用于资源释放：

```go
file, err := os.Open(name)
if err != nil {
	return err
}
defer file.Close()
```

规则：

- 被延迟调用的函数值和实参在执行到 `defer` 时立即求值。
- 延迟调用在外围函数返回前执行，顺序为后进先出。
- 即使函数因 panic 退出，已注册的 defer 仍会执行。
- defer 可以读取或修改命名返回值。

```go
func f() (n int) {
	defer func() { n++ }()
	return 1 // 最终返回 2
}
```

### 11.11 go

`go f(args...)` 在新的 goroutine 中调用函数。函数值和实参在当前 goroutine 执行到 `go` 语句时求值；返回值会被丢弃：

```go
go worker(id)
go func() {
	fmt.Println("async")
}()
```

### 11.12 select

`select` 在一组 channel 通信中选择可进行的分支：

```go
select {
case v := <-in:
	fmt.Println(v)
case out <- value:
	fmt.Println("sent")
case <-done:
	return
default:
	fmt.Println("no communication ready")
}
```

规则：

- 进入 `select` 时，所有 case 的 channel 操作数和发送值表达式按源码顺序求值一次。
- 若多个通信同时可进行，会伪随机选择一个。
- 无 case 可进行且有 `default` 时执行 `default`。
- 无 case 可进行且无 `default` 时阻塞。
- `select {}` 永久阻塞。
- 从关闭的 channel 接收总是可进行；向关闭的 channel 发送会 panic。

---

## 12. 函数

### 12.1 声明语法

```go
func name(parameterList) resultList {
	// body
}
```

参数类型相同时可合并：

```go
func add(a, b int) int {
	return a + b
}
```

多个返回值：

```go
func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errors.New("division by zero")
	}
	return a / b, nil
}
```

### 12.2 参数传递

Go 的所有参数都按值传递。传递数组会复制数组；传递指针会复制指针；传递切片、map、channel、接口或函数时，复制的是这些值自身，其内部可能仍引用共享数据。

```go
func resetSlice(s []int) {
	s[0] = 0           // 调用方通常可见：修改共享底层数组
	s = append(s, 1)   // 新的切片头只赋给局部变量
}
```

### 12.3 可变参数

```go
func join(separator string, parts ...string) string {
	return strings.Join(parts, separator)
}
```

函数体内 `parts` 的类型是 `[]string`。可变参数必须是最后一个参数。

### 12.4 匿名函数和立即调用

```go
result := func(x int) int {
	return x * x
}(5)
```

### 12.5 递归

```go
func factorial(n uint) uint {
	if n < 2 {
		return 1
	}
	return n * factorial(n-1)
}
```

匿名函数递归时需先声明变量：

```go
var walk func(int)
walk = func(n int) {
	if n > 0 {
		walk(n - 1)
	}
}
```

### 12.6 init 与 main

```go
func init() {
	// 包初始化阶段自动执行
}

func main() {
	// 可执行程序入口
}
```

`init` 和 `main` 都不能有参数和返回值。一个源文件可声明多个 `init`，一个包也可跨文件拥有多个 `init`。

---

## 13. 方法

### 13.1 方法声明

方法是在函数名前增加接收者参数的函数：

```go
type Counter int

func (c Counter) Value() int {
	return int(c)
}

func (c *Counter) Inc() {
	*c++ // 解析为 (*c)++
}
```

接收者的基本类型必须定义在当前包中，并且不能是指针或接口类型；接收者参数本身可以写成 `T` 或 `*T`。

### 13.2 值接收者与指针接收者

- 值接收者得到值的副本，适合小型、不可变语义的类型。
- 指针接收者可修改原值，避免复制大对象，也常用于保持方法集一致。
- 对可寻址的 `T` 值调用 `(*T)` 方法时，编译器可自动取址。

```go
var c Counter
c.Inc() // 自动转成 (&c).Inc()
```

但 map 元素等不可寻址值不能依赖这种自动取址。

### 13.3 方法集

核心规则：

- 定义类型 `T` 的方法集包含接收者为 `T` 的方法。
- `*T` 的方法集包含接收者为 `T` 和 `*T` 的方法。
- 因此只有指针接收者实现接口时，通常只有 `*T` 实现该接口，`T` 不实现。

```go
type Writer interface {
	Write([]byte) (int, error)
}

type Buffer struct{}
func (*Buffer) Write(p []byte) (int, error) { return len(p), nil }

var _ Writer = (*Buffer)(nil)
// var _ Writer = Buffer{} // 编译错误
```

### 13.4 方法值与方法表达式

方法值绑定接收者：

```go
c := Counter(1)
f := c.Value
fmt.Println(f())
```

方法表达式把接收者变成第一个显式参数：

```go
f := Counter.Value
fmt.Println(f(c))
```

### 13.5 嵌入与方法提升

```go
type Logger struct{}
func (Logger) Log(string) {}

type Service struct {
	Logger
}

var s Service
s.Log("started")
```

嵌入是组合，不是继承。方法是否进入外层类型的方法集，还取决于嵌入的是 `T` 还是 `*T` 以及接收者类型。

---

## 14. 接口

### 14.1 基本接口

接口描述方法集合，类型通过实现全部方法隐式满足接口：

```go
type Reader interface {
	Read([]byte) (int, error)
}
```

不需要也不存在 `implements` 关键字。

### 14.2 接口嵌入

```go
type ReadWriter interface {
	Reader
	Writer
}
```

嵌入接口得到方法集合的交集语义：实现者必须满足组合后的所有方法要求。重复嵌入同签名方法是允许的，冲突签名不允许。

### 14.3 空接口与 any

```go
interface{}
any // 预声明别名：type any = interface{}
```

它们可保存任意非接口或接口类型的值。优先使用 `any` 表达通用值。

### 14.4 接口值

接口值可理解为动态类型和动态值二元组：

```go
var x any          // 动态类型和动态值都为空，x == nil
var p *int = nil
x = p              // 动态类型是 *int，动态值是 nil，x != nil
```

这就是“带类型的 nil”陷阱。返回接口时应直接返回 `nil`，而不是装入接口的 nil 指针。

### 14.5 类型断言与类型 switch

```go
s, ok := x.(string)

switch v := x.(type) {
case string:
	fmt.Println(v)
case fmt.Stringer:
	fmt.Println(v.String())
}
```

### 14.6 约束接口

接口还可以包含类型项、底层类型项和联合项，用于描述类型集合：

```go
type Integer interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64 |
		~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64 | ~uintptr
}
```

- `~T` 表示底层类型为 `T` 的所有类型。
- `A | B` 表示类型集合的并集。
- 多行接口元素之间表示类型集合的交集。
- `comparable` 表示支持 `==` 和 `!=` 的类型约束。

包含类型项的非基本接口只能用作约束，不能作为普通变量类型：

```go
// var x interface{ ~int | ~string } // 非法：不能作为普通值类型
```

---

## 15. 泛型

### 15.1 泛型函数

```go
func Max[T ~int | ~float64](a, b T) T {
	if a > b {
		return a
	}
	return b
}

n := Max(1, 2)          // 推断 T 为 int
f := Max[float64](1, 2) // 显式实例化
```

类型参数列表紧跟函数名，每个类型参数由名称和约束组成。

### 15.2 泛型类型

```go
type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(v T) {
	s.items = append(s.items, v)
}

func (s *Stack[T]) Pop() (zero T, ok bool) {
	if len(s.items) == 0 {
		return zero, false
	}
	i := len(s.items) - 1
	v := s.items[i]
	s.items = s.items[:i]
	return v, true
}
```

使用泛型类型时必须实例化：

```go
var stack Stack[string]
```

方法可以使用接收者类型已经声明的类型参数，但方法不能额外声明自己的类型参数。

### 15.3 约束

```go
type Number interface {
	~int | ~int64 | ~float32 | ~float64
}

func Sum[T Number](values []T) T {
	var total T
	for _, value := range values {
		total += value
	}
	return total
}
```

约束决定对类型参数值可执行哪些操作。只有约束类型集合中的每个类型都支持某操作时，泛型代码中才能使用该操作。

### 15.4 comparable

```go
func HasKey[K comparable, V any](m map[K]V, key K) bool {
	_, ok := m[key]
	return ok
}
```

map 键类型必须满足 `comparable`。注意某些接口类型虽满足 `comparable` 约束，但其中装入不可比较的动态值后，运行时比较仍可能 panic。

### 15.5 类型推断

编译器通常可从实参推断函数类型参数：

```go
func First[T any](values []T) T { return values[0] }

s := First([]string{"a", "b"})
```

无法推断或需要指定不同类型时显式提供全部或前缀类型实参。泛型类型的类型实参不能靠变量声明右侧之外的上下文任意省略。

### 15.6 泛型类型别名

Go 1.24 起可声明泛型别名：

```go
type Vector[T any] = []T
type Lookup[K comparable, V any] = map[K]V
```

别名不会创建新类型，使用时必须实例化，例如 `Vector[int]`。

### 15.7 当前语法限制

- 方法不能声明接收者之外的新类型参数。
- 类型参数不能用在类型 switch 或类型断言的 `. (type)` 位置；可以先转换为 `any` 再检查动态类型，但这通常意味着设计需要重新评估。
- 不能直接访问类型参数值的字段，即使类型集合中所有类型看起来具有同名字段；通常用方法约束表达行为。

---

## 16. 错误、panic 与 recover

### 16.1 error 惯用法

`error` 是预声明接口：

```go
type error interface {
	Error() string
}
```

Go 用普通返回值传递可预期错误：

```go
value, err := parse(input)
if err != nil {
	return fmt.Errorf("parse input: %w", err)
}
```

这属于惯用法，不是特殊异常语法。

### 16.2 panic

`panic(v)` 停止当前函数的正常执行，依次执行当前 goroutine 调用栈中已注册的 defer，然后终止该 goroutine；若未被恢复，程序崩溃。

```go
if impossible {
	panic("unreachable state")
}
```

panic 通常用于不可恢复的程序不变量破坏，不应用于普通业务错误。

### 16.3 recover

`recover()` 只有在 panic 展开期间、被延迟函数直接调用时才能停止该 panic：

```go
func guarded() (err error) {
	defer func() {
		if v := recover(); v != nil {
			err = fmt.Errorf("panic: %v", v)
		}
	}()

	dangerous()
	return nil
}
```

在正常执行路径或非直接 defer 调用中，`recover()` 返回 `nil`。一个 goroutine 不能恢复另一个 goroutine 的 panic。

---

## 17. 并发语法

### 17.1 goroutine

```go
go function(args...)
```

`go` 后必须是函数或方法调用，不能把调用结果用于赋值。

### 17.2 发送与接收

```go
ch <- value // 发送
value := <-ch
value, ok := <-ch
```

无缓冲 channel 需要发送方和接收方会合；有缓冲 channel 在缓冲区满时阻塞发送，在空时阻塞接收。

### 17.3 关闭 channel

```go
close(ch)
```

规则：

- 通常由发送方关闭，用于表示不会再发送值。
- 只有双向或只发送 channel 可以传给 `close`，只接收 channel 不能关闭。
- 关闭 nil channel 或已关闭 channel 会 panic。
- 向已关闭 channel 发送会 panic。
- 接收方不需要、通常也不应该关闭 channel。
- channel 不像文件一样要求总是关闭；只有需要通知接收方“数据结束”时才关闭。

### 17.4 nil channel

对 nil channel 的发送和接收会永久阻塞。在 `select` 中，可将 channel 设为 nil 来动态禁用相应 case：

```go
var out chan<- int
if ready {
	out = ch
}

select {
case out <- value:
default:
}
```

### 17.5 同步不是自动产生的

启动 goroutine 不会自动等待它完成；应使用 channel、`sync.WaitGroup` 或其他同步机制建立生命周期和 happens-before 关系。仅仅 `time.Sleep` 不是可靠同步。

---

## 18. 内置函数

### 18.1 分配与容器

#### new

`new(T)` 分配一个零值 `T` 并返回 `*T`：

```go
p := new(int)
```

#### make

`make` 只用于切片、map 和 channel，返回初始化后的 `T`，不是 `*T`：

```go
s := make([]int, 3, 10)
m := make(map[string]int, 100)
ch := make(chan int, 10)
```

#### append

```go
s = append(s, value)
s = append(s, values...)
```

追加字符串到 `[]byte` 有特殊形式：

```go
b = append(b, "text"...)
```

#### copy

```go
n := copy(dst, src)
```

复制数量是两者长度的较小值，允许源和目标重叠。还可从字符串复制到 `[]byte`。

#### clear

```go
clear(slice) // 元素置零，长度不变
clear(m)     // 删除所有条目
```

### 18.2 长度与容量

```go
len(x)
cap(x)
```

- `len` 可用于字符串、数组、数组指针、切片、map 和 channel。
- `cap` 可用于数组、数组指针、切片和 channel。
- 某些数组或数组指针的 `len`、`cap` 表达式是常量，且在不含函数调用或 channel 接收时可能不求值操作数。

### 18.3 map 与 channel

```go
delete(m, key)
close(ch)
```

### 18.4 复数

```go
z := complex(realPart, imagPart)
r := real(z)
i := imag(z)
```

### 18.5 数值边界辅助

```go
smallest := min(a, b, c)
largest := max(a, b, c)
```

参数必须是有序类型，所有实参需满足类型统一规则。若全是常量，结果也是常量。

### 18.6 panic 与恢复

```go
panic(value)
value := recover()
```

### 18.7 输出调试

```go
print(values...)
println(values...)
```

`print` 和 `println` 主要用于引导和底层调试，输出格式由实现决定；正式程序应使用 `fmt` 或日志包。

---

## 19. 包、导入与初始化顺序

### 19.1 导入形式

普通导入：

```go
import "fmt"
```

分组导入：

```go
import (
	"fmt"
	"net/http"
)
```

别名导入：

```go
import jsoniter "github.com/json-iterator/go"
```

空白导入只执行包初始化，不能引用其标识符：

```go
import _ "database/sql/driver"
```

点导入会把目标包的导出标识符直接引入当前文件，易冲突，除少数测试场景外不推荐：

```go
import . "math"
```

导入是文件级声明；导入后未使用会编译失败。

### 19.2 包初始化依赖

包级变量按依赖关系初始化：

```go
var a = b + 1
var b = 2
```

`b` 会先于 `a` 初始化，即使文本顺序在后。无依赖变量按编译器确定的文件顺序和源码声明顺序初始化，不应依赖未规定的跨文件文件名顺序。

### 19.3 完整初始化顺序

对一个可执行程序，概念顺序是：

1. 递归初始化导入包；每个包只初始化一次。
2. 初始化当前包的包级变量。
3. 按编译器给定的文件顺序和源码顺序调用当前包的所有 `init()`。
4. 所有依赖包完成后，调用 `main.main()`。

初始化在单个 goroutine 中顺序进行；`init` 可以启动其他 goroutine，但初始化过程不会自动等待它们完成。

### 19.4 internal 包

路径中含 `internal` 的包只能被其父目录树内的代码导入。这是 Go 工具链的导入规则，不是新的可见性关键字。

---

## 20. 常见语法陷阱

### 20.1 := 造成变量遮蔽

```go
var err error
if ready {
	value, err := load() // 若 value 也是新变量，这里的 err 可能是内层新变量
	_ = value
	_ = err
}
```

需要修改外层变量时先声明其他变量，再使用 `=`。

### 20.2 nil 接口不等于装有 nil 指针的接口

```go
var p *MyError
var err error = p
fmt.Println(err == nil) // false
```

### 20.3 append 后必须接收结果

```go
s = append(s, value)
```

扩容后底层数组可能变化，忽略结果既不能更新长度，也可能丢失新数组。

### 20.4 range 的 value 是副本

```go
for i := range users {
	users[i].Active = true
}
```

直接修改 `for _, user := range users` 中的 `user` 通常只修改副本。

### 20.5 map 元素不可取址

```go
// &m[key]                 // 非法
// m[key].Field = value    // 若值是结构体，非法

v := m[key]
v.Field = value
m[key] = v
```

也可把 map 值设计为指针。

### 20.6 defer 实参立即求值

```go
x := 1
defer fmt.Println(x) // 保存 1
x = 2
```

闭包则读取执行时的变量值：

```go
x := 1
defer func() { fmt.Println(x) }() // 输出 2
x = 2
```

### 20.7 nil 切片与空切片

```go
var a []int        // nil，len=0
b := []int{}       // 非 nil，len=0
c := make([]int, 0) // 非 nil，len=0
```

多数操作中行为相同，但与 `nil` 比较、JSON 编码或反射结果可能不同。

### 20.8 数组长度属于类型

```go
var a [2]int
var b [3]int
// a = b // 类型不同
```

### 20.9 字符串索引是 byte

```go
s := "中"
fmt.Println(len(s)) // UTF-8 下为 3
fmt.Println(s[0])   // 第一个字节，不是 rune '中'
```

按字符处理时使用 `range` 或转换为 `[]rune`。

### 20.10 map 遍历无序

若需要稳定顺序，应先收集键、排序，再按键访问。

### 20.11 channel 关闭不是广播值

关闭表示“不会再有值”。接收者应使用 `v, ok := <-ch` 或 `for v := range ch` 判断结束，不应把零值误当作业务数据。

### 20.12 copy、赋值与深拷贝不同

- 数组或结构体赋值复制值，但其中的切片、map、指针字段仍可能共享数据。
- 切片赋值只复制切片描述值，不复制元素。
- `copy` 只复制一层切片元素。
- 真正的深拷贝需要按数据结构语义递归实现。

### 20.13 浮点数不能直接表达所有小数

语法允许比较浮点数，但业务上不应假设计算结果可精确等于十进制期望值。金额通常使用整数最小单位或十进制定点实现。

### 20.14 并发访问共享变量会产生数据竞争

语法正确不代表并发正确。通过 channel 传递所有权，或使用互斥锁、原子操作等同步共享状态，并用 `go test -race` 检查。

---

## 附录：速查表

### A. 声明模板

```go
package pkg

import "path"

const Name = "value"
var Count int

type ID int64
type Alias = ID

type T struct{}
type I interface{}

func F[T any](v T) T { return v }
func (t *T) M()      {}
```

### B. 控制流模板

```go
if init; condition {
} else {
}

switch init; expression {
case value1, value2:
default:
}

switch v := x.(type) {
case T:
	_ = v
}

for init; condition; post {
}

for key, value := range collection {
	_, _ = key, value
}

select {
case v := <-in:
	_ = v
case out <- value:
default:
}
```

### C. 常用类型模板

```go
[N]T          // 数组
[]T           // 切片
map[K]V       // map
struct{ F T } // 结构体
*T            // 指针
func(P) R     // 函数
interface{ M() } // 接口
chan T        // 双向 channel
chan<- T      // 只发送 channel
<-chan T      // 只接收 channel
```

### D. 可比较性速查

| 类型 | 可用 `==` / `!=` | 可与 `nil` 比较 |
| --- | --- | --- |
| 布尔、数值、字符串、指针、channel | 是 | 指针和 channel 可以 |
| 数组 | 元素可比较时可以 | 否 |
| 结构体 | 全部字段可比较时可以 | 否 |
| 接口 | 可以；动态值不可比较时可能 panic | 是 |
| 切片、map、函数 | 仅能与 `nil` 比较 | 是 |

### E. channel 状态速查

| 操作 | nil channel | 打开且可用 | 已关闭 |
| --- | --- | --- | --- |
| 发送 | 永久阻塞 | 发送或阻塞 | panic |
| 接收 | 永久阻塞 | 接收或阻塞 | 缓冲排空后立即返回零值，`ok=false` |
| 关闭 | panic | 成功 | panic |

### F. 官方依据

- [The Go Programming Language Specification](https://go.dev/ref/spec)
- [Effective Go](https://go.dev/doc/effective_go)
- [Go 1.22 Release Notes](https://go.dev/doc/go1.22)
- [Go 1.23 Release Notes](https://go.dev/doc/go1.23)
- [Go 1.24 Release Notes](https://go.dev/doc/go1.24)
