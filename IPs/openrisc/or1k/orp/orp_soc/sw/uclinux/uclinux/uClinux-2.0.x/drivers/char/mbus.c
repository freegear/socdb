/************************************************************************/
/*                                                                      */
/*  mbus.c - functions for the mbus driver                              */
/*                                                                      */
/*  (C) Copyright 1999, Martin Floeer (mfloeer@axcent.de)               */      /*                                                                      */
/*                                                                      */
/************************************************************************/
                                                                             



#ifndef __KERNEL__
#define __KERNEL__
#endif
#include <linux/kernel.h>
#include <linux/malloc.h>
#include <linux/fs.h>
#include <linux/errno.h>
#include <linux/types.h>
#include <linux/proc_fs.h>
#include <linux/fcntl.h>
#include <linux/sched.h>

#include <asm/coldfire.h>
#include <asm/types.h>
#include <asm/mcfsim.h>
#include <asm/mcfmbus.h>

#include <asm/system.h>
#include <asm/segment.h>

#include "mbus.h"



int mbus_major = MBUS_MAJOR;
int mbus_nr_devs = MBUS_NR_DEVS;

Mbus_Dev *mbus_devices;


volatile char *mbus_base=(char*) (MCF_MBAR + MCFMBUS_BASE); 


static unsigned char mbus_transfer_complete(void)
{
	if((*(mbus_base + MCFMBUS_MBSR) & MCFMBUS_MBSR_MCF) != 0) return(0x1);
	return(0x0);
}


static unsigned char mbus_idle(void)
{
	if((*(mbus_base + MCFMBUS_MBSR) & MCFMBUS_MBSR_MBB) == 0) return(0x1);
	return(0x0);
}

static unsigned char mbus_interrupt_pending(void)
{
	if((*(mbus_base + MCFMBUS_MBSR) & MCFMBUS_MBSR_MIF) != 0) return(0x1);
	return(0x0);
}


static void mbus_clear_interrupt(void)
{
	*(mbus_base + MCFMBUS_MBSR) = *(mbus_base + MCFMBUS_MBSR) & ~MCFMBUS_MBSR_MIF;
}	


static unsigned char mbus_arbitration_lost(void)
{
	if((*(mbus_base + MCFMBUS_MBSR) & MCFMBUS_MBSR_MAL) != 0) return(0x1);
	return(0x0);
}


static unsigned char mbus_received_acknowledge(void)
{
	if((*(mbus_base + MCFMBUS_MBSR) & MCFMBUS_MBSR_RXAK) == 0) return(0x1);
	return(0x0);
}


static void mbus_set_address(unsigned char address)
{
	*(mbus_base + MCFMBUS_MADR) = MCFMBUS_MADR_ADDR(address);
}


static void mbus_set_clock(unsigned char clock)
{
	*(mbus_base + MCFMBUS_MFDR) = clock;
}

static void mbus_set_direction(unsigned char state)
{
	if(state == 0x1) *(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) | MCFMBUS_MBCR_MTX;	/* transmit mode */
		else *(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) & ~MCFMBUS_MBCR_MTX;				/* transmit mode */
}


static void mbus_set_mode(unsigned char state)
{
	if(state == 0x1) *(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) | MCFMBUS_MBCR_MSTA;	/* master mode */
		else *(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) & ~MCFMBUS_MBCR_MSTA;				/* slave mode */
}


static void mbus_repeat_start(void)
{
	*(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) | MCFMBUS_MBCR_RSTA;	/* generate repeat start cycle */
}

static int mbus_error()
{
	if(mbus_arbitration_lost() == 0x1) return(-1);
	if(mbus_received_acknowledge() == 0x0) return (-2);
	return(0);
}

