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

#include "gpio.h"
#include "uart.h"
#include "dmac.h"

#include "memorymap.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define BLACK	0xff000000
#define BLUE	0xffff0000
#define GREEN	0xff00ff00
#define CYAN	0xffffff00
#define RED		0xff0000ff
#define MAGENTA	0xffff00ff
#define YELLOW	0xff00ffff
#define WHITE	0xffffffff

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DDRTest(void);
void EthernetReadWriteTest(void);
void VideoEncoderEnable(void);
void InterruptTest(void);
void BGMTest(void);
void AudioDelayedLoopback(void);
void VideoTest(void);
void NandTest(void);
void ADV7181BTest(void);
void SEIPReadWriteTest(void);

void PCIInterfaceTest(void);
void MACInterfaceTest(void);
void fpga1Test(void);

//static void Menu(void);

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
#define MODE         0
#define EN_DAC0             1
#define EN_DAC1             1
#define EN_DAC2             1
#define EN_SQPIXEL          0
#define EN_NONINTERLACE     0
int main(void)
{
	int count = 1000;
	int ch;
	volatile smtUint32 * ddram_testregion = (volatile smtUint32 *)(DDR_TESTREGION);
	GPIOOutputEnable(0x800fffff);
	GPIOWrite(0xA4321);
#ifndef SIMUL    
	UartInit();
#endif
    GPIOWrite(0xA4322);

	DPRINTF("Power On Self Test Start\n");
	//UartPrintf("Power On Self Test Start\n");
//    MACInterfaceTest();

//    PCIInterfaceTest();
    
    pciScan();
    UartGetch();
    fpga1Test();

//    DDRInit();
	//DDRTest();

	//NandTest();
	

	GPIOWrite(0xA4323);
//	EthernetReadWriteTest();

	GPIOWrite(0xA4324);
//	ADV7181BTest();		// I2C test

	GPIOWrite(0xA4325);
//	SEIPReadWriteTest();

//	VideoInputTest();
    while(1);
//___________________FPGA test end

	return 0;
}


void fpga1Test()
{
    int i;
	volatile smtUint32 * MAC_SLAVE0 = (volatile smtUint32 *)(AHB0_STARTADDR);    
	volatile smtUint32 * MAC_SLAVE1 = (volatile smtUint32 *)(AHB1_STARTADDR);    
    smtUint32 compVal,data,ramSize=1024;
    
    DPRINTF("AHB SLAVE0 Internal Sram Test Start!!\n");

    for(i=0;i<ramSize;i++)
    {
        data=(i&0xff)<<24|(i&0xfff)<<12|(i&0xfff);
        MAC_SLAVE0[i]=data;       
        //DPRINTF("[%d] data is %x \n",i,data);
    }

    for(i=0;i<ramSize;i++)
    {
        data = SMT_READ(MAC_SLAVE0[i]);
        DPRINTF("[%d] data is %x \n",i,data);
        if(data != ((i&0xff)<<24|(i&0xfff)<<12|(i&0xfff)) )
        {
            DPRINTF("[%d] ERROR\n",i);
            GPIOWrite(0x0000dead);
        }
    }
    DPRINTF("AHB SLAVE_0 Internal Sram Test OK!!\n");

    UartGetch();

    DPRINTF("AHB SLAVE1 Internal Sram Test Start!!\n");
    for(i=0;i<ramSize;i++)
    {
        data=(i&0xff)<<24|(i&0xfff)<<12|(i&0xfff);
        MAC_SLAVE1[i]=data;       
        //DPRINTF("[%d] data is %x \n",i,data);
    }

    for(i=0;i<ramSize;i++)
    {
        data = SMT_READ(MAC_SLAVE1[i]);
        DPRINTF("[%d] data is %x \n",i,data);
        if(data != ((i&0xff)<<24|(i&0xfff)<<12|(i&0xfff)) ) 
        {
            DPRINTF("[%d] ERROR\n",i);
            GPIOWrite(0x0000dead);
        }
    }

    DPRINTF("AHB SLAVE_1 Internal Sram Test OK!!\n");
/*
    for(i=0;i<ramSize;i++)
    {   
        if((i%2)==0) MAC_SLAVE1[i]=0xaabbccdd;       
        else MAC_SLAVE1[i]=0x11223344;
    }
    
    for(i=0;i<ramSize;i++)
    {
        data = SMT_READ(MAC_SLAVE1[i]);
//        DPRINTF("[%d] data is %x \n",i,data);
        if((i%2)==0) compVal=0xaabbccdd;
        else         compVal=0x11223344;

        if(data != compVal){
            GPIOWrite(0x0000dead);
            DPRINTF("[%d] ERROR\n",i);
        }
    }
    DPRINTF("AHB SLAVE_1 Internal Sram Test OK!!\n");
*/
/*    
        MAC_SLAVE0[0]=0x00000000;       
        MAC_SLAVE0[1]=0x11111111;       
        MAC_SLAVE0[2]=0x22222222;       
        MAC_SLAVE0[3]=0x33333333;       
        MAC_SLAVE0[4]=0x44444444;       
    
        data = SMT_READ(MAC_SLAVE0[0]);
        if(data != 0x00000000)
            GPIOWrite(0x00000000);
        else GPIOWrite(0xffffffff);

        data = SMT_READ(MAC_SLAVE0[1]);
        if(data != 0x11111111)
            GPIOWrite(0x11111111);
        else GPIOWrite(0xffffffff);

        data = SMT_READ(MAC_SLAVE0[2]);
        if(data != 0x22222222)
            GPIOWrite(0x22222222);
        else GPIOWrite(0xffffffff);

        data = SMT_READ(MAC_SLAVE0[3]);
        if(data != 0x33333333)
            GPIOWrite(0x33333333);
        else GPIOWrite(0xffffffff);

        data = SMT_READ(MAC_SLAVE0[4]);
        if(data != 0x44444444)
            GPIOWrite(0x44444444);
        else GPIOWrite(0xffffffff);
*/    
}




