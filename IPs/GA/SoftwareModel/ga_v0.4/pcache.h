/*************************************************************************

   Header of the Pixel cache

   file name : pcache.h

   created by gtlee

   data : 2006.6.22

   note :

   history :

*****************************************************************/



//===========================================================
// Global



// Request channel kind
#define  PCC_SRC_PIC    0   // source picture
#define  PCC_SRC_PAT    1   // source masking pattern
#define  PCC_DRW_PAT    2   // draw pattern. brush
#define  PCC_PALLETE    3   // source picture palette

#define  PCC_KIND       4


// operation define
#define  PCC_RD         0
#define  PCC_WR         1



#define  PCC_HIT        1
#define  PCC_MISS       0





#ifdef __PCACHE__ //======================================
// local define of the pcache

#define        PCACHE_SIZE       2048
#define        WAY_NUM           2
#define        LINE_SIZE         32
#define        LINE_NUM          (PCACHE_SIZE/LINE_SIZE)    // 64개
#define        WAY_LINE_NUM      (LINE_NUM/WAY_NUM)         // 32개

//  ADDRESS : [31:9] --> TAG
//            [ 8:5] --> LINE 결정.


// line 구분 : addr[8:5]
#define        CHK_TAG_SFT       5
#define        CHK_TAG_MSK       0x0F
#define        CHK_TAG_ADR       (CHK_TAG_SFT+4)


typedef struct str_cache_flag {
	int    emptyb;
} s_cache_flag;




void init_pcache(void);
void close_pcache(void);
int chk_cache_op(int kind);
int set_rd_cache(int kind, uint addr, int bytes, 
				 uchar *buffer, int prerd);
void cache_op(void);
int rd_pcache(uchar *buffer, uint *addr, int *num, int kind, int prerd);
int rdline(uchar *buffer,uint addr);





#else // __PCACHE__ //======================================
// external define 


extern void init_pcache(void);
extern void close_pcache(void);
extern int chk_cache_op(int kind);
extern int set_rd_cache(int kind, uint addr, int bytes, 
						uchar *buffer, int prerd);
extern void cache_op(void);
extern int rd_pcache(uchar *buffer, uint *addr, int *num, 
					 int kind, int prerd);
extern int rdline(uchar *buffer,uint addr);


#endif // __PCACHE__ //======================================







