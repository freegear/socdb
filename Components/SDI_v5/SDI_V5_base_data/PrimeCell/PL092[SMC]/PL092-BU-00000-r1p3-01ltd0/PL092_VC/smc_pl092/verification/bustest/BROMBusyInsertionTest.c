/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : BROMBusyInsertionTest.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC with
--           different types of BURST ROMs connected to different banks.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void BROMBusyInsertionTest()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  Does the Burst read and write transactions by inserting busy at random 
        places
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE and HBURST values
  */

  int i, k, BusyCnt, Address, LoBits;
  int WST1, WST2, Burst, Bound, idlest;
  int chip, temp, QWStart;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 Addr;
  int32 data;
  int trans1[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans2[7] = {2,1,3,3,3,1,5};
  int trans3[12] = {2,3,3,1,1,3,3,3,1,3,0,5};
  int trans4[7] = {2,0,2,3,3,1,5};
  int trans5[10] = {2,1,2,1,1,3,1,3,1,5};
  int trans6[17] = {2,0,0,2,1,0,2,1,2,1,3,3,1,3,2,1,5};
  int trans7[29] = {2,3,0,2,3,3,1,3,1,3,3,3,3,1,1,1,1,3,1,3,1,3,3,3,1,1,3,1,5};
  int trans[128];
  int trans8[29] = {2,3,1,1,3,3,1,3,1,3,1,3,3,1,3,1,1,1,3,3,3,3,1,3,1,3,3,1,5};
  int trans9[18] = {2,3,1,3,1,1,3,1,3,1,1,3,1,1,3,1,3,5};
  char PrintStr[128];
  char* SizeStr[7] = {"WRD","HWRD", "BYTE","HWRD", "WRD","HWRD","HWRD"};


C(" Configure the memory");

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x000000A0, 0x000000,
                  0x000000);
     ConfigureUUT(0, 0x02, 0x00, 0x04, 0x00, 0x00, 0x00000020, 0x000000,
                  0x000000);
     ConfigureUUT(6, 0x01, 0x16, 0x02, 0x00, 0x00, 0x00000060, 0x000000,
                  0x000000);

   
    C("INCR BURST");

     MemAddr = SMCMEM_1 + 0x120 * 0x00; 
     HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0xAABBCCDD);
     HSA(MemAddr+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0xBBCCDDEE);
     HSA(MemAddr+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x10000000);
     HSA(MemAddr+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x22222222);
     HSA(MemAddr+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0xCCDDEEFF);
     HSA(MemAddr+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x11223344);
     HSA(MemAddr+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x20000000);
     HSA(MemAddr+8, SEQ, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x555C5555);
     HSA(MemAddr+12, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x11111111);
     HSA(MemAddr+12, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x22222222);
     HSA(MemAddr+12, SEQ, INCR, , WRD, , 0x1, , , , ,);
     HSW( , 0x55588555);


  /** Reading back the data **/
     HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
     HSR( , 0xAABBCCDD, , NoMask, ,TransferTests_21);
     HSA(MemAddr+4, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_21);
     HSR( , 0xCCDDEEFF, , NoMask, ,TransferTests_22);
     HSA(MemAddr+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSR( , 0x555C5555, , NoMask, ,TransferTests_22);
     HSA(MemAddr+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSR( , 0x555C5555, , NoMask, ,TransferTests_22);
     HSA(MemAddr+8, BUSY, INCR, , WRD, , 0x1, , , , ,);
     HSR( , 0x555C5555, , NoMask, ,TransferTests_22);
     HSR( , 0x555C5555, , NoMask, ,TransferTests_22);
     HSR( , 0x55588555, , NoMask, ,TransferTests_22);

    
data = 0x44444444;

  C("INCR4 burst termination and rebuild");

  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {

      C("INCR4 Burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x120 * 0x00;
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 16;
      if (Bound > 1024)
        Address = Address - 16;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR4, data, BusyCnt, i-1, 1, 0, 0,0);
      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 4 - i, INCR4, data, 0, 0, 0, 0, 0,1);

      data = 0x44444444;
      /* Check data through reads */
      WordRd(Address, 4, INCR4, data,idlest);
    }
  }
 


