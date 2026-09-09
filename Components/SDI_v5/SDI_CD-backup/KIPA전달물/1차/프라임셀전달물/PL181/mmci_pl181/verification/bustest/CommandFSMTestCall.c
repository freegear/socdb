/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : CommandFSMTestCall.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to verify CPSM operation
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  COMMANDFSM  Test *******************************/
/******************************************************************************/

void CommandFSMTest (int32 argument, int32 index, int32 respdelay,
                     int32 cardsel, int32 resp0, int32 resp1,
                     int32 resp2, int32 resp3, int32 clkdiv, int32 pwr,
                     int32 crc, int32 mode, int32 intrpt, int32 bypass)
{
  /* Summary : Command FSM Tests
     ===========================

     Short Response mode
     -------------------
     The command register and argument register
     are programmed for short response. A few transfers are allowed to
     occur. The data received and transmitted are checked along with
     the relevant status flags.

     Long Response mode
     ------------------
     The command register and argument register are
     programmed for long response. A few transfers are allowed to
     occur. The data received and transmitted are checked along with
     the relevant status flags.

     No Response mode
     ----------------
     The command register and argument register are
     programmed for No response. A few transfers are allowed to occur.
     The data transmitted is checked along with the relevant flags.

     In each of the above modes the following variations are included.
     - The bits of the Argument, Response and Index fields are changed,
       so that all variations of data go into the CRC generation block
       in the MMCI.
     - The ClkDiv value is programmed to different values so that the
       frequency of operation is varied.
     - The Trickbox is programmed to give a wrong CRC.
     - The CPSM test are run in power down mode.
     - The Trickbox is programmed to give the response after programmed
       delays.
  */

  int32 indexand, modeand, intrptand, pwrand, bypassand, resp3and;
  indexand   = index & INDEX_MASK;
  modeand    = (mode  & 0x00000003) << 6;
  intrptand  = (intrpt  & 0x00000001) << 8;
  pwrand     = (pwr  & 0x00000001) << 9;
  bypassand  = (bypass  & 0x00000001) << 10;
  resp3and   =  resp3 & 0x00FFFFFF;

  PSW(POWERON | VOLTAGE3, MMCIPower);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x10);
  PSW(0x00010000,MMCITBPCDisable);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x10);
  PSW(clkdiv | CLKENB | pwrand | bypassand, MMCIClock);
  Idle(((MCLK_PERIOD/PCLK_PERIOD) * (2 * (CLKDIV + 1))) * 0x10);

  /* Reset all Protocol Disables when not in power save mode */
  if (pwr == 0x0)
  PSW(0x00000000,MMCITBPCDisable);

  PSW(argument, MMCIArgument);
  PSW(indexand, MMCITBCmdResponse);
  PSW(resp1, MMCITBResponse1);
  PSW(resp2, MMCITBResponse2);
  PSW(resp3and, MMCITBResponse3);
  PSW(respdelay, MMCITBRespTimer);
  PSW(crc, MMCITBControl);
  if (mode == 0x00000001)
    PSW(cardsel, MMCITBResponse0);
  else
    PSW(resp0, MMCITBResponse0);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  PSW(indexand | modeand | 0x00000400 | intrptand, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  if ((mode == 0x00000002)||(mode == 0x00000000)) /* CmdSent mode  */
   {
    PO(0x00000080, CMDSENT, MMCIStatus,0x0000FFFF);
    PI(20);
    PSR(indexand, INDEX_MASK, MMCITBRecdCmdInd);
    PSR(argument, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
   }
  else
    if (crc == 0x00000001 && respdelay < 0x0000003E) /* CRC error set */
      PO(0x00000001, CMDCRCFAIL, MMCIStatus,0x0000FFFF);
    else
     {
      if (intrpt == 0x00000001) /* Intrpt bit set hence no timeout */
        if (respdelay >= 0x0000003E) /* respdelay < 62 ,no timeout*/
          PO(0x00000000, CMDTIMEOUT, MMCIStatus,0x0000FFFF);
      else
        if (respdelay < 0x0000003E) /* respdelay < 62 ,no timeout*/
          PO(0x00000040, CMDRESPEND, MMCIStatus,0x0000FFFF);
        else
          PO(0x00000004, CMDTIMEOUT, MMCIStatus,0x0000FFFF);

      if (crc == 0x00000000 && respdelay < 0x0000003E)
        {
         PO(0x00000040, CMDRESPEND, MMCIStatus,0x0000FFFF);
         PSR(indexand, INDEX_MASK, MMCITBRecdCmdInd);
         PSR(argument, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
         if (mode == 0x00000001)
           {
             PSR(indexand, INDEX_MASK, MMCIRespCmd);
             PSR(cardsel, MASK_MMCIResponse0, MMCIResponse0);
           }
         if (mode == 0x00000003)
           {
             PSR(0x0000003F, INDEX_MASK, MMCIRespCmd);
             PSR(resp0, MASK_MMCIResponse0, MMCIResponse0);
             PSR(resp1, MASK_MMCIResponse1, MMCIResponse1);
             PSR(resp2, MASK_MMCIResponse2, MMCIResponse2);
             resp3and   = (resp3 & 0x00FFFFFF) << 8;
             PSR(resp3and, 0x7FFFFF00, MMCIResponse3);
           }
        }
   }
}

/******************************************************************************/
/**************************** COMMANDFSM Test call ****************************/
/******************************************************************************/

void CommandFSMTestCall(void)
{
  /*
     Summary : CommandFSMTestCall
     ============================
     This test exercises the CPSM in the following different
     possibilities,
     o Bypass and non-bypass mode
     o Powersave and non-powersave mode
     o Short response,long response and no response modes
     o Interrupt mode and non-Interrupt mode
     o Timeout, just timeout (Timeout at exactly 64 MMCICLKOUT periods)
       and no timeout cases
     o Responses with correct and wrong crc's
     This test achieves the above by repeatedly calling the
     CommandFSMTest() function with different arguments.
  */

  int32 argument,index,respdelay,cardsel,resp0,resp1,resp2,resp3;
  int32 clkdiv,pwr,crc,mode,intrpt,bypass;

  for (clkdiv = 0; clkdiv < 2 ;clkdiv++)
  {
    if (clkdiv == 0)
      bypass = 0x1;
    else
      bypass = 0x0;

    for (pwr = 0; pwr < 2; pwr++)
    {
      PSW(0x00010000,MMCITBPCDisable);
      for (mode = 0x0; mode < 0x4; mode ++)
        for (intrpt = 0; intrpt < 2; intrpt++)
          for (respdelay = 0x1; respdelay < 0x5F;
                                      respdelay = respdelay + 0x1F)
            for (crc = 0x0; crc < 0x2; crc++)
            {
              sprintf(printstr, "COMMAND TRANSFER INITIATED WITH
                 BYPASS BIT  = %d
                 PWRSAVE BIT = %d
                 INTR BIT    = %d", bypass, pwr, intrpt);
              C(printstr);
              if ( respdelay > 0x3E )
              {
                C("TRICKBOX RESPONSE DELAY PROGRAMMED FOR TIMEOUT");
                PSW(0x00010000,MMCITBPCDisable);
              }
              if (crc == 1)
              {
                C("TRICKBOX PROGRAMMED TO RESPOND WITH WRONG CRC");
                PSW(0x00010000,MMCITBPCDisable);
              }
              if (mode == 0x0 || mode == 0x2)
              {
                C("NO-RESPONSE MODE");
              }
              else
              {
                if (mode == 0x1)
                  C("SHORT RESPONSE MODE");
                else
                  C("LONG RESPONSE MODE");
              }

              argument = Randomgen();
              index    = Randomgen() & 0x0000003F;
              cardsel  = Randomgen();
              resp0    = Randomgen();
              resp1    = Randomgen();
              resp2    = Randomgen();
              resp3    = Randomgen();


              PSW(CLEARALL, MMCIClear);
              CommandFSMTest (argument, index, respdelay, cardsel,
                              resp0, resp1, resp2, resp3, clkdiv,
                              pwr, crc, mode, intrpt, bypass);
              if (MCLK_PERIOD > PCLK_PERIOD)
                PSW(0x00000000,MMCITBPCDisable);
            }
    }
  }

  C("END OF COMMAND FSM TESTS");
}

/*******************************  End  ****************************************/
