FROM conanio/clang39 as basebuild
RUN mkdir app
WORKDIR /app
COPY . .
RUN mkdir build
WORKDIR /app/build
ENV CC=clang-3.9
ENV CXX=clang++-3.9

FROM basebuild as depbuild
RUN sudo ln -s /usr/bin/clang++-3.9 /usr/local/bin/clang++
RUN conan install .. -s compiler=clang -s compiler.version=3.9 -s compiler.libcxx=libstdc++ --build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release

FROM depbuild as postbuild
RUN cmake --build .

FROM ubuntu
COPY --from=postbuild /app/build/bin/main /bin/main
CMD ./bin/main