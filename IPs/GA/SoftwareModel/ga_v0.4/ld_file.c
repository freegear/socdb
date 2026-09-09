/****************************************************

   Load Configuration file to memory

   file name : ld_file.c
   created by gtlee
   data : 2006.6.28

   note :
         
   history :

****************************************************/

#define __DEBUG__


#ifndef  __LD_FILE__
#define  __LD_FILE__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "ga.h"
#include "axi_if.h"

#include "ld_file.h"


// Infomation of pictures 
//   memory에 load한 picture의 정보를 관리하는 변수.
//   이를 이용해서 command structure를 setting
FILE     *pic_list = NULL;
FILE     *bmp = NULL;

s_pic     picture[16] = {0};

// the virtual memory address of palettes
FILE     *pal_list = NULL;
FILE     *pal = NULL;

//     store memory pointer
uint      palette[8] = {0};


// command list
//     store memory pointer
uint      cmdstr_list[100]={0}; // the list of the command structure
                           // if 0, end




//=================================================
// Load Pictures
// BMP file을 읽어 picture structure를 initialize한다.
// BMP와 24bpp의 color배열은 동일.
// video buffer도 line단위로 align을 맞추므로 BMP와 동일
// --> bmp를 그대로 load해도 됨.

int ld_pic(char *list_name)
// list_name : picture structure file list
// return : number of picture
{
	int       pic_num;
	int       size;
	char      str[104];
	int       maxx, maxy;
	int       palette;


	// open list file
	pic_list = fopen(list_name,"r");
	if(pic_list == NULL) {
		printf("\n ERROR : no picture list file");
		exit(0);
	}

	for(pic_num=0;pic_num<16;pic_num++) {
		// read bmp file name
		str[0] = 0;
		if(fscanf(pic_list,"%100s", str) == EOF) {
			if(pic_num == 0) {
				printf("\n ERROR : No Picture file : %s",list_name);
				if(pic_list != NULL) {
					fclose(pic_list);
					pic_list = NULL;
				} // if
				exit(0);
			} // if
			else {
				printf("\n End Picture : %s",list_name);
				break;
			}
		} // if
		if(strlen(str) == 0) break; // end file
		if(fscanf(pic_list,"%d %d", &maxx, &maxy) == EOF) {
			printf("\n ERROR : Unexpected end of the BMP file list : %s",list_name);
			if(pic_list != NULL) {
				fclose(pic_list);
				pic_list = NULL;
			} // if
			exit(0);
		} // if

		if(fscanf(pic_list,"\nP%d", &palette) == EOF) {
			printf("\n ERROR : Unexpected end of the BMP file list : %s",list_name);
			if(pic_list != NULL) {
				fclose(pic_list);
				pic_list = NULL;
			} // if
			exit(0);
		} // if

		// line의 size 계산.
		// expected file size
		size = calc_hsize(C24BPP,maxx) * maxy; // color type of a BMP is 24bpp
		
		// load bmp file
		if(ld_bmp(str,&picture[pic_num].addr,maxx,size) == FAIL) {
			// if fail.
			if(pic_list != NULL) {
				fclose(pic_list);
				pic_list = NULL;
			} // if
			exit(0);
		} // if

		picture[pic_num].maxx = maxx;
		picture[pic_num].maxy = maxy;
		picture[pic_num].type = C24BPP; // BMP file
		picture[pic_num].palette = palette & 7;
#ifdef __DEBUG__
		printf("\n Picture loaded : %s",str);
		printf("\n size : %d, %d",picture[pic_num].maxx,
			   picture[pic_num].maxy);
		printf("\n type : %d", picture[pic_num].type);
		printf("\n memory address : %x",picture[pic_num].addr);
		printf("\n Palette number : %d\n", picture[pic_num].palette);
#endif
	} // for

	if(pic_list != NULL) {
		fclose(pic_list);
		pic_list = NULL;
	} // if

	return pic_num;
} // ld_pic






//-------------------------------------------------------
// Load BMP file to memory
int ld_bmp(char *fname, uint *buff, int hsize, int size)
// fname : bmp file name
// buff : for store a picture buffer address
// hsize : horizontal pixels
// size : the total size of a picture 
// return : SUCC/FAIL
{
	int       small;
	uchar    *mem;   // allocated memory pointer
	struct stat   fstat;

	if(stat(fname,&fstat) != 0) {
		printf("\n ERROR : Cannot get file state : %s",fname);
		return FAIL;
	}
	
	if((fstat.st_size-BMP_HSIZE) > size) {
		printf("\n ERROR : BMP file size is not correct : %s",fname);
		return FAIL;
	}
	
	bmp = fopen(fname, "rb");
	if(bmp == NULL) {
		printf("\n ERROR : Cannot open BMP file, %s",fname);
		return FAIL;
	}

	// skip header
	fseek(bmp,BMP_HSIZE,SEEK_SET);

	// block transfer size
	small = fstat.st_size - BMP_HSIZE;

	// allocate memory
	mem = malloc(small+16);

	if(mem == NULL) {
		printf("\n ERROR : Picture memory allocation has a error.");
		fclose(bmp);
		bmp = NULL;
		return FAIL;
	}

	*buff = (uint)mem;

	fread(mem, 1, small, bmp);

	fclose(bmp);
	bmp = NULL;

	return SUCC;
} // ld_bmp







