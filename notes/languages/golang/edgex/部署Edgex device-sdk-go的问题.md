版本 v2.0.0

# 构建
```shell
go build github.com/edgexfoundry/go-mod-bootstrap/v2/bootstrap/flags: module requires Go 1.16
go build github.com/edgexfoundry/device-sdk-go/v2/example/config: module requires Go 1.16
go build github.com/pebbe/zmq4: module requires Go 1.16
go build github.com/edgexfoundry/go-mod-messaging/v2/internal/pkg: module requires Go 1.16
go build github.com/hashicorp/go-rootcerts: module requires Go 1.12
go build github.com/edgexfoundry/go-mod-core-contracts/v2/errors: module requires Go 1.16
go build github.com/gorilla/websocket: module requires Go 1.12
go build github.com/gorilla/mux: module requires Go 1.12
go build github.com/hashicorp/serf/coordinate: module requires Go 1.12
make: *** [Makefile:22：cmd/device-simple/device-simple] 错误 1
```

重新下载 go version 1.16





```shell
go: downloading github.com/x448/float16 v0.8.4
go: downloading golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd
go: downloading github.com/hashicorp/consul/api v1.8.1
go: downloading github.com/stretchr/objx v0.1.0
go: downloading github.com/pebbe/zmq4 v1.2.7
verifying github.com/hashicorp/consul/api@v1.8.1: checksum mismatch
        downloaded: h1:BOEQaMWoGMhmQ29fC26bi0qb7/rId9JzZP2V0Xmx7m8=
        go.sum:     h1:QXilRDnjFtcfoD2jxtfOuNCHmcf3djrOXrip74DgO8U=

SECURITY ERROR
This download does NOT match an earlier download recorded in go.sum.
The bits may have been replaced on the origin server, or an attacker may
have intercepted the download attempt.

For more information, see 'go help module-auth'.
make: *** [Makefile:21：cmd/device-simple/device-simple] 错误 1
```

删除 go.sum 重来







```shell
go: downloading github.com/golang/protobuf v1.3.2
go: downloading gopkg.in/fsnotify.v1 v1.4.7
go: downloading golang.org/x/sync v0.0.0-20190423024810-112230192c58
go: downloading github.com/fsnotify/fsnotify v1.4.7
CGO_ENABLED=1 GO111MODULE=on go build -ldflags "-X github.com/edgexfoundry/device-simple.Version=0.0.0" -o cmd/device-simple/device-simple ./cmd/device-simple
# pkg-config --cflags  -- libzmq
Package libzmq was not found in the pkg-config search path.
Perhaps you should add the directory containing `libzmq.pc'
to the PKG_CONFIG_PATH environment variable
Package 'libzmq', required by 'virtual:world', not found
pkg-config: exit status 1
make: *** [Makefile:22：cmd/device-simple/device-simple] 错误 2
```

安装

```shell
# 安装
sudo apt update
sudo apt install libzmq3-dev
# 验证安装

pkg-config --modversion libzmq

