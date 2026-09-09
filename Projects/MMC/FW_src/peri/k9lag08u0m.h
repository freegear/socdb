/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: k9lag08u0m.h
	Description	: K9LAG08U0M configration file
----------------------------------------------------------*/
#ifndef __K9LAG08U0M_H__
#define __K9LAG08U0M_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

//-----------------------------------------------------------
//	K9LAG08U0M 
//-----------------------------------------------------------
//
// command code
//
#define CC_RDIDCMD     					(0x90)		// check
#define CC_PAGERDCMD0  					(0x00)		// check
#define CC_PAGERDCMD1  					(0x30)		// check
#define CC_PAGEWRCMD0  					(0x80)		// check
#define CC_PAGEWRCMD1  					(0x10)		// check
#define CC_BERASECMD0  					(0x60)		// check
#define CC_BERASECMD1  					(0xD0)		// check
#define CC_RESETCMD    					(0xFF)		// check
#define CC_RDSTATCMD0  					(0x70)		// check
#define CC_RDSTATCMD1  					(0x7B)		// check

#define	CC_PAGERWRDCMD0					(0x85)		// check	
#define	CC_PAGERWRDCMD1					(0x00)		// check
#define	CC_PAGERRRDCMD0					(0x05)		// check
#define	CC_PAGERRRDCMD1					(0xE0)		// check
//
// address+command size
//
#define CS_RDIDCMD     					(0x02)		// check cmd0+c0
#define CS_PAGEWRCMD  					(0x07)		// check cmd0+c0+c1+r0+r1+r2+cmd1
#define CS_PAGERDCMD  					(0x07)		// check cmd0+c0+c1+r0+r1+r2+cmd1
#define CS_BERASECMD  					(0x05)		// check cmd0+r0+r1+r2+cmd1
#define CS_RDSTATCMD   					(0x01)		// check cmd0
#define CS_RESETCMD    					(0x01)		// ???	not tested
#define	CS_PAGERWRDCMD					(0x00)		// ???	not tested
#define	CS_PAGERRDCMD					(0x00)		// ???	not tested
//
// address+command bit flag
//
#define	CB_RESETCMD						(0x01)		// check (b 0000 0001)
#define	CB_RDIDCMD						(0x01)		// check (b 0000 0001)
#define	CB_PAGERDCMD					(0x41)		// check (b 0100 0001)
#define	CB_PAGEWRCMD					(0x41)		// check (b 0100 0001)
#define	CB_BERASECMD					(0x11)		// check (b 0001 0001)
#define	OPCFG_FLG_COMMAND				(0x01)
//
//	transize
//
#define	OPCFG_TS_BYTE					(0x00)		// check
#define	OPCFG_TS_HWORD					(0x01)		// check
#define	OPCFG_TS_WORD					(0x02)		// check
//
// operation
//
#define OPCFG_OPR_READDATA    			(0x00)		// check
#define OPCFG_OPR_READSTATUS 			(0x01)		// check 
#define OPCFG_OPR_READID      			(0x02)		// check
#define OPCFG_OPR_WRITEDATA   			(0x03)		// check
#define OPCFG_OPR_NOP         			(0x07)		// check
//
// option
//
#define OPCFG_OPT_RNBWAIT     			(0x01)		// check
#define OPCFG_OPT_AUTORDSTAT  			(0x02)		// check
#define OPCFG_OPT_CONTINUE    			(0x03)		// check
#define OPCFG_OPT_NOP					(0x00)		// check
//
// config
//
#define	NANDT_CFG_NANDBOOTEN			(0x00)
#define	NANDT_CFG_IOWIDTH				(0x00)
#define	NANDT_CFG_NANDWITH				(0x00)
#define	NANDT_CFG_BOOTCFG				(0x00)
#define	NANDT_CFG_OUTDTMN				(0x00)
#define	NANDT_CFG_TADLTWB				(0x0F)
#define	NANDT_CFG_TACLS					(0x02)
#define	NANDT_CFG_TRWLP					(0x02)
#define	NANDT_CFG_TRWHP					(0x02)
#define	NANDT_CTRL_FIFOLEV				(0x07)

//
//	address define
//
#define	ADDRESS0(c)						((c) & 0xFF)					// A00 ~ A07
#define	ADDRESS1(c)                 	(((c) >> 8) & 0xF)				// A08 ~ A11
#define	ADDRESS2(p, b)                 	((((b) & 0x3)<<6)|((p) & 0x3F))	// A12 ~ a19 
#define	ADDRESS3(b)                 	(((b) >> 2) & 0xFF)				// A20 ~ A27
#define	ADDRESS4(b)                 	(((b) >> 10) & 0xFF)			// A28 ~ A30
#endif //__K9LAG08U0M_H__