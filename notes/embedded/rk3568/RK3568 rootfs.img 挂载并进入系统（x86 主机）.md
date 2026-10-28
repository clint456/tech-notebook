适用于：在 **x86_64 主机（如 Ubuntu PC）** 上挂载并进入 **RK3568 的 ARM64 rootfs.img**，用于调试或检查。

---

## 🧰 前提准备
+ 已获取 RK3568 的 `rootfs.img`
+ 主机系统为 Ubuntu/Debian
+ 已安装 `sudo` 权限用户

---

## ✅ 安装 QEMU 支持 ARM 架构
```bash
sudo apt update
sudo apt install qemu-user-static
```

---

## 🗂️ 挂载 rootfs.img 到本地目录
```bash
mkdir /mnt/rkfs
sudo mount rootfs.img /mnt/rkfs
```

---

## 🛠️ 拷贝 QEMU 模拟器到 rootfs 中
RK3568 为 ARM64 架构，需使用 `qemu-aarch64-static`：

```bash
sudo cp /usr/bin/qemu-aarch64-static /mnt/rkfs/usr/bin/
```

> 如果 rootfs 是 32 位 ARM，可改为：
>

```bash
sudo cp /usr/bin/qemu-arm-static /mnt/rkfs/usr/bin/
```

---

## 🚪 使用 chroot 进入 ARM64 rootfs
```bash
sudo chroot /mnt/rkfs /bin/bash
```

如果 `/bin/bash` 不存在，可尝试：

```bash
sudo chroot /mnt/rkfs /bin/sh
```

---

## 🧪 可选：确认架构是否匹配
```bash
file /mnt/rkfs/bin/bash
```

输出应包含：

```plain
ELF 64-bit LSB executable, ARM aarch64
```

---

## 🚀 替代方法：使用 systemd-nspawn（推荐）
```bash
sudo systemd-nspawn -D /mnt/rkfs
```

> 更稳定、自动处理挂载、环境隔离更好。
>

---

## 🧹 退出和卸载 rootfs
```bash
exit
sudo umount /mnt/rkfs
```

---

## 📝 常见问题汇总
| 问题 | 解决方法 |
| --- | --- |
| `No such file or directory: /bin/bash` | 可能架构不兼容或 shell 没装，检查是否为 ARM64，改用 `/bin/sh` 或装 bash |
| `Illegal instruction` | 没有使用 QEMU 模拟器，记得拷贝 `qemu-aarch64-static` |
| `Exec format error` | 架构不兼容，需使用 QEMU |


---

已经能 chroot 进去了，接下来挂载 `proc`、`sys`、`dev` 这些伪文件系统，可以让 rootfs 更像一个真实运行的系统，有些命令（比如 `ps`、`top`、`mount`）才能正常工作。

---

## ✅ 挂载 proc / sys / dev 文件系统（chroot 前）
在 `chroot`**之前**，运行以下命令：

```bash
sudo mount -t proc /proc /mnt/rkfs/proc
sudo mount -t sysfs /sys /mnt/rkfs/sys
sudo mount --bind /dev /mnt/rkfs/dev
sudo mount --bind /dev/pts /mnt/rkfs/dev/pts
```

如果你还想网络相关功能正常，可以加上：

```bash
sudo mount --bind /run /mnt/rkfs/run
```

---

## 🔁 然后进入 chroot：
```bash
sudo chroot /mnt/rkfs /bin/bash
```

或者：

```bash
sudo chroot /mnt/rkfs /bin/sh
```

---

## 🧹 退出后卸载：
退出 `chroot` 后依次卸载挂载的系统：

```bash
sudo umount /mnt/rkfs/dev/pts
sudo umount /mnt/rkfs/dev
sudo umount /mnt/rkfs/proc
sudo umount /mnt/rkfs/sys
sudo umount /mnt/rkfs/run   # 如果之前挂了的话
```

---



