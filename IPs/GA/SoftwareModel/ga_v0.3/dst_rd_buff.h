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
#define   NOPMEM         0

#endif   //  __BUFF_CNTL_DEF__

// for destination buffer
#define    DST_BUFF_WLEGTH     8     // word count
#define    DST_BUFF_INDEX      5     // offset address  bit width
#define    DST_BUFF_IDX_MSK    0x1F  // 32byte¿Ãπ«∑Œ.




#ifdef    __DST_RD_BUFF__
//==================================================
// Local








#else 
//==================================================
// External






#endif
