#ifndef SCREEN_H
#define SCREEN_H

#define RESX 640
#define RESY 480
#define CHAR_WIDTH 8
#define CHAR_HEIGHT 12
#define COLOR_BLACK 0x00
#define COLOR_WHITE 0xFF

#define CHARSX (RESX/CHAR_WIDTH)
#define CHARSY (RESY/CHAR_HEIGHT)

#define SCREEN_BUFFER     (0x80100000)
#define SCREEN_REG        (0xc0000000)
#define SCREEN_PALLETE    (0x80000400)
#define SCREEN_BUFFER_REG (0xc0000004)
#define PUT_PIXEL(x, y, color) (*(((unsigned char *)SCREEN_BUFFER) + (y) * RESY + (x)) = (color))
#define SET_PALLETE(i, r, g, b) (*(((unsigned long *)SCREEN_PALLETE) + (i) * 4) = ((r) << 4) | ((g) << 8) | ((b) << 12))

void put_char_xy (int x, int y, char c);
void put_char (char c);
void put_string (char *s);
void screen_clear ();
void screen_init ();

extern unsigned long fg_color;
extern unsigned long bg_color;
extern int cx;
extern int cy;

#endif
