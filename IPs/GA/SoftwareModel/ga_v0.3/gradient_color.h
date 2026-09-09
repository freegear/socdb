/****************************************************

   gradient color interpolation

   file name : gradient_color.h
   created by gtlee
   data : 2006.10.10

   note : 
         
   history :

****************************************************/


//==================================================
// global









#ifdef  __GRADIENT__
//==================================================
// Local

void gradient_base(uint t_color, uint r_color, uint b_color, uint l_color,
				   int *dst_vpos, int now_vpos, int st_hpos, int ed_hpos,
				   float *base_color, float *ratio);

void all_color_interp(uint color_s, uint color_l,
					  int pos_s, int pos_l,
					  int now_pos, float *color);

float  color_interp(float d_ratio,int color_s, int color_l);

void  next_color(float *color, float *ratio);

uint satr_color(float *fcolor);









#else 
//==================================================
// External

extern void gradient_base(uint t_color, uint r_color, uint b_color, uint l_color,
				   int *dst_vpos, int now_vpos, int st_hpos, int ed_hpos,
				   float *base_color, float *ratio);

extern void  next_color(float *color, float *ratio);

extern uint satr_color(float *fcolor);





#endif
