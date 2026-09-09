#ifndef __MOON_REG_H__
#define __MOON_REG_H__
///////////////////////////////////////////////////////////////////
// This header file include register defintions of the MOON
///////////////////////////////////////////////////////////////////
typedef struct _MOON_ETH_REG{
    volatile unsigned int eth_cfg;      //0xc0000000
    volatile unsigned int rand_clnum;   //0xc0000004
    volatile unsigned int mhash_f0;     //0xc0000008
    volatile unsigned int mhash_f1;     //0xc000000c
    volatile unsigned int smac_haddr;   //0xc0000010 
    volatile unsigned int smac_laddr;   //0xc0000014
    volatile unsigned int dmac_haddr;   //0xc0000018
    volatile unsigned int dmac_laddr;   //0xc000001c
    volatile unsigned int fctrl_hda;    //0xc0000020
    volatile unsigned int fctrl_lda;    //0xc0000024
    volatile unsigned int len_type;     //0xc0000028
    volatile unsigned int op_ptime;     //0xc000002c
    volatile unsigned int rx_psta;      //0xc0000030
    volatile unsigned int rx_lsta;      //0xc0000034
    volatile unsigned int tx_psta;      //0xc0000038
    volatile unsigned int tx_lsta;      //0xc000003c
    volatile unsigned int mi_cfg;       //0xc0000040
    volatile unsigned int physt_read;   //0xc0000044
    volatile unsigned int physt_mask;   //0xc0000048
    volatile unsigned int eth_rmib0;    //0xc000004c
    volatile unsigned int eth_rmib1;    //0xc0000050
    volatile unsigned int eth_rmib2;    //0xc0000054
    volatile unsigned int eth_rmib3;    //0xc0000058
    volatile unsigned int eth_rmib4;    //0xc000005c
    volatile unsigned int eth_rmib5;    //0xc0000060
    volatile unsigned int eth_rmib6;    //0xc0000064
    volatile unsigned int eth_tmib0;    //0xc0000068
    volatile unsigned int eth_tmib1;    //0xc000006c
    volatile unsigned int eth_tmib2;    //0xc0000070
    volatile unsigned int eth_tmib3;    //0xc0000074
    volatile unsigned int eth_tmib4;    //0xc0000078
    volatile unsigned int eth_tmib5;    //0xc000007c
    volatile unsigned int intr_en;      //0xc0000080
    volatile unsigned int intr_mask;    //0xc0000084
    volatile unsigned int intr_src;     //0xc0000088
    volatile unsigned int txpkt_queue;  //0xc000008c
    volatile unsigned int txpkt_ptr;    //0xc0000090
    volatile unsigned int txpkt_len;    //0xc0000094
}MOON_ETH_REG,*PMOON_ETH_REG;


// USB
typedef struct _MOON_USB_REG	{
    volatile unsigned int   usb_cfg;
    volatile unsigned int   usb_e0status;
    volatile unsigned int   usb_e1status;
    volatile unsigned int   usb_e2status;
    volatile unsigned int   usb_e3status;
    volatile unsigned int   usb_txpkt_que;
    volatile unsigned int   usb_txpkt_sptr;
    volatile unsigned int   usb_txpkt_len;
    volatile unsigned int   usb_intr_en;
    volatile unsigned int   usb_intr_mask;
    volatile unsigned int   usb_intr_src;
    volatile unsigned int   usb_dev_d0;
    volatile unsigned int   usb_dev_d1;
    volatile unsigned int   usb_dev_d2;
    volatile unsigned int   usb_dev_d3;
    volatile unsigned int   usb_dev_d4;
    volatile unsigned int   usb_dev_q0;
    volatile unsigned int   usb_dev_q1;
    volatile unsigned int   usb_dev_q2;
    volatile unsigned int   usb_cfg_d0;
    volatile unsigned int   usb_cfg_d1;
    volatile unsigned int   usb_cfg_d2;
    volatile unsigned int   usb_oscfg_d0;
    volatile unsigned int   usb_oscfg_d1;
    volatile unsigned int   usb_oscfg_d2;
    volatile unsigned int   usb_intf_d0;
    volatile unsigned int   usb_intf_d1;
    volatile unsigned int   usb_intf_d2;
    volatile unsigned int   usb_endp1_d0;
    volatile unsigned int   usb_endp1_d1;
    volatile unsigned int   usb_endp2_d0;
    volatile unsigned int   usb_endp2_d1;
    volatile unsigned int   usb_endp3_d0;
    volatile unsigned int   usb_endp3_d1;
}MOON_USB_REG,*PMOON_USB_REG;

