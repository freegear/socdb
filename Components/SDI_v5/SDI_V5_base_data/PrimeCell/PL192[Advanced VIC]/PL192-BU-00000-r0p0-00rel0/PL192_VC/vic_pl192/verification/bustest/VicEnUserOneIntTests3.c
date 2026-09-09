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
-- File Name              : VicEnUserOneIntTests3.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform One-interrupt tests and User defined 
--           Interrupt Combination tests
--
-- --=========================================================================*/
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** InitValue()                                IntRoutines.c               ***/
/*** TwoInterrupt()                             IntRoutines.c               ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** ServiceTwo()                               IntRoutines.c               ***/
/*** FourInterrupt()                            IntRoutines.c               ***/
/*** ServiceFour()                              IntRoutines.c               ***/
/*** EightInterrupt()                           IntRoutines.c               ***/
/*** ServiceEight()                             IntRoutines.c               ***/
/*** SxtnInterrupt()                            IntRoutines.c               ***/
/*** ServiceSxtn()                              IntRoutines.c               ***/
/*** AllInterrupt()                             IntRoutines.c               ***/
/*** ServiceAll()                               IntRoutines.c               ***/
/*** TwoDiffInt()                               IntRoutines.c               ***/
/*** SimulClear()                               IntRoutines.c               ***/
/*** AllIntService()                            IntRoutines.c               ***/
/******************************************************************************/
 
/******************************************************************************/
/****************** User defined and One Interrupt Tests **********************/
/******************************************************************************/

