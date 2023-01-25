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
