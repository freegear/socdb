/*
 * linux/arch/arm/drivers/char/consoledriver.c
 *
 * Low-level console routines
 */
#include <linux/string.h>

#include <asm/hardware.h>
#include <asm/io.h>

#include "vt_kern.h"

#define palette_setpixel(p) outl(0x10000000|((p) & 255), IO_VIDC_BASE)
#define palette_write(v)  outl(0x00000000|((v) & 0x00ffffff), IO_VIDC_BASE)
/*
 * Don't allow underline through to erasing/scrolling routines
 */
#define FLG_MASK (~(FLG_UNDERLINE << 24))

extern void scroll_set_origin (unsigned long offset);
extern void ll_write_char(unsigned long ps, unsigned long chinfo);

static void vcd_buffer_gotoxy(struct con_struct *vcd)
{
	vcd->screen.pos = vcd->screen.origin;
	vcd->buffer.pos = vcd->curstate.y * vtdata.buffer.sizerow +
    			  vcd->curstate.x;
}

static void vcd_buffer_scrollup(struct con_struct *vcd, unsigned int t, unsigned int b, unsigned int l)
{
	unsigned int old_top, new_top, old_end, new_end;

	if (b > vtdata.numrows || t >= b || l == 0)
		return;

	l *= vtdata.buffer.sizerow;
	old_top = t * vtdata.buffer.sizerow;
	new_top = old_top + l;
	new_end = b * vtdata.buffer.sizerow;
	old_end = new_end - l;

	if (new_top < new_end) /* we have something to move */
		memmove (vcd->buffer.buffer + old_top, vcd->buffer.buffer + new_top,
			 (new_end - new_top) << 2);

	if (old_end < new_end) {
		if (old_end < old_top)
			old_end = old_top;
		memsetl (vcd->buffer.buffer + old_end, (vcd->combined_state & FLG_MASK) | 32,
			(new_end - old_end) << 2);
	}
}

static void vcd_buffer_scrolldown(struct con_struct *vcd, unsigned int t, unsigned int b, unsigned int l)
{
	unsigned int old_top, new_top, old_end, new_end;

	if (b > vtdata.numrows || t >= b || l == 0)
		return;

	l *= vtdata.buffer.sizerow;
	new_top = t * vtdata.buffer.sizerow;
	old_top = new_top + l;
	old_end = b * vtdata.buffer.sizerow;
	new_end = old_end - l;

	if (new_top < new_end) /* we have something to move */
		memmove (vcd->buffer.buffer + old_top, vcd->buffer.buffer + new_top,
			 (new_end - new_top) << 2);

	if (new_top < old_top) { /* we have something to clear */
		if (old_top > old_end)
			old_top = old_end;
		memsetl (vcd->buffer.buffer + new_top, (vcd->combined_state & FLG_MASK) | 32,
				(old_top - new_top) << 2);
	}
}

static unsigned long *vcd_buffer_buffer_pos(struct con_struct *vcd, unsigned int offset)
{
	return vcd->buffer.buffer + offset;
}

static void vcd_buffer_delete_char(struct con_struct *vcd, unsigned int n)
{
	unsigned long *buffer;
	unsigned int len;

	buffer = vcd->buffer.buffer + vcd->buffer.pos;

	if (n >= vtdata.numcolumns - vcd->curstate.x) {
		n = vtdata.numcolumns - vcd->curstate.x;
		len = 0;
	} else {
		len = vtdata.numcolumns - vcd->curstate.x - n;
		memmove (buffer, buffer + n, len << 2);
	}
	memsetl (buffer + len, (vcd->combined_state & FLG_MASK) | 32, n << 2);
}

static void vcd_buffer_insert_char(struct con_struct *vcd, unsigned int n)
{
	unsigned long *buffer;

	buffer = vcd->buffer.buffer + vcd->buffer.pos;

	if (n >= vtdata.numcolumns - vcd->curstate.x)
		n = vtdata.numcolumns - vcd->curstate.x;
	else
		memmove (buffer + n, buffer, (vtdata.numcolumns - vcd->curstate.x - n) << 2);
	memsetl (buffer, (vcd->combined_state & FLG_MASK) | 32, n << 2);
}

