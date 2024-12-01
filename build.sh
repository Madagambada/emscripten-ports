#!/bin/bash

#emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

ln -s / $EMSDK/upstream/emscripten/em
mkdir install
installdir=$(pwd)/install

#openssl
wget https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz
tar -xf openssl-3.4.0.tar.gz
cd openssl-3.4.0
emconfigure ./Configure --release -no-tests -no-asm -no-afalgeng -no-apps -no-shared --prefix=$installdir
emmake make -j4
emmake make install
cd ..

#nghttp2
wget https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.gz
tar -xf nghttp2-1.64.0.tar.gz
cd nghttp2-1.64.0 
emconfigure ./configure --enable-lib-only --prefix $installdir
emmake make -j4
emmake make install
cd ..

#zlib
wget https://github.com/madler/zlib/releases/download/v1.3.1/zlib131.zip
unzip zlib131.zip
cd zlib-1.3.1
emconfigure ./configure --static --prefix $installdir
emmake make -j4
emmake make install
cd ..

#curl
wget https://github.com/curl/curl/releases/download/curl-8_11_0/curl-8.11.0.zip
unzip curl-8.11.0.zip
cd curl-8.11.0
CPPFLAGS="-I$installdir/include/" LDFLAGS="-L$installdir/lib -L$installdir/libx32" emconfigure ./configure --disable-shared --with-openssl --without-libpsl --disable-docs --with-ca-embed=/etc/ssl/certs/ca-certificates.crt --with-nghttp2 --prefix $installdir
emmake make -j4
emmake make install
cd ..

tar -zcvf ports.tar.gz install