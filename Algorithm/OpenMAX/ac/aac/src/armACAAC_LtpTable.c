/*
*  armACAAC_LtpTable.c
* 
* (c) Copyright 2005,2006 ARM Limited. All Rights Reserved.
* 
* THIS SOFTWARE IS PROVIDED “AS IS”, ARM EXPRESSLY DISCLAIMS ALL REPRESENTATIONS, 
* WARRANTIES, CONDITIONS OR OTHER TERMS, EXPRESS, IMPLIED OR STATUTORY, INCLUDING 
* WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, 
* SATISFACTORY QUALITY, AND FITNESS FOR A PARTICULAR PURPOSE. 
* 
* Your use of this Software may require additional licenses, including but not 
* limited to copyright and patent licenses from various entities. Should any 
* such additional copyright, patent or other licenses be required, ARM expects 
* that you will and you agree to obtain any such licenses at your own expense. 
* You are solely responsible for obtaining any such licenses and the copyright 
* licenses granted herein are conditioned on you obtaining such additional 
* licenses.
* 
*
*  Description:
*  Look - Up table for value of ltp coefficients
*/
#include "omxtypes.h"

#include "armACAAC_Tables.h"

const OMX_F64 armACAAC_ltpTable[8] = 
            { 0.570829, 0.696616, 0.813004, 0.911304, 
              0.984900, 1.067894, 1.194601, 1.369533 };

/*End of File*/

