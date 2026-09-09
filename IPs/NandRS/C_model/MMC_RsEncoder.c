#include <stdio.h>

void Encoder520_512(  int *data);
void ErrorDetect520_512(  int *data);
int BinMult(  int a, int b);
int KeyEquationSolver (void);

int Uclid_check(void);
  int Inverse_GF1024 (  int Number);
//  primitive polynomial = [1 0 0 0 0 0 0 1 0 0 1]
//  따라서 x^10 = x^3 + 1
// 
// 사용할 생성자
// generator = (x - a) (x - a^2) (x - a^3) (x - a^4) (x - a^5)(x - a^6)(x - a^7)(x - a^8) 
//
// 전개 
//  
//  x^4 + (a^4 + a^3 + a^2 + a) x^3 + (a^7 + a^6 + a^4 + a^3) x^2 + (a^9 + a^8 + a^7 + a^6) x + a^10
//  x^4 + (a^8 + a^7 + a^6 + a^5) x^3 + (a^15 + a^14 + a^12 + a^11) x^2 + (a^21 + a^20 + a^19 + a^18) x + a^26
// 
//  x^8 + 
//  (a^8 + a^7 + a^6 + a^5 + a^4 + a^3 + a^2 + a)x^7 +
//  (a^15 + a^14 + a^11 + a^10 + a^8 + a^7 + a^4 + a^3)x^6 +
//  (a^21 + a^20 + a^18 + a^16 + a^11 + a^8)x^5
//  (a^26 + a^25 + a^23 + a^22 + a^21 + a^20 + a^19 + a^17 + a^16 + a^15 + a^14 + a^13 + a^11 + a^10) x^4
//  (a^30 + a^29 + a^27 + a^25 + a^20 + a^18 + a^16 + a^15) x^3
//  (a^33 + a^32 + a^29 + a^28 + a^26 + a^25 + a^22 + a^21) x^2
//  (a^35 + a^34 + a^33 + a^32 + a^31 + a^30 + a^29 + a^28) x^1
//  a^36
//
//
//
//  
//
// generator의 근은  2, 4, 8, 16, 32, 64, 128, 256
void Encoder514_512(int *data);
  int s[8]={0,};

  int data[520] = { 
			         1,  2,  3,  4,  5,  6,  7,  8,  9,  10,
				11, 12, 13, 14, 15, 16, 17, 18, 19,  20,
				21, 22, 23, 24, 25, 26, 27, 28, 29,  30,
				31, 32, 33, 34, 35, 36, 37, 38, 39,  40,
			 	41, 42, 43, 44, 45, 46, 47, 48, 49,  50,
				51, 52, 53, 54, 55, 56, 57, 58, 59,  60,
				61, 62, 63, 64, 65, 66, 67, 68, 69,  70,
				71, 72, 73, 74, 75, 76, 77, 78, 79,  80,
				81, 82, 83, 84, 85, 86, 87, 88, 89,  90,
				91, 92, 93, 94, 95, 96, 97, 98, 99, 100,
			       101,102,103,104,105,106,107,108,109, 110,
			       111,112,113,114,115,116,117,118,119, 120,
			       121,122,123,124,125,126,127,128,129, 130,
			       131,132,133,134,135,136,137,138,139, 140,
			       141,142,143,144,145,146,147,148,149, 150,
			       151,152,153,154,155,156,157,158,159, 160,
			       161,162,163,164,165,166,167,168,169, 170,
			       171,172,173,174,175,176,177,178,179, 180,
			       181,182,183,184,185,186,187,188,189, 190,
			       191,192,193,194,195,196,197,198,199, 200,
			       201,202,203,204,205,206,207,208,209, 210,
			       211,212,213,214,215,216,217,218,219, 220,
			       221,222,223,224,225,226,227,228,229, 230,
			       231,232,233,234,235,236,237,238,239, 240,
			       241,242,243,244,245,246,247,248,249, 250,
			       251,252,253,254,255,256,257,258,259, 260,
			       261,262,263,264,265,266,267,268,269, 270,
			       271,272,273,274,275,276,277,278,279, 280,
			       281,282,283,284,285,286,287,288,289, 290,
			       291,292,293,294,295,296,297,298,299, 300,
			       301,302,303,304,305,306,307,308,309, 310,
			       311,312,313,314,315,316,317,318,319, 320,
			       321,322,323,324,325,326,327,328,329, 330,
			       331,332,333,334,335,336,337,338,339, 340,
			       341,342,343,344,345,346,347,348,349, 350,
			       351,352,353,354,355,356,357,358,359, 360,
			       361,362,363,364,365,366,367,368,369, 370,
			       371,372,373,374,375,376,377,378,379, 380,
			       381,382,383,384,385,386,387,388,389, 390,
			       391,392,393,394,395,396,397,398,399, 400,
			       401,402,403,404,405,406,407,408,409, 410,
			       411,412,413,414,415,416,417,418,419, 420,
			       421,422,423,424,425,426,427,428,429, 430,
			       431,432,433,434,435,436,437,438,439, 440,
			       441,442,443,444,445,446,447,448,449, 450,
			       451,452,453,454,455,456,457,458,459, 460,
			       461,462,463,464,465,466,467,468,469, 470,
			       471,472,473,474,475,476,477,478,479, 480,
			       481,482,483,484,485,486,487,488,489, 490,
			       491,492,493,494,495,496,497,498,499, 500,
			       501,502,503,504,505,506,507,508,509, 510,
			       511,512,0,0,0,0,0,0,0,0} ;


  int data2[520] = { 
			        0 ,  0,  3,  4,  5,  6,  7,  8,  9,  10,
				11, 12, 13, 14, 15, 16, 17, 18, 19,  20,
				21, 22, 23, 24, 25, 26, 27, 28, 29,  30,
				31, 32, 33, 34, 35, 36, 37, 38, 39,  40,
			 	41, 42, 43, 44, 45, 46, 47, 48, 49,  50,
				51, 52, 53, 54, 55, 56, 57, 58, 59,  60,
				61, 62, 63, 64, 65, 66, 67, 68, 69,  70,
				71, 72, 73, 74, 75, 76, 77, 78, 79,  80,
				81, 82, 83, 84, 85, 86, 87, 88, 89,  90,
				91, 92, 93, 94, 95, 96, 97, 98, 99, 100,
			       101,102,103,104,105,106,107,108,109, 110,
			       111,112,113,114,115,116,117,118,119, 120,
			       121,122,123,124,125,126,127,128,129, 130,
			       131,132,133,134,135,136,137,138,139, 140,
			       141,142,143,144,145,146,147,148,149, 150,
			       151,152,153,154,155,156,157,158,159, 160,
			       161,162,163,164,165,166,167,168,169, 170,
			       171,172,173,174,175,176,177,178,179, 180,
			       181,182,183,184,185,186,187,188,189, 190,
			       191,192,193,194,195,196,197,198,199, 200,
			       201,202,203,204,205,206,207,208,209, 210,
			       211,212,213,214,215,216,217,218,219, 220,
			       221,222,223,224,225,226,227,228,229, 230,
			       231,232,233,234,235,236,237,238,239, 240,
			       241,242,243,244,245,246,247,248,249, 250,
			       251,252,253,254,255,256,257,258,259, 260,
			       261,262,263,264,265,266,267,268,269, 270,
			       271,272,273,274,275,276,277,278,279, 280,
			       281,282,283,284,285,286,287,288,289, 290,
			       291,292,293,294,295,296,297,298,299, 300,
			       301,302,303,304,305,306,307,308,309, 310,
			       311,312,313,314,315,316,317,318,319, 320,
			       321,322,323,324,325,326,327,328,329, 330,
			       331,332,333,334,335,336,337,338,339, 340,
			       341,342,343,344,345,346,347,348,349, 350,
			       351,352,353,354,355,356,357,358,359, 360,
			       361,362,363,364,365,366,367,368,369, 370,
			       371,372,373,374,375,376,377,378,379, 380,
			       381,382,383,384,385,386,387,388,389, 390,
			       391,392,393,394,395,396,397,398,399, 400,
			       401,402,403,404,405,406,407,408,409, 410,
			       411,412,413,414,415,416,417,418,419, 420,
			       421,422,423,424,425,426,427,428,429, 430,
			       431,432,433,434,435,436,437,438,439, 440,
			       441,442,443,444,445,446,447,448,449, 450,
			       451,452,453,454,455,456,457,458,459, 460,
			       461,462,463,464,465,466,467,468,469, 470,
			       471,472,473,474,475,476,477,478,479, 480,
			       481,482,483,484,485,486,487,488,489, 490,
			       491,492,493,494,495,496,497,498,499, 500,
			       501,502,503,504,505,506,507,508,509, 510,
			       511,512,245,708,310,930,184,340,318, 631} ;


