#ifndef __host_debug_h__
#define __host_debug_h__
/*******************************************************************************
** File          : $HeadURL$ 
** Author        : $Author$
** Project       : HSCTRL 
** Instances     : 
** Creation date : 
********************************************************************************
********************************************************************************
** ChipIdea Microelectronica - IPCS
** TECMAIA, Rua Eng. Frederico Ulrich, n 2650
** 4470-920 MOREIRA MAIA
** Portugal
** Tel: +351 229471010
** Fax: +351 229471011
** e_mail: chipidea.com
********************************************************************************
** ISO 9001:2000 - Certified Company
** (C) 2005 Copyright Chipidea(R)
** Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to
** the information contained herein without notice. No liability shall be
** incurred as a result of its use or application.
********************************************************************************
** Modification history:
** $Date$
** $Revision$
*******************************************************************************
*** Comments:      
***   This file contains definitions for debugging the software stack
***                                                               
**************************************************************************
**END*********************************************************/
#include "types.h"

//#define DEBUG_INFO                                              
#define _DBUG_                                                  
//#define OTG_DEBUG                                               
//#define HOST_TESTING                                            
                                                                        
//The following switch can be used to enable debugging of the stack       
//#define _HOST_DEBUG_                                            
#define _DEVICE_DEBUG_                                          
//#define _OTG_DEBUG_                                             
                                                                        
//The following switches can be used to enable levels of debug information
#define _DEBUG_INFO_TRACE_LEVEL_                                
//#define _DEBUG_INFO_DATA_LEVEL_                                 
                                                                        
//ASSERT switch can be to used to ensure that all routines check for      
//important parameters passed to them.                                    
#define _ASSERT_                                                





/*--------------------------------------------------------------**
** Debug macros, assume _DBUG_ is defined during development    **
**    (perhaps in the make file), and undefined for production. **
**--------------------------------------------------------------*/
#define DEBUG_FLUSH
#define DEBUG_PRINT(X)
#define DEBUG_PRINT2(X,Y)


/*--------------------------------------------------------------**
** ASSERT macros, assume _ASSERT_ is defined during development **
**    (perhaps in the make file), and undefined for production. **
** This macro will check for pointer values and other validations
** wherever appropriate.
**--------------------------------------------------------------*/
#define ASSERT(X,Y)


/************************************************************
The following array is used to make a run time trace route
inside the USB stack.
*************************************************************/
#define DEBUG_LOG_TRACE(x)
#define START_DEBUG_TRACE
#define STOP_DEBUG_TRACE


/************************************************************
The following are global data structures that can be used
to copy data from stack on run time. This structure can
be analyzed at run time to see the state of various other
data structures in the memory.
*************************************************************/


/**************************************************************
	The following lines assign numbers to each of the routines
	in the stack. These numbers can be used to generate a trace
	on sequenece of routines entered.
**************************************************************/



#endif
/* EOF */
