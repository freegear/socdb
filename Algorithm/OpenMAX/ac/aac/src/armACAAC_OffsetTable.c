/**
 *  armACAAC_OffsetTable.c
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
 * Description:
 * Tables for scaleFactor band description for short and long windows used in AAC
**/

#include "omxtypes.h"

#include "armACAAC_Tables.h"
                                                     /*0  1  2   3   4   5   6   7  8   9   10  11  12  13  14  15  16  17  18  19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36    37  38   39   40   41 */
static const OMX_U16 armACAAC_longOffsetTable0[42] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 64, 72, 80, 88, 96, 108, 120, 132, 144, 156, 172, 188, 212, 240, 276, 320, 384, 448, 512, 576, 640, 704, 768, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTable1[42] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 64, 72, 80, 88, 96, 108, 120, 132, 144, 156, 172, 188, 212, 240, 276, 320, 384, 448, 512, 576, 640, 704, 768, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTable2[48] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 64, 72, 80, 88, 100, 112, 124, 140, 156, 172, 192, 216, 240, 268, 304, 344, 384, 424, 464, 504, 544, 584, 624, 664, 704, 744, 784, 824, 864, 904, 944, 984, 1024 };

static const OMX_U16 armACAAC_longOffsetTable3[50] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 96, 108, 120, 132, 144, 160, 176, 196, 216, 240, 264, 292, 320, 352, 384, 416, 448, 480, 512, 544, 576, 608, 640, 672, 704, 736, 768, 800, 832, 864, 896, 928, 1024 };

static const OMX_U16 armACAAC_longOffsetTable4[50] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 96, 108, 120, 132, 144, 160, 176, 196, 216, 240, 264, 292, 320, 352, 384, 416, 448, 480, 512, 544, 576, 608, 640, 672, 704, 736, 768, 800, 832, 864, 896, 928, 1024 };

static const OMX_U16 armACAAC_longOffsetTable5[52] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 96, 108, 120, 132, 144, 160, 176, 196, 216, 240, 264, 292, 320, 352, 384, 416, 448, 480, 512, 544, 576, 608, 640, 672, 704, 736, 768, 800, 832, 864, 896, 928, 960, 992, 1024 };

static const OMX_U16 armACAAC_longOffsetTable6[48] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 136, 148, 160, 172, 188, 204, 220, 240, 260, 284, 308, 336, 364, 396, 432, 468, 508, 552, 600, 652, 704, 768, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTable7[48] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 136, 148, 160, 172, 188, 204, 220, 240, 260, 284, 308, 336, 364, 396, 432, 468, 508, 552, 600, 652, 704, 768, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTable8[44] = { 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160, 172, 184, 196, 212, 228, 244, 260, 280, 300, 320, 344, 368, 396, 424, 456, 492, 532, 572, 616, 664, 716, 772, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTable9[44] = { 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160, 172, 184, 196, 212, 228, 244, 260, 280, 300, 320, 344, 368, 396, 424, 456, 492, 532, 572, 616, 664, 716, 772, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTablea[44] = { 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160, 172, 184, 196, 212, 228, 244, 260, 280, 300, 320, 344, 368, 396, 424, 456, 492, 532, 572, 616, 664, 716, 772, 832, 896, 960, 1024 };

static const OMX_U16 armACAAC_longOffsetTableb[41] = { 0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 172, 188, 204, 220, 236, 252, 268, 288, 308, 328, 348, 372, 396, 420, 448, 476, 508, 544, 580, 620, 664, 712, 764, 820, 880, 944, 1024 };

static const OMX_U16 armACAAC_shortOffsetTable0[13] = { 0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 92, 128 }; 

static const OMX_U16 armACAAC_shortOffsetTable1[13] = { 0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 92, 128  }; 

static const OMX_U16 armACAAC_shortOffsetTable2[13] = { 0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 92, 128  };

static const OMX_U16 armACAAC_shortOffsetTable3[15] = { 0, 4, 8, 12, 16, 20, 28, 36, 44, 56, 68, 80, 96, 112, 128  };

static const OMX_U16 armACAAC_shortOffsetTable4[15] = { 0, 4, 8, 12, 16, 20, 28, 36, 44, 56, 68, 80, 96, 112, 128  };

static const OMX_U16 armACAAC_shortOffsetTable5[15] = { 0, 4, 8, 12, 16, 20, 28, 36, 44, 56, 68, 80, 96, 112, 128  };

static const OMX_U16 armACAAC_shortOffsetTable6[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 36, 44, 52, 64, 76, 92, 108, 128  };

static const OMX_U16 armACAAC_shortOffsetTable7[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 36, 44, 52, 64, 76, 92, 108, 128  };

static const OMX_U16 armACAAC_shortOffsetTable8[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 60, 72, 88, 108, 128  };

static const OMX_U16 armACAAC_shortOffsetTable9[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 60, 72, 88, 108, 128  };

static const OMX_U16 armACAAC_shortOffsetTablea[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 60, 72, 88, 108, 128  };

static const OMX_U16 armACAAC_shortOffsetTableb[16] = { 0, 4, 8, 12, 16, 20, 24, 28, 36, 44, 52, 60, 72, 88, 108, 128  };

const OMX_U16 armACAAC_numSwbLong[12]        = { 41, 41, 47, 49, 49, 51, 47, 47, 43, 43, 43, 40 };
const OMX_U16 armACAAC_numSwbShort[12]       = { 12, 12, 12, 14, 14, 14, 15, 15, 15, 15, 15, 15 };


const OMX_U16 *armACAAC_swbOffsetLongWindow[12] = 
{
    armACAAC_longOffsetTable0,

    armACAAC_longOffsetTable1,

    armACAAC_longOffsetTable2,

    armACAAC_longOffsetTable3,

    armACAAC_longOffsetTable4,

    armACAAC_longOffsetTable5,

    armACAAC_longOffsetTable6,

    armACAAC_longOffsetTable7,

    armACAAC_longOffsetTable8,    
    
    armACAAC_longOffsetTable9,
    
    armACAAC_longOffsetTablea,

    armACAAC_longOffsetTableb

};


const OMX_U16 *armACAAC_swbOffsetShortWindow[] = 
{
    armACAAC_shortOffsetTable0,

    armACAAC_shortOffsetTable1,

    armACAAC_shortOffsetTable2,

    armACAAC_shortOffsetTable3,
    
    armACAAC_shortOffsetTable4,

    armACAAC_shortOffsetTable5,

    armACAAC_shortOffsetTable6,

    armACAAC_shortOffsetTable7,

    armACAAC_shortOffsetTable8,

    armACAAC_shortOffsetTable9,

    armACAAC_shortOffsetTablea,

    armACAAC_shortOffsetTableb

};

/*End of File*/
