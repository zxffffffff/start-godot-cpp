# start-godot-cpp
一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension

# Godot 4
- 有了重大更新和改变，有很多不兼容 Godot 3 的内容
- 文档选择 en 再手动翻译，**中文文档很多过时内容**
- 选择最新的 `tag 4.0` 分支下载，确认是 **stable** 版本

## C++ modules
- 比 GDExtension 提供更底层的接口支持
- 每次更改都需要编译 Godot 源码（支持动态/静态编译）

### 1.准备工作
- 下载 Godot 源码（已下载至./godot）
  https://github.com/godotengine/godot.git
- 编译参考
  https://docs.godotengine.org/en/stable/contributing/development/compiling/index.html
- **准备开发环境** `Python` `scons`
  ```Bash
  python -m pip install scons
  ```
- **macOS 手动安装 Vulkan**
  https://vulkan.lunarg.com/sdk/home

### 2.使用自定义 modules
- 参考
  https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html
  - 编译Editor `target=editor` （**缺省**）
  - 编译导出模板 `target=template_debug`，`target=template_release`
- **Windows 编译 Godot.exe**
  ```Bash
  cd godot
  scons -j8 platform=windows custom_modules=../cpp_modules vsproj=yes
  ```
- **macOS 编译 Godot.app**
  ```Bash
  cd godot
  scons -j8 platform=macos custom_modules=../cpp_modules
  # 需要额外的命令来生成.app
  cp -r misc/dist/macos_tools.app bin/Godot.app
  mkdir -p bin/Godot.app/Contents/MacOS
  cp bin/godot.macos.editor.arm64 bin/Godot.app/Contents/MacOS/Godot
  chmod +x bin/Godot.app/Contents/MacOS/Godot
  # 解决安全提示 “已损坏，无法打开。 您应该将它移到废纸篓”
  sudo xattr -r -d com.apple.quarantine bin/Godot.app
  ```

## GDExtension
- 不限于 C/C++ 未来可能有更多语言扩展
- 无需编译 Godot 源码

### 1.准备工作
- 下载 C++ 扩展源码（已添加./cpp_extensions/godot-cpp）
  https://github.com/godotengine/godot-cpp.git

### 2.使用自定义 GDExtension
- 参考
  https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html
  - 编译Debug `target=template_debug` （**缺省**）
  - 编译Release `target=template_release`
- **Windows 编译 libgdexample.windows.xxx.dll** 
  ```Bash
  cd cpp_extensions
  scons -j8 platform=windows target=template_release
  ```
- **macOS 编译 libgdexample.macos.xxx.framework**
  ```Bash
  cd cpp_extensions
  scons -j8 platform=macos target=template_release
  ```
- **工程中引用扩展** `my_app/bin/gdexample.gdextension`
  ```
  windows.x86_64="res://bin/libgdexample.windows.template_release.x86_64.dll"
  macos="res://bin/libgdexample.macos.template_release.framework"
  linux.64="res://bin/libgdexample.linux.template_release.64.so"
  ```
