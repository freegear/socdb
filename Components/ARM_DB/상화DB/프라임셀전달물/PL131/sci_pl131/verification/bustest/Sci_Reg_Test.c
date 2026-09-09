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
--  File Name              : Sci_Reg_Test.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--  
------------------------------------------------------------------------------*/

/*******************************************************************************
   Purpose : This file has the function Reg_Test
             which may be called in the main file Sci.c
*******************************************************************************/

void Reg_Test()
{
/*
 
  Summary : Register Tests
  ========================
 
 The register tests check the following functionality
 
 o  Reset value test: Checking the initial value of each register bit
    just after reset.
 o  Read/write test: First write '1' to all bits of the
    read/writable registers, read back and compare with expected value of
    '1' in all bit positions. Repeat with bit value of '0'.
 o  Read only test: Write a bit pattern that is different from the Reset
    value of each register, read back and ensure that the Reset values are
    returned instead of the just written pattern. This confirms that the
    registers are indeed read only registers.
*/

RES(LOW,0x1,0x1);
PI(0x02);
 
C("Reset value tests");

PSR(0x00000000, 0x0000FFFF, SCIDATA,       scidata);
PSR(0x00000000, 0x0000FFFF, SCICR0,        scicr0);
PSR(0x00000000, 0x0000FFFF, SCICR1,        scicr1);
PSR(0x00000000, 0x0000FFFF, SCICR2,        scicr2);
PSR(0x00000000, 0x0000FFFF, SCICLKICC,     sciclkicc);
PSR(0x00000000, 0x0000FFFF, SCIVALUE,      scivalue);
PSR(0x00000000, 0x0000FFFF, SCIBAUD,       scibaud);
PSR(0x00000000, 0x0000FFFF, SCITIDE,       scitide);
PSR(0x00000000, 0x0000FFFF, SCIDMACR,      scidmacr);
PSR(0x00000000, 0x0000FFFF, SCISTABLE,     scistable);
PSR(0x00000000, 0x0000FFFF, SCIATIME,      sciatime);
PSR(0x00000000, 0x0000FFFF, SCIDTIME,      scidtime);
PSR(0x00000000, 0x0000FFFF, SCIATRSTIME,   sciatrstime);
PSR(0x00000000, 0x0000FFFF, SCIATRDTIME,   sciatrdtime);
PSR(0x00000000, 0x0000FFFF, SCISTOPTIME,   scistoptime);
PSR(0x00000000, 0x0000FFFF, SCISTARTTIME,  scistarttime);
PSR(0x00000000, 0x0000FFFF, SCIRETRY,      sciretry);
PSR(0x00000000, 0x0000FFFF, SCICHTIMELS,   scichtimels);
PSR(0x00000000, 0x0000FFFF, SCICHTIMEMS,   scichtimems);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMELS,  sciblktimels);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMEMS,  sciblktimems);
PSR(0x00000000, 0x0000FFFF, SCICHGUARD,    scichguard);
PSR(0x00000000, 0x0000FFFF, SCIBLKGUARD,   sciblkguard);
PSR(0x00000000, 0x0000FFFF, SCIRXTIME,     scirxtime);
PSR(0x0000000A, 0x0000FFFF, SCIFIFOSTATUS, scififostatus);
PSR(0x00000000, 0x0000FFFF, SCITXCOUNT,    scitxcount);
PSR(0x00000000, 0x0000FFFF, SCIRXCOUNT,    scirxcount);
PSR(0x00000000, 0x0000FFFF, SCIIMSC,       sciimsc);
PSR(0x0000400A, 0x0000FFFF, SCIRIS,        sciris);
PSR(0x00000000, 0x0000FFFF, SCIMIS,        scimis);
PSR(0x00000000, 0x0000FFFF, SCIICR,        sciicr);
PSR(0x00000000, 0x0000FFFF, SCISYNCACT,    scisyncact);
PSR(0x00000000, 0x0000FFFF, SCISYNCTX,     scisynctx);
PSR(0x00000000, 0x0000FFFF, SCISYNCRX,     scisyncrx);

