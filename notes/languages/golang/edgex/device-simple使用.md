根据 `./device-simple -h` 的输出，你可以使用 `device-simple` 命令行工具来运行 EdgeX Foundry 的设备服务。以下是一些常见的使用方式：

### 1. **运行设备服务（默认配置）**
```bash
./device-simple
```

如果你的 `configuration.yaml` 文件在默认位置（`./res/configuration.yaml`），那么直接运行即可。

---

### 2. **使用指定的本地配置文件**
```bash
./device-simple -cf myconfig.yaml
```

或

```bash
./device-simple --configFile myconfig.yaml
```

这将使用 `myconfig.yaml` 作为配置文件。

---

### 3. **指定配置目录**
```bash
./device-simple -cd /path/to/config
```

或

```bash
./device-simple --configDir /path/to/config
```

这将从 `/path/to/config` 目录加载配置。

---

### 4. **启用注册中心（Registry）**
如果你希望 `device-simple` 使用 EdgeX 注册中心（如 Consul），可以启用 `-r` 选项：

```bash
./device-simple -r
```

或

```bash
./device-simple --registry
```

---

### 5. **使用远程服务（与 EdgeX 核心服务分开运行）**
如果设备服务需要连接到远程的 EdgeX 核心服务：

```bash
./device-simple -rsh=192.168.1.100,192.168.1.101,localhost
```

+ `192.168.1.100`：本地系统的主机名
+ `192.168.1.101`：远程 EdgeX 服务的主机名
+ `localhost`：Web 服务器绑定的主机名

---

### 6. **以开发者模式运行**
```bash
./device-simple -d
```

或

```bash
./device-simple --dev
```

这样会将 `Host` 配置的值覆盖为 `localhost`，适用于 Docker 容器混合模式（hybrid mode）。

---

### 7. **指定实例名称（多实例运行）**
如果你需要在同一台机器上运行多个 `device-simple` 实例：

```bash
./device-simple -i instance1
```

或

```bash
./device-simple --instance instance1
```

这样，服务名称将变为 `device-simple_instance1`。

---

### 8. **使用配置提供者**
如果你想让 `device-simple` 从配置提供者（如 Consul）加载配置：

```bash
./device-simple -cp=consul.http://localhost:8500
```

或

```bash
./device-simple --configProvider=consul.http://localhost:8500
```

这将从 `http://localhost:8500` 的 Consul 服务器获取配置。

---

### 9. **覆盖远程配置**
如果你希望覆盖配置提供者中的设置：

```bash
./device-simple -o
```

或

```bash
./device-simple --overwrite
```

⚠️ **注意：** 这会覆盖远程配置，可能影响其他手动修改的配置。

---

### 10. **获取帮助**
```bash
./device-simple -h
```

或

```bash
./device-simple --help
```

这会显示帮助信息（即你当前看到的内容）。

---

你可以根据具体的需求，组合这些参数来运行 `device-simple` 设备服务。🚀