("INCR burst termination and rebuild");

  for (k = 0; k < 2; k++)
  {
    for (i = 1; i < 6; i ++)
    {
      C("INCR burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x520 * 0x00;
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 24;
      if (Bound > 1024)
        Address = Address - 24;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 6 - i, INCR, data, 0, 0, 0, 0, 0,1);

      data = 0x44444444;
      /* Check data through reads */
      WordRd(Address, 6, INCR, data,idlest);
    }
  }

  C("INCR8 burst termination and rebuild");

  for (k = 0; k < 2; k++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("INCR8 burst termination ");
      data = 0x55555555;
      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x420 * 0x00;

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 32;
      if (Bound > 1024)
        Address = Address - 32;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;
      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR8, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 8 - i, INCR8, data, 0, 0, 0, 0, 0,1);
      data = 0x55555555;
      /* Check data through reads */
      WordRd(Address, 8, INCR8, data,idlest);
    }
  }
  C("INCR16 burst termination and rebuild");

  data = 0x66666666;
  for (k = 0; k < 2; k++)
  {
    for (i = 1; i < 3; i ++)
    {
      C("INCR16 burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x120 * 0x00;
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 64;
      if (Bound > 1024)
        Address = Address - 64;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR16, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 16 - i, INCR16, data, 0, 0, 0, 0, 0,1);

      data = 0x66666666;
      /* Check data through reads */
      WordRd(Address, 16, INCR16, data,idlest);
    }
  }

  C("WRAP4 burst termination and rebuild");

  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP4 Burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x120 * 0x00;
       temp = 0;
      Address = Address + (4*temp);
      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP4, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 4)
      {
        /* Burst was interrupted before the address wrapped around */

        WordTrans(Address + (4*i), 4-temp-i, WRAP4, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP4, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-4),(4 - i),WRAP4,data, 0, 0, 0,0,0,1);
      }

      data = 0x66666666;
      /* Check data through reads */
      WordRd(Address, 4, WRAP4, data,idlest);
    }
  }

  C("WRAP8 burst termination and rebuild");

  data = 0x77777777;
  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP8 burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x620 * 0x00;
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = 0;
      Address = Address + (4*temp);

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP8, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 8)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 8-temp-i, WRAP8, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP8, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-8),(8 - i),WRAP8,data, 0, 0, 0,0,0,1);
      }

      data = 0x77777777;
      /* Check data through reads */
      WordRd(Address, 8, WRAP8, data,idlest);
    }
  }

 C("WRAP16 burst termination and rebuild");

  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP16 burst termination ");

      /* Generate a random address and align it with a QW address */
      Address = SMCMEM_1 + 0x120 * 0x00;
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = 0;
      Address = Address + (4*temp);

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP16, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if (temp + i <= 16)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 16-temp-i,WRAP16, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP16, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
       /* Burst was interrupted after the address wrapped around */
     WordTrans(QWStart+4*(temp+i-16), (16 - i),WRAP16, data, 0, 0,0, 0,0,1);
      }

      data = 0x77777777;
      /* Check data through reads */
      WordRd(Address, 16, WRAP16, data,idlest);
    }
  }

 C("Insert Busy for CS1");
  Address = SMCMEM_1 + 0x120 * 0x00;
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSW(,0x22222222);
  HSA(Address+1, BUSY, INCR, OK, BYTE);
  HSW(,0x33333333);
  HSA(Address+1, SEQ, INCR, OK, BYTE);
  HSW(,0x44444444);
  HSA(Address+2, BUSY, INCR, OK, BYTE);
  HSW(,0x55555555);
  HSA(Address+2, SEQ, INCR, OK, BYTE);
  HSW(,0x66666666);
  HSA(Address+3, SEQ, INCR, OK, BYTE);
  HSW(,0x77777777);
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR(, 0x22222222, ,0x000000FF);
  HSA(Address+1, BUSY, INCR, OK, BYTE);
  HSR(,0x44444444, ,MaskAll);
  HSA(Address+1, SEQ, INCR, OK, BYTE);
  HSR(,0x44444444, ,0x0000FF00);
  HSA(Address+2, BUSY, INCR, OK, BYTE);
  HSR(,0x66666666, ,MaskAll);
  HSA(Address+2, SEQ, INCR, OK, BYTE);
  HSR(,0x66666666, ,0x00FF0000);
  HSA(Address+3, BUSY, INCR, OK, BYTE);
  HSR(,0x77777777, ,MaskAll);
  HSA(Address+3, SEQ, INCR, OK, BYTE);
  HSR(,0x77777777, ,0xFF000000);

  C("Insert Busy for 32 bit Memory device");
  Address = SMCMEM_1 + 0x420 * 0x00;

  Sequence('w',Address, trans8,"inc",2,0x66666666,0);
  Sequence('r',Address, trans8,"inc",2,0x66666666,0);
  Sequence('w',Address+64, trans8,"inc",1,0x40000001,0);
  Sequence('r',Address+64, trans8,"inc",1,0x40000001,0);
  Sequence('w',Address+44, trans8,"inc",0,0x80000002,0);
  Sequence('r',Address+44, trans8,"inc",0,0x80000002,0);
  Sequence('w',Address, trans8,"in4",1,0x55667788,0);
  Sequence('r',Address, trans8,"in4",1,0x55667788,0);
  Address = SMCMEM_1 + 0x520 * 0x62;
  Sequence('w',Address, trans8,"in4",2,0x22222222,0);
  Sequence('r',Address, trans8,"in4",2,0x22222222,0);
  Sequence('w',Address+4, trans8,"in4",0,0x55557777,0);
  Sequence('r',Address+4, trans8,"in4",0,0x55557777,0);
  Address = SMCMEM_1 + 0x640 * 0x44;
  Sequence('w',Address, trans8,"in8",2,0x88222288,0);
  Sequence('r',Address, trans8,"in8",2,0x88222288,0);
  Sequence('w',Address+4, trans8,"in8",0,0x85557777,0);
  Sequence('r',Address+4, trans8,"in8",0,0x85557777,0);
  Sequence('w',Address+34, trans8,"in8",1,0x80000077,0);
  Sequence('r',Address+34, trans8,"in8",1,0x80000077,0);
  Address = SMCMEM_1 + 0x440 * 0x84;
  Sequence('w',Address, trans8,"i16",2,0x66222266,0);
  Sequence('r',Address, trans8,"i16",2,0x66222266,0);
  Sequence('w',Address+4, trans8,"i16",0,0x65557777,0);
  Sequence('r',Address+4, trans8,"i16",0,0x65557777,0);
  Sequence('w',Address+34, trans8,"i16",1,0x60000077,0);
  Sequence('r',Address+34, trans8,"i16",1,0x60000077,0);
  Address = SMCMEM_1 + 0x100 * 0x00;
  Sequence('w',Address, trans5,"wr4",2,0x46222246,0);
  Sequence('r',Address, trans5,"wr4",2,0x46222246,0);
  Sequence('w',Address, trans5,"wr4",0,0x65544777,0);
  Sequence('r',Address, trans5,"wr4",0,0x65544777,0);
  Sequence('w',Address, trans5,"wr4",1,0x60044474,0);
  Sequence('r',Address, trans5,"wr4",1,0x60044474,0);
  
  Address = SMCMEM_1 + 0x100 * 0x00;
  Sequence('w',Address, trans9,"wr8",0,0xAAAAAA00,0);
  Sequence('r',Address, trans9,"wr8",0,0xAAAAAA00,0);
  Address = SMCMEM_1 + 0x4C0 * 0x00;
  Sequence('w',Address, trans9,"wr8",2,0x10000004,0);
  Sequence('r',Address, trans9,"wr8",2,0x10000004,0);
  Address = SMCMEM_1 + 0x600 * 0x00;
  Sequence('w',Address, trans9,"wr8",1,0xBCAAAAAA,0);
  Sequence('r',Address, trans9,"wr8",1,0xBCAAAAAA,0);

  Address = SMCMEM_1 + 0x100 * 0x00;
  Sequence('w',Address, trans8,"w16",0,0xAAAAAA00,0);
  Sequence('r',Address, trans8,"w16",0,0xAAAAAA00,0);
  Address = SMCMEM_1 + 0x4C0 * 0x00;
  Sequence('w',Address, trans8,"w16",2,0x10000004,0);
  Sequence('r',Address, trans8,"w16",2,0x10000004,0);
  Address = SMCMEM_1 + 0x600 * 0x00;
  Sequence('w',Address, trans8,"w16",1,0xBCAAAAAA,0);
  Sequence('r',Address, trans8,"w16",1,0xBCAAAAAA,0);

  C("Insert Busy for 16 bit Memory device");

