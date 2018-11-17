---
layout: post
title: ROS Installation Guide on Drive PX2
description: 
date: 2018-04-02
categories: [Drive PX2]
tags: []
use_math: true
---

```bash
# ros kinetic 설치방법은 AMDx64 CPU 버전과 동일합니다
$ sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

$ sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# ROS kinetic 패키지 설치
$ sudo apt-get install ros-kinetic-desktop-full

# ROS 의존성 패키지들 설치
$ sudo rosdep init
$ rosdep update
$ sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential

# ROS dyros packages 의존성 패키지 설치
$ sudo apt-get install ros-kinetic-ompl ros-kinetic-pcl*
```

- - -
- <http://wiki.ros.org/Installation/UbuntuARM>
