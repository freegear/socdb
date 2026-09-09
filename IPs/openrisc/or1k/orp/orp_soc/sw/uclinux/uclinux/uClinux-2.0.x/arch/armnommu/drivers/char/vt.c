/*
 * linux/arch/arm/drivers/char/vt.c
 *
 * VT routines
 *
 * Changelog:
 *  05-Sep-1996	RMK	Fixed race condition between VT switch & initialisation
 *  08-Sep-1996	RMK	Adapted Brad Pepers (ramparts@agt.net) console buffering code
 *			(vt_put_char & vt_flush_chars).
 *  02-Sep-1997 RMK	Added in VT switch disable
 */

#include <linux/config.h>
#include <linux/sched.h>
#include <linux/tty.h>
#include <linux/kd.h>
#include <linux/errno.h>
#include <linux/malloc.h>
#include <linux/mm.h>
#include <linux/tty.h>
#include <linux/major.h>

#include <asm/segment.h>
#include <asm/hardware.h>

#include "kbd_kern.h"
#include "vt_kern.h"

#define CON_XMIT_SIZE	2048

#ifndef MIN
#define MIN(a,b)        ((a) < (b) ? (a) : (b))
#endif

/*
 * VCD functions
 */
extern void		vcd_blankscreen (int nopowersave);
extern void		vcd_disallocate (struct vt *);
extern int		vcd_init (struct vt *, int kmallocok, unsigned long *kmem);
extern int		vcd_ioctl (struct vt *, int cmd, unsigned long arg);
extern unsigned long	vcd_pre_init (unsigned long kmem, struct vt *);
extern int		vcd_resize (int rows, int columns);
extern void		vcd_restorestate (const struct vt *);
extern void		vcd_savestate (const struct vt *, int blanked);
extern void		vcd_unblankscreen (void);
extern int		vcd_write (const struct vt *, int from_user, const unsigned char *buf, int count);
extern void		vcd_setup_graphics (const struct vt *);

/*
 * Console functions
 */
extern void con_reset_palette (const struct vt *vt);
extern void con_set_palette (const struct vt *vt);
extern int con_init (void);

static int vt_refcount;
int do_poke_blanked_console;
static struct tty_driver vt_driver;
static struct tty_struct *vt_table[MAX_NR_CONSOLES];
static struct termios *vt_termios[MAX_NR_CONSOLES];
static struct termios *vt_termios_locked[MAX_NR_CONSOLES];

struct vt_data vtdata;
struct vt vt_con_data[MAX_NR_CONSOLES];

extern void vt_do_blankscreen (int nopowersave);
extern void vt_do_unblankscreen (void);

/* set this to the sound driver's wave output trigger */
void (*mksound_hook)(unsigned int freq, unsigned int vol, unsigned int duration);
/*
 * last_console is the last used console
 */
struct vt *last_console;
struct vt *want_console;
static char vt_dont_switch = 0;

/*
 * Sometimes we want to wait until a particular VT has been activated. We
 * do it in a very simple manner. Everybody waits on a single queue and
 * get woken up at once. Those that are satisfied go on with their business,
 * while those not ready go back to sleep. Seems overkill to add a wait
 * to each vt just for this - usually this does nothing!
 */
static struct wait_queue *vt_activate_queue = NULL;

/*
 * Sleeps until a vt is activated, or the task is interrupted. Returns
 * 0 if activation, -1 if interrupted.
 */
static int vt_waitonactivate (void)
{
    interruptible_sleep_on (&vt_activate_queue);
    return (current->signal & ~current->blocked) ? -1 : 0;
}

#define vt_wake_waitactive() wake_up(&vt_activate_queue)

