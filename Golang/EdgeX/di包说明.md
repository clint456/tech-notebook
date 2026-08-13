# EdgeX `go-mod-bootstrap/v4/di` 包说明

> 包路径：`github.com/edgexfoundry/go-mod-bootstrap/v4/di`
>
> 本文依据本机模块缓存中的 `go-mod-bootstrap/v4 v4.0.3` 源码整理。不同 EdgeX 版本的 API 可能有变化，使用时应以项目 `go.mod` 锁定的版本为准。

## 1. 这个包解决什么问题

`di` 是 EdgeX Bootstrap 提供的一个轻量级依赖注入容器，DI 是 Dependency Injection 的缩写。

它主要负责三件事：

1. 使用字符串名称注册服务构造函数。
2. 第一次请求服务时才执行构造函数，即惰性创建。
3. 缓存构造结果，后续返回同一个实例，即容器级单例。

它不是类似 Java Spring 的自动扫描框架，也不会根据结构体字段或函数参数自动装配依赖。注册、查找和类型断言都由代码显式完成。

可以把它理解为下面这套机制：

```text
服务名称 -> 构造函数 -> 第一次 Get 时创建实例 -> 缓存实例 -> 后续重复使用
```

EdgeX 用它把日志客户端、配置、消息总线客户端、注册中心客户端、密钥提供者以及各类业务组件放进同一个容器，再传给不同的 BootstrapHandler 使用。

---

## 2. 导入与版本

```go
import "github.com/edgexfoundry/go-mod-bootstrap/v4/di"
```

模块依赖示例：

```go
require github.com/edgexfoundry/go-mod-bootstrap/v4 v4.0.3
```

路径中的 `/v4` 是 Go Module 的主版本后缀，不能省略。

---

## 3. 核心 API 一览

`di` 包公开的内容很少：

```go
type Get func(serviceName string) interface{}

type ServiceConstructor func(get Get) interface{}

type ServiceConstructorMap map[string]ServiceConstructor

type Container struct {
	// 字段未导出
}

func NewContainer(serviceConstructors ServiceConstructorMap) *Container
func (c *Container) Update(serviceConstructors ServiceConstructorMap)
func (c *Container) Get(serviceName string) interface{}

func TypeInstanceToName(v interface{}) string
```

在当前 Go 版本中，`interface{}` 可以理解为 `any`。该包保留 `interface{}` 写法是其 API 源码风格。

---

## 4. 最小可运行示例

```go
package main

import (
	"fmt"

	"github.com/edgexfoundry/go-mod-bootstrap/v4/di"
)

const (
	configName = "config"
	serviceName = "service"
)

type Config struct {
	Prefix string
}

type Service struct {
	config *Config
}

func (s *Service) Message(name string) string {
	return s.config.Prefix + ", " + name
}

func main() {
	dic := di.NewContainer(di.ServiceConstructorMap{
		configName: func(get di.Get) interface{} {
			return &Config{Prefix: "hello"}
		},
		serviceName: func(get di.Get) interface{} {
			config := get(configName).(*Config)
			return &Service{config: config}
		},
	})

	service := dic.Get(serviceName).(*Service)
	fmt.Println(service.Message("EdgeX"))
}
```

执行过程：

1. `NewContainer` 只保存两个构造函数，此时没有创建 `Config` 或 `Service`。
2. `dic.Get(serviceName)` 发现 `Service` 尚未创建，于是执行其构造函数。
3. `Service` 构造函数调用 `get(configName)`，容器创建并缓存 `Config`。
4. 容器创建并缓存 `Service`。
5. 再次调用 `dic.Get(serviceName)` 时，直接返回缓存的 `Service`。

---

## 5. `Get` 类型

定义：

```go
type Get func(serviceName string) interface{}
```

`Get` 是一个函数类型。它接收服务名并返回容器中的服务值。

容器公开方法 `dic.Get` 的方法值可以直接作为 `di.Get` 使用：

```go
var get di.Get = dic.Get
service := get(serviceName)
```

构造函数拿到的 `get` 用于解析其他依赖：

```go
func(get di.Get) interface{} {
	logger := get(loggerName).(Logger)
	return NewService(logger)
}
```

这样构造函数只依赖一个查找函数，不需要依赖整个 `*di.Container`。

### 未注册服务

查找不存在的服务会返回 `nil`，不会由容器主动 panic：

```go
value := dic.Get("missing")
fmt.Println(value == nil) // true
```

但紧接着做强制类型断言仍会 panic：

```go
service := dic.Get("missing").(*Service) // panic
```

