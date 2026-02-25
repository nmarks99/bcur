#include <stddef.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>

#include <epicsThread.h>
#include <iocsh.h>
#include <epicsExit.h>

int main(int argc,char *argv[])
{
    if(argc>=2) {
	iocsh(argv[1]);
	epicsThreadSleep(.2);
    }
    iocsh(NULL);
	epicsExit(0);
    return(0);
}


// // use lua shell instead of iocsh
// #include "luaShell.h"
// int main(int argc,char *argv[])
// {
    // // enables a common environment between st.lua interactive shell
    // luashSetCommonState("default");
//
    // if(argc>=2) {
        // luash(argv[1]);
        // epicsThreadSleep(.2);
    // }
    // luash(NULL);
	// epicsExit(0);
   // return(0);
// }
