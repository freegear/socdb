/****************************************************

   Header of the Calc. source pixel position

   file name : src_pic.h
   created by gtlee
   data : 2006.9.27

   note :
         
   history :

****************************************************/

//==================================================
// global







#ifdef  __SRC_PIC__ //===========================================
// Local

void src_base_pos_blt(int va, int vb, int vc, int vd, 
					  int now_vpos, int hda, int hcb,
					  pos sa, pos sb, pos sc, pos sd,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos);
void calc_base_pos_blt(int va, int vd, int now_vpos,
					   pos sa, pos sd, fpos *sda);
void src_base_pos_rot(int dzp_v, int now_vpos,
					  int sin_fix, int cos_fix,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos );
void calc_src_pos(float *h_ratio, float *v_ratio, 
				  fpos *src_pos);
uint interp_src_pixel(uint src_color[4], fpos *src_pos);
uint interp_color(uint color[4], pos *pos_i);
uint interp_src_pat(uint pat[4], fpos *src_pos);




#else  // __SRC_PIC__ //==========================================
// External

void src_base_pos_blt(int va, int vb, int vc, int vd, 
					  int now_vpos, int hda, int hcb,
					  pos sa, pos sb, pos sc, pos sd,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos);
void calc_base_pos_blt(int va, int vd, int now_vpos,
					   pos sa, pos sd, fpos *sda);
void src_base_pos_rot(int dzp_v, int now_vpos,
					  int sin_fix, int cos_fix,
					  float *h_ratio, float *v_ratio, 
					  fpos *src_pos );
void calc_src_pos(float *h_ratio, float *v_ratio, 
				  fpos *src_pos);
uint interp_src_pixel(uint src_color[4], fpos *src_pos);
uint interp_color(uint color[4], pos *pos_i);
uint interp_src_pat(uint pat[4], fpos *src_pos);


#endif  // __SRC_PIC__ //==========================================
