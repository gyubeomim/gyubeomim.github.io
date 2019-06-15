---
layout: post
title: Tensorflow on Drive PX2
description: 
date: 2018-03-27
categories: [Drive PX2]
tags: []
use_math: true
comments: true
---

- Drive PX2에 `Tensorflow`를 설치하려면 `aarch64(arm)` cpu 버전에 맞는 Tensorflow를 설치해야한다
 - 관련 Document가 매우 부족하다
 - 현재 최선의 방법은 `bazel` 이라는 빌드 툴을 사용해서 Tensorflow를 `aarch64` 버전으로 빌드하는 방벙이 최선인듯


<br/>
- Drive PX2 NVIDIA Homepage에 Group 같은거에 Join 하려면 시간이 걸린다
 - Approve 받는데까지 기간이 걸린다
 - 이걸 승인받아야 `DriveInstall 5.0.5.0a Linux 패키지를 다운받을 수 있다
  - 이걸 다운받아야 `CUDA 9.0` 을 Tensorflow가 인식하는듯


<br/>
- `ros-kinetic-dbw-mkz*` 관련 패키지들이 설치되지 않는다
 - `aarch64`를 지원하지 않고 `amd64`만 지원한다

<br><br>
## Installation Guide
- jdk를 설치한다
```bash
$ wget http://openjdk.linaro.org/releases/jdk8u-server-release-1708.tar.xz
$ tar xvf jdk8u-server-release-1708.tar.xz
$ cd jdk8u-server-release-1708
$ export JAVA_HOME=$PWD
$ cd jre/lib/security/
$ rm cacerts
 
$ sudo apt-get install ca-certificates-java -y
$ ln --symbolic /etc/ssl/certs/java/cacerts . 
 
$ cd jdk8u-server-release-1708/bin
$ export PATH=$PWD:$PATH
```

- pip로 파이썬 패키지들을 설치한다

```bash
sudo apt-get install python-numpy python-dev python-pip python-wheel python-virtualenv

```

- `bazel`을 설치한다

```bash
# Pre-requisites for Bazel
$ sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
 
$ wget https://github.com/bazelbuild/bazel/releases/download/0.11.1/bazel-0.11.1-dist.zip
$ mkdir bazel-0.11.1
$ unzip bazel-0.11.1-dist.zip -d bazel-0.11.1
$ cd bazel-0.11.1
```

- `bazel` 코드 중 아래 코드를 추가한다 (`aarch64`용)

```bash
diff --git a/scripts/bootstrap/buildenv.sh b/scripts/bootstrap/buildenv.sh
index 502f2c1..a2ab4dc 100755
--- a/scripts/bootstrap/buildenv.sh
+++ b/scripts/bootstrap/buildenv.sh
@@ -40,7 +40,7 @@ PLATFORM="$(uname -s | tr 'A-Z' 'a-z')"
 
 MACHINE_TYPE="$(uname -m)"
 MACHINE_IS_64BIT='no'
-if [ "${MACHINE_TYPE}" = 'amd64' -o "${MACHINE_TYPE}" = 'x86_64' -o "${MACHINE_TYPE}" = 's390x' ]; then
+if [ "${MACHINE_TYPE}" = 'amd64' -o "${MACHINE_TYPE}" = 'x86_64' -o "${MACHINE_TYPE}" = 's390x'  -o "${MACHINE_TYPE}" = 'aarch64' ]; then
   MACHINE_IS_64BIT='yes'
 fi
 