PSR(0x00000031, 0x0000FFFF, SCIPeriphID0,  sciperiphid0);
PSR(0x00000011, 0x0000FFFF, SCIPeriphID1,  sciperiphid1);
PSR(0x00000004, 0x0000FFFF, SCIPeriphID2,  sciperiphid2);
PSR(0x00000000, 0x0000FFFF, SCIPeriphID3,  sciperiphid3);
PSR(0x0000000D, 0x0000FFFF, SCIPCellID0,   scipcellid0);
PSR(0x000000F0, 0x0000FFFF, SCIPCellID1,   scipcellid1);
PSR(0x00000005, 0x0000FFFF, SCIPCellID2,   scipcellid2);
PSR(0x000000B1, 0x0000FFFF, SCIPCellID3,   scipcellid3);

PSR(0x00000000, 0x0000FFFF, SCITCR);

C( " Register R/W test " );

/* Writing '1' to all bits of the writable registers */
PSW(0x0000FFFF, SCICR0);
PSW(0x0000FFFF, SCICR1);
PSW(0x0000FFFF, SCICLKICC);
PSW(0x0000FFFF, SCIVALUE);
PSW(0x0000FFFF, SCIBAUD);
PSW(0x0000FFFF, SCITIDE);
PSW(0x0000FFFF, SCIDMACR);
PSW(0x0000FFFF, SCISTABLE);
PSW(0x0000FFFF, SCIATIME);
PSW(0x0000FFFF, SCIDTIME);
PSW(0x0000FFFF, SCIATRSTIME);
PSW(0x0000FFFF, SCIATRDTIME);
PSW(0x0000FFFF, SCISTOPTIME);
PSW(0x0000FFFF, SCISTARTTIME);
PSW(0x0000FFFF, SCIRETRY);
PSW(0x0000FFFF, SCICHTIMELS);
PSW(0x0000FFFF, SCICHTIMEMS);
PSW(0x0000FFFF, SCIBLKTIMELS);
PSW(0x0000FFFF, SCIBLKTIMEMS);
PSW(0x0000FFFF, SCICHGUARD);
PSW(0x0000FFFF, SCIBLKGUARD);
PSW(0x0000FFFF, SCIRXTIME);
PSW(0x0000FFFF, SCIIMSC);
PSW(0x0000FFFF, SCISYNCACT);
PSW(0x0000FFFF, SCISYNCTX);


/* Reading the writable registers */
PSR(0x000000FF, 0x0000FFFF, SCICR0,       scicr0);
PSR(0x0000007F, 0x0000FFFF, SCICR1,       scicr1);
PSR(0x000000FF, 0x0000FFFF, SCICLKICC,    sciclkicc);
PSR(0x000000FF, 0x0000FFFF, SCIVALUE,     scivalue);
PSR(0x0000FFFF, 0x0000FFFF, SCIBAUD,      scibaud);
PSR(0x000000FF, 0x0000FFFF, SCITIDE,      scitide);
PSR(0x00000003, 0x0000FFFF, SCIDMACR,     scidmacr);
PSR(0x000003FF, 0x0000FFFF, SCISTABLE,    scistable);
PSR(0x0000FFFF, 0x0000FFFF, SCIATIME,     sciatime);
PSR(0x0000FFFF, 0x0000FFFF, SCIDTIME,     scidtime);
PSR(0x0000FFFF, 0x0000FFFF, SCIATRSTIME,  sciatrstime);
PSR(0x00000FFF, 0x0000FFFF, SCISTOPTIME,  scistoptime);
PSR(0x00000FFF, 0x0000FFFF, SCISTARTTIME, scistarttime);
PSR(0x0000003F, 0x0000FFFF, SCIRETRY,     sciretry);
PSR(0x0000FFFF, 0x0000FFFF, SCICHTIMELS,  scichtimels);
PSR(0x0000FFFF, 0x0000FFFF, SCICHTIMEMS,  scichtimems);
PSR(0x0000FFFF, 0x0000FFFF, SCIBLKTIMELS, sciblktimels);
PSR(0x0000FFFF, 0x0000FFFF, SCIBLKTIMEMS, scibllktimems);
PSR(0x000000FF, 0x0000FFFF, SCICHGUARD,   scichguard);
PSR(0x000000FF, 0x0000FFFF, SCIBLKGUARD,  sciblkguard);
PSR(0x0000FFFF, 0x0000FFFF, SCIRXTIME,    scirxtime);
PSR(0x0000FFFF, 0x00007FFF, SCIIMSC,      sciimsc);
/* SCISYNCACT read bits are of the controlled pins, not the register */
PSR(0x00000000, 0x0000FFFF, SCISYNCACT,   scisyncact);
PSR(0x0000003F, 0x0000FFFF, SCISYNCTX,    scisynctx);


