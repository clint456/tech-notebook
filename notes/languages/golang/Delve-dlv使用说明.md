# Delve（dlv）使用说明

> Delve 是 Go 官方生态中最常用的源码级调试器，命令名为 `dlv`。它可以启动程序、调试测试、附加进程、分析 core dump，并通过 DAP 协议供 VS Code、GoLand 等 IDE 使用。
>
> 本机当前未检测到 `dlv` 命令，使用前需先安装。

## 1. 安装与检查

### 1.1 安装最新版

```powershell
go install github.com/go-delve/delve/cmd/dlv@latest
```

`go install` 会把可执行文件安装到：

1. `GOBIN` 指定的目录；或
2. `GOBIN` 为空时的 `GOPATH/bin`。

检查目录：

```powershell
go env GOBIN
go env GOPATH
```

Windows 默认通常是：

```text
C:\Users\用户名\go\bin\dlv.exe
```

安装后验证：

```powershell
dlv version
dlv help
```

### 1.2 提示“找不到 dlv”

先直接检查文件：

```powershell
$goPath = go env GOPATH
Test-Path "$goPath\bin\dlv.exe"
```

如果文件存在，将 `$goPath\bin` 加入用户 `PATH`，然后重新打开终端。

当前 PowerShell 会话可临时添加：

```powershell
$env:Path += ";$(go env GOPATH)\bin"
```

也可以直接使用完整路径：

```powershell
& "$(go env GOPATH)\bin\dlv.exe" version
```

### 1.3 固定版本

团队项目最好固定已验证的 Delve 版本：

```powershell
go install github.com/go-delve/delve/cmd/dlv@vX.Y.Z
```

把 `vX.Y.Z` 替换为团队选定的真实版本号。具体版本应根据项目 Go 版本和团队工具链确定。Go 版本较新而 Delve 太旧时，可能出现“不支持当前 Go 版本”的提示。

---

## 2. 核心命令概览

| 命令 | 使用场景 |
| --- | --- |
| `dlv debug` | 从源码编译并调试当前 main 包，最常用 |
| `dlv test` | 编译并调试测试 |
| `dlv exec` | 调试已经编译好的 Go 可执行文件 |
| `dlv attach` | 附加到正在运行的 Go 进程 |
| `dlv core` | 调试 core dump 或 Windows minidump |
| `dlv dap` | 启动 DAP 服务，供 IDE 连接 |
| `dlv connect` | 连接到 headless Delve 服务 |
| `dlv trace` | 非交互地跟踪函数调用 |
| `dlv version` | 查看版本 |

查看某个命令的帮助：

```powershell
dlv help debug
dlv help test
dlv help exec
```

进入交互调试器后查看命令：

```text
(dlv) help
(dlv) help break
```

---

## 3. 使用 `dlv debug` 调试源码

### 3.1 调试当前目录

进入包含 `main` 包的目录：

```powershell
dlv debug
```

Delve 会：

1. 使用适合调试的参数编译程序；
2. 启动调试进程；
3. 进入 `(dlv)` 交互终端。

程序默认会在入口附近暂停。可设置断点后继续：

```text
(dlv) break main.main
(dlv) continue
```

### 3.2 调试指定包

```powershell
dlv debug ./cmd/server
```

也可以使用完整导入路径：

```powershell
dlv debug example.com/project/cmd/server
```

### 3.3 给被调试程序传参数

Delve 参数和程序参数之间使用 `--` 分隔：

```powershell
dlv debug ./cmd/server -- --config .\res\configuration.yaml --port 48080
```

含义：

```text
dlv debug ./cmd/server     Delve 自己的命令和参数
--                         参数分隔符
--config ... --port ...    传给目标 Go 程序的参数
```

如果目标程序需要位置参数，同样放在 `--` 后：

```powershell
dlv debug . -- input.txt output.txt
```

### 3.4 设置工作目录

目标程序依赖相对路径时，可指定运行目录：

```powershell
dlv debug ./cmd/server --wd F:\work\project
```

先用当前版本帮助确认参数是否可用：

```powershell
dlv help debug
```

---

## 4. 一次完整调试会话

假设源码为：

```go
package main

import "fmt"

func add(a, b int) int {
	result := a + b
	return result
}

func main() {
	total := add(2, 3)
	fmt.Println(total)
}
```

启动：

```powershell
dlv debug
```

在交互终端执行：

