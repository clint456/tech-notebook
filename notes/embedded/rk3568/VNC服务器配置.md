### 1、安装 xfce4
```shell
sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
```

### 2、安装 VNC 服务器
```shell
sudo apt install tigervnc-standalone-server tigervnc-common
```

### 3、在~/.vnc/目录下创建xstartup文件，在里面输入如下
```shell
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
```



### 4、 启动vncser:
运行：vncserver

若输入：netstate -tul查看到监听端口只在内网起作用的话，可以这样进行vnc启动：（netstate -tunpl）

Vncserver -localhost no启动即可。

或者这样启动：

tigervncserver -localhost no -xstartup /usr/bin/xterm

### 5、 指定分辨率方式启动：
vncserver -geometry 1366x700 -localhost no

