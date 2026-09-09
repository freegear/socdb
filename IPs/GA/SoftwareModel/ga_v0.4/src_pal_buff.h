/****************************************************
  
   Header of the Read Palette of a source picture

   file name : src_pal_buff.h
   created by gtlee
   data : 2006.10.19

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


// for source palette buffer
#define    SRCPL_BUFF_WLEGTH     4     // word count
#define    SRCPL_BUFF_INDEX      4     // bit width of the offset address
#define    SRCPL_BUFF_IDX_MSK    0x0F  // 16byte¿Ãπ«∑Œ.



#ifdef    __SRC_PAL_BUFF__ //=======================
// Local

int chk_src_pal_full(void);
void set_pal_full(void);
int chk_src_pal_rd(void);
void read_src_pal(uint addr);
int chk_src_pal(uint addr);
uint rd_src_pal(uint addr);



#else // __SRC_PAL_BUFF__ //========================
// External

extern int chk_src_pal_full(void);
extern void set_pal_full(void);
extern int chk_src_pal_rd(void);
extern void read_src_pal(uint addr);
extern int chk_src_pal(uint addr);
extern uint rd_src_pal(uint addr);


#endif // __SRC_PAL_BUFF__ //========================

