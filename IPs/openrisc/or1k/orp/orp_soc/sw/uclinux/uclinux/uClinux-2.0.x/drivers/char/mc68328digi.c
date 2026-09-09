/* mc68328digi.c
 *
 * Linux driver to make the PalmPilot's touchpad behave
 * like a PS/2 mouse.
 *
 * My apologies, this is currently a complete mess. It'll notice taps
 * on Copilot and a real Pilot, but can't figure out the coordinates on the Pilot.
 *
 * Based on touchpad driver.
 * Copyright (C) 1998  Kenneth Albanowski <kjahds@kjahds.com>,
 *                     The Silver Hammer Group, Ltd.
 *
 * Original History
 * -------
 *	0.0 1997-05-16 Alan Cox <alan@cymru.net> - Pad reader
 *	0.1 1997-05-19 Robin O'Leary <robin@acm.org> - PS/2 emulation
 *	0.2 1997-06-03 Robin O'Leary <robin@acm.org> - tap gesture
 *	0.3 1997-07-10 Robin O'Leary <robin@acm.org> - sticky drag
 *
 * Distribution
 * ------------
 * Copyright (C) 1997-06-18 Robin O'Leary <robin@acm.org>  All rights reserved.
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * Get the latest version from ftp://swan.ml.org/pub/pc110/
 */

#include <linux/config.h>
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/kernel.h>
#include <linux/busmouse.h>
#include <linux/signal.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/miscdevice.h>
#include <linux/ptrace.h>
#include <linux/ioport.h>
#include <linux/interrupt.h>

#include <asm/signal.h>
#include <asm/io.h>
#include <asm/irq.h>

#include "mc68328digi.h"


static struct mc68328digi_params default_params = {
	MC68328DIGI_PS2,	/* read mode */
	50 MS,		/* bounce interval */
	800 MS,		/* sticky-drag */
	300 MS,		/* tap interval */
	10,		/* IRQ */
	0x15E0,		/* I/O port */
	0, 		/* Not calibrated */
	1<<16,	0,	/* X calibration values (unity) */
	1<<16,	0	/* Y calibration values (unity) */
};


static struct mc68328digi_params current_params;


/* driver/filesystem interface management */
static struct wait_queue *queue;
static struct fasync_struct *asyncptr;
static int active=0;	/* number of concurrent open()s */


/*
 * Utility to reset a timer to go off some time in the future.
 */
static void set_timer_callback(struct timer_list *timer, int ticks)
{
	cli();
	del_timer(timer);
	timer->expires = jiffies+ticks;
	add_timer(timer);
	sti();
}


/* Take care of letting any waiting processes know that
 * now would be a good time to do a read().  Called
 * whenever a state transition occurs, real or synthetic.
 */
static void wake_readers(void)
{
	wake_up_interruptible(&queue);
	if(asyncptr)
		kill_fasync(asyncptr, SIGIO);
}


/*****************************************************************************/
/*
 * Deal with the messy business of synthesizing button tap and drag
 * events.
 *
 * Exports:
 *	notify_digi_up_down()
 *		Must be called whenever debounced pad up/down state changes.
 *	button_pending
 *		Flag is set whenever read_button() has new values
 *		to return.
 *	read_button()
 *		Obtains the current synthetic mouse button state.
 */

/* These keep track of up/down transitions needed to generate the
 * synthetic mouse button events.  While recent_transition is set,
 * up/down events cause transition_count to increment.  tap_timer
 * turns off the recent_transition flag and may cause some synthetic
 * up/down mouse events to be created by incrementing synthesize_tap.
 */
static int button_pending=0;
static int recent_transition=0;
static int transition_count=0;
static int synthesize_tap=0;
static void tap_timeout(unsigned long data);
static struct timer_list tap_timer = { NULL, NULL, 0, 0, tap_timeout };


/* This callback goes off a short time after an up/down transition;
 * before it goes off, transitions will be considered part of a
 * single PS/2 event and counted in transition_count.  Once the
 * timeout occurs the recent_transition flag is cleared and
 * any synthetic mouse up/down events are generated.
 */
static void tap_timeout(unsigned long data)
{
	printk("tap_timeout\n");
	if(!recent_transition)
	{
		printk("mc68328digi: tap_timeout but no recent transition!\n");
	}
	if( (transition_count==2)
	 || (transition_count==4)
	 || (transition_count==6) )
	{
		synthesize_tap+=transition_count;
		button_pending = 1;
		wake_readers();
	}
	recent_transition=0;
}


