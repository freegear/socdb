/*----------------------------------------------------------
	File Name   : main.c 
	Description : Application Entry Point File
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#define  __GCC_ARM__  1
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
// #include "irq_toy.c"

#define SIMUL
//FPGA GCC environment
#include "./API/apigpio.c"
#include "./API/apiuart.c"
#include "./API/apidmac.c"
#include "./API/apispi.c"

#ifdef SIMUL
#define DPRINTF(fmt, args...)	/* NULL */
#else
#define DPRINTF(fmt, args...)	UART_printf(fmt, ##args)
#endif

#define LOOPBACK

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void UART_Initial(void);
void SDR_Test(void);
void InitializeSDRCtrl(void);
void UART_printf(const char *format, ...);

smtUint32 SPI_Test(void);
void SPI_Init(smtUint32 PreVal, smtUint32 DivVal);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */




/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : main()
    Prototype           : void main(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
int main(void)
{
	int i, count;
	int yes_or_no;
	int sum;
	unsigned data;

	SMT_WRITE(GPIO_OUT, 0x00014321);
//	SMT_WRITE(GPIO_OUT, 0x00004321);
	GPIO_OutputEnable(0xffff);
	GPIO_Write(0x4321);
	GPIO_Write(0x1357);

#ifndef SIMUL
	UART_Initial();
#endif
	DPRINTF("Test\n");
	

	SPI_Test();


	InitializeSDRCtrl();
	GPIO_Write(0x4323);

	SDR_Test();
	GPIO_Write(0x4325);

	i = 0;
	while(1)
	{
		count = 1000;
		GPIO_Write(i);
		i++;
		while(count--);
	}
    while(1);
//___________________FPGA test end

	return 0;
}

void InitializeSDRCtrl(void)
{
	int i;
	unsigned stable_cnt;
	static int initialized = 0;

	if(initialized == 1)
		return;

	DPRINTF("Initializing SDR Controller...");
//	SMT_WRITE(DDRTCON, 0x00000000);
//	SMT_WRITE(DDRREF,  0x00200820); // default value (SDRAM mode CAS)
	SMT_WRITE(DDRTCON, 0x001A70A); // CAS latency default setting (tcl_s/tcl)
	//SMT_WRITE(DDRTCON, 0x000A72A); // CAS latency CL3 setting
	SMT_WRITE(DDRREF, 0x00200820); // REFRESH Counter setting (SDRAM setting)


	//SMT_WRITE(DDRCON, 0x00000A3); // 16bit SDR
	SMT_WRITE(DDRCON, 0x0000023); // 32bit SDR
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
/*
	do {
		stable_cnt = SMT_READ(DDRREF);
		stable_cnt &= 0x01f00000;
		stable_cnt >>= 20;
	} while(stable_cnt != 0);
*/

	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	DPRINTF("SDR Status Register : 0x%08x\n ",SMT_READ(DDRDLL));
	initialized = 1;
	DPRINTF("Done\n");
}

//#define SDR_TEST_COUNT 2048		/* 1K WORD */
#define SDR_TEST_COUNT 2048		/* 1K WORD */
static unsigned test_temp[SDR_TEST_COUNT];
#define DATA0(x) (((x)&0xff)|((((x+1)&0xff)^0xff)<<8)|((((x+2)&0xff)^0xff)<<16)|(((x+1)&0xff)<<24))
#define DATA1(x) 0x55aaaa55
#define DATA2(x) 0xaa5555aa

void SDR_Test(void)
{
	int i;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(SDRAM_STARTADDR);
	unsigned data;
	unsigned expected_data;

	InitializeSDRCtrl();

	DPRINTF("SDR Test...\n");

	// PHASE 0 : single write => single/burst read
	// single write
	//
	//
	//
	DPRINTF("SDR Single Write All Region..");
	for(i = 0; i < ((2*64*1024*1024)/4); i++)
		ddram_testregion[i] = i;

	DPRINTF("   Done!..\n");
	DPRINTF("SDR Single Read All Region.. ");
	for(i = 0; i < ((2*64*1024*1024)/4); i++)
	{
		data = ddram_testregion[i];

		if(data != i)
		{
		DPRINTF("SDR READ Error address 0x%08x \n", i);

			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");

	DPRINTF("SDR Single Write..");
	for(i = 0; i < SDR_TEST_COUNT; i++)
		ddram_testregion[i] = i;//DATA0(i);

	DPRINTF("   Done!..\n");
	DPRINTF("SDR Single Read.. ");
	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
	//	DPRINTF("read 0x%08x when 0x%08x expected\n", data, i);//DATA0(i));
		if(data != i)//DATA0(i))
		{
		DPRINTF("SDR READ Error address 0x%08x \n", i);

			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");

	DPRINTF("SDR Burst Read Test");
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
	//		DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");


	DPRINTF("SDR Burst Write ");
	for(i = 0; i < SDR_TEST_COUNT; i++)
	test_temp[i] = i;
	DMACMemCopy(0, (unsigned char *)ddram_testregion, (unsigned char *)test_temp, SDR_TEST_COUNT*4);
	DPRINTF("   Done!..\n");

	DPRINTF("SDR Single Read Test");
	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");

	DPRINTF("SDR Burst Read Test");
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
	//		DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
		if(data != i)
		{
			expected_data = i;
			goto error;
		}
	}
	DPRINTF("  PASS!..\n");
	DPRINTF("---------------------------------------------------------\n");



/*
	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
			DPRINTF("Bread 0x%08x when 0x%08x expected\n", data, DATA0(i));
	if(data != DATA0(i))
		{
			expected_data = DATA0(i);
			goto error;
		}
	}
*/

#if 0
	// PHASE 1 : burst write => single/burst read
	// burst write SDR region
	for(i = 0; i < SDR_TEST_COUNT; i++)
		test_temp[i] = DATA1(i);
	DMACMemCopy(0, (unsigned char *)ddram_testregion, (unsigned char *)test_temp, SDR_TEST_COUNT*4);

	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA1(i))
		{
			expected_data = DATA1(i);
			goto error;
		}
	}

	// burst read
	for(i = 0; i < SDR_TEST_COUNT; i++)
		test_temp[i] = 0xffffffff;
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA1(i))
		{
			expected_data = DATA1(i);
			goto error;
		}
	}


	// PHASE 2 : single write => single/burst read
	// single write
	for(i = 0; i < SDR_TEST_COUNT; i++)
		ddram_testregion[i] = DATA2(i);

	// single read
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = ddram_testregion[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}

	// burst read using DMA
	DMACMemCopy(0, (unsigned char *)test_temp, (unsigned char *)ddram_testregion, SDR_TEST_COUNT*4);
	for(i = 0; i < SDR_TEST_COUNT; i++)
	{
		data = test_temp[i];
		if(data != DATA2(i))
		{
			expected_data = DATA2(i);
			goto error;
		}
	}