static void vcd_buffer_write_char(struct con_struct *vcd, unsigned long character)
{
	if (vcd->need_wrap) {
		vcd->buffer.pos -= vcd->curstate.x;
		vcd->need_wrap = vcd->curstate.x = 0;
		if (vcd->curstate.y + 1 == vcd->bottom)
			vcd_buffer_scrollup(vcd, vcd->top, vcd->bottom, 1);
		else if (vcd->curstate.y + 1 < vtdata.numrows) {
			vcd->curstate.y += 1;
			vcd->buffer.pos += vtdata.buffer.sizerow;
		}
	}
	if (vcd->decim)
		vcd_buffer_insert_char(vcd, 1);
	vcd->buffer.buffer[vcd->buffer.pos] = character;

	if (vcd->curstate.x + 1 == vtdata.numcolumns)
		vcd->need_wrap = vcd->decawm;
	else {
		vcd->curstate.x ++;
		vcd->buffer.pos ++;
	}
}

static void vcd_buffer_erase(struct con_struct *vcd, unsigned char sx, unsigned char sy,
				unsigned char ex, unsigned char ey)
{
	unsigned int start = sy * vtdata.numcolumns + sx;
	unsigned int end = ey * vtdata.numcolumns + ex + 1;

	memsetl (vcd->buffer.buffer + start, (vcd->combined_state & FLG_MASK) | 32, (end - start) << 2);
}

struct console_driver buffer_driver = {
	vcd_buffer_gotoxy,
	vcd_buffer_scrollup,
	vcd_buffer_scrolldown,
	vcd_buffer_buffer_pos,
	vcd_buffer_delete_char,
	vcd_buffer_insert_char,
	NULL,
	vcd_buffer_write_char,
	vcd_buffer_erase
};


static void vcd_screen_gotoxy(struct con_struct *vcd)
{
	vcd->screen.pos = vcd->screen.origin +
			  vcd->curstate.y * vtdata.screen.sizerow +
			  vcd->curstate.x * vtdata.screen.bytespercharh;
	vcd->buffer.pos = vtdata.buffer.origin +
			  vcd->curstate.y * vtdata.buffer.sizerow +
    			  vcd->curstate.x;
}

static void vcd_screen_scrollup(struct con_struct *vcd, unsigned int t, unsigned int b, unsigned int l)
{
	unsigned int hardware;

	if (b > vtdata.numrows || t >= b || l == 0)
		return;

	hardware = (b == vtdata.numrows && t == 0);

	if (hardware) {
		vcd->buffer.pos -= vtdata.buffer.origin;
		vtdata.buffer.origin += l * vtdata.buffer.sizerow;
		if (vtdata.buffer.origin > vtdata.buffer.lastorigin) {
			memmove (vtdata.buffer.buffer,
				 vtdata.buffer.buffer + vtdata.buffer.origin,
				 (vtdata.buffer.totsize - vtdata.buffer.sizerow) << 2);
			vtdata.buffer.origin = 0;
		}
		vcd->buffer.pos += vtdata.buffer.origin;
		memsetl (vtdata.buffer.buffer + vtdata.buffer.origin +
				(vtdata.numrows - l) * vtdata.buffer.sizerow,
				(vcd->combined_state & FLG_MASK) | 32,
				l * vtdata.buffer.sizerow << 2);

		vcd->screen.pos -= vcd->screen.origin;
		vcd->screen.origin += l * vtdata.screen.sizerow;
		if (vcd->screen.origin >= vtdata.screen.memend)
			vcd->screen.origin = vcd->screen.origin -
					vtdata.screen.memend + vtdata.screen.memstart;
		vcd->screen.pos += vcd->screen.origin;
		memsetl ((void *)(vcd->screen.origin + vtdata.screen.sizerow * (vtdata.numrows - l)),
			vcd->cached_backcolwrd, l * vtdata.screen.sizerow);
		scroll_set_origin (vcd->screen.origin);
	} else {
		unsigned int old_top, new_top, old_end, new_end;
		unsigned char *origin = (unsigned char *)vcd->screen.origin;

		old_top = t;
		new_top = t + l;
		new_end = b;
		old_end = b - l;

		if (new_top < new_end) { /* we have something to move */
			memmove (vtdata.buffer.buffer + vtdata.buffer.origin + old_top * vtdata.buffer.sizerow,
				 vtdata.buffer.buffer + vtdata.buffer.origin + new_top * vtdata.buffer.sizerow,
				 (new_end - new_top) * vtdata.buffer.sizerow << 2);
			memmove (origin + old_top * vtdata.screen.sizerow,
				 origin + new_top * vtdata.screen.sizerow,
				 (new_end - new_top) * vtdata.screen.sizerow);
		}
		if (old_end < new_end) {
			if (old_end < old_top)
				old_end = old_top;
			memsetl (vtdata.buffer.buffer + vtdata.buffer.origin + old_end * vtdata.buffer.sizerow,
				 (vcd->combined_state & FLG_MASK) | 32,
				 (new_end - old_end) * vtdata.buffer.sizerow << 2);
			memsetl ((unsigned long *)(origin + old_end * vtdata.screen.sizerow),
				 vcd->cached_backcolwrd,
				 (new_end - old_end) * vtdata.screen.sizerow);
		}
	}
}

