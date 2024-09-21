#!/bin/sh
set -e

root_path=$(cd "$(dirname "$0")" && pwd)
cd ${root_path}

#### 1-1-5、**web 手动安装 Emscripten**
source ~/.zshrc
source $EMSDK_ROOT/emsdk_env.sh
emcc --check

# 2-2-2、macOS 编译 libgdexample.macos.xxx.framework
cd ${root_path}/cpp_extensions

# threads=no
scons platform=web custom_api_file=../godot/bin/extension_api.json target=template_debug
scons platform=web custom_api_file=../godot/bin/extension_api.json target=template_release

# 移动到 my_app
mv bin/* ../my_app/bin/
