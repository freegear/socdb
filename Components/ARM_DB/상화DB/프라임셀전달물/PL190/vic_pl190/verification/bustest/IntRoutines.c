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
-- File Name              : IntRoutines.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This file contains all the functions which are used only by
--           the Interrupt tests. (The Interrupts tests are
--           'UserOneIntTests', 'TwoFourIntTest', 'EightAllIntTests'.)
--
-- --=================================================================*/
 
/**********************************************************************/
/********************* List of Functions Called ***********************/
/**********************************************************************/
/*** Function name                              Located in          ***/
/*** -------------------------------------------------------------- ***/
/*** ReadStatus()                               IntRoutines.c       ***/
/*** WaitLoop()                                 VicCommon.c         ***/
/*** ApplyIntr()                                IntRoutines.c       ***/
/*** CurServReg()                               IntRoutines.c       ***/
/*** FIQServ()                                  IntRoutines.c       ***/
/*** VectIRQServ()                              IntRoutines.c       ***/
/*** NonVectIRQServ()                           IntRoutines.c       ***/
/*** UserIntService()                           IntRoutines.c       ***/
/**********************************************************************/
 
/**********************************************************************/
/*************************** Apply Interrupt **************************/
/**********************************************************************/

void ApplyIntr(int select)
{
  /*
     Summary: Apply Interrupt
     ========================
     This function performs the following:
 
     o  Writes a new value in the TrIntSource register of the Trickbox 
        or the VICSoftInt register of the Vic.
 
     The input argument can be either 0 and 1. If it is 0, then the
     interrupt is raised via the TrickBox. Else, it is raised through
     the VICSoftInt register. 
  */
 
  if (select == 0)
  {
    HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , );
    HSW( , D_TrIntSource, ,TrIntSource_write);
  }
  else if (select == 1)
  {
    HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , D_TrIntSource, ,SoftInt_write);

    /** While writing into the VICSoftInt register, only those bits  **/
    /** that are a logic '1' in the write-data, are made HIGH. Other **/
    /** bits are left unaffected. Here, the requirement is to clear  **/
    /** all other bits.  Hence, the bitwise NOTed form of the data   **/
    /** is written into the VICSoftIntClr register. This will write  **/
    /** ZEROes to the previously unaffected bit positions.           **/
    HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ~D_TrIntSource, ,SoftIntClear_write);
  }
    WaitLoop(3);
}
 
/**********************************************************************/
/************************ Read Status Registers ***********************/
/**********************************************************************/

void ReadStatus()
{
  /*
     Summary: Read Status Registers
     ==============================
     This function performs the following:
 
     o  Reads the VICIRQStatus and VICFIQStatus registers.

     o  Reads the VICRawIntr register.

     o  Accesses are performed in a burst. 
  */

  /** One wait state is added for the double synchronisation of the **/
  /** Status signals.                                               **/
  WaitLoop(1);
 
  /** The VICIRQStatus, VICFIQStatus and the VICRawIntr registers **/
  /** are read using a burst access.                              **/
  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , D_VICIRQStatus, , NoMask, ,IntRoutines_1);
  HSR( , D_VICFIQStatus, , NoMask, ,IntRoutines_2);
  HSR( , D_VICRawIntr, , NoMask, ,IntRoutines_3);
}
 
/**********************************************************************/
/********************** Current Service Register **********************/
/**********************************************************************/

void CurServReg()
{
  /*
     Summary: Current Service Register
     =================================
     This function performs the following:
 
     o  Determines the active Vectored interrupts and stores them in a 
        variable called CSR.
     
     In order to keep a track of all the vectored interrupt sources
     which are currently active, a 16-bit hex variable called CSR is
     used. Its function can be explained with an illustration. 
    
     Consider a case where the VIC is programmed such that
     VICINTSOURCE[8] and VICINTSOURCE[11] should raise Vectored
     Interrupts via Vector Banks 5 and 9 respectively. The 16-bit CSR
     vector would be modified such that bits 5 and 9 are set. Hence the
     CSR holds a record of all active interrupts that need to be
     serviced by an ISR. Once a Vectored Interrupt has been serviced,
     its corresponding CSR bit would be cleared. In the above case,
     since Vectored Interrupt 5 has a higher priority than Vectored
     Interrupt 8, CSR bit 5 would be cleared before clearing CSR bit 8.
  */
 
  int j;
  int32 intrpt, shift, bit;
 
  CSR = 0x0000;
  for (j = 0; j < VEC_COUNT; j++)
  {

    /** Checks whether the Vectored interrupts are enabled. **/
    if ((D_VICVectCntl[j] & 0x00000020) == 0x00000020)
    {

      /** Determine which Source is mapped to the corresponding **/
      /** Vector address.                                       **/
      shift = D_VICVectCntl[j] & 0x0000001F;
      intrpt = LSB1 << shift;
 
      /** Checking whether this corresponding interrupt is active. **/
      bit = LSB1;
      if ((intrpt & D_VICIRQStatus) == intrpt)
      {

        /** If active, then that bit in the CSR is set. **/
        bit = bit << j;
        CSR = CSR | bit;
      }
    }
  }
}
 
/**********************************************************************/
/********************** Clear All FIQ Interrupts **********************/
/**********************************************************************/

void FIQServ(int select)
{
  /*
     Summary: Clear FIQ interrupts
     =============================
     This function performs the following:
 
     o  Determines the bit in the TrIntSource causing the FIQ interrupt.
 
     o  Clears that bit in the TrIntSource.
 
     o  Looks for any Daisy-Chain FIQ interrupt and handles it.

     o  If the argument is 0, then it means that the interrupts are due
        to the TrIntIn register of the Trickbox. It it is 1, then it is
        due to VICSoftInt register of the Vic.

     This function clears all the FIQ interrupts. By comparing with the
     VICFIQStatus register, it is possible to determine which bits in
     the VICINTSOURCE are currently requesting a FIQ. Now, beginning
     from the 0th position, all the FIQ interrupt sources are cleared by
     writing 0s in the corresponding positions in the TrIntSource
     register of the TrickBox. If the interrupt is applied via the
     VICSoftInt register, then the bits of that register will be
     cleared. After clearing all the interrupts in this manner, the FIQ
     interrupt due to any external source is checked for. If there are
     any, then they are cleared as well.
  */
 
  int j;
  int32 intr;
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** Check if a FIQ interrupt is pending via the VICINTSOURCE or **/
  /** VICSoftInt register.                                        **/
  intr = LSB1;
  for (j = 0; j < INT_COUNT; j++, intr = intr <<1)
  {
    if ((intr & D_VICFIQStatus) == intr)
    {

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP regsiter     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
      /** To indicate the status of nVICFIQ, VICITOP1 is read. **/
      HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , DataF, , UnMaskFIQ, ,IntRoutines_4);
}

      /** The interrupt which is currently being serviced is **/
      /** cleared.                                           **/
      D_TrIntSource = D_TrIntSource & ~intr;
      ApplyIntr(select);
    }
  }

  /** Check if an External FIQ interrupt is pending. **/
  if ((D_TrIntIn & 0x00000001) == 0x00000000)
  {

    /** The bit causing the FIQ is cleared. **/
    D_TrIntIn = D_TrIntIn | 0x00000001;
    HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , D_TrIntIn);
  }
}

