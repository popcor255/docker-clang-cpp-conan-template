FROM conanio/clang39 as clangbase
RUN mkdir app
WORKDIR /app
COPY . .
RUN mkdir build
WORKDIR /app/build
ENV CC=clang-3.9
ENV CXX=clang++-3.9

FROM clangbase as clangdep
RUN sudo ln -s /usr/bin/clang++-3.9 /usr/local/bin/clang++
RUN conan install .. -s compiler=clang -s compiler.version=3.9 -s compiler.libcxx=libstdc++ --build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release

FROM clangdep
RUN cmake --build .
CMD bin/main