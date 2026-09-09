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


uint      cmdstr_list[100]={0}; // the list of the command structure
                           // if 0, end


// the virtual memory address of palettes
uint      palette[8] = {0};

FILE     *pal_list = NULL;
FILE     *pal = NULL;







//=================================================
// Load Pictures
// BMP와 24bpp의 color배열은 동일.
// video buffer도 line단위로 align을 맞추므로 BMP와 동일
// --> bmp를 그대로 load해도 됨.

int ld_pic(uint vmoff, char *list_name)
// vmoff : virtual memory offset address
// list_name : picture structure file list
// return : number of picture
{
	int       pic_num;
	int       size;
	char      str[104];
	int       maxx, maxy;
	uchar    *next_pic;

	// open list file
	pic_list = fopen(list_name,"r");
	if(pic_list == NULL) {
		printf("\n ERROR : no picture list file");
		exit(0);
	}

	// 32byte align
	next_pic = vmm_base + vmoff;
	next_pic += (((uint)next_pic & 0x1f)==0)? 0 : 0x1f;
	next_pic = (uchar *)((uint)next_pic & (~(0x0001f)));
	
	for(pic_num=0;pic_num<16;pic_num++) {
		// read bmp file name
		str[0] = 0;
		if(fscanf(pic_list,"%100s", str) == EOF) {
			if(pic_num == 0) {
				printf("\n ERROR : No Picture file : %s",list_name);
				fclose(pic_list);
				pic_list = NULL;
				exit(0);
			} // if
			else {
				printf("\n End Picture : %s",list_name);
				fclose(pic_list);
				pic_list = NULL;
				break;
			}
		} // if
		if(strlen(str) == 0) break; // end file
		if(fscanf(pic_list,"%d %d", &maxx, &maxy) == EOF) {
			printf("\n ERROR : Unexpected end of the BMP file list : %s",list_name);
			fclose(pic_list);
			pic_list = NULL;
			exit(0);
		} // if

		// line의 size 계산.
		// expected file size
		size = calc_hsize(C24BPP,maxx) * maxy; // color type of a BMP is 24bpp
		//size = maxx * maxy * 3;  <== old version
		
		picture[pic_num].addr = (uint)(next_pic - vmm_base);
		if((picture[pic_num].addr + size) >= vmm_size) {
			printf("\n ERROR : Virtual main memory size is small than the pictures.");
			fclose(pic_list);
			pic_list = NULL;
			exit(0);
		} // if

		// load bmp file
		ld_bmp(str,next_pic,maxx,size);

		picture[pic_num].maxx = maxx;
		picture[pic_num].maxy = maxy;
		picture[pic_num].type = C24BPP; // BMP file
		picture[pic_num].palette = 0;
#ifdef __DEBUG__
		printf("\n Picture loaded : %s",str);
		printf("\n size : %d, %d",picture[pic_num].maxx,
			   picture[pic_num].maxy);
		printf("\n type : %d", picture[pic_num].type);
		printf("\n Virtual memory address : %x\n",picture[pic_num].addr);
#endif
		// 32byte align
		next_pic += size + 100;
		next_pic += (((uint)next_pic & 0x1f)==0)? 0 : 0x1f;
		next_pic = (uchar *)((uint)next_pic & (~0x0001f));
	} // for

	return pic_num;
}

