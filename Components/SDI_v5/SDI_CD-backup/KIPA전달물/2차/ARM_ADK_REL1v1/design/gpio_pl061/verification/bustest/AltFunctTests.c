/*----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : AltFunctTests.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

void AltFunctTests()
{
 /*
   Summary : Alternate Functionality Test
   ======================================
   o After reset : GPIODIR = 0x00(INPUT) & GPIOAFSEL = 0x00 (APB-XP INTERFACE)       
     - Data will flow to the APB interface from the GPIO pins. 
     - Data in the Alternate Functionality lines are ignored.    
   
   o Data will flow from the APB interface to the GPIO pins. 
     - Data in the Alternate Functionality lines are ignored.

   o Data will flow to the APB interface from the GPIO pins.
     - Data in the Alternate Functionality lines are ignored.

   o Data will flow from the Alt. Functionality lines to the GPIO pins. 
     - Data in the APB interface lines are ignored.

   o Data will flow to the Alt. Functionality lines from the GPIO pins. 
     - Data in the APB interface lines are ignored.
 */


/********************************************************************************************/
/********************************************************************************************/
/**       o After reset :   GPIODIR = 0x00(INPUT) & GPIOAFSEL = 0x00 ( APB-XP INTERFACE )  **/
/**         - Data will flow to the APB interface from the GPIO pins.                      **/
/**         - Data in the Alternate Functionality lines are ignored.                       **/
/********************************************************************************************/
/********************************************************************************************/
  
  /* RESET */
  RES(LOW,0x01,0x01);
  PI(0x02);
  /* GPIO Setup */ 
  /* Just after RESET, GPIO Alternate Functionality reg = 0x00 --> APB i/f &  INPUT */
  PSR(0x00000000, NoMask, GPIOAFSEL); /* Verification : APB                                 */
  PSR(0x00000000, NoMask, GPIODIR);   /* Verification : INPUT                               */

  /* Simulate Alternate Functionality to show that when APB interface is selected to drive  */
  /* the GPIO no interference is allowed from the Alternate Functionality lines in the pins */
  /* Here we simulate an attempt by the device connected in the Alt.Funct. lines to drive   */
  /* 0xFF into the XP pins. GPIOAFSEL = 0x00*/
  PSW(0x00000000, GTAENR);          /* GPIO GP Alt. Funct Data direction = 0x00--> OUTPUTS  */
  PSR(0x00000000, NoMask, GTAENR);  /* Verification :     nGPAFEN = 0x00 (output ENABLED)   */
  PSW(0x000000FF, GTAOUTR);         /* GPIO GP Alt. Funct Data register  = 0xFF--> HIGH     */
  PSR(0x000000FF, NoMask, GTAOUTR); /* Verification :     nGPAFOUT = 0xFF                   */ 
  /* The remaining verification steps will run without being affected by this.              */

  /* APB INTERFACE */   
  /* After reset GPIO Data Direction register = 0x00--> INPUTS                              */
  PSR(0x00000000, NoMask, GPIODIR);  /* Verification : INPUTS                               */
  PSR(0x000000FF, NoMask, GTENR);    /* nGPEN status is all ones : = nGPIODIR = not(GPIODIR)*/

  /* 0x00  */
  PSW(0x00000000, GTINR);                  /* GPIO Input Data  GPIN ==> = LOW :   :: 0x00   */
  PSR(0x00000000, NoMask, GTINR);          /* Verification :GPIN =                   0x00   */
  PI(0x02);                                /* Allow for two cycles to synchronize input     */
  PSR(0x00000000, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA = GPIN = LOW == 0x00   */

  /* 0x55  */
  PSW(0x00000055, GTINR);                  /* GPIO Input Data  GPIN ==> = LOW :   :: 0x55   */
  PSR(0x00000055, NoMask, GTINR );         /* Verification :GPIN =                   0x55   */
  PI(0x02);                                /* Allow for two cycles to synchronize input     */
  PSR(0x00000055, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA = GPIN = LOW == 0x55   */

  /* 0xFF  */
  PSW(0x000000FF, GTINR);                  /* GPIO Input Data  GPIN ==> = LOW :   :: 0xFF   */
  PSR(0x000000FF, NoMask, GTINR);          /* Verification :GPIN =                   0xFF   */
  PI(0x02);                                /* Allow for two cycles to synchronize input     */
  PSR(0x000000FF, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA = GPIN = LOW == 0xFF   */

  /* 0xAA  */
  PSW(0x000000AA, GTINR);                  /* GPIO Input Data  GPIN ==> = LOW :   :: 0xAA   */
  PSR(0x000000AA, NoMask, GTINR);          /* Verification :GPIN =                   0xAA   */
  PI(0x02);                                /* Allow for two cycles to synchronize input     */
  PSR(0x000000AA, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA = GPIN = LOW == 0xAA   */

  /* 0x00  */
  PSW(0x00000000, GTINR);                  /* GPIO Input Data  GPIN ==> = LOW :   :: 0x00   */
  PSR(0x00000000, NoMask, GTINR);          /* Verification :GPIN =                   0x00   */
  PI(0x02);                                /* Allow for two cycles to synchronize input     */
  PSR(0x00000000, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA = GPIN = LOW == 0x00   */

/********************************************************************************************/
/********************************************************************************************/
/**       GPIODIR = 0xFF(OUTPUT) & GPIOAFSEL = 0x00 ( APB-XP INTERFACE )                   **/
/**       o Data will flow from the APB interface to the GPIO pins.                        **/
/**         - Data in the Alternate Functionality lines are ignored.                       **/
/********************************************************************************************/
/********************************************************************************************/

PI(0x3F);
  /* GPIO Setup */
  PSW(0x00000000, GPIOAFSEL);        /* GPIO Alternate Functionality reg = 0x00--> APB i/f*/ 
  PSR(0x00000000, NoMask, GPIOAFSEL);/* Verification : APB */

  /* Simulate Alternate Functionality to show that when APB interface is selected to drive  */
  /* the GPIO no interference is allowed from the Alternate Functionality lines in the pins */
  /* Here we simulate an attempt by the device connected in the Alt.Funct. lines to drive   */
  /* 0xFF into the XP pins. GPIOAFSEL = 0x00*/
  PSW(0x00000000, GTAENR);          /* GPIO GP Alt. Funct Data direction = 0x00--> OUTPUTS  */
  PSR(0x00000000, NoMask, GTAENR);  /* Verification :     nGPAFEN = 0x00 (output ENABLED)   */
  PSW(0x000000FF, GTAOUTR);         /* GPIO GP Alt. Funct Data register  = 0xFF--> HIGH     */
  PSR(0x000000FF, NoMask, GTAOUTR); /* Verification :     nGPAFOUT = 0xFF                   */ 
  /* The remaining verification steps will run without being affected by this.              */

  /* APB INTERFACE */   
  PSW(0x000000FF, GPIODIR);          /* GPIO Data Direction register = 0xFF--> OUTPUTS      */
  PSR(0x000000FF, NoMask, GPIODIR);  /* Verification : OUTPUT                               */
  PSR(0x00000000, NoMask, GTENR);    /* nGPEN status is all zeros: = nGPIODIR = not(GPIODIR)*/
  /* 0x00  */
  PSW(0x00000000, GPIODATA+0x3FC);         /* GPIO Data ==> GPOUT   = LOW ::: 0X00 */ 
  PSR(0x00000000, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA  LOW          */
  PSR(0x00000000, NoMask, GTOUTR);         /* GPOUT = GPIODATA =              0x00 */

  /* 0x55  */
  PSW(0x00000055, GPIODATA+0x3FC);         /* GPIO Data ==> GPOUT = 0101 0101b ::: 0X55 */ 
  PSR(0x00000055, NoMask, GPIODATA+0x3FC); /* Verification :  GPIODATA             0X55 */
  PSR(0x00000055, NoMask, GTOUTR);         /* GPOUT = GPIODATA =                   0x55 */

  /* 0xFF  */
  PSW(0x000000FF, GPIODATA+0x3FC);         /* GPIO Data ==> GPOUT   = HIGH ::: 0XFF */ 
  PSR(0x000000FF, NoMask, GPIODATA+0x3FC); /* Verification GPIODATA  :HIGH          */  
  PSR(0x000000FF, NoMask, GTOUTR);         /* GPOUT = GPIODATA =               0xFF */

  /* 0xAA  */
  PSW(0x000000AA, GPIODATA+0x3FC);         /* GPIO Data ==> GPOUT = 1010 1010b ::: 0XAA */ 
  PSR(0x000000AA, NoMask, GPIODATA+0x3FC); /* Verification GPIODATA              : 0xAA */  
  PSR(0x000000AA, NoMask, GTOUTR);         /* GPOUT = GPIODATA =                   0xAA */
 
 /* 0x00  */
  PSW(0x00000000, GPIODATA+0x3FC);         /* GPIO Data ==> GPOUT   = LOW ::: 0X00 */ 
  PSR(0x00000000, NoMask, GPIODATA+0x3FC); /* Verification :GPIODATA  LOW          */
  PSR(0x00000000, NoMask, GTOUTR);         /* GPOUT = GPIODATA =              0x00 */

/********************************************************************************************/
/********************************************************************************************/
/**       GPIODIR = 0x00(OUTPUT) & GPIOAFSEL = 0xFF ( AF-XP INTERFACE )                    **/
/**       o Data will flow from the Alt. Functionality lines to the GPIO pins.             **/
/**         - Data in the APB interface lines are ignored.                                 **/
/********************************************************************************************/
/********************************************************************************************/
PI(0x3F);
  /* GPIO Setup */
  PSW(0x000000FF, GPIOAFSEL);        /* GPIO Alternate Functionality reg = 0xFF--> Alt.Func.*/
  PSR(0x000000FF, NoMask, GPIOAFSEL);/* Verification : AF  SELECTED                         */

  /* Simulate APB Functionality to show that when Alt.Funct. interface is selected to drive */
  /* the GPIO no interference is allowed from the APB interface lines in the pins           */
  /* Here we simulate an attempt by the APB bus via the GPIODATA register to drive          */
  /* 0xFF into the XP pins. GPIOAFSEL = 0xFF                                                */
  PSW(0x000000FF, GPIODIR);          /* GPIO Data Direction register = 0xFF--> OUTPUTS      */
  PSR(0x000000FF, NoMask, GPIODIR);  /* Verification : OUTPUT                               */
  PSW(0x000000FF, GPIODATA+0x3FC);          /* GPIO Data ==> GPAPBOUT   = HIGH ::: 0XFF     */
  PSR(0x000000FF, NoMask, GPIODATA+0x3FC);  /* Verification GPIODATA     :HIGH              */
  /* The remaining verification steps will run without being affected by this.              */

  /* ALTERNATE FUNCTIONALITY INTERFACE */  
  PSW(0x00000000, GTAENR);          /* nGPAFEN Alt.Funct. Data Direction reg.=0x00-->OUTPUTS*/
  PSR(0x00000000, NoMask, GTAENR);  /* Verification : OUTPUTS                               */
  PSR(0x00000000, NoMask, GTENR);   /* nGPEN status is all zeros:   = nGPAFEN = 0x00        */
  /*   0x00   */
  PSW(0x00000000, GTAOUTR);         /* GPIO Alt. Funct Data: GPAFOUT = 0x00 --> LOW         */
  PSR(0x00000000, NoMask, GTAOUTR); /* Verification :        GPAFOUT = 0x00                 */
  PSR(0x00000000, NoMask, GTOUTR);  /* Verification :GPOUT = GPAFOUT = 0x00 --> LOW         */
  /*   0x55   */
  PSW(0x00000055, GTAOUTR);         /* GPIO Alt. Funct Data: GPAFOUT = 0x55 --> 0101 0101   */
  PSR(0x00000055, NoMask, GTAOUTR); /* Verification :        GPAFOUT = 0x55                 */
  PSR(0x00000055, NoMask, GTOUTR);  /* Verification :GPOUT = GPAFOUT = 0x55 --> 0101 0101   */
  /*   0xFF   */
  PSW(0x000000FF, GTAOUTR);         /* GPIO Alt. Funct Data: GPAFOUT = 0xFF --> HIGH        */
  PSR(0x000000FF, NoMask, GTAOUTR); /* Verification :        GPAFOUT = 0xFF                 */
  PSR(0x000000FF, NoMask, GTOUTR);  /* Verification :GPOUT = GPAFOUT = 0xFF --> HIGH        */
  /*   0xAA   */
  PSW(0x000000AA, GTAOUTR);         /* GPIO Alt. Funct Data: GPAFOUT = 0xAA --> 1010 1010   */
  PSR(0x000000AA, NoMask, GTAOUTR); /* Verification :        GPAFOUT = 0xAA                 */
  PSR(0x000000AA, NoMask, GTOUTR);  /* Verification :GPOUT = GPAFOUT = 0xAA --> 1010 1010   */
  /*   0x00   */
  PSW(0x00000000, GTAOUTR);         /* GPIO Alt. Funct Data: GPAFOUT = 0x00 --> LOW         */
  PSR(0x00000000, NoMask, GTAOUTR); /* Verification :        GPAFOUT = 0x00                 */
  PSR(0x00000000, NoMask, GTOUTR);  /* Verification :GPOUT = GPAFOUT = 0x00 --> LOW         */

PI(0x3F);


/********************************************************************************************/
/********************************************************************************************/
/**       GPIODIR = 0x00(INPUT) & GPIOAFSEL = 0xFF ( AF-XP INTERFACE )                     **/
/**       o Data will flow to the Alt. Functionality lines from the GPIO pins.             **/
/**         - Data in the APB interface lines are ignored.                                 **/
/********************************************************************************************/
/********************************************************************************************/

  /* GPIO Setup */
  PSW(0x000000FF, GPIOAFSEL);        /* GPIO Alternate Functionality reg = 0xFF--> Alt.Func.*/
  PSR(0x000000FF, NoMask, GPIOAFSEL);/* Verification : AF  SELECTED                         */

  /* Simulate APB Functionality to show that when Alt.Funct. interface is selected to drive */
  /* the GPIO no interference is allowed from the APB interface lines in the pins           */
  /* Here we simulate an attempt by the APB bus via the GPIODATA register to drive          */
  /* 0xFF into the XP pins. GPIOAFSEL = 0xFF                                                */  
  PSW(0x000000FF, GPIODIR);          /* GPIO Data Direction register = 0xFF--> OUTPUTS      */
  PSR(0x000000FF, NoMask, GPIODIR);  /* Verification : OUTPUT                               */
  PSW(0x000000FF, GPIODATA+0x3FC);          /* GPIO Data ==> GPAPBOUT   = HIGH ::: 0XFF     */
  PSR(0x000000FF, NoMask, GPIODATA+0x3FC);  /* Verification GPIODATA     :HIGH              */
  /* The remaining verification steps will run without being affected by this.              */

  /* ALTERNATE FUNCTIONALITY INTERFACE */  
  PSW(0x000000FF, GTAENR);          /* nGPAFEN Alt.Funct. Data Direction reg.=0xFF-->INPUTS */
  PSR(0x000000FF, NoMask, GTAENR);  /* Verification : INPUTS                                */
  PSR(0x000000FF, NoMask, GTENR);   /* nGPEN status is all ones :   = nGPAFEN = 0xFF        */

  /*   0x00   */
  PSW(0x00000000, GTINR);                  /* GPIO Input Data GPIN ==>  LOW     :: 0x00    */ 
  PSR(0x00000000, NoMask, GTINR);          /* Verification :  GPIN =               0x00    */
  PSR(0x00000000, NoMask, GTAINR);  /* Verification :  GPAFIN=GPIN =    LOW     :: 0x00    */ 

  /*   0x55   */
  PSW(0x00000055, GTINR);                  /* GPIO Input Data GPIN ==>0101 0101 :: 0x55     */
  PSR(0x00000055, NoMask, GTINR );         /* Verification :  GPIN =               0x55     */
  PSR(0x00000055, NoMask, GTAINR);  /* Verification :  GPAFIN=GPIN =  0101 0101 :: 0x55     */

  /*   0xFF   */
  PSW(0x000000FF, GTINR);                  /* GPIO Input Data GPIN ==>  HIGH    :: 0xFF     */
  PSR(0x000000FF, NoMask, GTINR);          /* Verification :  GPIN =               0xFF     */
  PSR(0x000000FF, NoMask, GTAINR);  /* Verification :  GPAFIN=GPIN =    HIGH    :: 0xFF     */

  /*   0xAA   */
  PSW(0x000000AA, GTINR);                  /* GPIO Input Data GPIN ==>1010 1010 :: 0xAA     */
  PSR(0x000000AA, NoMask, GTINR);          /* Verification :  GPIN =               0xAA     */
  PSR(0x000000AA, NoMask, GTAINR);  /* Verification :  GPAFIN=GPIN =  1010 1010 :: 0xAA     */

  /*   0x00   */
  PSW(0x00000000, GTINR);                  /* GPIO Input Data GPIN ==>  LOW     :: 0x00    */ 
  PSR(0x00000000, NoMask, GTINR);          /* Verification :  GPIN =               0x00    */
  PSR(0x00000000, NoMask, GTAINR);  /* Verification :  GPAFIN=GPIN =    LOW     :: 0x00    */ 

PI(0x3F);

}
