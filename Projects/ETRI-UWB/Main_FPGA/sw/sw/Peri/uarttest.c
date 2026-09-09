/*----------------------------------------------------------
	File Name   : i2s.c 
	Description : i2s Controller test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/
#include "sysinc.h"
#include "Commonmacro.h"
#include "uart.h"
#include "dmac.h"
#include "dma_mux.h"

void UARTTest(void)
{
	int i;
	int uart0_rx_dmach;
	unsigned char buffer[32];

	GPIOWrite(1);
	uart0_rx_dmach = DMAChannelAlloc(DMA_UART0RX);
	SMT_WRITE(DMACSAdr(uart0_rx_dmach), (unsigned)&UART0_RX);
	SMT_WRITE(DMACDAdr(uart0_rx_dmach), (unsigned)buffer);
	SMT_WRITE(DMACCon(uart0_rx_dmach), (unsigned) 0x00630020);
	SMT_WRITE(DMACDescrp(uart0_rx_dmach), 1);
	SMT_WRITE(DMACSta(uart0_rx_dmach), 0x8000000F);

	GPIOWrite(2);
	UartPuts("0123456789ABCDEFGHIJKLMNOPQRSTUV");

	GPIOWrite(3);
	while(1)
	{
		if(SMT_READ(DMACSta(uart0_rx_dmach)) & 0x00000009)
			break;
	}

	GPIOWrite(4);
	for(i = 0; i < 32; i++)
		GPIOWrite(buffer[i]);
	GPIOWrite(5);
}
