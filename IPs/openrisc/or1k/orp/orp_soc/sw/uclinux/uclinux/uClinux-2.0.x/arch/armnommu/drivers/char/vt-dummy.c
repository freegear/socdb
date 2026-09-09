/*
 * linux/arch/arm/drivers/char/vt-dummy.c
 *
 * VT routines
 *
 * Changelog:
 *  05-Sep-1996	RMK	Fixed race condition between VT switch & initialisation
 *  08-Sep-1996	RMK	Adapted Brad Pepers (ramparts@agt.net) console buffering code
 *			(vt_put_char & vt_flush_chars).
 *  20-Sep-1996	RMK	Cut down version for StrongARM eval board.
 */

#include <linux/sched.h>
#include <linux/tty.h>
#include <linux/kd.h>
#include <linux/errno.h>
#include <linux/malloc.h>
#include <linux/mm.h>
#include <linux/tty.h>
#include <linux/major.h>

#include <asm/segment.h>

#include "kbd_kern.h"
#include "vt_kern.h"

/*
 * VCD functions
 */
extern int		vcd_init (struct vt *, int kmallocok, unsigned long *kmem);
extern int		vcd_ioctl (struct vt *, int cmd, unsigned long arg);
extern unsigned long	vcd_pre_init (unsigned long kmem, struct vt *);

static int vt_refcount;
static struct tty_driver vt_driver;
static struct tty_struct *vt_table[MAX_NR_CONSOLES];
static struct termios *vt_termios[MAX_NR_CONSOLES];
static struct termios *vt_termios_locked[MAX_NR_CONSOLES];

int shift_state = 0;
struct vt_data vtdata;
struct vt vt_con_data[1];

extern void vt_do_blankscreen (int nopowersave);
extern void vt_do_unblankscreen (void);

/*
 * last_console is the last used console
 */
struct vt *last_console;

int vt_deallocate (int arg)
{
    return 0;
}

void vt_pokeblankedconsole (void)
{
}

/*
 * for tty_io.c
 */
void vt_do_unblankscreen (void)
{
}

int sel_loadlut (const unsigned long arg)
{
	return 0;
}

int set_selection (const unsigned long arg, struct tty_struct *tty)
{
	return 0;
}

int paste_selection (struct tty_struct *tty)
{
	return 0;
}

/*
 * for panic.c
 */
void do_unblank_screen (void)
{
}

static int vt_open (struct tty_struct *tty, struct file *filp)
{
    return 0;
}

static int vt_write (struct tty_struct *tty, int from_user,
			const unsigned char *buf, int count)
{
    return vcd_write (NULL, from_user, buf, count);
}

static void vt_put_char (struct tty_struct *tty, unsigned char ch)
{
    vcd_write (NULL, 0, &ch, 1);
}

static int vt_write_room (struct tty_struct *tty)
{
    return 4096;
}

static int vt_chars_in_buffer (struct tty_struct *tty)
{
    return 0;
}

static int vt_ioctl (struct tty_struct *tty, struct file *filp,
			unsigned int cmd, unsigned long arg)
{
    struct vt *vt = tty->driver_data;
    int perm;

    if (!vt_allocated (vt))	/* impossible ? */
	return -ENOIOCTLCMD;
    /*
     * To have permissions to do most of the vt ioctls, we either
     * have to be the owner of the tty, or super-user.
     */
    perm = 0;
    if (current->tty == tty || suser ())
	perm = 1;

#define PERM if (!perm) return -EPERM

    switch (cmd) {
    case KDGETMODE:
    case KDSETMODE:
    case VT_GETMODE:
    case VT_SETMODE:
    case VT_GETSTATE:
    case VT_OPENQRY:
    case VT_ACTIVATE:
    case VT_WAITACTIVE:
    case VT_RELDISP:
    case VT_GETSCRINFO:
	return -EINVAL;

    case VT_RESIZE:
    case KIOCSOUND:
    case KDMKTONE:
	PERM;
    case VT_DISALLOCATE:
	return 0;

    case KDMAPDISP:
    case KDUNMAPDISP:
    case KDSKBMODE:
    case KDSKBMETA:
    case KDSETKEYCODE:
    case KDSKBENT:
    case KDSKBSENT:
    case KDSKBDIACR:
    case KDSKBLED:
    case KDSETLED:
    case KDSIGACCEPT:
    case KDGKBTYPE:
    case KDADDIO:
    case KDDELIO:
    case KDENABIO:
    case KDDISABIO:
    case KDGKBMODE:
    case KDGKBMETA:
    case KDGETKEYCODE:
    case KDGKBENT:
    case KDGKBSENT:
    case KDGKBDIACR:
    case KDGKBLED:
    case KDGETLED:
	return -EINVAL;

    case VT_SETPALETTE:
    case PIO_FONT:
    case PIO_SCRNMAP:
    case PIO_UNISCRNMAP:
    case PIO_UNIMAPCLR:
    case PIO_UNIMAP:
	PERM;

    case VT_GETPALETTE:
    case GIO_FONT:
    case GIO_SCRNMAP:
    case GIO_UNISCRNMAP:
    case GIO_UNIMAP:
	return vcd_ioctl (vt, cmd, arg);
    }
    return -ENOIOCTLCMD;
}

static void vt_dummy (struct tty_struct *tty)
{
}

int vcs_init(void)
{
    return 0;
}

unsigned long vt_pre_init (unsigned long kmem)
{
    kmem = vcd_pre_init (kmem, NULL);

    memset (vt_con_data, 0, sizeof (vt_con_data));

    vtdata.blanked	= NULL;
    vtdata.fgconsole	= vt_con_data;

    vt_con_data->tty = &vt_table[0];
    vt_con_data->num = 1;

    return kmem;
}

/*
 * This is the post initialisation.  We have kmalloc setup so we can use it...
 */
void vt_post_init (void)
{
    memset (&vt_driver, 0, sizeof (struct tty_driver));
    vt_driver.magic		= TTY_DRIVER_MAGIC;
    vt_driver.name		= "tty";
    vt_driver.name_base		= 1;
    vt_driver.major		= TTY_MAJOR;
    vt_driver.minor_start	= 1;
    vt_driver.num		= MAX_NR_CONSOLES;
    vt_driver.type		= TTY_DRIVER_TYPE_CONSOLE;
    vt_driver.init_termios	= tty_std_termios;
    vt_driver.flags		= TTY_DRIVER_REAL_RAW;
    vt_driver.refcount		= &vt_refcount;
    vt_driver.table		= vt_table;
    vt_driver.termios		= vt_termios;
    vt_driver.termios_locked	= vt_termios_locked;
    vt_driver.open		= vt_open;
    vt_driver.write		= vt_write;
    vt_driver.put_char		= vt_put_char;
    vt_driver.flush_chars	= vt_dummy;
    vt_driver.write_room	= vt_write_room;
    vt_driver.chars_in_buffer	= vt_chars_in_buffer;
    vt_driver.ioctl		= vt_ioctl;
    vt_driver.stop		= vt_dummy;
    vt_driver.start		= vt_dummy;
    vt_driver.throttle		= vt_dummy;
    vt_driver.unthrottle	= vt_dummy;

    if (tty_register_driver (&vt_driver))
	panic ("Couldn't register console driver");
}
