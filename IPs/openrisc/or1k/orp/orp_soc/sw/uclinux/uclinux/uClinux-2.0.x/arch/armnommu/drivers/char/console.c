/*
 * linux/arch/arm/drivers/char/console.c
 *
 * Modifications (C) 1995, 1996 Russell King
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
 *	'unsigned long con_init(unsigned long)'
 * S	'int con_open(struct tty_struct *tty,struct file *filp)'
 * S	'void con_write(struct tty_struct *tty)'
 * S	'void console_print(const char *b)'
 *
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

#define BLANK 0x0020

/* A bitmap for codes <32. A bit of 1 indicates that the code
 * corresponding to that bit number invokes a special action
 * (such as cursor movement) and should not be displayed as a
 * glyph unless the disp_ctrl mode is explicitly enabled.
 */
#define CTRL_ACTION 0x0d00ff81
#define CTRL_ALWAYS 0x0800f501  /* Cannot be overriden by disp_ctrl */

/*
 * Here is the default bell parameters: 750HZ, 1/8th of a second
 */
#define DEFAULT_BELL_PITCH	750
#define DEFAULT_BELL_DURATION	(HZ/8)

/*
 *  NOTE!!! We sometimes disable and enable interrupts for a short while
 * (to put a word in video IO), but this will work even for keyboard
 * interrupts. We know interrupts aren't enabled when getting a keyboard
 * interrupt, as we use trap-gates. Hopefully all is well.
 */
 
#include <linux/config.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/interrupt.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/kd.h>
#include <linux/major.h>
#include <linux/malloc.h>
#include <linux/mm.h>

#include <asm/io.h>
#include <asm/segment.h>
#include <asm/irq.h>
#include <asm/hardware.h>

#define DEBUG

#include "kbd_kern.h"
#include "consolemap.h"
#include "vt_kern.h"
#include "selection.h"

#define set_kbd(x) set_vc_kbd_mode (vt->kbd, x)
#define clr_kbd(x) clr_vc_kbd_mode (vt->kbd, x)
#define is_kbd(x)  vc_kbd_mode (vt->kbd, x)

#define decarm		VC_REPEAT
#define decckm		VC_CKMODE
#define kbdapplic	VC_APPLIC
#define lnm		VC_CRLF

/*
 * this is what the terminal answers to a ESC-Z or csi0c query.
 */
#define VT100ID "\033[?1;2c"
#define VT102ID "\033[?6c"

extern int setup_arm_irq(int, struct irqaction *);

/*
 * routines to load custom translation table, EGA/VGA font and
 * VGA colour palette from console.c
 */
extern int con_set_trans_old(unsigned char * table);
extern int con_get_trans_old(unsigned char * table);
extern int con_set_trans_new(unsigned short * table);
extern int con_get_trans_new(unsigned short * table);
extern void con_clear_unimap(struct unimapinit *ui);
extern int con_set_unimap(ushort ct, struct unipair *list);
extern int con_get_unimap(ushort ct, ushort *uct, struct unipair *list);
extern void con_set_default_unimap(void);
extern int con_set_font(char * fontmap);
extern int con_get_font(char * fontmap);


/* ARM Extensions */
#if defined(HAS_VIDC)

extern void memc_write (int reg, int val);
extern void vidc_write (int reg, int val);
static int __r;
#define palette_setpixel(p) __r = p
#define palette_write(v)			\
{						\
  int rr = __r++, red, green, blue, vv = (v);	\
  red   = (vv >> 4)  & 0x00f;			\
  green = (vv >> 8)  & 0x0f0;			\
  blue  = (vv >> 12) & 0xf00;			\
  outl((rr<<26)|red|green|blue, IO_VIDC_BASE);	\
}

#define MAX_PIX 16

#elif defined(HAS_VIDC20)
#define palette_setpixel(p)	outl(0x10000000|((p) & 255), IO_VIDC_BASE)
#define palette_write(v)	outl(0x00000000|((v) & 0x00ffffff), IO_VIDC_BASE)
#define MAX_PIX 256
#endif

/*
 * from ll_wr_char.S
 */
int bytes_per_char_h, bytes_per_char_v, video_size_row;
extern void ll_write_char(unsigned long ps, unsigned long chinfo);
extern unsigned long con_charconvtable[256];
extern unsigned long map_screen_mem (unsigned long vid_base, unsigned long kmem, int remap);
#include <linux/ctype.h>

extern struct console_driver screen_driver, buffer_driver;

#ifndef MIN
#define MIN(a,b)	((a) < (b) ? (a) : (b))
#endif

static void gotoxy (struct con_struct *vcd, int new_x, int new_y);
static inline void set_cursor (const struct vt * const vt);
extern void reset_vc(const struct vt * const vt);
extern void register_console(void (*proc)(const char *));
extern void compute_shiftstate(void);
extern void con_reset_palette (const struct vt * const vt);
extern void con_set_palette (const struct vt * const vt);

static int printable;				/* Is console ready for printing? */

#define console_charmask 0xff
#ifndef console_charmask
static unsigned short console_charmask = 0x0ff;
#endif

#include "font.h"

static const unsigned long palette_1[MAX_PIX] = {
	0x00000000,		/* Black   */
	0x00ffffff,		/* White   */
	0x00000000		/* Black   */
};

static const unsigned long palette_4[MAX_PIX] = {
	0x00000000,		/* Black   */
	0x000000cc,		/* Red     */
	0x0000cc00,		/* Green   */
	0x0000cccc,		/* Yellow  */
	0x00cc0000,		/* Blue    */
	0x00cc00cc,		/* Magenta */
	0x00cccc00,		/* Cyan    */
	0x00cccccc,		/* White   */
	0x00000000,
	0x000000ff,
	0x0000ff00,
	0x0000ffff,
	0x00ff0000,
	0x00ff00ff,
	0x00ffff00,
	0x00ffffff
};

#if defined(HAS_VIDC)
static const unsigned long palette_8[MAX_PIX] = {
	0x00000000,
	0x00111111,
	0x00222222,
	0x00333333,
	0x00440000,
	0x00551111,
	0x00662222,
	0x00773333,
	0x00000044,
	0x00111155,
	0x00222266,
	0x00333377,
	0x00440044,
	0x00551155,
	0x00662266,
	0x00773377
};
#elif defined(HAS_VIDC20)
#define palette_8 palette_4
#endif

static const unsigned long *default_palette_entries = palette_4;

static const unsigned char color_1[] = {0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1 };
static const unsigned char color_4[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 };
#if defined(HAS_VIDC)
static const unsigned char color_8[] = {0x00, 0x18, 0x60, 0x78, 0x84, 0x9C, 0xE4, 0xFC,
					0x00, 0x1B, 0x63, 0x7B, 0x87, 0x9F, 0xE7, 0xFF};
#elif defined(HAS_VIDC20)
static const unsigned char color_8[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 };
#endif
static const unsigned char *color_table = color_4;

/*===================================================================================*/

#ifdef CONFIG_SERIAL_ECHO
#include "serialecho.c"
#endif

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
	if (vma_offset > vtdata.screen.memsize ||
	    vma_end - vma_start + vma_offset > vtdata.screen.memsize)
		return -EINVAL;
	return remap_page_range(vma_start, SCREEN2_BASE + vma_offset,
				vma_end - vma_start, prot);
}

#ifdef DEBUG
static int vcd_validate (struct con_struct *vcd, const char *msg)
{
    unsigned long old_scrorigin, old_scrpos, old_buforigin, old_bufpos, w = 0;

    old_scrorigin = vcd->screen.origin;
    old_scrpos = vcd->screen.pos;
    old_buforigin = vtdata.buffer.origin;
    old_bufpos = vcd->buffer.pos;
    if (vcd->screen.origin < SCREEN1_BASE || vcd->screen.origin > SCREEN1_END) {
	vcd->screen.origin = SCREEN2_BASE;
	w = 1;
    }
    if (vcd->screen.pos < SCREEN1_BASE || vcd->screen.pos > SCREEN2_END) {
	vcd->screen.pos = SCREEN2_BASE;
	w = 1;
    }
    
    if (w)
	printk ("*** CONSOLE ERROR: %s: (%p): origin = %08lX pos = %08lX ***\n",
				msg, vcd, old_scrorigin, old_scrpos);
    return w;
}
#endif

