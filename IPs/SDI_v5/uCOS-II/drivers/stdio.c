/*
 *	stdio.c
 */

#include "stdio.h"
#include "includes.h"

extern void SerialOutputByte(const char);
extern int SerialIsReadyChar( void );
extern char SerialIsGetChar( void );

static void PrintChar(char *fmt, char c);
static void PrintDec(char *fmt, int value);
static void PrintHex(char *fmt, int value);
static void PrintString(char *fmt, char *cptr);
static int  Power(int num, int cnt);


// 역할 : long형으로 memory의 내용 복사.
//        속도를 중시하지 않는 다면 잘 사용안함????
// 매개 : 
// 반환 : 
// 주의 : numWords는 4 byte 단위의 개수.
void MemCpy32(void *dest, void *src, int numWords){
	volatile long *s1=dest, *s2=src;
	while(numWords--) {
		*s1++ = *s2++;
	}
	return;
}	// MemCpy32.


// 역할 : char형으로 memory의 내용 복사.
// 매개 : 
// 반환 : 
// 주의 : cnt는 1 byte 단위의 길이.
void memcpy(void *dest, void *src, int cnt){
	char *s1=dest, *s2=src, *endptr=(char *)dest+cnt;
	
	while (s1<endptr)
		*s1++ = *s2++;
	return;
}	// MemCpy.



// 역할 : memory를 특정한 값으로 채움. man memset.
// 매개 : dest : 주소.
//        c    : 채울 문자.
//        len  : 1 byte 단위의 길이.
// 반환 : 
// 주의 : 
void memset(void *dest, char c, int len)
{
	char *s=dest;
	char *limit = (char *)dest+len;

	while (s < limit) *s++ = c;
}	// MemSet.


// 역할 : addr1, addr2 memory에 기록된 값을 길이 len만큼 비교.
// 매개 : dest : 주소.
// 반환 : return : 0 : equal	ret : addr1 > addr2	-ret : addr1 < addr2.
// 주의 : 
int MemCmp(void *addr1, void *addr2, int len)
{
	volatile char *s1=addr1, *s2=addr2;
	volatile char *endptr = (char *)addr1+len;

	while ((ulong)s1 < (ulong)endptr){
		if (*s1++ != *s2++) return *(--s1) - *(--s2);
	}
	return 0;
}	// MemCmp.


// 역할 : 문자열 복사. '\0'가 나올 때까지.
// 매개 : dest : 대상 주소.
//        src  : 원본 주소.
// 반환 : 
// 주의 : 
void StrCpy(char *dest, char *src){
	volatile char *s1=dest, *s2=src;
	
	while (*s2!=0) *s1++ = *s2++;
	*s1 = 0;
	return;
}	// StrCpy.


// 문자열 길이 구하기.
// return : 문자열 길이.
int StrLen(char *dest){
	volatile char *tmp = dest;

	if (!tmp) return -1;
	while (*tmp!=0) tmp++;
	return (tmp - dest);
}	// StrLen.


// 문자열 s1, s2을 길이 len의 범위 이내에서 비교.
// return : 0 : equil		ret : s1 > s2		-ret : s1 < s2
int StrNCmp(char *s1, char *s2, int len){
	int i;

	for(i = 0; i < len; i++){
		if(s1[i] != s2[i])	return ((int)s1[i]) - ((int)s2[i]);
		if(s1[i] == 0)		return 0;
	}
	return 0;
} // StrNCmp.


// 문자열 s1, s2를 비교.
// return : 0 : equil		ret : s1 > s2		-ret : s1 < s2
int StrCmp(char *s1, char *s2){
	for (; *s1 && *s2; s1++, s2++){
		if (*s1 != *s2) return ((int)(*s1) - (int)(*s2));
	}
	if (*s1 || *s2) return ((int)(*s1) - (int)(*s2));
	return 0;
}	// StrCmp.


// 역할 : 16진수 문자열 s에서 1, 2, 4 byte 정수형을 만들어 retval에 기록.
// 매개 : s      : 변환할 문자열의 주소.
//        retval : 변환된 값이 기록될 주소. short로 변환하고자 하면 short * 형이어야 함.
//        type   : char : 8, short : 16, long : 32.
// 반환 : return : 1 : success		0 : failure.
// 주의 : no type check. retval의 변수형에 주의해서 사용하세요....
bool HexToInt(char *s, void *retval, VAR_TYPE type){
	char	c;
	int		i;
	long	rval;

	if (!s || !retval) return false;
	if (!StrNCmp(s, "0x", 2)) s+=2;
	// fine int value.
	for (i=0, rval=0; i<type/4; i++){
		if (*s=='\0'){
			if (i==0) return false;
			else      break;
		}
		c = *s++;

		if      (c>='0' && c<='9') c-='0';
		else if (c>='a' && c<='f') c=c-'a'+10;
		else if (c>='A' && c<='F') c=c-'A'+10;
		else    return false;

		rval = rval<<4 | c;
	}
	// make retval.
	switch (type){
		case 8 :
			*(char *)retval = (char)rval;
			break;
		case 16 :
			*(short *)retval = (short)rval;
			break;
		case 32 :
			*(long *)retval = (long)rval;
			break;
		default :
			return false;
	}
	return true;
}	// HexToInt.