static void read_button(int *b)
{
	if(synthesize_tap)
	{
		*b=--synthesize_tap & 1;
	}
	else
	{
		*b=(!recent_transition && transition_count==3);	/* drag */
	}
	button_pending=(synthesize_tap>0);
}



/*****************************************************************************/
/*
 * Read pad absolute co-ordinates and debounced up/down state.
 *
 * Exports:
 *	pad_irq()
 *		Function to be called whenever the pad signals
 *		that it has new data available.
 *	read_raw_digi()
 *		Returns the most current pad state.
 *	xy_pending
 *		Flag is set whenever read_raw_digi() has new values
 *		to return.
 * Imports:
 *	wake_readers()
 *		Called when movement occurs.
 *	notify_digi_up_down()
 *		Called when debounced up/down status changes.
 */

/* These are up/down state and absolute co-ords read directly from pad */
static int raw_data[3];
static int raw_data_count=0;
static int raw_x=0, raw_y=0;	/* most recent absolute co-ords read */
static int raw_down=0;		/* raw up/down state */
static int debounced_down=0;	/* up/down state after debounce processing */
static int is_new_stroke=0;	/* set when xy are discontinuous */
static enum {
	NO_BOUNCE, JUST_GONE_UP, JUST_GONE_DOWN, STICKY_DRAG_UP
} bounce=NO_BOUNCE;
				/* set just after an up/down transition */
static int xy_pending=0;	/* set if new data have not yet been read */

/* Timer goes off a short while after an up/down transition and copies
 * the value of raw_down to debounced_down.
 */
static void bounce_timeout(unsigned long data);
static struct timer_list bounce_timer = { NULL, NULL, 0, 0, bounce_timeout };


/* Called by the raw pad read routines when a (debounced) up/down
 * transition is detected.
 */
void notify_digi_up_down(void)
{
	if(recent_transition)
	{
		transition_count++;
	}
	else
	{
		transition_count=1;
		recent_transition=1;
	}
	set_timer_callback(&tap_timer, current_params.tap_interval);

	/* changes to transition_count can cause reported button to change */
	button_pending = 1;
	is_new_stroke=1;
	wake_readers();
}



static void bounce_timeout(unsigned long data)
{
	/* No further up/down transitions happened within the
	 * bounce period, so treat this as a genuine transition.
	 */
	switch(bounce)
	{
		case NO_BOUNCE:
		{
			/* Strange; the timer callback should only go off if
			 * we were expecting to do bounce processing!
			 */
			printk("mc68328digi, bounce_timeout: bounce flag not set!\n");
			break;
		}
		case JUST_GONE_UP:
		case STICKY_DRAG_UP:
		{
			/* The last up we spotted really was an up, so set
			 * debounced state the same as raw state.
			 */
			bounce=NO_BOUNCE;
			if(debounced_down==raw_down)
			{
				printk("mc68328digi, bounce_timeout: raw already debounced!\n");
			}
			debounced_down=raw_down;
			notify_digi_up_down();
			break;
		}
		case JUST_GONE_DOWN:
		{
			/* We don't debounce down events, but we still time
			 * out soon after one occurs so we can avoid the (x,y)
			 * skittering that sometimes happens.
			 */
			bounce=NO_BOUNCE;
			break;
		}
	}
}

static void handle_raw(int new_x, int new_y, int new_down);

static void release_timeout(void);
static struct timer_list release_timer = { NULL, NULL, 0, 0, release_timeout };
static void release_timeout(void)
{
	(*((volatile unsigned long*)0xFFFFF304)) |= (1<<20); 
	
	handle_raw(raw_x, raw_y, 0);
	
	(*((volatile unsigned long*)0xFFFFF304)) &= ~(1<<20);   /* Enable interrupt */
}


/*
 * Callback when pad's irq goes off; copies values in to raw_* globals;
 * initiates debounce processing.
 */
