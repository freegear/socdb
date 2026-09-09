/*
 *    x^0.45 table generation for gamma correct
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
	float out;
	int i;
    int j;


	printf("short E045[256] = {\n");

	for(i = 0; i < 256; i++)
	{
        out = ((float)i)/((float)(256));

        out = pow((float)(out),(float)0.45);
        j   = (unsigned int)(out*256);
        if(i != 255)
			printf("%d, \n",  j);
        else
			printf("%d}; \n", j);

	}
	return 0;
}
