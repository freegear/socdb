/******************************************************************************            
 *                                                                                         
 *  Title  : binToHexFileConverison.c                                                      
 *  Version 0.0,                                                                           
 *                                                                                         
 *  Description: This program converts binary file into hexadecimal text file..            
 *  Input: Binary file fileName.* (*.*)                                                    
 *  Output: Hex text file fileName.hex                                                     
 *                                                                                         
 *                                                                                         
 *  Author: Lukas Tomasek, tomasekl@fzu.cz                                                 
 *                                                                                         
 ******************************************************************************/           
                                                                                           
/******************************************************************************            
 *                              Header files                                  *            
 ******************************************************************************/           
                                                                                           
#include <stdio.h>                                                                        
                                                                                           
/******************************************************************************            
 *                               Definitions                                  *            
 ******************************************************************************/           
                                                                                           
/******************************************************************************            
 *                        Static Function Declarations                        *            
 ******************************************************************************/           
                                                                                           
                                                                                           
/******************************************************************************            
 *                                              Main                                      *
 ******************************************************************************/           
                                                                                           
int main(int argc, char *argv[]){                                                          
                                                                                           
        FILE *hexFileHandle;                                                               
        FILE *binFileHandle;                                                               
        size_t bytesRead;                                                                  
        char errorMessage[200];                                                            
        int status;                                                                        
        long binFileSize, i;                                                               
        char hexFileName[300];                                                             
        char binFileName[300];                                                             
        char directory[300];                                                               
        int hexValue;                                                                      
        unsigned char binValue;                                                            
        unsigned char convertValue;                                                        
        int length, dirLength;                                                             
                                                                                           
        memset(binFileName, 0, 300);                                                       
        memset(hexFileName, 0, 300);                                                       
        strcpy(binFileName,argv[1]); /* get input bin file name */                         
    printf("%s\n", binFileName);                                                           
                                                                                           
        /* create hex file name (*.hex) */                                                 
        length=strlen(binFileName)-4;                                                      
        strncpy(hexFileName, binFileName, length);                                         
                                                                                           
        strcat(hexFileName,".hex");                                                        
        printf("%s\n", hexFileName);                                                       
                                                                                           
        hexFileHandle = fopen (hexFileName, "w"); /* open text file for write */           
        binFileHandle = fopen (binFileName, "rb"); /* open binary file for read */         

		fseek(binFileHandle, 1, SEEK_END);
		binFileSize = ftell(binFileHandle);
		fseek(binFileHandle, 0, SEEK_SET);
        printf("binFileSize :%d\n",binFileSize);                                                                        
        //status=GetFileSize(binFileName, &binFileSize);                                     
        
        fprintf(hexFileHandle, "unsigned char bin_data_array[%d] = {\n", binFileSize);

        for(i=1;i<(binFileSize+1);++i){                                                        
                fread (&binValue, 1, 1, binFileHandle);                                    
				if( (i%8)==0 )
				{ 
                	fprintf(hexFileHandle,"0x%2.2X,\n", binValue);                                  
				}
				else
				{
               		fprintf(hexFileHandle,"0x%2.2X, ", binValue);                                  
				}
        }                                                                                  
        fprintf(hexFileHandle, "};\n");

        /* close files */                                                                  
        status=fclose(hexFileHandle);                                                      
        status=fclose(binFileHandle);                                                      
                                                                                           
        printf("----- PRESS ANY KEY -------\n\n");                                             
        getchar();                                                                         
                                                                                           
        return(0);                                                                         
}                                                                                          
                                                                                           
/******************************************************************************            
 *                              Static functions                              *            
 ******************************************************************************/           
                                                                                           
                                                                                           
/******************************************************************************/           
                                                                                                 
