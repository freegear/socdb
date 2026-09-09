/* Test basic c functionality.  */

#include "../support/support.h"
#include "../support/spr_defs.h"

int main()
{
	unsigned long SPR_RDATA;
	unsigned long i;
	unsigned long CQStatus;
	unsigned long CBStatus;

// First
	CQStatus=mfspr(SPR_CQSTS);	// Read Command Queue Status, Empty Check
	while (CQStatus != 0x00000000) {
		CQStatus=mfspr(SPR_CQSTS);	// Read Command Queue Status, Empty Check
	}
	SPR_RDATA=mfspr(SPR_CQDAT);		// Read Command Queue Data(Start Address)
	mtspr(SPR_CBRSA, SPR_RDATA); 	// Write Command Buffer Start Address
	mtspr(SPR_CBCON, 0x110);		// Enable Read DMA and Command Buffer Length(16 Double Word)

	asm("l.nop");	// should be applied for First Read ^.^
	asm("l.nop");	
	asm("l.nop");	

	for(i=0;i<32;i++) {				// 32 Word 
		//CBStatus =mfspr(SPR_CBCON);		// Command Buffer Empty Check
		//if (CBStatus == 0x0000000) {
			SPR_RDATA=mfspr(SPR_CBDAT);	// Read Command Buffer Data
		//}
	}

// Second
	//SPR_RDATA=mfspr(SPR_CQSTS);	// Read Command Queue Status, Empty Check
	SPR_RDATA=mfspr(SPR_CQDAT);		// Read Command Queue Data(Start Address)
	mtspr(SPR_CBRSA, SPR_RDATA); 	// Write Command Buffer Start Address
	mtspr(SPR_CBCON, 0x108);		// Enable Read DMA and Command Buffer Length(8 Double Word)

	asm("l.nop");	
	asm("l.nop");	
	asm("l.nop");	

	for(i=0;i<16;i++) {				// 16 Word 
		//CBStatus =mfspr(SPR_CBCON);		// Command Buffer Empty Check
		//if (CBStatus == 0x0000000) {
			SPR_RDATA=mfspr(SPR_CBDAT);	// Read Command Buffer Data
		//}
	}

}