/* Writing '0' to all bits of the writable registers */
PSW(0x00000000, SCICR0);
PSW(0x00000000, SCICR1);
PSW(0x00000000, SCICLKICC);
PSW(0x00000000, SCIVALUE);
PSW(0x00000000, SCIBAUD);
PSW(0x00000000, SCITIDE);
PSW(0x00000000, SCIDMACR);
PSW(0x00000000, SCISTABLE);
PSW(0x00000000, SCIATIME);
PSW(0x00000000, SCIDTIME);
PSW(0x00000000, SCIATRSTIME);
PSW(0x00000000, SCIATRDTIME);
PSW(0x00000000, SCISTOPTIME);
PSW(0x00000000, SCISTARTTIME);
PSW(0x00000000, SCIRETRY);
PSW(0x00000000, SCICHTIMELS);
PSW(0x00000000, SCICHTIMEMS);
PSW(0x00000000, SCIBLKTIMELS);
PSW(0x00000000, SCIBLKTIMEMS);
PSW(0x00000000, SCICHGUARD);
PSW(0x00000000, SCIBLKGUARD);
PSW(0x00000000, SCIRXTIME);
PSW(0x00000000, SCIIMSC);
PSW(0x00000000, SCISYNCACT);
PSW(0x00000000, SCISYNCTX);


/* Reading the writable registers */
PSR(0x00000000, 0x0000FFFF, SCICR0,       scicr0);
PSR(0x00000000, 0x0000FFFF, SCICR1,       scicr1);
PSR(0x00000000, 0x0000FFFF, SCICLKICC,    sciclkicc);
PSR(0x00000000, 0x0000FFFF, SCIVALUE,     scivalue);
PSR(0x00000000, 0x0000FFFF, SCIBAUD,      scibaud);
PSR(0x00000000, 0x0000FFFF, SCITIDE,      scitide);
PSR(0x00000000, 0x0000FFFF, SCIDMACR,     scidmacr);
PSR(0x00000000, 0x0000FFFF, SCISTABLE,    scistable);
PSR(0x00000000, 0x0000FFFF, SCIATIME,     sciatime);
PSR(0x00000000, 0x0000FFFF, SCIDTIME,     scidtime);
PSR(0x00000000, 0x0000FFFF, SCIATRSTIME,  sciatrstime);
PSR(0x00000000, 0x0000FFFF, SCISTOPTIME,  scistoptime);
PSR(0x00000000, 0x0000FFFF, SCISTARTTIME, scistarttime);
PSR(0x00000000, 0x0000FFFF, SCIRETRY,     sciretry);
PSR(0x00000000, 0x0000FFFF, SCICHTIMELS,  scichtimels);
PSR(0x00000000, 0x0000FFFF, SCICHTIMEMS,  scichtimems);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMELS, sciblktimels);
PSR(0x00000000, 0x0000FFFF, SCIBLKTIMEMS, sciclktimems);
PSR(0x00000000, 0x0000FFFF, SCICHGUARD,   scichguard);
PSR(0x00000000, 0x0000FFFF, SCIBLKGUARD,  sciblkguard);
PSR(0x00000000, 0x0000FFFF, SCIRXTIME,    scirxtime);
PSR(0x00000000, 0x0000FFFF, SCIIMSC,      sciimsc);
PSR(0x00000000, 0x0000FFFF, SCISYNCACT,   scisyncact);
PSR(0x00000000, 0x0000FFFF, SCISYNCTX,    scisynctx);


