/*
 * linux/arch/arm/drivers/char/console-dummy.c
 *
 * Modifications (C) 1996 Russell King
 */

/*
 * This module exports the console io functions:
 *
 *  'int           vcd_init (struct vt *vt, int kmallocok, unsigned long *kmem)'
 *  'unsigned long vcd_pre_init (unsigned long kmem, struct vt *vt)'
 *  'void          vcd_disallocate (struct vt *vt)'
 *  'int           vcd_resize (unsigned long lines, unsigned long cols)'
 *  'void          vcd_blankscreen (int nopowersave)'
 *  'void          vcd_unblankscreen (void)'
 *  'void          vcd_savestate (const struct vt *vt, int blanked)'
 *  'void          vcd_restorestate (const struct vt *vt)'
 *  'void          vcd_setup_graphics (const struct vt *vt)'
 *  'int           vcd_write (const struct vt *vt, int from_user, const unsigned char *buf, int count)'
 *  'int           vcd_ioctl (const struct vt *vt, int cmd, unsigned long arg)'
 *
 *
 *	'int vc_allocate(unsigned int console)'
 *	'int vc_cons_allocated (unsigned int console)'
 *	'int vc_resize(unsigned long lines,unsigned long cols)'
 *	'void vc_disallocate(unsigned int currcons)'
 *
 *	'unsigned long con_init(unsigned long)'
 * S	'int con_open(struct tty_struct *tty,struct file *filp)'
 * S	'void con_write(struct tty_struct *tty)'
 * S	'void console_print(const char *b)'
 *	'void update_screen(int new_console)'
 *
 *	'void blank_screen(void)'
 *	'void unblank_screen(void)'
 *	'void scrollback(int lines)'			*
 *	'void scrollfront(int lines)'			*
 *	'int do_screendump(int arg)'
 *
 *	'int con_get_font(char *)'
 *	'int con_set_font(char *)'
 *	'int con_get_trans(char *)'
 *	'int con_set_trans(char *)'
 *
 *	'int mouse_reporting(void)'
 */

#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/interrupt.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/kd.h>
#include <linux/major.h>
#include <linux/mm.h>
#include <linux/malloc.h>

#include <asm/segment.h>
#include <asm/irq.h>

#include "kbd_kern.h"
#include "consolemap.h"
#include "vt_kern.h"
#include "selection.h"

extern void register_console(void (*proc)(const char *));
static int printable;				/* Is console ready for printing? */

#define SERIAL_ECHO_PORT	0x2f8
#define SERIAL_ECHO_DIVISOR	3

#include "serialecho.c"

/*
 * functions to handle /dev/fb
 */
int con_fb_read(char *buf, unsigned long pos, int count)
{
	return -EIO;
}

int con_fb_write(const char *buf, unsigned long pos, int count)
{
	return -EIO;
}

int con_fb_mmap(unsigned long vma_start, unsigned long vma_offset,
			unsigned long vma_end, pgprot_t prot)
{
	return -EINVAL;
}

void no_scroll (char *str, int *ints)
{
}

void mouse_report (struct tty_struct *tty, int butt, int mrx, int mry)
{
}

int mouse_reporting (void)
{
    return 0;
}

static inline unsigned long *bufferpos (const struct vt * const vt, int offset)
{
    return NULL;
}

void invert_screen (const struct vt * const vt, unsigned int offset, unsigned int count)
{
}

void complement_pos (const struct vt * const vt, unsigned int offset)
{
}

unsigned long screen_word (const struct vt * const vt, unsigned int offset)
{
    return 0;
}

int scrw2glyph (unsigned long scr_word)
{
    return 0;
}

unsigned long *screen_pos (const struct vt * const vt, unsigned int offset)
{
    return NULL;
}

void getconsxy (const struct vt * const vt, char *p)
{
    p[0] = p[1] = 0;
}

void putconsxy (const struct vt * const vt, char *p)
{
}

void console_print(const char *b)
{
    static int printing = 0;

    if (!printable || printing)
	return;  /* console not yet initialized */

    printing = 1;
    serial_echo_print (b);
    printing = 0;
}

void update_scrmem (const struct vt * const vt, int start, int length)
{
}

void set_scrmem (const struct vt * const vt, long offset)
{
}

int con_set_font (char *arg)
{
    return -EINVAL;
}

int con_get_font (char *arg)
{
    return -EINVAL;
}

void con_reset_palette (const struct vt * const vt)
{
}

void con_set_palette (const struct vt * const vt)
{
}

/* == arm specific console code ============================================================== */

int do_screendump(int arg)
{
    return -EINVAL;
}

/*===============================================================================================*/

int vcd_init (struct vt *vt, int kmallocok, unsigned long *kmem)
{
    return 0;
}

unsigned long vcd_pre_init (unsigned long kmem, struct vt *vt)
{
    serial_echo_init (SERIAL_ECHO_PORT);
    printable = 1;

    printk ("Console: dummy console driver\n");
    register_console (console_print);
    return kmem;
}

void vcd_disallocate (struct vt *vt)
{
}

int vcd_resize(unsigned long lines, unsigned long cols)
{/* TODO */
	return -ENOMEM;
}

void vcd_blankscreen(int nopowersave)
{
}

void vcd_unblankscreen (void)
{
}

void vcd_savestate (const struct vt *vt, int blanked)
{
}

void vcd_restorestate (const struct vt *vt)
{
}

void vcd_setup_graphics (const struct vt *vt)
{
}

static char vcd_buffer[128];
int vcd_write (const struct vt *vt, int from_user, const unsigned char *buf, int count)
{
    int tmp = count;
    while (tmp) {
	int i;

	i = tmp < 127 ? tmp : 127;

	tmp -= i;
	memcpy (vcd_buffer, buf, i);
	buf += i;

	vcd_buffer[i] = 0;
	serial_echo_print(vcd_buffer);
    }
    return count;
}

int vcd_ioctl (const struct vt *vt, int cmd, unsigned long arg)
{
    switch (cmd) {
    case PIO_FONT:
    case GIO_FONT:
    case PIO_SCRNMAP:
    case GIO_SCRNMAP:
    case PIO_UNISCRNMAP:
    case GIO_UNISCRNMAP:
    case PIO_UNIMAPCLR:
    case PIO_UNIMAP:
    case GIO_UNIMAP:
	return -EINVAL;

    default:
	return -ENOIOCTLCMD;
    }
}

void console_map_init (void)
{
}

/*
 * Report the current status of the vc. This is exported to modules (ARub)
 */
int con_get_info(int *mode, int *shift, int *col, int *row,
			struct tty_struct **tty)
{
    if (mode) *mode = 0;
    if (shift) *shift = 0;
    if (col) *col = 0;
    if (row) *row = 0;
    if (tty) *tty = NULL;
    return 0;
}
