/****************************************************

   Header of the Destination Read Buffer

   file name : dst_rd_buff.h
   created by gtlee
   data : 2006.10.12

   note :
         
   history :

****************************************************/

//==================================================
// global

#ifndef   __BUFF_CNTL_DEF__

#define   __BUFF_CNTL_DEF__
// operation mode define
#define   HIT            1
#define   MISS           0

#define   BYPASS         1
#define   RUN            0
#define   WAIT           1


#define   OPMEM          1
#define   NOMEM          0

#endif   //  __BUFF_CNTL_DEF__

// for destination buffer
#define    DST_BUFF_WLEGTH     8     // word count
#define    DST_BUFF_INDEX      5     // offset address  bit width
#define    DST_BUFF_IDX_MSK    0x1F  // 32byte¿Ãπ«∑Œ.




#ifdef    __DST_RD_BUFF__ //===============================
// Local

int chk_dst_full(int index);
int chk_dst_rd(void);
int get_dst_used_fg(void);
void read_dst(uint dst_addr);
int chk_dst_pixel(uint addr);
int sd_dummy_wd(uint *word, uint *addr);
void update_dummy_fg(int ctype, int st_addr, int ed_addr, int buff_num);
int chk_ld_dst(uint adddr, int ctype, int hpos);
uint rd_dst_pixel(int ctype, int hpos);



#else  //  __DST_RD_BUFF__ //===============================
// External

extern int chk_dst_full(int index);
extern int chk_dst_rd(void);
extern int get_dst_used_fg(void);
extern void read_dst(uint dst_addr);
extern int chk_dst_pixel(uint addr);
extern int sd_dummy_wd(uint *word, uint *addr);
extern void update_dummy_fg(int ctype, int st_addr, int ed_addr, int buff_num);
extern int chk_ld_dst(uint adddr, int ctype, int hpos);
extern uint rd_dst_pixel(int ctype, int hpos);

#endif   //  __DST_RD_BUFF__ //===============================
