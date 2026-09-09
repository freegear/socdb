/****************************************************

   header of a overlay pixels

   file name : overlay.h
   created by gtlee
   data : 2006.10.20

   note : 
         
   history :

****************************************************/

//==================================================
// global










#ifdef    __OVERLAY__
//==================================================
// Local

uint rast_op(uint r_code, uint dst_color, uint dst_pat,
			 uint src_color, uint src_pat, 
			 uint brush_color);
uint alpha_blend(int const_alpha, int choose, uint dst_color,
				 uint src_color);
int pre_alpha(int color, int alpha);
int single_alpha(int src_color, int src_alpha, int dst_color);



#else // not __OVERLAY__ //===============================
// External


extern uint rast_op(uint r_code, uint dst_color, uint dst_pat,
			 uint src_color, uint src_pat, 
			 uint brush_color);
extern uint alpha_blend(int const_alpha, int choose, uint dst_color,
				 uint src_color);
extern int pre_alpha(int color, int alpha);
extern int single_alpha(int src_color, int src_alpha, int dst_color);



#endif  // not __OVERLAY__ //===============================

