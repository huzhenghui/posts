#!/bin/sh
echo pandoc --version
pandoc --version
echo ls -al ./dist/Pandocomatic/
ls -al ./dist/Pandocomatic/
echo apt-get update
apt-get update
echo apt-get install --assume-yes --no-install-recommends ruby
apt-get install --assume-yes --no-install-recommends ruby
echo gem install pandocomatic
gem install pandocomatic
echo pandocomatic
pandocomatic --debug --input . --output ./dist/Pandocomatic/ --config ./Pandocomatic/pandocomatic.yaml
