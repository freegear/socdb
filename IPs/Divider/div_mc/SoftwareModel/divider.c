/*

   Divider simulation for HDL coding


*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define  __HDL_DEBUG__

int main()
{
  int c;

  float  i,j;

  float  q;
  float  r;
  
#ifdef __HDL_DEBUG__
  for(c=0;c<10;c++) printf("%1x%04x%04x%04x%04x\n",0,0,0,0,0);
#endif

  for(i=0;i<pow(2,16);i+=23)    {
      for(j=i;j<(pow(2,16)/10);j+=17)	{

		  if(i == 0) {
			  q = 0;
			  r = i;
		  }
		  else {
			  q = (i/j);
//			  r = i-(q*j);
		  }

		  q = (float)((int)(q * pow(2,15)));  // MSB is 2^15
		  
		  q = q / pow(2,15);
		  
		  r = i-(q*j);

		  if(r < 0) r = 0;

#ifndef __HDL_DEBUG__
		  printf("dividend : %.1f divisor : %.1f q : %.6f r : %.6f\n",i,j,q,r);
#endif

		  q = q * pow(2,15);  // MSB is 2^15
		  r = r * pow(2,15);  // MSB is 2^15

#ifdef __HDL_DEBUG__
		  printf("1%04x%04x%04x%04x\n",(int)i,(int)j,(int)q,(int)r);
#else
		  
		  printf("1 %04x %04x %04x %04x\n\n",(int)i,(int)j,(int)q,(int)r);
#endif
	  } // for j
  } // for i
}