Address = SMCMEM_0 + 0x620 * 0xFF;

  Sequence('w',Address, trans8,"inc",2,0x36666663,0);
  Sequence('r',Address, trans8,"inc",2,0x36666663,0);
  Sequence('w',Address+64, trans8,"inc",1,0x43300301,0);
  Sequence('r',Address+64, trans8,"inc",1,0x43300301,0);
  Sequence('w',Address+44, trans8,"inc",0,0x55300002,0);
  Sequence('r',Address+44, trans8,"inc",0,0x55300002,0);
  Sequence('w',Address, trans8,"in4",1,0xAA6677BB,0);
  Sequence('r',Address, trans8,"in4",1,0xAA6677BB,0);
  Address = SMCMEM_0 + 0x1AE * 0x28;
  Sequence('w',Address, trans8,"in4",2,0x22334422,0);
  Sequence('r',Address, trans8,"in4",2,0x22334422,0);
  Sequence('w',Address+24, trans8,"in4",0,0xCC5577CC,0);
  Sequence('r',Address+24, trans8,"in4",0,0xCC5577CC,0);
  Address = SMCMEM_0 + 0x640 * 0x34;
  Sequence('w',Address, trans8,"in8",2,0x88222288,0);
  Sequence('r',Address, trans8,"in8",2,0x88222288,0);
  Sequence('w',Address+4, trans8,"in8",0,0xDDDD7766,0);
  Sequence('r',Address+4, trans8,"in8",0,0xDDDD7766,0);
  Sequence('w',Address+34, trans8,"in8",1,0x80CC0077,0);
  Sequence('r',Address+34, trans8,"in8",1,0x80CC0077,0);
  Address = SMCMEM_0 + 0x4E0 * 0xFF;
  Sequence('w',Address, trans8,"i16",2,0x12342266,0);
  Sequence('r',Address, trans8,"i16",2,0x12342266,0);
  Sequence('w',Address+4, trans8,"i16",0,0x34567777,0);
  Sequence('r',Address+4, trans8,"i16",0,0x34567777,0);
  Sequence('w',Address+34, trans8,"i16",1,0x55002077,0);
  Sequence('r',Address+34, trans8,"i16",1,0x55002077,0);
  Address = SMCMEM_0 + 0x100 * 0x00;
  Sequence('w',Address, trans5,"wr4",2,0x46AAA246,0);
  Sequence('r',Address, trans5,"wr4",2,0x46AAA246,0);
  Sequence('w',Address, trans5,"wr4",0,0x65BBB777,0);
  Sequence('r',Address, trans5,"wr4",0,0x65BBB777,0);
  Sequence('w',Address, trans5,"wr4",1,0x60E4E474,0);
  Sequence('r',Address, trans5,"wr4",1,0x60E4E474,0);

  Address = SMCMEM_0 + 0x5B0 * 0x00;
  Sequence('w',Address, trans9,"wr8",0,0xAABBCC00,0);
  Sequence('r',Address, trans9,"wr8",0,0xAABBCC00,0);
  Address = SMCMEM_0 + 0x4C0 * 0x00;
  Sequence('w',Address, trans9,"wr8",2,0x10066004,0);
  Sequence('r',Address, trans9,"wr8",2,0x10066004,0);
  Address = SMCMEM_0 + 0x600 * 0x00;
  Sequence('w',Address, trans9,"wr8",1,0xBCAAFFAA,0);
  Sequence('r',Address, trans9,"wr8",1,0xBCAAFFAA,0);

  Address = SMCMEM_0 + 0x360 * 0x00;
  Sequence('w',Address, trans8,"w16",0,0xAAAAAA00,0);
  Sequence('r',Address, trans8,"w16",0,0xAAAAAA00,0);
  Address = SMCMEM_0 + 0x4C0 * 0x00;
  Sequence('w',Address, trans8,"w16",2,0x10000004,0);
  Sequence('r',Address, trans8,"w16",2,0x10000004,0);
  Address = SMCMEM_0 + 0x220 * 0x00;
  Sequence('w',Address, trans8,"w16",1,0xBCAAAAAA,0);
  Sequence('r',Address, trans8,"w16",1,0xBCAAAAAA,0);


 C("Insert Busy for 8 bit device");
