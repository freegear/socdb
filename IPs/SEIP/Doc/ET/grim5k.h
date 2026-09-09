/*********************************************************************
*
*   This confidential and proprietary software may be used only as
*   authorised by a licensing agreement from CORERIVER Semiconductor
* 	Co., Ltd.
*
*   (c) Copyright 2005 CORERIVER Semiconductor Co., Ltd.
*     All Rights Reserved
*
*   The entire notice above must be reproduced on all authorised
*   copies and copies may only be made to the extent permitted
*   by a licensing agreement from CORERIVER Semiconductor Co., Ltd.
*
* -------------------------------------------------------------------
*
*   FILE             : grim5k.h
*   AUTHOR           : CORERIVER
*   DESCRIPTION      : Top module
*   VERSION          : $Revision: $ ($Date: $)
*   COMMENT          :
*
*********************************************************************/

#ifndef GRIM5K_H
#define GRIM5K_H

/* GRIM5K Memory Map */

/* Internal SRAM (4K Bytes) */
#define IRAMBase_			0x1F040000
#define IRAM_LIMIT		0x1F050000 - 1
#define IRAM_SIZE		IRAM_LIMIT - IRAMBase_ + 1

// General SDRAM Controller Registers
#define SDRAMBase_ 		0xFFE00000
#define	SDRAMCFGR_		(SDRAMBase_ + 0x000)
#define	SDRAMMRSR_		(SDRAMBase_ + 0x004)
#define	SDRAMCONR_		(SDRAMBase_ + 0x008)
#define	SDRAMREFR_		(SDRAMBase_ + 0x00C)
#define	ROMRAMREFR_		(SDRAMBase_ + 0x030)

// DDR SDRAM Controller Registers
#define DDRBase_ 			0xFFE00000
#define	DDRCFGR_			(DDRBase_ + 0x010)
#define	DDRMRSR_			(DDRBase_ + 0x014)
#define	DDRCONR_			(DDRBase_ + 0x018)
#define	DDRREFR_			(DDRBase_ + 0x01C)

// SE SDRAM Controller Registers
#define SESDRBase_ 		0xFFE00000
#define	SESDRCFGR_		(SESDRBase_ + 0x020)
#define	SESDRMRSR_		(SESDRBase_ + 0x024)
#define	SESDRCONR_		(SESDRBase_ + 0x028)
#define	SESDRREFR_		(SESDRBase_ + 0x02C)

// NAND FLASH Controller Registers
#define NFLASHBase_ 	0xFFE00300
#define	NFCFGR_				(NFLASHBase_ + 0x000)
#define	NFCONR_				(NFLASHBase_ + 0x004)
#define	NFCMDR_				(NFLASHBase_ + 0x008)
#define	NFADDRR_			(NFLASHBase_ + 0x00C)
#define	NFDATAR_			(NFLASHBase_ + 0x010)
#define	NFSTR_				(NFLASHBase_ + 0x014)
#define	NFMECCR_			(NFLASHBase_ + 0x018)
#define	NFSECCR_			(NFLASHBase_ + 0x01C)
#define	NFECONR_			(NFLASHBase_ + 0x020)

// General DMA Controller Registers
#define GDMABase0_ 		0xFFE00400
#define GDMAIR0_ 			(GDMABase0_ + 0x000)
#define GDMAIER0_ 		(GDMABase0_ + 0x004)
#define GDMASTR0_ 		(GDMABase0_ + 0x008)
#define GDMACONR0_ 		(GDMABase0_ + 0x00C)
#define GDMACFGR0_ 		(GDMABase0_ + 0x010)
#define GDMASAR0_ 		(GDMABase0_ + 0x014)
#define GDMADAR0_ 		(GDMABase0_ + 0x018)
#define GDMATCR0_ 		(GDMABase0_ + 0x01C)
#define GDMADTR0_ 		(GDMABase0_ + 0x020)
#define GDMASVAR0_ 		(GDMABase0_ + 0x024)
#define GDMASNAR0_ 		(GDMABase0_ + 0x028)
#define GDMADVAR0_ 		(GDMABase0_ + 0x02C)
#define GDMADNAR0_ 		(GDMABase0_ + 0x030)

