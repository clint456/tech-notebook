# 南向和北向概念
在 EdgeX Foundry 中，南向（Southbound）和 北向（Northbound）分别指代不同的数据流和通信方向。具体来说：

### 1. **南向 (Southbound)**
+ **定义**：南向通常指的是与设备层和硬件交互的接口。这些接口用于获取设备数据，并将这些数据传递到 EdgeX 的核心组件（如 `core-data`、`core-metadata`）。
+ **作用**：设备服务（Device Services）充当南向接口的桥梁，负责与物理设备或传感器进行通信。设备服务收集设备数据，并将其传输到 EdgeX 的核心服务中进行进一步处理或存储。
+ **协议**：南向接口通常会使用多种协议来与不同类型的设备通信，例如：

每个设备服务都可以通过这些协议与特定的硬件设备进行交互。

    - **MQTT**
    - **CoAP**
    - **Modbus**
    - **REST**
    - **SNMP**
    - **BACnet**
    - **Bluetooth** 等等。

### 2. **北向 (Northbound)**
+ **定义**：北向通常指的是与应用层或外部系统交互的接口。通过北向接口，EdgeX 的数据可以传递给上层应用、分析系统、云平台或其他外部服务。
+ **作用**：北向接口主要用于暴露 EdgeX 系统中处理过的数据，支持与应用程序进行集成、数据可视化、监控、分析等功能。EdgeX 提供了一些常见的北向服务，如 API 网关、消息总线、HTTP 和 MQTT 等协议的支持。
+ **协议**：北向接口的协议通常是基于应用层的协议，例如：

EdgeX 通过这些协议将设备数据、处理结果或状态信息传递给上层应用程序或外部系统。

    - **REST API**：可以暴露核心服务的 HTTP 接口，供外部应用或用户访问。
    - **MQTT**：适用于与云平台或其他系统进行数据交换。
    - **WebSocket**、**gRPC** 等：这些也可以作为北向接口的一部分用于与外部系统进行实时通信。

### 总结
+ **南向**：指的是设备层面与硬件设备之间的通信，数据从设备流入 EdgeX 系统。
+ **北向**：指的是 EdgeX 系统与上层应用或外部系统之间的通信，数据从 EdgeX 系统流向外部应用或云平台。

这些南向和北向接口使得 EdgeX 可以灵活地连接各种设备和应用场景，提供高度可扩展的 IoT 解决方案。

