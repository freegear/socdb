//*********************************
//	image compare
// 	by : thlee
//*********************************
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 2048*2048*3


//********** use initailize ***************
FILE *src_file1=NULL;
FILE *src_file2=NULL;

FILE *out_file=NULL;
char *out_fname= "compare.dat";


int help();
int conv_hex();

long length;
unsigned int *img1;
unsigned int *img2;

int main(int argc, char *argv[])
{

    int i=0;
    int r=0;
    int g=1;
    int b=2;
    int r_sum=0,r_diff=0,rmax_diff=0;
    int g_sum=0,g_diff=0,gmax_diff=0;
    int b_sum=0,b_diff=0,bmax_diff=0;
    float r_avr,g_avr,b_avr;
    int div=0;


    printf("argc is %d\n",argc); 
    if(argc != 3)
	{
		help();
		return 0;
	}
	
    if((src_file1 = fopen(argv[1],"r")) == NULL)
	{	
		printf("can't open file \n");
		return 0;
	}

    if((src_file2 = fopen(argv[2],"r")) == NULL)
	{	
		printf("can't open file \n");
		return 0;
	}
    
    conv_hex(); 

    fclose(src_file1);
    fclose(src_file2);

    out_file= fopen(out_fname,"wt");
    
    printf("length is %d\n",length);
    for(i=0;i<length/4;i++)
    {
        if(r==i)
        {
            r=r+3;
            r_diff=img1[i]-img2[i];

            if(r_diff<0) r_diff=r_diff * (-1);
            if(rmax_diff<r_diff) rmax_diff=r_diff;
            fprintf(out_file,"MAXIMUM R difference : %d\n",rmax_diff);

            r_sum=r_sum+r_diff;
            fprintf(out_file,"%d - %d = %d  \n",img1[i],img2[i],r_diff);  
        }
        else if(g==i)
        {
            g=g+3;
            g_diff=img1[i]-img2[i];
            
            if(g_diff<0) g_diff=g_diff * (-1);
            if(gmax_diff<g_diff) gmax_diff=g_diff;
            fprintf(out_file,"MAXIMUM G difference : %d\n",gmax_diff);

            g_sum=g_sum+g_diff;
            fprintf(out_file,"%d - %d = %d\n",img1[i],img2[i],g_diff);  
        }
        else if(b==i)
        {
            b=b+3;
            b_diff=img1[i]-img2[i];
            
            if(b_diff<0) b_diff=b_diff * (-1);
            if(bmax_diff<b_diff) bmax_diff=b_diff;
            fprintf(out_file,"MAXIMUM B difference : %d\n",bmax_diff);
            
            b_sum=b_sum+b_diff;
            fprintf(out_file,"%d - %d = %d \n\n",img1[i],img2[i],b_diff);  
        }
    }
    
    fprintf(out_file,"MAXIMUM R difference : %d\n",rmax_diff);
    fprintf(out_file,"MAXIMUM G difference : %d\n",gmax_diff);
    fprintf(out_file,"MAXIMUM B difference : %d\n",bmax_diff);

    printf("MAXIMUM R difference : %d\n",rmax_diff);
    printf("MAXIMUM G difference : %d\n",gmax_diff);
    printf("MAXIMUM B difference : %d\n",bmax_diff);

    printf("R_sum : %d\n",r_sum);
    printf("G_sum : %d\n",g_sum);
    printf("B_sum : %d\n",b_sum);
 
    length=length/4;//total line
    div=length/3;
    r_avr=(float)r_sum/div;
    g_avr=(float)g_sum/div;
    b_avr=(float)b_sum/div;
    
    fprintf(out_file,"R average : %f\n",r_avr);
    fprintf(out_file,"G average : %f\n",g_avr);
    fprintf(out_file,"B average : %f\n",b_avr);

    printf("div is %d\n",div);
    printf("R average : %f\n",r_avr);
    printf("G average : %f\n",g_avr);
    printf("B average : %f\n",b_avr);
    
    return 0;
}


int conv_hex()
{
    int i=0;
    int j,k=0;
    unsigned int ch;
    unsigned char cnt=0x0;

    fseek(src_file1,0L,SEEK_END);	
	length = ftell(src_file1);
    img1 = malloc(length);
    fseek(src_file1,0L,SEEK_SET);
printf("1 length is %d\n",length);

    fseek(src_file2,0L,SEEK_END);	
	length = ftell(src_file2);
    img2 = malloc(length);
    fseek(src_file2,0L,SEEK_SET);
printf("2 length is %d\n",length);

    while((ch = getc(src_file1)) != EOF)	
	{
        if( (ch >= '0' && ch <= '9') || 
            (ch >= 'a' && ch <= 'f') || 
		    (ch >= 'A' && ch <= 'F')
          ) 
        {
            if(cnt==0x00) j=1; 
            else j=0;  
            cnt = ~cnt;
            if(ch>='0' && ch<='9')
            { 
                img1[i] |= ((ch - '0')&0x0f) << (4*j);
            }
            else if(ch>='a' && ch<='f' )
            {
                img1[i] |= (((ch - 'a')+10)&0x0f) << (4*j);
            }
            else if(ch>='A' && ch<='F')
            {
                img1[i] |= (((ch - 'A')+10)&0x0f) << (4*j);
            }
            if(j==0){
                i++;
            }
        }
    }
    
    i=0;
    j=0;
    cnt=0;

    while((ch = getc(src_file2)) != EOF)	
	{
        if( (ch >= '0' && ch <= '9') || 
            (ch >= 'a' && ch <= 'f') || 
		    (ch >= 'A' && ch <= 'F')
          ) 
        {
            if(cnt==0x00) j=1; 
            else j=0;  
            cnt = ~cnt;
            if(ch>='0' && ch<='9')
            { 
                img2[i] |= ((ch - '0')&0x0f) << (4*j);
            }
            else if(ch>='a' && ch<='f' )
            {
                img2[i] |= (((ch - 'a')+10)&0x0f) << (4*j);
            }
            else if(ch>='A' && ch<='F')
            {
                img2[i] |= (((ch - 'A')+10)&0x0f) << (4*j);
            }
            if(j==0){
                i++;
            }
        }
    }
   
}

int help()
{
	printf(" image compare\n");
	printf(" usage => \n");
	printf(" $ run.exe bilinear.dat photoshop.dat \n");
    return 1;
}

