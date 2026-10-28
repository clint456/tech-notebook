> [基础系统配置](https://zhuanlan.zhihu.com/p/358975333)
>

# 系统安装
## 启动盘制作
官网下载[https://manjaro.org/](https://manjaro.org/)，利用软碟通/rufus等工具制作镜像，(软碟通注意选择Raw模式生成)

---

## pacman命令使用
![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1713080395506-8aa2cdb8-893a-4e2a-89ea-1d6039db9cbd.png)

### 系统更新
在Archlinux中，使用一条命令即可对整个系统进行更新

`pacman -Syu`

如果您已经使用pacman -Sy 将本地的包数据库与远程的仓库进行辽同步，也可以只是用

` pacman -Su` 



### 安装包
+ `pacman -S <package name>`  安装包，也可以安装多个包，以空格符号分开
+ `pacman -Sy <package name> `将在同步包数据库后再执行安装
+ `pacman -Sv <package name>`显示操作信息安装
+ `pacman -U`安装本地包，其扩展名一般为`pkg.tar.gz`



---

## 系统初始配置
### 换源：
```plain
sudo pacman-mirrors -i -c China -m rank
```

选择延迟小的服务器



### 更新系统
```plain
sudo pacman -Syyu 
sudo pacman -S base-devel vim  #安装vim
```





