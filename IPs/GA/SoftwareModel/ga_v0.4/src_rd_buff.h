/****************************************************

   Header of the Source Read Buffer

   file name : src_rd_buff.h
   created by gtlee
   data : 2006.10.16

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

#endif  // __BUFF_CNTL_DEF__

// for source pixel buffer
#define    SRC_BUFF_WLEGTH     4     // word count
#define    SRC_BUFF_INDEX      4     // bit width of the offset address
#define    SRC_BUFF_IDX_MSK    0x0F  // 16byte¿Ãπ«∑Œ.




#ifdef    __SRC_RD_BUFF__ //========================
// Local

int chk_src_full(int index);
int chk_src_rd(void);
void read_src(uint src_addr, int lowb);
int chk_src_pixel(uint addr, int lowb);
int chk_ld_src(int ctype, int hpos, int lowb);
uint rd_src_pixel(int ctype, int hpos, int lowb);
int rd_src_two(uint addr0, uint addr1, uint hpos,
			   int ctype,  uint *pixel0, uint *pixel1);
int chk_src_buff(uint addr);


#else // not __SRC_RD_BUFF__ //======================
// External

extern int chk_src_full(int index);
extern int chk_src_rd(void);
extern void read_src(uint src_addr, int lowb);
extern int chk_src_pixel(uint addr, int lowb);
extern int chk_ld_src(int ctype, int hpos, int lowb);
extern uint rd_src_pixel(int ctype, int hpos, int lowb);
extern int rd_src_two(uint addr0, uint addr1, uint hpos,
					  int ctype,  uint *pixel0, uint *pixel1);
extern int chk_src_buff(uint addr);


#endif // __SRC_RD_BUFF__ //======================

