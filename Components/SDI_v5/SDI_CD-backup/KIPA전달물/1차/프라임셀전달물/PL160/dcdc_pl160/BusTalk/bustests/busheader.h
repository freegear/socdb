/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : busheader.h,v
--  File Revision          : 1.2
--  
--  Release Information    : PL160-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose : Definitions of passed bridge variables
------------------------------------------------------------------------------*/

#ifndef __HEADER_H
#define __HEADER_H

/* SIZE definitions */
/*
#define byte               'b'
#define half_word          'h'
#define word               'w'
#define reserved           'r'
*/
/* PROT definitions */
/*
#define supervisor_opcode  "so"
#define supervisor_data    "sd"
#define user_opcode        "uo"
#define user_data          "ud"
*/
/* R_W definitions */
/*
#define write              "wr"
#define read               "rd"
*/
/* RESPONSE definitions */
/*
#define done              "dne"
#define error             "err"
#define last              "lst"
#define retract           "ret"
*/

/* EDGE definitions */

#define rising            '/'
#define falling           '\\'

/* PHASE definitions */

#define LOW                'L'
#define HIGH               'H'

/* Virtual Register definitions */
#define R0                 "R0"
#define R1                 "R1"
#define R2                 "R2"
#define R3                 "R3"
#define R4                 "R4"
#define R5                 "R5"
#define R6                 "R6"
#define R7                 "R7"

/* misc */

#define no_tag             "xxx"

#endif