可选依赖应使用带 `ok` 的类型断言：

```go
service, ok := dic.Get(serviceName).(*Service)
if !ok {
	// 依赖不存在，或注册值类型不正确
}
```

---

## 6. `ServiceConstructor`

定义：

```go
type ServiceConstructor func(get Get) interface{}
```

它是服务工厂函数。容器在服务第一次被请求时调用它，并把容器自身的内部查找函数作为 `get` 参数传入。

构造函数可以：

- 直接返回已有实例；
- 创建新实例；
- 通过 `get` 获取其他服务后组装实例；
- 返回具体类型或接口实现。

直接保存已有实例：

```go
config := &Config{Prefix: "hello"}

constructors := di.ServiceConstructorMap{
	configName: func(get di.Get) interface{} {
		return config
	},
}
```

创建依赖其他服务的实例：

```go
constructors := di.ServiceConstructorMap{
	serviceName: func(get di.Get) interface{} {
		config := get(configName).(*Config)
		return NewService(config)
	},
}
```

虽然参数名通常写成 `get`，它只是一个普通函数参数，可以改名。

---

## 7. `ServiceConstructorMap`

定义：

```go
type ServiceConstructorMap map[string]ServiceConstructor
```

键是服务名称，值是构造函数：

```go
constructors := di.ServiceConstructorMap{
	"logger": func(get di.Get) interface{} {
		return NewLogger()
	},
	"service": func(get di.Get) interface{} {
		return NewService(get("logger").(Logger))
	},
}
```

技术上可以手写任意字符串作为名称，但 EdgeX 通常使用 `TypeInstanceToName` 生成名称，防止不同包中同名类型冲突。

---

## 8. `NewContainer`

定义：

```go
func NewContainer(serviceConstructors ServiceConstructorMap) *Container
```

创建并初始化一个容器：

```go
dic := di.NewContainer(constructors)
```

也可以创建空容器：

```go
dic1 := di.NewContainer(nil)
dic2 := di.NewContainer(di.ServiceConstructorMap{})
```

两者都可以继续调用 `Update` 注册服务。

`NewContainer` 不会立即执行构造函数。实际实例在第一次 `Get` 时创建。

EdgeX 源码中常把容器变量命名为 `dic`，意思是 Dependency Injection Container。

---

## 9. `Container.Get`

定义：

```go
func (c *Container) Get(serviceName string) interface{}
```

基本用法：

```go
value := dic.Get(serviceName)
service := value.(*Service)
```

它具有以下行为：

| 场景 | 结果 |
| --- | --- |
| 名称未注册 | 返回 `nil` |
| 已注册但未构造 | 调用构造函数，缓存并返回结果 |
| 已构造 | 返回缓存实例 |
| 构造函数返回 `nil` | 本次返回 `nil`，下次 `Get` 会再次执行构造函数 |

最后一条来自实现方式：容器使用 `instance == nil` 判断是否已经构造。因此，不要把无类型 `nil` 当作需要缓存的有效服务值。

### 单例范围

这里的“单例”只表示同一个 `Container`、同一个服务名在没有被 `Update` 替换时共享实例：

```go
first := dic.Get(serviceName)
second := dic.Get(serviceName)
fmt.Println(first == second)
```

不同容器会有各自的实例缓存，它不是进程级全局单例。

---

## 10. `Container.Update`

定义：

```go
func (c *Container) Update(serviceConstructors ServiceConstructorMap)
```

`Update` 用于新增或替换构造函数：

```go
dic.Update(di.ServiceConstructorMap{
	serviceName: func(get di.Get) interface{} {
		return NewService()
	},
})
```

如果名称不存在，就新增服务；如果名称已存在，就替换它。

### 替换会清空该名称的实例缓存

当前实现会把服务条目重写为：

```go
service{
	constructor: newConstructor,
	instance:    nil,
}
```

因此下一次 `Get` 会执行新构造函数：

```go
oldValue := dic.Get(serviceName)

dic.Update(di.ServiceConstructorMap{
	serviceName: func(get di.Get) interface{} {
		return replacement
	},
})

newValue := dic.Get(serviceName)
```

需要注意：

- 容器不会自动关闭、停止或释放旧实例。
- 其他对象如果已经持有旧实例，不会自动更新引用。
- 依赖该服务的其他已缓存服务也不会自动重建。

例如 `Service` 构造时保存了旧 `Config`，之后只更新 `Config` 并不会改变已构造的 `Service`：

```text
更新 Config 构造函数
       |
       +-- 下一次 Get(Config) 得到新 Config
       |
       +-- 已缓存的 Service 仍持有旧 Config
```