/**********************************************************************/
/*************** Clear All Non-Vectored IRQ Interrupts ****************/
/**********************************************************************/

void NonVectIRQServ(int select)
{
  /*
     Summary: Clear Non-Vectored IRQ interrupts
     ==========================================
     This function performs the following:
 
     o  Determines the bit in the TrIntSource causing the Non-Vectored
        IRQ interrupt.
 
     o  Clears that bit in the TrIntSource.
 
     o  Performs a write to the VICVectAddr register.
 
     o  Looks for any Daisy-Chain Non-Vectored IRQ interrupt and
        handles it.

     This function clears all the Non-Vectored IRQ Interrupts. When this
     function is accessed all the FIQ interrupts and the Vectored-IRQ
     interrupts would have already been cleared. By comparing with the
     VICIRQStatus register, it is possible to determing which bits in
     the VICINTSOURCE are currently requesting a Non-Vectored IRQ. All
     the 1s in this register correspond to Non-Vectored IRQ
     interrupts. Hence, the VICVectAddr register is read expecting the
     Default address. Now, beginning from the 0th position, all the IRQ
     interrupt sources are cleared by writing 0s in the corresponding
     positions in the TrIntSource register of the TrickBox. To indicate
     the end of the Service Routine, a write is conducted on the
     VICVectAddr register. If the interrupts are applied via the
     VICSoftInt register, the bits of that register will be cleared.
     After clearing all the interrupts in this manner, the IRQ
     interrupts due to any external source is checked for. If there are
     any, they are cleared as well.
  */
 
  int32 intr;
  int j;
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** Check if an IRQ interrupt is pending via the VICINTSOURCE or **/
  /** the VICSoftInt register.                                     **/
  intr = LSB1;
  for (j = 0; j < INT_COUNT; j++, intr = intr << 1)
  {
    if ((intr & D_VICIRQStatus) == intr)
    {

     WaitLoop(2);

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP regsiter     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
      /** To indicate the status of nVICIRQ, VICITOP1 is read. **/
      HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , DataF, , UnMaskIRQ, ,IntRoutines_5);

      /** To indicate the status of VICVectAddrOut, VICITOP2 is **/
      /** read.                                                 **/
      HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_6);
}

      /** The VICVectAddr is read expecting the Default Address. **/
      /** This marks the beginning of the Interrupt Service Routine. **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_7);

      /** The interrupt which is currently being serviced is **/
      /** cleared.                                           **/
      D_TrIntSource = D_TrIntSource & ~intr;
      ApplyIntr(select);

      /** A write access is done on the VICVectAddr. This marks the **/
      /** end of the Interrupt Service Routine.                     **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSW( , ZERO);
    }
  }
 
  /** Check if an External IRQ interrupt is pending. **/
  if ((D_TrIntIn & 0x00000002) == 0x00000000)
  {

    /** The bit causing the IRQ is cleared. **/
    D_TrIntIn = D_TrIntIn | 0x00000002;
    HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , D_TrIntIn);
  }
}
 
/**********************************************************************/
/***************** Clear All Vectored IRQ Interrupts ******************/
/**********************************************************************/

void VectIRQServ(int select)
{
  /*
     Summary: Clear Vectored IRQ interrupts
     ======================================
     This function performs the following:
 
     o  Determines the bit in the TrIntSource causing the Vectored IRQ
        interrupt. This is done by mapping with the CSR.
 
     o  Clears that bit in the TrIntSource.
 
     o  Performs a write to the VICVectAddr register.
 
     o  Looks for any Daisy-Chain Vectored IRQ interrupt and handles
        it.

     When this function is called, the FIQ interrupts are already
     cleared. The variable CSR, which holds the information about the
     active Vectored interrupt, is used here. For every '1' in any of
     the bits in this variable, there is a Vectored interrupt. The CSR
     is read from the 0th bit. Suppose, the 4th bit of the CSR is 1 and
     bits 0 to 3 contained 0s. Then, the highest priority interrupt
     currently active is from the source number defined by the value in
     VICVectCntl[4] and its vector address is at VICVectAddr[4].
     Thus, the VICVectAddr register is read expecting the value to be
     same as that in the VICVectAddr[4]. Now, the interrupt source is
     cleared by clearing the interrupt pointed by the VICVectCntl[4]. To
     indicate the end of the service routine a write is conducted on
     VICVectAddr.
  */
 
  int j;
  int32 intr, Int_num, Int_pos, address;
 
  /** Read Status Registers. **/
  ReadStatus();
 
  intr = LSB1;
  for (j = 0; j < VEC_COUNT; j++, intr = intr << 1)
  {
    if ((intr & CSR) == intr)
    {

     WaitLoop(2);

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP regsiter     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
      /** To indicate the status of nVICFIQ, VICITOP1 is read. **/
      HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , DataF, , UnMaskIRQ, ,IntRoutines_8);
 
      /** To indicate the status of VICVectAddrOut, VICITOP2 is **/
      /** read.                                                 **/
      HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICVectAddr[j], , NoMask, ,IntRoutines_9);
}

      /** A VICVectAddr access is performed assuming the word size **/
      /** to be Half-Word. This is done for an Error response.     **/
      HSA(VICVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1);
      HSR( , ZERO, , NoMask, ,IntRoutines_10);

      /** The VICVectAddr is read. This marks the beginning of the **/
      /** Interrupt Service Routine.                               **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICVectAddr[j], , NoMask, ,IntRoutines_11);
 
      /** Determining the source, which has raised the current **/
      /** interrupt.                                           **/
      Int_num = D_VICVectCntl[j] & 0x0000001F;
      Int_pos = LSB1 << Int_num;
 
      /** The interrupt, which is currenty being serviced is **/
      /** cleared.                                           **/
      D_TrIntSource = D_TrIntSource & (~Int_pos);
      ApplyIntr(select);

      /** A write access is done on the VICVectAddr. This marks the **/
      /** end of the Interrupt Service Routine.                     **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSW( , ZERO);
 
      /** The CSR is updated by writing a '0' in the corresponding **/
      /** bit position.                                            **/
      CSR = CSR & ~intr;
    }
  }
 
  /** A VICDefVectAddr access is performed assuming the word size to **/  /** be Half-Word. This is done for an Error response.              **/
  HSA(VICDefVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1);
  HSW( , LSB1);
}
 
