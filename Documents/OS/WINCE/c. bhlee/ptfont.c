#include <stdio.h>
#include <curses.h>


void Usage(void);

#define DF_RD_SIZE   32 /*per 4byte */
#define FNT_8x8      8
#define FNT_16x16    16
#define ARG_COUNT    3 

int main(int argc, char **argv)
{
    FILE *fp;
    int fileSz;
    int fontSz;

    int i,j;

    int vCount;

    char out, currLine;

    if(argc<ARG_COUNT)
    {
        Usage();
        goto exit_program;
    }

    fontSz = atoi(argv[2]);
    
    fp = fopen(argv[1],"r"); 
    if(fp==NULL) 
    {
        printf("UnExist Files\n");
    }
    
    fseek(fp, 1,  SEEK_END);
    fileSz = ftell(fp);
    fseek(fp, 0,  SEEK_SET);

    printf("Font FileName : %s\n", argv[1]);
    printf("Font Size     : %d\n", fontSz);
    printf("File Size     : %d\n\n\n", fileSz);

    while(!feof(fp))
    {
       for(vCount=0;vCount<16;vCount++)
       {
           for(i=0;i<2;i++)
           {
               currLine = fgetc(fp);

               for(j=0;j<8;j++)
               {
                   out = currLine & (0x80>>j);

                   if(out!=0) printf("#");
                   else printf("*");
               }
           }
           printf("\n");
      } 

      printf("\n");
      printf("\n");

    }// while

exit_program:
    
    fclose(fp);


    return 0;
}


void Usage(void)
{
    
} 
