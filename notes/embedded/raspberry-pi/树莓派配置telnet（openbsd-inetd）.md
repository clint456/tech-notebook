以下是使用 `openbsd-inetd` 在树莓派 5 上开启 Telnet 的整理笔记，步骤清晰简洁，适合快速参考。我会用中文编写，并确保逻辑连贯，方便你随时查阅或操作。

---

# 在树莓派 5 上使用 openbsd-inetd 开启 Telnet
**目标**：通过 `openbsd-inetd` 配置并启动 Telnet 服务，允许从 Windows 使用 Telnet 客户端连接树莓派 5。

**当前日期**：2025年3月13日  
**操作系统**：假设使用 Raspberry Pi OS（基于 Debian）。

---

## 前提条件
+ 树莓派 5 已连接网络，且你知道其 IP 地址（通过 `hostname -I` 查看）。
+ 你有终端访问权限（本地或通过 SSH）。

---

## 步骤
### 1. 更新系统
确保软件包是最新的：

```plain
sudo apt update && sudo apt upgrade -y
```

### 2. 安装 Telnet 服务器和 openbsd-inetd
安装必要的软件包：

```plain
sudo apt install telnetd openbsd-inetd -y
```

+ `telnetd`：Telnet 服务器。
+ `openbsd-inetd`：管理 Telnet 服务的守护进程。

### 3. 配置 Telnet 服务
编辑 `openbsd-inetd` 的配置文件：

```plain
sudo nano /etc/inetd.conf
```

检查或添加以下一行（如果已存在，确保未被注释，即前面没有 `#`）：

```plain
telnet  stream  tcp  nowait  root  /usr/sbin/telnetd  telnetd
```

+ 说明：
    - `telnet`：服务名称。
    - `stream`：使用流式套接字。
    - `tcp`：协议。
    - `nowait`：不等待，允许并发连接。
    - `root`：以 root 用户运行。
    - `/usr/sbin/telnetd`：Telnet 服务器路径。
+ 保存并退出（Ctrl+O，Enter，Ctrl+X）。

### 4. 重启 openbsd-inetd 服务
应用配置并启动服务：

```plain
sudo /etc/init.d/openbsd-inetd restart
```

确保服务开机自启（通常默认启用）：

```plain
sudo systemctl enable openbsd-inetd
```

### 5. 验证 Telnet 是否运行
检查端口 23 是否监听：

```plain
netstat -tuln | grep 23
```

+ 预期输出：

```plain
tcp  0  0  0.0.0.0:23  0.0.0.0:*  LISTEN
```

+ 如果没有输出，服务未启动，需排查。

### 6. 测试连接
+ **本地测试**：  
在树莓派上运行：

```plain
telnet localhost
```

应提示登录，输入默认用户名 `pi` 和密码（如 `raspberry`，除非已更改）。

+ **从 Windows 测试**：
    1. 确保 Windows 已启用 Telnet 客户端：
        * 控制面板 > 程序和功能 > 打开或关闭 Windows 功能 > 勾选“Telnet 客户端”。
    2. 打开命令提示符（cmd），运行：

```plain
telnet <树莓派IP>
```

例如：`telnet 192.168.1.100`。

---

## 故障排查
### 问题 1：没有端口 23 监听
+ **检查服务状态**：

```plain
sudo systemctl status openbsd-inetd
```

    - 如果未运行，启动：

```plain
sudo systemctl start openbsd-inetd
```

+ **检查 telnetd 是否安装**：

```plain
ls -l /usr/sbin/telnetd
```

    - 如果不存在，重新安装：

```plain
sudo apt install --reinstall telnetd
```

+ **检查配置文件**：  
确保 `/etc/inetd.conf` 中 Telnet 行未被注释。

### 问题 2：连接被拒绝
+ **防火墙**：  
检查是否启用了防火墙：

```plain
sudo ufw status
```

    - 如果启用，允许端口 23：

```plain
sudo ufw allow 23
sudo ufw reload
```

+ **端口冲突**：  
检查是否有其他进程占用端口 23：

```plain
sudo lsof -i :23
```

    - 如果有，停止相关进程。

### 问题 3：日志排查
+ 查看系统日志：

```plain
sudo journalctl -u openbsd-inetd
```

寻找错误信息，例如文件路径错误或权限问题。

---

## 注意事项
+ **安全性**：Telnet 不加密，建议仅在本地网络中使用。远程访问推荐 SSH。
+ **SSH 替代**：
    - 启用 SSH：

```plain
sudo raspi-config
```

选择 `Interface Options` > `SSH` > 启用。

    - 从 Windows：

```plain
ssh pi@<树莓派IP>
```

---

## 总结
完成以上步骤后，树莓派 5 应成功运行 Telnet 服务，可通过 Windows Telnet 客户端连接。如果仍遇到问题，提供以下信息以进一步排查：

1. `netstat -tuln | grep 23` 的输出。
2. `sudo systemctl status openbsd-inetd` 的输出。
3. `/etc/inetd.conf` 中 Telnet 行的内容。

---

这份笔记涵盖了完整流程和常见问题，希望对你有帮助！有什么疑问随时问我。

