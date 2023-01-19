---
title: 套娃：在一个GitHub Action中触发另一个GitHub Action
date: 2023-01-19
publishdate: 2023-01-19
---

<!-- markdownlint-disable-next-line MD025 -->
# 在一个`GitHub Action`中触发另一个`GitHub Action`

## 目录

- [在一个`GitHub Action`中触发另一个`GitHub Action`](#在一个github-action中触发另一个github-action)
  - [目录](#目录)
  - [简介](#简介)
  - [仓库](#仓库)
    - [`xuekaiyuan-com/xuekaiyuan-com.github.io`仓库](#xuekaiyuan-comxuekaiyuan-comgithubio仓库)
    - [`huzhenghui/posts`仓库](#huzhenghuiposts仓库)
  - [版本](#版本)
    - [`v0.1`](#v01)
  - [仓库结构](#仓库结构)
    - [`xuekaiyuan-com/xuekaiyuan-com.github.io`仓库结构](#xuekaiyuan-comxuekaiyuan-comgithubio仓库结构)
    - [`huzhenghui/posts`仓库结构](#huzhenghuiposts仓库结构)
  - [`xuekaiyuan-com/xuekaiyuan-com.github.io`相关文件](#xuekaiyuan-comxuekaiyuan-comgithubio相关文件)
    - [`xuekaiyuan-com/xuekaiyuan-com.github.io`的 `git submodule`（子模块）](#xuekaiyuan-comxuekaiyuan-comgithubio的-git-submodule子模块)
    - [`xuekaiyuan-com/xuekaiyuan-com.github.io`的`GitHub Action`](#xuekaiyuan-comxuekaiyuan-comgithubio的github-action)
  - [`huzhenghui/posts`的`GitHub Action`相关设置与文件](#huzhenghuiposts的github-action相关设置与文件)
    - [创建`Personal access token`](#创建personal-access-token)
    - [设置`Actions secrets`](#设置actions-secrets)
    - [`huzhenghui/posts`的`GitHub Action`文件](#huzhenghuiposts的github-action文件)
  - [`huzhenghui/posts`的内容](#huzhenghuiposts的内容)
    - [`/_index.md`](#_indexmd)
    - [`/GitHub/README.md`](#githubreadmemd)
    - [`/README.md`](#readmemd)

## 简介

本文讲解如何在一个`GitHub Action`中触发另一个`GitHub Action`，也可以称为`GitHub Action`套娃。
演示网站为

<https://www.xuekaiyuan.com/>

本文发表在

<https://blog.csdn.net/hu_zhenghui/article/details/128741195>

## 仓库

### `xuekaiyuan-com/xuekaiyuan-com.github.io`仓库

仓库位于<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>

相关版本为

[v0.3](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.3)

详见<https://www.xuekaiyuan.com/posts/xuekaiyuan/readme/>

### `huzhenghui/posts`仓库

仓库位于<https://github.com/huzhenghui/posts/>

相关版本为

[v0.1](https://github.com/huzhenghui/posts/tree/v0.1)

## 版本

### `v0.1`

初始版本，位置在

<https://github.com/huzhenghui/posts/tree/v0.1>

## 仓库结构

命令

```shell
tree -a -F -I '.git/'
```

### `xuekaiyuan-com/xuekaiyuan-com.github.io`仓库结构

```text
./
├── .github/
│   └── workflows/
│       └── hugo.yml
├── .gitmodules
└── content/
    └── huzhenghui/
        ├── .git
        ├── .github/
        │   └── workflows/
        │       └── main.yml
        ├── GitHub/
        │   └── README.md
        ├── README.md -> ./GitHub/README.md
        └── _index.md
```

### `huzhenghui/posts`仓库结构

```text
./
├── .github/
│   └── workflows/
│       └── main.yml
├── GitHub/
│   └── README.md
├── README.md -> ./GitHub/README.md
└── _index.md

3 directories, 4 files
```

## `xuekaiyuan-com/xuekaiyuan-com.github.io`相关文件

### `xuekaiyuan-com/xuekaiyuan-com.github.io`的 `git submodule`（子模块）

在<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>中，
运行如下命令将<https://github.com/huzhenghui/posts/>添加为子模块

```shell
git submodule add https://github.com/huzhenghui/posts content/huzhenghui
```

命令中<https://github.com/huzhenghui/posts>为子模块仓库的位置，
`content/huzhenghui`为添加的位置，添加后可以看到`git submodule`（子模块）的配置文件

<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/master/.gitmodules>

```toml
[submodule "content/huzhenghui"]
 path = content/huzhenghui
 url = https://github.com/huzhenghui/posts
```

子模块添加在<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/master/content>，
其中可以看到`huzhenghui`，单击即可进入<https://github.com/huzhenghui/posts/>

### `xuekaiyuan-com/xuekaiyuan-com.github.io`的`GitHub Action`

基于`GitHub`自动创建的`Hugo` `Action`，位置在

<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/master/.github/workflows/hugo.yml>

Since [v0.1](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.1)
使用`GitHub`自动创建的`Hugo` `Action`

<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/v0.1/.github/workflows/hugo.yml>

[v0.3](https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/tree/v0.3)
响应<https://github.com/huzhenghui/posts/>中`GitHub Action`触发的事件，并增加`git submodule`（子模块）自动更新。

<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/blob/v0.3/.github/workflows/hugo.yml>

其中在`on`中增加响应`repository_dispatch`事件，`repository_dispatch`事件在[`huzhenghui/posts`的`GitHub Action`文件](https://www.xuekaiyuan.com/huzhenghui/github/readme/#huzhenghuiposts%E7%9A%84github-action%E6%96%87%E4%BB%B6)中触发。

```diff
 on:
   # Runs on pushes targeting the default branch
   push:
     branches: ["master"]
 
   # Allows you to run this workflow manually from the Actions tab
   workflow_dispatch:
+  repository_dispatch:
```

在`jobs`的`Checkout`之后`Setup Pages`之前增加`Update module`

```diff
       - name: Checkout
         uses: actions/checkout@v3
         with:
           submodules: recursive
+      - name: Update module
+        run: git submodule update --remote
       - name: Setup Pages
         id: pages
         uses: actions/configure-pages@v2
```

## `huzhenghui/posts`的`GitHub Action`相关设置与文件

### 创建`Personal access token`

访问<https://github.com/settings/tokens>，创建`Personal access token`

`Note`设置为易于记住的内容，例如

```text
https://github.com/huzhenghui/posts trigger https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io GitHub Action
```

在`Select scopes`中选中`repo`，创建后记录值，将在[设置`Actions secrets`](#设置actions-secrets)中使用。

### 设置`Actions secrets`

访问<https://github.com/huzhenghui/posts/settings/secrets/actions>，
创建`repository secret`

`Name`设置为便于在`GitHub Action`中使用的名字，例如`TRIGGER_XUEKAIYUAN_COM`，
将在[`huzhenghui/posts`的`GitHub Action`文件](#huzhenghuiposts的github-action文件)中使用。

`Secret`中为[创建`Personal access token`](#创建personal-access-token)记录的值。

### `huzhenghui/posts`的`GitHub Action`文件

手工创建，位置在

<https://github.com/huzhenghui/posts/blob/master/.github/workflows/main.yml>

Since[v0.1](https://github.com/huzhenghui/posts/tree/v0.1)

<https://github.com/huzhenghui/posts/blob/v0.1/.github/workflows/main.yml>

```yaml
name: Trigger https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io GitHub Action

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
      - name: POST https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches
        run: |
          curl \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${{ secrets.TRIGGER_XUEKAIYUAN_COM }}"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches \
            -d '{"event_type":"trigger by https://github.com/huzhenghui/posts/","client_payload":{"unit":false,"integration":true}}'
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
      - name: POST https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches
        run: |
          curl \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${{ secrets.TRIGGER_XUEKAIYUAN_COM }}"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches \
            -d '{"event_type":"trigger by https://github.com/huzhenghui/posts/","client_payload":{"unit":false,"integration":true}}'
```

其中只有一个任务`trigger`，
任务中只有一个步骤`POST https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches`，
运行的命令为

```yaml
        run: |
          curl \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer ${{ secrets.TRIGGER_XUEKAIYUAN_COM }}"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches \
            -d '{"event_type":"trigger by https://github.com/huzhenghui/posts/","client_payload":{"unit":false,"integration":true}}'
```

其中

- `${{ secrets.TRIGGER_XUEKAIYUAN_COM }}`为[设置`Actions secrets`](#设置actions-secrets)的`Name`。
- <https://api.github.com/repos/xuekaiyuan-com/xuekaiyuan-com.github.io/dispatches>为<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/>的`repository_dispatch`事件的接口。
- `"event_type":"trigger by https://github.com/huzhenghui/posts/"`将显示在<https://github.com/xuekaiyuan-com/xuekaiyuan-com.github.io/actions>表示触发来源。

运行后将触发[`xuekaiyuan-com/xuekaiyuan-com.github.io`的`GitHub Action`](#xuekaiyuan-comxuekaiyuan-comgithubio的github-action)。

## `huzhenghui/posts`的内容

### `/_index.md`

索引页，内容显示在

<https://www.xuekaiyuan.com/huzhenghui/>

文件位置在

<https://github.com/huzhenghui/posts/blob/master/_index.md>

Since [v0.1](https://github.com/huzhenghui/posts/tree/v0.1)

<https://github.com/huzhenghui/posts/blob/v0.1/_index.md>

```markdown
---
title: 胡争辉
date: 2023-01-20
publishdate: 2023-01-20
---

<!-- markdownlint-disable-next-line MD025 -->
# 胡争辉

<https://github.com/huzhenghui/posts/>
```

### `/GitHub/README.md`

本文件，位置在

<https://github.com/huzhenghui/posts/blob/master/GitHub/README.md>

Since [v0.1](https://github.com/huzhenghui/posts/tree/v0.1)

<https://github.com/huzhenghui/posts/blob/v0.1/GitHub/README.md>

### `/README.md`

软链接，链接到[`/GitHub/README.md`](#githubreadmemd)

<https://github.com/huzhenghui/posts/blob/master/README.md>

Since [v0.1](https://github.com/huzhenghui/posts/tree/v0.1)

<https://github.com/huzhenghui/posts/blob/v0.1/README.md>
