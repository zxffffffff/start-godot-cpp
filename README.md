# start-godot-cpp
一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension


## C++ modules
- https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html#doc-custom-modules-in-c
- 比 GDExtension 提供更底层的接口支持
- 每次更改都需要编译 Godot 源码（支持动态/静态编译）

### 1.准备工作
- 下载 Godot 源码（已添加subtree）
  ```
  git subtree add --prefix=godot https://github.com/godotengine/godot 4.0 --squash
  ```
- 开发环境 
  ```
  python -m pip install scons
  ```

### 2.使用自定义 modules
- 编译参考 https://docs.godotengine.org/en/stable/contributing/development/compiling/index.html
- 模块参考 https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html
- Windows 编译 Godot + cpp_modules
  ```
  cd /path/to/godot
  scons -j8 platform=windows target=template_release custom_modules=/path/to/cpp_modules
  ```
- macOS 编译
  ```
  cd /path/to/godot
  scons -j8 platform=macos target=template_release custom_modules=/path/to/cpp_modules
  # 需要额外的命令来生成.app
  cp -r misc/dist/macos_tools.app ./Godot.app
  mkdir -p Godot.app/Contents/MacOS
  cp bin/godot.macos.editor.arm64 Godot.app/Contents/MacOS/Godot
  chmod +x Godot.app/Contents/MacOS/Godot
  ```

## GDExtension
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/what_is_gdextension.html
- 不限于 C/C++ 未来可能有更多语言扩展
- 无需编译 Godot 源码

### 1.准备工作
- 下载 C++ 扩展源码（已添加subtree）
  ```
  git subtree add --prefix=cpp_extensions/godot-cpp https://github.com/godotengine/godot-cpp 4.0 --squash
  ```

### 2.使用自定义 GDExtension
- 参考 https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html
- Windows 编译 cpp_extensions 
  ```
  cd cpp_extensions
  scons -j8 platform=windows target=template_release
  ```
- macOS 编译
  ```
  cd cpp_extensions
  scons -j8 platform=macos target=template_release
  ```
- 工程添加扩展 `my_app/bin/gdexample.gdextension`