void digi_interrupt(int irq, void *ptr, struct pt_regs *regs)
{
	unsigned long flags;
	int new_x, new_y, new_down;
	volatile int i;

/*	set_timer_callback(&release_timer, 1);*/
	
	save_flags(flags); cli();

#define PORTF_DIR (*(volatile unsigned char*)0xFFFFF428)
#define PORTF_DAT (*(volatile unsigned char*)0xFFFFF429)
#define PORTF_PUP (*(volatile unsigned char*)0xFFFFF42A)
#define PORTF_SEL (*(volatile unsigned char*)0xFFFFF42B)

#define PORTM_DIR (*(volatile unsigned char*)0xFFFFF448)
#define PORTM_DAT (*(volatile unsigned char*)0xFFFFF449)
#define PORTM_PUP (*(volatile unsigned char*)0xFFFFF44A)
#define PORTM_SEL (*(volatile unsigned char*)0xFFFFF44B)

#define SPIMCONT (*(volatile unsigned short*)0xFFFFF802)
#define SPIMDATA (*(volatile unsigned short*)0xFFFFF800)


#define SPIMCONT_IRQEN	0x40
#define SPIMCONT_IRQ	0x80
#define SPIMCONT_XCH	0x100
#define SPIMCONT_EN	0x200

#define PF_DigiYVOff	0x01
#define PF_DigiYGOn	0x02
#define PF_DigiXVOff	0x04
#define PF_DigiXGOn	0x08
#define PF_LCDEnable	0x10
#define PF_LCDVccOff	0x20
#define PF_LCDVeeOn	0x40
#define PF_ADSelect	0x80

#define PF_DigiMask	0x0f
#define PF_DigiOff	(PF_DigiYVOff|PF_DigiXVOff)
#define PF_DigiTap	(PF_DigiXGOn|PF_DigiYVOff|PF_DigiXVOff)
#define PF_DigiGetY	(PF_DigiXGOn|PF_DigiYVOff)
#define PF_DigiGetX	(PF_DigiXVOff|PF_DigiYGOn)

#define PM_VCCFAIL	0x04
#define PM_DOCKBUTTON	0x20
#define PM_PENIO	0x40
#define PM_DOCKIN	0x80


#if 0
	PORTM_PUP &= ~PM_PENIO;
	PORTM_SEL |= PM_PENIO;
	
	PORTF_DAT = (PORTF_DAT & ~PF_DigiMask) | PF_DigiOff;
	PORTF_DAT = (PORTF_DAT & ~PF_DigiMask) | PF_DigiGetY;
	
	
	SPIMCONT = 0x427f;
	SPIMDATA = 0xc000;
	
	PORTF_DAT &= ~PF_ADSelect;

	/* Tell SPIM to sequence */
	SPIMCONT &= ~SPIMCONT_XCH;
	SPIMCONT |= SPIMCONT_XCH;

	/* Wait till sample is retrieved */
	while (!(SPIMCONT & SPIMCONT_IRQ))
		;
	new_y = SPIMDATA;
	
	PORTF_DAT |= PF_ADSelect;

	SPIMCONT &= ~SPIMCONT_EN;

	PORTF_DAT = (PORTF_DAT & ~PF_DigiMask) | PF_DigiOff;
	PORTF_DAT = (PORTF_DAT & ~PF_DigiMask) | PF_DigiGetX;

	SPIMCONT = 0x427F;
	SPIMDATA = 0xffff;
	
	PORTF_DAT &= ~PF_ADSelect;

	/* Tell SPIM to sequence */
	SPIMCONT &= ~SPIMCONT_XCH;
	SPIMCONT |= SPIMCONT_XCH;

	/* Wait till sample is retrieved */
	while (!(SPIMCONT & SPIMCONT_IRQ))
		;
	new_x = SPIMDATA;
	
	PORTF_DAT |= PF_ADSelect;
	
	SPIMCONT &= ~SPIMCONT_EN;

	PORTF_DAT = (PORTF_DAT & PF_DigiMask) | PF_DigiOff;
	PORTF_DAT = (PORTF_DAT & PF_DigiMask) | PF_DigiTap;
	
	PORTM_PUP |= PM_PENIO;
	PORTM_SEL &= ~PM_PENIO;
#endif


#if 1
	

#define PFDATA (*((volatile unsigned char*)0xFFFFF429))	

#if 0
	(*(volatile unsigned char*)0xFFFFF44A) &= ~64; /* Switch off Port M Pen IRQ pullup */
	(*(volatile unsigned char*)0xFFFFF44B) |= 64;  /* Turn on Port M Pen IRQ select */
#endif
	(*(volatile unsigned char*)0xFFFFF44A) = 0xad; /* Switch off Port M Pen IRQ pullup */
	(*(volatile unsigned char*)0xFFFFF44B) = 0xd0;  /* Turn on Port M Pen IRQ select */
	
#if 0
	(*(volatile unsigned char*)0xFFFFF429) = 0xD5;    /* Set PFDATA to D5, Turn off digi power */ 
#endif
	PFDATA = (PFDATA & 0xf0) | 5;
	(*(volatile unsigned char*)0xFFFFF429) = 0xD9;    /* Set PFDATA to D9, Measure Y */
	(*(volatile unsigned short*)0xFFFFF802) = 0x427f; /* Set SPIMCONT to 427f */
	(*(volatile unsigned short*)0xFFFFF800) = 0xc000; /* Set SPIMDATA to c000, Preload data*/
#if 0
	(*((volatile unsigned char*)0xFFFFF439)) &= ~2;    /* Enable A/D */
#endif
	PFDATA &= ~0x80;
#if 0
	(*((volatile unsigned char*)0xFFFFF429)) = 0x59;    /* Set PFDATA to 59, Measure Y, A/D select HW2  */
#endif	
	(*((volatile unsigned short*)0xFFFFF802)) &= ~0x0100; /* Set SPIMCONT to 427f */
	(*((volatile unsigned short*)0xFFFFF802)) |= 0x0100; /* Set SPIMCONT to 437f */
	
	while(!((*((volatile unsigned short*)0xFFFFF802)) & 0x80))
		;

	new_y = (*((volatile unsigned short*)0xFFFFF800)); /* Read SPIMDATA */
	
	PFDATA |= 0x80;
#if 0
	(*(volatile unsigned char*)0xFFFFF429) = 0xD9;    /* Set PFDATA to D9 */
#endif
#if 0
	(*((volatile unsigned char*)0xFFFFF439)) |= 2;    /* Disable A/D */
#endif
	(*(volatile unsigned short*)0xFFFFF802) = 0x407f;/* Set SPIMCONT to 407f */
	
	(*(volatile unsigned char*)0xFFFFF429) = 0xD5;    /* Set PFDATA to D5 */
	(*(volatile unsigned char*)0xFFFFF429) = 0xD6;    /* Set PFDATA to D6 */
	(*(volatile unsigned short*)0xFFFFF802) = 0x427f;/* Set SPIMCONT to 427f */
	(*(volatile unsigned short*)0xFFFFF800) = 0xffff; /* Set SPIMDATA to ffff */

	PFDATA &= ~0x80;
#if 0
	(*((volatile unsigned char*)0xFFFFF429)) = 0x56;    /* Set PFDATA to 56 */
#endif
#if 0
	(*((volatile unsigned char*)0xFFFFF439)) &= ~2;    /* Enable A/D */
#endif
	(*(volatile unsigned short*)0xFFFFF802) = 0x427f;/* Set SPIMCONT to 427f */
	(*((volatile unsigned short*)0xFFFFF802)) = 0x437f; /* Set SPIMCONT to 437f */

	while(!((*((volatile unsigned short*)0xFFFFF802)) & 0x80)) 
		;

	new_x = (*((volatile unsigned short*)0xFFFFF800)); /* Read SPIMDATA */

	PFDATA |= 0x80;
#if 0
	(*(volatile unsigned char*)0xFFFFF429) = 0xD6;    /* Set PFDATA to d6 */
#endif
#if 0
	(*((volatile unsigned char*)0xFFFFF439)) |= 2;    /* Disable A/D */
#endif
	(*(volatile unsigned short*)0xFFFFF802) = 0x407f;/* Set SPIMCONT to 407f */

	(*(volatile unsigned char*)0xFFFFF429) = 0xD5;    /* Set PFDATA to d5 */
	(*(volatile unsigned char*)0xFFFFF429) = 0xDD;    /* Set PFDATA to dd */
	
#if 0
	(*(volatile unsigned char*)0xFFFFF44A) |= 64; /* Turn on Port M Pen IRQ pullup */
	(*(volatile unsigned char*)0xFFFFF44B) &= ~64;  /* Switch off Port M Pen IRQ select */
#endif
	(*(volatile unsigned char*)0xFFFFF44A) = 0xed; /* Switch off Port M Pen IRQ pullup */
	(*(volatile unsigned char*)0xFFFFF44B) = 0x90;  /* Turn on Port M Pen IRQ select */
	
	
#if 0	
	new_x = ((long)new_x * current_params.x_a + current_params.x_b) >> 16;
	new_y = ((long)new_y * current_params.y_a + current_params.y_b) >> 16;

	/*printk("calibrated x=%d, y=%d\n", new_x, new_y);*/
	
	handle_raw(new_x, new_y, 1);
#endif

#endif

	printk("raw x=%d, y=%d\n", new_x, new_y);

	restore_flags(flags);



}