# 清理并重新构建
go clean
make build
```



# 链接
```shell
clint@raspberrypi:~/edgexfoundry/device-simple/cmd/device-simple $ ./device-simple -cp -d
level=INFO ts=2025-03-20T03:05:29.130807179Z app=device-simple source=config.go:718 msg="Using Configuration provider (consul) from: http://localhost:8500 with base path of edgex/v3/core-common-config-bootstrapper/all-services"
level=INFO ts=2025-03-20T03:05:29.137248663Z app=device-simple source=config.go:442 msg="loading the common configuration for service type device-service"
level=INFO ts=2025-03-20T03:05:29.137433127Z app=device-simple source=config.go:718 msg="Using Configuration provider (consul) from: http://localhost:8500 with base path of edgex/v3/core-common-config-bootstrapper/device-services"
level=INFO ts=2025-03-20T03:05:29.146257162Z app=device-simple source=config.go:173 msg="Common configuration loaded from the Configuration Provider. No overrides applied"
level=INFO ts=2025-03-20T03:05:29.146297625Z app=device-simple source=config.go:718 msg="Using Configuration provider (consul) from: http://localhost:8500 with base path of edgex/v3/device-simple"
level=INFO ts=2025-03-20T03:05:29.151169599Z app=device-simple source=config.go:218 msg="Private configuration loaded from the Configuration Provider. No overrides applied"
level=INFO ts=2025-03-20T03:05:29.1512351Z app=device-simple source=config.go:269 msg="listening for private config changes"
level=INFO ts=2025-03-20T03:05:29.151256544Z app=device-simple source=config.go:271 msg="listening for all services common config changes"
level=INFO ts=2025-03-20T03:05:29.151329193Z app=device-simple source=config.go:278 msg="listening for device service common config changes"
level=INFO ts=2025-03-20T03:05:29.151509916Z app=device-simple source=httpserver.go:149 msg="Web server starting (0.0.0.0:59999)"
level=INFO ts=2025-03-20T03:05:29.151558787Z app=device-simple source=messaging.go:66 msg="Setting options for secure MessageBus with AuthMode='usernamepassword' and SecretName='redisdb"
level=INFO ts=2025-03-20T03:05:29.15174477Z app=device-simple source=messaging.go:104 msg="Connected to redis Message Bus @ redis://localhost:6379 with AuthMode='usernamepassword'"
level=INFO ts=2025-03-20T03:05:29.152520589Z app=device-simple source=command.go:36 msg="Subscribing to command requests on topic: edgex/device/command/request/device-simple/#"
level=INFO ts=2025-03-20T03:05:29.152555404Z app=device-simple source=command.go:40 msg="Responses to command requests will be published on topic: edgex/response/device-simple/<requestId>"
level=INFO ts=2025-03-20T03:05:29.154153451Z app=device-simple source=callback.go:34 msg="Subscribing to System Events on topic: edgex/system-events/core-metadata/+/+/device-simple/#"
level=INFO ts=2025-03-20T03:05:29.155727349Z app=device-simple source=validation.go:31 msg="Subscribing to device validation requests on topic: edgex/device-simple/validate/device"
level=INFO ts=2025-03-20T03:05:29.155776387Z app=device-simple source=validation.go:35 msg="Responses to device validation requests will be published on topic: edgex/response/device-simple/<requestId>"
level=INFO ts=2025-03-20T03:05:29.157071783Z app=device-simple source=manager.go:128 msg="Metrics Manager started with a report interval of 30s"
level=INFO ts=2025-03-20T03:05:29.157128024Z app=device-simple source=clients.go:167 msg="Using REST for 'core-metadata' clients @ http://localhost:59881"
level=INFO ts=2025-03-20T03:05:29.157184729Z app=device-simple source=restrouter.go:56 msg="Registering v2 routes..."
level=INFO ts=2025-03-20T03:05:29.159295982Z app=device-simple source=devices.go:78 msg="LastConnected-Simple-Device01 metric has been registered and will be reported (if enabled)"
level=INFO ts=2025-03-20T03:05:29.159369371Z app=device-simple source=devices.go:78 msg="LastConnected-RandNum-Device01 metric has been registered and will be reported (if enabled)"
level=INFO ts=2025-03-20T03:05:29.161655459Z app=device-simple source=config.go:576 msg="Checking if custom configuration ('SimpleCustom') exists in Configuration Provider"
level=INFO ts=2025-03-20T03:05:29.163719083Z app=device-simple source=config.go:597 msg="Loaded custom configuration from Configuration Provider, no overrides applied"
level=INFO ts=2025-03-20T03:05:29.163774491Z app=device-simple source=simpledriver.go:105 msg="Custom config is: {./res/off.jpg ./res/on.png {10}}"
level=INFO ts=2025-03-20T03:05:29.163796176Z app=device-simple source=config.go:690 msg="Watching for custom configuration changes has started for `SimpleCustom/Writable`"
level=INFO ts=2025-03-20T03:05:29.163812232Z app=device-simple source=simpledriver.go:131 msg="Registered ReadCommandsExecuted metric for collection when enabled"
level=INFO ts=2025-03-20T03:05:29.164502162Z app=device-simple source=service.go:299 msg="device service device-simple exists, updating it"
level=INFO ts=2025-03-20T03:05:29.165965782Z app=device-simple source=profiles.go:89 msg="Loading pre-defined Device Profiles from /home/clint/edgexfoundry/device-simple/cmd/device-simple/res/profiles(3 files found)"
level=INFO ts=2025-03-20T03:05:29.167363179Z app=device-simple source=profiles.go:190 msg="Device Profile Simple-Device exists, using the existing one"
level=INFO ts=2025-03-20T03:05:29.168103999Z app=device-simple source=profiles.go:190 msg="Device Profile RandNum-Device exists, using the existing one"
level=INFO ts=2025-03-20T03:05:29.168285944Z app=device-simple source=devices.go:107 msg="Loading pre-defined Devices from /home/clint/edgexfoundry/device-simple/cmd/device-simple/res/devices(3 files found)"
level=INFO ts=2025-03-20T03:05:29.16845326Z app=device-simple source=devices.go:187 msg="Device RandNum-Device01 exists, using the existing one"
level=INFO ts=2025-03-20T03:05:29.168685465Z app=device-simple source=devices.go:187 msg="Device Simple-Device01 exists, using the existing one"
level=INFO ts=2025-03-20T03:05:29.168737188Z app=device-simple source=provisionwatchers.go:79 msg="Loading pre-defined Provision Watchers from /home/clint/edgexfoundry/device-simple/cmd/device-simple/res/provisionwatchers(2 files found)"
level=INFO ts=2025-03-20T03:05:29.169845769Z app=device-simple source=provisionwatchers.go:165 msg="ProvisionWatcher Simple-Provision-Watcher exists, using the existing one"
level=INFO ts=2025-03-20T03:05:29.169945102Z app=device-simple source=autodiscovery.go:32 msg="AutoDiscovery stopped: disabled by configuration"
level=INFO ts=2025-03-20T03:05:29.169969491Z app=device-simple source=message.go:50 msg="Service dependencies resolved..."
level=INFO ts=2025-03-20T03:05:29.169985084Z app=device-simple source=message.go:51 msg="Starting device-simple 0.0.0 "
level=INFO ts=2025-03-20T03:05:29.169998566Z app=device-simple source=message.go:55 msg="device simple started"
level=INFO ts=2025-03-20T03:05:29.170011807Z app=device-simple source=message.go:58 msg="Service started in: 39.345073ms"
level=INFO ts=2025-03-20T03:05:29.170031473Z app=device-simple source=bootstrap.go:251 msg="SecuritySecretsRequested metric registered and will be reported (if enabled)"
level=INFO ts=2025-03-20T03:05:29.170044659Z app=device-simple source=bootstrap.go:251 msg="SecuritySecretsStored metric registered and will be reported (if enabled)"
```

从你提供的日志来看，`./device-simple -cp -d` 命令成功启动了 `device-simple` 服务，并且没有出现明显的错误。日志显示服务已经正确初始化并运行在 Raspberry Pi 上，使用了 Consul 作为配置提供者（`-cp` 表示 "configuration provider"），并且启用了调试模式（`-d`）。以下是对日志的详细分析以及运行状态的说明：

---

### 日志分析
#### 1. 配置加载
+ **配置来源：Consul**

```plain
level=INFO ts=2025-03-20T03:05:29.130807179Z app=device-simple source=config.go:718 msg="Using Configuration provider (consul) from: http://localhost:8500 with base path of edgex/v3/core-common-config-bootstrapper/all-services"
```

服务从 Consul（`http://localhost:8500`）加载配置，路径包括通用配置（`all-services`）、设备服务通用配置（`device-services`）和私有配置（`edgex/v3/device-simple`）。这表明你运行了带有 Consul 的 EdgeX 环境。

