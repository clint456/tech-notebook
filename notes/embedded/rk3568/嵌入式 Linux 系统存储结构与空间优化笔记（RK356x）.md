---

> 适用于 Tronlong @ RK356x 等裁剪型 Linux 系统环境，目标是解决根目录空间不足、自动挂载外部分区、自动软链接用户目录、打包一键部署。
>

---

## 🧱 一、系统环境概览
### 📌 系统特点
+ 嵌入式 Linux 系统，根文件系统 `/` 剪裁至极小（<6GB）
+ 开发依赖工具未预装，如 `cmake`
+ 使用 microSD/eMMC 存储，存在多个挂载分区

---

### 🧾 当前分区状态（`df -h`）
| 挂载点 | 大小 | 已用 | 可用 | 用途 |
| --- | --- | --- | --- | --- |
| `/dev/root` | 5.9G | 5.6G | 0 | 根文件系统（已满） |
| `/dev/mmcblk0p6` | 3.4G | 3.2G | 79M | 用户系统扩展区 |
| `/dev/mmcblk1p9` | 24G | 288K | 24G | 大容量可用空间 |
| 其余分区 | 数十 MB | - | - | 启动/引导/保留分区 |


---

## ❗ 二、问题起因
在使用 `apt install cmake` 时出现错误：

```plain
E: You don't have enough free space in /var/cache/apt/archives/
```

**原因**：根分区 `/` 可用空间为 0，APT 无法下载安装包。

---

## ✅ 三、解决思路
### ✔️ 临时解决方法
```bash
sudo apt clean
sudo apt autoremove
sudo journalctl --vacuum-time=3d
sudo rm -rf /tmp/*
```

也可临时指定 APT 缓存路径至大空间分区：

```bash
sudo apt -o dir::cache::archives="/run/media/mmcblk1p9/apt-cache" install cmake
```

---

## 🛠️ 四、持久解决方案设计
### 🎯 目标：
1. 将用户目录和 apt 缓存迁移至大空间分区
2. 使用软链接保留原有路径结构
3. 设置开机自动迁移
4. 打包为 `.deb` 一键部署

---

### 📁 拟迁移目录
+ `~/Downloads`
+ `~/Documents`
+ `~/Projects`
+ `~/.cache`
+ `/var/cache/apt/archives`

---

### 📜 脚本内容（link_to_large_storage.sh）
```bash
#!/bin/bash

TARGET_MOUNT="/run/media/mmcblk1p9"
TARGET_WORKSPACE="$TARGET_MOUNT/workspace"

if [ ! -d "$TARGET_MOUNT" ]; then
    echo "❌ 挂载点 $TARGET_MOUNT 不存在"
    exit 1
fi

mkdir -p "$TARGET_WORKSPACE"
USER_DIRS=(Downloads Documents Projects .cache)

for dir in "${USER_DIRS[@]}"; do
    SRC="$HOME/$dir"
    DEST="$TARGET_WORKSPACE/$dir"

    if [ -L "$SRC" ]; then
        echo "🔗 $SRC 已经是软链接，跳过"
        continue
    fi

    if [ -d "$SRC" ]; then
        mv "$SRC" "$DEST"
        ln -s "$DEST" "$SRC"
    else
        mkdir -p "$DEST"
        ln -s "$DEST" "$SRC"
    fi
done

# APT 缓存迁移
APT_CACHE="/var/cache/apt/archives"
APT_DEST="$TARGET_WORKSPACE/apt-archives"

if [ ! -L "$APT_CACHE" ]; then
    sudo mkdir -p "$APT_DEST"
    sudo mv "$APT_CACHE" "$APT_DEST"
    sudo ln -s "$APT_DEST" "$APT_CACHE"
fi

echo "🎉 所有目录迁移完成！"
```

---

## ⚙️ 五、自动挂载大容量分区（/etc/fstab 配置）
### ✨ 获取 UUID
```bash
sudo blkid
```

输出示例：

```plain
/dev/mmcblk1p9: LABEL="userdata" UUID="24609623-c21b-46a0-a4a8-a655fefed9ed" TYPE="ext4" PARTLABEL="userdata" PARTUUID="2d5e0000-0000-4d6f-8000-106a00004e61"
```

### ✨ 编辑 `/etc/fstab`
```bash
sudo vim /etc/fstab
```

添加：

```plain
UUID=24609623-c21b-46a0-a4a8-a655fefed9ed /run/media/mmcblk1p9 ext4 defaults,noatime 0 2
```

然后挂载测试：

```bash
sudo mkdir -p /run/media/mmcblk1p9
sudo mount -a
```

---

