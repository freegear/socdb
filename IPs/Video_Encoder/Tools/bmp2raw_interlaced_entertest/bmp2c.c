#include <stdio.h>
#include <stdlib.h>
//#define __TEST__
//#define __TEST1__

int	main(int argc, char **argv)
{
	FILE *ifp, *ofp, *ofp2, *ofp3;
	int  sized;
	int  i,j,k;
	char  *bs;

	if(argc != 4)
	{
		fprintf(stderr, "Usage:%s [bmpfile.bmp] [outfile C array] [raw file]  \n", argv[0]);
		exit(1);
	}

	ifp  = fopen(argv[1], "r");
	ofp  = fopen(argv[2], "w");

	sized = double_space(ifp);

	ofp2 = fopen(argv[3], "w");
	ofp3 = fopen("ScaleOut.bmp", "w");
	ifp  = fopen(argv[1], "r");

	char tmp[sized];
	char **tmpRGB;
	char **ScaleRGB;
	size_t bytes;
	int	X,Y;

	fread(tmp, 1,sized,ifp);

	X = (tmp[19] & 0xff) << 8;
	X = X + (tmp[18] & 0xff);
	printf("width [%d] \n", X);

	Y = (tmp[23] & 0xff) << 8;
	Y = Y + (tmp[22] & 0xff);
	printf("height[%d] \n", Y);

    tmp[23] = 0x02;
    tmp[22] = 0x40;

    tmpRGB   = (char**)malloc(sizeof(char*) * Y);
    ScaleRGB = (char**)malloc(sizeof(char*) * 576);

    for(i=0;Y>i;i++)
        tmpRGB[i] = (char *)malloc(sizeof(char) * X *3);

    for(i=0;576>i;i++)
        ScaleRGB[i] = (char *)malloc(sizeof(char) * X *3);

	k = 54;


	for(i=(Y-1);i>=0;i--)
			for(j=0;j<X*3;j=j+3)
			{
				tmpRGB[i][j]    = (tmp[k++] & 0xff);
				tmpRGB[i][j+1]  = (tmp[k++] & 0xff);
				tmpRGB[i][j+2]  = (tmp[k++] & 0xff);

#ifdef __TEST__
                
				printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j]     & 0xff);
				printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
				printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
			}


    int q;
    q = 0;
    k = 54;
	//for(i=(576-1);i>=0;i--) {
	for(i=0;i<576;i++) {
        if(((i%6) == 0) && (q <96) && i != 0) {
            q++;
			for(j=0;j<X*3;j=j+3) {
				ScaleRGB[i][j]    = (tmp[k++] & 0xff);
				ScaleRGB[i][j+1]  = (tmp[k++] & 0xff);
				ScaleRGB[i][j+2]  = (tmp[k++] & 0xff);
            }
            k = k - (X*3);

        } else {
			for(j=0;j<X*3;j=j+3)
			{
				ScaleRGB[i][j]    = (tmp[k++] & 0xff);
				ScaleRGB[i][j+1]  = (tmp[k++] & 0xff);
				ScaleRGB[i][j+2]  = (tmp[k++] & 0xff);
			}
        }
    }


	sized = sized - 54;
	fprintf(ofp, "const unsigned char %s[%d] = {",argv[2] ,sized);
#ifdef __TEST__
    printf("TEST1 output_________\n");