static void vcd_screen_scrolldown(struct con_struct *vcd, unsigned int t, unsigned int b, unsigned int l)
{
	unsigned int hardware;
	if (b > vtdata.numrows || t >= b || l == 0)
		return;

	hardware = (b == vtdata.numrows && t == 0);

	if (hardware) {
		vcd->buffer.pos -= vtdata.buffer.origin;
		vtdata.buffer.origin -= vtdata.buffer.sizerow;
		if ((int)vtdata.buffer.origin < 0) {
			memmove (vtdata.buffer.buffer + vtdata.buffer.lastorigin + l * vtdata.buffer.sizerow,
				 vtdata.buffer.buffer,
				 (vtdata.buffer.totsize - l * vtdata.buffer.sizerow) << 2);
			vtdata.buffer.origin = vtdata.buffer.lastorigin;
		}
		vcd->buffer.pos += vtdata.buffer.origin;
		memsetl (vtdata.buffer.buffer + vtdata.buffer.origin, (vcd->combined_state & FLG_MASK) | 32,
				vtdata.buffer.sizerow << 2);

		vcd->screen.pos -= vcd->screen.origin;
		vcd->screen.origin -= l * vtdata.screen.sizerow;
		if (vcd->screen.origin < vtdata.screen.memstart)
			vcd->screen.origin = vcd->screen.origin - vtdata.screen.memstart + vtdata.screen.memend;
		vcd->screen.pos += vcd->screen.origin;
		memsetl ((void *)vcd->screen.origin, vcd->cached_backcolwrd, l * vtdata.screen.sizerow);
		scroll_set_origin (vcd->screen.origin);
	} else {
		unsigned int old_top, new_top, old_end, new_end;
		unsigned char *origin = (unsigned char *)vcd->screen.origin;

		new_top = t;
		old_top = t + l;
		old_end = b;
		new_end = b - l;

		if (new_top < new_end) { /* we have something to move */
			memmove (vtdata.buffer.buffer + vtdata.buffer.origin + old_top * vtdata.buffer.sizerow,
				 vtdata.buffer.buffer + vtdata.buffer.origin + new_top * vtdata.buffer.sizerow,
				 (new_end - new_top) * vtdata.buffer.sizerow << 2);
			memmove (origin + old_top * vtdata.screen.sizerow,
				 origin + new_top * vtdata.screen.sizerow,
				 (new_end - new_top) * vtdata.screen.sizerow);
		}
		if (new_top < old_top) { /* we have something to clear */
			if (old_top > old_end)
				old_top = old_end;
			memsetl (vtdata.buffer.buffer + vtdata.buffer.origin + new_top * vtdata.buffer.sizerow,
				 (vcd->combined_state & FLG_MASK) | 32,
				 (old_top - new_top) * vtdata.buffer.sizerow << 2);
			memsetl ((unsigned long *)(origin + new_top * vtdata.screen.sizerow),
				 vcd->cached_backcolwrd,
				 (old_top - new_top) * vtdata.screen.sizerow);
		}
	}
}

