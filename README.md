# start-godot-cpp
一个 Godot 脚手架项目，使用源码编译扩展 C++ modules/GDExtension

## GDExtension
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/what_is_gdextension.html
- 不限于 C/C++ 未来可能有更多语言扩展
- 无需编译 Godot 源码

## C++ modules
- https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html#doc-custom-modules-in-c
- 比 GDExtension 提供更底层的接口支持
- 每次更改都需要编译 Godot 源码（支持动态/静态编译）
- `scons -j8 platform=windows custom_modules=C:\path\to\cpp_modules`