// General DMA Controller Registers
#define GDMABase1_ 		0xFFE00440
#define GDMAIR1_ 			(GDMABase1_ + 0x000)
#define GDMAIER1_ 		(GDMABase1_ + 0x004)
#define GDMASTR1_ 		(GDMABase1_ + 0x008)
#define GDMACONR1_ 		(GDMABase1_ + 0x00C)
#define GDMACFGR1_ 		(GDMABase1_ + 0x010)
#define GDMASAR1_ 		(GDMABase1_ + 0x014)
#define GDMADAR1_ 		(GDMABase1_ + 0x018)
#define GDMATCR1_ 		(GDMABase1_ + 0x01C)
#define GDMADTR1_ 		(GDMABase1_ + 0x020)
#define GDMASVAR1_ 		(GDMABase1_ + 0x024)
#define GDMASNAR1_ 		(GDMABase1_ + 0x028)
#define GDMADVAR1_ 		(GDMABase1_ + 0x02C)
#define GDMADNAR1_ 		(GDMABase1_ + 0x030)

// General DMA Controller Registers
#define GDMABase2_ 		0xFFE00480
#define GDMAIR2_ 			(GDMABase2_ + 0x000)
#define GDMAIER2_ 		(GDMABase2_ + 0x004)
#define GDMASTR2_ 		(GDMABase2_ + 0x008)
#define GDMACONR2_ 		(GDMABase2_ + 0x00C)
#define GDMACFGR2_ 		(GDMABase2_ + 0x010)
#define GDMASAR2_ 		(GDMABase2_ + 0x014)
#define GDMADAR2_ 		(GDMABase2_ + 0x018)
#define GDMATCR2_ 		(GDMABase2_ + 0x01C)
#define GDMADTR2_ 		(GDMABase2_ + 0x020)
#define GDMASVAR2_ 		(GDMABase2_ + 0x024)
#define GDMASNAR2_ 		(GDMABase2_ + 0x028)
#define GDMADVAR2_ 		(GDMABase2_ + 0x02C)
#define GDMADNAR2_ 		(GDMABase2_ + 0x030)

// General DMA Controller Registers
#define GDMABase3_ 		0xFFE004C0
#define GDMAIR3_ 			(GDMABase3_ + 0x000)
#define GDMAIER3_ 		(GDMABase3_ + 0x004)
#define GDMASTR3_ 		(GDMABase3_ + 0x008)
#define GDMACONR3_ 		(GDMABase3_ + 0x00C)
#define GDMACFGR3_ 		(GDMABase3_ + 0x010)
#define GDMASAR3_ 		(GDMABase3_ + 0x014)
#define GDMADAR3_ 		(GDMABase3_ + 0x018)
#define GDMATCR3_ 		(GDMABase3_ + 0x01C)
#define GDMADTR3_ 		(GDMABase3_ + 0x020)
#define GDMASVAR3_ 		(GDMABase3_ + 0x024)
#define GDMASNAR3_ 		(GDMABase3_ + 0x028)
#define GDMADVAR3_ 		(GDMABase3_ + 0x02C)
#define GDMADNAR3_ 		(GDMABase3_ + 0x030)


// IDE Control Registers 
#define IDEBase_ 			0xFFE00C00
#define	IDECON_				(IDEBase_ + 0x000)
#define	IDESTAT_			(IDEBase_ + 0x004)
#define	IDEPCTR_			(IDEBase_ + 0x008)
#define	IDEPFTR0_			(IDEBase_ + 0x00C)
#define	IDEPFTR1_			(IDEBase_ + 0x010)
#define	IDEDTR0_			(IDEBase_ + 0x014)
#define	IDEDTR1_			(IDEBase_ + 0x018)
#define	IDEDTXDB_			(IDEBase_ + 0x03C)
#define	IDEDRXDB_			(IDEBase_ + 0x03C)
#define	IDEATADEV_		(IDEBase_ + 0x040)

// Global Control Registers 
#define GCNTLBase_ 		0xFFE01000
#define	REVREG_				(GCNTLBase_ + 0x000)
#define	PCON_					(GCNTLBase_ + 0x004)
#define	PAUSE_				(GCNTLBase_ + 0x008)
#define	REMAP_				(GCNTLBase_ + 0x00C)
#define	PLL0CON_			(GCNTLBase_ + 0x010)
#define	PLL0PARM_			(GCNTLBase_ + 0x014)
#define	PLL1CON_			(GCNTLBase_ + 0x018)
#define	PLL1PARM_			(GCNTLBase_ + 0x01C)
#define	PLL2CON_			(GCNTLBase_ + 0x020)
#define	PLL2PARM_			(GCNTLBase_ + 0x024)
#define	CONFIG_				(GCNTLBase_ + 0x030)

