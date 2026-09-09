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
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose : Definitions of passed bridge
--
-- --=================================================================*/

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

/* misc */

#define no_tag             "xxx"

#endif

/* --=========================== End ==============================-- */
