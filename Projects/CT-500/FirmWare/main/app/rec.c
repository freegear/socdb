#include <string.h>
#include "sysinc.h"
#include "Commonmacro.h"
#include "gpio.h"
#include "uart.h"
//#include "dmac.h"
#include "dma_mux.h"
#include "rec.h"
#include "irq.h"


//#include "libdma.h"

void ReadRec(void);


static smtUint32 idxRxRecData = 0;
static smtUint32 idxTxRecData = 0;

typedef struct _RecStatus
{
	smtInt32 recSize;
	smtInt8 des_cnt;
} RecStatus;

#define DMA_DAT_LOOP_SIZE		4	//32
static smtUint8 rec_rx_dmach, rec_tx_dmach;
static RecStatus recStatus;
unsigned int bFirst = 0;

void Old_WriteRecTest(smtBoolean interruptFlag);
void Orgin_WriteRec(smtBoolean start, smtBoolean end);
void New_WriteRecTest(smtBoolean interruptFlag);
void New_ReadRec(void);
void Orgin_ReadRecord(smtUint32 recFileSize);


void CheckPCMRXStatus(void)
{
	smtUint32 readData = 0;

	readData = (SMT_READ(SEIP_RXSTS) & 0x00000070)>>4;
	
	if( readData != 0 )
	{
		;//smt2UARTPrint(CFG_UART_CH,"PCM Rx FIFO DATA : %d\n", readData);
	} else
	{
		;//smt2UARTPrint(CFG_UART_CH,"PCM Rx FIFO has no Data\n");
	}
}

void CheckPCMTXStatus(void)
{
	smtUint32 readData = 0;

	readData = (SMT_READ(SEIP_TXSTS) & 0x00000070)>>4;
	
	if( readData != 0 )
	{
		;//smt2UARTPrint(CFG_UART_CH,"PCM Tx FIFO DATA : %d\n", readData);
	} else
	{
		;//smt2UARTPrint(CFG_UART_CH,"PCM Tx FIFO has no Data\n");
	}	
}
void SEIP_DMA_RX_Enable(void)
{
	// Check whether SEIP is ready 
	do
	{
		if( (SMT_READ(SEIP_RST) &0x00000080) == 0x00000080 )
			break;
	} while(1);

	
	//SEIP RX DMA Control Init
	smt2UARTPrint(CFG_UART_CH,"SEIP DMA RX Init.....\n");
	SMT_WRITE(SEIP_RXCON, 
				(1<<31)		// Reset PCM RX DMA
				| (1<<30)	// Reset RCM RX DMA FIFO
				| (0x6<<4)	// DMA Request Fill Level 
				| (0<<2)		// Disable fail interrupt
				| (0<<1)		// Disable fifo interrupt
				| (1)		// PCM RX DMA Enable
	);
	
}

void SEIP_DMA_TX_Enable(void)
{
	// Check whether SEIP is ready 
	do
	{
		if( (SMT_READ(SEIP_RST) &0x00000080) == 0x00000080 )
			break;
	} while(1);
	
	//SEIP TX DMA Control Init
	smt2UARTPrint(CFG_UART_CH,"SEIP DMA TX Init.....\n");
	SMT_WRITE(SEIP_TXCON, 
				(1<<31)		// Reset PCM RX DMA
				| (1<<30)	// Reset RCM RX DMA FIFO
				| (0x7<<4)	// DMA Request Fill Level 
				| (0<<2)		// Disable fail interrupt
				| (0<<1)		// Disable fifo interrupt
				| (1)		// PCM TX DMA Enable
	);	
}



volatile smtUint32 REC_InterruptFlag  = 0;
volatile smtUint32 REC_InterruptValue = 0;

static smtUint8 IRQ_DMAX[]= 
{
	IRQ_DMA0,
	IRQ_DMA1,
	IRQ_DMA2,
	IRQ_DMA3,
	IRQ_DMA4,
	IRQ_DMA5,
	IRQ_DMA6,
	IRQ_DMA7
};

