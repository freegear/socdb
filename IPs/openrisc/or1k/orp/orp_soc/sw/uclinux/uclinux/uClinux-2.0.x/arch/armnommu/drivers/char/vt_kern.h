/*
 * linux/arch/arm/drivers/char/vt.h
 *
 * Virtual Terminal bits...
 */

#ifndef _VT_KERN_H
#define _VT_KERN_H

#include <linux/vt.h>
 
#define NPAR 16
#define SEL_BUFFER_SIZE 4096

struct vc_state {
    unsigned char	forecol;		/* foreground			*/
    unsigned char	backcol;		/* background			*/
    unsigned char	x;			/* x position			*/
    unsigned char	y;			/* y position			*/
#define FLG_BOLD	0x01
#define FLG_ITALIC	0x02
#define FLG_UNDERLINE	0x04
#define FLG_FLASH	0x08
#define FLG_INVERSE	0x10
#define FLG_CHRSET	0x20
    unsigned char	flags;			/* special flags		*/
    unsigned char	G0_charset;		/* G0 character set		*/
    unsigned char	G1_charset;		/* G1 character set		*/
    unsigned char	__unused;		/* unused			*/
};

extern struct con_struct *___GCC_HACK_TO_STOP_ITS_SILLY_COMPLAINTS___;

struct console_driver {
    void (*gotoxy)(struct con_struct *vcd);
    void (*scroll_up)(struct con_struct *vcd,unsigned int,unsigned int,unsigned int);
    void (*scroll_down)(struct con_struct *vcd,unsigned int,unsigned int,unsigned int);
    unsigned long *(*buffer_pos)(struct con_struct *vcd,unsigned int offset);
    void (*delete_char)(struct con_struct *vcd,unsigned int);
    void (*insert_char)(struct con_struct *vcd,unsigned int);
    void (*put_char)(struct con_struct *vcd,unsigned long);
    void (*write_char)(struct con_struct *vcd,unsigned long);
    void (*erase)(struct con_struct *vcd,unsigned char,unsigned char,unsigned char,unsigned char);
};

struct con_struct {
    struct {
	unsigned int	origin;			/* address of top-left		*/
	unsigned int	pos;			/* current position into screen	*/
	unsigned long	*palette_entries;	/* Current palette		*/
	unsigned int	cursoron;		/* Cursor on count		*/
    } screen;

    struct {
	unsigned long	*buffer;		/* pointer to actual buffer	*/
	unsigned int	size;			/* size of buffer		*/
	unsigned int	pos;			/* current position into buffer */
	unsigned char	kmalloced	: 1;	/* buffer kmalloced		*/
    } buffer;

    struct console_driver driver;
    /*
     * State
     */
    struct vc_state	curstate;		/* current state		*/
    struct vc_state	savedstate;		/* saved state			*/
    unsigned long	combined_state;		/* combined state		*/
    unsigned long	cached_backcolwrd;	/* cached background colour	*/
    unsigned long	tab_stop[5];		/* tab stops			*/
    unsigned short	*translate;		/* translation table		*/

    unsigned char	top;			/* top of scrollable region	*/
    unsigned char	bottom;			/* bottom of scrollable region	*/
    unsigned char	def_forecol;		/* default foreground		*/
    unsigned char	def_backcol;		/* default background		*/

     unsigned char	cursor_count;		/* on/off cursor count (int)	*/

      unsigned char	disp_ctrl	: 1;	/* display control characters	*/
      unsigned char	toggle_meta	: 1;	/* toggle high bit		*/
      unsigned char	decscnm		: 1;	/* screen mode			*/
      unsigned char	decom		: 1;	/* origin mode			*/
      unsigned char	decawm		: 1;	/* autowrap mode		*/
      unsigned char	deccm		: 1;	/* cursor visible		*/
      unsigned char	decim		: 1;	/* insert mode			*/
      unsigned char	deccolm		: 1;	/* 80/132 col mode		*/

      unsigned char	report_mouse	: 2;	/* mouse reporting?		*/
      unsigned char	need_wrap	: 1;	/* need to wrap			*/
      unsigned char	ques		: 1;
    /*
     * UTF
     */
      unsigned char	utf		: 1;	/* Unicode UTF-8 encoding	*/