void vt_reset (const struct vt *vt)
{
    vt->kbd->kbdmode		= VC_XLATE;
    vt->vtd->vc_mode		= KD_TEXT;
    vt->vtd->vt_mode.mode	= VT_AUTO;
    vt->vtd->vt_mode.waitv	= 0;
    vt->vtd->vt_mode.relsig	= 0;
    vt->vtd->vt_mode.acqsig	= 0;
    vt->vtd->vt_mode.frsig	= 0;
    vt->vtd->vt_pid		= -1;
    vt->vtd->vt_newvt		= NULL;
    con_reset_palette (vt);
}

static int vt_allocate (struct vt *vt)
{
    if (!vt_allocated(vt)) {
	void *data, *p;
	int r;

	data = kmalloc (sizeof (*vt->vcd) +
			sizeof (*vt->kbd) +
			sizeof (*vt->vtd) + CON_XMIT_SIZE, GFP_KERNEL);
	if (!data)
	    return -ENOMEM;

	vt->vcd = data;  p = ((struct con_struct *)data + 1);
	vt->kbd = p;     p = ((struct kbd_struct *)p + 1);
	vt->vtd = p;	 p = ((struct vt_struct *)p + 1);
	vt->vtd->xmit_buf = p;

	if ((r = kbd_struct_init (vt, 1)) < 0) {
	    vt->vcd = NULL;
	    vt->kbd = NULL;
	    vt->vtd = NULL;
	    kfree (data);
	    return r;
	}

	if ((r = vcd_init (vt, 1, NULL)) < 0) {
	    vt->vcd = NULL;
	    vt->kbd = NULL;
	    vt->vtd = NULL;
	    kfree (data);
	    return r;
	}
	vt_reset (vt);
	vt->vtd->xmitting = vt->vtd->xmit_cnt =
	vt->vtd->xmit_out = vt->vtd->xmit_in = 0;
	vt->allocinit = 1;
    }
    return 0;
}

static int vt_disallocate (struct vt *vt)
{
    if (vt_allocated (vt)) {
	void *data = vt->vcd;

	vt->allocinit = 0;
	vcd_disallocate (vt);
	vt->vcd = NULL;
	vt->kbd = NULL;
	vt->vtd = NULL;

	kfree (data);
    }
    return 0;
}

void vt_updatescreen (const struct vt *newvt)
{
    static int lock = 0;

    if (newvt == vtdata.fgconsole || lock)
	return;

    if (!vt_allocated (newvt)) {
	printk ("updatescreen: tty %d not allocated ??\n", newvt->num);
	return;
    }

    lock = 1;

    vcd_savestate (vtdata.fgconsole, vtdata.blanked != NULL);

    vtdata.fgconsole = (struct vt *)newvt;

    vcd_restorestate (vtdata.fgconsole);
    compute_shiftstate ();

    lock = 0;
}

/*
 * Performs the back end of a vt switch
 */
void vt_completechangeconsole (const struct vt *new_console)
{
    unsigned char old_vt_mode;
    struct vt *old_vt = vtdata.fgconsole;

    if (new_console == old_vt || (vt_dont_switch))
	return;
    if (!vt_allocated (new_console))
	return;
    last_console = old_vt;

    /*
     * If we're switching, we could be going from KD_GRAPHICS to
     * KD_TEXT mode or vice versa, which means we need to blank or
     * unblank the screen later.
     */
    old_vt_mode = old_vt->vtd->vc_mode;
    vt_updatescreen (new_console);

    /*
     * If this new console is under process control, send it a signal
     * telling it that it has acquired. Also check if it has died and
     * clean up (similar to logic employed in vt_changeconsole())
     */
    if (new_console->vtd->vt_mode.mode == VT_PROCESS) {
	/*
	 * Send the signal as privileged - kill_proc() will
	 * tell us if the process has gone or something else
	 * is awry
	 */
	if (kill_proc(new_console->vtd->vt_pid,
			      new_console->vtd->vt_mode.acqsig,
			      1) != 0) {
	    /*
	     * The controlling process has died, so we revert back to
	     * normal operation. In this case, we'll also change back
	     * to KD_TEXT mode. I'm not sure if this is strictly correct
	     * but it saves the agony when the X server dies and the screen
	     * remains blanked due to KD_GRAPHICS! It would be nice to do
	     * this outside of VT_PROCESS but there is no single process
	     * to account for and tracking tty count may be undesirable.
	     */
	    vt_reset (new_console);
	}
    }

    /*
     * We do this here because the controlling process above may have
     * gone, and so there is now a new vc_mode
     */
    if (old_vt_mode != new_console->vtd->vc_mode) {
	if (new_console->vtd->vc_mode == KD_TEXT)
	    vt_do_unblankscreen ();
	else {
	    vt_do_blankscreen (1);
	    vcd_setup_graphics (new_console);
	}
    }

    /* Set the colour palette for this VT */
    if (new_console->vtd->vc_mode == KD_TEXT)
	con_set_palette (new_console);
	
    /*
     * Wake anyone waiting for their VT to activate
     */
    vt_wake_waitactive();
    return;
}

