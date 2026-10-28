以下是整理后的 `emqx ctl` 命令列表：  

---

## **状态管理**
+ `status` - 显示代理状态  
+ `broker` - 显示代理版本、运行时间和描述  
+ `broker stats` - 显示客户端、主题和订阅统计信息  
+ `broker metrics` - 显示代理指标

---

## **集群管理**
+ `cluster join <Node>` - 加入集群  
+ `cluster leave` - 退出集群  
+ `cluster force-leave <Node>` - 强制节点离开集群  
+ `cluster status [--json]` - 显示集群状态  
+ `cluster discovery enable` - 启用并运行自动集群发现（如果已配置）

---

## **客户端管理**
+ `clients list` - 列出所有客户端  
+ `clients show <ClientId>` - 显示特定客户端信息  
+ `clients kick <ClientId>` - 踢出特定客户端

---

## **主题管理**
+ `topics list` - 列出所有主题  
+ `topics show <Topic>` - 显示特定主题信息

---

## **订阅管理**
+ `subscriptions list` - 列出所有订阅  
+ `subscriptions show <ClientId>` - 显示客户端的订阅信息  
+ `subscriptions add <ClientId> <Topic> <QoS>` - 手动添加静态订阅  
+ `subscriptions del <ClientId> <Topic>` - 手动删除静态订阅

---

## **插件管理**
+ `plugins list` - 列出所有安装的插件  
+ `plugins describe <Name-Vsn>` - 显示插件详情  
+ `plugins install <Name-Vsn>` - 安装插件  
+ `plugins uninstall <Name-Vsn>` - 卸载插件  
+ `plugins start <Name-Vsn>` - 启动插件  
+ `plugins stop <Name-Vsn>` - 停止插件  
+ `plugins restart <Name-Vsn>` - 重启插件  
+ `plugins disable <Name-Vsn>` - 禁用插件自启  
+ `plugins enable <Name-Vsn> [Position]` - 启用插件自启，并指定启动顺序

---

## **Erlang VM 信息**
+ `vm all` - 显示 Erlang VM 信息  
+ `vm load` - 显示 VM 负载  
+ `vm memory` - 显示 VM 内存使用情况  
+ `vm process` - 显示 VM 进程信息  
+ `vm io` - 显示 VM IO 信息  
+ `vm ports` - 显示 VM 端口信息

---

## **Mnesia 数据库**
+ `mnesia` - 显示 Mnesia 系统信息

---

## **日志管理**
+ `log set-level <Level>` - 设置全局日志级别  
+ `log primary-level` - 显示主日志级别  
+ `log primary-level <Level>` - 设置主日志级别  
+ `log handlers list` - 显示日志处理器  
+ `log handlers start <HandlerId>` - 启动日志处理器  
+ `log handlers stop <HandlerId>` - 停止日志处理器  
+ `log handlers set-level <HandlerId> <Level>` - 设置日志处理器级别

---

## **跟踪（Trace）**
+ `trace list` - 列出所有本地跟踪  
+ `trace start client <ClientId> <File> [<Level>] [<Formatter>]` - 开启客户端跟踪（格式：text/json）  
+ `trace stop client <ClientId>` - 停止客户端跟踪  
+ `trace start topic <Topic> <File> [<Level>] [<Formatter>]` - 开启主题跟踪  
+ `trace stop topic <Topic>` - 停止主题跟踪  
+ `trace start ip_address <IP> <File> [<Level>] [<Formatter>]` - 开启 IP 地址跟踪  
+ `trace stop ip_address <IP>` - 停止 IP 地址跟踪  
+ `trace start ruleid <RuleID> <File> [<Level>] [<Formatter>]` - 开启规则 ID 跟踪  
+ `trace stop ruleid <RuleID>` - 停止规则 ID 跟踪

---

