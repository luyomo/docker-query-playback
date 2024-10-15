FROM centos:centos7 as compiler

COPY ./config/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum update -y && yum -y install tbb tbb-devel cmake boost boost-devel make gcc-c++ mariadb-devel.x86_64 git

RUN git clone https://github.com/Percona-Lab/query-playback.git

RUN mkdir query-playback/build_dir && cd query-playback/build_dir && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && make

FROM centos:centos7

RUN --mount=type=bind,from=compiler,source=/query-playback/build_dir/,target=/query-playback/build_dir cp /query-playback/build_dir/percona-playback /

COPY ./config/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum update -y && yum -y install boost tbb mariadb.x86_64 && yum clean -y all

ENTRYPOINT ["/percona-playback"]