/*
 * Performs the front-end of a vt switch
 */
void vt_changeconsole (struct vt *new_console)
{
    struct vt *old_vt = vtdata.fgconsole;

    if (new_console == old_vt || (vt_dont_switch))
	return;
    if (!vt_allocated (new_console))
	return;

    /*
     * If this vt is in process mode, then we need to handshake with
     * that process before switching. Essentially, we store where that
     * vt wants to switch to and wait for it to tell us when it's done
     * (via VT_RELDISP ioctl).
     *
     * We also check to see if the controlling process still exists.
     * If it doesn't, we reset this vt to auto mode and continue.
     * This is a cheap way to track process control. The worst thing
     * that can happen is: we send a signal to a process, it dies, and
     * the switch gets "lost" waiting for a response; hopefully, the
     * user will try again, we'll detect the process is gone (unless
     * the user waits just the right amount of time :-) and revert the
     * vt to auto control.
     */
    if (old_vt->vtd->vt_mode.mode == VT_PROCESS) {
	/*
	 * Send the signal as privileged - kill_proc() will
	 * tell us if the process has gone or something else
	 * is awry
	 */
	if (kill_proc(old_vt->vtd->vt_pid, old_vt->vtd->vt_mode.relsig, 1) == 0) {
	    /*
	     * It worked. Mark the vt to switch to and
	     * return. The process needs to send us a
	     * VT_RELDISP ioctl to complete the switch.
	     */
	    old_vt->vtd->vt_newvt = new_console;
	    return;
	}

	/*
	 * The controlling process has died, so we revert back to
	 * normal operation. In this case, we'll also change back
	 * to KD_TEXT mode. I'm not sure if this is strictly correct
	 * but it saves the agony when the X server dies and the screen
	 * remains blanked due to KD_GRAPHICS! It would be nice to do
	 * this outside of VT_PROCESS but there is no single process
	 * to account for and tracking tty count may be undesirable.
	 */
	vt_reset (old_vt);

	/*
	 * Fall through to normal (VT_AUTO) handling of the switch...
	 */
    }

    /*
     * Ignore all switches in KD_GRAPHICS+VT_AUTO mode
     */
    if (old_vt->vtd->vc_mode == KD_GRAPHICS)
	return;

    vt_completechangeconsole (new_console);
}

/*
 * If a vt is under process control, the kernel will not switch to it
 * immediately, but postpone the operation until the process calls this
 * ioctl, allowing the switch to complete.
 *
 * According to the X sources this is the behavior:
 *      0:      pending switch-from not OK
 *      1:      pending switch-from OK
 *      2:      completed switch-to OK
 */
