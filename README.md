# start-godot-cpp

一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension 和 C#，导出到所有平台 (PC, Mobile, Web)


# Godot 

选择最新的 `tag 4.x` 分支下载，确认是 **stable** 版本。

文档选择 en 再手动翻译，**中文文档很多过时内容**。

版本更新不兼容历史版本 (3.x -> 4.0 -> 4.1 -> 4.2) 参考文档：https://docs.godotengine.org/zh-cn/4.x/tutorials/migrating/index.html


## 1、源码编译 (C++ modules 和 C#)

`C++ modules` 是比 GDExtension 提供更底层的接口支持，每次更改都需要编译 Godot 源码 (支持动态/静态编译)

**4.2 新增 `C#` 支持**，Android 需要 .NET 7.0，iOS 需要 .NET 8.0，暂不支持 Web。

### 1-1、准备工作

编译流程文档：https://docs.godotengine.org/en/stable/contributing/development/compiling/index.html

#### 1-1-1、下载 Godot 源码 (使用 `git submodule` 添加至 `./godot`)

```bash
# 已添加，无需执行，仅作参考
git submodule add -b 4.2 https://github.com/godotengine/godot.git ./godot 
```

#### 1-1-2、**安装编译依赖** `Python` `scons`

官网下载安装python最新版，macOS需要运行 `Install Certificates.command` 信任证书：https://www.python.org/

```bash
python -m pip install scons
```

#### 1-1-3、**4.2 新增 `C#` 支持，手动安装 `.NET SDK`**

下载安装：https://dotnet.microsoft.com/download

```bash
# 检查安装版本，最低 6.0+，建议 8.0+
dotnet --info
```

#### 1-1-4、**macOS 手动安装 Vulkan**

下载安装：https://vulkan.lunarg.com/sdk/home

#### 1-1-5、**web 手动安装 Emscripten**

下载安装：https://emscripten.org/

```bash
cd # 软件安装目录，mac建议“/Users/xxx”，win建议“C://Program Files”
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull

# win
./emsdk.bat install latest  # 下载安装tools
./emsdk.bat activate latest # 激活当前sdk
./emsdk_env.bat             # 添加环境变量
./emcmdprompt.bat           # 打开terminal新窗口 (建议)

# mac
./emsdk install latest  
./emsdk activate latest 
source ./emsdk_env.sh       # 添加环境变量 (每次打开terminal新窗口都要调用！)

# 检查
emcc --check
```

### 1-2、源码编译 Editor & Template

C++ modules 参考：https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html

C# 参考：https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_with_dotnet.html

- 平台 `platform=windows`，`platform=macos`，`platform=web`

- 编译 Editor `target=editor` (**缺省**)

- 编译导出模板 Template `target=template_debug`，`target=template_release` (模板用于打包发布)

- **4.2 新增 `C#` 支持** `module_mono_enabled=yes`

#### 1-2-1、**Windows 编译 editor.exe 和 template.dll**

```bash
cd godot

scons -j8 platform=windows custom_modules=../cpp_modules target=editor module_mono_enabled=yes
scons -j8 platform=windows custom_modules=../cpp_modules target=template_debug module_mono_enabled=yes
scons -j8 platform=windows custom_modules=../cpp_modules target=template_release module_mono_enabled=yes
```

#### 1-2-2、**macOS 编译 Godot.app 和 template.zip**

```bash
cd godot

scons -j8 platform=macos custom_modules=../cpp_modules target=editor module_mono_enabled=yes
scons -j8 platform=macos custom_modules=../cpp_modules target=template_debug module_mono_enabled=yes
scons -j8 platform=macos custom_modules=../cpp_modules target=template_release module_mono_enabled=yes

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
zip -q -9 -r bin/macos_template.zip bin/macos_template.app

# C# 还需拷贝 GodotSharp，参考 1-2-4
cp -R bin/GodotSharp bin/Godot.app/Contents/Resources/GodotSharp

# 解决安全提示 “已损坏，无法打开。 您应该将它移到废纸篓”
sudo xattr -r -d com.apple.quarantine bin/Godot.app
```

#### 1-2-3、**Web 编译 Template.zip**

