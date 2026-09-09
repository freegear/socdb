
/* DO NOT EDIT!! - this file automatically generated
 *                 from .s file by awk -f s2h.awk
 */
/***************************************************************************
 *  * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 *  * Copyright © ARM Limited 1998.  All rights reserved.
 *  ***************************************************************************/
/* ****************************************************************************
 * 
 *   Defines for exception handling in uHAL library code.
 * 
 * ****************************************************************************/


#define NoIRQ                           0x80		 /*  Bit 7 of cspr */
#define NoFIQ                           0x40		 /*  Bit 6 of cspr */
#define NoINTS                          (NoIRQ | NoFIQ)  /*  Both */
#define MaskINTS                        NoINTS

#define AllIRQs                         0xFF		 /*  Mask for interrupt controller */

#define ResetV                          0x00
#define UndefV                          0x04
#define SwiV                            0x08
#define IrqV                            0x18
#define FiqV                            0x1C

#define ModeMask                        0x1F		 /* Processor mode in CPSR */

#define SVC32Mode                       0x13
#define IRQ32Mode                       0x12
#define FIQ32Mode                       0x11
#define User32Mode                      0x10
/* Error modes */
#define Abort32Mode                     0x17
#define Undef32Mode                     0x1B

#define PSR_T_bit                       0x20

#define UserStackSize                   0x20000
#define SVCStackSize                    0x4000
#define IRQStackSize                    0x2000
#define UndefStackSize                  0x200
/* Not currently used, but defined anyway */
#define FIQStackSize                    0x400
#define AbortStackSize                  0x400

/* SWIs known to uHAL */
#define SWI_Angel                       0x123456
#define SWI_Angel_Thumb                 0xAB
#define angel_SWI_SYS_WRITEC            0x03
#define angel_SWI_SYS_WRITE0            0x04
#define angel_SWI_SYS_READC             0x07
#define angel_SWI_SYS_HEAPINFO          0x16
#define angel_SWIreason_EnterSVC        0x17
#define angel_SWIreason_ReportException  0x18
#define ADP_Stopped_ApplicationExit     0x20026

#define SYS_READ_SWI                    0x06
#define SYS_WRITE_SWI                   0x05
#define SYS_FILE_CLOSE                  0x02
#define SYS_FILE_OPEN                   0x01
/* 	END				  End of file
 */