int ld_bmp(char *fname, uchar *buff, int hsize, int size)
// fname : bmp file name
// buff : destination buffer address
// hsize : horizontal pixels
// size : the total size of a picture 
// return : SUCC/FAIL
{
	int       small;
	//int     i;
	//int     h_pos; // horizontal position for skipping align dummy
	//int     skip_byte; // size of align dummy
	//uchar   r,g,b;
	//int     ch;
	struct stat   fstat;

	if(stat(fname,&fstat) != 0) {
		printf("\n ERROR : Cannot get file state : %s",fname);
		exit(0);
	}
	
	if((fstat.st_size-BMP_HSIZE) > size) {
		printf("\n ERROR : BMP file size is not correct : %s",fname);
		exit(0);
	}
	
	bmp = fopen(fname, "rb");
	if(bmp == NULL) {
		printf("\n ERROR : Cannot open BMP file, %s",fname);
		exit(0);
	}

	// skip header
	fseek(bmp,BMP_HSIZE,SEEK_SET);

	// block transfer
	small = fstat.st_size - BMP_HSIZE;
	fread(buff, 1, small, bmp);

/*  // 24bpp display buffer와 bmp가 동일한 format으로 저장되므로 아래의 변환은 불필요.
	// calc. the size of a BMP align dummy <= no need
	skip_byte = 4 - ((hsize * 3)%4);

	for(h_pos=0,i=0;i<size;i++) {
		ch = fgetc(bmp);
		if(ch == EOF) {
			printf("\n ERROR : Unexpected end of the BMP file : %s",fname);
			fclose(bmp);
			bmp = NULL;
			exit(0);
		} // if
		
		if(i%3 == 0) b = ch;
		else if(i%3 == 1) g = ch;
		else {
			r = ch;
			// write color
			*(buff+i-2) = (uchar) r;
			*(buff+i-1) = (uchar) g;
			*(buff+i  ) = (uchar) b;
			h_pos ++;

			if(skip_byte != 0 && h_pos == 0) { // align dummy가 있을 경우
				fseek(bmp,skip_byte, SEEK_CUR);
			}// if
		} // else
	} // for
*/
	fclose(bmp);
	bmp = NULL;

	return SUCC;

}


//=============================================================
// load command structure

int ld_cmdstr(uint vm_addr, uint *cmdlist, char *listfn)
// vm_addr : target virtual memory address
// cmdlist : command structure list address
// listfn : command list file name
// return : count of the command structure lists
{
	FILE     *list = NULL;
	char     fname[104];
	int      cmdnum;
	uint     trg_addr;
	uint     next_addr;
	
	// file open
	list = fopen(listfn,"r");
	if(list == NULL) {
		printf("\n ERROR : cannot open the command list file : %s",
			   listfn);
		exit(0);
	} // if
	
	cmdnum = 0;
	trg_addr = vm_addr;
	while((fscanf(list,"%100s",fname) != EOF) &&
		  (cmdnum < 99))  {
		// load a file
		next_addr = ld_cmd(trg_addr, fname);
		if(trg_addr == 0) {
			fclose(list);
			exit(0);
		} // if

		// set the start address of the command structures
		*(cmdlist+cmdnum) = trg_addr;
		// connection command linked list
		if(lnklist(trg_addr, next_addr-1) == 0) {
			*(cmdlist+cmdnum) = 0;
			fclose(list);
			exit(0);
		} // if

		trg_addr = next_addr;
		cmdnum ++;
	} // while
	
	fclose(list);
	return cmdnum;
} // ld_cmdstr



uint ld_cmd(uint vm_addr, char *cmdfn)
// vm_addr : target virtual memory address
// cmdfn : command file name
// return : next virtual memory offset
{
	FILE     *cmdf = NULL;
	uint      cmd;
	int       ch;
	int       bytes; // 0 ~ 7
	int       vm_off;
	int       ignore;
	
	cmdf = fopen(cmdfn,"r");
	if(cmdf == NULL) {
		printf("\n ERROR : cannot open the command file : %s",
			   cmdfn);
		return 0;
	} // if

	bytes = 0;
	vm_off = vm_addr;
	vm_off += ((vm_off % 32) == 0)? 0 : 32 ;
	vm_off &= ~(0x1f);
	ignore = 0;
	cmd = 0;

	while(1) {
		ch = getc(cmdf);
		if(ch == EOF) {
			if(bytes != 0) *(uint *)(vmm_base + vm_off) = cmd;
			break;
		} // if
		
		// shift 
		if(ch == '\n') {
			bytes = 3;
			ignore = 0; // end of a ignore
		}
		else if(ignore == 1) continue;
		else if(ch == '/') { // if a comment line
			bytes = 3;
			// skip to the end of a line
			ignore = 1;
		}
		else {
			if(ch >= '0' && ch <= '9') ch -= '0';
			else if(ch >= 'a' && ch <= 'f') ch -= 'a' + 10;
			else if(ch >= 'A' && ch <= 'F') ch -= 'A' + 10;
			else continue; // ignore charater
		
			ch &= 0x0f;
			cmd = (cmd << 4) + ch;
		}

		if(bytes == 0x03) {
			*(uint *)(vmm_base + vm_off) = cmd;
			vm_off += 4;
		} // if
			
		bytes ++;
		bytes &= 0x03;

	} // while(1)

	fclose(cmdf);
	if(vm_off == vm_addr) return 0;
	
	return vm_off;

} // ld_cmd


