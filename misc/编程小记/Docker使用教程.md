[1. Docker - 快速通关 （3h）](https://www.yuque.com/leifengyang/sutong/au0lv3sv3eldsmn8)



# 一、基础命令使用
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742304484823-56134093-181d-4a76-91e8-bc039eceb3bf.png)

## 1、 理解容器
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742288351434-3395f748-ebd5-472b-bcf5-6c6b15e4a797.png)



+ 容器类似轻量级的 VM
+ 容器共享操作系统内核
+ 容器拥有自己的文件系统、CPU、内存、进程空间
+ 容器之间相互隔离

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742288518381-db8fe978-739a-4303-9190-4bf5722e2533.png)



## 2、docker 安装
参考官网

```bash
# 移除旧版本docker
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

# 配置docker yum源。
sudo yum install -y yum-utils
sudo yum-config-manager \
--add-repo \
http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


# 安装 最新 docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动& 开机启动docker； enable + start 二合一
systemctl enable docker --now

# 配置加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://mirror.ccs.tencentyun.com",
        "https://docker.m.daocloud.io"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 3、常用命令
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742290852290-8e217ee9-963c-4e3a-941d-78d807326428.png)



```plain
#查看运行中的容器
docker ps
#查看所有容器
docker ps -a
#搜索镜像
docker search nginx
#下载镜像
docker pull nginx
#下载指定版本镜像
docker pull nginx:1.26.0
#查看所有镜像
docker images
#删除指定id的镜像
docker rmi e784f4560448


#运行一个新容器
docker run nginx
#停止容器
docker stop keen_blackwell
#启动容器
docker start 592
#重启容器
docker restart 592
#查看容器资源占用情况
docker stats 592
#查看容器日志
docker logs 592
#删除指定容器
docker rm 592
#强制删除指定容器
docker rm -f 592
# 后台启动容器
docker run -d --name mynginx nginx
# 后台启动并暴露端口
docker run -d --name mynginx -p 80:80 nginx
# 进入容器内部
docker exec -it mynginx /bin/bash

# 提交容器变化打成一个新的镜像
docker commit -m "update index.html" mynginx mynginx:v1.0
# 保存镜像为指定文件
docker save -o mynginx.tar mynginx:v1.0
# 删除多个镜像
docker rmi bde7d154a67f 94543a6c1aef e784f4560448
# 加载镜像
docker load -i mynginx.tar 


