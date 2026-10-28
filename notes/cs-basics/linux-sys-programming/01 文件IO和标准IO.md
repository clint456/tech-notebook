# 文件IO和标准IO

- 文件UI是LInux系统提供的接口，针对文件和磁盘进行操作，**不带缓存机制**；

- 标准IO是C语言函数库中的标准IO模型，在`stdio.h`中定义，通过缓存区操作文件，**带缓存机制**。
- Linux系统中一切皆是文件，包括普通文件、目录、设备文件（不包括网络设备），管道、FIFO队列、socket套接字等，在终端输入`ls -l`即可查看文件类型和权限。

## 标准IO和文件IO常用API

| 操作      | 标准IO | 文件IO |
| --------- | ------ | ------ |
| 打开/创建 | fopen  | open   |
| 读  | getc、fgetc、getchar、fgets、gets、fread | read|
| 写 | putc、fputc、putc、fputs、puts、fwrite | write |
| 关闭 | fclose | close |

## 标准IO和文件IO的区别

- 标准IO是c语言库函数中的一个API操作，底层是封装了系统调用操作，头文件是`stdio.h`；
- 文件IO是直接操作系统调用函数，头文件是`unistd.h`;

![image-20250713212101873](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8%E6%96%87%E4%BB%B6IO%E4%B8%8E%E6%A0%87%E5%87%86IO.png)



1. ## 文件IO `open()`

   

2. ## 文件IO `close()`

3. ## 文件IO`read()`

4. ## 文件IO `write()`

5. ## 文件IO`lseek()`

![image-20250713212633943](https://raw.githubusercontent.com/clint456/PicGo/main/Linux%E9%A9%B1%E5%8A%A8%E6%96%87%E4%BB%B6IO%20lseek().png)

#### 函数定义 

lseek() : 移动文件的读写位置