/**********************************************************************/
/************************ Apply One Interrupt *************************/
/**********************************************************************/

int32 OneInterrupt(int i1)
{
  /*
     Summary: Applies One Interrupt
     ==============================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt;
 
  /** A 32-bit interrupt vector is generated to represent one **/
  /** interrupt.                                              **/
  Interrupt = LSB1 << i1;
 
  return (Interrupt);
}
 
/**********************************************************************/
/************************ Apply Two Interrupts ************************/
/**********************************************************************/

int32 TwoInterrupt(int i1, int i2)
{
  /*
     Summary: Applies Two Interrupts
     ================================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt, TwoInt1, TwoInt2;
 
  /** 32-bit vectors are generated, each representing one interrupt. **/
  TwoInt1 = LSB1 << i1;
  TwoInt2 = LSB1 << i2;
 
  /** All the above vectors are logically ORed to get a single **/
  /** vector representing two interrupts.                      **/
  Interrupt = TwoInt1 | TwoInt2;
 
  return (Interrupt);
}

/**********************************************************************/
/*********************** Apply Four Interrupts ************************/
/**********************************************************************/

int32 FourInterrupt(int i1, int i2, int i3, int i4)
{
  /*
     Summary: Applies Four Interrupts
     ================================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt, FourInt1, FourInt2, FourInt3, FourInt4;
 
  /** 32-bit vectors are generated, each representing one interrupt. **/
  FourInt1 = LSB1 << i1;
  FourInt2 = LSB1 << i2;
  FourInt3 = LSB1 << i3;
  FourInt4 = LSB1 << i4;
 
  /** All the above vectors are logically ORed to get a single **/
  /** vector representing four interrupts.                     **/
  Interrupt = FourInt1 | FourInt2 | FourInt3 | FourInt4;
 
  return (Interrupt);
}
 
/**********************************************************************/
/*********************** Apply Eight Interrupts ***********************/
/**********************************************************************/

int32 EightInterrupt(int i1, int i2, int i3, int i4, int i5, int i6,
                    int i7, int i8)
{
  /*
     Summary: Applies Eight Interrupts
     ================================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt, EightInt1, EightInt2, EightInt3, EightInt4;
  int32 EightInt5, EightInt6, EightInt7, EightInt8;
 
  /** 32-bit vectors are generated, each representing one interrupt. **/
  EightInt1 = LSB1 << i1;
  EightInt2 = LSB1 << i2;
  EightInt3 = LSB1 << i3;
  EightInt4 = LSB1 << i4;
  EightInt5 = LSB1 << i5;
  EightInt6 = LSB1 << i6;
  EightInt7 = LSB1 << i7;
  EightInt8 = LSB1 << i8;
 
  /** All the above vectors are logically ORed to get a single **/
  /** vector representing eight interrupts.                    **/
  Interrupt = EightInt1 | EightInt2 | EightInt3 | EightInt4 | EightInt5;
  Interrupt = Interrupt | EightInt6 | EightInt7 | EightInt8;
 
  return (Interrupt);
}
 
/**********************************************************************/
/********************** Apply Sixteen Interrupts **********************/
/**********************************************************************/

int32 SxtnInterrupt(int i1, int i2, int i3, int i4, int i5, int i6,
                   int i7, int i8, int i9, int i10, int i11, int i12,
                   int i13, int i14, int i15, int i16)
{
  /*
     Summary: Applies Sixteen Interrupts
     ===================================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt, SxtnInt1, SxtnInt2, SxtnInt3, SxtnInt4, SxtnInt5;
  int32 SxtnInt6, SxtnInt7, SxtnInt8, SxtnInt9, SxtnInt10, SxtnInt11;
  int32 SxtnInt12, SxtnInt13, SxtnInt14, SxtnInt15, SxtnInt16;
 
  /** 32-bit vectors are generated, each representing one interrupt. **/
  SxtnInt1 = LSB1 << i1;
  SxtnInt2 = LSB1 << i2;
  SxtnInt3 = LSB1 << i3;
  SxtnInt4 = LSB1 << i4;
  SxtnInt5 = LSB1 << i5;
  SxtnInt6 = LSB1 << i6;
  SxtnInt7 = LSB1 << i7;
  SxtnInt8 = LSB1 << i8;
  SxtnInt9 = LSB1 << i9;
  SxtnInt10 = LSB1 << i10;
  SxtnInt11 = LSB1 << i11;
  SxtnInt12 = LSB1 << i12;
  SxtnInt13 = LSB1 << i13;
  SxtnInt14 = LSB1 << i14;
  SxtnInt15 = LSB1 << i15;
  SxtnInt16 = LSB1 << i16;
 
  /** All the above vectors are logically ORed to get a single **/
  /** vector representing sixteen interrupts.                  **/
  Interrupt = SxtnInt1 | SxtnInt2 | SxtnInt3 | SxtnInt4 | SxtnInt5;
  Interrupt = Interrupt | SxtnInt6 | SxtnInt7 | SxtnInt8 | SxtnInt9;
  Interrupt = Interrupt | SxtnInt10 | SxtnInt11 | SxtnInt12 | SxtnInt13;
  Interrupt = Interrupt | SxtnInt14 | SxtnInt15 | SxtnInt16;
 
  return (Interrupt);
}
 
/**********************************************************************/
/************************ Apply All Interrupts ************************/
/**********************************************************************/

int32 AllInterrupt()
{
  /*
     Summary: Applies Thirty-two Interrupts
     ===================================
     This function performs the following:
 
     o  Takes the interrupt sources as parameters.
 
     o  Generates the corresponding variable to be equated to
        D_TrIntSource
  */
 
  int32 Interrupt;
 
  /** A 32-bit interrupt vector is generated to represent **/
  /** thirty-two interrupts.                              **/
  Interrupt = DataF;
 
  return (Interrupt);
}
 
/**********************************************************************/
/**************** Service and Clear All the Interrupts ****************/
/**********************************************************************/

