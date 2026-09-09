/***************************************************************************/
/* This is a sample program to demonstrate the use of Easy Ethernet MAC    */
/* Copyright (c) 2006 - NikTec Inc. All Rights reserved			   */
/***************************************************************************/
#include <manik_system.h>
#include <stdio.h>

#define EEMAC_RESET_WPTR	1
#define EEMAC_RESET_MPTR	(1<<3)
#define EEMAC_START_XMIT	(1<<2)
#define EEMAC_READ_DONE		(1<<4)
#define EEMAC_RECV_ENB		(1<<1)
#define EEMAC_XMIT_BUSY		(1<<2)
#define EEMAC_RECV_IENB		(1<<5)
#define EEMAC_XMIT_IENB		(1<<6)
#define EEMAC_PROMISCUOUS	(1<<7)
#define EEMAC_RECV_DONE		(1<<8)
#define EEMAC_RECV_CRCERR	(1<<9)
#define EEMAC_RESET_COUNTER     (1<<10)

#define EEMAC_CTRL_REG		0
#define EEMAC_DATA_REG		1
#define EEMAC_MACADDR_REG	2
#define EEMAC_COUNTER_REG	4

#define eth_base (volatile unsigned int *)(EEMAC_BASE)

/*--------------------------------------------------------------*/
/* eth_get_status() - returns the status . the bits are     	*/
/* 		      BIT:0 - 0					*/
/* 		      BIT:1 - receive enabled			*/
/* 		      BIT:2 - transmit busy 			*/
/* 		      BIT:3 - 0		 			*/
/* 		      BIT:4 - 0		 			*/
/* 		      BIT:5 - receive interrupt enabled		*/
/* 		      BIT:6 - transmit interrupt enabled	*/
/* 		      BIT:7 - promiscuous mode enabled		*/
/* 		      BIT:8 - packet ready in receive buffer	*/
/*		      BIT:9 - CRC error valid only when BIT:8   */
/* 		      BIT:10-15 - 0  				*/
/*		      BIT:31-16 - receive packet length valid when BIT:8 */
/*--------------------------------------------------------------*/
unsigned int eth_get_status()
{
	unsigned int estat = *(eth_base+EEMAC_CTRL_REG);
	return estat;
}

/*--------------------------------------------------------------*/
/* eth_set_status() - set the ethernet status bits              */
/*--------------------------------------------------------------*/
void eth_set_status(unsigned int stat_bits)
{
	unsigned int prev;

	*(eth_base+EEMAC_CTRL_REG) |= stat_bits;
}

/*--------------------------------------------------------------*/
/* eth_clr_status() - clear bits in the status register         */
/*--------------------------------------------------------------*/
void eth_clr_status(unsigned int stat_bits)
{
	unsigned int prev;

	*(eth_base+EEMAC_CTRL_REG) &= ~stat_bits;
}

/*--------------------------------------------------------------*/
/* eth_get_len() - returns length of received packet		*/
/*--------------------------------------------------------------*/
int eth_get_len()
{
	return eth_get_status() >> 16;
}

/*--------------------------------------------------------------*/
/* eth_get_packet() - copies received packet from receive fifo  */
/*		      to an user supplied buffer		*/
/*--------------------------------------------------------------*/
void eth_get_packet(unsigned char *buff, int len)
{
	int i;

	for (i = 0; i < len ; i++) {
		int ch = *(eth_base+EEMAC_DATA_REG);
		*buff++ = ch;
	}
	eth_set_status(EEMAC_READ_DONE);
	return ;
}

/*--------------------------------------------------------------*/
/* eth_send_packet() - sends a packet, waits for xmit buffer to */
/*                     to become empty				*/
/*--------------------------------------------------------------*/
void eth_send_packet(unsigned char *buff, int len)
{
	int i;

	/* wait for xmit buffer to become empty */
	while (eth_get_status() & EEMAC_XMIT_BUSY);
	
	/* reset the write pointer */
	eth_set_status(EEMAC_RESET_WPTR);
	for (i = 0 ; i < len; i++ )
		*(eth_base+EEMAC_DATA_REG) = *buff++;

	/* start transmission */
	eth_set_status(EEMAC_START_XMIT);
}

/*--------------------------------------------------------------*/
/* eth_set_macaddr() - sets the mac address 			*/
/*--------------------------------------------------------------*/
void eth_set_macaddr( char *macaddr, int len)
{
	int i;
	
	eth_set_status(EEMAC_RESET_MPTR);
	
	/* needs to be reversed */
	for (i = len - 1; i >= 0; i++)
		*(eth_base+EEMAC_MACADDR_REG) = *(macaddr+i);
}

/*--------------------------------------------------------------*/
/* eth_get_macaddr() - gets the mac address 			*/
/*--------------------------------------------------------------*/
void eth_get_macaddr( char *macaddr, int len)
{
	int i;
	
	eth_set_status(EEMAC_RESET_MPTR);
	
	/* needs to be reversed */
	for (i = len - 1; i >= 0 ; i++)
		*(macaddr+i) = *(eth_base+EEMAC_MACADDR_REG);
}
/*--------------------------------------------------------------*/
/* eth_get_counter() - gets the counter 			*/
/*--------------------------------------------------------------*/
int eth_get_counter()
{
	return *(eth_base+EEMAC_COUNTER_REG);
}

/*--------------------------------------------------------------*/
/* eth_isr() - interrupt service routine called by crt0         */
/*--------------------------------------------------------------*/
void eth_isr(unsigned int *registers)
{
	eth_clr_status(EEMAC_RECV_IENB);
}

static void print_stat()
{
	unsigned int estat = eth_get_status();
	short elen = estat >> 16;
	
	estat &= 0x0000ffff;
	if (estat & EEMAC_RECV_ENB)    ser_put_str("Receive enabled\n\r");
	if (estat & EEMAC_XMIT_BUSY)   ser_put_str("Transmit in progress\n\r");
	if (estat & EEMAC_RECV_IENB)   ser_put_str("Receive interrupt enabled\n\r");
	if (estat & EEMAC_XMIT_IENB)   ser_put_str("Transmit interrupt enabled\n\r");
	if ((estat & (EEMAC_PROMISCUOUS|EEMAC_RECV_DONE)) == (EEMAC_PROMISCUOUS|EEMAC_RECV_DONE))
		ser_put_str("Promiscuous mode enabled\n\r");
	if (estat & EEMAC_RECV_DONE)   ser_put_str("Packet received\n\r");
	if (estat & EEMAC_RECV_CRCERR) ser_put_str("CRC Error detected\n\r");
}
