/*************************************************************************

   Header for the Graphic sub-processor

   file name : gpu.h
   created by gtlee
   data : 2006.7.4

   note :
          
   history :

************************************************************************/
//-----------------------------------------------------
// Global



typedef struct bline_str {
	int      en;     // enable/disable
	pos      spos;   // start position
	int      dv;
	int      dh;
	int      lnum;   // estimation중인 line number
	pos      epos;   // end position
	int      evorh;  // end horizontal or virtical
} bline_info;


typedef struct circle_str {
	int      en;
	pos      spos;
	int      r;        // 반지름.
	int      ccase;    // circle type case
	int      lnum;     // estimation중인 line number
} cicle_info;

// Line Number
// 0 --> 1 : 0
// 1 --> 2 : 1
// 2 --> 3 : 2
// 3 --> 0 : 3



#ifdef    __GPU__
//-----------------------------------------------------
// local

int rd_cmd_fst(void);
void rd_cmd_rest(void);


#else
//-----------------------------------------------------
// external

extern int rd_cmd_fst(void);
extern void rd_cmd_rest(void);


#endif