void New_RECDMAHandler(smtUint32 irq)
{
	int IntCount = 0;
	REC_InterruptFlag = SMT_TRUE;
	REC_InterruptValue = SMT_READ(DMACSta(rec_rx_dmach));

	if(REC_InterruptValue&(1<<3))
	{
		IntCount++;
		SMT_WRITE(DMACSta(rec_rx_dmach),0x0000000F); 
		return;
	}
	
	SMT_WRITE(DMACSta(rec_rx_dmach),REC_InterruptValue|0x0000000F); 
}

void RECDMAHandler(smtUint32 irq)
{	
	int IntCount = 0;
	REC_InterruptFlag = SMT_TRUE;
	REC_InterruptValue = SMT_READ(DMACSta(irq));

	if(REC_InterruptValue&(1<<3))
	{
		IntCount++;
		SMT_WRITE(DMACSta(irq),0x0000000F); 
		return;
	}
	
	SMT_WRITE(DMACSta(irq),REC_InterruptValue|0x0000000F); 
}

smtUint32 descBuffer[DMA_DAT_LOOP_SIZE*4];

void New_WriteRec(smtBoolean start, smtBoolean end, smtBoolean stop)
{
	unsigned i;
	unsigned loopback_start_addr = AUDIO_TESTADDR;	
	
	EdmaStruct edma[DMA_DAT_LOOP_SIZE];
	//smtUint32 descBuffer[DMA_DAT_LOOP_SIZE*4];
	
	for(i=0;i<(DMA_DAT_LOOP_SIZE*4);i++)
		descBuffer[i] = 0;
#if 0
	// Clear Data
	for(i = 0; i < 0x8000*DMA_DAT_LOOP_SIZE; i++)
		*(((unsigned *)loopback_start_addr)+i) = 0;
#endif	

	memset((void*)loopback_start_addr,0x0,(0x45000*DMA_DAT_LOOP_SIZE));
	// Transfer Data : 4M
	for(i = 0; i < DMA_DAT_LOOP_SIZE; i++)	
	{
		edma[i].src = (unsigned)(&SEIP_TXDAT);
		edma[i].srcInc = DMA_ADDR_NOINC;
		edma[i].srcWidth = DMA_BUSWIDTH32;

		edma[i].dst = loopback_start_addr + 0x45000*i;
		edma[i].dstInc = DMA_ADDR_INC;
		edma[i].dstWidth = DMA_BUSWIDTH32;

		edma[i].startIntEn = start;
		edma[i].endIntEn = end;
		edma[i].stopIntEn = stop;	

		edma[i].totSize = 0x45000;
		edma[i].transSize = DMA_TRANSSIZE8;

		edma[i].enM2M	= 0x0;

		edma[i].descListBase = (smtUint32)descBuffer;
	}
	
	smt2EDMAChAsign(DMA_CHALLOC, DMA_SEIPTX, &rec_rx_dmach);
	smt2UARTPrint(CFG_UART_CH,"RX channel = %d\n",rec_rx_dmach);

	//SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009);

	smtEDMAUseDescrp(rec_rx_dmach, DMA_DAT_LOOP_SIZE, edma);	
}

