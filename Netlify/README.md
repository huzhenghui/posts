---
title: 在Netlify上发布GitHub中基于Hugo的静态网站
date: 2023-01-24
publishdate: 2023-01-24
---

<!-- markdownlint-disable-next-line MD025 -->
# 在`Netlify`上发布`GitHub`中基于`Hugo`的静态网站

## 目录

- [在`Netlify`上发布`GitHub`中基于`Hugo`的静态网站](#在netlify上发布github中基于hugo的静态网站)
    - [目录](#目录)
    - [简介](#简介)
    - [仓库](#仓库)
        - [`xuekaiyuan-com/xuekaiyuan-com.github.io`仓库](#xuekaiyuan-comxuekaiyuan-comgithubio仓库)
        - [`huzhenghui/posts`仓库](#huzhenghuiposts仓库)
    - [相关仓库结构](#相关仓库结构)
    - [注册`Netlify`](#注册netlify)
    - [创建站点](#创建站点)
    - [设置站点地址](#设置站点地址)
    - [修改构建命令](#修改构建命令)
    - [创建`部署挂钩`](#创建部署挂钩)
    - [设置`Repository secrets`](#设置repository-secrets)
    - [`.github/workflows/netlify.yml`](#githubworkflowsnetlifyyml)
    - [`Netlify/README.md`](#netlifyreadmemd)

## 简介

本文讲解如何在`Netlify`上发布`GitHub`中基于`Hugo`的静态网站。
目前网站已发布在

<https://www.xuekaiyuan.com/>

已经同步发布在

<https://xuekaiyuan.pages.dev/>

本文将网站同步发布在

<https://xuekaiyuan.netlify.app>

本文发表在

<https://www.xuekaiyuan.com/huzhenghui/netlify/readme/>

<https://xuekaiyuan.pages.dev/huzhenghui/netlify/readme/>

<https://xuekaiyuan.netlify.app/huzhenghui/netlify/readme/>

<https://blog.csdn.net/hu_zhenghui/article/details/128756035>

## 仓库

### `xuekaiyuan-com/xuekaiyuan-com.github.io`仓库

仓库位于<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>

相关版本为

[v0.3](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.3)

详见<https://www.xuekaiyuan.com/posts/xuekaiyuan/readme/>

### `huzhenghui/posts`仓库

仓库位于<https://github.com/huzhenghui/posts/>

- [v0.1](https://github.com/huzhenghui/posts/tree/v0.1)
    - 实现了自动触发更新<https://www.xuekaiyuan.com/>

- [v0.2](https://github.com/huzhenghui/posts/tree/v0.2)
    - 网站同步发布在<https://xuekaiyuan.pages.dev/>

本文将把网站同步发布在

<https://xuekaiyuan.netlify.app/>

相关版本为<https://github.com/huzhenghui/posts/tree/v0.3>

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
│       └── netlify.yml
└── Netlify/
    └── README.md
```

## 注册`Netlify`

访问<https://app.netlify.com/>注册账号，注册后访问控制台页面<https://app.netlify.com/>

## 创建站点

在控制台页面<https://app.netlify.com/>选择`Sites`。
单击`Add new site`按钮，按照向导关联`Git`仓库<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>。

## 设置站点地址

创建后访问站点设置，选择`Site settings`，选择`Site details`，
在`Site information`中单击`Change site name`，设置`Site name`为`xuekaiyuan`，可以看到网站地址为

<https://xuekaiyuan.netlify.app/>

此时站点设置页面的地址也变为

<https://app.netlify.com/sites/xuekaiyuan/settings/general>

## 修改构建命令

进入`Build & deploy`设置页面

<https://app.netlify.com/sites/xuekaiyuan/settings/deploys>

在`build settings`中单击`Edit settings`，在`Build command`中输入

```bash
git submodule update --remote;hugo --baseURL 'https://xuekaiyuan.netlify.app'
```

这个命令包含两个子命令，`git submodule update --remote`用于更新子模块，前面
[xuekaiyuan-com/xuekaiyuan-com.github.io的 git submodule（子模块）](https://www.xuekaiyuan.com/huzhenghui/github/readme/#xuekaiyuan-comxuekaiyuan-comgithubio%E7%9A%84-git-submodule%E5%AD%90%E6%A8%A1%E5%9D%97)
将<https://github.com/huzhenghui/posts/>添加为<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>的子模块。
运行`git submodule update --remote`命令将拉取远程的<https://github.com/huzhenghui/posts/>仓库。

第二个子命令为`hugo --baseURL 'https://xuekaiyuan.netlify.app'`，
这是因为仓库<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>中`Hugo`配置文件
<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/master/config.toml>内容为

```toml
baseURL      = 'https://www.xuekaiyuan.com/'
languageCode = 'zh-cn'
title        = '学开源'
```

已经设置`baseURL`值为<https://www.xuekaiyuan.com/>，而`Netlify`分配的域名为<https://xuekaiyuan.netlify.app/>，
需要通过命令行设置为该域名。

## 创建`部署挂钩`

为了让仓库<https://github.com/huzhenghui/posts/>更新时能自动触发更新<https://xuekaiyuan.netlify.app/>，
需要在<https://xuekaiyuan.netlify.app/>的设置中创建部署挂钩，
在`Build hooks`中单击`Add build hook`，创建后记录部署挂钩的`URL`，前缀为

```text
https://api.netlify.com/build_hooks/
```

将在[设置`Repository secrets`](#设置repository-secrets)中使用该值。

## 设置`Repository secrets`

访问仓库<https://github.com/huzhenghui/posts/>的`Repository secrets`设置页面

<https://github.com/huzhenghui/posts/settings/secrets/actions>

在`Repository secrets`中可以看到已经有两项

- `TRIGGER_XUEKAIYUAN_COM`，
    - 这是在[设置`Actions secrets`](https://www.xuekaiyuan.com/huzhenghui/github/readme/#%E8%AE%BE%E7%BD%AEactions-secrets)中设置的。
- `TRIGGER_XUEKAIYUAN_PAGES_DEV`
    - 这是在[设置`Repository secrets`](https://www.xuekaiyuan.com/huzhenghui/cloudflare/readme/#%E8%AE%BE%E7%BD%AErepository-secrets)中设置的。

接下来增加一项，名称设置为`TRIGGER_XUEKAIYUAN_NETLIFY_APP`，值设置为前面[创建部署挂钩](#创建部署挂钩)记录的`URL`。

该设置将在[`.github/workflows/netlify.yml`](#githubworkflowsnetlifyyml)中使用。

## `.github/workflows/netlify.yml`

手工创建，位置在

<https://github.com/huzhenghui/posts/blob/master/.github/workflows/netlify.yml>

Since [v0.3](https://github.com/huzhenghui/posts/tree/v0.3)

<https://github.com/huzhenghui/posts/blob/v0.3/.github/workflows/netlify.yml>

```yaml
name: Trigger https://xuekaiyuan.netlify.app Build hooks

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
      - name: POST https://xuekaiyuan.netlify.app Build hooks
        run: |
          curl \
            -X POST -d '{}' \
            "${{ secrets.TRIGGER_XUEKAIYUAN_NETLIFY_APP }}"
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
      - name: POST https://xuekaiyuan.netlify.app Build hooks
        run: |
          curl \
            -X POST -d '{}' \
            "${{ secrets.TRIGGER_XUEKAIYUAN_NETLIFY_APP }}"
```

其中只有一个任务`trigger`，
任务中只有一个步骤`POST https://xuekaiyuan.netlify.app Build hooks`
运行的命令为

```yaml
        run: |
          curl \
            -X POST -d '{}' \
            "${{ secrets.TRIGGER_XUEKAIYUAN_NETLIFY_APP }}"
```

其中`${{ secrets.TRIGGER_XUEKAIYUAN_NETLIFY_APP }}`为[设置`Repository secrets`](#设置repository-secrets)中设置的值。

## `Netlify/README.md`

本文件，位置在<https://github.com/huzhenghui/posts/blob/master/Netlify/README.md>

Since [v0.3](https://github.com/huzhenghui/posts/tree/v0.3)

<https://github.com/huzhenghui/posts/blob/v0.3/Netlify/README.md>