# 登录 docker hub
docker login
# 重新给镜像打标签
docker tag mynginx:v1.0 leifengyang/mynginx:v1.0
# 推送镜像
docker push leifengyang/mynginx:v1.0
```

## 4、容器操作
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742298553610-3892e2f6-a684-479f-8b07-280421d28a16.png)



## 5、run 细节
### 端口映射
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742300379587-af21d528-78e0-4466-a31d-2a3841f7c63a.png)

希望能够通过浏览器访问内部容器里的 nginx，就需要将容器的端口映射到宿主机的端口上

```bash
docker run -d --name mynginx -p 80:80 nginx
```

宿主机端口与容器端口细节

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742300857154-abfba62e-d41c-4b19-96ce-ac10839ff2e9.png)

> 80 可以重复，88 不可以重复；
>
> 宿主机只有一个，对应端口 88 也只有一个；
>
> 容器是在宿主机中，每个容器都可以使用 80，只不过使用的时候端口映射不同就可以！
>

### 进入容器操作
#### 进入
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301161916-652138b6-b0e1-42db-b06d-07d96a0e5c7f.png)

#### 修改
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301350682-40732178-f59b-46e4-bfee-a8fd104ca8fd.png)

#### 效果
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301364133-b8fec324-5d70-4cd8-a91a-78b072bc95f0.png)

#### exit 退出容器
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301520785-489da267-ced5-4284-9351-09761de38202.png)

## 6、保存镜像
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301797635-dbb163bd-b8e0-474d-80d6-6c5f0ab82cd9.png)



### 提交
> 将修改好的容器提交为一个镜像 images
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301826883-5fff8320-b444-45db-8619-39f6c2cd8678.png)

测试

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301879295-26b3aec7-58a3-4d6c-82c8-b835f02ab862.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301887394-ea9de89b-0550-407d-9b3d-efd53eaf59e4.png)



### 保存
> 将镜像保存
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742301921702-f363dee1-0e96-4feb-b859-9f5eb0062832.png)

测试

> 将镜像保存为一个 tar 包
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742302075977-c6ba4b53-a98c-4aa8-ad02-034d9b043608.png)

### 加载
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742302313000-6ee2ee45-492b-474c-bae5-fc85909940c7.png)

将 save 的压缩包转为可用容器

测试

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742302449677-7def7422-f55e-4064-b5fc-70b3e895f04e.png)

## 7、分享社区
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742302677650-620f6209-b2c6-4238-8c47-8136d44ab12f.png)

### login 登陆命令
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303039568-43170976-90cb-40af-88ef-6f34c3f867ce.png)

测试登陆

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303021326-ea28278d-a70d-4d45-919b-24780c7f13b4.png)



### tag 改名命令
> 名字需要符合 dockerhub 的格式，需要修改名字
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303248312-f72ba40a-a319-4c7a-8a55-ab5219009b4c.png)



### push 推送命令
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303368177-8547da5c-6a49-4fde-ae5f-7f8b17b02ea7.png)

测试

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303532232-7851abb8-e310-4bd2-bda5-d5224f1d1e3b.png)

修改 tag 后测试

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303590862-86ba6dcf-2dd2-4621-965e-b08c43fd4636.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303597907-a0967a55-c7f6-40b9-8449-f38ad5df1db7.png)

成功推送



### 写一个 overview
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303739705-ca25f125-b929-4406-a6e1-dd79a9d0a914.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742303777318-054a831a-badd-40f3-9cc5-1610e27768ec.png)



### 防止 pull 的时候不带标签
> 将最新版的镜像修改 tag 为 clinton/[ 包 ]:latest
>
> 然后推送，pull 的时候不带标签会默认下载 latest 版本
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742304319923-eec32302-0ee8-41d4-962e-73f9ddfe8c01.png)



## 小结：
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742304508665-f8134938-7b82-493b-8520-676afd6ac9ac.png)

## 补充
### 1、容器名不能重复
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742304768898-2521bc73-8d28-4897-abbf-b81be6c7ebff.png)

### 2、 防火墙入站规则修改
如果访问除 `22`和 `80`以为的端口时，记得去服务器的防火墙中的入站规则中进行修改。



# 二、高级技巧
## docker 存储
> 掌握目录挂载、数据卷、让容器数据不再丢失
>

### 容器内部数据有两大难题：
+ 不容易修改

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742306618949-4b40f31c-324c-42b0-8f61-ffe7801f6f20.png)

+ 容器出现崩溃后，数据丢失

> 容器删除后，数据就没有了
>



### 1、目录挂载
> 容器外修改，容器内也会相应修改
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742306859597-7b1e534e-1baa-44d9-a122-482819194b5d.png)

```shell
docker run -d -p 80:80 -v /app/nghtml:/usr/share//nginx/html --name app01 nginx
```

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742307106481-a908e74f-4435-4760-9fd3-be2c280f9397.png)



就算容器被删除，外部挂载目录依然在，数据得到保护

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742307393791-80160d1f-a9f9-4fed-8433-816d3ca1b2fd.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742307544693-63aa0d76-d162-4265-9498-26eb6411842c.png)



在容器外部修改效果相同

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742307759636-32993a20-05a5-4534-8e97-3c30d49b0064.png)



### 2、卷映射
> 希望能够修改配置文件，尝试使用目录挂载方式
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742312749523-212b9466-03eb-41f5-9698-34e7757865c8.png)

> 一般来说 容器进行配置时，会先读取外部的挂载，但是如果使用目录挂载的话，会先访问外部的，导致内部的容器缺乏配置文件导致无法启动
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742313532460-718b3c0f-a576-4255-adb5-7eaf8367635f.png)

> 但是我好像成功了
>
> ![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742313559501-28a5743f-2ea5-4a78-aa2a-3af0a561ec72.png)
>



所以就需要用到卷映射

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742313935902-8d97c121-b1be-4f3c-af6c-d058ee20c41d.png)

测试

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314009460-27a20c9c-dd1a-43bc-b9c9-db1c20b3c2de.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314319641-59a4a48f-153a-4d76-aaee-95aa0f80a6c5.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314327135-5b49a943-f6ad-491e-8300-282c4d793ac2.png)



#### docker volume 相关操作
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314559854-bcff17c8-3278-4ffc-a8ab-795202d2dc8c.png)



### 批量操作容器小技巧
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742306362239-07f3c48e-5cad-421a-988c-1cf5386b7928.png)



## docker 网络
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314747429-8b099491-7b9c-49e6-b327-3435710761c8.png)

绕远了，容器 1->宿主机->容器 2

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314804281-53503711-3f7c-4d08-8860-50bea43b7af6.png)

### docker 网络机制
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314847998-3ce17e20-f328-4ecb-9c18-5d6104ed4d97.png)

查看 app01 容器网络地址

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742314970928-2d7794a4-2841-4a06-95b7-bd5f895917d9.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315036608-90cdbf5a-1e6c-48ab-a109-bef34004eead.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315174470-8d1039fe-09bc-4f73-8182-86ac49fb85cf.png)



### 创建 docker 自定义网络
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315266290-c288a261-388a-40d9-ad79-f71381aeb283.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315336767-6166970d-02fc-4192-bea1-f159ca16e6a6.png)

app1 加入 mynet 网络

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315441194-ba2ca23a-6b81-4cb9-8510-60f542449e36.png)

app2 加入 mynet 网络

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315488159-bb93c0f8-5fe0-4e96-ba5c-f018f4dacc23.png)

通过容器名可以直接互相访问

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742315568035-bdbeb201-ef61-4323-aa84-2fd04b928d6d.png)

docker 允许自定义网络，并让容器加入该网络



### Redis 主从同步网络集群
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742316187689-9af9e3df-a069-4130-813f-10a39536f32c.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742316374837-907daa4e-a32e-465a-9f1f-618171aa61c6.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742316685426-7fdf544a-3fec-4653-a020-7a060f1b8495.png)



![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742316509607-0f5d32c5-a71b-49f7-af22-a708287fc947.png)



## 最佳实践——MySql
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742316848403-4bcb871d-56aa-42f9-a5e6-c478d7f9677a.png)



> 在 docker hub 上找到一个新的 images 时，首先关注三点
>
> + 网络：端口如何映射等
> + 存储：配置文件、启动文件、数据文件进行目录挂载或者卷映射
> + 环境变量：镜像会提供一些环境变量选择
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742346971730-03fecf88-a9f3-4874-abca-bd95cd0188e0.png)

---

## docker Compose
> 进行批量管理容器
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742347412260-0f209419-9276-4384-851d-f8a86e4e3c02.png)

以前的做法：

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742347535683-2ccb42c5-6714-49c9-af75-230eb35247c2.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742347681869-cce6bed2-8081-4283-b135-29cd876b9a40.png)

### 语法
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742347956252-286df86a-6d79-4428-a806-cccf7d9bc3c8.png)

[Services top-level elements](https://docs.docker.com/reference/compose-file/services/) 参考官方文档进行编写



```shell
name: myblog
services:
  mysql:
    container_name: mysql
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_DATABASE=wordpress
    volumes:
      - mysql-data:/var/lib/mysql
      - /app/myconf:/etc/mysql/conf.d
    restart: always
    networks:
      - blog

  wordpress:
    image: wordpress
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: 123456
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress:/var/www/html
    restart: always
    networks:
      - blog
    depends_on: # 先启动数据库，在启动wordpress
      - mysql

