/*----------------------------------------------------------
	File Name   : apimmc.c 
	Description : MMCSD test code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "mmcsd.h"
#include "global.h"
#include "dmac.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

// register MAP
#define SPI_BASEADDR			(APB1_STARTADDR+0x3000)
#define SPICON				(*(volatile unsigned *)(SPI_BASEADDR+0x000))
#define SPIPRE				(*(volatile unsigned *)(SPI_BASEADDR+0x004))
#define SPISTA				(*(volatile unsigned *)(SPI_BASEADDR+0x008))
#define SPIINTDMA			(*(volatile unsigned *)(SPI_BASEADDR+0x00C))
#define SPIINTSTA			(*(volatile unsigned *)(SPI_BASEADDR+0x010))
#define SPITXDAT			(*(volatile unsigned *)(SPI_BASEADDR+0x014))
#define SPIRXDAT			(*(volatile unsigned *)(SPI_BASEADDR+0x018))
// This Hidden register (confidential)
#define SPIHIDDEN			(*(volatile unsigned *)(SPI_BASEADDR+0x01C))


// SPICON register
#define SPIENABLE			(0x1Ul)<<3
#define	MS					(0x1Ul)<<2
#define CPOL				(0x1Ul)<<1
#define	CPHA				(0x1Ul)<<0

// SPIPRE register
#define	SPIPRESCALER		(0xffUl)<<0
#define SPIDIVIDER			(0xffUl)<<8
	// PCLK/(SPIDIVIDE*(SPIRESCALER+1))

// SPISTA register
#define SPITXFIFOFULL		(0x1Ul)<<5
#define SPITXFIFOEMPTY		(0x1Ul)<<4
#define SPIRXFIFOFULL		(0x1Ul)<<3
#define SPIRXFIFOEMPTY		(0x1Ul)<<2
#define SPIBUSY				(0x1Ul)<<1
#define	SPIERROR			(0x1Ul)<<0

// SPIINTDMA
#define SPITXFINTEN			(0x1Ul)<<13
#define SPIRXFINTEN			(0x1Ul)<<12
#define SPIRXTOUTINTEN		(0x1Ul)<<11
#define SPIRXFOVRINTEN		(0x1Ul)<<10
#define SPITXDMAREQEN		(0x1Ul)<<9
#define SPITXDMALEVEL		(0xFUl)<<5
#define SPIRXDMAREQEN		(0x1Ul)<<4
#define SPIRXDMALEVEL		(0xFUl)<<0

// SPIINTSTA
#define RTIC				(0x1Ul)<<5
#define RORIC				(0x1Ul)<<4
#define TXFIFOINTSTA		(0x1Ul)<<3
#define RXFIFOINTSTA		(0x1Ul)<<2
#define RXTOUTINTSTA		(0x1Ul)<<1
#define RXOVRINTSTA			(0x1Ul)<<0

// SPITXDAT
#define TXDAT				(0xFFFFUl)<<0

// SPIRXDAT
#define	RXDAT				(0xFFFFUl)<<0

// SPIHIDDEN
#define DATASIZE			(0xFUl)<<4
#define	MODE				(0x3Ul)<<2
#define	SLAVEOEN			(0x1Ul)<<1
#define	LBM					(0x1Ul)<<0

// SPI DMA Channel
#define SPIRXDMACH			0 			// DMAREQ0
#define SPITXDMACH			1			// DMAREQ1


#define IncAdrType			1
#define NoIncAdrType		0
#define WidthBYTE			0x0
#define WidthHWORD			0x1
#define WidthWORD			0x2
#define TSize1B				0x0
#define TSize2B				0x1
#define TSize4B				0x2
#define TSize8B				0x3
#define TSize16B			0x4
#define TSize32B			0x5


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */



/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : SPITest()
    Prototype       : smtUint32 SPITest(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/





