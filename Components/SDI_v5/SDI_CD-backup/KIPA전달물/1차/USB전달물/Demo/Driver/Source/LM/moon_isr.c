////////////////////////////////////////////////////////////////////  
// INCLUDE Files
////////////////////////////////////////////////////////////////////
#include	"uhal.h"
#include	"gtx.h"
#include	"MOON_type.h"
#include	"MOON_addr.h"
#include	"MOON_reg.h"
/////////////////////////////////////////////////////////////////////
extern int gBufIdx;
extern moon_priv MoonObj;
extern PDEBUG_VAR debug_var;	

void moon_balloc_interrupt(PMOON_DMA_REG pDmaReg);
void moon_balloc(PMOON_DMA_REG pDmaReg);
void moon_eth_interrupt(PMOON_ETH_REG pEthReg);
void eth_tx_interrupt(PMOON_ETH_REG eth_reg);
void eth_rx_interrupt(PMOON_ETH_REG eth_reg);
int eth_tx_data(PMOON_ETH_REG pEthReg,int addr,int len);
int usb_tx_data(int addr,int len);
void moon_usb_interrupt(PMOON_USB_REG pDmaReg);
void usb_rx_interrupt(void);
void usb_tx_interrupt(void);

////////////////////////////////////////////////////////////////////
// Name : MOONISR
// Desc : ISR for MOON
// Caution : LM Interrupt is mapped to extern0 interrupt of ARM
//			 Later extern0 and extern1 interrupt will be used
////////////////////////////////////////////////////////////////////

void MOONISR()
{
	int intr_src=	*(int*)IC_IRQ0_STAT_REG;
	uHALr_printf("Interrupt Occurs\n");
	if(intr_src&(1<<MOON_INTR))
	{
				
		uint MoonIntReg=*(int*)MOON_IRQ_STAT;
		
		if(MoonIntReg & MOON_BUF_INTR)
	    {
    		moon_balloc_interrupt((PMOON_DMA_REG)DMA_BASE_ADDR);
	    }
	    
	    if(MoonIntReg & MOON_ETH_INTR)
	    {
    		moon_eth_interrupt((PMOON_ETH_REG)ETH_BASE_ADDR);
    	}
	    
	    if (MoonIntReg & MOON_USB_INTR)
    	{
    		moon_usb_interrupt((PMOON_USB_REG)USB_BASE_ADDR);
	    }
		
	}
}	// of MOONISR (Main Interrupt Service Routine)



void moon_balloc_interrupt(PMOON_DMA_REG pDmaReg)
{
    debug_var->balloc_int_occur++;
    moon_balloc(pDmaReg);   	
}

void moon_balloc(PMOON_DMA_REG pDmaReg)
{
    unsigned int buf_wptr=(pDmaReg->buf_ptr>>8)&0x1f;
    unsigned int buf_size =pDmaReg->buf_size&0xffff;
    unsigned int i;

    for (i = 0; i < 16; i++)
    {
    	*(unsigned int *) (LBUFFER_BADDR+(buf_wptr<<2)) = RX_DESC_BUF_ADDR + (gBufIdx<<4);
    	*(unsigned int *) (DBUFFER_BADDR+(buf_wptr<<2)) = RX_BUFFER_BASE_ADDR + gBufIdx*buf_size;
    	buf_wptr++;
    	if (buf_wptr == 0x20) buf_wptr=0;
    	
    	gBufIdx++;
    	if (gBufIdx==0x100) gBufIdx= 0;
    }
    
    pDmaReg->buf_ptr &= 0xffffe0ff;
 
    pDmaReg->buf_ptr |= (buf_wptr<<8);
}

void moon_eth_interrupt(PMOON_ETH_REG pEthReg)
{
    unsigned int intr_src=pEthReg->intr_src;

    if(intr_src&0x3f)
    {
        if(intr_src & 1)
        {
            debug_var->eth_rx_int_occur++;
            eth_rx_interrupt(pEthReg);
        }
        if(intr_src & 2)
        {
            debug_var->eth_tx_int_occur++;
            eth_tx_interrupt(pEthReg);
        }

        if(intr_src & 0x3c)
        {
            if(intr_src & 0x4)
            {
                debug_var->eth_rx_pause_frame++;
                pEthReg->intr_src|=0x400;   //clear rx_pause_frame_int
            }

            if(intr_src & 0x8)
            {
                debug_var->eth_tx_pause_frame++;
                pEthReg->intr_src|=0x800;   //clear tx_pause_frame_int
            }
            if(intr_src & 0x10)
            {
                debug_var->eth_mi_interrupt++;
                pEthReg->intr_src|=0x1000;  //clear MI interrupt
            }
            if(intr_src & 0x20)
            {
                debug_var->eth_phy_interrupt++;
                pEthReg->intr_src|=0x2000;  //clear PHY interrupt
            }
        }

    }

}   // of moon_eth_interrupt (Main Interrupt Service Routine)


void eth_tx_interrupt(PMOON_ETH_REG eth_reg)
{
	pmoon_priv priv=&MoonObj;
    PINTR_QUE pTxMsg;
    unsigned int tx_q_index=(eth_reg->intr_src&0xf0000000)>>28;
    

    pTxMsg=(PINTR_QUE)&priv->tx_eth_queue[tx_q_index];
    if(pTxMsg->frame_status & TX_FRAME_ST_ERR_MASK)
    {
        if(pTxMsg->frame_status & TX_FRAME_ST_LATE_COLLISION)
            debug_var->eth_tx_late_collision++;
        else if(pTxMsg->frame_status & TX_FRAME_ST_EXCESS_COLLISION)
            debug_var->eth_tx_excess_collision++;
    }else
    {
        debug_var->eth_tx_ok++;
    }


    eth_reg->intr_src|=0x200;   
    
}