# 卷映射需要在外部声明
volumes:
  mysql-data:
  wordpress:
  
# 网络需要在外部声明
networks:
  blog:
```

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742348973791-a35b6b07-e6ec-40a6-9a8b-58a72c4ee4b2.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742349094484-b72fefc4-e80e-4ae8-a0ee-bcd4ec5792fd.png)

### 特性
+ 增量更新
    - 修改 Docker Compose 文件。重新启动应用。只会触发修改项的重新启动。
+ 数据不删
    - 默认就算down了容器，所有挂载的卷不会被移除。比较安全



---

## Dockerfile 
### 1、 制作镜像
> 构建自定义镜像
>

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742350116796-eff61a66-0699-40fc-9d1f-38d5b6ecbf56.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742350141401-938f065e-ed0d-4eff-bc28-0ee9e7ec8cf2.png)

详细参考[Dockerfile reference](https://docs.docker.com/reference/dockerfile/)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352020060-ca195509-2acd-477e-ba4e-2c5ba0ccd507.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742351902722-b99219de-54f7-4ebd-9c55-ee5c3e778fc4.png)

构建成功

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352060419-e72f0f3e-063f-4166-a8f8-8be4046b3561.png)

启动成功

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352273679-20c934d3-fe79-40f2-996d-d986157244e0.png)



### 2、镜像分层存储机制
![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352976739-cc17e62f-5c02-4634-b5b8-74faf6716b8d.png)

> 每一行指令就会产生一个存储层。
>
> 
>

举个栗子：

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742353033746-feaa7874-8c38-4d4f-a5ae-021fa47f5d80.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352662977-c50364c2-c814-4851-b7a5-b0c1a9dab578.png)

> docker images inspect [imges]
>

![R/W layer：可读写层](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352773823-9365b661-5e26-46f1-a46f-90ceee49329f.png)

> 可读写层当容器删除后，他也会随之删除
>
> 所以推荐数据挂载到外部
>



![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352786681-f080dd86-c927-4753-8edf-7118f8d1b434.png)

![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742352944480-5d70f6b7-8b24-4a1e-96f1-a0cff3db980f.png)



# 三、一键启动所有中间件


![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1742353353392-500fd720-8ffa-43de-9ffa-64cbf1310226.png)

```shell
#Disable memory paging and swapping performance
sudo swapoff -a

