#!/bin/sh
set -e

root_path=$(cd "$(dirname "$0")" && pwd)
cd ${root_path}

# 1-1-2、**安装编译依赖** `Python` `scons`
python -m pip install scons

#### 1-1-5、**web 手动安装 Emscripten**
source ~/.zshrc
source $EMSDK_ROOT/emsdk_env.sh
emcc --check

# 1-2-2、macOS 编译 template
cd ${root_path}/godot
rm -rf bin/.web_zip
rm -f  bin/godot.side.web.template_*
rm -f  bin/godot.web.template_*

# threads=no javascript_eval=no
scons platform=web custom_modules=../cpp_modules target=template_debug   dlink_enabled=yes
scons platform=web custom_modules=../cpp_modules target=template_release dlink_enabled=yes
