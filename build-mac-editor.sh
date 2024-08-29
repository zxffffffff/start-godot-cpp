#!/bin/sh
set -e

root_path=$(cd "$(dirname "$0")" && pwd)
cd ${root_path}

# 1-1-2、**安装编译依赖** `Python` `scons`
python -m pip install scons

# 1-2-2、macOS 编译 Godot.app
cd ${root_path}/godot
rm -rf bin/Godot.app
rm -f  bin/godot.macos.editor.arm64
rm -f  bin/extension_api.json

scons -j8 platform=macos custom_modules=../cpp_modules target=editor arch=arm64

# 需要额外的命令来生成 Godot.app
cp -r misc/dist/macos_tools.app bin/Godot.app
mkdir -p bin/Godot.app/Contents/MacOS
cp bin/godot.macos.editor.arm64 bin/Godot.app/Contents/MacOS/Godot
chmod +x bin/Godot.app/Contents/MacOS/Godot

# 解决安全提示 “已损坏，无法打开。 您应该将它移到废纸篓”
sudo xattr -r -d com.apple.quarantine bin/Godot.app

# 2-1-1、4.1 增加步骤 生成扩展元数据
cd ${root_path}/godot/bin

# 注意 macOS 命令行位于 Godot.app/Contents/MacOS/Godot
Godot.app/Contents/MacOS/Godot --dump-extension-api extension_api.json
