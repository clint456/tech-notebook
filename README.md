# 技术笔记库

个人技术笔记。知识内容统一用 Markdown 记录，代码 / 图片 / 资料作为配套资源分开放置。

- 全部笔记清单：[索引.md](./索引.md)（脚本自动生成）
- 写作与目录规范：[文档规范.md](./文档规范.md)
- 笔记模板：[_模板](./_模板)
- 本地大文件：[资料](./资料/README.md)（不入库）

## 目录结构

```text
tech-notebook/
├── README.md                 # 本文件：仓库导航与约定
├── 索引.md                   # 全部笔记清单（脚本生成，勿手改）
├── 文档规范.md               # 命名 / 目录 / 提交规范
│
├── 00-inbox/                 # 临时 / 未归类，定期清空
│
├── notes/                    # 纯笔记（md + 同名 .assets）
│   ├── cs-basics/            # 计算机基础
│   │   ├── operating-system/
│   │   ├── tcp-ip/           # 按《TCP/IP 详解》章节分目录
│   │   └── linux-sys-programming/
│   ├── embedded/             # 嵌入式
│   │   ├── stm32/  freertos/  rk3568/  mqtt/  raspberry-pi/
│   │   └── linux-driver/     # 入门 / 内核模块 / 字符设备 / 中断 / SPI
│   ├── languages/            # 语言
│   │   ├── c-cpp/  golang/（含 edgex/）  typescript/
│   └── hardware/
│
├── code/                     # 可运行代码
│   ├── leetcode/             # 每题一个目录
│   ├── golang-demos/         # 原 Golang/Code_Demo 的章节练习
│   ├── projects/             # chatroom / chatsys / customer / customerManage / oa
│   └── typescript/
│
├── interview/                # 面试
│   ├── 八股文/
│   └── 面试记录/
│
├── career/                   # 公司与职业规划
├── misc/                      # 杂项：读书笔记 / 编程小记 / idea
│
├── 资料/                     # PDF、镜像等大文件（.gitignore 忽略，仅保留说明）
├── _模板/                    # 笔记 / 实验记录 / 排错记录模板
└── scripts/                  # 索引生成脚本
```

## 笔记分布

| 目录 | 内容 | 篇数 |
| --- | --- | --- |
| [notes/cs-basics/operating-system](./notes/cs-basics/operating-system) | 进程、线程、IPC | 4 |
| [notes/cs-basics/tcp-ip](./notes/cs-basics/tcp-ip) | TCP/IP 协议栈原理与习题 | 25 |
| [notes/cs-basics/linux-sys-programming](./notes/cs-basics/linux-sys-programming) | Linux 文件 IO、进程、IPC 编程 | 6 |
| [notes/embedded/freertos](./notes/embedded/freertos) | FreeRTOS 内核机制 | 10 |
| [notes/embedded/linux-driver](./notes/embedded/linux-driver) | Linux 驱动（入门 / 内核模块 / 字符设备 / 中断 / SPI） | 35 |
| [notes/embedded/rk3568](./notes/embedded/rk3568) | RK356x 平台移植、编译与排错 | 13 |
| [notes/embedded/stm32](./notes/embedded/stm32) | STM32 开发与外设 | 3 |
| [notes/embedded/mqtt](./notes/embedded/mqtt) | MQTT 协议与 EMQX | 2 |
| [notes/embedded/raspberry-pi](./notes/embedded/raspberry-pi) | 树莓派使用与网络调试 | 8 |
| [notes/embedded](./notes/embedded) | 嵌入式技术栈路线图 | 1 |
| [notes/languages/c-cpp](./notes/languages/c-cpp) | C/C++ 语言与工程实践 | 2 |
| [notes/languages/golang](./notes/languages/golang) | Go 语言、标准库、EdgeX | 21 |
| [notes/languages/typescript](./notes/languages/typescript) | TypeScript 语法 | 2 |
| [notes/hardware](./notes/hardware) | 器件、电路与硬件路线 | 2 |
| [interview/八股文](./interview/八股文) | 面经速记 | 1 |
| [interview/面试记录](./interview/面试记录) | C / Linux 面试题、简历问答、公司面试 | 4 |
| [career](./career) | 求职规划、考公规划、汇源入职学习 | 11 |
| [misc/编程小记](./misc/编程小记) | Docker / Vim / PowerShell 等工具实践 | 10 |
| [misc/读书笔记](./misc/读书笔记) | 阅读记录 | 1 |
| [code](./code) | 可运行代码（LeetCode、Go 练习、项目） | — |

## 快速上手

新增一篇笔记：

1. 判断归属：先看 `notes/`（纯知识），再看 `interview/`、`career/`、`misc/`；不确定就放 `00-inbox/`。
2. 复制 [_模板/笔记模板.md](./_模板/笔记模板.md)，按「背景 → 结论 → 正文 → 参考」填写。
3. 更新索引：

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\生成目录索引.ps1
   ```

4. 提交：

   ```powershell
   git add -A
   git commit -m "docs(linux-driver): 补充内核模块加载流程"
   ```

## 本次结构迁移对照

| 原位置 | 新位置 |
| --- | --- |
| `C_C++/` | `notes/languages/c-cpp/` |
| `Golang/*.md` | `notes/languages/golang/` |
| `Golang/EdgeX/` | `notes/languages/golang/edgex/` |
| `Golang/Code_Demo/` | `code/golang-demos/` |
| `Golang/Code_Demo/{chatroom,chatsys,customer,customerManage,oa}` | `code/projects/` |
| `TypeScript/*.md` | `notes/languages/typescript/` |
| `TypeScript/code/01` | `code/typescript/01` |
| `操作系统/` | `notes/cs-basics/operating-system/` |
| `TCP_IP协议栈/TCP_IP协议 —— 第N章` | `notes/cs-basics/tcp-ip/0N-第N章...` |
| `Linux/Linux系统编程`、`Linux/Linux应用开发` | `notes/cs-basics/linux-sys-programming/` |
| `Linux/{驱动开发入门篇,Linux 模块化编程,字符设备驱动模型,中断及异常,Linux驱动子系统/SPI子系统}` | `notes/embedded/linux-driver/{getting-started,kernel-module,char-device,interrupt,spi}` |
| `Linux/高级嵌入式开发工程师技术栈.md` | `notes/embedded/` |
| `FreeRTOS/`、`STM32/`、`RK3568/`、`MQTT/` | `notes/embedded/{freertos,stm32,rk3568,mqtt}` |
| `树莓派/` | `notes/embedded/raspberry-pi/` |
| `硬件/` | `notes/hardware/` |
| `八股文/` | `interview/八股文/` |
| `面试/{C语言面试题及题解,Linux面试题及题解,简历内容问答,四川汇源光通信}` | `interview/面试记录/` |
| `面试/{2025嵌入式求职规划,考公规划}` | `career/` |
| `汇源入职学习/` | `career/汇源入职学习/` |
| `读书笔记/`、`编程小记/`、`Idea/` | `misc/{读书笔记,编程小记,idea}/` |
| `LeetCode/` | `code/leetcode/` |
| `Golang/*.pdf`、`Idea/量化交易系统/*.pdf` | `资料/`（不入库） |