+ **配置加载成功**

```plain
level=INFO ts=2025-03-20T03:05:29.146257162Z app=device-simple source=config.go:173 msg="Common configuration loaded from the Configuration Provider. No overrides applied"
level=INFO ts=2025-03-20T03:05:29.151169599Z app=device-simple source=config.go:218 msg="Private configuration loaded from the Configuration Provider. No overrides applied"
```

通用配置和私有配置都成功加载，没有本地覆盖（说明完全依赖 Consul 的配置）。

+ **配置监听**

```plain
level=INFO ts=2025-03-20T03:05:29.1512351Z app=device-simple source=config.go:269 msg="listening for private config changes"
level=INFO ts=2025-03-20T03:05:29.151256544Z app=device-simple source=config.go:271 msg="listening for all services common config changes"
```

服务启动了对配置变化的实时监听，表明它会动态响应 Consul 中的配置更新。

#### 2. Web 服务启动
+ **监听端口**

```plain
level=INFO ts=2025-03-20T03:05:29.151509916Z app=device-simple source=httpserver.go:149 msg="Web server starting (0.0.0.0:59999)"
```

服务启动了 HTTP 服务器，监听在 `0.0.0.0:59999`，可以通过此端口访问 REST API（例如 `http://localhost:59999/api/v3/ping`）。

#### 3. Message Bus 配置
+ **连接 Redis**

```plain
level=INFO ts=2025-03-20T03:05:29.15174477Z app=device-simple source=messaging.go:104 msg="Connected to redis Message Bus @ redis://localhost:6379 with AuthMode='usernamepassword'"
```

服务成功连接到 Redis（`localhost:6379`）作为消息总线，使用用户名密码认证（密钥名称为 `redisdb`）。这表明 Redis 正在运行，并且配置正确。

+ **订阅主题**

