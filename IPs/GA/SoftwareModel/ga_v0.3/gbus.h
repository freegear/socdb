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
	int    posx;  // pixel horizontal position
	int    posy;  // pixel vertical position
	int    pnum;  // pixel number or bytes
//	int    kind;  // target kind. src/dst/pattern...
	uint   addr;  // src address for command structure

	uchar *buffer;

	int    prerd; // next pre-read
	int    endb;  // if 0, operation complete
} typ_mem_cmd;



// memory command
#define    CMD_MEM_RD        0
#define    CMD_MEM_WR        1




#ifdef   __GBUS__
//---------------------------------------------------
// Local

int set_rd_pxl(int kind, int posx, int posy, int pnum, 
				   uchar *buffer, int prerd);
int set_rd_cmd_pal(int kind, uint addr,int off, int num, 
				   uchar *buffer, int prerd);
int set_wr_pxl(int kind, int posx, int posy, 
				   int pnum, uchar *buffer);
int chk_op(int kind);
void mem_op(void);
void mem_rd(int channel);
void mem_wr(int channel);

uint calc_trg_addr(int posx, int posy, int pic_kind);


#else // __GBUS__
//---------------------------------------------------
// External

extern int chk_op(int kind);
extern int set_rd_pxl(int kind, int posx, int posy, int pnum, 
					  uchar *buffer, int prerd);
extern int set_rd_cmd_pal(int kind, uint addr,int off, int num, 
						  uchar *buffer, int prerd);
extern int set_wr_pxl(int kind, int posx, int posy, 
					  int pnum, uchar *buffer);

extern void mem_op(void);

#endif // __GBUS__

