///////////////////////////////////////////////////////////////
// This file includes address information of MOON
///////////////////////////////////////////////////////////////
#define		MOON_CM_REG_BADDR		    0x10000000
#define		MOON_SC_REG_BADDR		    0x11000000
#define		MOON_EBI_REG_BADDR	        0x32000000

#define		MOON_CT0_REG_BADDR	        0x13000000
#define		MOON_CT1_REG_BADDR	        0x13000100
#define		MOON_CT2_REG_BADDR	        0x13000200

#define		MOON_IC_IRQ0_REG_BADDR		0x34000000
#define		MOON_IC_IRQ1_REG_BADDR		0x34000040
#define		MOON_IC_IRQ2_REG_BADDR		0x34000080
#define		MOON_IC_IRQ3_REG_BADDR		0x340000c0

#define		MOON_IC_FIQ0_REG_BADDR		0x34000020
#define		MOON_IC_FIQ1_REG_BADDR		0x34000060
#define		MOON_IC_FIQ2_REG_BADDR		0x340000a0
#define		MOON_IC_FIQ3_REG_BADDR		0x340000e0

#define		MOON_IC_SI0_REG_BADDR		0x34000010
#define		MOON_IC_SI1_REG_BADDR		0x34000050
#define		MOON_IC_SI2_REG_BADDR		0x34000090
#define		MOON_IC_SI3_REG_BADDR		0x340000d0

#define		MOON_RTC_REG_BADDR	        0x35000000	// (FFS)
#define		MOON_UA0_REG_BADDR	        0x36000000	// (FFS)
#define		MOON_UA1_REG_BADDR	        0x37000000	// (FFS)


#define		MOON_SC_OSC_REG		        0x11000004	//
#define		MOON_SC_LOCK_REG		    0x1100001c	//
/////////////////////////////////////////////////////////
//	Moon Interrupt Register
/////////////////////////////////////////////////////////
#define 	MOON_IRQ_STAT				0xc3000000
#define 	MOON_IRQ_RSTAT				0xc3000004
#define 	MOON_IRQ_ENSET				0xc3000008
#define 	MOON_IRQ_ENCLR				0xc300000c

#define 	MOON_ETH_INTR				0x00000001
#define 	MOON_USB_INTR				0x00000002
#define 	MOON_BUF_INTR				0x00000004
/////////////////////////////////////////////////////////
// SDRAM Region
/////////////////////////////////////////////////////////
#define     SDRAM_BASE                  0x80000000

/////////////////////////////////////////////////////////
// LM Region
/////////////////////////////////////////////////////////
#define ETH_BASE_ADDR              0xc0000000  //Ethernet0 Register Base Addrs
#define ETH_TX_INT_Q               0xc0003000
#define ETH_RX_INT_Q               0xc0003080
#define ETH_TX_PKT_Q               0xc0003100

#define USB_BASE_ADDR              0xc1000000  //Ethernet1 Register Base Addrs
#define USB_TX_INT_Q               0xc1002000
#define USB_RX_INT_Q               0xc1002080
#define USB_TX_PKT_Q               0xc1002100

#define DMA_BASE_ADDR       		0xc2000000
#define LBUFFER_BADDR 				0xc2000040
#define DBUFFER_BADDR 				0xc20000c0



// ETHERNET
#define     ETH_BASE                    0xc0000000
#define 	ETH_TX_INT_Q               	0xc0003000
#define 	ETH_RX_INT_Q               	0xc0003080
#define 	ETH_TX_PKT_Q               	0xc0003100