若需要完整刷新依赖图，必须按依赖关系更新相关服务，或创建新容器。

---

## 11. `TypeInstanceToName`

定义：

```go
func TypeInstanceToName(v interface{}) string
```

该函数通过反射返回类型的完整名称：

```text
包导入路径.类型名
```

具体类型示例：

```go
type Config struct{}

var ConfigName = di.TypeInstanceToName(Config{})
```

如果 `Config` 位于 `example.com/demo/config` 包，结果类似：

```text
example.com/demo/config.Config
```

### 接口名称的标准写法

接口不能直接构造值，EdgeX 使用“指向接口的 nil 指针”表达接口类型：

```go
type Logger interface {
	Info(message string)
}

var LoggerName = di.TypeInstanceToName((*Logger)(nil))
```

这里必须注意：

- `(*Logger)(nil)` 的类型是 `*Logger`；
- 传入接口后，反射能看到这个指针类型；
- `TypeInstanceToName` 对指针形式取 `Elem()`，得到接口的包路径和名称；
- 不要写 `var logger Logger; TypeInstanceToName(logger)`，因为此时传入的是 nil 接口，`reflect.TypeOf` 返回 nil，函数会 panic。

### 适用范围和限制

该函数适合命名的具体类型，以及 `(*SomeInterface)(nil)` 这种接口标记。

命名具体类型的指针也可以工作，例如 `new(Config)` 会通过 `Elem()` 得到 `Config` 的名称。不过，为了与 EdgeX 代码保持一致，具体类型通常直接传零值，接口才使用 nil 指针标记。

不要传入：

- 无类型 nil 或动态类型为空的 nil 接口；
- 切片、map、匿名结构体、匿名接口等无命名类型。

当前实现只区分“自身有名称的类型”和“对无名称类型取一次 `Elem()`”两种情况，并不是通用的类型名称序列化工具。对无命名类型可能生成空名称、意外名称或直接 panic，应遵循 EdgeX 源码中的标准模式。

---

## 12. EdgeX 推荐的容器封装模式

EdgeX 业务代码通常不会到处写：

```go
dic.Get("logger").(Logger)
```

而是在专门的 `container` 包中同时定义服务名和类型安全的读取函数。

### 12.1 定义接口

```go
package logging

type Logger interface {
	Info(message string)
}
```

### 12.2 定义名称和 From 函数

```go
package container

import (
	"example.com/service/logging"
	"github.com/edgexfoundry/go-mod-bootstrap/v4/di"
)

var LoggerName = di.TypeInstanceToName((*logging.Logger)(nil))

func LoggerFrom(get di.Get) logging.Logger {
	logger, ok := get(LoggerName).(logging.Logger)
	if !ok {
		return nil
	}
	return logger
}
```

### 12.3 注册实现

```go
dic := di.NewContainer(di.ServiceConstructorMap{
	container.LoggerName: func(get di.Get) interface{} {
		return logging.NewLogger()
	},
})
```

### 12.4 获取依赖

```go
logger := container.LoggerFrom(dic.Get)
if logger == nil {
	return errors.New("logger is not available")
}
```

这种封装有几个好处：

- 服务名只定义一次；
- 类型断言集中在一处；
- 调用方得到明确的静态类型；
- 可选依赖可以统一返回 nil；
- 重构包路径或接口名时修改范围更小。

`go-mod-bootstrap/v4/bootstrap/container` 中的 `LoggingClientFrom`、`ConfigurationFrom`、`MessagingClientFrom` 等函数就是这种模式。

---

## 13. 在 BootstrapHandler 中使用

EdgeX 的 BootstrapHandler 签名包含容器：

```go
type BootstrapHandler func(
	ctx context.Context,
	wg *sync.WaitGroup,
	startupTimer startup.Timer,
	dic *di.Container,
) bool
```

自定义处理器可以在启动阶段读取依赖：

```go
func BootstrapHandler(
	ctx context.Context,
	wg *sync.WaitGroup,
	startupTimer startup.Timer,
	dic *di.Container,
) bool {
	logger := container.LoggerFrom(dic.Get)
	if logger == nil {
		return false
	}

	logger.Info("custom bootstrap handler started")
	return true
}
```

也可以在处理器完成初始化后向容器追加服务：

```go
client, err := NewClient()
if err != nil {
	return false
}

dic.Update(di.ServiceConstructorMap{
	container.ClientName: func(get di.Get) interface{} {
		return client
	},
})
```

Bootstrap handlers 按传入切片的顺序执行。因此，如果后一个 handler 需要前一个 handler 注册的服务，必须保持正确顺序。

