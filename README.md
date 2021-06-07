# syn-sys

本仓库的存在是为了将 `syn-sys`  部署到 docker 中。

## 使用指南

> 如果需要部署到 arm64 服务器中，请先切换到 `arm64` 分支。

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