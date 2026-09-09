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
-- File Name              : VicIntServ.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           All routines for VIC port enabled CPU's Interrupt 
--           servicing.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ReadStatus()                               IntRoutines.c               ***/
/*** WaitLoop()                                 VicCommon.c                 ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** CurServReg()                               IntRoutines.c               ***/
/*** FIQServ()                                  IntRoutines.c               ***/
/*** VicIRQServ()                               IntRoutines.c               ***/
/*** VicUserIntService()                        IntRoutines.c               ***/
/******************************************************************************/
 
 
/******************************************************************************/
/********************* Clear All Vectored IRQ Interrupts **********************/
/******************************************************************************/
void VicDaisyServ()
{
  if ((D_TrIntIn & 0x00000002) == 0x00000000)
  {
    WaitLoop(2);

    C("Polling for Address Valid");
    WaitLoop(3);
    HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HPO( , ADDRV, , , );
    WaitLoop(3);
    /* Is this more Correct? 
    HPO( , ADDRV, , UnMaskIRQ, ,Poll_ADDRV_Daisy); */

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
/********************* Clear All Vectored IRQ Interrupts **********************/
/******************************************************************************/

void VicIRQServ(int select)
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
 
  /** Read Status Registers. **/
  ReadStatus();
 
  for (j = 0; j < INT_COUNT; j++)
  {
    intr = LSB1;
    hiprio = SWPrio[j];
    intr = intr << hiprio;
    intr = intr & ~D_VICIntSelect;

    /* Service the higher priority Daisy interrupt. */
    if(D_VICVectPriorityDaisy <= D_VICVectPriority[hiprio])
    {
      VicDaisyServ(); 
    }  

    if (((intr & CSR) == intr) & (intr != 0))
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
        /** To indicate the status of VICVectAddrOut, VICITOP2 is **/
        /** read.                                                 **/
        WaitLoop(1);
        HSA(VICITOP2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HSR( , D_VICVectAddr[hiprio], , NoMask, ,VicIntServ_2);
      }

      /** A VICVectAddr access is performed assuming the word size **/
      /** to be Half-Word. This is done for an Error response.     **/
      HSA(VICVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1);
      HSR( , ZERO, , NoMask, ,VicIntServ_3);

      WaitLoop(3);
      HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HPO( , ADDRV, , , );
      WaitLoop(3);
 
      /** The interrupt, which is currenty being serviced is **/
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
  /* Service Daisy If there is any. */
  VicDaisyServ(); 
 
}
 
 
/******************************************************************************/
/******************** Service and Clear All the Interrupts ********************/
/******************************************************************************/

void VicAllIntService(int select)
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
      VicIRQServ(select);
  }
}
 
/******************************************************************************/
/******************* Service and Clear a specific Interrupt *******************/
/******************************************************************************/

void VicUserIntService(int intr)
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
           /* Poll the ADDRV (Address Valid) if an interrupt is found. */
            WaitLoop(3);
            HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
            HPO( , ADDRV, , , );
            WaitLoop(3);

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
/*********************** Service and Clear Two Interrupts *********************/
/******************************************************************************/

void VicServiceTwo(int c1, int c2)
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
  VicUserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c2);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
  WaitLoop(3);
}

/******************************************************************************/
/********************** Service and Clear Four Interrupts *********************/
/******************************************************************************/

void VicServiceFour(int c1, int c2, int c3, int c4)
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
  VicUserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c4);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/******************************************************************************/
/********************** Service and Clear Eight Interrupts ********************/
/******************************************************************************/

void VicServiceEight(int c1, int c2, int c3, int c4, int c5, int c6,
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
  VicUserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c8);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/******************************************************************************/
/********************* Service and Clear Sixteen Interrupts *******************/
/******************************************************************************/

void VicServiceSxtn(int c1, int c2, int c3, int c4, int c5, int c6, int c7,
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
  VicUserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c8);

  /** The interrupt raised by source c9 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c9);

  /** The interrupt raised by source c10 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c10);

  /** The interrupt raised by source c11 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c11);

  /** The interrupt raised by source c12 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c12);

  /** The interrupt raised by source c13 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c13);

  /** The interrupt raised by source c14 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c14);

  /** The interrupt raised by source c15 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c15);

  /** The interrupt raised by source c16 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c16);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/******************************************************************************/
/******************** Service and Clear Thirty-Two Interrupts *****************/
/******************************************************************************/