static unsigned long *vcd_screen_buffer_pos(struct con_struct *vcd, unsigned int offset)
{
	return vtdata.buffer.buffer + vtdata.buffer.origin + offset;
}

static void vcd_screen_delete_char (struct con_struct *vcd, unsigned int n)
{
	unsigned int row, clear, movelen, setlen, bpr;
	unsigned char *to, *from;
	unsigned long *buffer;

	buffer = vtdata.buffer.buffer + vcd->buffer.pos;

	if (n >= vtdata.numcolumns - vcd->curstate.x) {
		n = vtdata.numcolumns - vcd->curstate.x;
		movelen = 0;
	} else {
		movelen = vtdata.numcolumns - vcd->curstate.x - n;
		memmove (buffer, buffer + n, movelen << 2);
	}
	memsetl (buffer + movelen, (vcd->combined_state & FLG_MASK) | 32, n << 2);

	clear = vcd->cached_backcolwrd & 255;
	to = (unsigned char *)vcd->screen.pos;
	setlen = n * vtdata.screen.bytespercharh;
	from = to + setlen;
	bpr = vtdata.numcolumns * vtdata.screen.bytespercharh;
	movelen = bpr - setlen - vcd->curstate.x * vtdata.screen.bytespercharh;

	for (row = vtdata.screen.bytespercharv; row > 0; row--, to += bpr, from += bpr) {
		memmove (to, from, movelen);
		memset (to + movelen, clear, setlen);
	}
}

static void vcd_screen_insert_char (struct con_struct *vcd, unsigned int n)
{
	unsigned int row, clear, movelen, setlen, bpr;
	unsigned char *to, *from;
	unsigned long *buffer;

	buffer = vtdata.buffer.buffer + vcd->buffer.pos;

	if (n >= vtdata.numcolumns - vcd->curstate.x)
		n = vtdata.numcolumns - vcd->curstate.x;
	else
		memmove (buffer + n, buffer, (vtdata.numcolumns - vcd->curstate.x - n) << 2);
	memsetl (buffer, (vcd->combined_state & FLG_MASK) | 32, n << 2);

	clear = vcd->cached_backcolwrd & 255;
	from = (unsigned char *)vcd->screen.pos;
	setlen = n * vtdata.screen.bytespercharh;
	to = from + setlen;
	bpr = vtdata.numcolumns * vtdata.screen.bytespercharh;
	movelen = bpr - setlen - vcd->curstate.x * vtdata.screen.bytespercharh;

	for (row = vtdata.screen.bytespercharv; row > 0; row--, to += bpr, from += bpr) {
		memmove (to, from, movelen);
		memset (from, clear, setlen);
	}
}

static void vcd_screen_put_char(struct con_struct *vcd, unsigned long character)
{
	char c = character & 255;

	if (c == 8) {
		if (!vcd->need_wrap) {
			vcd->screen.pos -= vtdata.screen.bytespercharh;
			vcd->buffer.pos --;
			vcd->curstate.x --;
		} else
			vcd->need_wrap = 0;
		return;
	}
	if (c == 10 || c == 13 || vcd->need_wrap) {
		vcd->screen.pos -= vcd->curstate.x * vtdata.screen.bytespercharh;
		vcd->buffer.pos -= vcd->curstate.x;
		vcd->need_wrap = vcd->curstate.x = 0;
		if (vcd->curstate.y + 1 == vcd->bottom)
			vcd_screen_scrollup (vcd, vcd->top, vcd->bottom, 1);
		else if (vcd->curstate.y < vtdata.numrows - 1) {
			vcd->curstate.y += 1;
			vcd->buffer.pos += vtdata.buffer.sizerow;
			vcd->screen.pos += vtdata.screen.sizerow;
		}
		if (c == 10 || c == 13)
			return;
	}
	ll_write_char (vcd->screen.pos, character);
	vtdata.buffer.buffer[vcd->buffer.pos] = character;

	if (vcd->curstate.x + 1 == vtdata.numcolumns)
		vcd->need_wrap = 1;
	else {
		vcd->curstate.x++;
		vcd->screen.pos += vtdata.screen.bytespercharh;
		vcd->buffer.pos ++;
	}
}

