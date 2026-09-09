#include "stdio.h"
#include "stdlib.h"
#include "jpegdec.h"

#ifndef __ARMCODE__

#	include <sys/stat.h>

#endif



#if 0
#  define RD_FILE_NAME  "..\\..\\..\\PANORAMA_1.JPG"
#  define WR_FILE_NAME  "..\\..\\..\\PANORAMA_1.RAW"
#endif

#if 0
#  define RD_FILE_NAME  ".\\PANORAMA_1.JPG"
#  define WR_FILE_NAME  ".\\PANORAMA_1.RAW"
#  define RD_FILE_SIZE  171444
#  define MAX_IMG_WIDTH  1440
#  define MAX_IMG_HEIGHT 480
#endif

#if 1
#  define RD_FILE_NAME  ".\\TEST_1.JPG"
#  define WR_FILE_NAME  ".\\TEST_1.RAW"
#  define RD_FILE_SIZE  18554
#  define MAX_IMG_WIDTH  116
#  define MAX_IMG_HEIGHT 175
#endif


#define MAX_JPG_SIZE   (256*1024)

#define WR_FILE_SIZE  (MAX_IMG_WIDTH*MAX_IMG_HEIGHT*3)

BYTE bmp[WR_FILE_SIZE];

int main()
{ 

	FILE * infp;
	FILE * outfp;
	
	int  width;
	int	 height;
	BYTE jpeg_data[MAX_JPG_SIZE];
	int  i;

	int filesize ;
	
	
#ifndef __ARMCODE__
	struct stat fstat;
	stat(RD_FILE_NAME,&fstat);
	
	filesize = fstat.st_size;
#else
	filesize = RD_FILE_SIZE;
#endif
	
		
	printf("===============  TEST  ==============\n");

	infp = fopen(RD_FILE_NAME ,"rb");
	
	if( infp == (FILE *)0)
	{
		printf("Read File Error .. Plase check it\n");
		exit(0);
	}
	else
		printf(" Read File Set OK\n");
	
	i = 0;
	
#if 0
	while(fread(&jpeg_data[i], 1, 1, infp) != EOF)
	{
	  i++;
	  printf("%08d  %02X\n",i,jpeg_data[i]);
	}

       printf("Readed JPG Size : %08d bytes\n",i);
#else
	{
		for( i = 0 ; i < filesize ; i++)
		  {
		    jpeg_data[i] = fgetc(infp);			
		  }

		printf("Readed JPG Size : %08d bytes\n",i);
		printf("Readed JPG Data : %02X %02X %02X %02X\n",
		       jpeg_data[0],jpeg_data[1],jpeg_data[2],jpeg_data[3]);
		printf("Readed JPG Data : %02X %02X %02X %02X\n",
		       jpeg_data[4],jpeg_data[5],jpeg_data[6],jpeg_data[7]);
		printf("Readed JPG Data : %02X %02X %02X %02X\n",
		       jpeg_data[8],jpeg_data[9],jpeg_data[10],jpeg_data[11]);
		printf("Readed JPG Data : %02X %02X %02X %02X\n",
		       jpeg_data[12],jpeg_data[13],jpeg_data[14],jpeg_data[15]);
	}
#endif

	
	JpegDecodeInit();
	
	printf("Start JPEG Decode....\n");
	
	width  = MAX_IMG_WIDTH;
	height = MAX_IMG_HEIGHT;

	JpegDecode(jpeg_data, bmp, &width, &height);
	
	printf("End of JPEG Decode...\n");


	printf("BMPData : %02X %02X %02X %02X\n",
   	                      bmp[0], bmp[1], bmp[2], bmp[3]);
	printf("BMPData : %02X %02X %02X %02X\n",
   	                      bmp[4], bmp[5], bmp[6], bmp[7]);

	printf("Write RAW File\n");
	
	outfp = fopen(WR_FILE_NAME ,"wb");
	
	if( outfp == (FILE *)0)
	{
		printf("Write File Error .. Plase check it\n");
		exit(0);
	}
	else
		printf("Write File Set OK\n");
		
	for(i = 0 ; i < WR_FILE_SIZE ;i++)
		fputc(bmp[i],outfp);
	
	fclose(outfp);
	fclose(infp);
		
	
	
}//end of main