void no_scroll(char *str, int *ints)
{
}

static unsigned long __origin;		/* Offset of currently displayed screen */

static void __set_origin(unsigned long offset)
{
	unsigned long flags;

	clear_selection ();

	offset = offset - vtdata.screen.memstart;
	if (offset >= vtdata.screen.memsize)
		offset -= vtdata.screen.memsize;

	save_flags_cli (flags);
	__origin = offset;
	video_set_dma(0, vtdata.screen.memsize, offset);
	restore_flags(flags);
}

void scrollback(int lines)
{
}

void scrollfront(int lines)
{
}

void scroll_set_origin (unsigned long offset)
{
	__set_origin(offset);
}

static void set_origin (const struct vt * const vt)
{
	if (vtdata.fgconsole != vt || vt->vtd->vc_mode == KD_GRAPHICS)
		return;
	__set_origin(vt->vcd->screen.origin);
}

/* -------------------------------------------------------------------------------
 * Cursor
 * ------------------------------------------------------------------------------- */

static char cursor_on = 0;
static unsigned long cp;

static void put_cursor(char on_off,unsigned long newcp)
{
	static char con;
	unsigned long cp_p = cp;
	int c = vtdata.screen.bytespercharh == 8 ? color_table[15] : 0x11 * color_table[15];
	int i;

	if (vtdata.fgconsole->vtd->vc_mode == KD_GRAPHICS)
		return;

	cp = newcp;

	if (con != on_off) {
		if (cp_p != -1)
			for (i = 0; i < vtdata.screen.bytespercharh; i++)
				((unsigned char*)cp_p)[i]^=c;
		con = on_off;
	}
}

static void vsync_irq(int irq, void *dev_id, struct pt_regs *regs)
{
	static char cursor_flash = 16;

	if (!--cursor_flash) {
		cursor_flash = 16;
		cursor_on = cursor_on ? 0 : 1;
		if (vtdata.fgconsole->vcd->screen.cursoron > 0)
			put_cursor(cursor_on,cp);
	}
}

static void hide_cursor(void)
{
	put_cursor (0, -1);
}

static void set_cursor (const struct vt * const vt)
{
	unsigned long flags;

	if (vt != vtdata.fgconsole || vt->vtd->vc_mode == KD_GRAPHICS)
		return;

	save_flags_cli (flags);
	if (vt->vcd->deccm) {
#ifdef DEBUG
    		vcd_validate (vt->vcd, "set_cursor");
#endif
		cp = vt->vcd->screen.pos + vtdata.numcolumns *
			vtdata.screen.bytespercharh * (vtdata.screen.bytespercharv - 1);
	} else
		hide_cursor();
	restore_flags(flags);
}

static void vcd_removecursors (const struct vt *vt)
{
	unsigned long flags;

	save_flags_cli (flags);

	if (--vt->vcd->screen.cursoron == 0 && vtdata.fgconsole == vt)
		put_cursor (0, cp);

	restore_flags (flags);
}

static void vcd_restorecursors(const struct vt *vt)
{
	unsigned long flags;

	save_flags_cli (flags);

	if (++vt->vcd->screen.cursoron == 1 && cursor_on && vtdata.fgconsole == vt)
		put_cursor (1, cp);

	restore_flags (flags);
}

/* -----------------------------------------------------------------------------------------
 * VC stuff
 * ----------------------------------------------------------------------------------------- */
/*
 * gotoxy() must verify all boundaries, because the arguments
 * might also be negative. If a given position is out of
 * bounds, the cursor is placed at the nearest margin.
 */
static void gotoxy (struct con_struct *vcd, int new_x, int new_y)
{
    int min_y, max_y;

    if (new_x < 0)
	vcd->curstate.x = 0;
    else
    if (new_x >= vtdata.numcolumns)
	vcd->curstate.x = vtdata.numcolumns - 1;
    else
	vcd->curstate.x = new_x;

    if (vcd->decom) {
	new_y += vcd->top;
	min_y = vcd->top;
	max_y = vcd->bottom;
    } else {
	min_y = 0;
	max_y = vtdata.numrows;
    }

    if (new_y < min_y)
	vcd->curstate.y = min_y;
    else if (new_y >= max_y)
	vcd->curstate.y = max_y - 1;
    else
	vcd->curstate.y = new_y;

    vcd->driver.gotoxy (vcd);
    vcd->need_wrap = 0;
#ifdef DEBUG
    vcd_validate (vcd, "gotoxy");
#endif
}

/* for absolute user moves, when decom is set */
static void gotoxay (struct con_struct *vcd, int new_x, int new_y)
{
    gotoxy(vcd, new_x, vcd->decom ? (vcd->top+new_y) : new_y);
}

static void update_attr (const struct vt * const vt)
{
    unsigned int backcol, forecol;

    backcol = color_table[vt->vcd->curstate.backcol];
    if (vt->vcd->curstate.flags & FLG_BOLD)
	forecol = color_table[vt->vcd->curstate.forecol + 8];
    else
	forecol = color_table[vt->vcd->curstate.forecol];
    vt->vcd->combined_state = (vt->vcd->curstate.flags << 24) |
			      (backcol << 16) |
			      (forecol << 8);
    switch (vtdata.screen.bitsperpix) {
    case 1:
	vt->vcd->cached_backcolwrd = 0;
	break;
    default:
    case 4:
	vt->vcd->cached_backcolwrd = 0x11111111 * backcol;
	break;
    case 8:
	vt->vcd->cached_backcolwrd = 0x01010101 * backcol;
	break;
    }
}

static void default_attr (const struct vt * const vt)
{
    vt->vcd->curstate.flags &= ~(FLG_INVERSE|FLG_FLASH|FLG_UNDERLINE|FLG_ITALIC|FLG_BOLD);
    vt->vcd->curstate.forecol = vt->vcd->def_forecol;
    vt->vcd->curstate.backcol = vt->vcd->def_backcol;
}

static int csi_m (const struct vt * const vt)
{
    struct con_struct *vcd = vt->vcd;
    int i, ret = 0;

    for (i = 0; i <= vcd->npar; i++) {
	switch (vcd->par[i]) {
	case 0:
	    default_attr (vt);
	    break;
	case 1:
	    vcd->curstate.flags |= FLG_BOLD;
	    break;	/* Bold */
	case 2:
	    vcd->curstate.flags &= ~FLG_BOLD;
	    break;	/* Feint */
	case 3:
	    vcd->curstate.flags |= FLG_ITALIC;
	    break;	/* Italic */
	case 4:
	    vcd->curstate.flags |= FLG_UNDERLINE;
	    break;	/* Underline */
	case 5:
	case 6:
	    vcd->curstate.flags |= FLG_FLASH;
	    break;	/* Flash */
	case 7:
	    vcd->curstate.flags |= FLG_INVERSE;
	    break;	/* Inverse chars */

	case 10:
	    /* ANSI X3.64-1979 (SCO-ish?)
	     * Select primary font, don't display
	     * control chars if defined, don't set
	     * bit 8 on output.
	     */
	    vcd->translate = set_translate(vcd->curstate.flags & FLG_CHRSET
				? vcd->curstate.G1_charset
				: vcd->curstate.G0_charset);
	    vcd->disp_ctrl = 0;
	    vcd->toggle_meta = 0;
	    ret = 1;
	    break;
	case 11:
	    /* ANSI X3.64-1979 (SCO-ish?)
	     * Select first alternate font, let's
	     * chars < 32 be displayed as ROM chars.
	     */
	    vcd->translate = set_translate(IBMPC_MAP);
	    vcd->disp_ctrl = 1;
	    vcd->toggle_meta = 0;
	    ret = 1;
	    break;
	case 12:
	    /* ANSI X3.64-1979 (SCO-ish?)
	     * Select second alternate font, toggle
	     * high bit before displaying as ROM char.
	     */
	    vcd->translate = set_translate(IBMPC_MAP);
	    vcd->disp_ctrl = 1;
	    vcd->toggle_meta = 1;
	    ret = 1;
	    break;
	case 21:
	case 22:
	    vcd->curstate.flags &= ~FLG_BOLD;
	    break;
	case 24:
	    vcd->curstate.flags &= ~FLG_UNDERLINE;
	    break;
	case 25:
	    vcd->curstate.flags &= ~FLG_FLASH;
	    break;
	case 27:
	    vcd->curstate.flags &= ~FLG_INVERSE;
	    break;
	case 30:
	case 31:
	case 32:
	case 33:
	case 34:
	case 35:
	case 36:
	case 37:
	    vcd->curstate.forecol = vcd->par[i]-30;
	    break;						/* Foreground colour */
	case 38:
	    vcd->curstate.forecol = vcd->def_forecol;
	    vcd->curstate.flags &= ~FLG_UNDERLINE;
	    break;
	case 39:
	    vcd->curstate.forecol = vcd->def_forecol;
	    vcd->curstate.flags &= ~FLG_UNDERLINE;
	    break;						/* Default foreground colour */
	case 40:
	case 41:
	case 42:
	case 43:
	case 44:
	case 45:
	case 46:
	case 47:
	    vcd->curstate.backcol = vcd->par[i]-40;
	    break;						/* Background colour */
	case 49:
	    vcd->curstate.backcol = vcd->def_backcol;
	    break;						/* Default background colour */
	}
    }
    update_attr (vt);
    return ret;
}

