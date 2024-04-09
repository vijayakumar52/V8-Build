g++ j2v8.cpp -fPIC -c -I. -I ./include/ -I/Users/user-name/Library/Java/JavaVirtualMachines/liberica-11.0.15/include -I/Users/user-name/Library/Java/JavaVirtualMachines/liberica-11.0.15/include/darwin -L./ -lv8_monolith -ldl -std=c++17
ar crs libv8_monolith.a j2v8.o
g++ -shared -o libj2v8_aarch64.dylib j2v8.o libv8_monolith.a