// 역할 : 10진수 문자열 s에서 정수를 만들어 retval이 가리키는 위치에 기록.
// 매개 : s      : 변환할 문자열의 주소.
//        retval : 변환된 값이 기록될 주소.
// 반환 : return : 1 : success		0 : failure.
// 주의 :
bool DecToLong(char *s, long *retval){
	long remainder;
	if (!s || !s[0]) return false;

	for (*retval=0; *s; s++){
		if (*s < '0' || *s > '9') return false;
		remainder = *s - '0';
		*retval = *retval * 10 + remainder;
	}

	return true;
}	// DecToLong.


// hexdump.
// 출력.
// offset      Hex Value                                        Ascii Value
// 0x00000000  ff 0A 7A 79 00 00 78 7D ff 0A 7A 79 00 00 78 7D  ..zy..x}..zy..x}
void HexDump(char *addr, int len){
	char	*s=addr, *endPtr=(char *)((long)addr+len);
	int		i, remainder=len%16;
	
	printf("\n");
	printf("Offset      Hex Value                                        Ascii value\n");
	
	// print out 16 byte blocks.
	while (s+16<=endPtr){
		// offset 출력.
		printf("0x%08lx  ", (long)(s-addr));
		// 16 bytes 단위로 내용 출력.
		for (i=0; i<16; i++){
			printf("%02x ", s[i]);
		}
		printf(" ");
		for (i=0; i<16; i++){
			if		(s[i]>=32 && s[i]<=125)	printf("%c", s[i]);
			else							printf(".");
		}
		s += 16;
		printf("\n");
	}
	
	// Print out remainder.
	if (remainder){
		// offset 출력.
		printf("0x%08lx  ", (long)(s-addr));
		// 16 bytes 단위로 출력하고 남은 것 출력.
		for (i=0; i<remainder; i++){
			printf("%02x ", s[i]);
		}
		for (i=0; i<(16-remainder); i++){
			printf("   ");
		}
		printf(" ");
		for (i=0; i<remainder; i++){
			if		(s[i]>=32 && s[i]<=125)	printf("%c", s[i]);
			else							printf(".");
		}
		for (i=0; i<(16-remainder); i++){
			printf(" ");
		}
		printf("\n");
	}
	return;
}	// HexDump.


// 역할 : printf() 중 일부를 간단하게 구현.
// 매개 : fmt : printf()와 동일하나 "%s", "%c", "%d", "%x" 사용 가능.
//              %d, %x의 경우에는 "%08x", "%8x"와 같이 나타낼 길이와 빈 공간을 0으로 채울지 선택 가능.
// 반환 : 없음.
// 주의 : 없음.
void printf(char *fmt, ...)
{
	int		i;
	va_list args;
	char	*s=fmt;
	char	format[10];	// fmt의 인자가 "%08lx"라면, "08l"를 임시로 기록.
	
	va_start(args, fmt);
	while (*s){
		if (*s=='%'){
			s++;
			// s에서 "%08lx"형식을 가져와 format에 기록. 나중에 출력함수에 넘겨줌.
			format[0] = '%';
			for (i=1; i<10;){
				if (*s=='c' || *s=='d' || *s=='x' || *s=='s' || *s=='%'){
					format[i++] = *s;
					format[i] = '\0';
					break;
				}
				else {
					format[i++] = *s++;
				}
			}
			// "%s", "%c", "%d", "%x"를 찾아 출력할 함수 호출.
			switch (*s++){
				case 'c' :
					PrintChar(format, va_arg(args, int));
					break;
				case 'd' :
					PrintDec(format, va_arg(args, int));
					break;
				case 'x' :
					PrintHex(format, va_arg(args, int));
					break;
				case 's' :
					PrintString(format, va_arg(args, char *));
					break;
				case '%' :
					PrintChar("%c", '%');
					break;
			}
		}
		else {
			PrintChar("%c", *s);
			s++;
		}
	}
	va_end(args);
	return;
}


