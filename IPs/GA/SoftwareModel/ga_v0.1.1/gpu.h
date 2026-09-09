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
	int      update; // parameter updated
	pos      st_pos;   // start position
	int      dv;
	int      dh;
	//int      lnum;   // estimation중인 line number
	pos      sp_pos; // stop position. for line pattern.
                     // if no pattern, st_pos == epos
	pos      ed_pos;   // end position
//	int      evorh;  // end horizontal or virtical
} bline_info;


typedef struct circle_str {
	int      en;
	int      update; // parameter updated
	pos      st_pos;
	int      r;        // 반지름.

	int      ccase;    // circle type case
	//int      lnum;     // estimation중인 line number
	pos      ed_pos;     // end position
} cicle_info;

// Line Number
// 0 --> 1 : 0
// 1 --> 2 : 1
// 2 --> 3 : 2
// 3 --> 0 : 3



#ifdef    __GPU__
//-----------------------------------------------------
// local

// define GPU process names
#define    PROC_GET_QUEUE      0
#define    RD_8_CMD            (PROC_GET_QUEUE+1)
#define    WAIT_BUS_8          (RD_8_CMD+1)
#define    RD_REST_CMD         (WAIT_BUS_8+1)
#define    WAIT_BUS_REST       (RD_REST_CMD+1)
#define    GET_CMD_INFO        (WAIT_BUS_REST+1)
#define    GET_LINE_INFO       (GET_CMD_INFO+1)
#define    CHK_IN_BUFF         (GET_LINE_INFO+1)
#define    WAIT_LINE_PARAM     (CHK_IN_BUFF+1)
#define    LINE_EDGE           (WAIT_LINE_PARAM+1)
#define    CHECK_NEXT_LINE     (LINE_EDGE+1)
#define    LINE_PARAM          (CHECK_NEXT_LINE+1)
#define    LINE_ESTIMATE       (LINE_PARAM+1)
#define    CHK_DRAW_AREA       (LINE_ESTIMATE+1)
#define    DRAW_HLINE          (CHK_DRAW_AREA+1)
#define    _DEFAULT_           (DRAW_HLINE+1)



int rd_cmd_fst(void);
void rd_cmd_rest(void);


#else
//-----------------------------------------------------
// external

extern int rd_cmd_fst(void);
extern void rd_cmd_rest(void);


#endif
