#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "bmplib.h"
#define WIDTH 480
#define HEIGHT 272

int main(int argc, char *argv[])
{
	bmphandle_t bh = NULL;
	unsigned buffer;
	int i, j, count;

	if(argc != 2)
	{
		fprintf(stderr, "Usage : %s bmpfile\n", argv[0]);
		exit(-1);
	}

	bh = bmp_read_open(argv[1]);
	if(bh == NULL)
	{
		fprintf(stderr, "Cannot open file %s\n", argv[1]);
		exit(-1);
	}

	fprintf(stdout, "const unsigned rgbdata[] = {");

	count = 0;
	for(i = 0; i < HEIGHT; i++)
	{
		for(j = 0; j < WIDTH; j++)
		{
			struct bgrpixel pixel;

			bmp_getpixel(bh, &pixel, j, i);

			buffer = (0xff<<24)|(pixel.b<<16)|(pixel.g<<8)|pixel.r;
			if(count % 8 == 0)
				fprintf(stdout, "\n");

			fprintf(stdout, "0x%08x, ", buffer);
			count++;
		}
	}
	fprintf(stdout, "\n};\n");

	return 0;
}