typedef struct _MOON_DMA_REG{
    volatile unsigned int dummy0;
    volatile unsigned int dummy1;
    volatile unsigned int dummy2;
    volatile unsigned int buf_ptr;      
    volatile unsigned int buf_size;
}MOON_DMA_REG,*PMOON_DMA_REG;

/*
// DMA
    volatile unsigned int   dma_buf_ptr;
    uint    dma_buf_size;
    
    uint    dma_lbuf0;
    uint    dma_lbuf1;
    uint    dma_lbuf2;
    uint    dma_lbuf3;
    uint    dma_lbuf4;
    uint    dma_lbuf5;
    uint    dma_lbuf6;
    uint    dma_lbuf7;
    uint    dma_lbuf8;
    uint    dma_lbuf9;
    uint    dma_lbuf10;
    uint    dma_lbuf11;
    uint    dma_lbuf12;
    uint    dma_lbuf13;
    uint    dma_lbuf14;
    uint    dma_lbuf15;
    uint    dma_lbuf16;
    uint    dma_lbuf17;
    uint    dma_lbuf18;
    uint    dma_lbuf19;
    uint    dma_lbuf20;
    uint    dma_lbuf21;
    uint    dma_lbuf22;
    uint    dma_lbuf23;
    uint    dma_lbuf24;
    uint    dma_lbuf25;
    uint    dma_lbuf26;
    uint    dma_lbuf27;
    uint    dma_lbuf28;
    uint    dma_lbuf29;
    uint    dma_lbuf30;
    uint    dma_lbuf31;        

    uint    dma_dbuf0;
    uint    dma_dbuf1;
    uint    dma_dbuf2;
    uint    dma_dbuf3;
    uint    dma_dbuf4;
    uint    dma_dbuf5;
    uint    dma_dbuf6;
    uint    dma_dbuf7;
    uint    dma_dbuf8;
    uint    dma_dbuf9;
    uint    dma_dbuf10;
    uint    dma_dbuf11;
    uint    dma_dbuf12;
    uint    dma_dbuf13;
    uint    dma_dbuf14;
    uint    dma_dbuf15;
    uint    dma_dbuf16;
    uint    dma_dbuf17;
    uint    dma_dbuf18;
    uint    dma_dbuf19;
    uint    dma_dbuf20;
    uint    dma_dbuf21;
    uint    dma_dbuf22;
    uint    dma_dbuf23;
    uint    dma_dbuf24;
    uint    dma_dbuf25;
    uint    dma_dbuf26;
    uint    dma_dbuf27;
    uint    dma_dbuf28;
    uint    dma_dbuf29;
    uint    dma_dbuf30;
    uint    dma_dbuf31;        

} MOON_LM_REG,*PMOON_LM_REG;
DEBUG_VAR_ADDR
*/

typedef struct _MOON_CM_REG	{
	uint	cm_id;				// 0x10000000
	uint	cm_proc;			// 0x10000004
	uint	cm_osc;				// 0x10000008
	uint	cm_ctrl;			// 0x1000000c
	uint	cm_stat;			// 0x10000010
	uint	cm_lock;			// 0x10000014
	uint	res_cm0;			// 0x10000018
	uint	res_cm1;			// 0x1000001c
	uint	cm_sdram;			// 0x10000020
	uint	res_cm2;			// 0x10000024
	uint	res_cm3;			// 0x10000028
	uint	res_cm4;			// 0x1000002c
	uint	res_cm5;			// 0x10000020
	uint	res_cm6;			// 0x10000024
	uint	res_cm7;			// 0x10000028
	uint	res_cm8;			// 0x1000002c
	uint	cm_irq_stat;		// 0x10000040
	uint	cm_irq_rstat;		// 0x10000044
	uint	cm_irq_enset;		// 0x10000048
	uint	cm_irq_enclr;		// 0x1000004c
	uint	cm_softint_set;		// 0x10000050
	uint	cm_softint_clr;		// 0x10000054
	uint	res_cm9;			// 0x10000058
	uint	res_cma;			// 0x1000005c
	uint	cm_fiq_stat;		// 0x10000060
	uint	cm_fiq_rstat;		// 0x10000064
	uint	cm_fiq_enset;		// 0x10000068
	uint	cm_fiq_enclr;		// 0x1000006c
} MOON_CM_REG;

typedef struct _MOON_SC_REG	{
	uint	sc_id;				// 0x11000000
	uint	sc_osc;				// 0x11000004
	uint	sc_ctrls;			// 0x11000008
	uint	sc_ctrlc;			// 0x1100000c
	uint	sc_dec;				// 0x11000010
	uint	sc_arb;				// 0x11000014
	uint	sc_pci;				// 0x11000018
	uint	sc_lock;			// 0x1100001c
	uint	sc_lbfaddr;			// 0x11000020
	uint	sc_lbfcode;			// 0x11000024
} MOON_SC_REG;

