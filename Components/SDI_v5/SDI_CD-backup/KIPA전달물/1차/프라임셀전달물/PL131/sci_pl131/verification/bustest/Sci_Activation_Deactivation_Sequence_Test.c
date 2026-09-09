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
--  File Name              : Sci_Activation_Deactivation_Sequence_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Activation_Deactivation_Sequence_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Activation_Deactivation_Sequence_Test(ActCount_value,DactCount_value,
                                          CLKICC_value)
{

/*
  Summary :  Activation_Deactivation Sequence Test
  ===============================================

  o This test checks the activation sequence.

  o Keeping the SCIDETECT signal high for a time which is sufficient to
    generate SCICARDININTR and check whether the interrupt is generated.
  
  o Start the Card activation sequence by enabling the Start bit.

  o Check the card activation sequence. Poll for the SCICARDUPINTR.

  o Start the Card deactivation sequence by enabling the finish bit.

  o Check the Card deactivation sequence. Also Poll for the SCICARDDNINTR. 
          
*/

int Poll_value,DELAY_value,i;
 
/* Enable the trickbox; also make SCIDETECT signal to '1' */
PSW(0x2001,SCITrCR);

/* Program the SCICLKICC register. It is used for SCICLK width calculation */
PSW(CLKICC_value,SCICLKICC);
PSW(CLKICC_value,SCITrCKICC);

/* Clear all the  SCI interrupts */
PSW(0x1FFF,SCIICR);

/* Unmask all SCI interrupts */
PSW(0x7FFF,SCIIMSC);

/* Dummy clocks for synchronisation */
PI(Dummyclock);

/* Read the interrupt identification register before making the 
SCIDETECT to '1' */ 
PSR(0x4000,0x7FFF,SCIRIS);
PSR(0x0009,0x1FFF,SCITrSR1);

/* Enable the Bypass mode. Also Write a value to the SCISTABLE register */ 
PSW(0x05,SCISTABLE);
PSW(0x20,SCICR1);

/* Program the SCIATIME register. This value is used for Card activation 
sequence */
PSW(ActCount_value,SCIATIME);

/* Program the SCIDTIME register. This value is used for Card deactivation 
sequence */
PSW(DactCount_value,SCIDTIME);

/* Make SCIDETECT signal to '1' */
PSW(0x2011,SCITrCR);
PI(Dummyclock);


/* Poll for the SCICARDININTR. 0x05 is SCISTABLE register value */ 
Poll_value = 0x05 * clkmulfactor + Margin;  
PO(0x1000,0x00001000,SCITrSR1,Poll_value,SCICARDININTR failed);

/* Read the SCI Interrupt identification register. Expecting
SCICARDININTR = 1 */
PSR(0x4001,0x00007FFF,SCIRIS);
PSR(0x4001,0x00007FFF,SCIMIS);

/* Read SCISYNCACT register. Expecting CARDPRESENT = '1' */
PSR(0x400,0x3FF,SCISYNCACT);

/* Initiate the activation sequence by writing  '1' to the Start bit */ 
PSW(0x01,SCICR2);

/* Poll for the SCICARDUPINTR */ 
Poll_value = (ActCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02 
             * clkmulfactor + Margin; 
/* After the first stage of activation sequence nSCIDATAEN ='1',
nSCIDATAOUTEN = '1', DATAEN ='1' and POWER = '1' */ 
PO(0x709,0x3FF,SCISYNCACT,Poll_value,First stage of activation);
PSR(0x709,0x3FF,SCISYNCACT, after1st);

/* After the second stage of activation sequence nSCIDATAEN ='1',
nSCIDATAOUTEN = '1', SCICLKOUT = '1', DATAEN ='1',CLKEN ='1' and 
POWER = '1', */ 
PO(0x70D,0x33F,SCISYNCACT,Poll_value,Second stage of activation);
PSR(0x70D,0x33F,SCISYNCACT, after2nd);

/* After the third stage of activation sequence nSCIDATAEN ='1',
nSCIDATAOUTEN = '1', DATAEN ='1',CLKEN ='1'  
CRESET ='1' and POWER = '1', */ 
PO(0x78F,0x3FF,SCISYNCACT,Poll_value,Third stage of activation);

/* Poll for the SCICARDUPINTR */ 
Poll_value = Dummyclock; 
PO(0x0400,0x00000400,SCITrSR1,Poll_value,SCICARDUPINTR failed);
C("Card Up interrupt");

/* Read the SCI Interrupt identification register. Expecting
SCICARDUPINTR = 1 */
PSR(0x0004,0x0004,SCIRIS, after3rd);
PSR(0x0004,0x0004,SCIMIS);

/* Read SCITrSR1 register in the trickbox. Expecting SCICARDUPINTR =1,
SCIINTR =1 */
PSR(0x0401,0x00000401,SCITrSR1);
    
/* Disable the SCICARDUPINTR */
PSW(0x004,SCIICR);

/* Idle clock is required for the interrupt to become disabled  */
PI(Dummyclock);
 
/* Read the SCI Interrupt identification register. Expecting
SCICARDUPINTR = 0 */
PSR(0x000,0x004,SCIRIS);
PSR(0x000,0x004,SCIMIS);
PSR(0x0001,0x0401,SCITrSR1);
 
/* Initiate the deactivation sequence by writing  '1' to the finish bit */ 
PSW(0x02,SCICR2);

Poll_value = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02 
             * clkmulfactor + Margin;

/* After the first stage CRESET = '0' */
PO(0x78D,0x3FF,SCISYNCACT,Poll_value,First stage of deactivation);

/* After the second stage CLKEN ='0' and SCICLKOUT = '0' */ 
PO(0x709,0x3FF,SCISYNCACT,Poll_value,Second stage of deactivation);

/* After the third stage DATAEN ='0',nSCIDATAOUTEN ='0',nSCIDATAEN ='0' */  
PO(0x401,0x3FF,SCISYNCACT,Poll_value,Third stage of deactivation);

/* After the 4th stage POWER = '0' */ 
PI(Dummyclock);
PO(0x400,0x3FF,SCISYNCACT,Poll_value,fourth_stage_of_deactivation);

/* Poll for the SCICARDDNINTR */ 
PI(Dummyclock);
PO(0x0200,0x00000200,SCITrSR1,Poll_value,SCICARDDNINTR_failed);
PSR(0x0200,0x00000200,SCITrSR1);
C("Card Down interrupt");

/* Read the SCI Interrupt identification register. Expecting
SCICARDDNNTR = 1 */
PSR(0x008,0x008,SCIRIS);
PSR(0x008,0x008,SCIMIS);

/* Read SCITrSR1 register in the trickbox. Expecting SCICARDDNINTR =1,
SCIINTR =1 */
PSR(0x0201,0x00000201,SCITrSR1);

/* Disable the SCICARDDNINTR */
PSW(0x008,SCIICR);
 
/* Idle clock is required for the interrupt to become disabled  */
PI(Dummyclock);
 
/* Read the SCI Interrupt identification register. Expecting
SCICARDDNINTR = 0 */
PSR(0x000,0x008,SCIRIS);
PSR(0x000,0x008,SCIMIS);
PSR(0x0000,0x00000200,SCITrSR1);

/* Make SCIDETECT to '0'  otherwise after debounce time SCICARDININTR 
becomes high */
PSW(0x2001,SCITrCR);

DELAY_value = (DactCount_value + 0x01) * (CLKICC_value + 0x01) * 0x02 
             * clkmulfactor * 0x03 + Margin;

/* Waiting for the completion of the deactivation */
  DELAY_value = DELAY_value/254  + 1;
 
  for(i = DELAY_value; i >= 0; i--)
  PI(254);

/* Mask all SCI interrupts  */
PSW(0x0000, SCIIMSC);

}/* End Function */
