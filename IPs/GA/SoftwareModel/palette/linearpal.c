/*************************************************************************

   Generate linear palette

   file name : linearpal.c
   created by gtlee
   data : 2006.7.4

   note :
          use standard output

   history :

************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>



int main(int argc, char *argv[])
{
	int    palette;
	int    i;
	int    alpha;

	alpha = 0;
	palette = 0;
	for(i=0;i<256;i++) {
		printf("%02X%02X%02X%02X\n",alpha,palette,palette,palette);
		palette ++;
	}
	
}
