#!/bin/sh
set -e

root_path=$(cd "$(dirname "$0")" && pwd)
cd ${root_path}

# 1-1-2、**安装编译依赖** `Python` `scons`
python -m pip install scons

# 1-2-2、macOS 编译 template
cd ${root_path}/godot
rm -rf bin/macos_template.app
rm -f  bin/macos_template.zip
rm -f  bin/godot.macos.template_*

scons platform=macos custom_modules=../cpp_modules target=template_debug arch=x86_64
scons platform=macos custom_modules=../cpp_modules target=template_debug arch=arm64
scons platform=macos custom_modules=../cpp_modules target=template_release arch=x86_64
scons platform=macos custom_modules=../cpp_modules target=template_release arch=arm64

# 需要额外的命令来生成 Godot.app
cp -r misc/dist/macos_tools.app bin/Godot.app
mkdir -p bin/Godot.app/Contents/MacOS
cp bin/godot.macos.editor.arm64 bin/Godot.app/Contents/MacOS/Godot
chmod +x bin/Godot.app/Contents/MacOS/Godot

# 需要额外的命令来生成 macos_template.zip
lipo -create bin/godot.macos.template_release.x86_64 bin/godot.macos.template_release.arm64 -output bin/godot.macos.template_release.universal
lipo -create bin/godot.macos.template_debug.x86_64 bin/godot.macos.template_debug.arm64 -output bin/godot.macos.template_debug.universal

cp -r misc/dist/macos_template.app bin/macos_template.app
mkdir -p bin/macos_template.app/Contents/MacOS
cp bin/godot.macos.template_release.universal bin/macos_template.app/Contents/MacOS/godot_macos_release.universal
cp bin/godot.macos.template_debug.universal bin/macos_template.app/Contents/MacOS/godot_macos_debug.universal
chmod +x bin/macos_template.app/Contents/MacOS/godot_macos*

# 解决安全提示 “已损坏，无法打开。 您应该将它移到废纸篓”
sudo xattr -r -d com.apple.quarantine bin/macos_template.app

zip -q -9 -r bin/macos_template.zip bin/macos_template.app