void AllIntService(int select)
{
  /*
     Summary: Services All the Interrupts
     ====================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  Executes the FIQs, if any.
 
     o  Executes the Vectored IRQs, if any, in the order of priority.
 
     o  Executes the Non-Vectored IRQs, if any.
  */

  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);
 
  /** Read Status Registers. **/ 
  ReadStatus();
 
  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  /** Check whether there are any active FIQs. **/
  if ((D_VICFIQStatus) || ((~D_TrIntIn & 0x00000001) == 0x00000001))
  {
    /** Service and clear all the FIQs. **/
    FIQServ(select);
  }
 
  /** Check whether there are any active IRQs. **/
  if ((D_VICIRQStatus) || ((~D_TrIntIn & 0x00000002)
       == 0x00000002))
  {

    /** Check whether this IRQ is being raised through a vector **/
    /** bank.                                                   **/
    if ((CSR) || (D_TrVectAddrIn != D_VICDefVectAddr))
    {

      /** Service and clear all the Vectored IRQs in the order of **/
      /** their priorities.                                       **/
      VectIRQServ(select);
    }
 
    /** Check whether any Non-Vectored IRQs are pending. **/
    if (CSR == 0x0000)
    {

      /** Service and clear all the Non-Vectored IRQs. **/
      NonVectIRQServ(select);
    }
  }
}
 
/**********************************************************************/
/*************** Service and Clear a specific Interrupt ***************/
/**********************************************************************/

void UserIntService(int intr)
{
  /*
     Summary: Services a Specific Interrupt
     ======================================
     This function performs the following:
 
     o  Clears the interrupt specified by the user.

     This function is called when the user decides the order in which 
     interrupts are to  be cleared. The interrups may not be cleared in
     their priority order. Hence, while clearing the Vectored Interrupt
     once the VectAddrOut is read it should not be read until this 
     particular interrupt bit is cleared. Hence, a 16-bit global
     variable called servreg is used. 

     The handler sequence is illustrated with an example:

     Suppose, the content of the CSR = 0b0000000110001001. This means
     that 4 vector interrupts are currently active. Since, the 0th, 3rd,
     7th and 8th bits of the CSR are 1, we need to look for those
     Control and Address registers. Let the last 5 bits of the
     VICVectCntl[0], VICVectCntl[3], VICVectCntl[7] and VICVectCntl[8]
     registers read 10, 3, 17 and 8, respectively, in decimal. This
     means that the the priority of the Vector interrupts is in the
     order 10, 3, 17, 8.  Thus, the VectAddrOut will be the
     VICVectAddr[0]. Let the user decide to clear the interrupt in the
     order 17, 3, 10, 8. Then, as soon as the VectAddrOut is read, the
     servreg is made 0b0000000000000001. This is to indicate which
     interrupt is currently being serviced. Now, 17th interrupt is
     cleared. Now, No. 3 interrupt has to be cleared. But, before
     reading the VectAddr register, the servreg is checked whether it is
     zero. If it is non-zero then the expected address-out will be the
     default address. Now, after clearing the 3rd interrupt, the 10th
     interrupt has to be cleared. Again, since the servreg is not zero
     the expected address will be the default address. Now, at this
     point the servreg is cleared. Next, when the 8th interrupt is to be
     cleared the expected address will be VICVectAddr[8]. When the
     interrupt is an FIQ, then the address is not read. Once, any of the
     interrupts are cleared, a variable 'cleared' is set to 1 so that
     no further interrupts are cleared in this function call.
  */

  int i, j, k, inter, cleared = 0, next = 1;
  int32 shiftbit, clrbit, clrCSR;
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1); 

  /** Check whether the interrupt source, which is passed as the **/
  /** argument is raising a FIQ.                                 **/
  clrbit = LSB1 << intr;
  if ((clrbit & D_VICFIQStatus) == clrbit)
  {
    /** The interrupts source, which is passed as the argument is **/
    /** raising a FIQ, then it is cleared.                        **/
    D_TrIntSource = D_TrIntSource & ~clrbit;
    ApplyIntr(0);

    /** Add one IDLE cycle to compensate for the one clock          **/
    /** discrepancy due to the clocked output of the status         **/
    /** registers.                                                  **/
    WaitLoop(1);

    /** Read Status Registers. **/
    ReadStatus();
  }
  /** Check whether the interrupt source, which is passed as the **/
  /** argument is raising an IRQ.                                **/
  else if ((clrbit & D_VICIRQStatus) == clrbit)
  {
    /** Check whether the interrupt source is raising a Vectored **/
    /** IRQ.                                                     **/
    for (i = 0; i < VEC_COUNT; i++)
    {
      if ((D_VICVectCntl[i] & 0x0000001F) == intr)
      {

        /** Check whether any Interrupt Service Routine is running. **/
        if (servreg != Data0)
        {

          /** If any Interrupt is currently being serviced, then the **/
          /** expected address from the VICVectAddrOut is the        **/
          /** Default Vector Address.                                **/
          addrout = D_VICDefVectAddr;
        }
 
        inter = LSB1;
        for (j = 0; j < VEC_COUNT; j++, inter = inter << 1)
        {
          if (((inter & CSR) == inter) && (next == 1) && (servreg
                 == Data0))
          {

            /** If the source raised a Vectored interrupt and        **/
            /** previously no Vectored interrupts are being          **/
            /** serviced, the VICVectAddr register is read expecting **/
            /** the required address.                                **/
            addrout = D_VICVectAddr[j];
            HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
            HSR( , addrout, , NoMask, ,IntRoutines_12);

            /** Once the VICVectAddr is read, the address out will **/
            /** change to the Default address.                     **/
            addrout = D_VICDefVectAddr;

            /** Now, the servreg is modified to indicate that an **/
            /** interrupt is currently being serviced.           **/
            servreg = inter;

            /** The loop should be terminated here. **/
            next = 0;
          }
        }

        /** Now, the interrupt should be cleared by writing a '0' in **/
        /** the corresponding bit position in the VICIntSource.      **/
        D_TrIntSource = D_TrIntSource & ~clrbit;
        ApplyIntr(0);

        /** If the interrupt just cleared has been serviced, then a  **/
        /** write access should be done on the VICVectAddr register. **/
        clrCSR = LSB1 << i;
        if (clrCSR == servreg)
        {
          HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
          HSW( , Data0);

          /** After the write access, the servreg has to be cleared **/
          /** indicating that no interrupts are currently being     **/
          /** serviced.                                             **/
          servreg = Data0;
        }

        /** Now, the CSR is to be updated. **/
        CSR = CSR & ~clrCSR;

        /** Variable 'cleared' is set so that no further interrupts **/
        /** are cleared in this access to this function.            **/
        cleared = 1;
      }
    }
 
    /** If still any interrupt is not cleared in this access to the **/
    /** function, then it means that the source is raising a        **/
    /** Non-Vectored Interrupt.                                     **/
    if (cleared == 0)
    {

      /** If no Vectored IRQ is being currently serviced, then the **/
      /** highest priority interrupt should be serviced.           **/
      if (servreg == Data0)
      {
        shiftbit = LSB1;
        clrbit = LSB1 << intr;
        for (k = 0; k < VEC_COUNT; k++, shiftbit = shiftbit << 1)
        {
          if (((shiftbit & CSR) == shiftbit) &&
              ((clrbit & D_VICIRQStatus) == clrbit) && (servreg
                == Data0))
          {

            /** The Vector Address is read. **/
            addrout = D_VICVectAddr[k];
            HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
            HSR( , addrout, , NoMask, ,IntRoutines_13);
            
            /** After the servicing has been started servreg has to **/
            /** be updated.                                         **/
            servreg = shiftbit;

            /** Now, the address out will be the default address. **/
            addrout = D_VICDefVectAddr;

            break;
          }
        }
      }
   
      /** Clear the interrupt by writing in the VICIntSource **/
      /** register.                                          **/
      D_TrIntSource = D_TrIntSource & ~clrbit;
      ApplyIntr(0);
    }
 
    /** Add one IDLE cycle to compensate for the one clock  **/
    /** discrepancy due to the clocked output of the status **/
    /** registers.                                          **/
    WaitLoop(1);

    /** Read Status Registers. **/
    ReadStatus();
  }
}
 