// Sound Engine
#define	SE_BASE				0xFFE02000
#define	SEBase_				0xFFE01400
#define	SEI2SRXCON_		(SEBase_ + 0x0000)
#define	SEI2SRXINT_		(SEBase_ + 0x0004)
#define	SEI2SRXDAT_		(SEBase_ + 0x0008)
#define	SEI2SRXADR_		(SEBase_ + 0x000C)
#define	SEI2STXCON_		(SEBase_ + 0x0010)
#define	SEI2STXINT_		(SEBase_ + 0x0014)
#define	SEI2STXDAT_		(SEBase_ + 0x0018)
#define	SEI2STXADR_		(SEBase_ + 0x001C)

#define	FFTCON_				(SEBase_ + 0x0020)
#define	FFTINT_				(SEBase_ + 0x0024)
#define	MIC0L_PEAK0_	(SEBase_ + 0x0030)
#define	MIC0L_PEAK1_	(SEBase_ + 0x0034)
#define	MIC0L_PEAK2_	(SEBase_ + 0x0038)
#define	MIC0L_PEAK3_	(SEBase_ + 0x003C)
#define	MIC0R_PEAK0_	(SEBase_ + 0x0040)
#define	MIC0R_PEAK1_	(SEBase_ + 0x0044)
#define	MIC0R_PEAK2_	(SEBase_ + 0x0048)
#define	MIC0R_PEAK3_	(SEBase_ + 0x004C)
#define	MIC1L_PEAK0_	(SEBase_ + 0x0050)
#define	MIC1L_PEAK1_	(SEBase_ + 0x0054)
#define	MIC1L_PEAK2_	(SEBase_ + 0x0058)
#define	MIC1L_PEAK3_	(SEBase_ + 0x005C)
#define	MIC1R_PEAK0_	(SEBase_ + 0x0060)
#define	MIC1R_PEAK1_	(SEBase_ + 0x0064)
#define	MIC1R_PEAK2_	(SEBase_ + 0x0068)
#define	MIC1R_PEAK3_	(SEBase_ + 0x006C)

#define	SECON_				(SEBase_ + 0x0100)
#define	SEPCMRX_			(SEBase_ + 0x0104)
#define	SEPCMTX_			(SEBase_ + 0x0108)

// Capture Engine
#define	CEBase_				0xFFE03000
#define	CECON_				(CEBase_ + 0x0000)
#define	CESTS_				(CEBase_ + 0x0004)
#define	CEOFFST_			(CEBase_ + 0x0008)
#define	CEISIZE_			(CEBase_ + 0x000C)
#define	CEDSTBA_			(CEBase_ + 0x0010)
#define	CESC_					(CEBase_ + 0x0014)
#define	CEGC_					(CEBase_ + 0x0018)
#define	CEDSIZE_			(CEBase_ + 0x001C)

// Video Encoder
#define	VEBase_				0xFFE03400
#define	VECFG0_				(VEBase_ + 0x0000)
#define	VECFG1_				(VEBase_ + 0x0004)
#define	VECFG2_				(VEBase_ + 0x0008)
#define	VECFG3_				(VEBase_ + 0x000C)

// JPEG Decoder
#define	JPDBase_			0xFFE03800
#define	JPDCON_				(JPDBase_ + 0x0000)
#define	JPSTATE_			(JPDBase_ + 0x0004)
#define	JPSRCBA_			(JPDBase_ + 0x0008)
#define	JPDSTBA_			(JPDBase_ + 0x000C)
#define	JPISIZE_			(JPDBase_ + 0x0010)
#define	JPDSIZE_			(JPDBase_ + 0x0014)