void handle_raw(int new_x, int new_y, int new_down) {

	/*printk("Pen: %x,%x %x\n", new_x, new_y, new_down);*/

	if( (raw_x!=new_x) || (raw_y!=new_y) )
	{
		raw_x=new_x;
		raw_y=new_y;
		xy_pending=1;
	}

	if(new_down != raw_down)
	{
		/* Down state has changed.  raw_down always holds
		 * the most recently observed state.
		 */
		raw_down=new_down;

		/* Forget any earlier bounce processing */
		if(bounce)
		{
			del_timer(&bounce_timer);
			bounce=NO_BOUNCE;
		}

		if(new_down)
		{
			if(debounced_down)
			{
				/* pad gone down, but we were reporting
				 * it down anyway because we suspected
				 * (correctly) that the last up was just
				 * a bounce
				 */
				is_new_stroke=1;
			}
			else
			{
				bounce=JUST_GONE_DOWN;
				set_timer_callback(&bounce_timer,
					current_params.bounce_interval);
				/* start new stroke/tap */
				debounced_down=new_down;
				notify_digi_up_down();
			}
		}
		else /* just gone up */
		{
			if(recent_transition)
			{
				/* early bounces are probably part of
				 * a multi-tap gesture, so process
				 * immediately
				 */
				debounced_down=new_down;
				notify_digi_up_down();
			}
			else if(transition_count==3)
			{
				/* give chance to move */
				bounce=STICKY_DRAG_UP;
				set_timer_callback(&bounce_timer,
					current_params.sticky_drag);
			}
			else
			{
				/* don't trust it yet */
				bounce=JUST_GONE_UP;
				set_timer_callback(&bounce_timer,
					current_params.bounce_interval);
			}
		}
	}
	/*printk("Bounce=%d, x=%d, y=%d, new_stroke=%d, debounced_down=%d\n",
		bounce, raw_x, raw_y, is_new_stroke, debounced_down);*/

	wake_readers();


#if 0	

	/* Obtain byte from pad and prime for next byte */
	{
		int value=inb_p(current_params.io);
		int handshake=inb_p(current_params.io+2);
		outb_p(handshake | 1, current_params.io+2);
		outb_p(handshake &~1, current_params.io+2);
		inb_p(0x64);

		raw_data[raw_data_count++]=value;
	}

	if(raw_data_count==3)
	{
		/* The pad provides triples of data. The first byte has
		 * 0x80=bit 8 X, 0x01=bit 7 X, 0x08=bit 8 Y, 0x01=still down
		 * The second byte is bits 0-6 X
		 * The third is bits 0-6 Y
		 */
		int new_down=raw_data[0]&0x01;
		int new_x=raw_data[1];
		int new_y=raw_data[2];
		if(raw_data[0]&0x10) new_x+=128;
		if(raw_data[0]&0x80) new_x+=256;
		if(raw_data[0]&0x08) new_y+=128;

		if( (raw_x!=new_x) || (raw_y!=new_y) )
		{
			raw_x=new_x;
			raw_y=new_y;
			xy_pending=1;
		}

		if(new_down != raw_down)
		{
			/* Down state has changed.  raw_down always holds
			 * the most recently observed state.
			 */
			raw_down=new_down;

			/* Forget any earlier bounce processing */
			if(bounce)
			{
				del_timer(&bounce_timer);
				bounce=NO_BOUNCE;
			}

			if(new_down)
			{
				if(debounced_down)
				{
					/* pad gone down, but we were reporting
					 * it down anyway because we suspected
					 * (correctly) that the last up was just
					 * a bounce
					 */
					is_new_stroke=1;
				}
				else
				{
					bounce=JUST_GONE_DOWN;
					set_timer_callback(&bounce_timer,
						current_params.bounce_interval);
					/* start new stroke/tap */
					debounced_down=new_down;
					notify_digi_up_down();
				}
			}
			else /* just gone up */
			{
				if(recent_transition)
				{
					/* early bounces are probably part of
					 * a multi-tap gesture, so process
					 * immediately
					 */
					debounced_down=new_down;
					notify_digi_up_down();
				}
				else if(transition_count==3)
				{
					/* give chance to move */
					bounce=STICKY_DRAG_UP;
					set_timer_callback(&bounce_timer,
						current_params.sticky_drag);
				}
				else
				{
					/* don't trust it yet */
					bounce=JUST_GONE_UP;
					set_timer_callback(&bounce_timer,
						current_params.bounce_interval);
				}
			}
		}
		wake_readers();
		raw_data_count=0;
	}
#endif
}