## **集群跟踪（Traces）**
+ `traces list` - 列出所有集群跟踪  
+ `traces start <Name> client <ClientId> [<Duration>] [<Formatter>]` - 开启客户端跟踪  
+ `traces start <Name> topic <Topic> [<Duration>] [<Formatter>]` - 开启主题跟踪  
+ `traces start <Name> ruleid <RuleID> [<Duration>] [<Formatter>]` - 开启规则 ID 跟踪  
+ `traces start <Name> ip_address <IPAddr> [<Duration>] [<Formatter>]` - 开启 IP 地址跟踪  
+ `traces stop <Name>` - 停止跟踪  
+ `traces delete <Name>` - 删除跟踪

---

## **监听器管理**
+ `listeners` - 列出监听器  
+ `listeners stop <Identifier>` - 停止监听器  
+ `listeners start <Identifier>` - 启动监听器  
+ `listeners restart <Identifier>` - 重启监听器  
+ `listeners enable <Identifier> <true/false>` - 启用或禁用监听器

---

## **授权缓存**
+ `authz cache-clean all` - 清除所有节点的授权缓存  
+ `authz cache-clean node <Node>` - 清除特定节点的授权缓存  
+ `authz cache-clean <ClientId>` - 清除特定客户端的授权缓存

---

## **证书缓存**
+ `pem_cache clean all` - 清除所有节点的 x509 证书缓存  
+ `pem_cache clean node <Node>` - 清除特定节点的 x509 证书缓存

---

## **过载保护**
+ `olp status` - 查看 OLP 状态  
+ `olp enable` - 启用 OLP  
+ `olp disable` - 禁用 OLP

---

## **数据导入导出**
+ `data import <File>` - 从指定 tar 归档文件导入数据  
+ `data export [--root-keys key1,key2,key3] [--table-sets set1,set2,set3] [--dir out_dir]` - 导出数据

---

## **独占主题管理**
+ `exclusive list` - 列出所有独占主题  
+ `exclusive delete <Topic>` - 删除独占主题

---

## **保留消息**
+ `retainer info` - 显示保留消息数量  
+ `retainer topics [<Start> <Limit>]` - 显示保留消息主题  
+ `retainer clean [<Topic>]` - 清除所有或指定主题的保留消息  
+ `retainer reindex status` - 显示重建索引状态（仅适用于内置后端）  
+ `retainer reindex start [force]` - 重新生成索引（可选 `force` 强制忽略先前的索引）

---

## **观察者**
+ `observer status` - 启动观察器  
+ `observer bin_leak` - 强制执行垃圾回收，打印二进制泄漏进程  
+ `observer load Mod` - 增强模块同步

---

## **配置管理**
+ `conf reload --replace|--merge` - 重新加载 `emqx.conf` 配置文件  
+ `conf show_keys` - 显示当前使用的配置键  
+ `conf show [<key>]` - 显示特定配置键值  
+ `conf load --replace|--merge <path>` - 从 HOCON 格式配置文件加载配置  
+ `conf cluster_sync status` - 显示集群配置同步状态  
+ `conf cluster_sync fix` - 使用最完整的配置同步其他节点

---

## **规则管理**
+ `rules list` - 列出所有规则  
+ `rules show <RuleID>` - 显示特定规则信息

---

## **管理员管理**
+ `admins add <Username> <Password> <Description>` - 添加仪表板用户  
+ `admins passwd <Username> <Password>` - 重置用户密码  
+ `admins del <Username>` - 删除用户

---

## **网关管理**
+ `gateway list` - 列出所有网关  
+ `gateway lookup <Name>` - 查看网关详情  
+ `gateway load <Name> <JsonConf>` - 载入网关  
+ `gateway unload <Name>` - 卸载网关  
+ `gateway stop <Name>` - 停止网关  
+ `gateway start <Name>` - 启动网关  
+ `gateway-clients list <Name>` - 列出网关的所有客户端  
+ `gateway-clients lookup <Name> <ClientId>` - 查看网关客户端信息  
+ `gateway-clients kick <Name> <ClientId>` - 踢出网关客户端  
+ `gateway-metrics <Name>` - 显示网关指标

---

这样更清晰、易读！

