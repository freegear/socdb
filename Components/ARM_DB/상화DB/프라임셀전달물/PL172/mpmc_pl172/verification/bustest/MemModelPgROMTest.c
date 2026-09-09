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
-- File Name              : MemModelPgROMTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests async page mode access with the page mode
--           ROM device
--
--           TEST ID : MPMC_MemModelPgROMTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/************************** MemModelStPgModeTest ******************************/
/******************************************************************************/
MemModelPgROMTest()
{
  /*
    Summary: MemModelPgROMTest
    =============================
    This test performs the following functionalities:
      
        o Initializes the static wait registers

        o Does the page mode read from the page mode read ROM devices.

        o Inserts the BUSY trans in between the transfer randomly.

  */
  int i, flag, Addr,AddrLSB;
  int burst,size, csel;
  int trans[2];
  int trans1[2] = {1,5};
  int trans0[7] = {2,3,3,3,3,3,5};
  int trans4[5] = {2,3,3,3,5};
  int trans8[9] = {2,3,3,3,3,3,3,3,5};
  int trans16[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int Data;
  int BusyIns;
  C("TEST ID : MPMC_MemModelPgROMTest_1");
  /* Disable Address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  /* Set Bank 0 Memory Type as Pg mode flash (16 bits width) */
  StInitProc(0,1,1,0,1,0,1,1,1,0x1,0x1,0x7,0x5,0x8,0x5,0x8);
  /* Set Bank 1 Memory Type as Pg mode flash (32 bits width) */
  StInitProc(1,2,1,0,1,0,1,1,1,0x1,0x1,0x3,0x1,0x1,0x1,0x1);

  /* Set Bank 2 Memory Type as Pg mode flash (16 bits width) */
  StInitProc(2,1,1,0,1,0,1,1,1,0x1,0x1,0x8,0x5,0x8,0x1,0x1);

  /* Set Bank 3 Memory Type as Pg mode flash (32 bits width) */
  StInitProc(3,2,1,0,1,0,1,1,1,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  C("Read from CS0 which has 16bit data width memory");
  Data = 0x00000000; 
  Addr = 0x00000000;
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(size = 0; size < 3; size++)
    {
      /* selection of size */
      for(csel = 0;csel < 2; csel++)
      {
         if (csel == 0)
         {
            if(size == 0)
            {
              if(burst == 1)
              { 
                 Addr = rand() & 0xF;
                 for(i = 0; i < 8; i++)
                 {
                    AddrLSB = Addr & 0xF;
                    flag = AddrLSB % 2;
                    if(i == 0)
                      trans[0] = 2;
                    else
                      trans[0] = 3;
                    trans[1] = 5;
                    if (flag == 0)
                      Data = Addr >> 1;
                    else
                      Data = 0;
                    Sequence('r',Addr,trans,"inc",0,Data,0);
                    Addr = Addr++;
                    BusyIns = rand() % 0x2;
                    if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"inc",0,0x87654321,0);
                 } 
              } 
              else if(burst == 3)
              {
                 Addr = rand() & 0xF + 0x20;
                 for(i = 0; i < 4; i++)
                 {
                    AddrLSB = Addr & 0xF;
                    flag = AddrLSB % 2;
                    if(i == 0)
                      trans[0] = 2;
                    else
                      trans[0] = 3;
                    trans[1] = 5;
                    if (flag == 0)
                      Data = Addr >> 1;
                    else
                      Data = 0;
                    Sequence('r',Addr,trans,"in4",0,Data,0);
                    Addr = Addr++;
                    BusyIns = rand() % 0x2;
                    if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in4",0,0x87654321,0);
                 } 
              }
              else if(burst == 5)
              { 
                 Addr = rand() & 0xF + 0x40;
                 for(i = 0; i < 8; i++)
                 {
                    AddrLSB = Addr & 0xF;
                    flag = AddrLSB % 2;
                    if(i == 0)
                      trans[0] = 2;
                    else
                      trans[0] = 3;
                    trans[1] = 5;
                    if (flag == 0)
                      Data = Addr >> 1;
                    else
                      Data = 0;
                    Sequence('r',Addr,trans,"in8",0,Data,0);
                    Addr = Addr++;
                    BusyIns = rand() % 0x2;
                    if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in8",0,0x87654321,0);
                 } 
              }
              else if(burst == 7)
              {    
                 Addr = rand() & 0xF + 0x60;
                 for(i = 0; i < 16; i++)
                 {
                    AddrLSB = Addr & 0xF;
                    flag = AddrLSB % 2;
                    if(i == 0)
                      trans[0] = 2;
                    else
                      trans[0] = 3;
                    trans[1] = 5;
                    if (flag == 0)
                      Data = Addr >> 1;
                    else
                      Data = 0;
                    Sequence('r',Addr,trans,"i16",0,Data,0);
                    Addr = Addr++;
                    BusyIns = rand() % 0x2;
                    if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"i16",0,0x87654321,0);
                 } 
              } 
            }
            else if (size == 1)
            {
              if(burst == 1)
              {
                Addr = rand() & 0xE + 0x80; 
                Data = Addr >> 1;
                for (i = 0; i < 9; i++)
                {
                  flag = i % 2;
                  if(i == 0)
                    trans[0] = 2;
                  else
                    trans[0] = 3;
                  trans[1] = 5;
                  Sequence('r',Addr,trans,"inc",1,Data,0); 
                  Addr = Addr + 2;
                  BusyIns = rand() % 0x2;
                  if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"inc",1,0x87654321,0);
                  Data = Addr >> 1;
                }
             }
             else if(burst == 3)
             {
               Addr = rand() & 0xE + 0xA0;
               Data = Addr >> 1;
               for (i = 0; i < 4; i++)
               {
                 flag = i % 2;
                 if(i == 0)
                   trans[0] = 2;
                 else
                   trans[0] = 3;
                 trans[1] = 5;
                 Sequence('r',Addr,trans,"in4",1,Data,0);
                 Addr = Addr + 2;
                 BusyIns = rand() % 0x2;
                 if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in4",1,0x87654321,0);
                 Data = Addr >> 1;
               } 
             }
             else if(burst == 5)
             {
               Addr = rand() & 0xE + 0xA0;
               Data = Addr >> 1;
               for (i = 0; i < 8; i++)
               {
                 flag = i % 2;
                 if(i == 0)
                   trans[0] = 2;
                 else
                   trans[0] = 3;
                 trans[1] = 5;
                 Sequence('r',Addr,trans,"in8",1,Data,0);
                 Addr = Addr + 2;
                 BusyIns = rand() % 0x2;
                 if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in8",1,0x87654321,0);
                 Data = Addr >> 1;
               } 
             }
             else if(burst == 7)
             {
               Addr = rand() & 0xE + 0xC0;
               Data = Addr >> 1;
               for (i = 0; i < 16; i++)
               {
                 flag = i % 2;
                 if(i == 0)
                   trans[0] = 2;
                 else
                   trans[0] = 3;
                 trans[1] = 5;
                 Sequence('r',Addr,trans,"i16",1,Data,0);
                 Addr = Addr + 2;
                 BusyIns = rand() % 0x2;
                 if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"i16",1,0x87654321,0);
                 Data = Addr >> 1;
               }
             }
           } 
           else if(size == 2)
           {
             if(burst == 1)
             {
                Addr = rand() & 0xC + 0x100;
                
                Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                for (i = 0; i < 17; i++)
                {
                   flag = i % 2;
                   if(i == 0)
                     trans[0] = 2;
                   else
                     trans[0] = 3;
                   trans[1] = 5;
                   Sequence('r',Addr,trans,"inc",2,Data,0);
                   Addr = Addr + 4;
                   BusyIns = rand() % 0x2;
                   if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"inc",2,0x87654321,0);
                   Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                } 
              }
              else if (burst == 3)
              {
                 Addr = rand() & 0xC + 0x140;
                Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                for (i = 0; i < 4; i++)
                {
                   flag = i % 2;
                   if(i == 0)
                     trans[0] = 2;
                   else
                     trans[0] = 3;
                   trans[1] = 5;
                   Sequence('r',Addr,trans,"in4",2,Data,0);
                   Addr = Addr + 4;
                   BusyIns = rand() % 0x2;
                   if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in4",2,0x87654321,0);
                   Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                }
              }
              if (burst == 5)
              {
                Addr = rand() & 0xC + 0x160;
                Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                for (i = 0; i < 8; i++)
                {
                   flag = i % 2;
                   if(i == 0)
                     trans[0] = 2;
                   else
                     trans[0] = 3;
                   trans[1] = 5;
                   Sequence('r',Addr,trans,"in8",2,Data,0);
                   Addr = Addr + 4;
                   BusyIns = rand() % 0x2;
                   if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"in8",2,0x87654321,0);
                   Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                }
              }
              if (burst == 7)
              {
                Addr = rand() & 0xC + 0x180;
                Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                for (i = 0; i < 16; i++)
                {
                   flag = i % 2;
                   if(i == 0)
                     trans[0] = 2;
                   else
                     trans[0] = 3;
                   trans[1] = 5;
                   Sequence('r',Addr,trans,"i16",2,Data,0);
                   Addr = Addr + 4;
                   BusyIns = rand() % 0x2;
                   if (BusyIns == 1)
                     Sequence('r',Addr,trans1,"i16",2,0x87654321,0);
                   Data = (((Addr+2) >> 1) << 16) | (Addr >> 1);
                }
              }
             }
           }
           else if(csel == 1)
           {
             if(size == 0)
             {
                if(burst == 1)
                {
                   Addr = rand() & 0xF;
                   Addr = Addr + 0x10000000;
                   AddrLSB = Addr & 0xF;
                   if((AddrLSB % 2) != 0)
                     Data = 0x0;
                   else  
                     Data = (Addr >> 1);
                   for (i = 0; i < 17; i++)
                   {
                     if(i == 0)
                       trans[0] = 2;
                     else
                       trans[0] = 3;
                     trans[1] = 5; 
                     Sequence('r',Addr,trans,"inc",0,Data,0);
                     Addr = Addr + 1;
                     BusyIns = rand() % 0x2;
                     if (BusyIns == 1)
                       Sequence('r',Addr,trans1,"inc",0,0x87654321,0);
                     AddrLSB = Addr & 0xF;
                     if((AddrLSB % 2) != 0)
                       Data = 0x0;
                     else
                       Data = (Addr >> 1);
                   }
                 }
                 if(burst == 3)
                {
                   Addr = rand() & 0xF + 0x40;
                   Addr = Addr + 0x10000000;
                   AddrLSB = Addr & 0xF;
                   if((AddrLSB % 2) != 0)
                     Data = 0x0;
                   else
                     Data = (Addr >> 1);
                   for (i = 0; i < 4; i++)
                   {
                     if(i == 0)
                       trans[0] = 2;
                     else
                       trans[0] = 3;
                     trans[1] = 5;
                     Sequence('r',Addr,trans,"in4",0,Data,0);
                     Addr = Addr + 1;
                     BusyIns = rand() % 0x2;
                     if (BusyIns == 1)
                       Sequence('r',Addr,trans1,"in4",0,0x87654321,0);
                     AddrLSB = Addr & 0xF;
                     if((AddrLSB % 2) != 0)
                       Data = 0x0;
                     else
                       Data = (Addr >> 1);
                   }
                 }
                 if(burst == 5)
                {
                   Addr = rand() & 0xF + 0x40;
                   Addr = Addr + 0x10000000;
                   AddrLSB = Addr & 0xF;
                   if((AddrLSB % 2) != 0)
                     Data = 0x0;
                   else
                     Data = (Addr >> 1);
                   for (i = 0; i < 8; i++)
                   {
                     if(i == 0)
                       trans[0] = 2;
                     else
                       trans[0] = 3;
                     trans[1] = 5;
                     Sequence('r',Addr,trans,"in8",0,Data,0);
                     Addr = Addr + 1;
                     BusyIns = rand() % 0x2;
                     if (BusyIns == 1)
                       Sequence('r',Addr,trans1,"in8",0,0x87654321,0);
                     AddrLSB = Addr & 0xF;
                     if((AddrLSB % 2) != 0)
                       Data = 0x0;
                     else
                       Data = (Addr >> 1);
                   }
                 }
                if(burst == 7)
                {
                   Addr = rand() & 0xF + 0x40;
                   Addr = Addr + 0x10000000;
                   AddrLSB = Addr & 0xF;
                   if((AddrLSB % 2) != 0)
                     Data = 0x0;
                   else
                     Data = (Addr >> 1);
                   for (i = 0; i < 16; i++)
                   {
                     if(i == 0)
                       trans[0] = 2;
                     else
                       trans[0] = 3;
                     trans[1] = 5;
                     Sequence('r',Addr,trans,"i16",0,Data,0);
                     Addr = Addr + 1;
                     BusyIns = rand() % 0x2;
                     if (BusyIns == 1)
                       Sequence('r',Addr,trans1,"i16",0,0x87654321,0);
                     AddrLSB = Addr & 0xF;
                     if((AddrLSB % 2) != 0)
                       Data = 0x0;
                     else
                       Data = (Addr >> 1);
                   }
                 }
               }
               else if (size == 1)
               {
                  if(burst == 1)
                  {
                     Addr = rand() & 0xE + 0x80;
                     Data = Addr >> 1; 
                     Addr = Addr + 0x10000000;
                     for (i = 0; i < 15; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"inc",1,Data,0);
                       Addr = Addr + 2;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"inc",1,0x87654321,0);
                       Data = (Addr & 0x0000FFFF) >> 1;
                     }
                  }
                  if(burst == 3)
                  {
                     Addr = rand() & 0xE + 0xA0;
                     Data = Addr >> 1;
                     Addr = Addr + 0x10000000;
                     for (i = 0; i < 4; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"in4",1,Data,0);
                       Addr = Addr + 2;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"in4",1,0x87654321,0);
                       Data = (Addr & 0x0000FFFF) >> 1;
                     }
                  }   
                  if(burst == 5)
                  {
                     Addr = rand() & 0xE + 0xC0;
                     Data = Addr >> 1;
                     Addr = Addr + 0x10000000;
                     for (i = 0; i < 8; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"in8",1,Data,0);
                       Addr = Addr + 2;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"in8",1,0x87654321,0);
                       Data = (Addr & 0x0000FFFF) >> 1;
                     }
                   }
                   if(burst == 7)
                  {
                     Addr = rand() & 0xE + 0x100;
                     Data = Addr >> 1;
                     Addr = Addr + 0x10000000;
                     for (i = 0; i < 16; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"i16",1,Data,0);
                       Addr = Addr + 2;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"i16",1,0x87654321,0);
                       Data = (Addr & 0x0000FFFF) >> 1;
                     }
                   }
                }
                else if(size == 2)
                {
                  if(burst == 1)
                  {
                     Addr = rand() & 0xC;
                     Data = (((Addr + 2) >> 1) << 16) | (Addr >> 1);
                     Addr = Addr | 0x10000000;
                     for (i = 0; i < 16; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"inc",2,Data,0);
                       Addr = Addr + 4;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"inc",2,0x87654321,0);
                       Data = ((((Addr & 0x0000FFFF) + 2) >> 1) << 16) |
                                ((Addr & 0x0000FFFF) >> 1);
                     }
                   }
                   if(burst == 3)
                  {
                     Addr = rand() & 0xC + 0x120;
                     Data = Addr >> 1;
                     Data = ((Data + 1) << 16) | Data;
                     Addr = Addr | 0x10000000;
                     for (i = 0; i < 4; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"in4",2,Data,0);
                       Addr = Addr + 4;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"in4",2,0x87654321,0);
                       Data = ((((Addr & 0x0000FFFF) + 2) >> 1) << 16) |
                                ((Addr & 0x0000FFFF) >> 1);
                     }
                   }
                   if(burst == 5)
                  {
                     Addr = rand() & 0xC + 0x140;
                     Data = Addr >> 1;
                     Data = ((Data + 1) << 16) | Data;
                     Addr = Addr | 0x10000000;
                     for (i = 0; i < 8; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"in8",2,Data,0);
                       Addr = Addr + 4;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"in8",2,0x87654321,0);
                       Data = ((((Addr & 0x0000FFFF) + 2) >> 1) << 16) |
                                ((Addr & 0x0000FFFF) >> 1);
                     }
                   }
                   if(burst == 7)
                  {
                     Addr = rand() & 0xC + 0x200;
                     Data = Addr >> 1;
                     Data = ((Data + 1) << 16) | Data;
                     Addr = Addr | 0x10000000;
                     for (i = 0; i < 16; i++)
                     {
                       if(i == 0)
                       trans[0] = 2;
                       else
                         trans[0] = 3;
                       trans[1] = 5;
                       Sequence('r',Addr,trans,"i16",2,Data,0);
                       Addr = Addr + 4;
                       BusyIns = rand() % 0x2;
                       if (BusyIns == 1)
                         Sequence('r',Addr,trans1,"i16",2,0x87654321,0);
                       Data = ((((Addr & 0x0000FFFF) + 2) >> 1) << 16) |
                                ((Addr & 0x0000FFFF) >> 1);
                     }
                   }
                }
            }
         }
      }
    }
}
