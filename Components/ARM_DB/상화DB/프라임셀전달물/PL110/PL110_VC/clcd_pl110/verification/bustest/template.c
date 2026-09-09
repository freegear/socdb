/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : template.c,v
--  File Revision          : 1.1.1.1
--
--  Release Information    : PrimeCell(TM)-PL110-REL1v1
--
------------------------------------------------------------------------------*/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"

#define D 0xFEEDF00D
#define ZERO 0x00000000
#define NoMask  0xFFFFFFFF
#define MaskAll 0x00000000

/*

 AHB Slave Bus Cycle commands primitives 
 ---------------------------------------
 HSA([addr], [trans], [burst], [response], [size], [limit], [master],
      [hmastlock], [num_cyc], [idl_cyc], [rs_limit], [prot])
 HSW([data1], [data2], [supp_msg], [tag])                  
 HSR([exp_val1], [exp_val2], [mask1], [mask2], [supp_msg], [tag])    

 [data1]   : 8 character hex with 0x as prefix. Gives the higher 32 bits of the
             data. Default value is zero 

 [data2]   : 8 character hex with 0x as prefix. Gives the lower 32 bits of the
             data. Default value is zero 

 [exp_val1]: 8 character hex with 0x as prefix. Gives the higher 32 bits of the 
             expected value. Default value is zero

 [exp_val2]: 8 character hex with 0x as prefix. Gives the lower 32 bits of the
             expected value. Default value is zero

 [mask1]   : 8 character hex with 0x as prefix. Gives the higher 32 bits of the
             mask value. Default value is zero

 [mask2]   : 8 character hex with 0x as prefix. Gives the lower 32 bits of the
             mask value. Default value is zero

 [addr]    : 8 character hex with 0x as prefix. If address is not specified, it
             is considered to be a burst transfer and the address is calculated
             based on the address, size and burst type specified in the 
             previous command.  

 [trans]   : (IDLE, BUSY, NSEQ or SEQ). Default value is SEQ.

 [burst]   : (INCR, INCR4, INCR8, WRAP4 or WRAP8). Default value is INCR4. 
             But if address is not specified and burst value is also not 
             specified, it takes the same value as in the previous command. 

 [response]: (OK, ERROR, RETRY, or SPLIT). Default value is OK.

 [size]    : (BYTE, HWRD, WRD, DWRD). Default value is WRD
             But if address is not specified and size value is also not 
             specified, it takes the same value as in the previous command. 

 [limit]   : 8 character hex with 0x as prefix. It is the maximum number of
             cycles for which the command can be re-issued when num_cyc has a
             value zero. Default value is zero. 

 [master]  : One character hex with 0x as prefix. Denotes the master initiating 
             present transfer.

 [mastlock]: (0 - 1) Denoting whether the current master has locked the bus. 

 [num_cyc] : (1 - 9, 0xA, 0xB, etc.) Default value is zero. When num_cyc is
             zero, the transfer ends only when the expected response is got or
             the limit is reached

 [idl_cyc] : 8 character hex with 0x as prefix. Gives the number of idle cycles
             that will be issued before a transfer that has got a retry/split 
             response is re-issued. Default value is 1. 
 
 [rs_limit]: 8 character hex with 0x as prefix. It is the maximum number of 
             re-issues of a retry/split transfer till an OK or ERROR response 
             is recieved. Default value is 0. 

 [supp_msg]: (0 - 1) Suppress messages if set.
  
 [prot]    : A single hex character. Can omit the 0x prefix if not using A-F
 
 [tag]     : String message that is given out along with error or warning
             messages

 Other commands 
 --------------
 HSP(exp_hsplitx, numcyc0, numcyc1, numcyc2, numcyc3, numcyc4, numcyc5, numcyc6,
 numcyc7, numcyc8, numcyc9, numcyc10, numcyc11, numcyc12, numcyc13, numcyc14, numcyc15, limit)
 HSEN(endianness) 
 RES(phase,[delay],[num_cyc])
 VW(Rx,data,mask,phase,delay)
 VR(Rx,expdata,mask,edge,delay,tag)
 C("string")
 TestStart(address)
 TestEnd()

 phase     : (LOW, HIGH)
 [num_cyc] : (1 - 9, 0xA, 0xB, etc.) Default value is 1.
 [delay]   : (1 - 9, 0xA, 0xB, etc.) Default value is 0.

 num_cycx  :  Same as num_cyc field in HSA command. 'x' denotes master number. 
 endianness : (BIG,LITTLE,DISABLE) - defaut is LITTLE
*/

int main() {

  TestStart(ZERO);
  /* Include your test program here */

  TestEnd();
  return 0;
}