/**********************************************************************/
/******************* Service and Clear Two Interrupts *****************/
/**********************************************************************/

void ServiceTwo(int c1, int c2)
{
  /*
     Summary: Services the Two-Interrupts
     ====================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  The interrupts are cleared in the specified order.
  */
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);

  /* Store details of vectored interrupts. */ 
  CurServReg();
 
  /* Read status registers. */
  ReadStatus();
 
  /** The interrupt raised by source c1 is serviced and cleared. **/ 
  UserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c2);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
  WaitLoop(3);
}

/**********************************************************************/
/****************** Service and Clear Four Interrupts *****************/
/**********************************************************************/

void ServiceFour(int c1, int c2, int c3, int c4)
{
  /*
     Summary: Services the Four-Interrupts
     =====================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  The interrupts are cleared in the specified order.
  */
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);

  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** The interrupt raised by source c1 is serviced and cleared. **/ 
  UserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c4);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/**********************************************************************/
/****************** Service and Clear Eight Interrupts ****************/
/**********************************************************************/

void ServiceEight(int c1, int c2, int c3, int c4, int c5, int c6,
                  int c7, int c8)
{
  /*
     Summary: Services the Eight-Interrupts
     ======================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  The interrupts are cleared in the specified order.
  */
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);

  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** The interrupt raised by source c1 is serviced and cleared. **/ 
  UserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c8);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/**********************************************************************/
/***************** Service and Clear Sixteen Interrupts ***************/
/**********************************************************************/

void ServiceSxtn(int c1, int c2, int c3, int c4, int c5, int c6, int c7,
                 int c8, int c9, int c10, int c11, int c12, int c13,
                 int c14, int c15, int c16)
{
  /*
     Summary: Services the Sixteen-Interrupts
     ========================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  The interrupts are cleared in the specified order.
  */
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);

  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** The interrupt raised by source c1 is serviced and cleared. **/ 
  UserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c8);

  /** The interrupt raised by source c9 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c9);

  /** The interrupt raised by source c10 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c10);

  /** The interrupt raised by source c11 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c11);

  /** The interrupt raised by source c12 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c12);

  /** The interrupt raised by source c13 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c13);

  /** The interrupt raised by source c14 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c14);

  /** The interrupt raised by source c15 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c15);

  /** The interrupt raised by source c16 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c16);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/**********************************************************************/
/**************** Service and Clear Thirty-Two Interrupts *************/
/**********************************************************************/

void ServiceAll(int c1, int c2, int c3, int c4, int c5, int c6, int c7,
                int c8, int c9, int c10, int c11, int c12, int c13,
                int c14, int c15, int c16, int c17, int c18, int c19,
                int c20, int c21, int c22, int c23, int c24, int c25,
                int c26, int c27, int c28, int c29, int c30, int c31,
                int c32)
{
  /*
     Summary: Services the Thirty-Two-Interrupts
     ===========================================
     This function performs the following:
 
     o  Reads the Status registers.
 
     o  Writes into the CSR register the details of any vectored
        interrupt.
 
     o  The interrupts are cleared in the specified order.
  */
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);

  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  /** Read Status Registers. **/
  ReadStatus();
 
  /** The interrupt raised by source c1 is serviced and cleared. **/ 
  UserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c8);

  /** The interrupt raised by source c9 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  UserIntService(c9);

  /** The interrupt raised by source c10 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c10);

  /** The interrupt raised by source c11 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c11);

  /** The interrupt raised by source c12 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c12);

  /** The interrupt raised by source c13 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c13);

  /** The interrupt raised by source c14 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c14);

  /** The interrupt raised by source c15 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c15);

  /** The interrupt raised by source c16 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c16);

  /** The interrupt raised by source c17 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c17);

  /** The interrupt raised by source c18 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c18);

  /** The interrupt raised by source c19 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c19);

  /** The interrupt raised by source c20 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c20);

  /** The interrupt raised by source c21 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c21);

  /** The interrupt raised by source c22 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c22);

  /** The interrupt raised by source c23 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c23);

  /** The interrupt raised by source c24 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c24);

  /** The interrupt raised by source c25 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c25);

  /** The interrupt raised by source c26 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c26);

  /** The interrupt raised by source c27 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c27);

  /** The interrupt raised by source c28 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c28);

  /** The interrupt raised by source c29 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c29);

  /** The interrupt raised by source c30 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c30);

  /** The interrupt raised by source c31 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c31);

  /** The interrupt raised by source c32 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  UserIntService(c32);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/**********************************************************************/
/*********** Apply and Service Two Non-Simultaneous Interrupts ********/
/**********************************************************************/

