
#include <stdio.h>
#include <stdlib.h> /* for exit */
#include <string.h>
#include <assert.h>

#include "sine_table.c"
#include "sine_table2.c"

short Sine(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 1
	value = sine_table[phase];
#else
	if(phase & 0x0100)
		index = (-(phase & 0x00ff))&0x00ff;
	else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = sine_table[index];
		break;
	case 1:
		value = cosine_table[index];
		break;
	case 2:
		value = cosine_table[index];
		break;
	case 3:
		value = sine_table[index];
		break;
	case 4:
		value = -sine_table[index];
		break;
	case 5:
		value = -cosine_table[index];
		break;
	case 6:
		value = -cosine_table[index];
		break;
	case 7:
		value = -sine_table[index];
		break;
	}
#endif
	return value;
}

short Sine1(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 0
	value = sine_table[phase];
#else
	if(phase & 0x0100) {
        if(phase == 0x100)
		    index = 0x00ff;
        else if(phase == 0x300)
		    index = 0x00ff;
        else if(phase == 0x500)
		    index = 0x00ff;
        else if(phase == 0x700)
		    index = 0x00ff;
        else
        {
		    index = (0x0ff-(phase & 0x00ff))&0x00ff;
        }
    } else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = sine_table256[index];
		break;
	case 1:
		value = cosine_table256[index];
		break;
	case 2:
		value = cosine_table256[index];
		break;
	case 3:
		value = sine_table256[index];
		break;
	case 4:
		value = -sine_table256[index];
		break;
	case 5:
		value = -cosine_table256[index];
		break;
	case 6:
		value = -cosine_table256[index];
		break;
	case 7:
		value = -sine_table256[index];
		break;
	}
#endif
	return value;
}


short Cosine(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 1
	value = cosine_table[phase];
#else
	if(phase & 0x0100)
        if(phase == 0x100)
		    index = 0x00ff;
        else if(phase == 0x300)
		    index = 0x00ff;
        else if(phase == 0x500)
		    index = 0x00ff;
        else if(phase == 0x700)
		    index = 0x00ff;
        else
        {
		    index = (0x0ff-(phase & 0x00ff))&0x00ff;
		    //index = ((-(phase & 0x00ff))&0x00ff);
        }
	else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = cosine_table[index];
		break;
	case 1:
		value = sine_table[index];
		break;
	case 2:
		value = -sine_table[index];
		break;
	case 3:
		value = -cosine_table[index];
		break;
	case 4:
		value = -cosine_table[index];
		break;
	case 5:
		value = -sine_table[index];
		break;
	case 6:
		value = sine_table[index];
		break;
	case 7:
		value = cosine_table[index];
		break;
	}
#endif

	return value;
}


short Cosine1(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 0
	value = cosine_table[phase];
#else
	if(phase & 0x0100)
        if(phase == 0x100)
		    index = 0x00ff;
        else if(phase == 0x300)
		    index = 0x00ff;
        else if(phase == 0x500)
		    index = 0x00ff;
        else if(phase == 0x700)
		    index = 0x00ff;
        else
        {
		    index = (0x0ff-(phase & 0x00ff))&0x00ff;

            //printf("TSETxxx %x index %x\n",phase, index);
		    //index = (-(phase & 0x00ff))&0x00ff;
        }
	else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = cosine_table256[index];
		break;
	case 1:
		value = sine_table256[index];
		break;
	case 2:
		value = -sine_table256[index] ;
		break;
	case 3:
		value = -cosine_table256[index];
		break;
	case 4:
		value = -cosine_table256[index];
		break;
	case 5:
		value = -sine_table256[index];
		break;
	case 6:
		value = sine_table256[index];
		break;
	case 7:
		value = cosine_table256[index];
		break;
	}
#endif

	return value;
}

int MULX(short U, short BUFF)
{

    int value;

    if(BUFF < 0 && U < 0 )
        value = ((-U*(-BUFF)));
    else if(BUFF < 0 && U >0 )
        value = -((U*(-BUFF)));
    else if(BUFF > 0 && U <0 )
        value = -((-U*(BUFF)));
    else
        value = (U*BUFF);

    return value; // output is 20bits valide
}




int main(void)
{
    FILE *ofp_Sin0, *ofp_Sin1;
    FILE *ofp_MULA, *ofp_MULB;
    FILE *ofp_MULO;

    ofp_Sin0 = fopen("./ALL_SINWAVE", "w");
    ofp_Sin1 = fopen("./QUART_SINWAVE", "w");
    ofp_MULA = fopen("./MULA", "w");
    ofp_MULB = fopen("./MULB", "w");
    ofp_MULO = fopen("./MULO", "w");

    int i=0, j=0, k=0;
    int R,G,B;
    int Y,U,V;
    
    for(i=0; 2048>i; i++)
    {
        fprintf(ofp_Sin0, "%d %d %d\n", i, Sine(i), Cosine(i));
        fprintf(ofp_Sin1, "%4d %03x %03x\n", i, Sine1(i)&0x7ff, Cosine1(i)&0x7ff);
    }

    /*
    i = 0;
    for(R=0; 256>R; R++) {
        for(G=0; 256>G; G++) {
            for(B=0; 256>B; B++) {
        
                Y = ((155*R) + (304*G) + ( 59*B) +128)>>8;
                U = ((-76*R) - (150*G) + (226*B) +128)>>8;
                V = ((319*R) - (267*G) - ( 52*B) +128)>>8;

                printf("%d Y %03x U %03x V %03x \n", i++, Y, U, V);
            }
        }
    }
    */

    int A;

    for(i =0 ; i < 1024; i++) {

        for(j =0 ; j < 512; j++) {
            A =  (MULX(i, j)+256)/512;
            fprintf(ofp_MULA, "%03x %03x %03x\n", i&0x3ff, j&0x3ff, A & 0x3ff);
        }

        for(j = -511 ; j <0; j++) {
            A =  (MULX(i, j)+256)/512;
            fprintf(ofp_MULA, "%03x %03x %03x\n", i&0x3ff, j&0x3ff, A & 0x3ff);
        }
    }

    return 0;
}