void PrintChar(char *fmt, char c)
{
	SerialOutputByte(c);
	return;
}


void PrintDec(char *fmt, int l)
{
	int	i, j;
	char	c, *s=fmt, tol[10];
	bool	flag0=false, flagl=false;	// "%08lx"에서 '0', 'l'의 존재 여부.
	long	flagcnt=0;					// "%08lx"에서 "8"을 찾아서 long형으로.
	bool	leading_zero=true;			// long형의 data를 출력하기 위한 변수.
	long	divisor, result, remainder;

	// fmt의 "%08lx"에서 '0', '8', 'l'을 해석.
	for (i=0; (c=s[i]) != 0; i++){
		if (c=='d') break;
		else if (c>='1' && c<='9'){
			for (j=0; s[i]>='0' && s[i]<='9'; j++){
				tol[j] = s[i++];
			}
			tol[j] = '\0';
			i--;
			DecToLong(tol, &flagcnt);
		}
		else if (c=='0') flag0=true;
		else if (c=='l') flagl=true;
		else continue;
	}

	// 위의 flag에 따라 출력.
	if (flagcnt){
		if (flagcnt>9) flagcnt=9;
		remainder = l%(Power(10, flagcnt));	// flagcnt보다 윗자리의 수는 걸러냄. 199에 flagcnt==2이면, 99만.

		for (divisor=Power(10, flagcnt-1); divisor>0; divisor/=10){
			result = remainder/divisor;
			remainder %= divisor;

			if (result!=0 || divisor==1) leading_zero = false;

			if (leading_zero==true){
				if (flag0)	SerialOutputByte('0');
				else		SerialOutputByte(' ');
			}
			else SerialOutputByte((char)(result)+'0');
		}
	} else {
		remainder = l;

		for (divisor=1000000000; divisor>0; divisor/=10){
			result = remainder/divisor;
			remainder %= divisor;

			if (result!=0 || divisor==1) leading_zero = false;
			if (leading_zero==false) SerialOutputByte((char)(result)+'0');
		}
	}
	return;
}


void PrintHex(char *fmt, int l){
	int		i, j;
	char	c, *s=fmt, tol[10];
	bool	flag0=false, flagl=false;	// flags.
	long	flagcnt=0;
	bool	leading_zero=true;
	char	uHex, lHex;
	int		cnt;						// "%5x"의 경우 5개만 출력하도록 출력한 개수.

	// fmt의 "%08lx"에서 '0', '8', 'l'을 해석.
	for (i=0; (c=s[i]) != 0; i++){
		if (c=='x') break;
		else if (c>='1' && c<='9'){
			for (j=0; s[i]>='0' && s[i]<='9'; j++){
				tol[j] = s[i++];
			}
			tol[j] = '\0';
			i--;
			DecToLong(tol, &flagcnt);
		}
		else if (c=='0') flag0=true;
		else if (c=='l') flagl=true;
		else continue;
	}

	s = (char *)(&l);
	l = SWAP32(l);		// little, big endian에 따라서.(big이 출력하기 쉬워 순서를 바꿈)
	
	// 위의 flag에 따라 출력.
	if (flagcnt){
		if (flagcnt&0x01){	// flagcnt가 홀수 일때, upper를 무시, lower만 출력.
			c = s[(8-(flagcnt+1))/2]; // 홀수 일때 그 위치를 포함하는 곳의 값을 가져 옵니다.
			
			// lower 4 bits를 가져와서 ascii code로.
			lHex = ((c>>0)&0x0f);
			if (lHex!=0) leading_zero=false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;

			// lower 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(lHex);
			
			flagcnt--;
		}

		// byte단위의 data를 Hex로 출력.
		for (cnt=0, i=(8-flagcnt)/2; i<4; i++){
			c = s[i];
				
			// get upper 4 bits and lower 4 bits.
			uHex = ((c>>4)&0x0f);
			lHex = ((c>>0)&0x0f);

			// upper 4 bits and lower 4 bits to '0'~'9', 'A'~'F'.
			// upper 4 bits를 ascii code로.
			if (uHex!=0) leading_zero = false;
			if (uHex<10) uHex+='0';
			else         uHex+='A'-10;

			// upper 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(uHex);
			
			// lower 4 bits를 ascii code로.
			if (lHex!=0) leading_zero = false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;

			// lower 4 bits 출력.
			if (leading_zero){
				if (flag0) SerialOutputByte('0');
				else       SerialOutputByte(' ');
			}
			else SerialOutputByte(lHex);
		}
	}
	else {
		for (i=0; i<4; i++){
			c = s[i];
	
			// get upper 4 bits and lower 4 bits.
			uHex = ((c>>4)&0x0f);
			lHex = ((c>>0)&0x0f);

			// upper 4 bits and lower 4 bits to '0'~'9', 'A'~'F'.
			if (uHex!=0) leading_zero = false;
			if (uHex<10) uHex+='0';
			else         uHex+='A'-10;
			if (!leading_zero) SerialOutputByte(uHex);
			
			if (lHex!=0 || i==3) leading_zero = false;
			if (lHex<10) lHex+='0';
			else         lHex+='A'-10;
			if (!leading_zero) SerialOutputByte(lHex);
		}
	}
	return;
}