```text
(dlv) break main.add
Breakpoint 1 set at ...

(dlv) continue
> main.add() ...

(dlv) args
a = 2
b = 3

(dlv) next
(dlv) print result
5

(dlv) stack
(dlv) continue
(dlv) quit
```

常用节奏是：

```text
设置断点 -> continue -> 查看参数和局部变量 -> next/step -> 查看调用栈 -> continue/quit
```

---

## 5. 断点

### 5.1 按函数名设置

```text
(dlv) break main.main
(dlv) break main.add
```

包较多时使用完整函数名：

```text
(dlv) break example.com/project/service.(*Service).Run
```

方法名可能包含括号和星号。如果 shell 解析命令而不是在 `(dlv)` 终端输入，应注意引用；交互终端中通常可直接输入。

### 5.2 按文件和行号设置

```text
(dlv) break main.go:12
(dlv) break service/handler.go:85
```

Windows 路径包含盘符冒号时，优先使用相对路径或函数名，减少位置表达式歧义。

### 5.3 给断点命名

```text
(dlv) break requestStart main.handleRequest
```

之后可以通过名称操作：

```text
(dlv) clear requestStart
```

### 5.4 条件断点

先建立断点，再添加条件：

```text
(dlv) break main.process
(dlv) condition 1 userID == 100
```

断点编号可用 `breakpoints` 查看：

```text
(dlv) breakpoints
```

条件示例：

```text
(dlv) condition 1 err != nil
(dlv) condition 2 len(items) > 10
(dlv) condition 3 request.Method == "POST"
```

### 5.5 命中次数条件

Delve 支持基于命中次数的条件，具体语法随版本确认：

```text
(dlv) help condition
```

### 5.6 清除断点

```text
(dlv) clear 1
(dlv) clearall
```

---

## 6. 单步执行

| 命令 | 含义 |
| --- | --- |
| `continue` / `c` | 继续运行到下一个断点或程序结束 |
| `next` / `n` | 执行当前源码行，不进入被调用函数 |
| `step` / `s` | 执行当前源码行，进入被调用函数 |
| `stepout` | 运行到当前函数返回 |
| `step-instruction` | 单步执行 CPU 指令，通常只用于底层问题 |
| `next-instruction` | 执行下一条指令，不进入调用 |
| `restart` | 重新启动目标程序 |
| `halt` | 暂停正在运行的目标 |

典型使用：

```text
(dlv) next
(dlv) step
(dlv) stepout
(dlv) continue
```

如果 `next` 跳转看起来异常，通常与编译器优化、内联、defer 或 goroutine 调度有关，可参考后面的排障章节。

---

## 7. 查看变量和表达式

### 7.1 局部变量和参数

```text
(dlv) locals
(dlv) args
```

更详细地展开复杂值：

```text
(dlv) locals -v
(dlv) args -v
```

具体选项以当前版本为准：

```text
(dlv) help locals
```

### 7.2 打印表达式

```text
(dlv) print user
(dlv) print user.Name
(dlv) print items[0]
(dlv) print len(items)
(dlv) print err != nil
```

简写：

```text
(dlv) p user.ID
```

Delve 的表达式求值器支持常见 Go 表达式，但不是完整的 Go 编译执行环境。某些函数调用、泛型、unsafe 或经过优化的值可能受限制。

### 7.3 设置变量

```text
(dlv) set count = 10
(dlv) set enabled = true
```

目标变量必须可写，赋值表达式也受调试器能力限制。修改运行状态可能掩盖真实问题，应记录修改内容。

### 7.4 查看包变量

```text
(dlv) vars
```

可用正则过滤：

```text
(dlv) vars config
```

### 7.5 查看寄存器

```text
(dlv) regs
```

通常只在汇编、cgo、崩溃现场或编译器问题中需要。

---

## 8. 调用栈与源码位置

### 8.1 当前调用栈

```text
(dlv) stack
```

显示更多帧：

```text
(dlv) stack 20
```

### 8.2 切换栈帧

```text
(dlv) frame 1
(dlv) locals
```

也可以在指定帧执行命令：

```text
(dlv) frame 2 locals
```

### 8.3 查看源码

```text
(dlv) list
(dlv) list main.main
(dlv) list main.go:20
```

### 8.4 返回当前函数

```text
(dlv) stepout
```

---

## 9. goroutine 调试

Go 并发问题是 Delve 最有价值的场景之一。

