#include <stdio.h>

void pr_bin(unsigned char ival, FILE *outf)
{
	int i;
	for (i = 0; i < 8; i++) {
		putc (((ival & 0x80) ? '1' : '0'),outf);
		ival <<= 1;
	}
}

int main(int argc, char **argv)
{
	FILE *ipf, *opf;
	unsigned char ival;

	if (argc < 3) {
		printf("usage : %s input<binary file> output<ascii binary file> [optional vhdl file]\n", argv[0]);
		exit(-1);
	}

	if (!(ipf = fopen(argv[1],"rb"))) {
		printf("cannot open input file %s \n",argv[1]);
		exit(-1);
	}
	if (!(opf = fopen(argv[2],"w"))) {
		printf("cannot open output file %s \n",argv[2]);
		exit(-1);
	}
	while (!feof(ipf)) {
		if (fread(&ival, sizeof(ival), 1, ipf) != 1) break;
		pr_bin(ival, opf);		
		if (fread(&ival, sizeof(ival), 1, ipf) != 1) break;
		pr_bin(ival, opf);		
		if (fread(&ival, sizeof(ival), 1, ipf) != 1) break;
		pr_bin(ival, opf);		
		if (fread(&ival, sizeof(ival), 1, ipf) != 1) break;
		pr_bin(ival, opf);		
		putc('\n',opf);
	}
	fclose(ipf);
	fclose(opf);
	return 0;
}
