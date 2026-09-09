//#include "stdafx.h"
#include "jpegdec.h"

#ifndef __ARM_TEST__
#   include "stdio.h"
#endif

#ifndef __SHMT__
#	pragma warning(disable: 4244)
#endif




/////////////////////////////////////////////////////////////////////
// jpeg variable
/////////////////////////////////////////////////////////////////////

JPEGWORD RInterval; 		// Restart Interval

JPEGBYTE Hmax; 			// Maximum Horizontal Sampling Factor for all component
JPEGBYTE Vmax; 			// Maximum Vertical Sampling Factor for all component
DQT TbQ[20]; 			// Quantization Table
DHT TbH[20]; 			// Huffman Table
short ZZ[64]; 			// 8x8 Block 정보를 담는 배열

FRAMEHEADER FrameHeader;// FrameHeader 구조채
SCANHEADER ScanHeader; 	// ScanHeader 구조체
short PrevDC[3]; 		// DC 성분의 Predictor



JPEGBYTE * Jptr, * Bptr; // JPEG, BMP pointer
int RstCount; // 디코딩 중일때 Restart Interval 카운터
JPEGULONG XMBlockNum, YMBlockNum; // X, Y 블럭 갯수
JPEGULONG CurXMBlock, CurYMBlock; // 디코딩 중인 X, Y 블럭


JPEGBOOL JpegDecodeFlag;


 
/////////////////////////////////////////////////////////////////////
// jpeg macro (bit stream handler & color lookup table)
/////////////////////////////////////////////////////////////////////
#define GET_MARKER()		((JPEGULONG)((*Jptr << 8) | *(Jptr+1)))
#define GET_JLENGTH(ptr)	((JPEGULONG)((*(ptr) << 8) | *((ptr)+1)))





#  define RESET_PBS() { pBS->buf=0; pBS->cnt=0; }
#  define CHECK_PBS(n) { \
	while((n) > pBS->cnt) { \
	pBS->buf = (pBS->buf << 8) | *Jptr++; \
	pBS->cnt += 8; \
	if((pBS->buf & 0xff) == 0xff) Jptr++; } }
#  define GET_PBIT(n) (((int) (pBS->buf >> (pBS->cnt -= (n)))) & ((1<<(n))-1))


#if 0
#  define RESET_PBS() { \
                 pBS->buf = 0;\
                 pBS->buf = *Jptr++; \
                 pBS->buf = (pBS->buf<<8)|*Jptr++; \
                 pBS->buf = (pBS->buf<<8)|*Jptr++; \
                 pBS->buf = (pBS->buf<<8)|*Jptr++; \
          }

#  define SHOW_BIT(n)
                 ((int)(pBS->buf & (0xffffffff << (32-n))))

