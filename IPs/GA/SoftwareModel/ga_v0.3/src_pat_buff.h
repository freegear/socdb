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
#define   NOPMEM         0

#endif



// for source pattern buffer
#define    SRCP_BUFF_WLEGTH     2     // word count
#define    SRCP_BUFF_INDEX      3     // offset address bit width
#define    SRCP_BUFF_IDX_MSK    0x07  // 8byte¿Ãπ«∑Œ.








#ifdef    __SRC_PAT_BUFF__
//==================================================
// Local








#else 
//==================================================
// External






#endif