     unsigned char	utf_count;		/* UTF character count		*/
    unsigned long	utf_char;		/* UTF character built		*/
    unsigned long	npar;			/* number of params		*/
    unsigned long	par[NPAR];		/* params			*/
    unsigned int	bell_pitch;		/* console bell pitch		*/
    unsigned int	bell_duration;		/* console bell duration	*/
    unsigned char	state;			/* Current escape state		*/

};

struct vt_data {
    unsigned char	numcolumns;		/* number of columns		*/
    unsigned char	numrows;		/* number of rows		*/
    unsigned char	__unused[2];
    struct vt		*fgconsole;		/* displayed VC			*/
    struct vt		*blanked;		/* blanked VC			*/
    struct {
    	unsigned char	bitsperpix;		/* bits per pixel		*/
	unsigned char	bytespercharh;		/* horiz. bytes a char takes	*/
	unsigned char	bytespercharv;		/* vert. bytes a char takes	*/
	unsigned char	__unused[1];
	unsigned long	sizerow;		/* size of a row of chars	*/
	unsigned long	totsize;		/* total character size		*/
	unsigned long	memstart;		/* video mem start		*/
	unsigned long	memsize;		/* video mem size		*/
	unsigned long	memend;			/* video mem end		*/
	unsigned long	blankinterval;		/* blank interval		*/
    } screen;
    struct {
	unsigned long	*buffer;		/* address of screen buffer	*/
	unsigned long	totsize;		/* total buffer size		*/
	unsigned long	lastorigin;		/* last origin address		*/
	unsigned long	origin;			/* current origin		*/
	unsigned long	sizerow;		/* size of a row of chars	*/
    } buffer;
    struct {
	struct vt	*vt;			/* selected VC			*/
	int		start;			/* start offset			*/
	int		end;			/* end offset			*/
	int		length;			/* buffer length		*/
	char		*buffer;		/* buffer			*/
    } select;
};

extern struct vt_data vtdata;
extern struct tty_driver console_driver;

struct vt_struct {
    unsigned char	vc_mode;		/* hmm...			*/
    unsigned char	vc_kbdraw;
    unsigned char	vc_kbde0;
    unsigned char	vc_kbdleds;
    struct vt_mode	vt_mode;
    pid_t		vt_pid;
    struct vt		*vt_newvt;		/* VT to switch to..		*/
    struct wait_queue	*paste_wait;
    unsigned char *	xmit_buf;
    unsigned int	xmit_cnt;
    unsigned int	xmit_out;
    unsigned int	xmit_in;
    unsigned int	xmitting;
};

struct vt {
    /*
     * Per-console data
     */
    struct con_struct *vcd;
    /*
     * Keyboard stuff
     */
    struct kbd_struct *kbd;
    /*
     * VT stuff
     */
    struct vt_struct *vtd;
    /*
     * tty that this VT is connected to
     */
    struct tty_struct **tty;
    /*
     * tty number of this vt struct
     */
    unsigned char num;
    /*
     * is this vt allocated and initialised?
     */
    unsigned char allocinit;
    /*
     * might add  scrmem at some time, to have everything
     * in one place - the disadvantage would be that
     * vc_cons etc can no longer be static
     */
};

extern struct vt vt_con_data[];

#define VT_IS_IN_USE(i) (vt_driver.table[i] && vt_driver.table[i]->count)
#define VT_BUSY(i) (VT_IS_IN_USE(i) || vt_con_data + i == vtdata.fgconsole || vt_con_data + i == vtdata.select.vt)

extern inline int vt_allocated (const struct vt * const vt)
{
    return vt->allocinit != 0;
}

extern void		vt_reset (const struct vt *vt);
extern void		vt_completechangeconsole (const struct vt *vt);
extern void		vt_changeconsole (struct vt *newvt);
extern void		vt_mksound (unsigned int count, unsigned int vol, unsigned int ticks);
extern int	 	vt_deallocate (int arg);
extern int		vt_resize (int cols, int rows);

/*
 * Blanking ...
 */
extern void		vt_pokeblankedconsole (void);
extern void		vt_do_unblankscreen (void);
extern void		vt_do_blankscreen (int nopowersave);

/*
 * Screen switching...
 */
extern void		vt_updatescreen (const struct vt *newvt);

/*
 * Initialisation ...
 */
extern unsigned long	vt_pre_init (unsigned long kmem);
extern void		vt_post_init (void);

#endif /* _VT_KERN_H */
