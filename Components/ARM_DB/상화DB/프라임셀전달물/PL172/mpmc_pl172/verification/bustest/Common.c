/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Common.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It is a common program which contains functions used by other test
--           cases. 
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** Variables *************************************/
/******************************************************************************/
char retstr[100];
char debugstr[500];
char message[200];
/******************************************************************************/
/****************************** WaitLoop **************************************/
/******************************************************************************/
void WaitLoop(int cycles)
{
  /*
    Summary : Idle cycle insertion Loop
    ===================================

    o The number of Idle cycles inserted will be determined by the
      integer 'cycles'
   
    o Idle cycles are inserted during read operation
  */

  int i;

  for (i = 1; i <= cycles; i++)
  {
    HSA(0x00000000, IDLE, INCR, , , , , , , , , ,idle);
    HSR(, Data_0s, , , ,idlecycle);
  }
}
/******************************************************************************/
/****************************** WrWaitLoop ************************************/
/******************************************************************************/
void WrWaitLoop(int cycles)
{
  /*
    Summary : Idle cycle insertion Loop
    ===================================

    o The number of Idle cycles inserted will be determined by the
      integer 'cycles'

    o Idle cycles are inserted during write operation
  */

  int i;

  for (i = 1; i <= cycles; i++)
  {
    HSA(0x00000000, IDLE, INCR, , , , , , , , , ,idle);
    HSW(, Data_0s);
  }
}
/******************************************************************************/
/************************************* Message   ******************************/
/******************************************************************************/

void debug_info(char *message)
{
  /*
     Summary: debug_info
     ===================
     
     o This is to selectively display the messages.
  */
    
  if (INFO == 1)
    C(message);
}

/******************************************************************************/
/******************************* Word Write  **********************************/
/******************************************************************************/
 void WordTrans(unsigned long address,int datacount,char BurstType[7],
               int32 data, int BusyCnt, int Position1,
               int PosnCount1, int Position2, int PosnCount2,int htran)
{
  /*
     Summary : Word Write Function
     =============================
     This function can issue Word data transfers from the AHB ports in all
     the HBURST types. It can also insert any number of BUSY states in the
     data transfer anywhere in the burst. The BUSY states can be inserted in any
     2 sets of positions in the burst. The positions of the burst where the BUSY
     states are to be inserted are decided by the input arguments Position1 and
     Position2. The number of Positions starting from Position1 where the busy
     states are to be inserted is decided by the input argument PosnCount1.
     Similarly, PosnCount2 decides the number of positions in which the busy
     states are to be inserted starting from Position2. The number of BUSY
     states that are inserted each time is decided by the input argument BusyCnt
  */

  unsigned index=0;
  unsigned i=0,k;
  int      count = 1, count1, count2;
  int      Mask;
  char *htrans[2] = {"n","s"};
  char     message [1000];
  if (datacount != 0)
  {
    HSA(address,htrans[htran],BurstType,OK,WRD);
 
    index = ((address) % 64);

    HSW(,data++);

    if (datacount > Position1)
    {
      if (Position1 >= 1)
      {
        for (i = 0; i < Position1; i++)
        {
          if (BurstType == WRAP4)
          {
            Mask      = address & 0x000F;
            if (Mask == 0x0C)
              address = address - 0x0C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP8)
          {
            Mask      = address & 0x001F;
            if (Mask == 0x01C)
              address = address - 0x01C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP16)
          {
            Mask      = address & 0x003F;
            if (Mask == 0x03C)
              address = address - 0x03C;
            else
              address = address + 4;
          }
          else
            address    = address + 4;

          HSA(address,SEQ,BurstType,OK,WRD);
          HSW(,data++);
          count += 1;
        }
      }

      if (PosnCount1 > 0)
      {
        if (BusyCnt != 0)
        {
          for (k = 0; k < BusyCnt; k++)
          {
            HSA(,BUSY, ,OK,WRD);
            HSW(,data, ,Busydata);
          }
        }
      }
      if (datacount > 1)
      {
        if (datacount >= (Position1 + PosnCount1))
          count1 = PosnCount1;
        else
        {
          count1 = datacount - Position1 - 1;
         C("Invalid values :Datacount is lesser than (Position1 + PosnCount1)");
        }
        for (i = 1; i < count1; i++)
        {
          if (BurstType == WRAP4)
          {
            Mask      = address & 0x000F;
            if (Mask == 0x0C)
              address = address - 0x0C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP8)
          {
            Mask      = address & 0x001F;
            if (Mask == 0x01C)
              address = address - 0x01C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP16)
          {
            Mask      = address & 0x003F;
            if (Mask == 0x03C)
              address = address - 0x03C;
            else
              address = address + 4;
          }
          else
            address    = address + 4;
 
          HSA(address,SEQ,BurstType,OK,WRD);
          HSW(,data++);
          count += 1;
 
          if (BusyCnt != 0)
          {
            for (k = 0; k < BusyCnt; k++)
            {
              HSA(,BUSY, ,OK,WRD);
              HSW(,data, ,Busydata);
            }
          }
        }
      }
    } 
 
    for (i = count; i < (Position2 + 1); i++)
    {
      if (BurstType == WRAP4)
      {
        Mask      = address & 0x000F;
        if (Mask == 0x0C)
          address = address - 0x0C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP8)
      {
        Mask      = address & 0x001F;
        if (Mask == 0x01C)
          address = address - 0x01C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP16)
      {
        Mask      = address & 0x003F;
        if (Mask == 0x03C)
          address = address - 0x03C;
        else
          address = address + 4;
      }
      else
        address    = address + 4;
 
      HSA(address,SEQ,BurstType,OK,WRD);
      HSW(,data++);
      count += 1;
    } 
 
    if ((PosnCount2 > 0) && (Position2 < datacount) &&
       (Position2 >= (Position1 + PosnCount1)))
    {
      if (BusyCnt != 0)
      {
        for (k = 0; k < BusyCnt; k++)
        {
          HSA(,BUSY, ,OK,WRD);
          HSW(,data, ,Busydata);
        }
 
     }
    }

    if ((datacount > Position2) && (datacount > count))
    {
      if (Position2 >= (Position1 + PosnCount1))
      {
        if (datacount > (Position2 + PosnCount2))
          count2 = PosnCount2;
        else
        {
          count2 = datacount - Position2 - 1;
         C("Invalid values :Datacount is lesser than (Position2 + PosnCount2)");
        }
        for (i = 1; i < count2; i++)
        {
          if (BurstType == WRAP4)
          {
            Mask      = address & 0x000F;
            if (Mask == 0x0C)
              address = address - 0x0C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP8)
          {
            Mask      = address & 0x001F;
            if (Mask == 0x01C)
              address = address - 0x01C;
            else
              address = address + 4;
          }
          else if (BurstType == WRAP16)
          {
            Mask      = address & 0x003F;
            if (Mask == 0x03C)
              address = address - 0x03C;
            else
              address = address + 4;
          }
          else
            address    = address + 4;
 
          HSA(address,SEQ,BurstType,OK,WRD);
          HSW(,data++);
          count += 1;

          if (BusyCnt != 0)
          {
            for (k = 0; k < BusyCnt; k++)
            {
              HSA(,BUSY, ,OK,WRD);
              HSW(,data, ,Busydata);
            }
          }
        }
      }
      else if (PosnCount2 != 0)
      {
        if ((Position1 != Position2) && (PosnCount2 != 0))
          C("Invalid values :Position2 is lesser than Position1");
        else if (Position2 < (Position1 + PosnCount1))
         C("Invalid values :Position2 is lesser than (Position1 + PosnCount1)");
      }
    } 
    for (i = count; i < datacount; i++)
    {
      if (BurstType == WRAP4)
      {
        Mask      = address & 0x000F;
        if (Mask == 0x0C)
          address = address - 0x0C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP8)
      {
        Mask      = address & 0x001F;
        if (Mask == 0x01C)
          address = address - 0x01C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP16)
      {
        Mask      = address & 0x003F;
        if (Mask == 0x03C)
          address = address - 0x03C;
        else
          address = address + 4;
      }
      else
        address    = address + 4;
 
      HSA(address,SEQ,BurstType,OK,WRD);
      HSW(,data++);
    }
  }
} 
/****************************************************************************/
/******************************* Word Read **********************************/
/****************************************************************************/
void WordRd(unsigned long address,unsigned int datacount,char BurstType[7],
int32 data,int idlest)
{
  /*
    Summary : WordRd
    ================
    This function generates the AHB slave test bench instructions for
    a wordwide read access. The starting address of the read access
    is the input address. The number of data transfers in the read
    access is same as the input datacount and the data is stored in
    the respective address of the bytedata array input.
  */
  int busyst,k;
  unsigned start=0;
  unsigned index=0;
  unsigned i=0;
  int Mask;

  if (datacount != 0)
  {
    HSA(address,NSEQ,BurstType,OK,WRD);
    HSR(,data++, ,0xFFFFFFFF, ,firstWdRd);
 
    busyst = (rand() % 6 + 1);
    for(k = 0; k < busyst; k++)
    {
       HSA(address + 4, BUSY, BurstType, OK, WRD);
       HSR(,data , ,MaskALL);
    }
    if(idlest == 1)
    {
      HSA(0x00000000,IDLE,BurstType, OK, WRD);
      HSR(,data , ,MaskALL);
      address = address + 4;
      HSA(address,NSEQ, BurstType, OK, WRD);
      HSR(,data++, ,MaskALL);
    }
    for (i = 1; i<datacount-1 ; i++)
    {
      if (BurstType == WRAP4)
      {
        Mask      = address & 0x000F;
        if (Mask == 0x0C)
          address = address - 0x0C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP8)
      {
        Mask      = address & 0x001F;
        if (Mask == 0x01C)
          address = address - 0x01C;
        else
          address = address + 4;
      }
      else if (BurstType == WRAP16)
      {
        Mask      = address & 0x003F;
        if (Mask == 0x03C)
          address = address - 0x03C;
        else
          address = address + 4;
      }
      else
        address    = address + 4;
 
      HSA(address,SEQ,BurstType,OK,WRD);
      HSR(,data++, ,0xFFFFFFFF, ,WordRd);
    }
  }
} 
/******************************************************************************/
struct ConstantList {
              char *ConstantName;
              int32  ConstantValue;
              }; 