static void respond_string (char *p, struct tty_struct *tty)
{
    while (*p)
	tty_insert_flip_char (tty, *p++, 0);
    tty_schedule_flip (tty);
}

static void cursor_report (const struct vt *vt)
{
    char buf[40];

    sprintf (buf, "\033[%d;%dR", vt->vcd->curstate.y + (vt->vcd->decom ? vt->vcd->top + 1 : 1),
				     vt->vcd->curstate.x + 1);
    respond_string (buf, *vt->tty);
}

static void status_report (struct tty_struct *tty)
{
    respond_string ("\033[0n", tty);
}

static void respond_ID (struct tty_struct *tty)
{
    respond_string(VT102ID, tty);
}

void mouse_report (struct tty_struct *tty, int butt, int mrx, int mry)
{
    char buf[8];

    sprintf (buf,"\033[M%c%c%c", (char)(' ' + butt), (char)('!' + mrx),
	(char)('!'+mry));
    respond_string(buf, tty);
}

/* invoked by ioctl(TIOCLINUX) */
int mouse_reporting (void)
{
    return vtdata.fgconsole->vcd->report_mouse;
}

static inline unsigned long screenpos (const struct vt * const vt, int offset)
{
    int hx, hy;

    hx = offset % vtdata.numcolumns;
    hy = offset / vtdata.numcolumns;
    return vt->vcd->screen.origin + hy * vtdata.screen.sizerow + hx * vtdata.screen.bytespercharh;
}

void invert_screen (const struct vt * const vt, unsigned int offset, unsigned int count)
{
    struct con_struct *vcd = vt->vcd;
    unsigned long *buffer = vcd->driver.buffer_pos(vcd, offset);
    unsigned long p, pp;
    int i;

    for (i = 0; i <= count; i++)
	buffer[i] ^= FLG_INVERSE << 24;

    if (vt == vtdata.fgconsole) {
	int hx, hy, hex, hey;

	hx = offset % vtdata.numcolumns;
	hy = offset / vtdata.numcolumns;
	hex = (offset + count) % vtdata.numcolumns;
	hey = (offset + count) / vtdata.numcolumns;

	p = vcd->screen.origin + hy * vtdata.screen.sizerow;
	pp = p + hx * vtdata.screen.bytespercharh;
	for (;hy <= hey; hy ++) {
	    for (; hx < ((hy == hey) ? hex + 1 : vtdata.numcolumns); hx ++) {
		ll_write_char (pp, *buffer++);
		pp += vtdata.screen.bytespercharh;
	    }
	    hx = 0;
	    pp = p += vtdata.screen.sizerow;
	}       
    }
}

void complement_pos (const struct vt * const vt, unsigned int offset)
{
    static unsigned long old = 0;
    static unsigned long p = 0;
    unsigned long complement;

    switch (vtdata.screen.bitsperpix) {
    case 4:
	complement = 0x00070700;
	break;
    case 8:
#ifndef HAS_VIDC20
	complement = 0x00fcfc00;
#else
	complement = 0x00070700;
#endif
	break;
    default:
	complement = 0;
    }

    if (p)
	ll_write_char (p, old);
    if ((int)offset == -1)
	p = 0;
    else {
	old = *vt->vcd->driver.buffer_pos(vt->vcd, offset);
	p = screenpos (vt, offset);
	ll_write_char (p, old ^ complement);
    }
}

unsigned long screen_word (const struct vt * const vt, unsigned int offset)
{
    return *vt->vcd->driver.buffer_pos (vt->vcd, offset);
}

int scrw2glyph (unsigned long scr_word)
{
    return scr_word & 255;
}

unsigned long *screen_pos (const struct vt * const vt, unsigned int offset)
{
    return vt->vcd->driver.buffer_pos (vt->vcd, offset);
}

void getconsxy (const struct vt * const vt, char *p)
{
    p[0] = vt->vcd->curstate.x;
    p[1] = vt->vcd->curstate.y;
}

void putconsxy (const struct vt * const vt, char *p)
{
    gotoxy (vt->vcd, p[0], p[1]);
    set_cursor (vt);
}

static void csi_J (const struct vt * const vt, int vpar);

static void set_mode (const struct vt * const vt, int on_off)
{
    struct con_struct *vcd = vt->vcd;
    int i;

    for (i = 0; i <= vcd->npar; i++)
	if (vcd->ques)
	    switch(vcd->par[i]) {	/* DEC private modes set/reset */
	    case 1:			/* Cursor keys send ^[Ox/^[[x */
		if (on_off)
		    set_kbd(decckm);
		else
		    clr_kbd(decckm);
		break;
	    case 3:		/* 80/132 mode switch unimplemented */
		vcd->deccolm = on_off;
		csi_J (vt, 2);
		gotoxy (vcd, 0, 0);
		break;
	    case 5:		/* Inverted screen on/off */
		if (vcd->decscnm != on_off) {
		    vcd->decscnm = on_off;
		    invert_screen (vt, 0, vtdata.buffer.totsize);
		    update_attr (vt);
		}
		break;
	    case 6:		/* Origin relative/absolute */
		vcd->decom = on_off;
		gotoxay (vcd, 0, 0);
		break;
	    case 7:		/* Autowrap on/off */
		vcd->decawm = on_off;
		break;
	    case 8:		/* Autorepeat on/off */
		if (on_off)
		    set_kbd(decarm);
		else
		    clr_kbd(decarm);
		break;
	    case 9:
		vcd->report_mouse = on_off ? 1 : 0;
		break;
	    case 25:		/* Cursor on/off */
		vcd->deccm = on_off;
		set_cursor (vt);
		break;
	    case 1000:
		vcd->report_mouse = on_off ? 2 : 0;
		break;
	    }
	else
	    switch(vcd->par[i]) {	/* ANSI modes set/reset */
	    case 3:			/* Monitor (display ctrls) */
		vcd->disp_ctrl = on_off;
		break;
	    case 4:			/* Insert mode on/off */
		vcd->decim = on_off;
		break;
	    case 20:			/* Lf, Enter = CrLf/Lf */
		if (on_off)
		    set_kbd(lnm);
		else
		    clr_kbd(lnm);
		break;
	    }
}

static void setterm_command (const struct vt * const vt)
{
	struct con_struct *vcd = vt->vcd;	
	switch (vt->vcd->par[0]) {
		case 1: /* Set colour for underline mode (implemented as an underline) */
		case 2: /* set colour for half intensity mode (unimplemented) */
			break;
		case 8:
			vcd->def_forecol = vcd->curstate.forecol;
			vcd->def_backcol = vcd->curstate.backcol;
			break;
		case 9:
			vtdata.screen.blankinterval =
				((vcd->par[1] < 60) ? vcd->par[1] : 60) * 60 * HZ;
			vt_pokeblankedconsole ();
			break;
		case 10: /* set bell frequency in Hz */
			if (vcd->npar >= 1)
				vcd->bell_pitch = vcd->par[1];
			else
				vcd->bell_pitch = DEFAULT_BELL_PITCH;
			break;
		case 11: /* set bell duration in msec */
			if (vcd->npar >= 1)
				vcd->bell_duration = (vcd->par[1] < 2000) ?
					vcd->par[1]*HZ/1000 : 0;
			else
				vcd->bell_duration = DEFAULT_BELL_DURATION;
			break;
		case 12: { /* bring specified console to the front */
			int arg = vcd->par[1];
			if (arg >= 1 && vt_allocated(vt_con_data + (arg - 1) ))
				vt_updatescreen(vt_con_data + (arg - 1));
			break;
			}
		case 13: /* unblank the screen */
			vt_do_unblankscreen ();
			break;
		case 14: /* set vesa powerdown interval */
#if todo
			vesa_off_interval = ((vcd->par[1] < 60) ? vcd->par[1] : 60) * 60 * HZ;
#endif
			break;
	}
}