void New_WriteRecTest(smtBoolean interruptFlag)
{
	int i;
	int count;
	smtInt32 oldrecSize = 0;
	unsigned loopback_start_addr = AUDIO_TESTADDR;
	smtUint32 reg;

	smtBoolean interrupt, stop, start, end;

	REC_InterruptFlag = SMT_FALSE;

	if(interruptFlag==SMT_TRUE)
	{
		interrupt = SMT_TRUE;
		stop	  = SMT_TRUE;
		start	  = SMT_TRUE;
		end		  = SMT_FALSE;
	}
	else
	{
		interrupt = SMT_FALSE;
		stop	  = SMT_FALSE;
		start	  = SMT_FALSE;
		end		  = SMT_FALSE;
	}
	
	
	//SEIP_DMA_RX_Enable();
	SEIP_DMA_TX_Enable();

	New_WriteRec(start, end, stop);
	
	memset((void*)&recStatus,0,sizeof(RecStatus));
	//SMT_WRITE(DMACDAdr(rec_rx_dmach),loopback_start_addr); 	

	if(interrupt==SMT_TRUE)
	{
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(IRQ_DMAX[rec_rx_dmach], New_RECDMAHandler);
		Enable_IRQ();

		while(1)
		{
			if(REC_InterruptFlag==SMT_TRUE)
			{
				REC_InterruptFlag = SMT_FALSE;

				if(REC_InterruptValue & 0x0)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Error\n");
				}

				if(REC_InterruptValue & 0x2)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] End\n");
				}

				if(REC_InterruptValue & 0x4)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Start\n");
				}
				
				if(REC_InterruptValue & 0x08)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Stop\n");
					
					break;
				}
			}
		}

		smtEDMAGetTransLength(rec_rx_dmach, AUDIO_TESTADDR, &recStatus.recSize);

		smt2EDMAChAsign(DMA_CHDALLOC, DMA_SEIPTX, &rec_rx_dmach);

		smt2DMADisable(rec_rx_dmach);  
		
		ReleaseIRQ(rec_rx_dmach);

		return;
	}

	
	while(1)
	{
		char uart_input;
		count = 100000;
	
#if 1
		// [1] in case recording space is full...
		//if(smt2DMAGetStatus(rec_rx_dmach)==DMA_STOPINT)
		if(DMACSta(rec_rx_dmach) & 0x00000009)
		{
			smtEDMAGetTransLength(rec_rx_dmach, AUDIO_TESTADDR, &recStatus.recSize); 
			smt2DMADisable(rec_rx_dmach);
			smt2EDMAChAsign(DMA_CHDALLOC, DMA_SEIPTX, &rec_rx_dmach);
 			break;
		}
#endif

		if((i%100) == 0)
		{
			//smt2UARTPrint(CFG_UART_CH,"Write Size : %08x\n", 0x80000 -(DMACCon(rec_rx_dmach)&0xfffff));
			smt2UARTPrint(CFG_UART_CH,"Des Addr : %08x\n", (DMACDAdr(rec_rx_dmach)));		
			CheckPCMRXStatus();
			CheckPCMTXStatus();
		}
	
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);
		i++;
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

			// [2] in case recording is stopped by user event...			
			if(uart_input == '0')
			{
				// calculate the transfered data size
				{
					smtInt8 j;

					smtEDMAGetTransLength(rec_rx_dmach, AUDIO_TESTADDR, &recStatus.recSize);  
					smt2UARTPrint(CFG_UART_CH,"record Size = %08x\n",recStatus.recSize);
					SMT_WRITE(DMACDAdr(rec_rx_dmach),loopback_start_addr); 						
				}

 				smt2EDMAChAsign(DMA_CHDALLOC, DMA_SEIPTX, &rec_rx_dmach);
				smt2DMADisable(rec_rx_dmach);				
				//SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 
				break;
			}
		}
		i &= 0xfffff;
		while(count--);
	}
}



