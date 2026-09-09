/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : lcdpredrv.c 
	Description : lcd pre-layer driver
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "lcd_pre_drv.h"

/*------------------------------------------------------------------------------
    Function name   : smtDMSetMasterCtrl
    Prototype       : void smtDMSetMasterCtrl(DMCtrl maCtrl)
    Return          : none
    Argument        : none
    Comments        : 
                set LCD Controller mode
------------------------------------------------------------------------------*/
void smtDMSetMasterCtrl(DMCtrl *pMaCtrl)
{
	SMT_WRITE(
			DMCON,
			  ( ( pMaCtrl->swReset		& 0x1 ) << 7 )	
			 |( ( pMaCtrl->prioritySel	& 0x1 ) << 3 )
 			 |( ( pMaCtrl->errIntEn		& 0x1 ) << 2 )
			 |( ( pMaCtrl->startIntEn	& 0x1 ) << 1 )
			 |( ( pMaCtrl->endIntEn		& 0x1 ) << 0 )
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetMasterCtrl
    Prototype       : void smtDMGetMasterCtrl(DMCtrl *pMaCtrl)
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetMasterCtrl(DMCtrl *pMaCtrl)
{
	smtUint32 Register = SMT_READ(DMCON);

	pMaCtrl->prioritySel	= ( ( Register >> 3 ) & 0x1 );
	pMaCtrl->errIntEn		= ( ( Register >> 2 ) & 0x1 );
	pMaCtrl->startIntEn		= ( ( Register >> 1 ) & 0x1 );
	//pMaCtrl->swReset		= ( ( Register >> 0 ) & 0x1 );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetMasterStatus
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetMasterStatus(DMStatus *pMaStat)
{
	smtUint32 Register = SMT_READ(DMSTS);

	pMaStat->evenFieldInt	= ( Register >>  15 ) & 0x1;
	pMaStat->cDmaFifoErr	= ( Register >>  8  ) & 0x1;
	pMaStat->gDmaFifoErr	= ( Register >>  7  ) & 0x1;
	pMaStat->vDmaFifoErr	= ( Register >>  6  ) & 0x1;
	pMaStat->cFifoErr		= ( Register >>  5  ) & 0x1;
	pMaStat->gFifoErr		= ( Register >>  4  ) & 0x1;
	pMaStat->vFifoErr		= ( Register >>  3  ) & 0x1;
	pMaStat->mixFifoErr		= ( Register >>  2  ) & 0x1;
	pMaStat->startFrame		= ( Register >>  1  ) & 0x1;
	pMaStat->endFrame		= ( Register >>  0  ) & 0x1;
	
}

//CURSOR PLANE
/*------------------------------------------------------------------------------
    Function name   : smtDMSetCCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCCtrl(DMPlaneCtrl *pCtrl)
{
	SMT_WRITE(
			CCON,
			  ( (pCtrl->xEn		& 0x1	) <<	31 )
			 |( (pCtrl->pixFmt	& 0x3	) <<	27 )
			 |( (pCtrl->sWidth	& 0x3FF	) <<	11 )
			 |( (pCtrl->sHeight	& 0x3FF	) <<	0  )
		);	
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetCCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCCtrl(DMPlaneCtrl *pCtrl)
{
	smtUint32 Register = SMT_READ(CCON);
	pCtrl->xEn		= ( ( Register >> 31 ) & 0x1  );
	pCtrl->pixFmt	= ( ( Register >> 27 ) & 0x3  );
	pCtrl->sWidth	= ( ( Register >> 11 ) & 0x3FF);
	pCtrl->sHeight	= ( ( Register >>  0 ) & 0x3FF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetCBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCBlndMode(DMPlaneBlndMode *pBlndMode)
{
	SMT_WRITE(
			CBMOD,
			  ( (pBlndMode->colKeyEn	& 0x1	) << 30 )
			 |( (pBlndMode->blendMod	& 0x3	) << 27 )
			 |( (pBlndMode->xPos		& 0x7FF	) << 11 )
			 |( (pBlndMode->yPos		& 0x7FF	) << 0 )
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetCBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCBlndMode(DMPlaneBlndMode *pBlndMode)
{
	smtUint32 Register = SMT_READ(CBMOD);
	pBlndMode->colKeyEn  = ( ( Register >> 30 ) & 0x1	);
	pBlndMode->blendMod  = ( ( Register >> 27 ) & 0x3	);
	pBlndMode->xPos		 = ( ( Register >> 11 ) & 0x7FF	);
	pBlndMode->yPos		 = ( ( Register >> 0  ) & 0x7FF	);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetCBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCBlnd(DMPlaneBlnd *pBlnd)
{
	SMT_WRITE(
			CBLND,
			  ( ( pBlnd->alpha	& 0xFF     ) <<	24 )
			 |( ( pBlnd->colKey	& 0xFFFFFF ) <<  0 )
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetCBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCBlnd(DMPlaneBlnd *pblnd)
{
	smtUint32 Register = SMT_READ(CBLND);
	pblnd->alpha = 	( ( Register >> 24 ) & 0xFF		);
	pblnd->colKey = ( ( Register >>  0 ) & 0xFFFFFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetCBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCBase(smtUint16 planeXRef)
{
	SMT_WRITE(
			CBASE,
			  (planeXRef & 0x7FF ) << 0 
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetCBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCBase(smtUint16 *pPlaneXRef)
{
	*pPlaneXRef = (smtUint16)(SMT_READ(CBASE) & 0x7FF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetCAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCAddr(smtUint32 addr)
{
	SMT_WRITE(CADDR, addr);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetCAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCAddr(smtUint32 *pAddr)
{
	*pAddr = (smtUint32)SMT_READ(CADDR);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetCPalette(DMPlanePalette *pPalette)
{
	SMT_WRITE(
			CPALADDR,
			  ( (pPalette->palAddr & 0xFF    ) << 0  )
		);

	SMT_WRITE(
			CPALM,
			 ( (pPalette->palData & 0xFFFFFFFF) <<  0 )
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetCPalette(DMPlanePalette *pPalette)
{
	smtUint32 Register = SMT_READ(CPALM);
	pPalette->palAddr	= ( ( Register >> 24 ) & 0xFF    );
	pPalette->palData	= ( ( Register >>  0 ) & 0xFFFFFF);
}

//GRAPHIC PLANE
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGCtrl(DMPlaneCtrl *pCtrl)
{
	SMT_WRITE(
			GCON,
			  ( (pCtrl->xEn				& 0x1  ) << 31 )
			 |( (pCtrl->gColBarEn		& 0x1  ) << 30 )
			 |( (pCtrl->pixFmt			& 0x7  ) << 27 )
			 |( (pCtrl->gammaEn			& 0x1  ) << 26 )
			 |( (pCtrl->vPlaneN2PUpEn	& 0x1  ) << 25 )
			 |( (pCtrl->sWidth			& 0x7FF) << 11 )
			 |( (pCtrl->sHeight			& 0x7FF) <<  0 )
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGCtrl(DMPlaneCtrl *pCtrl)
{
	smtUint32 Register = SMT_READ(GCON);
	pCtrl->xEn				= ( ( Register >> 31 ) & 0x1  );
	pCtrl->gColBarEn		= ( ( Register >> 30 ) & 0x1  );
	pCtrl->pixFmt			= ( ( Register >> 27 ) & 0x7  );
	pCtrl->gammaEn			= ( ( Register >> 26 ) & 0x1  );
	pCtrl->vPlaneN2PUpEn	= ( ( Register >> 25 ) & 0x1  );
	pCtrl->sWidth			= ( ( Register >> 11 ) & 0x7FF);
	pCtrl->sHeight			= ( ( Register >>  0 ) & 0x7FF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGBlndMode(DMPlaneBlndMode *pBlndMode)
{
	SMT_WRITE(
			GBMOD,
			  ( (pBlndMode->colKeyEn	& 0x1 	) << 30 )
			 |( (pBlndMode->blendMod	& 0x3 	) << 27 )
 			 |( (pBlndMode->xPos		& 0x7FF	) << 11 )
			 |( (pBlndMode->yPos		& 0x7FF	) << 0  )

		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGBlndMode(DMPlaneBlndMode *pBlndMode)
{
	smtUint32 Register = SMT_READ(GBMOD);
	pBlndMode->colKeyEn	 = ( ( Register >> 30 ) & 0x1 );
	pBlndMode->blendMod	 = ( ( Register >> 27 ) & 0x3 );
	pBlndMode->xPos		 = ( ( Register >> 11 ) & 0x7FF	);
	pBlndMode->yPos		 = ( ( Register >> 0  ) & 0x7FF	);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGBlnd(DMPlaneBlnd *pblnd)
{
	SMT_WRITE(
			GBLND,
			  ( (pblnd->alpha	& 0xFF     ) <<	24 )
			 |( (pblnd->colKey	& 0xFFFFFF ) <<  0 )
		);		
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGBlnd(DMPlaneBlnd *pblnd)
{
	smtUint32 Register = SMT_READ(GBLND);
	pblnd->alpha = ( ( Register >> 24 ) & 0xFF		);
	pblnd->colKey = ( ( Register >>  0 ) & 0xFFFFFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGBase(smtUint16 planeXRef)
{
	SMT_WRITE(
			GBASE,
			  (planeXRef & 0xFFF ) << 0 
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGBase(smtUint16 *pPlaneXRef)
{
	*pPlaneXRef = (smtUint16)(SMT_READ(GBASE) & 0xFFF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGAddr(smtUint32 addr)
{
	SMT_WRITE(GADDR, addr);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGAddr(smtUint32 *pAddr)
{
	*pAddr = (smtUint32)SMT_READ(GADDR);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGGamma
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGGamma(smtUint8 idx, smtUint32 gammaVal)
{
	SMT_WRITE(GGAMMAXX(idx),gammaVal);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGGamma
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGGamma(smtUint8 idx, smtUint32 *pGammaVal)
{
	*pGammaVal = SMT_READ(GGAMMAXX(idx));
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetGPalette(DMPlanePalette *pPalette)
{
	SMT_WRITE(
			GPALADDR,
			  ( (pPalette->palAddr & 0xFF    ) << 0  )
		);

	SMT_WRITE(
			GPALM,
			 ( (pPalette->palData & 0xFFFFFFFF) <<  0 )
		);

}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGPalette
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetGPalette(DMPlanePalette *pPalette)
{
	smtUint32 Register = SMT_READ(GPALM);
	pPalette->palAddr	= ( ( Register >> 24 ) & 0xFF    );
	pPalette->palData	= ( ( Register >>  0 ) & 0xFFFFFF);
}

//VIDEO PLANE
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVCtrl(DMPlaneCtrl *pCtrl)
{
	SMT_WRITE(
			VCON,
			  ( (pCtrl->xEn				& 0x1  ) << 31 )
			 |( (pCtrl->vPlaneIFEn		& 0x1  ) << 30 )
			 |( (pCtrl->vPlaneN2PUpEn	& 0x1  ) << 29 )
			 |( (pCtrl->pixFmt			& 0x3  ) << 27 )
			 |( (pCtrl->gammaEn			& 0x1  ) << 26 )
			 |( (pCtrl->sWidth			& 0x7FF) << 11 )
			 |( (pCtrl->sHeight			& 0x7FF) <<  0 )
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVCtrl(DMPlaneCtrl *pCtrl)
{
	smtUint32 Register = SMT_READ(VCON);
	pCtrl->xEn			= ( ( Register >> 31 ) & 0x1  );
	pCtrl->vPlaneIFEn	= ( ( Register >> 30 ) & 0x1  );
	pCtrl->vPlaneN2PUpEn= ( ( Register >> 29 ) & 0x1  );
	pCtrl->pixFmt		= ( ( Register >> 27 ) & 0x3  );
	pCtrl->gammaEn		= ( ( Register >> 26 ) & 0x1  );
	pCtrl->sWidth		= ( ( Register >> 11 ) & 0x7FF);
	pCtrl->sHeight		= ( ( Register >>  0 ) & 0x7FF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVBlndMode(DMPlaneBlndMode *pBlndMode)
{
	SMT_WRITE(
			VBMOD,
			  ( (pBlndMode->colKeyEn	& 0x1 )		 << 30 )
			 |( (pBlndMode->blendMod	& 0x3 )		 << 27 )
 			 |( (pBlndMode->xPos		& 0x7FF	)	 << 11 )
			 |( (pBlndMode->yPos		& 0x7FF	)	 << 0  )
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVBlndMode
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVBlndMode(DMPlaneBlndMode *pBlndMode)
{
	smtUint32 Register = SMT_READ(VBMOD);
	pBlndMode->colKeyEn	 = ( ( Register >> 30 ) & 0x1 );
	pBlndMode->blendMod	 = ( ( Register >> 27 ) & 0x7 );
	pBlndMode->xPos		 = ( ( Register >> 11 ) & 0x7FF	);
	pBlndMode->yPos		 = ( ( Register >> 0  ) & 0x7FF	);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVBlnd(DMPlaneBlnd *pblnd)
{
	SMT_WRITE(
			VBLND,
			  ( (pblnd->alpha	& 0xFF     ) <<	24 )
			 |( (pblnd->colKey	& 0xFFFFFF ) <<  0 )
		);		
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVBlnd
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVBlnd(DMPlaneBlnd *pblnd)
{
	smtUint32 Register = SMT_READ(VBLND);
	pblnd->alpha = ( ( Register >> 24 ) & 0xFF		);
	pblnd->colKey = ( ( Register >>  0 ) & 0xFFFFFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetGBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVBase(smtUint16 planeXRef)
{
	SMT_WRITE(
			VBASE,
			  (planeXRef & 0xFFF ) << 0 
		);			 
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetGBase
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVBase(smtUint16 *pPlaneXRef)
{
	*pPlaneXRef = (smtUint16)(SMT_READ(VBASE) & 0xFFF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVAddr(smtUint32 addr)
{
	SMT_WRITE(VADDR, addr);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVAddr
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVAddr(smtUint32 *pAddr)
{
	*pAddr = (smtUint32)SMT_READ(VADDR);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVAddr2
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVAddr2(smtUint32 addr2)
{
	SMT_WRITE(VADDR2, addr2);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVAddr2
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVAddr2(smtUint32 *pAddr2)
{
	*pAddr2 = (smtUint32)SMT_READ(VADDR2);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVGamma
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVGamma(smtUint8 idx , smtUint32 gammaVal)
{
	SMT_WRITE(VGAMMAXX(idx), gammaVal);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVGamma
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVGamma(smtUint8 idx, smtUint32 *pGammaVal)
{
	*pGammaVal = SMT_READ(VGAMMAXX(idx));
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetBGCol
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetBGCol(smtUint32 colour)
{
	SMT_WRITE(BGCOL, colour);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetBGCol
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetBGCol(smtUint32 *pColour)
{
	*pColour = (smtUint32)( SMT_READ(BGCOL) & 0xFFFFFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetLCDCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetLCDCtrl(DMLcdCtrl *pCtrl)
{
	SMT_WRITE(
			LCDCON,(\
			 ((pCtrl->lcdEn  		& 0x1)<<31)	|((pCtrl->lcdPwrEn		&0x1)<<30)\
			|((pCtrl->lcdBpp 		& 0x3)<< 8)	|((pCtrl->rbSwap 		& 0x1)<< 7)\
			|((pCtrl->invertWrEn	& 0x1)<<6)	|((pCtrl->invertVSync 	& 0x1)<<5)\
			|((pCtrl->invertHSync	& 0x1)<<4)	|((pCtrl->invertPixClk	& 0x1)<<3)\
			|((pCtrl->pDiv			& 0x7)<<0))
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetLCDCtrl
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetLCDCtrl(DMLcdCtrl *pCtrl)
{
	smtUint32 Register = SMT_READ(LCDCON);
	pCtrl->lcdEn	= ( ( Register >> 31 ) & 0x1 );
	pCtrl->lcdPwrEn		= ( ( Register >> 30 ) & 0x1 );
	pCtrl->lcdBpp		= ( ( Register >>  8 ) & 0x3 );
	pCtrl->rbSwap		= ( ( Register >>  7 ) & 0x1 );
	pCtrl->invertWrEn	= ( ( Register >>  6 ) & 0x1 );
	pCtrl->invertVSync	= ( ( Register >>  5 ) & 0x1 );
	pCtrl->invertHSync	= ( ( Register >>  4 ) & 0x1 );
	pCtrl->invertPixClk	= ( ( Register >>  3 ) & 0x1 );
	pCtrl->pDiv			= ( ( Register >>  0 ) & 0x7 );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetHSync0
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetHSync0(DMHSync0Ctrl *pHSync0)
{
	SMT_WRITE(
			HSYNC0,
			 ( ( pHSync0->tHBackPorch		& 0xFF ) << 8)
			|( ( pHSync0->tHFrontPorch		& 0xFF ) << 0)
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetHSync0
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetHSync0(DMHSync0Ctrl *pHSync0)
{
	smtUint32 Register = SMT_READ(HSYNC0);
	pHSync0->tHBackPorch	= ( ( Register >> 8 ) & 0xFF );
	pHSync0->tHFrontPorch	= ( ( Register >> 0 ) & 0xFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetHSync1
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetHSync1(DMHSync1Ctrl *pHSync1)
{
	SMT_WRITE(
			HSYNC1,
			 ( ( pHSync1->tHPulsWidth		& 0xFF ) << 11)
			|( ( pHSync1->tHDspPixPerLine	& 0x7FF) <<  0)
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetHSync1
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetHSync1(DMHSync1Ctrl *pHSync1)
{
	smtUint32 Register = SMT_READ(HSYNC1);
	pHSync1->tHPulsWidth		= ( ( Register >> 11 ) & 0xFF );
	pHSync1->tHDspPixPerLine	= ( ( Register >>  0 ) & 0x7FF);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVSync0
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVSync0(DMVSync0Ctrl *pVSync0)
{
	SMT_WRITE(
			VSYNC0,
			 ( ( pVSync0->tVBackPorch		& 0xFF ) << 8)
			|( ( pVSync0->tVFrontPorch		& 0xFF ) << 0)
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVSync0
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVSync0(DMVSync0Ctrl *pVSync0)
{
	smtUint32 Register = SMT_READ(VSYNC0);
	pVSync0->tVBackPorch	= ( ( Register >> 8 ) & 0xFF );
	pVSync0->tVFrontPorch	= ( ( Register >> 0 ) & 0xFF );
}
/*------------------------------------------------------------------------------
    Function name   : smtDMSetVSync1
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMSetVSync1(DMVSync1Ctrl *pVSync1)
{
	SMT_WRITE(
			VSYNC1,
			 ( ( pVSync1->tVPulsWidth	& 0x3F ) << 11)
			|( ( pVSync1->tVDspPeriod	& 0x7FF) <<  0)
		);
}
/*------------------------------------------------------------------------------
    Function name   : smtDMGetVSync1
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
------------------------------------------------------------------------------*/
void smtDMGetVSync1(DMVSync1Ctrl *pVSync1)
{
	smtUint32 Register = SMT_READ(VSYNC1);
	pVSync1->tVPulsWidth	= ( ( Register >> 11 ) & 0x3F );
	pVSync1->tVDspPeriod	= ( ( Register >>  0 ) & 0x7FF);
}
