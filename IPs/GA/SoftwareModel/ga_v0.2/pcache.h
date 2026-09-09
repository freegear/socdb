/*************************************************************************

   Header of the Pixel cache

   file name : pcache.h

   created by gtlee

   data : 2006.6.22

   note :

   history :

************************************************************************/



//===========================================================
// Global

#define        PCACHE_SIZE       2048
#define        WAY_NUM           4
#define        LINE_SIZE         32
#define        LINE_NUM          (PCACHE_SIZE/LINE_SIZE)    // 64개
#define        WAY_LINE_NUM      (LINE_SIZE/WAY_NUM)        // 16개

//  ADDRESS : [31:9] --> TAG
//            [ 8:5] --> LINE 결정.


// line 구분 : addr[8:5]
#define        CHK_TAG_SFT       5
#define        CHK_TAG_MSK       0x0F
#define        CHK_TAG_ADR       (CHK_TAG_SFT+4)






#ifdef __PCACHE__
//---------------------------------------------------------
// local define of the pcache

#define        PCACHE_SIZE       2048
#define        WAY_NUM           4
#define        LINE_SIZE         32
#define        LINE_NUM          (PCACHE_SIZE/LINE_SIZE)    // 64개
#define        WAY_LINE_NUM      (LINE_SIZE/WAY_NUM)        // 16개

//  ADDRESS : [31:9] --> TAG
//            [ 8:5] --> LINE 결정.


// line 구분 : addr[8:5]
#define        CHK_TAG_SFT       5
#define        CHK_TAG_MSK       0x0F
#define        CHK_TAG_ADR       (CHK_TAG_SFT+4)


typedef struct str_cache_flag {
	int    emptyb;
	int    update;
	int    kind;
} s_cache_flag;



int rdline(uchar *buffer,uint addr, int kind);
int wrline(uchar *buffer, uint addr, int num);

void init_pcache(void);
void close_pcache(void);
int rd_pcache(uchar *buffer, uint addr, int num, int kind, int nextop);
int wr_pcache(uchar *buffer, uint addr, int num);


#else
//---------------------------------------------------------
// external define 




extern void init_pcache(void);
extern void close_pcache(void);
extern int rd_pcache(uchar *buffer, uint addr, int num, int kind, int nextop);
extern int wr_pcache(uchar *buffer, uint addr, int num);


#endif







