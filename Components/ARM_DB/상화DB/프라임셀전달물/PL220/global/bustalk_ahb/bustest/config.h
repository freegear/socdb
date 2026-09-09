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
-- File Name              : config.h.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose  : Default values for test bench. Also includes
--            timing information
--
-- --=================================================================*/

#ifndef __CONFIG_H
#define __CONFIG_H

/* DEFAULT assignments */
#define def_size          WRD
#define def_burst         INCR4
#define def_trans         SEQ
#define def_prot          0 
#define def_response      OK
#define def_delay         0
#define def_num_cyc       0
#define def_idl_cyc       1
#define def_limit         0
#define def_masternum     0xF
#define def_masterlock    0
#define def_Exphsplit     0x0
#define def_togendianness LITTLE 
#define def_rs_limit      0
#define def_supp_msg      FALSE
#define def_address       -1    /* Dummy value passed into function so 
                                   that the address can be calculated 
                                   from state information */

/* Global state variable for use in busmacros.c */

S_state *state;  /* Change this type for each test bench */

#endif

/***************************** End ************************************/
