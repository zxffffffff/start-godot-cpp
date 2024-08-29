#!/bin/sh
set -e

root_path=$(cd "$(dirname "$0")" && pwd)
cd ${root_path}

# 2-2-2、macOS 编译 libgdexample.macos.xxx.framework
cd ${root_path}/cpp_extensions

scons -j8 platform=macos custom_api_file=../godot/bin/extension_api.json target=template_debug
scons -j8 platform=macos custom_api_file=../godot/bin/extension_api.json target=template_release