#define     ETH_CTRL_CFG                0xc0000000
#define     ETH_PAUSE_TIMER             0xc0000004
#define     ETH_MHASH_F0                0xc0000008
#define     ETH_MHASH_F1                0xc000000c
#define     ETH_SMAC_HADDR              0xc0000010
#define     ETH_SMAC_LADDR              0xc0000014
#define     ETH_DMAC_HADDR              0xc0000018
#define     ETH_DMAC_LADDR              0xc000001c
#define     ETH_FCTRL_HDA               0xc0000020
#define     ETH_FCTRL_LDA               0xc0000024
#define     ETH_LEN_TYPE                0xc0000028
#define     ETH_OP_PTIME                0xc000002c
#define     ETH_RP_STATUS               0xc0000030
#define     ETH_RL_STATUS               0xc0000034
#define     ETH_TP_STATUS               0xc0000038
#define     ETH_TL_STATUS               0xc000003c
#define     ETH_MI_CFG                  0xc0000040
#define     ETH_PHYST_RDEN              0xc0000044
#define     ETH_PHYST_MASK              0xc0000048
#define     ETH_RMIB0                   0xc000004c
#define     ETH_RMIB1                   0xc0000050
#define     ETH_RMIB2                   0xc0000054
#define     ETH_RMIB3                   0xc0000058
#define     ETH_RMIB4                   0xc000005c
#define     ETH_RMIB5                   0xc0000060
#define     ETH_RMIB6                   0xc0000064
#define     ETH_TMIB0                   0xc0000068
#define     ETH_TMIB1                   0xc000006c
#define     ETH_TMIB2                   0xc0000070
#define     ETH_TMIB3                   0xc0000074
#define     ETH_TMIB4                   0xc0000078
#define     ETH_TMIB5                   0xc000007c
#define     ETH_INTR_EN                 0xc0000080
#define     ETH_INTR_MASK               0xc0000084
#define     ETH_INTR_SRC                0xc0000088
#define     ETH_TXPKT_QUE               0xc000008c
#define     ETH_TXPKT_SPTR              0xc0000090
#define     ETH_TXPKT_LEN               0xc0000094

// USB
#define     USB_CFG                     0xc1000000
#define     USB_E0STATUS                0xc1000004
#define     USB_E1STATUS                0xc1000008
#define     USB_E2STATUS                0xc100000c
#define     USB_E3STATUS                0xc1000010
#define     USB_TXPKT_QUE               0xc1000014
#define     USB_TXPKT_SPTR              0xc1000018
#define     USB_TXPKT_LEN               0xc100001c
#define     USB_INTR_EN                 0xc1000020
#define     USB_INTR_MASK               0xc1000024
#define     USB_INTR_SRC                0xc1000028

#define     USB_DEV_D0                  0xc1000040
#define     USB_DEV_D1                  0xc1000044
#define     USB_DEV_D2                  0xc1000048
#define     USB_DEV_D3                  0xc100004c
#define     USB_DEV_D4                  0xc1000050
#define     USB_DEV_Q0                  0xc1000054
#define     USB_DEV_Q1                  0xc1000058
#define     USB_DEV_Q2                  0xc100005c
#define     USB_CFG_D0                  0xc1000060
#define     USB_CFG_D1                  0xc1000064
#define     USB_CFG_D2                  0xc1000068
#define     USB_OSCFG_D0                0xc100006c
#define     USB_OSCFG_D1                0xc1000070
#define     USB_OSCFG_D2                0xc1000074
#define     USB_INTF_D0                 0xc1000078
#define     USB_INTF_D1                 0xc100007c
#define     USB_INTF_D2                 0xc1000080
#define     USB_ENDP1_D0                0xc1000084
#define     USB_ENDP1_D1                0xc1000088
#define     USB_ENDP2_D0                0xc100008c
#define     USB_ENDP2_D1                0xc1000090
#define     USB_ENDP3_D0                0xc1000094
#define     USB_ENDP3_D1                0xc1000098

// DMA
#define     DMA_BASE                    0xc2000000

#define     DMA_BUF_PTR                 0xc200000c
#define     DMA_BUF_SIZE                0xc2000010

