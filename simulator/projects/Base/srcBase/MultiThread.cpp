#include <iostream>
#include <thread>
#include <chrono>

#include "TaskA.h"
#include "TaskB.h"

int main()
{
   char result;
   // Launch two new threads. They will start executing immediately
   std::thread worker_threadA(worker_functionA); 
   std::thread worker_threadB(worker_functionB); 

   // Pause the main thread
   std::cout << "Press a key to finish" << std::endl;
   std::cin >> result;

   // Join up the two worker threads back to the main thread
   worker_threadA.join();
   worker_threadB.join();
   // Return success
   return 1;
}