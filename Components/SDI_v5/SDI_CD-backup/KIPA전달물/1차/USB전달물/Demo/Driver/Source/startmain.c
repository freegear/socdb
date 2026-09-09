////////////////////////////////////////////////////////////////////
// This file contains main() function, start point of GTX CEU-SAR
// Test Devei Driver
// main() is called by boot.o, boot image provided by uHAL library.
// If you want to add some addtional function, register them here
// Glotrex Co, Ltd 2001.03.01
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////  
// INCLUDE Files
////////////////////////////////////////////////////////////////////
#include	"uhal.h"
#include	"gtx.h"
#include	"MOON_type.h"
#include	"MOON_addr.h"
#include	"MOON_reg.h"


////////////////////////////////////////////////////////////////////
// define constants
////////////////////////////////////////////////////////////////////
#define DATA_BUF_SIZE       0x600

#define MOON_IRQ_BIT  9
#define MOON_PROMPT	"Moon >"

// Mode setting
#define ETH_FULL_DUPLEX 		1
#define ETH_PROMISCUOUS		1
#define ETH_ACCEPT_GADDR		0
#define ETH_CFRAME_PASS 		0
#define ETH_TXPAUSE_ENABLE	0
#define ETH_TXFCTRL_ENABLE	0
#define ETH_LIMIT_CLSN 		1
#define ETH_CRCTR_MODE		0
#define ETH_STRST_ONREAD		0
#define ETH_TX_ENABLE 		1
#define ETH_RX_ENABLE		1
#define ETH_GMII				0

////////////////////////////////////////////////////////////////////
// Global Variable
////////////////////////////////////////////////////////////////////
int gBufIdx;
moon_priv MoonObj;
PDEBUG_VAR debug_var;	
char Eth0_MACaddr[]={0x00,0x40,0x99,0x36,0x35,0x01};
////////////////////////////////////////////////////////////////////
// Function ProtoType
////////////////////////////////////////////////////////////////////
void DmaRegInit(PMOON_DMA_REG dma_reg);
void Moon_Prompt(void);
void Moon_PrintLogo(void);
void print_stat();
void read();
void write();

////////////////////////////////////////////////////////////////////
// External Function Declaration
////////////////////////////////////////////////////////////////////
extern void		MOONISR();

//extern UINT		g_default_IRQn;                                                                                                                                                                                                                                                                                            
//extern JOB_QUE_CTRL		g_job_ctrl_idx[NUM_OF_PRIORITY];


////////////////////////////////////////////////////////////////////
// Global Variable Definition
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
// Name : GtxCtrlClk()
// Desc : Adjust Clock Rate
// Param : The Value For Setting SC_OSC(0x11000004) & SC_LOCK(0x1100001c)
////////////////////////////////////////////////////////////////////
void GtxCtrlClk(uint osc, uint lock)
{

	*(uint*) MOON_SC_LOCK_REG = lock;
	*(uint*) MOON_SC_OSC_REG = osc;
		// (osc+8)/4 =MHz
}


void Init_dd()
{
	pmoon_priv priv=&MoonObj;
    priv->eth_reg		=	(PMOON_ETH_REG)ETH_BASE;
    priv->rx_eth_queue	=	(PINTR_QUE)ETH_RX_INT_Q;
    priv->tx_eth_queue	=	(PINTR_QUE)ETH_TX_INT_Q;
    priv->rx_usb_queue	=	(PINTR_QUE)USB_RX_INT_Q;
    priv->tx_usb_queue	=	(PINTR_QUE)USB_TX_INT_Q;
    
    debug_var=(PDEBUG_VAR)DEBUG_VAR_ADDR;
    
    DmaRegInit((PMOON_DMA_REG)DMA_BASE);
    gBufIdx=0;
    memset((PDEBUG_VAR) DEBUG_VAR_ADDR,0,sizeof(DEBUG_VAR));
}