static inline int vt_reldisp (const struct vt *old_vt, int arg)
{
    int i;

    if (old_vt->vtd->vt_mode.mode != VT_PROCESS)
	return -EINVAL;

    if (old_vt->vtd->vt_newvt) {
	/*
	 * Switching-from response
	 */
	if (arg == 0)
	    /*
	     * Switch disallowed, so forget we were trying
	     * to do it.
	     */
	    old_vt->vtd->vt_newvt = NULL;
	else {
	    /*
	     * The current vt has been released, so complete the
	     * switch.
	     */
	    struct vt *new_vt = old_vt->vtd->vt_newvt;
	    old_vt->vtd->vt_newvt = NULL;
	    i = vt_allocate (new_vt);
	    if (i)
		return i;
	    vt_completechangeconsole (new_vt);
	}
    } else {
	/*
	 * Switched-to response
	 */
	if (arg != VT_ACKACQ)
	    return -EINVAL;
    }
    return 0;
}

/*
 * Set the mode of a VT.
 */
static inline int vt_kdsetmode (const struct vt *vt, int mode)
{
    /*
     * Currently, setting the mode from KD_TEXT to KD_GRAPHICS
     * doesn't do a whole lot. I'm not sure if it should do any
     * restoration of modes or what...
     */
    switch (mode) {
    case KD_TEXT0:
    case KD_TEXT1:
	mode = KD_TEXT;
    case KD_GRAPHICS:
    case KD_TEXT:
	break;
    default:
	return -EINVAL;
    }

    if (vt->vtd->vc_mode == mode)
	return 0;

    vt->vtd->vc_mode = mode;
    if (vt != vtdata.fgconsole)
	return 0;

    /*
     * explicitly blank/unblank the screen if switching modes
     */
    if (mode == KD_TEXT) {
	vt_do_unblankscreen ();
        vcd_restorestate (vt);
    } else {
	vt_do_blankscreen (1);
	vcd_setup_graphics (vt);
    }
    return 0;
}

static inline int vt_setmode (const struct vt *vt, struct vt_mode *vtmode)
{
    if (vtmode->mode != VT_AUTO && vtmode->mode != VT_PROCESS)
	return -EINVAL;

    vt->vtd->vt_mode = *vtmode;
    vt->vtd->vt_mode.frsig = 0;
    vt->vtd->vt_pid = current->pid;
    vt->vtd->vt_newvt = NULL;
    return 0;
}

void vt_mksound (unsigned int freq, unsigned int vol, unsigned int ticks)
{
    if (mksound_hook)
        mksound_hook (freq, vol, ticks);
}

/*
 * Deallocate memory associated to VT (but leave VT1)
 */
int vt_deallocate (int arg)
{
    int i;

    if (arg == 0) {
	/*
	 * deallocate all unused consoles, but leave 0
	 */
	for (i = 1; i < MAX_NR_CONSOLES; i++)
	    if (!VT_BUSY (i))
		vt_disallocate (vt_con_data + i);
    } else {
	arg -= 1;
	if (VT_BUSY (arg))
	    return -EBUSY;
	if (arg)
	    vt_disallocate (vt_con_data + arg);
    }
    return 0;
}

int vt_resize (int columns, int rows)
{
    return vcd_resize (rows, columns);
}

void vt_pokeblankedconsole (void)
{
    timer_active &= ~(1 << BLANK_TIMER);
    if (vtdata.fgconsole->vtd->vc_mode == KD_GRAPHICS)
	return;
    if (vtdata.blanked) {
	timer_table[BLANK_TIMER].expires = 0;
	timer_active |= 1 << BLANK_TIMER;
    } else if (vtdata.screen.blankinterval) {
	timer_table[BLANK_TIMER].expires = jiffies + vtdata.screen.blankinterval;
	timer_active |= 1 << BLANK_TIMER;
    }
}

static void vt_blankscreen (void);

