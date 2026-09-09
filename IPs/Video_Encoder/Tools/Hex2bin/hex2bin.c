/*
  Hex to Binary

  created by gtlee

  date : 2005.11.21

  note :

  history :
*/


//#define   __DEBUG__

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/stat.h>

FILE  *srcfile = NULL;
FILE  *dstfile = NULL;


void exit_fun(void);
void help(void);
int  chk_hex(unsigned char ch);
int  cnv_hex2bin(unsigned char ch);

int main(int argc, char *argv[])
{
	struct stat fstat;

	int         s_pnt; // start pointer
	int         e_pnt; // end pointer
	int         n_pnt; // now pointer
	int         i;
	char        ch;
	int         value;
	
	atexit(exit_fun);
	
	// get list file name
	if(argc < 3) {
		help();
		exit(0);
	}

#ifdef  __DEBUG__
	printf("\n input file name : %s",argv[1]);
#endif

	//---------------------------------------------
	//---- check file size
	stat(argv[1],&fstat);
	if(fstat.st_size < 1) {
		printf("\nERROR : the input file size is too small.");
		exit(0);
	}
	
	//---- source file open
	srcfile = fopen(argv[1],"rb");
	if(srcfile == NULL) {
		printf("\nERROR : Cannot open source file : %s",argv[1]);
		exit(0);
	}
	
	//---------------------------------------------
	// destination file name
	dstfile = fopen(argv[2],"wb");
	if(dstfile == NULL) {
		printf("\nERROR : Cannot open destination file : %s",argv[2]);
		exit(0);
	}
	
	//----------------------------------------------
	//
	//
	s_pnt = 0;
	e_pnt = 0;
	
#ifdef  __DEBUG__
		printf("Size of file = %d\n",fstat.st_size);
#endif

	while(s_pnt < fstat.st_size) {
		fseek(srcfile,s_pnt,SEEK_SET);
		ch = fgetc(srcfile);
		// search the first effective char.
		if(chk_hex(ch) == 1) { // if hex char,
			e_pnt = s_pnt+1;
			
			// search the end of an line
			while(e_pnt < fstat.st_size) {
				ch = fgetc(srcfile);
				if(chk_hex(ch) == 0)  // if not hex char,
					break;
				e_pnt ++;
			}

#ifdef  __DEBUG__
			printf("\nStart Point = %d\n",s_pnt);
			printf(  "End Point   = %d\n",e_pnt);
#endif

			// if end of the file and no effective char, exit
			if((e_pnt-1) == s_pnt) {  // if over the file, exit
				s_pnt = e_pnt;
				break;
			}
			
			// 유효한 hex char가 있을때.
			n_pnt = e_pnt - 1;

			for(i=e_pnt-s_pnt;i>0;i-=2,n_pnt-=2) {
				fseek(srcfile,n_pnt,SEEK_SET);
				value = 0x0f & cnv_hex2bin(fgetc(srcfile));
				if(i-1 > 0) {
					fseek(srcfile,n_pnt-1,SEEK_SET);
					value += cnv_hex2bin(fgetc(srcfile))<<4;
				}
#ifdef  __DEBUG__
			printf("value = %02x\n",value);
#endif
				fputc(value&0xff,dstfile);
			} // for
			s_pnt = e_pnt;
		} // if
		else s_pnt ++;
#ifdef  __DEBUG__
		printf("Start Point 2 = %d\n",s_pnt);
#endif
	} // while
	exit(0);
}



// 도움말 출력
void help(void)
{
	puts("\nConvert HEX to Binary.");
	puts("	USAGE : hex2bin [hex file name] [binary file name]");
	puts("			create binary file.");
}


// Free memory and close files
void exit_fun(void)
{
	if(srcfile != NULL) fclose(srcfile);
	if(dstfile != NULL) fclose(dstfile);
}


int  chk_hex(unsigned char ch)
{
	if(ch >= '0' && ch <='9') return 1;
	else if(ch >='a' && ch <='z') return 1;
	else if(ch >='A' && ch <='Z') return 1;
	else return 0;
}

int  cnv_hex2bin(unsigned char ch)
{
	if(ch >= '0' && ch <='9')     return ch - '0';
	else if(ch >='a' && ch <='z') return ch - 'a' + 10;
	else if(ch >='A' && ch <='Z') return ch - 'A' + 10;
	else return 0;
}