void mbus_interrupt(int irq, void *dev_id, struct pt_regs *regs)
{
	
	
	int error;
	
	mbus_clear_interrupt();

	error = mbus_error();
	if(error!=0) 
	{
		MBUS_STATE = error;
		mbus_set_mode(MBUS_SLAVE);					/* generate stop signal */
		return;
	}

	if(MBUS_MODE == 0x1)							/* which mbus mode*/
	{
						/*** transmit ***/
		if(MBUS_DATA_COUNT < 0)
		{

			*(mbus_base + MCFMBUS_MBDR) = MBUS_DEST_ADDRESS_BUFFER;	
			/* put destination address to mbus */
			MBUS_DATA_COUNT++;
		}
		else
		{
			if(MBUS_DATA_COUNT != MBUS_DATA_NUMBER)			/* last byte transmit ? */
			{


				*(mbus_base + MCFMBUS_MBDR) = *MBUS_DATA++;	/* put data to mbus *//* so funkt es */

				MBUS_DATA_COUNT++;
			}
			else
			{

				mbus_set_mode(MBUS_SLAVE);			/* generate stop signal */
				MBUS_STATE = MBUS_STATE_IDLE;
			}
		}
	}
	else
	{																/*** receive ***/
		if(MBUS_DATA_COUNT < 0)
		{
			if(MBUS_DATA_COUNT == -2)
			{
				*(mbus_base + MCFMBUS_MBDR) =
				MBUS_DEST_ADDRESS_BUFFER;	/* put
				destination address to mbus */
				MBUS_DATA_COUNT++;
			}
			else
			{
				mbus_set_direction(MBUS_RECEIVE);					/* receive mbus */
				*MBUS_DATA = *(mbus_base + MCFMBUS_MBDR);						/* dummy read from mbus */
				MBUS_DATA_COUNT++;
			}
		}
		else
		{
			if(MBUS_DATA_COUNT != MBUS_DATA_NUMBER)					/* last byte receive ? */
			{
				*MBUS_DATA++ = *(mbus_base + MCFMBUS_MBDR);					/* read data from mbus */
				MBUS_DATA_COUNT++;
			}
			else
			{
				mbus_set_mode(MBUS_SLAVE);							/* generate stop signal */
				MBUS_STATE = MBUS_STATE_IDLE;
			}

	
		}
	}
}
 
/* 
 * This function starts the transmission of one char  
 * 
 * Paramters: 
 *  slave_address1			7 bit Slave address (a7,a6,a5,a4,a3,a2,a1,X) 
 *  data_address			8 bit Slave destination data Address
 *  buf					source data buffer			
 * Returns: 
 *							None 
 */ 
void mbus_putchar(unsigned char slave_address, unsigned char data_address, char
*buf)
{
	while(mbus_idle() == 0x0);								/* wait for bus idle */
	MBUS_STATE = MBUS_STATE_BUSY;


	mbus_set_direction(MBUS_TRANSMIT);								/* transmit mbus */
	mbus_set_mode(MBUS_MASTER);
				
	MBUS_MODE = MBUS_TRANSMIT;
	MBUS_DATA_COUNT = -1;									/* INIT data counter */
	MBUS_DATA_NUMBER = 1;									/* INIT data number */
	MBUS_DEST_ADDRESS_BUFFER = data_address;
	MBUS_DATA = buf;

	*(mbus_base + MCFMBUS_MBDR) = slave_address & ~MCFMBUS_MBDR_READ;	/* send mbus_address and write access*/
}

/* 
 * This function starts the receiving of one char  
 * 
 * Paramters: 
 *  slave_address1			7 bit Slave address (a7,a6,a5,a4,a3,a2,a1,X) 
 *  data_address			8 bit Slave source data Address
 *  buf					destination data buffer
 * Returns: 
 *							None 
 */
void mbus_getchar(unsigned char slave_address, unsigned char data_address, char *buf)
{
	while(mbus_idle() == 0x0);					/* wait for bus idle */

	MBUS_STATE = MBUS_STATE_BUSY;

	mbus_set_direction(MBUS_TRANSMIT);				/* transmit mbus */
	mbus_set_mode(MBUS_MASTER);

	MBUS_MODE = MBUS_RECEIVE;
	MBUS_DATA_COUNT = -2;						/* INIT data counter */
	MBUS_DATA_NUMBER = 1;						/* INIT data number */
	MBUS_DEST_ADDRESS_BUFFER = data_address;
	MBUS_DATA = buf;

	*(mbus_base + MCFMBUS_MBDR) = slave_address & ~MCFMBUS_MBDR_READ;	/* send mbus_address and write access*/
}

/* 
 * This function starts the transmission of n char  
 * 
 * Paramters: 
 *  slave_address1			7 bit Slave address (a7,a6,a5,a4,a3,a2,a1,X) 
 *  dest_address			8 bit Slave destination data Address
 *  buf					source data buffer
 * Returns: 
 *							None 
 */
