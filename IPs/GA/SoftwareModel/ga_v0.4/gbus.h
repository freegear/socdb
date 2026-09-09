/*************************************************************************

   Graphic Bus. Read bus and Write Bus.

   file name : gbus.h

   created by gtlee

   data : 2006.6.27

   note :
          
   history :

************************************************************************/


//===========================================
// Global

//---------------------------------------------------------
// memory operation을 수행하는 block과 요청하는 block간의 통신을 위한 구조체.
//    Normal 상태에서는 endb가 0으로 operation complete 상태로 유지.
//    Memory operation이 요청되면, 각 변수가 setting되며, endb가 1로 변경.
//    operation이 완료되면 endb를 0으로 변경.
//    endb의 상태를 monitor하다 endb가 0으로 변경되면 다음 operation수행.
typedef  struct str_mem_cmd {
	int    cmd;   // read/writeb
	uint   addr;  // src address for command structure
	uint   bytes;  // data size

	uchar *buffer;

	int    prerd; // next pre-read
	int    endb;  // if 0, operation complete
} typ_mem_cmd;




// MEM Request channel kind
#define MEM_PCACHE       0
#define MEM_DST_PIC      1
#define MEM_DST_PAT      2
#define MEM_CMD_STR      3

#define MEM_WRITE        4    // write buffer for destination picture

#define MEM_RD_KIND      4    // read channel의 개수.
#define MEM_KIND         5    // total channel



// memory command
#define    MEM_RD_OP     0
#define    MEM_WR_OP     1






#ifdef   __GBUS__  //=========================================
// Local

int chk_op(int kind);
int set_rd_mem(int kind, uint addr, int bytes, 
			   uchar *buffer, int prerd);
int set_wr_mem(int kind, uint addr, int bytes, uchar *buffer);
void mem_op(void);
void mem_rd(int channel);
void mem_wr(int channel);


#else // __GBUS__  //=========================================
// External

extern int chk_op(int kind);
extern int set_rd_mem(int kind, uint addr, int bytes, 
					  uchar *buffer, int prerd);
extern int set_wr_mem(int kind, uint addr, int bytes, uchar *buffer);
extern void mem_op(void);
extern void mem_rd(int channel);
extern void mem_wr(int channel);


#endif // __GBUS__  //=========================================

