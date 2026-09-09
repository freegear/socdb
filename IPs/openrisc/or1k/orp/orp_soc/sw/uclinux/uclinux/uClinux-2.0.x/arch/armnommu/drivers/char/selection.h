/*
 * selection.h
 *
 * Interface between console.c, tty_io.c, vt.c, vc_screen.c and selection.c
 */

extern void clear_selection (void);
extern int set_selection (const unsigned long arg, struct tty_struct *tty);
extern int paste_selection (struct tty_struct *tty);
extern int sel_loadlut (const unsigned long arg);
extern int mouse_reporting (void);
extern void mouse_report (struct tty_struct *tty, int butt, int mrx, int mry);

extern void vt_do_unblankscreen (void);
extern unsigned long *screen_pos (const struct vt *const vt, unsigned int offset);
extern unsigned long screen_word (const struct vt *const vt, unsigned int offset);
extern int scrw2glyph (unsigned long scr_word);
extern void complement_pos (const struct vt * const vt, unsigned int offset);
extern void invert_screen (const struct vt *const vt, unsigned int offset, unsigned int count);

extern void getconsxy (const struct vt *const vt, char *p);
extern void putconsxy (const struct vt *const vt, char *p);
extern void update_scrmem (const struct vt *const vt, int offset, int length);