```plain
level=INFO ts=2025-03-20T03:05:29.152520589Z app=device-simple source=command.go:36 msg="Subscribing to command requests on topic: edgex/device/command/request/device-simple/#"
level=INFO ts=2025-03-20T03:05:29.154153451Z app=device-simple source=callback.go:34 msg="Subscribing to System Events on topic: edgex/system-events/core-metadata/+/+/device-simple/#"
level=INFO ts=2025-03-20T03:05:29.155727349Z app=device-simple source=validation.go:31 msg="Subscribing to device validation requests on topic: edgex/device-simple/validate/device"
```

服务订阅了多个消息主题，包括命令请求、系统事件和设备验证请求，表明它已准备好处理外部命令和事件。

#### 4. 设备和服务初始化
+ **设备配置文件加载**

```plain
level=INFO ts=2025-03-20T03:05:29.165965782Z app=device-simple source=profiles.go:89 msg="Loading pre-defined Device Profiles from /home/clint/edgexfoundry/device-simple/cmd/device-simple/res/profiles(3 files found)"
level=INFO ts=2025-03-20T03:05:29.168285944Z app=device-simple source=devices.go:107 msg="Loading pre-defined Devices from /home/clint/edgexfoundry/device-simple/cmd/device-simple/res/devices(3 files found)"
```

服务加载了预定义的设备配置文件和设备定义（分别找到 3 个文件），并发现已有设备（`Simple-Device01` 和 `RandNum-Device01`）和配置文件（`Simple-Device` 和 `RandNum-Device`），因此使用现有配置。

+ **服务注册**

```plain
level=INFO ts=2025-03-20T03:05:29.164502162Z app=device-simple source=service.go:299 msg="device service device-simple exists, updating it"
```

服务在 `core-metadata` 中已存在，因此执行更新操作（而不是新建）。

#### 5. 自定义配置和指标
+ **自定义配置**

```plain
level=INFO ts=2025-03-20T03:05:29.163774491Z app=device-simple source=simpledriver.go:105 msg="Custom config is: {./res/off.jpg ./res/on.png {10}}"
```

加载了自定义配置 `SimpleCustom`，包括图片路径和参数 `{10}`，表明 `device-simple` 的驱动程序已正确解析配置。

+ **指标注册**

```plain
level=INFO ts=2025-03-20T03:05:29.159295982Z app=device-simple source=devices.go:78 msg="LastConnected-Simple-Device01 metric has been registered and will be reported (if enabled)"
level=INFO ts=2025-03-20T03:05:29.163812232Z app=device-simple source=simpledriver.go:131 msg="Registered ReadCommandsExecuted metric for collection when enabled"
```

服务注册了多个指标（如设备最后连接时间和读取命令执行次数），这些指标会在启用时报告。

#### 6. 服务启动完成
+ **启动成功**

```plain
level=INFO ts=2025-03-20T03:05:29.169985084Z app=device-simple source=message.go:51 msg="Starting device-simple 0.0.0 "
level=INFO ts=2025-03-20T03:05:29.170011807Z app=device-simple source=message.go:58 msg="Service started in: 39.345073ms"
```

服务成功启动，耗时约 39.3 毫秒，没有错误。

---

### 运行状态总结
1. **服务正常运行**
    - 日志中没有 `ERROR` 或 `WARN` 级别的消息，表明 `device-simple` 已正确启动并处于活动状态。
    - 服务连接到了 Consul（配置）、Redis（消息总线）和 `core-metadata`（元数据服务，`http://localhost:59881`）。
2. **依赖服务**
    - Consul（`localhost:8500`）：提供配置。
    - Redis（`localhost:6379`）：消息总线。
    - Core Metadata（`localhost:59881`）：设备和服务元数据。
3. **功能就绪**
    - HTTP 服务器监听在 `59999` 端口。
    - 订阅了命令、系统事件和验证请求的主题。
    - 加载了预定义的设备和配置文件。

---

### 如何验证运行是否正确
1. **检查 REST API**

```bash
curl http://localhost:59999/api/v3/ping
```

如果返回时间戳（例如 `"2025-03-20T03:05:29Z"`），说明服务正常运行。

2. **检查设备数据**  
查询 `core-data` 查看设备事件：

```bash
curl http://localhost:59880/api/v3/event/device/name/Simple-Device01
```

（假设 `core-data` 在 `59880` 端口运行）。

3. **发送命令**  
使用 REST 或消息总线发送命令到 `Simple-Device01`，观察日志是否有响应。

---



# 非安全模式环境变量
EDGEX_SECURITY_SECRET_STORE

This environment variable indicates whether the service is expected to initialize the secure SecretStore which allows the service to access secrets from Vault. Defaults to true if not set or not set to false. When set to true the EdgeX security services must be running. If running EdgeX in non-secure mode you then want this explicitly set to false.



Example - Using docker-compose to disable secure SecretStore



environment: 

  EDGEX_SECURITY_SECRET_STORE: "false"



