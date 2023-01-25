---
title: 使用GitHub作为Markdown图床
date: 2023-01-26
publishdate: 2023-01-26
url: huzhenghui/pandocomatic/readme.textbundle/
---

<!-- markdownlint-disable-next-line MD025 -->
# 使用`GitHub`作为`Markdown`图床

## 目录

- [使用`GitHub`作为`Markdown`图床](#使用github作为markdown图床)
    - [目录](#目录)
    - [简介](#简介)
    - [仓库](#仓库)
        - [`xuekaiyuan-com/xuekaiyuan-com.github.io`仓库](#xuekaiyuan-comxuekaiyuan-comgithubio仓库)
        - [`huzhenghui/posts`仓库](#huzhenghuiposts仓库)
        - [`huzhenghui/posts-pandocomatic`仓库](#huzhenghuiposts-pandocomatic仓库)
    - [`huzhenghui/posts`仓库结构](#huzhenghuiposts仓库结构)
    - [创建`Personal access tokens`](#创建personal-access-tokens)
    - [设置`Repository secrets`](#设置repository-secrets)
    - [`.github/workflows/pandocomatic.yml`](#githubworkflowspandocomaticyml)
        - [`.github/workflows/pandocomatic.yml`程序](#githubworkflowspandocomaticyml程序)
        - [`.github/workflows/pandocomatic.yml`触发工作流的事件](#githubworkflowspandocomaticyml触发工作流的事件)
        - [`.github/workflows/pandocomatic.yml`工作流中所有作业的默认设置](#githubworkflowspandocomaticyml工作流中所有作业的默认设置)
        - [`.github/workflows/pandocomatic.yml`工作流作业](#githubworkflowspandocomaticyml工作流作业)
        - [运行`pandocomatic`作业的计算机类型](#运行pandocomatic作业的计算机类型)
        - [第一步：获取`huzhenghui/posts`仓库代码](#第一步获取huzhenghuiposts仓库代码)
        - [第二步：删除文件夹`./dist/Pandocomatic/`的占位文件](#第二步删除文件夹distpandocomatic的占位文件)
        - [第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)
        - [第四步：在`Pandoc`的`Docker`镜像中安装并运行`Pandocomatic`](#第四步在pandoc的docker镜像中安装并运行pandocomatic)
        - [第五步：设置`Git`用户邮箱](#第五步设置git用户邮箱)
        - [第六步：设置`Git`用户名](#第六步设置git用户名)
        - [第七步：提交代码](#第七步提交代码)
        - [第八步：推送](#第八步推送)
    - [`./Pandocomatic/docker.entrypoint.sh`](#pandocomaticdockerentrypointsh)
    - [`./Pandocomatic/pandocomatic.yaml`](#pandocomaticpandocomaticyaml)
    - [`Pandocomatic/pandocomatic-data/image.lua`](#pandocomaticpandocomatic-dataimagelua)
        - [`Pandocomatic/pandocomatic-data/image.lua`本地变量](#pandocomaticpandocomatic-dataimagelua本地变量)
        - [`extract_metadata_vars`函数](#extract_metadata_vars函数)
        - [`image_converter`函数](#image_converter函数)
        - [返回`pandoc`钩子](#返回pandoc钩子)
    - [`Pandocomatic/README.textbundle/text.md`](#pandocomaticreadmetextbundletextmd)
    - [`Pandocomatic/README.textbundle/index.md`](#pandocomaticreadmetextbundleindexmd)
    - [`Pandocomatic/README.md`](#pandocomaticreadmemd)
    - [生成图片](#生成图片)

## 简介

本文讲解如何使用`GitHub Actions`将`Markdown`文件中图片的相对路径转换为绝对路径，
后续将`Markdown`文件复制到其他位置可以保持图片链接地址，也就是使用`GitHub`作为`Markdown`图床。

目前网站已发布在

<https://www.xuekaiyuan.com/>

已经同步发布在

<https://xuekaiyuan.pages.dev/>

<https://xuekaiyuan.netlify.app/>

本文发表在

<https://www.xuekaiyuan.com/huzhenghui/pandocomatic/readme.textbundle/>

<https://xuekaiyuan.pages.dev/huzhenghui/pandocomatic/readme.textbundle/>

<https://xuekaiyuan.netlify.app/huzhenghui/pandocomatic/readme.textbundle/>

<https://blog.csdn.net/hu_zhenghui/article/details/128766110>

## 仓库

### `xuekaiyuan-com/xuekaiyuan-com.github.io`仓库

仓库位于<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>

相关版本为

[v0.3](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.3)

详见<https://www.xuekaiyuan.com/posts/xuekaiyuan/readme/>

### `huzhenghui/posts`仓库

仓库位于<https://github.com/huzhenghui/posts>

- [v0.1](https://github.com/huzhenghui/posts/tree/v0.1)
    - 实现了自动触发更新<https://www.xuekaiyuan.com/>
- [v0.2](https://github.com/huzhenghui/posts/tree/v0.2)
    - 网站同步发布在<https://xuekaiyuan.pages.dev/>
- [v0.3](https://github.com/huzhenghui/posts/tree/v0.3)
    - 网站同步发布在<https://xuekaiyuan.netlify.app/>

本文将使用`GitHub Actions`将`Markdown`文件中图片的相对路径转换为绝对路径，
转换目标为[`huzhenghui/posts-pandocomatic`仓库](#huzhenghuiposts-pandocomatic仓库)。

相关版本为

<https://github.com/huzhenghui/posts/tree/v0.4>

### `huzhenghui/posts-pandocomatic`仓库

新建仓库，用于保存生成的文件，位置在

<https://github.com/huzhenghui/posts-pandocomatic/>

## `huzhenghui/posts`仓库结构

查询命令

```shell
{find './.github/workflows/pandocomatic.yml'; find './Pandocomatic'; find './dist/Pandocomatic'} | as-tree
```

本文相关文件为

```text
.
├── .github/workflows
│   └── pandocomatic.yml
├── Pandocomatic
│   ├── README.md
│   ├── README.textbundle
│   │   ├── assets
│   │   │   ├── docker.entrypoint.sh.png
│   │   │   ├── image.lua.png
│   │   │   ├── pandocomatic.config.yaml.png
│   │   │   └── workflows.pandocomatic.yml.png
│   │   ├── index.md
│   │   └── text.md
│   ├── assets
│   │   ├── docker.entrypoint.sh.png
│   │   ├── image.lua.png
│   │   ├── pandocomatic.config.yaml.png
│   │   └── workflows.pandocomatic.yml.png
│   ├── docker.entrypoint.sh
│   ├── pandocomatic-data
│   │   └── image.lua
│   └── pandocomatic.yaml
└── dist/Pandocomatic
    └── .gitkeep
```

## 创建`Personal access tokens`

由于需要向仓库提交代码，为避免安全隐患，应当仅能操作[`huzhenghui/posts-pandocomatic`仓库](#huzhenghuiposts-pandocomatic仓库)，
因此需要使用`Github`新的[Fine-grained personal access tokens](https://github.com/settings/tokens?type=beta)。

创建`Personal access tokens`，设置名称为

```text
API_TOKEN_GITHUB_POSTS_PANDOCOMATIC
```

仓库访问`Repository access`选择<https://github.com/huzhenghui/posts-pandocomatic/>。
仓库权限`Repository permissions`选择

- Read access to metadata
- Read and Write access to code

将在[设置`Repository secrets`](#设置repository-secrets)中使用该值。

## 设置`Repository secrets`

访问仓库<https://github.com/huzhenghui/posts/>的`Repository secrets`设置页面

<https://github.com/huzhenghui/posts/settings/secrets/actions>

在`Repository secrets`中可以看到已经有三项

1. `TRIGGER_XUEKAIYUAN_COM`，
    - 这是在[套娃：在一个`GitHub Action`中触发另一个`GitHub Action`](https://www.xuekaiyuan.com/huzhenghui/github/readme/)的[设置`Actions secrets`](https://www.xuekaiyuan.com/huzhenghui/github/readme/#%E8%AE%BE%E7%BD%AEactions-secrets)中设置的。
1. `TRIGGER_XUEKAIYUAN_PAGES_DEV`
    - 这是在[在`Cloudflare Pages`上发布`GitHub`中基于`Hugo`的静态网站](https://www.xuekaiyuan.com/huzhenghui/cloudflare/readme/)的[设置`Repository secrets`](https://www.xuekaiyuan.com/huzhenghui/cloudflare/readme/#%E8%AE%BE%E7%BD%AErepository-secrets)中设置的。
1. `TRIGGER_XUEKAIYUAN_NETLIFY_APP`
    - 这是在[在`Netlify`上发布`GitHub`中基于`Hugo`的静态网站](https://www.xuekaiyuan.com/huzhenghui/netlify/readme/)的[设置`Repository secrets`]([#设置repository-secrets](https://www.xuekaiyuan.com/huzhenghui/netlify/readme/#%E8%AE%BE%E7%BD%AErepository-secrets))中设置的。

接下来增加一项，名称设置为`API_TOKEN_GITHUB_POSTS_PANDOCOMATIC`，值设置为前面[创建`Personal access tokens`](#创建personal-access-tokens)记录的值。

该设置将在[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)中使用。

## `.github/workflows/pandocomatic.yml`

### `.github/workflows/pandocomatic.yml`程序

手工创建，位置在

<https://github.com/huzhenghui/posts/blob/master/.github/workflows/pandocomatic.yml>

Since [v0.4](https://github.com/huzhenghui/posts/tree/v0.4)

<https://github.com/huzhenghui/posts/blob/v0.4/.github/workflows/pandocomatic.yml>

![.github/workflows/pandocomatic.yml](assets/workflows.pandocomatic.yml.png)

```yaml
name: Converted by pandocomatic and publish to https://github.com/huzhenghui/posts-pandocomatic

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
  # Converted by pandocomatic and publish to https://github.com/huzhenghui/posts-pandocomatic
  pandocomatic:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: rm ./dist/Pandocomatic/.gitkeep
        run: rm ./dist/Pandocomatic/.gitkeep
      - name: clone https://github.com/huzhenghui/posts-pandocomatic
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB_POSTS_PANDOCOMATIC }}
        run: git clone --single-branch --depth 1 --branch master https://huzhenghui:$API_TOKEN_GITHUB@github.com/huzhenghui/posts-pandocomatic.git './dist/Pandocomatic/'
      - name: Run Pandocomatic in docker://pandoc/core:2.19-ubuntu
        uses: docker://pandoc/core:2.19-ubuntu
        with:
          entrypoint: "./Pandocomatic/docker.entrypoint.sh"
      - name: user.email
        run: git config --global user.email "hu@daonao.com"
      - name: user.name
        run: git config --global user.name "huzhenghui"
      - name: commit
        run: |
          cd './dist/Pandocomatic/'; \
          git add --all; \
          git commit --allow-empty --message='pandoc Trigger'
      - name: push
        run: |
          cd './dist/Pandocomatic/'; \
          git push origin
```

### `.github/workflows/pandocomatic.yml`触发工作流的事件

其中`on`为`GitHub Action`触发工作流的事件。

- 响应`master`分支的`push`
- 响应<https://github.com/huzhenghui/posts/actions>页面中手动触发工作流

```yaml
on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:
```

### `.github/workflows/pandocomatic.yml`工作流中所有作业的默认设置

其中`defaults`设置了工作流中所有作业的默认设置，这里默认使用`bash`运行。

```yaml
# Default to bash
defaults:
  run:
    shell: bash
```

### `.github/workflows/pandocomatic.yml`工作流作业

在`jobs`中为工作流中运行的作业，其中只有一个作业`pandocomatic`。

```yaml
jobs:
  # Converted by pandocomatic and publish to https://github.com/huzhenghui/posts-pandocomatic
  pandocomatic:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: rm ./dist/Pandocomatic/.gitkeep
        run: rm ./dist/Pandocomatic/.gitkeep
      - name: clone https://github.com/huzhenghui/posts-pandocomatic
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB_POSTS_PANDOCOMATIC }}
        run: git clone --single-branch --depth 1 --branch master https://huzhenghui:$API_TOKEN_GITHUB@github.com/huzhenghui/posts-pandocomatic.git './dist/Pandocomatic/'
      - name: Run Pandocomatic in docker://pandoc/core:2.19-ubuntu
        uses: docker://pandoc/core:2.19-ubuntu
        with:
          entrypoint: "./Pandocomatic/docker.entrypoint.sh"
      - name: user.email
        run: git config --global user.email "hu@daonao.com"
      - name: user.name
        run: git config --global user.name "huzhenghui"
      - name: commit
        run: |
          cd './dist/Pandocomatic/'; \
          git add --all; \
          git commit --allow-empty --message='pandoc Trigger'
      - name: push
        run: |
          cd './dist/Pandocomatic/'; \
          git push origin
```

### 运行`pandocomatic`作业的计算机类型

运行环境为最新版的`Ubuntu`

```yaml
    runs-on: ubuntu-latest
```

可用运行环境在<https://github.com/actions/runner-images>，目前（2023年1月26日）可用运行环境如下

<!-- markdownlint-capture -->
<!-- markdownlint-configure-file { "MD033": { "allowed_elements": ["sup"] } } -->
| 镜像 | YAML 标签 | 包含软件 | 最新镜像进度 |
| --------------------|---------------------|--------------------|---------------------|
| Ubuntu 22.04 | `ubuntu-latest` or `ubuntu-22.04` | [ubuntu-22.04] | [![status22](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu22&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu22&redirect=1)
| Ubuntu 20.04 | `ubuntu-20.04` | [ubuntu-20.04] | [![status20](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu20&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu20&redirect=1)
| Ubuntu 18.04 <sup>deprecated</sup>  | `ubuntu-18.04` | [ubuntu-18.04] | [![status18](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu18&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=ubuntu18&redirect=1)
| macOS 12 | `macos-latest` or `macos-12`| [macOS-12] | [![statusumac12](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-12&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-12&redirect=1)
| macOS 11 | `macos-11`| [macOS-11] | [![statusmac11](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-11&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-11&redirect=1)
| macOS 10.15 <sup>deprecated</sup> | `macos-10.15` | [macOS-10.15] | [![statusmac10](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-10.15&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=macos-10.15&redirect=1)
| Windows Server 2022 | `windows-latest` or `windows-2022` | [windows-2022] | [![statuswin22](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=windows-2022&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=windows-2022&redirect=1) |
| Windows Server 2019 | `windows-2019` | [windows-2019] | [![statuswin19](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=windows-2019&badge=1)](https://actionvirtualenvironmentsstatus.azurewebsites.net/api/status?imageName=windows-2019&redirect=1)
<!-- markdownlint-restore -->

### 第一步：获取`huzhenghui/posts`仓库代码

```yaml
      - name: Checkout
        uses: actions/checkout@v3
```

### 第二步：删除文件夹`./dist/Pandocomatic/`的占位文件

```yaml
      - name: rm ./dist/Pandocomatic/.gitkeep
        run: rm ./dist/Pandocomatic/.gitkeep
```

删除后，文件夹`./dist/Pandocomatic/`将是空文件夹，以便于[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)。

### 第三步：获取`huzhenghui/posts-pandocomatic`仓库代码

此时`./dist/Pandocomatic/`已是空文件夹，
接下来获取[`huzhenghui/posts`仓库](#huzhenghuiposts仓库)代码到`./dist/Pandocomatic/`文件夹。

```yaml
      - name: clone https://github.com/huzhenghui/posts-pandocomatic
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB_POSTS_PANDOCOMATIC }}
        run: git clone --single-branch --depth 1 --branch master https://huzhenghui:$API_TOKEN_GITHUB@github.com/huzhenghui/posts-pandocomatic.git './dist/Pandocomatic/'
```

其中`API_TOKEN_GITHUB`为[设置`Repository secrets`](#设置repository-secrets)中设置的值。

```yaml
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB_POSTS_PANDOCOMATIC }}
```

获取代码的命令为

```shell
git clone --single-branch --depth 1 --branch master https://huzhenghui:$API_TOKEN_GITHUB@github.com/huzhenghui/posts-pandocomatic.git './dist/Pandocomatic/'
```

为提升自动化更新代码的速度，所以使用`--single-branch`仅获取一个分支，使用`--depth 1`仅获取最后的状态，并指定分支名称`--branch master`。

### 第四步：在`Pandoc`的`Docker`镜像中安装并运行`Pandocomatic`

```yaml
      - name: Run Pandocomatic in docker://pandoc/core:2.19-ubuntu
        uses: docker://pandoc/core:2.19-ubuntu
        with:
          entrypoint: "./Pandocomatic/docker.entrypoint.sh"
```

从[运行`pandocomatic`作业的计算机类型](#运行pandocomatic作业的计算机类型)可知，
`GitHub Action`可以选择的最新版本的`Ubuntu`的版本是`ubuntu-22.04`。

搜索`Ubuntu`的预编译包<https://packages.ubuntu.com/search?keywords=pandoc>可以看到，
`ubuntu-22.04`中的`pandoc`的版本是`2.9.2.1-3ubuntu2`，查询`pandoc`网站可知，
[2.9.2.1](https://pandoc.org/releases.html#pandoc-2.9.2.1-2020-03-23)版本在`2020年03月23日`发布，
为使用和开发环境一直的较新版`pandoc`，这一步使用`Pandoc`的`Docker`镜像。

```yaml
        uses: docker://pandoc/core:2.19-ubuntu
```

`Pandoc`的`Docker`镜像在<https://hub.docker.com/r/pandoc/core>，
查询可用版本<https://hub.docker.com/r/pandoc/core/tags>，
选择和开发环境最接近的<https://hub.docker.com/r/pandoc/core/tags?name=2.19-ubuntu>。
因为镜像中没有`pandocomatic`，所以需要安装并运行`pandocomatic`，
因此编写脚本[`./Pandocomatic/docker.entrypoint.sh`](#pandocomaticdockerentrypointsh)，
使用参数`entrypoint`指定镜像中运行脚本的路径。

```yaml
        with:
          entrypoint: "./Pandocomatic/docker.entrypoint.sh"
```

### 第五步：设置`Git`用户邮箱

在[第七步：提交代码](#第七步提交代码)中需要设置`user.email`参数。

```yaml
      - name: user.email
        run: git config --global user.email "hu@daonao.com"
```

### 第六步：设置`Git`用户名

在[第七步：提交代码](#第七步提交代码)中需要设置`user.name`参数。

```yaml
      - name: user.name
        run: git config --global user.name "huzhenghui"
```

### 第七步：提交代码

```yaml
      - name: commit
        run: |
          cd './dist/Pandocomatic/'; \
          git add --all; \
          git commit --allow-empty --message='pandoc Trigger'
```

先进入[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)中获取代码的路径，
此时代码已经在[第四步：在`Pandoc`的`Docker`镜像中安装并运行`Pandocomatic`](#第四步在pandoc的docker镜像中安装并运行pandocomatic)中被脚本[`./Pandocomatic/docker.entrypoint.sh`](#pandocomaticdockerentrypointsh)更新。

```shell
cd './dist/Pandocomatic/';
```

添加全部文件

```shell
git add --all
```

提交文件

```shell
git commit --allow-empty --message='pandoc Trigger'
```

因为是自动运行，因此在[第四步：在`Pandoc`的`Docker`镜像中安装并运行`Pandocomatic`](#第四步在pandoc的docker镜像中安装并运行pandocomatic)中生成的文件可能和已有文件完全相同，也就是没有文件被更新，因此提交时使用允许无文件的参数`--allow-empty`。

### 第八步：推送

```yaml
      - name: push
        run: |
          cd './dist/Pandocomatic/'; \
          git push origin
```

`Github Action`中每一步的运行环境相同，因此也需要先进入[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)中获取代码的路径。

```shell
cd './dist/Pandocomatic/';
```

再推送

```shell
git push origin
```

## `./Pandocomatic/docker.entrypoint.sh`

在[第四步：在`Pandoc`的`Docker`镜像中安装并运行`Pandocomatic`](#第四步在pandoc的docker镜像中安装并运行pandocomatic)中讲到在镜像中需要通过脚本运行`Pandocomatic`。

脚本位置在

<https://github.com/huzhenghui/posts/blob/master/Pandocomatic/docker.entrypoint.sh>

Since [v0.4](https://github.com/huzhenghui/posts/tree/v0.4)

<https://github.com/huzhenghui/posts/blob/v0.4/Pandocomatic/docker.entrypoint.sh>

![./Pandocomatic/docker.entrypoint.sh](assets/docker.entrypoint.sh.png)

```shell
#!/bin/sh
echo 打印系统上安装的 pandoc 版本。
pandoc --version
echo 列出目录 ./dist/Pandocomatic/ 中的文件
ls -al ./dist/Pandocomatic/
echo 使用 apt-get update 更新包索引
apt-get update
echo 使用 apt-get 安装 Ruby
apt-get install --assume-yes --no-install-recommends ruby
echo 使用 gem 安装 pandocomatic
gem install pandocomatic
echo 使用配置文件 ./Pandocomatic/pandocomatic.yaml 运行 pandocomatic
pandocomatic --debug --input . --output ./dist/Pandocomatic/ --config ./Pandocomatic/pandocomatic.yaml
```

打印系统上安装的`pandoc`版本。

```shell
pandoc --version
```

运行输出为

```text
pandoc 2.19.2
Compiled with pandoc-types 1.22.2.1, texmath 0.12.5.2, skylighting 0.13,
citeproc 0.8.0.1, ipynb 0.2, hslua 2.1.0
Scripting engine: Lua 5.3
User data directory: /github/home/.local/share/pandoc
Copyright (C) 2006-2022 John MacFarlane. Web:  https://pandoc.org
This is free software; see the source for copying conditions. There is no
warranty, not even for merchantability or fitness for a particular purpose.
```

用于核对运行版本。

列出目录`./dist/Pandocomatic/`中的文件

```shell
ls -al ./dist/Pandocomatic/
```

运行输出为

```text
drwxr-xr-x 7 1001 123 4096 Jan 26 04:02 .
drwxr-xr-x 3 1001 123 4096 Jan 26 04:02 ..
drwxr-xr-x 8 1001 123 4096 Jan 26 04:02 .git
drwxr-xr-x 2 1001 123 4096 Jan 26 04:02 Cloudflare
drwxr-xr-x 2 1001 123 4096 Jan 26 04:02 GitHub
drwxr-xr-x 2 1001 123 4096 Jan 26 04:02 Netlify
drwxr-xr-x 4 1001 123 4096 Jan 26 04:02 Pandocomatic
-rw-r--r-- 1 1001 123   99 Jan 26 04:02 _index.md
```

用于检查[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)的运行情况。

使用`apt-get update`更新包索引。

```shell
apt-get update
```

使用`apt-get`安装`Ruby`

```shell
apt-get install --assume-yes --no-install-recommends ruby
```

使用`gem`安装`pandocomatic`

```shell
gem install pandocomatic
```

使用配置文件[`./Pandocomatic/pandocomatic.yaml`](#pandocomaticpandocomaticyaml)运行`pandocomatic`

```shell
pandocomatic --debug --input . --output ./dist/Pandocomatic/ --config ./Pandocomatic/pandocomatic.yaml
```

输入文件夹为当前目录`.`，也就项目根目录，输出目录为[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)的位置，也就是覆盖[`huzhenghui/posts-pandocomatic`仓库](#huzhenghuiposts-pandocomatic仓库)的文件。

## `./Pandocomatic/pandocomatic.yaml`

由于参数较多，在[`./Pandocomatic/docker.entrypoint.sh`](#pandocomaticdockerentrypointsh)中运行`pandocomatic`时使用配置文件。

配置文件位置在

<https://github.com/huzhenghui/posts/blob/master/Pandocomatic/pandocomatic.yaml>

Since [v0.4](https://github.com/huzhenghui/posts/tree/v0.4)

<https://github.com/huzhenghui/posts/blob/v0.4/Pandocomatic/pandocomatic.yaml>

![./Pandocomatic/pandocomatic.yaml](assets/pandocomatic.config.yaml.png)

```yaml
settings:
  data-dir: ./pandocomatic-data/
  recursive: true
  skip:
    - dist
templates:
  md:
    glob: ["*.md"]
    metadata:
      IMAGE_PREFIX: https://raw.githubusercontent.com/huzhenghui/posts/master/
    pandoc:
      from: markdown
      to: gfm
      lua-filter: image.lua
```

其中`settings`为`Pandocomatic`设置。

```yaml
settings:
  data-dir: ./pandocomatic-data/
  recursive: true
  skip:
    - dist

```

`data-dir`指定`Pandocomatic`的数据文件夹为`./pandocomatic-data/`目录，
也就是[`Pandocomatic/pandocomatic-data/image.lua`](#pandocomaticpandocomatic-dataimagelua)的路径。

`recursive`设置为`true`，表示递归转换子文件夹。

`skip`指定跳过的文件夹，由于`dist`文件夹用于保存[第三步：获取`huzhenghui/posts-pandocomatic`仓库代码](#第三步获取huzhenghuiposts-pandocomatic仓库代码)，因此需要设置为跳过`dist`文件夹。

`templates`定义`Pandocomatic`的模板，配置中只有一个模板`md`。

```yaml
templates:
  md:
    glob: ["*.md"]
    metadata:
      IMAGE_PREFIX: https://raw.githubusercontent.com/huzhenghui/posts/master/
    pandoc:
      from: markdown
      to: gfm
      lua-filter: image.lua
```

`glob`参数用于匹配转换的文件名，`*.md`表示匹配扩展名为`.md`的文件。

`metadata`用于设置`pandoc`所使用的元数据，
此处为元数据项`IMAGE_PREFIX`的值为<https://raw.githubusercontent.com/huzhenghui/posts/master/>，
用于在[`Pandocomatic/pandocomatic-data/image.lua`](#pandocomaticpandocomatic-dataimagelua)添加为图片的前缀路径。

`pandoc`为调用`pandoc`的参数，`from`为`pandoc`的`--from`参数，`markdown`表示输入格式为`markdown`，
`to`为`pandoc`的`--to`参数，`gfm`表示输出格式为`Github-Flavored Markdown`，也就是`Github`风格的`markdown`，
`lua-filter`为`pandoc`的`--lua-filter`参数，指定`Lua`脚本的路径，也就是[`Pandocomatic/pandocomatic-data/image.lua`](#pandocomaticpandocomatic-dataimagelua)的路径，由于`data-dir`指定`Pandocomatic`的数据文件夹为`./pandocomatic-data/`目录，因此值为相对路径`image.lua`。

## `Pandocomatic/pandocomatic-data/image.lua`

在配置文件[`./Pandocomatic/pandocomatic.yaml`](#pandocomaticpandocomaticyaml)设置`pandoc`运行时的`lua`脚本。

`lua`脚本文件位置在

<https://github.com/huzhenghui/posts/blob/master/Pandocomatic/pandocomatic-data/image.lua>

Since [v0.4](https://github.com/huzhenghui/posts/tree/v0.4)

<https://github.com/huzhenghui/posts/blob/v0.4/Pandocomatic/pandocomatic-data/image.lua>

![Pandocomatic/pandocomatic-data/image.lua](assets/image.lua.png)

```lua
-- 图片地址前缀
local image_prefix
-- markdown 文件夹的根目录
local root
-- markdown_path 是正在转换的 markdown 文件的路径
local markdown_path
-- 从元数据中提取元数据变量
function extract_metadata_vars (meta)
    -- 枚举元数据中的变量
    for k, v in pairs(meta) do
        -- 从元数据中提取 IMAGE_PREFIX 变量
        if k == 'IMAGE_PREFIX' then
            -- pandoc.utils.stringify(v) 是一个将变量转换为字符串的函数
            image_prefix = pandoc.utils.stringify(v)
        end
        -- 获取 pandocomatic 设置的文件的信息
        if k == 'pandocomatic-fileinfo' then
            -- 获取 markdown 文件的路径和 markdown 文件的根目录。
            for k1,v1 in pairs(v) do
                -- src_path 是 markdown 文件的文件夹的根目录
                if k1 == 'src_path' then
                    -- root 是 markdown 文件的根目录
                    root = pandoc.utils.stringify(v1)
                end
                -- 获取 markdown 文件的路径
                if k1 == 'path' then
                    -- markdown_path 是 markdown 文件的路径
                    markdown_path = pandoc.utils.stringify(v1)
                end
            end
        end
    end
end
-- 将图像路径转换为 URL 的函数
function image_converter(elem)
    -- 检查图像是否已经是 URL。如果是，它什么也不做。如果不是，它将图像路径转换为 URL。
    if elem.src:find('https://', 1, true) ~= 1 then
        -- directory 是 markdown 文件的目录
        directory = pandoc.path.directory(markdown_path)
        -- pandoc.path.join 是连接两条路径的函数，结果为图像的绝对路径。
        image_absolute_path = pandoc.path.join({directory, elem.src})
        -- image_relative_root_path 是图片相对于 markdown 文件根目录的路径。
        image_relative_root_path = pandoc.path.make_relative(image_absolute_path, root)
        -- image_prefix 是 URL 的前缀，拼接图片相对路径得到image_url 是图片的 URL。
        image_url = image_prefix .. image_relative_root_path
        -- 更改 Image 元素的 src 属性的值为图片的 URL。
        elem.src = image_url
    end
    -- 返回修改后的元素。
    return elem
end
-- 返回函数钩子
return {
    -- {Meta = extract_metadata_vars} 是将应用于元数据的过滤器。
    {Meta = extract_metadata_vars},
    -- 将 image_converter 函数应用于所有 Image 元素。
    {Image = image_converter}
}
```

### `Pandocomatic/pandocomatic-data/image.lua`本地变量

脚本中包含三个本地变量

- `image_prefix`
    - 用于保存在[`extract_metadata_vars`函数](#extract_metadata_vars函数)获取的在[`./Pandocomatic/pandocomatic.yaml`](#pandocomaticpandocomaticyaml)设置的元数据项`IMAGE_PREFIX`
    - 在[`image_converter`函数](#image_converter函数)使用该变量拼接`URL`
- `root`
    - 用于保存在[`extract_metadata_vars`函数](#extract_metadata_vars函数)获取的元数据项`pandocomatic-fileinfo`中的`root`值，该值为`pandocomatic`自动设置的文件信息。
    - 在[`image_converter`函数](#image_converter函数)使用该变量计算图片相对路径
- `markdown_path`
    - 用于保存在[`extract_metadata_vars`函数](#extract_metadata_vars函数)获取的元数据项`pandocomatic-fileinfo`中的`src_path`值
    - 在[`image_converter`函数](#image_converter函数)使用该变量获取`markdown`文件所在路径

### `extract_metadata_vars`函数

```lua
-- 从元数据中提取元数据变量
function extract_metadata_vars (meta)
    -- 枚举元数据中的变量
    for k, v in pairs(meta) do
        -- 从元数据中提取 IMAGE_PREFIX 变量
        if k == 'IMAGE_PREFIX' then
            -- pandoc.utils.stringify(v) 是一个将变量转换为字符串的函数
            image_prefix = pandoc.utils.stringify(v)
        end
        -- 获取 pandocomatic 设置的文件的信息
        if k == 'pandocomatic-fileinfo' then
            -- 获取 markdown 文件的路径和 markdown 文件的根目录。
            for k1,v1 in pairs(v) do
                -- src_path 是 markdown 文件的文件夹的根目录
                if k1 == 'src_path' then
                    -- root 是 markdown 文件的根目录
                    root = pandoc.utils.stringify(v1)
                end
                -- 获取 markdown 文件的路径
                if k1 == 'path' then
                    -- markdown_path 是 markdown 文件的路径
                    markdown_path = pandoc.utils.stringify(v1)
                end
            end
        end
    end
end
```

### `image_converter`函数

```lua
-- 将图像路径转换为 URL 的函数
function image_converter(elem)
    -- 检查图像是否已经是 URL。如果是，它什么也不做。如果不是，它将图像路径转换为 URL。
    if elem.src:find('https://', 1, true) ~= 1 then
        -- directory 是 markdown 文件的目录
        directory = pandoc.path.directory(markdown_path)
        -- pandoc.path.join 是连接两条路径的函数，结果为图像的绝对路径。
        image_absolute_path = pandoc.path.join({directory, elem.src})
        -- image_relative_root_path 是图片相对于 markdown 文件根目录的路径。
        image_relative_root_path = pandoc.path.make_relative(image_absolute_path, root)
        -- image_prefix 是 URL 的前缀，拼接图片相对路径得到image_url 是图片的 URL。
        image_url = image_prefix .. image_relative_root_path
        -- 更改 Image 元素的 src 属性的值为图片的 URL。
        elem.src = image_url
    end
    -- 返回修改后的元素。
    return elem
end
```

### 返回`pandoc`钩子

```lua
-- 返回函数钩子
return {
    -- {Meta = extract_metadata_vars} 是将应用于元数据的过滤器。
    {Meta = extract_metadata_vars},
    -- 将 image_converter 函数应用于所有 Image 元素。
    {Image = image_converter}
}
```

## `Pandocomatic/README.textbundle/text.md`

本文件，位置在<https://github.com/huzhenghui/posts/blob/master/Pandocomatic/README.textbundle/text.md>

Since [v0.4](https://github.com/huzhenghui/posts/tree/v0.4)

<https://github.com/huzhenghui/posts/blob/v0.4/Pandocomatic/README.textbundle/text.md>

文件名使用`text.md`是为了遵从`textbundle`规范。

## `Pandocomatic/README.textbundle/index.md`

软链接到[`Pandocomatic/README.textbundle/text.md`](#pandocomaticreadmetextbundletextmd)

文件名使用`index.md`是为了符合`Hugo`的`Leaf Bundle`约定。

## `Pandocomatic/README.md`

软链接到[`Pandocomatic/README.textbundle/text.md`](#pandocomaticreadmetextbundletextmd)

文件名使用`README.md`是符合`Github`的约定，由于`markdown`文件的图片使用相对路径，
因此需要额外存放一份图片在<https://github.com/huzhenghui/posts/tree/master/Pandocomatic/assets>，
这也是本文将图片转成`URL`绝对地址的用途之一。

## 生成图片

本文所使用图片都使用`silicon`命令生成。

生成[`.github/workflows/pandocomatic.yml`](#githubworkflowspandocomaticyml)

```shell
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'gruvbox' --highlight-lines '29-32' '.github/workflows/pandocomatic.yml' --output 'Pandocomatic/assets/workflows.pandocomatic.yml.png'
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'zenburn' --highlight-lines '29-32' '.github/workflows/pandocomatic.yml' --output 'Pandocomatic/README.textbundle/assets/workflows.pandocomatic.yml.png'
```

生成[`./Pandocomatic/docker.entrypoint.sh`](#pandocomaticdockerentrypointsh)

```shell
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'gruvbox' --highlight-lines '13' 'Pandocomatic/docker.entrypoint.sh' --output 'Pandocomatic/assets/docker.entrypoint.sh.png'
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'zenburn' --highlight-lines '13' 'Pandocomatic/docker.entrypoint.sh' --output 'Pandocomatic/README.textbundle/assets/docker.entrypoint.sh.png'
```

生成[`./Pandocomatic/pandocomatic.yaml`](#pandocomaticpandocomaticyaml)

```shell
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'gruvbox' --highlight-lines '8-14' 'Pandocomatic/pandocomatic.yaml' --output 'Pandocomatic/assets/pandocomatic.config.yaml.png'
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'zenburn' --highlight-lines '8-14' 'Pandocomatic/pandocomatic.yaml' --output 'Pandocomatic/README.textbundle/assets/pandocomatic.config.yaml.png'
```

生成[`Pandocomatic/pandocomatic-data/image.lua`](#pandocomaticpandocomatic-dataimagelua)

```shell
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'gruvbox' --highlight-lines '34-51' 'Pandocomatic/pandocomatic-data/image.lua' --output 'Pandocomatic/assets/image.lua.png'
silicon --background '#FFFFFF' --pad-horiz 10 --pad-vert 20 --shadow-blur-radius 10 --font 'FiraMono Nerd Font Mono;Simsong' --theme 'zenburn' --highlight-lines '34-51' 'Pandocomatic/pandocomatic-data/image.lua' --output 'Pandocomatic/README.textbundle/assets/image.lua.png'
```
