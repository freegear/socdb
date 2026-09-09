/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: vif.c 
	Description	: Video interface
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"

#include "vif.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define VIF_INT_NUM		0x1

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void ISRVIF(smtUint32 irq);
static smtUint32 VIFOperationTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile static smtUint8 vifIntFlag;


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: VICTest()
	Prototype		: smtUint32 VICTest(void)
	Return			: void
	Argument		:
	Comments		: VIC test routine
-----------------------------------------------------------*/
smtUint32 VIFTest(void)
{
	smtUint32 errCode;

	// TEST1 : Register R/W
	(smtBoolean)errCode = RegisterVIF();

	if (errCode != SMT_SUCCESS)
		return SMT_ERROR;

	// TEST2 : Operation
	#if 0	// TEST2/3 can't auto diagnostic program.
	errCode = VIFOperationTest();
	if(errCode != SMT_SUCCESS)
		return SMT_ERROR;
	#endif

	// TEST3 : Interrupt
	// Interupt test is included in TEST2

	return SMT_SUCCESS;       // Success
}

/*----------------------------------------------------------
	Function name	: VIFOperationTest()
	Prototype		: smtUnit32 VIFOperationTest(void)
	Return			: 0 when Succeed, infinite loop when fail
	Argument		:
	Comments		: VIF operation test
-----------------------------------------------------------*/
static smtUint32 VIFOperationTest(void)
{
	smtUint16 position;

	VIF_CTRL_STRUCT vifData;
	VIF_PROP_STRUCT vifProperty;

	// Don't test automatically.

	// 1. VIF intial setting
	// Set VIF control register
	vifData.ycOrder = 0;
	vifData.startIntEn = 1;	// Start frame int enable	//0;		
	vifData.endIntEn = 1;	// End frame int enable	//0;
	vifData.dmaEn = 0;

	// Configure the position
	vifProperty.vifDmaAddr = 0x0;
	vifProperty.vifXPos = 0x0;
	vifProperty.vifYPos = 0x0;
	vifProperty.vifXSize = 100;
	vifProperty.vifYSize = 100;

	smtVIFSetMode(vifData);
	// 2. YUV order
	smtVIFGetMode(vifData);
	vifData.ycOrder = 1;		// Cb/Y1/Cr/Y0
	smtVIFSetMode(vifData);

	// 3. Operation
	for (position = 0; position < 100; position++)
	{
		vifProperty.vifXPos = position;
		vifProperty.vifYPos = position;
		smtVIFSetProperty(vifProperty);

		RequestIRQ(VIF_INT_NUM, ISRVIF);
		smtVIFStart();

		// Wait until vif interrupt occurs
		while(vifIntFlag == 0)
		{
			;
		}
		vifIntFlag = 0;

		ReleaseIRQ(VIF_INT_NUM);
	}

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: ISRVIF()
	Prototype		: static void ISRVIF(smtUint32 irq)
	Return		:
	Argument	:
	Comments	:
		WDT interrupt handler
----------------------------------------------------------*/
static void ISRVIF(smtUint32 irq)
{
	vifIntFlag += 1;
	AckIRQ(irq);	// VIF interrupt clear
}