// USB
#define	USBBase_						0xFFE04000
#define	USB_ID_							(USBBase_ + 0x000)
#define	USB_HWGENERAL_			(USBBase_ + 0x004)
#define	USB_HWHOST_					(USBBase_ + 0x008)
#define	USB_HWDEVICE_				(USBBase_ + 0x00C)
#define	USB_HWTXBUF_				(USBBase_ + 0x010)
#define	USB_HWRXBUF_				(USBBase_ + 0x014)
#define	USB_GPTIMER0LD_			(USBBase_ + 0x080)
#define	USB_GPTIMER0CTRL_		(USBBase_ + 0x084)
#define	USB_GPTIMER1LD_			(USBBase_ + 0x088)
#define	USB_GPTIMER1CTRL_		(USBBase_ + 0x08C)
#define	USB_CAPLENGTH_			(USBBase_ + 0x100)
#define	USB_HCIVERSION_			(USBBase_ + 0x102)
#define	USB_HCSPARAMS_			(USBBase_ + 0x104)
#define	USB_HCCPARAMS_			(USBBase_ + 0x108)
#define	USB_DCIVERSION_			(USBBase_ + 0x120)
#define	USB_DCCPARAMS_			(USBBase_ + 0x124)
#define	USB_CMD_						(USBBase_ + 0x140)
#define	USB_STS_						(USBBase_ + 0x144)
#define	USB_INTR_						(USBBase_ + 0x148)
#define	USB_FRINDEX_				(USBBase_ + 0x14C)
#define	USB_PERIODICLISTBASE_	(USBBase_ + 0x154)
#define	USB_ASYNCLISTADDR_	(USBBase_ + 0x158)
#define	USB_TTCTRL_					(USBBase_ + 0x15C)
#define	USB_BURSTSIZE_			(USBBase_ + 0x160)
#define	USB_TXFILLTUNING_		(USBBase_ + 0x164)
#define	USB_ENDPTNAK_				(USBBase_ + 0x178)
#define	USB_ENDPTNAKEN_			(USBBase_ + 0x17C)
#define	USB_PORTSC1_				(USBBase_ + 0x184)
#define	USB_PORTSC2_				(USBBase_ + 0x188)
#define	USB_PORTSC3_				(USBBase_ + 0x18C)
#define	USB_PORTSC4_				(USBBase_ + 0x190)
#define	USB_PORTSC5_				(USBBase_ + 0x194)
#define	USB_PORTSC6_				(USBBase_ + 0x198)
#define	USB_PORTSC7_				(USBBase_ + 0x19C)
#define	USB_PORTSC8_				(USBBase_ + 0x1A0)
#define	USB_OTGSC_					(USBBase_ + 0x1A4)
#define	USB_MODE_						(USBBase_ + 0x1A8)
#define	USB_ENPDTSETUPSTAT_	(USBBase_ + 0x1AC)
#define	USB_ENDPTPRIME_			(USBBase_ + 0x1B0)
#define	USB_ENDPTFLUSH_			(USBBase_ + 0x1B4)
#define	USB_ENDPTSTAT_			(USBBase_ + 0x1B8)
#define	USB_ENDPTCOMPLETE_	(USBBase_ + 0x1BC)
#define	USB_ENDPTCTRL0_			(USBBase_ + 0x1C0)
#define	USB_ENDPTCTRL1_			(USBBase_ + 0x1C4)
#define	USB_ENDPTCTRL2_			(USBBase_ + 0x1C8)
#define	USB_ENDPTCTRL3_			(USBBase_ + 0x1CC)
#define	USB_ENDPTCTRL4_			(USBBase_ + 0x1D0)
#define	USB_ENDPTCTRL5_			(USBBase_ + 0x1D4)
#define	USB_ENDPTCTRL6_			(USBBase_ + 0x1D8)
#define	USB_ENDPTCTRL7_			(USBBase_ + 0x1DC)
#define	USB_ENDPTCTRL8_			(USBBase_ + 0x1E0)
#define	USB_ENDPTCTRL9_			(USBBase_ + 0x1E4)
#define	USB_ENDPTCTRL10_		(USBBase_ + 0x1E8)
#define	USB_ENDPTCTRL11_		(USBBase_ + 0x1EC)
#define	USB_ENDPTCTRL12_		(USBBase_ + 0x1F0)
#define	USB_ENDPTCTRL13_		(USBBase_ + 0x1F4)
#define	USB_ENDPTCTRL14_		(USBBase_ + 0x1F8)
#define	USB_ENDPTCTRL15_		(USBBase_ + 0x1FC)


