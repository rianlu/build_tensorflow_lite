#!/bin/bash
# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

set -x
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TENSORFLOW_DIR="${SCRIPT_DIR}/../../../.."

FREE_MEM="$(free -m | awk '/^Mem/ {print $2}')"
# Use "-j 4" only memory is larger than 2GB
if [[ "FREE_MEM" -gt "2000" ]]; then
  NO_JOB=4
else
  NO_JOB=1
fi

# EXTRA_CXXFLAGS="-sysroot=/opt/ndk/standalone-toolchain/ndkr20-aarch64/sysroot"

export ndk_standalone_root="/Users/lu/Development/android_toolchains/arm64-android-toolchain"
export EXTRA_CXXFLAGS="-isysroot=${ndk_standalone_root}/sysroot"
export CC_PREFIX=${ndk_standalone_root}/bin/

make -j ${NO_JOB} TARGET=android_armv8a -C "${TENSORFLOW_DIR}" -f tensorflow/lite/tools/make/Makefile.android $@