//  int generator[8] ={836, 587, 58, 928, 663, 323, 51, 510};
  int generator[8] ={400,665, 677,29 ,1006,427,778,255};
	
	int data3[520]={0,};

int main(void)
{

	int i,j;
//	printf("%d " ,BinMult(458,82));
//
	/*int EP;
	EP=4;
	for (i=0; i < 502 ; i++ ) 
	{
	if (i != 0)
		{
		EP =	BinMult (EP, 4); 	// a^4을 곱한다.
		}
	}
	printf("EP value = %d", EP );
	printf(" value = %d" , BinMult(EP,10));

	EP=10;
	for (i=0; i < 503 ; i++ ) 
	{
	if (i != 0)
		{
		EP =	BinMult (EP, 4); 	// a^4을 곱한다.
		}
	}
	printf("EP value = %d", EP );
*/		

//  Inverse_GF1024 (0);

	ErrorDetect520_512(data2);
	#if 0
	Encoder520_512(data);
	// decoder
	ErrorDetect520_512(data2);
	KeyEquationSolver();
	#endif
}


// GF (2^10)
// 기준 입력이 8bit이므로 상위에 2bit를 덧붙여 encoding하여야한다.
void Encoder520_512(int *data) // (520,512) encoder  최대 4symbol 정정 가능
{
	// 덧셈 xor
	int parity[8] = {0, }; // Initialize LFSR

	int indata;
	int i;
	for (i=0; i < 512 ; i++)// information signal is 512 byte data 
	{
		indata = parity[7]^(data[i]); 
		parity[7] = parity[6]^BinMult(indata, generator[7]);
		parity[6] = parity[5]^BinMult(indata, generator[6]);
		parity[5] = parity[4]^BinMult(indata, generator[5]);
		parity[4] = parity[3]^BinMult(indata, generator[4]);
		parity[3] = parity[2]^BinMult(indata, generator[3]);
		parity[2] = parity[1]^BinMult(indata, generator[2]);
		parity[1] = parity[0]^BinMult(indata, generator[1]);
		parity[0] = BinMult(indata, generator[0]);
	}
	printf ("Reed Solomon Encoding End\n\r");
	printf ("Reed Solomon Parity value:  ");
	for (i = 0 ; i < 8; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");

	data [512] = parity[7]; // 계산된 패리티를 정보 뒤에 붙인다
	data [513] = parity[6]; 
	data [514] = parity[5]; 
	data [515] = parity[4]; 
	data [516] = parity[3]; 
	data [517] = parity[2];
	data [518] = parity[1];
	data [519] = parity[0];

	for (i=0; i < 520 ; i ++)
	printf ("%3d " ,data[i]);
	printf ("\n\r " ,data[i]);

}


int BinMult(int a, int b)
{
	//곱셈
	// A.B = (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)(b0 + b1x + b2x^2 + b3x^3 ... b9x^9)
	// b0 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^0 +
	// b1 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^1 +
	// b2 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^2 +
	// b3 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^3 +
	// b4 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^4 +
	// b5 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^5 +
	// b6 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^6 +
	// b7 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^7 +
	// b8 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^8 +
	// b9 (a0 + a1x + a2x^2 + a3x^3 ... a9x^9)x^9
	
	// 계수별로 분리하면
	// x^0  = a0b0
	// x^1  = a1b0 + a0b1
	// x^2  = a2b0 + a1b1 + a0b2
	// x^3  = a3b0 + a2b1 + a1b2 + a0b3
	// x^4  = a4b0 + a3b1 + a2b2 + a1b3 + a0b4
	// x^5  = a5b0 + a4b1 + a3b2 + a2b3 + a1b4 + a0b5
	// x^6  = a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a1b5 + a0b6
	// x^7  = a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a1b6 + a0b7
	// x^8  = a8b0 + a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7 + a0b8
	// x^9  = a9b0 + a8b1 + a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7 + a1b8 + a0b9
	// x^10 = a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a1b9
	// x^11 = a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9
	// x^12 = a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9
	// x^13 = a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9  
	// x^14 = a9b5 + a8b6 + a7b7 + a6b8 + a5b9
	// x^15 = a9b6 + a8b7 + a7b8 + a6b9
	// x^16 = a9b7 + a8b8 + a7b9
	// x^17 = a9b8 + a8b9
	// x^18 = a9b9 
	//
	//  primitive polynomial = [1 0 0 0 0 0 0 1 0 0 1]
	//  따라서 x^10 = x^3 + 1
	//
	//  x^10 =				x^3  + 1
	//  x^11 = 				x^4  + x
	//  x^12 =				x^5  + x^2
	//  x^13 = 				x^6  + x^3
	//  x^14 = 				x^7  + x^4
	//  x^15 =				 x^8  + x^5
	//  x^16 =				 x^9  + x^6
	//  x^17 = x^10 + x^7 =			 x^7 + x^3 + 1
	//  x^18 = x^11 + x^8 =			 x^8 + x^4 + x
	//
	//  x^0 = a0b0 + (a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a1b9) + (a9b8 + a8b9)
	//  x^1 = a1b0 + a0b1 + (a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9) + a9b9 
	//  x^2 = a2b0 + a1b1 + a0b2 + (a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9)
	//  x^3 = a3b0 + a2b1 + a1b2 + a0b3 + (a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a1b9) + (a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9) + (a9b8 + a8b9)
	//  x^4 = a4b0 + a3b1 + a2b2 + a1b3 + a0b4 + (a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9) + (a9b5 + a8b6 + a7b7 + a6b8 + a5b9) + a9b9 
	//  x^5 = a5b0 + a4b1 + a3b2 + a2b3 + a1b4 + a0b5 + (a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9) + (a9b6 + a8b7 + a7b8 + a6b9)
	//  x^6 = a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a1b5 + a0b6 + a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9 + a9b7 + a8b8 + a7b9
	//  x^7 = a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a1b6 + a0b7 + a9b5 + a8b6 + a7b7 + a6b8 + a5b9 + a9b8 + a8b9
	//  x^8 = a8b0 + a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7 + a0b8 + a9b6 + a8b7 + a7b8 + a6b9 + a9b9 
	//  x^9 = a9b0 + a8b1 + a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7 + a1b8 + a0b9 + a9b7 + a8b8 + a7b9

	// 입력되는 데이터 a의 0번과 1번 비트가 더미라고 하면
	//
	//  x^0 = a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a9b8 + a8b9
	//  x^1 = a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9 + a9b9 
	//  x^2 = a2b0 + a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9
	//  x^3 = a3b0 + a2b1 + a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8) + (a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9) + (a9b8 + a8b9)
	//  x^4 = a4b0 + a3b1 + a2b2 + a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9) + (a9b5 + a8b6 + a7b7 + a6b8 + a5b9) + a9b9 
	//  x^5 = a5b0 + a4b1 + a3b2 + a2b3 + a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9) + (a9b6 + a8b7 + a7b8 + a6b9)
	//  x^6 = a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9 + a9b7 + a8b8 + a7b9
	//  x^7 = a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a9b5 + a8b6 + a7b7 + a6b8 + a5b9 + a9b8 + a8b9
	//  x^8 = a8b0 + a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a9b6 + a8b7 + a7b8 + a6b9 + a9b9 
	//  x^9 = a9b0 + a8b1 + a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7 + a9b7 + a8b8 + a7b9
	//  위와 같다.
	
	  int data;
	  int data0, data1, data2, data3, data4, data5, data6, data7, data8, data9;
	  int a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
	  int b0, b1, b2, b3, b4, b5, b6, b7, b8, b9;
//--------------- bit level operation
	a0 = a & 0x0001;
	a1 = (a & 0x0002)>>1;
	a2 = (a & 0x0004)>>2;
	a3 = (a & 0x0008)>>3;
	a4 = (a & 0x0010)>>4;
	a5 = (a & 0x0020)>>5;
	a6 = (a & 0x0040)>>6;
	a7 = (a & 0x0080)>>7;
	a8 = (a & 0x0100)>>8;
	a9 = (a & 0x0200)>>9;

	b0 = (b & 0x0001);
	b1 = (b & 0x0002)>>1;
	b2 = (b & 0x0004)>>2;
	b3 = (b & 0x0008)>>3;
	b4 = (b & 0x0010)>>4;
	b5 = (b & 0x0020)>>5;
	b6 = (b & 0x0040)>>6;
	b7 = (b & 0x0080)>>7;
	b8 = (b & 0x0100)>>8;
	b9 = (b & 0x0200)>>9;

		//  x^0 = a0b0 + (a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a1b9) + (a9b8 + a8b9)
	data0 = (a0&b0 ^ 
		a9&b1 ^ 
		a8&b2 ^ 
		a7&b3 ^ 
		a6&b4 ^ 
		a5&b5 ^ 
		a4&b6 ^ 
		a3&b7 ^ 
		a2&b8 ^ 
		a1&b9 ^ 
		a9&b8 ^ 
		a8&b9) & 0x0001;

		//  x^1 = a1b0 + a0b1 + (a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9) + a9b9 
	data1 = (a1&b0 ^ 
		a0&b1 ^
		a9&b2 ^ 
		a8&b3 ^
		a7&b4 ^
		a6&b5 ^
		a5&b6 ^
		a4&b7 ^
		a3&b8 ^
		a2&b9 ^
		a9&b9 ) & 0x0001;
	
		//  x^2 = a2b0 + a1b1 + a0b2 + (a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9)
	data2 = (a2&b0 ^
		a1&b1 ^
		a0&b2 ^
		a9&b3 ^
		a8&b4 ^
		a7&b5 ^
		a6&b6 ^
		a5&b7 ^
		a4&b8 ^
		a3&b9) & 0x0001;

	//  x^3 = a3b0 + a2b1 + a1b2 + a0b3 + (a9b1 + a8b2 + a7b3 + a6b4 + a5b5 + a4b6 + a3b7 + a2b8 + a1b9) + (a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9) + (a9b8 + a8b9)
	data3 = (
 		a3&b0 ^
		a2&b1 ^
		a1&b2 ^
		a0&b3 ^
		a9&b1 ^
		a8&b2 ^
		a7&b3 ^
		a6&b4 ^
		a5&b5 ^
		a4&b6 ^
		a3&b7 ^
		a2&b8 ^
		a1&b9 ^
		a9&b4 ^
		a8&b5 ^
		a7&b6 ^
		a6&b7 ^
		a5&b8 ^
		a4&b9 ^
		a9&b8 ^
		a8&b9) & 0x0001;
	//  x^4 = a4b0 + a3b1 + a2b2 + a1b3 + a0b4 + (a9b2 + a8b3 + a7b4 + a6b5 + a5b6 + a4b7 + a3b8 + a2b9) + (a9b5 + a8b6 + a7b7 + a6b8 + a5b9) + a9b9 
 	data4 = (
		a4&b0 ^ 
		a3&b1 ^
		a2&b2 ^
		a1&b3 ^
		a0&b4 ^
		a9&b2 ^
		a8&b3 ^
		a7&b4 ^
		a6&b5 ^
		a5&b6 ^
		a4&b7 ^
		a3&b8 ^
		a2&b9 ^
		a9&b5 ^
		a8&b6 ^ 
		a7&b7 ^
		a6&b8 ^
		a5&b9 ^
		a9&b9 ) & 0x0001;
	//  x^5 = a5b0 + a4b1 + a3b2 + a2b3 + a1b4 + a0b5 + (a9b3 + a8b4 + a7b5 + a6b6 + a5b7 + a4b8 + a3b9) + (a9b6 + a8b7 + a7b8 + a6b9)
	data5 = (
		a5&b0 ^
		a4&b1 ^
		a3&b2 ^
		a2&b3 ^ 
		a1&b4 ^ 
		a0&b5 ^ 
		a9&b3 ^
		a8&b4 ^
		a7&b5 ^
		a6&b6 ^
		a5&b7 ^
		a4&b8 ^
		a3&b9 ^
		a9&b6 ^
		a8&b7 ^
		a7&b8 ^
		a6&b9) & 0x0001;

	//  x^6 = a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a1b5 + a0b6 + a9b4 + a8b5 + a7b6 + a6b7 + a5b8 + a4b9 + a9b7 + a8b8 + a7b9
	data6 = (
		a6&b0 ^ 
		a5&b1 ^
		a4&b2 ^
		a3&b3 ^
		a2&b4 ^
		a1&b5 ^
		a0&b6 ^
		a9&b4 ^
		a8&b5 ^
		a7&b6 ^
		a6&b7 ^
		a5&b8 ^
		a4&b9 ^
		a9&b7 ^
		a8&b8 ^
		a7&b9) & 0x0001 ;

	//  x^7 = a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a1b6 + a0b7 + a9b5 + a8b6 + a7b7 + a6b8 + a5b9 + a9b8 + a8b9
	data7 = (
		a7&b0 ^
		a6&b1 ^
		a5&b2 ^
		a4&b3 ^
		a3&b4 ^
		a2&b5 ^
		a1&b6 ^
		a0&b7 ^
		a9&b5 ^
		a8&b6 ^
		a7&b7 ^
		a6&b8 ^
		a5&b9 ^
		a9&b8 ^
		a8&b9) & 0x0001;

	//  x^8 = a8b0 + a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7 + a0b8 + a9b6 + a8b7 + a7b8 + a6b9 + a9b9 
	data8 = (
		a8&b0 ^
		a7&b1 ^
		a6&b2 ^
		a5&b3 ^
		a4&b4 ^ 
		a3&b5 ^
		a2&b6 ^
		a1&b7 ^
		a0&b8 ^
		a9&b6 ^
		a8&b7 ^
		a7&b8 ^
		a6&b9 ^
		a9&b9)&0x0001;

	//  x^9 = a9b0 + a8b1 + a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7 + a1b8 + a0b9 + a9b7 + a8b8 + a7b9
	data9 = (
		 a9&b0 ^
		 a8&b1 ^
		 a7&b2 ^
		 a6&b3 ^
		 a5&b4 ^
		 a4&b5 ^
		 a3&b6 ^
		 a2&b7 ^
		 a1&b8 ^
		 a0&b9 ^
		 a9&b7 ^
		 a8&b8 ^
		 a7&b9)& 0x0001	;

		data = (data9<<9)|(data8<<8)|(data7<<7)|(data6<<6)|(data5<<5)|(data4<<4)|(data3<<3)|(data2<<2)|(data1<<1)|(data0);

	return data;
}


/// Decoding Part


// Syndrom Check
void ErrorDetect520_512(int *data) // syndrom 계산
{
	// R(X) = C(X) + E(X) 이므로
	// 수신 다항식에 Generator로 사용한 다항식의 근을 넣으면 C(X) = G(X)Q(X)이므로 C(X)항은 사라지게된다.
	// 
	// C(x) = Cn-1x^n-1 + .... + C0
	// C(x) = C254x^254 + .... + C0
	
	// 따라서 C254 = data[0]
	// C[0]= data[254]가 된다.
	//
	// 신드롬을 계산해야하는데.
	// 수신 다항식을 
	// R(X) = rn-1 X^n-1 + ...r1X + r0라하면
	//
	// 신드롬은  여기에 생성다항식의 근을 넣어서 구한다.
	// 즉,
	// Sk = rn-1 a^n-1k + ... r1a^k + r0 (k= 1,2 .. 2t)	
	// Sk = (...((rn-1 a^k + rn-2)a^k + rn-3)a^k +...+r1)a^k +r0)
	//  계수에 근을 곱하고 다음 계수를 더하고  a^k를 구하는 구조이다.
	//
	//  S = S2t +... S1이므로 모두 구하여 더한다.
	//
	
	//generator의 근은 2, 4, 8, 16, 32, 64, 128, 256
	int d,k;
//	int groot2[8] = { 2, 4, 8, 16, 32, 64, 128, 256};
	int groot2[8] = {1, 2, 4, 8, 16, 32, 64, 128}; // Generator 다항식의 근
	int i,j;

	for (i=0; i<8 ; i++)
		s[i]= 0;
	for (i=0; i <8 ; i++)
	{
		for (j=0; j<520; j++)
		{
			if (j==0)
			{
				d= data[j];
			}
			else
			{
				k = (BinMult(d,groot2[i]));
				d = (data[j]^k);
			}
		}
		s[i] = d; //s는 신드롬 다항식
	}

	if (s[0]|s[1]|s[2]|s[3]|s[4]|s[5]|s[6]|s[7])
	{
		printf (" Receive data Error Detected !! \n\r");
		printf(" systoric \n\r");
		printf(" syndrom s0 = %d, s1= %d, s2= %d, s3= %d \n\r" , s[0], s[1], s[2], s[3]);
		printf(" syndrom s4 = %d, s5= %d, s6= %d, s7= %d \n\r" , s[4], s[5], s[6], s[7]);
	}
	else
	{
		printf (" Receive data No Error !! \n\r");
	}

	
}

int KeyEquationSolver (void)
{
	int R [9] = {0,0,0,0,0,0,0,0,1}; // r0 = x^2t
	int Q [9] = {0, } ; //초기값은 신드롬 다항식

	int Rorder [9];
       	int Qorder [9];	
       	int Lorder [9];	

	int OrderR, OrderQ, OrderL;

	int i, j, k;
	int lambda[9] 	= {0,};
	int mue[9]	= {0,};
	int temp[9]	= {0,};
	int tempR[9]	= {0,};
	int temp1[9]	= {0,};
	int ErrPosition[9] = {0,};
	int ErrValue[9]	= {0,};
	int tmp;

	int EP8, EP7, EP6, EP5, EP4, EP3, EP2, EP1, EP0;
	int EV7, EV6, EV5, EV4, EV3, EV2, EV1, EV0;
	int ErrorEven, ErrorOdd;
	lambda[0] = 0;
	mue[0] = 1; 
	Q[8] = 0;
	Q[7] = (s[7])&0x3ff;
	Q[6] = (s[6])&0x3ff;
	Q[5] = (s[5])&0x3ff;
	Q[4] = (s[4])&0x3ff;
	Q[3] = (s[3])&0x3ff;
	Q[2] = (s[2])&0x3ff;
	Q[1] = (s[1])&0x3ff;
	Q[0] = (s[0])&0x3ff;

	R[8] = 1; // R0 = x^8

	printf("  \n\r ");
	printf("  \n\r ");
	printf(" -Initial Value Check- \n\r ");
	printf(" Q = ");
	for (i= 0; i <9 ; i++)
		printf(" %3d ",Q[i]);
		printf("  \n\r ");

	printf(" R = ");
	for (i= 0; i < 9 ; i++)
		printf(" %3d ",R[i]);
		printf("  \n\r ");

	printf(" Lambda = ");
	for (i= 0; i < 9 ; i++)
		printf(" %3d ",lambda[i]);
		printf("  \n\r ");

	printf(" Mue = ");
	for (i= 0; i < 9 ; i++)
		printf(" %3d ",mue[i]);
	printf("  \n\r ");
	printf("  \n\r ");
	printf("  \n\r ");

	for (k=1;  ; k++)
	{
		// 차수 비교
		// R order - Q order
		for (j=0 ; j< 9 ; j++)
		{
			if (R[j])	Rorder[j] = 1; // 계수가 0이 아니면 1을 넣는다.
			else		Rorder[j] = 0;
		}
		for (j=0 ; j< 9 ; j++)
		{
			if (Q[j])	Qorder[j] = 1; 
			else		Qorder[j] = 0; 
		}

		printf (" Rorder");
		for (j=0 ; j<9 ; j++)
		{
		printf (" %3d ",Rorder[j]);
		}
		printf (" \n\r");

		printf(" Qorder");
		for (j=0 ; j<9 ; j++)
		{
		printf (" %3d ",Qorder[j]);
		}
		printf (" \n\r");


		// first 1  position calcuation // 최상위 1이 나오는 bit 위치
		i=8;
		while( Rorder[i] !=1) 
			{	
				if (i==0)
					break;
				else
					i--;
			}
			OrderR = i;

		i=8;
		while( Qorder[i] !=1) 
			{	
				if (i==0)
					break;
				else
					i--;
			}
			OrderQ = i;

		printf(" OrderR %3d OrderQ %3d \n\r", OrderR , OrderQ);
		printf(" OrderR - OrderQ %3d \n\r", OrderR-OrderQ);

		if ((OrderR-OrderQ)>=0) // 서로의 차수를 비교
		{ 

			for (j=8; j>=0 ; j--)  // 계수크기만큼 반복
			{
				if ((j-(OrderR-OrderQ))>=0)
				{
					// R의 차수가 Q의 차수 보다 작을 경우로
					// R다항식에 Q의 최고차항의 계수를 곱한다.
					// Q다항식에는 R다항식의 최고차 항의 계수를 곱하여 같은 차수끼리 뺀다
					// (최고차항을 없애기 위해서)
					tmp =BinMult(Q[OrderQ], R[j])^BinMult(R[OrderR], Q[j-(OrderR-OrderQ)]) ; //유클리드 알고리즘 
				}
				else
				{
				tmp =BinMult(Q[OrderQ], R[j])^BinMult(R[OrderR], 0) ; //유클리드 알고리즘 
				// R의 차수가 Q보다 크다.
				}

				tempR[j]= tmp;
				if ((j-(OrderR- OrderQ))>=0)
				{
				tmp= BinMult(Q[OrderQ], lambda[j])^BinMult(R[OrderR], mue[j-(OrderR-OrderQ)]) ;
				}
				else
				{
				tmp= BinMult(Q[OrderQ], lambda[j])^BinMult(R[OrderR], 0) ;
				}
				lambda[j]= tmp;
			}

			for (j=8; j>=0 ; j--)
			{
				R[j] = tempR[j];
			}

		}
		else// Q가 더 높은 차수를 가질때
		{

			for (j= 8 ; j>=0 ; j--)
			{	

				if ((j-(OrderQ - OrderR))>=0)
				{
				temp[j] = BinMult(R[OrderR],Q[j]) ^ BinMult(Q[OrderQ],R[j-(OrderQ-OrderR)]);	
				}

				else
				{
				temp[j] = BinMult(R[OrderR],Q[j]) ^ BinMult(Q[OrderQ],0);	
				}


				if ((j-(OrderQ - OrderR))>=0)
				{
				temp1[j] = BinMult(R[OrderR],mue[j]) ^ BinMult(Q[OrderQ],lambda[(j-(OrderQ - OrderR))]);	
				}
				else
				{
				temp1[j] = BinMult(R[OrderR],mue[j]) ^ BinMult(Q[OrderQ],0);	
				}
			}

			for (j = 0 ; j < 9 ; j++)
			{
			Q[j] = R[j]; 
			mue[j]= lambda[j];
			}

			for (j = 0 ; j < 9 ; j++)
			{
			lambda[j] = temp1[j]; 
			R[j]= temp[j];
			}
	
		}

		printf(" R Poly: ");
		for (j=0 ; j <9 ; j++)
		{
			printf(" %3d ", R[j]);	
		}
		printf("\n\r");


		printf(" Q Poly: ");
		for (j=0 ; j <9 ; j++)
		{
			printf(" %3d ", Q[j]);
		}
		printf("\n\r");
	
		printf(" L Poly: ");
		for (j=0 ; j <9 ; j++)
		{
			printf(" %3d ", lambda[j]);
		}
		printf("\n\r");

		printf(" M Poly: ");
		for (j=0 ; j <9 ; j++)
		{
			printf(" %3d ", mue[j]);
		}
		printf("\n\r");


		for (j=0 ; j< 9 ; j++)
		{
			if (R[j])
				Rorder[j] = 1;
			else	
				Rorder[j] = 0;
		}
		for (j=0 ; j< 9 ; j++)
		{
			if (lambda[j])
				Lorder[j] = 1; 
			else
				Lorder[j] = 0; 
		}


		i=8;
		while( Rorder[i] !=1) 
			{	
				if (i==0)
					break;
				else
					i--;
			}
			OrderR = i;

		i=8;
		while( Lorder[i] !=1) 
			{	
				if (i==0)
					break;
				else
					i--;
			}
			OrderL = i;

		if (OrderR < OrderL)
		{
			for (j=0; j< 5 ; j++)
			{
				ErrPosition[j]= lambda[j];
			       	ErrValue[j] = R[j];
				printf(" ErrPosition[%2d] = %3d ", j, ErrPosition[j]);
				printf(" ErrValue[%2d] 	 = %3d \n\r", j, ErrValue[j]);
			}
			
			break;

		}

	}	
	// 에러 다항식과 에러값 다항식을 위에서 얻었으므로 이것을 풀어야 한다.
	//
	//
	// a^0 ... a^(n-1) // n개의 근을 대입
	// 에러 다항식이 0이 되는 값의 역이 에러의 보정된 값이다.
	//
	//
	// Chien Search
	//
	// 짝수항과 홀수 항을 나누어 연산
	//
	// a^1 ~ a^1023 까지 모두 넣어 다항식 0이 되는 것을 찾는다.
	//
	// 에러 위치 다항식과  에러 평가 다항식의 형태는 다음과 같으므로
	//
	// σ(a^i) =  σ0 +σ1a^i + σ2(a^i)^2 +σ3(a^i)^3 + ... σt(a^i)^t
	//
	// 계수가 곱해진 상태에서 i번 누적하여 a를 곱하는 형태로 만들면 된다.
	  
	EP4=ErrPosition[4];// 계수와 a^4을 곱한다.
	EP3=ErrPosition[3];// 계수와 a^3을 곱한다.
	EP2=ErrPosition[2];// 계수와 a^2을 곱한다.
	EP1=ErrPosition[1];// 계수와 a^1을 곱한다.
	EP0=ErrPosition[0];// 계수와 a^0을 곱한다.

	EV4 = ErrValue[4];
	EV3 = ErrValue[3];
	EV2 = ErrValue[2];
	EV1 = ErrValue[1];
	EV0 = ErrValue[0];


		k = 0 ; // error is correctable ? 0 is uncorrectable 1 is correctable
	 for (i=0; i < (520+503) ; i++ )  // RS(520,512)은 RS1023의 축약형이다.
		 			// 초항이 (a^503)이 곱해진 형태면 520 cycle만에 끝나고 아니면 1023까지 모두 넣어준다.
					//
		{
		if (i != 0)
			{
				EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
				EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
				EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
				EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
				EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
				EV4 = 	BinMult	(EV4,16);
				EV3 = 	BinMult	(EV3,8);
				EV2 = 	BinMult	(EV2,4);
				EV1 = 	BinMult	(EV1,2);
				EV0 = 	BinMult	(EV0,1);

			};

		ErrorOdd  =  EP3 ^ EP1;
		ErrorEven =  EP4 ^ EP2 ^ EP0 ;

		if ((ErrorEven^ErrorOdd) == 0)
			{
				k=1;
				printf("Error Location is %d (%d) and Error Value is %d \n\r", i, i-503, (EV4^EV3^EV2^EV1^EV0));
				printf("ErrorOdd Value is %d %d\n\r",ErrorOdd, ErrorEven); // Error Odd의 역원과 Error value를 곱한다.

			// Error odd 의 역원을 찾아 Error Value에 곱한다.
			// 여기서 ErrorOdd의 역원은 x * x^-1 = 1 이므로
			// ErrorOdd에 곱해서 1이 되는 수를 찾으면 그것이 ErrorOdd의 역원이된다. 
				for (j = 0 ; j <1023 ; j++)
					if (BinMult(ErrorOdd,j)==1)
					{
						printf("- %3d \n\r", j);  // j is inverse of ErrorOdd 	
						printf ("Error Correction value : %3d \n\r",BinMult(j,(EV4^EV3^EV2^EV1^EV0)));
				
						//위에 계산한 Error Correcting Value와 Receive Data를 XOR하면 정정된 값을 얻을 수 있다.
						// I = R(받은 데이터) + E(에러)
					}

			}
		}


	// 축약형인 경우 다음과 같이 계산하면 cycle이 줄어든다.

	// a^502이 초항이 된다.
	EP4=ErrPosition[4];// 계수와 a^4을 곱한다.
	EP3=ErrPosition[3];// 계수와 a^3을 곱한다.
	EP2=ErrPosition[2];// 계수와 a^2을 곱한다.
	EP1=ErrPosition[1];// 계수와 a^1을 곱한다.
	EP0=ErrPosition[0];// 계수와 a^0을 곱한다.

	EV4 = ErrValue[4];
	EV3 = ErrValue[3];
	EV2 = ErrValue[2];
	EV1 = ErrValue[1];
	EV0 = ErrValue[0];

	 for (i=0; i < 503 ; i++ )  // RS(520,512)은 RS1023의 축약형이다.
		 			// 초항이 (a^503)이 곱해진 형태면 520 cycle만에 끝나고 아니면 1023까지 모두 넣어준다.
					//
		{
		if (i != 0)
			{
				EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
				EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
				EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
				EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
				EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
				EV4 = 	BinMult	(EV4,16);
				EV3 = 	BinMult	(EV3,8);
				EV2 = 	BinMult	(EV2,4);
				EV1 = 	BinMult	(EV1,2);
				EV0 = 	BinMult	(EV0,1);

			}
		}

	 for (i=0; i < 521 ; i++ ) 
		{
			EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
			EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
			EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
			EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
			EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
			EV4 = 	BinMult	(EV4,16);
			EV3 = 	BinMult	(EV3,8);
			EV2 = 	BinMult	(EV2,4);
			EV1 = 	BinMult	(EV1,2);
			EV0 = 	BinMult	(EV0,1);

			ErrorOdd  = EP3 ^ EP1;
			ErrorEven = EP4 ^ EP2 ^ EP0 ;

		if ((ErrorEven^ErrorOdd) == 0) // Error있는 경우
			{
				printf("Error Location is %d and Error Value is %d \n\r", i, (EV4^EV3^EV2^EV1^EV0));
				printf("ErrorOdd Value is %d %d\n\r",ErrorOdd, ErrorEven); // Error Odd의 역원과 Error value를 곱한다.

			/*		printf(" EV0 = %d \n\r", EV0);
					printf(" EV1 = %d \n\r", EV1);
					printf(" EV2 = %d \n\r", EV2);
					printf(" EV3 = %d \n\r", EV3);
					printf(" EV4 = %d \n\r", EV4);
					printf(" EV5 = %d \n\r", EV5);
					printf(" EV6 = %d \n\r", EV6);
					printf(" EV7 = %d \n\r", EV7);
			*/
			// Error odd 의 역원을 찾아 Error Value에 곱한다.
			// 여기서 ErrorOdd의 역원은 x * x^-1 = 1 이므로
			// ErrorOdd에 곱해서 1이 되는 수를 찾으면 그것이 ErrorOdd의 역원이된다. 
				for (j = 0 ; j <1023 ; j++)
					if (BinMult(ErrorOdd,j)==1)
					{
						printf("- %3d %3d \n\r", j, BinMult(ErrorOdd, j));  // j is inverse of ErrorOdd 	
						printf ("Error Correction value : %3d \n\r",BinMult(j,(EV4^EV3^EV2^EV1^EV0)));
				

					//	printf(" %d \n\r ", Inverse_GF1024(ErrorOdd));
						//위에 계산한 Error Correcting Value와 Receive Data를 XOR하면 정정된 값을 얻을 수 있다.
						// I = R(받은 데이터) + E(에러)
					}
			}
		}
	 

}


int Uclid_check(void)
{
	int R[8]= {837,  1009,  1019,  280,  436,  787,    0,    0     };
	int Q[8]= {199,  305,  284,  944,  908,   36,    0,    0};
	int i;
//		printf ("data0 = %d\n\r" , BinMult(0,Q[6])^BinMult(Q[0],R[5]));
//	for (i=1; i<8 ; i++)
//		printf ("data%d = %d\n\r" , i , BinMult(R[i-1],Q[6])^BinMult(Q[i],R[5]));
	//
	for (i=0; i<8 ; i++)
		printf ("data%d = %d\n\r" , i , BinMult(R[i],Q[5])^BinMult(Q[i],R[5]));



}

int Inverse_GF1024 (int Number)
	{
		int a ;
		int i,j;
	
		for (i=0;i<1025;i++)
			{
			a =1;
			for (j = 0 ; j <1022 ; j++)
			a = BinMult(i, a); // a^1023 는 a^-1
			printf(" %d : outdata = %d; \n\r", i, a);
			}
/*

			for (j = 0 ; j <1023 ; j++)
				if (BinMult(Number,j)==1)
					{
					printf("<%3d %3d \n\r", j, BinMult(Number, j));  // j is inverse of ErrorOdd 	
					}
			return  a;
*/
	}