void VicEnUserOneIntTests3()
{
  /*
     Summary: One and User Defined Interrupt Tests
     =============================================
     This function performs the following:
 
     o  Initialises all registers. 
 
     o  Writes the interrupt value in the TrIntSource register or in the
        VICSoftInt register.
 
     o  Services the interrupt using a general function used to handle
        all the interrupts.

     One Interrupt test
     ------------------
     1 bit in the VICINTSOURCE vector is set by invoking a function.
     Thirty two combinations are performed with Vectored Interrupts 
     enabled. Two sequences with Vectored Interrupts disabled are also
     performed. All the above tests are repeated with the interrupts 
     being raised via the VICSoftInt register.

     User Defined Interrupt test
     ---------------------------
       i. Interrupts are applied and cleared in the order the user
          wishes.
      ii. Two interrupts are raised one after the another ie. they
          are NOT raised simultaneously on the same clock.
     iii. Four interrupts are applied out of which, two are
          simultaneously cleared.
  */

  int j1, i;
 
  for (i = 12; i < (16); i++)
  {

      /** Before applying the interrupts, some of the registers like **/
      /** VICIntEnable, VICSoftInt, etc. are initialised. The        **/
      /** InitValue() function assigns a new value to all global     **/
      /** variables. These values are written into their respective  **/
      /** address locations by the Initialise() function. The last   **/
      /** argument of the function Initialise() decides whether the  **/
      /** Vectored interrupts will be active or not. 32 cases are    **/
      /** considered, when the Vectored interrupts are enabled. 2    **/
      /** cases are considered by keeping the Vectored interrupts    **/
      /** disabled.                                                  **/      

    InitValue(i);

    D_VICTrAckCnt = (i) & 0x7;
    if (D_VICTrAckCnt == 0)
       D_VICTrAckCnt = 3;

    Initialise();

    C("One Interrupt - Applied via VICINTSOURCE");

    for (j1 = 0; j1 < INT_COUNT; j1++)
    {
 
      /** Select the Interrupt request to be raised. **/
      D_TrIntSource = OneInterrupt(j1);

      /** Raise the selected interrupt via VICINTSOURCE. **/ 
      ApplyIntr(0);
 
      /** Service the interrupts. **/
      VicAllIntService(0);
    }

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("One Interrupt - Applied via the VICSoftInt Register");

    for (j1 = 0; j1 < INT_COUNT; )
    {
 
      /** Select the Interrupt request to be raised. **/
      D_TrIntSource = OneInterrupt(j1);

      /** Raise the interrupts via the VICSoftInt register. **/ 
      ApplyIntr(1);
 
      /** Service the interrupts. **/
      VicAllIntService(1);

      j1 += 2;
    }

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);

    C("User Defined Interrupt Tests -> Two Interrupt case");
    C("User Defined Servicing order");

    /** External Interrupts are Disabled while performing these **/
    /** tests.                                                  **/
    HSA(VICTrVectAddrIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , Data0);
    HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , NoExtInt);

    /** Select VICINTSOURCE 0 and 28. **/
    D_TrIntSource = TwoInterrupt(0, 28);
 
    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);

    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/ 
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** source 28 will be cleared first and then source 0.          **/
    VicServiceTwo(28, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);

    /** Select VICINTSOURCE 4 and 24. **/
    D_TrIntSource = TwoInterrupt(4, 24);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);

    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/ 
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** source 24 will be cleared first and then source 4.          **/
    VicServiceTwo(24, 4);
   
    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);

    /** Select VICINTSOURCE 8 and 20. **/
    D_TrIntSource = TwoInterrupt(8, 20);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** source 20 will be cleared first and then source 8.          **/
    VicServiceTwo(20, 8);
   
    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);

    /** Select VICINTSOURCE 12 and 16. **/
    D_TrIntSource = TwoInterrupt(12, 16);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** source 16 will be cleared first and then source 12.         **/
    VicServiceTwo(16, 12);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("User Defined Interrupt Tests -> Four Interrupt case");
    C("User Defined Servicing order");
 
    /** Select VICINTSOURCE 0, 14, 16 and 30. **/
    D_TrIntSource = FourInterrupt(0, 14, 16, 30);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/  
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 16, 14, 30 and 0.                       **/
    VicServiceFour(16, 14, 30, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 2, 12, 18 and 28. **/
    D_TrIntSource = FourInterrupt(2, 12, 18, 28);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 18, 12, 28 and 2.                       **/
    VicServiceFour(18, 12, 28, 2);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 4, 10, 20 and 26. **/
    D_TrIntSource = FourInterrupt(4, 10, 20, 26);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 20, 10, 26 and 4.                       **/
    VicServiceFour(20, 10, 26, 4);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    /** Select VICINTSOURCE 6, 8, 22 and 24. **/
    D_TrIntSource = FourInterrupt(6, 8, 22, 24);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 22, 8, 24 and 6.                        **/
    VicServiceFour(22, 8, 24, 6);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("User Defined Interrupt Tests -> Eight Interrupt case");
    C("User Defined Servicing order");

    /** Select VICINTSOURCE 0, 7, 8, 15, 16, 23, 24 and 31. **/
    D_TrIntSource = EightInterrupt(0, 7, 8, 15, 16, 23, 24, 31);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 24, 23, 31, 16, 8, 7, 15 and 0.         **/
    VicServiceEight(24, 23, 31, 16, 8, 7, 15, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 1, 6, 9, 14, 17, 22, 25 and 30. **/
    D_TrIntSource = EightInterrupt(1, 6, 9, 14, 17, 22, 25, 30);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 25, 22, 30, 17, 9, 6, 14 and 1.         **/
    VicServiceEight(25, 22, 30, 17, 9, 6, 14, 1);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 2, 5, 10, 13, 18, 21, 26 and 29. **/
    D_TrIntSource = EightInterrupt(2, 5, 10, 13, 18, 21, 26, 29);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 26, 21, 29, 18, 10, 5, 13 and 2.        **/
    VicServiceEight(26, 21, 29, 18, 10, 5, 13, 2);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 3, 4, 11, 12, 19, 20, 27 and 28. **/
    D_TrIntSource = EightInterrupt(3, 4, 11, 12, 19, 20, 27, 28);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 27, 20, 28, 19, 11, 4, 12 and 3.        **/
    VicServiceEight(27, 20, 28, 19, 11, 4, 12, 3);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("User Defined Interrupt Tests -> Sixteen Interrupt case");
    C("User Defined Servicing order");

    /** Select VICINTSOURCE 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, **/
    /** 12, 13, 14 and 15.                                        **/
    D_TrIntSource = SxtnInterrupt(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                                12, 13, 14, 15);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 14, 13, 15, 12, 10, 9, 11, 8, 6, 5, 7,  **/
    /** 4, 2, 1, 3 and 0.                                           **/
    VicServiceSxtn(14, 13, 15, 12, 10, 9, 11, 8, 6, 5, 7, 4, 2, 1, 3, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, **/
    /** 26, 27, 28, 29, 30 and 31.                                  **/
    D_TrIntSource = SxtnInterrupt(16, 17, 18, 19, 20, 21, 22, 23, 24,
                                  25, 26, 27, 28, 29, 30, 31);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 30, 29, 31, 28, 26, 25, 27, 24, 22, 21, **/
    /** 23, 20, 18, 17, 19 and 16.                                  **/
    VicServiceSxtn(30, 29, 31, 28, 26, 25, 27, 24, 22, 21, 23, 20, 18, 17,
                19, 16);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,  **/
    /** 22, 24, 26, 28 and 30.                                      **/
    D_TrIntSource = SxtnInterrupt(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
                                22, 24, 26, 28, 30);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 28, 26, 30, 24, 20, 18, 22, 16, 12, 10, **/ 
    /** 14, 8, 4, 2, 6, and 0.                                      **/
    VicServiceSxtn(28, 26, 30, 24, 20, 18, 22, 16, 12, 10, 14, 8, 4, 2, 6,
                0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select VICINTSOURCE 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21,  **/
    /** 23, 25, 27, 29 and 31.                                      **/
    D_TrIntSource = SxtnInterrupt(1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21,
                                23, 25, 27, 29, 31);

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 9, 27, 31, 25, 21, 19, 23, 17, 13, 11,  **/
    /** 17, 9, 5, 3, 7 and 1.                                       **/
    VicServiceSxtn(29, 27, 31, 25, 21, 19, 23, 17, 13, 11, 17, 9, 5, 3, 7,
                1);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("User Defined Interrupt Tests -> All Interrupt case");
    C("User Defined Servicing order");

    /** Select all VICINTSOURCE. **/ 
    D_TrIntSource = AllInterrupt();

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, **/
    /** 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, **/
    /** 5, 4, 3, 2, 1 and 0.                                        **/
    VicServiceAll(31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18,
               17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2,
               1, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select all VICINTSOURCE. **/                                    
    D_TrIntSource = AllInterrupt();

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;

    /** The interrupts are serviced according to their priorities.  **/
    /** But, it is cleared as programmed by the user. In this case, **/
    /** the order is source 30, 29, 31, 28, 26, 25, 27, 24, 22, 21, **/
    /** 23, 20, 18, 17, 19, 16, 14, 13, 15, 12, 10, 9, 11, 8, 6, 5, **/
    /** 7, 4, 2, 1, 3 and 0.                                        **/
    VicServiceAll(30, 29, 31, 28, 26, 25, 27, 24, 22, 21, 23, 20, 18, 17,
               19, 16, 14, 13, 15, 12, 10, 9, 11, 8, 6, 5, 7, 4, 2, 1,
               3, 0);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select all VICINTSOURCE. **/                                    
    D_TrIntSource = AllInterrupt();

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 31, 28, 30, 29, 27, 24, 26, 25, 23, 20, **/ 
    /** 22, 21, 19, 16, 18, 17, 15, 12, 14, 13, 11, 8, 10, 9, 7, 4, **/
    /** 6, 5, 3, 0, 2 and 1.                                        **/
    VicServiceAll(31, 28, 30, 29, 27, 24, 26, 25, 23, 20, 22, 21, 19, 16,
               18, 17, 15, 12, 14, 13, 11, 8, 10, 9, 7, 4, 6, 5, 3, 0,
               2, 1);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Select all VICINTSOURCE. **/                                    
    D_TrIntSource = AllInterrupt();

    /** Raise the interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);
 
    /** Initialise the variable that tracks the interrupt that is **/   
    /** being serviced.                                           **/
    servreg = Data0;
 
    /** The interrupts are serviced according to their priorities.  **/ 
    /** But, it is cleared as programmed by the user. In this case, **/ 
    /** the order is source 31, 30, 29, 28, 3, 2, 1, 0, 27, 26, 25, **/ 
    /** 24, 7, 6, 5, 4, 23, 22, 21, 20, 11, 10, 9, 8, 19, 18, 17,   **/ 
    /** 16, 15, 14, 13 and 12.                                      **/
    VicServiceAll(31, 30, 29, 28, 3, 2, 1, 0, 27, 26, 25, 24, 7, 6, 5, 4,
               23, 22, 21, 20, 11, 10, 9, 8, 19, 18, 17, 16, 15, 14, 13,
               12);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("User Defined Interrupt Tests - Two Interrupt case");
    C("Two Interrupts are applied one after the other");

    /** An Interrupt is applied from source 0. The ISR service of    **/
    /** Source 0 is started by reading its vector address and        **/
    /** status. Then, another interrupt from source 28 is applied.   **/
    /** The pending interrupts are serviced and cleared according to **/
    /** their priorities.                                            **/
    VicTwoDiffInt(0, 28);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** An Interrupt is applied from source 4. The ISR service of    **/
    /** Source 4 is started by reading its vector address and        **/
    /** status. Then, another interrupt from source 24 is applied.   **/
    /** The pending interrupts are serviced and cleared according to **/
    /** their priorities.                                            **/
    VicTwoDiffInt(4, 24);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** An Interrupt is applied from source 8. The ISR service of    **/
    /** Source 8 is started by reading its vector address and        **/
    /** status. Then, another interrupt from source 20 is applied.   **/
    /** The pending interrupts are serviced and cleared according to **/
    /** their priorities.                                            **/
    VicTwoDiffInt(8, 20);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** An Interrupt is applied from source 12. The ISR service      **/
    /** of Source 12 is started by reading its vector address and    **/
    /** status. Then, another interrupt from source 16 is applied.   **/
    /** The pending interrupts are serviced and cleared according to **/
    /** their priorities.                                            **/
    VicTwoDiffInt(12, 16);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("User Defined Interrupt Tests - Four Interrupt case");
    C("Four Interrupts are applied, two are simultaneously cleared");

    /** Out of the Four Interrupts applied, the highest priority     **/
    /** interrupt will be serviced first. While clearing that        **/
    /** interrupt the second highest priority interrupt will also be **/
    /** cleared simultaneously.                                      **/
    VicSimulClear(0, 14, 16, 30);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Out of the Four Interrupts applied, the highest priority     **/
    /** interrupt will be serviced first. While clearing that        **/
    /** interrupt the second highest priority interrupt will also be **/
    /** cleared simultaneously.                                      **/
    VicSimulClear(2, 12, 18, 28);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Out of the Four Interrupts applied, the highest priority     **/
    /** interrupt will be serviced first. While clearing that        **/
    /** interrupt the second highest priority interrupt will also be **/
    /** cleared simultaneously.                                      **/
    VicSimulClear(4, 10, 20, 26);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    /** Out of the Four Interrupts applied, the highest priority     **/
    /** interrupt will be serviced first. While clearing that        **/
    /** interrupt the second highest priority interrupt will also be **/
    /** cleared simultaneously.                                      **/
    VicSimulClear(6, 8, 22, 24);

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
  }
}

/************************************ End *************************************/
