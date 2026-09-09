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
-- File Name              : busmacros.h.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : Macro definitions to generate .tif and .bif vectors
--           from BusTalk Source code for APB Slaves.
--
-- --=================================================================*/

/**********************************************************************/
/***                                                                ***/
/*** MACRO DEFINITIONS                                              ***/
/***                                                                ***/
/**********************************************************************/
/*** PNW(data, addr, [tag])                                         ***/
/*** PSW(data, addr, [tag])                                         ***/
/*** PNR(addr, [tag])                                               ***/
/*** PSR(expected, mask, addr, [tag])                               ***/
/*** PO(expected, mask, addr, [limit], [tag])                       ***/
/*** PI(num_cyc, [tag])                                             ***/
/*** RES(phase,[delay],[num_cyc])                                   ***/
/*** C(message)                                                     ***/
/***                                                                ***/
/**********************************************************************/

/* Type definitions for BusTalk macros */

typedef int int32;

typedef enum {p_nread, p_sread, p_nwrite, p_swrite, p_idle} P_transfer;

/* state structure for APB Slave test bench  */

typedef struct P_state {  
  P_transfer transfer;
  int32 address;
  int32 data;
} P_state;

/* APB Slave Bus Cycle commands primitives */

void PNW(int32 data,int32 address,char* tag);
void PSW(int32 data,int32 address,char* tag);
void PNR(int32 address,char* tag);
void PSR(int32 expected, int32 mask,int32 addr,char* tag);
void PO(int32 expected, int32 mask,int32 addr,int32 limit,char* tag);
void PI(int num_cyc,char* tag);
  
/* Others */

void RES(char phase,int delay,int num_cyc);
void C(char *string, char *tag);
void TestStart();
void TestEnd();

/* --=========================== End ==============================-- */
