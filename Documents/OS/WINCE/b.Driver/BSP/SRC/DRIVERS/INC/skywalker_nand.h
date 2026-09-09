//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//------------------------------------------------------------------------------
//
//  Header: skywalker_nand.h
//
//  Defines the NAND controller CPU register layout and definitions.
//
#ifndef __S3C2410X_NAND_H
#define __S3C2410X_NAND_H

#if __cplusplus
    extern "C" 
    {
#endif


//------------------------------------------------------------------------------
//  Type: S3C2410X_NAND_REG    
//
//  NAND Flash controller register layout. This register bank is located 
//  by the constant CPU_BASE_REG_XX_NAND in the configuration file 
//  cpu_base_reg_cfg.h.
//

typedef struct  
{
    UINT32  NFCONF;             // configuration reg
    UINT8   NFCMD;              // command set reg
    UINT8   pad1[3];            // pad 
    UINT8   NFADDR;             // address set reg
    UINT8   pad2[3];            // pad 
    UINT8   NFDATA;             // data reg
    UINT8   pad3[3];            // pad
    UINT32  NFSTAT;             // operation status reg
    UINT8   NFECC0;             // error correction code 0
    UINT8   NFECC1;             // error correction code 1
    UINT8   NFECC2;             // error correction code 2

} S3C2410X_NAND_REG, *PS3C2410X_NAND_REG;    


#if __cplusplus
    }
#endif

#endif 
