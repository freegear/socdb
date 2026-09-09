#include <stdarg.h>

int global = 5;

int func (unsigned long a, char b) {
  global = 2;
  a = 3 + a;
  b = 4 + b;
  return a + b;
}

int main () {
  int local = 7;
  int i;
  char tmp[50];
  
  screen_init ();
  screen_clear ();
  for (i = 0; i < 10; i++)
    put_char (i + '0');
  put_char ('\n');
  put_char ('\n');

  put_string ("Hello, World!");

  i = 0;
  while (1) {
    put_string ("This is OpenRISC running on Xess XSV board ...");
    put_char ('0' + i & 7);
    put_char ('\n');
  }
}
