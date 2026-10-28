

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1745312985491-853d0847-4d64-4b79-a1d9-bcca44f6d791.png)

## 🔍 1. Suspend 模式概述
### ❓ Suspend 是什么？
Suspend 是 Linux 的电源管理机制，允许系统在不完全关机的情况下暂停运行，以达到节能目的，并能迅速恢复。

---

## 🧭 2. Linux 支持的挂起模式（/sys/power/state）
你可以通过以下命令查看当前系统支持的 suspend 模式：

```bash
cat /sys/power/state
```

可能输出：

```plain
freeze mem
```

| 模式 | 描述 |
| --- | --- |
| `freeze` | 仅冻结用户空间进程，CPU 和大多数设备仍运行，恢复最快；适合调试 |
| `standby` | CPU 停止运行，部分外设关闭（非所有平台支持） |
| `mem`<br/>（即 deep） | Suspend-to-RAM：几乎所有设备断电，仅 RAM 保持供电，功耗最低 |
| `disk` | Hibernate：保存内存内容到磁盘后断电；嵌入式系统很少使用 |


在你的系统日志中：

```plain
[ 1214.316150] PM: suspend entry (deep)
```

这里的 `deep` 实际上就是 `mem` 模式，即 Suspend-to-RAM。

---

## 🔬 3. suspend to mem（deep） 的工作流程
### 进入 suspend 的步骤如下：
1. **冻结用户空间**
    - 内核将所有用户进程冻结（通过 freezer 子系统）
    - 确保在休眠过程中进程不改变系统状态
2. **同步文件系统**
    - 调用 `sync()` 确保数据安全写入
3. **关闭或挂起外设**
    - 每个驱动调用其 `suspend()` 回调，进入低功耗或断电状态
4. **关闭非启动核**
    - 除 boot CPU 以外的核心全部关闭
5. **平台进入低功耗模式**
    - SoC（如 RK356x）进入系统级 suspend 状态（由 PMIC 控制）
6. **等待唤醒中断**
    - 系统被中断（如 GPIO、RTC）唤醒
7. **resume：步骤逆向执行**
    - 重新初始化设备 → 恢复进程 → 系统恢复运行

---

## 🧯 4. suspend/resume 失败的常见原因
| 问题类别 | 描述 |
| --- | --- |
| ❌ 唤醒源未配置 | 系统进入 suspend 后没有设备产生中断唤醒 |
| ❌ 设备驱动不支持 suspend | 某些驱动 suspend/resume 回调未正确实现，造成挂起后无法恢复 |
| ❌ 串口挂起导致日志中断 | 控制台挂起后无法查看恢复过程 |
| ❌ CPU 核 resume 失败 | 多核平台 resume 阶段失败，系统卡死 |
| ❌ 电源管理芯片配置不当 | PMIC 进入错误状态无法恢复，常见于硬件平台初期调试阶段 |


---

## 🛠 5. 调试 suspend 的常用方法
### ✅ 5.1 启用 suspend 阶段日志打印
默认串口在 suspend 期间会关闭，导致无法看到 resume 阶段日志。

#### 解决方法：
1. **添加内核启动参数：**

在 U-Boot 中执行：

```bash
setenv bootargs "${bootargs} no_console_suspend"
saveenv
```

1. **重启系统，观察 suspend 阶段日志是否继续输出。**

---

### ✅ 5.2 手动测试 suspend：
```bash
echo mem > /sys/power/state    # 进入 suspend-to-RAM（deep）
```

```bash
echo freeze > /sys/power/state # 进入轻度挂起（调试推荐）
```

如果无法恢复，说明唤醒源未配置或 resume 阶段失败。

---

### ✅ 5.3 查看系统唤醒源配置
```bash
# 查看所有唤醒设备的状态
cat /sys/class/wakeup/*/device/power/wakeup
```

或：

```bash
cat /sys/kernel/debug/wakeup_sources
```

输出中应有至少一个 `enabled` 状态的设备，否则系统将无法被唤醒。

---

## 🧩 6. 如何关闭 suspend（特别是 deep suspend）
### 方法一：临时进入 freeze 模式（推荐）
```bash
echo freeze > /sys/power/state
```

用于代替 deep 模式进行测试。

---

### 方法二：设置默认 suspend 模式为 freeze
在启动参数中添加：

```bash
mem_sleep_default=shallow
```

在 U-Boot 添加：

```bash
setenv bootargs "${bootargs} mem_sleep_default=shallow"
saveenv
```

此后 `echo mem > /sys/power/state` 实际进入的是 `freeze` 而非 deep。

---

### 方法三：彻底禁用 suspend 功能（仅限自编内核）
在内核 `menuconfig` 中取消勾选：

```plain
Power management options --->
    [ ] Suspend to RAM and standby
```

或直接设置：

```plain
CONFIG_SUSPEND=n
```

---

## 📋 7. RK356x 平台相关提示
+ RK356x 支持 suspend-to-RAM，但需要：
    - DTS 中配置唤醒中断（如 GPIO 键）
    - 正确配置 PMIC（如 RK817）的电源状态机
    - 验证 CPU resume 流程完整
+ 串口恢复日志只能通过 `no_console_suspend` 保证打印
+ 深度挂起恢复失败时，建议先在 `freeze` 模式下调试驱动 suspend/resume 回调是否正常

---

## 🧪 8. 推荐的调试步骤（从浅入深）
| 阶段 | 操作 |
| --- | --- |
| ✅ 阶段 1 | 添加 `no_console_suspend`<br/> 参数，确保日志输出完整 |
| ✅ 阶段 2 | 手动进入 `freeze`<br/> 模式，确保系统不会卡死 |
| ✅ 阶段 3 | 手动测试 `echo mem`<br/>，验证 deep suspend 恢复是否正常 |
| ✅ 阶段 4 | 使用 `dmesg`<br/> 和串口日志确认驱动 suspend/resume 是否有异常 |
| ✅ 阶段 5 | 精调 DTS 唤醒源配置、核查中断触发机制 |
| ✅ 阶段 6 | 逐步恢复系统 suspend 功能，接入正式测试流程 |


---

## 📎 附录：常用命令汇总
```bash
# 查看支持的 suspend 模式
cat /sys/power/state

# 切换 suspend 模式
echo freeze > /sys/power/state
echo mem > /sys/power/state

# 查看唤醒源
cat /sys/kernel/debug/wakeup_sources
cat /sys/class/wakeup/*/device/power/wakeup

# 检查内核是否启用了 suspend
zcat /proc/config.gz | grep CONFIG_SUSPEND
```

