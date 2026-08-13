# Go语言 context 包

## 1. 概述

[`context`](https://pkg.go.dev/context) 包定义了 Context 类型，用于在 API 边界和不同 goroutine 之间传递截止时间（deadline）、取消信号（cancellation signals）以及其他请求范围内的数据（request-scoped values）。

- 典型用法：服务器收到请求时创建 Context，所有处理链路都应传递 Context，并可通过 `WithCancel`、`WithDeadline`、`WithTimeout`、`WithValue` 派生新的 Context。
- Context 可被取消，表示相关工作应当停止。带有截止时间的 Context 会在超时后自动取消。
- Context 取消会级联，所有派生的子 Context 也会被取消。

---

## 2. Context 接口定义

```go
// Context 是一个接口，定义如下：
type Context interface {
    Deadline() (deadline time.Time, ok bool)
    Done() <-chan struct{}
    Err() error
    Value(key any) any
}
```

- `Deadline()`：返回 context 被取消的时间点（如有）。
- `Done()`：返回一个 channel，在 context 被取消或超时时关闭。
- `Err()`：context 正常时返回 nil，被取消或超时时返回错误。
- `Value(key)`：获取 context 关联的值，仅用于请求范围内的数据。

---

## 3. Context 的创建与派生

- `context.Background()`：返回一个空的、永不取消的根 Context，常用于主函数、初始化、测试等。
- `context.TODO()`：当不确定用哪个 Context 时使用。
- 派生 Context：
  - `WithCancel(parent)`：返回可手动取消的子 Context。
  - `WithDeadline(parent, deadline)`：返回带截止时间的子 Context。
  - `WithTimeout(parent, timeout)`：返回带超时时间的子 Context。
  - `WithValue(parent, key, val)`：返回携带特定值的子 Context。

> **注意**：每次派生都会返回新对象，Context 是不可变的。

---

## 4. 取消信号与超时控制

- `Done()` channel 用于通知 goroutine 取消信号。
- 通过 `select` 监听 `ctx.Done()`，可及时响应取消或超时。
- `WithTimeout` 和 `WithDeadline` 自动取消，`WithCancel` 需手动调用返回的 `cancelFunc`。
- **最佳实践**：务必在所有控制流路径下调用 `cancelFunc`，否则会导致资源泄漏。

---

## 5. WithValue 用法与风险

- 仅用于传递"跨 API 边界且与请求范围相关的元数据"，如 trace_id、认证信息等。
- **不要**用 context 传递业务参数或可选参数。
- 建议用自定义类型作为 key，避免不同包间 key 冲突。
- 存储的数据类型为 `interface{}`，类型断言时需注意健壮性。

---

## 6. 典型应用场景与最佳实践

- **不要**把 Context 保存到结构体中，应通过参数传递。
- **不要**在多个 goroutine 之间传递可变 Context。
- **不要**用 Context 传递除元数据外的业务数据。
- **不要**传递 nil Context，若不确定用哪个 Context，使用 `context.TODO()`。
- 典型应用场景：HTTP 请求超时控制、数据库操作超时与取消、微服务链路追踪等。
- Context 可安全地被多个 goroutine 同时使用。

---

## 7. 代码示例

### 超时控制示例

```go
package main
import (
    "context"
    "fmt"
    "time"
)
func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
    defer cancel()
    select {
    case <-ctx.Done():
        fmt.Println("超时或被取消：", ctx.Err())
    case <-time.After(2 * time.Second):
        fmt.Println("正常完成")
    }
}
```

### WithValue 用法示例

```go
package main
import (
    "context"
    "fmt"
)
type traceIDKey struct{}
func main() {
    ctx := context.WithValue(context.Background(), traceIDKey{}, "123456")
    logWithTrace(ctx)
}
func logWithTrace(ctx context.Context) {
    if v, ok := ctx.Value(traceIDKey{}).(string); ok {
        fmt.Println("trace_id:", v)
    }
}
```

### 取消信号的级联示例

```go
package main
import (
    "context"
    "fmt"
    "time"
)
func main() {
    ctx, cancel := context.WithCancel(context.Background())
    go func() {
        <-time.After(1 * time.Second)
        cancel()
    }()
    select {
    case <-ctx.Done():
        fmt.Println("收到取消信号：", ctx.Err())
    }
}
```

---

## 8. 常见误区与易错点

- 不要将 Context 作为结构体字段。
- 不要用 Context 传递除元数据外的业务数据。
- 不要传递 nil Context。
- 派生的 Context 必须在不再使用时调用 cancelFunc，避免资源泄漏。
- WithValue 的 key 应为自定义类型，避免冲突。

---

## 9. 参考资料

- [Go 官方 context 文档](https://pkg.go.dev/context)
- [Go 官方博客：Go Concurrency Patterns: Context](https://go.dev/blog/context)
- [Go 官方博客：Pipelines](https://go.dev/blog/pipelines)
- [小白也能看懂的context包](https://cloud.tencent.com/developer/article/1900658)

---

## 10. 总结

context 是 Go 并发编程中不可或缺的工具。合理设计 context 的传递链路，遵循最佳实践，能有效提升代码的健壮性和可维护性。建议多参考官方文档和社区最佳实践，避免常见误区。 