---

## 14. 线程安全与锁行为

`Container` 内部使用 `sync.RWMutex`，但当前 v4.0.3 实现中 `Get` 和 `Update` 实际都获取写锁：

```go
func (c *Container) Get(serviceName string) interface{} {
	c.mutex.Lock()
	defer c.mutex.Unlock()
	return c.get(serviceName)
}
```

这意味着：

- 多个 goroutine 可以安全调用 `Get` 和 `Update`，容器内部 map 不会并发读写；
- 同一时间只有一个 `Get` 或 `Update` 在容器内部执行；
- 构造函数执行期间锁不会释放；
- 构造函数可通过传入的内部 `get` 解析其他依赖，因为内部 `get` 不会再次加锁；
- 不应在构造函数中捕获外部 `dic` 并调用 `dic.Get`，否则会尝试重复获取同一把非可重入锁并死锁。

正确：

```go
serviceName: func(get di.Get) interface{} {
	return NewService(get(configName).(*Config))
},
```

错误：

```go
serviceName: func(get di.Get) interface{} {
	// 不要这样写：外层 Get 已持有锁
	return NewService(dic.Get(configName).(*Config))
},
```

容器线程安全只保护注册表和实例缓存，不会自动让容器中保存的服务实例变成线程安全。

---

## 15. 循环依赖

这个容器没有循环依赖检测。

```go
dic := di.NewContainer(di.ServiceConstructorMap{
	"a": func(get di.Get) interface{} {
		return get("b")
	},
	"b": func(get di.Get) interface{} {
		return get("a")
	},
})

dic.Get("a")
```

`a -> b -> a -> ...` 会不断递归，最终导致栈溢出。

解决方式通常是：

- 重新划分职责，消除双向依赖；
- 抽出两者共同依赖的第三个接口；
- 让一个方向通过回调、事件或消息通信；
- 在组合根中先构造对象，再显式完成必要连接，而不是互相从容器解析。

---

## 16. 测试中的依赖替换

`Update` 很适合给测试注入 stub 或 mock：

```go
type FakeLogger struct {
	messages []string
}

func (f *FakeLogger) Info(message string) {
	f.messages = append(f.messages, message)
}

func newTestContainer() (*di.Container, *FakeLogger) {
	logger := &FakeLogger{}

	dic := di.NewContainer(di.ServiceConstructorMap{
		container.LoggerName: func(get di.Get) interface{} {
			return logger
		},
	})

	return dic, logger
}
```

替换已有服务：

```go
fake := &FakeClient{}

dic.Update(di.ServiceConstructorMap{
	container.ClientName: func(get di.Get) interface{} {
		return fake
	},
})
```

测试时最好为每个测试用例创建独立容器，避免实例缓存和更新操作在测试之间互相影响。

---

## 17. 常见问题和陷阱

### 17.1 名称和返回类型不匹配

容器只按字符串查找，不检查构造函数返回类型：

```go
dic.Update(di.ServiceConstructorMap{
	container.LoggerName: func(get di.Get) interface{} {
		return &Config{} // 编译能通过，但运行时类型断言失败
	},
})
```

应把名称、构造函数和 `XxxFrom` 放在容易统一维护的位置，并增加测试。

### 17.2 直接强制断言可选依赖

```go
client := dic.Get(clientName).(Client)
```

依赖未注册或类型不对时会 panic。对于可选服务，使用 `XxxFrom` 和带 `ok` 的类型断言。

### 17.3 误以为 Update 会更新整个依赖图

`Update` 只重置对应名称的构造函数和实例，不会追踪哪些已构造对象依赖它。

### 17.4 构造函数返回 nil

无类型 nil 不会被视为已缓存实例，每次 `Get` 都会再次调用构造函数。对于可选依赖，通常干脆不注册，读取端处理 nil。

### 17.5 在构造函数中调用公开的 `dic.Get`

公开 `Get` 会重新获取容器锁，造成死锁。构造函数必须使用参数 `get`。

### 17.6 循环依赖

容器不检测环，会无限递归。应从设计上消除。

### 17.7 长耗时构造函数阻塞所有容器操作

构造函数在容器写锁内运行。网络重试、长时间等待等操作会阻塞其他 `Get` 和 `Update`。EdgeX 启动组件通常在 BootstrapHandler 中完成有生命周期的初始化，再把结果放入容器。

### 17.8 复制 Container

`Container` 内含互斥锁，不应按值复制。始终传递 `*di.Container`。

### 17.9 容器不管理资源销毁

