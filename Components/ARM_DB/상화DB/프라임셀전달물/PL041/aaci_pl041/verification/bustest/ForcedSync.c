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
-- File Name              : ForcedSync.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : 
--           Test code for Forced Sync test.
--
-- --=================================================================*/

/**********************************************************************/
/************************ Forced Sync Test ****************************/
/**********************************************************************/
void ForcedSync(void)
{
 /* 
   Summary : ForcedSync
   ====================
           This test verifies that the AACISYNC port follows the
   FORCEDSYNC bit in the AACISYNC register. The FORCEDSYNC bit is
   made '0' for a few clocks and then made '1' for a few clocks. The
   trickbox internally checks whether the AACISYNC port follows the
   FORCEDSYNC bit which is mirrored in the trickbox. Any differences
   between the two values are flagged as errors by the trickbox.
 */

 int temp;
 temp = AACIBITCLK_PERIOD / PCLK_PERIOD;

 if (AACIBITCLK_PERIOD < PCLK_PERIOD)
   temp = 0x1;

 C("FORCED SYNC TEST");

 PSW(AACITB_BtClkRst, AACITrCntlReg);/* Disable Bitclk*/
 PI(0x02);
 C("CHECKING THE AACISYNC PORT IN THE ABSENSE OF AACIBITCLK");

 /* Set ForcedSync Bit     */
 PSW(AACI_FORCEDSYNC, AACISYNC);

 /* Wait for a duration of 10 Bitclk periods during which the
    trickbox flags an error if the AACISYNC port is not '1' */
 PI(10 * temp);

 /* Clear ForcedSync Bit   */
 PSW(0x0, AACISYNC);

 /* Wait for a duration of 10 Bitclk periods during which the
    trickbox flags an error if the AACISYNC port is not '0' */
 PI(10 * temp);

 C("CHECKING THE AACISYNC PORT IN THE PRESENSE OF AACIBITCLK");

  /* Set ForcedSync Bit     */
 PSW(AACI_FORCEDSYNC, AACISYNC);

 /* Enable Bitclk          */
 PSW(AACITB_BtClkEn | AACITB_BtClkRst,AACITrCntlReg);

 /* Wait for a duration of 20 Bitclk periods during which the
    trickbox flags an error if the AACISYNC port is not '1' */
 PI(20 * temp);

 /* Clear ForcedSync Bit   */
 PSW(0x0, AACISYNC);

  /* Wait for a duration of 10 Bitclk periods during which the
    trickbox flags an error if the AACISYNC port is not '0' */
 PI(20 * temp);

 C("END OF FORCED SYNC TEST");
}

/************************ End of ForcedSync.c *************************/
