/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************

   This file contains some basic drivers etc. to interface with the serial
   port(s) on a ARM target. The aim of these routines is to provide
   a standard access mechanism without having target-specific code.
  
	$Id: uart.c,v 1.1.6.1 2000/01/18 15:46:28 drusling Exp $

******************************************************************************/


#include "uart.h"
#include "except_h.h"
#include "uart.h"

