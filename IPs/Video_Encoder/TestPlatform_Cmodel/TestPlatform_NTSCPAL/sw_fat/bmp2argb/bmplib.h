/*
 * bmplib.h : header for bmplib(simple bmp reading/writing library)
 *
 * Copyright(C) 2002, 2003 holelee
 *
 */

struct bmphandle_s;

typedef struct bmphandle_s *bmphandle_t;

struct bgrpixel
{
	unsigned char b, g, r;
};

/* for reading */
bmphandle_t bmp_read_open(const char *filename);
int bmp_getpixel(bmphandle_t bh, struct bgrpixel *ppel, int x, int y);

/* for writing */
bmphandle_t bmp_write_open(const char *filename, int width, int height, int bpp);
int bmp_putpixel(bmphandle_t bh, struct bgrpixel pel, int x, int y);
/* bmp_write_open only support bpp = 24 now */
/* note on writing : real file I/O performed at bmp_close() */ 
/* common */
void bmp_close(bmphandle_t bh);
int bmp_height(bmphandle_t bh);
int bmp_width(bmphandle_t bh);
