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
#define   NOPMEM         0

#endif  // __BUFF_CNTL_DEF__


// for source palette buffer
#define    SRCPL_BUFF_WLEGTH     4     // word count
#define    SRCPL_BUFF_INDEX      4     // bit width of the offset address
#define    SRCPL_BUFF_IDX_MSK    0x0F  // 16byte¿Ãπ«∑Œ.



#ifdef    __SRC_PAL_BUFF__
//==================================================
// Local








#else // not __SRC_PAL_BUFF__
//==================================================
// External










#endif // __SRC_PAL_BUFF__

