FROM ubuntu:14.04

# 更新阿里源
COPY sources.list /etc/apt/sources.list
RUN apt-get clean
RUN apt-get update

# 解决 debconf: unable to initialzie frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# 配置系统语言环境和时区
RUN apt-get install -y language-pack-zh-hant language-pack-zh-hans
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

# 添加64位系统对32位支持
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0

# 安装源码所需编译工具
RUN apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib
RUN apt-get install -y libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev python
RUN apt-get install -y libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip

# 配置java环境（这里使用openjdk-7）
# 注：Android5.x - Android 6.0编译需要用jdk7，Android7.0及其以上需要用jdk8
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH=$JAVA_HOME/bin:$PATH