void TwoDiffInt(int i1, int i2)
{
  /*
     Summary: Applies and Services Two Non-Simultaneous Interrupts
     =============================================================
     This function performs the following:
 
     o  Applies one interrupt.
 
     o  Reads the address.
 
     o  Apply the second interrupt.

     o  Read the address.

     o  According to priority, clear the interrupts.

     In this function two interrupts are applied, one after the other.
     As soon as the first interrupt is applied, the servicing of this
     interrupt is started. If the first interrupt is a FIQ, then the
     address need not be read. Else, the required address is read. Now,
     the second interrupt is applied. If, the second interrupt has a
     higher priority than the first, the second interrupt is serviced
     and cleared before the first interrupt is cleared. First, the FIQs
     are looked for. If there are any, then they are simply cleared by
     clearing the corresponding bit in the VICINTSOURCE. Then, the
     Vectored IRQs are checked. If the first interrupt was a lower
     priority Vector IRQ than the second interrupt, then the address out
     will change. Thus the address read should be the new one. After
     clearing the second interrupt, the address will again be the
     Default address, as the first interrupt's service routine has
     already begun. After this the Non-Vectored IRQs are serviced and
     cleared.
  */
 
  int32 intru, intrpt1, intrpt2, CSR1, CSR2, intrpt, Int_pos, Int_num;
  int k, j;
 
  /** The first interrupt is applied. **/
  D_TrIntSource = LSB1 << i1;
  ApplyIntr(0);

  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);
 
  /** Read Status Registers. **/
  ReadStatus();

  /** Store details of Vectored Interrupts. **/
  CurServReg();

  /** The bit position corresponding to the first interrupt is **/
  /** stored in the variable called CSR1.                      **/
  CSR1 = CSR;

  /** If the first interrupt is a Vectored-IRQ, read the Vector **/
  /** Address.                                                  **/
  if ((CSR != 0x0000) && (D_VICIRQStatus != 0))
  {
    intru = LSB1;
    for (k = 0; k < VEC_COUNT; k++, intru = intru << 1)
    {
      if ((intru & CSR) == intru)
      {
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICVectAddr[k], , NoMask, ,IntRoutines_14);
      }
    }
  }

  /** If the first interrupt is a Non-Vectored IRQ, read the Default **/
  /** address from the Vector Address register.                      **/
  if ((CSR == 0x0000) && (D_VICIRQStatus != 0))
  {
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_15);
  }

  /** Now, the second interrupt is applied. **/
  D_TrIntSource = D_TrIntSource | (LSB1 << i2);
  ApplyIntr(0);

  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);
 
  /** Read Status Registers. **/
  ReadStatus();

  /** Store details of Vectored Interrupts. **/
  CurServReg();

  /** The bit position corresponding to the second interrupt is **/
  /** stored in the variable called CSR2.                       **/
  CSR2 = CSR & ~CSR1;
 
  /** Check whether the first interrupt is a FIQ. **/
  intru = LSB1 << i1;
  if ((intru & D_VICFIQStatus) == intru)
  {
    /** If the first interrupt is a FIQ, then it is cleared. **/
    D_TrIntSource = D_TrIntSource & ~intru;
    ApplyIntr(0);
  }

  /** Check whether the second interrupt is a FIQ. **/
  intru = LSB1 << i2;
  if ((intru & D_VICFIQStatus) == intru)
  {

    /** If the second interrupt is a FIQ, then it is cleared. **/
    D_TrIntSource = D_TrIntSource & ~intru;
    ApplyIntr(0);
  }
 
  /** Now, there are no FIQs pending. Determine whether the first   **/
  /** interrupt is a Vectored-IRQ and if the second is either a     **/
  /** Non-Vectored or a Vectored-IRQ of lower priority. In both     **/
  /** cases the address out won't change on the application of the  **/
  /** second interrupt. And the first interrupt can now be cleared. **/
  if (((CSR1 != 0x0000) & (CSR1 < CSR2)) || ((CSR1 != 0x0000) & (CSR2
        == 0x0000)))
  {

    /** If the first interrupt had higher priority it is cleared **/
    /** here.                                                    **/
    intru = LSB1 << i1;
    D_TrIntSource = D_TrIntSource & ~intru;
    ApplyIntr(0);

    /** End the ISR by writing to the VICVectAddr register. **/
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
    WaitLoop(2);

    /** CSR is updated. **/
    CSR = CSR & ~CSR1;
  }

  /** The interrupt to be cleared first is the second interrupt,     **/
  /** which is a vectored interrupt. This condition occurs, when the **/
  /** second interrupt is a vectored interrupt of higher priority.   **/
  else
  {
    intrpt = LSB1;
    for (j = 0; j < VEC_COUNT; j++, intrpt = intrpt << 1)
    {
      if ((intrpt & CSR) == intrpt) 
      {
        if (CSR == (CSR2 | CSR1))
        {
          /** Beginning of the Service Routine of the second **/
          /** interrupt.                                     **/
          HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
          HSR( , D_VICVectAddr[j], , NoMask, ,IntRoutines_16);
        }
        if (CSR == CSR1)
        {
          /** The first interrupt servicing has already started.    **/
          /** Hence, the expected address would be the Default one. **/
          HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
          HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_17);
        }

        /** Determine the interrupt source number. **/
        Int_num = D_VICVectCntl[j] & 0x0000001F;
        Int_pos = LSB1 << Int_num;

        /** Clear the interrupt. **/
        D_TrIntSource = D_TrIntSource & (~Int_pos);
        ApplyIntr(0);

        /** Mark the end of the service routine by a write access to **/
        /** the VICVectAddr register.                                **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSW( , ZERO);
        WaitLoop(2);
 
        /** Update the CSR. **/
        CSR = CSR & ~intrpt;
      }
    }
  }

  /** Checking if any Non-Vectored IRQs are left. **/
  if (D_VICIRQStatus || D_VICIRQStatus)
  {
    /** Service and clear all the pending Non-Vectored IRQs. **/
    if (!(CSR || CSR))
    {
      /** If the first interrupt is a Non-Vectored IRQ, then its **/
      /** address would have been read. Hence, now it has to be  **/
      /** cleared.                                               **/ 
      intrpt1 = LSB1 << i1;
      if ((D_VICIRQStatus & intrpt1) == intrpt1)
      {

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP regsiter     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
        /** To indicate the status of nVICIRQ, VICITOP1 is read.    **/
        /** Since, the address is already been read, the nVICIRQ is **/
        /** high. Hence, the internal VICIRQ is low.                **/
        HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , Data0, , UnMaskIRQ, ,IntRoutines_18);

        /** To indicate the status of VICVectAddrOut, VICITOP2 is **/
        /** read.                                                 **/
        HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_19);
}

        /** The source which raised the first Non-Vectored Interrupt **/
        /** is cleared.                                              **/
        D_TrIntSource = D_TrIntSource & ~intrpt1;
        ApplyIntr(0);

        /** To mark the end of the ISR, a write access is conducted **/
        /** on the VICVectAddr.                                     **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSW( , ZERO);
        WaitLoop(2);
      }

      /** If the second interrupt is a Non-Vectored IRQ, then it **/
      /** would not have been serviced yet.                      **/
      intrpt2 = LSB1 << i2;
      if ((D_VICIRQStatus & intrpt1) == intrpt1)
      {

/** Some set_false_path are being done for the test mode paths in    **/
/** the VIC. These paths get exercised during ITIP/ITOP regsiter     **/
/** reads in netlist simulations leading to the buswatcher flagging  **/
/** timing violations on the HRDATA BUS. Hence, to bypass ITIP/ITOP  **/
/** register accesses during netlist simulations, a                  **/
/** "#define VICrtl_sim " directive is used in the Vic.h file. For   **/
/** only RTL simulations, the ITIP/ITOP registers are checked.       **/
/** For netlist simulations, the directive is "#define VICrtl_sim 0" **/
/** For RTL simulations, the directive is "#define VICrtl_sim 1"     **/
if (VICrtl_sim == 1)
{
        /** To indicate the status of nVICIRQ, VICITOP1 is read. **/
        HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , DataF, , UnMaskIRQ, ,IntRoutines_20);
  
        /** To indicate the status of VICVectAddrOut, VICITOP2 is **/
        /** read.                                                 **/
        HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_21);
}
  
        /** The VICVectAddr is read expecting the Default Address. **/
        /** This marks the beginning of the Interrupt Service      **/
        /** Routine.                                               **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_22);
  
        /** The interrupt which is currently being serviced is **/
        /** cleared.                                           **/
        intrpt2 = LSB1 << i2;
        D_TrIntSource = D_TrIntSource & ~intrpt2;
        ApplyIntr(0);

        /** A write access is done on the VICVectAddr. This marks **/
        /** the end of the Interrupt Service Routine.             **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSW( , ZERO);
        WaitLoop(2);
      }
    }
  }
}
 
/**********************************************************************/
/***************** Clear Two Interrupts Simultaneously ****************/
/**********************************************************************/

