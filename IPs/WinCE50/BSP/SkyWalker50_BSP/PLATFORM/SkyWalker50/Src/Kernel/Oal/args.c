#include <bsp.h>

//------------------------------------------------------------------------------
//
//  Function:  OALArgsQuery
//
//  This function is called from other OAL modules to return boot arguments.
//  Boot arguments are typically placed in fixed memory location and they are
//  filled by boot loader. In case that boot arguments can't be located
//  the function should return NULL. The OAL module then must use default
//  values.
//


VOID* OALArgsQuery(UINT32 type)
{
    VOID *pData = NULL;
    BSP_ARGS *pArgs;

    OALMSG(OAL_ARGS&&OAL_FUNC, (L"+OALArgsQuery(%d)\r\n", type));

    // Get pointer to expected boot args location
    pArgs = (BSP_ARGS*)IMAGE_SHARE_ARGS_UA_START;

    // Check if there is expected signature
    if (
        pArgs->header.signature  != OAL_ARGS_SIGNATURE ||
        pArgs->header.oalVersion != OAL_ARGS_VERSION   ||
        pArgs->header.bspVersion != BSP_ARGS_VERSION
    ) goto cleanUp;

    // Depending on required args
    switch (type) {
    case OAL_ARGS_QUERY_DEVID:
        pData = &pArgs->deviceId;
        break;
    case OAL_ARGS_QUERY_KITL:
        pData = &pArgs->kitl;
        break;
    }

cleanUp:
    OALMSG(OAL_ARGS&&OAL_FUNC, (L"-OALArgsQuery(pData = 0x%08x)\r\n", pData));
    return pData;
}

//------------------------------------------------------------------------------