static void read_raw_digi(int *down, int *debounced, int *stroke, int *x, int *y)
{

	/*disable_irq(current_params.irq);*/
	(*((volatile unsigned long*)0xFFFFF304)) |= (1<<20);   /* Enable interrupt */
	{
		*down=raw_down;
		*debounced=debounced_down;
		*stroke=is_new_stroke;
		*x=raw_x;
		*y=raw_y;
		xy_pending = 0;
		is_new_stroke = 0;
	}
	(*((volatile unsigned long*)0xFFFFF304)) &= ~(1<<20);   /* Enable interrupt */
	/*enable_irq(current_params.irq);*/
}

/*****************************************************************************/
/*
 * Filesystem interface
 */

/* Read returns byte triples, so we need to keep track of
 * how much of a triple has been read.  This is shared across
 * all processes which have this device open---not that anything
 * will make much sense in that case.
 */
static int read_bytes[3];
static int read_byte_count=0;


static void sample_rare(int d[3])
{
	int thisd, thisdd, thiss, thisx, thisy;

	read_raw_digi(&thisd, &thisdd, &thiss, &thisx, &thisy);

	d[0]=(thisd?0x80:0)
	   | (thisx/256)<<4
	   | (thisdd?0x08:0)
	   | (thisy/256)
	;
	d[1]=thisx%256;
	d[2]=thisy%256;
}


