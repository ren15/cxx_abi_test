set -xe

docker build -t local_centos7:latest images/centos7

docker run \
    -v ${PWD}:/app \
    local_centos7:latest \
    bash -c "scl enable devtoolset-11 'cd /app && g++ --version && g++ src/main.cpp src/f.cpp'"

strings a.out | grep f_to_locate

readelf -p .comment a.out

rm -f a.out


docker run \
    -v ${PWD}:/app \
    local_centos7:latest \
    bash -c "scl enable devtoolset-11 'cd /app && g++ --version && g++ -c -o f.o src/f.cpp && g++ -shared -o libf.so f.o'"

readelf -p .comment libf.so

strings libf.so | grep f_to_locate

rm -f libf.so f.o


