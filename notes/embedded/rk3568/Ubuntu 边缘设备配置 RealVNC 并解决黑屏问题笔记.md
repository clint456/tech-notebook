## 🖥️ 目标
在 **Ubuntu 20 + RealVNC + RK356x 边缘平台**上部署 VNC 服务器，并实现 **从 Windows 客户端通过 VNC Viewer 成功连接图形界面**（避免黑屏）。

---

## 📦 一、安装 VNC 服务器和桌面环境
### 1. 安装 TigerVNC：
```bash
sudo apt update
sudo apt install tigervnc-standalone-server -y
```

### 2. 安装轻量桌面环境 `fluxbox`（推荐，兼容性好）：
```bash
sudo apt install fluxbox -y
```

> 说明：原使用 `xfce4` 桌面会因无 GPU 支持而导致黑屏，故推荐使用 `fluxbox` 替代。
>

---

## 📁 二、配置 VNC 启动脚本
编辑 `~/.vnc/xstartup` 文件：

```bash
nano ~/.vnc/xstartup
```

粘贴以下内容：

```shell
#!/bin/sh

xrdb $HOME/.Xresources

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=FLUXBOX

fluxbox &
```

保存后赋予可执行权限：

```bash
chmod +x ~/.vnc/xstartup
```

> ⚠️ 若提示 `.Xresources` 文件不存在，可执行：
>

```bash
touch ~/.Xresources
```

---

## 🔁 三、启动 VNC 服务
1. **杀掉原会话并清理锁文件：**

```bash
vncserver -kill :1
vncserver -kill :2
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
rm -rf /tmp/.X2-lock /tmp/.X11-unix/X2
```

2. **启动新的 VNC 会话：**

```bash
vncserver :1
```

---

## 💻 四、Windows 客户端连接
1. 安装 [VNC Viewer (RealVNC)](https://www.realvnc.com/en/connect/download/viewer/)
2. 输入连接地址：

```plain
<Ubuntu设备局域网IP>:1
```

例如：

```plain
192.168.1.88:1
```

3. 输入 VNC 密码（首次运行 `vncserver` 会提示设置）。

### <font style="color:rgb(71, 85, 105);">安全连接VNC桌面</font>
<font style="color:rgb(71, 85, 105);">VNC本身在连接时不使用安全协议。为了安全连接，您可以使用SSH隧道连接到服务器，然后告诉VNC客户端使用该隧道而不是直接连接。</font>

<font style="color:rgb(71, 85, 105);">在您的本地计算机上创建一个SSH连接，安全地将其转发到VNC的localhost连接。您可以通过Linux或macOS的终端使用以下命令来完成此操作。记得将”sammy”和”your_server_ip”替换为您的非root用户名和服务器的IP地址。</font>

```plain
ssh -L 5901:127.0.0.1:5901 -C -N -l Tronlong 192.168.8.123
```

<font style="color:rgb(71, 85, 105);">请注意，在您在本地机器的终端上运行此命令后，不会返回任何输出。您需要使用VNC客户端来查看图形界面。</font>

<font style="color:rgb(71, 85, 105);">这个ssh命令的选项含义如下：</font>

+ <font style="color:rgb(71, 85, 105);">The -L switch specifies the port bindings. In this case you’re binding port 5901 of the remote connection to port 5901 on your local machine.</font>
+ <font style="color:rgb(71, 85, 105);">The -C switch enables compression to help minimize resource consumption and speed things up.</font>
+ <font style="color:rgb(71, 85, 105);">The -N switch tells ssh that you don’t want to execute a remote command.</font>
+ <font style="color:rgb(71, 85, 105);">The -l switch specifies the remote login name. Make sure to replace sammy and your_server_ip with the name of your non-root user and your server’s IP address.</font>

<font style="color:rgb(71, 85, 105);">如果你正在使用PuTTY连接到服务器，你可以通过右键点击终端窗口的顶部栏，并选择”更改设置”选项来创建一个SSH隧道。</font>

<font style="color:rgb(71, 85, 105);">鼠标右击顶部栏以显示“更改设置”选项。</font>

<font style="color:rgb(71, 85, 105);">在PuTTY重新配置窗口的左侧树形菜单中找到”连接”分支。展开SSH分支，然后点击”Tunnels”。在控制SSH端口转发的选项屏幕上，将源端口设置为5901，目的地设置为localhost:5901</font>

---

## 🧩 附：常见问题与解决
| 问题 | 解决方法 |
| --- | --- |
| 连接成功但黑屏 | 使用 `fluxbox` 替代 `xfce4`，避免 GPU 渲染问题 |
| `.Xresources` 文件缺失 | 使用 `touch ~/.Xresources` 创建空文件即可 |
| 端口 5901 无法访问 | 关闭或配置防火墙：`sudo ufw allow 5901/tcp` |
| 启动提示 X server already running | 杀掉残留会话，并清理 `/tmp/.X*` 文件 |


---

✅ 配置完成后，VNC Viewer 打开的是一个轻量级图形桌面，支持启动终端、文件管理器等。

需要更完整桌面体验也可后续安装 `xfce4-goodies`，但在没有 GPU 的嵌入式平台上仍推荐使用 `fluxbox`、`openbox` 这类轻量桌面。

---