static void sample_debug(int d[3])
{
	int thisd, thisdd, thiss, thisx, thisy;
	int b;
	cli();
	read_raw_digi(&thisd, &thisdd, &thiss, &thisx, &thisy);
	d[0]=(thisd?0x80:0) | (thisdd?0x40:0) | (thiss?0x20:0) | bounce;
	d[1]=(recent_transition?0x80:0)+transition_count;
	read_button(&b);
	d[2]=(synthesize_tap<<4) | (b?0x01:0);
	sti();
}


static void sample_ps2(int d[3])
{
	static int lastx, lasty;

	int thisd, thisdd, thiss, thisx, thisy;
	int dx, dy, b;

	/*
	 * Obtain the current mouse parameters and limit as appropriate for
	 * the return data format.  Interrupts are only disabled while 
	 * obtaining the parameters, NOT during the puts_fs_byte() calls,
	 * so paging in put_user() does not affect mouse tracking.
	 */
	read_raw_digi(&thisd, &thisdd, &thiss, &thisx, &thisy);
	read_button(&b);

	/* Now compare with previous readings. */
	if( thiss /* new stroke */
	 || (bounce!=NO_BOUNCE) )
	{
		dx=0;
		dy=0;
	}
	else
	{
		dx = (thisx-lastx);
		dy = -(thisy-lasty);
	}
	lastx=thisx;
	lasty=thisy;

	d[0]= ((dy<0)?0x20:0)
	    | ((dx<0)?0x10:0)
	    | (b? 0x00:0x08)
	;
	d[1]=dx;
	d[2]=dy;
}



static int fasync_digi(struct inode *inode, struct file *filp, int on)
{
	int retval;

	retval = fasync_helper(inode, filp, on, &asyncptr);
	if (retval < 0)
		return retval;
	return 0;
}


/*
 * close access to the pad
 */
static void close_digi(struct inode * inode, struct file * file)
{
	fasync_digi(inode, file, 0);
	if (--active)
		return;

	(*((volatile unsigned long*)0xFFFFF304)) |= (1<<20);   /* Enable interrupt */
#if 0
	outb(0x30, current_params.io+2);	/* switch off digitiser */
#endif
	MOD_DEC_USE_COUNT;
}


/*
 * open access to the pad
 */
static int open_digi(struct inode * inode, struct file * file)
{
	if (active++)
		return 0;
	MOD_INC_USE_COUNT;

#if 0
	cli();
	outb(0x30, current_params.io+2);	/* switch off digitiser */
	pad_irq(0,0,0);		/* read to flush any pending bytes */
	pad_irq(0,0,0);		/* read to flush any pending bytes */
	pad_irq(0,0,0);		/* read to flush any pending bytes */
	outb(0x38, current_params.io+2);	/* switch on digitiser */
	current_params = default_params;
	raw_data_count=0;		/* re-sync input byte counter */
	read_byte_count=0;		/* re-sync output byte counter */
	button_pending=0;
	recent_transition=0;
	transition_count=0;
	synthesize_tap=0;
	del_timer(&bounce_timer);
	del_timer(&tap_timer);
	sti();
#endif

	cli();
	current_params = default_params;
	raw_data_count=0;		/* re-sync input byte counter */
	read_byte_count=0;		/* re-sync output byte counter */
	button_pending=0;
	recent_transition=0;
	transition_count=0;
	synthesize_tap=0;
	del_timer(&bounce_timer);
	del_timer(&tap_timer);
	sti();

	return 0;
}


