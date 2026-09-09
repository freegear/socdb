#ifndef __JPEG_DECODER_H__
#define __JPEG_DECODER_H__

#ifndef __SHMT__
#	define __SHMT__
#endif

#ifndef __SHMT__	// Blocked By GUNDAM
#	pragma once	
#endif

#ifndef __ARMCODE__
#	define __ARMCODE__
#endif


#ifdef __SHMT__

#ifndef  __OUTPUT_RGB__
#  define  __OUTPUT_RGB__
#endif

#ifndef __TEST__
//#  define __TEST__
#endif


	typedef unsigned char BYTE ;
	typedef unsigned int    BOOL ;
	typedef unsigned short  WORD ;
	typedef unsigned long  ULONG;
	typedef unsigned int   UINT;
	
#	ifndef NULL
#		define NULL (0)
#	endif

#	ifndef TRUE
#		define TRUE (1)
#	endif

#	ifndef FALSE
#		define FALSE (0)
#	endif

#	ifndef MAX
#		define MAX(X,Y)  ((X)>(Y)?X:Y)
#	endif

#	ifndef MIN
#		define MIN(X,Y)  ((X)<(Y)?X:Y)
#	endif

void * memset( void * m, int c, int n);
void * memcpy( void * dst0, void * src0, int len0);

#endif


#define STRIDE(width, bit)             ((((width * bit) + 31) & ~31) >> 3)

#define DISPLAY_DIB_BPP            (24)


/////////////////////////////////////////////////////////////////////
// jpeg structure
/////////////////////////////////////////////////////////////////////
typedef struct
{
	BYTE C[3]; 			// Y, Cb, Cr 성분
} SET;

typedef struct
{
	BYTE Q[64]; 		// Qantization Table 값
} DQT;

typedef struct
{
	BOOL Flag; 			// 사용되었는지 여부를 나타내는 플래그
	int Num; 			// 허프만 코드의 수
	WORD HUFFCODE[400]; // 허프만 코드
	BYTE HUFFSIZE[200]; // 허프만 코드의 길이
	BYTE HUFFVAL[200];  // 허프만 코드가 나타내는 값
	WORD MAXCODE[17]; 	// 해당 길이에서 가장 큰 코드
	WORD MINCODE[17]; 	// 해당 길이에서 가장 작은 코드
	int VALPTR[17]; 	// 해당 길이의 코드가 시작되는 인덱스
	int *PT; 			// VALUE로 INDEX를 빠르게 찾기 위한 포인터
} DHT;

typedef struct
{
	WORD Y; 			// 이미지의 높이
	WORD X; 			// 이미지의 넓이
	BYTE Nf; 			// 컴포넌트 수
	BYTE C[3]; 			// 컴포넌트 아이디
	BYTE H[3]; 			// 컴포넌트의 Horizontal Sampling Factor
	BYTE V[3]; 			// 컴포넌트의 Vertical Sampling Factor
	BYTE Tq[3]; 		// 해당 컴포넌트에 사용되는 양자화테이블 번호
} FRAMEHEADER;

typedef struct
{
	BYTE Ns; 			// 컴포넌트 수
	BYTE Cs[3]; 		// 컴포넌트 아이디
	BYTE Td[3]; 		// 컴포넌트의 DC Huffman Table 번호
	BYTE Ta[3]; 		// 컴포넌트의 AC Huffman Table 번호
	BYTE Ss;
	BYTE Se;
	BYTE Ah;
	BYTE Al;
} SCANHEADER;





/////////////////////////////////////////////////////////////////////
// public function
// picture size = only (1024 * 480) : too slow jpeg decoding
/////////////////////////////////////////////////////////////////////

void JpegDecodeInit(void);
void JpegDecode(BYTE * jpeg, BYTE * bmp, int * width, int * height);



/////////////////////////////////////////////////////////////////////
// private function
/////////////////////////////////////////////////////////////////////

void JpegDecodeStart(void);
void JpegDecodeRun(void);

int jpeg_DecodeHeader(void);
void jpeg_Zigzag(void);

int jpeg_DecodeHeadervoid(void);
int jpeg_FindSOI(void);
void jpeg_LoadDQT(BYTE * Qptr);
int jpeg_LoadDHT(BYTE * Hptr);
void jpeg_LoadSOF(BYTE * Fptr);
void jpeg_LoadSOS(BYTE * Sptr);
BYTE jpeg_HuffDecode( int Th );
short jpeg_Extend(WORD V, BYTE T);
void jpeg_DecodeDC( int Th );
void jpeg_DecodeAC(int Th);
void jpeg_DecodeDU( int N );
void jpeg_Zigzagvoid(void);
void jpeg_IDCT(short * block);
void jpeg_InitIDCT(void);
void jpeg_InitCLUT(void);
void jpeg_DecodeMCU(int mx, int my);




#endif //__JPEG_DECODER_H__