// CRT Controller
#define	CRTBase_		0xFFE04400
#define	CRTCON_		(CRTBase_ + 0x0000)
#define	CRTSTS_		(CRTBase_ + 0x0004)
#define	CRTCBA_		(CRTBase_ + 0x0008)
#define	CRTCLS_		(CRTBase_ + 0x000C)
#define	CRTCDA_		(CRTBase_ + 0x0010)
#define	CRTCLA_		(CRTBase_ + 0x0014)
#define	CRTCLT_		(CRTBase_ + 0x0018)
#define	CRTCYX_		(CRTBase_ + 0x001C)
#define	CRTGN0_		(CRTBase_ + 0x0020)
#define	CRTGN1_		(CRTBase_ + 0x0024)
#define	CRTGCN_		(CRTBase_ + 0x0028)
#define	CRTCK0_		(CRTBase_ + 0x002C)
#define	CRTCK1_		(CRTBase_ + 0x0030)

// 2D Graphic Engine
#define	GEBase_		0xFFE04800
#define	GECON_		(GEBase_ + 0x0000)
#define	GESTS_		(GEBase_ + 0x0004)
#define	GEFB0BA_	(GEBase_ + 0x0008)
#define	GEFB1BA_	(GEBase_ + 0x000C)
#define	GEFB2BA_	(GEBase_ + 0x0010)
#define	GEDSIZE_	(GEBase_ + 0x0014)
#define	GEFBSBA_	(GEBase_ + 0x0018)
#define	GEW0OP_		(GEBase_ + 0x0020)
#define	GEW0CP_		(GEBase_ + 0x0024)
#define	GEW0BA_		(GEBase_ + 0x0028)
#define	GEW0IW_		(GEBase_ + 0x002C)
#define	GEW0SS_		(GEBase_ + 0x0030)
#define	GEW0DS_		(GEBase_ + 0x0034)
#define	GEW0DE_		(GEBase_ + 0x0038)
#define	GEW1OP_		(GEBase_ + 0x0040)
#define	GEW1CP_		(GEBase_ + 0x0044)
#define	GEW1BA_		(GEBase_ + 0x0048)
#define	GEW1IW_		(GEBase_ + 0x004C)
#define	GEW1SS_		(GEBase_ + 0x0050)
#define	GEW1DS_		(GEBase_ + 0x0054)
#define	GEW1DE_		(GEBase_ + 0x0058)
#define	GEW2OP_		(GEBase_ + 0x0060)
#define	GEW2CP_		(GEBase_ + 0x0064)
#define	GEW2BA_		(GEBase_ + 0x0068)
#define	GEW2IW_		(GEBase_ + 0x006C)
#define	GEW2SS_		(GEBase_ + 0x0070)
#define	GEW2DS_		(GEBase_ + 0x0074)
#define	GEW2DE_		(GEBase_ + 0x0078)
#define	GEW3OP_		(GEBase_ + 0x0080)
#define	GEW3CP_		(GEBase_ + 0x0084)
#define	GEW3BA_		(GEBase_ + 0x0088)
#define	GEW3IW_		(GEBase_ + 0x008C)
#define	GEW3SS_		(GEBase_ + 0x0090)
#define	GEW3DS_		(GEBase_ + 0x0094)
#define	GEW3DE_		(GEBase_ + 0x0098)
#define	GEW4OP_		(GEBase_ + 0x00A0)
#define	GEW4CP_		(GEBase_ + 0x00A4)
#define	GEW4BA_		(GEBase_ + 0x00A8)
#define	GEW4IW_		(GEBase_ + 0x00AC)
#define	GEW4SS_		(GEBase_ + 0x00B0)
#define	GEW4DS_		(GEBase_ + 0x00B4)
#define	GEW4DE_		(GEBase_ + 0x00B8)
#define	GEW5OP_		(GEBase_ + 0x00C0)
#define	GEW5CP_		(GEBase_ + 0x00C4)
#define	GEW5BA_		(GEBase_ + 0x00C8)
#define	GEW5IW_		(GEBase_ + 0x00CC)
#define	GEW5SS_		(GEBase_ + 0x00D0)
#define	GEW5DS_		(GEBase_ + 0x00D4)
#define	GEW5DE_		(GEBase_ + 0x00D8)
#define	GEW6OP_		(GEBase_ + 0x00E0)
#define	GEW6CP_		(GEBase_ + 0x00E4)
#define	GEW6BA_		(GEBase_ + 0x00E8)
#define	GEW6IW_		(GEBase_ + 0x00EC)
#define	GEW6SS_		(GEBase_ + 0x00F0)
#define	GEW6DS_		(GEBase_ + 0x00F4)
#define	GEW6DE_		(GEBase_ + 0x00F8)
#define	GEW7OP_		(GEBase_ + 0x0100)
#define	GEW7CP_		(GEBase_ + 0x0104)
#define	GEW7BA_		(GEBase_ + 0x0108)
#define	GEW7IW_		(GEBase_ + 0x010C)
#define	GEW7SS_		(GEBase_ + 0x0110)
#define	GEW7DS_		(GEBase_ + 0x0114)
#define	GEW7DE_		(GEBase_ + 0x0118)