/******************************************************************************/
struct ConstantList MpmcConstants[400] 
     = {
        "MPMCControl",MPMCControl,
        "MPMCStatus",MPMCStatus,
        "MPMCConfig",MPMCConfig,
        "MPMCDyCntl",MPMCDyCntl,
        "MPMCDyRef",MPMCDyRef,
        "MPMCDyRdCfg",MPMCDyRdCfg,
        "MPMCDytRP",MPMCDytRP,
        "MPMCDytRAS",MPMCDytRAS,
        "MPMCDytSREX",MPMCDytSREX,
        "MPMCDytAPR",MPMCDytAPR,
        "MPMCDytDAL",MPMCDytDAL,
        "MPMCDytWR",MPMCDytWR,
        "MPMCDytRC",MPMCDytRC,
        "MPMCDytRFC",MPMCDytRFC,
        "MPMCDytXSR",MPMCDytXSR,
        "MPMCDytRRD",MPMCDytRRD,
        "MPMCDytMRD",MPMCDytMRD,
        "MPMCStExdWt",MPMCStExdWt,
        "MPMCDyConfig0",MPMCDyConfig0,
        "MPMCDyRasCas0",MPMCDyRasCas0,
        "MPMCDyConfig1",MPMCDyConfig1,
        "MPMCDyRasCas1",MPMCDyRasCas1,
        "MPMCDyConfig2",MPMCDyConfig2,
        "MPMCDyRasCas2",MPMCDyRasCas2,
        "MPMCDyConfig3",MPMCDyConfig3,
        "MPMCDyRasCas3",MPMCDyRasCas3,
        "MPMCStConfig0",MPMCStConfig0,
        "MPMCStWtWen0",MPMCStWtWen0,
        "MPMCStWtOen0",MPMCStWtOen0,
        "MPMCStWtRd0",MPMCStWtRd0,
        "MPMCStWtPg0",MPMCStWtPg0,
        "MPMCStWtWr0",MPMCStWtWr0,
        "MPMCStWtTurn0",MPMCStWtTurn0,
        "MPMCStConfig1",MPMCStConfig1,
        "MPMCStWtWen1",MPMCStWtWen1,
        "MPMCStWtOen1",MPMCStWtOen1,
        "MPMCStWtRd1",MPMCStWtRd1,
        "MPMCStWtPg1",MPMCStWtPg1,
        "MPMCStWtWr1",MPMCStWtWr1,
        "MPMCStWtTurn1",MPMCStWtTurn1,
        "MPMCStConfig2",MPMCStConfig2,
        "MPMCStWtWen2",MPMCStWtWen2,
        "MPMCStWtOen2",MPMCStWtOen2,
        "MPMCStWtRd2",MPMCStWtRd2,
        "MPMCStWtPg2",MPMCStWtPg2,
        "MPMCStWtWr2",MPMCStWtWr2,
        "MPMCStWtTurn2",MPMCStWtTurn2,
        "MPMCStConfig3",MPMCStConfig3,
        "MPMCStWtWen3",MPMCStWtWen3,
        "MPMCStWtOen3",MPMCStWtOen3,
        "MPMCStWtRd3",MPMCStWtRd3,
        "MPMCStWtPg3",MPMCStWtPg3,
        "MPMCStWtWr3",MPMCStWtWr3,
        "MPMCStWtTurn3",MPMCStWtTurn3,
        "MPMCITCR",MPMCITCR,
        "MPMCITIP",MPMCITIP,
        "MPMCITOP",MPMCITOP,
        "MPMCPeriphId4",MPMCPeriphId4,
        "MPMCPeriphId5",MPMCPeriphId5,
        "MPMCPeriphId6",MPMCPeriphId6,
        "MPMCPeriphId7",MPMCPeriphId7,
        "MPMCPeriphId0",MPMCPeriphId0,
        "MPMCPeriphId1",MPMCPeriphId1,
        "MPMCPeriphId2",MPMCPeriphId2,
        "MPMCPeriphId3",MPMCPeriphId3,
        "MPMCPCellId0",MPMCPCellId0,
        "MPMCPCellId1",MPMCPCellId1,
        "MPMCPCellId2",MPMCPCellId2,
        "MPMCPCellId3",MPMCPCellId3,
        "PRST_MPMCControl",PRST_MPMCControl,
        "PRST_MPMCStatus",PRST_MPMCStatus,
        "PRST_MPMCConfig",PRST_MPMCConfig,
        "PRST_MPMCDyCntl",PRST_MPMCDyCntl,
        "PRST_MPMCDyRef", PRST_MPMCDyRef,
        "PRST_MPMCDyRdCfg", PRST_MPMCDyRdCfg,
        "PRST_MPMCDytRP",PRST_MPMCDytRP,
        "PRST_MPMCDytRAS",PRST_MPMCDytRAS,
        "PRST_MPMCDytSREX",PRST_MPMCDytSREX,
        "PRST_MPMCDytAPR",PRST_MPMCDytAPR,
        "PRST_MPMCDytDAL",PRST_MPMCDytDAL,
        "PRST_MPMCDytWR",PRST_MPMCDytWR,
        "PRST_MPMCDytRC",PRST_MPMCDytRC,
        "PRST_MPMCDytRFC",PRST_MPMCDytRFC,
        "PRST_MPMCDytXSR",PRST_MPMCDytXSR,
        "PRST_MPMCDytRRD",PRST_MPMCDytRRD,
        "PRST_MPMCDytMRD",PRST_MPMCDytMRD,
        "PRST_MPMCStExdWt",PRST_MPMCStExdWt,
        "PRST_MPMCDyConfig0",PRST_MPMCDyConfig0,
        "PRST_MPMCDyRasCas0",PRST_MPMCDyRasCas0,
        "PRST_MPMCDyConfig1",PRST_MPMCDyConfig1,
        "PRST_MPMCDyRasCas1",PRST_MPMCDyRasCas1,
        "PRST_MPMCDyConfig2",PRST_MPMCDyConfig2,
        "PRST_MPMCDyRasCas2",PRST_MPMCDyRasCas2,
        "PRST_MPMCDyConfig3",PRST_MPMCDyConfig2,
        "PRST_MPMCDyRasCas3",PRST_MPMCDyRasCas2,
        "PRST_MPMCStConfig0",PRST_MPMCStConfig0,
        "PRST_MPMCStWtWen0",PRST_MPMCStWtWen0,
        "PRST_MPMCStWtOen0",PRST_MPMCStWtOen0,
        "PRST_MPMCStWtRd0",PRST_MPMCStWtRd0,
        "PRST_MPMCStWtPg0",PRST_MPMCStWtPg0,
        "PRST_MPMCStWtWr0",PRST_MPMCStWtWr0,
        "PRST_MPMCStWtTurn0",PRST_MPMCStWtTurn0,
        "PRST_MPMCStConfig1",PRST_MPMCStConfig1,
        "PRST_MPMCStWtWen1",PRST_MPMCStWtWen1,
        "PRST_MPMCStWtOen1",PRST_MPMCStWtOen1,
        "PRST_MPMCStWtRd1",PRST_MPMCStWtRd1,
        "PRST_MPMCStWtPg1",PRST_MPMCStWtPg1,
        "PRST_MPMCStWtWr1",PRST_MPMCStWtWr1,
        "PRST_MPMCStWtTurn1",PRST_MPMCStWtTurn1,
        "PRST_MPMCStConfig2",PRST_MPMCStConfig2,
        "PRST_MPMCStWtWen2",PRST_MPMCStWtWen2,
        "PRST_MPMCStWtOen2",PRST_MPMCStWtOen2,
        "PRST_MPMCStWtRd2",PRST_MPMCStWtRd2,
        "PRST_MPMCStWtPg2",PRST_MPMCStWtPg2,
        "PRST_MPMCStWtWr2",PRST_MPMCStWtWr2,
        "PRST_MPMCStWtTurn2",PRST_MPMCStWtTurn2,
        "PRST_MPMCStConfig3",PRST_MPMCStConfig3,
        "PRST_MPMCStWtWen3",PRST_MPMCStWtWen3,
        "PRST_MPMCStWtOen3",PRST_MPMCStWtOen3,
        "PRST_MPMCStWtRd3",PRST_MPMCStWtRd3,
        "PRST_MPMCStWtPg3",PRST_MPMCStWtPg3,
        "PRST_MPMCStWtWr3",PRST_MPMCStWtWr3,
        "PRST_MPMCStWtTurn3",PRST_MPMCStWtTurn3,
        "PRST_MPMCITCR",PRST_MPMCITCR,
        "PRST_MPMCPeriphId4",PRST_MPMCPeriphId4,
        "PRST_MPMCPeriphId5",PRST_MPMCPeriphId5,
        "PRST_MPMCPeriphId6",PRST_MPMCPeriphId6,
        "PRST_MPMCPeriphId7",PRST_MPMCPeriphId7,
        "PRST_MPMCPeriphId0",PRST_MPMCPeriphId0,
        "PRST_MPMCPeriphId1",PRST_MPMCPeriphId1,
        "PRST_MPMCPeriphId2",PRST_MPMCPeriphId2,
        "PRST_MPMCPeriphId3",PRST_MPMCPeriphId3,
        "PRST_MPMCPCellId0",PRST_MPMCPCellId0,
        "PRST_MPMCPCellId1",PRST_MPMCPCellId1,
        "PRST_MPMCPCellId2",PRST_MPMCPCellId2,
        "PRST_MPMCPCellId3",PRST_MPMCPCellId3,
        "HRST_MPMCControl",HRST_MPMCControl,
        "HRST_MPMCITCR",HRST_MPMCITCR,
        "HRST_MPMCITIP",HRST_MPMCITIP,
        "HRST_MPMCITOP",HRST_MPMCITOP,
        "HRST_MPMCPeriphId4",HRST_MPMCPeriphId4,
        "HRST_MPMCPeriphId5",HRST_MPMCPeriphId5,
        "HRST_MPMCPeriphId6",HRST_MPMCPeriphId6,
        "HRST_MPMCPeriphId7",HRST_MPMCPeriphId7,
        "HRST_MPMCPeriphId0",HRST_MPMCPeriphId0,
        "HRST_MPMCPeriphId1",HRST_MPMCPeriphId1,
        "HRST_MPMCPeriphId2",HRST_MPMCPeriphId2,
        "HRST_MPMCPeriphId3",HRST_MPMCPeriphId3,
        "HRST_MPMCPCellId0",HRST_MPMCPCellId0,
        "HRST_MPMCPCellId1",HRST_MPMCPCellId1,
        "HRST_MPMCPCellId2",HRST_MPMCPCellId2,
        "HRST_MPMCPCellId3",HRST_MPMCPCellId3,
        "RDO_MPMCStatus",RDO_MPMCStatus,
        "RDO_MPMCPeriphId4",RDO_MPMCPeriphId4,
        "RDO_MPMCPeriphId5",RDO_MPMCPeriphId5,
        "RDO_MPMCPeriphId6",RDO_MPMCPeriphId6,
        "RDO_MPMCPeriphId7",RDO_MPMCPeriphId7,
        "RDO_MPMCPeriphId0",RDO_MPMCPeriphId0,
        "RDO_MPMCPeriphId1",RDO_MPMCPeriphId1,
        "RDO_MPMCPeriphId2",RDO_MPMCPeriphId2,
        "RDO_MPMCPeriphId3",RDO_MPMCPeriphId3,
        "RDO_MPMCPCellId0",RDO_MPMCPCellId0,
        "RDO_MPMCPCellId1",RDO_MPMCPCellId1,
        "RDO_MPMCPCellId2",RDO_MPMCPCellId2,
        "RDO_MPMCPCellId3",RDO_MPMCPCellId3,
        "MASK_MPMCControl",MASK_MPMCControl,
        "MASK_MPMCConfig",MASK_MPMCConfig,
        "MASK_MPMCDyCntl",MASK_MPMCDyCntl,
        "MASK_MPMCDyRef",MASK_MPMCDyRef,
        "MASK_MPMCDyRdCfg",MASK_MPMCDyRdCfg,
        "MASK_MPMCDytRP",MASK_MPMCDytRP,
        "MASK_MPMCDytRAS",MASK_MPMCDytRAS,
        "MASK_MPMCDytSREX",MASK_MPMCDytSREX,
        "MASK_MPMCDytAPR",MASK_MPMCDytAPR,
        "MASK_MPMCDytDAL",MASK_MPMCDytDAL,
        "MASK_MPMCDytWR",MASK_MPMCDytWR,
        "MASK_MPMCDytRC",MASK_MPMCDytRC,
        "MASK_MPMCDytRFC",MASK_MPMCDytRFC,
        "MASK_MPMCDytXSR",MASK_MPMCDytXSR,
        "MASK_MPMCDytRRD",MASK_MPMCDytRRD,
        "MASK_MPMCDytMRD",MASK_MPMCDytMRD,
        "MASK_MPMCStExdWt",MASK_MPMCStExdWt,
        "MASK_MPMCDyConfig0",MASK_MPMCDyConfig0,
        "MASK_MPMCDyRasCas0",MASK_MPMCDyRasCas0,
        "MASK_MPMCDyConfig1",MASK_MPMCDyConfig1,
        "MASK_MPMCDyRasCas1",MASK_MPMCDyRasCas1,
        "MASK_MPMCDyConfig2",MASK_MPMCDyConfig2,
        "MASK_MPMCDyRasCas2",MASK_MPMCDyRasCas2,
        "MASK_MPMCDyConfig3",MASK_MPMCDyConfig3,
        "MASK_MPMCDyRasCas3",MASK_MPMCDyRasCas3,
        "MASK_MPMCStConfig0",MASK_MPMCStConfig0,
        "MASK_MPMCStWtWen0",MASK_MPMCStWtWen0,
        "MASK_MPMCStWtOen0",MASK_MPMCStWtOen0,
        "MASK_MPMCStWtRd0",MASK_MPMCStWtRd0,
        "MASK_MPMCStWtPg0",MASK_MPMCStWtPg0,
        "MASK_MPMCStWtWr0",MASK_MPMCStWtWr0,
        "MASK_MPMCStWtTurn0",MASK_MPMCStWtTurn0,
        "MASK_MPMCStConfig1",MASK_MPMCStConfig1,
        "MASK_MPMCStWtWen1",MASK_MPMCStWtWen1,
        "MASK_MPMCStWtOen1",MASK_MPMCStWtOen1,
        "MASK_MPMCStWtRd1",MASK_MPMCStWtRd1,
        "MASK_MPMCStWtPg1",MASK_MPMCStWtPg1,
        "MASK_MPMCStWtWr1",MASK_MPMCStWtWr1,
        "MASK_MPMCStWtTurn1",MASK_MPMCStWtTurn1,
        "MASK_MPMCStConfig2",MASK_MPMCStConfig2,
        "MASK_MPMCStWtWen2",MASK_MPMCStWtWen2,
        "MASK_MPMCStWtOen2",MASK_MPMCStWtOen2,
        "MASK_MPMCStWtRd2",MASK_MPMCStWtRd2,
        "MASK_MPMCStWtPg2",MASK_MPMCStWtPg2,
        "MASK_MPMCStWtWr2",MASK_MPMCStWtWr2,
        "MASK_MPMCStWtTurn2",MASK_MPMCStWtTurn2,
        "MASK_MPMCStConfig3",MASK_MPMCStConfig3,
        "MASK_MPMCStWtWen3",MASK_MPMCStWtWen3,
        "MASK_MPMCStWtOen3",MASK_MPMCStWtOen3,
        "MASK_MPMCStWtRd3",MASK_MPMCStWtRd3,
        "MASK_MPMCStWtPg3",MASK_MPMCStWtPg3,
        "MASK_MPMCStWtWr3",MASK_MPMCStWtWr3,
        "MASK_MPMCStWtTurn3",MASK_MPMCStWtTurn3,
        "MASK_MPMCITCR",MASK_MPMCITCR,
        "MASK_MPMCITIP",MASK_MPMCITIP,
        "MASK_MPMCITOP",MASK_MPMCITOP,
        "PMASK_MPMCControl",PMASK_MPMCControl,
        "PMASK_MPMCStatus",PMASK_MPMCStatus,
        "PMASK_MPMCConfig",PMASK_MPMCConfig,
        "PMASK_MPMCDyCntl",PMASK_MPMCDyCntl,
        "PMASK_MPMCDyRef",PMASK_MPMCDyRef,
        "PMASK_MPMCDyRdCfg",PMASK_MPMCDyRdCfg,
        "PMASK_MPMCDytRP",PMASK_MPMCDytRP,
        "PMASK_MPMCDytRAS",PMASK_MPMCDytRAS,
        "PMASK_MPMCDytSREX",PMASK_MPMCDytSREX,
        "PMASK_MPMCDytAPR",PMASK_MPMCDytAPR,
        "PMASK_MPMCDytDAL",PMASK_MPMCDytDAL,
        "PMASK_MPMCDytWR",PMASK_MPMCDytWR,
        "PMASK_MPMCDytRC",PMASK_MPMCDytRC,
        "PMASK_MPMCDytRFC",PMASK_MPMCDytRFC,
        "PMASK_MPMCDytXSR",PMASK_MPMCDytXSR,
        "PMASK_MPMCDytRRD",PMASK_MPMCDytRRD,
        "PMASK_MPMCDytMRD",PMASK_MPMCDytMRD,
        "PMASK_MPMCStExdWt",PMASK_MPMCStExdWt,
        "PMASK_MPMCDyConfig0",PMASK_MPMCDyConfig0,
        "PMASK_MPMCDyRasCas0",PMASK_MPMCDyRasCas0,
        "PMASK_MPMCDyConfig1",PMASK_MPMCDyConfig1,
        "PMASK_MPMCDyRasCas1",PMASK_MPMCDyRasCas1,
        "PMASK_MPMCDyConfig2",PMASK_MPMCDyConfig2,
        "PMASK_MPMCDyRasCas2",PMASK_MPMCDyRasCas2,
        "PMASK_MPMCDyConfig3",PMASK_MPMCDyConfig3,
        "PMASK_MPMCDyRasCas3",PMASK_MPMCDyRasCas3,
        "PMASK_MPMCStConfig0",PMASK_MPMCStConfig0,
        "PMASK_MPMCStWtWen0",PMASK_MPMCStWtWen0,
        "PMASK_MPMCStWtOen0",PMASK_MPMCStWtOen0,
        "PMASK_MPMCStWtRd0",PMASK_MPMCStWtRd0,
        "PMASK_MPMCStWtPg0",PMASK_MPMCStWtPg0,
        "PMASK_MPMCStWtWr0",PMASK_MPMCStWtWr0,
        "PMASK_MPMCStWtTurn0",PMASK_MPMCStWtTurn0,
        "PMASK_MPMCStConfig1",PMASK_MPMCStConfig1,
        "PMASK_MPMCStWtWen1",PMASK_MPMCStWtWen1,
        "PMASK_MPMCStWtOen1",PMASK_MPMCStWtOen1,
        "PMASK_MPMCStWtRd1",PMASK_MPMCStWtRd1,
        "PMASK_MPMCStWtPg1",PMASK_MPMCStWtPg1,
        "PMASK_MPMCStWtWr1",PMASK_MPMCStWtWr1,
        "PMASK_MPMCStWtTurn1",PMASK_MPMCStWtTurn1,
        "PMASK_MPMCStConfig2",PMASK_MPMCStConfig2,
        "PMASK_MPMCStWtWen2",PMASK_MPMCStWtWen2,
        "PMASK_MPMCStWtOen2",PMASK_MPMCStWtOen2,
        "PMASK_MPMCStWtRd2",PMASK_MPMCStWtRd2,
        "PMASK_MPMCStWtPg2",PMASK_MPMCStWtPg2,
        "PMASK_MPMCStWtWr2",PMASK_MPMCStWtWr2,
        "PMASK_MPMCStWtTurn2",PMASK_MPMCStWtTurn2,
        "PMASK_MPMCStConfig3",PMASK_MPMCStConfig3,
        "PMASK_MPMCStWtWen3",PMASK_MPMCStWtWen3,
        "PMASK_MPMCStWtOen3",PMASK_MPMCStWtOen3,
        "PMASK_MPMCStWtRd3",PMASK_MPMCStWtRd3,
        "PMASK_MPMCStWtPg3",PMASK_MPMCStWtPg3,
        "PMASK_MPMCStWtWr3",PMASK_MPMCStWtWr3,
        "PMASK_MPMCStWtTurn3",PMASK_MPMCStWtTurn3,
        "PMASK_MPMCITCR",PMASK_MPMCITCR,
        "PMASK_MPMCPeriphId4",PMASK_MPMCPeriphId4,
        "PMASK_MPMCPeriphId5",PMASK_MPMCPeriphId5,
        "PMASK_MPMCPeriphId6",PMASK_MPMCPeriphId6,
        "PMASK_MPMCPeriphId7",PMASK_MPMCPeriphId7,
        "PMASK_MPMCPeriphId0",PMASK_MPMCPeriphId0,
        "PMASK_MPMCPeriphId1",PMASK_MPMCPeriphId1,
        "PMASK_MPMCPeriphId2",PMASK_MPMCPeriphId2,
        "PMASK_MPMCPeriphId3",PMASK_MPMCPeriphId3,
        "PMASK_MPMCPCellId0",PMASK_MPMCPCellId0,
        "PMASK_MPMCPCellId1",PMASK_MPMCPCellId1,
        "PMASK_MPMCPCellId2",PMASK_MPMCPCellId2,
        "PMASK_MPMCPCellId3",PMASK_MPMCPCellId3,
        "HMASK_MPMCControl",HMASK_MPMCControl,
        "HMASK_MPMCITCR",HMASK_MPMCITCR,
        "HMASK_MPMCITIP",HMASK_MPMCITIP,
        "HMASK_MPMCITOP",HMASK_MPMCITOP,
        "HMASK_MPMCPeriphId4",HMASK_MPMCPeriphId4,
        "HMASK_MPMCPeriphId5",HMASK_MPMCPeriphId5,
        "HMASK_MPMCPeriphId6",HMASK_MPMCPeriphId6,
        "HMASK_MPMCPeriphId7",HMASK_MPMCPeriphId7,
        "HMASK_MPMCPeriphId0",HMASK_MPMCPeriphId0,
        "HMASK_MPMCPeriphId1",HMASK_MPMCPeriphId1,
        "HMASK_MPMCPeriphId2",HMASK_MPMCPeriphId2,
        "HMASK_MPMCPeriphId3",HMASK_MPMCPeriphId3,
        "HMASK_MPMCPCellId0",HMASK_MPMCPCellId0,
        "HMASK_MPMCPCellId1",HMASK_MPMCPCellId1,
        "HMASK_MPMCPCellId2",HMASK_MPMCPCellId2,
        "HMASK_MPMCPCellId3",HMASK_MPMCPCellId3,
        "LASTREG",0xABCDEF01 
        };  
