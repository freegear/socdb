#include <stdio.h>

unsigned int binstr2int(char *bstr)
{
	unsigned int i = 0;

	while (*bstr) {
		i <<= 1;
		i |= *bstr++ - '0';	       
	}
	return i;
}

int main(int argc, char **argv)
{
	int count = argc-2;
	int i,j;
	unsigned int result = 0;
	int rev ;

	if (count == 0) {
		printf("Usage : rominit [0|1] value1 value2 ..\n");
		exit(-1);
	}

	for (i = 2 ; i <= count+1; i++ ) {
		printf("'%s' => 0x%x\n",argv[i],j=binstr2int(argv[i]));
		result |= (1 << j);
	}
	
	if (argv[1][0] == '1') {
		printf("result INIT[0x%08X]\n",result);
	} else {
		printf("result INIT[0x%08X]\n",~result);
	}
}