void eth_rx_interrupt(PMOON_ETH_REG eth_reg)
{

	pmoon_priv priv=&MoonObj;
    PINTR_QUE pRxMsg;
    unsigned int rx_q_index=(eth_reg->intr_src&0x00f00000)>>20;
    int pkt_size,pkt_addr;

    pRxMsg=(PINTR_QUE)&priv->rx_eth_queue[rx_q_index];
    if(pRxMsg->frame_status&RX_FRAME_ST_ERR_MASK)
    {
        if(pRxMsg->frame_status     & RX_FRAME_ST_CRC_ERROR) debug_var->eth_rx_crc_error++;
        else if(pRxMsg->frame_status & RX_FRAME_ST_SHORT_PACKET) debug_var->eth_rx_short_packet++;
        else if(pRxMsg->frame_status & RX_FRAME_ST_LONG_PACKET) debug_var->eth_rx_long_packet++;
        else if(pRxMsg->frame_status & RX_FRAME_ST_OVER_FLOW) debug_var->eth_rx_over_flow++;
    }else
    {
        debug_var->eth_rx_ok++;
        //extract buffer(type 0) infomation.
        pkt_addr=pRxMsg->data_addr;
        pkt_size=pRxMsg->data_len;

		// Send Data
        while(!usb_tx_data(pkt_addr,pkt_size));
        
    }
//  ethernet_rx_interrupt clear
    eth_reg->intr_src|=0x100;
}


int eth_tx_data(PMOON_ETH_REG pEthReg,int addr,int len)
{

	debug_var->eth_tx_try++;


    if ( pEthReg->txpkt_queue & 0xc0000000)
    {
        if(pEthReg->txpkt_queue & 0x80000000)
        {
	 		debug_var->eth_tx_frame_Q_full++;

        }
        if(pEthReg->txpkt_queue & 0x40000000)
        {
	 		debug_var->eth_tx_busy++;
      
        }
        return 0;       //return error
    }

    pEthReg->txpkt_ptr = (int)addr;	
    pEthReg->txpkt_len = len;

#ifdef  CAFE_DEBUG
    printk("\n ETHERNET TX >>\n");
    dump(pkt_ptr, pkt_sz);
#endif

	debug_var->eth_tx_complete++;

    pEthReg->txpkt_queue |= 0x100;      //transmit mac frame.
   
   return 1;
}

int usb_tx_data(int addr,int len)
{


    debug_var->usb_tx_try++;

    *(int*)0x43000018 = (int)addr;
    *(int*)0x4300001c = len;

#ifdef  CSLEE_DEBUG
    if(IsEth0) printk("\n ETHER0 TX >>\n");
    else printk("\n ETHER1 TX >>\n");
    dump(pkt_ptr, pkt_sz);
#endif

	debug_var->usb_tx_complete++;

    *(int*)0x43000014 |= 0x100;      //transmit mac frame.
   
   return 1;
}
/***************************************************************
* Eth1 interrupt Handler 
* -tx/rx interrupt, 
* -send function
****************************************************************/
//#define USB_INTR_SRC	0x43000028

void moon_usb_interrupt(PMOON_USB_REG pUsbReg)
{
	int intr_src=*(int*)USB_INTR_SRC;

//	uHALr_printf("usb_int occur:(0x%08x)\n",intr_src);

    if(intr_src & 0x3f)
    {
        if(intr_src & 1)
        {
            debug_var->usb_rx_int_occur++;

            usb_rx_interrupt();
        }
        if(intr_src & 2)
        {
            debug_var->usb_tx_int_occur++;
            usb_tx_interrupt();
        }

  
    }
   
}   // of moon1_usb_interrupt (Main Interrupt Service Routine)


void usb_rx_interrupt()
{

	pmoon_priv priv=&MoonObj;
	PINTR_QUE pRxMsg;
    unsigned int rx_q_index=((*(int*)USB_INTR_SRC) &0x00f00000)>>20;
    int pkt_size,pkt_addr;

    pRxMsg=(PINTR_QUE)&priv->rx_usb_queue[rx_q_index];
//  ASSERT(pRxMsg->frame_status == 0);      //check frame error bits

    {
            debug_var->usb_rx_ok++;       
        //extract buffer(type 0) infomation.
        pkt_addr=*(int*)pRxMsg->data_addr;
        pkt_size=pRxMsg->data_len;
        
        // Send Data
        while(!eth_tx_data((PMOON_ETH_REG)ETH_BASE_ADDR,pkt_addr,pkt_size));
        
#ifdef  CSLEE_DEBUG
    printk("\n* ETHER1 RX >>\n");
    dump((char*)pkt_addr, pkt_size);
#endif

    }
//  ethernet_rx_interrupt clear
    *(int*)USB_INTR_SRC|=0x100;
}

void usb_tx_interrupt()
{
	pmoon_priv priv=&MoonObj;
    PINTR_QUE pTxMsg;
    unsigned int tx_q_index=((*(int*)USB_INTR_SRC)&0xf0000000)>>28;

//  	uHALr_printf("usb_tx\n");
    pTxMsg=(PINTR_QUE)&priv->tx_usb_queue[tx_q_index];

    {
        debug_var->usb_tx_ok++;
    }


//  interrupt clear 
    *(int*)USB_INTR_SRC|=0x200;
}