## 🚀 六、创建开机自动执行脚本服务（systemd）
### 📄 文件路径：`/etc/systemd/system/link-workspace.service`
```properties
[Unit]
Description=Auto-link user directories to large workspace
After=local-fs.target
Requires=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/link_to_large_storage.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

### 启动并设为开机自启：
```bash
sudo systemctl daemon-reload # 刷新systemctl配置
sudo systemctl enable link-workspace.service
sudo systemctl start link-workspace.service
sudo systemctl status link-workspace.service //查看日志輸出
```

---

## 📦 七、打包为 `.deb` 安装包
### 📁 目录结构示例
```plain
link-workspace_1.0/
├── DEBIAN/
│   └── control
├── etc/
│   └── systemd/system/link-workspace.service
└── usr/
    └── local/bin/link_to_large_storage.sh
```

### 🧾 `control` 文件内容：
```plain
Package: link-workspace
Version: 1.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Tronlong Dev <you@example.com>
Description: Automatically link user directories and apt cache to external workspace.
```

### 打包命令：
```bash
dpkg-deb --build link-workspace_1.0
```

### 安装包使用：
```bash
sudo dpkg -i link-workspace_1.0.deb
sudo systemctl enable link-workspace.service
sudo systemctl start link-workspace.service
```

---

## 🧼 八、卸载清理方式
```bash
sudo systemctl disable link-workspace.service
sudo dpkg -r link-workspace
```

---

## 🎯 九、增强功能：挂载失败报警与日志记录
### 📌 功能概述
1. **挂载失败报警**：如果挂载大容量分区失败，通过 `logger` 写入系统日志，并通过邮件发送通知。
2. **日志记录**：每个关键步骤都会写入 `/var/log/link_workspace.log`，方便后续查看脚本执行的详细信息。

### 📜 更新后的脚本（带日志记录与挂载失败报警）
```bash
#!/bin/bash

LOG_FILE="/var/log/link_workspace.log"
TARGET_MOUNT="/run/media/mmcblk1p9"
TARGET_WORKSPACE="$TARGET_MOUNT/workspace"
EMAIL="your-email@example.com"

echo "$(date '+%Y-%m-%d %H:%M:%S') 开始执行脚本..." >> $LOG_FILE

# 检查挂载是否成功
if ! mount -a; then
    logger "🔴 大容量分区挂载失败：/dev/mmcblk1p9"
    echo "$(date '+%Y-%m-%d %H:%M:%S') 挂载失败：大容量分区未挂载" >> $LOG_FILE
    echo "⚠️ 大容量分区挂载失败，已记录日志" >&2
    echo "大容量分区挂载失败，分区可能未挂载。" | mail -s "挂载失败警告" $EMAIL
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') 大容量分区挂载成功" >> $LOG_FILE

# 检查目标挂载点是否存在
if [ ! -d "$TARGET_MOUNT" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') 错误：挂载点 $TARGET_MOUNT 不存在" >> $LOG_FILE
    exit 1
fi

# 创建工作目录
mkdir -p "$TARGET_WORKSPACE"

USER_DIRS=(Downloads Documents Projects .cache)

for dir in "${USER_DIRS[@]}"; do
    SRC="$HOME/$dir"
    DEST="$TARGET_WORKSPACE/$dir"

    if [ -L "$SRC" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $SRC 已经是软链接，跳过" >> $LOG_FILE
        continue
    fi

    if [ -d "$SRC" ]; then
        mv "$SRC" "$DEST"
        ln -s "$DEST" "$SRC"
        echo "$(date '+%Y-%m-%d %H:%M:%S') 迁移并创建软链接：$SRC -> $DEST" >> $LOG_FILE
    else
        mkdir -p "$DEST"
        ln -s "$DEST" "$SRC"
        echo "$(date '+%Y-%m-%d %H:%M:%S') 仅创建软链接：$SRC -> $DEST" >> $LOG_FILE
    fi
done

# APT 缓存迁移
APT_CACHE="/var/cache/apt/archives"
APT_DEST="$TARGET_WORKSPACE/apt-archives"

if [ ! -L "$APT_CACHE" ]; then
    sudo mkdir -p "$APT_DEST"
    sudo mv "$APT_CACHE" "$APT_DEST"
    sudo ln -s "$APT_DEST" "$APT_CACHE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') 迁移并创建软链接：$APT_CACHE -> $APT_DEST" >> $LOG_FILE
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') 所有目录迁移完成！" >> $LOG_FILE
```

---

## 🎉 总结
+ **挂载失败报警**：通过 `logger` 写入系统日志，并通过邮件发送通知，增强了系统的可靠性。
+ **日志记录**：每个重要步骤都会写入 `/var/log/link_workspace.log`，便于追踪和调试。
+ **完善系统**：通过增强日志和报警机制，系统运行更加可靠，方便后续排查问题。

---

