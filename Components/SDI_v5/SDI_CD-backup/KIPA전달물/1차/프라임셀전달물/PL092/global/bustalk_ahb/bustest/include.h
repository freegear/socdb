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
-- File Name              : include.h.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : Default values for test bench. Also includes
--           timing information
--
-- --=================================================================*/

/**********************************************************************/
/* Purpose : 
/*           This file contains all the include header files that are */
/*           needed to compile the Top.c top-level test. It is        */
/*           included by the at compile time.                         */
/*           This is necesssary because the Top.c needs to be         */
/*           pre-processed, then awked and then compiled. The flow    */
/*           allows the functions called by the Top.c to live in      */
/*           separate files - makes it much cleaner to read and       */
/*           maintain.                                                */
/**********************************************************************/

#include <stdio.h> 
#include <string.h>
#include "busmacros.h"
#include "busheader.h"
#include "config.h"
#include "busmacros.c"

/***************************** End ************************************/
