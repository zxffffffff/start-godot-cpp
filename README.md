# start-godot-cpp

一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension，导出到所有平台 (PC, Mobile, Web)

# Godot 

选择最新的 `tag 4.x` 分支下载，确认是 **stable** 版本。

文档选择 en 再手动翻译，**中文文档很多过时内容**。

> 版本更新不兼容历史版本（3->4，4.0->4.1），参考文档：
> https://docs.godotengine.org/zh-cn/4.x/tutorials/migrating/index.html

## 【1】C++ modules

比 GDExtension 提供更底层的接口支持。

每次更改都需要编译 Godot 源码（支持动态/静态编译）

### 【1.1】准备工作

#### 下载 Godot 源码（使用 `git submodule` 添加至 `./godot`）
> git submodule add -b 4.2 https://github.com/godotengine/godot.git ./godot  

编译流程文档：
> https://docs.godotengine.org/en/stable/contributing/development/compiling/index.html

#### **安装开发依赖** `Python` `scons`

官网下载安装python最新版，macOS需要运行`Install Certificates.command`信任证书
> https://www.python.org/

```Bash
python -m pip install scons
```

#### **macOS 手动安装 Vulkan**
> https://vulkan.lunarg.com/sdk/home

#### **web 手动安装 Emscripten**
> https://emscripten.org/

```Bash
cd # 软件安装目录，mac建议“/Users/xxx”，win建议“C://Program Files”
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull

# win
./emsdk.bat install latest  # 下载安装tools
./emsdk.bat activate latest # 激活当前sdk
./emsdk_env.bat             # 添加环境变量
./emcmdprompt.bat           # 打开terminal新窗口（建议）

# mac
./emsdk install latest  
./emsdk activate latest 
source ./emsdk_env.sh       # 添加环境变量（每次打开terminal新窗口都要调用！）

# 检查
emcc --check
```

### 【1.2】源码编译 Editor & Template

> https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html

- 平台 `platform=windows`，`platform=macos`，`platform=web`

- 编译 Editor `target=editor` （**缺省**）

- 编译导出模板 Template `target=template_debug`，`target=template_release`

#### **Windows 编译 editor.exe 和 template.dll**
```Bash
cd godot
scons -j8 platform=windows custom_modules=../cpp_modules
scons -j8 platform=windows custom_modules=../cpp_modules target=template_debug
scons -j8 platform=windows custom_modules=../cpp_modules target=template_release
```

#### **macOS 编译 Godot.app 和 template.so**
```Bash
cd godot
scons -j8 platform=macos custom_modules=../cpp_modules
scons -j8 platform=macos custom_modules=../cpp_modules target=template_debug
scons -j8 platform=macos custom_modules=../cpp_modules target=template_release
# 需要额外的命令来生成.app
cp -r misc/dist/macos_tools.app bin/Godot.app
mkdir -p bin/Godot.app/Contents/MacOS
cp bin/godot.macos.editor.arm64 bin/Godot.app/Contents/MacOS/Godot
chmod +x bin/Godot.app/Contents/MacOS/Godot
# 解决安全提示 “已损坏，无法打开。 您应该将它移到废纸篓”
sudo xattr -r -d com.apple.quarantine bin/Godot.app
```

#### **Web 编译 Template.zip**
```Bash
cd godot
# 注意需要 emsdk_env 环境，否则识别不到 web
# JS单例存在安全风险，可选关闭：javascript_eval=no
# 开启 GDExtension：dlink_enabled=yes
scons -j8 platform=web custom_modules=../cpp_modules target=template_debug javascript_eval=no dlink_enabled=yes
scons -j8 platform=web custom_modules=../cpp_modules target=template_release javascript_eval=no dlink_enabled=yes
```

## 【2】GDExtension (C++ binding)

引擎与脚本交互的一层抽象层，可以支持任意编程语言（官方 GDScript C++ C# 社区 Rust）

无需编译 Godot 源码。

### 【2.1】准备工作

下载 C++ 扩展源码（使用 `git submodule` 添加至 `./cpp_extensions/godot-cpp`）
> git submodule add -b 4.2 https://github.com/godotengine/godot-cpp.git ./cpp_extensions/godot-cpp

#### **4.1 增加步骤** 生成扩展元数据
```Bash
cd godot/bin
godot.xxx.editor.xxx --dump-extension-api extension_api.json
```

### 【2.2】编译扩展库

> https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html

- 编译 Debug `target=template_debug` （**缺省**）
- 编译 Release `target=template_release`
- **4.1 增加步骤** 绑定扩展元数据 `custom_api_file=<PATH_TO_FILE>`

#### **Windows 编译 libgdexample.windows.xxx.dll**
```Bash
cd cpp_extensions
scons -j8 platform=windows custom_api_file=../godot/bin/extension_api.json
```

#### **macOS 编译 libgdexample.macos.xxx.framework**
```Bash
cd cpp_extensions
scons -j8 platform=macos custom_api_file=../godot/bin/extension_api.json
```

### 【2.3】项目中引用扩展库

配置文件：
> `my_app/bin/gdexample.gdextension`

配置参数：
```Bash
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
