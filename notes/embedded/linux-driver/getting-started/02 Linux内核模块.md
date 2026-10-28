# Linux驱动编译

Linux内核架构很庞大，组件也很多，如果希望将自己设计的驱动包含在内核中，有两种办法：

1. Linux模块（Module），把驱动编译成模块，然后`insmod`加载入内核中。
2. 直接把驱动编译到内核中。

## Linux模块编译驱动

以module的方式编译驱动，需要以下几个部分：

1. 内核成功编译过；
2. 找到内核的arm编译器；
3. 编写简单的Makefile文件，Makefile文件中需要指向内核源码目录（成功编译过的内核源目录）；
4. 编译简单驱动；
5. imsmod加载简单驱动；

```c
// 最简单的设备驱动-helloworld
#include <linux/init.h>
#include <linux/module.h>

static int hello_init(void) 
{
  printk("hello! \n");
  return 0;
}
static void hello_exit(void)
{ s
    printk("goodbye! \n"); 
}
module_init(hello_init)
module_exit(hello_exit);
MODULE_LICENSE("GPL");
```

### 创龙开发板编译内核

参考官方文档`\TL3568-EVM-S(Ubuntu20.04)_V2.0\3-用户手册`的内核编译部分

<img src="https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717101631616.png" alt="image-20250717101631616" style="zoom:50%;" />

至此Tronglong Linux内核编译完成！

![image-20250717101828683](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717101828683.png)

接下来我们需要更新开发板的内核版本，利用RKD开发工具，将`boot.img`上传的到开发板指定的内存块中，如果已经修改过设备分区表，需要先从设备中获取：

![image-20250717102217533](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717102217533.png)

没有修改过可以直接`执行`上传

![image-20250717102255638](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717102255638.png)

可以看到内核的版本已经更新为`5.10.226-rt89`，接下来我们需要利用该内核的支持来编译简单设备驱动，然后再`insmod`进Tronlong开发板。
![](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717102404586.png)

### Makefile简单设备驱动

```makefile
obj-m += helloworld.o
KDIR =/home/clint/Linux/rk3568/Kernel226 # 再次确认，内核源码与开发板上的内核版本对不对的上
PWD ?= $(shell pwd)
all:
make -C $(KDIR) M=$(PWD) modules ARCH=arm64 CROSS_COMPILE=/home/clint/Linux/rk3568/Ubuntu/rk3568-ubuntu20.04-sdk-v1.0/sysroots/x86_64-linux/bin/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
clean:
        rm -rf modules.order *.o workqueque.o Module.symvers *.mod.c *.ko
        
```

- `KDIR`：内核源码文件夹，这里要选择与Tronlong开发板上对应的那个;
- `PWD` ： 当前目录，将会把Makefile文件和驱动源码放到该目录下编译。
- `make -C`
  - $(KDIR) M=$(PWD) modules，表示将当前目录下的文件编译为模块,并且制定了内核源码的路径;
  - ARCH=arm表示设置目标CPU类别为arm，也就是编译的依赖内核和驱动模块目标CPU为ARM；
  - CR0SS_COMPILE=/usr/local/arm64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-，这里的路径，指向内核编译器的路径。



### 编译简单驱动

![image-20250717103953092](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717103953092.png)

make后，可以看到生成了`.ko`文件

### 加载moudle-简单设备驱动

![image-20250717103907809](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717103907809.png)

![image-20250717104048365](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717104048365.png)

### 卸载简单驱动

![image-20250717111537736](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8/image-20250717111537736.png)

## 驱动模块直接编译进内核

Linux内核的编译可以为嵌入式系统构建可运行的Linux操作系统映像，在编译内核时，需要配置内核，可以使用以下几种方法：

```bash
make config  # 基于文本的最传统的配置界面，不推荐
make menuconfig # 基于文本菜单的配置界面
make xconfig # 要求QT被安装
make gconfig # 要求GTK+被安装
```

### 图形化配置内核

最推荐`make menuconfig`不依赖QT、GTK+，在Tronlong RK3568中，内核源码终端的系统环境变量中配置一下编译器：

```bash
//compile_arm.sh
export CROSS_COMPILE=/home/clint/Linux/rk3568/Ubuntu/rk3568-ubuntu20.04-sdk-v1.0/sysroots/x86_64-linux/bin/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export ARCH=arm64
```

配置内核编译选项：

`make rockchip_linux_defconfig`