void New_ReadRecTest(void)
{
	int i;
	int count;
	smtUint32 reg;
	smtInt32 oldreadSize = 0,readSize = 0;
	unsigned loopback_start_addr = AUDIO_TESTADDR;
	
	SEIP_DMA_RX_Enable();
	//SEIP_DMA_TX_Enable();

	New_ReadRec();
	
	i = 0;
	recStatus.des_cnt = 0;
	
	while(1)
	{
		char uart_input;
		count = 100000;
		
		// [1] in case recording space is full...
		/*
		if(DMACSta(rec_tx_dmach) & 0x00000009)
		{
			smt2DMADisable(rec_tx_dmach);
			break;
		}
		*/
		reg = DMACSta(rec_tx_dmach);

		if(reg&0x02)
		{
			smt2UARTPrint(CFG_UART_CH, "EndInterrupt\n");
		}
		if(reg&0x04)
		{
			smt2UARTPrint(CFG_UART_CH, "StartInterrupt\n");
		}
		if(reg&0x08)
		{
			smt2UARTPrint(CFG_UART_CH, "StopInterrupt\n");
			smt2DMADisable(rec_tx_dmach);
			break;			
		}


		if((i%100) == 0)
		{	
			smt2UARTPrint(CFG_UART_CH,"Src Addr: %08x\n", DMACSAdr(rec_tx_dmach));
			//smt2UARTPrint(CFG_UART_CH,"Read Size : %08x\n", 0x80000 - (DMACCon(rec_tx_dmach)&0xfffff));			
			CheckPCMRXStatus();
			CheckPCMTXStatus();
		}
		i++;
	
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

			// [2] in case recording is stopped by user event...
			if(uart_input == '0')
			{
				smt2DMADisable(rec_tx_dmach);	
				break;			
			}

		}
		i &= 0xfffff;
		while(count--);
	}	

	return;
}



void New_ReadRec(void)
{
	int i;
	unsigned loopback_start_addr = AUDIO_TESTADDR;
	smtInt32	tailRecSize = 0;
	EdmaStruct edma[DMA_DAT_LOOP_SIZE];
	smtUint32 ret;
	
	recStatus.des_cnt = recStatus.recSize / 0x80000;
	tailRecSize = recStatus.recSize - (0x80000*recStatus.des_cnt);
	smt2UARTPrint(CFG_UART_CH,"des cnt: %08x\n", recStatus.des_cnt);

	for(i=0;i<(DMA_DAT_LOOP_SIZE*4);i++)
		descBuffer[i] = 0;

	//recStatus.des_cnt = recStatus.des_cnt + 1;
	for(i = 0; i < recStatus.des_cnt; i++)	
	{
		edma[i].src 		= (unsigned)loopback_start_addr + 0x80000*i;		
		edma[i].srcInc 		= DMA_ADDR_INC;
		edma[i].srcWidth 	= DMA_BUSWIDTH32;

		edma[i].dst 		= (unsigned)(&SEIP_RXDAT);
		edma[i].dstInc 		= DMA_ADDR_NOINC;
		edma[i].dstWidth 	= DMA_BUSWIDTH32;

		edma[i].transSize 	= DMA_TRANSSIZE8;
		edma[i].totSize 	= 0x80000;
		
		edma[i].startIntEn 	= SMT_FALSE;
		edma[i].stopIntEn 	= SMT_TRUE;
		edma[i].endIntEn 	= SMT_FALSE;

		edma[i].enM2M		= SMT_FALSE;
		
		edma[i].descListBase = (smtUint32)descBuffer;
		smt2UARTPrint(CFG_UART_CH,"Desc Addr : %08x\n",edma[i].src);				
	}

	memcpy((void*)&edma[i],(void*)&edma[i-1],sizeof(edma[i-1]));
	edma[i].totSize 	= tailRecSize;
	edma[i].src 		= (unsigned)loopback_start_addr + 0x80000*i;

	smt2EDMAChAsign(DMA_CHALLOC, DMA_SEIPRX, &rec_tx_dmach);
	//rec_rx_dmach = DMAChannelAlloc(DMA_SEIPTX);
	smt2UARTPrint(CFG_UART_CH,"RX channel = %d\n",rec_tx_dmach);

	ret = smt2DMADisable(rec_tx_dmach);
	
	if(ret)
	{
		smt2UARTPrint(CFG_UART_CH,"disable EDMA error\n");
	}
	
	smtEDMAUseDescrp(rec_tx_dmach, recStatus.des_cnt + 1, edma);	
}



////////////////////////////////////////////////////////////////////////////
struct dma_desc
{
	unsigned src_addr;
	unsigned dest_addr;
	unsigned control;
	unsigned desc_addr;
};

static struct dma_desc tx_start_dma_desc;

