/*************************************************************************
   Header of color type conversion from/to 32bpp

   file name : fromto32bpp.h

   created by gtlee

   data : 2006.6.26

   note :
          
   history :

************************************************************************/

#ifdef   __FROMTO32BPP__


void to32bpp(uchar *pbuffer, uint addr, int pnum, int type, 
			 int kind, int prerd);

void from32bpp(uchar *pbuffer, uint addr, int pnum, int type, int kind);



#else



extern void to32bpp(uchar *pbuffer, uint addr, int pnum, int type, 
			 int kind, int prerd);

extern void from32bpp(uchar *pbuffer, uint addr, int pnum, int type, int kind);




#endif



//=======================================================
// Global 