# Edit the sysctl config file
sudo vi /etc/sysctl.conf

# Add a line to define the desired value
# or change the value if the key exists,
# and then save your changes.
vm.max_map_count=262144

# Reload the kernel parameters using sysctl
sudo sysctl -p

# Verify that the change was applied by checking the value
cat /proc/sys/vm/max_map_count
```

## yaml
> 注意：
>
> + 将下面文件中 `kafka` 的  `<font style="color:rgb(0, 0, 0);background-color:rgb(242, 244, 248);">119.45.147.122</font>` 改为你自己的服务器IP。
> + 所有容器都做了时间同步，这样容器的时间和linux主机的时间就一致了
>
> 准备一个 `compose.yaml`文件，内容如下：
>

```yaml
name: devsoft
services:
  redis:
    image: bitnami/redis:latest
    restart: always
    container_name: redis
    environment:
      - REDIS_PASSWORD=123456
    ports:
      - '6379:6379'
    volumes:
      - redis-data:/bitnami/redis/data
      - redis-conf:/opt/bitnami/redis/mounted-etc
      - /etc/localtime:/etc/localtime:ro

  mysql:
    image: mysql:8.0.31
    restart: always
    container_name: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    ports:
      - '3306:3306'
      - '33060:33060'
    volumes:
      - mysql-conf:/etc/mysql/conf.d
      - mysql-data:/var/lib/mysql
      - /etc/localtime:/etc/localtime:ro

  rabbit:
    image: rabbitmq:3-management
    restart: always
    container_name: rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=rabbit
      - RABBITMQ_DEFAULT_PASS=rabbit
      - RABBITMQ_DEFAULT_VHOST=dev
    volumes:
      - rabbit-data:/var/lib/rabbitmq
      - rabbit-app:/etc/rabbitmq
      - /etc/localtime:/etc/localtime:ro
  opensearch-node1:
    image: opensearchproject/opensearch:2.13.0
    container_name: opensearch-node1
    environment:
      - cluster.name=opensearch-cluster # Name the cluster
      - node.name=opensearch-node1 # Name the node that will run in this container
      - discovery.seed_hosts=opensearch-node1,opensearch-node2 # Nodes to look for when discovering the cluster
      - cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2 # Nodes eligibile to serve as cluster manager
      - bootstrap.memory_lock=true # Disable JVM heap memory swapping
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m" # Set min and max JVM heap sizes to at least 50% of system RAM
      - "DISABLE_INSTALL_DEMO_CONFIG=true" # Prevents execution of bundled demo script which installs demo certificates and security configurations to OpenSearch
      - "DISABLE_SECURITY_PLUGIN=true" # Disables Security plugin
    ulimits:
      memlock:
        soft: -1 # Set memlock to unlimited (no soft or hard limit)
        hard: -1
      nofile:
        soft: 65536 # Maximum number of open files for the opensearch user - set to at least 65536
        hard: 65536
    volumes:
      - opensearch-data1:/usr/share/opensearch/data # Creates volume called opensearch-data1 and mounts it to the container
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 9200:9200 # REST API
      - 9600:9600 # Performance Analyzer

  opensearch-node2:
    image: opensearchproject/opensearch:2.13.0
    container_name: opensearch-node2
    environment:
      - cluster.name=opensearch-cluster # Name the cluster
      - node.name=opensearch-node2 # Name the node that will run in this container
      - discovery.seed_hosts=opensearch-node1,opensearch-node2 # Nodes to look for when discovering the cluster
      - cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2 # Nodes eligibile to serve as cluster manager
      - bootstrap.memory_lock=true # Disable JVM heap memory swapping
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m" # Set min and max JVM heap sizes to at least 50% of system RAM
      - "DISABLE_INSTALL_DEMO_CONFIG=true" # Prevents execution of bundled demo script which installs demo certificates and security configurations to OpenSearch
      - "DISABLE_SECURITY_PLUGIN=true" # Disables Security plugin
    ulimits:
      memlock:
        soft: -1 # Set memlock to unlimited (no soft or hard limit)
        hard: -1
      nofile:
        soft: 65536 # Maximum number of open files for the opensearch user - set to at least 65536
        hard: 65536
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - opensearch-data2:/usr/share/opensearch/data # Creates volume called opensearch-data2 and mounts it to the container

  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:2.13.0
    container_name: opensearch-dashboards
    ports:
      - 5601:5601 # Map host port 5601 to container port 5601
    expose:
      - "5601" # Expose port 5601 for web access to OpenSearch Dashboards
    environment:
      - 'OPENSEARCH_HOSTS=["http://opensearch-node1:9200","http://opensearch-node2:9200"]'
      - "DISABLE_SECURITY_DASHBOARDS_PLUGIN=true" # disables security dashboards plugin in OpenSearch Dashboards
    volumes:
      - /etc/localtime:/etc/localtime:ro
  zookeeper:
    image: bitnami/zookeeper:3.9
    container_name: zookeeper
    restart: always
    ports:
      - "2181:2181"
    volumes:
      - "zookeeper_data:/bitnami"
      - /etc/localtime:/etc/localtime:ro
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes

  kafka:
    image: 'bitnami/kafka:3.4'
    container_name: kafka
    restart: always
    hostname: kafka
    ports:
      - '9092:9092'
      - '9094:9094'
    environment:
      - KAFKA_CFG_NODE_ID=0
      - KAFKA_CFG_PROCESS_ROLES=controller,broker
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093,EXTERNAL://0.0.0.0:9094
      - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,EXTERNAL://119.45.147.122:9094
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@kafka:9093
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - ALLOW_PLAINTEXT_LISTENER=yes
      - "KAFKA_HEAP_OPTS=-Xmx512m -Xms512m"
    volumes:
      - kafka-conf:/bitnami/kafka/config
      - kafka-data:/bitnami/kafka/data
      - /etc/localtime:/etc/localtime:ro
  kafka-ui:
    container_name: kafka-ui
    image: provectuslabs/kafka-ui:latest
    restart: always
    ports:
      - 8080:8080
    environment:
      DYNAMIC_CONFIG_ENABLED: true
      KAFKA_CLUSTERS_0_NAME: kafka-dev
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:9092
    volumes:
      - kafkaui-app:/etc/kafkaui
      - /etc/localtime:/etc/localtime:ro

  nacos:
    image: nacos/nacos-server:v2.3.1
    container_name: nacos
    ports:
      - 8848:8848
      - 9848:9848
    environment:
      - PREFER_HOST_MODE=hostname
      - MODE=standalone
      - JVM_XMX=512m
      - JVM_XMS=512m
      - SPRING_DATASOURCE_PLATFORM=mysql
      - MYSQL_SERVICE_HOST=nacos-mysql
      - MYSQL_SERVICE_DB_NAME=nacos_devtest
      - MYSQL_SERVICE_PORT=3306
      - MYSQL_SERVICE_USER=nacos
      - MYSQL_SERVICE_PASSWORD=nacos
      - MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
      - NACOS_AUTH_IDENTITY_KEY=2222
      - NACOS_AUTH_IDENTITY_VALUE=2xxx
      - NACOS_AUTH_TOKEN=SecretKey012345678901234567890123456789012345678901234567890123456789
      - NACOS_AUTH_ENABLE=true
    volumes:
      - /app/nacos/standalone-logs/:/home/nacos/logs
      - /etc/localtime:/etc/localtime:ro
    depends_on:
      nacos-mysql:
        condition: service_healthy
  nacos-mysql:
    container_name: nacos-mysql
    build:
      context: .
      dockerfile_inline: |
        FROM mysql:8.0.31
        ADD https://raw.githubusercontent.com/alibaba/nacos/2.3.2/distribution/conf/mysql-schema.sql /docker-entrypoint-initdb.d/nacos-mysql.sql
        RUN chown -R mysql:mysql /docker-entrypoint-initdb.d/nacos-mysql.sql
        EXPOSE 3306
        CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]
    image: nacos/mysql:8.0.30
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=nacos_devtest
      - MYSQL_USER=nacos
      - MYSQL_PASSWORD=nacos
      - LANG=C.UTF-8
    volumes:
      - nacos-mysqldata:/var/lib/mysql
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "13306:3306"
    healthcheck:
      test: [ "CMD", "mysqladmin" ,"ping", "-h", "localhost" ]
      interval: 5s
      timeout: 10s
      retries: 10
  prometheus:
    image: prom/prometheus:v2.52.0
    container_name: prometheus
    restart: always
    ports:
      - 9090:9090
    volumes:
      - prometheus-data:/prometheus
      - prometheus-conf:/etc/prometheus
      - /etc/localtime:/etc/localtime:ro

  grafana:
    image: grafana/grafana:10.4.2
    container_name: grafana
    restart: always
    ports:
      - 3000:3000
    volumes:
      - grafana-data:/var/lib/grafana
      - /etc/localtime:/etc/localtime:ro