# Device 层
[Device Service SDK - Go SDK API - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/3.1/microservices/device/sdk/api/GoDeviceSDK/GoDeviceSDKAPI/#driverconfigs) 

## DeviceServiceSDK
API 是如何实现的

```go
type DeviceServiceSDK interface {
    AddDevice(device models.Device) (string, error)
    Devices() []models.Device
    GetDeviceByName(name string) (models.Device, error)
    UpdateDevice(device models.Device) error
    RemoveDeviceByName(name string) error
    AddDeviceProfile(profile models.DeviceProfile) (string, error)
    DeviceProfiles() []models.DeviceProfile
    GetProfileByName(name string) (models.DeviceProfile, error)
    UpdateDeviceProfile(profile models.DeviceProfile) error
    RemoveDeviceProfileByName(name string) error
    AddProvisionWatcher(watcher models.ProvisionWatcher) (string, error)
    ProvisionWatchers() []models.ProvisionWatcher
    GetProvisionWatcherByName(name string) (models.ProvisionWatcher, error)
    UpdateProvisionWatcher(watcher models.ProvisionWatcher) error
    RemoveProvisionWatcher(name string) error
    DeviceResource(deviceName string, deviceResource string) (models.DeviceResource, bool)
    DeviceCommand(deviceName string, commandName string) (models.DeviceCommand, bool)
    AddDeviceAutoEvent(deviceName string, event models.AutoEvent) error
    RemoveDeviceAutoEvent(deviceName string, event models.AutoEvent) error
    UpdateDeviceOperatingState(name string, state models.OperatingState) error
    DeviceExistsForName(name string) bool
    PatchDevice(updateDevice dtos.UpdateDevice) error
    Run() error
    Name() string
    Version() string
    AsyncReadingsEnabled() bool
    AsyncValuesChannel() chan *sdkModels.AsyncValues
    DiscoveredDeviceChannel() chan []sdkModels.DiscoveredDevice
    DeviceDiscoveryEnabled() bool
    DriverConfigs() map[string]string
    AddRoute(route string, handler func(http.ResponseWriter, *http.Request), methods ...string) error
    AddCustomRoute(route string, authenticated Authenticated, handler func(echo.Context) error, methods ...string) error
    LoadCustomConfig(customConfig UpdatableConfig, sectionName string) error
    ListenForCustomConfigChanges(configToWatch interface{}, sectionName string, changedCallback func(interface{})) error
    LoggingClient() logger.LoggingClient
    SecretProvider() interfaces.SecretProvider
    MetricsManager() interfaces.MetricsManager
}
```



下面我将专注于解释 `DeviceServiceSDK` 接口的工作流程，梳理其在 EdgeX Foundry 设备服务中的生命周期和功能调用顺序，帮助您理解其整体运行机制。

---

### `DeviceServiceSDK` 接口工作流程
`DeviceServiceSDK` 是 EdgeX Go Device SDK 的核心接口，定义了设备服务的基本功能。它的工作流程可以分为三个主要阶段：**初始化阶段**、**运行阶段** 和 **操作阶段**。以下是详细的流程描述：

#### 1. 初始化阶段
这是设备服务启动并准备运行的阶段，主要由 `Run()` 方法驱动。

+ **入口**：  
开发者在 `main.go` 中创建 `DeviceServiceSDK` 实例并调用 `Run()`：

```go
func main() {
    sdk := &sdk.Service{} // 创建 SDK 实例
    driver := &SimpleDriver{} // 自定义驱动
    err := sdk.Run(driver) // 启动服务
    if err != nil {
        log.Fatal(err)
    }
}
```

+ **流程**：
    1. **配置加载**  
        * 调用内部方法加载配置，可能来自本地文件（`configuration.yaml`）或配置提供者（如 `keeper`）。
        * 配置包括服务地址（`Service.Host`、`Service.Port`）、客户端地址（`Clients`）、驱动配置（`Driver`）等。
        * 示例日志：

```plain
level=INFO ... msg="Loading configuration file from res/configuration.yaml"
```

    2. **驱动初始化**  
        * 调用驱动的 `Initialize` 方法，传入日志客户端、异步通道等。
        * 驱动可以通过 `DriverConfigs()` 获取自定义配置。
        * 示例：

```go
func (d *SimpleDriver) Initialize(lc logger.LoggingClient, asyncCh chan<- *sdkModels.AsyncValues, deviceCh chan<- []sdkModels.DiscoveredDevice) error {
    lc.Info("Driver initialized")
    configs := d.sdk.DriverConfigs()
    return nil
}
```

    3. **服务注册**  
        * 将设备服务注册到核心元数据服务（`core-metadata`），包括服务名称（`Name()`）和版本（`Version()`）。
        * 示例日志：

```plain
level=INFO ... msg="Service started: device-simple"
```

    4. **通道初始化**  
        * 如果启用异步读数（`AsyncReadingsEnabled()` 返回 `true`），初始化 `AsyncValuesChannel()`。
        * 如果启用设备发现（`DeviceDiscoveryEnabled()` 返回 `true`），初始化 `DiscoveredDeviceChannel()`。

---

#### 2. 运行阶段
服务启动后进入运行状态，监听请求并处理设备操作。

+ **流程**：
    1. **Web 服务器启动**  
        * 启动 HTTP 服务器，监听配置中的地址（例如 `192.168.32.56:59983`）。
        * 日志：

```plain
level=INFO ... msg="Web server starting (192.168.32.56:59983)"
```

        * 支持通过 `AddRoute` 或 `AddCustomRoute` 添加自定义路由。
    2. **消息总线连接**  
        * 连接消息总线（如 Redis、MQTT），用于发布设备事件和接收命令。
        * 如果失败，可能导致启动错误（如前述日志中的 `Unable to connect MessageBus`）。
    3. **配置监听**  
        * 调用 `ListenForCustomConfigChanges` 监听配置变化，动态更新服务行为。
        * 示例：

```go
sdk.ListenForCustomConfigChanges(&customConfig, "Driver", func(updated interface{}) {
    log.Printf("Driver config updated: %v", updated)
})
```

    4. **设备管理初始化**  
        * 从 `DevicesDir` 和 `ProfilesDir` 加载设备和配置文件。
        * 调用 `AddDevice`、`AddDeviceProfile` 等方法注册初始设备。

---

#### 3. 操作阶段
服务运行后，通过接口方法响应外部请求或驱动程序调用。

+ **设备管理**：
    - `AddDevice(device models.Device)`：添加新设备到核心元数据。
    - `GetDeviceByName(name string)`：查询设备信息。
    - `UpdateDevice(device models.Device)`：更新设备属性。
    - `RemoveDeviceByName(name string)`：删除设备。
    - 示例：通过 REST API 或内部调用触发。
+ **设备配置文件管理**：
    - `AddDeviceProfile(profile models.DeviceProfile)`：添加设备配置文件。
    - `GetProfileByName(name string)`：获取配置文件。
    - `UpdateDeviceProfile(profile models.DeviceProfile)`：更新配置文件。
    - `RemoveDeviceProfileByName(name string)`：删除配置文件。
+ **资源和命令查询**：
    - `DeviceResource(deviceName, deviceResource)`：获取设备资源定义。
    - `DeviceCommand(deviceName, commandName)`：获取设备命令定义。
    - 示例：驱动程序在 `HandleReadCommands` 中调用。
+ **自动事件管理**：
    - `AddDeviceAutoEvent(deviceName, event)`：添加自动事件（如定时读取）。
    - `RemoveDeviceAutoEvent(deviceName, event)`：移除自动事件。
+ **状态管理**：
    - `UpdateDeviceOperatingState(name, state)`：更新设备运行状态（如 `UP` 或 `DOWN`）。
    - `DeviceExistsForName(name)`：检查设备是否存在。
+ **驱动配置**：
    - `DriverConfigs()`：提供驱动程序的自定义配置，供驱动在运行时使用。
+ **异步和发现支持**：
    - `AsyncValuesChannel()`：接收异步读数。
    - `DiscoveredDeviceChannel()`：接收发现的设备。
+ **辅助功能**：
    - `LoggingClient()`：提供日志记录。
    - `SecretProvider()`：访问安全凭证。
    - `MetricsManager()`：管理性能指标。

---

### 工作流程图示
```plain
[main()]
   |
   v
[Run()]
   |--> 加载配置 (本地或 keeper)
   |--> 初始化驱动 (Initialize())
   |--> 注册服务
   |--> 初始化通道 (Async/Discovery)
   |
   v
[运行阶段]
   |--> 启动 Web 服务器
   |--> 连接消息总线
   |--> 监听配置变化
   |--> 加载设备和配置文件
   |
   v
[操作阶段]
   |--> 设备管理 (AddDevice, GetDeviceByName, etc.)
   |--> 配置文件管理 (AddDeviceProfile, etc.)
   |--> 资源/命令查询 (DeviceResource, DeviceCommand)
   |--> 自动事件 (AddDeviceAutoEvent)
   |--> 驱动配置 (DriverConfigs)
   |--> 异步/发现 (AsyncValuesChannel)
```

---

### 示例：添加设备并读取配置
```go
func main() {
    sdk := &sdk.Service{}
    driver := &SimpleDriver{sdk: sdk}
    sdk.Run(driver)
}

type SimpleDriver struct {
    sdk DeviceServiceSDK
}
    
func (d *SimpleDriver) Initialize(lc logger.LoggingClient, asyncCh chan<- *sdkModels.AsyncValues, deviceCh chan<- []sdkModels.DiscoveredDevice) error {
    device := models.Device{Name: "TestDevice"}
    id, err := d.sdk.AddDevice(device)
    if err != nil {
        return err
    }
    lc.Infof("Device added: %s", id)
    configs := d.sdk.DriverConfigs()
    lc.Infof("Driver configs: %v", configs)
    return nil
}
```

+ **流程**：
    1. `Run()` 加载配置并调用 `Initialize`。
    2. `AddDevice` 注册设备到核心元数据。
    3. `DriverConfigs()` 返回配置供驱动使用。

---

### 总结
`DeviceServiceSDK` 的工作流程分为：

1. **初始化**：加载配置、初始化驱动、注册服务。
2. **运行**：启动服务器、连接消息总线、监听变化。
3. **操作**：通过接口方法管理设备、配置文件和驱动行为。

每个方法都在特定阶段被调用，共同支持设备服务的运行。如果您需要深入某个方法（如 `Run()` 或 `DriverConfigs()`）的具体实现，请告诉我，我可以进一步展开！





好的，先翻译再总结：





# Service 层
## Configuring Add-on Service（配置附加服务**）**
[Configuring Add-on Service](https://docs.edgexfoundry.org/3.1/security/Ch-Configuring-Add-On-Services/)

在当前的 EdgeX 安全服务中，我们为现有的默认服务（如 `core-data`、`core-metadata`、`device-virtual` 等）设置并配置了所有与安全相关的属性和环境变量。这些设置和服务环境变量已经预配置好，并准备在安全模式下运行，无需对 Docker-compose 文件进行任何更新或修改。然而，一些预构建的附加服务，如某些设备服务（例如 `device-camera`、`device-modbus`）以及一些应用服务（例如 `app-http-export`、`app-mqtt-export`）默认没有预配置。并且如果你添加自定义的应用服务，默认也没有预配置，因此需要进行一些配置工作才能使它们在安全模式下运行。

EdgeX 提供了一种方法，允许用户将这些附加服务配置到 EdgeX Docker 软件堆栈中，并使其在安全模式下运行。这可以通过 Docker-compose 文件来实现，用户只需添加一些额外的环境变量，并对微服务的 Dockerfile 进行一些修改。在 `edgex-compose` 仓库中，`compose-builder` 工具提供了多种方式来处理这些附加服务，例如通过 `add-security.yml` 和 `make` 命令生成适用于安全模式的 docker-compose 文件。有关更多详细信息，请参阅 `compose-builder` 的 README 文档。

上述相同的指导方针也适用于自定义设备服务和应用服务，即非 EdgeX 构建的服务。

EdgeX Ireland 版本的一个主要安全特性是利用 `service-security-bootstrapper` 来确保正确的启动顺序，从而确保所有服务在启动时都能获得所需的安全依赖。

目前，EdgeX 默认使用 Vault 作为密钥存储的实现，并且如果用户选择使用 Consul，则 Consul 用作配置和/或注册服务。某些默认服务已预配置为生成密钥存储，例如 EdgeX 的核心/支持服务、`device-virtual`、`device-rest` 和 `app-rules-engine` 服务。

:::info
**注意：** Vault 将在 EdgeX 4.0 中被弃用，新的实现将使用 OpenBao 作为默认的密钥存储。

:::

对于运行附加服务（例如 `device-camera`、`app-http-export`）在安全模式下，它们的密钥存储并不会默认生成，但可以通过以下配置步骤生成。

以下示例假设 EdgeX 服务运行在 Docker 环境中，因此示例将使用 Docker-compose 的方式进行说明。

**配置附加服务**

### 使附加服务兼容 `security-bootstrapper`
  
要使用 `security-bootstrapper` 的 Docker 入口脚本进行安全启动，`device-camera` 的 Dockerfile 应该继承类似 Alpine 的基础镜像，并使用 `apk add --update` 安装 `dumb-init`。Dockerfile 示例：

```dockerfile
FROM alpine:3.12
RUN apk add --update --no-cache dumb-init
```

然后，服务本身需要将 `/edgex-init/ready_to_run_wait_install.sh` 作为入口点脚本，并为该服务添加相关的 Docker 卷，以便在安全模式下使用。示例：

```yaml
app-service-rules:
  entrypoint: ["/edgex-init/ready_to_run_wait_install.sh"]
  command: "/app-service-configurable ${DEFAULT_EDGEX_RUN_CMD_PARMS}"
  volumes:
    - edgex-init:/edgex-init:ro,z
    - /tmp/edgex/secrets/app-rules-engine:/tmp/edgex/secrets/app-rules-engine:ro,z
  depends_on:
    - security-bootstrapper
```

### 配置服务的密钥存储
  
在 EdgeX 3.0 中，服务的密钥存储配置已从每个服务的配置文件中移除。现在，服务的密钥存储配置有默认值，可以通过环境变量覆盖这些默认值。对于附加服务，必须将服务密钥添加到 `secretstore-setup` 服务的 `EDGEX_ADD_SECRETSTORE_TOKENS` 环境变量中。示例：

```yaml
secretstore-setup:
  container_name: edgex-secretstore-setup
  environment:
    EDGEX_ADD_SECRETSTORE_TOKENS: 'device-onvif-camera'
```

### （可选）配置已知的密钥
  
`EDGEX_ADD_KNOWN_SECRETS` 环境变量允许将已知的密钥（如 Redis 数据库凭证）添加到附加服务的密钥存储中。需要 Redis 数据库凭证的附加服务必须在其密钥存储中包含该凭证。示例：

```yaml
secretstore-setup:
  container_name: edgex-secretstore-setup
  environment:
    EDGEX_ADD_KNOWN_SECRETS: redisdb[app-rules-engine],redisdb[device-rest],redisdb[device-virtual]
```

### （可选）配置 Consul ACL 角色
  
如果附加服务使用 Consul 作为配置或注册中心，需要配置 `EDGEX_ADD_REGISTRY_ACL_ROLES` 环境变量，告诉 `security-bootstrapper` 为这些服务生成 ACL 角色。示例：

```yaml
consul:
  container_name: edgex-core-consul
  environment:
    EDGEX_ADD_REGISTRY_ACL_ROLES: app-http-export,device-modbus
```

### （可选）配置 API 网关路由
  
如果希望外部用户或应用程序能够访问附加服务的端点，可以通过 `proxy-setup` 服务的 `EDGEX_ADD_PROXY_ROUTE` 环境变量将这些服务路由到 API 网关。示例：

```yaml
edgex-proxy:
  environment:
    EDGEX_ADD_PROXY_ROUTE: "device-camera.http://edgex-device-onvif-camera:59984, device-modbus.http://edgex-device-modbus:59901"
```

### 总结
1. **EdgeX 安全模式配置**：默认服务已经配置为支持安全模式，但附加服务和自定义服务需要手动配置。
2. **Dockerfile 修改**：附加服务需要继承基础镜像（如 Alpine）并安装 `dumb-init`，以确保启动时的安全依赖关系。
3. **密钥存储配置**：服务需要通过环境变量配置生成密钥存储令牌，并确保服务能够访问所需的密钥（如 Redis 密码）。
4. **Consul ACL 角色**：如果服务依赖于 Consul，需要配置 ACL 角色以确保安全访问。
5. **API 网关配置**：如果需要通过外部访问附加服务的 API，可以通过设置 API 网关路由来实现。

这些步骤确保附加服务能够在 EdgeX 的安全模式下正常运行，保证其依赖关系和访问权限得以正确处理。如果有任何问题，随时可以继续交流！

