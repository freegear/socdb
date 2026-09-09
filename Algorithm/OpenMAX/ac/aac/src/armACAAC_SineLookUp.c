/**
 *  armACAAC_SineLookUp.c
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
 * Description:
 * Look Up table for sine(x) 
**/

#include "omxtypes.h"

#include "armACAAC_Tables.h"

const OMX_F64 armACAAC_SinLookUp[32]=  
{ 
    -0.342020143325668880 ,-0.995734176295034470 ,-0.642787609686539470 ,-0.961825643172819040 ,-0.866025403784438820 ,-0.895163291355062340 ,-0.984807753012208020 ,-0.798017227280239490 ,
    -0.984807753012208020 ,-0.673695643646557210 ,-0.866025403784438600 ,-0.526432162877355720 ,-0.642787609686539250 ,-0.361241666187152920 ,-0.342020143325668710 ,-0.183749517816570340 ,
     0.000000000000000000 , 0.000000000000000000 , 0.433883739117558060 , 0.207911690817759310 , 0.781831482468029690 , 0.406736643075800150 , 0.974927912181823510 , 0.587785252292473140 ,
     0.974927912181823620 , 0.743144825477394130 , 0.781831482468029910 , 0.866025403784438600 , 0.433883739117558620 , 0.951056516295153530 , 0.000000000000000567 , 0.994521895368273290 
};

/*End of File*/
