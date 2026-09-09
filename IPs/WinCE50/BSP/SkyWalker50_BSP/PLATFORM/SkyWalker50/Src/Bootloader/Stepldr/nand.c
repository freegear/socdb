#include <windows.h>
#include "skywalkeraddr.h"
#include "option.h"

#define NF_CMD(cmd)	    {rNFCMD=cmd;}
#define NF_ADDR(addr)	  {rNFADDR=addr;}	

#if 1		// for SMT926aNAND
//  For flash chip that is bigger than 32 MB, we need to have 4 step address
#define NEED_EXT_ADDR               1

#define NF_nFCE_L()	        {rNFCONT &= ~(1 << 1);}
#define NF_nFCE_H()	        {rNFCONT |=  (1 << 1);}
#define NF_RSTECC()	        {rNFCONT |=  (1 << 4);}

#define NF_MECC_UnLock()	{rNFCONT &= ~(1<<5);}
#define NF_MECC_Lock()		{rNFCONT |= (1<<5);}

#define NF_CLEAR_RB()		{rNFSTAT |=  (1 << 2);}
#define NF_DETECT_RB()		{while(!(rNFSTAT&(1<<2)));}
#define NF_WAITRB()         {while (!(rNFSTAT & (1 << 2)));} 

#else

#define NF_nFCE_L()	    {rNFCONT&=~(1<<1);}
#define NF_nFCE_H()	    {rNFCONT|=(1<<1);}
#define NF_RSTECC()	    {rNFCONT|=(1<<4);}
#define NF_WAITRB()     {while(!(rNFSTAT&(1<<0)));} 

#endif

#define NF_RDDATA() 	   (rNFDATA)
#define NF_RDDATA32() 	   (rNFDATA32)
#define NF_WRDATA(data) 	{rNFDATA=data;}

#define NF_RDMECC0()			(rNFMECC0)
#define NF_RDMECC1()			(rNFMECC1)

#define NF_RDMECCD0()			(rNFMECCD0)
#define NF_RDMECCD1()			(rNFMECCD1)

#define NF_WRMECCD0(data)			{rNFMECCD0 = (data);}
#define NF_WRMECCD1(data)			{rNFMECCD1 = (data);}


#define ID_K9S1208V0M	  0xec76

// HCLK=133Mhz
#define TACLS		7//0    //0  //1clk(0ns) 
#define TWRPH0		7//6    //2  //3clk(25ns)
#define TWRPH1		7//2    //0  //1clk(10ns)  //TACLS+TWRPH0+TWRPH1>=50ns

void __RdPage512(BYTE *bufPt); 


int NF_ReadPage(UINT32 block,UINT32 page,UINT8 *buffer)
{
    volatile int i;
    register UINT8 * bufPt=buffer;
    unsigned int blockPage;
	ULONG MECC;

    blockPage=(block<<5)+page;
    NF_RSTECC();    // Initialize ECC
	NF_MECC_UnLock();
    
    NF_nFCE_L();    
    NF_CMD(0x00);   // Read command
    NF_ADDR(0);	    // Column = 0
    NF_ADDR(blockPage&0xff);	    //
    NF_ADDR((blockPage>>8)&0xff);   // Block & Page num.
    NF_ADDR((blockPage>>16)&0xff);  //

    for(i=0 ; i<50 ; i++); //wait tWB(100ns)
    
    NF_WAITRB();    // Wait tR(max 12us)

    __RdPage512(bufPt);
	NF_MECC_Lock();

	MECC = NF_RDDATA32();
	MECC = NF_RDDATA32();
	    
    MECC = NF_RDDATA32();
    NF_WRMECCD0( ((MECC&0xff00    )<<8) |  (MECC&0xff    )      );
    NF_WRMECCD1( ((MECC&0xff000000)>>8) | ((MECC&0xff0000)>>16) );
    NF_nFCE_H();    

	if(rNFESTAT0 & 0x3)
	{
		Uart_SendString("ECC ERROR block");
		Uart_SendDWORD(block,0);
		Uart_SendString("page");
		Uart_SendDWORD(page,1);
		return 0;
	}
	else
		return 1;

}


void NF_Reset(void)
{
    volatile int i;
   
    NF_nFCE_L();

    NF_CMD(0xFF);              // reset command.

    for(i=0 ; i<10 ; i++);     // tWB = 100ns. 

    NF_WAITRB();               // wait 200~500us.
     
    NF_nFCE_H();
}


void NF_Init(void)
{

    rNFCONF = (TACLS  <<  12) | /* CLE & ALE = HCLK * (TACLS  + 1)   */
                          (TWRPH0 <<  8) | /* TWRPH0    = HCLK * (TWRPH0 + 1)   */
                          (TWRPH1 <<  4) |
						  (0<<0);

    rNFCONT = (0<<13)|(0<<12)|(0<<10)|(0<<9)|(0<<8)|(0<<6)|(0<<5)|(1<<4)|(1<<1)|(1<<0);
	rNFSTAT = 0x4;
    NF_Reset();
}
