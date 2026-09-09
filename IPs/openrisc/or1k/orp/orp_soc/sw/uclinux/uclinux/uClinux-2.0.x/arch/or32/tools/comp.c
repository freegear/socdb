#include <stdio.h>

unsigned char src[5000000];
unsigned char dest[10000000];
unsigned char dec[10000000];

#define CRC(x) (crc = (crc << 5) | (x))

unsigned long compress (unsigned char *in, unsigned char *out, unsigned long size)
{
  unsigned char hist[0x10000] = {0};
  unsigned char *mask;
  unsigned short hash = 0;
  unsigned i, b;
  unsigned long csize = 5;
  unsigned long crc = 0;
  
  *out++ = (size >> 24) & 0xff;
  *out++ = (size >> 16) & 0xff;
  *out++ = (size >> 8) & 0xff;
  *out++ = (size >> 0) & 0xff;
  mask = out++;
  *mask = 0;
  for (i = 0, b = 0; i < size; i++) {
    CRC(*in);
    if (*in == hist[hash]) *mask |= 1 << b;
    else {
      *out++ = *in;
      csize++;
    }
    hist[hash] = *in;
    hash <<= 8;
    hash |= *in;
    if (++b == 8) {
      mask = out++;
      csize++;
      *mask = 0;
      b = 0;
    }
    in++;
  }
  printf ("original CRC = %08x\n", crc);
  return csize;
}

unsigned long decompress (unsigned char *in, unsigned char *out)
{
  unsigned char hist[0x10000] = {0};
  unsigned long size;
  int b = 0, i;
  unsigned char *mask;
  unsigned short hash = 0;
  unsigned long crc = 0;
  
  CRC(*in); size = (*in++) << 24;
  CRC(*in); size |= (*in++) << 16;
  CRC(*in); size |= (*in++) << 8;
  CRC(*in); size |= (*in++) << 0;
  CRC(*in); mask = in++;
  for (i = 0; i < size; i++) {
    unsigned char c;
    if ((*mask >> b) & 1) c = hist[hash];
    else CRC(c = *in++);
    *out++ = c;
    hist[hash] = c;
    hash <<= 8;
    hash |= c;
    hash &= 0xffff;
    if (++b == 8) {
      CRC(*in);
      mask = in++;
      b = 0;
    }
  }
  printf ("compressed CRC = %08x\n", crc);
  return size;
}

int main (int argc, char *argv[])
{
  FILE *fi;
  unsigned short hash = 0;
  int i, size;
  char tmp[50];
  unsigned long crc = 0;
  if (argc != 2) return -1;

  fi = fopen (argv[1], "rb");
  if (!fi) return 1;
  size = fread (src, 1, sizeof (src), fi);
  fclose (fi);
  printf ("original size = %i (%08x)\n", size, size);
  size = compress (src, dest, size);
  printf ("compressed size = %i (%08x)\n", size, size);
  sprintf (tmp, "%s.cmp", argv[1]);
  fi = fopen (tmp, "wb+");
  fwrite (dest, 1, size, fi);
  fclose (fi);
  size = decompress (dest, dec);
  printf ("decompressed size = %i (%08x)\n", size, size);
  for (i = 0; i < size; i++)
    if (src[i] != dec[i]) {
      printf ("error!\n");
      return 1;
    }
#if 0
  fi = fopen ("fl_img.dec", "wb+");
  fwrite (dec, 1, size, fi);
  fclose (fi);
#endif
  return 0;
}