/*
 * writes are disallowed
 */
static int write_digi(struct inode * inode, struct file * file, const char * buffer, int count)
{
	return -EINVAL;
}


void new_sample(int d[3])
{
	switch(current_params.mode)
	{
		case MC68328DIGI_RARE:	sample_rare(d);		break;
		case MC68328DIGI_DEBUG:	sample_debug(d);	break;
		case MC68328DIGI_PS2:	sample_ps2(d);		break;
	}
}


/*
 * Read pad data.  Currently never blocks.
 */
static int read_digi(struct inode * inode, struct file * file, char * buffer, int count)
{
	int r;

	if ((r = verify_area(VERIFY_WRITE, buffer, count)))
		return r;

	for(r=0; r<count; r++)
	{
		if(!read_byte_count)
			new_sample(read_bytes);
		put_user(read_bytes[read_byte_count], buffer+r);
		read_byte_count = (read_byte_count+1)%3;
	}
	return r;
}


/*
 * select for pad input
 */
static int pad_select(struct inode *inode, struct file *file, int sel_type, select_table * wait)
{
	if(sel_type == SEL_IN) {
	    	if(button_pending || xy_pending)
			return 1;
		select_wait(&queue, wait);
    	}
	return 0;
}


static int pad_ioctl(struct inode *inode, struct file * file,
	unsigned int cmd, unsigned long arg)
{
	int i;
	struct mc68328digi_params new;

	if (!inode)
		return -EINVAL;
		
	switch (cmd) {
	case MC68328DIGIIOCGETP:
		printk("pad_ioctl: get %d\n",current_params.mode);
		i = verify_area(VERIFY_WRITE, (void *)arg, sizeof(new));
		if(i) return i;
		new = current_params;
		memcpy_tofs((void *)arg, &new, sizeof(new));
		return 0;

	case MC68328DIGIIOCSETP:
		printk("pad_ioctl: set, was %d",current_params.mode);
		i = verify_area(VERIFY_READ, (void *)arg, sizeof(new));
		if (i) return i;
		memcpy_fromfs(&new, (void *)arg, sizeof(new));

		if( (new.mode<MC68328DIGI_RARE)
		 || (new.mode>MC68328DIGI_PS2)
		 || (new.bounce_interval<0)
		 || (new.sticky_drag<0)
		 || (new.tap_interval<0)
		)
			return -EINVAL;

		current_params.mode	= new.mode;
		current_params.bounce_interval	= new.bounce_interval;
		current_params.sticky_drag	= new.sticky_drag;
		current_params.tap_interval	= new.tap_interval;
		printk("now %d\n",current_params.mode);
		return 0;
	}
	return -ENOIOCTLCMD;
}


static struct file_operations pad_fops = {
	NULL,		/* pad_seek */
	read_digi,
	write_digi,
	NULL, 		/* pad_readdir */
	pad_select,
	pad_ioctl,
	NULL,		/* pad_mmap */
	open_digi,
	close_digi,
	NULL,
	fasync_digi,
};


static struct miscdevice mc68328_digi = {
	MC68328DIGI_MINOR, "mc68328 digitizer", &pad_fops
};


