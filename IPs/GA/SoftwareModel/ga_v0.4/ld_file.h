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



#ifdef    __LD_FILE__ //============================================
// local

int ld_pic(char *list_name);
int ld_bmp(char *fname, uint *buff, int hsize, int size);
int ld_pal_list(char *pflname);
int ld_pal(uint *buff, char *palfn);
int ld_cmdstr(char *listfn);
int ld_cmd(uint *vm_addr, uint **end_addr, char *cmdfn);
void ld_close(void);


#else // __LD_FILE__ //============================================
// external

extern s_pic     picture[16];
extern uint      palette[8];
extern uint      cmdstr_list[100];


extern int ld_pic(char *list_name);
extern int ld_bmp(char *fname, uint *buff, int hsize, int size);
extern int ld_pal_list(char *pflname);
extern int ld_pal(uint *buff, char *palfn);
extern int ld_cmdstr(char *listfn);
extern int ld_cmd(uint *vm_addr, uint **end_addr, char *cmdfn);
extern void ld_close(void);

#endif // __LD_FILE__  //============================================
