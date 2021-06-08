# syn-sys

本仓库的存在是为了将 `syn-sys`  部署到 docker 中。

## 使用指南

> 如果需要部署到 arm64 服务器中，请先切换到 `arm64` 分支，并阅读《[可能存在的问题](#可能存在的问题)》。

### 部署前的准备

* 一台运行 Linux 的服务器
* `backend` 文件夹所在仓库的访问权限
* 参照《[Get Docker](https://docs.docker.com/get-docker/)》， 安装好 Docker 等必须的软件

### 开始部署

```bash
# 先下载本仓库以及子模块
git clone --recurse-submodules git@github.com:JUST-NC/syn-sys.git
# 再移动到仓库所在文件夹内
cd syn-sys
# 最后运行 docker-compose
sudo DOCKER_BUILDKIT=1 docker-compose up -d
```

## 可能存在的问题

### Service 'ruoyi-be' failed to build: the --mount option requires BuildKit. 

一种可能是服务器中的 Docker 版本太老了，因为按照官方文档描述， `BuildKit` 存在于 Docker 18.09 及以上的版本。如果你有权限更新 Docker 的话，可以先尝试更新 Docker（不知道怎么更新请去读官方文档）。如果没有办法更新的话，请在本地的 [be.Dockerfile](./be.Dockerfile) 中，找到 `--mount=type=cache,target=/root/.m2`，并删去它。

另一种可能是你在使用 arm64 服务器，我本地测试时使用的一个开发板就存在这个问题。我的开发板安装的 Docker 似乎缺少 BuildKit ——尝试过《[Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/)》中所有启用 BuildKit 的方法都不管用。这种情况请参照上方说明，删除 `--mount=type=cache,target=/root/.m2`。

删除的操作，唯一带来的不良影响是每次构建都需要重新下载依赖，导致等待时间变长。

**删除的例子：**

```diff
# be.Dockerfile
- RUN --mount=type=cache,target=/root/.m2 mvn clean install && mvn clean package -f ruoyi-admin/pom.xml
+ RUN mvn clean install && mvn clean package -f ruoyi-admin/pom.xml
```

### 后端不断重启

这应该是内存不足……本地测试时使用的那个开发板就因为只有 1G 的内存出现了这个问题。可以尝试在本地的 [be.Dockerfile](./be.Dockerfile) 中，修改 `CMD` 中的参数，减少内存分配，应该能解决这个问题。实际部署到学校的服务器上，应该是没有这个问题的——总不可能给你这么小的内存吧……

**例子：**

```diff
# be.Dockerfile
- CMD ["java", "-jar", "-Duser.timezone=Asia/Shanghai", "-Xms256m", "-Xmx1024m", "-XX:MetaspaceSize=128m", "-XX:MaxMetaspaceSize=512m", "/app/ruoyi-admin.jar"]
+ CMD ["java", "-jar", "-Duser.timezone=Asia/Shanghai", "-Xms128m", "-Xmx512m", "-XX:MetaspaceSize=128m", "-XX:MaxMetaspaceSize=512m", "/app/ruoyi-admin.jar"]
```