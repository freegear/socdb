/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Sci_Debounce_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Debounce_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Debounce_Test(Bypass,CLKICC_value,ExtCount_value,DactCount_value)

{

/*
  Summary : Debounce Test
  ========================
 
  o This test checks the debounce mechanism after card detection by 
    the interface. It also checks the deactivation sequence. In this test
    the deactivation is started by making the SCIDETECT signal to '0'.
    (Hardware initiated deactivation)  

  o This test checks the SCICARDININTR, SCICARDOUTINTR, SCICARDDNINTR  
 
  o Keeping the SCIDETECT signal high for a time which is sufficient to 
    generate SCICARDININTR and check whether the interrupt is generated.

  o After the SCICARDININTR generation, make the SCIDETECT signal to '0'
    and check interrupts. 

  o Repeat the above sequence for Bypass mode(with zero and non zero 
    debounce time)

*/

int Poll_value;

/* Enable the trickbox and make nRST = '1' */
PSW(0x2001,SCITrCR);

PI(0x60);

/* Program the SCICLKICC register. It is used for SCICLK width calculation */
PSW(CLKICC_value,SCICLKICC);
PSW(CLKICC_value,SCITrCKICC);

/* Reset all SCI interrupts */
PSW(0x1FFF,SCIICR);

/* Dummy clocks required for synchronisation */
PI(Dummyclock);

/* Read the interrupt register; also the check the status of the interrupt
at the pin using SCITrSR1 */
PSR(0x4000,0x7FFF,SCIRIS);
PSR(0x0000,0x7FFF,SCIMIS);
PSR(0x0000,0x1FFF,SCITrSR1); 

/* Unmask all SCI interrupts  */
PSW(0x7FFF,SCIIMSC);

/* Dummy clocks required for synchronisation */
PI(Dummyclock);

if(Bypass == 0x01)  
/* Non Bypass mode */ 
  PSW(0x00,SCICR1);
else
/* Bypass mode  */
  PSW(0x20,SCICR1);

/* Load the programmed value into the SCI deactivation counter */
PSW(DactCount_value,SCIDTIME);

/* Load the programmed value into the external counter which determines the
debounce time  */ 
PSW(ExtCount_value,SCISTABLE);

/* Set the trickbox and make SCIDETECT signal to '1', also make 
nRST = '1' */
PSW(0x2011,SCITrCR);
PI(Dummyclock);
PI(Dummyclock);

/* Poll for the SCICARDININTR */ 
Poll_value = (ExtCount_value + 0x01) * clkmulfactor * (1 + Bypass * 0xFFFF)
              + Dummyclock  + Margin; 
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);
C("Card dectect Interrupt");

/* Read the SCI Interrupt identification register. Expecting 
SCICARDININTR = '1' after the debounce time */
PSR(0x4001,0x00007FFF,SCIRIS);
PSR(0x4001,0x00007FFF,SCIMIS);

/* Read interrupt at the pin using SCITrSR1 register in the trickbox. 
Expecting SCICARDININTR = 1, SCIINTR = 1; */
PSR(0x1009,0x01FFF,SCITrSR1);

/* Clear the SCIDETECT signal to '0' */
PSW(0x2001,SCITrCR);
PI(Dummyclock);

/* Poll for SCICARDDNINTR. Deactivation sequence has three stages.
Each sequence time is determined by SCICLK and Deactivation count value. It 
also includes some synchronisation clocks (0x07). */
Poll_value = (DactCount_value + 0x01) * 0x03 * clkmulfactor
             * (CLKICC_value + 1) * 0x02 + 0x07  + Margin;

PO(0x0200,0x0000200,SCITrSR1,Poll_value,SCICARDDNINTR failed);
C("Card down interrupt");

/* Dummy clocks required for sychronisation to the PCLK domain */
PI(Dummyclock);
PI(Dummyclock);

/* Read the SCI Interrupt identification register. Expecting 
SCICARDININTR = 0, SCICARDOUTINTR = 1, SCICARDDNINTR = 1 */
PSR(0x400A,0x00007FFF,SCIRIS, sciris_1);
PSR(0x400A,0x00007FFF,SCIMIS);

/* Read SCITrSR1 register in the trickbox. Expecting SCICARDININTR = 0,
SCICARDOUTINTR = 1,  SCICARDDNINTR = 1, SCIINTR = 1;  */
PSR(0x0A09,0x00001FFF,SCITrSR1);

/* Clear the interrupts one by one. Clear SCICARDDNINTR  */
PSW(0x008,SCIICR);
PI(Dummyclock);
PSR(0x4002,0x00007FFF,SCIRIS);
PSR(0x4002,0x00007FFF,SCIMIS);
PSR(0x0809,0x00001FFF,SCITrSR1);

/* Clear SCICARDOUTINTR interrupt */ 
PSW(0x002,SCIICR);
PI(Dummyclock);
PSR(0x4000,0x00007FFF,SCIRIS);
PSR(0x4000,0x00007FFF,SCIMIS);
PSR(0x0009,0x00001FFF,SCITrSR1);

/* Mask all SCI interrupts  */
PSW(0x0000, SCIIMSC);
}/* End Function */
