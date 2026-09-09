/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntRoutines.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains all the functions which are used only by
--           the Interrupt tests. (The Interrupts tests are
--           'UserOneIntTests', 'TwoFourIntTest', 'EightAllIntTests' etc.)
--
-- --=========================================================================*/
 
/*#include <stdlib.h>*/

/******************************************************************************/
/********************* List of Functions Called *******************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ReadStatus()                               IntRoutines.c               ***/
/*** WaitLoop()                                 VicCommon.c                 ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** CurServReg()                               IntRoutines.c               ***/
/*** FIQServ()                                  IntRoutines.c               ***/
/*** IRQServ()                                  IntRoutines.c               ***/
/*** UserIntService()                           IntRoutines.c               ***/
/******************************************************************************/
 
/******************************************************************************/
/*************************** Apply Interrupt **********************************/
/******************************************************************************/

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
    /** ZEROs to the previously unaffected bit positions.           **/
    HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ~D_TrIntSource, ,SoftIntClear_write);
  }
    WaitLoop(3);
}
 
/******************************************************************************/
/************************ Read Status Registers *******************************/
/******************************************************************************/

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
  HSA(VICRawIntr, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSR( , D_VICRawIntr, , NoMask, ,IntRoutines_3);
}
 
/******************************************************************************/
/********************** Current Service Register ******************************/
/******************************************************************************/

void CurServReg()
{
  /*
     Summary: Current Service Register
     =================================
     This function performs the following:
 
     o  Determines the active Vectored interrupts and stores them in a 
        variable called CSR.
     
     In order to keep a track of all the vectored interrupt sources
     which are currently active, a 32-bit hex variable called CSR is
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
 
  CSR = 0x00000000;
  CSR = D_VICIRQStatus;
}
 
/******************************************************************************/
/********************** Clear All FIQ Interrupts ******************************/
/******************************************************************************/

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
   /** the VIC. These paths get exercised during ITIP/ITOP register     **/
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

/******************************************************************************/
/***************** Clear All Vectored IRQ Interrupts **************************/
/******************************************************************************/
void DaisyServ()
{
  if ((D_TrIntIn & 0x00000002) == 0x00000000)
  {
    WaitLoop(2);
  /** Check if an External IRQ interrupt is pending. **/
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot)
    HSR( , D_TrVectAddrIn, , NoMask, ,IntRoutines_Daisy);

    /** The bit causing the IRQ is cleared. **/
    D_TrIntIn = D_TrIntIn | 0x00000002;
    HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , D_TrIntIn);

    /** A write access is done on the VICVectAddr. This marks the **/
    /** end of the Interrupt Service Routine.                     **/
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO);
  }
}

/******************************************************************************/
/***************** Clear All Vectored IRQ Interrupts **************************/
/******************************************************************************/

void IRQServ(int select)
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
  int32 intr, Int_num, Int_pos, address, hiprio;
  char debugstr[120];
 
  /** Read Status Registers. **/
  ReadStatus();
 
  for (j = 0; j < INT_COUNT; j++)
  {
    intr = LSB1;
    hiprio = SWPrio[j];
    intr = intr << hiprio;
    intr = intr & ~D_VICIntSelect;

    /* Service the higher priority Daisy interrupt. */
    if(D_VICVectPriorityDaisy < D_VICVectPriority[hiprio])
    {
      DaisyServ(); 
    }  

    if (((intr & CSR) == intr) & (intr != 0))
    {

      WaitLoop(2);

    /** Some set_false_path are being done for the test mode paths in    **/
    /** the VIC. These paths get exercised during ITIP/ITOP register     **/
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
        HSR( , D_VICVectAddr[hiprio], , NoMask, ,IntRoutines_9);
      }

      /** A VICVectAddr access is performed assuming the word size **/
      /** to be Half-Word. This is done for an Error response.     **/
      HSA(VICVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1);
      HSR( , ZERO, , NoMask, ,IntRoutines_10);

      /** The VICVectAddr is read. This marks the beginning of the **/
      /** Interrupt Service Routine.                               **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICVectAddr[hiprio], , NoMask, ,IntRoutines_11);
 
      /** The interrupt, which is currently being serviced is **/
      /** cleared.                                           **/
      D_TrIntSource = D_TrIntSource & (~intr);
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
  /* Service Daisy interrupt if it's there. */
  DaisyServ(); 
 
}
 
