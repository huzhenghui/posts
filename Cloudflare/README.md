---
title: 在Cloudflare Pages上发布GitHub中基于Hugo的静态网站
date: 2023-01-23
publishdate: 2023-01-23
---

<!-- markdownlint-disable-next-line MD025 -->
# 在`Cloudflare Pages`上发布`GitHub`中基于`Hugo`的静态网站

## 目录

- [在`Cloudflare Pages`上发布`GitHub`中基于`Hugo`的静态网站](#在cloudflare-pages上发布github中基于hugo的静态网站)
  - [目录](#目录)
  - [简介](#简介)
  - [仓库](#仓库)
    - [`xuekaiyuan-com/xuekaiyuan-com.github.io`仓库](#xuekaiyuan-comxuekaiyuan-comgithubio仓库)
    - [`huzhenghui/posts`仓库](#huzhenghuiposts仓库)
  - [相关仓库结构](#相关仓库结构)
  - [注册`Cloudflare`](#注册cloudflare)
  - [创建站点](#创建站点)
  - [修改构建命令](#修改构建命令)
  - [设置`Hugo`版本](#设置hugo版本)
  - [创建`部署挂钩`](#创建部署挂钩)
  - [设置`Repository secrets`](#设置repository-secrets)
  - [`.github/workflows/cloudflare.yml`](#githubworkflowscloudflareyml)
  - [`Cloudflare/README.md`](#cloudflarereadmemd)

## 简介

本文讲解如何在`Cloudflare Pages`上发布`GitHub`中基于`Hugo`的静态网站。
目前网站已发布在

<https://www.xuekaiyuan.com/>

本文将网站同步发布在

<https://xuekaiyuan.pages.dev/>

本文发表在

<https://www.xuekaiyuan.com/huzhenghui/cloudflare/readme/>

<https://xuekaiyuan.pages.dev/huzhenghui/cloudflare/readme/>

<https://blog.csdn.net/hu_zhenghui/article/details/128752863>

## 仓库

### `xuekaiyuan-com/xuekaiyuan-com.github.io`仓库

仓库位于<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>

相关版本为

[v0.3](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.3)

详见<https://www.xuekaiyuan.com/posts/xuekaiyuan/readme/>

### `huzhenghui/posts`仓库

仓库位于<https://github.com/huzhenghui/posts/>

在[v0.1](https://github.com/huzhenghui/posts/tree/v0.1)中实现了自动触发更新<https://www.xuekaiyuan.com/>

本文将把网站同步发布在

<https://xuekaiyuan.pages.dev/>

相关版本为[v0.2](https://github.com/huzhenghui/posts/tree/v0.2)

## 相关仓库结构

查询命令

```shell
tree -a -F -I '.git/'
```

本文相关文件为

```text
./
├── .github/
│   └── workflows/
│       └── cloudflare.yml
└── Cloudflare/
    └── README.md
```

## 注册`Cloudflare`

访问<http://pages.cloudflare.com/>注册账号，注册后访问控制台页面<https://pages.cloudflare.com/>

## 创建站点

在控制台页面<https://pages.cloudflare.com/>中单击左侧的`Pages`，
单击`创建项目`按钮，按照向导关联`Git`仓库<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>。
预设选择`Hugo`。

## 修改构建命令

按照向导操作后查看设置，可以看到构建命令为

```shell
hugo
```

修改构建命令，输入

```shell
git submodule update --remote;hugo --baseURL 'https://xuekaiyuan.pages.dev'
```

这个命令包含两个子命令，`git submodule update --remote`用于更新子模块，前面
[xuekaiyuan-com/xuekaiyuan-com.github.io的 git submodule（子模块）](https://www.xuekaiyuan.com/huzhenghui/github/readme/#xuekaiyuan-comxuekaiyuan-comgithubio%E7%9A%84-git-submodule%E5%AD%90%E6%A8%A1%E5%9D%97)
将<https://github.com/huzhenghui/posts/>添加为<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>的子模块。
运行`git submodule update --remote`命令将拉取远程的<https://github.com/huzhenghui/posts/>仓库。

第二个子命令为`hugo --baseURL 'https://xuekaiyuan.pages.dev'`，
这是因为仓库<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>中`Hugo`配置文件
<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/master/config.toml>内容为

```toml
baseURL      = 'https://www.xuekaiyuan.com/'
languageCode = 'zh-cn'
title        = '学开源'
```

已经设置`baseURL`值为<https://www.xuekaiyuan.com/>，而`Cloudflare`分配的域名为<https://xuekaiyuan.pages.dev/>，
需要通过命令行设置为该域名。

## 设置`Hugo`版本

查看`hugo`版本

```shell
hugo version
```

结果为

```text
hugo v0.101.0+extended darwin/amd64 BuildDate=unknown
```

在`环境变量`的`制作`中增加环境变量`HUGO_VERSION`，设置为所使用的`hugo`版本`0.101.0`

## 创建`部署挂钩`

为了让仓库<https://github.com/huzhenghui/posts/>更新时能自动触发更新<https://xuekaiyuan.pages.dev/>，
需要在<https://xuekaiyuan.pages.dev/>的设置中创建部署挂钩。

创建后记录部署挂钩的`URL`，前缀为

```text
https://api.cloudflare.com/client/v4/pages/webhooks/deploy_hooks/
```

将在[设置`Repository secrets`](#设置repository-secrets)中使用该值。

## 设置`Repository secrets`

访问仓库<https://github.com/huzhenghui/posts/>的`Repository secrets`设置页面

<https://github.com/huzhenghui/posts/settings/secrets/actions>

在`Repository secrets`中可以看到已经有一项`TRIGGER_XUEKAIYUAN_COM`，
这是在[设置Actions secrets](https://www.xuekaiyuan.com/huzhenghui/github/readme/#%E8%AE%BE%E7%BD%AEactions-secrets)中设置的。

接下来增加一项，名称设置为`TRIGGER_XUEKAIYUAN_PAGES_DEV`，值设置为前面[创建`部署挂钩`](#创建部署挂钩)记录的`URL`。

该设置将在[`.github/workflows/cloudflare.yml`](#githubworkflowscloudflareyml)中使用。

## `.github/workflows/cloudflare.yml`

手工创建，位置在

<https://github.com/huzhenghui/posts/blob/master/.github/workflows/cloudflare.yml>

Since [v0.2](https://github.com/huzhenghui/posts/tree/v0.2)

<https://github.com/huzhenghui/posts/blob/v0.2/.github/workflows/cloudflare.yml>

```yaml
name: Trigger https://xuekaiyuan.pages.dev deploy hook

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Trigger job
  trigger:
    runs-on: ubuntu-latest
    steps:
      - name: POST https://xuekaiyuan.pages.dev deploy hook
        run: |
          curl \
            -X POST \
            "${{ secrets.TRIGGER_XUEKAIYUAN_PAGES_DEV }}"
```

其中`on`为`GitHub Action`响应的事件。

- 响应`master`分支的`push`
- 响应<https://github.com/huzhenghui/posts/actions>页面中手工触发

```yaml
on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:
```

其中`defaults`设置了默认环境，这里默认使用`bash`运行。

```yaml
# Default to bash
defaults:
  run:
    shell: bash
```

在`jobs`中为运行的任务。

```yaml
jobs:
  # Trigger job
  trigger:
    runs-on: ubuntu-latest
    steps:
      - name: POST https://xuekaiyuan.pages.dev deploy hook
        run: |
          curl \
            -X POST \
            "${{ secrets.TRIGGER_XUEKAIYUAN_PAGES_DEV }}"
```

其中只有一个任务`trigger`，
任务中只有一个步骤`POST https://xuekaiyuan.pages.dev deploy hook`
运行的命令为

```yaml
        run: |
          curl \
            -X POST \
            "${{ secrets.TRIGGER_XUEKAIYUAN_PAGES_DEV }}"
```

其中`${{ secrets.TRIGGER_XUEKAIYUAN_PAGES_DEV }}`为[设置`Repository secrets`](#设置repository-secrets)中设置的值。

## `Cloudflare/README.md`

本文件，位置在<https://github.com/huzhenghui/posts/blob/v0.2/Cloudflare/README.md>

Since [v0.2](https://github.com/huzhenghui/posts/tree/v0.2)

<https://github.com/huzhenghui/posts/blob/v0.2/Cloudflare/README.md>