void mbus_putchars(unsigned char slave_address, unsigned char data_address, char *buf, int number)
{
	while(mbus_idle() == 0x0);					/* wait for bus idle */
	MBUS_STATE = MBUS_STATE_BUSY;

	mbus_set_direction(MBUS_TRANSMIT);								/* transmit mbus */
	mbus_set_mode(MBUS_MASTER);
	MBUS_MODE = MBUS_TRANSMIT;
	MBUS_DATA_COUNT = -1;												/* INIT data counter */
	MBUS_DATA_NUMBER = number;											/* INIT data number */
	MBUS_DEST_ADDRESS_BUFFER = data_address;
	MBUS_DATA = buf;
	*(mbus_base + MCFMBUS_MBDR) = slave_address & ~MCFMBUS_MBDR_READ;	/* send mbus_address and write access*/
	
}
 

unsigned char mbus_busy_event(void)
{
/*	unsigned char state;
	

	if(MBUS_STATE == MBUS_STATE_BUSY) state = 0x1;
		else state= 0x0;

	return(state);*/

	if(MBUS_STATE == MBUS_STATE_BUSY) return 0x1;
	
	return 0x0;
}



int mbus_open (struct inode * inode, struct file *filp)
{

	int minor = MINOR(inode->i_rdev);
	Mbus_Dev *dev; 
	if (minor >= mbus_nr_devs) {
			return -ENODEV;
			printk("Error: no such device \n");
			}
	
		
	dev = &mbus_devices[minor];
	dev->name="mbus";	
	/*Initialisierung mbus*/
	
	mbus_set_clock(MCFMBUS_CLK);

	mbus_set_address(MCFMBUS_ADDRESS);

	*(mbus_base + MCFMBUS_MBCR) = MCFMBUS_MBCR_MEN ;	/* first enable M-BUS	*/
							/* Interrupt disable	*/
							/* set to Slave mode	*/
							/* set to receive mode	*/
							/* with acknowledge	*/
	if (request_irq(MCFMBUS_IRQ_VECTOR, mbus_interrupt, 0, dev->name, NULL)) printk(" kein Interrupt\n");
	*(volatile unsigned char*)(MCF_MBAR + MCFSIM_ICR3) = MCFMBUS_IRQ_LEVEL | MCFSIM_ICR_AUTOVEC;	/* set MBUS IRQ-Level and autovector */
	mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_MBUS);   
	*(mbus_base + MCFMBUS_MBCR) = *(mbus_base + MCFMBUS_MBCR) | MCFMBUS_MBCR_MIEN ;		/* Interrupt enable*/
	
	/*Ender Initialisierung mbus*/
	
	return 0;
}

mbus_release(struct inode * inode, struct file *filp)
{
*(volatile unsigned char*)(MCF_MBAR + MCFSIM_ICR3)= 0x0;
mcf_setimr(mcf_getimr()  | MCFSIM_IMR_MBUS);
free_irq(MCFMBUS_IRQ_VECTOR, NULL);
}
/*
* Using the read function:	first Byte of buf slave address
*				second Byte of buf dest address
*				following Bytes read buffer
*/
			
read_write_t mbus_read (struct inode *inode, struct file *filp, char *buf,
count_t count)
{
	
	Mbus_Dev *dev= filp->private_data;
	char address=*buf++, dest_address=*buf++;
	if (count> 3) 	{
			printk(KERN_ERR "nur ein Zeichen Lesen\n");
			return -1;
			}
	dev->usage++;
	
	mbus_getchar(address, dest_address, buf);
	
	dev->usage--;
	return 0;
}

/*
* Using the write function:      	first Byte of buf slave address
*                               	second Byte of buf dest address
*                               	following Bytes  write buffer
*/ 
                                                                    	
read_write_t mbus_write (struct inode *inode, struct file *filp, char *buf,
count_t count)
{
	Mbus_Dev *dev= filp->private_data;
	
	char address=*buf++, dest_address=*buf++;
	count = count -2;
	
	dev->usage++;
	
	mbus_putchars(address, dest_address, buf, count);
	
	dev->usage--;
	return 0;
}
	

struct file_operations mbus_fops =
{
NULL,
mbus_read,
mbus_write,
NULL,
NULL,
NULL,
NULL,
mbus_open,
mbus_release,

};

int mbus_init(void)
{
	int result, i;
	result = register_chrdev(mbus_major, "mbus",  &mbus_fops);
	
	if (result<0) 
		{
		printk("keine Major\n");
		}

	
	mbus_devices = kmalloc(mbus_nr_devs * sizeof(Mbus_Dev), GFP_KERNEL);
	
	if (!mbus_devices)
		{
		result = -ENOMEM;
		goto fail_malloc;
		}

	
	return 0;

	fail_malloc: 	unregister_chrdev(mbus_major, "mbus");
			return result;
			
}
