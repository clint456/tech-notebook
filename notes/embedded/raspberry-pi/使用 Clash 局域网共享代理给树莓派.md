以下是关于如何使用 Clash 在局域网内共享代理，让树莓派通过主机代理访问网络的总结笔记。用中文整理，简洁清晰，方便快速参考。

---

# 使用 Clash 局域网共享代理给树莓派
**目标**：让树莓派通过主机运行的 Clash 代理访问网络。  
**前提**：主机和树莓派在同一局域网，主机运行 Clash。

---

## 环境
+ **主机**：
    - IP：例如 `192.168.32.56`（通过 `ipconfig` 或 `ifconfig` 查看）。
    - Clash 端口：默认 HTTP 代理 `7890`，SOCKS5 代理 `7891`。
+ **树莓派**：
    - 系统：Raspberry Pi OS。
    - 已联网，可通过终端或 SSH 操作。

---

## 步骤
### 1. 确认 Clash 配置
+ **主机上**：
    - 检查 Clash 配置文件（`config.yaml`）：
        * `port: 7890`（HTTP 代理端口）。
        * `socks-port: 7891`（SOCKS5 端口，可选）。
        * `allow-lan: true`（允许局域网访问）。

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742294455068-b5a310b8-5834-48b7-b9f9-1dda87b9bdd0.png)

    - 重启 Clash 应用生效。
+ **测试可用性**：  
在树莓派上：

```plain
curl -x http://192.168.32.56:7890 https://www.google.com
```

    - 成功返回内容则代理可用。

### 2. 树莓派设置代理
#### 临时设置（当前会话）
```plain
export http_proxy="http://192.168.32.56:7890"
export https_proxy="http://192.168.32.56:7890"
export no_proxy="localhost,127.0.0.1,192.168.32.0/24"
```

+ 测试：

```plain
curl https://www.google.com
```

#### 永久设置（写入配置文件）
+ 编辑 `~/.bashrc`：

```plain
nano ~/.bashrc
```

+ 添加：

```plain
export http_proxy="http://192.168.32.56:7890"
export https_proxy="http://192.168.32.56:7890"
export no_proxy="localhost,127.0.0.1,192.168.32.0/24"
```

+ 保存并应用：

```plain
source ~/.bashrc
```

+ 验证：

```plain
echo $http_proxy
```

### 3. 配置 APT 使用代理
+ 编辑 APT 代理文件：

```plain
sudo nano /etc/apt/apt.conf.d/10proxy
```

+ 添加：

```plain
Acquire::http::Proxy "http://192.168.32.56:7890";
Acquire::https::Proxy "http://192.168.32.56:7890";
```

+ 保存并测试：

```plain
sudo apt update
```

### 4. （可选）全局代理
+ 安装 `proxychains`：

```plain
sudo apt install proxychains -y
```

+ 编辑配置文件：

```plain
sudo nano /etc/proxychains.conf
```

+ 修改代理行：

```plain
http 192.168.32.56 7890
```

或（SOCKS5）：

```plain
socks5 192.168.32.56 7891
```

+ 使用：

```plain
proxychains curl https://www.google.com
```

---

## 注意事项
+ **端口调整**：Clash 若非默认端口，替换 `7890` 为实际值。
+ **防火墙**：
    - 主机需开放代理端口（例如 Windows 防火墙或 `sudo ufw allow 7890`）。
+ **验证**：
    - 重启树莓派后：

```plain
curl https://www.google.com
```

+ **局域网范围**：`no_proxy` 中的 `192.168.32.0/24` 根据实际网段调整。

---

## 故障排查
+ **连接失败**：
    - 确认主机 IP 和端口。
    - 检查 Clash 是否监听：`netstat -tuln | grep 7890`（主机上）。
+ **APT 无效**：
    - 检查 `/etc/apt/apt.conf.d/10proxy` 语法。
+ **环境变量未加载**：
    - `env | grep proxy` 确认。

---

## 总结
+ **核心设置**：树莓派通过 `http_proxy` 和 `https_proxy` 使用主机 Clash 代理。
+ **关键命令**：
    - 临时：`export http_proxy="http://192.168.32.56:7890"`
    - 永久：编辑 `~/.bashrc`
    - APT：配置 `/etc/apt/apt.conf.d/10proxy`
+ **结果**：树莓派可通过主机代理访问外部网络。

这份笔记涵盖了完整流程，有问题可随时补充或调整！