//=============================================================
// load palettes
// max number is 8

// load palette list file
//     palette은 없어도 상관없음.
int ld_pal_list(char *pflname)
// pflname : palette list file name
// return : count of palettes
{
	FILE    *pallf = NULL;
	char     fname[104];
	int      palnum; // count of palettes
	uint     mem;
	uint     next_addr;

	// file open
	pallf = fopen(pflname,"r");
	if(pallf == NULL) {
		printf("\n ERROR : cannot open the palette list file : %s",
			   pflname);
		return 0;
	} // if
	
	palnum = 0;
	while((fscanf(pallf,"%100s",fname) != EOF) &&
		  (palnum < 8)) {
		// load a file
		if(ld_pal(&mem, fname) == FAIL) {
			fclose(pallf);
			pallf = NULL;
			exit(0);
		}
		palette[palnum] = mem;
		palnum ++;
	} // while
	
	fclose(pallf);
	pallf = NULL;
	
	return palnum;
} // ld_pal_list






//-----------------------------------------------------
// load palette file
// Length of a p alette is 256 words.
int ld_pal(uint *buff, char *palfn)
// buff : return memory address pointer
// palfn : palette file name
// return : SUCC/FAIL
{
	FILE     *palf = NULL;
	uint     *mem;
	uint      pal;
	int       ch;
	int       bytes; // 0 ~ 7
	int       words; // palette words
	int       ignore;

	palf = fopen(palfn,"r");
	if(palf == NULL) {
		printf("\n ERROR : cannot open the palette file : %s",
			   palfn);
		return SUCC;
	} // if
	
	// allocate memory
	mem = malloc(256*sizeof(uint));

	if(mem == NULL) {
		printf("\n ERROR : Palette memory allocation has a error.");
		fclose(palf);
		palf = NULL;
		return FAIL;
	}
	*buff = (uint)mem; // return memory address

	bytes = 0;
	ignore = 0;
	pal = 0;
	words = 0;

	while(words < 256) {
		ch = getc(palf);
		if(ch == EOF) {
			if(bytes != 0) {
			*mem = pal;
			}				
			break;
		} // if
		
		// shift 
		if(ch == '\n') {
			bytes = 0;
			ignore = 0; // end of a ignore
			continue;
		}
		else if(ignore == 1) continue;
		else if(ch == '/') { // if a comment line
			bytes = 7;
			// skip to the end of a line
			ignore = 1;
		}
		else {
			if(ch >= '0' && ch <= '9') ch -= '0';
			else if(ch >= 'a' && ch <= 'f') ch = ch - 'a' + 10;
			else if(ch >= 'A' && ch <= 'F') ch = ch - 'A' + 10;
			else continue; // ignore charater
		
			ch &= 0x0f;
			pal = (pal << 4) + ch;
		}

		if(bytes == 7) {
			*mem = pal;
#ifdef   __DEBUG__
			printf("\n PAL : %08X",pal);
#endif
			mem ++; // to next point
			words ++;
			bytes = 0;
			pal = 0;
		} // if
		else {
			bytes ++;
		} // else
	} // while(1)

	// fill dummy
	for(;words<256;words++) {
		*mem = 0;
		mem ++;
	} // for

	if(palf != NULL) fclose(palf);
	
	return SUCC;
} // ld_pal






//=============================================================
// load command structure
//   picture information, palette information등은 직접 memory address를 
//   지정하지 않고, 기반 자료 structure에서의 순번을 지정함.
//   --> 이를 pointer로 변환하는 함수를 제공.
int ld_cmdstr(char *listfn)
// listfn : command list file name
// return : count of the command structure lists
{
	FILE     *list = NULL;
	char     fname[104];
	int      cmdnum;
	uint     mem;
	uint     *end_addr;
	
	// file open
	list = fopen(listfn,"r");
	if(list == NULL) {
		printf("\n ERROR : cannot open the command list file : %s",
			   listfn);
		exit(0);
	} // if
	
	cmdnum = 0;
	while((fscanf(list,"%100s",fname) != EOF) &&
		  (cmdnum < 99))  {
		// load a file
		if(ld_cmd(&mem, &end_addr, fname) == FAIL) {
			fclose(list);
			list = NULL;
			exit(0);
		} // if
		
		cmdstr_list[cmdnum] = mem;

		// connection command linked list
		if(lnklist((uint*)mem, end_addr) == 0) {
			cmdstr_list[cmdnum] = 0;
			fclose(list);
			list = NULL;
			exit(0);
		} // if

		cmdnum ++;
	} // while
	
	fclose(list);
	list = NULL;

	return cmdnum;
} // ld_cmdstr