void PrintString(char *fmt, char *s){
	if (!fmt || !s) return;
	while (*s) SerialOutputByte(*s++);
	return;
}


int Power(int num, int cnt){
	long retval=num;
	cnt--;

	while (cnt--){
		retval *= num;
	}
	return retval;
}


int getc(void)
{               
	// 한문자 대기 
	while( !SerialIsReadyChar() );
	return SerialIsGetChar() & 0xFF;
}

int gets(char *s)
{
	int cnt = 0;
	char  c;

	while((c = getc()) != CR)
	{
		if(c != BS)
		{
			cnt++;
			*s++ = c;
			printf("%c",c );
		}
		else
		{
			if(cnt > 0)
			{ cnt--; *s-- = ' ';
				printf("\b \b");
			}
		}
	}
	*s = 0;
	return(cnt);
}		

char *delim_ = " .:\n";   //\f\n\r\t\v
int Cfg_parse_args(char *cmdline, char **argv)
{
	char *tok;
	int argc = 0;

	argv[argc] = NULL;
	for (tok = strtok(cmdline, delim_); tok; tok = strtok(NULL, delim_))
	{
		argv[argc++] = tok;
	}
	return argc;
}

//------------------------------------------------------------------------------
// 설명 : 토큰 문자를 판정한다. 
//------------------------------------------------------------------------------
char * ___strtok;
char * strtok(char * s,const char * ct)
{
	char *sbegin, *send;

	sbegin  = s ? s : ___strtok;
	if (!sbegin) {
		return NULL;
	}
	sbegin += strspn(sbegin,ct);
	if (*sbegin == '\0') {
		___strtok = NULL;
		return( NULL );
	}
	send = strpbrk( sbegin, ct);
	if (send && *send != '\0')
		*send++ = '\0';
	___strtok = send;
	return (sbegin);
}

//------------------------------------------------------------------------------
// 설명 : 문자열의 문자 구성을 비교 한다. 
//------------------------------------------------------------------------------
unsigned int strspn(const char *s, const char *accept)
{
	const char *p;
	const char *a;
	unsigned int count = 0;
	
	for (p = s; *p != '\0'; ++p) {
		for (a = accept; *a != '\0'; ++a) {
			if (*p == *a)
				break;
		}
		if (*a == '\0')
			return count;
		++count;
	}
	return count;
}

//------------------------------------------------------------------------------
// 설명 : 구분 문자를 검색한다. 
//------------------------------------------------------------------------------
char * strpbrk(const char * cs,const char * ct)
{
	const char *sc1,*sc2;

	for( sc1 = cs; *sc1 != '\0'; ++sc1) {
		for( sc2 = ct; *sc2 != '\0'; ++sc2) {
			if (*sc1 == *sc2)
				return (char *) sc1;
		}
	}
	return NULL;
}

unsigned long strtoul(const char *str, char **endptr, int requestedbase)
{
	unsigned long num = 0;
	char c;
	unsigned char digit;
	int base = 10;
	int nchars = 0;
	int leadingZero = 0;
	unsigned char strtoul_err = 0;
	
	while ((c = *str) != 0) {
		if (nchars == 0 && c == '0') {
			leadingZero = 1;
			goto step;
		} else if (leadingZero && nchars == 1) {
			if (c == 'x') {
				base = 16;
				goto step;
			} else if (c == 'o') {
				base = 8;
				goto step;
			}
		}
		if (c >= '0' && c <= '9') {
			digit = c - '0';
		} else if (c >= 'a' && c <= 'z') {
			digit = c - 'a' + 10;
		} else if (c >= 'A' && c <= 'Z') {
			digit = c - 'A' + 10;
		} else {
			strtoul_err = 3;
			return 0;
		}
		if (digit >= base) {
			strtoul_err = 4;
			return 0;
		}
		num *= base;
		num += digit;
step:
		str++;
		nchars++;
	}
	return num;
}