void SimulClear(int i1, int i2, int i3, int i4)
{
  /*
     Summary: Clears Two Interrupts simultaneously
     =============================================
     This function performs the following:
 
     o  Applies four interrupts simultaneously.
 
     o  The interrupts are serviced according to their priorities. 
        While clearing the highest-priority interrupt, the second
        highest priority interrupt is also cleared simultaneously.

     Two variables viz. 'intnum' and 'vectnum' are defined. These
     variables keep a track of the number of interrupts serviced. The 
     'intnum' keeps a track of the number of interrupts serviced and the
     'vectnum' keeps a track of the number of vectored interrupts 
     serviced. First, the FIQs are checked for. Then, the Vectored-IRQs
     and then the Non-Vectored-IRQs are checked for. When the value of 
     'intnum' is 1, which means that one interrupt is being serviced,
     none of the interrupts are cleared. The second highest priority
     interrupt is determined. Then both the interrupts are
     simultaneously cleared. 
  */
 
  int intnum, vectnum, k;
  int32 intru, int_num, int_pos;
 
  /** Application of the four interrupts. **/
  D_TrIntSource = FourInterrupt(i1, i2, i3, i4);
  ApplyIntr(0);

  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1); 
 
  /** Read Status Registers. **/
  ReadStatus();

  /** Store details of Vectored Interrupts. **/
  CurServReg();
 
  vectnum = 0;
  intnum = 0;

  /** Determine whether any source has raised an FIQ. **/
  if (D_VICFIQStatus)
  {
    intru = LSB1;
    for (k = 0; k < INT_COUNT; k++, intru = intru << 1)
    {
      if ((intru & D_VICFIQStatus) == intru)
      {

        /** Though the TrIntSource is not written with a new value **/
        /** till the second highest priority interrupt is not      **/
        /** determined, the variable D_TrIntSource is updated.     **/
        D_TrIntSource = D_TrIntSource & ~intru;
        intnum++;

        /** If one interrupt is being serviced, no interrupts will **/
        /** be cleared. Else, the interrupt is cleared.            **/
        if (intnum != 1)
        {
          ApplyIntr(0);
        }
      }
    }
  }
 
  /** Add one IDLE cycle to compensate for the one clock discrepancy **/
  /** due to the clocked output of the status registers.             **/
  WaitLoop(1);
 
  /** If one interrupt is being serviced, the status registers need **/
  /** not be read again.                                            **/
  if (intnum != 1)
  {
    /** Read Status Registers. **/
    ReadStatus();
  }
 
  /** Now, vectored interrupts are checked for. **/
  intru = LSB1;
  for (k = 0; k < VEC_COUNT; k++, intru = intru << 1)
  {
    if ((intru & CSR) == intru)
    {

      /** If one vectored interrupts is currently being serviced, **/
      /** then the vector address is not read. Else, the vector   **/
      /** address of the highest priority interrupt is read.      **/
      if (vectnum != 1)
      {
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICVectAddr[k], , NoMask, ,IntRoutines_23);
      }
 
      vectnum++;
      intnum++;
 
      /** Though the TrIntSource is not written with a new value    **/
      /** till the second highest priority interrupt is determined, **/
      /** the variable D_TrIntSource is updated.                    **/
      int_num = D_VICVectCntl[k] & 0x0000001F;
      int_pos = LSB1 << int_num;
      D_TrIntSource = D_TrIntSource & ~int_pos;
 
      /** If one interrupt is being serviced, no interrupts will be **/
      /** cleared. Else, the interrupt is cleared.                  **/
      if (intnum != 1)
      {
        ApplyIntr(0);

        /** To mark the end of the servicing, a write access is done **/
        /** to the Vector address register.                          **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSW( , ZERO);
      }
 
      /** CSR is updated. **/
      CSR = CSR & ~intru;
    }
  }

  /** If only one interrupt is serviced yet and that is a Vectored **/
  /** interrupt, then the interrupt is cleared.                    **/
  if ((intnum == 1) && (vectnum == 1))
  {
    ApplyIntr(0);
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
  }
 
  if (intnum != 1)
  {

    /** Read Status Registers. **/
    ReadStatus();
  }
 
  /** Now, Non Vectored interrupts are checked for. **/
  intru = LSB1;
  for (k = 0; k < INT_COUNT; k++, intru = intru << 1)
  {
    if ((intru & D_VICIRQStatus) == intru)
    {

      /** Though the TrIntSource is not written with a new value    **/
      /** till the second highest priority interrupt is determined, **/
      /** the variable D_TrIntSource is updated.                    **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICDefVectAddr, , NoMask, ,IntRoutines_24);
      D_TrIntSource = D_TrIntSource & ~intru;
 
      intnum++;

      /** If one interrupt is being serviced, no interrupts will be **/
      /** cleared. Else, the interrupt is cleared.                  **/
      if (intnum != 1)
      {
        ApplyIntr(0);

        /** To mark the end of the servicing, a write access is done **/
        /** to the Vector address register.                          **/
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSW( , ZERO);
      }
    }
  }
 
  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/**********************************************************************/
/****************** Initial values for the Registers ******************/
/**********************************************************************/

