#ifndef TASKA_H
#define TASKA_H
#include <iostream>
#include <thread>
#include <chrono>

//#ifdef __cplusplus
//    extern "C" {
//#endif

#ifdef BUILD_TASKA
    #define TASKA __declspec(dllexport)
#else
    #define TASKA __declspec(dllimport)
#endif







void TASKA worker_functionA(void);








//#ifdef __cplusplus
//    }
//#endif

#endif