C( "Register read-only test" );
/* Write all 1's to read only registers */
PSW(0x0000FFFF, SCIFIFOSTATUS);
PSW(0x0000FFFF, SCITXCOUNT);
PSW(0x0000FFFF, SCIRXCOUNT);
PSW(0x0000FFFF, SCIRIS);
PSW(0x0000FFFF, SCIMIS);
PSW(0x0000FFFF, SCIPeriphID0);
PSW(0x0000FFFF, SCIPeriphID1);
PSW(0x0000FFFF, SCIPeriphID2);
PSW(0x0000FFFF, SCIPeriphID3);
PSW(0x0000FFFF, SCIPCellID0);
PSW(0x0000FFFF, SCIPCellID1);
PSW(0x0000FFFF, SCIPCellID2);
PSW(0x0000FFFF, SCIPCellID3);

/* Read back the reset value */
PSR(0x0000000A, 0x0000FFFF, SCIFIFOSTATUS, scififostatus);
PSR(0x00000000, 0x0000FFFF, SCITXCOUNT,    scitxcount);
PSR(0x00000000, 0x0000FFFF, SCIRXCOUNT,    scirxcount);
PSR(0x0000400A, 0x0000FFFF, SCIRIS,        sciris);
PSR(0x00000000, 0x0000FFFF, SCIMIS,        scimis);
PSR(0x00000031, 0x0000FFFF, SCIPeriphID0,  sciperiphid0);
PSR(0x00000011, 0x0000FFFF, SCIPeriphID1,  sciperiphid1);
PSR(0x00000004, 0x0000FFFF, SCIPeriphID2,  sciperiphid2);
PSR(0x00000000, 0x0000FFFF, SCIPeriphID3,  sciperiphid3);
PSR(0x0000000D, 0x0000FFFF, SCIPCellID0,   scipcellid0);
PSR(0x000000F0, 0x0000FFFF, SCIPCellID1,   scipcellid1);
PSR(0x00000005, 0x0000FFFF, SCIPCellID2,   scipcellid2);
PSR(0x000000B1, 0x0000FFFF, SCIPCellID3,   scipcellid3);


/* Write all 0's to read only registers */
PSW(0x00000000, SCIFIFOSTATUS);
PSW(0x00000000, SCITXCOUNT);
PSW(0x00000000, SCIRXCOUNT);
PSW(0x00000000, SCIRIS);
PSW(0x00000000, SCIMIS);
PSW(0x00000000, SCIPeriphID0);
PSW(0x00000000, SCIPeriphID1);
PSW(0x00000000, SCIPeriphID2);
PSW(0x00000000, SCIPeriphID3);
PSW(0x00000000, SCIPCellID0);
PSW(0x00000000, SCIPCellID1);
PSW(0x00000000, SCIPCellID2);
PSW(0x00000000, SCIPCellID3);

/* Read back the reset value */
PSR(0x0000000A, 0x0000FFFF, SCIFIFOSTATUS, scififostatus);
PSR(0x00000000, 0x0000FFFF, SCITXCOUNT,    scitxcoount);
PSR(0x00000000, 0x0000FFFF, SCIRXCOUNT,    scirxcount);
PSR(0x0000400A, 0x0000FFFF, SCIRIS,        sciris);
PSR(0x00000000, 0x0000FFFF, SCIMIS,        scimis);
PSR(0x00000031, 0x0000FFFF, SCIPeriphID0,  sciperiphd0);
PSR(0x00000011, 0x0000FFFF, SCIPeriphID1,  sciperiphd1);
PSR(0x00000004, 0x0000FFFF, SCIPeriphID2,  sciperiphd2);
PSR(0x00000000, 0x0000FFFF, SCIPeriphID3,  sciperiphd3);
PSR(0x0000000D, 0x0000FFFF, SCIPCellID0,   scipcelld0);
PSR(0x000000F0, 0x0000FFFF, SCIPCellID1,   scipcelld1);
PSR(0x00000005, 0x0000FFFF, SCIPCellID2,   scipcelld2);
PSR(0x000000B1, 0x0000FFFF, SCIPCellID3,   scipcelld3);

}/* Function End */
