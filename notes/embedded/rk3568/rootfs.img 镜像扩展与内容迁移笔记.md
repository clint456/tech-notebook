### ✅ 目标：
将 `rootfs.img` 的内容迁移到一个更大的 `rootfs-expanded.img` 中，实现文件系统扩容。

---

### 📁 准备目录与挂载镜像
```bash
# 创建挂载目录
mkdir -p ~/mount_dir
mkdir -p ~/mount_expanded

# 挂载原始 rootfs.img
sudo mount rootfs.img ~/mount_dir

# 挂载扩展后的 rootfs-expanded.img
sudo mount rootfs-expanded.img ~/mount_expanded

# 检查挂载是否成功
mount | grep mount_
```

---

### ⚠️ 注意：不要使用 `mv`，使用 `rsync` 或 `cp -a`
#### 推荐做法（保持权限、链接、特殊文件等）：
```bash
# 推荐方式1：rsync 方式迁移
sudo rsync -aHAX ~/mount_dir/ ~/mount_expanded/

# 或推荐方式2：cp -a 方式迁移
sudo cp -a ~/mount_dir/. ~/mount_expanded/
```

注意 `cp` 后面是 `.` 表示包括隐藏文件。

---

### 🧹 清理挂载
```bash
# 卸载两个挂载点
sudo umount ~/mount_dir
sudo umount ~/mount_expanded
```

---

### ✅ 问题排查提示
+ 若 `mount_expanded` 里出现数字命名文件夹（如 `1/`, `2/`），很可能是：
    - 没有正确挂载 `rootfs-expanded.img`，操作的是空目录。
    - 或者复制过程出错，目录结构被误解。

建议使用 `mount` 命令确认挂载情况，并避免使用 `mv`。

---

### 📌 小贴士
+ `mv` 不适用于跨挂载点的数据迁移，尤其是挂载在 loop device 的镜像文件。
+ 使用 `rsync` 可保留 ACL、权限、设备文件、软链接等，是最安全的做法。
+ 可以用 `df -h` 和 `lsblk` 辅助查看挂载的设备容量和路径。

---

需要我补充自动化脚本、或支持 squashfs、ext4 格式检测的话，也可以继续拓展 👍