它没有 `Close`、作用域或析构回调。数据库连接、消息客户端和 goroutine 等资源仍需由 Bootstrap 生命周期、context、WaitGroup 或显式清理函数负责关闭。

---

## 18. 推荐实践

1. 使用 `TypeInstanceToName` 或集中定义的常量作为服务名，不散落魔法字符串。
2. 为每个常用依赖提供 `XxxFrom(get di.Get) T` 函数。
3. 构造函数内部只使用参数 `get`，不要调用捕获的 `dic.Get`。
4. 避免循环依赖，让依赖关系保持单向。
5. 构造函数保持快速，不在容器锁内执行长时间阻塞操作。
6. 在启动完成前注册好必需依赖，不要把缺失的必需依赖拖到业务请求阶段才暴露。
7. 对可选依赖使用安全类型断言，对必需依赖给出清晰错误。
8. `Update` 前明确旧实例如何关闭，以及依赖它的已缓存对象是否需要同步替换。
9. 每个测试创建独立容器，用 mock 构造函数替换外部依赖。
10. 容器只负责组装，不要把它当成任意全局数据存储。

---

## 19. 一份完整的推荐写法

```go
package main

import (
	"errors"
	"fmt"

	"github.com/edgexfoundry/go-mod-bootstrap/v4/di"
)

type Logger interface {
	Info(message string)
}

type consoleLogger struct{}

func (consoleLogger) Info(message string) {
	fmt.Println(message)
}

type Greeter struct {
	logger Logger
}

func (g *Greeter) Greet(name string) {
	g.logger.Info("hello, " + name)
}

var (
	LoggerName  = di.TypeInstanceToName((*Logger)(nil))
	GreeterName = di.TypeInstanceToName(Greeter{})
)

func LoggerFrom(get di.Get) Logger {
	logger, ok := get(LoggerName).(Logger)
	if !ok {
		return nil
	}
	return logger
}

func GreeterFrom(get di.Get) *Greeter {
	greeter, ok := get(GreeterName).(*Greeter)
	if !ok {
		return nil
	}
	return greeter
}

func buildContainer() *di.Container {
	return di.NewContainer(di.ServiceConstructorMap{
		LoggerName: func(get di.Get) interface{} {
			return consoleLogger{}
		},
		GreeterName: func(get di.Get) interface{} {
			return &Greeter{
				logger: LoggerFrom(get),
			}
		},
	})
}

func run(dic *di.Container) error {
	greeter := GreeterFrom(dic.Get)
	if greeter == nil || greeter.logger == nil {
		return errors.New("greeter dependencies are not available")
	}

	greeter.Greet("EdgeX")
	return nil
}

func main() {
	if err := run(buildContainer()); err != nil {
		panic(err)
	}
}
```

这个示例体现了 EdgeX 中最常见的四层结构：

```text
接口或具体类型
    -> TypeInstanceToName 生成服务名
    -> ServiceConstructorMap 注册构造函数
    -> XxxFrom 封装查找和类型断言
```

---

## 20. API 速查

| API | 用途 | 关键行为 |
| --- | --- | --- |
| `di.NewContainer(map)` | 创建容器 | 只注册构造函数，不立即构造实例 |
| `dic.Get(name)` | 获取服务 | 首次惰性构造，之后返回缓存实例；未知名称返回 nil |
| `dic.Update(map)` | 新增或替换服务 | 重置对应名称的实例缓存；不处理旧实例销毁 |
| `di.TypeInstanceToName(v)` | 生成类型服务名 | 具体类型传值，接口使用 `(*Interface)(nil)` |
| `di.Get` | 查找函数类型 | 传给构造函数或 `XxxFrom` 辅助函数 |
| `di.ServiceConstructor` | 服务构造函数类型 | 可以通过 `get` 解析其他依赖 |
| `di.ServiceConstructorMap` | 批量注册表 | `map[string]ServiceConstructor` |

---

## 21. 一句话总结

`go-mod-bootstrap/v4/di` 是一个线程安全的、按名称注册构造函数、首次访问时创建并缓存实例的轻量容器；在 EdgeX 中，最规范的用法是通过 `TypeInstanceToName` 定义名称，通过 `XxxFrom(di.Get)` 封装类型断言，再由 BootstrapHandler 按启动顺序读取或追加依赖。

## 参考

- [go-mod-bootstrap v4 di package](https://pkg.go.dev/github.com/edgexfoundry/go-mod-bootstrap/v4/di)
- [EdgeX Foundry go-mod-bootstrap](https://github.com/edgexfoundry/go-mod-bootstrap)