//--------------------------------------------------------
// load a command structure to memory
//    512byte단위로 allocation한 뒤 모자라면 더 큰 memory를 allocation,
//    그리고 복사.
int ld_cmd(uint *vm_addr, uint **end_addr, char *cmdfn)
// vm_addr : target memory address
// end_addr :
// cmdfn : command file name
// return : FAIL/SUCC
{
	FILE     *cmdf = NULL;
	uint     *mem;
	uint     *mem_s;
	uint      cmd;
	int       ch;
	int       bytes; // 0 ~ 7
	int       words; // 총 word길이.
	int       ignore;
	
	cmdf = fopen(cmdfn,"r");
	if(cmdf == NULL) {
		printf("\n ERROR : cannot open the command file : %s",
			   cmdfn);
		return FAIL;
	} // if

	// allocate memory
	mem = malloc(512*sizeof(uint));

	if(mem == NULL) {
		printf("\n ERROR : command memory allocation has a error.");
		fclose(cmdf);
		return FAIL;
	}
	*vm_addr = (uint)mem; // copy a address of the command structure.

	bytes = 0;
	ignore = 0;
	cmd = 0;
	words = 0;
	while(1) {
		ch = getc(cmdf);
		if(ch == EOF) {
			if(bytes != 0) {
				*mem = cmd;
				mem ++;
			} // if
			break;
		} // if  ch
		
		// shift 
		if(ch == '\n') {
			bytes = 0;
			ignore = 0; // end of a ignore
			continue;
		} // if ch
		else if(ignore == 1) continue;
		else if(ch == '/') { // if a comment line
			bytes = 7;
			// skip to the end of a line
			ignore = 1;
		} // else if ch
		else {
			if(ch >= '0' && ch <= '9') ch -= '0';
			else if(ch >= 'a' && ch <= 'f') ch = ch - 'a' + 10;
			else if(ch >= 'A' && ch <= 'F') ch = ch - 'A' + 10;
			else continue; // ignore charater
		
			ch &= 0x0f;
			cmd = (cmd << 4) + ch;
		} // else

		if(bytes == 7) {
			if((words&0x1ff) == 0 && words != 0) {
				// buffer is full
				// --> replace memory block
				mem_s = (uint *)vm_addr;
				
				mem = malloc(((words>>9)+1)*512*sizeof(uint));
				
				if(mem == NULL) {
					printf("\n ERROR : command memory allocation has a error.");
					if(cmdf != NULL) {
						fclose(cmdf);
						cmdf = NULL;
					}
					*vm_addr = 0;
					free(mem_s);
					return FAIL;
				} // if mem
	
				*vm_addr = (uint)mem; // copy a address of the command structure.
				
				memcpy(mem, mem_s, (words>>9)*512*sizeof(uint)); // copy commands
				free(mem_s);

				mem += words; // set new write position
			}// if words
			*mem = cmd; // copy a command
#ifdef   __DEBUG__
			printf("\n CMD : %08X : %08X",mem,cmd);
#endif
			mem ++; // next write position
		} // if bytes
			
		bytes ++;

	} // while(1)

	// return last address
	*end_addr = mem - 1;

	if(cmdf != NULL) {
		fclose(cmdf);
		cmdf = NULL;
	} // if cmdf

	return SUCC;

} // ld_cmd








//=============================================================
// file과 memory를 close/free시킨다.
void ld_close(void)
{
	int    i;

	if(pic_list != NULL) fclose(pic_list);
	pic_list = NULL;

	if(bmp != NULL) fclose(bmp);
	bmp = NULL;


	if(pal_list != NULL) fclose(pal_list);
	pal_list = NULL;

	if(pal != NULL) fclose(pal);
	pal = NULL;


	for(i=0;i<16;i++) {
		if(picture[i].addr != 0) {
			free((char *)picture[i].addr);
			picture[i].addr = 0;
		} // if
	} // for

	for(i=0;i<8;i++) {
		if(palette[i] != 0) {
			free((char *)palette[i]);
			palette[i] = 0;
		} // if
	} // for
	
	
	for(i=0;i<100;i++) {
		if(cmdstr_list[i] != 0) {
			free((char *)cmdstr_list[i]);
			cmdstr_list[i] = 0;
		} // if
	} // for
	
} // ld_close