//=============================================================
// load palettes
// max number is 8

//     load palette list file
//     palette은 없어도 상관없음.
int ld_pal_list(uint vm_addr, uint *pallist, char *pflname)
// vm_addr : the target the virtual memory address
// pallist : palette list address
// pflname : palette list file name
// return : count of palettes
{
	FILE    *pallf = NULL;
	char     fname[104];
	int      palnum; // count of palettes
	uint     trg_addr;
	uint     next_addr;

	// file open
	pallf = fopen(pflname,"r");
	if(pallf == NULL) {
		printf("\n ERROR : cannot open the palette list file : %s",
			   pflname);
		return 0;
	} // if
	
	palnum = 0;
	trg_addr = vm_addr;
	while((fscanf(pallf,"%100s",fname) != EOF) &&
		  (palnum < 8)) {
		// load a file
		*(pallist+palnum) = trg_addr;
		next_addr = ld_pal(trg_addr, fname);
		if(trg_addr == 0) {
			*(pallist+palnum) = 0;
			break;
		} // if

		trg_addr = next_addr;
		palnum ++;
	} // while
	
	fclose(pallf);
	
	return palnum;
} // ld_pal_list


// load palette file
uint ld_pal(uint vm_addr, char *palfn)
// vm_addr : target virtual memory address
// palfn : palette file name
// return : next virtual memory affset
{
	FILE     *palf = NULL;
	uint      pal;
	int       ch;
	int       bytes; // 0 ~ 7
	int       vm_off;
	int       ignore;

	palf = fopen(palfn,"r");
	if(palf == NULL) {
		printf("\n ERROR : cannot open the palette file : %s",
			   palfn);
		return 0;
	} // if
	
	bytes = 0;
	vm_off = vm_addr;
	vm_off += ((vm_off % 32) == 0)? 0 : 32 ;
	vm_off &= ~(0x1f);
	ignore = 0;
	pal = 0;

	while(1) {
		ch = getc(palf);
		if(ch == EOF) {
			if(bytes != 0) *(uint *)(vmm_base + vm_off) = pal;
			break;
		} // if
		
		// shift 
		if(ch == '\n') {
			bytes = 3;
			ignore = 0; // end of a ignore
		}
		else if(ignore == 1) continue;
		else if(ch == '/') { // if a comment line
			bytes = 3;
			// skip to the end of a line
			ignore = 1;
		}
		else {
			if(ch >= '0' && ch <= '9') ch -= '0';
			else if(ch >= 'a' && ch <= 'f') ch -= 'a' + 10;
			else if(ch >= 'A' && ch <= 'F') ch -= 'A' + 10;
			else continue; // ignore charater
		
			ch &= 0x0f;
			pal = (pal << 4) + ch;
		}

		if(bytes == 0x03) {
			*(uint *)(vmm_base + vm_off) = pal;
			vm_off += 4;
		} // if
			
		bytes ++;
		bytes &= 0x03;

	} // while(1)

	fclose(palf);
	if(vm_off == vm_addr) return 0;
	
	return vm_off;

} // ld_pal



//=============================================================
void ld_close(void)
{
	int    i;

	if(pic_list != NULL) fclose(pic_list);
	pic_list = NULL;

	if(bmp != NULL) fclose(bmp);
	bmp = NULL;

	/*
	for(i=0;i<16;i++) {
		if(picture[i].addr != 0) {
			free((char *)picture[i].addr);
			picture[i].addr = 0;
		}
	}
	*/
	
}
