/****************************************************
  
   Header of the destination write buffer

   file name : dst_wr_buff.h
   created by gtlee
   data : 2006.10.24

   note :
         
   history :

****************************************************/



//==================================================
// global



// for destination buffer
#define    WR_BUFF_WLEGTH     8     // word count
#define    WR_BUFF_INDEX      5     // offset address bit width
#define    WR_BUFF_IDX_MSK    0x1F  // 32byte¿Ãπ«∑Œ.



#ifdef    __DST_RD_BUFF__
//==================================================
// Local

// for pixel write to write buffer
#define WR_BUFF_OK         1    // writable
#define WR_BUFF_FULL       0    // stall


#define ST_IDLE       0
#define ST_UD_BUFF    1   // update buffer
#define ST_DM_BUFF    2   // dump now buffer data to memory 








#else 
//==================================================
// External






#endif
