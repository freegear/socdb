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
-- Purpose  : Macro definitions to generate .bif vectors
--            from BusTalk Source code for AHB Slaves.
--
-- --=================================================================*/

/* Type definitions for BusTalk macros */

typedef int int32;

typedef enum {t_byte,t_h_word,t_word,t_d_word,t_4_word,
              t_8_word,t_16_word,t_32_word} T_size;

typedef enum {s_read,s_write} S_transfer;

/* state structures for each test bench */

typedef struct S_state {  /* Slave test bench */
  S_transfer transfer;
  T_size size;
  int32 address;
  int32 kbboundary;
  char* burst;
} S_state;

/* Slave primitives */

void SW(int32 data1,int32 data2,int32 address,char* trans,char* burst,char* response,char size,int32 limit,int masternum, int masterlock, int numcyc,int32 idlcyc,int32 rslimit, char suppmsg, int prot,char* tag);
void SR(int32 expected1,int32 expected2,int32 mask1,int32 mask2,int32 address,char* trans,char* burst,char* response,char size,int32 limit, int32 masternum, int masterlock, int numcyc,int32 idlcyc,int32 rslimit, char suppmsg, int prot,char* tag);
void PO(int32 expected1,int32 expected2,int32 mask1,int32 mask2,int32 address,char* trans,char* burst,char* response,char size,int32 limit, int32 masternum, int masterlock, int numcyc,int32 idlcyc,int32 rslimit, char suppmsg, int prot,int32 time_out, char* tag);
void VW(char* vrnum,int32 data,int32 mask,char phase,int delay);
void VR(char* vrnum,int32 expected,int32 mask,char edge,int delay,char* tag);

/* Others */

void RES(char phase,int delay,int num_cyc);
void HSP(int exp_master, int num_cyc0, int num_cyc1, int num_cyc2, int num_cyc3,int num_cyc4, int num_cyc5, int num_cyc6, int num_cyc7, int num_cyc8, int num_cyc9, int num_cyc10, int num_cyc11, int num_cyc12, int num_cyc13, int num_cyc14, int num_cyc15, int limit);
void HSEN(char togendianness);
void TCV(int32 baseadd, char size, int incr, int locked, int prot);
void C(char *string, char *tag);
void TestStart(int32 address);
void TestEnd();

/****************************** End ***********************************/
