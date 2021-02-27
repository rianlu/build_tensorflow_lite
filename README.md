# 编译Tensorflow Lite 静态库

#### 简介

`fork`的目的主要是记一下几个注意点，防止踩坑，顺便更新下仓库里的脚本，`demo`并未更新，请自行修改



#### 准备

`Tensorflow`版本：`2.4.1`

`NDK`版本：`r18b`

```bash
git clone https://github.com/rianlu/build_tflite_static_library.git

git clone https://github.com/tensorflow/tensorflow.git
```


#### 生成工具链

生成对应架构的工具链

```bash
$ANDROID_NDK/build/tools/make_standalone_toolchain.py --arch arm --api 21 --install-dir arm-android-toolchain

$ANDROID_NDK/build/tools/make_standalone_toolchain.py --arch arm64 --api 21 --install-dir arm64-android-toolchain

$ANDROID_NDK/build/tools/make_standalone_toolchain.py --arch x86 --api 21 --install-dir x86-android-toolchain

$ANDROID_NDK/build/tools/make_standalone_toolchain.py --arch x86_64 --api 21 --install-dir x86_64-android-toolchain
```



#### 修改脚本

下载对应的`Tensorflow`源码，把仓库里的`tensorflow/lite/tools/make/.sh`放到`Tensorflow`源码的对应位置，这里额外添加了`x86`以及`x86_64`的脚本

然后把仓库里的`tensorflow/lite/tools/make/targets/android_makefile.inc`放到`Tensorflow`源码的对应位置，这里已经对`android_makefile.inc`作了修改，可以支持`arm64-v8a`、`armeabi-v7a`、`x86`、`x86_64`四种架构

然后修改`tensorflow/lite/tools/make/.sh`里的`ndk_standalone_root`，使其对应各个架构的工具链



#### 修改Makefile.android

如果使用的是`Tensorflow 2.4.1`可以直接使用仓库里的`Makefile.android`，原仓库里的`Makefile.android`对应的版本是`Tensorflow 2.3.0`，如果是更高版本，作如下修改：

进入到`${tensorflow_root}/tensorflow/lite/tools/make`目录，将`Makefile`改为`Makefile.android`（可以先备份一下）

```ini
# 注释下面两行

# TARGET_TOOLCHAIN_PREFIX :=
# CC_PREFIX :=

# 原
PROFILER_SRCS := \
	tensorflow/lite/profiling/memory_info.cc \
	tensorflow/lite/profiling/platform_profiler.cc \
	tensorflow/lite/profiling/time.cc
	
# 修改后
PROFILER_SRCS := \
	tensorflow/lite/profiling/memory_info.cc \
	tensorflow/lite/profiling/platform_profiler.cc \
	tensorflow/lite/profiling/atrace_profiler.cc \
	tensorflow/lite/profiling/time.cc
	
# 原
ifeq ($(TARGET_ARCH),aarch64)

# 修改后
ifeq ($(findstring $(TARGET_ARCH),  android_armv8a, android_armv7a),)
```



#### 执行脚本

执行`./download_dependencies.sh`，下载`Tensorflow Lite`依赖

执行`chmod +x build_android_xx.sh`以及`./build_android_xx.sh`

可能会出现以下错误：

```bash
fatal error: -f/--auxiliary may not be used without -shared
clang70++: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [/Users/enjoymusic/Development/tensorflow-repository/tensorflow-2.4.1/tensorflow/lite/tools/make/gen/android_armv7a/bin/benchmark_model] Error 1
```

这个对生成的`benchmark-lib.a`可能有影响，但是对`libtensorflow-lite.a`无影响