/******************************************************************************/
struct MPMCPResTab {
               char *regname;
               int  PResVal;
              };
/******************************************************************************/
struct MPMCPResTab MPMCPRes[100]=
      {
        "MPMCControl",PRST_MPMCControl,
        "MPMCStatus",PRST_MPMCStatus,
        "MPMCConfig",PRST_MPMCConfig,
        "MPMCDyCntl",PRST_MPMCDyCntl,
        "MPMCDyRef",PRST_MPMCDyRef,
        "MPMCDyRdCfg",PRST_MPMCDyRdCfg,
        "MPMCDytRP",PRST_MPMCDytRP,
        "MPMCDytRAS",PRST_MPMCDytRAS,
        "MPMCDytSREX",PRST_MPMCDytSREX,
        "MPMCDytAPR",PRST_MPMCDytAPR,
        "MPMCDytDAL",PRST_MPMCDytDAL,
        "MPMCDytWR",PRST_MPMCDytWR,
        "MPMCDytRC",PRST_MPMCDytRC,
        "MPMCDytRFC",PRST_MPMCDytRFC,
        "MPMCDytXSR",PRST_MPMCDytXSR,
        "MPMCDytRRD",PRST_MPMCDytRRD,
        "MPMCDytMRD",PRST_MPMCDytMRD,
        "MPMCStExdWt",PRST_MPMCStExdWt,
        "MPMCDyConfig0",PRST_MPMCDyConfig0,
        "MPMCDyRasCas0",PRST_MPMCDyRasCas0,
        "MPMCDyConfig1",PRST_MPMCDyConfig1,
        "MPMCDyRasCas1",PRST_MPMCDyRasCas1,
        "MPMCDyConfig2",PRST_MPMCDyConfig2,
        "MPMCDyRasCas2",PRST_MPMCDyRasCas2,
        "MPMCDyConfig3",PRST_MPMCDyConfig3,
        "MPMCDyRasCas3",PRST_MPMCDyRasCas3,
        "MPMCStConfig0",PRST_MPMCStConfig0,
        "MPMCStWtWen0",PRST_MPMCStWtWen0,
        "MPMCStWtOen0",PRST_MPMCStWtOen0,
        "MPMCStWtRd0",PRST_MPMCStWtRd0,
        "MPMCStWtPg0",PRST_MPMCStWtPg0,
        "MPMCStWtWr0",PRST_MPMCStWtWr0,
        "MPMCStWtTurn0",PRST_MPMCStWtTurn0,
        "MPMCStConfig1",PRST_MPMCStConfig1,
        "MPMCStWtWen1",PRST_MPMCStWtWen1,
        "MPMCStWtOen1",PRST_MPMCStWtOen1,
        "MPMCStWtRd1",PRST_MPMCStWtRd1,
        "MPMCStWtPg1",PRST_MPMCStWtPg1,
        "MPMCStWtWr1",PRST_MPMCStWtWr1,
        "MPMCStWtTurn1",PRST_MPMCStWtTurn1,
        "MPMCStConfig2",PRST_MPMCStConfig2,
        "MPMCStWtWen2",PRST_MPMCStWtWen2,
        "MPMCStWtOen2",PRST_MPMCStWtOen2,
        "MPMCStWtRd2",PRST_MPMCStWtRd2,
        "MPMCStWtPg2",PRST_MPMCStWtPg2,
        "MPMCStWtWr2",PRST_MPMCStWtWr2,
        "MPMCStWtTurn2",PRST_MPMCStWtTurn2,
        "MPMCStConfig3",PRST_MPMCStConfig3,
        "MPMCStWtWen3",PRST_MPMCStWtWen3,
        "MPMCStWtOen3",PRST_MPMCStWtOen3,
        "MPMCStWtRd3",PRST_MPMCStWtRd3,
        "MPMCStWtPg3",PRST_MPMCStWtPg3,
        "MPMCStWtWr3",PRST_MPMCStWtWr3,
        "MPMCStWtTurn3",PRST_MPMCStWtTurn3,
        "MPMCITCR",PRST_MPMCITCR,
        "MPMCPeriphId4",PRST_MPMCPeriphId4,
        "MPMCPeriphId5",PRST_MPMCPeriphId5,
        "MPMCPeriphId6",PRST_MPMCPeriphId6,
        "MPMCPeriphId7",PRST_MPMCPeriphId7,
        "MPMCPeriphId0",PRST_MPMCPeriphId0,
        "MPMCPeriphId1",PRST_MPMCPeriphId1,
        "MPMCPeriphId2",PRST_MPMCPeriphId2,
        "MPMCPeriphId3",PRST_MPMCPeriphId3,
        "MPMCPCellId0",PRST_MPMCPCellId0,
        "MPMCPCellId1",PRST_MPMCPCellId1,
        "MPMCPCellId2",PRST_MPMCPCellId2,
        "MPMCPCellId3",PRST_MPMCPCellId3,
        "LASTREG",0xABCDEF01
      };
