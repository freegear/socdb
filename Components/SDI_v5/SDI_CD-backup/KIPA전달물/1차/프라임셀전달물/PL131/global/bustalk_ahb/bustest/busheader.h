/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : busheader.h.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose : Definitions 
--
-- --=================================================================*/

#ifndef __HEADER_H
#define __HEADER_H

/* SIZE definitions */

#define BYTE               'b'
#define HWRD               'h'
#define WRD                'w'
#define DWRD               'd'
#define FWRD               'f'
#define EWRD               'e'
#define SWRD               's'
#define TWRD               't'

/* RESPONSE definitions */

#define OK                "ok"
#define ERROR             "er"
#define RETRY             "re"
#define SPLIT             "sp"

/* TRANSFER definitions */

#define IDLE              "i"
#define BUSY              "b"
#define NSEQ              "n"
#define SEQ               "s"

/* BURST definitions */
#define SINGLE           "sin"
#define INCR             "inc"
#define INCR4            "in4"
#define INCR8            "in8"
#define INCR16           "i16"
#define WRAP4            "wr4"
#define WRAP8            "wr8"
#define WRAP16           "w16"

/* supp_msg definitions */
#define FALSE            'f'
#define TRUE             't'

/* Endianness definitions */
#define LITTLE             'l'
#define BIG                'b'
#define DISABLE            'd'

/* EDGE definitions */
#define rising            '/'
#define falling           '\\'

/* PHASE definitions */
#define LOW                'L'
#define HIGH               'H'

/* Virtual Register definitions */
#define R0                "R0"
#define R1                "R1"
#define R2                "R2"
#define R3                "R3"
#define R4                "R4"
#define R5                "R5"
#define R6                "R6"
#define R7                "R7"

/* misc */

#define no_tag             'xxx'

#endif

/* --============================= End ============================-- */