typedef struct _MOON_EBI_REG	{
	uint	ebi_csr0;			// 0x12000000
	uint	ebi_csr1;			// 0x12000004
	uint	ebi_csr2;			// 0x12000008
	uint	ebi_csr3;			// 0x1200000c
} MOON_EBI_REG;

typedef struct _MOON_CT_REG	{
	uint	timer_load;
	uint	timer_value;
	uint	timer_ctrl;
	uint	timer_clr;
} MOON_CT_REG;	// 3 Kinds Of Register Group

typedef struct _MOON_IC_REG	{
	uint	irq_status;
	uint	irq_rawstat;
	uint	irq_enbset;
	uint	irq_enbclr;
} MOON_IC_REG;	// 4 Kinds Of Register Group, IRQ/FIQ

typedef struct _MOON_SWI_REG	{
	uint	swi_enbset;
	uint	swi_enbclr;
} MOON_SWI_REG;

typedef struct _MOON_RTC_REG	{
	uint	rtc_dr;				// 0x15000000
	uint	rtc_mr;				// 0x15000004
	uint	rtc_stateoi;		// 0x15000008
	uint	rtc_lr;				// 0x1500000c
	uint	rtc_cr;				// 0x15000010
} MOON_RTC_REG;


//////////////////////////////////////////////////////////////////
// Individual Register Format
//////////////////////////////////////////////////////////////////
typedef struct _CM_CTRL	{
	uint	led:1;		// read,write
	uint	mbdet:1;	// read only, MotherBoardDetect
	uint	remap:1;	// read,write
	uint	reset:1;	// write only
	uint	res:28;
} CM_CTRL;		// cm_ctrl (0x1000000c)

///////////////////////////////////////////////////////////////
// Moon Object
///////////////////////////////////////////////////////////////

typedef struct _DEBUG_VAR
{
    unsigned int balloc_int_occur;
    
    unsigned int eth_tx_try;
        unsigned int eth_tx_complete;
        unsigned int eth_tx_frame_Q_full;
        unsigned int eth_tx_busy;


    unsigned int eth_tx_int_occur;
        unsigned int eth_tx_ok;
        unsigned int eth_tx_late_collision;
        unsigned int eth_tx_excess_collision;
        unsigned int eth_tx_carrier_sense_err;

    unsigned int eth_rx_int_occur;
        unsigned int eth_rx_ok;
        unsigned int eth_rx_crc_error;
        unsigned int eth_rx_short_packet;
        unsigned int eth_rx_long_packet;
        unsigned int eth_rx_over_flow;

    unsigned int eth_rx_pause_frame;
    unsigned int eth_tx_pause_frame;
    unsigned int eth_mi_interrupt;
    unsigned int eth_phy_interrupt;
    
    unsigned int usb_tx_try;
        unsigned int usb_tx_complete;

    unsigned int usb_tx_int_occur;
        unsigned int usb_tx_ok;

    unsigned int usb_rx_int_occur;
        unsigned int usb_rx_ok;

}DEBUG_VAR,*PDEBUG_VAR;

typedef struct _INTR_QUE    {
    unsigned short  data_len;
    unsigned short  frame_status;
    unsigned int    data_addr;
}INTR_QUE, *PINTR_QUE;

typedef struct _moon_priv
{
    PMOON_ETH_REG 	eth_reg;
    PMOON_USB_REG	usb_reg;
    PINTR_QUE   rx_eth_queue;
    PINTR_QUE   tx_eth_queue;
    PINTR_QUE   rx_usb_queue;
    PINTR_QUE   tx_usb_queue;
}moon_priv,*pmoon_priv;


//  Tx Frame Status
#define TX_FRAME_ST_OK                  0x1
#define TX_FRAME_ST_LATE_COLLISION      0x2
#define TX_FRAME_ST_EXCESS_COLLISION    0x4
#define TX_FRAME_ST_ERR_MASK            0x06

//  Rx Frame Status
#define RX_FRAME_ST_OK                      0x1
#define RX_FRAME_ST_CRC_ERROR               0x2
#define RX_FRAME_ST_SHORT_PACKET            0x4
#define RX_FRAME_ST_LONG_PACKET             0x8
#define RX_FRAME_ST_OVER_FLOW               0x16
#define RX_FRAME_ST_ERR_MASK                0x1e


#endif //__MOON_REG_H__