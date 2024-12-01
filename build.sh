#!/bin/bash

#emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

ln -s / $EMSDK/upstream/emscripten/em
mkdir install
installdir=$(pwd)/install

#openssl
wget https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz
tar -xf openssl-3.4.0.tar.gz
cd openssl-3.4.0
emconfigure ./Configure CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' --release -no-tests -no-asm -no-afalgeng -no-apps -no-shared --prefix=$installdir
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4 
emmake make install
cd ..

#nghttp2
wget https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.gz
tar -xf nghttp2-1.64.0.tar.gz
cd nghttp2-1.64.0 
emconfigure ./configure CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' --enable-lib-only --prefix $installdir
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4
emmake make install
cd ..

#zlib
wget https://github.com/madler/zlib/releases/download/v1.3.1/zlib131.zip
unzip zlib131.zip
cd zlib-1.3.1
emconfigure ./configure CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' --static --prefix $installdir
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4
emmake make install
cd ..

#c-ares
wget https://github.com/c-ares/c-ares/releases/download/v1.34.3/c-ares-1.34.3.tar.gz
tar -xf c-ares-1.34.3.tar.gz
cd c-ares-1.34.3
mkdir build
cd build
emcmake cmake CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -DCMAKE_BUILD_TYPE=Release -DCARES_STATIC=Yes -DCARES_SHARED=No -DCARES_BUILD_TOOLS=No -DCMAKE_INSTALL_PREFIX=$installdir ..
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4
emmake make install
cd ../..

#curl
wget https://github.com/curl/curl/releases/download/curl-8_11_0/curl-8.11.0.zip
unzip curl-8.11.0.zip
cd curl-8.11.0
CFLAGS="-pthread" CXXFLAGS="-pthread" CPPFLAGS="-I$installdir/include/" LDFLAGS="-L$installdir/lib -L$installdir/libx32 -sPTHREAD_POOL_SIZE=4" emconfigure ./configure --disable-shared --with-openssl --without-libpsl --disable-docs --with-ca-embed=/etc/ssl/certs/ca-certificates.crt --with-nghttp2 --enable-ares --prefix $installdir
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4
emmake make install
cd ..

#SDL
wget https://github.com/libsdl-org/SDL/releases/download/preview-3.1.6/SDL3-3.1.6.zip
unzip SDL3-3.1.6.zip
cd SDL3-3.1.6
mkdir build
cd build
emcmake cmake CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -DSDL_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DSDL_THREADS=On -DCMAKE_INSTALL_PREFIX=$installdir ..
emmake make CFLAGS='-pthread' CXXFLAGS='-pthread' LD_FLAGS='-sPTHREAD_POOL_SIZE=4' -j4
emmake make install
cd ../..

tar -zcvf ports.tar.gz install