static struct dma_desc tx_dma_desc_loop[DMA_DAT_LOOP_SIZE];
static struct dma_desc rx_dma_desc_loop[DMA_DAT_LOOP_SIZE];


void Orgin_ReadRecord(smtUint32 recFileSize)
{
	int i;
	unsigned loopback_start_addr = AUDIO_TESTADDR;
	smtInt32	tailRecSize = 0;
	
	recStatus.des_cnt = recStatus.recSize / 0x80000;
	tailRecSize = recStatus.recSize - (0x80000*recStatus.des_cnt);
	smt2UARTPrint(CFG_UART_CH,"des cnt: %08x\n", recStatus.des_cnt);
	for(i=0; i < recStatus.des_cnt; i++)
	{
		tx_dma_desc_loop[i].src_addr = loopback_start_addr + 0x80000*i;
		smt2UARTPrint(CFG_UART_CH,"Desc Addr : %08x\n",tx_dma_desc_loop[i].src_addr);
		tx_dma_desc_loop[i].dest_addr = (unsigned)(&SEIP_RXDAT);
		tx_dma_desc_loop[i].control = 0x80000 |	// Transfer Length 64KB
									( 0 << 31 ) |	// Mask Start Interrupt
									( 0 << 30 ) |	// Mask End Interrupt
									( 0 << 29 ) | //  Operated by DMA Request
									( 1 << 28 ) |	// Source Address Increment
									( 2 << 26 ) |	// Source Device 16 bit Bus Width
									( 0 << 25 ) |  // Destination Address No increase
									( 2 << 23 ) |	// Destination Device 16 bit Bus Width
									( 3 << 20 );	// Each DMA Transfer size 32 byte
		tx_dma_desc_loop[i].desc_addr = (unsigned)&tx_dma_desc_loop[i+1];		
	}
	 // tailing description 
	tx_dma_desc_loop[recStatus.des_cnt].src_addr = loopback_start_addr + 0x80000*recStatus.des_cnt;
	smt2UARTPrint(CFG_UART_CH,"Desc Addr : %08x\n",tx_dma_desc_loop[recStatus.des_cnt].src_addr);	 
	tx_dma_desc_loop[recStatus.des_cnt].dest_addr = (unsigned)(&SEIP_RXDAT);
	tx_dma_desc_loop[recStatus.des_cnt].control = tailRecSize |	// Transfer Length 64KB
								( 0 << 31 ) |	// Mask Start Interrupt
								( 0 << 30 ) |	// Mask End Interrupt
								( 0 << 29 ) | //  Operated by DMA Request
								( 1 << 28 ) |	// Source Address Increment
								( 2 << 26 ) |	// Source Device 16 bit Bus Width
								( 0 << 25 ) |  // Destination Address No increase
								( 2 << 23 ) |	// Destination Device 16 bit Bus Width
								( 3 << 20 );	// Each DMA Transfer size 32 byte
	tx_dma_desc_loop[recStatus.des_cnt].desc_addr = 1;	

	rec_tx_dmach = DMAChannelAlloc(DMA_SEIPRX);
	smt2UARTPrint(CFG_UART_CH,"TX channel = %d\n",rec_tx_dmach);	
	SMT_WRITE(DMACSta(rec_tx_dmach),0x00000009); 
	DMACUseDescrp(rec_tx_dmach, (unsigned)(&tx_dma_desc_loop[0]));	
	return;
}



