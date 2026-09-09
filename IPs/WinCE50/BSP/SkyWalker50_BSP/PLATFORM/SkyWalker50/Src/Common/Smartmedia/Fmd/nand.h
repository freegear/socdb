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
#ifndef __NAND_H__
#define __NAND_H__

#define NAND_BLOCK_CNT          (1024 * 4)      /* Each Plane has 1024 Blocks   */
#define NAND_PAGE_CNT           (32)            /* Each Block has 32 Pages      */
#define NAND_PAGE_SIZE          (512)           /* Each Page has 512 Bytes      */
#define NAND_BLOCK_SIZE         (NAND_PAGE_CNT * NAND_PAGE_SIZE)

#define CMD_READID              0x90        //  ReadID
#define CMD_READ                0x00        //  Read
#define CMD_READ2               0x50        //  Read2
#define CMD_RESET               0xff        //  Reset
#define CMD_ERASE               0x60        //  Erase phase 1
#define CMD_ERASE2              0xd0        //  Erase phase 2
#define CMD_WRITE               0x80        //  Write phase 1
#define CMD_WRITE2              0x10        //  Write phase 2

/* !!! Maximum Delay Setting, Please Adjust these value to Optimize */
#define TACLS                   7      
#define TWRPH0                  7 
#define TWRPH1                  7 

#define NF_CMD(cmd)	            {smtNAND->NFCMD   =  (unsigned char)(cmd);}
#define NF_ADDR(addr)	        {smtNAND->NFADDR  =  (unsigned char)(addr);}	

#if 1		// for SMT926aNAND
//  For flash chip that is bigger than 32 MB, we need to have 4 step address
#define NEED_EXT_ADDR               1

#define NF_nFCE_L()	        {smtNAND->NFCONT &= ~(1 << 1);}
#define NF_nFCE_H()	        {smtNAND->NFCONT |=  (1 << 1);}
#define NF_RSTECC()	        {smtNAND->NFCONT |=  (1 << 4);}

#define NF_MECC_UnLock()	{smtNAND->NFCONT &= ~(1<<5);}
#define NF_MECC_Lock()		{smtNAND->NFCONT |= (1<<5);}
#define NF_SECC_UnLock()	{smtNAND->NFCONT &= ~(1<<6);}
#define NF_SECC_Lock()		{smtNAND->NFCONT |= (1<<6);}

#define NF_CLEAR_RB()		{smtNAND->NFSTAT |=  (1 << 2);}
#define NF_DETECT_RB()		{while(!(smtNAND->NFSTAT&(1<<2)));}
#define NF_WAITRB()         {while (!(smtNAND->NFSTAT & (1 << 0)));} 

#else		

#define NF_nFCE_L()	            {smtNAND->NFCONT &= ~(1 << 1);}
#define NF_nFCE_H()	            {smtNAND->NFCONT |=  (1 << 1);}
#define NF_RSTECC()	            {smtNAND->NFCONT |=  (1 << 4);}
#define NF_WAITRB()             {while (!(smtNAND->NFSTAT & (1 << 0)));} 

#endif	// SMT926aNAND

#define NF_RDDATA() 	        (smtNAND->NFDATA)
#define NF_WRDATA(data)         {smtNAND->NFDATA  =  (data);}

#define NF_RDMECC0()			(smtNAND->NFMECC0)
#define NF_RDMECC1()			(smtNAND->NFMECC1)
#define NF_RDSECC()				(smtNAND->NFSECC)

#define NF_RDMECCD0()			(smtNAND->NFMECCD0)
#define NF_RDMECCD1()			(smtNAND->NFMECCD1)
#define NF_RDSECCD()			(smtNAND->NFSECCD)

#define NF_WRMECCD0(data)			{smtNAND->NFMECCD0 = (data);}
#define NF_WRMECCD1(data)			{smtNAND->NFMECCD1 = (data);}
#define NF_WRSECCD(data)			{smtNAND->NFSECCD = (data);}

#define NF_RDESTST0				(smtNAND->NFESTAT0)
#define NF_RDESTST1				(smtNAND->NFESTAT1)


#endif    // __NAND_H_.