volumes:
  redis-data:
  redis-conf:
  mysql-conf:
  mysql-data:
  rabbit-data:
  rabbit-app:
  opensearch-data1:
  opensearch-data2:
  nacos-mysqldata:
  zookeeper_data:
  kafka-conf:
  kafka-data:
  kafkaui-app:
  prometheus-data:
  prometheus-conf:
  grafana-data:
```



## 启动
```shell
# 在 compose.yaml 文件所在的目录下执行
docker compose up -d
# 等待启动所有容器
```



> tip：如果重启了服务器，可能有些容器会启动失败。再执行一遍 `docker compose up -d`即可。所有程序都可运行成功，并且不会丢失数据。请放心使用。
>

## 访问
+ zookeeper可视化工具下载：
    - [https://github.com/vran-dev/PrettyZoo/releases/download/v2.1.1/prettyZoo-win.zip](https://github.com/vran-dev/PrettyZoo/releases/download/v2.1.1/prettyZoo-win.zip)
+ redis可视化工具下载：
    - [https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v1.6.4/Another-Redis-Desktop-Manager.1.6.4.exe](https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v1.6.4/Another-Redis-Desktop-Manager.1.6.4.exe)

| 组件（容器名） | 介绍 | 访问地址 | 账号/密码 | 特性 |
| --- | --- | --- | --- | --- |
| Redis(redis) | k-v 库 | 你的ip:6379 | 单密码模式：123456 | 已开启AOF |
| MySQL(mysql) | 数据库 | 你的ip:3306 | root/123456 | 默认utf8mb4字符集 |
| Rabbit(rabbit) | 消息队列 | 你的ip:15672 | rabbit/rabbit | 暴露5672和15672端口 |
| OpenSearch(opensearch-node1/2) | 检索引擎 | 你的ip:9200 |  | 内存512mb；两个节点 |
| opensearch-dashboards | search可视化 | 你的ip:5601 |  |  |
| Zookeeper(zookeeper) | 分布式协调 | 你的ip:2181 |  | 允许匿名登录 |
| kafka(kafka) | 消息队列 | 你的ip:9092   外部访问:9094 |  | 占用内存512mb |
| kafka-ui(kafka-ui) | kafka可视化 | 你的ip:8080 |  |  |
| nacos(nacos) | 注册/配置中心 | 你的ip:8848 | nacos/nacos | 持久化数据到MySQL |
| nacos-mysql(nacos-mysql) | nacos配套数据库 | 你的ip:13306 | root/root |  |
| prometheus(prometheus) | 时序数据库 | 你的ip:9090 |  |  |
| grafana(grafana) |  | 你的ip:3000 | admin/admin |  |
|  |  |  |  |  |


