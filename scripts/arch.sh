set -xe

docker build -t local_arch images/arch

docker run \
    -v ${PWD}:/app \
    -it local_arch \
    bash -c "cd /app && g++ --version && g++ src/main.cpp src/f.cpp"

strings a.out | grep f_to_locate

# This should output gcc11 and gcc4.8.5 because of the linker
readelf -p .comment a.out

rm -f a.out

echo "-------------------"

docker run \
    -v ${PWD}:/app \
    -it local_arch \
    bash -c "cd /app && g++ --version && g++ -c -o f.o src/f.cpp && g++ -shared -o libf.so f.o"

# This should output only gcc 11 because it's only dynamic lib
readelf -p .comment libf.so

strings libf.so | grep f_to_locate

rm -f libf.so f.o


# Try old abi

docker run \
    -v ${PWD}:/app \
    -it local_arch \
    bash -c "cd /app && g++ --version && g++ -c -D_GLIBCXX_USE_CXX11_ABI=0 -o f.o src/f.cpp && g++ -D_GLIBCXX_USE_CXX11_ABI=0 -shared -o libf.so f.o"

# This should output only gcc 11 because it's only dynamic lib
readelf -p .comment libf.so

strings libf.so | grep f_to_locate

rm -f libf.so f.o