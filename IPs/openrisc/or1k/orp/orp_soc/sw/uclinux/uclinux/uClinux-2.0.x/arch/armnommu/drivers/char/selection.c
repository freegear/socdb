/*
 * linux/arch/arm/drivers/char/console/selection.c
 *
 * This module exports the functions:
 *
 *     'int set_selection(const unsigned long arg)'
 *     'void clear_selection(void)'
 *     'int paste_selection(struct tty_struct *tty)'
 *     'int sel_loadlut(const unsigned long arg)'
 *
 * Now that /dev/vcs exists, most of this can disappear again.
 */

#include <linux/tty.h>
#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/malloc.h>
#include <linux/types.h>

#include <asm/segment.h>

#include "vt_kern.h"
#include "consolemap.h"
#include "selection.h"

#ifndef MIN
#define MIN(a,b)	((a) < (b) ? (a) : (b))
#endif

/* Don't take this from <ctype.h>: 011-015 in the buffer aren't spaces */
#define isspace(c)	((c) == ' ')

#define sel_pos(n)	inverse_translate(scrw2glyph(screen_word(vtdata.select.vt, n)))

/*
 * clear_selection, highlight and highlight_pointer can be called
 * from interrupt (via scrollback/front)
 */

/*
 * set reverse video on characters s-e of console with selection.
 */
static inline void highlight (const int s, const int e)
{
	invert_screen(vtdata.select.vt, s, e - s);
}

/*
 * use complementary color to show the pointer
 */
static inline void highlight_pointer (int where)
{
	complement_pos(vtdata.select.vt, where);
}

/*
 * Remove the current selection highlight, if any,
 * from the console holding selection.
 */
void clear_selection (void)
{
	highlight_pointer(-1); /* hide the pointer */
	if (vtdata.select.start != -1) {
		highlight(vtdata.select.start, vtdata.select.end);
		vtdata.select.start = -1;
	}
}

/*
 * User settable table: what characters are to be considered alphabetic?
 * 256 bits
 */
static u32 inwordLut[8]={
  0x00000000, /* control chars     */
  0x03FF0000, /* digits            */
  0x87FFFFFE, /* uppercase and '_' */
  0x07FFFFFE, /* lowercase         */
  0x00000000,
  0x00000000,
  0xFF7FFFFF, /* latin-1 accented letters, not multiplication sign */
  0xFF7FFFFF  /* latin-1 accented letters, not division sign */
};

static inline int inword(const unsigned char c)
{
	return (inwordLut[c>>5] >> (c & 31)) & 1;
}

/*
 * set inwordLut contents.  Invoked by ioctl().
 */
int sel_loadlut(const unsigned long arg)
{
	int i = verify_area(VERIFY_READ, (char *) arg, 36);
	if (i)
		return i;
	memcpy_fromfs(inwordLut, (u32 *)(arg+4), 32);
	return 0;
}

/*
 * does buffer offset p correspond to character at LH/RH edge of screen?
 */
static inline int atedge(const int p)
{
	return (!(p % vtdata.numcolumns) || !((p + 1) % vtdata.numcolumns));
}

/*
 * constrain v such that v <= u
 */
static inline int limit (const int v, const int u)
{
	return ((v > u) ? u : v);
}

/*
 * set the current selection.  Invoked by ioctl().
 */