### 9.1 列出 goroutine

```text
(dlv) goroutines
```

通常会显示 goroutine ID、状态和当前函数。

### 9.2 切换 goroutine

```text
(dlv) goroutine 18
```

在指定 goroutine 上执行命令：

```text
(dlv) goroutine 18 stack
(dlv) goroutine 18 locals
```

### 9.3 查看所有 goroutine 的栈

```text
(dlv) goroutines -t
```

具体过滤和分组选项查看：

```text
(dlv) help goroutines
```

### 9.4 只让当前 goroutine 单步

并发程序中，普通 `next` 或 `step` 期间其他 goroutine 也可能运行。需要聚焦当前 goroutine 时，可使用相应的 goroutine 调度选项或检查点机制；不同 Delve 版本支持细节不同，应查看：

```text
(dlv) help next
(dlv) help step
```

不要把调试器暂停后的调度顺序误认为生产环境真实顺序。断点本身会改变并发时序。

---

## 10. 调试测试

### 10.1 调试当前包测试

```powershell
dlv test
```

### 10.2 调试指定包

```powershell
dlv test ./service
```

### 10.3 只运行某个测试

测试二进制参数放在 `--` 后：

```powershell
dlv test ./service -- -test.run '^TestCreateUser$' -test.v
```

子测试：

```powershell
dlv test ./service -- -test.run '^TestCreateUser/invalid_input$' -test.v
```

### 10.4 设置测试断点

```text
(dlv) break example.com/project/service.TestCreateUser
(dlv) continue
```

也可以直接断在被测业务函数：

```text
(dlv) break example.com/project/service.(*Service).CreateUser
```

### 10.5 调试基准测试

```powershell
dlv test ./service -- -test.run '^$' -test.bench '^BenchmarkParse$'
```

调试器会显著影响性能，不应使用 Delve 下的耗时数据评价 benchmark 性能；这里只用于检查逻辑。

---

## 11. 调试已编译程序

### 11.1 构建适合调试的二进制

```powershell
go build -gcflags="all=-N -l" -o .\bin\server-debug.exe .\cmd\server
```

参数含义：

- `-N`：关闭优化；
- `-l`：关闭内联；
- `all=`：对所有参与编译的包应用参数。

### 11.2 使用 dlv exec

```powershell
dlv exec .\bin\server-debug.exe
```

传递程序参数：

```powershell
dlv exec .\bin\server-debug.exe -- --config .\res\configuration.yaml
```

生产构建若使用了 `-s -w` 去除调试信息，Delve 能看到的信息会严重受限。需要调试的二进制应保留 DWARF 信息。

---

## 12. 附加到运行中的进程

### 12.1 查找 PID

PowerShell：

```powershell
Get-Process server
```

按命令行检查：

```powershell
Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq "server.exe" } |
    Select-Object ProcessId, Name, CommandLine
```

### 12.2 附加

```powershell
dlv attach 12345
```

附加后可正常设置断点、查看 goroutine 和变量：

```text
(dlv) goroutines
(dlv) break example.com/project/service.(*Service).Run
(dlv) continue
```

### 12.3 权限问题

附加进程通常要求：

- 调试器和目标进程属于相同用户，或调试器具有更高权限；
- 操作系统允许进程调试；
- 安全软件未阻止调试操作。

Windows 上若目标以管理员身份运行，Delve 通常也需要在管理员终端运行。提升权限属于安全敏感操作，只在明确需要且了解目标进程时进行。

### 12.4 退出时是否杀死目标

附加场景下退出调试器是否终止或分离目标，取决于退出命令和选项。操作生产进程前先查看：

```text
(dlv) help quit
```

不要在不了解行为时直接对生产进程执行 `quit`。

---

## 13. Headless 远程调试

Headless 模式让 Delve 作为调试服务器运行，客户端从另一终端或机器连接。

### 13.1 启动服务

```powershell
dlv debug .\cmd\server `
    --headless `
    --listen=127.0.0.1:2345 `
    --api-version=2 `
    --accept-multiclient
```

调试已有二进制：

```powershell
dlv exec .\bin\server-debug.exe `
    --headless `
    --listen=127.0.0.1:2345 `
    --api-version=2
