#include <stdio.h>
#include <stdlib.h>


int	main(int argc, char **argv)
{
	FILE *ifp, *ofp;
	int  sized;
	int  i;

	ifp = fopen(argv[1], "r");
	ofp = fopen(argv[2], "w");

	sized = double_space(ifp);

	ifp = fopen(argv[1], "r");

	char tmp[sized];
	char tmpA[1024];
	char *tmpB;
	char indata_p[1024];
	size_t bytes;

	fread(tmp, 1,sized,ifp);


	fprintf(ofp, "#define %s_SIZE %d \n", argv[2] , sized);
	fprintf(ofp, "const char %s[%d] = {", argv[2] ,sized);

	for(i=0;i<sized;i++)
	{
		fprintf(ofp, "%d \n", tmp[i] & 0xff);
		//fprintf(ofp,2,1, tmp[i]);
		//printf("%2x ==> %d \n ", tmp[i]&0xff, i);
	}

	fprintf(ofp, "}; \n ");
	fprintf(ofp, "\n");

	fclose(ifp);
	fclose(ofp);
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


	printf("%d \n",k);
	return(k);
}