int mc68328digi_init(void)
{
	current_params = default_params;
	raw_data_count=0;		/* re-sync input byte counter */
	read_byte_count=0;		/* re-sync output byte counter */
	button_pending=0;
	recent_transition=0;
	transition_count=0;
	synthesize_tap=0;
	del_timer(&bounce_timer);
	del_timer(&tap_timer);


	/*if(request_irq(current_params.irq, pad_irq, 0, "mc68328digi", 0))
	{
		printk("mc68328digi: Unable to get IRQ.\n");
		return -EBUSY;
	}
	if(check_region(current_params.io, 4))
	{
		printk("mc68328digi: I/O area in use.\n");
		free_irq(current_params.irq,0);
		return -EBUSY;
	}
	request_region(current_params.io, 4, "mc68328digi");
	printk("PC110 digitizer pad at 0x%X, irq %d.\n",
		current_params.io,current_params.irq);*/

	if (request_irq(IRQ_MACHSPEC | PEN_IRQ_NUM,
	    		digi_interrupt,
	    		IRQ_FLG_STD,
            		"M68328 Digitizer", NULL))
		panic("Unable to attach 68328 digitizer interrupt\n");

	printk("MC68328 digitizer.\n");
	misc_register(&mc68328_digi);

	(*(volatile unsigned char*)0xFFFFF42B) = 0xFF; /*Setting PFSEL byte to ff*/
	(*(volatile unsigned char*)0xFFFFF428) = 0xFF; /*Setting PFDIR byte to ff*/
	(*(volatile unsigned char*)0xFFFFF42A) = 0x00; /*Setting PFPUEN byte to 0*/

	(*(volatile unsigned char*)0xFFFFF429) = 0xc5; /*Setting PFDATA byte to c5*/
	(*(volatile unsigned char*)0xFFFFF429) = 0xd5; /*Setting PFDATA byte to d5*/
	(*(volatile unsigned char*)0xFFFFF448) = 0x50; /*Setting PMDIR byte to 50*/
	(*(volatile unsigned char*)0xFFFFF449) = 0x00; /*Setting PMDATA byte to 0*/
	(*(volatile unsigned char*)0xFFFFF44B) = 0xd0; /*Setting PMSEL byte to d0*/
	(*(volatile unsigned char*)0xFFFFF429) = 0xd5; /*Setting PFDATA byte to d5*/
#if 0
	(*(volatile unsigned char*)0xFFFFF431) = 0x60; /*Setting PGDATA byte to 60*/
#endif
	(*(volatile unsigned short*)0xFFFFF802) = 0x427f; /*Setting SPIMCONT word to 427f*/
	(*(volatile unsigned short*)0xFFFFF800) = 0xffff; /*Setting SPIMDATA word to ffff*/
	(*(volatile unsigned char*)0xFFFFF429) = 0x55; /*Setting PFDATA byte to 55*/
	(*(volatile unsigned short*)0xFFFFF802) = 0x427f; /*Setting SPIMCONT word to 427f*/
	(*(volatile unsigned short*)0xFFFFF802) = 0x437f; /*Setting SPIMCONT word to 437f*/
	(void)(*(volatile unsigned short*)0xFFFFF800); /*Returning word from SPIMDATA ffff*/
	(*(volatile unsigned char*)0xFFFFF429) = 0xd5; /*Setting PFDATA byte to d5*/
	(*(volatile unsigned short*)0xFFFFF802) = 0x407f; /*Setting SPIMCONT word to 407f*/
#if 0
	(*(volatile unsigned char*)0xFFFFF431) = 0x70; /*Setting PGDATA byte to 70*/
#endif
	(*(volatile unsigned char*)0xFFFFF448) = 0x50; /*Setting PMDIR byte to 50*/
	(*(volatile unsigned char*)0xFFFFF449) = 0x00; /*Setting PMDATA byte to 0*/
	(*(volatile unsigned char*)0xFFFFF44A) = 0xED; /* Port M Pullups (dangerous?) */
	(*(volatile unsigned char*)0xFFFFF44B) = 0xd0; /*Setting PMSEL byte to d0*/
	(*(volatile unsigned char*)0xFFFFF429) = 0xd5; /*Setting PFDATA byte to d5*/
	(*(volatile unsigned char*)0xFFFFF429) = 0xdd; /*Setting PFDATA byte to dd*/

	
	(*((volatile unsigned long*)0xFFFFF304)) &= ~(1<<20);   /* Enable interrupt */
	(*(volatile unsigned char*)0xFFFFF44A) |= 64; /* Turn on Port M Pen IRQ pullup */
	(*(volatile unsigned char*)0xFFFFF44B) &= ~64;  /* Switch off Port M Pen IRQ select */
	
	/*outb(0x30, current_params.io+2);*/	/* switch off digitiser */
	
	return 0;
}


static void mc68328digi_unload(void)
{
#if 0
	outb(0x30, current_params.io+2);	/* switch off digitiser */
#endif
	/*if(current_params.irq)
		free_irq(current_params.irq, 0);
	current_params.irq=0;
	release_region(current_params.io, 4);*/
	misc_deregister(&mc68328_digi);
}


int init_module(void)
{
	return mc68328digi_init();
}

void cleanup_module(void)
{
	mc68328digi_unload();
}
