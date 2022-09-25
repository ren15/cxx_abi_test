set -xe

export DOCKER_IMAGE=local_centos7

docker build -t $DOCKER_IMAGE images/centos7

docker run \
    -v ${PWD}:/app \
    $DOCKER_IMAGE \
    bash -c "scl enable devtoolset-11 'cd /app && g++ --version && g++ src/main.cpp src/f.cpp'"

strings a.out | grep f_to_locate

readelf -p .comment a.out

rm -f a.out


docker run \
    -v ${PWD}:/app \
    $DOCKER_IMAGE \
    bash -c "scl enable devtoolset-11 'cd /app && g++ --version && g++ -c -o f.o src/f.cpp && g++ -shared -o libf.so f.o'"

readelf -p .comment libf.so

strings libf.so | grep f_to_locate

rm -f libf.so f.o

# Try new abi
# Doesn't work because https://bugzilla.redhat.com/show_bug.cgi?id=1546704

docker run \
    -v ${PWD}:/app \
    $DOCKER_IMAGE \
    bash -c "scl enable devtoolset-11 'cd /app && g++ --version && g++ -c -D_GLIBCXX_USE_CXX11_ABI=1 -std=c++17 -o f.o src/f.cpp && g++ -D_GLIBCXX_USE_CXX11_ABI=1 -std=c++17 -shared -o libf.so f.o'"

# This should output only gcc 11 because it's only dynamic lib
readelf -p .comment libf.so

strings libf.so | grep f_to_locate

rm -f libf.so f.o