#endif

    for(i=0;i<54;i++)
        fwrite(&tmp[i]  , sizeof(char), 1 ,ofp3);

	//for(i=0;i<Y;i++)
	for(i=0;i<576;i++)
			for(j=0;j<X*3;j=j+3)
			{
				//fprintf(ofp, "%d, ",tmpRGB[i][j] & 0xff);
				//fprintf(ofp, "%d, ",tmpRGB[i][j+1] & 0xff);
				//fprintf(ofp, "%d, ",tmpRGB[i][j+2] & 0xff);
				if(i%6==0) fprintf(ofp, "\n");

                //fwrite(&tmpRGB[i][j]  , sizeof(char), 1 ,ofp2);
                //fwrite(&tmpRGB[i][j+1], sizeof(char), 1 ,ofp2);
                //fwrite(&tmpRGB[i][j+2], sizeof(char), 1 ,ofp2);
                fwrite(&ScaleRGB[i][j]  , sizeof(char), 1 ,ofp3);
                fwrite(&ScaleRGB[i][j+1], sizeof(char), 1 ,ofp3);
                fwrite(&ScaleRGB[i][j+2], sizeof(char), 1 ,ofp3);

#ifdef __TEST__
				printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j] & 0xff);
				printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
				printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
			}

#if 0
	for(i=0;i<Y;i=i+2)
		for(j=0;j<X*3;j=j+3)
		{
            fwrite(&tmpRGB[i][j+2], sizeof(char), 1 ,ofp2);
            fwrite(&tmpRGB[i][j+1], sizeof(char), 1 ,ofp2);
            fwrite(&tmpRGB[i][j]  , sizeof(char), 1 ,ofp2);

#ifdef __TEST1__
			printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j] & 0xff);
			printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
			printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
	    }

	for(i=1;i<Y;i=i+2)
		for(j=0;j<X*3;j=j+3)
		{
            fwrite(&tmpRGB[i][j+2], sizeof(char), 1 ,ofp2);
            fwrite(&tmpRGB[i][j+1], sizeof(char), 1 ,ofp2);
            fwrite(&tmpRGB[i][j]  , sizeof(char), 1 ,ofp2);

#ifdef __TEST1__
			printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j] & 0xff);
			printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
			printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
	    }
#else

	//for(i=0;i<576;i=i+2)
	for(i=575;i>=0;i=i-2)
		for(j=0;j<X*3;j=j+3)
		{
            fwrite(&ScaleRGB[i][j+2], sizeof(char), 1 ,ofp2);
            fwrite(&ScaleRGB[i][j+1], sizeof(char), 1 ,ofp2);
            fwrite(&ScaleRGB[i][j]  , sizeof(char), 1 ,ofp2);

#ifdef __TEST1__
			printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j] & 0xff);
			printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
			printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
	    }

	//for(i=1;i<576;i=i+2)
	for(i=574;i>=0;i=i-2)
		for(j=0;j<X*3;j=j+3)
		{
            fwrite(&ScaleRGB[i][j+2], sizeof(char), 1 ,ofp2);
            fwrite(&ScaleRGB[i][j+1], sizeof(char), 1 ,ofp2);
            fwrite(&ScaleRGB[i][j]  , sizeof(char), 1 ,ofp2);

#ifdef __TEST1__
			printf("1 [%d][%d]=> %02x \n", i, j,tmpRGB[i][j] & 0xff);
			printf("2 [%d][%d]=> %02x \n", i, j+1,tmpRGB[i][j+1] & 0xff);
			printf("3 [%d][%d]=> %02x \n", i, j+2,tmpRGB[i][j+2] & 0xff);
#endif
	    }

#endif

	fprintf(ofp, "}; \n ");
	fprintf(ofp, "\n");

	fclose(ifp);
	fclose(ofp);
	fclose(ofp2);

    for(i=0;Y>i;i++)
        free(tmpRGB[i]);

    free(tmpRGB);

    for(i=0;576>i;i++)
        free(ScaleRGB[i]);

    free(ScaleRGB);

	return 0;
}


int double_space(FILE *ifp)
{
	int i=1024;
	int k=0;

	char indata_p[1024];
	size_t bytes;


	while(1)

	{
		bytes=fread(indata_p, 1,i,ifp);
		if(bytes>0)
		{
		//fwrite(indata_p, 1,bytes,ofp);
		k = k + bytes;
		}
		else	break;
	}


	printf("total size[%d] \n",k);
	return(k);
}

