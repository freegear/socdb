//------------------------------------------------------------------------------
/*
*
*    File Name:  ECC.c
*     Revision:  1.0
*         Date:  Jan 20, 2006
*        Email:  nandsupport@micron.com
*      Company:  Micron Technology, Inc.
*
*  Description:  Micron NAND I/O Driver
**
*   Disclaimer:  This software code and all associated documentation, 
*	comments or other information (collectively "Software") is provided 
*	"AS IS" without warranty of any kind. MICRON TECHNOLOGY, INC. 
*	("MTI") EXPRESSLY DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED,
*	INCLUDING BUT NOT LIMITED TO, NONINFRINGEMENT OF THIRD PARTY
*	RIGHTS, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS
*	FOR ANY PARTICULAR PURPOSE. MTI DOES NOT WARRANT THAT THE
*	SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE OPERATION OF
*	THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. FURTHERMORE,
*	MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*	THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS,
*	ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT
*	OF USE OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO
*	EVENT SHALL MTI, ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE
*	LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, 
*	OR SPECIAL DAMAGES (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS
*	OF PROFITS, BUSINESS INTERRUPTION, OR LOSS 
*	OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE THE SOFTWARE,
*	EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
*	Because some jurisdictions prohibit the exclusion or limitation of liability for 
*	consequential or incidental damages, the above limitation may not apply to you.
*
*                Copyright ?2006 Micron Technology, Inc.
*                All rights researved
*
* Rev  Author			Date		Changes
* ---  ---------------	----------	-------------------------------
* 1.0  WW				01/20/2006	Initial release
*/
//------------------------------------------------------------------------------
/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: micro_ecc.c 
	Description	: ecc software module
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#define P1EMask		(1 << 0)
#define P2EMask		(1 << 1)
#define P4EMask		(1 << 2)
#define P8EMask		(1 << 3)
#define P16EMask	(1 << 4)
#define P32EMask	(1 << 5)
#define P64EMask	(1 << 6)
#define P128EMask	(1 << 7)
#define P256EMask	(1 << 8)
#define P512EMask	(1 << 9)
#define P1024EMask	(1 << 10)
#define P2048EMask	(1 << 11)

#define P1OMsk		(1 << 16)
#define P2OMsk		(1 << 17)
#define P4OMsk		(1 << 18)
#define P8OMsk		(1 << 19)
#define P16OMsk		(1 << 20)
#define P32OMsk		(1 << 21)
#define P64OMsk		(1 << 22)
#define P128OMsk	(1 << 23)
#define P256OMsk	(1 << 24)
#define P512OMsk	(1 << 25)
#define P1024OMsk	(1 << 26)
#define P2048OMsk	(1 << 27)

#define TF(value)	(value ? 1 : 0)
		

#define P2048e(a)	(TF(a & P2048EMask)	<< 0 )
#define P2048o(a)	(TF(a & P2048OMsk)	<< 1 )
#define P1e(a)		(TF(a & P1EMask)	<< 2 )
#define P1o(a)		(TF(a & P1OMsk)		<< 3 )
#define P2e(a)		(TF(a & P2EMask)	<< 4 )
#define P2o(a)		(TF(a & P2OMsk)		<< 5 )
#define P4e(a)		(TF(a & P4EMask)	<< 6 )
#define P4o(a)		(TF(a & P4OMsk)		<< 7 )

#define P8e(a)		(TF(a & P8EMask)	<< 0 )
#define P8o(a)		(TF(a & P8OMsk)		<< 1 )
#define P16e(a)		(TF(a & P16EMask)	<< 2 )
#define P16o(a)		(TF(a & P16OMsk)	<< 3 )
#define P32e(a)		(TF(a & P32EMask)	<< 4 )
#define P32o(a)		(TF(a & P32OMsk)	<< 5 )
#define P64e(a)		(TF(a & P64EMask)	<< 6 )
#define P64o(a)		(TF(a & P64OMsk)	<< 7 )

