
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char *argv[])
{
	int    x;
	int    y;
	int    d;
	int    x2m1;
	int    r;
	int    dy;
	
	if(argc < 2) {
		printf("\n no radius.");
		printf("\n uses : circle_al [radius]");
		return 0;
	}
	r = atoi(argv[1]);
	x = 0;
	y = r;
	d = -r;
	x2m1= -1;
	printf("\n X=%2d, Y=%2d\n",x,y);
	for(x=1;x<r/sqrt(2);x++) {
		printf("\n x=%2d, x2m1=%2d, d=%2d, y=%2d",x,x2m1,d,y);
		x2m1 += 2;
		d += x2m1;
		printf("\n d=%2d",d);
		//if(d >=r) d-=r;
		if (d>=0) {
			y --;
			d -= (y<<1);  /* Must do this AFTER y-- */
			//dy = d/y;
			//y-=(dy+1);
			//dy = d/y;
			//d -= (y*(dy+2));
		}
		printf("\n X=%2d, Y=%2d\n",x,y);
	}

	printf("\n Reverse ");

//	if (d<0) {
//		d += (y<<1);  /* Must do this AFTER y-- */
//	}
//	d -= x2m1;
//	x2m1 -= 2;


	for(x-=1;x>0;x--) {
		printf("\n X=%2d, Y=%2d",x,y);
		d += (y<<1);  /* Must do this AFTER y-- */

		printf("\n d=%2d",d);
		d -= x2m1;
		if(d>=0) {

			d -= (y<<1);  /* Must do this AFTER y-- */
		}
		else y++;
		x2m1 -= 2;
		printf("\n x=%2d, x2m1=%2d, d=%2d, y=%2d\n",x,x2m1,d,y);
	}
	

	return 0;
}
