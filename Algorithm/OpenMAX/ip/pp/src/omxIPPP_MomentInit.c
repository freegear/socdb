/**
 *
 *  omxIPPP_MomentInit.c
 * 
 * (c) Copyright 2005,2006 ARM Limited. All Rights Reserved.
 * 
 * THIS SOFTWARE IS PROVIDED “AS IS”, ARM EXPRESSLY DISCLAIMS ALL REPRESENTATIONS, 
 * WARRANTIES, CONDITIONS OR OTHER TERMS, EXPRESS, IMPLIED OR STATUTORY, INCLUDING 
 * WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, 
 * SATISFACTORY QUALITY, AND FITNESS FOR A PARTICULAR PURPOSE. 
 * 
 * Your use of this Software may require additional licenses, including but not 
 * limited to copyright and patent licenses from various entities. Should any 
 * such additional copyright, patent or other licenses be required, ARM expects 
 * that you will and you agree to obtain any such licenses at your own expense. 
 * You are solely responsible for obtaining any such licenses and the copyright 
 * licenses granted herein are conditioned on you obtaining such additional 
 * licenses.
 * 
 *
 * Description  : Image Statistics Routine - Initializes the Moment state structure.
 *
 */

#include "omxtypes.h"
#include "omxIP.h"
#include "armCOMM.h"
#include "armIP.h"

/**
 * Function: omxIPPP_MomentInit
 *
 * Description:
 * Moment state structure initialization.
 *
 * Remarks:
 * Initializes moment state structure.
 *
 *
 * Parameters:
 * [in]  pState         pointer to the uninitialized state structure
 * [out] pState         pointer to the initialized state structure
 *
 * Return Value:
 * Standard OMXResult result. See enumeration for possible result codes.
 *
 */

OMXResult omxIPPP_MomentInit(
    OMXMomentState *pState
    )
{
    OMX_INT i, j, k;
    ARMIPPP_MomentState *pMomentState = (ARMIPPP_MomentState *)pState;
    
    armRetArgErrIf(!pMomentState, OMX_StsNullPtrErr);
    
    pMomentState->maxValidChannel = -1;
    for(i = 0; i < ARM_IPPP_MOMENTS_MAX_CHANL; i++)
    {
        for(j = 0; j < ARM_IPPP_MOMENTS_MAX_ORDER; j++)
        {
            for(k = 0; k < ARM_IPPP_MOMENTS_MAX_ORDER; k++)
            {
                pMomentState->spMoments[i][j][k] = 0;
                pMomentState->ctMoments[i][j][k] = 0;
            }
        }
    }
    
    return OMX_StsNoErr;
}

/* End of file */