void vt_do_unblankscreen (void)
{
    if (!vtdata.blanked)
	return;

    if (!vt_allocated (vtdata.fgconsole)) {
	/* impossible... */
	printk ("unblank_screen: tty %d not allocated ??\n", vtdata.fgconsole->num);
	return;
    }

    timer_table[BLANK_TIMER].fn = vt_blankscreen;

    if (vtdata.screen.blankinterval) {
	timer_table[BLANK_TIMER].expires = jiffies + vtdata.screen.blankinterval;
	timer_active |= 1 << BLANK_TIMER;
    }

    vtdata.blanked = NULL;

    vcd_unblankscreen ();
}

/*
 * for panic.c
 */
void do_unblank_screen (void)
{
    vt_do_unblankscreen ();
}

void vt_do_blankscreen (int nopowersave)
{
    if (vtdata.blanked)
	return;

    timer_active &= ~(1 << BLANK_TIMER);
    timer_table[BLANK_TIMER].fn = do_unblank_screen;

    vtdata.blanked = vtdata.fgconsole;

    vcd_blankscreen (nopowersave);
}

static void vt_blankscreen (void)
{
    vt_do_blankscreen (0);
}

static int vt_open (struct tty_struct *tty, struct file *filp)
{
    struct vt *vt;
    unsigned int idx;
    int i;

    idx = MINOR(tty->device) - tty->driver.minor_start;

    vt = vt_con_data + idx;

    if ((i = vt_allocate (vt)) < 0)
	return i;

    tty->driver_data = vt;

    if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
	tty->winsize.ws_row = vtdata.numrows;
	tty->winsize.ws_col = vtdata.numcolumns;
    }
    return 0;
}

static void vt_vtd_flush_chars (const struct vt *vt, struct vt_struct *vtd)
{
    unsigned long flags;

    save_flags (flags);
    if (vtd->xmitting)
	return;

    vtd->xmitting = 1;

    while (1) {
	int c;

	cli ();
	c = MIN(vtd->xmit_cnt, CON_XMIT_SIZE - vtd->xmit_out);

	if (c <= 0)
	    break;

	restore_flags (flags);

	c = vcd_write (vt, 0, vtd->xmit_buf + vtd->xmit_out, c);

	cli ();

	if (c <= 0)
	    break;
	vtd->xmit_out = (vtd->xmit_out + c) & (CON_XMIT_SIZE - 1);
	vtd->xmit_cnt -= c;
    }

    vtd->xmitting = 0;
    restore_flags (flags);
    if (*vt->tty)
	wake_up_interruptible (&(*vt->tty)->write_wait);
}

static int vt_write (struct tty_struct *tty, int from_user,
			const unsigned char *buf, int count)
{
    static unsigned long last_error = 0;
    const struct vt *vt = (struct vt *)tty->driver_data;

    if (vt_allocated (vt)) {
	if (vt->vtd->xmit_cnt)
	    vt_vtd_flush_chars (vt, vt->vtd);
	return vcd_write (vt, from_user, buf, count);
    }

    if (jiffies > last_error + 10*HZ) {
	printk ("vt_write: tty %d not allocated\n", vt->num);
	last_error = jiffies;
    }
    return 0;
}

static void vt_put_char (struct tty_struct *tty, unsigned char ch)
{
    const struct vt *vt = (struct vt *)tty->driver_data;
    unsigned long flags;

    if (!vt_allocated (vt))
	return;

    save_flags_cli (flags);
    if (vt->vtd->xmit_cnt < CON_XMIT_SIZE - 1) {
	vt->vtd->xmit_buf[vt->vtd->xmit_in++] = ch;
	vt->vtd->xmit_in &= CON_XMIT_SIZE - 1;
	vt->vtd->xmit_cnt ++;
    }
    restore_flags (flags);
}

static void vt_flush_chars (struct tty_struct *tty)
{
    const struct vt *vt = (struct vt *)tty->driver_data;

    if (!vt_allocated (vt) || !vt->vtd->xmit_cnt || tty->stopped)
	return;

    vt_vtd_flush_chars (vt, vt->vtd);
}

