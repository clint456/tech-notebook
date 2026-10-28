## Markdown 和快捷键全覆盖
> 💡 Tips：语雀支持全功能 markdown 语法，可以点击文档编辑页右下角小键盘查看全部支持的语法和快捷键。
>

+ 支持导入导出 `markdown` 文件。
+ 支持自动识别粘贴的 `markdown` 格式内容转换为富文本。

## 行内代码
> 💡 Tips：可通过 markdown 语法（```+ `code` + ``` + `空格`）或者快捷键 `ctrl/cmd` + `E`快速插入行内代码。
>

在文本中使用`行内代码`，可以顺畅地显示代码变量名。

## 代码块
> 💡 Tips：输入`/代码块`或点击上方工具栏点击上方工具栏![](https://cdn.nlark.com/yuque/0/2022/png/519985/1646896088287-c8e7ef6c-2748-40d7-b53f-223b99fc5be5.png)，选择「代码块」、插入代码卡片。
>

代码块同时支持多种颜色主题：

```javascript
export default class QuickSort extends Sort {
  sort(originalArray) {
    const array = [...originalArray];

    if (array.length <= 1) {
      return array;
    }

    // Init left and right arrays.
    const leftArray = [];
    const rightArray = [];

    // Take the first element of array as a pivot.
    const pivotElement = array.shift();
    const centerArray = [pivotElement];

    // Split all array elements between left, center and right arrays.
    while (array.length) {
      const currentElement = array.shift();

      // Call visiting callback.
      this.callbacks.visitingCallback(currentElement);

      if (this.comparator.equal(currentElement, pivotElement)) {
        centerArray.push(currentElement);
      } else if (this.comparator.lessThan(currentElement, pivotElement)) {
        leftArray.push(currentElement);
      } else {
        rightArray.push(currentElement);
      }
    }
    // Sort left and right arrays.
    const leftArraySorted = this.sort(leftArray);
    const rightArraySorted = this.sort(rightArray);

    return leftArraySorted.concat(centerArray, rightArraySorted);
  }
}
```

```javascript
export default class QuickSort extends Sort {
  sort(originalArray) {
    const array = [...originalArray];

    if (array.length <= 1) {
      return array;
    }

    // Init left and right arrays.
    const leftArray = [];
    const rightArray = [];

    // Take the first element of array as a pivot.
    const pivotElement = array.shift();
    const centerArray = [pivotElement];

    // Split all array elements between left, center and right arrays.
    while (array.length) {
      const currentElement = array.shift();

      // Call visiting callback.
      this.callbacks.visitingCallback(currentElement);

      if (this.comparator.equal(currentElement, pivotElement)) {
        centerArray.push(currentElement);
      } else if (this.comparator.lessThan(currentElement, pivotElement)) {
        leftArray.push(currentElement);
      } else {
        rightArray.push(currentElement);
      }
    }
    // Sort left and right arrays.
    const leftArraySorted = this.sort(leftArray);
    const rightArraySorted = this.sort(rightArray);

    return leftArraySorted.concat(centerArray, rightArraySorted);
  }
}
```

```javascript
export default class QuickSort extends Sort {
  sort(originalArray) {
    const array = [...originalArray];

    if (array.length <= 1) {
      return array;
    }

    // Init left and right arrays.
    const leftArray = [];
    const rightArray = [];

    // Take the first element of array as a pivot.
    const pivotElement = array.shift();
    const centerArray = [pivotElement];

    // Split all array elements between left, center and right arrays.
    while (array.length) {
      const currentElement = array.shift();

      // Call visiting callback.
      this.callbacks.visitingCallback(currentElement);

      if (this.comparator.equal(currentElement, pivotElement)) {
        centerArray.push(currentElement);
      } else if (this.comparator.lessThan(currentElement, pivotElement)) {
        leftArray.push(currentElement);
      } else {
        rightArray.push(currentElement);
      }
    }
    // Sort left and right arrays.
    const leftArraySorted = this.sort(leftArray);
    const rightArraySorted = this.sort(rightArray);

    return leftArraySorted.concat(centerArray, rightArraySorted);
  }
}
```

## 数学公式
> 💡 Tips：输入 `/公式`或点击上方工具栏点击上方工具栏![](https://cdn.nlark.com/yuque/0/2022/png/519985/1646896088287-c8e7ef6c-2748-40d7-b53f-223b99fc5be5.png)，选择「公式」、插入公式卡片。
>

公式支持行内嵌套：![image](https://intranetproxy.alipay.com/skylark/lark/__latex/8986e6bf4f4b4ff45d88debcfd9615ca.svg)，也支持块级嵌入。

![image](https://intranetproxy.alipay.com/skylark/lark/__latex/45d276c520dbdf5bf9f9f3e4a7e5c480.svg)

## 画板
> 💡 Tips：输入`/画板`或点击上方工具栏![](https://cdn.nlark.com/yuque/0/2022/png/519985/1646896088287-c8e7ef6c-2748-40d7-b53f-223b99fc5be5.png)，选择「画板」、绘制流程图、架构图等各种图形。
>

![画板](https://intranetproxy.alipay.com/skylark/lark/0/2022/jpeg/141/1643261198014-1b94d73a-8d53-416b-bc0e-05c2b61793ea.jpeg)

![画板](https://intranetproxy.alipay.com/skylark/lark/0/2022/jpeg/141/1643260172392-f825fb81-bb39-49eb-982b-2e1467396ba4.jpeg)



![画板](https://cdn.nlark.com/yuque/0/2022/jpeg/956523/1657187591568-621b44f9-81f7-4be7-8c31-257d7ec9ab0a.jpeg)

## 文本绘图
> 💡 Tips：输入`/文本绘图`点击上方工具栏![](https://cdn.nlark.com/yuque/0/2022/png/519985/1646896088287-c8e7ef6c-2748-40d7-b53f-223b99fc5be5.png)，选择「文本绘图」、插入文本绘图卡片。  
支持 [plantuml](https://plantuml.com/)、[mermaid](https://mermaid-js.github.io/mermaid/#/) 等多种格式，点击`预览`可看到图形。具体代码样式见[说明文档](https://www.yuque.com/yuque/gpvawt/gantt)。
>

![](https://intranetproxy.alipay.com/skylark/lark/__puml/b11b6192390c95750c4b71c2580ff529.svg)

![](https://lark-assets-test-aliyun.oss-cn-hangzhou.aliyuncs.com/yuque/__mermaid_v3/743010bfb6962498a4b9a485b60a8305.svg)











# 第一章 概述
## 1.1 体系结构原则


## 1.2 设计和实现
### 1.2.1 分层
> 分层的概念基于开放系统互连标准（OSI）的模型，该模型由国际标准化组织（ISO）定义的。
>

####  OSI 七层网络模型
### 1.2.2 分层实现中的复用、分解、封装
在计算机网络中，分层模型（如OSI七层模型或TCP/IP四层模型）的设计核心是**模块化**和**抽象化**。这种设计使得每一层可以独立实现其功能，同时通过**复用**、**分解**和**封装**等机制，实现高效的数据传输和通信。以下是对这三个概念的详细解释：

---

#### 1. 复用（Multiplexing）
##### 定义：
复用是指多个高层协议或数据流可以通过同一个低层协议进行传输的能力。换句话说，一个低层协议可以为多个高层协议提供服务。

##### 关键点：
+ **目的**：提高资源利用率，减少冗余。
+ **实现方式**：通过标识符（如端口号、协议号等）区分不同的数据流。
+ **应用场景**：
    - 在传输层，TCP和UDP协议可以共享同一网络层协议（IP）。
    - 在应用层，HTTP、FTP、SMTP等协议可以共享传输层协议（如TCP）。

##### 示例：
+ **传输层复用**：一台主机上的多个应用程序可以通过不同的端口号（如80用于HTTP，25用于SMTP）共享同一个TCP连接。
+ **网络层复用**：IP协议可以承载多种上层协议（如TCP、UDP、ICMP），通过IP头部的“协议字段”来区分。

---

#### 2. 分解（Demultiplexing）
##### 定义：
分解是复用的逆过程，指低层接收到的数据包被正确地分配给对应的高层协议或应用程序。

##### 关键点：
+ **目的**：确保数据能够准确地传递到目标协议或应用程序。
+ **实现方式**：根据标识符（如端口号、协议号等）将数据分发到正确的接收方。
+ **应用场景**：
    - 网络层接收到IP数据包后，根据“协议字段”将其交给TCP、UDP或其他协议处理。
    - 传输层接收到数据段后，根据“端口号”将其传递给对应的应用程序。

##### 示例：
+ **传输层分解**：当服务器接收到一个TCP数据包时，根据目标端口号（如80）将其传递给HTTP服务。
+ **网络层分解**：路由器接收到IP数据包后，根据“协议字段”决定将其交给TCP还是UDP处理。

---

#### 3. 封装（Encapsulation）
##### 定义：
封装是指在发送数据时，每一层都会将上层传递下来的数据加上本层的头部（有时还包括尾部），形成一个新的数据单元，然后传递给下一层。

##### 关键点：
+ **目的**：为数据添加必要的控制信息，以便每一层能够完成其特定的功能。
+ **实现方式**：每层在数据前添加头部（Header），有时在数据后添加尾部（Trailer）。
+ **封装顺序**：从高层到低层依次封装，最终形成可以在物理介质上传输的比特流。

##### 示例：
以HTTP请求为例：

1. **应用层**：HTTP协议生成请求数据（如GET /index.html）。
2. **传输层**：TCP协议为HTTP数据添加TCP头部（包括源端口和目标端口），形成TCP段。
3. **网络层**：IP协议为TCP段添加IP头部（包括源IP地址和目标IP地址），形成IP数据包。
4. **数据链路层**：以太网协议为IP数据包添加帧头部（包括源MAC地址和目标MAC地址），形成以太网帧。
5. **物理层**：将以太网帧转换为比特流，通过物理介质传输。

##### 封装与解封装的过程：
+ **封装**：从高层到低层逐步添加头部和尾部。
+ **解封装**：从低层到高层逐步移除头部和尾部，恢复原始数据。

---

##### 总结：复用、分解与封装的关系
| 概念 | 定义 | 目的 | 示例场景 |
| --- | --- | --- | --- |
| **复用** | 多个高层协议共享一个低层协议 | 提高资源利用率 | 多个应用通过TCP/IP协议栈共享网络 |
| **分解** | 低层将数据分发给对应的高层协议或应用 | 确保数据准确传递 | 根据端口号将数据分发给HTTP或FTP服务 |
| **封装** | 每一层为数据添加头部/尾部 | 添加控制信息，完成特定功能 | HTTP数据逐层封装为TCP段、IP包、以太网帧 |


---

#### 实际应用中的例子
假设用户通过浏览器访问一个网页（HTTP请求）：

1. **封装过程**：
    - 应用层：HTTP协议生成请求数据。
    - 传输层：TCP为HTTP数据添加头部（包括端口号）。
    - 网络层：IP为TCP段添加头部（包括IP地址）。
    - 数据链路层：以太网为IP数据包添加头部（包括MAC地址）。
    - 物理层：将以太网帧转换为比特流，通过网线传输。
2. **分解过程**：
    - 接收端逐层移除头部，恢复原始HTTP请求数据。

---

通过复用、分解和封装，分层模型实现了网络通信的高效性和灵活性，同时也降低了复杂性，便于开发和维护。希望以上内容对你有所帮助！如果还有疑问，请随时提问！

OSI（Open Systems Interconnection，开放系统互连）七层网络模型是由国际标准化组织（ISO）提出的一种网络通信模型。它将网络通信的功能划分为七个层次，每一层都有特定的功能和协议。这种分层设计使得网络系统的开发、维护和故障排查更加清晰和模块化。

| 主机 | 编号 | 名称 | 描述 |
| :---: | :---: | :---: | :---: |
| | 7 | 应用层 | 指定完成某些用户初始化任务的方法。应用协议通常由应用开发者设计和实现（FTP、Skype 等） |
| | 6 | 表示层 | 指定针对应用的数据表示格式和转换规则的方法。典型例子（字符从 EBCDIC 转换位 ASCII 码。）加密由时候与本层相关，但也可能在其他层中。 |
| | 5 | 会话层 | 指定由多个连接组成一个通信会话的方法。它有可能包括关闭连接、重启连接和检查点进程。（ISO X.255 是一哥会话层协议。） |
| | 4 | 传输层 | 指定运行在相同计算机系统中的多个程序之间的连接或关联的方法。如果在其他地方没有实现，本层可能实现可靠的投递（TCP、ISO TP4） |
| 所有网络设备 | 3 | 网络层 | 指定经过潜在不同类型链路层网络的多跳通信方法。对于分组网络，它描述了抽象的分组格式和标准的编址结构（IP 数据报、X.25PLP、ISO CLNP） |
| | 2 | 链路层 | 指定经过单一链路通信的方法，包括多个系统共享同一介质时的“介质访问”控制协议。本层通常包括差错检测和链路层地址格式（以太网、WIFI） |
| | 1 | 物理层 | 指定链接器、数据速率和如何在某些介质上进行编码。本层业描述底层的差错检测和纠正、频率分析。本书我们尽力避开这一层。 |


> ISO 定义的标准 7 层 OSI 模型。每个网络设备（从理论上）并不需要实现所有协议。OSI 的术语和层数被广泛使用。
>

以下是OSI七层模型的详细说明：

---

##### 1. 物理层（Physical Layer）
+ **功能**：负责在物理介质上传输原始比特流（0和1），定义了电气、机械、过程和功能特性。
+ **关键点**：
    - 规定了硬件设备之间的接口标准（如电压、电缆类型、连接器等）。
    - 处理信号的传输方式（如模拟信号或数字信号）。
    - 不涉及数据的实际内容，只关注如何将比特流转换为电信号、光信号或无线信号。
+ **典型设备**：网卡、集线器、中继器、光纤、电缆等。
+ **协议示例**：以太网（Ethernet）、RS-232、USB等。

---

##### 2. 数据链路层（Data Link Layer）
+ **功能**：提供节点到节点的数据传输服务，确保数据帧在物理链路上可靠传输。
+ **关键点**：
    - 将数据封装成帧（Frame），并进行错误检测（如CRC校验）。
    - 提供流量控制和链路管理。
    - 分为两个子层：
        * **逻辑链路控制（LLC）**：处理帧的同步和流量控制。
        * **媒体访问控制（MAC）**：负责设备的地址分配和介质访问控制。
+ **典型设备**：交换机、网桥。
+ **协议示例**：以太网（IEEE 802.3）、PPP（点对点协议）、Wi-Fi（IEEE 802.11）。

---

##### 3. 网络层（Network Layer）
+ **功能**：负责数据包的路由选择和转发，实现不同网络之间的通信。
+ **关键点**：
    - 提供逻辑地址（如IP地址）来标识设备。
    - 决定数据从源到目的地的最佳路径。
    - 处理分组的分割与重组。
+ **典型设备**：路由器、三层交换机。
+ **协议示例**：IP（IPv4/IPv6）、ICMP、ARP、RIP、OSPF。

---

##### 4. 传输层（Transport Layer）
+ **功能**：提供端到端的可靠通信，确保数据完整性和顺序。
+ **关键点**：
    - 负责建立、维护和终止会话。
    - 提供错误恢复和流量控制。
    - 支持面向连接（如TCP）和无连接（如UDP）两种模式。
+ **典型协议**：
    - **TCP（传输控制协议）**：可靠传输，提供确认、重传机制。
    - **UDP（用户数据报协议）**：不可靠但高效，适用于实时应用。
+ **应用场景**：文件传输、视频流、网页浏览等。

---

##### 5. 会话层（Session Layer）
+ **功能**：负责建立、管理和终止会话（Session），协调通信双方的交互。
+ **关键点**：
    - 提供会话的同步和检查点功能。
    - 控制对话的开始、暂停和结束。
    - 可能包括身份验证和授权。
+ **典型协议**：NetBIOS、RPC（远程过程调用）、SIP（会话发起协议）。

---

##### 6. 表示层（Presentation Layer）
+ **功能**：负责数据的表示、加密和压缩，确保数据格式的兼容性。
+ **关键点**：
    - 数据编码和解码（如ASCII、EBCDIC）。
    - 数据加密和解密（如SSL/TLS）。
    - 数据压缩和解压缩。
+ **典型协议**：JPEG、MPEG、SSL/TLS。

---

##### 7. 应用层（Application Layer）
+ **功能**：直接面向用户，提供网络服务和应用程序接口。
+ **关键点**：
    - 支持用户访问网络资源。
    - 包括文件传输、电子邮件、网页浏览等功能。
    - 提供高级协议和服务。
+ **典型协议**：HTTP、HTTPS、FTP、SMTP、DNS、Telnet。

---

##### 总结：各层的主要职责
| 层次 | 功能描述 | 典型协议/设备 |
| --- | --- | --- |
| 应用层 | 用户接口，提供网络服务 | HTTP、FTP、SMTP |
| 表示层 | 数据格式化、加密、压缩 | SSL/TLS、JPEG |
| 会话层 | 建立、管理和终止会话 | SIP、RPC |
| 传输层 | 端到端通信，可靠性保障 | TCP、UDP |
| 网络层 | 数据包路由和转发 | IP、ICMP、ARP |
| 数据链路层 | 节点间可靠传输，帧封装和错误检测 | Ethernet、PPP |
| 物理层 | 比特流的物理传输 | 电缆、光纤、集线器 |


---

##### 实际应用中的简化模型
虽然OSI模型是理论上的标准，但在实际网络中，TCP/IP模型更为常用。TCP/IP模型只有四层（应用层、传输层、网络层、网络接口层），与OSI模型的对应关系如下：

| OSI模型 | TCP/IP模型 |
| :---: | :---: |
| 应用层 | 应用层 |
| 表示层 | |
| 会话层 | |
| 传输层 | 传输层 |
| 网络层 | 网络层 |
| 数据链路层 | 网络接口层 |
| 物理层 | |


---



## 1.3 TCP/IP 协议族结构和协议
### 1.3.1 ARPANET 参考模型


1.4 Internet、内联网和外联网

1.5 设计应用

1.6 标准化进程

1.7 实现和软件分发

1.8 与 Internet 体系结构相关的攻击

1.9 总结

# 第二章 Internet 地址结构
2.1 前言

2.2 表示 IP 地址

2.3 基本的 IP 地址结构

2.4 CIDR 和聚合

2.5 特殊用途地址

2.6 分配

2.7 单播地址分配

2.8 与 IP 地址相关的攻击

2.9 总结



# 第三章 链路层


# 第四章 地址解析协议


# 第五章 Internet 协议 


# 第六章 系统配置 ：DHCP 和自动配置


# 第七章 防火墙和网络地址转换 


# 第八章 ICMPv4 和 ICMPv6：Internet 控制报文协议


# 第九章 广播和本地组播（IGMP 和 MLD）


# 第十章 用户数据报协议和 IP 分片


# 第十一章  名称解析和域名解析


# 第十二章 TCP：传输控制协议（初步）
# 
# 第十三章 TCP 连接管理
# 
# 第十四章 TCP 超时与重传
# 
# 第十五章 TCP 数据流与窗口管理
# 
# 第十六章 TCP 拥塞控制
# 
# 第十七章 TCP 保活机制
# 
# 第十八章 安全：可扩展身份认证协议、IP 安全协议、传输层安全、DNS 安全、域名密钥识别邮件