Address = SMCMEM_6 + 0x2FC * 0x00;

  Sequence('w',Address, trans8,"inc",2,0xFF66FF63,0);
  Sequence('r',Address, trans8,"inc",2,0xFF66FF63,0);
  Sequence('w',Address+64, trans8,"inc",1,0xEF30CF01,0);
  Sequence('r',Address+64, trans8,"inc",1,0xEF30CF01,0);
  Sequence('w',Address+44, trans8,"inc",0,0xD5000082,0);
  Sequence('r',Address+44, trans8,"inc",0,0xD5000082,0);
  Sequence('w',Address, trans8,"in4",1,0xAA0074BB,0);
  Sequence('r',Address, trans8,"in4",1,0xAA0074BB,0);
  Address = SMCMEM_0 + 0x2FC * 0xFF;
  Sequence('w',Address, trans8,"in4",2,0x88334422,0);
  Sequence('r',Address, trans8,"in4",2,0x88334422,0);
  Sequence('w',Address+24, trans8,"in4",0,0xCC5577EC,0);
  Sequence('r',Address+24, trans8,"in4",0,0xCC5577EC,0);
  Address = SMCMEM_0 + 0x6AC * 0x64;
  Sequence('w',Address, trans8,"in8",2,0x88E222EE,0);
  Sequence('r',Address, trans8,"in8",2,0x88E222EE,0);
  Sequence('w',Address+4, trans8,"in8",0,0x5D5D7766,0);
  Sequence('r',Address+4, trans8,"in8",0,0x5D5D7766,0);
  Sequence('w',Address+34, trans8,"in8",1,0x80CC00A7,0);
  Sequence('r',Address+34, trans8,"in8",1,0x80CC00A7,0);
  Address = SMCMEM_0 + 0x8A0 * 0xFF;
  Sequence('w',Address, trans8,"i16",2,0x123422F6,0);
  Sequence('r',Address, trans8,"i16",2,0x123422F6,0);
  Sequence('w',Address+4, trans8,"i16",0,0x3456FE77,0);
  Sequence('r',Address+4, trans8,"i16",0,0x3456FE77,0);
  Sequence('w',Address+34, trans8,"i16",1,0x55002147,0);
  Sequence('r',Address+34, trans8,"i16",1,0x55002147,0);
  Address = SMCMEM_0 + 0x4A0 * 0x00;
  Sequence('w',Address, trans5,"wr4",2,0x40AAACC6,0);
  Sequence('r',Address, trans5,"wr4",2,0x40AAACC6,0);
  Sequence('w',Address, trans5,"wr4",0,0x65BBB7F7,0);
  Sequence('r',Address, trans5,"wr4",0,0x65BBB7F7,0);
  Sequence('w',Address, trans5,"wr4",1,0x10E4E474,0);
  Sequence('r',Address, trans5,"wr4",1,0x10E4E474,0);

  Address = SMCMEM_0 + 0x560 * 0x00;
  Sequence('w',Address, trans9,"wr8",0,0x5ABBCC00,0);
  Sequence('r',Address, trans9,"wr8",0,0x5ABBCC00,0);
  Address = SMCMEM_0 + 0x4C0 * 0x00;
  Sequence('w',Address, trans9,"wr8",2,0x10023404,0);
  Sequence('r',Address, trans9,"wr8",2,0x10023404,0);
  Address = SMCMEM_0 + 0x600 * 0x00;
  Sequence('w',Address, trans9,"wr8",1,0xBC00FFAA,0);
  Sequence('r',Address, trans9,"wr8",1,0xBC00FFAA,0);

  Address = SMCMEM_0 + 0x360 * 0x00;
  Sequence('w',Address, trans8,"w16",0,0xAABCDE00,0);
  Sequence('r',Address, trans8,"w16",0,0xAABCDE00,0);
  Address = SMCMEM_0 + 0x4C0 * 0x00;
  Sequence('w',Address, trans8,"w16",2,0x10567004,0);
  Sequence('r',Address, trans8,"w16",2,0x10567004,0);
  Address = SMCMEM_0 + 0x220 * 0x00;
  Sequence('w',Address, trans8,"w16",1,0xBCAAEFAA,0);
  Sequence('r',Address, trans8,"w16",1,0xBCAAEFAA,0);

}


/************************************ End *************************************/