static int vt_write_room (struct tty_struct *tty)
{
    const struct vt *vt = (struct vt *)tty->driver_data;
    int r;

    if (!vt_allocated (vt))
	return 0;

    r = CON_XMIT_SIZE - vt->vtd->xmit_cnt - 8; /* allow 8 char overflow */
    if (r < 0)
	return 0;
    else
	return r;
}

static int vt_chars_in_buffer (struct tty_struct *tty)
{
    const struct vt *vt = (struct vt *)tty->driver_data;

    if (!vt_allocated (vt))
	return CON_XMIT_SIZE;
    return vt->vtd->xmit_cnt;
}
#if 0
static void vt_flush_buffer (struct tty_struct *tty)
{
    const struct vt *vt = (struct vt *)tty->driver_data;

    if (!vt_allocated (vt))
	return;

    cli ();
    vt->vtd->xmit_cnt = vt->vtd->xmit_out = vt->vtd->xmit_in = 0;
    sti ();
}
#endif
static int vt_ioctl (struct tty_struct *tty, struct file *filp,
			unsigned int cmd, unsigned long arg)
{
    struct vt *vt = tty->driver_data;
    int perm, i;

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
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (unsigned long));
	if (!i)
	    put_user (vt->vtd->vc_mode, (unsigned long *)arg);
	return i;

    case KDSETMODE:
	PERM;
	return vt_kdsetmode (vt, arg);

    case VT_GETMODE:
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (struct vt_mode));
	if (i)
	    return i;
	memcpy_tofs ((void *)arg, &vt->vtd->vt_mode, sizeof (struct vt_mode));
	return 0;

    case VT_SETMODE: {
	struct vt_mode vtmode;

	PERM;
	i = verify_area (VERIFY_READ, (void *)arg, sizeof (struct vt_mode));
	if (i)
	    return i;
	memcpy_fromfs (&vtmode, (void *)arg, sizeof (struct vt_mode));
	return vt_setmode (vt, &vtmode);
	}

    case VT_GETSTATE: {
	/*
	 * Returns global VT state.  Note that VT 0 is always open, since
	 * it's an alias for the current VT, and people can't use it here.
	 * We cannot return state for more than 16 VTs, since v_state is short.
	 */
	struct vt_stat *vtstat = (struct vt_stat *)arg;
	unsigned short state = 1, mask = 2;

	i = verify_area (VERIFY_WRITE, vtstat, sizeof (struct vt_stat));
	if (i)
	    return i;

	for (i = 0; i < MAX_NR_CONSOLES && mask; ++i, mask <<= 1)
	    if (VT_IS_IN_USE(i))
		state |= mask;

	put_user (vtdata.fgconsole->num, &vtstat->v_active);
	put_user (state, &vtstat->v_state);
	return 0;
	}

    case VT_OPENQRY:
	/*
	 * Returns the first available (non-open) console
	 */
	i = verify_area (VERIFY_WRITE, (void *)arg, sizeof (unsigned long));
	if (i)
	    return i;

	for (i = 0; i < MAX_NR_CONSOLES; i++)
	    if (!VT_IS_IN_USE(i))
		break;
	if (i < MAX_NR_CONSOLES)
	    put_user (i + 1, (unsigned long *)arg);
	else
	    put_user (-1, (unsigned long *)arg);
	return 0;

    case VT_ACTIVATE:
	PERM;
	/*
	 * VT activate will cause us to switch to vt #num with num >= 1
	 * (switches to vt0, our console, are not allowed, just to preserve
	 * sanity)
	 */
	if (arg == 0 || arg > MAX_NR_CONSOLES)
	    return -ENXIO;
	vt = vt_con_data + (arg - 1);
	i = vt_allocate (vt);
	if (i)
	    return i;

	vt_changeconsole (vt);
	return 0;

    case VT_WAITACTIVE:
	PERM;
	/*
	 * wait until the specified VT has been activated
	 */
	if (arg == 0 || arg > MAX_NR_CONSOLES)
	    return -ENXIO;
	vt = vt_con_data + (arg - 1);
	while (vt != vtdata.fgconsole) {
	    if (vt_waitonactivate () < 0)
		return -EINTR;
        }
	return 0;

    case VT_RELDISP:
	PERM;
	return vt_reldisp (vt, arg);

    case VT_RESIZE: {
	struct vt_sizes *vtsizes = (struct vt_sizes *)arg;
	ushort ll, cc;

	PERM;

	i = verify_area (VERIFY_READ, (void *)vtsizes, sizeof (struct vt_sizes));
	if (i)
	    return i;
	ll = get_user (&vtsizes->v_rows);
	cc = get_user (&vtsizes->v_cols);
	return vt_resize (cc, ll);
	}

    case KIOCSOUND:
	PERM;
	vt_mksound (arg, 72, 5);
	return 0;

    case KDMKTONE: {
	unsigned int freq  = get_user ((unsigned long *)arg);
	unsigned int vol   = get_user ((unsigned long *)(arg + 4));
	unsigned int ticks = get_user ((unsigned long *)(arg + 8));

	PERM;
	/*
	 * Generate the tone for the apropriate number of ticks.
	 * If time is zero, turn off sound ourselves.
	 */
	vt_mksound (freq, vol, ticks);
	return 0;
	}

    case VT_DISALLOCATE:
	if (arg > MAX_NR_CONSOLES)
	    return -ENXIO;
	return vt_deallocate (arg);

    case VT_GETSCRINFO:
	/*
	 * Get screen dimentions
	 */
	i = verify_area (VERIFY_WRITE, (void *)arg, 5 * sizeof (unsigned long));
	if (!i) {
	    put_user (0, (unsigned long *)arg);
	    put_user (vtdata.numcolumns * 8, (unsigned long *)(arg + 4));
	    put_user (vtdata.numrows * 8, (unsigned long *)(arg + 8));
	    put_user (vtdata.screen.bitsperpix, (unsigned long *)(arg + 12)); /* bpp */
#ifndef HAS_VIDC20
	    put_user (4, (unsigned long *)(arg + 16)); /* depth */
#else
	    put_user (8, (unsigned long *)(arg + 16)); /* depth */
#endif
	}
	return i;

    case VT_LOCKSWITCH:
	if (!suser())
	    return -EPERM;
	vt_dont_switch = 1;
	return 0;

    case VT_UNLOCKSWITCH:
	if (!suser())
	    return -EPERM;
	vt_dont_switch = 0;
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
	PERM;

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
	return kbd_ioctl (vt, cmd, arg);

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
/*
 * Turn the Scroll-Lock LED on when the tty is stopped
 */
