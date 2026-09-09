// Reed Solomon Encoder 
// 1. Using Binary Multiply Encoder
//  LFSR 
// GF(256) 
// (n-k) = (255-251)  2t=4  t=2
//  Generator  g(x) = [1 1 1 1]
//  input shift data
//  data [512]

#include "stdio.h"
#include "ncurses.h"
//  primitive polynomial = [1 0 0 0 1 1 1 0 1]
//  따라서 x^8 = x^4 + x^3 + x^2 + 1

// 사용할 생성자
// generator = (x - a) ( x - a^2) ( x - a^3) ( x - a^4)
// 전개 하면
// x^4 - (a^4 + a^3 + a^2 + a)x^3 + (a^7 + a^6 + a^5 + a^5 + a^4 + a^3) x^2 + ( a^9 + a^8 + a^7 + a^6) x + a^10
//
//각 계수는
//
// g0 = a^10 = a^6 + a^5 + a^4 + a^2 = ( 0100_0000 ^ 0010_0000 ^ 0001_0000 ^ 0000_0100 ) = (0111_0100) = 116
//
// g1 = (a^9 + a^8 + a^7 + a^6) = (a^5 + a^4 + a^3 + a + a^4 + a^3 + a^2 + 1 + a^7 + a^6) = a^7 + a^6 + a^5 + a^2 + a + 1 = (1110_0111) = 231
//
// g2 = (a^7 + a^6 + a^4 + a^3) = (1101_1000) = 216
//
// g3 = (a^4 + a^3 + a^2 + a) = (0001_1110)
//
// g4 = 1
//
//  generator의 근은 2, 4, 8, 16  
//
void Encoder255_251(unsigned char *data);// (255,251) encoder
void Encoder31_19(unsigned char *data);// (31,19) encoder
void ErrorChk31_19(unsigned char *data);
unsigned char BinMult (unsigned char a, unsigned char b);
unsigned char BinMult_GF31 (unsigned char a, unsigned char b);
void ErrorDetect(unsigned char *data);
void ErrorDetect204(unsigned char *data); // syndrom 계산
void ErrorDetect31_19(unsigned char *data); // syndrom 계산
void ErrDet(unsigned char *data);
unsigned char KeyEquationSolver (void);
unsigned char KeyEquationSolverTest (void);
void Encoder204_188(unsigned char *data);
unsigned char Invers_GF256 (unsigned char Number);

unsigned char generator[5] = {116, 231, 216, 30, 1}; // x^4 + 30x^3 + 216x^2 + 231x + 116
unsigned char generator2[12] = {31, 24, 10, 31, 25, 19, 3, 18, 12, 15, 11, 30};
//unsigned char groot[4] = {2, 4, 8, 16};
unsigned char groot[4] = {1, 2, 4, 8};
//unsigned char groot2[12] = {2, 4, 8, 16, 5, 10, 20, 13, 26, 17, 7, 14};
unsigned char groot2[12] = {6, 12, 24, 21, 15, 30, 25, 23, 11, 22, 9, 18}; //a^19 ... a^30
//unsigned char groot2[12] = {1, 2, 4, 8, 16, 5, 10, 20, 13, 26, 17, 7};

unsigned char data [255]= {	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
	      			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  0,  0,  0,  0
				}; // input data 251 size 인코딩 데이터

unsigned char data204[204]= {	 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 
				11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
				21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 
				31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
				41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 
				51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 
				61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 
				71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 
				81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 
				91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 
				101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
				111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 
				121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 
				131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 
				141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 
				151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 
				161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 
				171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 
				181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 
				191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 
				201, 202, 203, 204
				};

unsigned char data204_Err[204]= {	  1,   2,   3,   4,   5,   0,   0,   0,   0,  0, 
					 11,  12,  13,  14,  15,  16,  17,  18,  19,  20, 
					 21,  22,  23,  24,  25,  26,  27,  28,  29,  30, 
					 31,  32,  33,  34,  35,  36,  37,  38,  39,  40, 
				  	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50, 
					 51,  52,  53,  54,  55,  56,  57,  58,  59,  60, 
					 61,  62,  63,  64,  65,  66,  67,  68,  69,  70, 
					 71,  72,  73,  74,  75,  76,  77,  78,  79,  80, 
					 81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 
					 91,  92,  93,  94,  95,  96,  97,  98,  99, 100, 
					101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
					111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 
					121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 
					131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 
					141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 
					151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 
					161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 
					171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 
					181, 182, 183, 184, 185, 186, 187, 188, 195, 231, 
					90, 194, 142, 112, 85, 171, 63, 242, 251, 154, 
					1, 82, 0, 222
				};

unsigned char data204_Err2[204]= {	  1,   2,   3,   4,   5,   0,   0,   0,   0,  0, 
					 11,  12,  13,  14,  15,  16,  17,  18,  19,  20, 
					 21,  22,  23,  24,  25,  26,  27,  28,  29,  30, 
					 31,  32,  33,  34,  35,  36,  37,  38,  39,  40, 
				  	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50, 
					 51,  52,  53,  54,  55,  56,  57,  58,  59,  60, 
					 61,  62,  63,  64,  65,  66,  67,  68,  69,  70, 
					 71,  72,  73,  74,  75,  76,  77,  78,  79,  80, 
					 81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 
					 91,  92,  93,  94,  95,  96,  97,  98,  99, 100, 
					101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
					111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 
					121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 
					131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 
					141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 
					151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 
					161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 
					171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 
					181, 182, 183, 184, 185, 186, 187, 188, 227, 244, 
					244, 237, 159,   9,  19,  10, 131, 151,  86, 126, 
					 20, 155, 230, 237
				};



unsigned char rcvdata [255]= {	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
	      			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,213,204,  0,  0
				}; // 에러가 포함된 데이터

unsigned char rcvdata2[255]= {	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
	      			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
				0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  0,  0,  0,  0
				};
unsigned char data31_19[31] = {20,  4,  5, 17, 22,  1,  2, 28,  3, 17,
       				6,  7, 10, 31, 11, 20,  4,  5,  1, 23, 
			       20,  2, 22,  4, 11,  6, 30, 20, 31, 10, 30 };
unsigned char data31_19_[31] ={ 5,  4, 20, 17, 13, 16,  8,  7, 24, 17,
       			       12, 28, 10, 31, 26,  5,  4, 20, 16, 29, 
			        5,  8, 13,  4, 26, 12, 15, 5, 31, 10, 15 };

unsigned char data31_19_err[31] ={ 5,  4, 20, 17, 13, 16,  8,  7, 24, 17,
       			       12, 28, 10, 31, 26,  5,  4, 20, 16, 29, 
			        5,  8, 13,  4, 26, 12, 15, 5, 31, 10, 0 };

unsigned char s[17]={0,};

void main(void)
{
//	initscr();
	Encoder204_188(data204);
#if 0
	ErrorChk31_19(data31_19_);
	ErrorDetect31_19(data31_19_err); // Error Data Input
	KeyEquationSolver ();
#endif

//int j;
//	unsigned char a;
//	for (j =0 ; j <255 ; j++ )
//	printf("%d \n\r",Invers_GF256 (j));
	
	ErrorDetect204(data204_Err);
	if (s[16]|s[15]|s[14]|s[13]|s[12]|s[11]|s[10]|s[9]|s[8]|s[7]|s[6]|s[5]|s[4]|s[3]|s[2]|s[1]|s[0])
		KeyEquationSolverTest ();
//	endwin();
	
}

