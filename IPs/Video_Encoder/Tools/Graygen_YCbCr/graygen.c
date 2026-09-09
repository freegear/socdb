/*
 * colorbar.c
 *
 * description : 75% NTSC/PAL Colorbar generator
 *
 * Copyright(C) 2003 holelee
 *
 */
#include <stdio.h>
#include <assert.h>
#include <strings.h>	/* for strcasecmp() */

#define WIDTH 720
#define MAX_HEIGHT 576
#define COLOR_WIDTH (180/2)

/* colors in 75% NTSC colorbar : { Y, Cb, Cr } */
#define WHITE_NTSC { 180, 128, 128 }
#define WHITE_PAL { 235, 128, 128 }
#define YELLOW { 162, 44, 142 }
#define CYAN { 131, 156, 44 }
#define GREEN { 112, 72, 58 }
#define MAGENTA { 84, 184, 198 }
#define RED { 65, 100, 212 }
#define BLUE { 35, 212, 114 }
#define BLACK { 16, 128, 128 }

typedef struct { unsigned char Y, Cb, Cr; } YCbCrColor;

YCbCrColor *Colorbar;
YCbCrColor Colorbar_NTSC[8] = { WHITE_NTSC, YELLOW, CYAN, GREEN, MAGENTA, RED, BLUE, BLACK };
YCbCrColor Colorbar_PAL[8]  = { WHITE_PAL, YELLOW, CYAN, GREEN, MAGENTA, RED, BLUE, BLACK };

main(int argc, char *argv[])
{
	int i, j, k;
	unsigned char Y601[MAX_HEIGHT][WIDTH];
	unsigned char Cb[MAX_HEIGHT][WIDTH/2];
	unsigned char Cr[MAX_HEIGHT][WIDTH/2];
	unsigned char *buffer;
	int buffersize;
	int height;
	int is_ntsc;
	FILE *fp;

    FILE *ofp;

	if(argc != 3)
	{
		fprintf(stderr, "Usage:%s {ntsc|pal} filename.yuv\n", argv[0]);
		exit(1);
	}
	if(!strcasecmp(argv[1], "ntsc"))
	{
		height = 485;
		buffersize = 1716*525;
		is_ntsc = 1;
	}
	else if(!strcasecmp(argv[1], "pal"))
	{
		height = 576;
		buffersize = 1724*625;
		is_ntsc = 0;
	}
	else
	{
		fprintf(stderr, "Usage:%s {ntsc|pal} filename.yuv\n", argv[0]);
		exit(1);
	}

	ofp = fopen("./COLOR_BAR.c", "w");
	fprintf(ofp, "const char image[%d] = {\n", buffersize);

	if(is_ntsc)
		Colorbar = Colorbar_NTSC;
	else
		Colorbar = Colorbar_PAL;
		
	for(i = 0; i < height; i++)
	{
		for(j = 0; j < WIDTH; j++)
		{
			for(k = 0; k < 8; k++)
				if((j - k*COLOR_WIDTH) < COLOR_WIDTH)
					break;
			if(k >= 8)	k = 7;
			Y601[i][j] = Colorbar[k].Y;
			if((j & 0x01)== 0)
			{
				Cb[i][j>>1] = Colorbar[k].Cb;
				Cr[i][j>>1] = Colorbar[k].Cr;
			}
		}
	}

	buffer = (unsigned char *)malloc(buffersize);
    k = 0;
	for(i = 0; i < height; i++)
	{
		    for(j = 0; j < WIDTH; j+=2)
		    {
#if 0
                buffer[k++] = Cb[i][j>>1] ;
		        fprintf(ofp, "%d, ", buffer[k-1] & 0xff);
                buffer[k++] = Y601[i][j] ;
		        fprintf(ofp, "%d, ", buffer[k-1] & 0xff);
                buffer[k++] = Cr[i][j>>1] ;
		        fprintf(ofp, "%d, ", buffer[k-1] & 0xff);
                buffer[k++] = Y601[i][j+1] ;

                if(i == height-1 && j == WIDTH-2)
		            fprintf(ofp, "%d \n", buffer[k-1] & 0xff);
                else
		            fprintf(ofp, "%d, \n", buffer[k-1] & 0xff);
#else
                buffer[k++] = (char)(0)  ;
                buffer[k++] = j;
                buffer[k++] = (char)(0)  ;
                buffer[k++] = j+1;
#endif

            }

    }

	fp = fopen(argv[2], "wb");
	if(fp == NULL)
	{
		fprintf(stderr, "Cannot open file(%s)\n", argv[2]);
		exit(1);
	}

	fwrite(buffer, buffersize, 1, fp);
	fclose(fp);

	fprintf(ofp, "}; \n ");
	fprintf(ofp, "\n");
	fclose(ofp);
	return 0;
}
