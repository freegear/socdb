/****************************************************

   Header of the Load configuration files to memory

   file name : ld_file.h
   created by gtlee
   data : 2006.6.28

   note :
         
   history :

*****************************************************/
//--------------------------------------------------
// Global

#define  BMP_HSIZE   54 // header size of a bmp file


#ifdef __LD_FILE__
//--------------------------------------------------
// local
void ld_close(void);

int ld_pic(uint vmoff, char *list_name);
int ld_bmp(char *fname, uchar *buff, int hsize, int size);

int ld_cmdstr(uint vm_addr, uint *cmdlist, char *listfn);
uint ld_cmd(uint vm_addr, char *cmdfn);

int ld_pal_list(uint vm_addr, uint *pallist, char *pflname);
uint ld_pal(uint vm_addr, char *palfn);

#else
//--------------------------------------------------
// external

extern s_pic     picture[16];
extern uint      palette[8];
extern uint      cmdstr_list[100];

extern int ld_pic(uint vmoff, char *list_name);
extern int ld_cmdstr(uint vm_addr, uint *cmdlist, char *listfn);
extern int ld_pal_list(uint vm_addr, uint *pallist, char *pflname);

extern void ld_close(void);


#endif
