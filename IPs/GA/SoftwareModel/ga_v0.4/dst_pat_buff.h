/****************************************************

   Header of the destination mask pattern Read Buffer

   file name : dst_pat_buff.h
   created by gtlee
   data : 2006.10.14

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




// for destination pattern buffer
#define    DSTP_BUFF_WLEGTH     2     // word count
#define    DSTP_BUFF_INDEX      3     // offset address bit width
#define    DSTP_BUFF_IDX_MSK    0x07  // 8byte¿Ãπ«∑Œ.






#ifdef    __DST_PAT_BUFF__ //==================================
// Local

int chk_dst_pat_full(int index);
int chk_dst_pat_rd(void);
int get_dst_pat_used_fg(void);
void read_dst_pat(uint pat_addr);
int chk_dst_pat(uint addr);
int rd_dst_pat(int hpos);




#else  // not  __DST_PAT_BUFF__ //=============================
// External

extern int chk_dst_pat_full(int index);
extern int chk_dst_pat_rd(void);
extern int get_dst_pat_used_fg(void);
extern void read_dst_pat(uint pat_addr);
extern int chk_dst_pat(uint addr);
extern int rd_dst_pat(int hpos);


#endif //  __DST_PAT_BUFF__ //=================================
