在 Docker 上部署 EdgeX Foundry 是一个常见且高效的方式，特别适合快速搭建 IoT 边缘计算平台。以下是一个简洁的教程，介绍如何使用 Docker 配合 EdgeX 进行部署，基于最新版本（截至 2025 年 3 月 17 日，推荐使用 EdgeX 3.1 版本）。

---

### 1. **准备工作**
确保你的环境满足以下要求：

+ **操作系统**: Linux（如 Ubuntu）、Windows 或 macOS。
+ **Docker**: 已安装并运行（建议最新稳定版，验证：`docker --version`）。
+ **Docker Compose**: 已安装（验证：`docker compose version`）。
+ **网络**: 确保可以访问 Docker Hub 或 GitHub。
+ **硬件**: 至少 4GB 内存和 2 核 CPU，具体取决于部署规模。

---

### 2. **获取 EdgeX Docker Compose 文件**
EdgeX 提供预配置的 Docker Compose 文件，用于快速部署所有微服务。你可以从官方 GitHub 仓库下载适合的版本。

#### 下载命令（以 EdgeX 3.1 无安全配置为例）：
+ **x86 架构**:

```bash
curl https://raw.githubusercontent.com/edgexfoundry/edgex-compose/v3.1/docker-compose-no-secty.yml -o docker-compose.yml
```

+ **ARM64 架构**:

```bash
curl https://raw.githubusercontent.com/edgexfoundry/edgex-compose/v3.1/docker-compose-no-secty-arm64.yml -o docker-compose.yml
```

说明：

+ `no-secty` 表示无安全配置，便于初次使用。如果需要安全性（如 TLS），选择带 `secty` 的文件。
+ 文件下载后保存为 `docker-compose.yml`，位于当前工作目录。

---

### 3. **启动 EdgeX 服务**
在包含 `docker-compose.yml` 的目录下运行以下命令，拉取镜像并启动所有服务：

```bash
docker compose up -d
```

+ `-d`: 后台运行容器。
+ 这将部署 EdgeX 的核心服务（如核心数据、命令服务、元数据服务等）和默认支持服务。

#### 检查运行状态：
```bash
docker compose ps
```

输出应显示所有容器状态为 `Up`，如 `edgex-core-data`、`edgex-core-metadata` 等。如果某些容器退出（`Exited`），可能是初始化容器（如 `config-seed`），这是正常行为。

---

### 4. **验证部署**
#### 检查日志：
查看某个服务的日志，确保正常运行：

```bash
docker compose logs -f edgex-core-data
```

按 `Ctrl+C` 退出日志查看。

#### 测试服务可用性：
EdgeX 微服务提供 REST API，可通过 `curl` 或浏览器验证：

+ 检查核心数据服务：

```bash
curl http://localhost:59880/api/v3/ping
```

应返回类似 `"EdgeX Core Data is alive"` 的响应。

---

### 5. **添加设备服务（可选）**
默认的 `docker-compose-no-secty.yml` 文件不包含设备服务。若需模拟设备数据，可启用虚拟设备服务：

#### 修改 docker-compose.yml：
打开文件，找到 `device-virtual` 服务部分（可能已注释），取消注释或添加如下内容：

```yaml
device-virtual:
  image: edgexfoundry/device-virtual:3.1.0
  ports:
    - "127.0.0.1:59900:59900"
  container_name: edgex-device-virtual
  hostname: edgex-device-virtual
  networks:
    - edgex-network
  depends_on:
    - data
    - command
```

保存后重新启动：

```bash
docker compose up -d
```

#### 验证设备数据：
查询虚拟设备生成的事件：

```bash
curl http://localhost:59880/api/v3/event/device/Random-Integer-Device/10
```

返回最近 10 条随机整数数据。

---

### 6. **自定义部署（可选）**
#### 使用 Compose Builder 工具：
若需特定服务组合（如添加 MQTT 设备服务），可使用 EdgeX 的 Compose Builder：

1. 克隆仓库：

```bash
git clone https://github.com/edgexfoundry/edgex-compose.git
cd edgex-compose
git checkout v3.1
```

2. 进入 `compose-builder` 目录：

```bash
cd compose-builder
```

3. 生成自定义文件：

```bash
make gen no-secty ds-mqtt mqtt-broker
```

生成的 `docker-compose.yaml` 包含 MQTT 设备服务和代理。

4. 部署：

```bash
docker compose -f docker-compose.yaml up -d
```

---

### 7. **数据导出（可选）**
将 EdgeX 数据导出到外部系统（如 MQTT 经纪人）：

#### 添加应用服务：
在 `docker-compose.yml` 中添加以下内容：

```yaml
app-service-mqtt:
  image: edgexfoundry/app-service-configurable:3.1.0
  ports:
    - "127.0.0.1:59701:59701"
  container_name: edgex-app-mqtt
  environment:
    - EDGEDB_CLI_PROFILE=mqtt-export
    - TRIGGER_PUBLISH_TOPIC=EdgeXEvents
    - MQTT_BROKER_ADDRESS=broker.hivemq.com
    - MQTT_BROKER_PORT=1883
  depends_on:
    - data
```

保存并运行 `docker compose up -d`。

#### 验证导出：
使用 MQTT 客户端（如 `mosquitto_sub`）订阅：

```bash
mosquitto_sub -h broker.hivemq.com -p 1883 -t EdgeXEvents
```

可以看到虚拟设备生成的随机数据。

---

### 8. **停止和清理**
+ 停止服务：

```bash
docker compose down
```

+ 删除卷数据（谨慎操作）：

```bash
docker compose down -v
```

---

### 注意事项
+ **端口冲突**: 若本地端口被占用（如 59880），编辑 `docker-compose.yml` 调整映射端口。
+ **性能优化**: 大规模部署时，考虑调整容器资源限制（CPU、内存）。
+ **安全性**: 生产环境建议使用带安全配置的文件，并配置 TLS 和认证。

---

通过以上步骤，你可以使用 Docker 快速部署 EdgeX，并根据需求添加设备服务或导出数据。如需更深入的定制，请参考 [EdgeX 官方文档](https://docs.edgexfoundry.org)。有具体问题可以告诉我，我会进一步协助！