int set_selection (const unsigned long arg, struct tty_struct *tty)
{
    struct vt * vt = vtdata.fgconsole;
    int sel_mode, new_sel_start, new_sel_end, spc;
    char *bp, *obp;
    int i, ps, pe;

    vt_do_unblankscreen ();

    {
	unsigned short *args, xs, ys, xe, ye;

	args = (unsigned short *)(arg + 1);
	xs = get_user (args ++) - 1;
	ys = get_user (args ++) - 1;
	xe = get_user (args ++) - 1;
	ye = get_user (args ++) - 1;
	sel_mode = get_user (args);

	xs = limit (xs, vtdata.numcolumns - 1);
	ys = limit (ys, vtdata.numrows - 1);
	xe = limit (xe, vtdata.numcolumns - 1);
	ye = limit (ye, vtdata.numrows - 1);
	ps = ys * vtdata.numcolumns + xs;
	pe = ye * vtdata.numcolumns + xe;

	if (sel_mode == 4) {
	    /* useful for screendump without selection highlights */
	    clear_selection ();
	    return 0;
	}

	if (vt->vcd->report_mouse && sel_mode & 16) {
	    mouse_report (tty, sel_mode & 15, xs, ys);
	    return 0;
	}
    }

    if (ps > pe) { /* make sel_start <= sel_end */
	ps ^= pe;
	pe ^= ps;
	ps ^= pe;
    }

    if (vt != vtdata.select.vt) {
	clear_selection ();
	vtdata.select.vt = vt;
    }

    switch (sel_mode) {
    case 0: /* character-by-character selection */
	new_sel_start = ps;
	new_sel_end = pe;
	break;
    case 1: /* word-by-word selection */
	spc = isspace (sel_pos (ps));
	for (new_sel_start = ps; ; ps --) {
	    if (( spc && !isspace (sel_pos (ps))) ||
	        (!spc && !inword (sel_pos (ps))))
		break;
	    new_sel_start = ps;
	    if (!(ps % vtdata.numcolumns))
		break;
	}
	spc = isspace (sel_pos (pe));
	for (new_sel_end = pe; ; pe ++) {
	    if (( spc && !isspace (sel_pos (pe))) ||
	        (!spc && !inword (sel_pos (pe))))
		break;
	    new_sel_end = pe;
	    if (!((pe + 1) % vtdata.numcolumns))
		break;
	}
	break;
    case 2: /* line-by-line selection */
	new_sel_start = ps - ps % vtdata.numcolumns;
	new_sel_end = pe + vtdata.numcolumns - pe % vtdata.numcolumns - 1;
	break;
    case 3:
	highlight_pointer (pe);
	return 0;
    default:
	return -EINVAL;
    }

    /* remove the pointer */
    highlight_pointer (-1);

    /* select to end of line if on trailing space */
    if (new_sel_end > new_sel_start && !atedge(new_sel_end) && isspace(sel_pos(new_sel_end))) {
	for (pe = new_sel_end + 1; ; pe ++)
	    if (!isspace (sel_pos (pe)) || atedge (pe))
		break;
	if (isspace (sel_pos (pe)))
	    new_sel_end = pe;
    }
    if (vtdata.select.start == -1)			/* no current selection */
	highlight (new_sel_start, new_sel_end);
    else if (new_sel_start == vtdata.select.start) {
	if (new_sel_end == vtdata.select.end)		/* no action required */
	    return 0;
	else if (new_sel_end > vtdata.select.end)	/* extend to right */
	    highlight (vtdata.select.end + 1, new_sel_end);
	else						/* contract from right */
	    highlight (new_sel_end + 1, vtdata.select.end);
    } else if (new_sel_end == vtdata.select.end) {
	if (new_sel_start < vtdata.select.start)	/* extend to left */
	    highlight (new_sel_start, vtdata.select.start - 1);
	else				/* contract from left */
	    highlight (vtdata.select.start, new_sel_start - 1);
    } else {	/* some other case; start selection from scratch */
	clear_selection ();
	highlight (new_sel_start, new_sel_end);
    }
    vtdata.select.start = new_sel_start;
    vtdata.select.end = new_sel_end;

    if (vtdata.select.buffer)
	kfree (vtdata.select.buffer);
    vtdata.select.buffer = kmalloc (vtdata.select.end - vtdata.select.start + 1, GFP_KERNEL);
    if (!vtdata.select.buffer) {
	printk ("selection: kmalloc() failed\n");
	clear_selection ();
	return -ENOMEM;
    }

    obp = bp = vtdata.select.buffer;
    for (i = vtdata.select.start; i <= vtdata.select.end; i++) {
	*bp = sel_pos (i);
	if (!isspace (*bp++))
	    obp = bp;
	if (!((i + 1) % vtdata.numcolumns)) {
	    /* strip trailing blanks from line and add newline,
	     * unless non-space at end of line.
	     */
	    if (obp != bp) {
		bp = obp;
		*bp++ = '\r';
	    }
	    obp = bp;
	}
    }
    vtdata.select.length = bp - vtdata.select.buffer;
    return 0;
}

/* Insert the contents of the selection buffer into the queue of the
 * tty associated with the current console. Invoked by ioctl().
 */
int paste_selection (struct tty_struct *tty)
{
	struct wait_queue wait = { current, NULL };
	struct vt_struct *vt = ((struct vt *)tty->driver_data)->vtd;
	char	*bp = vtdata.select.buffer;
	int	c = vtdata.select.length;
	int	l;

	if (!bp || !c)
		return 0;
	vt_do_unblankscreen ();
	add_wait_queue(&vt->paste_wait, &wait);
	do {
		current->state = TASK_INTERRUPTIBLE;
		if (test_bit(TTY_THROTTLED, &tty->flags)) {
			schedule();
			continue;
		}
		l = MIN(c, tty->ldisc.receive_room(tty));
		tty->ldisc.receive_buf(tty, bp, 0, l);
		c -= l;
		bp += l;
	} while (c);
	remove_wait_queue(&vt->paste_wait, &wait);
	current->state = TASK_RUNNING;
	return 0;
}