#endif

	DPRINTF("Done\n");
	return;

error:
	DPRINTF("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIO_Write(0xdead);
	while(1);
}
smtUint32 SPI_Test(void)
{
	smtUint32 spi_testregion[8];
	smtUint32 SPIDATA[8];

	smtUint32	i, data;
	unsigned expected_data;
			DPRINTF("LoopBack Test\n");
			SMT_WRITE(SPIHIDDEN, (SMT_READ(SPIHIDDEN)|0x01) ); 	// Hidden Register Setting For LoopBack Test
			//-----------------------------------------------------------------
			DPRINTF("Normal Mode Test No DMA");
			SPI_Init(0x08,0xF4);					// SPI Enable	
			SMT_WRITE(SPIINTDMA, 	( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
									((1<<12)&SPIRXFINTEN)		|	// RX FIFO Interrupt
                	                ((1<<11)&SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
                    	            ((1<<10)&SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
                        	        ((0<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
                            	    ((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
                                	((0<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
                                	((1<<0)&SPIRXDMALEVEL)		));	// RX DMA Request Level Setting

			// TXFIFO DATA WRITE	
			for(i = 0; i <8; i++)
				SMT_WRITE(SPITXDAT, i);

			// TXFIFO EMPTY CHECK
			while ((SMT_READ(SPISTA)& 0x0010)==0x0000)  	// Empty??
			{
					DPRINTF("TXFIFOLEVEL is 0x%08x \n", ((SMT_READ(SPISTA)&0x3C00)>>10));
			}	
			GPIO_Write(0x1111);
			// RXFIFO FULL CHECK
			while ((SMT_READ(SPISTA)& 0x0008)==0x0000) // Full?
			{
					DPRINTF("RXFIFOLEVEL is 0x%08x \n",((SMT_READ(SPISTA)&0x03C0)>>6));
			}
			GPIO_Write(0x1112);

			for(i = 0; i <8; i++)
			{
					data = SMT_READ(SPIRXDAT);
					DPRINTF("READ Value :  0x%08x \n", data);
					#ifdef  LOOPBACK 
					if(data != i)
					{
						DPRINTF("SPI READ Error address 0x%08x \n", i);
						expected_data = i;
						goto error;
					}
					#endif
			}
			GPIO_Write(0x1113);

			DPRINTF(" -> PASS\n");

			//-----------------------------------------------------------------
			DPRINTF("TX DMA Mode Test");
			for(i = 0; i <8; i++)
				spi_testregion[i] = i; 			// DATA 
			SMT_WRITE(SPIINTDMA, 	( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
									((1<<12)&SPIRXFINTEN)		|	// RX FIFO Interrupt
                	                ((1<<11)&SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
                    	            ((1<<10)&SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
                        	        ((1<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
                            	    ((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
                                	((0<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
                                	((1<<0)&SPIRXDMALEVEL)		));	// RX DMA Request Level Setting

			DMACEnable(SPITXDMACH);				// TX DMA Enable
			// DMA Setting for No Description Mode

			DMACNoDescrp(SPITXDMACH, 			// DMA Channel
						(unsigned int)spi_testregion, 	// Source Address
						IncAdrType, 			// Source Address Type
						WidthWORD,				// WORD Data
	      			    (SPI_BASEADDR+0x14),  	// Destination Address
						NoIncAdrType, 			// Destination Address Type 
						WidthWORD,				// WidthBYTE,// BYTE Data // APB Bus Must 32bit access
						TSize4B, 				// 1 Cycle DMA Transfer Size
						(8*4)					// Total DMA Using Transfer Size
						);

			while((SMT_READ(DMACSta(1))&0x08)!=0x08); // Wait Stop Interrupt
			GPIO_Write(0x1114); // end of DMA
			
			// TXFIFO EMPTY CHECK
			while ((SMT_READ(SPISTA)& 0x0010)==0x0000)  	// Empty??
			{
					DPRINTF("TXFIFOLEVEL is 0x%08x \n", ((SMT_READ(SPISTA)&0x3C00)>>10));
			}
			GPIO_Write(0x1115); // end of TX

			// RXFIFO FULL CHECK
			while ((SMT_READ(SPISTA)& 0x0008)==0x0000) // Full?
			{
					DPRINTF("RXFIFOLEVEL is 0x%08x \n",((SMT_READ(SPISTA)&0x03C0)>>6));
			}
			GPIO_Write(0x1116);


			for(i = 0; i < 8; i++)
			{
				data = SMT_READ(SPIRXDAT);
				#ifdef LOOPBACK
				if(data != i)
				{
					DPRINTF("SPI READ Error address 0x%08x \n", i);
					expected_data = i;
					goto error;
				}
				#endif			
			}	

			DMACDisable(SPITXDMACH);
			DPRINTF(" -> PASS\n"); // end of TX DMA Test

			GPIO_Write(0x1117);

			SMT_WRITE(SPIINTDMA, 	( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
									((1<<12)&SPIRXFINTEN)		|	// RX FIFO Interrupt
                	                ((1<<11)&SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
                    	            ((1<<10)&SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
                        	        ((0<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
                            	    ((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
                                	((0<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
                                	((1<<0)&SPIRXDMALEVEL)		));	// RX DMA Request Level Setting



			//-----------------------------------------------------------------
			DPRINTF("RX DMA Mode Test");
			DMACDisable(SPITXDMACH); 	// TX DMA Disable
			DMACEnable(SPIRXDMACH);		// Rx DMA Enable
			SMT_WRITE(SPIINTDMA, 	( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
									((1<<12)&SPIRXFINTEN)		|	// RX FIFO Interrupt
                	                ((1<<11)&SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
                    	            ((1<<10)&SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
                        	        ((1<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
                            	    ((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
                                	((1<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
                                	((1<<0)&SPIRXDMALEVEL)		));	// RX DMA Request Level Setting

			// TXFIFO DATA WRITE	
			for(i = 0; i <8; i++)
				SMT_WRITE(SPITXDAT, i);

			// DMA Setting for No Description Mode
			DMACNoDescrp(SPIRXDMACH, 			// DMA Channel
	      				(SPI_BASEADDR+0x18),  	// Source Address
						NoIncAdrType, 			// Source Address Type 
						WidthWORD, 				// BYTE Data
						(unsigned int)spi_testregion, 	// Destination Address
						IncAdrType, 			// Destination Address Type
						WidthWORD,				// WORD Data
						TSize4B, 				// 1 Cycle DMA Transfer Size
						(8*4)					// Total DMA Using Transfer Size
						);
			while((SMT_READ(DMACSta(0))&0x08)!=0x08); // Wait Stop Interrupt
			GPIO_Write(0x1118);
			DMACDisable(SPIRXDMACH);

			for(i = 0; i < 8; i++)
			{
				data = spi_testregion[i];
				#ifdef LOOPBACK
				if(data != i)
				{
					DPRINTF("SPI READ Error address 0x%08x \n", i);
					expected_data = i;
					goto error;
				}
				#endif
			}
			GPIO_Write(0x1119);
			DPRINTF(" -> PASS\n");


			//-----------------------------------------------------------------
			DPRINTF("TX and RX DMA Mode Test");
			for(i = 0; i <8; i++)
				spi_testregion[i] = i; 			// DATA 

			//for(i = 0; i <8; i++)
			//	SMT_WRITE(SPITXDAT, i);
			DMACEnable(SPIRXDMACH);		// RX DMA Enable
			DMACEnable(SPITXDMACH);		// TX DMA Enable

			// DMA Setting for No Description Mode
			DMACNoDescrp(SPITXDMACH, 			// DMA Channel
						(unsigned int)spi_testregion, 	// Source Address
						IncAdrType, 			// Source Address Type
						WidthWORD,				// WORD Data
	      				(SPI_BASEADDR+0x14),	// Destination Address
						NoIncAdrType, 			// Destination Address Type 
						WidthWORD, 				// BYTE Data
						TSize4B, 				// 1 Cycle DMA Transfer Size
						(8*4)						// Total DMA Using Transfer Size
						);
			// DMA Setting for No Description Mode
			DMACNoDescrp(SPIRXDMACH, 			// DMA Channel
	      				(SPI_BASEADDR+0x18),	// Source Address
						NoIncAdrType, 			// Source Address Type 
						WidthWORD, 				// BYTE Data
						(unsigned int)SPIDATA, 	// Destination Address
						IncAdrType, 			// Destination Address Type
						WidthWORD,				// WORD Data
						TSize4B, 				// 1 Cycle DMA Transfer Size
						(8*4)					// Total DMA Using Transfer Size
						);
			while((SMT_READ(DMACSta(1))&0x08)!=0x08); // Wait Stop Interrupt
			GPIO_Write(0x1117);
			DMACDisable(SPITXDMACH);
			while((SMT_READ(DMACSta(0))&0x08)!=0x08); // Wait Stop Interrupt
			GPIO_Write(0x1118);
			DMACDisable(SPIRXDMACH);
			for(i = 0; i < 8; i++)
			{
				data = SPIDATA[i];
				#ifdef LOOPBACK
				if(data != i)
				{
					DPRINTF("SPI READ Error 0x%08x \n", i);
					expected_data = i;
					goto error;
				}
				#endif
			}	

			DPRINTF("-> PASS!\n");
			DPRINTF("End SPI TEST\n");
			return;

error:
	DPRINTF("Error(Read %08x when expected %08x)\n", data, expected_data);
	GPIO_Write(0xdead);
	while(1);
}

/*-----------------------------------------------------------------------
    Function name   : SPI_Init()
    Prototype       : smtUint32 SPI_Init(smtUint32 PreVal)
    Return          : 
    Argument        :
    Comments        :  PCLK/(SPIDIVIDE*(SPIRESCALER+1))
-----------------------------------------------------------------------*/

void SPI_Init(smtUint32 PreVal, smtUint32 DivVal)
{

		//PCLK/(SPIDIVIDE*(SPIRESCALER+1))
		SMT_WRITE(SPIPRE, 		(PreVal & SPIPRESCALER )|(DivVal& SPIDIVIDER)); 	// Prescaler Setting
		SMT_WRITE(SPIINTDMA, 	( ((1<<13)&SPITXFINTEN) 	|	// Tx FIFO Interrupt
								((1<<12)&SPIRXFINTEN)		|	// RX FIFO Interrupt
                                ((1<<11)&SPIRXTOUTINTEN)	|	// RX Time Out Interrupt
                                ((1<<10)&SPIRXFOVRINTEN)	|	// RX FIFO Overrun Interrupt	
                                ((1<<9)&SPITXDMAREQEN)	|	// TX DMA Request Enable
                                ((1<<5)&SPITXDMALEVEL)	|	// TX DMA Request Level Setting
                                ((1<<4)&SPIRXDMAREQEN)	|	// RX DMA Request Enable
                                ((1<<0)&SPIRXDMALEVEL)		));	// RX DMA Request Level Setting

		SMT_WRITE(SPICON, 		((1<<3)&SPIENABLE)| // SPI Enable  0: Disable 1: Enable
								((0<<2)&MS)|		// SPI Master/Slave Mode Select 0: Master 1: Slave
								((0<<1)&CPOL)|		// SPI Mode0 Setting
								((0<<1)&CPHA)
								); 						// Control Register Setting

}


