#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int i;
	FILE *fp;
	unsigned length;

	if(argc != 3)
	{
		fprintf(stderr, "Usage : %s binaryfile table_name\n", argv[0]);
		exit(-1);
	}

	fp = fopen(argv[1], "rb");
	if(fp == NULL)
	{
		fprintf(stderr, "Cannot open file %s\n", argv[1]);
		exit(-1);
	}

	fseek(fp, 3000*4*4, SEEK_SET);	// Skip some zero data
	printf("const unsigned %s[] = {", argv[2]);
	i = 0;
	for(;i <256*1024;)
	{
		unsigned  data;

		if(fread(&data, sizeof(unsigned), 1, fp) <= 0)
			break;

		if(i%4 == 0)
			printf("\n\t");
		printf("0x%08x, ", data);
		i++;
	}
	printf("\n};\n");
	
	return 0;
}
