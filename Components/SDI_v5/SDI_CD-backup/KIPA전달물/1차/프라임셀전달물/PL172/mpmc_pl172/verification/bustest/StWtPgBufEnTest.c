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
-- File Name              : StWtPgBufEnTest.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Checks page mode operation with buffers enabled
--
--           TEST ID : MPMC_StWtBufEn_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** StWtPgBufEnTest *******************************/
/******************************************************************************/
void StWtPgBufEnTest()
{
  /* 
     Summary: StWtPgBufEnTest
     ========================
     This test performs the following operations.

     o  Enable Page mode access to Burst Mode ROM.

     o  It reads from Burst ROM with different types of burst, sizes with 
        buffers enabled.

  */
  unsigned long MemAddr, ReadData1,WriteData1,TmpRdData,TmpData;
  char debugstr[500];
  int i,k,x;
  int burst, csel, size, chip, Addr, Data;
  int trans[2];
  int transb[2];
  int lim, tmplim, AddrLSB, TmpLSB;
  int Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF}; 
  int Shift[3] = {8,16,24};
  int BusyIns;
  int32 DataCS0,DataCS1,DataCS2,DataCS3,OrgData;
  char *bursttype[7] = {"INCR", "INCR4", "INCR8","INCR16", "WRAP4",
                        "WRAP8", "WRAP16"};
  char *sizetype[3] = {"BYTE","HWRD","WRD"};
  int32 Hmask[] = {0x0000FFFF, 0xFFFF0000};
  int32 Bmask[] = {0x000000FF, 0x0000FF00, 0x00FF0000,0xFF000000};
  C("TEST ID : MPMC_StWtBufEn_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrExBkOff, 0x0000000A, "WRD");
  /* Configure registers as well as memory banks */
  C("Program bank0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,1,0,1,0,1,1,1,0x3,0x5,0x7,0x6,0x5,0x1,0x4);
  TrickMemInit(0,2,1,0,1,0,1,1,1,0x3,0x5,0x7,0x6,0x5,0x1,MPMCTrMEMBData[0],
               0x0);

  /* Program bank1 : enable page mode, read buffer and connect BHE pin to Vcc */
  C("Program bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,1,0,1,0,1,1,1,0x2,0x3,0x5,0x4,0x3,0x1,0x4);
  TrickMemInit(1,1,1,0,1,0,0,1,1,0x2,0x3,0x5,0x4,0x3,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Program bank2 : enable page mode ,disable read and write buffer */
  C("Program bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,1,0,0,0,1,1,1,0x3,0x5,0x8,0x6,0x4,0x1,0x4);
  TrickMemInit(2,0,1,0,0,0,1,0,1,0x3,0x5,0x8,0x6,0x4,0x1,MPMCTrMEMBData[2],
               0x0);

  /* Program bank3 : enable page mode, read buffer and connect BHE pin to GND */
  C("Program bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,0,1,0,0,0,1,1,1,0x2,0x2,0x4,0x3,0x5,0x1,0x4);
  TrickMemInit(3,0,1,0,0,0,1,1,1,0x2,0x2,0x4,0x3,0x5,0x1,MPMCTrMEMBData[3],
               0x0);

  DataCS0 = 0x11111111;
  DataCS1 = 0x00003333;
  DataCS2 = 0x00000022;
  DataCS3 = 0x00000022;
  for (burst = 0; burst < 8; burst++)
  {
    /* selection of chip */
    for(size = 0; size < 3; size++)
    {
      /* selection of size */
      for(csel = 0;csel < 3; csel++)
      {
        chip = csel;
        Data = 0x11111111;
        if(burst == 0)
        {
          if(size == 0)
          {
            Addr = rand() & 0x00F;
            TmpLSB = Addr & 0xF;
            TmpLSB = TmpLSB % 4;
            if(csel == 1 && TmpLSB < 2)
               Data = 0x11111111;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111112;
            if(csel == 2)
               Data = 0x11111111 + TmpLSB;
          }  
          else if(size == 1)
          {
            Addr = (rand() & 0x00E) + 0x1A;
            TmpLSB = Addr & 0x2;
            if(csel == 2)
            {
             if(TmpLSB == 2) 
               Data = 0x11111113;
             else
               Data = 0x11111111;
            }
          }
          else if(size == 2)
          {
            Addr = (rand() & 0x00C) + 0x40;
          }
          MemAddr = Addr & 0x0FC;
          if(chip == 0)
            MemAddr = MemAddr;
          else if (chip == 1)
            MemAddr = MemAddr << 0x1;
          else
            MemAddr = MemAddr << 0x2;
          Addr = Addr | (chip << 28);
          
          AHBWriteMem(csel, MemAddr, 0x1E, DataCS0); 
          for (i = 0; i < 7; i++)
          {
            AddrLSB = Addr & 0x0000000F;
            if ( i == 0)
              trans[0] = 2;
            trans[1] = 5;
            
            if (chip == 0)
            {
               if(size == 0)
               {
                   tmplim = AddrLSB % 4; 
                   k = AddrLSB % 4;
                   if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
               }
               else if(size == 1)
               {
                  lim = 2;
                  k = ((AddrLSB)/2) % lim;
                  tmplim = k % lim;
                  if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
                }
                if (size == 2)
                {
                  k = 0;
                  tmplim = 0;
                  if(i != 0)
                    Data = Data + 1;
                }
                  TmpData = Data & (Mask[size] << (Shift[size] * k));
                  TmpData = (TmpData) >> (Shift[size] * k);
             }
             else if (chip == 1)
             {
               if (size != 2)
               {
                 if(size == 0)
                 {
                   lim = 2;
                   k = AddrLSB % 2; 
                   tmplim =  k % lim;
                 if(tmplim == 0)
                 {
                   if (i != 0)
                     Data = Data + 1;
                 }
                 TmpData = Data & (Mask[size] << (Shift[size] * k));
                 TmpData = TmpData >> (Shift[size] * k);
                 }
                 else if(size == 1)
                 {
                   tmplim = 0;
                    if (i != 0)
                      Data = Data + 1; 
                   k = (AddrLSB/2) % 2;
                   TmpData = Data & Mask[size];
                 }  
               }
               else
               {
                 TmpData = ((Data & 0x0000FFFF) |
                            (((Data+1) & 0x0000FFFF) << 16));
                 Data = Data + 2; 
               }
             } 
             else if (chip == 2)
             {
                if (size == 2)
                {
                  TmpData = ((((Data + 3) & 0x00000FF) << 24) |
                            (((Data + 2) & 0x00000FF) << 16)|
                            (((Data + 1) & 0x000000FF)<< 8) |
                              (Data & 0x000000FF));
                  Data = Data + 4;
                }
                else if (size == 1)
                {
                  TmpData = ((((Data + 1) & 0x000000FF) << 8) |
                              (Data & 0x000000FF));
                  Data = Data + 2;
                }
                else
                {
                  TmpData = Data;
                  Data = Data + 1;
                }
             }
             Sequence('r', Addr,trans,"sin",size,TmpData,0);
             if(size == 0)
               Addr = Addr + 1;
             else if(size == 1)
               Addr = Addr + 2;
             else if(size == 2)
               Addr = Addr + 4;
             BusyIns = rand() % 2;
             if (BusyIns == 1)
             {
               transb[0] = 1;
               transb[1] = 5;
               Sequence('r', Addr,transb,"sin",size,0x87654321,0);
             }
          }
         }
        
        Data = 0x11111111;
        if(burst == 1)
        {
          if(size == 0)
          {
            Addr = rand() & 0x00F + 0x90;
            TmpLSB = Addr & 0xF;
            TmpLSB = TmpLSB % 4;
            if(csel == 1 && TmpLSB < 2)
               Data = 0x11111111;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111112;
            if(csel == 2)
               Data = 0x11111111 + TmpLSB;
          }  
          else if(size == 1)
          {
            Addr = (rand() & 0x00E) + 0x110;
            TmpLSB = Addr & 0x3;
            if (csel == 1 && TmpLSB < 2)
               Data = 0x11111110;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111111; 
            else if(csel == 2)
            {
             if(TmpLSB == 2) 
               Data = 0x11111113;
             else
               Data = 0x11111111;
            }
          }
          else if(size == 2)
          {
            Addr = (rand() & 0x00C) + 0x150;
          }
          MemAddr = Addr & 0xFFC;
          if(chip == 0)
            MemAddr = MemAddr;
          else if (chip == 1)
            MemAddr = MemAddr << 0x1;
          else
            MemAddr = MemAddr << 0x2;
          Addr = Addr | (chip << 28);
          
          AHBWriteMem(csel, MemAddr, 0x20, DataCS0);
          for (i = 0; i < 6; i++)
          {
            AddrLSB = Addr & 0x0000000F;
            if ( i == 0)
              trans[0] = 2;
            else
              trans[0] = 3;
            trans[1] = 5;
            
            if (chip == 0)
            {
               if(size == 0)
               {
                   tmplim = AddrLSB % 4; 
                   k = AddrLSB % 4;
                   if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
               }
               else if(size == 1)
               {
                  lim = 2;
                  k = ((AddrLSB)/2) % lim;
                  tmplim = k % lim;
                  if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
                }
                if (size == 2)
                {
                  k = 0;
                  tmplim = 0;
                  if(i != 0)
                    Data = Data + 1;
                }
                  TmpData = Data & (Mask[size] << (Shift[size] * k));
                  TmpData = (TmpData) >> (Shift[size] * k);
             }
             else if (chip == 1)
             {
               if (size != 2)
               {
                 if(size == 0)
                 {
                   k = AddrLSB % 2; 
                   tmplim =  k % lim;
                 if(tmplim == 0)
                 {
                   if (i != 0)
                     Data = Data + 1;
                 }
                 TmpData = Data & (Mask[size] << (Shift[size] * k));
                 TmpData = TmpData >> (Shift[size] * k);
                 }
                 else if(size == 1)
                 {
                   tmplim = 0;
                   Data = Data + 1;
                   k = (AddrLSB/2) % 2;
                   TmpData = Data & Mask[size];
                 }  
               }
               else
               {
                 TmpData = ((Data & 0x0000FFFF) |
                            (((Data+1) & 0x0000FFFF) << 16));
                 Data = Data + 2; 
               }
             } 
             else if (chip == 2)
             {
                if (size == 2)
                {
                  TmpData = ((((Data + 3) & 0x00000FF) << 24) |
                            (((Data + 2) & 0x00000FF) << 16)|
                            (((Data + 1) & 0x000000FF)<< 8) |
                              (Data & 0x000000FF));
                  Data = Data + 4;
                }
                else if (size == 1)
                {
                  TmpData = ((((Data + 1) & 0x000000FF) << 8) |
                              (Data & 0x000000FF));
                  Data = Data + 2;
                }
                else
                {
                  TmpData = Data;
                  Data = Data + 1;
                }
             }
             Sequence('r', Addr,trans,"inc",size,TmpData,0);
             if(size == 0)
               Addr = Addr + 1;
             else if(size == 1)
               Addr = Addr + 2;
             else if(size == 2)
               Addr = Addr + 4;
             BusyIns = rand() % 2;
             if (BusyIns == 1)
             {
               transb[0] = 1;
               transb[1] = 5;
               Sequence('r', Addr,transb,"inc",size,0x87654321,0);
             }
          }
         }

        Data = 0x11111111;
        if(burst == 3)
        {
          if(size == 0)
          {
            Addr = rand() & 0x00F + 0x190;
            TmpLSB = Addr & 0xF;
            TmpLSB = TmpLSB % 4;
            if(csel == 1 && TmpLSB < 2)
               Data = 0x11111111;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111112;
            if(csel == 2)
               Data = 0x11111111 + TmpLSB;
          }  
          else if(size == 1)
          {
            Addr = (rand() & 0x00E) + 0x1B0;
            TmpLSB = Addr & 0x3;
            if (csel == 1 && TmpLSB < 2)
               Data = 0x11111110;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111111; 
            else if(csel == 2)
            {
             if(TmpLSB == 2) 
               Data = 0x11111113;
             else
               Data = 0x11111111;
            }
          }
          else if(size == 2)
          {
            Addr = (rand() & 0x00C) + 0x070;
          }
          MemAddr = Addr & 0xFFC;
          if(chip == 0)
            MemAddr = MemAddr;
          else if (chip == 1)
            MemAddr = MemAddr << 0x1;
          else
            MemAddr = MemAddr << 0x2;
          Addr = Addr | (chip << 28);
          
          AHBWriteMem(csel, MemAddr, 0x20, DataCS0);
          for (i = 0; i < 4; i++)
          {
            AddrLSB = Addr & 0x0000000F;
            if ( i == 0)
              trans[0] = 2;
            else
              trans[0] = 3;
            trans[1] = 5;
            
            if (chip == 0)
            {
               if(size == 0)
               {
                   tmplim = AddrLSB % 4; 
                   k = AddrLSB % 4;
                   if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
               }
               else if(size == 1)
               {
                  lim = 2;
                  k = ((AddrLSB)/2) % lim;
                  tmplim = k % lim;
                  if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
                }
                if (size == 2)
                {
                  k = 0;
                  tmplim = 0;
                  if(i != 0)
                    Data = Data + 1;
                }
                  TmpData = Data & (Mask[size] << (Shift[size] * k));
                  TmpData = (TmpData) >> (Shift[size] * k);
             }
             else if (chip == 1)
             {
               if (size != 2)
               {
                 if(size == 0)
                 {
                   k = AddrLSB % 2; 
                   tmplim =  k % lim;
                 if(tmplim == 0)
                 {
                   if (i != 0)
                     Data = Data + 1;
                 }
                 TmpData = Data & (Mask[size] << (Shift[size] * k));
                 TmpData = TmpData >> (Shift[size] * k);
                 }
                 else if(size == 1)
                 {
                   tmplim = 0;
                   Data = Data + 1;
                   k = (AddrLSB/2) % 2;
                   TmpData = Data & Mask[size];
                 }  
               }
               else
               {
                 TmpData = ((Data & 0x0000FFFF) |
                            (((Data+1) & 0x0000FFFF) << 16));
                 Data = Data + 2; 
               }
             } 
             else if (chip == 2)
             {
                if (size == 2)
                {
                  TmpData = ((((Data + 3) & 0x00000FF) << 24) |
                            (((Data + 2) & 0x00000FF) << 16)|
                            (((Data + 1) & 0x000000FF)<< 8) |
                              (Data & 0x000000FF));
                  Data = Data + 4;
                }
                else if (size == 1)
                {
                  TmpData = ((((Data + 1) & 0x000000FF) << 8) |
                              (Data & 0x000000FF));
                  Data = Data + 2;
                }
                else
                {
                  TmpData = Data;
                  Data = Data + 1;
                }
             }
             Sequence('r', Addr,trans,"in4",size,TmpData,0);
             if(size == 0)
               Addr = Addr + 1;
             else if(size == 1)
               Addr = Addr + 2;
             else if(size == 2)
               Addr = Addr + 4;
             BusyIns = rand() % 2;
             if (BusyIns == 1)
             {
               transb[0] = 1;
               transb[1] = 5;
               Sequence('r', Addr,transb,"in4",size,0x87654321,0);
             }
          }
        }
         
        Data = 0x11111111;
        if(burst == 5)
        {
          if(size == 0)
          {
            Addr = rand() & 0x00F + 0x230;
            TmpLSB = Addr & 0xF;
            TmpLSB = TmpLSB % 4;
            if(csel == 1 && TmpLSB < 2)
               Data = 0x11111111;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111112;
            if(csel == 2)
               Data = 0x11111111 + TmpLSB;
          }  
          else if(size == 1)
          {
            Addr = (rand() & 0x00E) + 0x270;
            TmpLSB = Addr & 0x3;
            if (csel == 1 && TmpLSB < 2)
               Data = 0x11111110;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111111; 
            else if(csel == 2)
            {
             if(TmpLSB == 2) 
               Data = 0x11111113;
             else
               Data = 0x11111111;
            }
          }
          else if(size == 2)
          {
            Addr = (rand() & 0x00C) + 0x2A0;
          }
          MemAddr = Addr & 0xFFC;
          if(chip == 0)
            MemAddr = MemAddr;
          else if (chip == 1)
            MemAddr = MemAddr << 0x1;
          else
            MemAddr = MemAddr << 0x2;
          Addr = Addr | (chip << 28);
          
          AHBWriteMem(csel, MemAddr, 0x20, DataCS0);
          for (i = 0; i < 8; i++)
          {
            AddrLSB = Addr & 0x0000000F;
            if ( i == 0)
              trans[0] = 2;
            else
              trans[0] = 3;
            trans[1] = 5;
            
            if (chip == 0)
            {
               if(size == 0)
               {
                   tmplim = AddrLSB % 4; 
                   k = AddrLSB % 4;
                   if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
               }
               else if(size == 1)
               {
                  lim = 2;
                  k = ((AddrLSB)/2) % lim;
                  tmplim = k % lim;
                  if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
                }
                if (size == 2)
                {
                  k = 0;
                  tmplim = 0;
                  if(i != 0)
                    Data = Data + 1;
                }
                  TmpData = Data & (Mask[size] << (Shift[size] * k));
                  TmpData = (TmpData) >> (Shift[size] * k);
             }
             else if (chip == 1)
             {
               if (size != 2)
               {
                 if(size == 0)
                 {
                   k = AddrLSB % 2; 
                   tmplim =  k % lim;
                 if(tmplim == 0)
                 {
                   if (i != 0)
                     Data = Data + 1;
                 }
                 TmpData = Data & (Mask[size] << (Shift[size] * k));
                 TmpData = TmpData >> (Shift[size] * k);
                 }
                 else if(size == 1)
                 {
                   tmplim = 0;
                   Data = Data + 1;
                   k = (AddrLSB/2) % 2;
                   TmpData = Data & Mask[size];
                 }  
               }
               else
               {
                 TmpData = ((Data & 0x0000FFFF) |
                            (((Data+1) & 0x0000FFFF) << 16));
                 Data = Data + 2; 
               }
             } 
             else if (chip == 2)
             {
                if (size == 2)
                {
                  TmpData = ((((Data + 3) & 0x00000FF) << 24) |
                            (((Data + 2) & 0x00000FF) << 16)|
                            (((Data + 1) & 0x000000FF)<< 8) |
                              (Data & 0x000000FF));
                  Data = Data + 4;
                }
                else if (size == 1)
                {
                  TmpData = ((((Data + 1) & 0x000000FF) << 8) |
                              (Data & 0x000000FF));
                  Data = Data + 2;
                }
                else
                {
                  TmpData = Data;
                  Data = Data + 1;
                }
             }
             Sequence('r', Addr,trans,"in8",size,TmpData,0);
             if(size == 0)
               Addr = Addr + 1;
             else if(size == 1)
               Addr = Addr + 2;
             else if(size == 2)
               Addr = Addr + 4;
              if (BusyIns == 2)
             {
               transb[0] = 1;
               transb[1] = 5;
               Sequence('r', Addr,transb,"in8",size,0x87654321,0);
             }
          }
         }
         
        Data = 0x11111111;
        if(burst == 7)
        {
          if(size == 0)
          {
            Addr = rand() & 0x00F + 0x0E0;
            TmpLSB = Addr & 0xF;
            TmpLSB = TmpLSB % 4;
            if(csel == 1 && TmpLSB < 2)
               Data = 0x11111111;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111112;
            if(csel == 2)
               Data = 0x11111111 + TmpLSB;
          }  
          else if(size == 1)
          {
            Addr = (rand() & 0x00E) + 0x340;
            TmpLSB = Addr & 0x3;
            if (csel == 1 && TmpLSB < 2)
               Data = 0x11111110;
            else if(csel == 1 && TmpLSB > 1)
               Data = 0x11111111; 
            else if(csel == 2)
            {
             if(TmpLSB == 2) 
               Data = 0x11111113;
             else
               Data = 0x11111111;
            }
          }
          else if(size == 2)
          {
            Addr = (rand() & 0x00C) + 0x280;
          }
          MemAddr = Addr & 0xFFC;
          if(chip == 0)
            MemAddr = MemAddr;
          else if (chip == 1)
            MemAddr = MemAddr << 0x1;
          else
            MemAddr = MemAddr << 0x2;
          Addr = Addr | (chip << 28);
          if(csel == 2 && size == 2)
             AHBWriteMem(csel, MemAddr, 0x40, DataCS0);
          else
             AHBWriteMem(csel, MemAddr, 0x20, DataCS0);
          for (i = 0; i < 16; i++)
          {
            AddrLSB = Addr & 0x0000000F;
            if ( i == 0)
              trans[0] = 2;
            else
              trans[0] = 3;
            trans[1] = 5;
            
            if (chip == 0)
            {
               if(size == 0)
               {
                   tmplim = AddrLSB % 4; 
                   k = AddrLSB % 4;
                   if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
               }
               else if(size == 1)
               {
                  lim = 2;
                  k = ((AddrLSB)/2) % lim;
                  tmplim = k % lim;
                  if (tmplim == 0)
                   {
                     if(i != 0) 
                       Data = Data + 1;
                   }
                }
                if (size == 2)
                {
                  k = 0;
                  tmplim = 0;
                  if(i != 0)
                    Data = Data + 1;
                }
                  TmpData = Data & (Mask[size] << (Shift[size] * k));
                  TmpData = (TmpData) >> (Shift[size] * k);
             }
             else if (chip == 1)
             {
               if (size != 2)
               {
                 if(size == 0)
                 {
                   k = AddrLSB % 2; 
                   tmplim =  k % lim;
                 if(tmplim == 0)
                 {
                   if (i != 0)
                     Data = Data + 1;
                 }
                 TmpData = Data & (Mask[size] << (Shift[size] * k));
                 TmpData = TmpData >> (Shift[size] * k);
                 }
                 else if(size == 1)
                 {
                   tmplim = 0;
                   Data = Data + 1;
                   k = (AddrLSB/2) % 2;
                   TmpData = Data & Mask[size];
                 }  
               }
               else
               {
                 TmpData = ((Data & 0x0000FFFF) |
                            (((Data+1) & 0x0000FFFF) << 16));
                 Data = Data + 2; 
               }
             } 
             else if (chip == 2)
             {
                if (size == 2)
                {
                  TmpData = ((((Data + 3) & 0x00000FF) << 24) |
                            (((Data + 2) & 0x00000FF) << 16)|
                            (((Data + 1) & 0x000000FF)<< 8) |
                              (Data & 0x000000FF));
                  Data = Data + 4;
                }
                else if (size == 1)
                {
                  TmpData = ((((Data + 1) & 0x000000FF) << 8) |
                              (Data & 0x000000FF));
                  Data = Data + 2;
                }
                else
                {
                  TmpData = Data;
                  Data = Data + 1;
                }
             }
             Sequence('r', Addr,trans,"i16",size,TmpData,0);
             if(size == 0)
               Addr = Addr + 1;
             else if(size == 1)
               Addr = Addr + 2;
             else if(size == 2)
               Addr = Addr + 4;
              if (BusyIns == 2)
             {
               transb[0] = 1;
               transb[1] = 5;
               Sequence('r', Addr,transb,"i16",size,0x87654321,0);
             }
          }
        }
      } /* end of size */
    } /* end of csel */
  }/*end of burst */

  C("Perform read with WRAP4");
   C("Reading from bank0 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(0, 0x00, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x0000FF00, ,BURSTROMTest_6);
  ReadData1 = ReadData1 + 1;
  for(i = 2; i < 5; i++)
  {
     k = i % 4;
     if(k == 0)
     ReadData1 = DataCS0;
     TmpRdData = ReadData1 & Bmask[k];
     HSR(, TmpRdData, ,Bmask[k], ,BURSTROMTest_6);
  }
    
  C("Reading from bank0 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(0, 0x20, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x22;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0x00FF0000, ,BURSTROMTest_6);
  ReadData1 = ReadData1 + 1;
  for(i = 3; i < 6; i++)
  {
     k = i % 4;
     if(k == 0)
     ReadData1 = DataCS0;
     TmpRdData = ReadData1 & Bmask[k];
     HSR(, TmpRdData, ,Bmask[k], ,BURSTROMTest_6);
  }

  C("Reading from bank0 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(0, 0x40, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x43;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, ReadData1, ,0xFF000000, ,BURSTROMTest_6);
  ReadData1 = ReadData1 + 1;
  for(i = 4; i < 7; i++)
  {
     k = i % 4;
     if(k == 0)
     ReadData1 = DataCS0;
     TmpRdData = ReadData1 & Bmask[k];
     HSR(, TmpRdData, ,Bmask[k], ,BURSTROMTest_6);
  }
  
  C("Perform read with WRAP8");
   C("Reading from bank0 with burst as WRAP8 and size as BYTE");
   AHBWriteMem(0, 0xD0, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0xD1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x11111111, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(, 0x11111111, ,0x00FF0000, ,BURSTROMTest_7);
  HSR(, 0x11111111, ,0xFF000000, ,BURSTROMTest_8);
  HSR(, 0x11111112, ,0x000000FF, ,BURSTROMTest_9);
  HSR(, 0x11111112, ,0x0000FF00, ,BURSTROMTest_10);
  HSR(, 0x11111112, ,0x00FF0000, ,BURSTROMTest_11);
  HSR(, 0x11111112, ,0xFF000000, ,BURSTROMTest_12);
  HSR(, 0x11111111, ,0x000000FF, ,BURSTROMTest_13);
   
  C("Reading from bank0 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(0, 0x60, 0x20, 0x22222222);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x62;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x22222222, ,0x00FF0000, ,BURSTROMTest_6);
  HSR(, 0x22222222, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x22222223, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x22222223, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x22222223, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x22222223, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x22222222, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x22222222, ,0x0000FF00, ,BURSTROMTest_13);

  C("Reading from bank0 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(0, 0x80, 0x20, 0x33333333);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x83;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x33333333, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x33333334, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x33333334, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x33333334, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x33333334, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x33333333, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x33333333, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x33333333, ,0x00FF0000, ,BURSTROMTest_14);

  C("Reading from bank0 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(0, 0x140, 0x40, 0x33333333);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x143;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x33333333, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x33333334, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x33333334, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x33333334, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x33333334, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x33333335, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x33333335, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x33333335, ,0x00FF0000, ,BURSTROMTest_14);
  HSR(, 0x33333335, ,0xFF000000, ,BURSTROMTest_15);
  HSR(, 0x33333336, ,0x000000FF, ,BURSTROMTest_16);
  HSR(, 0x33333336, ,0x0000FF00, ,BURSTROMTest_17);
  HSR(, 0x33333336, ,0x00FF0000, ,BURSTROMTest_18);
  HSR(, 0x33333336, ,0xFF000000, ,BURSTROMTest_19);
  HSR(, 0x33333333, ,0x000000FF, ,BURSTROMTest_20);
  HSR(, 0x33333333, ,0x0000FF00, ,BURSTROMTest_21);
  HSR(, 0x33333333, ,0x00FF0000, ,BURSTROMTest_22);

  C("Reading from bank0 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(0, 0xA0, 0x40, 0x33333333);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0xA1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x33333333, ,0x0000FF00, ,BURSTROMTest_7);
  HSR(, 0x33333333, ,0x00FF0000, ,BURSTROMTest_8);
  HSR(, 0x33333333, ,0xFF000000, ,BURSTROMTest_9);
  HSR(, 0x33333334, ,0x000000FF, ,BURSTROMTest_10);
  HSR(, 0x33333334, ,0x0000FF00, ,BURSTROMTest_11);
  HSR(, 0x33333334, ,0x00FF0000, ,BURSTROMTest_12);
  HSR(, 0x33333334, ,0xFF000000, ,BURSTROMTest_13);
  HSR(, 0x33333335, ,0x000000FF, ,BURSTROMTest_14);
  HSR(, 0x33333335, ,0x0000FF00, ,BURSTROMTest_15);
  HSR(, 0x33333335, ,0x00FF0000, ,BURSTROMTest_16);
  HSR(, 0x33333335, ,0xFF000000, ,BURSTROMTest_17);
  HSR(, 0x33333336, ,0x000000FF, ,BURSTROMTest_18);
  HSR(, 0x33333336, ,0x0000FF00, ,BURSTROMTest_19);
  HSR(, 0x33333336, ,0x00FF0000, ,BURSTROMTest_20);
  HSR(, 0x33333336, ,0xFF000000, ,BURSTROMTest_21);
  HSR(, 0x33333333, ,0x000000FF, ,BURSTROMTest_22);

  
  C("Perform read with WRAP4");
   C("Reading from bank1 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(1, 0x00, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, 0x11111111, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(, 0x11121111, ,0x00FF0000, ,BURSTROMTest_6);
  HSR(, 0x11121111, ,0xFF000000, ,BURSTROMTest_6);
  HSR(, 0x11111111, ,0x000000FF, ,BURSTROMTest_6);
    
  C("Reading from bank1 with burst as WRAP4 and size as BYTE");
  AHBWriteMem(1, 0x40, 0x20, 0x22222222);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x22;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(,0x22232222, ,0x00FF0000, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0xFF000000, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0x000000FF, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0x0000FF00, ,BURSTROMTest_6);

   C("Reading from bank1 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(1, 0x1C0, 0x20, 0x22222222); 
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0xE3;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(,0x22232222, ,0xFF000000, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0x000000FF, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0x00FF0000, ,BURSTROMTest_6);

  
  C("Perform read with WRAP8");
  C("Reading from bank1 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(1, 0x1E0, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0xF1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x11121111, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(, 0x11121111, ,0x00FF0000, ,BURSTROMTest_7);
  HSR(, 0x11121111, ,0xFF000000, ,BURSTROMTest_8);
  HSR(, 0x11141113, ,0x000000FF, ,BURSTROMTest_9);
  HSR(, 0x11141113, ,0x0000FF00, ,BURSTROMTest_10);
  HSR(, 0x11141113, ,0x00FF0000, ,BURSTROMTest_11);
  HSR(, 0x11141113, ,0xFF000000, ,BURSTROMTest_12);
  HSR(, 0x11121111, ,0x000000FF, ,BURSTROMTest_13);
   
  C("Reading from bank1 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(1, 0x220, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x112;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x11121111, ,0x00FF0000, ,BURSTROMTest_7);
  HSR(, 0x11121111, ,0xFF000000, ,BURSTROMTest_8);
  HSR(, 0x11141113, ,0x000000FF, ,BURSTROMTest_9);
  HSR(, 0x11141113, ,0x0000FF00, ,BURSTROMTest_10);
  HSR(, 0x11141113, ,0x00FF0000, ,BURSTROMTest_11);
  HSR(, 0x11141113, ,0xFF000000, ,BURSTROMTest_12);
  HSR(, 0x11121111, ,0x000000FF, ,BURSTROMTest_13);
  HSR(, 0x11121111, ,0x0000FF00, ,BURSTROMTest_14);

  C("Reading from bank1 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(1, 0x240, 0x20, 0x22222222);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x123;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x22232222, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x22252224, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x22252224, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x22252224, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x22252224, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x22232222, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x22232222, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x22232222, ,0x00FF0000, ,BURSTROMTest_6);

  C("Reading from bank1 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(1, 0x260, 0x20, 0x33333333);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x133;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x33343333, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x33363335, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x33363335, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x33363335, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x33363335, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x33343333, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x33343333, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x33343333, ,0x00FF0000, ,BURSTROMTest_14);


  C("Reading from bank1 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(1, 0x280, 0x40, 0x33333333);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x143;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x33343333, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x33363335, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x33363335, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x33363335, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x33363335, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x33383337, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x33383337, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x33383337, ,0x00FF0000, ,BURSTROMTest_14);
  HSR(, 0x33383337, ,0xFF000000, ,BURSTROMTest_15);
  HSR(, 0x333A3339, ,0x000000FF, ,BURSTROMTest_16);
  HSR(, 0x333A3339, ,0x0000FF00, ,BURSTROMTest_17);
  HSR(, 0x333A3339, ,0x00FF0000, ,BURSTROMTest_18);
  HSR(, 0x333A3339, ,0xFF000000, ,BURSTROMTest_19);
  HSR(, 0x33343333, ,0x000000FF, ,BURSTROMTest_20);
  HSR(, 0x33343333, ,0x0000FF00, ,BURSTROMTest_21);
  HSR(, 0x33343333, ,0x00FF0000, ,BURSTROMTest_22);

  C("Reading from bank1 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(1, 0x2C0, 0x40, 0x33333333);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x161;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x33343333, ,0x0000FF00, ,BURSTROMTest_7);
  HSR(, 0x33343333, ,0x00FF0000, ,BURSTROMTest_8);
  HSR(, 0x33343333, ,0xFF000000, ,BURSTROMTest_9);
  HSR(, 0x33363335, ,0x000000FF, ,BURSTROMTest_10);
  HSR(, 0x33363335, ,0x0000FF00, ,BURSTROMTest_11);
  HSR(, 0x33363335, ,0x00FF0000, ,BURSTROMTest_12);
  HSR(, 0x33363335, ,0xFF000000, ,BURSTROMTest_13);
  HSR(, 0x33383337, ,0x000000FF, ,BURSTROMTest_14);
  HSR(, 0x33383337, ,0x0000FF00, ,BURSTROMTest_15);
  HSR(, 0x33383337, ,0x00FF0000, ,BURSTROMTest_16);
  HSR(, 0x33383337, ,0xFF000000, ,BURSTROMTest_17);
  HSR(, 0x333A3339, ,0x000000FF, ,BURSTROMTest_18);
  HSR(, 0x333A3339, ,0x0000FF00, ,BURSTROMTest_19);
  HSR(, 0x333A3339, ,0x00FF0000, ,BURSTROMTest_20);
  HSR(, 0x333A3339, ,0xFF000000, ,BURSTROMTest_21);
  HSR(, 0x33343333, ,0x000000FF, ,BURSTROMTest_22);

  
  C("Perform read with WRAP4");
   C("Reading from bank2 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(2, 0x300, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0xC1;
  /* burst = WRAP4, sizetype = BYTE */
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(, 0x14131211, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(, 0x14131211, ,0x00FF0000, ,BURSTROMTest_6);
  HSR(, 0x14131211, ,0xFF000000, ,BURSTROMTest_6);
  HSR(, 0x14131211, ,0x000000FF, ,BURSTROMTest_6);
    
  C("Reading from bank2 with burst as WRAP4 and size as BYTE");
  AHBWriteMem(2, 0x340, 0x20, 0x22222222);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0xD2;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(,0x25242322, ,0x00FF0000, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0xFF000000, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0x000000FF, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0x0000FF00, ,BURSTROMTest_6);

   C("Reading from bank2 with burst as WRAP4 and size as BYTE");
   AHBWriteMem(2, 0x380, 0x20, 0x22222222); 
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0xE3;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE);
  HSR(,0x25242322, ,0xFF000000, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0x000000FF, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0x00FF0000, ,BURSTROMTest_6);

  
  C("Perform read with WRAP8");
  C("Reading from bank2 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(2, 0x3C0, 0x10, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0xF1;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x14131211, ,0x0000FF00, ,BURSTROMTest_6);
  HSR(, 0x14131211, ,0x00FF0000, ,BURSTROMTest_7);
  HSR(, 0x14131211, ,0xFF000000, ,BURSTROMTest_8);
  HSR(, 0x18171615, ,0x000000FF, ,BURSTROMTest_9);
  HSR(, 0x18171615, ,0x0000FF00, ,BURSTROMTest_10);
  HSR(, 0x18171615, ,0x00FF0000, ,BURSTROMTest_11);
  HSR(, 0x18171615, ,0xFF000000, ,BURSTROMTest_12);
  HSR(, 0x14131211, ,0x000000FF, ,BURSTROMTest_13);
   
  C("Reading from bank2 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(2, 0xC0, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x32;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x14131211, ,0x00FF0000, ,BURSTROMTest_7);
  HSR(, 0x14131211, ,0xFF000000, ,BURSTROMTest_8);
  HSR(, 0x18171615, ,0x000000FF, ,BURSTROMTest_9);
  HSR(, 0x18171615, ,0x0000FF00, ,BURSTROMTest_10);
  HSR(, 0x18171615, ,0x00FF0000, ,BURSTROMTest_11);
  HSR(, 0x18171615, ,0xFF000000, ,BURSTROMTest_12);
  HSR(, 0x14131211, ,0x000000FF, ,BURSTROMTest_13);
  HSR(, 0x14131211, ,0x0000FF00, ,BURSTROMTest_14);

  C("Reading from bank2 with burst as WRAP8 and size as BYTE");
  AHBWriteMem(2, 0x140, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x53;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, BYTE);
  HSR(, 0x14131211, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x18171615, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x18171615, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x18171615, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x18171615, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x14131211, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x14131211, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x14131211, ,0x00FF0000, ,BURSTROMTest_6);

  C("Reading from bank2 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(2, 0x40, 0x40, 0x33333333);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x13;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x36353433, ,0xFF000000, ,BURSTROMTest_7);
  HSR(, 0x3A393837, ,0x000000FF, ,BURSTROMTest_8);
  HSR(, 0x3A393837, ,0x0000FF00, ,BURSTROMTest_9);
  HSR(, 0x3A393837, ,0x00FF0000, ,BURSTROMTest_10);
  HSR(, 0x3A393837, ,0xFF000000, ,BURSTROMTest_11);
  HSR(, 0x3E3D3C3B, ,0x000000FF, ,BURSTROMTest_12);
  HSR(, 0x3E3D3C3B, ,0x0000FF00, ,BURSTROMTest_13);
  HSR(, 0x3E3D3C3B, ,0x00FF0000, ,BURSTROMTest_14);
  HSR(, 0x3E3D3C3B, ,0xFF000000, ,BURSTROMTest_15);
  HSR(, 0x4241403F, ,0x000000FF, ,BURSTROMTest_16);
  HSR(, 0x4241403F, ,0x0000FF00, ,BURSTROMTest_17);
  HSR(, 0x4241403F, ,0x00FF0000, ,BURSTROMTest_18);
  HSR(, 0x4241403F, ,0xFF000000, ,BURSTROMTest_19);
  HSR(, 0x36353433, ,0x000000FF, ,BURSTROMTest_20);
  HSR(, 0x36353433, ,0x0000FF00, ,BURSTROMTest_21);
  HSR(, 0x36353433, ,0x00FF0000, ,BURSTROMTest_22);

  C("Reading from bank2 with burst as WRAP16 and size as BYTE");
  AHBWriteMem(2, 0x80, 0x40, 0x33333333);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x21;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, BYTE);
  HSR(, 0x36353433, ,0x0000FF00, ,BURSTROMTest_7);
  HSR(, 0x36353433, ,0x00FF0000, ,BURSTROMTest_8);
  HSR(, 0x36353433, ,0xFF000000, ,BURSTROMTest_9);
  HSR(, 0x3A393837, ,0x000000FF, ,BURSTROMTest_10);
  HSR(, 0x3A393837, ,0x0000FF00, ,BURSTROMTest_11);
  HSR(, 0x3A393837, ,0x00FF0000, ,BURSTROMTest_12);
  HSR(, 0x3A393837, ,0xFF000000, ,BURSTROMTest_13);
  HSR(, 0x3E3D3C3B, ,0x000000FF, ,BURSTROMTest_14);
  HSR(, 0x3E3D3C3B, ,0x0000FF00, ,BURSTROMTest_15);
  HSR(, 0x3E3D3C3B, ,0x00FF0000, ,BURSTROMTest_16);
  HSR(, 0x3E3D3C3B, ,0xFF000000, ,BURSTROMTest_17);
  HSR(, 0x4241403F, ,0x000000FF, ,BURSTROMTest_18);
  HSR(, 0x4241403F, ,0x0000FF00, ,BURSTROMTest_19);
  HSR(, 0x4241403F, ,0x00FF0000, ,BURSTROMTest_20);
  HSR(, 0x4241403F, ,0xFF000000, ,BURSTROMTest_21);
  HSR(, 0x36353433, ,0x000000FF, ,BURSTROMTest_22);

  C("Perform read with WRAP4");
   C("Reading from bank0 with burst as WRAP4 and size as HWRD");
   AHBWriteMem(0, 0x00, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x2;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(, 0x11111111, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11111112, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x11111112, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11111111, ,0x0000FFFF, ,BURSTROMTest_6);
    
  C("Reading from bank0 with burst as WRAP4 and size as HWRD");
   AHBWriteMem(0, 0x20, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x24;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(, 0x11111112, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x11111112, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11111111, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x11111111, ,0xFFFF0000, ,BURSTROMTest_6);

  C("Perform read with WRAP8");
   C("Reading from bank0 with burst as WRAP8 and size as HWRD");
   AHBWriteMem(0, 0x00, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x6;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x11111112, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11111113, ,0x0000FFFF, ,BURSTROMTest_7);
  HSR(, 0x11111113, ,0xFFFF0000, ,BURSTROMTest_8);
  HSR(, 0x11111114, ,0x0000FFFF, ,BURSTROMTest_9);
  HSR(, 0x11111114, ,0xFFFF0000, ,BURSTROMTest_10);
  HSR(, 0x11111111, ,0x0000FFFF, ,BURSTROMTest_11);
  HSR(, 0x11111111, ,0xFFFF0000, ,BURSTROMTest_12);
  HSR(, 0x11111112, ,0x0000FFFF, ,BURSTROMTest_13);
   
  C("Reading from bank0 with burst as WRAP8 and size as HWRD");
  AHBWriteMem(0, 0x40, 0x20, 0x11111111);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x48;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x11111113, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x11111113, ,0xFFFF0000, ,BURSTROMTest_7);
  HSR(, 0x11111114, ,0x0000FFFF, ,BURSTROMTest_8);
  HSR(, 0x11111114, ,0xFFFF0000, ,BURSTROMTest_9);
  HSR(, 0x11111111, ,0x0000FFFF, ,BURSTROMTest_10);
  HSR(, 0x11111111, ,0xFFFF0000, ,BURSTROMTest_11);
  HSR(, 0x11111112, ,0x0000FFFF, ,BURSTROMTest_12);
  HSR(, 0x11111112, ,0xFFFF0000, ,BURSTROMTest_13);


  C("Reading from bank0 with burst as WRAP16 and size as HWRD");
  AHBWriteMem(0, 0x2C0, 0x40, 0x33333333);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x2C4;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, HWRD);
  HSR(, 0x33333334, ,0x0000FFFF, ,BURSTROMTest_7);
  HSR(, 0x33333334, ,0xFFFF0000, ,BURSTROMTest_8);
  HSR(, 0x33333335, ,0x0000FFFF, ,BURSTROMTest_9);
  HSR(, 0x33333335, ,0xFFFF0000, ,BURSTROMTest_10);
  HSR(, 0x33333336, ,0x0000FFFF, ,BURSTROMTest_11);
  HSR(, 0x33333336, ,0xFFFF0000, ,BURSTROMTest_12);
  HSR(, 0x33333337, ,0x0000FFFF, ,BURSTROMTest_13);
  HSR(, 0x33333337, ,0xFFFF0000, ,BURSTROMTest_14);
  HSR(, 0x33333338, ,0x0000FFFF, ,BURSTROMTest_15);
  HSR(, 0x33333338, ,0xFFFF0000, ,BURSTROMTest_16);
  HSR(, 0x33333339, ,0x0000FFFF, ,BURSTROMTest_17);
  HSR(, 0x33333339, ,0xFFFF0000, ,BURSTROMTest_18);
  HSR(, 0x3333333A, ,0x0000FFFF, ,BURSTROMTest_19);
  HSR(, 0x3333333A, ,0xFFFF0000, ,BURSTROMTest_20);
  HSR(, 0x33333333, ,0x0000FFFF, ,BURSTROMTest_21);
  HSR(, 0x33333333, ,0xFFFF0000, ,BURSTROMTest_22);

  C("Reading from bank0 with burst as WRAP16 and size as HWRD");
  AHBWriteMem(0, 0x80, 0x40, 0x33333333);
  MemAddr = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + 0x86;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, HWRD);
  HSR(, 0x33333334, ,0xFFFF0000, ,BURSTROMTest_7);
  HSR(, 0x33333335, ,0x0000FFFF, ,BURSTROMTest_8);
  HSR(, 0x33333335, ,0xFFFF0000, ,BURSTROMTest_9);
  HSR(, 0x33333336, ,0x0000FFFF, ,BURSTROMTest_10);
  HSR(, 0x33333336, ,0xFFFF0000, ,BURSTROMTest_11);
  HSR(, 0x33333337, ,0x0000FFFF, ,BURSTROMTest_12);
  HSR(, 0x33333337, ,0xFFFF0000, ,BURSTROMTest_13);
  HSR(, 0x33333338, ,0x0000FFFF, ,BURSTROMTest_14);
  HSR(, 0x33333338, ,0xFFFF0000, ,BURSTROMTest_15);
  HSR(, 0x33333339, ,0x0000FFFF, ,BURSTROMTest_16);
  HSR(, 0x33333339, ,0xFFFF0000, ,BURSTROMTest_17);
  HSR(, 0x3333333A, ,0x0000FFFF, ,BURSTROMTest_18);
  HSR(, 0x3333333A, ,0xFFFF0000, ,BURSTROMTest_19);
  HSR(, 0x33333333, ,0x0000FFFF, ,BURSTROMTest_20);
  HSR(, 0x33333333, ,0xFFFF0000, ,BURSTROMTest_21);
  HSR(, 0x33333334, ,0x0000FFFF, ,BURSTROMTest_22);

  
  C("Perform read with WRAP4");
   C("Reading from bank1 with burst as WRAP4 and size as HWRD");
   AHBWriteMem(1, 0x00, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x2;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(, 0x11121111, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11141113, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x11141113, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11121111, ,0x0000FFFF, ,BURSTROMTest_6);
    
  C("Reading from bank1 with burst as WRAP4 and size as HWRD");
  AHBWriteMem(1, 0x40, 0x20, 0x22222222);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x20;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(,0x22232222, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(,0x22232222, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(,0x22252224, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(,0x22252224, ,0xFFFF0000, ,BURSTROMTest_6);

  
  C("Perform read with WRAP8");
  C("Reading from bank1 with burst as WRAP8 and size as HWRD");
  AHBWriteMem(1, 0x00, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x2;
  /* burst = WRAP8, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x11121111, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x11141113, ,0x0000FFFF, ,BURSTROMTest_7);
  HSR(, 0x11141113, ,0xFFFF0000, ,BURSTROMTest_8);
  HSR(, 0x11161115, ,0x0000FFFF, ,BURSTROMTest_9);
  HSR(, 0x11161115, ,0xFFFF0000, ,BURSTROMTest_10);
  HSR(, 0x11181117, ,0x0000FFFF, ,BURSTROMTest_11);
  HSR(, 0x11181117, ,0xFFFF0000, ,BURSTROMTest_12);
  HSR(, 0x11121111, ,0x0000FFFF, ,BURSTROMTest_13);
   
  C("Reading from bank1 with burst as WRAP8 and size as HWRD");
  AHBWriteMem(1, 0x60, 0x20, 0x11111111);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x30;
  /* burst = WRAP4, sizetype = BYTE */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x11121111, ,0x0000FFFF, ,BURSTROMTest_7);
  HSR(, 0x11121111, ,0xFFFF0000, ,BURSTROMTest_8);
  HSR(, 0x11141113, ,0x0000FFFF, ,BURSTROMTest_9);
  HSR(, 0x11141113, ,0xFFFF0000, ,BURSTROMTest_10);
  HSR(, 0x11161115, ,0x0000FFFF, ,BURSTROMTest_11);
  HSR(, 0x11161115, ,0xFFFF0000, ,BURSTROMTest_12);
  HSR(, 0x11181117, ,0x0000FFFF, ,BURSTROMTest_13);
  HSR(, 0x11181117, ,0xFFFF0000, ,BURSTROMTest_14);


  C("Reading from bank1 with burst as WRAP16 and size as HWRD");
  AHBWriteMem(1, 0x200, 0x40, 0x33333333);
  MemAddr = MEM1_BASE + (MPMCTrMEMBData[0] << 11) + 0x106;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, HWRD);
  HSR(, 0x33363335, ,0xFFFF0000, ,BURSTROMTest_7);
  HSR(, 0x33383337, ,0x0000FFFF, ,BURSTROMTest_8);
  HSR(, 0x33383337, ,0xFFFF0000, ,BURSTROMTest_9);
  HSR(, 0x333A3339, ,0x0000FFFF, ,BURSTROMTest_10);
  HSR(, 0x333A3339, ,0xFFFF0000, ,BURSTROMTest_11);
  HSR(, 0x333C333B, ,0x0000FFFF, ,BURSTROMTest_12);
  HSR(, 0x333C333B, ,0xFFFF0000, ,BURSTROMTest_13);
  HSR(, 0x333E333D, ,0x0000FFFF, ,BURSTROMTest_14);
  HSR(, 0x333E333D, ,0xFFFF0000, ,BURSTROMTest_15);
  HSR(, 0x3340333F, ,0x0000FFFF, ,BURSTROMTest_16);
  HSR(, 0x3340333F, ,0xFFFF0000, ,BURSTROMTest_17);
  HSR(, 0x33423341, ,0x0000FFFF, ,BURSTROMTest_18);
  HSR(, 0x33423341, ,0xFFFF0000, ,BURSTROMTest_19);
  HSR(, 0x33343333, ,0x0000FFFF, ,BURSTROMTest_20);
  HSR(, 0x33343333, ,0xFFFF0000, ,BURSTROMTest_21);
  HSR(, 0x33363335, ,0x0000FFFF, ,BURSTROMTest_22);

  /* Updated till here */
  C("Perform read with WRAP4");
   C("Reading from bank2 with burst as WRAP4 and size as HWRD");
   AHBWriteMem(2, 0x00, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x2;
  /* burst = WRAP4, sizetype = HWRD */
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(, 0x14131211, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x18171615, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(, 0x18171615, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(, 0x14131211, ,0x0000FFFF, ,BURSTROMTest_6);
    
  C("Reading from bank2 with burst as WRAP4 and size as HWRD");
  AHBWriteMem(2, 0x40, 0x20, 0x22222222);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x10;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD);
  HSR(,0x25242322, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(,0x25242322, ,0xFFFF0000, ,BURSTROMTest_6);
  HSR(,0x29282726, ,0x0000FFFF, ,BURSTROMTest_6);
  HSR(,0x29282726, ,0xFFFF0000, ,BURSTROMTest_6);

  C("Perform read with WRAP8");
  C("Reading from bank2 with burst as WRAP8 and size as HWRD");
  AHBWriteMem(2, 0x100, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x42;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x14131211, ,0xFFFF0000, ,BURSTROMTest_7);
  HSR(, 0x18171615, ,0x0000FFFF, ,BURSTROMTest_8);
  HSR(, 0x18171615, ,0xFFFF0000, ,BURSTROMTest_9);
  HSR(, 0x1C1B1A19, ,0x0000FFFF, ,BURSTROMTest_A);
  HSR(, 0x1C1B1A19, ,0xFFFF0000, ,BURSTROMTest_B);
  HSR(, 0x201F1E1D, ,0x0000FFFF, ,BURSTROMTest_C);
  HSR(, 0x201F1E1D, ,0xFFFF0000, ,BURSTROMTest_D);
  HSR(, 0x14131211, ,0xFFFF0000, ,BURSTROMTest_E);
   
  C("Reading from bank2 with burst as WRAP8 and size as HWRD");
  AHBWriteMem(2, 0xC0, 0x20, 0x11111111);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x34;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP8, OK, HWRD);
  HSR(, 0x18171615, ,0x0000FFFF, ,BURSTROMTest_9);
  HSR(, 0x18171615, ,0xFFFF0000, ,BURSTROMTest_10);
  HSR(, 0x1C1B1A19, ,0x0000FFFF, ,BURSTROMTest_11);
  HSR(, 0x1C1B1A19, ,0xFFFF0000, ,BURSTROMTest_12);
  HSR(, 0x201F1E1D, ,0x0000FFFF, ,BURSTROMTest_13);
  HSR(, 0x201F1E1D, ,0xFFFF0000, ,BURSTROMTest_14);
  HSR(, 0x14131211, ,0x0000FFFF, ,BURSTROMTest_7);
  HSR(, 0x14131211, ,0xFFFF0000, ,BURSTROMTest_8);

  C("Reading from bank2 with burst as WRAP16 and size as HWRD");
  AHBWriteMem(2, 0x200, 0x40, 0x33333333);
  MemAddr = MEM2_BASE + (MPMCTrMEMBData[0] << 11) + 0x82;
  /* burst = WRAP4, sizetype = HWRD */
  ReadData1 = DataCS0;
  HSA(MemAddr, NSEQ, WRAP16, OK, HWRD);
  HSR(, 0x36353433, ,0xFFFF0000, ,BURSTROMTest_8);
  HSR(, 0x3A393837, ,0x0000FFFF, ,BURSTROMTest_8);
  HSR(, 0x3A393837, ,0xFFFF0000, ,BURSTROMTest_9);
  HSR(, 0x3E3D3C3B, ,0x0000FFFF, ,BURSTROMTest_12);
  HSR(, 0x3E3D3C3B, ,0xFFFF0000, ,BURSTROMTest_13);
  HSR(, 0x4241403F, ,0x0000FFFF, ,BURSTROMTest_16);
  HSR(, 0x4241403F, ,0xFFFF0000, ,BURSTROMTest_17);
  HSR(, 0x46454443, ,0x0000FFFF, ,BURSTROMTest_20);
  HSR(, 0x46454443, ,0xFFFF0000, ,BURSTROMTest_20);
  HSR(, 0x4A494847, ,0x0000FFFF, ,BURSTROMTest_21);
  HSR(, 0x4A494847, ,0xFFFF0000, ,BURSTROMTest_21);
  HSR(, 0x4E4D4C4B, ,0x0000FFFF, ,BURSTROMTest_21);
  HSR(, 0x4E4D4C4B, ,0xFFFF0000, ,BURSTROMTest_21);
  HSR(, 0x5251504F, ,0x0000FFFF, ,BURSTROMTest_21);
  HSR(, 0x5251504F, ,0xFFFF0000, ,BURSTROMTest_21);
  HSR(, 0x36353433, ,0x0000FFFF, ,BURSTROMTest_22);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
}
/*-- --================================ End ================================--*/