/*
void MACInterfaceTest()
{
    unsigned int i;

    MACS0_0 = 0x12345678;
    MACS0_1 = 0xaabbccdd;
    MACS0_2 = 0xff00ff00;

    MACS1_0 = 0x12345678;
    MACS1_1 = 0xaabbccdd;
    MACS1_2 = 0xff00ff00;
 
    i = MACS0_0;
    i = MACS0_1;
    i = MACS0_2;

    i = MACS1_0;
    i = MACS1_1;
    i = MACS1_2;
    
}

void PCIInterfaceTest()
{
    unsigned int i;

    PCI0 = 0x12345678;
    PCI1 = 0xaabbccdd;
    PCI2 = 0xff00ff00;

    i = PCI0;
    i = PCI1;
    i = PCI2;
}
*/
/*
static void Menu(void)
{
	char user_input;
	unsigned char *backToMain = "Type '0' to return Menu\n";

	while(1)
	{
		DPRINTF("==== Test Menu ====\n");
		DPRINTF("1. Back Ground Music Play\n");
		DPRINTF("2. Audio Delayed Loop Back\n");
		DPRINTF("3. Video Test\n");
		DPRINTF("4. Interrupt Test\n");

		do {
			user_input = UartGetch();
		} while(user_input < '1' && user_input > '4');

		switch(user_input)
		{
		case '1':
			DPRINTF("Back Ground Music Play Start\n");
			DPRINTF(backToMain);
			BGMTest();
			break;
		case '2':
			DPRINTF("Audio Delayed Loop Back Start\n");
			DPRINTF(backToMain);
			AudioDelayedLoopback();
			break;
		case '3':
			DPRINTF("Video Output Test\n");
			DPRINTF(backToMain);
			VideoTest();
			break;
		case '4':
			DPRINTF("Interrupt Test Start\n");
			DPRINTF(backToMain);
			InterruptTest();
			break;
		}
	}
}
*/
void UndefHandler(unsigned *sp, unsigned spsr, unsigned lr)
{
	int i;
	UartPrintf("Register Dump at 0x%08x(SPSR:0x%08x LR:0x%08x)\n", (unsigned)sp, spsr, lr);
	for(i = 0; i < 15; i++)
		UartPrintf("0x%08x\n", *(sp+i));
}

