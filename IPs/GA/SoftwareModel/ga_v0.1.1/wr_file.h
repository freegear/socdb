/****************************************************

   header of the writing a picture to a file

   file name : wr_file.h
   created by gtlee
   data : 2006.7.3

   note :
         
   history :

****************************************************/


// global





#ifdef  __WR_FILE__
//-------------------------------------------------
// Internal

int wr_pic_list(char *fname);
uint wr_pic(int pic_num, int align, char *fname);


#else
//-------------------------------------------------
// External


extern int wr_pic_list(char *fname);




#endif
