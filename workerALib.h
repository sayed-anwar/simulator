#ifndef WORKERA_LIB_H
#define WORKERA_LIB_H
#include <iostream>
#include <thread>
#include <chrono>

//#ifdef __cplusplus
//    extern "C" {
//#endif

#ifdef BUILD_WORKERA
    #define WORKERA_LIB __declspec(dllexport)
#else
    #define WORKERA_LIB __declspec(dllimport)
#endif







void WORKERA_LIB worker_functionA(void);








//#ifdef __cplusplus
//    }
//#endif

#endif