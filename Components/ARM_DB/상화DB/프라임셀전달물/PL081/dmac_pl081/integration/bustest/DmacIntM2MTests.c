/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              :  DmacIntM2MTests.c.rca
-- File Revision          :  1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           These tests are targetted towards integration testing of the
--           AHB Master ports. These tests do M2M transfers through the 
--           the two master ports in the DMAC to the dummy memory
--           modules in the integration trickbox.
--
-- --=========================================================================*/

void DmacIntM2MTests()
{
 /*
   Summary : DmacIntM2MTests
   =========================
   These tests are carried out for integration testing of the master port
   of the Dmac.

   The tests are carried out on both the master ports by initiating
   a number of M2M data transfers between dummy memory models in the
   integration trickbox.

  LIMITATIONS :
  -----------
  1. These tests are targetted for the integration tests for the DMAC AHB
     Master ports. Here the dummy memory module is instantiated which
     responds to ALL the ADDRESSES and ALL the BUSWIDTH sizes. 
     But in the REAL systems that would not be the case.
     So things which should be taken care of are listed below:
     1. The actual addresses at which the AHB Slaves are present
        should be used in the accesses.
     2. The HSIZE to which is supported by the slaves should be used
        in the accesses
     3. For testing the connectivity of HPROT and HLOCK, AHB slaves
        that have support for these signals need to be used.
  So in this sense these tests are just informative as to how the integration
  tests can be run in the system. These will aid in defining the actual
  integration tests for the user system.

 */


   struct TestCases {
      char *TestNo;
      struct ChannelPara *CaseParameters;
     }; 
   struct ChannelPara ChannelTestPara[] =  {
     0, M2MDMAC, 32, 32, 1, 1, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, DEFWAIT1, DEFWAIT1, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR,
     1, M2MDMAC, 16, 32, 4, 4, 0x00000008, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFSPLIT, DEFSPLIT, ZERO, ZERO, PBC, LOCK, ZERO, ADDRINCR,
        ADDRINCR,
     0, M2MDMAC, 8, 16, 8, 8, 0x00000016, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFRETRY, DEFRETRY, ZERO, ZERO, pBc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, Pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     4, M2MDMAC, 32, 32, 1, 1, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, DEFWAIT1, DEFWAIT1, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR,
     5, M2MDMAC, 16, 32, 4, 4, 0x00000008, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFSPLIT, DEFSPLIT, ZERO, ZERO, PBC, LOCK, ZERO, ADDRINCR,
        ADDRINCR,
     6, M2MDMAC, 8, 16, 8, 8, 0x00000016, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFRETRY, DEFRETRY, ZERO, ZERO, pBc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     7, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, Pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, Pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
       };

     struct TestCases Tests[] = {
         "DMACINT_M2M_1",  &ChannelTestPara[0],
         "DMACINT_M2M_2",  &ChannelTestPara[1],
         "DMACINT_M2M_3",  &ChannelTestPara[2],
         "DMACINT_M2M_4",  &ChannelTestPara[3], 
#ifdef TWOMASTERCONFIG
         "DMACINT_M2M_5",  &ChannelTestPara[4],
         "DMACINT_M2M_6",  &ChannelTestPara[5],
         "DMACINT_M2M_7",  &ChannelTestPara[6],
         "DMACINT_M2M_8",  &ChannelTestPara[7],
#endif TWOMASTERCONFIG
         "DMACINT_M2M_9",  &ChannelTestPara[8], 
         "ENDOFTEST",      &ChannelTestPara[0]
         };

     int32 AddrPattern1 = 0xAAAAAAAC, AddrPattern2 = 0x5555555C;
     int32 AddrPattern3 = 0xFFFFFF30;
     int32 SrcAddrMask, DestAddrMask;
     int32 SrcAddr, DestAddr;
     int32 MemInfo;
     int32 CxConfigData;
     int32 CxControlRegData;
     int32 CxLLIRegData;
     int32 Addr, LLIAddr;
     int32 *RegAddr; 
     char  Message[100]; 

     struct TestCases *TestParameters = Tests;

     /* Enable the DMA Controller */
     Write(DMACConfig, DMACENABLE);

     while (TestParameters->TestNo != "ENDOFTEST")
     {
        struct ChannelPara *TestCasePara = TestParameters->CaseParameters;

        sprintf(Message,"Test No : %s",TestParameters->TestNo);
        C(Message);

        if (TestCasePara->SrcWidth == 8)
          SrcAddrMask = 0xFFFFFFFF;
        else if (TestCasePara->SrcWidth == 16)
          SrcAddrMask = 0xFFFFFFFE;
        else
          SrcAddrMask = 0xFFFFFFFC;

        if (TestCasePara->DestWidth == 8)
          DestAddrMask = 0xFFFFFFFF;
        else if (TestCasePara->DestWidth == 16)
          DestAddrMask = 0xFFFFFFFE;
        else
          DestAddrMask = 0xFFFFFFFC;

        /* Reset Memory 1 and 2 */
        Write(DMACTrMemEn0, MEMORYRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
        Write(DMACTrMemEn0, MEMORYRSTCLR);
        Write(DMACTrMemEn1, MEMORYRSTCLR);

        MemInfo = MEMORYENABLE | ADDRBASED | TestCasePara->SrcWaitCyc |
                  TestCasePara->SrcAHBResp;

        if (TestCasePara->SrcMaster == MASTER2)
        {
          Write(DMACTrMemEn1, MemInfo);
          if (TestParameters->TestNo == "DMACINT_M2M_5" ||
              TestParameters->TestNo == "DMACINT_M2M_7")
            Write(DMACTrMemData1, ONESCOMP);
          else
            Write(DMACTrMemData1, 0x00000000);
        }
        else
        {
          Write(DMACTrMemEn0, MemInfo);
          if (TestParameters->TestNo == "DMACINT_M2M_1" ||
              TestParameters->TestNo == "DMACINT_M2M_3")
            Write(DMACTrMemData0, ONESCOMP);
          else
            if (TestParameters->TestNo == "DMACINT_M2M_9")
              Write(DMACTrMemData0, 0x00000003);
            else
              Write(DMACTrMemData0, 0x00000000);
        }
    
        if (TestParameters->TestNo == "DMACINT_M2M_1" ||
            TestParameters->TestNo == "DMACINT_M2M_3" ||
            TestParameters->TestNo == "DMACINT_M2M_5" ||
            TestParameters->TestNo == "DMACINT_M2M_7")
        {
           SrcAddr  = AddrPattern1 & SrcAddrMask;
           DestAddr = AddrPattern1 & DestAddrMask;
        }
        else
          {
           if (TestParameters->TestNo == "DMACINT_M2M_9")
             {
              SrcAddr  = AddrPattern3 & SrcAddrMask;
              DestAddr = AddrPattern3 & DestAddrMask;
             }
           else
             {
              SrcAddr  = AddrPattern2 & SrcAddrMask;
              DestAddr = AddrPattern2 & DestAddrMask;
             }
          }

        CxControlRegData =
                        TestCasePara->TxSize             |
                        SbValue(TestCasePara->SrcBurst)  |
                        DbValue(TestCasePara->DestBurst) |
                        SwValue(TestCasePara->SrcWidth)  |
                        DwValue(TestCasePara->DestWidth) |
                        SmValue(TestCasePara->SrcMaster) |
                        DmValue(TestCasePara->DestMaster)|
                        SiValue(TestCasePara->SrcIncr)   |
                        DiValue(TestCasePara->DestIncr)  |
                        PtValue(TestCasePara->PROT);

        CxLLIRegData = 0x00000000;

       /*  Programmng ofSource, Destination, LLI and Control reg */
       ChannelPrgm(TestCasePara->Channel, SrcAddr, DestAddr, CxLLIRegData,
                   CxControlRegData);

       /* Enable Channel */
       CxConfigData = CHXENABLE |
                      TestCasePara->ChLOCK  |
                      TestCasePara->FlowControl;
 
       RegAddr = ChannelRegisters(TestCasePara->Channel);
       Write (*RegAddr + 0x00000010, CxConfigData);
   
       WaitLoop(200);

       TestParameters++;
     }
}
/************************** End of DmacIntM2MTests.c **************************/

