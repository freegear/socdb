 ; //******************************************************************************
 ; // Copyright: 
 ; // ----------------------------------------------------------------
 ; // This confidential and proprietary software may be used only as
 ; // authorised by a licensing agreement from ARM Limited
 ; //   (C) COPYRIGHT 2000,2001 ARM Limited
 ; //       ALL RIGHTS RESERVED
 ; // The entire notice above must be reproduced on all authorised
 ; // copies and copies may only be made to the extent permitted
 ; // by a licensing agreement from ARM Limited.
 ; // ----------------------------------------------------------------
 ; // File:     SYSDefs.h,v
 ; // Revision: 1.12
 ; // ----------------------------------------------------------------
 ; // 
 ; //  ----------------------------------------
 ; //  Version and Release Control Information:
 ; // 
 ; //  File Name              : SYSDefs.h.rca
 ; //  File Revision          : 1.9
 ; // 
 ; //  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 ; //  ----------------------------------------
 ; //
 ; //*****************************************************************************
 ; // Purpose:
 ; // This file contains all of the definitions for the system.
 ; //*****************************************************************************

;//-------------------------------------------------------------------------------
;//----------------------------STACK SETUP------------------------------------
;//-------------------------------------------------------------------------------
;//The data here sets up the stack and heap locations.
 ; // We use a memory model as below
 ; //
 ; // <<STACK LIMIT>>
 ; // FIQ Stack (SIZE FIQ_Size)
 ; // IRQ Stack (SIZE IRQ_Size)
 ; // ABT Stack (SIZE ABT_Size)
 ; // UND Stack (SIZE UND_Size)
 ; // SVC Stack (SIZE SVC_Size)
 ; // USR Stack (SIZE USR_Size)
 ; // ================================
 ; // HEAP
 ; // ================================
 ; // <<HEAP BASE>>
 ; //
FIQ_Size           EQU    1024*1
IRQ_Size           EQU    1024*4
ABT_Size           EQU    1024*1
UND_Size           EQU    1024*1
SVC_Size           EQU    1024*4
USR_Size           EQU    1024*64
Heap_Size          EQU    1024*16

;//The stacks and heaps are placed at:
;//
;//NOT SCATTERLOADING:
;//Heap Base - placed above code (Image$$ZI$$Limit)
;//Stacks    - placed above heap, based on heap size defined above 
;//
;//SCATTERLOADING:
;//Stacks    - if a region named 'STACK_END' exists, the stacks are placed BELOW this region
;//            so the top stack location will be the byte BEFORE this region starts
;//          - otherwise placed above heap, based on heap size defined above
;//Heap Base - if a region named 'HEAP' exists, the heap is placed in this region
;//          - otherwise, if a region named 'RAM' exists, the heap is placed in this region

 ; // The various ARM modes ...

Mode_USR32  EQU 0x10
Mode_FIQ32  EQU 0x11
Mode_IRQ32  EQU 0x12
Mode_ABT32  EQU 0x17
Mode_UND32  EQU 0x1b
Mode_SVC32  EQU 0x13
Mode_SYS32  EQU 0x1F

 ; // The core interrupt enable bits ...
I_Bit       EQU 0x80
F_Bit       EQU 0x40
FI_Bit		EQU 0xC0

	END

