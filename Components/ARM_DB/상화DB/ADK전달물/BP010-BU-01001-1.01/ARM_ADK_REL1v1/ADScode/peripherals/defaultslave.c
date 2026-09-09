//--========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT  2001 ARM Limited
//       ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :defaultslave.c,v
//  File Revision       :1.1
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : A region of memory occupied by Default Slave.
//  
//  Note                : The default slave is used to respond to transfers 
//                        made to regions of memory where no (other) AHB 
//                        system slaves are mapped. 
//
//                        An ERROR response is generated if a NONSEQUENTIAL 
//                        or SEQUENTIAL transfer is performed.
//
//                        This file refers to the Default Slave in one region
//                        of memory, but it is likely that the Default Slave
//                        will exist in other regions of memory.
//
//--========================================================================--


#include "defaultslave.h"

DefaultSlave defaultSlave;


// end of file defaultslave.c