static void csi_J (const struct vt * const vt, int vpar)
{
    unsigned char endx, endy;
    unsigned char startx, starty;

    switch (vpar) {
    case 0: /* erase from cursor to bottom of screen (including char at (x, y) */
	startx = vt->vcd->curstate.x;
	starty = vt->vcd->curstate.y;
	endx   = vtdata.numcolumns - 1;
	endy   = vtdata.numrows - 1;
	break;
    case 1: /* erase from top of screen to cursor (including char at (x, y) */
	startx = 0;
	starty = 0;
	endx   = vt->vcd->curstate.x;
	endy   = vt->vcd->curstate.y;
	break;
    case 2: /* erase entire screen */
	startx = 0;
	starty = 0;
	endx   = vtdata.numcolumns - 1;
	endy   = vtdata.numrows - 1;
#if TODO
	origin = video_mem_base;
	set_origin (currcons);
	gotoxy (currcons, x, y);
#endif
	break;
    default:
	return;
    }
    vt->vcd->driver.erase (vt->vcd, startx, starty, endx, endy);
    /*vt->vcd->need_wrap = 0; why? We don't move the cursor... */
}

static void csi_K (const struct vt * const vt, int vpar)
{
    unsigned char endx;
    unsigned char startx;

    switch(vpar) {
    case 0: /* erase from cursor to end of line */
	startx = vt->vcd->curstate.x;
	endx   = vtdata.numcolumns - 1;
	break;
    case 1: /* erase from beginning of line to cursor */
	startx = 0;
	endx   = vt->vcd->curstate.x;
	break;
    case 2: /* erase entire line */
	startx = 0;
	endx   = vtdata.numcolumns - 1;
	break;
    default:
	return;
    }
    vt->vcd->driver.erase(vt->vcd, startx, vt->vcd->curstate.y, endx, vt->vcd->curstate.y);
    /*vt->vcd->need_wrap = 0; why? We don't move the cursor... */
}

static void csi_X (const struct vt * const vt, int vpar) /* erase the following vpar positions */
{							 /* not vt100? */
    unsigned char countx, county;
    unsigned char startx, starty;

    if (!vpar)
	vpar++;

    startx = vt->vcd->curstate.x;
    starty = vt->vcd->curstate.y;
    countx = 0;
    county = 0;
#if TODO
    vt->vcd->driver.erase(vt->vcd,startx,starty,countx,county);
#endif
    /*vt->vcd->need_wrap = 0; why? We don't move the cursor... */
}

static void csi_at (const struct vt * const vt, int nr)
{
    if (nr > vtdata.numcolumns - vt->vcd->curstate.x)
	nr = vtdata.numcolumns - vt->vcd->curstate.x;
    else if (!nr)
	nr = 1;
    vt->vcd->driver.insert_char(vt->vcd, nr);
}

static void csi_L (const struct vt * const vt, int nr)
{
    if (nr > vtdata.numrows - vt->vcd->curstate.y)
	nr = vtdata.numrows - vt->vcd->curstate.y;
    else if (!nr)
	nr = 1;
    vt->vcd->driver.scroll_down (vt->vcd, vt->vcd->curstate.y, vt->vcd->bottom, nr);
/*  vt->vcd->need_wrap = 0; why? We haven't moved the cursor. */
}

static void csi_P (const struct vt * const vt, int nr)
{
    if (nr > vtdata.numcolumns)
	nr = vtdata.numcolumns;
    else if (!nr)
	nr = 1;
    vt->vcd->driver.delete_char(vt->vcd, nr);
}

static void csi_M (const struct vt * const vt, int nr)
{
    if (nr > vtdata.numrows)
	nr = vtdata.numrows;
    else if (!nr)
	nr = 1;
    vt->vcd->driver.scroll_up (vt->vcd, vt->vcd->curstate.y, vt->vcd->bottom, nr);
/*  vt->vcd->need_wrap = 0; why? we haven't moved the cursor. */
}

enum { ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
	ESpalette };

static void reset_terminal (const struct vt * const vt, int initialising)
{
    struct con_struct *vcd;

    vcd = vt->vcd;

    vcd->top			= 0;
    vcd->bottom 		= vtdata.numrows;
    vcd->state			= ESnormal;
    vcd->ques			= 0;
    vcd->translate		= set_translate (LAT1_MAP);
    vcd->curstate.G0_charset	= LAT1_MAP;
    vcd->curstate.G1_charset	= GRAF_MAP;
    vcd->curstate.flags 	= 0;
    vcd->need_wrap		= 0;
    vcd->report_mouse		= 0;
    vcd->utf			= 0;
    vcd->utf_count		= 0;
    vcd->disp_ctrl		= 0;
    vcd->toggle_meta		= 0;
    vcd->decscnm		= 0;
    vcd->decom			= 0;
    vcd->decawm 		= 1;
    vcd->deccm			= 1;
    vcd->decim			= 0;
    vcd->curstate.forecol	= 7;
    vcd->curstate.backcol	= 0;
    vcd->def_forecol		= 7;
    vcd->def_backcol		= 0;
    vcd->tab_stop[0]		= 0x01010100;
    vcd->tab_stop[1]		=
    vcd->tab_stop[2]		=
    vcd->tab_stop[3]		=
    vcd->tab_stop[4]		= 0x01010101;

    set_kbd (decarm);
    clr_kbd (decckm);
    clr_kbd(kbdapplic);
    clr_kbd(lnm);

    vt->kbd->lockstate		= 0;
    vt->kbd->ledmode		= LED_SHOW_FLAGS;
    vt->kbd->ledflagstate	= vt->kbd->default_ledflagstate;
    if (!initialising)
	set_leds ();

    if (vcd->screen.palette_entries) {
	kfree (vcd->screen.palette_entries);
	vcd->screen.palette_entries = 0;
    }

    gotoxy (vcd, 0, 0);
    vcd->savedstate = vcd->curstate;
    update_attr (vt);

    if (!initialising)
	csi_J (vt, 2);
}


static inline void update_palette(const struct vt * const vt)
{
	const unsigned long *palette_entries;
	int i;

	if (vt->vcd->screen.palette_entries || vt->vtd->vc_mode != KD_GRAPHICS)
		palette_entries = default_palette_entries;
	else
		palette_entries = vt->vcd->screen.palette_entries;

	palette_setpixel(0);
	for (i = MAX_PIX; i > 3; i -= 4) {
		palette_write(*palette_entries++);
		palette_write(*palette_entries++);
		palette_write(*palette_entries++);
		palette_write(*palette_entries++);
	}
	for (; i > 0; i--)
		palette_write(*palette_entries++);
}

void update_scrmem (const struct vt * const vt, int start, int length)
{
	unsigned long p, pp, sx, sy, ex, ey;
	unsigned long *buffer;

	length += start;
	sy = start / vtdata.numcolumns;
	sx = start % vtdata.numcolumns;
	ey = length / vtdata.numcolumns;
	ex = length % vtdata.numcolumns;

	if (ey > vtdata.numrows)
		ey = vtdata.numrows;

	p = vt->vcd->screen.origin + sy * vtdata.screen.sizerow;
	buffer = vt->vcd->buffer.buffer + start;

	if (ey > sy) {
		for (; sy < ey; sy++) {
			pp = p + sx * vtdata.screen.bytespercharh;
			for (; sx < vtdata.numcolumns; sx++) {
				ll_write_char (pp, *buffer++);
				pp += vtdata.screen.bytespercharh;
			}
			p += vtdata.screen.sizerow;
			sx = 0;
		}
	}

	if (ey == sy && ex) {
		for (; sx < ex; sx++) {
			ll_write_char (p, *buffer++);
			p += vtdata.screen.bytespercharh;
		}
	}
}