/******************************************************************************/
char *PRegNameArr[100] =
      {
        "MPMCControl","MPMCStatus",
        "MPMCConfig","MPMCDyCntl",
        "MPMCDyRef","MPMCDyRdCfg",
        "MPMCDytRP","MPMCDytRAS",
        "MPMCDytSREX","MPMCDytAPR",
        "MPMCDytDAL",
        "MPMCDytWR","MPMCDytRC",
        "MPMCDytRFC","MPMCDytXSR",
        "MPMCDytRRD","MPMCDytMRD",
        "MPMCStExdWt","MPMCDyConfig0", 
        "MPMCDyRasCas0","MPMCDyConfig1",
        "MPMCDyRasCas1","MPMCDyConfig2",
        "MPMCDyRasCas2","MPMCDyConfig3",
        "MPMCDyRasCas3", "MPMCStConfig0",
        "MPMCStWtWen0", "MPMCStWtOen0",
        "MPMCStWtRd0","MPMCStWtPg0",
        "MPMCStWtWr0","MPMCStWtTurn0",
        "MPMCStConfig1","MPMCStWtWen1",
        "MPMCStWtOen1","MPMCStWtRd1",
        "MPMCStWtPg1","MPMCStWtWr1",
        "MPMCStWtTurn1","MPMCStConfig2",
        "MPMCStWtWen2","MPMCStWtOen2",
        "MPMCStWtRd2","MPMCStWtPg2",
        "MPMCStWtWr2","MPMCStWtTurn2",
        "MPMCStConfig3","MPMCStWtWen3",
        "MPMCStWtOen3","MPMCStWtRd3",
        "MPMCStWtPg3","MPMCStWtWr3",
        "MPMCStWtTurn3","MPMCITCR",
        "MPMCPeriphId4","MPMCPeriphId5",
        "MPMCPeriphId6","MPMCPeriphId7",
        "MPMCPeriphId0","MPMCPeriphId1",
        "MPMCPeriphId2","MPMCPeriphId3",
        "MPMCPCellId0","MPMCPCellId1",
        "MPMCPCellId2","MPMCPCellId3",
        "LASTREG"
       }; 
/*****************************************************************************/
char *HMpmcRegisters[19] =
       {
         "MPMCControl",
         "MPMCITCR",
         "MPMCITIP",
         "MPMCITOP",
         "MPMCPeriphId4",
         "MPMCPeriphId5",
         "MPMCPeriphId6",
         "MPMCPeriphId7",
         "MPMCPeriphId0",
         "MPMCPeriphId1",
         "MPMCPeriphId2",
         "MPMCPeriphId3",
         "MPMCPCellId0",
         "MPMCPCellId1",
         "MPMCPCellId2",
         "MPMCPCellId3",
         "LASTREG"
       };
/******************************************************************************/
/* It defines a structure which has reset values of read only registers only  */

struct MPMCRORegRes
                  {
                   char *regname;
                   int  Reset;
                  };
/******************************************************************************/
struct MPMCRORegRes RORegRes[14] = 
       {
         "MPMCStatus",0x00000006,
         "MPMCPeriphId4",0x00000001,
         "MPMCPeriphId5",0x00000000,
         "MPMCPeriphId6",0x00000000,
         "MPMCPeriphId7",0x00000000,
         "MPMCPeriphId0",0x00000072,
         "MPMCPeriphId1",0x00000011,
         "MPMCPeriphId2",0x00000004,
         "MPMCPeriphId3",0x000000C2,
         "MPMCCellId0",0x0000000D,
         "MPMCCellId1",0x000000F0,
         "MPMCCellId2",0x00000005,
         "MPMCCellId3",0x000000B1,
         "LASTREG",0x12345678
       };
/****************************************************************************/

/* Read/Write registers' names */
char *MpmcRegisters[100] =
       {
         "MPMCControl","MPMCStatus",
         "MPMCConfig","MPMCDyCntl",
         "MPMCDyRef","MPMCDyRdCfg",
         "MPMCDytRP","MPMCDytRAS",
         "MPMCDytSREX","MPMCDytAPR",
         "MPMCDytDAL","MPMCDytWR",
         "MPMCDytRC","MPMCDytRFC",
         "MPMCDytXSR","MPMCDytRRD",
         "MPMCDytMRD","MPMCStExdWt",
         "MPMCDyConfig0","MPMCDyRasCas0",
         "MPMCDyConfig1","MPMCDyRasCas1",
         "MPMCDyConfig2","MPMCDyRasCas2",
         "MPMCDyConfig3","MPMCDyRasCas3",
         "MPMCStConfig0","MPMCStWtWen0",
         "MPMCStWtOen0","MPMCStWtRd0",
         "MPMCStWtPg0","MPMCStWtWr0",
         "MPMCStWtTurn0","MPMCStConfig1",
         "MPMCStWtWen1","MPMCStWtOen1",
         "MPMCStWtRd1","MPMCStWtPg1",
         "MPMCStWtWr1","MPMCStWtTurn1",
         "MPMCStConfig2","MPMCStWtWen2",
         "MPMCStWtOen2","MPMCStWtRd2",
         "MPMCStWtPg2","MPMCStWtWr2",
         "MPMCStWtTurn2","MPMCStConfig3",
         "MPMCStWtWen3","MPMCStWtOen3",
         "MPMCStWtRd3","MPMCStWtPg3",
         "MPMCStWtWr3","MPMCStWtTurn3",
         "MPMCITCR","MPMCITIP",
         "MPMCITOP","MPMCPeriphId4",
         "MPMCPeriphId5","MPMCPeriphId6",
         "MPMCPeriphId7","MPMCPeriphId0",
         "MPMCPeriphId1","MPMCPeriphId2",
         "MPMCPeriphId3","MPMCPCellId0",
         "MPMCPCellId1","MPMCPCellId2",
         "MPMCPCellId3","LASTREG"
       };
/****************************************************************************/

/* Array of read only registers */
char *ReadOnlyRegisters[19] =
       {
         "MPMCStatus",
         "MPMCPeriphId4","MPMCPeriphId5",
         "MPMCPeriphId6","MPMCPeriphId7",
         "MPMCPeriphId0","MPMCPeriphId1",  
         "MPMCPeriphId2","MPMCPeriphId3",
         "MPMCPCellId0","MPMCPCellId1",
         "MPMCPCellId2","MPMCPCellId3",
         "LASTREG"
       }; 
/******************************************************************************/

/* Array of Write Only register */
char *WriteOnlyRegisters[2] =
       {
         "LASTREG"
       };
/******************************************************************************/
/******************************** IsMpmcReg ***********************************/
/******************************************************************************/
int IsMpmcReg(const int32 Address)
{
  /* 
     Summary:
     ========
     o Given a register address, this will find out whether it is a valid
       Mpmc register address.
  */ 
  char **RegisterList;
  RegisterList = MpmcRegisters;

  sprintf(debugstr,"Fn IsMpmcReg : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsMpmcReg : It is a Mpmc Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsMpmcReg : It is NOT a Mpmc Register");
    debug_info(debugstr);

    return 0;
  }
} 
/******************************************************************************/
/**************************** HRESET MPMC Registers ***************************/
/******************************************************************************/
int IsHMpmcReg(const int32 Address)
{
 /*
     Summary:
     ========
     o Given a register address, this will find out whether it is a valid
       Mpmc register address which has Hreset value.
 */
  char **RegisterList;
  RegisterList = HMpmcRegisters;

  sprintf(debugstr,"Fn IsMpmcReg : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsMpmcReg:It is a valid Register having HReset value");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsMpmcReg : It doesn't have HReset value");
    debug_info(debugstr);

    return 0;
  }
}

/******************************************************************************/
/********************************** Read Only Register ************************/
/******************************************************************************/
int IsReadOnly(const int32 Address)
{
  /*
     Summary:
     ========
     o Given a register address, this function will return 1, if it is a
       read-only register of Mpmc. Otherwise it returns 0.
  */
  char **RegisterList;
  RegisterList = ReadOnlyRegisters;

  sprintf(debugstr,"Fn IsReadOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsReadOnly : It is a Read Only Register");
    debug_info(debugstr);
    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsReadOnly : It is NOT a Read Only Register");
    debug_info(debugstr);
    return 0;
  }
}