void Old_ReadRecTest(void)
{
	int i;
	int count;
	smtInt32 oldreadSize = 0,readSize = 0;
	unsigned loopback_start_addr = AUDIO_TESTADDR;
	
	SEIP_DMA_RX_Enable();
	//SEIP_DMA_TX_Enable();

	Orgin_ReadRecord(recStatus.recSize);
	SMT_WRITE(DMACSAdr(rec_tx_dmach),loopback_start_addr);
	
	i = 0;
	recStatus.des_cnt = 0;
	
	while(1)
	{
		char uart_input;
		count = 100000;
		
		// [1] in case recording space is full...
		if(DMACSta(rec_tx_dmach) & 0x00000009)
		{
			DMACDisable(rec_tx_dmach);
			SMT_WRITE(DMACSta(rec_tx_dmach),0x00000009);
			SMT_WRITE(DMACSAdr(rec_tx_dmach),loopback_start_addr);			
			DMAChannelFree(rec_tx_dmach);
			break;
		}

		if((i%100) == 0)
		{	
			smt2UARTPrint(CFG_UART_CH,"Src Addr: %08x\n", DMACSAdr(rec_tx_dmach));
			//smt2UARTPrint(CFG_UART_CH,"Read Size : %08x\n", 0x80000 - (DMACCon(rec_tx_dmach)&0xfffff));			
			CheckPCMRXStatus();
			CheckPCMTXStatus();
		}
		i++;
	
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

			// [2] in case recording is stopped by user event...
			if(uart_input == '0')
			{
				DMAChannelFree(rec_tx_dmach);
				DMACDisable(rec_tx_dmach);	
				SMT_WRITE(DMACSta(rec_tx_dmach),0x00000009); 
				SMT_WRITE(DMACSAdr(rec_tx_dmach),loopback_start_addr);				
				break;			
			}

		}
		i &= 0xfffff;
		while(count--);
	}	

	return;
}

void Orgin_WriteRec(smtBoolean start, smtBoolean end)
{
	unsigned i;
	unsigned loopback_start_addr = AUDIO_TESTADDR;	

	// Clear Data
	for(i = 0; i < 0x8000*DMA_DAT_LOOP_SIZE; i++)
		*(((unsigned *)loopback_start_addr)+i) = 0;

	// Transfer Data : 4M
	for(i = 0; i < DMA_DAT_LOOP_SIZE; i++)	
	{
		rx_dma_desc_loop[i].src_addr = (unsigned)(&SEIP_TXDAT);
		rx_dma_desc_loop[i].dest_addr = loopback_start_addr + 0x10000*i;

		rx_dma_desc_loop[i].control =  0x10000 |	// Transfer Length 64KB
									( start << 31 ) |	// Mask Start Interrupt
									( end << 30 ) |	// Mask End Interrupt
									( 0 << 29 ) | 	//  Operated by DMA Request
									( 0 << 28 ) |	// Source Address Increment
									( 2 << 26 ) |	// Source Device 16 bit Bus Width
									( 1 << 25 ) |  // Destination Address increase
									( 2 << 23 ) |	// Destination Device 16 bit Bus Width
									( 3 << 20 );	// Each DMA Transfer size 32 byte


		if(i != (DMA_DAT_LOOP_SIZE-1))
			rx_dma_desc_loop[i].desc_addr = (unsigned)&rx_dma_desc_loop[i+1];
	}
	rx_dma_desc_loop[(DMA_DAT_LOOP_SIZE-1)].desc_addr = 1;

	rec_rx_dmach = DMAChannelAlloc(DMA_SEIPTX);
	smt2UARTPrint(CFG_UART_CH,"RX channel = %d\n",rec_rx_dmach);
	SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 

	DMACUseDescrp(rec_rx_dmach, (unsigned)(&rx_dma_desc_loop));	
}