#define     DMA_LBUF0                   0xc2000040
#define     DMA_LBUF1                   0xc2000044
#define     DMA_LBUF2                   0xc2000048
#define     DMA_LBUF3                   0xc200004c
#define     DMA_LBUF4                   0xc2000050
#define     DMA_LBUF5                   0xc2000054
#define     DMA_LBUF6                   0xc2000058
#define     DMA_LBUF7                   0xc200005c
#define     DMA_LBUF8                   0xc2000060
#define     DMA_LBUF9                   0xc2000064
#define     DMA_LBUF10                  0xc2000068
#define     DMA_LBUF11                  0xc200006c
#define     DMA_LBUF12                  0xc2000070
#define     DMA_LBUF13                  0xc2000074
#define     DMA_LBUF14                  0xc2000078
#define     DMA_LBUF15                  0xc200007c
#define     DMA_LBUF16                  0xc2000080
#define     DMA_LBUF17                  0xc2000084
#define     DMA_LBUF18                  0xc2000088
#define     DMA_LBUF19                  0xc200008c
#define     DMA_LBUF20                  0xc2000090
#define     DMA_LBUF21                  0xc2000094
#define     DMA_LBUF22                  0xc2000098
#define     DMA_LBUF23                  0xc200009c
#define     DMA_LBUF24                  0xc20000a0
#define     DMA_LBUF25                  0xc20000a4
#define     DMA_LBUF26                  0xc20000a8
#define     DMA_LBUF27                  0xc20000ac
#define     DMA_LBUF28                  0xc20000b0
#define     DMA_LBUF29                  0xc20000b4
#define     DMA_LBUF30                  0xc20000b8
#define     DMA_LBUF31                  0xc20000bc

#define     DMA_DBUF0                   0xc20000c0
#define     DMA_DBUF1                   0xc20000c4
#define     DMA_DBUF2                   0xc20000c8
#define     DMA_DBUF3                   0xc20000cc
#define     DMA_DBUF4                   0xc20000d0
#define     DMA_DBUF5                   0xc20000d4
#define     DMA_DBUF6                   0xc20000d8
#define     DMA_DBUF7                   0xc20000dc
#define     DMA_DBUF8                   0xc20000e0
#define     DMA_DBUF9                   0xc20000e4
#define     DMA_DBUF10                  0xc20000e8
#define     DMA_DBUF11                  0xc20000ec
#define     DMA_DBUF12                  0xc20000f0
#define     DMA_DBUF13                  0xc20000f4
#define     DMA_DBUF14                  0xc20000f8
#define     DMA_DBUF15                  0xc20000fc
#define     DMA_DBUF16                  0xc2000100
#define     DMA_DBUF17                  0xc2000104
#define     DMA_DBUF18                  0xc2000108
#define     DMA_DBUF19                  0xc200010c
#define     DMA_DBUF20                  0xc2000110
#define     DMA_DBUF21                  0xc2000114
#define     DMA_DBUF22                  0xc2000118
#define     DMA_DBUF23                  0xc200011c
#define     DMA_DBUF24                  0xc2000120
#define     DMA_DBUF25                  0xc2000124
#define     DMA_DBUF26                  0xc2000128
#define     DMA_DBUF27                  0xc200012c
#define     DMA_DBUF28                  0xc2000130
#define     DMA_DBUF29                  0xc2000134
#define     DMA_DBUF30                  0xc2000138
#define     DMA_DBUF31                  0xc200013c

//////////////////////////////////////////////////////////////
//	DRAM memery
//////////////////////////////////////////////////////////////
#define 	RX_BUFFER_BASE_ADDR 		0x1000000
#define 	DEBUG_VAR_ADDR      		0x1040000

#define 	RX_DESC_BUF_ADDR	0x1050000
#define 	RX_DESC_BUF_NUM     0x100
#define 	RX_DESC_BUF_LEN     0x4

#define 	TX_DESC_BUF_ADDR	0x1060000
#define 	TX_DESC_BUF_NUM     0x100
#define 	TX_DESC_BUF_LEN     0x4