static void vcd_screen_write_char(struct con_struct *vcd, unsigned long character)
{
	if (vcd->need_wrap) {
		vcd->screen.pos -= vcd->curstate.x * vtdata.screen.bytespercharh;
		vcd->buffer.pos -= vcd->curstate.x;
		vcd->need_wrap = vcd->curstate.x = 0;
		if (vcd->curstate.y + 1 == vcd->bottom)
			vcd_screen_scrollup(vcd, vcd->top, vcd->bottom, 1);
		else if (vcd->curstate.y + 1 < vtdata.numrows) {
			vcd->curstate.y += 1;
			vcd->screen.pos += vtdata.screen.sizerow;
			vcd->buffer.pos += vtdata.buffer.sizerow;
		}
	}
	if (vcd->decim)
		vcd_screen_insert_char(vcd, 1);
	vtdata.buffer.buffer[vcd->buffer.pos] = character;
	ll_write_char (vcd->screen.pos, character);

	if (vcd->curstate.x + 1 == vtdata.numcolumns)
		vcd->need_wrap = vcd->decawm;
	else {
		vcd->curstate.x ++;
		vcd->screen.pos += vtdata.screen.bytespercharh;
		vcd->buffer.pos ++;
	}
}

static void vcd_screen_erase (struct con_struct *vcd, unsigned char sx, unsigned char sy,
                      unsigned char ex, unsigned char ey)
{
	unsigned int start = sy * vtdata.numcolumns + sx;
	unsigned int end = ey * vtdata.numcolumns + ex + 1;
	unsigned char *origin;

	memsetl (vtdata.buffer.buffer + vtdata.buffer.origin + start,
		 (vcd->combined_state & FLG_MASK) | 32, (end - start) << 2);
	if (sx) { /* erase to end of line */
		unsigned int c, i, increment;

		origin = (unsigned char *)vcd->screen.origin +
				sy * vtdata.screen.sizerow +
				sx * vtdata.screen.bytespercharh;
		increment = vtdata.numcolumns * vtdata.screen.bytespercharh;
		if (sy == ey)
			c = (ex - sx + 1) * vtdata.screen.bytespercharh;
		else
			c = (vtdata.numcolumns - sx) * vtdata.screen.bytespercharh;

		for (i = vtdata.screen.bytespercharv; i; i--, origin += increment)
			memset (origin, vcd->cached_backcolwrd, c);
		sy ++;
	}

	if (sy < ey) {
		origin = (unsigned char *)vcd->screen.origin + sy * vtdata.screen.sizerow;
		memset (origin, vcd->cached_backcolwrd, (ey - sy) * vtdata.screen.sizerow);
		sy = ey;
	}

	if (sy == ey) {
		unsigned int c, i, increment;

		origin = (unsigned char *)vcd->screen.origin +
				sy * vtdata.screen.sizerow;
		increment = vtdata.numcolumns * vtdata.screen.bytespercharh;
		c = (ex + 1) * vtdata.screen.bytespercharh;
		for (i = vtdata.screen.bytespercharv; i; i--, origin += increment)
			memset (origin, vcd->cached_backcolwrd, c);
	}
}

struct console_driver screen_driver = {
	vcd_screen_gotoxy,
	vcd_screen_scrollup,
	vcd_screen_scrolldown,
	vcd_screen_buffer_pos,
	vcd_screen_delete_char,
	vcd_screen_insert_char,
	vcd_screen_put_char,
	vcd_screen_write_char,
	vcd_screen_erase
};