void Old_WriteRecTest(smtBoolean interruptFlag)
{
	int i;
	int count;
	smtUint32 reg;
	smtInt32 oldrecSize = 0;
	unsigned loopback_start_addr = AUDIO_TESTADDR;

	smtBoolean interrupt, stop, start, end;

	REC_InterruptFlag = SMT_FALSE;

	if(interruptFlag==SMT_TRUE)
	{
		interrupt = SMT_TRUE;
		stop	  = SMT_TRUE;
		start	  = SMT_TRUE;
		end		  = SMT_FALSE;
	}
	else
	{
		interrupt = SMT_FALSE;
		stop	  = SMT_FALSE;
		start	  = SMT_FALSE;
		end		  = SMT_FALSE;
	}
	
	//SEIP_DMA_RX_Enable();
	SEIP_DMA_TX_Enable();

	Orgin_WriteRec(start, end);
	
	memset((void*)&recStatus,0,sizeof(RecStatus));
	SMT_WRITE(DMACDAdr(rec_rx_dmach),loopback_start_addr); 	

	if(interrupt==SMT_TRUE)
	{
		Disable_IRQ();
		EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
		RequestIRQ(rec_rx_dmach, RECDMAHandler);
		Enable_IRQ();

		while(1)
		{
			if(REC_InterruptFlag==SMT_TRUE)
			{
				REC_InterruptFlag = SMT_FALSE;

				if(REC_InterruptValue & 0x0)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Error\n");
				}

				if(REC_InterruptValue & 0x2)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] End\n");
				}

				if(REC_InterruptValue & 0x4)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Start\n");
				}
				
				if(REC_InterruptValue & 0x08)
				{
					smt2UARTPrint(CFG_UART_CH,"[INT] Stop\n");
					
					break;
				}
			}
		}

		recStatus.recSize = ((DMACDAdr(rec_rx_dmach)) - AUDIO_TESTADDR);
		SMT_WRITE(DMACDAdr(rec_rx_dmach),loopback_start_addr); 

		DMAChannelFree(rec_rx_dmach);
		DMACDisable(rec_rx_dmach);				
		SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 
		
		ReleaseIRQ(rec_rx_dmach);

		return;
	}

	
	while(1)
	{
		char uart_input;
		count = 100000;

#if 1	
		// [1] in case recording space is full...
		if(DMACSta(rec_rx_dmach) & 0x00000009)
		{
			DMACDisable(rec_rx_dmach);
			SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 
			DMAChannelFree(rec_rx_dmach);
			break;
		}
#else
		reg = DMACSta(rec_tx_dmach);

		if(reg & 0x00000009)
			smt2UARTPrint(CFG_UART_CH, "DMACSta(rec_tx_dmach) = 0x%08X\n, reg");

		if(reg&0x02)
		{
			smt2UARTPrint(CFG_UART_CH, "EndInterrupt\n");
		}
		if(reg&0x04)
		{
			smt2UARTPrint(CFG_UART_CH, "StartInterrupt\n");
		}
		if(reg&0x08)
		{
			DMACDisable(rec_rx_dmach);
			SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 
			DMAChannelFree(rec_rx_dmach);
			break;
		}

#endif
		if((i%100) == 0)
		{
			//smt2UARTPrint(CFG_UART_CH,"Write Size : %08x\n", 0x80000 -(DMACCon(rec_rx_dmach)&0xfffff));
			smt2UARTPrint(CFG_UART_CH,"Des Addr : %08x\n", (DMACDAdr(rec_rx_dmach)));		
			CheckPCMRXStatus();
			CheckPCMTXStatus();
		}
	
		//GPIOWrite(i);
		SMT_WRITE(GPIO0_OUT, i);
		i++;
		smt2UARTDataValid(CFG_UART_CH, &uart_input);
		if(uart_input)
		{
			smt2UARTGetCh(CFG_UART_CH, &uart_input, 0);

			// [2] in case recording is stopped by user event...			
			if(uart_input == '0')
			{
				// calculate the transfered data size
				{
					smtInt8 j;

					recStatus.recSize = ((DMACDAdr(rec_rx_dmach)) - AUDIO_TESTADDR);
					smt2UARTPrint(CFG_UART_CH,"record Size = %08x\n",recStatus.recSize);
					SMT_WRITE(DMACDAdr(rec_rx_dmach),loopback_start_addr); 						
				}
				
				DMAChannelFree(rec_rx_dmach);
				DMACDisable(rec_rx_dmach);				
				SMT_WRITE(DMACSta(rec_rx_dmach),0x00000009); 
				break;
			}
		}
		i &= 0xfffff;
		
		while(count--);
	}

	smt2UARTPrint(CFG_UART_CH,"count = %08x\n",count);

	return;
}


