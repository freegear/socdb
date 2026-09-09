/****************************************************
  
   header of the source picture mask pattern buffer

   file name : src_pat_buff.h
   created by gtlee
   data : 2006.10.18

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

#endif // __BUFF_CNTL_DEF__



// for source pattern buffer
#define    SRCP_BUFF_WLEGTH     2     // word count
#define    SRCP_BUFF_INDEX      3     // offset address bit width
#define    SRCP_BUFF_IDX_MSK    0x07  // 8byte¿Ãπ«∑Œ.






#ifdef    __SRC_PAT_BUFF__  //=======================
// Local


int chk_src_pat_full(int index);
int chk_src_pat_rd(void);
void read_src_pat(uint pat_addr, int lowb);
int chk_src_pat(uint addr, int lowb);
int rd_src_pat(int hpos, int lowb);
int rd_src_pat_two(uint addr0, uint addr1, uint hpos,
				   uint *pixel0, uint *pixel1);
int chk_src_pat_buff(uint addr);




#else //  __SRC_PAT_BUFF__  //=======================
// External

extern int chk_src_pat_full(int index);
extern int chk_src_pat_rd(void);
extern void read_src_pat(uint pat_addr, int lowb);
extern int chk_src_pat(uint addr, int lowb);
extern int rd_src_pat(int hpos, int lowb);
extern int rd_src_pat_two(uint addr0, uint addr1, uint hpos,
				   uint *pixel0, uint *pixel1);
extern int chk_src_pat_buff(uint addr);


#endif //  __SRC_PAT_BUFF__  //=======================