/******************************************************************************/
/********************************** Write Only Register ***********************/
/******************************************************************************/
int IsWriteOnly(const int32 Address)
{
  /*
     Summary:
     ========
     o Given a register address, this function will return 1, if it is a
       write-only register of Mpmc. Otherwise it returns 0.
  */
  char **RegisterList;
  RegisterList = WriteOnlyRegisters;

  sprintf(debugstr,"Fn IsWriteOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsWriteOnly : It is a Write Only Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsWriteOnly : It is NOT a Write Only Register");
    debug_info(debugstr);

    return 0;
  }
}

/******************************************************************************/
/********************************** Register Name *****************************/
/******************************************************************************/
char *RegisterName(int32 Address)
{
  /*
     Summary:
     ========
     o Given a Mpmc register address, this will return the name of the register.
  */
  char **RegisterList;
  RegisterList = MpmcRegisters;

  sprintf(debugstr,"Fn RegisterName : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn RegisterName : Register Name is %s",*RegisterList);
    debug_info(debugstr);

    return *RegisterList;
  }
  else
  {
    sprintf(debugstr,"Fn RegisterName : Register Name is RESERVED");
    debug_info(debugstr);

    return ("RESERVED");
  }
}
/******************************************************************************/
/***************************** String-Constant Conversion *********************/
/******************************************************************************/
int32 strconst (char *constname)
{
  /*
     Summary:
     ========
     o  Any constant name that is defined in MpmcConstants variable
        can be passed on to this function and it returns the value of
        the constant.
  */

  char *prnstr;
  struct ConstantList *StrConstPtr;

  StrConstPtr = MpmcConstants;

  sprintf(debugstr,"Fn strconst : Constant Name is %s",constname);
  debug_info(debugstr);

  sprintf(debugstr,"Fn strconst : Comparing against %s",
            StrConstPtr->ConstantName);
  debug_info(debugstr);

  while (strcmp(constname,StrConstPtr->ConstantName) != 0)
  {
    StrConstPtr++;

    sprintf(debugstr,"Fn strconst : Comparing against %s",
              StrConstPtr->ConstantName);
    debug_info(debugstr);

    if (StrConstPtr->ConstantName == "LASTREG")
    {
      sprintf(debugstr,"Error : Constant %s Not found.\n",constname);
      debug_info(debugstr);

      return 0;
    }
  }
  sprintf(debugstr,"Fn strconst : Constant Value is %X",
            StrConstPtr->ConstantValue);
  debug_info(debugstr);

  return StrConstPtr->ConstantValue;
}
/******************************************************************************/
/********************************* String Concatenation ***********************/
/******************************************************************************/
char *stringcat(char *string1, char *string2)
{
  /*
     Summary:
     ========
     o This will combine the given two strings, first string followed by the
       second one.
  */
  int i;
  int j=0;

  for (i = 0; i < strlen(string1); i++)
  {
    retstr[j] = string1[i];
    j++;
  }

  for (i = 0; i < strlen(string2); i++)
  {
    retstr[j] = string2[i];
    j++;
  }

  retstr[j] = '\0';
  return (retstr);
}
/******************************************************************************/
/************************************* Read access ****************************/
/******************************************************************************/
void Read(int32 address, int32 data, int32 mask)
/* 
     Summary:
     ========
     o AHB read access will be initiated. It is used for all register
       reads during Mpmc testing.
*/ 
{
  int wait;
  int32 data1;
  if((address == (MPMC_BASE + 0x00000004)) || (address == MPMC_BASE) ||
     (address == (MPMC_BASE + 0x00000020)))
    {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , ); 
    }
   else if(address == (MPMC_BASE + 0x00000F00))
   { 
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , 0x00000001, , mask, , );
      HSA(address, IDLE, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , 0x00000001, , mask, , );
   }
   else 
   {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , );
      HSA(address, IDLE, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , );
    }
}
/******************************************************************************/
/*********************************** ReadRes **********************************/
/******************************************************************************/
 void ReadRes(int32 address, int32 data, int32 mask)
 {
 /* 
     Summary:
     ========
     o AHB read access will be initiated. It is used for all register
       reads during Mpmc testing.
 */ 
  int wait;
  int32 data1;
  if((address == (MPMC_BASE + 0x00000004)) || (address == MPMC_BASE) ||
     (address == (MPMC_BASE + 0x00000020)))
    {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , ); 
    }
   else 
   {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , );
      HSA(address, IDLE, SINGLE, OK, WRD, 0x0, 0x0);
      HSR( , data, , mask, , );
    }
}
/******************************************************************************/
/************************ Write access - Error response ***********************/
/******************************************************************************/
void WriteErr(int32 address, int32 data, char size)
{
 /* 
     Summary:
     ========
     o AHB write access will be initiated, with the given data-size.
 */ 
  HSA(address, NSEQ, SINGLE, ERROR, size, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}

/******************************************************************************/
/************************************* Read access ****************************/
/******************************************************************************/
void ReadErr (int32 address, int32 data, int32 mask, char size)
  /*
     Summary:
     ========
     o AHB read access will be initiated with the given data-size.
  */
{
  HSA(address, NSEQ, SINGLE, ERROR, size, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}

/******************************************************************************/
/********************************* Next register name *************************/
/******************************************************************************/
char *NextRegisterName (char *currentregname)
{
 /* 
     Summary:
     ========
     o  Given a register name of the Mpmc controller, as defined in Mpmc.h file,
        this function will return the next register's name.
 */ 
  char **prnstr;
  prnstr = MpmcRegisters;
  sprintf(debugstr,"Fn NextRegisterName : Current Register Name is %s",
            currentregname);
  debug_info(debugstr);

  while ((strcmp(*prnstr,currentregname) != 0) &&
         (*prnstr != "LASTREG"))
  {
    prnstr++;
  }

  prnstr++;

  sprintf(debugstr,"Fn NextRegisterName : Next Register Name is %s",*prnstr);
  debug_info(debugstr);

  return *prnstr;
}

/******************************************************************************/
/******************************** Next Pregister name *************************/
/******************************************************************************/
char *NextPRegisterName (char *currentregname)
{
 /*
     Summary:
     ========
     o  Given a register name of the Mpmc controller, as defined in Mpmc.h file,
        this function will return the next register's name.
 */
  char **prnstr;
  prnstr = PRegNameArr;
  sprintf(debugstr,"Fn NextRegisterName : Current Register Name is %s",
            currentregname);
  debug_info(debugstr);

  while ((strcmp(*prnstr,currentregname) != 0) &&
         (*prnstr != "LASTREG"))
  {
    prnstr++;
  }

  prnstr++;

  sprintf(debugstr,"Fn NextRegisterName : Next Register Name is %s",*prnstr);
  debug_info(debugstr);

  return *prnstr;
}

/******************************************************************************/
/********************************* Next register name *************************/
/******************************************************************************/
char *NextHRegisterName (const char *currentregname)
{
  /*
     Summary:
     ========
     o  Given a register name of the Mpmc controller, as defined in Mpmc.h file,
        this function will return the next register's name.
  */
  char **prnstr;
  prnstr = HMpmcRegisters;
  sprintf(debugstr,"Fn NextHRegisterName : Current Register Name is %s",
            currentregname);
  debug_info(debugstr);

  while ((strcmp(*prnstr,currentregname) != 0) &&
         (*prnstr != "LASTREG"))
  {
    prnstr++;
  }

  prnstr++;

  sprintf(debugstr,"Fn NextHRegisterName : Next Register Name is %s",*prnstr);
  debug_info(debugstr);

  return *prnstr;
}
/******************************************************************************/
/******************************* Write Group of Registers *********************/
/******************************************************************************/
void RegWrite(int32 data, int groupsize)
{
  /*
     Summary:
     ========
     o This function will write the given data into a group of Mpmc registers.
       For example, if the "groupsize" is 2, then the given data will be
       written into registers 1-2, 5-6, 9-10 and so on. Please note that the
       sequence consists of valid Mpmc registers only (Two successive Mpmc
       registers need not be separated by a word address). Similarly if the
       "groupsize" is 4, then the given data will be written into registers
       1-4, 9-12, 17-20 and so on. Other registers will be written with
       1's compliment of the "data". Use the function RegRead() to read back
       all the "data" written into the Mpmc registers.
  */
  int i, j, k;
  int32 RegisterAddr;
  int32 WriteData;
  int32 WriteData1;
  char *RegName = "MPMCControl";

  k = 0;
  while (RegName != "LASTREG")
  {
    if (!(k%groupsize))
    {
      data = ~data;
    }
    RegisterAddr = strconst(RegName);

    sprintf(debugstr,"Register Name is %s",RegName);
    debug_info(debugstr);

    /* As this function is used during register tests, Mpmc and all channel
       enable bits are reset.                                              */
      WriteData = data;
    if(RegisterAddr == (MPMC_BASE + 0x00000F00))
    {
       HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
       HSW(,0x00000001);
    }
    else if(RegisterAddr == (MPMC_BASE + 0x00000000))
    {
      WriteData1 = WriteData & 0xFFFFFFFE;
      HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
      HSW( , WriteData1);
    }
    else if(RegisterAddr == (MPMC_BASE + 0x00000F20))
    {
      WriteData1 = WriteData & 0xFFFFFFFE;
      HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
      HSW( , WriteData1);
    }
    else 
    {
    HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSW( , WriteData);
    }
    k++;
    RegName = NextRegisterName(RegName);
  }
}
/******************************************************************************/
/******************************** WriteAllReg *********************************/
/******************************************************************************/
WriteAllReg(int32 Data)
{
  /*
     Summary:
     ========
     It writes to all registers with "Data".
  */
  int i;
  char *RegName ="MPMCControl";
  int32 RegAddr;
  int32 DataCntl;
  int32 Data1;
  while (RegName != "LASTREG")
  {
    RegAddr = strconst(RegName);
      if(RegName == "MPMCControl")
      {
        DataCntl = Data & 0xFFFFFFFE;
        HSA(RegAddr,NSEQ,INCR,OK,WRD);
        HSW(, DataCntl);
      }
      else if((RegName == "MPMCStatus") || (RegName == "MPMCDyCntl"))
      {
        HSA(RegAddr,NSEQ,INCR,OK,WRD);
        HSW(, Data);
      }
      else if(RegName == "MPMCITCR")
      {
        Data1 = Data | 0x00000001;

        HSA(RegAddr,NSEQ,INCR,OK,WRD);
        HSW(, Data1);  
        HSA(RegAddr,IDLE,INCR,OK,WRD);
        HSW(, Data1);
      } 
      else if(RegName == "MPMCITIP")
      {
        Data1 = Data & 0x000003FE;

        HSA(RegAddr,NSEQ,INCR,OK,WRD);
        HSW(, Data1);
        HSA(RegAddr,IDLE,INCR,OK,WRD);
        HSW(, Data1);
      }  
      else
      {
        HSA(RegAddr,NSEQ,INCR,OK,WRD);
        HSW(, Data);
        HSA(RegAddr,IDLE,INCR,OK,WRD);
        HSW(, Data);
      }
      RegName = NextRegisterName(RegName);
  }
}
/******************************************************************************/
/******************************* Read Group of Registers **********************/
/******************************************************************************/
void RegRead(int32 data, int groupsize)
{
  /*
     Summary:
     ========
     o This function will read the given data from a group of Mpmc registers.
       For example, if the "groupsize" is 2, then the given data will be
       read from registers 1-2, 5-6, 9-10 and so on. Please note that the
       sequence consists of valid Mpmc registers only (Two successive Mpmc
       registers need not be separated by a word address). Similarly if the
       "groupsize" is 4, then the given data will be read from registers
       1-4, 9-12, 17-20 and so on. 1's compliment of the data will be
       read from other registers.
       Please note that this function should be called only if the registers
       are written using "RegWrite" function.
  */
  int i, j, k;
  int32 RegisterAddr;
  int32 ExpData;
  char *RegName = "MPMCControl";

  k = 0;
  while (RegName != "LASTREG")
  {
    if (!(k%groupsize))
    {
      data = ~data;
    }
    RegisterAddr = strconst(RegName);

    /* If the register is a read-only register, then its value should not be
       affected by a write access to that register.
    */
    if (IsReadOnly(RegisterAddr) == 1)
    {
      ExpData = strconst(stringcat("RDO_",RegName));
    }
    else if (IsWriteOnly(RegisterAddr) == 1)
    {
      ExpData = 0x00000000;
    }
    else
    {
      ExpData = strconst(stringcat("MASK_",RegName)) & (data);
    }
    if(RegisterAddr == (MPMC_BASE + 0x00000F00))
    {
      HSA(RegisterAddr, NSEQ, INCR, OK, WRD);
      HSR(,0x00000001, ,0x00000001);
     } 
     else
   {
    HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSR( , ExpData, , MaskALL, ,MPMC_REG_RW);
   }
    k++;
    RegName = NextRegisterName(RegName);
  }
}
/******************************************************************************/
/******************************* Idle Write access ****************************/
/******************************************************************************/
void IdleWrite(int32 address, int32 data, char size)
{
  /*
     Summary:
     ========
     o Idle cycles will be intiated on the AHB bus, with the given data-size.
  */
  HSA(address, IDLE, WRAP4, OK, size, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}

/******************************************************************************/
/************************************ Write access ****************************/
/******************************************************************************/
void Write(int32 address, int32 data)
{
  /*
     Summary:
     ========
     o AHB write access will be initiated. It is used for all register
       writes while programming the Mpmc.
  */
   int wait;
   
  if((address == (MPMC_BASE + 0x00000004)) || (address == MPMC_BASE) ||
     (address == (MPMC_BASE + 0x00000020)))
    {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSW( , data);
    }
    else if(address == (MPMC_BASE + 0x00000F00))
    {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSW(,0x00000001);
    }
    else
    {
      HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0);
      HSW( , data);
      HSA(address, IDLE, SINGLE, OK, WRD, 0x0, 0x0);
      HSW( , data);
    }

}

/******************************************************************************/
/******************************** GetPres *************************************/
/******************************************************************************/
GetPres(char* RegName)
{
  /*
    Summary:
    ========
    This function returns POReset values.
  */
 struct MPMCPResTab *Ptr;
Ptr = MPMCPRes;
 while(Ptr->regname !="LASTREG")
  {
   if(Ptr-> regname == RegName)
     {
       return(Ptr-> PResVal);
       break;
     }
   Ptr++;
  }
}

/******************************************************************************/
/******************************** NextPRegName ********************************/
/******************************************************************************/
NextPRegName(char *RegName)
{
   /*
     Summary:
     ========
     This function returns next register name in the list PRegNameArr.
   */
   int i,j;
                           
   for(i=0;i<71;i++)      
   {
     if(strcmp(RegName, PRegNameArr[i]) == 0)
     {
       j = i + 1;
       return(*PRegNameArr[j]);
       break;
     }
   }
   return 0;
} 
/******************************************************************************/
/****************************** MPMCDisable ***********************************/
/******************************************************************************/
void MPMCDisable()
{
  /*
    Summary: 
    ========
    This function disables MPMController by writing 0 to enable bit
  */
  HSA(MPMCControl,NSEQ, INCR, OK, WRD);
  HSW(,0x00000001);
  WaitLoop(0x2);
  /* Poll Busy bit of MPMCStatus */
  debug_info("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  /* WaitLoop(0x2); */
  /* Write zero to enable bit of MPMCControl register to disable the 
  controller */
  C("Disable Mpmc");
  HSA(MPMCControl, NSEQ, INCR, OK, WRD, , , , , , ,);
  HSW(,0x00000000);
  WaitLoop(0x2);
}

/******************************************************************************/
/******************************* MPMCEnable ***********************************/
/******************************************************************************/
void MPMCEnable()
{
 /*
    Summary: 
    ========
    This function enables MPMController by writing 1 to enable bit
  */
  C("Enable MPMC");
  HSA(MPMCControl, NSEQ, INCR, OK, WRD, , , , , , ,);
  HSW(,0x00000001);
  WaitLoop(0x2);
}

/****************************************************************************/
/**************************** Data Array Generation *************************/
/****************************************************************************/
datagen(unsigned position,unsigned size,unsigned *bytedata)
{
/*

 Summary : datagen
 =================
 This function generates bytewide random data. The inputs are the
 starting address, number of data and the array to store the data.

*/

 unsigned i;
 char message[100];

 for(i=position;i<(position+size);i++)
 {
   bytedata[i] = (rand() % 256);
 }
}

/******************************************************************************/
/**************************** GetROResVal *************************************/
/******************************************************************************/
 GetROResVal(char *RegName)
{
  /*
    Summary:
    ========
    This function returns reset values for read only registers.
  */
 struct MPMCRORegRes *Ptr;
 Ptr = RORegRes;
 while(Ptr->regname !="LASTREG")
  {
   if(Ptr-> regname == RegName)
     {
       return(Ptr-> Reset);
       break;
     }
   Ptr++;
  }
} 
/******************************************************************************/
/***************************** CSPOReset **************************************/
/******************************************************************************/
void CSPOReset(void)
{
   /* 
     This funciton asserts POR pin and deasserts it by programming POR bit of 
     MPMCTrCR register. 
   */

   /* Assert POR and switch off protocol check to aviod spurious messages */
   HSA(MPMCTrCR, NSEQ,INCR,OK, WRD); 
   HSW(,0x00000012);
   /* Wait for finite time to keep POR low */
   WaitLoop(0x2);
 
   /* Deassert POR */
 
   HSA(MPMCTrCR, NSEQ,INCR,OK, WRD); 
   HSW(,0x00000000);
}
/******************************************************************************/
/****************************** POReset ***************************************/
/******************************************************************************/
void POReset(void)
{
  /*
    This funciton asserts POR pin and deasserts it by programming POR bit of
    MPMCTrCR register.
  */

  /* Assert POR */
  HSA(MPMCTrCR, NSEQ,INCR,OK, WRD);
  HSW(,0x00000002);
  /* Wait for finite time to keep POR low */

  WaitLoop(0x2);
  
  /* Deassert POR */
 
  HSA(MPMCTrCR, NSEQ,INCR,OK, WRD);
  HSW(,0x00000000);
}

/******************************************************************************/
/**************************** REGPOReset **************************************/
/******************************************************************************/
void REGPOReset(void)
{
  /*
    This funciton asserts POR pin and deasserts it by programming POR bit of
    MPMCTrCR register and it also switches off the protocol checker flag to 
    suppres the messages during POReset.
  */

  /* Assert POR */
  HSA(MPMCTrCR, NSEQ,INCR,OK, WRD);
  HSW(,0x00000012);
  /* Wait for finite time to keep POR low */

  WaitLoop(0x2);

  /* Deassert POR */

  HSA(MPMCTrCR, NSEQ,INCR,OK, WRD);
  HSW(,0x00000010);
}

/******************************************************************************/
int32 Random()
{
  /*
     Summary:
     ========
     o Creates a random number of 32 bits wide.
  */
  int32 RandomValue;
  RandomValue = (rand() % 256)*16777216 +
                (rand() % 256)*65536    +
                (rand() % 256)*256      +
                (rand() % 256);
  return RandomValue;
}

/******************************************************************************/
/******************************* TimingInit ***********************************/
/******************************************************************************/
void TimingInit(int tRP, int tRAS, int tSREX, int tAPR, int tDAL, 
           int tWR, int tRDL, int tRC, int tRFC, int tXSR, int tRRD, int tMRD)
{
  /*
     Summary: TimingInit
     ====================
     This function initializes the following registers with the predefined
     values.
     The registers are:
                       MPMCDytRP
                       MPMCDytRAS
                       MPMCDytSREX
                       MPMCDytAPR
                       MPMCDytDAL
                       MPMCDytWR
                       MPMCDytRC
                       MPMCDytRFC
                       MPMCDytXSR
                       MPMCDytRRD
                       MPMCDytMRD
  */
    HSA(MPMCDytRP, NSEQ, INCR, OK, WRD);
    HSW(,tRP);

    HSA(MPMCDytRAS, NSEQ, INCR, OK, WRD);
    HSW(,tRAS);

    HSA(MPMCDytSREX, NSEQ, INCR, OK, WRD);
    HSW(,tSREX);

    HSA(MPMCDytAPR, NSEQ, INCR, OK, WRD);
    HSW(,tAPR);

    HSA(MPMCDytDAL, NSEQ, INCR, OK, WRD);
    HSW(,tDAL);


    HSA(MPMCDytWR, NSEQ, INCR, OK, WRD);
    HSW(,tWR);


    HSA(MPMCDytRC, NSEQ, INCR, OK, WRD);
    HSW(,tRC);

    HSA(MPMCDytRFC, NSEQ, INCR, OK, WRD);
    HSW(,tRFC);

    HSA(MPMCDytXSR, NSEQ, INCR, OK, WRD);
    HSW(,tXSR);

    HSA(MPMCDytRRD, NSEQ, INCR, OK, WRD);
    HSW(,tRRD);

    HSA(MPMCDytMRD, NSEQ, INCR, OK, WRD);
    HSW(,tMRD);
}

/******************************************************************************/
/**************************** SyncInitializeProc ******************************/
/******************************************************************************/
SyncInitializeProc(
int burlen0,int burtype0,int caslat0,int raslat0,int opmode0,int wrburmode0,
int burlen1,int burtype1,int caslat1,int raslat1,int opmode1,int wrburmode1,
int burlen2,int burtype2,int caslat2,int raslat2,int opmode2,int wrburmode2,
int burlen3,int burtype3,int caslat3,int raslat3,int opmode3,int wrburmode3,
int md0,int mpw0,int ps0,int rbc0,int mw0,int rb0,int wb0, int wp0,int cw0,
int nb0, int rw0,
int md1,int mpw1,int ps1,int rbc1,int mw1,int rb1,int wb1, int wp1,int cw1,
int nb1, int rw1,
int md2,int mpw2,int ps2,int rbc2,int mw2,int rb2,int wb2, int wp2,int cw2, 
int nb2, int rw2,
int md3,int mpw3,int ps3,int rbc3,int mw3,int rb3,int wb3,int wp3,int cw3,
int nb3, int rw3,int rowpos0,int rowpos1,int rowpos2,int rowpos3,
int endian, int ClkRatio)
{
  /*
     Summary: SyncInitializeProc()
     ============================
     This function performs the following functionality
     o It checks for the buffer status and MPMC busy bits. When MPMC is idle
       and write buffer is empty it starts doing reinitialization process

    o  Initializes the sync memory
  */
  unsigned long Addr4,Addr5,Addr6,Addr7;
  int32 TempConfig;
  unsigned long Address4,Address5,Address6,Address7;
  int RasCas0,RasCas1,RasCas2,RasCas3;
  int Config,i;
  int32 SyCon0,SyCon1,SyCon2,SyCon3;
  char debugstr[100];
  int AM0,AM1,AM2,AM3;

  C("Program Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  WaitLoop(0x4);
  C("Apply Reset");
  RES(LOW, , ,);

  C("Reprogram Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  /* Enable InitChkRtn */
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000003);
  /* Program the MPMCDyConfig[0 - 3] and MPMCDyRasCas[0-3] with relevent
     values .RAS and CAS delays must be constitent with the values written
     to the mode register.                                                  */
  SyCon0 = md0 << 3 | mpw0 << 7 | ps0 << 9 | rbc0 << 12 | mw0 << 14 |
              rb0 << 18 | wb0 << 19 | wp0 << 20 | cw0 << 22 | nb0 << 26 |
              rw0 << 28;
  SyCon1 = md1 << 3 | mpw1 << 7 | ps1 << 9 | rbc1 << 12 | mw1 << 14 |
              rb1 << 18 | wb1 << 19 | wp1 << 20 | cw1 << 22 | nb1 << 26 |
              rw1 << 28;
  SyCon2 = md2 << 3 | mpw2 << 7 | ps2 << 9 | rbc2 << 12 | mw2 << 14 |
              rb2 << 18 | wb2 << 19 | wp2 << 20 | cw2 << 22 | nb2 << 26 |
              rw2 << 28;
  SyCon3 = md3 << 3 | mpw3 << 7 | ps3 << 9 | rbc3 << 12 | mw3 << 14 |
              rb3 << 18 | wb3 << 19 | wp3 << 20 | cw3 << 22 | nb3 << 26 |
              rw3 << 28;

  /* Program Expected no of refresh cycles for protocol */
  HSA(MPMCTrExpRef,NSEQ, INCR, OK, WRD);
  HSW(,0x8);

  RasCas0 =  caslat0 << 8 | raslat0;
  HSA(MPMCDyRasCas0,NSEQ,INCR,OK,WRD);
  HSW(,RasCas0);

  RasCas1 =  caslat1 << 8 | raslat1;
  HSA(MPMCDyRasCas1,NSEQ,INCR,OK,WRD);
  HSW(,RasCas1);

  RasCas2 =  caslat2 << 8 | raslat2;
  HSA(MPMCDyRasCas2,NSEQ,INCR,OK,WRD);
  HSW(,RasCas2);

  RasCas3 =  caslat3 << 8 | raslat3;
  HSA(MPMCDyRasCas3,NSEQ,INCR,OK,WRD);
  HSW(,RasCas3);

  /* Program MPMCDyConfig register */
  TempConfig = SyCon0 & 0xFFF3FFFF;
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon1 & 0xFFF3FFFF;
  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon2 & 0xFFF3FFFF;
  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon3 & 0xFFF3FFFF;
  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  /* Wait for 200us by performing dummy read operation which consumes two */
  /* clock cycles for each operation */
  C("Wait for 200us");
  WaitLoop(50);

  /* Apply NOP */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000183);
  WaitLoop(1);
  /* Issue Precharge by writing 10 to I field of MPMCDyCntl */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000103);

  /* write a small value to refresh register */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x00000002);

  /* Wait till 8 refresh has applied to memory */
  WaitLoop(0x100);
  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x0000001A);

  debug_info("Set I to MODE");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000083);

  /* Configure the mode register for its burst length, burst type, 
     CAS latency,*/
  /* operating mode, write burst mode by performing a read operation */
  Addr4 = wrburmode0 << 9 | opmode0 << 7 | caslat0 << 4 |
          burtype0 << 3 | burlen0;

  Addr5 = wrburmode1<< 9 | opmode1<< 7 | caslat1<< 4 |
          burtype1 << 3 | burlen1;

  Addr6 = wrburmode2 << 9 | opmode2 << 7 | caslat2 << 4 |
          burtype2 << 3 | burlen2;

  Addr7 = wrburmode3 << 9 | opmode3 << 7 | caslat3 << 4 |
          burtype3 << 3 | burlen3;

  Address4 = Addr4 << rowpos0;
  Address5 = Addr5 << rowpos1;
  Address6 = Addr6 << rowpos2;
  Address7 = Addr7 << rowpos3;
  /* Program the mode registers with the valid data */
  debug_info("Program mode registers");
  HSA(Address4 | 0x40000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address5 | 0x50000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address6 | 0x60000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address7 | 0x70000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  debug_info("Program I to normal Mode");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000003);
  /* Reprogram Configuration registers */
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,SyCon0);

  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,SyCon1);

  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,SyCon2);

  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,SyCon3);

  C("Verify that Initialization has taken place properly");
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000002);
 /*  Disable InitRtnChk */
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000080); 
}
/******************************************************************************/
/************************** SyncFlashSdramInitProc ****************************/
/******************************************************************************/
SyncFlashSdramInitProc(
int burlen0,int burtype0,int caslat0,int raslat0,int opmode0,int wrburmode0,
int burlen1,int burtype1,int caslat1,int raslat1,int opmode1,int wrburmode1,
int burlen2,int burtype2,int caslat2,int raslat2,int opmode2,int wrburmode2,
int burlen3,int burtype3,int caslat3,int raslat3,int opmode3,int wrburmode3,
int md0,int mpw0,int ps0,int rbc0,int mw0,int rb0,int wb0, int wp0,int cw0,
int nb0, int rw0,
int md1,int mpw1,int ps1,int rbc1,int mw1,int rb1,int wb1, int wp1,int cw1,
int nb1, int rw1,
int md2,int mpw2,int ps2,int rbc2,int mw2,int rb2,int wb2, int wp2,int cw2, 
int nb2, int rw2,
int md3,int mpw3,int ps3,int rbc3,int mw3,int rb3,int wb3,int wp3,int cw3,
int nb3, int rw3,int rowpos0,int rowpos1,int rowpos2,int rowpos3,
int endian, int ClkRatio)
{
  /*
     Summary: SyncFlashSdramInitProc()
     =================================
     This function performs the following functionality
     o It checks for the buffer status and MPMC busy bits. When MPMC is idle
       and write buffer is empty it starts doing reinitialization process

    o  Initializes the sync memory
  */
  unsigned long Addr4,Addr5,Addr6,Addr7;
  int32 TempConfig;
  unsigned long Address4,Address5,Address6,Address7;
  int RasCas0,RasCas1,RasCas2,RasCas3;
  int Config,i;
  int32 SyCon0,SyCon1,SyCon2,SyCon3;
  char debugstr[100];
  int AM0,AM1,AM2,AM3;

  C("Program Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  WaitLoop(0x4);
  C("Apply Reset");
  RES(LOW, , ,);

  C("Reprogram Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  /* Program the MPMCDyConfig[0 - 3] and MPMCDyRasCas[0-3] with relevent
     values .RAS and CAS delays must be constitent with the values written
     to the mode register.                                                  */
  SyCon0 = md0 << 3 | mpw0 << 7 | ps0 << 9 | rbc0 << 12 | mw0 << 14 |
              rb0 << 18 | wb0 << 19 | wp0 << 20 | cw0 << 22 | nb0 << 26 |
              rw0 << 28;
  SyCon1 = md1 << 3 | mpw1 << 7 | ps1 << 9 | rbc1 << 12 | mw1 << 14 |
              rb1 << 18 | wb1 << 19 | wp1 << 20 | cw1 << 22 | nb1 << 26 |
              rw1 << 28;
  SyCon2 = md2 << 3 | mpw2 << 7 | ps2 << 9 | rbc2 << 12 | mw2 << 14 |
              rb2 << 18 | wb2 << 19 | wp2 << 20 | cw2 << 22 | nb2 << 26 |
              rw2 << 28;
  SyCon3 = md3 << 3 | mpw3 << 7 | ps3 << 9 | rbc3 << 12 | mw3 << 14 |
              rb3 << 18 | wb3 << 19 | wp3 << 20 | cw3 << 22 | nb3 << 26 |
              rw3 << 28;

  debug_info("Switch off Protocol checker");
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x00000010);

  C("Assert nRP line");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00004003);

  /* Program Expected no of refresh cycles for protocol */
  HSA(MPMCTrExpRef,NSEQ, INCR, OK, WRD);
  HSW(,0x8);

  RasCas0 =  caslat0 << 8 | raslat0;
  HSA(MPMCDyRasCas0,NSEQ,INCR,OK,WRD);
  HSW(,RasCas0);

  RasCas1 =  caslat1 << 8 | raslat1;
  HSA(MPMCDyRasCas1,NSEQ,INCR,OK,WRD);
  HSW(,RasCas1);

  RasCas2 =  caslat2 << 8 | raslat2;
  HSA(MPMCDyRasCas2,NSEQ,INCR,OK,WRD);
  HSW(,RasCas2);

  RasCas3 =  caslat3 << 8 | raslat3;
  HSA(MPMCDyRasCas3,NSEQ,INCR,OK,WRD);
  HSW(,RasCas3);

  /* Program MPMCDyConfig register */
  TempConfig = SyCon0 & 0xFFF3FFFF;
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon1 & 0xFFF3FFFF;
  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon2 & 0xFFF3FFFF;
  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon3 & 0xFFF3FFFF;
  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);
  
  C("Wait for 200us");
  WaitLoop(50);

  /* Apply NOP */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00004183);
  /* Issue Precharge by writing 10 to I field of MPMCDyCntl */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00004103);

  /* write a small value to refresh register */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x00000002);

  /* Wait till 8 refresh has applied to memory */
  WaitLoop(0x108); 
  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x0000001A);

  debug_info("Set I to MODE");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00004083);

  /* Configure the mode register for its burst length, burst type, 
     CAS latency,*/
  /* operating mode, write burst mode by performing a read operation */
  Addr4 = wrburmode0 << 9 | opmode0 << 7 | caslat0 << 4 |
          burtype0 << 3 | burlen0;

  Addr5 = wrburmode1<< 9 | opmode1<< 7 | caslat1<< 4 |
          burtype1 << 3 | burlen1;

  Addr6 = wrburmode2 << 9 | opmode2 << 7 | caslat2 << 4 |
          burtype2 << 3 | burlen2;

  Addr7 = wrburmode3 << 9 | opmode3 << 7 | caslat3 << 4 |
          burtype3 << 3 | burlen3;

  Address4 = Addr4 << rowpos0;
  Address5 = Addr5 << rowpos1;
  Address6 = Addr6 << rowpos2;
  Address7 = Addr7 << rowpos3;
  /* Program the mode registers with the valid data */
  debug_info("Program mode registers");
  HSA(Address4 | 0x40000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address5 | 0x50000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address6 | 0x60000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address7 | 0x70000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  debug_info("Program I to normal Mode");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00004003);
  /* Reprogram Configuration registers */
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,SyCon0);

  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,SyCon1);

  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,SyCon2);

  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,SyCon3);

  debug_info("Switch on Protocol checker");
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(,0x00000000);
}
/******************************************************************************/
/************************************ Write access ****************************/
/******************************************************************************/
void WriteData(int32 address, int32 data,char *size)
{
  /*
     Summary: WriteData()
     ====================
     This function does the write operation
  */
  char hsize;
  if(size == "WRD")
    hsize = 'w';
  else if(size == "HWRD")
    hsize = 'h';
  else if(size == "BYTE")
    hsize = 'b';
  HSA(address, NSEQ, SINGLE, OK, hsize, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}
/******************************************************************************/
/************************************* Read access ****************************/
/******************************************************************************/
void ReadData(int32 address, int32 data, int32 mask,char *size)
{
  /*
     Summary: ReadData()
     ====================
     This function does the read operation
  */
  char hsize;
  if(size == "WRD")
    hsize = 'w';
  else if(size == "HWRD")
    hsize = 'h';
  else if(size == "BYTE")
    hsize = 'b';
  HSA(address, NSEQ, SINGLE, OK, hsize, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}

/******************************************************************************/
/****************************** ReProgramDyReg ********************************/
/******************************************************************************/
ReProgramDyReg(
int burlen0,int burtype0,int caslat0,int raslat0,int opmode0,int wrburmode0,
int burlen1,int burtype1,int caslat1,int raslat1,int opmode1,int wrburmode1,
int burlen2,int burtype2,int caslat2,int raslat2,int opmode2,int wrburmode2,
int burlen3,int burtype3,int caslat3,int raslat3,int opmode3,int wrburmode3,
int md0,int mpw0,int ps0,int rbc0,int mw0,int rb0,int wb0, int wp0,int cw0,
int nb0, int rw0,
int md1,int mpw1,int ps1,int rbc1,int mw1,int rb1,int wb1, int wp1,int cw1,
int nb1, int rw1,
int md2,int mpw2,int ps2,int rbc2,int mw2,int rb2,int wb2, int wp2,int cw2, 
int nb2, int rw2,
int md3,int mpw3,int ps3,int rbc3,int mw3,int rb3,int wb3,int wp3,int cw3,
int nb3, int rw3,int rowpos0,int rowpos1,int rowpos2,int rowpos3,
int endian, int ClkRatio, int RdCfg)
{
  /*
     Summary: ReProgramDyReg()
     =========================
     This function performs the following functionality
     o It initializes the dynamic memory controller registers which are supposed
       to be programmed during initialization.

  */
  unsigned long Addr4,Addr5,Addr6,Addr7;
  int32 TempConfig;
  unsigned long Address4,Address5,Address6,Address7;
  int RasCas0,RasCas1,RasCas2,RasCas3;
  int Config,i;
  int32 SyCon0,SyCon1,SyCon2,SyCon3;
  char debugstr[100];
  int AM0,AM1,AM2,AM3;

  C("Program Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  C("Program RdCfg register");
  HSA(MPMCDyRdCfg, NSEQ, INCR, OK, WRD);
  HSW(,RdCfg);

  C("Reprogram Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  /* Program the MPMCDyConfig[0 - 3] and MPMCDyRasCas[0-3] with relevent
     values .RAS and CAS delays must be constitent with the values written
     to the mode register.                                                  */
  SyCon0 = md0 << 3 | mpw0 << 7 | ps0 << 9 | rbc0 << 12 | mw0 << 14 |
              rb0 << 18 | wb0 << 19 | wp0 << 20 | cw0 << 22 | nb0 << 26 |
              rw0 << 28;
  SyCon1 = md1 << 3 | mpw1 << 7 | ps1 << 9 | rbc1 << 12 | mw1 << 14 |
              rb1 << 18 | wb1 << 19 | wp1 << 20 | cw1 << 22 | nb1 << 26 |
              rw1 << 28;
  SyCon2 = md2 << 3 | mpw2 << 7 | ps2 << 9 | rbc2 << 12 | mw2 << 14 |
              rb2 << 18 | wb2 << 19 | wp2 << 20 | cw2 << 22 | nb2 << 26 |
              rw2 << 28;
  SyCon3 = md3 << 3 | mpw3 << 7 | ps3 << 9 | rbc3 << 12 | mw3 << 14 |
              rb3 << 18 | wb3 << 19 | wp3 << 20 | cw3 << 22 | nb3 << 26 |
              rw3 << 28;

  RasCas0 =  caslat0 << 8 | raslat0;
  HSA(MPMCDyRasCas0,NSEQ,INCR,OK,WRD);
  HSW(,RasCas0);

  RasCas1 =  caslat1 << 8 | raslat1;
  HSA(MPMCDyRasCas1,NSEQ,INCR,OK,WRD);
  HSW(,RasCas1);

  RasCas2 =  caslat2 << 8 | raslat2;
  HSA(MPMCDyRasCas2,NSEQ,INCR,OK,WRD);
  HSW(,RasCas2);

  RasCas3 =  caslat3 << 8 | raslat3;
  HSA(MPMCDyRasCas3,NSEQ,INCR,OK,WRD);
  HSW(,RasCas3);

  /* Reprogram Configuration registers */
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,SyCon0);

  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,SyCon1);

  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,SyCon2);

  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,SyCon3);
}

