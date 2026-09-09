#include <asm/system.h>

#define CRCI(x) (crci = (crci << 5) | (x))
#define CRCO(x) (crco = (crco << 5) | (x))

unsigned long decompress (unsigned char *in, unsigned char *out)
{
  unsigned char hist[0x10000];
  unsigned long size;
  int b = 0, i;
  unsigned char *orig = in;
  unsigned char *mask;
  unsigned short hash = 0;
  unsigned long crci = 0, crco = 0;

  for (i = 0; i < 0x10000; i++) hist[i] = 0;
  
  CRCI(*in); size = (*in++) << 24;
  CRCI(*in); size |= (*in++) << 16;
  CRCI(*in); size |= (*in++) << 8;
  CRCI(*in); size |= (*in++) << 0;
  CRCI(*in); mask = in++;
_print("Size = %x\n", size);
  for (i = 0; i < size; i++) {
    unsigned char c;
    if ((*mask >> b) & 1) c = hist[hash];
    else CRCI(c = *in++);
    CRCO(*out++ = c);
    hist[hash] = c;
    hash <<= 8;
    hash |= c;
    hash &= 0xffff;
    if (++b == 8) {
      CRCI(*in); 
      mask = in++;
      b = 0;
    }
  }
/*
  print_str ("compressed CRC = ");
  print_n (crci);
  print_str ("\ndecompressed CRC = ");
  print_n (crco);
  print_str ("\ndecompressed size = ");
  print_n (size);
  print_str (" end ");
  print_n (out);
  print_str ("\ncompressed  size = ");
  print_n (in - orig);
  print_str (" end ");
  print_n (in);
  print_str ("\n");
*/
  return size;
}

