> [https://grok.com/share/bGVnYWN5_365d6fa8-011b-4376-8f3e-34c656cddfda](https://grok.com/share/bGVnYWN5_365d6fa8-011b-4376-8f3e-34c656cddfda)
>

**关键点：**  

+ 研究表明，设备A与设备B（均为device-mqtt服务下的设备）通过EdgeX v3.1的MessageBus（MQTT）实现通信，最可能的方式是使用应用服务来订阅设备A的事件，然后向设备B发送命令。  
+ 直接设备间通信可能需要自定义服务，但这不是标准做法，证据倾向于使用应用服务来处理。

**配置设备A发布事件：**  

+ 确保device-mqtt服务为设备A配置了MessageBus发布功能，默认已启用。事件将发布到类似 `edgex/events/device/<profileA>/<deviceA>/<source>` 的主题。

**设置应用服务订阅和处理：**  

+ 创建或使用现有应用服务，订阅设备A的事件主题，例如 `edgex/events/device/<profileA>/<deviceA>/#`。  
+ 应用服务根据事件内容，通过Core Command服务向设备B发送命令，例如通过REST API调用 `/api/v1/command/request`。

**注意事项：**  

+ 标准EdgeX架构下，设备服务主要发布事件，应用服务负责订阅和处理，不支持设备直接订阅其他设备的事件。  
+ 如需直接通信，可能需自定义device-mqtt服务，但这超出了标准使用范围，建议参考官方文档进行开发。

更多详情请查阅相关文档：[Device Services Send Events via MessageBus](https://docs.edgexfoundry.org/current/design/adr/013-Device-Service-Events-Message-Bus/)、[EdgeX MessageBus](https://docs.edgexfoundry.org/current/microservices/general/messagebus/)、[North-South Messaging](https://docs.edgexfoundry.org/current/design/adr/)。

---

### 调查报告
以下是关于如何在EdgeX v3.1中实现设备A与设备B（均为device-mqtt服务下的设备）通过MessageBus（MQTT）通信的详细分析，基于当前文档和研究结果。

#### 背景与上下文
EdgeX Foundry是一个开源的边缘物联网中间件平台，旨在通过各种协议和格式将设备数据集成到其核心服务中。设备服务（如device-mqtt）负责与物理设备交互，将传感器数据转换为EdgeX标准格式，并通过MessageBus发布事件。MessageBus是EdgeX内部的服务间通信机制，支持MQTT协议，允许服务发布和订阅事件。当前时间为2025年4月29日晚上9:16 CDT，分析基于EdgeX v3.1的最新文档。

用户的问题是实现设备A与设备B的通信，两个设备均由device-mqtt服务管理，需通过EdgeX的MessageBus（MQTT）实现。研究表明，标准架构下，设备服务主要发布事件，而应用服务负责订阅和处理事件，设备间直接通信需通过应用服务中介。

#### 通信模型分析
根据文档，EdgeX MessageBus使用多级主题结构，例如 `edgex/events/<publisher>/<device-profile-name>/<device-name>/<source-name>`，其中publisher为“device”表示设备服务发布。设备服务默认发布事件到MessageBus，而应用服务订阅这些事件进行处理。核心数据服务也可订阅以持久化事件，但设备服务不直接订阅其他设备的事件。

从“North-South Messaging”文档可知，设备服务会订阅MessageBus上的命令请求主题（如 `edgex/cmd/<profile>/<device>/<command>`），以接收来自Core Command的命令请求，并发布响应。但对于事件（Event/Readings），设备服务不设计为订阅其他设备的事件，这是应用服务的职责。

#### 标准实现步骤
鉴于上述分析，推荐的实现方式是使用应用服务来处理设备A与设备B的通信：

1. **设备A的事件发布：**  
    - 确保device-mqtt服务为设备A配置了MessageBus发布功能。在EdgeX v3.1中，`Device.UseMessageBus` 默认设置为true，事件将发布到主题如 `edgex/events/device/<profileA>/<deviceA>/<source>`。  
    - 配置示例见 [Device Services Send Events via MessageBus](https://docs.edgexfoundry.org/current/design/adr/013-Device-Service-Events-Message-Bus/)。
2. **应用服务订阅和处理：**  
    - 创建或使用现有应用服务，配置其订阅设备A的事件主题。例如，设置 `[MessageBus]` 配置中的 `SubscribeTopics = "edgex/events/device/<profileA>/<deviceA>/#"`，以接收所有设备A的事件。  
    - 应用服务处理事件逻辑后，可通过Core Command服务向设备B发送命令。例如，调用REST API `/api/v1/command/request` 发送命令，详见 [EdgeX MessageBus](https://docs.edgexfoundry.org/current/microservices/general/messagebus/)。
3. **设备B接收命令：**  
    - 设备B的device-mqtt服务会订阅命令请求主题（如 `edgex/cmd/<profileB>/<deviceB>/<command>`），接收来自应用服务的命令并执行。

#### 自定义实现的可能性
若用户坚持设备间直接通信（不通过应用服务），需自定义device-mqtt服务，使其订阅设备A的事件主题。这需要：

+ 使用Go SDK的go-mod-messaging模块，扩展device-mqtt服务以订阅MessageBus上的事件主题（如 `edgex/events/device/<profileA>/<deviceA>/#`）。  
+ 实现事件处理逻辑，例如根据设备A的事件更新设备B的状态。但这非标准做法，可能需要参考 [North-South Messaging](https://docs.edgexfoundry.org/current/design/) 文档开发。

#### 限制与注意事项
+ 标准device-mqtt服务设计为连接外部MQTT主题并发布到EdgeX MessageBus，不支持订阅内部事件主题。  
+ 设备服务订阅事件主题非标准用法，可能导致架构复杂性增加，建议优先使用应用服务。  
+ 配置时需确保MQTT代理（如Mosquitto）运行，并根据需求启用安全连接（如用户名/密码或客户端证书），详见相关文档。

#### 对比表：标准 vs 自定义实现
| **方面** | **标准实现（推荐）** | **自定义实现（非标准）** |
| --- | --- | --- |
| **通信方式** | 设备A发布事件，应用服务订阅并向设备B发送命令 | 设备B自定义订阅设备A的事件主题，直接处理 |
| **实现复杂度** | 低，基于现有应用服务功能 | 高，需修改device-mqtt服务代码 |
| **架构符合性** | 完全符合EdgeX标准架构 | 不符合标准，可能增加维护成本 |
| **适用场景** | 标准EdgeX部署，事件处理需逻辑复杂 | 特殊需求，设备间需实时直接交互 |
| **文档支持** | 详见 [EdgeX MessageBus](https://docs.edgexfoundry.org/current/microservices/general/messagebus/) | 需参考SDK文档，自行开发 |


#### 结论
研究表明，设备A与设备B通过EdgeX v3.1的MessageBus（MQTT）实现通信，最可行的标准方式是使用应用服务订阅设备A的事件并向设备B发送命令。这符合EdgeX架构设计，易于配置和维护。若需直接设备间通信，需自定义device-mqtt服务，但这非标准做法，建议谨慎评估。

#### 关键引用
+ [Device Services Send Events via MessageBus - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/current/design/adr/013-Device-Service-Events-Message-Bus/)  
+ [EdgeX MessageBus - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/current/microservices/general/messagebus/)  
+ [North-South Messaging - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/current/design/adr/)