int Eth_Initialize()
{
    unsigned char* pTemp;
	PMOON_ETH_REG eth_reg=MoonObj.eth_reg;

    eth_reg->intr_mask  =0x3;
    eth_reg->intr_en    =0x3;

//  assign mac adddr..  
    pTemp=(unsigned char*)&eth_reg->smac_haddr;
    *(pTemp++)=Eth0_MACaddr[3];
    *(pTemp++)=Eth0_MACaddr[2];
    *(pTemp++)=Eth0_MACaddr[1];
    *(pTemp++)=Eth0_MACaddr[0];
    pTemp++;
    pTemp++;
    *(pTemp++)=Eth0_MACaddr[5];
    *pTemp=Eth0_MACaddr[4];


    eth_reg->dmac_haddr = 0xffffffff;   // DMACADDR[5:4]
    eth_reg->dmac_laddr = 0xffff0000;   // DMACADDR[3:0]
    
    if (ETH_FULL_DUPLEX) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x10;
    if (ETH_PROMISCUOUS) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x20;
    if (ETH_ACCEPT_GADDR) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x40;
    if (ETH_CFRAME_PASS) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x80;
    if (ETH_TXPAUSE_ENABLE) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x100;
    if (ETH_TXFCTRL_ENABLE) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x200;
    if (ETH_LIMIT_CLSN) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x400;
    if (ETH_CRCTR_MODE) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x800;
    if (ETH_STRST_ONREAD) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x2000;
    if (ETH_TX_ENABLE) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x1;
    if (ETH_RX_ENABLE) eth_reg->eth_cfg = eth_reg->eth_cfg | 0x2;
	return 0;
}

void DmaRegInit(PMOON_DMA_REG dma_reg)
{
	dma_reg->buf_size=(int)DATA_BUF_SIZE;
}


int Usb_Initialize()
{

	*(int*)0xc1000024=3;//interrupt mask	
	*(int*)0xc1000020=3;//interrupt en
//device descriptor
	*(int*)0xc1002200=0x02000112;
	*(int*)0xc1002204=0x40000002;
	*(int*)0xc1002208=0x50250b2a;
	*(int*)0xc100220c=0x00000100;
	*(int*)0xc1002210=0x00000100;
	
//configuration descriptor
	*(int*)0xc1002280=0x003c0209;
	*(int*)0xc1002284=0xe0000102;
	*(int*)0xc1002288=0x000409fa;
	*(int*)0xc100228c=0x07020100;
	*(int*)0xc1002290=0x240c0000;
	*(int*)0xc1002294=0x1f080010;
	*(int*)0xc1002298=0xffffffff;
	*(int*)0xc100229c=0x05070020;
	*(int*)0xc10022a0=0x02000381;
	*(int*)0xc10022a4=0x01040901;
	*(int*)0xc10022a8=0x000a0200;
	*(int*)0xc10022ac=0x05070000;
	*(int*)0xc10022b0=0x02000282;
	*(int*)0xc10022b4=0x03050701;
	*(int*)0xc10022b8=0x01020002;
//	
	return 0;
}

////////////////////////////////////////////////////////////////////
// main()
// called by boot.o which contains boot code provided by uHAL library
////////////////////////////////////////////////////////////////////
int main(int argc, int *argv[])
{
	

    GtxCtrlClk(32, 0xa05f);
	(void) uHALr_InitHeap();
		// Initailize Heap Before Calling uHALr_alloc(), uHALr_free()

	uHALir_DefineIRQ(0,0,0);
 	uHALr_InitInterrupts();
 	uHALir_NewIRQ(MOONISR,0);
 		// Always Call This uHAL function to use Interrupt

	if ( (uHALr_RequestInterrupt(MOON_INTR, (PrHandler)MOONISR, (const UCHAR*)"MOON ISR")) )	{
		uHALr_printf("Assigning High Level Handler to Interrupt Fail\n");
		return 0;
	}
	uHALir_EnableInt();

	
	Init_dd();

	
    uHALr_EnableInterrupt(MOON_IRQ_BIT);
    // MAC Initialize	
	Eth_Initialize();
	// USB Initialize
	Usb_Initialize();
	// Interrupt Enable 
	// ( [2] : memory allocation, [1] : USB, [0] : Ethernet )
	*(int*) 0xc3000008 = 7;
		
	Moon_PrintLogo();
	Moon_Prompt();
	
	return 0;	

}	// of main()




