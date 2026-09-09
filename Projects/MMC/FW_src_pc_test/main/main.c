#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../inc/ftl.h"
#ifndef WIN32
smtUint8 	buffer[2048];
#else
smtUint8 	buffer[2048*100];
#endif

#ifndef WIN32	
//xdata char	memoryPool[20*1024];
xdata char* memoryPool= NULL;
#endif
/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
#ifndef WIN32
int MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size)
{
	smtUint32 	i;//, j;
	smtUint8	*pbuffer = (smtUint8 xdata*)buffer;
	seed = 0; // prevent compile warning
	for(i = 0; i < size; i++)
	{
		pbuffer[i] = i;
	}
	
	return 0;
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
int CheckPattern(smtUint32 seed, unsigned int buffer, unsigned int size)
{
	unsigned int 	i;//, j;
	smtUint8	pattern;
	smtUint8	*pbuffer = (smtUint8 xdata*)buffer;
	seed = 0;//prevent compile warning
	for(i = 0; i < size; i++)
	{
		
		pattern = i;
		if(pbuffer[i] != pattern)
		{
			printf("error[%d] 0x%02bx != 0x%02bx\n", i, pbuffer[i], pattern);
			return 0;
		}
	}
	
	return 1;
}

#else
int MakePattern(unsigned int seed, unsigned int buffer, unsigned int size)
{
	unsigned int 	i;//, j;
	unsigned int	*pbuffer = (unsigned int*)buffer;
	
	
	for(i = 0; i < size/sizeof(int); i++)
	{
		pbuffer[i] = ((seed<<16) | i);
	}
	
	return 0;
}
/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
int CheckPattern(unsigned int seed, unsigned int buffer, unsigned int size)
{
	unsigned int 	i;//, j;
	unsigned int	pattern;
	unsigned int	*pbuffer = (unsigned int*)buffer;
	for(i = 0; i < size/4; i++)
	{
		
		pattern = ((seed<<16) | i);
		if(pbuffer[i] != pattern)
		{
			return 0;
		}
	}
	
	return 1;
}
#endif
/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------
void HexDump(unsigned int buffer, unsigned int size)
{
	unsigned int 	i, j = 0;
	unsigned char	*pbuffer = (unsigned char*)buffer;
	for(i = 0; i < size/16; i++)
	{
		printf("0x%08x : ", &pbuffer[i*16+j]);
		for(j = 0; j < 16; j++) 
		 	printf("%02x ", pbuffer[i*16+j]);
		 
		printf(" | ");
		 
		for(j = 0; j < 16; j++) 
		{
			if( (pbuffer[i*16+j] >= 0x00)
			 && (pbuffer[i*16+j] <= 0x1F))
				printf(" ");
		 	else
				printf("%c", pbuffer[i*16+j]);
		}
		
		printf("\n");
		
	}	
	printf("\n");
}
*/
/*----------------------------------------------------------
	Function name	: RWTestInSeq
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
RWTestInSeq(
void
)
{
	smtUint8	ret;
	smtUint32	testIdx;
	smtUint32	multi, sector, sector_size;
	
	
	printf("---------------------------------------------------------------\n");
	printf("[MAIN] Sequential R/W Verity test \n");
	printf("---------------------------------------------------------------\n");
	
	// Initialize sector size
	sector_size = 512;
	
	// Initialize FTL
	ret = FTL_Init();
	if(ret == SMT_FALSE) {
		printf("flt_init fail!!!\n");
		return SMT_FALSE;
	}
	
	// R/W test in sequential sector
	for(
		testIdx = 0; 
		testIdx < 100; 
		testIdx++)
	{	
		// Make sector number & sector counter
		srand(testIdx);
#ifndef WIN32
		multi	= 2;
#else
		multi	= rand()%99 + 1;
#endif
		sector	= testIdx;
		
		// Print sector counter
		printf("---------------------------------------------------------------\n");
		printf("[MAIN] access sector\n");
		printf("---------------------------------------------------------------\n");
		printf("- Sector        : %08ld\n", sector);
		printf("- Sector count  : %08ld\n", multi);
	
		// Make pattern 
		MakePattern(sector, (smtUint32)buffer, sector_size*multi);
		printf("- Make pattern  : OK!!!\n");
		
		// Write pattern 
		ret = FTL_Write(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Write pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Write pattern : OK!!!\n");
		
		// Clear temporal buffer
		memset(buffer, 0, sizeof(smtInt8)*sector_size*multi);
		printf("- Buffer clear  : OK!!!\n");
		
		// Read & check pattern
		ret = FTL_Read(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Read pattern  : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Read pattern  : OK!!!\n");
		
		ret = CheckPattern(sector, (smtUint32)buffer, sector_size*multi);
		if(!ret)
		{	
			printf("- Check pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Check pattern : OK!!!\n");
		
	}

	// Deinitialize FTL
	ret = FTL_Deinit();
	if(ret == SMT_FALSE)
	{
		printf("ftl_deinit fail!!!\n");
		return SMT_FALSE;
	}


	return SMT_TRUE;	
	
}
/*----------------------------------------------------------
	Function name	: RWTestInSeq
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
RWTestInRandom(
void
)
{
	smtUint8	ret;
	smtUint32	testIdx;
	smtUint32	multi, sector, sector_size;
	
	
	printf("---------------------------------------------------------------\n");
	printf("[MAIN] Random R/W Verity test \n");
	printf("---------------------------------------------------------------\n");
	
	// Initialize sector size
	sector_size = 512;
	
	// Initialize FTL
	ret = FTL_Init();
	if(ret == SMT_FALSE) {
		printf("flt_init fail!!!\n");
		return SMT_FALSE;
	}
	
	// R/W test in sequential sector
	for(
		testIdx = 0; 
		testIdx < 100; 
		testIdx++)
	{	
		// Make sector number & sector counter
		srand(testIdx);
#ifndef WIN32
		multi	= 2;
		sector	= rand()%99+1;
#else
		multi	= rand()%99 + 1;
		sector	= rand()%100000;
#endif
		
		// Print sector counter
		printf("---------------------------------------------------------------\n");
		printf("[MAIN] access sector\n");
		printf("---------------------------------------------------------------\n");
		printf("- Sector        : %08ld\n", sector);
		printf("- Sector count  : %08ld\n", multi);
	
		// Make pattern 
		MakePattern(sector, (smtUint32)buffer, sector_size*multi);
		printf("- Make pattern  : OK!!!\n");
		
		// Write pattern 
		ret = FTL_Write(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Write pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Write pattern : OK!!!\n");
		
		// Clear temporal buffer
		memset(buffer, 0, sizeof(smtInt8)*sector_size*multi);
		printf("- Buffer clear  : OK!!!\n");
		
		// Read & check pattern
		ret = FTL_Read(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Read pattern  : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Read pattern  : OK!!!\n");
		
		ret = CheckPattern(sector, (smtUint32)buffer, sector_size*multi);
		if(!ret)
		{	
			printf("- Check pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Check pattern : OK!!!\n");
		
	}

	// Deinitialize FTL
	ret = FTL_Deinit();
	if(ret == SMT_FALSE)
	{
		printf("ftl_deinit fail!!!\n");
		return SMT_FALSE;
	}


	return SMT_TRUE;		
}
/*----------------------------------------------------------
	Function name	: RWTestInSeq
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
RWTestInSingle(
void
)
{
	smtUint8	ret;
	smtUint32	testIdx;
	smtUint32	multi, sector, sector_size;
	
	
	printf("---------------------------------------------------------------\n");
	printf("[MAIN] Single R/W Verity test \n");
	printf("---------------------------------------------------------------\n");
	
	// Initialize sector size
	sector_size = 512;
	
	// Initialize FTL
	ret = FTL_Init();
	if(ret == SMT_FALSE) {
		printf("flt_init fail!!!\n");
		return SMT_FALSE;
	}
	
	sector	= rand()%100000;
	
	// R/W test in sequential sector
	for(
		testIdx = 0; 
		testIdx < 100; 
		testIdx++)
	{	
		// Make sector number & sector counter
		srand(testIdx);
#ifndef WIN32
		multi	= 2;
#else
		multi	= rand()%99 + 1;
#endif		
		
		// Print sector counter
		printf("---------------------------------------------------------------\n");
		printf("[MAIN] access sector\n");
		printf("---------------------------------------------------------------\n");
		printf("- Sector        : %08ld\n", sector);
		printf("- Sector count  : %08ld\n", multi);
	
		// Make pattern 
		MakePattern(sector, (smtUint32)buffer, sector_size*multi);
		printf("- Make pattern  : OK!!!\n");
		
		// Write pattern 
		ret = FTL_Write(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Write pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Write pattern : OK!!!\n");
		
		// Clear temporal buffer
		memset(buffer, 0, sizeof(smtInt8)*sector_size*multi);
		printf("- Buffer clear  : OK!!!\n");
		
		// Read & check pattern
		ret = FTL_Read(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Read pattern  : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Read pattern  : OK!!!\n");
		
		ret = CheckPattern(sector, (smtUint32)buffer, sector_size*multi);
		if(!ret)
		{	
			printf("- Check pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Check pattern : OK!!!\n");
		
	}

	// Deinitialize FTL
	ret = FTL_Deinit();
	if(ret == SMT_FALSE)
	{
		printf("ftl_deinit fail!!!\n");
		return SMT_FALSE;
	}


	return SMT_TRUE;		
}
/*----------------------------------------------------------
	Function name	: RWTestInSeq
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtBoolean 
RWTestInReset(
void
)
{
	
	smtUint8	ret;
	smtUint32	testIdx;
	smtUint32	multi, sector, sector_size;
	
	
	printf("---------------------------------------------------------------\n");
	printf("[MAIN] Reset R/W Verity test \n");
	printf("---------------------------------------------------------------\n");
	
	// Initialize sector size
	sector_size = 512;
	
	// Initialize FTL
	ret = FTL_Init();
	if(ret == SMT_FALSE) {
		printf("flt_init fail!!!\n");
		return SMT_FALSE;
	}
			
	sector	= rand()%100000;
#ifndef WIN32
	multi	= 2;
#else
	multi	= rand()%99 + 1;
#endif
	
	// Write pattern
	for(
		testIdx = 0; 
		testIdx < 100; 
		testIdx++)
	{	
		
		sector = testIdx * multi;
		
		// Print sector counter
		printf("---------------------------------------------------------------\n");
		printf("[MAIN] access sector\n");
		printf("---------------------------------------------------------------\n");
		printf("- Sector        : %08ld\n", sector);
		printf("- Sector count  : %08ld\n", multi);
	
		// Make pattern 
		MakePattern(sector, (smtUint32)buffer, sector_size*multi);
		printf("- Make pattern  : OK!!!\n");
		
		// Write pattern 
		ret = FTL_Write(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Write pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Write pattern : OK!!!\n");
	
	}

	// Deinitialize FTL
	ret = FTL_Deinit();
	if(ret == SMT_FALSE)
	{
		printf("ftl_deinit fail!!!\n");
		return SMT_FALSE;
	}
	
	
	// Initialize FTL
	ret = FTL_Init();
	if(ret == SMT_FALSE) {
		printf("flt_init fail!!!\n");
		return SMT_FALSE;
	}
	
	// Read pattern
	for(
		testIdx = 0; 
		testIdx < 100; 
		testIdx++)
	{	
		
		sector = testIdx * multi;
		
		// Print sector counter
		printf("---------------------------------------------------------------\n");
		printf("[MAIN] access sector\n");
		printf("---------------------------------------------------------------\n");
		printf("- Sector        : %08ld\n", sector);
		printf("- Sector count  : %08ld\n", multi);
	
		
		// Clear temporal buffer
		memset(buffer, 0, sizeof(smtInt8)*sector_size*multi);
		printf("- Buffer clear  : OK!!!\n");
		
		// Read & check pattern
		ret = FTL_Read(sector, multi, (smtUint32)buffer);
		if(ret == SMT_FALSE) {
			printf("- Read pattern  : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Read pattern  : OK!!!\n");
		
		ret = CheckPattern(sector, (smtUint32)buffer, sector_size*multi);
		if(!ret)
		{	
			printf("- Check pattern : Fail!!!\n");
			return SMT_FALSE;
		}
		printf("- Check pattern : OK!!!\n");
		
	}

	// Deinitialize FTL
	ret = FTL_Deinit();
	if(ret == SMT_FALSE)
	{
		printf("ftl_deinit fail!!!\n");
		return SMT_FALSE;
	}	
	
	return SMT_TRUE;
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
int main()
{

	smtUint8	ret;
	smtUint32	loop;

#ifndef WIN32
	// Uart Init
	{
		CKCON |= (1<<4);
		PCON |= 0x80;		// 0x80=SMOD: set serial baudrate doubler 
		
		//TMOD = 0x25;		// Timer1 : mode 2, Internal clock use, Timer0 : counter
		TMOD = 0x20;

		//TH1 = 0xFB; 		// 12800
		TH1 = 0xF3; 		// 4800
		TR1 = 1;			// Timer1 run
		SCON = 0x50;		// Serial comm mode 1, REN 	= 1(reception enable)
		TI=1;		   
		RI=0;
	}
#endif

	printf("LLD 2CH Interleave RW Test main \n");
	ret = FTL_Format();
	if(ret == SMT_FALSE) {
		printf("FTL_Format fail!!!\n");
		SMT_ASSERT(0);
	}
	
	for(loop = 0; loop < 1000000; loop++)
	{
	
		ret = RWTestInSeq();	
		if(ret == SMT_FALSE)
		{
			printf("[MAIN] RWTestInSeq test fail!!!\n");
			//return -1;
			goto ERROR;
		}
		printf("[LLD MULTI INTERLEAVE TEST] LOOP = %08ld\n",loop);
		ret = RWTestInRandom();
		if(ret == SMT_FALSE)
		{
			printf("[MAIN] RWTestInRandom test fail!!!\n");
			//return -1;		
			goto ERROR;
		}
		printf("[LLD MULTI INTERLEAVE TEST] LOOP = %08ld\n",loop);
	
		ret = RWTestInSingle();
		if(ret == SMT_FALSE)
		{
			printf("[MAIN] RWTestInSingle test fail!!!\n");
			//return -1;
			goto ERROR;
		}	
		printf("[LLD MULTI INTERLEAVE TEST] LOOP = %08ld\n",loop);
	
		ret = RWTestInReset();
		if(ret == SMT_FALSE)
		{
			printf("[MAIN] RWTestInReset test fail!!!\n");
			//return -1;
			goto ERROR;
		}	
		printf("[LLD MULTI INTERLEAVE TEST] LOOP = %08ld\n",loop);
	}
	printf("[MAIN] test done!!!\n");
	while(1);
	
	return 0;
ERROR:
	printf("[MAIN] error\n");
	while(1);
}