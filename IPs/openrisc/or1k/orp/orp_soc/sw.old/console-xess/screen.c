#include <stdio.h>
#include "screen.h"

unsigned long fg_color = COLOR_WHITE;
unsigned long bg_color = COLOR_BLACK;
int cx = 0;
int cy = 0;

extern unsigned char font[256][12];
static char screen[CHARSY][CHARSX];

void put_char_xy (int x, int y, char c) {
  int i, j;
  screen[y][x] = c;
  x *= CHAR_WIDTH;
  y *= CHAR_HEIGHT;
  for (i = 0; i < CHAR_HEIGHT; i++) {
    int t = font[(unsigned char)c][i];
    for (j = 0; j < CHAR_WIDTH; j++) {
      if (t & 1)
        PUT_PIXEL(x + j, y + i, fg_color);
      else
        PUT_PIXEL(x + j, y + i, bg_color);       
       t >>= 1;
    }
  }
}

static void scroll() {
  int x,y;
  for (y = 1; y < CHARSY; y++)
    for (x = 0; x < CHARSX; x++)
      put_char_xy (x, y-1, screen[y][x]);
  for (x = 0; x < CHARSX; x++)
    put_char_xy (x, CHARSY-1, ' ');
  cy--;
}

void put_char(char c) {
  int t;
  switch (c) {
  case '\n':
    cy++;
    cx = 0;
    if (cy >= CHARSY)
      scroll();
    break;
  case '\r':
    cx = 0;
    break;
  case '\t':
    for (t = 0; t < 8 - cx & 7; t++)
      put_char(' ');
    break;
  default:
    cx++;
    if(cx >= CHARSX) put_char('\n');
    put_char_xy(cx, cy, c);
    break;
  }
}

void screen_clear () {
  int x, y;
  for (y = 0; y < CHARSY; y++)
    for (x = 0; x < CHARSX; x++)
      put_char_xy (x, y, ' ');
  cx = cy = 0;
}

void put_string(char *s) {
  while (*s) {
    put_char (*s);
    s++;
  }
}

void screen_init () {
  SET_PALLETE(COLOR_BLACK, 0, 0, 0);
  SET_PALLETE(COLOR_WHITE, 255, 255, 255);

  /* Set screen offset */
  *((unsigned long *)SCREEN_BUFFER_REG) = SCREEN_BUFFER;

  /* Turn screen on */
  *((unsigned long *)SCREEN_REG) = 0x00000001;
}