若需要修改内核配置，可通过以下命令，进入图形化界面，配置设备驱动、进行系统裁剪：
	`make menuconfig`

通过配置好的设备树 ，开始编译内核源码。

![image-20250718151302805](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718151302805-1752822787111-1.png)

`make tl3568-evm.img -j16`

内核默认配置有很多，下图的路径下包含了很多默认配置，包括刚刚编译的`rockchip_linux_defconfig`,根据需要选取即可。

![image-20250717140210815](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250717140210815.png)

Linux内核的系统配置由以下3个部分组成：

- Makefile: 分布在Linux内核源码中，定义Linux内核的编译规则。

- 配置文件（kconfig)：给用户提供配置选择的功能。

- 配置工具：包括配置命令解释器（对配置脚本中的使用的配置命令进行解释）和配置用户界面（提供字符界面和图形界面）。这些配置工具使用的都是脚本语言,如`Tcl/TK、Perl`等。

  > 使用`make menuconfig`等明令后，会生成一个`.config`配置文件，用于记录哪些部分被编译入内核、哪些被编译为内核模块。当我们`make menuconfig`保存后，Linux会将所有的配置选项以宏定义的形式保存在`include/generated/autoconf.h`下



**Linux内核中增加驱动程序需要完成以下三项工作**

- [ ] 将编写的源代码复制到Linux内核源码的相应目录中；
- [ ] 在目录的`Kconfig`文件中增加关于**新源代码**对应项目的编译选项；
- [ ] 在目录的`Makefile`文件中增加对**新源代码**的编译条目。

- Makefile是里面的编译规则，告诉make什么做饭（编译）；
- Kconfig内核配置的选项，告诉内核点啥菜（选择支持配置项）；
- .config配置完内核以后生成的配置选项，点完的清单。

### 内核中编译驱动

本节，我们需要在内核中增加驱动程序，需要驱动源码、Kconfig、Makefile，

先修改Kconfig，然后将驱动添加到菜单中，就可以用make Menuconfig图形化配置来修改.config,看一个例子

#### 例子

![image-20250718164325627](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718164325627.png)

#### 例子说明

1. **source "drivers/redled/Kconfig"**
   - 这行代码指示加载 `drivers/redled` 路径下的 Kconfig 文件，方便对该目录下的驱动进行配置管理。
2. **config LED_RK3568**
   - 配置 LED 驱动的名称。
3. **tristate "LED Support for GPIO Led"**
   - 配置 LED 驱动支持。`tristate` 表示该选项可以选择 3 个状态：`y` 表示启用，`n` 表示禁用，`m` 表示编译为模块。
4. **depends on LEDS_CLASS**
   - 该选项依赖于 `LEDS_CLASS`。只有在满足该依赖时，才能选择该配置项。
5. **help**
   - **说明**：该选项启用对 GPIO LED 的帮助支持信息。

#### 实例—、将`helloworld.c`编译进内核中

1、进入源码目录，创建hello驱动文件夹，并将helloworld.c拷贝至当前文件夹；

```bash
cd drivers/char
mkdir hello
cd hello #创建hello文件夹
```

2、在hello文件夹中创建并编辑Kconfig，Makefile

```c
# vim Kconfig
config HELLO
    tristate "hello wrold"
    help
        hello hello
```

```bash
# vim Makefile
obj-$(CONFIG_HELLO)+=helloworld.o
```

3、驱动文件`hellowrold.c、Keconfig、Makefile`准备完毕。下一步，需要修改上一级目录Makefile和Konfig。添加下图的内容

![image-20250718170242045](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718170242045.png)

![image-20250718170310959](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718170310959.png)

4、返回原源码目录，执行编译

```bash
export PATH=/home/clint/Linux/rk3568/Ubuntu/rk3568-ubuntu20.04-sdk-v1.0/sysroots/x86_64-linux/bin/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin:$PATH
export ARCH=arm64
##################################开始编译####################################
make rockchip_linux_defconfig
#################################启动menuconfig##############################
make menuconfig
```

![image-20250718171315706](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718171315706.png)

5、在menuconfig保存后，将会更新.config文件，查看.config，符合预期。

![image-20250718171401888](02%20Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97.assets/image-20250718171401888.png)

6、最后`cp .config arch/arm64/configs/rockchip_linux_defconfig `覆盖掉原有的`rockchip_linux_defconfig `,最终内核编译会使用你修改的内容。
