# start-godot-cpp
一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension


## C++ modules
- https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html#doc-custom-modules-in-c
- 比 GDExtension 提供更底层的接口支持
- 每次更改都需要编译 Godot 源码（支持动态/静态编译）

### 1.准备工作
- 下载 Godot 源码
- 开发环境 `python -m pip install scons`

### 2.使用自定义 modules
- 参考 `cpp_modules`
- 编译 `scons -j8 platform=windows custom_modules=C:\path\to\cpp_modules`


## GDExtension
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/what_is_gdextension.html
- 不限于 C/C++ 未来可能有更多语言扩展
- 无需编译 Godot 源码

### 1.准备工作
- C++ 扩展依赖 https://github.com/godotengine/godot-cpp
- `git submodule update --init`

### 2.使用自定义 GDExtension
- 参考 `godot-cpp` `cpp_extensions` `SConstruct` `my_app\bin\gdexample.gdextension`
- 编译 `scons -j8 platform=windows target=template_release`