void Moon_Prompt()
{
	char buffer[130];
	char* pBuf=buffer;
	int RxNum;
////		
	
	while(1)
	{
		pBuf=buffer;
		uHALr_putchar('\n');
		uHALr_printf(MOON_PROMPT);
		RxNum=0;
		do
		{
			*pBuf=uHALr_getchar();
			if(*pBuf==0x0D)
			{
				*pBuf=NULL;
				break;
			}else 
			{
				pBuf++;
			}
			
		}while(++RxNum<128);
		
		
		if(RxNum==128)
		{
			uHALr_printf(" command error..\n");
			continue;
		}else if(RxNum==0) continue;
		
		
		if(strcmp(buffer,"?")==0 ||strcmp(buffer,"h")==0 )
		{
			uHALr_putchar('\n');           	
			uHALr_printf("? or h     : help \n");
			uHALr_printf("stat       : statistics report \n");
			uHALr_printf("statc      : statistics clear \n");
			uHALr_printf("read       : read internal register or memory \n");
			uHALr_printf("write      : write internal register or memory \n");
			uHALr_printf("---------------------------------------------------------------------------\n");
			uHALr_printf("Copyright Glotrex Co. LTD. All rights reserved. http://www.glotrex.co.kr\n");
			uHALr_printf("---------------------------------------------------------------------------\n");
		}
		else if(strcmp(buffer,"stat")==0)print_stat(FALSE);
		else if(strcmp(buffer,"statc")==0)print_stat(TRUE);
		else if(strcmp(buffer,"read")==0)read();
		else if(strcmp(buffer,"write")==0)write();
		else uHALr_printf("%s: command not found\n",buffer);
		
		
	}
}

void Moon_PrintLogo()
{
	uHALr_printf("\n\n\n\n\n\n");
	uHALr_printf("=======================================================\n");
	uHALr_printf("Welcome ! Glotrex Co, Ltd. August 2003\n");
	uHALr_printf(">>>> USB 2.0 MOON Demo System <<<<\n");
	uHALr_printf("   USB 2.0-Ethernet Bridge Demo\n");
	uHALr_printf("=======================================================\n\n\n");
}