void set_scrmem (const struct vt * const vt, long offset)
{
    unsigned long p, pp, my, by;
    unsigned long *buffer;

    p = vt->vcd->screen.origin;
    buffer = vt->vcd->buffer.buffer;

    by = vtdata.screen.sizerow;
    for (my = vtdata.numrows; my > 0; my--) {
	int mx, bx = vtdata.screen.bytespercharh;
	pp = p;
	mx = vtdata.numcolumns;
	while (mx > 8) {
	    mx -= 8;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	    ll_write_char (pp, *buffer++); pp += bx;
	}
	while (mx > 0) {
	    mx -= 1;
	    ll_write_char (pp, *buffer++); pp += bx;
	}
	p += by;
    }
    pp = vt->vcd->screen.origin + vtdata.screen.memsize;
    memsetl((unsigned long *)p, vt->vcd->cached_backcolwrd, pp - p);
    update_palette(vt);
}

/*
 * PIO_FONT support
 */
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
	update_palette(vt);
}

/* == arm specific console code ============================================================== */

int do_screendump(int arg)
{
    char *buf = (char *)arg;
    int l;
    if (!suser())
	return -EPERM;
    l = verify_area (VERIFY_WRITE, buf, 2);
    if (l)
	return l;
    return -ENOSYS;
}

void vcd_disallocate (struct vt *vt)
{
	if (vt->vcd && vt->vcd->buffer.kmalloced) {
		vfree (vt->vcd->buffer.buffer);
		vt->vcd->buffer.buffer = NULL;
		vt->vcd->buffer.kmalloced = 0;
	}
}

int vcd_resize(unsigned long lines, unsigned long cols)
{/* TODO */
	return -ENOMEM;
}

void vcd_blankscreen(int nopowersave)
{
	unsigned int pix;

    /* DISABLE VIDEO */
	palette_setpixel(0);
	for (pix = 0; pix < MAX_PIX; pix++)
		palette_write(0);
}

void vcd_unblankscreen (void)
{
	update_palette(vtdata.fgconsole);
}

static unsigned long old_origin;

void vcd_savestate (const struct vt *vt, int blanked)
{
    struct con_struct *vcd = vt->vcd;
    clear_selection ();
    vcd_removecursors (vt);
    old_origin = vt->vcd->screen.origin;

    if (blanked)
	vtdata.blanked = NULL;

    memcpy (vcd->buffer.buffer, vtdata.buffer.buffer + vtdata.buffer.origin,
		vtdata.buffer.totsize << 2);
    vcd->buffer.pos -= vtdata.buffer.origin;
    vcd->driver = buffer_driver;
#ifdef DEBUG
    vcd_validate (vt->vcd, "vcd_savestate");
#endif
}

void vcd_restorestate (const struct vt *vt)
{
    struct con_struct *vcd = vt->vcd;
    int text_mode;
    /*
     * Reset the origin on this VT to be the same as the previous.
     * This way we don't get any jumps when we change VT's.
     */
    text_mode = vt->vtd->vc_mode == KD_TEXT ? 1 : 0;
    memcpy (vtdata.buffer.buffer, vcd->buffer.buffer, vtdata.buffer.totsize << 2);
    vtdata.buffer.origin = 0;
    if (text_mode) {
	vt->vcd->screen.origin = old_origin;
	set_scrmem (vt, 0);
    } else
	vt->vcd->screen.origin = SCREEN2_BASE;
    vcd->driver = screen_driver;
    gotoxy(vt->vcd, vt->vcd->curstate.x, vt->vcd->curstate.y);
#ifdef DEBUG
    vcd_validate (vt->vcd, "vcd_restorestate");
#endif
    set_origin(vt);
    set_cursor(vt);
    if (text_mode)
	vcd_restorecursors (vt);
    set_leds ();
}

void vcd_setup_graphics (const struct vt *vt)
{
    clear_selection ();
    vcd_removecursors (vt);
    __set_origin (vtdata.screen.memstart);
}

/*===============================================================================================*/

static int vcd_write_utf (struct con_struct *vcd, int c)
{
    /* Combine UTF-8 into Unicode */
    /* Incomplete characters silently ignored */
    if (c < 0x80) {
	vcd->utf_count = 0;
	return c;
    }

    if (vcd->utf_count > 0 && (c & 0xc0) == 0x80) {
	vcd->utf_char = (vcd->utf_char << 6) | (c & 0x3f);
	if (--vcd->utf_count == 0)
	    return vcd->utf_char;
	else
	    return -1;
    } else {
	unsigned int count, chr;
	if ((c & 0xe0) == 0xc0) {
	    count = 1;
	    chr = (c & 0x1f);
	} else if ((c & 0xf0) == 0xe0) {
	    count = 2;
	    chr = (c & 0x0f);
	} else if ((c & 0xf8) == 0xf0) {
	    count = 3;
	    chr = (c & 0x07);
	} else if ((c & 0xfc) == 0xf8) {
	    count = 4;
	    chr = (c & 0x03);
	} else if ((c & 0xfe) == 0xfc) {
	    count = 5;
	    chr = (c & 0x01);
	} else {
	    count = 0;
	    chr = 0;
	}
	vcd->utf_count = count;
	vcd->utf_char = chr;
	return -1;
    }
}

