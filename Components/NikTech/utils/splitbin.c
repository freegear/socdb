/* splitbin.c - split a binary file created by objcopy
   into 4 files for memory banks, used as input to
   sram models
*/
#include <stdio.h>

void pr_bin(unsigned char c, FILE *outf)
{
	int i;
	for (i = 0; i < 8; i++) {
		putc (((c & 0x80) ? '1' : '0'),outf);
		c <<= 1;
	}
	putc('\n',outf);
}

main(int argc, char **argv)
{
	FILE *binfile;
	FILE *of[4];
	int i,c, addr, width = 4;
	int oval;
	char *ofn_base;

	if (argc != 3) {
		printf("usage : splitbin <file>.bin sramfiles <# of file>\n");
		exit (-1);
	}
	
	if (!(binfile = fopen(argv[1],"rb"))) {
		printf("Cannot open input binary file %s\n", argv[1]);
		exit (-1);
	}
	
	if (argc == 4) {
		width = atoi(argv[3]);
	}

	ofn_base = (char *)malloc(strlen(argv[2])+10);
	
	for (i = 0 ; i < width ; i++) {
		sprintf(ofn_base,"%s%d.mem",argv[2],i);
		if (!(of[i] = fopen(ofn_base,"w"))) {
			printf("Cannot open  output file %s\n", ofn_base);
			exit (-1);
		}
	}
	free(ofn_base);
	
	i = 0;
	addr = 0;
	oval = 0;
	while (!feof(binfile)) {
		c = fgetc(binfile);
#if defined(PRINT_OUT)
		oval <<= 8;
		oval |= c;
#endif
		fprintf(of[width-1-i],"%d ",addr);
		pr_bin(c,of[width-1-i++]);
		if (i == width) {
#if defined(PRINT_OUT)
			printf("output 0x%08X\n", oval);
			oval = 0;
#endif
			i = 0;
			addr++;
		}
	}
	return 0;
}