#  define GET_BIT(n)
		 (Get n Bits)
		 (Decrease n Bit)
		 (while ( buf -> cnt < 24 )
		   pBS->buf = (pBS->buf<<8)|*Jptr++ ; pBS->cnt+=8;
#endif

/////////////////////////////////////////////////////////////////////
// jpeg function
/////////////////////////////////////////////////////////////////////

void JpegDecodeInit(void)
{
	jpeg_InitIDCT();
}

// jpeg -> RGB24 bitmap
void JpegDecode(JPEGBYTE * jpeg, JPEGBYTE * bmp, int * width, int * height)
{

	BIT_STREAM BS;

#ifndef __SHMT__
	if(jpeg == NULL || bmp == NULL) return;
#else
	if(jpeg == (JPEGBYTE *)NULL || bmp == (JPEGBYTE *)NULL) return;
#endif

	// pointer set
	Jptr = jpeg;
	Bptr = bmp;

	JpegDecodeStart(&BS);

	while(TRUE)
	{
		JpegDecodeRun(&BS);
		if(JpegDecodeFlag) break;
	}

	if(width) *width = FrameHeader.X;
	if(height) *height = FrameHeader.Y;
}
// jpeg -> RGB24 bitmap
void JpegDecode0(JPEGBYTE * jpeg, JPEGBYTE * bmp, int * width, int * height)
{

	BIT_STREAM BS;

#ifndef __SHMT__
	if(jpeg == NULL || bmp == NULL) return;
#else
	if(jpeg == (JPEGBYTE *)NULL || bmp == (JPEGBYTE *)NULL) return;
#endif

	// pointer set
	Jptr = jpeg;
	Bptr = bmp;

	JpegDecodeStart(&BS);

	while(TRUE)
	{
		JpegDecodeRun0(&BS);
		if(JpegDecodeFlag) break;
	}

	if(width) *width = FrameHeader.X;
	if(height) *height = FrameHeader.Y;
}

void JpegDecodeStart(BIT_STREAM * pBS)
{
	int i;

	if(Jptr[6] != 'J' && Jptr[7] != 'F') return;

	jpeg_DecodeHeader();

	// init
	RESET_PBS();

	for(i=0 ; i<ScanHeader.Ns ; i++) PrevDC[i] = 0;

	RstCount = 0;
	XMBlockNum = FrameHeader.X / 8 / Hmax;
	YMBlockNum = FrameHeader.Y / 8 / Vmax;
	CurXMBlock = 0;
	CurYMBlock = 0;

	JpegDecodeFlag = FALSE;
}


   void JpegDecodeRun(BIT_STREAM * pBS)
{
	int mk;

	if(CurYMBlock >= YMBlockNum)
	{
		CurXMBlock = 0;
		CurYMBlock = 0;

		JpegDecodeFlag = TRUE;
		return;
	}

	if(JpegDecodeFlag) return;

	jpeg_DecodeMCU(CurXMBlock, CurYMBlock , pBS);

	RstCount++;

	if(RstCount == RInterval)// Restart Marker Decode
	{
		RstCount = 0;
		mk = GET_MARKER();
		if((mk & 0xFFF0) == 0xFFD0)
		{
			RESET_PBS();
			Jptr += 2;

			PrevDC[0] = 0;
			PrevDC[1] = 0;
			PrevDC[2] = 0;
		}
	}

	CurXMBlock++;

	if(CurXMBlock >= XMBlockNum)
	{
		CurXMBlock = 0;
		CurYMBlock++;
	}
}
   void JpegDecodeRun0(BIT_STREAM * pBS)
{
	int mk;

	if(CurYMBlock >= YMBlockNum)
	{
		CurXMBlock = 0;
		CurYMBlock = 0;

		JpegDecodeFlag = TRUE;
		return;
	}

	if(JpegDecodeFlag) return;

	jpeg_DecodeMCU0(CurXMBlock, CurYMBlock , pBS);

	RstCount++;

	if(RstCount == RInterval)// Restart Marker Decode
	{
		RstCount = 0;
		mk = GET_MARKER();
		if((mk & 0xFFF0) == 0xFFD0)
		{
			RESET_PBS();
			Jptr += 2;

			PrevDC[0] = 0;
			PrevDC[1] = 0;
			PrevDC[2] = 0;
		}
	}

	CurXMBlock++;

	if(CurXMBlock >= XMBlockNum)
	{
		CurXMBlock = 0;
		CurYMBlock++;
	}
}

int jpeg_DecodeHeader()
{
	JPEGULONG i, k;
	int limit = 0;
	JPEGBOOL Exit_Flag = FALSE;

	RInterval = 0;

	jpeg_FindSOI();

	while(!Exit_Flag)
	{
		if(limit++ > 100000) return 0;

		i = GET_MARKER();
		switch(i)
		{
		case 0xFFC0 :            // Baseline DCT 프레임.
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			jpeg_LoadSOF(Jptr+2);
			Jptr += i;
			break;

		case 0xFFC4 :            // 허프만 테이블.
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			k = jpeg_LoadDHT(Jptr+2);
			Jptr += i;
			if(k >= 200) Exit_Flag = TRUE;
			break;

		case 0xFFD0 :            // DRI로 지정되는 간격마다 삽입되는 마커 MCU재시작
		case 0xFFD1 :
		case 0xFFD2 :
		case 0xFFD3 :
		case 0xFFD4 :
		case 0xFFD5 :
		case 0xFFD6 :
		case 0xFFD7 :
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			Jptr += i;
			break;

		case 0xFFD8 :            // Jpeg화일 시작(혹시 몰라서).
		case 0xFFD9 :            // Jpeg화일 끝.
			Jptr += 2;
			Exit_Flag = TRUE;
			break;

		case 0xFFDA :            // 스캔 데이터 시작.
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			jpeg_LoadSOS(Jptr+2);
			Jptr += i;
			/* jpeg block decoding 시작할때 빠짐 */
			Exit_Flag = TRUE;
			break;

		case 0xFFDB :            // 양자화 테이블.
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			jpeg_LoadDQT(Jptr+2);
			Jptr += i;
			break;

		case 0xFFDD:            // RST (재시작 간격)
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			RInterval = GET_JLENGTH(Jptr+2);
			Jptr += i;
			break;

		case 0xFFC1 :            // 확장방식 시퀸셜 DCT 프레임.
		case 0xFFC2 :            // 점층적 전송 방식 프레임.
		case 0xFFC3 :            // 공간적 예측 무손실 프레임.
		case 0xFFC5 :            // 차분 영상 DCT 부호화 프레임.
		case 0xFFC6 :            // 차분 영상 점층적 전송 방식 프레임.
		case 0xFFC7 :            // 차분 영상 공간적 예측 프레임.
		case 0xFFC8 :
		case 0xFFC9 :
		case 0xFFCA :
		case 0xFFCB :
		case 0xFFCC :            // 산술 부호화 테이블
		case 0xFFCD :
		case 0xFFCE :
		case 0xFFCF :
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			Jptr += i;
			Exit_Flag = TRUE;
			break;

		case 0xFFDC :            // 영상의 라인수
		case 0xFFDE :            // 계층적 부호화 표시
		case 0xFFDF :            // 화소수를 가로, 세로 두배 확대

		case 0xFFE0 :            // 응용프로그램에서 자유롭게 사용 (E0-EF)
		case 0xFFE1 :
		case 0xFFE2 :
		case 0xFFE3 :
		case 0xFFE4 :
		case 0xFFE5 :
		case 0xFFE6 :
		case 0xFFE7 :
		case 0xFFE8 :
		case 0xFFE9 :
		case 0xFFEA :
		case 0xFFEB :
		case 0xFFEC :
		case 0xFFED :
		case 0xFFEE :
		case 0xFFEF :
		case 0xFFF0 :            // 미래의 JPEG규약으로 사용하기 위해 예약된 코드(F0-FD)
		case 0xFFF1 :
		case 0xFFF2 :
		case 0xFFF3 :
		case 0xFFF4 :
		case 0xFFF5 :
		case 0xFFF6 :
		case 0xFFF7 :
		case 0xFFF8 :
		case 0xFFF9 :
		case 0xFFFA :
		case 0xFFFB :
		case 0xFFFC :
		case 0xFFFD :
		case 0xFFFE :
		case 0xFFFF :
			Jptr += 2;
			i = GET_JLENGTH(Jptr);
			Jptr += i;
			break;

		default :
			Jptr++;
			break;

		}// end of switch
	}// end of while

	return 1;
}

int jpeg_FindSOI()
{
	JPEGULONG i;
	int limit = 0;

	while(1)
	{
		if(limit++ > 100000) return 0;
		i = GET_MARKER();
		if (i == 0xFFD8) break;
		Jptr++;
	}
	Jptr += 2;

	return 1;
}

void jpeg_LoadDQT(JPEGBYTE * Qptr)
{
	JPEGBYTE i;
	int limit = 0;

	while(1)
	{
		if(limit++ > 100000) break;
		i = *Qptr;						// 첫바이트가 테이블(20개)번호
		if(i == 0xFF) break;
		Qptr++;
		i &= 0xF;
		memcpy_jy(TbQ[i].Q, Qptr, 64) ;	// 해당 테이블에 64개의 양자화 테이블 복사
		Qptr += 64;
	}
}

int jpeg_LoadDHT(JPEGBYTE * Hptr)
{ 
	// 허프만코드의 값을 읽고 DHT TbH[20] 구조체에 값을 저장(테이블)
	JPEGBYTE BITS[17], Th;
	int i, j, k, LASTK ;
	int Num = 0, maxnum  = 0;
	JPEGWORD CODE;
	JPEGBYTE SI;
	int limit = 0;

	while(1) {
		if(limit++>100000) break;

		Th = *Hptr;
		if (Th == 0xFF) break;

		Num  = 0;
		memcpy_jy(BITS, Hptr, 17) ;

		Hptr += 17 ;
		for( i=1 ; i<17 ; i++ ) Num += BITS[i] ;     //16개의 값을 모두 더해서 Num에 저장
		if (Num > maxnum) maxnum = Num;

		if (maxnum >= 200) break;

		memcpy_jy( TbH[ Th ].HUFFVAL, Hptr, Num ) ;     //Huffman Value 값을 Num크기만큼 Hptr에서 읽는다.
		Hptr += Num ;                                // Hptp가 증가

		// Generation of table of Huffman code sizes //
		i=1 ;    j=1 ;    k=0 ;
		while( i <= 16 ) {
			while( j <= BITS[ i ] )    {
				TbH[ Th ].HUFFSIZE[ k ] = ( JPEGBYTE )i ;
				k++ ;
				j++ ;
			}
			i++ ;
			j=1 ;
		}
		TbH[ Th ].HUFFSIZE[ k ] = 0 ;
		LASTK = k ;

		// Generation of table of Huffman codes
		k=0 ;
		CODE = 0 ;
		SI = TbH[ Th ].HUFFSIZE[ 0 ] ;

		while(1) {
			do {
				TbH[ Th ].HUFFCODE[ k ] = CODE ;
				CODE++ ;
				k++ ;
			} while( TbH[ Th ].HUFFSIZE[ k ] == SI );
			if( TbH[ Th ].HUFFSIZE[ k ] == 0 ) break ;

			do {
				CODE = CODE << 1 ;
				SI++ ;
			}while( TbH[ Th ].HUFFSIZE[ k ] != SI ) ;
		}

		// Decoder table generation //
		i=0 ; j=0 ;
		while(1) {
			do {
				i++ ;
				if( i > 16 ) break ;
				if( BITS[ i ] == 0 ) TbH[ Th ].MAXCODE[ i ] = -1 ;
			}while( BITS[ i ] == 0 ) ;
			if( i > 16 ) break ;

			TbH[ Th ].VALPTR[ i ] = j ;
			TbH[ Th ].MINCODE[ i ] = TbH[ Th ].HUFFCODE[ j ] ;
			j = j + BITS[ i ] - 1 ;
			TbH[ Th ].MAXCODE[ i ] = TbH[ Th ].HUFFCODE[ j ] ;
			j++ ;
		}
		TbH[ Th ].Num = Num ;

	}while(*Hptr != 0xFF) ;

	return maxnum;
}

void jpeg_LoadSOF(JPEGBYTE * Fptr)
{
	int i;
	JPEGBYTE * p;

	Fptr++;	// 양자화 비트수 스킵 (이프로그램에서는 안쓰나 보다.)
	FrameHeader.Y = GET_JLENGTH(Fptr);
	Fptr += 2;
	FrameHeader.X = GET_JLENGTH(Fptr);
	Fptr += 2;
	FrameHeader.Nf = *Fptr++;
	for(i=0 ; i<FrameHeader.Nf ; i++)
	{
		p = Fptr + (3*i);
		FrameHeader.C[i]  = *(p) ;  // Component identifier
		FrameHeader.H[i]  = *(p + 1) >> 4 ;  // Horizontal Sampling Factor
		FrameHeader.V[i]  = *(p + 1) & 0x0F; // Vertical Sampling Factor
		FrameHeader.Tq[i] = *(p + 2); // Quantizer Table destination selector

	}
}

void jpeg_LoadSOS(JPEGBYTE * Sptr)
{
	int i;
	JPEGBYTE * p;

	ScanHeader.Ns = *Sptr++;            // 스캔 컨퍼넌트 수
	for( i=0 ; i < ScanHeader.Ns ; i++ ) 
	{
		p = Sptr + (i*2);
		ScanHeader.Cs[ i ] = *(p);
		ScanHeader.Td[ i ] = *(p + 1) >> 4;
		ScanHeader.Ta[ i ] = *(p + 1) & 0x0F;
	}

	p = Sptr + (2 * ScanHeader.Ns);
	ScanHeader.Ss = *(p);
	ScanHeader.Se = *(p + 1);
	ScanHeader.Ah = *(p + 2) >> 4;
	ScanHeader.Al = *(p + 2) & 0x0F;

	// 최대 Sampling Factor 구함
	Hmax = Vmax = 0 ;
	for( i=0 ; i < FrameHeader.Nf ; i++ ) {
		if( FrameHeader.H[ i ] > Hmax )    Hmax = FrameHeader.H[ i ] ;
		if( FrameHeader.V[ i ] > Vmax )    Vmax = FrameHeader.V[ i ] ;
	}



	// 이미지 사이즈를 MCU 크기에 맞아 떨어지도록 다시 계산 //
	if( FrameHeader.X % ( 8 * Hmax ) != 0 )
		FrameHeader.X = ( FrameHeader.X / ( 8 * Hmax ) + 1 ) * ( 8 * Hmax ) ;
	if( FrameHeader.Y % ( 8 * Vmax ) != 0 )
		FrameHeader.Y = ( FrameHeader.Y / ( 8 * Vmax ) + 1 ) * ( 8 * Vmax ) ;
}


/////////////////////////////////////////////////////////////////////


    JPEGBYTE jpeg_HuffDecode( int Th , BIT_STREAM * pBS)
{
	int i = 1, j, limit = 0;
	JPEGWORD CODE;
	JPEGBYTE Value;


	CHECK_PBS(1);
	CODE = GET_PBIT(1);


	while( ( CODE > TbH[ Th ].MAXCODE[ i ] ) || ( TbH[ Th ].MAXCODE[ i ] == 65535 ) )
	{
		i++;

		CHECK_PBS(1);
		CODE = (CODE << 1) + GET_PBIT(1);
		
		//if(limit++>100000) break;
	}

	j = TbH[Th].VALPTR[i];
	j = j + CODE - TbH[Th].MINCODE[i];
	Value = TbH[Th].HUFFVAL[j];
	return Value;
}

// change inline funct
//inline short jpeg_Extend(JPEGWORD V, JPEGBYTE T)
__inline short jpeg_Extend(JPEGWORD V, JPEGBYTE T)
{
	JPEGWORD Vt = 1 << (T-1) ;

	if( V < Vt ) {
		Vt = (-1 << T) + 1 ;
		V += Vt ;
	}
	return ( short )V ;
}

void jpeg_DecodeDC( int Th , BIT_STREAM * pBS)
{
        JPEGBYTE T = jpeg_HuffDecode( Th , pBS) ;
	JPEGWORD V;

	CHECK_PBS(T);
	V = GET_PBIT(T);

	ZZ[0] = jpeg_Extend(V,T);
}

    void jpeg_DecodeAC(int Th,BIT_STREAM * pBS)
{
	int k = 1,i;
	JPEGBYTE RS, SS, RR, R;
	JPEGWORD V;

	memset_jy(&ZZ[1], 0, 63 * sizeof(short));

	// RR : ZZ에서 0 이 아닌 전 값으로부터의 상대적인 위치
	// SS : 0이 아닌 값의 범위(category)

	for(i=0; i<100000; i++) {

  	        RS = jpeg_HuffDecode( Th , pBS ) ;

		SS = RS & 0xf;
		RR = RS >> 4 ;
		R = RR ;
		if( SS == 0 ) {
			if(R == 15)    k += 16 ;
			else 
			  {
			    //if( k <= 63 )
			    //  {
			    //memset_jy(&ZZ[k], 0, (64-k) * sizeof(short));
			    //}

			    break ;
			  }
		} else {
			k += R ;
			CHECK_PBS(SS);
			V = GET_PBIT(SS);
			ZZ[ k ] = jpeg_Extend(V,SS);
			if( k == 63 ) break ;
			else k++ ;
		}
	}
}

void jpeg_DecodeDU( int N , BIT_STREAM * pBS, short * ZZ_OUT)
{ // N = Component ID 0/1/2
	int i ;
	short *pos;
	


	jpeg_DecodeDC(ScanHeader.Td[N],pBS);   
	jpeg_DecodeAC(ScanHeader.Ta[N] + 16,pBS);

	// Differential DC Restoration//
	ZZ[0] = ZZ[0] + PrevDC[N];
	PrevDC[N] = ZZ[0];

	// Dequantization //
	pos = ZZ;
	for(i=0; i<64; i++) *pos++ *= TbQ[FrameHeader.Tq[N]].Q[i];

	// Undo Zigzag Order //
	jpeg_Zigzag(ZZ_OUT);

	// Inverce Discrete Cosine Transform //
	jpeg_IDCT(ZZ_OUT);

	// Level Shifting  & Correct Error //	
	//pos = ZZ;
	

	for(i=0; i<64; i++)
	{
	  ZZ_OUT[i] = ZZ_OUT[i] + 128;
	  if(ZZ_OUT[i] < 0) ZZ_OUT[i] = 0;
	  else if(ZZ_OUT[i] > 255) ZZ_OUT[i] = 255;
	}	

}

short const ZIGZAG_TABLE[64] = 
{
	0,  1,  5,  6,  14, 15, 27, 28,
		2,  4,  7,  13, 16, 26, 29, 42,
		3,  8,  12, 17, 25, 30, 41, 43,
		9,  11, 18, 24, 31, 40, 44, 53,
		10, 19, 23, 32, 39, 45, 52, 54,
		20, 22, 33, 38, 46, 51, 55, 60,
		21, 34, 37, 47, 50, 56, 59, 61,
		35, 36, 48, 49, 57, 58, 62, 63
};

void jpeg_Zigzag(short * ZZ_OUT)
{
	int i;


	for(i=0 ; i<64 ; i+=4)
	  {
		ZZ_OUT[i  ] = ZZ[ZIGZAG_TABLE[i  ]];
		ZZ_OUT[i+1] = ZZ[ZIGZAG_TABLE[i+1]];
		ZZ_OUT[i+2] = ZZ[ZIGZAG_TABLE[i+2]];
		ZZ_OUT[i+3] = ZZ[ZIGZAG_TABLE[i+3]];
	  }
}


//////////////////////////////////
// 2-D IDCT, Chen-Wang algorithm
// from XviD
//////////////////////////////////

#define W1   (2841) // 2048*sqrt(2)*cos(1*pi/16)
#define W2   (2676) // 2048*sqrt(2)*cos(2*pi/16)
#define W3   (2408) // 2048*sqrt(2)*cos(3*pi/16)
#define W5   (1609) // 2048*sqrt(2)*cos(5*pi/16)
#define W6   (1108) // 2048*sqrt(2)*cos(6*pi/16)
#define W7   (565)  // 2048*sqrt(2)*cos(7*pi/16)
#define WP17 (3406) // W1 + W7
#define WM17 (2276) // W1 - W7
#define WP35 (4017) // W3 + W5
#define WM35 (799)  // W3 - W5
#define WP26 (3784) // W2 + W6
#define WM26 (1568) // W2 - W6

// clipping table
short iclip[1024];
short *iclp;

// two dimensional inverse discrete cosine transform
void jpeg_IDCT(short * block)
{
	short * blk;
	int i;
	register long X0, X1, X2, X3, X4, X5, X6, X7, X8;

	for(i=0 ; i<8; i++) /* idct rows */
	{
		blk = block + (i << 3);
		if(!((X1 = blk[4] << 11) | (X2 = blk[6]) | (X3 = blk[2]) | (X4 = blk[1]) | (X5 = blk[7]) | (X6 = blk[5]) | (X7 = blk[3])))
		{
			blk[0] = blk[1] = blk[2] = blk[3] = blk[4] = blk[5] = blk[6] = blk[7] = blk[0] << 3;
			continue;
		}

		X0 = (blk[0] << 11) + 128;	/* for proper rounding in the fourth stage  */

		/* first stage  */
		X8 = W7 * (X4 + X5);
		X4 = X8 + WM17 * X4;
		X5 = X8 - WP17 * X5;
		X8 = W3 * (X6 + X7);
		X6 = X8 - WM35 * X6;
		X7 = X8 - WP35 * X7;

		/* second stage  */
		X8 = X0 + X1;
		X0 -= X1;
		X1 = W6 * (X3 + X2);
		X2 = X1 - WP26 * X2;
		X3 = X1 + WM26 * X3;
		X1 = X4 + X6;
		X4 -= X6;
		X6 = X5 + X7;
		X5 -= X7;

		/* third stage  */
		X7 = X8 + X3;
		X8 -= X3;
		X3 = X0 + X2;
		X0 -= X2;
		X2 = (181 * (X4 + X5) + 128) >> 8;
		X4 = (181 * (X4 - X5) + 128) >> 8;

		/* fourth stage  */
		blk[0] = (X7 + X1) >> 8;
		blk[1] = (X3 + X2) >> 8;
		blk[2] = (X0 + X4) >> 8;
		blk[3] = (X8 + X6) >> 8;
		blk[4] = (X8 - X6) >> 8;
		blk[5] = (X0 - X4) >> 8;
		blk[6] = (X3 - X2) >> 8;
		blk[7] = (X7 - X1) >> 8;
	} /* end for idct_rows */


	for(i=0 ; i<8 ; i++) /* idct columns */
	{
		blk = block + i;
		if(!((X1 = (blk[32] << 8)) | (X2 = blk[48]) | (X3 = blk[16]) | (X4 = blk[8]) | (X5 = blk[56]) | (X6 = blk[40]) | (X7 = blk[24])))
		{
			blk[0] = blk[8] = blk[16] = blk[24] = blk[32] = blk[40] = blk[48] = blk[56] = iclp[(blk[0] + 32) >> 6];
			continue;
		}

		X0 = (blk[0] << 8) + 8192;

		/* first stage  */
		X8 = W7 * (X4 + X5) + 4;
		X4 = (X8 + WM17 * X4) >> 3;
		X5 = (X8 - WP17 * X5) >> 3;
		X8 = W3 * (X6 + X7) + 4;
		X6 = (X8 - WM35 * X6) >> 3;
		X7 = (X8 - WP35 * X7) >> 3;

		/* second stage  */
		X8 = X0 + X1;
		X0 -= X1;
		X1 = W6 * (X3 + X2) + 4;
		X2 = (X1 - WP26 * X2) >> 3;
		X3 = (X1 + WM26 * X3) >> 3;
		X1 = X4 + X6;
		X4 -= X6;
		X6 = X5 + X7;
		X5 -= X7;

		/* third stage  */
		X7 = X8 + X3;
		X8 -= X3;
		X3 = X0 + X2;
		X0 -= X2;
		X2 = (181 * (X4 + X5) + 128) >> 8;
		X4 = (181 * (X4 - X5) + 128) >> 8;

		/* fourth stage  */
		blk[0]  = iclp[(X7 + X1) >> 14];
		blk[8]  = iclp[(X3 + X2) >> 14];
		blk[16] = iclp[(X0 + X4) >> 14];
		blk[24] = iclp[(X8 + X6) >> 14];
		blk[32] = iclp[(X8 - X6) >> 14];
		blk[40] = iclp[(X0 - X4) >> 14];
		blk[48] = iclp[(X3 - X2) >> 14];
		blk[56] = iclp[(X7 - X1) >> 14];
	}
}

void jpeg_InitIDCT()
{
	int i;

	iclp = iclip + 512;
	for(i=-512 ; i<512 ; i++)
		iclp[i] = (i<-256) ? -256 : ((i>255) ? 255 : i);
}

///////////////////////////////
// create color lookup table
// for fast color conversion
///////////////////////////////



/////////////////////////////////////////////////////////////////////////////

   void jpeg_DecodeMCU0(int mx, int my, BIT_STREAM * pBS)
{


        JPEGBYTE MCU[3][(4*4*64)]; 	   // MCU 단위의 블럭

	int i, j, k, l, m, n, o;
	int Ns = ScanHeader.Ns;
	int H, V, Rh, Rv;
	int mWidth = Hmax * 8, mHeight = Vmax * 8;
	int bWidth = FrameHeader.X;
	int idx1, idx2, idx3;
	int iY, iCb, iCr; 
	int iR;
	int idx;
	short ZZ_OUT[64];

	JPEGBYTE * lBptr = Bptr;

#ifdef __OUTPUT_RGB__	
	int iG, iB;
#endif	

	int R, G, B;	
	int pos;
	int stride; 

	for( k=0 ; k < Ns ; k++ ) 
	{
	  H = FrameHeader.H[ k ] ;
	  V = FrameHeader.V[ k ] ;

	  // Divide Optimize
	  switch(H)
	    {
	    case 1: Rh = Hmax; break;
	    case 2: Rh = Hmax>>1;break;
	    case 4: Rh = Hmax>>2;break;
	    default: Rh = Hmax / H;
	    }

	  switch(V)
	    {
	    case 1: Rv = Vmax; break;
	    case 2: Rv = Vmax>>1;break;
	    case 4: Rv = Vmax>>2;break;
	    default: Rv = Vmax / V;
	    }


	  for( l=0 ; l < V ; l++ ) 
	    {
	      for( m=0 ; m<H ; m++ ) 
		{ 


		  jpeg_DecodeDU( k , pBS,ZZ_OUT);

		  for( i=0 ; i<8 ; i++ ) 
		    {
		      for( j=0 ; j<8 ; j++ ) 
			{
			  idx1 = ( ( l << 3 ) + i ) * Rv ;
			  idx2 = ( ( m << 3 ) + j ) * Rh ;
			  idx3 = ( i << 3 ) + j ;
#if 1
			  for( n = 0 ; n < Rv ; n++ )    
			    {
			      switch(Rh)
				{
				case 4 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 3 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 3 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 2 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 2 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 1 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 1 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 0 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				}
			    }
#else
			  for( n = 0 ; n < Rv ; n++ )    
			    {
			      for( o = 0 ; o < Rh ; o++ )    
				{
				  MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + o ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				}
			    }
#endif

			}
		    }
		}
	    }
	}
	
	idx = 0;
	//stride = STRIDE(bWidth, DISPLAY_DIB_BPP);
	stride = STRIDE(bWidth, 32);
	for( i = 0 ; i < mHeight ; i++ )
	{
		idx1 = my * mHeight + i ;

		for( j = 0 ; j < mWidth ; j++ )    
		{
			idx2 = mx * mWidth + j ;
			idx3 = i * mWidth + j ;

			pos = (idx1*stride) + (idx2*4);


			if (Ns > 1)
			{

				iY  = (JPEGBYTE)MCU[0][idx3];
				iCb = (JPEGBYTE)MCU[1][idx3];
				iCr = (JPEGBYTE)MCU[2][idx3];

		
				iR = iY +  (((iCr -128)*1436)>>10);
				iG = iY -  (
					    (
					     (
					      (iCb -128) *352 
					      )>>10
					     ) +  
					    (
					     (
					      (iCr - 128)*731
					      )>>10
					     )
					    );
				iB = iY +  (((iCb -128)*1814)>>10);
				

				R = MAX(MIN(iR, 255), 0);
				G = MAX(MIN(iG, 255), 0);
				B = MAX(MIN(iB, 255), 0);
				
				
				if(idx2 < bWidth)
				{
					/* Origin
					*(lBptr + pos)     = G;
					*(lBptr + pos + 1) = B;
					*(lBptr + pos + 2) = R;
					*/
					
					/* Graphic */
					*(lBptr + pos + 0) = B;
					*(lBptr + pos + 1) = G;
					*(lBptr + pos + 2) = R;
					*(lBptr + pos + 3) = 0;
					
				
				}

			} 
			else 
			{
				iY  = (JPEGBYTE)MCU[0][idx3];
				iR = iY;
				
				R = MAX(MIN(iR, 255), 0);
				G = R;
				B = R;

				if(idx2 < bWidth)
				{
					/*
					*(lBptr + pos)     = G;
					*(lBptr + pos + 1) = B;
					*(lBptr + pos + 2) = R;
					*/
					
					/* Graphic */
					*(lBptr + pos + 0) = B;
					*(lBptr + pos + 1) = G;
					*(lBptr + pos + 2) = R;
					*(lBptr + pos + 3) = 0;

					
				
				}
			}

		}
	}
}
   void jpeg_DecodeMCU(int mx, int my, BIT_STREAM * pBS)
{


        JPEGBYTE MCU[3][(4*4*64)]; 	   // MCU 단위의 블럭

	int i, j, k, l, m, n, o;
	int Ns = ScanHeader.Ns;
	int H, V, Rh, Rv;
	int mWidth = Hmax * 8, mHeight = Vmax * 8;
	int bWidth = FrameHeader.X;
	int idx1, idx2, idx3;
	int iY, iCb, iCr; 
	int iR;
	int idx;
	short ZZ_OUT[64];

	JPEGBYTE * lBptr = Bptr;

#ifdef __OUTPUT_RGB__	
	int iG, iB;
#endif	

	int R, G, B;	
	int pos;
	int stride; 

	for( k=0 ; k < Ns ; k++ ) 
	{
	  H = FrameHeader.H[ k ] ;
	  V = FrameHeader.V[ k ] ;

	  // Divide Optimize
	  switch(H)
	    {
	    case 1: Rh = Hmax; break;
	    case 2: Rh = Hmax>>1;break;
	    case 4: Rh = Hmax>>2;break;
	    default: Rh = Hmax / H;
	    }

	  switch(V)
	    {
	    case 1: Rv = Vmax; break;
	    case 2: Rv = Vmax>>1;break;
	    case 4: Rv = Vmax>>2;break;
	    default: Rv = Vmax / V;
	    }


	  for( l=0 ; l < V ; l++ ) 
	    {
	      for( m=0 ; m<H ; m++ ) 
		{ 


		  jpeg_DecodeDU( k , pBS,ZZ_OUT);

		  for( i=0 ; i<8 ; i++ ) 
		    {
		      for( j=0 ; j<8 ; j++ ) 
			{
			  idx1 = ( ( l << 3 ) + i ) * Rv ;
			  idx2 = ( ( m << 3 ) + j ) * Rh ;
			  idx3 = ( i << 3 ) + j ;
#if 1
			  for( n = 0 ; n < Rv ; n++ )    
			    {
			      switch(Rh)
				{
				case 4 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 3 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 3 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 2 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 2 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 1 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				case 1 : MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + 0 ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				}
			    }
#else
			  for( n = 0 ; n < Rv ; n++ )    
			    {
			      for( o = 0 ; o < Rh ; o++ )    
				{
				  MCU[k][ ( idx1 + n ) * mWidth + ( idx2 + o ) ] = ( JPEGBYTE )ZZ_OUT[ idx3 ] ;
				}
			    }
#endif

			}
		    }
		}
	    }
	}
	
	{
		#include <stdarg.h>
		extern unsigned char smt2UartPrint(int dispLvl, char *fmt, ...);
		
		//smt2UartPrint(11, "w,h mw, mh %d %d %d %d \n", mWidth, mHeight, mx, my);
		
	}
	idx = 0;
	//stride = STRIDE(bWidth, DISPLAY_DIB_BPP);
	stride = STRIDE(bWidth, 16);
	for( i = 0 ; i < mHeight ; i++ )
	{
		idx1 = my * mHeight + i ;

		for( j = 0 ; j < mWidth ; j++ )    
		{
			idx2 = mx * mWidth + j ;
			idx3 = i * mWidth + j ;

			//pos = (idx1 * stride) + (idx2 * (DISPLAY_DIB_BPP / 8));
			pos = (idx1 * 1440*2) + (idx2*2);//(DISPLAY_DIB_BPP / 8));


			if (Ns > 1)
			{

#ifdef __OUTPUT_RGB__
				iY  = (JPEGBYTE)MCU[0][idx3];
				iCb = (JPEGBYTE)MCU[1][idx3];
				iCr = (JPEGBYTE)MCU[2][idx3];

				/*
				iR = iY +  (((iCr -128)*1436)>>10);
				iG = iY -  (
					    (
					     (
					      (iCb -128) *352 
					      )>>10
					     ) +  
					    (
					     (
					      (iCr - 128)*731
					      )>>10
					     )
					    );
				iB = iY +  (((iCb -128)*1814)>>10);
				

				R = MAX(MIN(iR, 255), 0);
				G = MAX(MIN(iG, 255), 0);
				B = MAX(MIN(iB, 255), 0);
				*/
				
				if(idx2 < bWidth)
				{
					/* Origin
					*(lBptr + pos)     = G;
					*(lBptr + pos + 1) = B;
					*(lBptr + pos + 2) = R;
					*/
					
					/* Graphic 
					*(lBptr + pos + 0) = B;
					*(lBptr + pos + 1) = G;
					*(lBptr + pos + 2) = R;
					*(lBptr + pos + 3) = 0;
					*/
					
					/* Video */
					
					if(idx%2) *(lBptr + pos + 0) = iCr;
					else	  *(lBptr + pos + 0) = iCb;
					*(lBptr + pos + 1) = iY;
					idx++;
					
				
				}
#else
				R  = (JPEGBYTE)MCU[0][idx3];
				G  = (JPEGBYTE)MCU[1][idx3];
				B  = (JPEGBYTE)MCU[2][idx3];

				if(idx2 < bWidth)
				{
					*(lBptr + pos)     = G;
					*(lBptr + pos + 1) = B;
					*(lBptr + pos + 2) = R;
				}

#endif
			} 
			else 
			{
				iY  = (JPEGBYTE)MCU[0][idx3];
				iR = iY;
				
				/*
				R = MAX(MIN(iR, 255), 0);
				G = R;
				B = R;
				*/

				if(idx2 < bWidth)
				{
					/*
					*(lBptr + pos)     = G;
					*(lBptr + pos + 1) = B;
					*(lBptr + pos + 2) = R;
					*/
					
					/* Graphic 
					*(lBptr + pos + 0) = B;
					*(lBptr + pos + 1) = G;
					*(lBptr + pos + 2) = R;
					*(lBptr + pos + 3) = 0;
					*/
					
					
					/* Video currently don't use*/
					if(idx%2) *(lBptr + pos + 0) = iCr;
					else	  *(lBptr + pos + 0) = iCb;
					*(lBptr + pos + 1) = iY;
					idx++;
					
				
				}
			}
#if 0
			if (Ns > 1)
			{
				iY  = (JPEGBYTE)MCU[0][idx3];
				iCb = (JPEGBYTE)MCU[1][idx3];
				iCr = (JPEGBYTE)MCU[2][idx3];

				if(idx2 < bWidth)
				{
					*(lBptr + pos)     = iY;
					*(lBptr + pos + 1) = iCb;
					*(lBptr + pos + 2) = iCr;
				}
			} 
			else 
			{
				iY  = (JPEGBYTE)MCU[0][idx3];
				iR = iY;

				R = MAX(MIN(iR, 255), 0);x
				G = R;
				B = R;

				if(idx2 < bWidth)
				{
					*(lBptr + pos)     = B;
					*(lBptr + pos + 1) = G;
					*(lBptr + pos + 2) = R;
				}
			}			
#endif			
		}
	}
}

////////////////////////////////////////////////////////

/*****************************************/
#define LBLOCKSIZE (sizeof(long))
#define UNALIGNED(X)   ((long)X & (LBLOCKSIZE - 1))
#define TOO_SMALL(LEN) ((LEN) < LBLOCKSIZE)

//#define PREFER_SIZE_OVER_SPEED
//#define __OPTIMIZE_SIZE__

void * memset_jy( void * m, int c, int n)
{
#if defined(PREFER_SIZE_OVER_SPEED) || defined(__OPTIMIZE_SIZE__)
  char *s = (char *) m;

  while (n-- != 0)
    {
      *s++ = (char) c;
    }

  return m;
#else
  char *s = (char *) m;
  int i;
  unsigned long buffer;
  unsigned long *aligned_addr;
  unsigned int d = c & 0xff;	/* To avoid sign extension, copy C to an
				   unsigned variable.  */

  if (!TOO_SMALL (n) && !UNALIGNED (m))
    {
      /* If we get this far, we know that n is large and m is word-aligned. */
      aligned_addr = (unsigned long*)m;

      /* Store D into each char sized location in BUFFER so that
         we can set large blocks quickly.  */
      if (LBLOCKSIZE == 4)
        {
          buffer = (d << 8) | d;
          buffer |= (buffer << 16);
        }
      else
        {
          buffer = 0;
          for (i = 0; i < LBLOCKSIZE; i++)
	    buffer = (buffer << 8) | d;
        }

      while (n >= LBLOCKSIZE*4)
        {
          *aligned_addr++ = buffer;
          *aligned_addr++ = buffer;
          *aligned_addr++ = buffer;
          *aligned_addr++ = buffer;
          n -= 4*LBLOCKSIZE;
        }

      while (n >= LBLOCKSIZE)
        {
          *aligned_addr++ = buffer;
          n -= LBLOCKSIZE;
        }
      /* Pick up the remainder with a bytewise loop.  */
      s = (char*)aligned_addr;
    }

  while (n--)
    {
      *s++ = (char)d;
    }

  return m;
#endif /* not PREFER_SIZE_OVER_SPEED */
} 


/**********************/

/* Nonzero if either X or Y is not aligned on a "long" boundary.  */
#undef  UNALIGNED
#define UNALIGNED(X, Y)   (((long)X & (sizeof (long) - 1)) | ((long)Y & (sizeof (long) - 1)))

/* How many bytes are copied each iteration of the 4X unrolled loop.  */
#define BIGBLOCKSIZE    (sizeof (long) << 2)

/* How many bytes are copied each iteration of the word copy loop.  */
#define LITTLEBLOCKSIZE (sizeof (long))

/* Threshhold for punting to the byte copier.  */
#undef  TOO_SMALL
#define TOO_SMALL(LEN)  ((LEN) < BIGBLOCKSIZE)
 

void * memcpy_jy( void * dst0, void * src0, int len0)
{
#if defined(PREFER_SIZE_OVER_SPEED) || defined(__OPTIMIZE_SIZE__)
  void * save;

  char *dst = (char *) dst0;
  char *src = (char *) src0;
  
  save = dst0;

  while (len0--)
    {
      *dst++ = *src++;
    }

  return save;
#else
  char *dst = (char *)dst0;
  char *src = (char *)src0;
  long *aligned_dst;
  long *aligned_src;
  int   len =  len0;

  /* If the size is small, or either SRC or DST is unaligned,
     then punt into the byte copy loop.  This should be rare.  */
  if (!TOO_SMALL(len) && !UNALIGNED (src, dst))
    {
      aligned_dst = (long*)dst;
      aligned_src = (long*)src;

      /* Copy 4X long words at a time if possible.  */
      while (len >= BIGBLOCKSIZE)
        {
          *aligned_dst++ = *aligned_src++;
          *aligned_dst++ = *aligned_src++;
          *aligned_dst++ = *aligned_src++;
          *aligned_dst++ = *aligned_src++;
          len -= BIGBLOCKSIZE;
        }

      /* Copy one long word at a time if possible.  */
      while (len >= LITTLEBLOCKSIZE)
        {
          *aligned_dst++ = *aligned_src++;
          len -= LITTLEBLOCKSIZE;
        }

       /* Pick up any residual with a byte copier.  */
      dst = (char*)aligned_dst;
      src = (char*)aligned_src;
    }

  while (len--)
    *dst++ = *src++;

  return dst0;
#endif /* not PREFER_SIZE_OVER_SPEED */
} 