static void vt_stop (struct tty_struct *tty)
{
    if (tty) {
	const struct vt *vt = (struct vt *)tty->driver_data;
	if (vt_allocated (vt)) {
	    set_vc_kbd_led (vt->kbd, VC_SCROLLOCK);
	    set_leds ();
	}
    }
}

/*
 * Turn the Scroll-Lock LED off when the tty is started
 */
static void vt_start (struct tty_struct *tty)
{
    if (tty) {
	const struct vt *vt = (struct vt *)tty->driver_data;
	if (vt_allocated (vt)) {
	    clr_vc_kbd_led (vt->kbd, VC_SCROLLOCK);
	    set_leds ();
	}
	if (vt->vtd->xmit_cnt)
	    vt_vtd_flush_chars (vt, vt->vtd);
    }
}

/*
 * vt_throttle and vt_unthrottle are only used for
 * paste_selection(), which has to stuff in a large number
 * of characters...
 */
static void vt_throttle (struct tty_struct *tty)
{
}

static void vt_unthrottle (struct tty_struct *tty)
{
    const struct vt *vt = (struct vt *)tty->driver_data;

    if (vt_allocated (vt))
	wake_up_interruptible (&vt->vtd->paste_wait);
}

/*
 * This is the console switching bottom half handler.
 *
 * Doing console switching in a bottom half handler allows
 * us to do ths switches asynchronously (needed when we want
 * to switch due to a keyboard interrupt), while still giving
 * us the option to easily disable it to avoid races when we
 * need to write to the console.
 */