diff --git a/src/main/java/com/google/devtools/build/lib/util/CPU.java b/src/main/java/com/google/devtools/build/lib/util/CPU.java
index 7a85c29..e5f3eae 100755
--- a/src/main/java/com/google/devtools/build/lib/util/CPU.java
+++ b/src/main/java/com/google/devtools/build/lib/util/CPU.java
@@ -26,6 +26,7 @@ public enum CPU {
   X86_64("x86_64", ImmutableSet.of("amd64", "x86_64", "x64")),
   PPC("ppc", ImmutableSet.of("ppc", "ppc64", "ppc64le")),
   ARM("arm", ImmutableSet.of("arm", "armv7l")),
+  AARCH64("aarch64", ImmutableSet.of("aarch64")),
   S390X("s390x", ImmutableSet.of("s390x", "s390")),
   UNKNOWN("unknown", ImmutableSet.<String>of());
  
diff --git a/third_party/BUILD b/third_party/BUILD
index 9cd2fac..f1cd14c 100755
--- a/third_party/BUILD
+++ b/third_party/BUILD
@@ -583,6 +583,11 @@ config_setting(
 )
 
 config_setting(
+    name = "aarch64",
+    values = {"host_cpu": "aarch64"},
+)
+
+config_setting(
     name = "freebsd",
     values = {"host_cpu": "freebsd"},
 )

```

- 위 코드를 추가하고 아래 명령어를 실행해서 `bazel` 바이너리 파일을 만든다

```bash
$ ./compile.sh

#Copy bazel to $PATH
$ sudo cp output/bazel /usr/local/bin/
```

- `tensorflow`를 클론하고 아래 명령어를 실행해서 `aarch64` 용 `tensorflow` 를 빌드한다

```bash
$ git clone https://github.com/tensorflow/tensorflow/tree/37aa430d84ced579342a4044c89c236664be7f68

$ ./configure # disable everything 

$ bazel build -c opt --local_resources 2000,3.0,2.0 --verbose_failures tensorflow/tools/pip_package:build_pip_package

$ bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

```

- 생성된 `whl` 파일을 설치한다

```bash

$ cd /tmp/tensorflow_pkg
$ sudo pip install ....whl

```




- - -
# CUDA && CuDNN
- - -
```bash
$ sudo su
$ ./drive-setup.sh install-run-once-pkgs (not working)

# CUDA 8.0 for arm64 download
$ wget http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/006/linux-x64/cuda-repo-l4t-8-0-local_8.0.34-1_arm64.deb

$ sudo dpkg -i ...
$ sudo apt-get update
$ sudo apt-get install cuda-toolkit-8-0 -y
```

```bash
# in tensorflow github repo
# CDUA Compute Compatability : 6.2 (for Drive PX2)
$ ./configure

$ sudo apt-get install g++-4.9* g++-5* -y (not working)

```


```bash
$ bazel build --config=opt --verbose_failures --config=cuda //tensorflow/tools/pip_package:build_pip_packages

CUDA 9.0 && CuDNN 7.0 && Tensorflow 1.6.0 && bazel 0.11.1 (설치 실패)
CUDA 9.0 && CuDNN 7.0 && Tensorflow 1.6.0 && bazel 0.5.4 (설치 실패)
CUDA 8.0 && CuDNN 7.0 && Tensorflow 1.4.0 && bazel 0.5.4 (설치 실패)
CUDA 8.0 && CuDNN 6.0 && Tensorflow 1.4.0 && bazel 0.5.4 (설치 실패)
CUDA 8.0 && CuDNN 5.0 && Tensorflow 1.4.0 && bazel 0.5.4 (설치 실패)
CUDA 8.0 && CuDNN 5.0 && Tensorflow 1.3.0 && bazel 0.5.4 (설치 실패)(bazel 명령이 안먹힘)
CUDA 8.0 && CuDNN 5.0 && Tensorflow 1.2.0 && bazel 0.5.4 (설치 실패)(bazel 명령어 안먹힘))


```

- DriveInstall-5.0.5.0 버전을 설치해야한다
	- developer.nvidia.com forum에 접근제한이 걸려있어 설치하지 못하고 있다
	- 현재 `snu.ac.kr` 이메일 주소로 application을 submit한 상태


- - -
- <https://collaborate.linaro.org/display/BDTS/Building+and+Installing+Tensorflow+on+AArch64>
- <https://github.com/itdaniher/aarch64-tensorflow>
- <https://devtalk.nvidia.com/default/topic/982848/jetson-tx1/tx1-specific-arm64-deb-repo-for-cuda-8/post/5063154/>
