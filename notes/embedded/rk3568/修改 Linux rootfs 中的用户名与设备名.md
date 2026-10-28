以下是在 Linux `rootfs` 文件系统中修改用户名和设备名（主机名）的步骤，适用于正式系统启动前的配置或通过挂载文件系统进行修改。

## 1. 修改用户名
用户信息存储在 `/etc/passwd`、`/etc/shadow` 和 `/etc/group` 文件中。以下是将用户名从 `olduser` 改为 `newuser` 的步骤。

### 步骤
1. **准备工作**
    - 以 root 权限操作，或通过 live CD/USB 挂载 `rootfs`。
    - 如果直接操作 `rootfs`（如嵌入式系统），确保文件系统已挂载并有写权限。
2. **挂载 rootfs（若未启动系统）**

```bash
mount /dev/sdX /mnt  # 替换 /dev/sdX 为设备分区
```

3. **编辑 /etc/passwd**
    - 打开 `/mnt/etc/passwd`。
    - 找到：

```plain
olduser:x:1000:1000:Old User,,,:/home/olduser:/bin/bash
```

    - 修改为：

```plain
newuser:x:1000:1000:Old User,,,:/home/olduser:/bin/bash
```

4. **编辑 /etc/shadow**
    - 打开 `/mnt/etc/shadow`。
    - 找到：

```plain
olduser:$6$...:...:0:99999:7:::
```

    - 修改为：

```plain
newuser:$6$...:...:0:99999:7:::
```

5. **编辑 /etc/group**
    - 打开 `/mnt/etc/group`。
    - 将所有包含 `olduser` 的组成员更新为 `newuser`。
6. **更新用户主目录**
    - 重命名目录：

```bash
mv /mnt/home/olduser /mnt/home/newuser
```

    - 在 `/mnt/etc/passwd` 中更新主目录路径为 `/home/newuser`。
7. **检查其他配置文件**
    - 检查 `/mnt/etc/sudoers` 或 `/mnt/etc/sudoers.d/`，替换 `olduser` 为 `newuser`。
    - 检查自定义脚本或服务，更新用户名引用。
8. **同步并卸载**

```bash
sync
umount /mnt
```

9. **重启系统**
    - 验证新用户名：

```bash
whoami
```

## 2. 修改设备名（主机名）
主机名存储在 `/etc/hostname` 和 `/etc/hosts` 文件中。以下是将主机名从 `oldhostname` 改为 `newhostname` 的步骤。

### 步骤
1. **挂载 rootfs（若未启动系统）**

```bash
mount /dev/sdX /mnt
```

2. **编辑 /etc/hostname**
    - 打开 `/mnt/etc/hostname`。
    - 替换：

```plain
oldhostname
```

 为：

```plain
newhostname
```

3. **编辑 /etc/hosts**
    - 打开 `/mnt/etc/hosts`。
    - 找到：

```plain
127.0.0.1   localhost
127.0.1.1   oldhostname
```

    - 修改为：

```plain
127.0.0.1   localhost
127.0.1.1   newhostname
```

4. **同步并卸载**

```bash
sync
umount /mnt
```

5. **重启系统**
    - 验证新主机名：

```bash
hostname
```

## 注意事项
+ **备份**：修改前备份 `/etc/passwd`、`/etc/shadow`、`/etc/hostname`、`/etc/hosts`。
+ **权限**：使用 root 权限或 `sudo`。
+ **只读文件系统**：若 `rootfs` 只读，重新挂载为读写：

```bash
mount -o remount,rw /mnt
```

+ **复杂环境**：检查 NetworkManager 或其他服务配置。
+ **嵌入式系统**：
    - 解压或挂载镜像：

```bash
# tar.gz
tar -xzf rootfs.tar.gz -C /mnt
# ext4
mount -o loop rootfs.ext4 /mnt
```

    - 修改后重新打包：

```bash
# tar.gz
tar -czf new_rootfs.tar.gz -C /mnt .
# ext4
umount /mnt
```

## 验证
+ 启动系统后，检查：

```bash
whoami  # 确认用户名
hostname  # 确认主机名
```



root@RK356x-Hy:~# [ 1214.316150] PM: suspend entry (deep)

[ 1214.337544] Filesystems sync: 0.021 seconds

[ 1214.338414] Freezing user space processes ... (elapsed 0.003 seconds) done.

[ 1214.341805] OOM killer disabled.

[ 1214.341809] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.

[ 1214.343474] printk: Suspending console(s) (use no_console_suspend to debug)

[ 1214.489739] rk_gmac-dwmac fe010000.ethernet eth1: Link is Down

[ 1214.508222] Disabling non-boot CPUs ...

[ 1214.520282] psci: CPU1 killed (polled 1 ms)

[ 1214.525234] psci: CPU2 killed (polled 1 ms)

abcdeghijsramwfi▒DDR 2d653b3476 typ 24/01/20-15:04:19,fwver: v1.21



