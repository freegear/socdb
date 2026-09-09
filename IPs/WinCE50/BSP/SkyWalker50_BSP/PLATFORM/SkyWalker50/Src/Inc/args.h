#ifndef __ARGS_H
#define __ARGS_H

//------------------------------------------------------------------------------
//
// File:        args.h
//
// Description: This header file defines device structures and constant related
//              to boot configuration. BOOT_CFG structure defines layout of
//              persistent device information. It is used to control boot
//              process. BSP_ARGS structure defines information passed from
//              boot loader to kernel HAL/OAL. Each structure has version
//              field which should be updated each time when structure layout
//              change.
//
//------------------------------------------------------------------------------

#include "oal_args.h"
#include "oal_kitl.h"

#define BSP_ARGS_VERSION    1

typedef struct {
    OAL_ARGS_HEADER header; // Used to identify the arguements structure and verify its version
    UINT8 deviceId[16];                 // Device identification
    OAL_KITL_ARGS kitl; // Passed parameters to the OALKitlInit func
} BSP_ARGS;

//------------------------------------------------------------------------------

#endif