```

### 13.2 连接服务

另一个终端：

```powershell
dlv connect 127.0.0.1:2345
```

连接后进入普通 `(dlv)` 交互会话。

### 13.3 安全要求

Delve 调试接口拥有读取内存、修改变量和控制进程的能力，等同于高权限代码执行入口。

- 本机调试优先监听 `127.0.0.1`。
- 不要把端口直接暴露到公网。
- 跨机器调试优先使用 SSH 隧道或受保护的内部网络。
- 不要在无鉴权的情况下使用 `--listen=0.0.0.0:2345`。
- 调试结束后及时关闭 Delve 服务和网络端口。

SSH 隧道思路：

```text
本地 127.0.0.1:2345 -> SSH 加密隧道 -> 远端 127.0.0.1:2345
```

---

## 14. DAP 模式与 IDE

DAP 是 Debug Adapter Protocol。现代 VS Code Go 扩展和部分 IDE 使用它与 Delve 通信。

### 14.1 手动启动 DAP 服务

```powershell
dlv dap --listen=127.0.0.1:38697
```

通常 IDE 会自动启动 Delve，不需要手工运行 `dlv dap`。

### 14.2 VS Code `launch.json`

调试当前包：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug current package",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "program": "${workspaceFolder}",
      "args": ["--config", "res/configuration.yaml"]
    }
  ]
}
```

调试测试：

```json
{
  "name": "Debug package tests",
  "type": "go",
  "request": "launch",
  "mode": "test",
  "program": "${workspaceFolder}/service",
  "args": ["-test.run", "^TestCreateUser$"]
}
```

附加本地进程：

```json
{
  "name": "Attach to process",
  "type": "go",
  "request": "attach",
  "mode": "local",
  "processId": 12345
}
```

VS Code Go 扩展的字段会随版本演进，应以当前扩展文档和配置提示为准。

### 14.3 GoLand

GoLand 自带 Go 调试集成，底层通常使用 Delve。常见操作：

1. 在代码行号旁设置断点；
2. 创建 Go Build、Go Test 或 Go Remote 运行配置；
3. 设置工作目录、程序参数和环境变量；
4. 点击 Debug 启动。

远程配置需要让 IDE 和远端 Delve 使用匹配的协议及源码映射。

---

## 15. 容器与远程环境调试

### 15.1 在容器中运行 Delve

典型做法是在调试镜像中安装 `dlv`，保留源码和调试符号，然后启动 headless 服务：

```text
dlv exec /app/server \
  --headless \
  --listen=0.0.0.0:2345 \
  --api-version=2 \
  --accept-multiclient
```

容器还需要：

- 暴露或映射调试端口；
- 允许 ptrace 等调试能力；
- 保持本地源码路径与容器源码路径可映射；
- 使用含调试信息的二进制。

Linux Docker 常见调试权限包括 `SYS_PTRACE` 和放宽 seccomp，但这些会扩大容器权限，只应在隔离的开发环境启用。

### 15.2 源码路径映射

本地源码可能位于：

```text
F:\work\project
```

远端编译路径可能是：

```text
/workspace/project
```

IDE 远程调试配置需要设置 substitutePath 或等价路径映射，否则断点可能显示为灰色或无法绑定。

### 15.3 编译环境一致性

远程调试最好保证：

- Delve 支持目标二进制使用的 Go 版本；
- Delve 与目标程序运行在同一 OS/架构环境；
- 源码与被调试二进制对应同一提交；
- 二进制未剥离 DWARF 信息。

---

## 16. 调试崩溃转储

Delve 支持通过 `core` 子命令分析崩溃转储：

```powershell
dlv core .\bin\server.exe .\crash\server.dmp
```

Linux 常见形式：

```text
dlv core ./server ./core.12345
```

进入后常用命令：

```text
(dlv) goroutines
(dlv) stack
(dlv) threads
(dlv) locals
(dlv) print variable
```

要求：

- 可执行文件必须和转储文件严格匹配；
- 二进制需要保留调试信息；
- 源码路径最好仍可访问或配置映射；
- 操作系统和转储格式必须受当前 Delve 版本支持。

core 调试是静态现场分析，不能真正继续执行程序或修改后恢复运行。

---

## 17. 非交互函数跟踪

`dlv trace` 可在函数进入或返回时打印信息，而不进入完整交互会话：

```powershell
dlv trace . 'main\.process'
```

指定包：

```powershell
dlv trace .\cmd\server 'service\.\(\*Service\)\.Handle'
```

函数正则、返回值和栈信息等选项查看：