#define P128e(a)	(TF(a & P128EMask)	<< 0 )
#define P128o(a)	(TF(a & P128OMsk)	<< 1 )
#define P256e(a)	(TF(a & P256EMask)	<< 2 )
#define P256o(a)	(TF(a & P256OMsk)	<< 3 )
#define P512e(a)	(TF(a & P512EMask)	<< 4 )
#define P512o(a)	(TF(a & P512OMsk)	<< 5 )
#define P1024e(a)	(TF(a & P1024EMask)	<< 6 )
#define P1024o(a)	(TF(a & P1024OMsk)	<< 7 )

#define P8e_s(a)	(TF(a & P8EMask)	<< 0 )
#define P8o_s(a)	(TF(a & P8OMsk)		<< 1 )
#define P16e_s(a)	(TF(a & P16EMask)	<< 2 )
#define P16o_s(a)	(TF(a & P16OMsk)	<< 3 )
#define P1e_s(a)	(TF(a & P1EMask)	<< 4 )
#define P1o_s(a)	(TF(a & P1OMsk)		<< 5 )
#define P2e_s(a)	(TF(a & P2EMask)	<< 6 )
#define P2o_s(a)	(TF(a & P2OMsk)		<< 7 )

#define P4e_s(a)	(TF(a & P4EMask)	<< 0 )
#define P4o_s(a)	(TF(a & P4OMsk)		<< 1 )

#include "micro_ecc.h"

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "global.h"
#include "nand_pre_drv.h"