static int vcd_write_ctrl (const struct vt *vt, unsigned int c)
{
    struct con_struct *vcd = vt->vcd;
    /*
     *  Control characters can be used in the _middle_
     *  of an escape sequence.
     */
    switch (c) {
    case 0:
	return 0;
    case 7:
	if (vcd->bell_duration)
		vt_mksound (vcd->bell_pitch, 72, vcd->bell_duration);
	return 0;
    case 8:
	if (vcd->need_wrap)
	    vcd->need_wrap = 0;
	else if (vcd->curstate.x) {
	    vcd->curstate.x --;
	    if (vtdata.fgconsole == vt)
		vcd->screen.pos -= vtdata.screen.bytespercharh;
	    vcd->buffer.pos -= 1;
	    vcd->need_wrap = 0;
	}
	return 0;
    case 9:
	if (vtdata.fgconsole == vt)
	    vcd->screen.pos -= vcd->curstate.x * vtdata.screen.bytespercharh;
	vcd->buffer.pos -= vcd->curstate.x;
	while (vcd->curstate.x < vtdata.numcolumns - 1) {
	    vcd->curstate.x++;
	    if (vcd->tab_stop[vcd->curstate.x >> 5] & (1 << (vcd->curstate.x & 31)))
		break;
	}
	if (vtdata.fgconsole == vt)
	    vcd->screen.pos += vcd->curstate.x * vtdata.screen.bytespercharh;
	vcd->buffer.pos += vcd->curstate.x;
	return 0;
    case 10:
    case 11:
    case 12:
	if (vcd->curstate.y + 1 == vcd->bottom)
	    vcd->driver.scroll_up (vcd, vcd->top, vcd->bottom, 1);
	else if (vcd->curstate.y < vtdata.numrows - 1) {
	    vcd->curstate.y ++;
	    if (vtdata.fgconsole == vt)
		vcd->screen.pos += vtdata.screen.sizerow;
	    vcd->buffer.pos += vtdata.buffer.sizerow;
	}
	vcd->need_wrap = 0;
	if (!is_kbd(lnm))
	    return 0;
    case 13:
	if (vtdata.fgconsole == vt)
	    vcd->screen.pos -= vcd->curstate.x * vtdata.screen.bytespercharh;
	vcd->buffer.pos -= vcd->curstate.x;
	vcd->curstate.x = vcd->need_wrap = 0;
	return 0;
    case 14:
	vcd->curstate.flags |= FLG_CHRSET;
	vcd->disp_ctrl = 1;
	vcd->translate = set_translate(vcd->curstate.G1_charset);
	return 1;
    case 15:
	vcd->curstate.flags &= ~FLG_CHRSET;
	vcd->disp_ctrl = 0;
	vcd->translate = set_translate(vcd->curstate.G0_charset);
	return 1;
    case 24:
    case 26:
	vcd->state = ESnormal;
	return 0;
    case 27:
	vcd->state = ESesc;
	return 0;
    case 127:
	/* ignored */
	return 0;
    case 128+27:
	vcd->state = ESsquare;
	return 0;
    }

    switch(vcd->state) {
    case ESesc:
	vcd->state = ESnormal;
	switch (c) {
	case '[':
	    vcd->state = ESsquare;
	    break;
	case ']':
	    vcd->state = ESnonstd;
	    break;
	case '%':
	    vcd->state = ESpercent;
	    break;
	case 'E':
	    if (vtdata.fgconsole == vt)
		vcd->screen.pos -= vcd->curstate.x * vtdata.screen.bytespercharh;
	    vcd->buffer.pos -= vcd->curstate.x;
	    vcd->curstate.x = vcd->need_wrap = 0;
	case 'D':
	    if (vcd->curstate.y + 1 == vcd->bottom)
		vcd->driver.scroll_up (vcd, vcd->top, vcd->bottom, 1);
	    else if (vcd->curstate.y < vtdata.numrows - 1) {
		vcd->curstate.y ++;
		if (vtdata.fgconsole == vt)
		    vcd->screen.pos += vtdata.screen.sizerow;
		vcd->buffer.pos += vtdata.buffer.sizerow;
	    }
	    /* vcd->need_wrap = 0; why should we reset this when the x position is the same? */
	    break;
	case 'M':
	    if (vcd->curstate.y == vcd->top)
		vcd->driver.scroll_down (vcd, vcd->top, vcd->bottom, 1);
	    else if (vcd->curstate.y > 0) {
		vcd->curstate.y --;
		if (vtdata.fgconsole == vt)
		    vcd->screen.pos -= vtdata.screen.sizerow;
		vcd->buffer.pos -= vtdata.buffer.sizerow;
	    }
	    /* vcd->need_wrap = 0; why should we reset this when the x position is the same? */
	    break;
	case 'H':
	    vcd->tab_stop[vcd->curstate.x >> 5] |= (1 << (vcd->curstate.x & 31));
	    break;
	case 'Z':
	    respond_ID (*vt->tty);
	    break;
	case '7':
	    vcd->savedstate = vcd->curstate;
	    break;
	case '8':
	    vcd->curstate = vcd->savedstate;
 	    gotoxy(vt->vcd, vt->vcd->curstate.x, vt->vcd->curstate.y);
	    update_attr (vt);
	    return 1;
	case '(':
	    vcd->state = ESsetG0;
	    break;
	case ')':
	    vcd->state = ESsetG1;
	    break;
	case '#':
	    vcd->state = EShash;
	    break;
	case 'c':
	    reset_terminal (vt, 0);
	    break;
	case '>': /* Numeric keypad */
	    clr_kbd (kbdapplic);
	    break;
	case '=': /* Appl. keypad */
	    set_kbd (kbdapplic);
	    break;
	}
	return 0;
    case ESnonstd:
	vcd->state = ESnormal;
	switch (c) {
	case 'P': /* palette escape sequence */
	    for (vcd->npar = 0; vcd->npar < NPAR; vcd->npar++)
		vcd->par[vcd->npar] = 0;
	    vcd->npar = 0 ;
	    vcd->state = ESpalette;
	    return 0;
	case 'R': /* reset palette */
	    con_reset_palette (vt);
	default:
	    return 0;
	}
    case ESpalette:
	if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f')) {
	    vcd->par[vcd->npar++] = (c > '9' ? (c & 0xDF) - 'A' + 10 : c - '0');
	    if (vcd->npar == 7) {
#if TODO
		int i = par[0]*3, j = 1;
		palette[i] = 16*par[j++];
		palette[i++] += par[j++];
		palette[i] = 16*par[j++];
		palette[i++] += par[j++];
		palette[i] = 16*par[j++];
		palette[i++] += par[j];
#endif
		con_set_palette (vt);
		vcd->state = ESnormal;
	    }
	} else
	    vcd->state = ESnormal;
	return 0;
    case ESsquare:
	for (vcd->npar = 0; vcd->npar < NPAR; vcd->npar++)
	    vcd->par[vcd->npar] = 0;
	vcd->npar = 0;
	vcd->state = ESgetpars;
	if (c == '[') { /* Function key */
	    vcd->state = ESfunckey;
	    return 0;
	}

	vcd->ques = (c == '?');
	if (vcd->ques)
	    return 0;
    case ESgetpars:
	if (c == ';' && vcd->npar < NPAR - 1) {
	    vcd->npar ++;
	    return 0;
	} else
	if (c >= '0' && c <= '9') {
	    vcd->par[vcd->npar] = vcd->par[vcd->npar] * 10 + c - '0';
	    return 0;
	} else
	    vcd->state = ESgotpars;
    case ESgotpars:
	vcd->state=ESnormal;
	switch (c) {
	case 'h':
	    set_mode(vt, 1);
	    return 0;
	case 'l':
	    set_mode(vt, 0);
	    return 0;
	case 'n':
	    if (!vcd->ques) {
		if (vcd->par[0] == 5)
		    status_report (*vt->tty);
		else
		if (vcd->par[0] == 6)
		    cursor_report (vt);
	    }
	    return 0;
	}
	if (vcd->ques) {
		vcd->ques = 0;
		return 0;
	}
	switch(c) {
	case 'G':
	case '`':
	    if (vcd->par[0])
		vcd->par[0]--;
	    gotoxy (vcd, vcd->par[0], vcd->curstate.y);
	    return 0;
	case 'A':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, vcd->curstate.x, vcd->curstate.y - vcd->par[0]);
	    return 0;
	case 'B':
	case 'e':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, vcd->curstate.x, vcd->curstate.y + vcd->par[0]);
	    return 0;
	case 'C':
	case 'a':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, vcd->curstate.x + vcd->par[0], vcd->curstate.y);
	    return 0;
	case 'D':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, vcd->curstate.x - vcd->par[0], vcd->curstate.y);
	    return 0;
	case 'E':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, 0, vcd->curstate.y + vcd->par[0]);
	    return 0;
	case 'F':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    gotoxy (vcd, 0, vcd->curstate.y - vcd->par[0]);
	    return 0;
	case 'd':
	    if (vcd->par[0])
		vcd->par[0]--;
	    gotoxay (vcd, vcd->curstate.x, vcd->par[0]);
	    return 0;
	case 'H':
	case 'f':
	    if (vcd->par[0])
		vcd->par[0]--;
	    if (vcd->par[1])
		vcd->par[1]--;
	    gotoxay (vcd, vcd->par[1], vcd->par[0]);
	    return 0;
	case 'J':
	    csi_J (vt, vcd->par[0]);
	    return 0;
	case 'K':
	    csi_K (vt, vcd->par[0]);
	    return 0;
	case 'L':
	    csi_L (vt, vcd->par[0]);
	    return 0;
	case 'M':
	    csi_M (vt, vcd->par[0]);
	    return 0;
	case 'P':
	    csi_P (vt, vcd->par[0]);
	    return 0;
	case 'c':
	    if (!vcd->par[0])
		respond_ID(*vt->tty);
	    return 0;
	case 'g':
	    if (!vcd->par[0])
		vcd->tab_stop[vcd->curstate.x >> 5] &= ~(1 << (vcd->curstate.x & 31));
	    else
	    if (vcd->par[0] == 3) {
		vcd->tab_stop[0] =
		vcd->tab_stop[1] =
		vcd->tab_stop[2] =
		vcd->tab_stop[3] =
		vcd->tab_stop[4] = 0;
	    }
	    return 0;
	case 'm':
	    return csi_m (vt);
	case 'q': /* DECLL - but only 3 leds */
	    /* map 0,1,2,3 to 0,1,2,4 */
	    if (vcd->par[0] < 4)
		  setledstate(vt->kbd, (vcd->par[0] < 3 ? vcd->par[0] : 4));
	    return 0;
	case 'r':
	    if (!vcd->par[0])
		vcd->par[0]++;
	    if (!vcd->par[1])
		vcd->par[1] = vtdata.numrows;
	    if (vcd->par[0] < vcd->par[1] && vcd->par[1] <= vtdata.numrows) {
		vcd->top = vcd->par[0] - 1;
		vcd->bottom = vcd->par[1];
		gotoxay (vcd, 0, 0);
	    }
	    return 0;
	case 's':
	    vcd->savedstate = vcd->curstate;
	    return 0;
	case 'u':
	    vcd->curstate = vcd->savedstate;
	    update_attr (vt);
	    return 1;
	case 'X':
	    csi_X (vt, vcd->par[0]);
	    return 0;
	case '@':
	    csi_at (vt, vcd->par[0]);
	    return 0;
	case ']': /* setterm functions */
	    setterm_command (vt);
	    return 0;
	}
	return 0;
    case ESpercent:
	vcd->state = ESnormal;
	switch (c) {
	case '@': /* defined in ISO 2022 */
	    vcd->utf = 0;
	    return 0;
	case 'G': /* prelim official escape code */
	case '8': /* retained for compatibility */
	    vcd->utf = 1;
	    return 0;
	}
	return 0;
    case ESfunckey:
	vcd->state = ESnormal;
	return 0;
    case EShash:
	vcd->state = ESnormal;
	if (c == '8') {
	    /* DEC screen alignment test. kludge :-) */
	}
	return 0;
    case ESsetG0:
	vcd->state = ESnormal;
	if (c == '0')
	    vcd->curstate.G0_charset = GRAF_MAP;
	else
	if (c == 'B')
	    vcd->curstate.G0_charset = LAT1_MAP;
	else
	if (c == 'U')
	    vcd->curstate.G0_charset = IBMPC_MAP;
	else
	if (c == 'K')
	    vcd->curstate.G0_charset = USER_MAP;
	if ((vcd->curstate.flags & FLG_CHRSET) == 0) {
	    vcd->translate = set_translate(vcd->curstate.G0_charset);
	    return 1;
	}
	return 0;
    case ESsetG1:
	vcd->state = ESnormal;
	if (c == '0')
	    vcd->curstate.G1_charset = GRAF_MAP;
	else
	if (c == 'B')
	    vcd->curstate.G1_charset = LAT1_MAP;
	else
	if (c == 'U')
	    vcd->curstate.G1_charset = IBMPC_MAP;
	else
	if (c == 'K')
	    vcd->curstate.G1_charset = USER_MAP;
	if (vcd->curstate.flags & FLG_CHRSET) {
	    vcd->translate = set_translate(vcd->curstate.G1_charset);
	    return 1;
	}
	return 0;
    default:
	vcd->state = ESnormal;
    }
    return 0;
}