void InitValue(int choicenum)
{
  /*
     Summary: Initial values for the Registers
     =========================================
     This function performs the following:

     o  Generates 32 different initialisation sequences. 
 
     o  In 16 cases, there are no active External Interrupts.    
 
     o  In 4 cases, the External nVICFIQ is active

     o  In 4 cases, the External nVICIRQ is active

     o  In 8 cases, the External nVICFIQ and nVICIRQ are active

     o  The Vectored Interrupt Source is varied in the Control register

     o  The number of enabled interrupts are varied 

     o  The number of enabled FIQa and IRQs are varied. 
  */

  int choice;
 
  switch (choice = choicenum)
  {
    case 0: C("Case 0 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000020;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 1: C("Case 1 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000021;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 2: C("Case 2 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000022;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 3: C("Case 3 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000023;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 4: C("Case 4 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000024;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x00000000;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 5: C("Case 5 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000025;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xF0F0F0F0;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 6: C("Case 6 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000026;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x0F0F0F0F;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 7: C("Case 7 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000027;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x00FFFF00;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 8: C("Case 8 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000028;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xAAAAAAAA;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 9: C("Case 9 Initialisation");
            init_addr = 0x0000A000;
            init_cntl = 0x00000029;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFA5005AF;
            D_TrIntIn = NoExtInt;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 10: C("Case 10 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002A;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x55555555;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 11: C("Case 11 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002B;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;
 
    case 12: C("Case 12 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002C;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 13: C("Case 13 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002D;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;
 
    case 14: C("Case 14 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002E;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 15: C("Case 15 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000002F;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_TrIntIn = NoExtInt;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;

             break;

    /** External nVICFIQ is active. **/
    case 16: C("Case 16 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000030;
 
             D_VICIntEnable = 0x00000000;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = 0x00000002;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 17: C("Case 17 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000031;
 
             D_VICIntEnable = 0x0000FFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = Data1;
             D_TrIntIn = 0x00000002;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 18: C("Case 18 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000032;
 
             D_VICIntEnable = 0xFFFF0000;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = Data2;
             D_TrIntIn = 0x00000002;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 19: C("Case 19 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000033;
 
             D_VICIntEnable = 0xAAAAAAAA;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x33333333;
             D_TrIntIn = 0x00000002;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICIRQ is active. **/
    case 20: C("Case 20 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000034;
 
             D_VICIntEnable = 0x55555555;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_TrIntIn = 0x00000001;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000BBBB;
 
             break;
 
    /** External nVICIRQ is active. **/
    case 21: C("Case 21 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000035;
 
             D_VICIntEnable = 0xF0F0F0F0;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_TrIntIn = 0x00000001;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBB0000;
 
             break;

    /** External nVICIRQ is active. **/
    case 22: C("Case 22 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000036;
 
             D_VICIntEnable = 0x0F0F0F0F;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xF0000FFF;
             D_TrIntIn = 0x00000001;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xAAAA0000;
 
             break;

    /** External nVICIRQ is active. **/
    case 23: C("Case 23 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000037;
 
             D_VICIntEnable = 0x05AF05AF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFF0000FF;
             D_TrIntIn = 0x00000001;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000AAAA;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 24: C("Case 24 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000038;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFF0000F;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000BBBB;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 25: C("Case 25 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x00000039;
 
             D_VICIntEnable = 0x0FFFFFF0;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBB0000;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 26: C("Case 26 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003A;
 
             D_VICIntEnable = 0xF0FFFF0F;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0FFFF000;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x55555555;
  
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 27: C("Case 27 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003B;
 
             D_VICIntEnable = 0xFF0FF0FF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x00FFFF00;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x11111111;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 28: C("Case 28 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003C;
 
             D_VICIntEnable = 0xFFF00FFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x000FFFF0;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x22222222;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 29: C("Case 29 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003D;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x01234567;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x33333333;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 30: C("Case 30 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003E;

             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x89ABCD00;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x44444444;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 31: C("Case 31 Initialisation");
             init_addr = 0x0000A000;
             init_cntl = 0x0000003F;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_TrIntIn = 0x00000000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBBBBBB;
 
             break;
 
   }
}

/**********************************************************************/
/******************** Initialise all the Registers ********************/
/**********************************************************************/

void Initialise(int32 D_VICIntEnable, int32 D_VICSoftInt,
                int32 D_VICIntSelect, int32 D_TrIntIn,
                int32 D_TrVectAddrIn, int32 ProtectionOff,
                int32 initial_cntl, int32 initial_addr, int EnVectIRQ)
{
  /*
     Summary: Initialise all the registers
     =====================================
     This function performs the following:
 
     o  Writes the initial data into all the registers.
  */

  int i;
  int32 ADD_ADDR, ADD_CNTL;
 
  /** Clear all IntEnable and SoftInt bits to clear any pending **/
  /** Interrupts.                                               **/
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , DataF);
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , DataF);

  /** Set the IntEnable and SoftInt bits based on the value passed **/
  /** from the InitValue() function.                               **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICIntEnable);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICSoftInt);

  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICIntSelect);

  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_TrIntIn);

  HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_TrVectAddrIn);

  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ProtectionOff);

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICDefVectAddr);

  /** Enable protocol checkers in the Trickbox. **/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICTrTCR);

  /** Clear the Vectored Interrupt Enable bit. **/
  if (EnVectIRQ == 0)
  {
    init_cntl = init_cntl & 0xFFFFFFDF;
  }

  /** Program all control registers using burst transfers. **/
  ADD_CNTL = VICVectCntl_BASE;
  HSA(ADD_CNTL, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_cntl);
  D_VICVectCntl[0] = init_cntl;
  init_cntl++;
  for (i = 1; i < VEC_COUNT; i++)
  {
    if ((init_cntl == 0x00000040) && (EnVectIRQ == 1))
    {
      init_cntl = 0x00000020;
    }
    if ((init_cntl == 0x00000020) && (EnVectIRQ == 0))
    {
      init_cntl = 0x00000000;
    }
    HSW( , init_cntl);
    D_VICVectCntl[i] = init_cntl;
    init_cntl++;
  }

  /** Program all address registers using burst transfers. IDLE and **/
  /** BUSY transfers are introduced during the burst.               **/
  ADD_ADDR = VICVectAddr_BASE;
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[0] = init_addr;
  init_addr += 0x4;
  ADD_ADDR += 0x4;
  HSA(ADD_ADDR, IDLE, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, IDLE, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[1] = init_addr;
  init_addr += 0x4;
  for (i = 2; i < 8; i++)
  {
    HSW( , init_addr);
    D_VICVectAddr[i] = init_addr;
    init_addr += 0x4;
  }
  ADD_ADDR += 0x1C;
  HSA(ADD_ADDR, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[8] = init_addr;
  init_addr += 0x4;
  ADD_ADDR += 0x4;
  HSA(ADD_ADDR, BUSY, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, BUSY, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  HSA(ADD_ADDR, SEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , init_addr);
  D_VICVectAddr[9] = init_addr;
  init_addr += 0x4;
  for (i = 10; i < VEC_COUNT; i++)
  {
    HSW( , init_addr);
    D_VICVectAddr[i] = init_addr;
    init_addr += 0x4;
  }
}

/******************************** End *********************************/