```bash
cd godot

# 注意需要 emsdk_env 环境，否则识别不到 web
# JS单例存在安全风险，可选关闭：javascript_eval=no
# 开启 GDExtension：dlink_enabled=yes
scons -j8 platform=web custom_modules=../cpp_modules target=template_debug javascript_eval=no dlink_enabled=yes
scons -j8 platform=web custom_modules=../cpp_modules target=template_release javascript_eval=no dlink_enabled=yes
```

#### 1-2-4、**4.2 新增 `C#` 支持，生成 glue(胶水层) 和 assemblies(托管库)**

```bash
cd godot

# Generate glue sources
./bin/<godot_editor_mono> --headless --generate-mono-glue modules/mono/glue

# Build .NET assemblies <windows, macos, linux>
# --push-nupkgs-local 添加到本地源
python ./modules/mono/build_scripts/build_assemblies.py --godot-output-dir=./bin --push-nupkgs-local=./bin/MyLocalNugetSource --godot-platform=<platform>

# 项目报错找不到 Godot.NET.Sdk，需要执行命令恢复
cd my_app
nuget restore
```


## 2、GDExtension (C++ binding)

引擎与脚本交互的一层抽象层，可以支持任意编程语言 (C++)，无需编译 Godot 源码。

### 2-1、准备工作

下载 C++ 扩展源码 (使用 `git submodule` 添加至 `./cpp_extensions/godot-cpp`)

```bash
# 已添加，无需执行，仅作参考
git submodule add -b 4.2 https://github.com/godotengine/godot-cpp.git ./cpp_extensions/godot-cpp
```

#### 2-1-1、**4.1 增加步骤** 生成扩展元数据

```bash
cd godot/bin

# 注意 macOS 命令行位于
Godot.app/Contents/MacOS/Godot --dump-extension-api extension_api.json
```

### 2-2、编译扩展库

参考：https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html

- 编译 Debug `target=template_debug` (**缺省**)
- 编译 Release `target=template_release`
- **4.1 增加步骤** 绑定扩展元数据 `custom_api_file=<PATH_TO_FILE>`

#### 2-2-1、**Windows 编译 libgdexample.windows.xxx.dll**

```bash
cd cpp_extensions

scons -j8 platform=windows custom_api_file=../godot/bin/extension_api.json target=template_debug
scons -j8 platform=windows custom_api_file=../godot/bin/extension_api.json target=template_release
```

#### 2-2-2、**macOS 编译 libgdexample.macos.xxx.framework**

```bash
cd cpp_extensions

scons -j8 platform=macos custom_api_file=../godot/bin/extension_api.json target=template_debug
scons -j8 platform=macos custom_api_file=../godot/bin/extension_api.json target=template_release
```

### 2-3、项目中引用扩展库

配置文件：`my_app/bin/gdexample.gdextension`

配置参数：
```bash
macos.debug = "res://bin/libgdexample.macos.template_debug.framework"
macos.release = "res://bin/libgdexample.macos.template_release.framework"
windows.debug.x86_32 = "res://bin/libgdexample.windows.template_debug.x86_32.dll"
windows.release.x86_32 = "res://bin/libgdexample.windows.template_release.x86_32.dll"
windows.debug.x86_64 = "res://bin/libgdexample.windows.template_debug.x86_64.dll"
windows.release.x86_64 = "res://bin/libgdexample.windows.template_release.x86_64.dll"
linux.debug.x86_64 = "res://bin/libgdexample.linux.template_debug.x86_64.so"
linux.release.x86_64 = "res://bin/libgdexample.linux.template_release.x86_64.so"
linux.debug.arm64 = "res://bin/libgdexample.linux.template_debug.arm64.so"
linux.release.arm64 = "res://bin/libgdexample.linux.template_release.arm64.so"
linux.debug.rv64 = "res://bin/libgdexample.linux.template_debug.rv64.so"
linux.release.rv64 = "res://bin/libgdexample.linux.template_release.rv64.so"
android.debug.x86_64 = "res://bin/libgdexample.android.template_debug.x86_64.so"
android.release.x86_64 = "res://bin/libgdexample.android.template_release.x86_64.so"
android.debug.arm64 = "res://bin/libgdexample.android.template_debug.arm64.so"
android.release.arm64 = "res://bin/libgdexample.android.template_release.arm64.so"
```