// PM Memory
#define PM_BASE    0xFFE05000

// PIN MUX
#define	PINMUXBase_	0xFFE08000
#define	WROM_PINMUX_		(PINMUXBase_ + 0x000)
#define	LOCAL_PINMUX_		(PINMUXBase_ + 0x004)
#define	ETC_PINMUX_			(PINMUXBase_ + 0x008)

// UART
#define	UARTBase_	0xFFE08400
#define	URXD_			(UARTBase_ + 0x000)
#define	UTXD_			(UARTBase_ + 0x000)
#define	UDLL_			(UARTBase_ + 0x000)
#define	UIER_			(UARTBase_ + 0x004)
#define	UDLH_			(UARTBase_ + 0x004)
#define	UIIR_			(UARTBase_ + 0x008)
#define	UFCON_		(UARTBase_ + 0x008)
#define	ULCON_		(UARTBase_ + 0x00C)
#define	ULSTR_		(UARTBase_ + 0x014)
#define	URXD0_		(UARTBase_ + 0x000)
#define	UTXD0_		(UARTBase_ + 0x000)
#define	UDLL0_		(UARTBase_ + 0x000)
#define	UIER0_		(UARTBase_ + 0x004)
#define	UDLH0_		(UARTBase_ + 0x004)
#define	UIIR0_		(UARTBase_ + 0x008)
#define	UFCON0_		(UARTBase_ + 0x008)
#define	ULCON0_		(UARTBase_ + 0x00C)
#define	ULSTR0_		(UARTBase_ + 0x014)
#define	URXD1_		(UARTBase_ + 0x020)
#define	UTXD1_		(UARTBase_ + 0x020)
#define	UDLL1_		(UARTBase_ + 0x020)
#define	UIER1_		(UARTBase_ + 0x024)
#define	UDLH1_		(UARTBase_ + 0x024)
#define	UIIR1_		(UARTBase_ + 0x028)
#define	UFCON1_		(UARTBase_ + 0x028)
#define	ULCON1_		(UARTBase_ + 0x02C)
#define	ULSTR1_		(UARTBase_ + 0x034)
#define	URXD2_		(UARTBase_ + 0x040)
#define	UTXD2_		(UARTBase_ + 0x040)
#define	UDLL2_		(UARTBase_ + 0x040)
#define	UIER2_		(UARTBase_ + 0x044)
#define	UDLH2_		(UARTBase_ + 0x044)
#define	UIIR2_		(UARTBase_ + 0x048)
#define	UFCON2_		(UARTBase_ + 0x048)
#define	ULCON2_		(UARTBase_ + 0x04C)
#define	ULSTR2_		(UARTBase_ + 0x054)
#define	URXD3_		(UARTBase_ + 0x060)
#define	UTXD3_		(UARTBase_ + 0x060)
#define	UDLL3_		(UARTBase_ + 0x060)
#define	UIER3_		(UARTBase_ + 0x064)
#define	UDLH3_		(UARTBase_ + 0x064)
#define	UIIR3_		(UARTBase_ + 0x068)
#define	UFCON3_		(UARTBase_ + 0x068)
#define	ULCON3_		(UARTBase_ + 0x06C)
#define	ULSTR3_		(UARTBase_ + 0x074)
#define	URXD4_		(UARTBase_ + 0x080)
#define	UTXD4_		(UARTBase_ + 0x080)
#define	UDLL4_		(UARTBase_ + 0x080)
#define	UIER4_		(UARTBase_ + 0x084)
#define	UDLH4_		(UARTBase_ + 0x084)
#define	UIIR4_		(UARTBase_ + 0x088)
#define	UFCON4_		(UARTBase_ + 0x088)
#define	ULCON4_		(UARTBase_ + 0x08C)
#define	ULSTR4_		(UARTBase_ + 0x094)

