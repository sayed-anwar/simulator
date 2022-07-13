g++ -c -DBUILD_WORKERA workerALib.cpp
g++ -shared -o workerALib.dll workerALib.o -Wl,--out-implib,libworkerALib.a