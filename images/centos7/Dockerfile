FROM centos:7

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=http://mirror.facebook.net/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo

RUN \
    yum update -y \
    && yum install -y epel-release \
    && yum install -y --nogpgcheck \
        cmake3 \
        vim \
        wget \
        git \
        make \
        gcc \
        gcc-c++ \
        scl-utils \
        centos-release-scl \
    && yum install -y --nogpgcheck \
        devtoolset-11* \
        rh-python36

# enable cmake
RUN ln -s /bin/cmake3 /bin/cmake

# Test gcc-11
RUN scl enable devtoolset-11 "gcc --version"
RUN scl enable devtoolset-11 "g++ --version"

# install conan
RUN scl enable rh-python36 "python --version"
RUN scl enable rh-python36 "pip install --upgrade pip && pip install conan && conan --version"