extern smtUint32 smt2UARTPrint(smtUint8 uartCh, smtInt8 *format, ...);
#define ECCDPRINTF(f, args...)		 smt2UARTPrint(CFG_UART_CH, f, ##args)
//------------------------------------------------------------------------------
//	mu_count_bits
//	comment : v 32bits 변수의 1bit를 카운트한다. 
//------------------------------------------------------------------------------
u8 mu_count_bits(u32 v)
{
	u8 i, count;

	for(count=i=0; i<32; i++)
		count += (v>>i)&1 ? 1:0;
	return count;
}
//------------------------------------------------------------------------------
//	mu_ecc_correct
//	comment: m(obtain ecc)와 r(cacluated) ecc를 가지고 buf의 값을 정정한다. 
//------------------------------------------------------------------------------
u8 mu_ecc_correct(u32 m, u32 r, u8 *buf)
{
	u16 pe, po, is_ecc_ff;

	is_ecc_ff 	=	((m & 0xFFFFFF) == 0xFFFFFF);
	m 			=	m^r;

	switch (mu_count_bits(m)) 
	{
		case 0: // shall never get there since ecc equal, no call in
			return 0;
			
		case 1: // dont correct
			/*
			if(!gSilent) 
			{
				printf ( "ECC area error. No need to correct.\n");
			}
			*/
			return 0;
			
		case 12: // Correctable ?
			po	= m & 0x0000FFFF;
			pe	= (m>>16) & 0x0000FFFF;
			po	= (pe^po);
			
			if( 0x0FFF == po )
			{
				buf[pe>>3] ^= (1 << (pe&7));
				/*
				if(!gSilent) 
				{
					printf ( "Single bit error: offset: %d, bit: %d\n", 
						pe>>3, pe&7);
				}
				*/
					
				return 0;
			}
			else
			{
				/*
				if(!gSilent) 
				{
					printf( "Uncorrectable error A !! \n");
				}
				*/
					
				//return -1;
				return 0xFF;
			}
			
		default:
			
			if(is_ecc_ff && r == 0)
			{
				return 0;
			}
			
			/*
			if(!gSilent) 
			{
				printf( "Uncorrectable error B !! \n");
			}
			*/
				
			//return -1;
			return 0xFF;
		}
}
//------------------------------------------------------------------------------
//	mu_ecc_generate_512
//	comment : databuf(512byte)을 가지고 eccbuf에 ecc값을 packing한다. 
//------------------------------------------------------------------------------
u8 mu_ecc_generate_512(u8 *eccbuf, u8 *datbuf)
{
	u32 i, j;
	u8	byteParity[512], tmp = 0, tmp2=0;
	u8  parity_LUT[32] = {0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0, /**/ 1,0,0,1,0,1,1,0,0,1,1,0,1,0,0,1};
	u8  sum=0, Pcount = 0;
	u8	Pc0 = 0, Pc1 = 0, Pc2 = 0, Pc3 = 0, Pc4 = 0, Pc5 = 0, Pc6 = 0, Pc7 = 0;
	u8	PE1, PO1, PE2, PO2, PE4, PO4;
	u8	PE8 = 0, PO8 = 0, PE16 = 0, PO16 = 0, PE32 = 0, PO32 = 0;
	u8	PE64 = 0, PO64 = 0, PE128 = 0, PO128 = 0, PE256 = 0, PO256 = 0;
	u8	PE512 = 0, PO512 = 0, PE1024 = 0, PO1024 = 0, PE2048 = 0, PO2048 = 0;

	for( i = 0; i < 512; i++)
	{
		Pcount = Pcount ^ datbuf[i];
		tmp = (datbuf[i] & 0xf0) >> 4;
		tmp2 = datbuf[i] & 0x0f;
		switch(tmp)
		{
			case 0:	
			case 3:	
			case 5:	
			case 6:	
			case 9:	
			case 10: 
			case 12: 
			case 15:
				byteParity[i] = parity_LUT[tmp2]; 
				break;
				
			default:
				byteParity[i] = parity_LUT[tmp2+16]; 
				break;
		}
	}

	Pc0 = ((Pcount & 0x01) ? 1 : 0);
	Pc1 = ((Pcount & 0x02) ? 1 : 0);
	Pc2 = ((Pcount & 0x04) ? 1 : 0);
	Pc3 = ((Pcount & 0x08) ? 1 : 0);
	Pc4 = ((Pcount & 0x10) ? 1 : 0);
	Pc5 = ((Pcount & 0x20) ? 1 : 0);
	Pc6 = ((Pcount & 0x40) ? 1 : 0);
	Pc7 = ((Pcount & 0x80) ? 1 : 0);

	PO1 = Pc6 ^ Pc4 ^ Pc2 ^ Pc0;
	PE1 = Pc7 ^ Pc5 ^ Pc3 ^ Pc1;
	PO2 = Pc5 ^ Pc4 ^ Pc1 ^ Pc0;
	PE2 = Pc7 ^ Pc6 ^ Pc3 ^ Pc2;
	PO4 = Pc3 ^ Pc2 ^ Pc1 ^ Pc0;
	PE4 = Pc7 ^ Pc6 ^ Pc5 ^ Pc4;

	for( i = 0 ; i < 512;i++)	
	{
		sum=sum ^ byteParity[i];
	}

	for ( i = 0; i < 512; i = i+2 )
	{
		PO8 = PO8 ^ byteParity[i];
	}

	for ( i = 0; i < 512; i = i+4 )
	{
		PO16 = PO16 ^ byteParity[i];
		PO16 = PO16 ^ byteParity[i + 1];
	}
	
	for ( i = 0; i < 512; i = i+8 )
	{
		for ( j = 0; j <= 3; j++ )
		{
			PO32 = PO32 ^ byteParity[i+j];
		}
	}
		
	for ( i = 0; i < 512; i = i+16 )
	{
		for ( j = 0; j <= 7; j++ )
		{
			PO64 = PO64 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 512; i = i+32 )
	{
		for ( j = 0; j <= 15; j++ )
		{
			PO128 = PO128 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 512; i = i+64 )
	{
		for ( j = 0; j <= 31; j++ )
		{
			PO256 = PO256 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 512; i = i+128 )
	{
		for ( j = 0; j <= 63; j++ )
		{
			PO512 = PO512 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 512; i = i+256 )
	{
		for ( j = 0; j <= 127; j++ )
		{
			PO1024 = PO1024 ^ byteParity[i+j];
		}
	}

	for ( i = 0; i < 512; i = i+512 )
	{
		for ( j = 0; j <= 255; j++ )
		{
			PO2048 = PO2048 ^ byteParity[i+j];
		}
	}

	if(sum==0)
	{
		PE2048	= PO2048;
		PE1024	= PO1024;
		PE512	= PO512;
		PE256	= PO256;
		PE128	= PO128;
		PE64	= PO64;
		PE32	= PO32;
		PE16	= PO16;
		PE8		= PO8;
		
	} 
	else 
	{
		
		PE2048	= (PO2048 ? 0 : 1);
		PE1024 	= (PO1024 ? 0 : 1);
		PE512  	= (PO512  ? 0 : 1);
		PE256  	= (PO256  ? 0 : 1);
		PE128  	= (PO128  ? 0 : 1);
		PE64   	= (PO64   ? 0 : 1);
		PE32   	= (PO32   ? 0 : 1);
		PE16   	= (PO16   ? 0 : 1);
		PE8    	= (PO8    ? 0 : 1);
	}

	/*
	eccbuf[0]=(PO128 << 7) |(PO64 << 6) |(PO32 << 5) |(PO16 << 4) |(PO8 << 3) |(PO4 << 2) |(PO2 << 1) |(PO1);
	eccbuf[1]=(PE128 << 7) |(PE64 << 6) |(PE32 << 5) |(PE16 << 4) |(PE8 << 3) |(PE4 << 2) |(PE2 << 1) |(PE1);
	eccbuf[2]=(PE2048 << 7) |(PE1024 << 6) |(PE512 << 5) |(PE256 << 4) |(PO2048 << 3) |(PO1024 << 2) |(PO512 << 1) |(PO256);


	{
		
		u8	ecctmp[3];
		u32 tmp = eccbuf[0] | (eccbuf[1] << 16) | ((eccbuf[2] & 0xF0) << 20) | ((eccbuf[2] & 0x0F) << 8);

		ecctmp[0] = ~(P64o(tmp) | P64e(tmp) | P32o(tmp) | P32e(tmp) | P16o(tmp) | P16e(tmp) | P8o(tmp) | P8e(tmp) );
		ecctmp[1] = ~(P1024o(tmp) | P1024e(tmp) | P512o(tmp) | P512e(tmp) | P256o(tmp) | P256e(tmp) | P128o(tmp) | P128e(tmp));
		ecctmp[2] = ~( P4o(tmp) | P4e(tmp) | P2o(tmp) | P2e(tmp) | P1o(tmp) | P1e(tmp) | P2048o(tmp) | P2048e(tmp));
		
		eccbuf[0] = ecctmp[0];
		eccbuf[1] = ecctmp[1];
		eccbuf[2] = ecctmp[2];
		eccbuf[3] = 0x0;
	}
	*/
	{	
		eccbuf[3] = 0;
		eccbuf[2] = ((PO4 << 7) |(PE4 << 6) |(PO2 << 5) |(PE2<< 4) |(PO1 << 3) |(PE1 << 2) |(PO2048 << 1) |(PE2048));
		eccbuf[1] = ((PO1024 << 7) |(PE1024 << 6) |(PO512 << 5) |(PE512 << 4) |(PO256 << 3) |(PE256 << 2) |(PO128 << 1)  |(PE128));
		eccbuf[0] = ((PO64 << 7) |(PE64<< 6) |(PO32<< 5) |(PE32 << 4) |(PO16 << 3) |(PE16 << 2) |(PO8 << 1) |(PE8));

	}

	return 0;
}
//------------------------------------------------------------------------------
//	mu_ecc_generate_256
//	comment : databuf(512byte)을 가지고 eccbuf에 ecc값을 packing한다. 
//------------------------------------------------------------------------------
u8 mu_ecc_generate_256(u8 *eccbuf, u8 *datbuf)
{
	u32 i, j;
	static u8	byteParity[256];
	u8	tmp = 0, tmp2=0;
	u8  parity_LUT[32] = {0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0, /**/ 1,0,0,1,0,1,1,0,0,1,1,0,1,0,0,1};
	u8  sum=0, Pcount = 0;
	u8	Pc0 = 0, Pc1 = 0, Pc2 = 0, Pc3 = 0, Pc4 = 0, Pc5 = 0, Pc6 = 0, Pc7 = 0;
	u8	PE1, PO1, PE2, PO2, PE4, PO4;
	u8	PE8 = 0, PO8 = 0, PE16 = 0, PO16 = 0, PE32 = 0, PO32 = 0;
	u8	PE64 = 0, PO64 = 0, PE128 = 0, PO128 = 0, PE256 = 0, PO256 = 0;
	u8	PE512 = 0, PO512 = 0, PE1024 = 0, PO1024 = 0, PE2048 = 0, PO2048 = 0;

	for( i = 0; i < 256; i++)
	{
		Pcount = Pcount ^ datbuf[i];
		tmp = (datbuf[i] & 0xf0) >> 4;
		tmp2 = datbuf[i] & 0x0f;
		switch(tmp)
		{
			case 0:	
			case 3:	
			case 5:	
			case 6:	
			case 9:	
			case 10: 
			case 12: 
			case 15:
				byteParity[i] = parity_LUT[tmp2]; 
				break;
				
			default:
				byteParity[i] = parity_LUT[tmp2+16]; 
				break;
		}
	}

	Pc0 = ((Pcount & 0x01) ? 1 : 0);
	Pc1 = ((Pcount & 0x02) ? 1 : 0);
	Pc2 = ((Pcount & 0x04) ? 1 : 0);
	Pc3 = ((Pcount & 0x08) ? 1 : 0);
	Pc4 = ((Pcount & 0x10) ? 1 : 0);
	Pc5 = ((Pcount & 0x20) ? 1 : 0);
	Pc6 = ((Pcount & 0x40) ? 1 : 0);
	Pc7 = ((Pcount & 0x80) ? 1 : 0);

	PO1 = Pc6 ^ Pc4 ^ Pc2 ^ Pc0;
	PE1 = Pc7 ^ Pc5 ^ Pc3 ^ Pc1;
	PO2 = Pc5 ^ Pc4 ^ Pc1 ^ Pc0;
	PE2 = Pc7 ^ Pc6 ^ Pc3 ^ Pc2;
	PO4 = Pc3 ^ Pc2 ^ Pc1 ^ Pc0;
	PE4 = Pc7 ^ Pc6 ^ Pc5 ^ Pc4;

	for( i = 0 ; i < 256;i++)	
	{
		sum=sum ^ byteParity[i];
	}

	for ( i = 0; i < 256; i = i+2 )
	{
		PO8 = PO8 ^ byteParity[i];
	}

	for ( i = 0; i < 256; i = i+4 )
	{
		PO16 = PO16 ^ byteParity[i];
		PO16 = PO16 ^ byteParity[i + 1];
	}
	
	for ( i = 0; i < 256; i = i+8 )
	{
		for ( j = 0; j <= 3; j++ )
		{
			PO32 = PO32 ^ byteParity[i+j];
		}
	}
		
	for ( i = 0; i < 256; i = i+16 )
	{
		for ( j = 0; j <= 7; j++ )
		{
			PO64 = PO64 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 256; i = i+32 )
	{
		for ( j = 0; j <= 15; j++ )
		{
			PO128 = PO128 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 256; i = i+64 )
	{
		for ( j = 0; j <= 31; j++ )
		{
			PO256 = PO256 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 256; i = i+128 )
	{
		for ( j = 0; j <= 63; j++ )
		{
			PO512 = PO512 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 256; i = i+256 )
	{
		for ( j = 0; j <= 127; j++ )
		{
			PO1024 = PO1024 ^ byteParity[i+j];
		}
	}

	
	PO2048 = 0;

	if(sum==0)
	{
		PE2048	= PO2048;
		PE1024	= PO1024;
		PE512	= PO512;
		PE256	= PO256;
		PE128	= PO128;
		PE64	= PO64;
		PE32	= PO32;
		PE16	= PO16;
		PE8		= PO8;
		
	} 
	else 
	{
		
		PE2048	= 0;//(PO2048 ? 0 : 1);
		PE1024 	= (PO1024 ? 0 : 1);
		PE512  	= (PO512  ? 0 : 1);
		PE256  	= (PO256  ? 0 : 1);
		PE128  	= (PO128  ? 0 : 1);
		PE64   	= (PO64   ? 0 : 1);
		PE32   	= (PO32   ? 0 : 1);
		PE16   	= (PO16   ? 0 : 1);
		PE8    	= (PO8    ? 0 : 1);
	}

	{	
		eccbuf[3] = 0;
		eccbuf[2] = ((PO4 << 7) |(PE4 << 6) |(PO2 << 5) |(PE2<< 4) |(PO1 << 3) |(PE1 << 2) |(1 << 1) |1);
		eccbuf[1] = ((PO1024 << 7) |(PE1024 << 6) |(PO512 << 5) |(PE512 << 4) |(PO256 << 3) |(PE256 << 2) |(PO128 << 1)  |(PE128));
		eccbuf[0] = ((PO64 << 7) |(PE64<< 6) |(PO32<< 5) |(PE32 << 4) |(PO16 << 3) |(PE16 << 2) |(PO8 << 1) |(PE8));

	}
	/*	
	eccbuf[0]=(PO128 << 7) |(PO64 << 6) |(PO32 << 5) |(PO16 << 4) |(PO8 << 3) |(PO4 << 2) |(PO2 << 1) |(PO1);
	eccbuf[1]=(PE128 << 7) |(PE64 << 6) |(PE32 << 5) |(PE16 << 4) |(PE8 << 3) |(PE4 << 2) |(PE2 << 1) |(PE1);
	eccbuf[2]=(PE2048 << 7) |(PE1024 << 6) |(PE512 << 5) |(PE256 << 4) |(PO2048 << 3) |(PO1024 << 2) |(PO512 << 1) |(PO256);

	{
		
		u8	ecctmp[3];
		u32 tmp = eccbuf[0] | (eccbuf[1] << 16) | ((eccbuf[2] & 0xF0) << 20) | ((eccbuf[2] & 0x0F) << 8);

		ecctmp[0] = ~(P64o(tmp) | P64e(tmp) | P32o(tmp) | P32e(tmp) | P16o(tmp) | P16e(tmp) | P8o(tmp) | P8e(tmp) );
		ecctmp[1] = ~(P1024o(tmp) | P1024e(tmp) | P512o(tmp) | P512e(tmp) | P256o(tmp) | P256e(tmp) | P128o(tmp) | P128e(tmp));
		ecctmp[2] = ~( P4o(tmp) | P4e(tmp) | P2o(tmp) | P2e(tmp) | P1o(tmp) | P1e(tmp) | P2048o(tmp) | P2048e(tmp));
		
		eccbuf[0] = ecctmp[0];
		eccbuf[1] = ecctmp[1];
		eccbuf[2] = ecctmp[2];
		eccbuf[3] = 0x0;
	}
	*/
	
	return 0;
}
//------------------------------------------------------------------------------
//	mu_ecc_generate_256
//	comment : databuf(512byte)을 가지고 eccbuf에 ecc값을 packing한다. 
//------------------------------------------------------------------------------
u8 mu_ecc_generate_3(u8 *eccbuf, u8 *datbuf)
{
	u32 i, j;
	static u8	byteParity[256];
	u8  tmp = 0, tmp2=0;
	u8  parity_LUT[32] = {0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0, /**/ 1,0,0,1,0,1,1,0,0,1,1,0,1,0,0,1};
	u8  sum=0, Pcount = 0;
	u8	Pc0 = 0, Pc1 = 0, Pc2 = 0, Pc3 = 0, Pc4 = 0, Pc5 = 0, Pc6 = 0, Pc7 = 0;
	u8	PE1 = 0, PO1 = 0, PE2 = 0, PO2 = 0, PE4 = 0, PO4 = 0;
	u8	PE8 = 0, PO8 = 0, PE16 = 0, PO16 = 0, PE32 = 0, PO32 = 0;
	u8	PE64 = 0, PO64 = 0, PE128 = 0, PO128 = 0, PE256 = 0, PO256 = 0;
	u8	PE512 = 0, PO512 = 0, PE1024 = 0, PO1024 = 0, PE2048 = 0, PO2048 = 0;

	/*
	for(i = 0; i < 32; i++) 
		smt2UARTPrint(CFG_UART_CH, "[%d]%d\n", i, parity_LUT[i]);
		*/
		
	for( i = 0; i < 3; i++)
	{
		Pcount = Pcount ^ datbuf[i];
		tmp = (datbuf[i] & 0xf0) >> 4;
		tmp2 = datbuf[i] & 0x0f;
		switch(tmp)
		{
			case 0:	
			case 3:	
			case 5:	
			case 6:	
			case 9:	
			case 10: 
			case 12: 
			case 15:
				byteParity[i] = parity_LUT[tmp2]; 
				break;
				
			default:
				byteParity[i] = parity_LUT[tmp2+16]; 
				break;
		}
	}

	Pc0 = ((Pcount & 0x01) ? 1 : 0);
	Pc1 = ((Pcount & 0x02) ? 1 : 0);
	Pc2 = ((Pcount & 0x04) ? 1 : 0);
	Pc3 = ((Pcount & 0x08) ? 1 : 0);
	Pc4 = ((Pcount & 0x10) ? 1 : 0);
	Pc5 = ((Pcount & 0x20) ? 1 : 0);
	Pc6 = ((Pcount & 0x40) ? 1 : 0);
	Pc7 = ((Pcount & 0x80) ? 1 : 0);

	PO1 = Pc6 ^ Pc4 ^ Pc2 ^ Pc0;
	PE1 = Pc7 ^ Pc5 ^ Pc3 ^ Pc1;
	PO2 = Pc5 ^ Pc4 ^ Pc1 ^ Pc0;
	PE2 = Pc7 ^ Pc6 ^ Pc3 ^ Pc2;
	PO4 = Pc3 ^ Pc2 ^ Pc1 ^ Pc0;
	PE4 = Pc7 ^ Pc6 ^ Pc5 ^ Pc4;

	for( i = 0 ; i < 3;i++)	
	{
		sum=sum ^ byteParity[i];
	}

	for ( i = 0; i < 3; i = i+2 )
	{
		PO8 = PO8 ^ byteParity[i];
	}

	for ( i = 0; i < 3; i = i+4 )
	{
		PO16 = PO16 ^ byteParity[i];
		PO16 = PO16 ^ byteParity[i + 1];
	}
	
	for ( i = 0; i < 3; i = i+8 )
	{
		for ( j = 0; j <= 3; j++ )
		{
			PO32 = PO32 ^ byteParity[i+j];
		}
	}
		
	for ( i = 0; i < 3; i = i+16 )
	{
		for ( j = 0; j <= 7; j++ )
		{
			PO64 = PO64 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 3; i = i+32 )
	{
		for ( j = 0; j <= 15; j++ )
		{
			PO128 = PO128 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 3; i = i+64 )
	{
		for ( j = 0; j <= 31; j++ )
		{
			PO256 = PO256 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 3; i = i+128 )
	{
		for ( j = 0; j <= 63; j++ )
		{
			PO512 = PO512 ^ byteParity[i+j];
		}
	}
	
	for ( i = 0; i < 3; i = i+256 )
	{
		for ( j = 0; j <= 127; j++ )
		{
			PO1024 = PO1024 ^ byteParity[i+j];
		}
	}

	
	PO2048  = 0;
	PO2048	= 0;
	PO1024	= 0;
	PO512	= 0;
	PO256	= 0;
	PO128	= 0;
	PO64	= 0;
	PO32	= 0;
	
	if(sum==0)
	{
		PE2048	= PO2048;
		PE1024	= PO1024;
		PE512	= PO512;
		PE256	= PO256;
		PE128	= PO128;
		PE64	= PO64;
		PE32	= PO32;
		PE16	= PO16;
		PE8		= PO8;
		
	} 
	else 
	{
		
		PE2048	= 0;//(PO2048 ? 0 : 1);
		PE1024 	= 0;
		PE512  	= 0;
		PE256  	= 0;
		PE128  	= 0;
		PE64   	= 0;
		PE32   	= 0;
		PE16   	= (PO16   ? 0 : 1);
		PE8    	= (PO8    ? 0 : 1);
	}


	
	{
		
		
		eccbuf[3] = 0x0;
		eccbuf[2] = 0x0;
		eccbuf[1] = ((1 << 7) |(1 << 6) |(1 << 5) |(1 << 4) |(1 << 3) |(1 << 2) |(PO4 << 1)  |(PE4));
		eccbuf[0] = ((PO2 << 7) |(PE2<< 6) |(PO1<< 5) |(PE1 << 4) |(PO16 << 3) |(PE16 << 2) |(PO8 << 1) |(PE8));

	}
	
	/*
	eccbuf[0]=(PO128 << 7) |(PO64 << 6) |(PO32 << 5) |(PO16 << 4) |(PO8 << 3) |(PO4 << 2) |(PO2 << 1) |(PO1);
	eccbuf[1]=(PE128 << 7) |(PE64 << 6) |(PE32 << 5) |(PE16 << 4) |(PE8 << 3) |(PE4 << 2) |(PE2 << 1) |(PE1);
	eccbuf[2]=(PE2048 << 7) |(PE1024 << 6) |(PE512 << 5) |(PE256 << 4) |(PO2048 << 3) |(PO1024 << 2) |(PO512 << 1) |(PO256);

	{
		
		u8	ecctmp[3];
		u32 tmp = eccbuf[0] | (eccbuf[1] << 16) | ((eccbuf[2] & 0xF0) << 20) | ((eccbuf[2] & 0x0F) << 8);

		ecctmp[0] = ~(P64o(tmp) | P64e(tmp) | P32o(tmp) | P32e(tmp) | P16o(tmp) | P16e(tmp) | P8o(tmp) | P8e(tmp) );
		ecctmp[1] = ~(P1024o(tmp) | P1024e(tmp) | P512o(tmp) | P512e(tmp) | P256o(tmp) | P256e(tmp) | P128o(tmp) | P128e(tmp));
		ecctmp[2] = ~( P4o(tmp) | P4e(tmp) | P2o(tmp) | P2e(tmp) | P1o(tmp) | P1e(tmp) | P2048o(tmp) | P2048e(tmp));
		
		eccbuf[0] = ecctmp[0];
		eccbuf[1] = ecctmp[1];
		eccbuf[2] = ecctmp[2];
		eccbuf[3] = 0x0;
	}
	*/
	
	return 0;
}