static inline void vcd_write_char (struct con_struct *vcd, unsigned int c)
{
    if (c & ~console_charmask)
	return;
    vcd->driver.write_char (vcd, vcd->combined_state | (c & 255));
}

int vcd_write (const struct vt *vt, int from_user, const unsigned char *buf, int count)
{
    int strt_count = count;
    unsigned short *cached_trans;
    unsigned int cached_ctrls;
    register struct con_struct *vcd;

    if (from_user && get_fs () == KERNEL_DS)
	from_user = 0;

    vcd = vt->vcd;

#ifdef DEBUG
    vcd_validate (vcd, "vcd_write entry");
#endif

    vcd_removecursors (vt);
    if (vt == vtdata.select.vt)
	clear_selection();

    disable_bh (CONSOLE_BH);
recache:
    cached_ctrls = vcd->disp_ctrl ? CTRL_ALWAYS : CTRL_ACTION;
    cached_trans = vcd->translate + (vcd->toggle_meta ? 0x80 : 0);

    while (!(*vt->tty)->stopped && count) {
	int tc, c;
	enable_bh(CONSOLE_BH);
	__asm__("teq	%3, #0
	ldreqb	%0, [%1], #1
	ldrnebt	%0, [%1], #1" : "=r" (c), "=&r" (buf) : "1" (buf), "r" (from_user));
	disable_bh(CONSOLE_BH);
	count --;

	if (vcd->utf) {
	    if ((tc = vcd_write_utf (vcd, c)) < 0)
		continue;
	    c = tc;
	} else
	    tc = cached_trans[c];

	if (vcd->state == ESnormal && tc && (c != 127 || vcd->disp_ctrl) && (c != 128+27)) {
	    if (c >= 32 || (!vcd->utf && !(cached_ctrls & (1 << c)))) { /* ok */
		tc = conv_uni_to_pc (tc);
		if (tc == -4)
		    /* If we got -4 (not found) then see if we have
		       defined a replacement character (U+FFFD) */
		    tc = conv_uni_to_pc (0xfffd);
		else if (tc == -3)
		    /* Bad hash table -- hope for the best */
		    tc = c;

		vcd_write_char (vcd, tc);
		continue;
	    }
	}

	if (vcd_write_ctrl (vt, c))
	    goto recache;
	else
	    continue;
    }
    if (vt->vtd->vc_mode != KD_GRAPHICS)
	set_cursor (vt);
    vcd_restorecursors (vt);
    enable_bh(CONSOLE_BH);
#ifdef DEBUG
    vcd_validate (vcd, "vcd_write exit");
#endif
    return strt_count - count;
}

int vcd_ioctl (const struct vt *vt, int cmd, unsigned long arg)
{
    int i;
    switch (cmd) {
    case VT_GETPALETTE: {
	unsigned long pix, num, *ptr;
	const unsigned long *entries;

	ptr = (unsigned long *)arg;

	if ((i = verify_area (VERIFY_READ, ptr, 12)) != 0)
		return i;

	pix = get_user (ptr);
	num = get_user (ptr + 1);
	if (!num)
		return 0;
	if (pix > 255 || pix + num > 256)
		return -EINVAL;

	ptr = (unsigned long *) get_user (ptr + 2);
	if ((i = verify_area (VERIFY_WRITE, ptr, num * sizeof (unsigned long))) != 0)
		return i;

	if (vt->vcd->screen.palette_entries)
		entries = vt->vcd->screen.palette_entries + pix;
	else
		entries = default_palette_entries + pix;
	memcpy_tofs(ptr, entries, num * sizeof (unsigned long));
	return 0;
        }
    case VT_SETPALETTE: {
	unsigned long pix, num, *ptr, *sval;

	ptr = (unsigned long *)arg;

	if ((i = verify_area (VERIFY_READ, ptr, 12)) != 0)
		return i;

	pix = get_user (ptr);
	num = get_user (ptr + 1);
	if (!num)
		return 0;
	if (pix > 255 || pix + num > 256)
		return -EINVAL;

	ptr = (unsigned long *) get_user (ptr + 2);
	if ((i = verify_area (VERIFY_READ, ptr, num * sizeof (unsigned long))) != 0)
		return i;

	if (!vt->vcd->screen.palette_entries) {
		void *entries;
		entries = kmalloc (sizeof (unsigned long) * 256, GFP_KERNEL);
		if (!vt->vcd->screen.palette_entries) {
			if (!entries)
				return -ENOMEM;
			memcpy (entries, default_palette_entries, 256 * sizeof (unsigned long));
			vt->vcd->screen.palette_entries = entries;
		}
	}
	sval = vt->vcd->screen.palette_entries + pix;
	memcpy_fromfs (sval, ptr, num * sizeof (unsigned long));
	palette_setpixel(pix);
	for (i = num; i > 3; i -= 4) {
	    palette_write (*sval++);
	    palette_write (*sval++);
	    palette_write (*sval++);
	    palette_write (*sval++);
	}
	if (i & 2) {
	    palette_write (*sval++);
	    palette_write (*sval++);
	}
	if (i & 1)
	    palette_write (*sval++);
	return 0;
	}

    case PIO_FONT:
	if (vt->vtd->vc_mode != KD_TEXT)
	    return -EINVAL;
	return con_set_font((char *)arg);
	/* con_set_font() defined in console.c */

    case GIO_FONT:
	if (vt->vtd->vc_mode != KD_TEXT)
	    return -EINVAL;
	return con_get_font((char *)arg);
	/* con_get_font() defined in console.c */

    case PIO_SCRNMAP:
	return con_set_trans_old ((char *)arg);

    case GIO_SCRNMAP:
	return con_get_trans_old((char *)arg);

    case PIO_UNISCRNMAP:
	return con_set_trans_new((short *)arg);

    case GIO_UNISCRNMAP:
	return con_get_trans_new((short *)arg);

    case PIO_UNIMAPCLR: {
	struct unimapinit ui;

	i = verify_area(VERIFY_READ, (void *)arg, sizeof(struct unimapinit));
	if (i)
	    return i;
	memcpy_fromfs(&ui, (void *)arg, sizeof(struct unimapinit));
	con_clear_unimap(&ui);
	return 0;
	}

    case PIO_UNIMAP: {
	i = verify_area(VERIFY_READ, (void *)arg, sizeof(struct unimapdesc));
	if (i == 0) {
	    struct unimapdesc *ud;
	    u_short ct;
	    struct unipair *list;

	    ud = (struct unimapdesc *) arg;
	    ct = get_fs_word(&ud->entry_ct);
	    list = (struct unipair *) get_fs_long(&ud->entries);

	    i = verify_area(VERIFY_READ, (void *) list,
			ct*sizeof(struct unipair));
	    if (!i)
		return con_set_unimap(ct, list);
	}
	return i;
	}

    case GIO_UNIMAP: {
	i = verify_area(VERIFY_WRITE, (void *)arg, sizeof(struct unimapdesc));
	if (i == 0) {
	    struct unimapdesc *ud;
	    u_short ct;
	    struct unipair *list;

	    ud = (struct unimapdesc *) arg;
	    ct = get_fs_word(&ud->entry_ct);
	    list = (struct unipair *) get_fs_long(&ud->entries);
	    if (ct)
		i = verify_area(VERIFY_WRITE, (void *) list,
			ct*sizeof(struct unipair));
	    if (!i)
		return con_get_unimap(ct, &(ud->entry_ct), list);
	}
	return i;
	}

    default:
	return -ENOIOCTLCMD;
    }
}

void console_print(const char *b)
{
	static int printing = 0;
	struct vt *vt = vtdata.fgconsole;
	struct con_struct * const vcd = vt->vcd;
	unsigned char c;

#ifdef DEBUG
	vcd_validate (vcd, "console_print entry");
#endif

	if (!printable || printing || vt->vtd->vc_mode == KD_GRAPHICS)
		return;  /* console not yet initialized */
	printing = 1;

	if (!vt_allocated(vtdata.fgconsole)) {
		/* impossible */
	  	printk ("console_print: tty %d not allocated ??\n", vtdata.fgconsole->num);
	  	printing = 0;
	  	return;
	}

#ifdef CONFIG_SERIAL_ECHO
	serial_echo_print (b);
#endif
	vcd_removecursors (vt);
	while ((c = *b++) != 0)
		screen_driver.put_char(vcd, vcd->combined_state | (c & 255));
	set_cursor (vt);
	vcd_restorecursors (vt);

	vt_pokeblankedconsole ();
	printing = 0;
#ifdef DEBUG
	vcd_validate (vt->vcd, "console_print exit");
#endif
}

/*===============================================================================================*/

int vcd_init (struct vt *vt, int kmallocok, unsigned long *kmem)
{
	struct con_struct *vcd = vt->vcd;
	memset (vcd, 0, sizeof (*vcd));
    
	vcd->screen.origin		= vtdata.screen.memstart;
	vcd->screen.cursoron		= (kmem ? 1 : 0);
	vcd->screen.palette_entries	= NULL;
	vcd->driver			= buffer_driver;
	if (kmallocok) {
		vcd->buffer.buffer	= vmalloc (vtdata.buffer.totsize * sizeof (unsigned long));
		if (!vt->vcd->buffer.buffer)
			return -ENOMEM;
		vcd->buffer.kmalloced	= 1;
	} else {
		vcd->buffer.buffer	= (unsigned long *) *kmem;
		*kmem += vtdata.buffer.totsize * sizeof (unsigned long);
	}

	vt->vtd->paste_wait		= NULL;
	reset_terminal (vt, (kmem ? 1 : 0));
	return 0;
}

/*
 * We allow this irq to be shared
 */
static struct irqaction vsyncirq = { vsync_irq, SA_SHIRQ, 0, "vsync", NULL, NULL };
    
unsigned long vcd_pre_init (unsigned long kmem, struct vt *vt)
{
	int colours, i;

	switch (bytes_per_char_h) {
	default:
	case 1:
		default_palette_entries = palette_1;
		vtdata.screen.bytespercharh = 1;
		vtdata.screen.bitsperpix = 1;
		color_table = color_1;
		colours = 1;
		break;
	case 4:
		default_palette_entries = palette_4;
		vtdata.screen.bytespercharh = 4;
		vtdata.screen.bitsperpix = 4;
		color_table = color_4;
		colours = 16;
		for (i = 0; i < 256; i++)
			con_charconvtable[i] =
				(i & 128 ? 1 << 0  : 0) |
				(i & 64  ? 1 << 4  : 0) |
				(i & 32  ? 1 << 8  : 0) |
				(i & 16  ? 1 << 12 : 0) |
				(i & 8   ? 1 << 16 : 0) |
				(i & 4   ? 1 << 20 : 0) |
				(i & 2   ? 1 << 24 : 0) |
				(i & 1   ? 1 << 28 : 0);
		break;
	case 8:
		default_palette_entries = palette_8;
		vtdata.screen.bytespercharh = 8;
		vtdata.screen.bitsperpix = 8;
		color_table = color_8;
		colours = 256;
		for (i = 0; i < 16; i++)
			con_charconvtable[i] =
				(i & 8   ? 1 << 0  : 0) |
				(i & 4   ? 1 << 8  : 0) |
				(i & 2   ? 1 << 16 : 0) |
				(i & 1   ? 1 << 24 : 0);
		break;
	}
	video_size_row		= vtdata.numcolumns * vtdata.screen.bytespercharh;
	vtdata.screen.bytespercharv = bytes_per_char_v;
	vtdata.screen.sizerow   = video_size_row * vtdata.screen.bytespercharv;
	vtdata.screen.totsize	= vtdata.screen.sizerow * vtdata.numrows;

	vtdata.screen.memsize	= ((vtdata.screen.totsize - 1) | (PAGE_SIZE - 1)) + 1;
	vtdata.screen.memend	= SCREEN1_END;
	vtdata.screen.memstart	= vtdata.screen.memend - vtdata.screen.memsize;
	vtdata.buffer.buffer	= (unsigned long *)kmem;
	vtdata.buffer.sizerow	= vtdata.numcolumns;
	vtdata.buffer.totsize	= vtdata.numcolumns * vtdata.numrows;
	vtdata.buffer.lastorigin	= vtdata.buffer.totsize * 2;
	kmem = (unsigned long)(vtdata.buffer.buffer + vtdata.buffer.totsize * 3);
	memzero (vtdata.buffer.buffer, vtdata.buffer.totsize * 3 << 2);

	kmem = map_screen_mem (vtdata.screen.memstart, kmem, 1);

	palette_setpixel(0);
	for (i = 0; i < MAX_PIX; i++)
		palette_write(default_palette_entries[i]);

	vcd_init (vt, 0, &kmem);
	vt->vcd->driver = screen_driver;

	gotoxy (vt->vcd, ORIG_X, ORIG_Y);
	set_origin (vt);
	csi_J (vt, 0);
	printable = 1;

#ifdef CONFIG_SERIAL_ECHO
	serial_echo_init (SERIAL_ECHO_PORT);
#endif
	printk ("Console: %s %s %dx%dx%d, %d virtual console%s (max %d)\n",
		colours != 1 ? "colour" : "mono",
		"A-series",
		vtdata.numcolumns, vtdata.numrows, colours,
		MIN_NR_CONSOLES,
		(MIN_NR_CONSOLES == 1) ? "":"s",
		MAX_NR_CONSOLES);

	register_console (console_print);

	if (setup_arm_irq(IRQ_VSYNCPULSE, &vsyncirq))
		panic ("Unable to get VSYNC irq for console\n");

	return kmem;
}

/*
 * Report the current status of the vc. This is exported to modules (ARub)
 */
int con_get_info(int *mode, int *shift, int *col, int *row,
			struct tty_struct **tty)
{
	extern int shift_state;

	if (mode) *mode = vtdata.fgconsole->vtd->vc_mode;
	if (shift) *shift = shift_state;
	if (col) *col = vtdata.numcolumns;
	if (row) *row = vtdata.numrows;
	if (tty) *tty = *vtdata.fgconsole->tty;
	return vtdata.fgconsole->num;
}
