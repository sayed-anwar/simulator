#include "TaskB.h"


void worker_functionB(void)
{
        int loop = 0;
        // Loop 10 times
        while(loop < 10)
        {
            // Sleep for 1 seconds
            std::this_thread::sleep_for(std::chrono::milliseconds(1005));
            std::cout << "Thread B Reporting: " << loop << std::endl;
            loop++;
        }
}