#include <iostream>
#include <thread>
#include <chrono>

#include "workerALib.h"




void worker_functionB(void)
{
        int loop = 0;
        // Loop 10 times
        while(loop < 10)
        {
           // Sleep for 2.22 seconds
           std::this_thread::sleep_for(std::chrono::milliseconds(1000));
           std::cout << "Thread B Reporting: " << loop << std::endl;
           loop++;
        }
}

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