void Encoder255_251(unsigned char *data) // (255,251) encoder
{

	// 덧셈 xor
	unsigned char parity[4] = {0, 0, 0, 0}; // Initialize LFSR
	unsigned char indata;
	int i;
	for (i=0; i < 251 ; i++)// information signal is 251 byte data 
	{
		indata = parity[3]^data[i];
		parity[3] = parity[2]^BinMult(indata, generator[3]);
		parity[2] = parity[1]^BinMult(indata, generator[2]);
		parity[1] = parity[0]^BinMult(indata, generator[1]);
		parity[0] = BinMult(indata, generator[0]);
	}
	printf ("Reed Solomon Encoding End\n\r");
	printf ("Reed Solomon Parity value:  ");
	for (i = 0 ; i < 4; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");

	data [251] = parity[3]; // 계산된 패리티를 정보 뒤에 붙인다
	data [252] = parity[2];
	data [253] = parity[1];
	data [254] = parity[0];

	for (i=0; i < 255 ; i ++)
	printf ("%d " ,data[i]);

	printf ("\n\r " ,data[i]);
	//출력은 data [0] ... data[250] Parity[3] Parity[2] parity[1] parity[0]

}

void Encoder204_188(unsigned char *data) // (255,251) encoder
{

	// 덧셈 xor
	unsigned char parity[16] = {0,}; // Initialize LFSR
	//generator는 (x-1)(x-a)(x-a^2)..을 전개한 식을 사용한다.
	unsigned char generators[16] = {59,36,50,98,229,41,65,163,8,30,209,68,189,104,13,59};
	
	//unsigned char generators[16] ={79,44,81,100,49,183,56,17,232,187,126,104,31,103,52,118};


	unsigned char indata;
	int i;
	for (i=0; i < 188 ; i++)// information signal is 251 byte data 
	{
		indata = parity[15]^data[i];
		parity[15] = parity[14]^BinMult(indata, generators[15]);
		parity[14] = parity[13]^BinMult(indata, generators[14]);
		parity[13] = parity[12]^BinMult(indata, generators[13]);
		parity[12] = parity[11]^BinMult(indata, generators[12]);
		parity[11] = parity[10]^BinMult(indata, generators[11]);
		parity[10] = parity[9]^BinMult(indata, generators[10]);
		parity[9] = parity[8]^BinMult(indata, generators[9]);
		parity[8] = parity[7]^BinMult(indata, generators[8]);
		parity[7] = parity[6]^BinMult(indata, generators[7]);
		parity[6] = parity[5]^BinMult(indata, generators[6]);
		parity[5] = parity[4]^BinMult(indata, generators[5]);
		parity[4] = parity[3]^BinMult(indata, generators[4]);
		parity[3] = parity[2]^BinMult(indata, generators[3]);
		parity[2] = parity[1]^BinMult(indata, generators[2]);
		parity[1] = parity[0]^BinMult(indata, generators[1]);
		parity[0] = BinMult(indata, generators[0]);
	}
	printf ("Reed Solomon Encoding End\n\r");
	printf ("Reed Solomon Parity value:  ");
	for (i = 0 ; i < 16; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");

	data [188] = parity[15]; // 계산된 패리티를 정보 뒤에 붙인다
	data [189] = parity[14]; // 계산된 패리티를 정보 뒤에 붙인다
	data [190] = parity[13]; // 계산된 패리티를 정보 뒤에 붙인다
	data [191] = parity[12]; // 계산된 패리티를 정보 뒤에 붙인다
	data [192] = parity[11]; // 계산된 패리티를 정보 뒤에 붙인다
	data [193] = parity[10]; // 계산된 패리티를 정보 뒤에 붙인다
	data [194] = parity[9]; // 계산된 패리티를 정보 뒤에 붙인다
	data [195] = parity[8]; // 계산된 패리티를 정보 뒤에 붙인다
	data [196] = parity[7]; // 계산된 패리티를 정보 뒤에 붙인다
	data [197] = parity[6]; // 계산된 패리티를 정보 뒤에 붙인다
	data [198] = parity[5]; // 계산된 패리티를 정보 뒤에 붙인다
	data [199] = parity[4]; // 계산된 패리티를 정보 뒤에 붙인다
	data [200] = parity[3]; // 계산된 패리티를 정보 뒤에 붙인다
	data [201] = parity[2];
	data [202] = parity[1];
	data [203] = parity[0];

	for (i=0; i < 204 ; i ++)
	printf ("%d " ,data[i]);

	printf ("\n\r " ,data[i]);

}


void ErrDet(unsigned char *data) // 그냥 LFSR에 넣어 나머지를 구하는 테스트
{

	// 덧셈 xor
	unsigned char parity[4] = {0, 0, 0, 0}; // Initialize LFSR
	unsigned char indata;
	int i;
	for (i=0; i < 255 ; i++)// information signal is 251 byte data 
	{
		indata = parity[3]^data[i];
		parity[3] = parity[2]^BinMult(indata, generator[3]);
		parity[2] = parity[1]^BinMult(indata, generator[2]);
		parity[1] = parity[0]^BinMult(indata, generator[1]);
		parity[0] = BinMult(indata, generator[0]);
	}
	printf(" Using same LFSR \n\r");// 출력되는 값은 에러다항식인가??? 
	for (i = 0 ; i < 4; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");
}


void ErrorDetect(unsigned char *data) // syndrom 계산
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
	
	//generator의 근은 2, 4, 8, 16  
	unsigned char d;
	unsigned char s[4]={0,0,0,0};
	int i,j;
	for (i=0; i <4 ; i++)
	{
		for (j=0; j<255; j++)
		{
			if (j==0)
			{
				d= data[j];
			}
			else
			{
				d = data[j]^BinMult(d,groot[i]);
			//	printf ("%d: %d ", j, d);
			}
		}
			printf ("\n\r");
		s[i] = d;
	}

	if (s[0]|s[1]|s[2]|s[3])
	{
		printf (" Receive data Error Detected !! \n\r");
		printf(" systoric \n\r");
		printf(" syndrom s1 = %d, s2= %d, s3= %d, s4= %d \n\r" , s[0], s[1], s[2], s[3]);
	}
	else
	{
		printf (" Receive data No Error !! \n\r");
	}

	
}






void ErrorDetect204(unsigned char *data) // syndrom 계산
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
	
	//generator의 근은 2, 4, 8, 16  

	unsigned g204root [16] = {1, 2, 4, 8, 
				16,32,64,128,
				 29,58,116,232,
				205,135,19,38}; // 근은 이 것을 사용하여야함

	/*unsigned g204root [16] = {2, 4, 8, 
				16,32,64,128,
				 29,58,116,232,
				205,135,19,38,76};*/
	unsigned char d;
	//unsigned char s[16]={0,};
	int i,j;
	for (i=0; i <16 ; i++)
	{
		for (j=0; j<204; j++)
		{
			if (j==0)
			{
				d= data[j];
			}
			else
			{
				d = data[j]^BinMult(d,g204root[i]);
			//	printf ("%d: %d ", j, d);
			}
		}
			printf ("\n\r");
		s[i] = d;
	}

	if (s[0]|s[1]|s[2]|s[3]|s[4]|s[5]|s[6]|s[7]|s[8]|s[9]|s[10]|s[11]|s[12]|s[13]|s[14]|s[15])
	{
		printf (" Receive data Error Detected !! \n\r");
		printf(" systoric \n\r");
		printf(" syndrom s1 = %d, s2= %d, s3= %d, s4= %d \n\r" , s[0], s[1], s[2], s[3]);
		printf(" syndrom s5 = %d, s6= %d, s7= %d, s8= %d \n\r" , s[4], s[5], s[6], s[7]);
		printf(" syndrom s9 = %d, s10= %d, s11= %d, s12= %d \n\r" , s[8], s[9], s[10], s[11]);
		printf(" syndrom s13 = %d, s14= %d, s15= %d, s16= %d \n\r" , s[12], s[13], s[14], s[15]);
	}
	else
	{
		printf (" Receive data No Error !! \n\r");
	}

	
}


unsigned char BinMult (unsigned char a, unsigned char b) 
{
	//곱셈
	// A.B = (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)(b0 + b1x + b2x^2 + b3x^3 ... b7x^7)
	// b0 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^0 +
	// b1 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^1 +
	// b2 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^2 +
	// b3 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^3 +
	// b4 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^4 +
	// b5 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^5 +
	// b6 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^6 +
	// b7 (a0 + a1x + a2x^2 + a3x^3 ... a7x^7)x^7
	

	// 계수별로 분리하면
	// x^0  = a0b0
	// x^1  = a1b0 + a0b1
	// x^2  = a2b0 + a1b1 + a0b2
	// x^3  = a3b0 + a2b1 + a1b2 + a0b3
	// x^4  = a4b0 + a3b1 + a2b2 + a1b3 + a0b4
	// x^5  = a5b0 + a4b1 + a3b2 + a2b3 + a1b4 + a0b5
	// x^6  = a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a1b5 + a0b6
	// x^7  = a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a1b6 + a0b7
	// x^8  = a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7
	// x^9  = a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7
	// x^10 = a7b3 + a6b4 + a5b5 + a4b6 + a3b7
	// x^11 = a7b4 + a6b5 + a5b6 + a4b7
	// x^12 = a7b5 + a6b6 + a5b7 
	// x^13 = a7b6 + a6b7
	// x^14 = a7b7
	//
	//  primitive polynomial = [1 0 0 0 1 1 1 0 1]
	//  따라서 x^8 = x^4 + x^3 + x^2 + 1

	// x^8  =                                                      							x^4 + x^3 + x^2 + 1
	// x^9  =                                                      							x^5 + x^4 + x^3 + x
	// x^10 = 				                                                    			x^6 + x^5 + x^4 + x^2
	// x^11 =                                                      							x^7 + x^6 + x^5 + x^3
	// x^12 = x^8  + x^7 + x^6 + x^4 = x^4 + x^3 + x^2 + 1 + x^7 + x^6 + x^4 =  			x^7 + x^6 + x^3 + x^2 + 1
	// x^13 = x^9  + x^8 + x^7 + x^5 = x^5 + x^4 + x^3 + x + x^4 + x^3 + x^2 + 1 + x^7 + x^5 = x^7 + x^2 + x + 1 
	// x^14 = x^10 + x^9 + x^8 + x^6 = 
			  // x^6 + x^5 + x^4 + x^2 + x^5 + x^4 + x^3 + x + x^4 + x^3 + x^2 + 1 + x^6  = x^4 + x + 1 

	// 따라서 
	// x^0 = (a0b0) + (a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7) + (a7b5 + a6b6 + a5b7) +  (a7b6 + a6b7) + (a7b7)
	// x^1 = (a1b0 + a0b1) + (a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7) + (a7b6 + a6b7) + (a7b7)
	// x^2 = (a2b0 + a1b1 + a0b2) + (a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7) + (a7b3 + a6b4 + a5b5 + a4b6 + a3b7) + (a7b5 + a6b6 + a5b7) + (a7b6 + a6b7)
	// x^3 = (a3b0 + a2b1 + a1b2 + a0b3) + (a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7) + (a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7) + (a7b4 + a6b5 + a5b6 + a4b7) + (a7b5 + a6b6 + a5b7)
	// x^4 = (a4b0 + a3b1 + a2b2 + a1b3 + a0b4) + (a7b1 + a6b2 + a5b3 + a4b4 + a3b5 + a2b6 + a1b7) + (a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7) + (a7b3 + a6b4 + a5b5 + a4b6 + a3b7) + (a7b7)
	// x^5 = (a5b0 + a4b1 + a3b2 + a2b3 + a1b4 + a0b5) + (a7b2 + a6b3 + a5b4 + a4b5 + a3b6 + a2b7) + (a7b3 + a6b4 + a5b5 + a4b6 + a3b7) + (a7b4 + a6b5 + a5b6 + a4b7) 
	// x^6 = (a6b0 + a5b1 + a4b2 + a3b3 + a2b4 + a1b5 + a0b6) + (a7b3 + a6b4 + a5b5 + a4b6 + a3b7) + (a7b4 + a6b5 + a5b6 + a4b7) + (a7b5 + a6b6 + a5b7)
	// x^7 = (a7b0 + a6b1 + a5b2 + a4b3 + a3b4 + a2b5 + a1b6 + a0b7) + (a7b4 + a6b5 + a5b6 + a4b7) + (a7b5 + a6b6 + a5b7) + (a7b6 + a6b7)
	//
	unsigned char data;
	unsigned char data0, data1, data2, data3, data4, data5, data6, data7;
	unsigned char a0, a1, a2, a3, a4, a5, a6, a7;
	unsigned char b0, b1, b2, b3, b4, b5, b6, b7;
//--------------- bit level operation
	a0 = a & 0x01;
	a1 = (a & 0x02)>>1;
	a2 = (a & 0x04)>>2;
	a3 = (a & 0x08)>>3;
	a4 = (a & 0x10)>>4;
	a5 = (a & 0x20)>>5;
	a6 = (a & 0x40)>>6;
	a7 = (a & 0x80)>>7;

	b0 = (b & 0x01);
	b1 = (b & 0x02)>>1;
	b2 = (b & 0x04)>>2;
	b3 = (b & 0x08)>>3;
	b4 = (b & 0x10)>>4;
	b5 = (b & 0x20)>>5;
	b6 = (b & 0x40)>>6;
	b7 = (b & 0x80)>>7;

	data0 = (a0&b0 ^
		a7&b1 ^ 
		a6&b2 ^ 
		a5&b3 ^ 
		a4&b4 ^ 
		a3&b5 ^ 
		a7&b5 ^ 
		a2&b6 ^ 
		a6&b6 ^ 
		a7&b6 ^ 
		a1&b7 ^ 
		a5&b7 ^ 
		a6&b7 ^ 
		a7&b7)&0x01;

	data1 = (a1&b0 ^ 
		a0&b1 ^ 
		a7&b2 ^ 
		a6&b3 ^ 
		a5&b4 ^ 
		a4&b5 ^ 
		a3&b6 ^ 
		a7&b6 ^ 
		a2&b7 ^ 
		a6&b7 ^ 
		a7&b7)&0x01;

	data2 = (a2&b0 ^
		a1&b1 ^ 
		a7&b1 ^ 
		a0&b2 ^ 
		a6&b2 ^ 
		a5&b3 ^ 
		a7&b3 ^ 
		a4&b4 ^ 
		a6&b4 ^ 
		a3&b5 ^ 
		a5&b5 ^ 
		a7&b5 ^ 
		a2&b6 ^ 
		a4&b6 ^ 
		a6&b6 ^ 
		a7&b6 ^ 
		a1&b7 ^ 
		a3&b7 ^ 
		a5&b7 ^ 
		a6&b7)&0x01;

	data3 = (a3&b0 ^ 
		a2&b1 ^ 
		a7&b1 ^ 
		a1&b2 ^ 
		a6&b2 ^ 
		a7&b2 ^ 
		a0&b3 ^ 
		a5&b3 ^ 
		a6&b3 ^ 
		a4&b4 ^ 
		a5&b4 ^ 
		a7&b4 ^ 
		a3&b5 ^ 
		a4&b5 ^ 
		a6&b5 ^ 
		a7&b5 ^ 
		a2&b6 ^ 
		a3&b6 ^ 
		a5&b6 ^ 
		a6&b6 ^ 
		a1&b7 ^
		a2&b7 ^ 
		a4&b7 ^ 
		a5&b7)&0x01;

	data4 = (a4&b0 ^ 
		a3&b1 ^ 
		a7&b1 ^ 
		a2&b2 ^ 
		a6&b2 ^ 
		a7&b2 ^ 
		a1&b3 ^ 
		a5&b3 ^ 
		a6&b3 ^ 
		a0&b4 ^ 
		a4&b4 ^ 
		a5&b4 ^ 
		a3&b5 ^ 
		a4&b5 ^ 
		a2&b6 ^ 
		a3&b6 ^ 
		a1&b7 ^ 
		a2&b7 ^ 
		a7&b3 ^ 
		a6&b4 ^ 
		a5&b5 ^
	       	a4&b6 ^ 
		a3&b7 ^
		a7&b7)&0x01;

	data5 = (a5&b0 ^
		a4&b1 ^ 
		a3&b2 ^ 
		a7&b2 ^ 
		a2&b3 ^ 
		a6&b3 ^ 
		a7&b3 ^ 
		a1&b4 ^ 
		a5&b4 ^ 
		a6&b4 ^ 
		a7&b4 ^ 
		a0&b5 ^ 
		a4&b5 ^ 
		a5&b5 ^ 
		a6&b5 ^ 
		a3&b6 ^ 
		a4&b6 ^ 
		a5&b6 ^ 
		a2&b7 ^ 
		a3&b7 ^
		a4&b7)&0x01 ;
	
	data6 = (a6&b0 ^ 
		a5&b1 ^ 
		a4&b2 ^ 
		a3&b3 ^ 
		a7&b3 ^ 
		a2&b4 ^ 
		a6&b4 ^ 
		a7&b4 ^ 
		a1&b5 ^ 
		a5&b5 ^ 
		a6&b5 ^ 
		a7&b5 ^ 
		a0&b6 ^ 
		a4&b6 ^ 
		a5&b6 ^ 
		a6&b6 ^ 
		a3&b7 ^
		a4&b7 ^ 
		a5&b7)&0x01;

	data7 = (a7&b0 ^ 
		a6&b1 ^ 
		a5&b2 ^ 
		a4&b3 ^ 
		a3&b4 ^ 
		a7&b4 ^ 
		a2&b5 ^ 
		a6&b5 ^ 
		a7&b5 ^ 
		a1&b6 ^ 
		a5&b6 ^ 
		a6&b6 ^ 
		a7&b6 ^ 
		a0&b7 ^ 
		a4&b7 ^ 
		a5&b7 ^ 
		a6&b7)&0x01;

	data = (data7<<7)|(data6<<6)|(data5<<5)|(data4<<4)|(data3<<3)|(data2<<2)|(data1<<1)|(data0);

	return data;
}

// Test for OC RS Decoder
// GF(2^5)
//
// p(x) = X^5 + X^2 + 1 
// 
// g(x) = a^15 + a^21*X + a^6*X^2 + a^15*X^3 + a^25*X^4 + a^17*X^5 + a^18*X^6 + a^30*X^7 + a^20*X^8 + a^23*X^9 + a^27*X^10 + a^24*X^11 + X^12
//
//  GF(2^5)
//  0
//  1
//  a =2
//  a^2 =4
//  a^3 = 8
//  a^4 = 16
//  a^5 = a^2 + 1
//  a^6 = a^3 + a
//  a^7 = a^4 + a^2
//  a^8 = a^5 + a^3 = a^3 + a^2 + 1
//  a^9 = a^6 + a^4 = a^4 + a^3 + a
//  a^10 = a^7+ a^5 = a^4 + 1 
//  a^11 = a^8+ a^6 = a^4 + a^2 + a + 1
//  a^12 = a^9+ a^7 = a^3 + a^2 + a 
//  a^13 = a^10 + a^8 = a^4 + a^3 + a^2
//  a^14 = a^11 + a^9 = a^3 + a^2 + 1  
//  a^15 = a^12 + a^10 =  a^4 + a^3 + a^2 + a + 1
//...................

// g0 = a^15 = a^4 + a^3 + a^2 + a + 1  = 11111
// g1 = a^21 = (a^15)(a^6) = (a^4 + a^3 + a^2 + a + 1)(a^3 + a) = a^4 + a^3 = 11000
// g2 = a^6 = a^3 + a = 01010
// g3 = a^15 = a^4 + a^3 + a^2 + a + 1 = 11111
// g4 = a^25 = a^8 + a^7 = a^4 + a^3 + 1 = 11001
// g5 = a^17 = a^4 + a + 1 = 10011
// g6 = a^18 = a^5 + a^2 + a = a + 1  = 00011
// g7 = a^30 = (a^4 + a^3 + 1)(a^5)= a^9 + a^8 + a^5 = a^4 + a  =10010
// g8 = a^20 = a^3 + a^2 =01100
// g9 = a^23 = a^3 + a^2 + a + 1 =01111
// g10 = a^27= a^3 + a + 1 = 01011
// g11 = a^24= a^4 + a^3 + a^2 + a = 11110
// g12 = 1
//
// generator2[12] = {31, 24, 10, 31, 25, 19, 3, 18, 12, 15, 11, 30};
//
//
void Encoder31_19(unsigned char *data) // (31,19) encoder
{

	// 덧셈 xor
	unsigned char parity[12] = {0, 0, 0, 0, 0, 0,
				    0, 0, 0, 0, 0, 0}; // Initialize LFSR
	unsigned char indata;
	int i;
	for (i=0; i < 19 ; i++)// information signal is 19 Symbol 
	{
		indata = parity[11]^data[i];
		parity[11] = parity[10]^BinMult_GF31(indata, generator2[11]);
		parity[10] = parity[9]^BinMult_GF31(indata, generator2[10]);
		parity[9] = parity[8]^BinMult_GF31(indata, generator2[9]);
		parity[8] = parity[7]^BinMult_GF31(indata, generator2[8]);
		parity[7] = parity[6]^BinMult_GF31(indata, generator2[7]);
		parity[6] = parity[5]^BinMult_GF31(indata, generator2[6]);
		parity[5] = parity[4]^BinMult_GF31(indata, generator2[5]);
		parity[4] = parity[3]^BinMult_GF31(indata, generator2[4]);
		parity[3] = parity[2]^BinMult_GF31(indata, generator2[3]);
		parity[2] = parity[1]^BinMult_GF31(indata, generator2[2]);
		parity[1] = parity[0]^BinMult_GF31(indata, generator2[1]);
		parity[0] = BinMult_GF31(indata, generator2[0]);
	}
	printf ("Reed Solomon Encoding End\n\r");
	printf ("Reed Solomon Parity value:  ");
	for (i = 0 ; i < 12; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");

	data [19] = parity[11]&0x1f; // 계산된 패리티를 정보 뒤에 붙인다
	data [20] = parity[10]&0x1f;
	data [21] = parity[9]&0x1f;
	data [22] = parity[8]&0x1f;
	
	data [23] = parity[7]&0x1f;
	data [24] = parity[6]&0x1f;
	data [25] = parity[5]&0x1f;
	data [26] = parity[4]&0x1f;

	data [27] = parity[3]&0x1f;
	data [28] = parity[2]&0x1f;
	data [29] = parity[1]&0x1f;
	data [30] = parity[0]&0x1f;

	for (i=0; i < 31 ; i ++)
	printf ("%d " ,data[i]);

	printf ("\n\r " ,data[i]);

}

void ErrorChk31_19(unsigned char *data) // (31,19) encoder
{

	// 덧셈 xor
	unsigned char parity[12] = {0, 0, 0, 0, 0, 0,
				    0, 0, 0, 0, 0, 0}; // Initialize LFSR
	unsigned char indata;
	int i;
	for (i=0; i < 31 ; i++)// information signal is 19 Symbol 
	{
		indata = parity[11]^data[i];
		parity[11] = parity[10]^BinMult_GF31(indata, generator2[11]);
		parity[10] = parity[9]^BinMult_GF31(indata, generator2[10]);
		parity[9] = parity[8]^BinMult_GF31(indata, generator2[9]);
		parity[8] = parity[7]^BinMult_GF31(indata, generator2[8]);
		parity[7] = parity[6]^BinMult_GF31(indata, generator2[7]);
		parity[6] = parity[5]^BinMult_GF31(indata, generator2[6]);
		parity[5] = parity[4]^BinMult_GF31(indata, generator2[5]);
		parity[4] = parity[3]^BinMult_GF31(indata, generator2[4]);
		parity[3] = parity[2]^BinMult_GF31(indata, generator2[3]);
		parity[2] = parity[1]^BinMult_GF31(indata, generator2[2]);
		parity[1] = parity[0]^BinMult_GF31(indata, generator2[1]);
		parity[0] = BinMult_GF31(indata, generator2[0]);
	}
	printf ("Reed Solomon Parity value:  ");
	for (i = 0 ; i < 12; i++)
		printf (" Parity [%d] = %d ", i, parity[i]);
		printf ("\n\r");

	if (parity[0]^parity[1]^parity[2]^parity[3]^
		parity[4]^parity[5]^parity[6]^parity[7]^
		parity[8]^parity[9]^parity[10]^parity[11])
		printf (" Error Detected!!\n\r");
	else 
		printf (" No Error \n\r");
		

}

void ErrorDetect31_19(unsigned char *data) // syndrom 계산
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
	
	unsigned char d,k;

	int i,j;
	for (i=0; i <12 ; i++)
	{
		for (j=0; j<31; j++)
		{
			if (j==0)
			{
				d= data[j];
			}
			else
			{
				k = (BinMult_GF31(d,groot2[i]))&0x1f;
				d = (data[j]^k)&0x1f;
			}
			//	printf ("%d: %d(%d) ", j, d, k );
		}

		s[i] = d;
		printf (" %d \n\r", s[i]);

	}

	/*	for (j=1; j<31; j++)
		{
			if (j == 1)
				d = (data[j]^(BinMult_GF31(data[j-1],groot2[0])))&0x1f;
			else
				d = (data[j]^(BinMult_GF31(d,groot2[0])))&0x1f;
		}
		printf (" ^^ %d ^^	\n\r", d);

	*/


	if (s[0]|s[1]|s[2]|s[3]|s[4]|s[5]|s[6]|s[7]|s[8]|s[9]|s[10]|s[11])
	{
		printf (" Receive data Error Detected !! \n\r");
		printf(" systoric \n\r");
		printf(" syndrom s1 = %d, s2= %d, s3= %d, s4= %d \n\r" , s[0], s[1], s[2], s[3]);
		printf(" syndrom s5 = %d, s6= %d, s7= %d, s8= %d \n\r" , s[4], s[5], s[6], s[7]);
		printf(" syndrom s9 = %d, s10= %d, s11= %d, s12= %d \n\r" , s[8], s[9], s[10], s[11]);
	}
	else
	{
		printf (" Receive data No Error !! \n\r");
	}

	
}







unsigned char BinMult_GF31 (unsigned char a, unsigned char b) 
{
	//곱셈
	// A.B = (a0 + a1x + a2x^2 + a3x^3 + a4x^4)(b0 + b1x + b2x^2 + b3x^3 + b4x^4)
	// b0 (a0 + a1x + a2x^2 + a3x^3 + a4x^4)x^0 +
	// b1 (a0 + a1x + a2x^2 + a3x^3 + a4x^4)x^1 +
	// b2 (a0 + a1x + a2x^2 + a3x^3 + a4x^4)x^2 +
	// b3 (a0 + a1x + a2x^2 + a3x^3 + a4x^4)x^3 +
	// b4 (a0 + a1x + a2x^2 + a3x^3 + a4x^4)x^4
	
	// 계수별로 정리하면
	// 
	// x^0 = a0b0
	// x^1 = a0b1 + a1b0
	// x^2 = a2b0 + a1b1 + a0b2
	// x^3 = a3b0 + a2b1 + a1b2 + a0b3
	// x^4 = a4b0 + a3b1 + a2b2 + a1b3 + a0b4
	// x^5 = a4b1 + a3b2 + a2b3 + a1b4
	// x^6 = a4b2 + a3b3 + a2b4 
	// x^7 = a4b3 + a3b4
	// x^8 = a4b4 
	//
	//
	//  x^5 = x^2 + 1
	//  x^6 = x^3 + x
	//  x^7 = x^4 + x^2
	//  x^8 = x^3 + x^2 + 1
	//이므로
	// 따라서 
	//  x^0 = a0b0 + a4b1 + a3b2 + a2b3 + a1b4 + a4b4
	//  x^1 = a0b1 + a1b0 + a4b2 + a3b3 + a2b4
	//  x^2 = a2b0 + a1b1 + a0b2 + a4b1 + a3b2 + a2b3 + a1b4 + a4b3 + a3b4 + a4b4 
	//  x^3 = a3b0 + a2b1 + a1b2 + a0b3 + a4b2 + a3b3 + a2b4 + a4b4
	//  x^4 = a4b0 + a3b1 + a2b2 + a1b3 + a0b4 + a4b3 + a3b4
	//
	//
	unsigned char data;
	unsigned char data0, data1, data2, data3, data4;
	unsigned char a0, a1, a2, a3, a4;
	unsigned char b0, b1, b2, b3, b4;
//--------------- bit level operation
	a0 = a & 0x01;
	a1 = (a & 0x02)>>1;
	a2 = (a & 0x04)>>2;
	a3 = (a & 0x08)>>3;
	a4 = (a & 0x10)>>4;

	b0 = (b & 0x01);
	b1 = (b & 0x02)>>1;
	b2 = (b & 0x04)>>2;
	b3 = (b & 0x08)>>3;
	b4 = (b & 0x10)>>4;


	data0 = (a0&b0 ^ a4&b1 ^ a3&b2 ^ a2&b3 ^ a1&b4 ^ a4&b4);
	data1 = (a0&b1 ^ a1&b0 ^ a4&b2 ^ a3&b3 ^ a2&b4);
	data2 = (a2&b0 ^ a1&b1 ^ a0&b2 ^ a4&b1 ^ a3&b2 ^ a2&b3 ^ a1&b4 ^ a4&b3 ^ a3&b4 ^ a4&b4) ;
	data3 = (a3&b0 ^ a2&b1 ^ a1&b2 ^ a0&b3 ^ a4&b2 ^ a3&b3 ^ a2&b4 ^ a4&b4);
	data4 = (a4&b0 ^ a3&b1 ^ a2&b2 ^ a1&b3 ^ a0&b4 ^ a4&b3 ^ a3&b4);


	data = ((data4<<4)|(data3<<3)|(data2<<2)|(data1<<1)|(data0))&0x1f;

	return data;
}




unsigned char KeyEquationSolver (void)//unsigned char *syndrom) 
{
	// 에러가 발생한 경우 신드롬이 0이 아니다.
	// 신드롬을 토대로  key equation을 풀어야 한다.
	//  Key Equation은 
	//  S(x)σ(x) = w(x) mod x^2t로 
	//  신드롬 다항식 S(x)와 x^2t로 오류 위치 다항식σ(x)와 
	//  오류값 다항식 w(x)를 구해야 한다.
	//   S(x) 와 x^2t의 최대 공약수를 구한다.
	//   R0(x) = x^2t , Q0(x) = S(x)
	//   λ0(x) = 0, μ(x) = 1
	//
	//
	// Ri = [ σi-1* bi-1 * x^2t + σ1*S(x)
	// R1 = σ0* S2t-1 * x^2t + σ1*S(x)
	


	// l은 R(x)의 차수에서 Q(x)의 차수를 뺀 값
	//
	// l1 = R0 - Q0
	
       	// 초기값
	
	// R0 (x) = x^2t
	// Q0 (x) = S(x)
	// λ0(x) = 0
	// μ0(x) = 1
/*
	l1 = R1 - Q1	; // X^2t와 s의 차수 

	for (i=1;  ; i++)
	{
		li = R1order - Q1order;
		if (li>=0)
		{
	     	R = bi * R - x^li-1 * ai * Q  ;
		Q = Q;
		λ = bi * λ- x^li-1 * ai * μ ;
		μ = μ;
		}
		else
		{
		R[i] = a(i-1) * Q(i-1) -  x^(li-1) * b(i-1) * R(i-1);
		Q = R(i-1);
		λ =  a(i-1) * μ(i-1) - x^(li-1) * b(i-1) * λ(i-1);
		μ = λ(i-1);
		}

		if ( Riorder < λiorder)
		break;

	
	}

	R(x) = 에러 위치 다항식
	λ(x) = 에러값 다항식

*/

	unsigned char R [13] = {1,0,}; // r0 = x^2t
	unsigned char Q [12] = {0, } ; //초기값은 신드롬 다항식
	unsigned int l ;

	unsigned char Rorder [13];
       	unsigned char Qorder [13];	
       	unsigned char Lorder [13];	

	unsigned char OrderR, OrderQ, OrderL;

	int i, j,k;
	unsigned char lambda[13] = {0,};
	unsigned char mue[13]= {1,0,};
	unsigned char temp[13]= {0,};
	unsigned char temp1[13]= {0,};
	unsigned char ErrPosition[13] = {0,};
	unsigned char ErrValue[13]= {0,};

	lambda[0] = 0;
	mue[0] = 1; 

	for (i=0; i <12 ; i++ )
	{
	Q[i] = s[i]; // 초기 값은 신드롬 다항식임
	//	printf ("Q[%d] is %d \n\r", i, Q[i]);
	}

	for (k=1;  ; k++)
	{
		// 차수 비교
		// R order - Q order
		for (j=0 ; j< 13 ; j++)
		{
			if (R[j])
				Rorder[j] = 1;
			else	
				Rorder[j] = 0;
			if (Q[j])
				Qorder[j] = 1; 
			else
				Qorder[j] = 0; 
		}
		for (j=0 ; j< 13 ; j++)
		printf ("Rorder[%d] is %d \n\r", j, Rorder[j]);
		for (j=0 ; j< 13 ; j++)
		printf ("Qorder[%d] is %d \n\r", j, Qorder[j]);


		// first 1  position calcuation // 최상위 1이 나오는 bit 위치
		i= 0;
		for (;;)
		{
			printf ("a\n\r");
			if (Rorder[i])
			{
				switch (i)
				{	case 0 :
						OrderR = 12;
						break;
					case 1 :
						OrderR = 11;
						break;
					case 2 :
						OrderR = 10;
						break;
					case 3 :
						OrderR = 9;
						break;
					case 4 :
						OrderR = 8;
						break;
					case 5 :
						OrderR = 7;
						break;
					case 6 :
						OrderR = 6;
						break;
					case 7 :
						OrderR = 5;
						break;
					case 8 :
						OrderR = 4;
						break;
					case 9 :
						OrderR = 3;
						break;
					case 10:
						OrderR = 2;
						break;
					case 11:
						OrderR = 1;
						break;
					case 12:
						OrderR = 0;
						break;
				}
				printf ("OrderR is %d \n\r", OrderR);
				break;
			}
			i++;
			printf ("b\n\r");
		}
		i= 0;
		for (;;)
		{
			printf ("a-\n\r");
			if (Qorder[i])
			{	
			OrderQ = i;
			printf ("OrderQ is %d \n\r", OrderQ);
			break;
			}
			i--;
			printf ("b-\n\r");
		}	

		if ((OrderR-OrderQ)>=0) // 서로의 차수를 비교
		{

			for (j=0; j<13 ; j++)
			{
				R[j] =	BinMult_GF31 (Q[OrderQ], R[j])^	BinMult_GF31 (R[OrderR], Q[j]) ;
				lambda[j] = BinMult_GF31 (Q[OrderQ], lambda[j])^BinMult_GF31 (R[OrderR], mue[j]) ;
			}

		}
		else
		{
			for (j= 0 ; j < 13 ; j++)
			{	
				temp[j] = BinMult_GF31(R[OrderR],Q[j]) ^ BinMult_GF31(Q[OrderQ],R[j]);	
				temp1[j] = BinMult_GF31(R[OrderR],mue[j]) ^ BinMult_GF31(Q[OrderQ],lambda[j]);	
			}

			for (j= 0 ; j< 13 ; j++)
			{
			Q[j] = R[j]; 
			mue[j]= lambda[j];
			}

			for (j= 0 ; j< 13 ; j++)
			{
			lambda[j] = temp1[j]; 
			R[j]= temp[j];
			}

		}

		for (j=0 ; j< 13 ; j++)
		{
			if (R[j])
				Rorder[j] = 1;
			else	
				Rorder[j] = 0;
			if (lambda[j])
				Lorder[j] = 1; 
			else
				Lorder[j] = 0; 
		}


		i= 0;
		for (;;)
		{
			if (Rorder[i])
				{
				switch (i)
				{	case 0 :
						OrderR = 12;
						break;
					case 1 :
						OrderR = 11;
						break;
					case 2 :
						OrderR = 10;
						break;
					case 3 :
						OrderR = 9;
						break;
					case 4 :
						OrderR = 8;
						break;
					case 5 :
						OrderR = 7;
						break;
					case 6 :
						OrderR = 6;
						break;
					case 7 :
						OrderR = 5;
						break;
					case 8 :
						OrderR = 4;
						break;
					case 9 :
						OrderR = 3;
						break;
					case 10:
						OrderR = 2;
						break;
					case 11:
						OrderR = 1;
						break;
					case 12:
						OrderR = 0;
						break;
				}
				printf ("OrderR is %d \n\r", OrderR);
				break;
			}
			i++;
		}
		i= 0;
		for (;;)
		{
				if (Lorder[i])
				{
				switch (i)
				{	case 0 :
						OrderL = 12;
						break;
					case 1 :
						OrderL = 11;
						break;
					case 2 :
						OrderL = 10;
						break;
					case 3 :
						OrderL = 9;
						break;
					case 4 :
						OrderL = 8;
						break;
					case 5 :
						OrderL = 7;
						break;
					case 6 :
						OrderL = 6;
						break;
					case 7 :
						OrderL = 5;
						break;
					case 8 :
						OrderL = 4;
						break;
					case 9 :
						OrderL = 3;
						break;
					case 10:
						OrderL = 2;
						break;
					case 11:
						OrderL = 1;
						break;
					case 12:
						OrderL = 0;
						break;
				}
				printf ("OrderL is %d \n\r", OrderL);
				break;
			}
			i++;
		}	
	
		if (OrderR < OrderL)
		{
			for (j=0; j< 13 ; j++)
			{
				ErrPosition[j]= lambda[j];
			       	ErrValue[j] = R[j];
				printf(" ErrPosition[%2d] = %3d ", j, ErrPosition[j]);
				printf(" ErrValue[%2d] 	 = %3d \n\r", j, ErrValue[j]);
			}
			
			break;

		}
	}	

}

unsigned char KeyEquationSolverTest (void)
{
	unsigned char R [17] = {0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,1}; // r0 = x^2t
	unsigned char Q [17] = {0, } ; //초기값은 신드롬 다항식
	unsigned int l ;

	unsigned char Rorder [16];
       	unsigned char Qorder [16];	
       	unsigned char Lorder [16];	

	char OrderR, OrderQ, OrderL;

	int i, j,k;
	unsigned char lambda[17] = {0,};
	unsigned char mue[17]= {1,0,};
	unsigned char temp[17]= {0,};
	unsigned char tempR[17]= {0,};
	unsigned char temp1[17]= {0,};
	unsigned char ErrPosition[16] = {0,};
	unsigned char ErrValue[16]= {0,};
	unsigned char tmp;

	unsigned char EP8, EP7, EP6, EP5, EP4, EP3, EP2, EP1, EP0;
	unsigned char EV7, EV6, EV5, EV4, EV3, EV2, EV1, EV0;
	unsigned char ErrorEven, ErrorOdd;
	lambda[0] = 0;
	mue[0] = 1; 

	/*Q[16] = 0;
	Q[15] = 119; // 초기 값은 신드롬 다항식임
	Q[14] = 2;
	Q[13] = 66;
	Q[12] = 231;
	Q[11] = 253;
	Q[10] = 34;
	Q[9] = 249;
	Q[8] = 158;
	Q[7] = 191;
	Q[6] = 19;
	Q[5] = 82;
	Q[4] = 145;
	Q[3] = 129;
	Q[2] = 180;
	Q[1] = 176;
	Q[0] = 8;*/

	Q[16] = s[16];
	Q[15] = s[15]; // 초기 값은 신드롬 다항식임
	Q[14] = s[14];
	Q[13] = s[13];
	Q[12] = s[12];
	Q[11] = s[11];
	Q[10] = s[10];
	Q[9] = s[9];
	Q[8] = s[8];
	Q[7] = s[7];
	Q[6] = s[6];
	Q[5] = s[5];
	Q[4] = s[4];
	Q[3] = s[3];
	Q[2] = s[2];
	Q[1] = s[1];
	Q[0] = s[0];




	R[16] = 1; // R0 = x^16

	for (k=1;  ; k++)
	{
		// 차수 비교
		// R order - Q order
		for (j=0 ; j< 17 ; j++)
		{
			if (R[j])	Rorder[j] = 1; // 계수가 0이 아니면 1을 넣는다.
			else		Rorder[j] = 0;
		}
		for (j=0 ; j< 17 ; j++)
		{
			if (Q[j])	Qorder[j] = 1; 
			else		Qorder[j] = 0; 
		}


		// first 1  position calcuation // 최상위 1이 나오는 bit 위치
		for (i=16;i>=0; i--)
		{
			if (Rorder[i])
			{
				OrderR = i;  // 최상위 1이 나오는 위치는 차수이다.
				break;
			}
		}

		for (i=16;i>=0;i--)
		{
			if (Qorder[i])
			{	
				OrderQ = i; // 최상위 1이 나오는 위치는 차수이다.
				break;
			}
		}	

		if ((OrderR-OrderQ)>=0) // 서로의 차수를 비교
		{ 
			for (j=16; j>=0 ; j--)  // 계수크기만큼 반복
			{
				if ((j-(OrderR- OrderQ))>=0)
				{
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

			for (j=16; j>=0 ; j--)
			{
				R[j] = tempR[j];
			}

		}
		else// Q가 더 높은 차수를 가질때
		{

			
			for (j= 16 ; j>=0 ; j--)
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

			for (j= 0 ; j<17 ; j++)
			{
			Q[j] = R[j]; 
			mue[j]= lambda[j];
			}

			for (j= 0 ; j< 17 ; j++)
			{
			lambda[j] = temp1[j]; 
			R[j]= temp[j];
			}
	
		}

		for (j=0 ; j< 17 ; j++)
		{
			if (R[j])
				Rorder[j] = 1;
			else	
				Rorder[j] = 0;
		}
		for (j=0 ; j< 17 ; j++)
		{
			if (lambda[j])
				Lorder[j] = 1; 
			else
				Lorder[j] = 0; 
		}

		// first 1  position calcuation // 최상위 1이 나오는 bit 위치
		for (i=16; i>=0 ; i--)
		{
			if (Rorder[i])
			{
				OrderR = i;
		//		printf ("OrderR is %d \n\r", OrderR);
				break;
			}
			if (i==0)
			{
				OrderR=0;
		//		printf ("OrderR is %d \n\r", OrderR);
			}
		}
		for (i=16; i >=0 ; )
		{
			if (Lorder[i])
			{	
			OrderL = i;
		//	printf ("OrderL is %d \n\r", OrderL);
			break;
			}
			if (i==0)
			{
				OrderL=0;
		//	printf ("OrderL is %d \n\r", OrderL);
			}
			i--;
			
		}	
		if (OrderR < OrderL)
		{
			for (j=0; j< 16 ; j++)
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
	// a^1 ~ a^255 까지 모두 넣어 다항식 0이 되는 것을 찾는다.
	//
	// 에러 위치 다항식과  에러 평가 다항식의 형태는 다음과 같으므로
	//
	// σ(a^i) =  σ0 +σ1a^i + σ2(a^i)^2 +σ3(a^i)^3 + ... σt(a^i)^t
	//
	// 계수가 곱해진 상태에서 i번 누적하여 a를 곱하는 형태로 만들면 된다.
	  
	EP8=ErrPosition[8];// 계수와 (a^i)^8을 곱한다.
	EP7=ErrPosition[7];// 계수와 a^7을 곱한다.
	EP6=ErrPosition[6];// 계수와 a^6을 곱한다.
	EP5=ErrPosition[5];// 계수와 a^5을 곱한다.
	EP4=ErrPosition[4];// 계수와 a^4을 곱한다.
	EP3=ErrPosition[3];// 계수와 a^3을 곱한다.
	EP2=ErrPosition[2];// 계수와 a^2을 곱한다.
	EP1=ErrPosition[1];// 계수와 a^1을 곱한다.
	EP0=ErrPosition[0];// 계수와 a^0을 곱한다.

	EV7 = ErrValue[7]; //계수와 a^7을 곱한다.
	EV6 = ErrValue[6];
	EV5 = ErrValue[5];
	EV4 = ErrValue[4];
	EV3 = ErrValue[3];
	EV2 = ErrValue[2];
	EV1 = ErrValue[1];
	EV0 = ErrValue[0];


		k = 0 ; // error is correctable ? 0 is uncorrectable 1 is correctable
	 for (i=0; i < (204+51) ; i++ )  // RS(204,188)은 RS255의 축약형이다.
		 			// 초항이 (a^51)이 곱해진 형태면 204 cycle만에 끝나고 아니면 255까지 모두 넣어준다.
					//
		{
		if (i != 0)
			{
				EP8 =	BinMult (EP8, 29); 	// a^8을 곱한다.
				EP7 =	BinMult (EP7, 128);	// a^7을 곱한다.
				EP6 =	BinMult (EP6, 64); 	// a^6을 곱한다.
				EP5 =	BinMult (EP5, 32); 	// a^5을 곱한다.
				EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
				EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
				EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
				EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
				EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
				EV7 = 	BinMult	(EV7,128);  //계수와 a^7을 곱한다.
				EV6 = 	BinMult	(EV6,64);
				EV5 = 	BinMult	(EV5,32);
				EV4 = 	BinMult	(EV4,16);
				EV3 = 	BinMult	(EV3,8);
				EV2 = 	BinMult	(EV2,4);
				EV1 = 	BinMult	(EV1,2);
				EV0 = 	BinMult	(EV0,1);

			};

		ErrorOdd  = EP7 ^ EP5 ^ EP3 ^ EP1;
		ErrorEven = EP8 ^ EP6 ^ EP4 ^ EP2 ^ EP0 ;

		if ((ErrorEven^ErrorOdd) == 0)
			{
				k=1;
				printf("Error Location is %d (%d) and Error Value is %d \n\r", i, i-51, (EV7^EV6^EV5^EV4^EV3^EV2^EV1^EV0));
				printf("ErrorOdd Value is %d %d\n\r",ErrorOdd, ErrorEven); // Error Odd의 역원과 Error value를 곱한다.

			// Error odd 의 역원을 찾아 Error Value에 곱한다.
			// 여기서 ErrorOdd의 역원은 x * x^-1 = 1 이므로
			// ErrorOdd에 곱해서 1이 되는 수를 찾으면 그것이 ErrorOdd의 역원이된다. 
				for (j = 0 ; j <255 ; j++)
					if (BinMult(ErrorOdd,j)==1)
					{
						printf("- %3d %3d \n\r", j, BinMult(ErrorOdd, j));  // j is inverse of ErrorOdd 	
						printf ("Error Correction value : %3d \n\r",BinMult(j,(EV7^EV6^EV5^EV4^EV3^EV2^EV1^EV0)));
				
						//위에 계산한 Error Correcting Value와 Receive Data를 XOR하면 정정된 값을 얻을 수 있다.
						// I = R(받은 데이터) + E(에러)
					}
			

			}
		}


	// 축약형인 경우 다음과 같이 계산하면 cycle이 줄어든다.

	// a^50이 초항이 된다.
	EP8=ErrPosition[8];// 계수와 (a^i)^8을 곱한다.
	EP7=ErrPosition[7];// 계수와 a^7을 곱한다.
	EP6=ErrPosition[6];// 계수와 a^6을 곱한다.
	EP5=ErrPosition[5];// 계수와 a^5을 곱한다.
	EP4=ErrPosition[4];// 계수와 a^4을 곱한다.
	EP3=ErrPosition[3];// 계수와 a^3을 곱한다.
	EP2=ErrPosition[2];// 계수와 a^2을 곱한다.
	EP1=ErrPosition[1];// 계수와 a^1을 곱한다.
	EP0=ErrPosition[0];// 계수와 a^0을 곱한다.

	EV7 = ErrValue[7]; //계수와 a^7을 곱한다.
	EV6 = ErrValue[6];
	EV5 = ErrValue[5];
	EV4 = ErrValue[4];
	EV3 = ErrValue[3];
	EV2 = ErrValue[2];
	EV1 = ErrValue[1];
	EV0 = ErrValue[0];

	 for (i=0; i < 51 ; i++ )  // RS(204,188)은 RS255의 축약형이다.
		 			// 초항이 (a^51)이 곱해진 형태면 204 cycle만에 끝나고 아니면 255까지 모두 넣어준다.
					//
		{
		if (i != 0)
			{
				EP8 =	BinMult (EP8, 29); 	// a^8을 곱한다.
				EP7 =	BinMult (EP7, 128);	// a^7을 곱한다.
				EP6 =	BinMult (EP6, 64); 	// a^6을 곱한다.
				EP5 =	BinMult (EP5, 32); 	// a^5을 곱한다.
				EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
				EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
				EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
				EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
				EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
				EV7 = 	BinMult	(EV7,128);  //계수와 a^7을 곱한다.
				EV6 = 	BinMult	(EV6,64);
				EV5 = 	BinMult	(EV5,32);
				EV4 = 	BinMult	(EV4,16);
				EV3 = 	BinMult	(EV3,8);
				EV2 = 	BinMult	(EV2,4);
				EV1 = 	BinMult	(EV1,2);
				EV0 = 	BinMult	(EV0,1);

			}
		}

	 for (i=0; i < 204 ; i++ )  // RS(204,188)은 RS255의 축약형이다.
		 			// 초항이 (a^51)이 곱해진 형태면 204 cycle만에 끝나고 아니면 255까지 모두 넣어준다.
					//
		{
			EP8 =	BinMult (EP8, 29); 	// a^8을 곱한다.
			EP7 =	BinMult (EP7, 128);	// a^7을 곱한다.
			EP6 =	BinMult (EP6, 64); 	// a^6을 곱한다.
			EP5 =	BinMult (EP5, 32); 	// a^5을 곱한다.
			EP4 =	BinMult (EP4, 16); 	// a^4을 곱한다.
			EP3 =	BinMult (EP3, 8); 	// a^3을 곱한다.
			EP2 =	BinMult (EP2, 4); 	// a^2을 곱한다.
			EP1 =	BinMult (EP1, 2); 	// a^1을 곱한다.
			EP0 =	BinMult (EP0, 1); 	// a^0을 곱한다.
			EV7 = 	BinMult	(EV7,128);  //계수와 a^7을 곱한다.
			EV6 = 	BinMult	(EV6,64);
			EV5 = 	BinMult	(EV5,32);
			EV4 = 	BinMult	(EV4,16);
			EV3 = 	BinMult	(EV3,8);
			EV2 = 	BinMult	(EV2,4);
			EV1 = 	BinMult	(EV1,2);
			EV0 = 	BinMult	(EV0,1);

			ErrorOdd  = EP7 ^ EP5 ^ EP3 ^ EP1;
			ErrorEven = EP8 ^ EP6 ^ EP4 ^ EP2 ^ EP0 ;

		if ((ErrorEven^ErrorOdd) == 0)
			{
				printf("Error Location is %d and Error Value is %d \n\r", i, (EV7^EV6^EV5^EV4^EV3^EV2^EV1^EV0));
				printf("ErrorOdd Value is %d %d\n\r",ErrorOdd, ErrorEven); // Error Odd의 역원과 Error value를 곱한다.

			// Error odd 의 역원을 찾아 Error Value에 곱한다.
			// 여기서 ErrorOdd의 역원은 x * x^-1 = 1 이므로
			// ErrorOdd에 곱해서 1이 되는 수를 찾으면 그것이 ErrorOdd의 역원이된다. 
				for (j = 0 ; j <255 ; j++)
					if (BinMult(ErrorOdd,j)==1)
					{
						printf("- %3d %3d \n\r", j, BinMult(ErrorOdd, j));  // j is inverse of ErrorOdd 	
						printf ("Error Correction value : %3d \n\r",BinMult(j,(EV7^EV6^EV5^EV4^EV3^EV2^EV1^EV0)));
				
						//위에 계산한 Error Correcting Value와 Receive Data를 XOR하면 정정된 값을 얻을 수 있다.
						// I = R(받은 데이터) + E(에러)
					}
			}
		}
	 

}

unsigned char Invers_GF256 (unsigned char Number)
	{
		unsigned a ;
		int j;
	
			a =1;
			for (j = 0 ; j <254 ; j++)
			a = BinMult(Number, a); // a^255 는 a^-1
			for (j = 0 ; j <255 ; j++)
				if (BinMult(Number,j)==1)
					{
					printf("<%3d %3d \n\r", j, BinMult(Number, j));  // j is inverse of ErrorOdd 	
					}
			return  a;

	}
