---
layout: post
title: Drive PX2 Installations
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


- Drive PX2 NVIDIA Homepage에 Group 같은거에 Join 하려면 시간이 걸린다
 - Approve 받는데까지 기간이 걸린다
 - 이걸 승인받아야 `DriveInstall 5.0.5.0a Linux 패키지를 다운받을 수 있다
  - 이걸 다운받아야 `CUDA 9.0` 을 Tensorflow가 인식하는듯


- `ros-kinetic-dbw-mkz*` 관련 패키지들이 설치되지 않는다
 - `aarch64`를 지원하지 않고 `amd64`만 지원한다


```bash
$ sudo su
$ ./drive-setup.sh install-run-once-pkgs (not working)


- - -

$ wget http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/006/linux-x64/cuda-repo-l4t-8-0-local_8.0.34-1_arm64.deb

$ sudo dpkg -i ...
$ sudo apt-get update
$ sudo apt-get install cuda-toolkit-8-0
```


```bash
CUDA 8.0 && CuDNN 6.0
Tensorflow 1.4.0

in tensorflow github repo
$ ./configure

$ sudo apt-get install g++-4.9* g++-5* -y

```

- <https://devtalk.nvidia.com/default/topic/982848/jetson-tx1/tx1-specific-arm64-deb-repo-for-cuda-8/post/5063154/>
- <https://collaborate.linaro.org/display/BDTS/Building+and+Installing+Tensorflow+on+AArch64>