/******************************************************************************/
/************************* CmdDelSyncInitializeProc ***************************/
/******************************************************************************/
CmdDelSyncInitializeProc(
int burlen0,int burtype0,int caslat0,int raslat0,int opmode0,int wrburmode0,
int burlen1,int burtype1,int caslat1,int raslat1,int opmode1,int wrburmode1,
int burlen2,int burtype2,int caslat2,int raslat2,int opmode2,int wrburmode2,
int burlen3,int burtype3,int caslat3,int raslat3,int opmode3,int wrburmode3,
int md0,int mpw0,int ps0,int rbc0,int mw0,int rb0,int wb0, int wp0,int cw0,
int nb0, int rw0,
int md1,int mpw1,int ps1,int rbc1,int mw1,int rb1,int wb1, int wp1,int cw1,
int nb1, int rw1,
int md2,int mpw2,int ps2,int rbc2,int mw2,int rb2,int wb2, int wp2,int cw2, 
int nb2, int rw2,
int md3,int mpw3,int ps3,int rbc3,int mw3,int rb3,int wb3,int wp3,int cw3,
int nb3, int rw3,int rowpos0,int rowpos1,int rowpos2,int rowpos3,
int endian, int ClkRatio, int RdCfg)
{
  /*
     Summary: CmdDelSyncInitializeProc()
     ===================================
     This function performs the following functionality
     
     o This function is used when initialisation of dynamic memory to be
       done with command delayed mode enabled. It does the initialization 
       with the reprogramming of the RdCfg register.
  */
  unsigned long Addr4,Addr5,Addr6,Addr7;
  int32 TempConfig;
  unsigned long Address4,Address5,Address6,Address7;
  int RasCas0,RasCas1,RasCas2,RasCas3;
  int Config,i;
  int32 SyCon0,SyCon1,SyCon2,SyCon3;
  char debugstr[100];
  int AM0,AM1,AM2,AM3;

  C("Program RdCfg register");
  HSA(MPMCDyRdCfg, NSEQ, INCR, OK, WRD);
  HSW(,RdCfg);

  C("Program Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  WaitLoop(0x4);
  C("Apply Reset");
  RES(LOW, , ,);

  C("Reprogram Configuration register");
  Config = ClkRatio << 8 | endian;
  HSA(MPMCConfig, NSEQ, INCR, OK, WRD);
  HSW(,Config);

  /* Enable InitChkRtn */
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000003);
  /* Program the MPMCDyConfig[0 - 3] and MPMCDyRasCas[0-3] with relevent
     values .RAS and CAS delays must be constitent with the values written
     to the mode register.                                                  */
  SyCon0 = md0 << 3 | mpw0 << 7 | ps0 << 9 | rbc0 << 12 | mw0 << 14 |
              rb0 << 18 | wb0 << 19 | wp0 << 20 | cw0 << 22 | nb0 << 26 |
              rw0 << 28;
  SyCon1 = md1 << 3 | mpw1 << 7 | ps1 << 9 | rbc1 << 12 | mw1 << 14 |
              rb1 << 18 | wb1 << 19 | wp1 << 20 | cw1 << 22 | nb1 << 26 |
              rw1 << 28;
  SyCon2 = md2 << 3 | mpw2 << 7 | ps2 << 9 | rbc2 << 12 | mw2 << 14 |
              rb2 << 18 | wb2 << 19 | wp2 << 20 | cw2 << 22 | nb2 << 26 |
              rw2 << 28;
  SyCon3 = md3 << 3 | mpw3 << 7 | ps3 << 9 | rbc3 << 12 | mw3 << 14 |
              rb3 << 18 | wb3 << 19 | wp3 << 20 | cw3 << 22 | nb3 << 26 |
              rw3 << 28;

  /* Program Expected no of refresh cycles for protocol */
  HSA(MPMCTrExpRef,NSEQ, INCR, OK, WRD);
  HSW(,0x8);

  RasCas0 =  caslat0 << 8 | raslat0;
  HSA(MPMCDyRasCas0,NSEQ,INCR,OK,WRD);
  HSW(,RasCas0);

  RasCas1 =  caslat1 << 8 | raslat1;
  HSA(MPMCDyRasCas1,NSEQ,INCR,OK,WRD);
  HSW(,RasCas1);

  RasCas2 =  caslat2 << 8 | raslat2;
  HSA(MPMCDyRasCas2,NSEQ,INCR,OK,WRD);
  HSW(,RasCas2);

  RasCas3 =  caslat3 << 8 | raslat3;
  HSA(MPMCDyRasCas3,NSEQ,INCR,OK,WRD);
  HSW(,RasCas3);

  /* Program MPMCDyConfig register */
  TempConfig = SyCon0 & 0xFFF3FFFF;
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon1 & 0xFFF3FFFF;
  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon2 & 0xFFF3FFFF;
  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  TempConfig = SyCon3 & 0xFFF3FFFF;
  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,TempConfig);

  /* Wait for 200us by performing dummy read operation which consumes two */
  /* clock cycles for each operation */
  C("Wait for 200us");
  WaitLoop(50);

  /* Apply NOP */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000183);
  WaitLoop(1);
  /* Issue Precharge by writing 10 to I field of MPMCDyCntl */
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000103);

  /* write a small value to refresh register */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x00000002);

  /* Wait till 8 refresh has applied to memory */
  WaitLoop(0x108);
  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x0000001A);

  debug_info("Set I to MODE");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000083);

  /* Configure the mode register for its burst length, burst type, 
     CAS latency,*/
  /* operating mode, write burst mode by performing a read operation */
  Addr4 = wrburmode0 << 9 | opmode0 << 7 | caslat0 << 4 |
          burtype0 << 3 | burlen0;

  Addr5 = wrburmode1<< 9 | opmode1<< 7 | caslat1<< 4 |
          burtype1 << 3 | burlen1;

  Addr6 = wrburmode2 << 9 | opmode2 << 7 | caslat2 << 4 |
          burtype2 << 3 | burlen2;

  Addr7 = wrburmode3 << 9 | opmode3 << 7 | caslat3 << 4 |
          burtype3 << 3 | burlen3;

  Address4 = Addr4 << rowpos0;
  Address5 = Addr5 << rowpos1;
  Address6 = Addr6 << rowpos2;
  Address7 = Addr7 << rowpos3;
  /* Program the mode registers with the valid data */
  debug_info("Program mode registers");
  HSA(Address4 | 0x40000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address5 | 0x50000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address6 | 0x60000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  HSA(Address7 | 0x70000000, NSEQ, INCR, OK, BYTE);
  HSR(, , ,0x00000000);

  debug_info("Program I to normal Mode");
  HSA(MPMCDyCntl,NSEQ,SINGLE,OK,WRD);
  HSW(,0x00000003);
  /* Reprogram Configuration registers */
  HSA(MPMCDyConfig0,NSEQ,INCR,OK,WRD);
  HSW(,SyCon0);

  HSA(MPMCDyConfig1,NSEQ,INCR,OK,WRD);
  HSW(,SyCon1);

  HSA(MPMCDyConfig2,NSEQ,INCR,OK,WRD);
  HSW(,SyCon2);

  HSA(MPMCDyConfig3,NSEQ,INCR,OK,WRD);
  HSW(,SyCon3);

  C("Verify that Initialization has taken place properly");
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000002);
 /*  Disable InitRtnChk */
  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000); 
}
/*-- --============================= End ================================-- --*/