// PTC
#define PTCBase_			0xFFE08800
#define	PTC0_COUNT_		(PTCBase_ + 0x000)
#define	PTC0_LOAD_		(PTCBase_ + 0x004)
#define	PTC0_PERIOD_	(PTCBase_ + 0x008)
#define	PTC0_CON_			(PTCBase_ + 0x00C)
#define	PTC1_COUNT_		(PTCBase_ + 0x010)
#define	PTC1_LOAD_		(PTCBase_ + 0x014)
#define	PTC1_PERIOD_	(PTCBase_ + 0x018)
#define	PTC1_CON_			(PTCBase_ + 0x01C)
#define	PTC2_COUNT_		(PTCBase_ + 0x020)
#define	PTC2_LOAD_		(PTCBase_ + 0x024)
#define	PTC2_PERIOD_	(PTCBase_ + 0x028)
#define	PTC2_CON_			(PTCBase_ + 0x02C)
#define	PTC3_COUNT_		(PTCBase_ + 0x030)
#define	PTC3_LOAD_		(PTCBase_ + 0x034)
#define	PTC3_PERIOD_	(PTCBase_ + 0x038)
#define	PTC3_CON_			(PTCBase_ + 0x03C)
#define	PTC4_COUNT_		(PTCBase_ + 0x040)
#define	PTC4_LOAD_		(PTCBase_ + 0x044)
#define	PTC4_PERIOD_	(PTCBase_ + 0x048)
#define	PTC4_CON_			(PTCBase_ + 0x04C)

// PPM
#define PPMBase_	0xFFE08C00
#define PPMCON_		(PPMBase_ + 0x000)
#define PPMPWR_		(PPMBase_ + 0x004)

// I2C
#define I2CBase_	0xFFE09000
#define I2CCON_		(I2CBase_ + 0x000)
#define I2CDEV_		(I2CBase_ + 0x004)
#define I2CADDR_	(I2CBase_ + 0x008)
#define I2CNUM_		(I2CBase_ + 0x00C)
#define I2CSCAL_	(I2CBase_ + 0x010)
#define I2CRXD_		(I2CBase_ + 0x014)
#define I2CTXD_		(I2CBase_ + 0x014)

// ADC
#define ADCBase_	0xFFE09400
#define ADCON_		(ADCBase_ + 0x000)
#define ADCSEL_		(ADCBase_ + 0x004)
#define ADCDAT_		(ADCBase_ + 0x008)

// I2S
#define I2SBase_	0xFFE09800
#define I2SRXCON_	(I2SBase_ + 0x000)
#define I2SRXINT_	(I2SBase_ + 0x004)
#define I2SRXDAT_	(I2SBase_ + 0x008)
#define I2STXCON_	(I2SBase_ + 0x010)
#define I2STXINT_	(I2SBase_ + 0x014)
#define I2STXDAT_	(I2SBase_ + 0x018)

// WDT
#define WDTBase_	0xFFE09C00
#define WDTCON_		(WDTBase_ + 0x000)
#define WDTCNT_		(WDTBase_ + 0x004)

// GPIO
#define GPIOBase_		0xFFE0A000
#define	GPIO_IN_		(GPIOBase_ + 0x000)
#define	GPIO_OUT_		(GPIOBase_ + 0x00C)
#define	GPIO_OE_		(GPIOBase_ + 0x018)
#define	GPIO_AUX_		(GPIOBase_ + 0x024)