/******************************************************************************/
/************************ Apply One Interrupt *********************************/
/******************************************************************************/

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
 
/******************************************************************************/
/************************ Apply Two Interrupts ********************************/
/******************************************************************************/

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

/******************************************************************************/
/*********************** Apply Four Interrupts ********************************/
/******************************************************************************/

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
 
/******************************************************************************/
/*********************** Apply Eight Interrupts *******************************/
/******************************************************************************/

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
 
/******************************************************************************/
/********************** Apply Sixteen Interrupts ******************************/
/******************************************************************************/

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
 
/******************************************************************************/
/************************ Apply All Interrupts ********************************/
/******************************************************************************/

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
 
/******************************************************************************/
/**************** Service and Clear All the Interrupts ************************/
/******************************************************************************/

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
 
     o  Executes the IRQs, if any, in the order of priority.
 
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
  if ((D_VICIRQStatus) || ((~D_TrIntIn & 0x00000002) == 0x00000002))
  {

      /** Service and clear all the Vectored IRQs in the order of **/
      /** their priorities.                                       **/
      IRQServ(select);
  }
}
 
/******************************************************************************/
/*************** Service and Clear a specific Interrupt ***********************/
/******************************************************************************/

void UserIntService(int intr)
{
  /*
     Summary: Services a Specific Interrupt
     ======================================
     This function performs the following:
 
     o  Clears the interrupt specified by the user.

     This function is called when the user decides the order in which 
     interrupts are to  be cleared. The interrupts may not be cleared in
     their priority order. Hence, while clearing the Vectored Interrupt
     once the VectAddrOut is read it should not be read until this 
     particular interrupt bit is cleared. Hence, a 16-bit global
     variable called servreg is used. 

  */

  int i, j, k, inter, cleared = 0, next = 1;
  int32 shiftbit, clrbit, clrCSR;
  int32 hiprio;
 
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
    for (i = 0; i < INT_COUNT; i++)
    {
        inter = LSB1;
        for (j = 0; j < INT_COUNT; j++, inter = LSB1)
        {
          hiprio = SWPrio[j];
          inter = inter << hiprio;
          inter = inter & ~D_VICIntSelect;
          if ((inter != 0) && ((inter & CSR) == inter) && 
              (next == 1) && (servreg == Data0))
          {

            /** If the source raised a Vectored interrupt and        **/
            /** previously no Vectored interrupts are being          **/
            /** serviced, the VICVectAddr register is read expecting **/
            /** the required address.                                **/
            addrout = D_VICVectAddr[hiprio];
            HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
            HSR( , addrout, , NoMask, ,IntRoutines_12);

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
 
    /** Add one IDLE cycle to compensate for the one clock  **/
    /** discrepancy due to the clocked output of the status **/
    /** registers.                                          **/
    WaitLoop(1);

    /** Read Status Registers. **/
    ReadStatus();
  }
}
 
/******************************************************************************/
/******************* Service and Clear Two Interrupts *************************/
/******************************************************************************/

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

/******************************************************************************/
/****************** Service and Clear Four Interrupts *************************/
/******************************************************************************/

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
 
/******************************************************************************/
/****************** Service and Clear Eight Interrupts ************************/
/******************************************************************************/

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
 
/******************************************************************************/
/***************** Service and Clear Sixteen Interrupts ***********************/
/******************************************************************************/

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
 
/******************************************************************************/
/**************** Service and Clear Thirty-Two Interrupts *********************/
/******************************************************************************/

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
 
/******************************************************************************/
/*********** Apply and Service Two Non-Simultaneous Interrupts ****************/
/******************************************************************************/

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
  int32 lowi2, hiprio;
  char debugstr[120];
 
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
    for (k = 0; k < INT_COUNT; k++, intru = intru << 1)
    {
      if ((intru & CSR) == intru)
      {
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICVectAddr[k], , NoMask, ,IntRoutines_14);
      }
    }
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
 
  /* To reflect the SW priority */
  if(D_VICVectPriority[i1] > D_VICVectPriority[i2])
  {
    lowi2 = 1;
  }
  else if(D_VICVectPriority[i1] < D_VICVectPriority[i2])
  {
    lowi2 = 0;
  }
  else if(CSR1 < CSR2)
  {
    lowi2 = 1;
  }
  else
  {
    lowi2 = 0;
  }
  /** Now, there are no FIQs pending. Determine whether the first   **/
  /** interrupt is a Vectored-IRQ and if the second is IRQ of lower **/
  /** priority. In both cases the address out won't change on the   **/
  /** application of the second interrupt. And the first interrupt  **/
  /** can now be cleared.                                           **/
  if ((CSR1 != 0x0000) & ((lowi2 = 1) | (CSR2 == 0x0000))) 
  {

    /** If the first interrupt had higher priority it is cleared **/
    /** here.                                                    **/
    intru = LSB1 << i1;
    D_TrIntSource = D_TrIntSource & ~intru;
    ApplyIntr(0);

    /** End the ISR by writing to the VICVectAddr register. **/
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , ZERO, ,IntRoutines_30);
    WaitLoop(2);

    /** CSR is updated. **/
    CSR = CSR & ~CSR1;
    
    /** Now acknowledging and clearing the second interrupt if it was a IRQ **/
    /** of lower priority.                                                  **/
    if(CSR2 != 0)
    {

      /** The VICVectAddr is read. This marks the beginning of the **/
      /** Interrupt Service Routine.                               **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSR( , D_VICVectAddr[i2], , NoMask, ,IntRoutines_31);
     
      /** The interrupt, which is currently being serviced is **/
      /** cleared.                                           **/
      intru = LSB1 << i2;
      D_TrIntSource = D_TrIntSource & (~intru);
      ApplyIntr(0);
     
      /** A write access is done on the VICVectAddr. This marks the **/
      /** end of the Interrupt Service Routine.                     **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSW( , ZERO);
     
      /** The CSR is updated by writing a '0' in the corresponding **/
      /** bit position.                                            **/
      CSR = CSR & ~intru;
    }
  }

  /** The interrupt to be cleared first is the second interrupt,     **/
  /** which is a vectored interrupt. This condition occurs, when the **/
  /** second interrupt is a vectored interrupt of higher priority.   **/
  else
  {
    intrpt = LSB1;
    for (j = 0; j < INT_COUNT; j++, intrpt = LSB1)
    {
      hiprio = SWPrio[j];
      intrpt = intrpt << hiprio;
      intrpt = intrpt & ~D_VICIntSelect;
      if (((intrpt & CSR) == intrpt) & (intrpt != 0))
      {
        if (CSR == (CSR2 | CSR1))
        {
          /** Beginning of the Service Routine of the second **/
          /** interrupt.                                     **/
          HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
          HSR( , D_VICVectAddr[hiprio], , NoMask, ,IntRoutines_16);
        }

        /** Clear the interrupt. **/
        D_TrIntSource = D_TrIntSource & (~intrpt);
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
}
 
/******************************************************************************/
/***************** Clear Two Interrupts Simultaneously ************************/
/******************************************************************************/

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
     serviced. First, the FIQs are checked for. Then, IRQs are checked 
     for. When the value of 
     'intnum' is 1, which means that one interrupt is being serviced,
     none of the interrupts are cleared. The second highest priority
     interrupt is determined. Then both the interrupts are
     simultaneously cleared. 
  */
 
  int intnum, vectnum, k;
  int32 intru, int_num, int_pos;
  int32 hiprio;
  char debugstr[120];
 
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
  for (k = 0; k < INT_COUNT; k++, intru = LSB1)
  {
    hiprio = SWPrio[k];
    intru = intru << hiprio;
    intru = intru & ~D_VICIntSelect;
    if (((intru & CSR) == intru) & (intru != 0))
    {
      /** If one of the  interrupts is currently being serviced,  **/
      /** then the vector address is not read. Else, the vector   **/
      /** address of the highest priority interrupt is read.      **/
      WaitLoop(2);
      if (intnum != 1)
      {
        HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICVectAddr[hiprio], , NoMask, ,IntRoutines_23);
      }
 
      intnum++;
 
      D_TrIntSource = D_TrIntSource & ~intru;
 
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
    if (CSR == 0)
      break;
  }

}
 
/******************************************************************************/
/****************** Initial values for the Registers **************************/
/******************************************************************************/

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

  int choice, i;

  D_VICTrTCR = 0x05F;
 
  C("Programming interrupt source register.");
  switch (choice = choicenum)
  {
    /* No Daisy - with Daisy Highest priority */
    case 0: C("Case 0 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x00000008;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_VICSWPriorityMask = 0xFFFF;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0000;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 1: C("Case 1 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x00000009;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_VICSWPriorityMask = 0xF50A;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0001;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 2: C("Case 2 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000A;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_VICSWPriorityMask = 0x0AF5;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0002;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 3: C("Case 3 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000B;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFFFF0000;
            D_VICSWPriorityMask = 0x1111;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0003;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 4: C("Case 4 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000C;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x00000000;
            D_VICSWPriorityMask = 0xFFFF;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0004;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 5: C("Case 5 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000D;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xF0F0F0F0;
            D_VICSWPriorityMask = 0x3333;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0005;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 6: C("Case 6 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000E;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x0F0F0F0F;
            D_VICSWPriorityMask = 0x5555;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0006;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 7: C("Case 7 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x0000000F;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0x00FFFF00;
            D_VICSWPriorityMask = 0x7777;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0007;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 8: C("Case 8 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x00000000;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xAAAAAAAA;
            D_VICSWPriorityMask = 0xAAAA;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0008;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 9: C("Case 9 Initialisation");
            init_addr = 0x0000A000;
            init_swprio = 0x00000001;

            D_VICIntEnable = 0xFFFFFFFF;
            D_VICSoftInt = 0x00000000;
            D_VICIntSelect = 0xFA5005AF;
            D_VICSWPriorityMask = 0xCCCC;
            D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x0009;
            ProtectionOff = 0x00000000;
            D_TrVectAddrIn = 0x00000000;

            break;

    case 10: C("Case 10 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000002;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x55555555;
            D_VICSWPriorityMask = 0xFFFE;
             D_TrIntIn = NoExtInt;
            D_VICVectPriorityDaisy = 0x000a;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 11: C("Case 11 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000003;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
            D_VICSWPriorityMask = 0xFFFD;
             D_TrIntIn = NoExtInt;
             D_VICVectPriorityDaisy = 0x000b;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;
 
    case 12: C("Case 12 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000004;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
            D_VICSWPriorityMask = 0xFFFB;
             D_TrIntIn = NoExtInt;
             D_VICVectPriorityDaisy = 0x000c;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 13: C("Case 13 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000005;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
            D_VICSWPriorityMask = 0xFFF7;
             D_TrIntIn = NoExtInt;
             D_VICVectPriorityDaisy = 0x000d;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;
 
    case 14: C("Case 14 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000006;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
            D_VICSWPriorityMask = 0xFFEF;
             D_TrIntIn = NoExtInt;
             D_VICVectPriorityDaisy = 0x000e;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;
 
             break;

    case 15: C("Case 15 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000007;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
            D_VICSWPriorityMask = 0xFFDF;
             D_TrIntIn = NoExtInt;
             D_VICVectPriorityDaisy = 0x000f;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x00000000;

             break;

    /** External nVICFIQ is active. **/
    case 16: C("Case 16 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000008;
 
             D_VICIntEnable = 0x00000000;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
            D_VICSWPriorityMask = 0xFFBF;
             D_TrIntIn = 0x00000002;
             D_VICVectPriorityDaisy = 0x0000;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 17: C("Case 17 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000009;
 
             D_VICIntEnable = 0x0000FFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = Data1;
             D_VICSWPriorityMask = 0xFF7F;
             D_TrIntIn = 0x00000002;
             D_VICVectPriorityDaisy = 0x0001;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 18: C("Case 18 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000A;
 
             D_VICIntEnable = 0xFFFF0000;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = Data2;
             D_VICSWPriorityMask = 0xFEFF;
             D_TrIntIn = 0x00000002;
             D_VICVectPriorityDaisy = 0x0002;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICFIQ is active. **/
    case 19: C("Case 19 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000B;
 
             D_VICIntEnable = 0xAAAAAAAA;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x33333333;
             D_VICSWPriorityMask = 0xFDFF;
             D_TrIntIn = 0x00000002;
             D_VICVectPriorityDaisy = 0x0003;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x12345678;
 
             break;

    /** External nVICIRQ is active. **/
    case 20: C("Case 20 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000C;
 
             D_VICIntEnable = 0x55555555;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_VICSWPriorityMask = 0xFBFF;
             D_TrIntIn = 0x00000001;
             D_VICVectPriorityDaisy = 0x0004;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000BBBB;
 
             break;
 
    /** External nVICIRQ is active. **/
    case 21: C("Case 21 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000D;
 
             D_VICIntEnable = 0xF0F0F0F0;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0000FFFF;
             D_VICSWPriorityMask = 0xF7FF;
             D_TrIntIn = 0x00000001;
             D_VICVectPriorityDaisy = 0x0005;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBB0000;
 
             break;

    /** External nVICIRQ is active. **/
    case 22: C("Case 22 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000E;
 
             D_VICIntEnable = 0x0F0F0F0F;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xF0000FFF;
             D_VICSWPriorityMask = 0xEFFF;
             D_TrIntIn = 0x00000001;
             D_VICVectPriorityDaisy = 0x0006;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xAAAA0000;
 
             break;

    /** External nVICIRQ is active. **/
    case 23: C("Case 23 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x0000000F;
 
             D_VICIntEnable = 0x05AF05AF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFF0000FF;
             D_VICSWPriorityMask = 0xDFFF;
             D_TrIntIn = 0x00000001;
             D_VICVectPriorityDaisy = 0x0007;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000AAAA;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 24: C("Case 24 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000000;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFF0000F;
             D_VICSWPriorityMask = 0xBFFF;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x0008;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x0000BBBB;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 25: C("Case 25 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000001;
 
             D_VICIntEnable = 0x0FFFFFF0;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_VICSWPriorityMask = 0x7FFF;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x0009;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBB0000;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 26: C("Case 26 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000002;
 
             D_VICIntEnable = 0xF0FFFF0F;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x0FFFF000;
             D_VICSWPriorityMask = 0xFFFF;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000a;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x55555555;
  
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 27: C("Case 27 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000003;
 
             D_VICIntEnable = 0xFF0FF0FF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x00FFFF00;
             D_VICSWPriorityMask = 0xFFFF;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000b;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x11111111;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 28: C("Case 28 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000004;
 
             D_VICIntEnable = 0xFFF00FFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x000FFFF0;
             D_VICSWPriorityMask = 0x1234;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000c;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x22222222;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 29: C("Case 29 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000005;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x01234567;
             D_VICSWPriorityMask = 0x5678;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000d;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x33333333;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 30: C("Case 30 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000006;

             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0x89ABCD00;
             D_VICSWPriorityMask = 0x9ABC;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000e;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0x44444444;
 
             break;
 
    /** External nVICIRQ and nVICFIQ are active. **/
    case 31: C("Case 31 Initialisation");
             init_addr = 0x0000A000;
             init_swprio = 0x00000007;
 
             D_VICIntEnable = 0xFFFFFFFF;
             D_VICSoftInt = 0x00000000;
             D_VICIntSelect = 0xFFFF0000;
             D_VICSWPriorityMask = 0xDEF0;
             D_TrIntIn = 0x00000000;
             D_VICVectPriorityDaisy = 0x000f;
             ProtectionOff = 0x00000000;
             D_TrVectAddrIn = 0xBBBBBBBB;
 
             break;
 
   }

   /* VIC port is assumed to be not supported by default.   */
   /* So the VICTrAckCnt register is programmed to be zero. */
   D_VICTrAckCnt = 0x0;

   /* Programming software priority values. */

   C("Programming software priority values.");
   for(i = 0; i < INT_COUNT/2 ; i++, init_swprio++)
   {
      init_swprio = init_swprio & 0xF;
      if(choicenum < 16)
      {
          D_VICVectPriority[2*i]   = init_swprio;
          D_VICVectPriority[2*i+1] = init_swprio;

          SWPrio[2*init_swprio]   = 2*i;
          SWPrio[2*init_swprio+1] = 2*i + 1;
      }
      else 
      {
          D_VICVectPriority[i]             = init_swprio;
          D_VICVectPriority[INT_COUNT-1-i] = init_swprio;
          SWPrio[2*init_swprio]   = i;
          SWPrio[2*init_swprio+1] = INT_COUNT-1-i;
      }
   }
}

/******************************************************************************/
/******************** Initialise all the Registers ****************************/
/******************************************************************************/

void Initialise()
{
  /*
     Summary: Initialise all the registers
     =====================================
     This function performs the following:
 
     o  Writes the initial data into all the registers.
  */

  int i;
  int32 ADD_ADDR, ADD_PRIO;
 
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

  HSA(VICVectPriorityDaisy, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICVectPriorityDaisy);

  HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_TrVectAddrIn);

  HSA(VICTrAckCnt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICTrAckCnt);

  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ProtectionOff);

  /** Enable protocol checkers in the Trickbox. **/
  HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_VICTrTCR);

  /** Program all software priority registers using burst transfers. **/
  ADD_PRIO = VICVectPriority_BASE;
  HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
  HSW( , D_VICVectPriority[0]);
  for (i = 1; i < INT_COUNT; i++)
  {
    HSW( , D_VICVectPriority[i]);
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
  for (i = 10; i < INT_COUNT; i++)
  {
    HSW( , init_addr);
    D_VICVectAddr[i] = init_addr;
    init_addr += 0x4;
  }
}

/******************************************************************************/
/****************** Randomly assign initial values. ***************************/
/******************************************************************************/
void InitRandValue(int seed)
{
  int32 TRand32;
  
  int i;
 
  /***************  Vector address is constant ***********************/
  init_addr = 0x0000A000; 

  /***************  Interrupt Enable is random ***********************/
  /*srandom(seed);*/
  /*TRand32 = random();*/
  TRand32 = Data5;
  D_VICIntEnable = TRand32;

  /**********************  Interrupt select ***************************/
  /*srandom(seed);*/
  /*TRand32 = random();*/
  /************** 16IRQs (LSBs) and 16 FIQs (MSBs) ********************/
  TRand32 = 0xFFFF0000;
  D_VICIntSelect = TRand32;

  /************  Interrupt In is Zero. No Daisy. **********************/
  D_TrIntIn      = NoExtInt;
  D_TrVectAddrIn = 0x00000000;

  /******************* TrTcr Register *********************************/
  /*  bit 0 : FIQ Compare enable, bit 1 : IRQ Compare enable          */
  /*  bit 2 : Vect Addr Comp ena, bit 3 : Addr Out Comp enable        */
  /*  bit 4 : Ack Out  Comp enab, bit 5 : HCLK Off                    */
  /*  bit 6 : Clk Ratio 1:1     , bit 7 : Clk Ratio 1:2               */
  /********************************************************************/
  D_VICTrTCR = 0x05F;

  for (i = 0; i < 4; i += 8)
  {
    /*srand(seed++)*/
    /*TRand32 = random();*/
    TRand32 = 0x01234567;

    D_VICVectPriority[i+0] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+1] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+2] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+3] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+4] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+5] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+6] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
    D_VICVectPriority[i+7] = TRand32 & 0x0000000F;
    TRand32 = TRand32 >> 4;
  }

}
/******************************** End *****************************************/
