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
//  File Name           :rempause.h,v
//  File Revision       :1.6
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Remap/Pause Controller registers
//
//--========================================================================--

#ifndef REMPAUSE_H
#define REMPAUSE_H

#include "globals.h"

typedef struct
{ 
  volatile Word Pause;           // @ 0x00
  volatile Word Remap;           // @ 0x04
  volatile Word ResetStatus;     // @ 0x08
  volatile Word ResetStatusClr;  // @ 0x0c
  
  const Word fill0[1012];
  
  volatile const Word RpcPeriphID0; // @0xFE0
  volatile const Word RpcPeriphID1;
  volatile const Word RpcPeriphID2;
  volatile const Word RpcPeriphID3;
  volatile const Word RpcPCellID0;
  volatile const Word RpcPCellID1;
  volatile const Word RpcPCellID2;
  volatile const Word RpcPCellID3;
} RemPause;

extern RemPause remPause;

void EnterPauseMode(void);

// Peripheral ID
#define RPC_ID_VALUE  0x00041809
#define RPC_ID_MASK   0xFFFFFFFF

// Pause
#define RPCPauseHALT 0x4U

// ResetMap

// ResetStatus
#define RPCResetStatusMask 1U
#define RPCResetStatusPOR 0x1U

// ResetStatusClear
#define RPCResetStatusClearMask 1U
#define RPCResetStatusClearPOR 0x1U

#endif // defined( REMPAUSE_H )

// end of file rempause.h