#define	GPIO_IN0_		(GPIOBase_ + 0x000)
#define	GPIO_IN1_		(GPIOBase_ + 0x004)
#define	GPIO_IN2_		(GPIOBase_ + 0x008)
#define	GPIO_OUT0_	(GPIOBase_ + 0x00C)
#define	GPIO_OUT1_	(GPIOBase_ + 0x010)
#define	GPIO_OUT2_	(GPIOBase_ + 0x014)
#define	GPIO_OE0_		(GPIOBase_ + 0x018)
#define	GPIO_OE1_		(GPIOBase_ + 0x01C)
#define	GPIO_OE2_		(GPIOBase_ + 0x020)
#define	GPIO_AUX0_	(GPIOBase_ + 0x024)
#define	GPIO_AUX1_	(GPIOBase_ + 0x028)
#define	GPIO_AUX2_	(GPIOBase_ + 0x02C)
#define	GPIO_INTE_	(GPIOBase_ + 0x030)
#define	GPIO_EDGE_	(GPIOBase_ + 0x034)
#define	GPIO_INTS_	(GPIOBase_ + 0x038)

// Interrupt Controller
#define	ICBase_					0xFFE0A400
#define	INTSRC_					(ICBase_ + 0x000)
#define	INTMODE_				(ICBase_ + 0x004)
#define	IRQTESTSRC_			(ICBase_ + 0x008)
#define	IRQSRCSEL_			(ICBase_ + 0x00C)
#define	IRQMASK_				(ICBase_ + 0x010)
#define	IRQSTS_					(ICBase_ + 0x014)
#define	IRQMASKSET_			(ICBase_ + 0x018)
#define	IRQMASKCLR_			(ICBase_ + 0x01C)

#define	FIQTESTSRC_			(ICBase_ + 0x028)
#define	FIQSRCSEL_			(ICBase_ + 0x02C)
#define	FIQMASK_				(ICBase_ + 0x030)
#define	FIQSTS_					(ICBase_ + 0x034)
#define	FIQMASKSET_			(ICBase_ + 0x038)
#define	FIQMASKCLR_			(ICBase_ + 0x03C)


// SPI
#define SPIBase_			0xFFE0A800
#define SPI0CON_			(SPIBase_ + 0x000)
#define SPI0DIV_			(SPIBase_ + 0x004)
#define SPI0RXDATA0_	(SPIBase_ + 0x010)
#define SPI0TXDATA0_	(SPIBase_ + 0x010)
#define SPI0RXDATA1_	(SPIBase_ + 0x014)
#define SPI0TXDATA1_	(SPIBase_ + 0x014)
#define SPI0RXDATA2_	(SPIBase_ + 0x018)
#define SPI0TXDATA2_	(SPIBase_ + 0x018)
#define SPI0RXDATA3_	(SPIBase_ + 0x01C)
#define SPI0TXDATA3_	(SPIBase_ + 0x01C)
#define SPI1CON_			(SPIBase_ + 0x020)
#define SPI1DIV_			(SPIBase_ + 0x024)
#define SPI1RXDATA0_	(SPIBase_ + 0x030)
#define SPI1TXDATA0_	(SPIBase_ + 0x030)
#define SPI1RXDATA1_	(SPIBase_ + 0x034)
#define SPI1TXDATA1_	(SPIBase_ + 0x034)
#define SPI1RXDATA2_	(SPIBase_ + 0x038)
#define SPI1TXDATA2_	(SPIBase_ + 0x038)
#define SPI1RXDATA3_	(SPIBase_ + 0x03C)
#define SPI1TXDATA3_	(SPIBase_ + 0x03C)

// ADDA
#define ADDABase_			0xD30000
#define	ADDC_CON_			(ADDABase_ + 0x000)
#define	ADC0_DOUT_		(ADDABase_ + 0x004)
#define	ADC1_DOUT_		(ADDABase_ + 0x008)
#define	ADC2_DOUT_		(ADDABase_ + 0x00C)
#define	DAC0_DIN_			(ADDABase_ + 0x010)
#define	DAC1_DIN_			(ADDABase_ + 0x014)
#define	DAC2_DIN_			(ADDABase_ + 0x018)
#define	DAC3_DIN_			(ADDABase_ + 0x01C)


/* MACRO */
#define mem(x) 			*((volatile unsigned *) x)
#define mem_half(x) *((volatile unsigned short *) x)
#define mem_byte(x) *((volatile unsigned char *) x)

#define write(addr, data) 			mem(addr) = data
#define write_half(addr, data) 	mem_half(addr) = data
#define write_byte(addr, data) 	mem_byte(addr) = data

#define read(addr) 				mem(addr)
#define read_half(addr) 	mem_half(addr)
#define read_byte(addr) 	mem_byte(addr)

#endif // GRIM5K_H

/* EOF */
