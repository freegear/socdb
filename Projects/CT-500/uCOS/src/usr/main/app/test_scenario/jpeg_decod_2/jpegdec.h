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


typedef unsigned char   JPEGBYTE ;
typedef unsigned int    JPEGBOOL ;
typedef unsigned short  JPEGWORD ;
typedef unsigned long   JPEGULONG;
typedef unsigned int    JPEGUINT;

typedef struct 
{
  JPEGUINT buf;
  JPEGUINT cnt;
} BIT_STREAM;


	
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

void * memset_jy( void * m, int c, int n);
void * memcpy_jy( void * dst0, void * src0, int len0);

#endif


#define STRIDE(width, bit)             ((((width * bit) + 31) & ~31) >> 3)

#define DISPLAY_DIB_BPP            (24)


/////////////////////////////////////////////////////////////////////
// jpeg structure
/////////////////////////////////////////////////////////////////////
typedef struct
{
	JPEGBYTE C[3]; 			// Y, Cb, Cr 성분
} SET;

typedef struct
{
	JPEGBYTE Q[64]; 		// Qantization Table 값
} DQT;

typedef struct
{
	JPEGBOOL Flag; 			// 사용되었는지 여부를 나타내는 플래그
	int Num; 			// 허프만 코드의 수
	JPEGWORD HUFFCODE[400]; // 허프만 코드
	JPEGBYTE HUFFSIZE[200]; // 허프만 코드의 길이
	JPEGBYTE HUFFVAL[200];  // 허프만 코드가 나타내는 값
	JPEGWORD MAXCODE[17]; 	// 해당 길이에서 가장 큰 코드
	JPEGWORD MINCODE[17]; 	// 해당 길이에서 가장 작은 코드
	int VALPTR[17]; 	// 해당 길이의 코드가 시작되는 인덱스
	int *PT; 			// VALUE로 INDEX를 빠르게 찾기 위한 포인터
} DHT;

typedef struct
{
	JPEGWORD Y; 			// 이미지의 높이
	JPEGWORD X; 			// 이미지의 넓이
	JPEGBYTE Nf; 			// 컴포넌트 수
	JPEGBYTE C[3]; 			// 컴포넌트 아이디
	JPEGBYTE H[3]; 			// 컴포넌트의 Horizontal Sampling Factor
	JPEGBYTE V[3]; 			// 컴포넌트의 Vertical Sampling Factor
	JPEGBYTE Tq[3]; 		// 해당 컴포넌트에 사용되는 양자화테이블 번호
} FRAMEHEADER;

typedef struct
{
	JPEGBYTE Ns; 			// 컴포넌트 수
	JPEGBYTE Cs[3]; 		// 컴포넌트 아이디
	JPEGBYTE Td[3]; 		// 컴포넌트의 DC Huffman Table 번호
	JPEGBYTE Ta[3]; 		// 컴포넌트의 AC Huffman Table 번호
	JPEGBYTE Ss;
	JPEGBYTE Se;
	JPEGBYTE Ah;
	JPEGBYTE Al;
} SCANHEADER;





/////////////////////////////////////////////////////////////////////
// public function
// picture size = only (1024 * 480) : too slow jpeg decoding
/////////////////////////////////////////////////////////////////////

void JpegDecodeInit(void);
void JpegDecode(JPEGBYTE * jpeg, JPEGBYTE * bmp, int * width, int * height);



/////////////////////////////////////////////////////////////////////
// private function
/////////////////////////////////////////////////////////////////////

void JpegDecodeStart(BIT_STREAM * pBS);
void JpegDecodeRun(BIT_STREAM * pBS);
void JpegDecodeRun0(BIT_STREAM * pBS);

int jpeg_DecodeHeader(void);

int jpeg_DecodeHeadervoid(void);
int jpeg_FindSOI(void);
void jpeg_LoadDQT(JPEGBYTE * Qptr);
int jpeg_LoadDHT(JPEGBYTE * Hptr);
void jpeg_LoadSOF(JPEGBYTE * Fptr);
void jpeg_LoadSOS(JPEGBYTE * Sptr);
//inline short jpeg_Extend(JPEGWORD V, JPEGBYTE T);
__inline short jpeg_Extend(JPEGWORD V, JPEGBYTE T);

void jpeg_DecodeDU( int N , BIT_STREAM * pBS,short * ZZ_OUT);
void jpeg_DecodeAC(int Th , BIT_STREAM * pBS);
JPEGBYTE jpeg_HuffDecode( int Th , BIT_STREAM * pBS);
void jpeg_DecodeDC( int Th ,  BIT_STREAM * pBS);


void jpeg_Zigzag(short * ZZ_OUT);
void jpeg_IDCT(short * block);
void jpeg_InitIDCT(void);
void jpeg_InitCLUT(void);


void jpeg_DecodeMCU(int mx, int my, BIT_STREAM * pBS);
void jpeg_DecodeMCU0(int mx, int my, BIT_STREAM * pBS);




#endif //__JPEG_DECODER_H__