void print_stat(int IsErase)
{

    if (IsErase==0)
    {
        uHALr_printf("**** Eth ****");
        uHALr_printf("\t\t\t**** USB ****\n");

        uHALr_printf("Send Packet   : 0x%x",debug_var->eth_tx_try);
        uHALr_printf("\t\tSend Packet   : 0x%x\n",debug_var->usb_tx_try);
        uHALr_printf("  send completely: 0x%x",debug_var->eth_tx_complete);
        uHALr_printf("\t\t  send completely: 0x%x\n",debug_var->usb_tx_complete);
        uHALr_printf("  tx frame Q Full: 0x%x",debug_var->eth_tx_frame_Q_full);
        uHALr_printf("\n");
        uHALr_printf("  busy bit set: 0x%x",debug_var->eth_tx_busy);
        uHALr_printf("\n");

        uHALr_printf("tx interrupt  : 0x%x",debug_var->eth_tx_int_occur);
        uHALr_printf("\t\ttx interrupt  : 0x%x\n",debug_var->usb_tx_int_occur);
        uHALr_printf("  ok               : 0x%x",debug_var->eth_tx_ok);
        uHALr_printf("\t  ok               : 0x%x\n",debug_var->usb_tx_ok);
        uHALr_printf("  late_collision   : 0x%x",debug_var->eth_tx_late_collision);
        uHALr_printf("\n");
        uHALr_printf("  excess_collision : 0x%x",debug_var->eth_tx_excess_collision);
        uHALr_printf("\n");
        uHALr_printf("  carrier_sense_err: 0x%x",debug_var->eth_tx_carrier_sense_err);
        uHALr_printf("\n");

        uHALr_printf("rx interrupt  : 0x%x",debug_var->eth_rx_int_occur);
        uHALr_printf("\t\trx interrupt  : 0x%x\n",debug_var->usb_rx_int_occur);
        uHALr_printf("  ok               : 0x%x",debug_var->eth_rx_ok);
        uHALr_printf("\t  ok               : 0x%x\n",debug_var->usb_rx_ok);
        uHALr_printf("  crc_error        : 0x%x",debug_var->eth_rx_crc_error);
        uHALr_printf("\n");
        uHALr_printf("  short_packet     : 0x%x",debug_var->eth_rx_short_packet);
        uHALr_printf("\n");
        uHALr_printf("  long_packet      : 0x%x",debug_var->eth_rx_long_packet);
        uHALr_printf("\n");

        uHALr_printf("rx_pause_frame: 0x%x",debug_var->eth_rx_pause_frame);
        uHALr_printf("\n");

        uHALr_printf("tx_pause_frame: 0x%x",debug_var->eth_tx_pause_frame);
        uHALr_printf("\n");

        uHALr_printf("mi_interrupt  : 0x%x",debug_var->eth_mi_interrupt);
        uHALr_printf("\n");

        uHALr_printf("phy_interrupt : 0x%x",debug_var->eth_phy_interrupt);
        uHALr_printf("\n");

        uHALr_printf("\n");

    }
    else 
    {
        uHALr_printf("clear all variables...\n");
        memset((PDEBUG_VAR) DEBUG_VAR_ADDR,0,sizeof(DEBUG_VAR));
    }
	
}


void read()
{
	char temp[64];
	char *pBuf;
	unsigned int address;
	unsigned int RxNum;
	
	pBuf=temp;
	RxNum=0;
  	uHALr_printf("address:");
  	
		do
		{
			*pBuf=uHALr_getchar();
			if(*pBuf==0x0D)
			{
				*pBuf=NULL;
				break;
			}else 
			{
				pBuf++;
			}
			
		}while(++RxNum<63);
	atoh(temp,&address);
	uHALr_printf("*(int*)0x%08x = 0x%08x\n",address,*(int*)address);
		
}

void write()
{
	char temp[64];
	char *pBuf;
	unsigned int address;
	unsigned int data;
	int RxNum;
	
	pBuf=temp;
	RxNum=0;
  	uHALr_printf("address:");
  	
		do
		{
			*pBuf=uHALr_getchar();
			if(*pBuf==0x0D)
			{
				*pBuf=NULL;
				break;
			}else 
			{
				pBuf++;
			}
			
		}while(++RxNum<63);
	atoh(temp,&address);
	
		pBuf=temp;
		RxNum=0;
  	uHALr_printf("data:");
  	
		do
		{
			*pBuf=uHALr_getchar();
			if(*pBuf==0x0D)
			{
				*pBuf=NULL;
				break;
			}else 
			{
				pBuf++;
			}
			
		}while(++RxNum<63);
	atoh(temp,&data);
	
	*(int*)address=data;
	uHALr_printf("*(int*)0x%08x = 0x%08x\n",address,*(int*)address);
		
}

int atoh(char * str, unsigned int* result)
{
	char * buf=str;
	char * p;
	int str_len,i;
	unsigned int src_addr=0;
	
	
	if(buf[1]=='x' || buf[1]=='X')
	{
		buf++;buf++;
	}
	str_len=uHALr_strlen(buf);
	if(str_len>8 ) return 1;
	
	p=buf;
	for(i=0;i<str_len-1;i++,p++)
	{
    	if(*p>='0' && *p<='9') src_addr+=*p-'0';
    	else if(*p>'a' && *p<'f') src_addr+=10+*p -'a';
    	else if(*p==' ')
    	{
			*result =src_addr;
    		return 0;
    	}
   	
		src_addr<<=4;
	}
	
	*result =src_addr;
	
	return 0;
}