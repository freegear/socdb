/****************************************************

   header of calc. destination picture

   file name : dst_pic.h
   created by gtlee
   data : 2006.9.29

   note :
         
   history :

****************************************************/


//==================================================
// global







#ifdef  __DST_PIC__ //===============================
// Local


void next_hpos(int *hpos_s1, int *hpos_s2);
uint hbits_size(int pixel_type, int maxh);
uint calc_addr(uint baddr, int ctype, int maxh, int maxv, 
			   int now_vpos, int now_hpos, uint hbits);



#else // __DST_PIC__ //===============================
// External


extern void next_hpos(int *hpos_s1, int *hpos_s2);
extern uint hbits_size(int pixel_type, int maxh);
extern uint calc_addr(uint baddr, int ctype, int maxh, int maxv, 
			   int now_vpos, int now_hpos, uint hbits);


#endif // __DST_PIC__ //===============================