```powershell
dlv help trace
```

`trace` 会改变程序时序和性能，不等同于低开销生产观测工具。生产环境优先使用日志、指标、trace 系统或专门 profiler。

---

## 18. 常见排障

### 18.1 Delve 不支持当前 Go 版本

现象通常是启动时报版本不兼容。

处理：

```powershell
go install github.com/go-delve/delve/cmd/dlv@latest
dlv version
go version
```

如果项目必须使用旧版 Delve，则应使用其支持的 Go 工具链，不建议关闭兼容性检查后长期工作。

### 18.2 找不到源码或断点无法绑定

检查：

- 当前源码是否与二进制来自同一提交；
- 函数是否被条件编译排除；
- 文件路径和包路径是否正确；
- 远程环境是否配置源码路径映射；
- 函数是否被内联或优化；
- 断点行是否真的对应可执行语句。

可改用函数名断点：

```text
(dlv) funcs CreateUser
(dlv) break 完整函数名
```

### 18.3 变量显示为 optimized away

使用禁用优化和内联的构建：

```powershell
go build -gcflags="all=-N -l" -o server-debug.exe .\cmd\server
dlv exec .\server-debug.exe
```

`dlv debug` 和 `dlv test` 通常会自动使用适合调试的编译参数。

### 18.4 函数名找不到

搜索函数：

```text
(dlv) funcs Handler
```

搜索源码位置：

```text
(dlv) sources service
```

泛型实例、闭包和编译器生成函数的符号名可能与源码名称不同，先用 `funcs` 查询实际名称。

### 18.5 附加失败

检查：

- PID 是否仍存在；
- 当前用户是否有权限；
- 目标是否真的是 Go 程序；
- 安全软件或操作系统调试策略是否阻止；
- Delve 与目标架构是否匹配。

### 18.6 程序参数没有生效

确认使用了 `--`：

```powershell
dlv debug . -- --config config.yaml
```

`--` 前是 Delve 参数，后面才是目标程序参数。

### 18.7 相对路径读取文件失败

调试器启动目录可能和直接运行程序不同。打印或设置工作目录：

```go
wd, _ := os.Getwd()
fmt.Println(wd)
```

然后在 CLI 或 IDE 配置正确的工作目录。

### 18.8 cgo 调试受限

Delve 主要调试 Go 代码。进入 C/C++ 代码、查看复杂 C 状态时，可能需要 GDB 或 LLDB 配合，并处理不同调试信息和线程模型。

### 18.9 macOS 安全与签名问题

macOS 对进程调试、签名和权限有额外限制。应优先使用官方安装方式和 Delve 当前文档，不要随意关闭系统安全机制。

---

## 19. 常用命令速查

### 启动

```powershell
dlv debug
dlv debug .\cmd\server -- --config config.yaml
dlv test ./service -- -test.run '^TestName$' -test.v
dlv exec .\bin\server-debug.exe -- --port 8080
dlv attach 12345
dlv connect 127.0.0.1:2345
dlv dap --listen=127.0.0.1:38697
```

### 交互调试

```text
break main.main
break file.go:42
condition 1 err != nil
breakpoints
clear 1
continue
next
step
stepout
restart
```

### 查看状态

```text
args
locals
print variable
vars
stack
frame 1
list
goroutines
goroutine 18 stack
threads
```

### 控制和退出

```text
halt
continue
quit
help
```

---

## 20. 推荐调试流程

1. 先用普通测试或日志把问题缩小到包、函数或请求。
2. 使用 `dlv test` 或 `dlv debug`，优先从源码启动。
3. 在函数入口设置断点，不要一开始设置大量断点。
4. 命中后检查 `args`、`locals` 和 `stack`。
5. 并发问题同时检查 `goroutines`，记录目标 goroutine ID。
6. 使用条件断点减少无关命中。
7. 变量不可见时确认优化、内联和源码版本。
8. 远程调试只监听回环地址或使用安全隧道。
9. 不把调试器改变后的并发时序当作生产现场原貌。
10. 调试结束后删除临时调试二进制、关闭端口，并恢复环境配置。

## 参考

- [Delve GitHub](https://github.com/go-delve/delve)
- [Delve Documentation](https://github.com/go-delve/delve/tree/master/Documentation)
- [VS Code Go Debugging](https://github.com/golang/vscode-go/blob/master/docs/debugging.md)
