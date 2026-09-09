/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ForcedReset.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           Test code for Forced Reset test.
--
-- --=================================================================*/

/**********************************************************************/
/************************ Forced Reset test ***************************/
/**********************************************************************/
void ForcedReset(void)
{
 /*
   Summary : ForcedReset
   =====================
           This test verifies that the AACIRESET port follows the 
   FORCEDRESET bit in the AACIRESET register. The FORCEDRESET bit is 
   made '0' for a few clocks and then made '1' for a few clocks. The 
   trickbox internally checks whether the AACIRESET port follows the
   FORCEDRESET bit which is mirrored in the trickbox. Any differences 
   between the two values are flagged as errors by the trickbox. 
 */
 int i = 0;

 C(" FORCED RESET TEST");
 PSW(AACI_FORCEDRESET0,AACIRESET,FORCEDRESET);
 PI(0x02);
 for (i = 0; i < 10; i++)
   {
    PSR(AACI_FORCEDRESET0,MASK_ALL,AACIRESET,AACI1_T1);
    PI(0x02);
   }
 PSW(AACI_FORCEDRESET1, AACIRESET, FORCEDRESET);
 PI(0x02);
 
 for (i = 0; i < 10; i++)
   {
    PSR(AACI_FORCEDRESET1, MASK_ALL, AACIRESET,AACI1_T2);
    PI(0x02);
   } 
   PSW(AACITB_En | AACITB_BtClkEn | AACITB_BtClkRst, AACITrCntlReg);
 C(" END OF FORCED RESET TEST");
}

/************************ End of ForcedReset.c ************************/