static void console_bh(void)
{
	if (want_console) {
		if (want_console != vtdata.fgconsole) {
			vt_changeconsole(want_console);
			/* we only changed when the console had already
			   been allocated - a new console is not created
			   in an interrupt routine */
		}
		want_console = NULL;
	}
	if (do_poke_blanked_console) { /* do not unblank for a LED change */
		do_poke_blanked_console = 0;
		vt_pokeblankedconsole();
	}
}

/*
 * We don't have kmalloc setup yet.  We just want to get enough up so that printk
 * can work.
 *
 * Basically, we setup the VT structures for tty1.
 */
unsigned long vt_pre_init (unsigned long kmem)
{
    struct vt *vt = vt_con_data;

    memset (vt_con_data, 0, sizeof (vt_con_data));

    vtdata.numcolumns		= ORIG_VIDEO_COLS;
    vtdata.numrows		= ORIG_VIDEO_LINES;
    vtdata.blanked		= NULL;
    vtdata.fgconsole		= vt_con_data;
    vtdata.screen.blankinterval = 10*60*HZ;
    vtdata.select.vt		= NULL;
    vtdata.select.start		= -1;
    vtdata.select.end		= 0;
    vtdata.select.buffer	= NULL;

    vt->vcd		= (struct con_struct *)kmem;	kmem += sizeof (struct con_struct);
    vt->kbd		= (struct kbd_struct *)kmem;	kmem += sizeof (struct kbd_struct);
    vt->vtd		= (struct vt_struct *)kmem;	kmem += sizeof (struct vt_struct);
    vt->vtd->xmit_buf	= (unsigned char *)kmem;	kmem += CON_XMIT_SIZE;
    vt->vtd->xmitting	= vt->vtd->xmit_cnt =
    vt->vtd->xmit_out	= vt->vtd->xmit_in = 0;
    vt->tty = &vt_table[0];
    vt->num = 1;

    /*
     * vcd_init is called inside vcd_pre_init
     */
    kbd_struct_init (vt, 0);
    vt_reset (vt);
    vt->allocinit = 1;

    kmem = vcd_pre_init (kmem, vt);

    init_bh(CONSOLE_BH, console_bh);

    return kmem;
}

/*
 * This is the post initialisation.  We have kmalloc setup so we can use it...
 */
void vt_post_init (void)
{
    int i;

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
    vt_driver.flush_chars	= vt_flush_chars;
    vt_driver.write_room	= vt_write_room;
    vt_driver.chars_in_buffer	= vt_chars_in_buffer;
#if 0
    vt_driver.flush_buffer	= vt_flush_buffer;
#endif
    vt_driver.ioctl		= vt_ioctl;
    vt_driver.stop		= vt_stop;
    vt_driver.start		= vt_start;
    vt_driver.throttle		= vt_throttle;
    vt_driver.unthrottle	= vt_unthrottle;

    for (i = 1; i < MAX_NR_CONSOLES; i++) {
	struct vt *vt = vt_con_data + i;
	vt->tty = &vt_table[i];
	vt->num = i + 1;
	vt->allocinit = 0;
	if (i < MIN_NR_CONSOLES)
	    vt_allocate (vt);
    }

    if (tty_register_driver (&vt_driver))
	panic ("Couldn't register console driver");

    timer_table[BLANK_TIMER].fn	= vt_blankscreen;
    if (vtdata.screen.blankinterval) {
	timer_table[BLANK_TIMER].expires = jiffies + vtdata.screen.blankinterval;
	timer_active |= 1 << BLANK_TIMER;
    } else
	timer_table[BLANK_TIMER].expires = 0;
}
