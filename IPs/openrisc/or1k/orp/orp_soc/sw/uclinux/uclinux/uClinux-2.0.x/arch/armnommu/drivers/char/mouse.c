/*
 * linux/arch/arm/drivers/char/mouse.c
 *
 * Copyright (C) 1995, 1996 Russell King
 *
 * Medium-level interface for quadrature mouse.
 */

#include <linux/module.h>
#include <linux/config.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/signal.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <linux/miscdevice.h>
#include <linux/random.h>

#include <asm/system.h>
#include <asm/segment.h>
#include <asm/io.h>

#include "mouse.h"

#ifdef CONFIG_RPCMOUSE
extern void mouse_rpc_init (void);
#endif

static struct wait_queue *mouse_wait;
static struct fasync_struct *fasyncptr;
static char mouse_active;
static char mouse_buttons;
static char mouse_ready;
static int mouse_present;
static int mouse_dxpos;
static int mouse_dypos;

/*
 * a mouse driver just has to interface with these functions
 */
void add_mouse_movement(int dx, int dy)
{
	mouse_dxpos += dx;
	mouse_dypos += dy;
	mouse_ready = 1;
	wake_up(&mouse_wait);
	
}

int add_mouse_buttonchange(int set, int value)
{
	mouse_buttons = (mouse_buttons & ~set) ^ value;
	mouse_ready = 1;
	wake_up(&mouse_wait);
	return mouse_buttons;
}

static int fasync_mouse(struct inode *inode, struct file *filp, int on)
{
	int retval;

	retval = fasync_helper(inode, filp, on, &fasyncptr);
	if (retval < 0)
		return retval;
	return 0;
}

static void close_mouse(struct inode *inode, struct file *file)
{
	fasync_mouse (inode, file, 0);
	if (--mouse_active)
		return;
	mouse_ready = 0;

	MOD_DEC_USE_COUNT;
}

static int open_mouse(struct inode *inode,struct file *file)
{
	unsigned long flags;

	if (!mouse_present)
		return -EINVAL;

	if (mouse_active++)
		return 0;

	MOD_INC_USE_COUNT;

	save_flags_cli (flags);
	mouse_active  = 1;
	mouse_ready   = 0;
	mouse_dxpos   = 0;
	mouse_dypos   = 0;
	mouse_buttons = 7;
	restore_flags (flags);

	return 0;
}

static int write_mouse(struct inode *inode,struct file *file,const char *buffer,int count)
{
	return -EINVAL;
}

static int read_mouse(struct inode *inode,struct file *file,char *buffer,int count)
{
	unsigned long flags;
	int dxpos, dypos, i, buttons;

	if (count < 3)
		return -EINVAL;
	if ((i = verify_area(VERIFY_WRITE, buffer, count)))
		return i;
	if (!mouse_ready)
		return -EAGAIN;

	save_flags_cli (flags);

	dxpos = mouse_dxpos;
	dypos = mouse_dypos;
	buttons = mouse_buttons;

	if (dxpos < -127)
		dxpos =- 127;
	if (dxpos > 127)
		dxpos = 127;
	if (dypos < -127)
		dypos =- 127;
	if (dypos > 127)
		dypos = 127;

	mouse_dxpos -= dxpos;
	mouse_dypos -= dypos;
	mouse_ready = 0;

	restore_flags (flags);

	put_user ((char) buttons | 128, buffer);
	put_user ((char) dxpos, buffer + 1);
	put_user ((char) dypos, buffer + 2);
	for(i = 3; i < count; i++)
		put_user (0, buffer + i);
	return i;
}

static int select_mouse(struct inode *inode,struct file *file,int sel_type,select_table *wait)
{
	if (sel_type == SEL_IN) {
		if (mouse_ready)
			return 1;
		select_wait (&mouse_wait,wait);
	}
	return 0;
}

struct file_operations kbd_mouse_fops=
{
	NULL,			/* mouse_seek */
	read_mouse,
	write_mouse,
	NULL,			/* mouse_readdir */
	select_mouse,
	NULL,			/* mouse_ioctl */
	NULL,			/* mouse_mmap */
	open_mouse,
	close_mouse,
	NULL,
	fasync_mouse,
};

static struct miscdevice mouse_misc = {
	6, "mouse", &kbd_mouse_fops, NULL, NULL
};

int misc_mouse_init(void)
{
	unsigned long flags;

	save_flags_cli (flags);

	mouse_buttons = 0;
	mouse_dxpos   = 0;
	mouse_dypos   = 0;
	mouse_present = 1;
	mouse_ready   = 0;
	mouse_active  = 0;
	mouse_wait    = NULL;

	restore_flags (flags);
	misc_register (&mouse_misc);

#ifdef CONFIG_RPCMOUSE
	mouse_rpc_init();
#endif
	return 0;
}

#ifdef MODULE
int init_module(void)
{
	return misc_mouse_init();
}

void cleanup_module(void)
{
	misc_deregister (&mouse_misc);
}
#endif
