FROM centos:centos7.6.1810 
# 镜像的作者 
LABEL maintainer="<469288592@qq.com>" 

COPY resource /tmp/resource

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    TIME_ZONE=Asia/Shanghai

RUN localedef -v -c -i en_US -f UTF-8 zh_CN.UTF-8 >/dev/null 2>&1 &&\
    grep -q 'zh_CN.utf8' /etc/locale.conf || sed -i -E 's/^LANG=.*/LANG="zh_CN.UTF-8"/' /etc/locale.conf &&\
    yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm &&\
    yum install -y ntp yum-plugin-fastestmirror vim-enhanced ntp wget bash-completion elinks lrzsz unix2dos dos2unix git unzip net-tools cronie sudo tar &&\
    yum install -y rpm-build.x86_64 lua-devel sqlite-devel rpmdevtools mock &&\
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel &&\
    yum-config-manager --add-repo http://mirrors.xuncetech.com/xunce/xunce-dev/yum/el7/xunce-dev.repo &&\
    yum-config-manager --add-repo http://mirrors.xuncetech.com/xunce/AssetDataCenter/yum/AssetDataCenter.repo &&\
    yum install -y epel-release &&\
    yum install -y \
                 which \
                 gdb \
                 cmake-3.12.3 \
                 libtool \
                 gettext-devel \
                 unixODBC-devel \
                 openssl-devel \
                 libuv-1.22.0 \
                 libzmq-4.2.1 \
                 spdlog-1.1.0 \
                 protobuf-3.6.1 \
                 jsoncpp-1.8.0 \
                 hiredis-0.14.0 \
                 tinyxml2-7.0.0 \
                 librdkafka-1.1.0 \
                 libcurl \
                 libcurl-devel \
                 oracle-instantclient11.2-basic-11.2.0.4.0 \
                 oracle-instantclient11.2-dummy-1.0 \
                 oracle-instantclient11.2-devel-11.2.0.4.0 \
                 hiredis-vip-1.0.0 &&\
    yum install -y centos-release-scl &&\
    yum install -y devtoolset-7-gcc* &&\
    yum install -y devtoolset-7-make &&\
    scl enable devtoolset-7 bash &&\
    which gcc &&\
    gcc --version &&\
    echo "source /opt/rh/devtoolset-7/enable" >> /etc/profile &&\
    rpmdev-setuptree &&\
    dos2unix /tmp/resource/*sh && \
    cp -r /tmp/resource/agent.jar /usr/bin/agent.jar && \
    cp -r /tmp/resource/jenkins.sh /usr/local/bin/jenkins.sh && \
    chmod +x /usr/bin/agent.jar && chmod +x /usr/local/bin/jenkins.sh && \
    mkdir -p /data/jenkins_home && \
    cp -f /usr/include/librdkafka/rdkafka* /usr/include/ && \
    ln -nfs  /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    yum clean all && rm -fr /tmp/resource


WORKDIR /data/jenkins_home

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
