/*-------------------------------------------------------------------
File name : Lib.c

middle level routines
----------------------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "sysinc.h"
#include "structDef.h"
#include "Commonmacro.h"

#include "lib.h"

#define GLOBAL_DEFINE
#include "global.h"


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : smtDelay100us()
    Prototype           : smtBoolean smtDelay100us(smtInt32 time);
    Return              : smtBoolean
    Argument            : time ->  time to delay
    Comments        : function to delay.
                      time > 0 : the number of loop time
-----------------------------------------------------------------------*/
smtBoolean smtDelay100us(smtInt32 time)
{
#if 0
    //sysDelay100us(time);  //sysArmLib.c

#else
	{
		smtUint32 i;
		for(i=0; i<(time*100*4); i++)
		{
			volatile smtInt32 j;	// this volatile is effective when compiler cutting over at optimization.
			j++;
			j--;
		}
	}
#endif

    return SMT_SUCCESS;
}

/*---------------------------------------------------------
        MEMORY
--------------------------------------------------------- */
/* ESMC */
/*-----------------------------------------------------------------------
    Function name   : smtMemoryWrite()
    Prototype           : smtBoolean smtMemoryWrite(smtUint32 addr, smtUint32 *data, smtUint32 length)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Write data to memory as length
-----------------------------------------------------------------------*/
smtBoolean smtMemoryWrite(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
    smtUint32 size;
    smtUint32 memAddr;

    memAddr = addr;

    for(size=0; size<length/4; size++)
    {
        SMT_WRITE((*(smtUint32 *)memAddr), *(data+size))
        memAddr += 4;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtMemoryRead()
    Prototype           : smtBoolean smtMemoryRead(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Normal program
-----------------------------------------------------------------------*/
smtBoolean smtMemoryRead(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
    smtUint32 size;
    smtUint32 memAddr;

    memAddr = addr;

    for(size=0; size<length/4; size++)
    {
        *(data+size) = SMT_READ((*(smtUint32 *)memAddr));
        memAddr += 4;
    }

    return SMT_SUCCESS;
}


/*---------------------------------------------------------
        UART
--------------------------------------------------------- */

/*---------------------------------------------------------
        I2C
--------------------------------------------------------- */

/*---------------------------------------------------------
        TIMER & PWM
--------------------------------------------------------- */

/*---------------------------------------------------------
        GPIO
--------------------------------------------------------- */

/*---------------------------------------------------------
        VIC (Vectored Interrupt Controller)
--------------------------------------------------------- */

