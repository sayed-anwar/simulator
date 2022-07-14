#ifndef TASKB_H
#define TASKB_H
#include <iostream>
#include <thread>
#include <chrono>

//#ifdef __cplusplus
//    extern "C" {
//#endif

#ifdef BUILD_TASKB
    #define TASKB __declspec(dllexport)
#else
    #define TASKB __declspec(dllimport)
#endif







void TASKB worker_functionB(void);








//#ifdef __cplusplus
//    }
//#endif

#endif