#include "TaskA.h"


void worker_functionA(void)
{
        int loop = 0;
        // Loop 10 times
        while(loop < 10)
        {
            // Sleep for 1 seconds
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            std::cout << "Thread A Reporting: " << loop << std::endl;
            loop++;
        }
}