void VicServiceAll(int c1, int c2, int c3, int c4, int c5, int c6, int c7,
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
  VicUserIntService(c1);

  /** The interrupt raised by source c2 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c2);

  /** The interrupt raised by source c3 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c3);

  /** The interrupt raised by source c4 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c4);

  /** The interrupt raised by source c5 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c5);

  /** The interrupt raised by source c6 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c6);

  /** The interrupt raised by source c7 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c7);

  /** The interrupt raised by source c8 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c8);

  /** The interrupt raised by source c9 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then   **/
  /** this interrupt is not serviced. It is just cleared.           **/
  VicUserIntService(c9);

  /** The interrupt raised by source c10 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c10);

  /** The interrupt raised by source c11 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c11);

  /** The interrupt raised by source c12 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c12);

  /** The interrupt raised by source c13 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c13);

  /** The interrupt raised by source c14 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c14);

  /** The interrupt raised by source c15 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c15);

  /** The interrupt raised by source c16 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c16);

  /** The interrupt raised by source c17 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c17);

  /** The interrupt raised by source c18 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c18);

  /** The interrupt raised by source c19 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c19);

  /** The interrupt raised by source c20 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c20);

  /** The interrupt raised by source c21 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c21);

  /** The interrupt raised by source c22 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c22);

  /** The interrupt raised by source c23 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c23);

  /** The interrupt raised by source c24 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c24);

  /** The interrupt raised by source c25 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c25);

  /** The interrupt raised by source c26 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c26);

  /** The interrupt raised by source c27 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c27);

  /** The interrupt raised by source c28 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c28);

  /** The interrupt raised by source c29 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c29);

  /** The interrupt raised by source c30 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c30);

  /** The interrupt raised by source c31 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c31);

  /** The interrupt raised by source c32 is serviced and cleared. If **/
  /** a higher priority interrupt is already being serviced, then    **/
  /** this interrupt is not serviced. It is just cleared.            **/
  VicUserIntService(c32);

  /** Clear ALL interrupt sources. **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}
 
/******************************************************************************/
/*************** Apply and Service Two Non-Simultaneous Interrupts ************/
/******************************************************************************/

void VicTwoDiffInt(int i1, int i2)
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
        WaitLoop(3);
        HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
        HPO( , ADDRV, , , );
        WaitLoop(3);
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
    HSW( , ZERO, ,VicIntServ_7);
    WaitLoop(2);

    /** CSR is updated. **/
    CSR = CSR & ~CSR1;
    
    /** Now acknowledging and clearing the second interrupt if it was a IRQ **/
    /** of lower priority.                                                  **/
    if(CSR2 != 0)
    {

      /** Poll For Address valid to clear the interrupt.           **/
      WaitLoop(3);
      HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HPO( , ADDRV, , , );
      WaitLoop(3);
     
      /** The interrupt, which is currenty being serviced is **/
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
        /* Poll for Address Valid. */
          WaitLoop(3);
          HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
          HPO( , ADDRV, , , );
          WaitLoop(3);
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
/********************* Clear Two Interrupts Simultaneously ********************/
/******************************************************************************/

void VicSimulClear(int i1, int i2, int i3, int i4)
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
      /** then the vector address valid is not polled.            **/
      WaitLoop(2);
      if (intnum != 1)
      {
        /* Poll the ADDRV (Address Valid) if an interrupt is found. */
         WaitLoop(3);
         HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
         HPO( , ADDRV, , , );
         WaitLoop(3);
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

void VicInitReg()
{
  /* Initialise the register values.             */
  /* All the interrupt are IRQs - 32 IRQs.       */
  /* Daisy is set to IRQ - 33rd Interrupt.       */
  /* No soft priority, No soft proirity masking. */
  int i;

  D_VICTrTCR = 0x05F;
  init_addr = 0x0000A000;

  D_VICIntEnable = 0xFFFFFFFF;
  D_VICSoftInt   = 0x00000000;
  D_VICIntSelect = 0x00000000;
  D_VICSWPriorityMask    = 0xFFFF;
  D_VICVectPriorityDaisy = 0x0;
  D_TrIntIn      = 0x00000001;
  ProtectionOff  = 0x00000000;
  D_TrVectAddrIn = 0xAAAA0000;
  for(i = 0; i < INT_COUNT; D_VICVectPriority[i++] = 0xF);
}

void VicInitDaisyReg()
{
  /* Initialise the register values.             */
  /* All the interrupt are IRQs - 32 IRQs.       */
  /* Daisy is set to IRQ - 33rd Interrupt.       */
  /* No soft priority, No soft proirity masking. */
  int i;

  D_VICTrTCR = 0x05F;
  init_addr = 0x0000A000;

  D_VICIntEnable = 0xFFFFFFFF;
  D_VICSoftInt   = 0x00000000;
  D_VICIntSelect = 0x00000000;
  D_VICSWPriorityMask    = 0xFFFF;
  D_VICVectPriorityDaisy = 0x0;
  D_TrIntIn      = 0x00000001;
  ProtectionOff  = 0x00000000;
  D_TrVectAddrIn = 0xAAAA0000;
  for(i = 0; i < INT_COUNT; D_VICVectPriority[i++] = 0xF);
}

void VicStackDaisyServ()
{
  /** The bit causing the IRQ is cleared. **/
  D_TrIntIn = D_TrIntIn | 0x00000002;
  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_TrIntIn);

  /** A write access is done on the VICVectAddr. This marks the **/
  /** end of the Interrupt Service Routine.                     **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}

char Str[120];
void VicStackIntr(int intr, int select)
{
  int StackMax, i, D_intr, ADD_PRIO;
  StackMax = intr;

  for(i = 0; i < 15; i++)
  {

    /** Select the Interrupt requests to be raised. **/
    /** Start from the lowest.                      **/
    sprintf(Str, "Interrupt %X is applied", intr);
    C(Str);

    D_VICVectPriority[intr] = 0xE - i;
    ADD_PRIO = VICVectPriority_BASE + 4*intr;
    HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
    HSW( , D_VICVectPriority[intr]);


    D_intr = LSB1 << intr;
    D_TrIntSource = D_intr;

    /** Raise the selected Interrupts via VICINTSOURCE. **/
    ApplyIntr(select);

    WaitLoop(3);
    HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HPO( , ADDRV, , , );
    WaitLoop(3);

  /*  D_VICVectPriority[intr] = 0xF;
    ADD_PRIO = VICVectPriority_BASE + 4*intr;
    HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
    HSW( , D_VICVectPriority[intr]); */

    /** Apply Next highest priority interrupt. **/
    intr--;

  }

  C("--------- Serving the interrupts. -----------");
  D_VICTrAckCnt == 0;
  HSA(VICTrAckCnt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW(,ZERO);
  for(i = 0; i < 15; i++)
    {
      WaitLoop(2);
      /** A write access is done on the VICVectAddr. This marks the **/
      /** end of the Interrupt Service Routine.                     **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSW( , ZERO);
      sprintf(Str, "Interrupt %X is serviced", ++intr);
      C(Str);
    }
      return;
}

/****************************** End Of File **********************************/
 
