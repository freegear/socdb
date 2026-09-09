/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : busmacros.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose  : Macro definitions to generate .bif vectors
--            from BusTalk Source code for AHB Slaves.
--
-- --=========================================================================*/

/* Wrapped vector implementations that use the global state variable
   implicitly to update the values needed for an S-TRAN calculation. 
   TestStart should be used as the first BusTalk command to ensure
   correct set up and memory allocation. This uses the default values 
   for the first transfer. */

void TestStart(int32 address) {
  state = (S_state *)malloc(sizeof(S_state));  /* This type must be changed for each test bench */
  if (state == (S_state*)NULL) {
    printf(";-Failed Allocation of State\n");
    exit();
  }
  #ifdef TIF
    printf("; Test Start\n");
  #else
    printf(";- Starting test with defaults in place\n");
    SR(0,0,0,0,address,IDLE,INCR,OK,BYTE,def_limit,def_masternum,def_masterlock,def_num_cyc,def_idl_cyc,def_rs_limit,def_supp_msg,def_prot,"TestStart");
  #endif
  return;
}

void TestEnd() {
  #ifdef TIF
    printf("; Addressing cycle at end\n");
    printf("A 00000000\n");
    printf("; Exiting Test Mode\n");
    printf("E ZZZZZZZZ\n");
  #else
    SR(0,0,0,0,0,IDLE,INCR,OK,BYTE,def_limit,def_masternum,def_masterlock,def_num_cyc,def_idl_cyc,def_rs_limit,def_supp_msg,def_prot,"TestEnd");
    printf("TE\n");
  #endif
  return;
}

void C (char* string, char *tag) {
    size_t i;
    char *pS;
    char *pstring = string;
 
 
    pS = (char *) malloc(sizeof(char) * (strlen(string) + 1));
 
   /* Print out the string 'string', adding Control Characters 
      whenever newlines are encountered.
   */
 
    while (*pstring != (char)NULL) {
        i = strcspn (pstring, "\n");
        strncpy (pS, pstring, i);
        *(pS + i) = (char) NULL;
        if (*(pstring + i) == '\n')
          pstring = pstring + i + 1;
        else
          pstring = pstring + i;
        if(strcmp(tag, "header") == 0)
   #ifdef TIF
          ;
   #else
          printf("-- %s\n", pS);
   #endif
        else
           printf (";- %s\n", pS);
    }
    free (pS);
    return;
}
 

/* Command line argument options for the Slave test bench
   Address, Data, Mask, Expected are all 16 character Hex with the
   usual 0x prefix.

   Num_cyc is up to 2 hex characters - can omit the 0x prefix if
   not using A-F e.g. allowed : 1, 4, 9, 0xA, 10 (= 16 dec.), 0xAB
   size is BYTE, HWRD, WRD, DWRD, FWRD, EWRD, SWRD or TWRD
   response is OK, ERROR, RETRY, or SPLIT
   prot is hex character - can omit the 0x prefix if not using A-F
   burst is SINGLE, INCR, INCR4, INCR8, INCR16, WRAP4, WRAP8 or WRAP16 
   trans is IDLE, BUSY, NSEQ or SEQ
 */

void SW(int32 data1,int32 data2,int32 address,char* trans,char* burst,
        char* response,char size,int32 limit,int32 master_num, int masterlock,
        int num_cyc, int32 idl_cyc, int32 rs_limit,char supp_msg,int prot, 
        char* tag) {
  if (strcmp(trans, NSEQ) == 0)
    state->kbboundary = address + 0x400;
  if (address == def_address && (strcmp (trans, IDLE) != 0)) {
    if (state->transfer == s_write) {
      switch (state->size) {
        case t_byte     : address = state->address + 0x1;
                          size = 'b';
                          break;
        case t_h_word   : address = state->address + 0x2;
                          size = 'h';
                          break;
        case t_word     : address = state->address + 0x4;
                          size = 'w';
                          break;
        case t_d_word   : address = state->address + 0x8;
                          size = 'd';
                          break;
        case t_4_word   : address = state->address + 0x10;
                          size = 'f';
                          break;
        case t_8_word   : address = state->address + 0x20;
                          size = 'e';
                          break;
        case t_16_word  : address = state->address + 0x40;
                          size = 's';
                          break;
        case t_32_word  : address = state->address + 0x80;
                          size = 't';
                          break;
      }
    burst = state->burst;
    }
  }
  if ((address >=  (state->kbboundary)) && (strcmp (trans, IDLE) != 0))
  {
  C("1KB BOUNDARY VIOLATED","no tag"); 
  }
  else {
   #ifdef TIF
     if (strcmp(trans, IDLE) == 0) {
       printf("; Idle cycle\n");
       printf("A %08X\n", address);
     }
     else {
       if (strcmp(trans, NSEQ) == 0) {
         printf("; Addressing location %08x\n", address);
         printf("A %08X\n", address);
         printf("; Writing data %08X\n", data2);
         printf("W %08X\n", data2);
       }
       else {
         printf("; Writing data %08X\n", data2);
         printf("W %08X\n", data2);
       }
     }
   #else
     printf("SW %08X%08X %08X %s %s %s %c %08X %08X %01X %08X %08X %08X %c %01X \"%s\"\n",
           data1, data2,address,trans,burst,response,size,limit,master_num,
           masterlock, num_cyc,idl_cyc, rs_limit, supp_msg, prot, tag);
   #endif
  state->transfer = s_write;
  state->burst = burst;
  if (strcmp(trans, BUSY) != 0){
  if (strcmp(burst, WRAP4) == 0)
    { switch (size){
        case 'b' : if ((address & 0x3) == 0x3) {
                   state->address = address - 0x4;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x6) == 0x6) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0xC) == 0xC) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x18) == 0x18) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x30)== 0x30) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x60) == 0x60) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0xC0) == 0xC0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x180) == 0x180) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP8) == 0) 
    { switch (size){
        case 'b' : if ((address & 0x7) == 0x7) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0xE) == 0xE) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x1C) == 0x1C) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x38) == 0x38) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x70)== 0x70) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0xE0) == 0xE0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x1C0) == 0x1C0) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP16) == 0)
    { switch (size){
        case 'b' : if ((address & 0xF) == 0xF) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x1E) == 0x1E) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x3C) == 0x3C) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x78) == 0x78) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0xF0)== 0xF0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x1E0) == 0x1E0) {
                   state->address = address - 0x1C0;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x3C0) == 0x3C0) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
  }
  else state->address = address;
  }
  }
                       
  switch (size) {
    case 'b'  : state->size = t_byte;
                break;
    case 'h'  : state->size = t_h_word;
                break;
    case 'w'  : state->size = t_word;
                break;
    case 'd'  : state->size = t_d_word;
                break;
    case 'f'  : state->size = t_4_word;
                break;
    case 'e'  : state->size = t_8_word;
                break;
    case 's'  : state->size = t_16_word;
                break;
    case 't'  : state->size = t_32_word;
                break;
  }
  return;
}

void SR(int32 expected1,int32 expected2,int32 mask1,int32 mask2,int32 address,
        char* trans,char* burst,char* response,char size,int32 limit, 
        int32 master_num, int masterlock, int num_cyc,int32 idl_cyc,
        int32 rs_limit, char supp_msg,int prot,char* tag) {
  if (strcmp(trans, NSEQ) == 0)
    state->kbboundary = address + 0x400;
  if (address == def_address && (strcmp (trans, IDLE) != 0)) {
    if (state->transfer == s_read) {
      switch (state->size) {
        case t_byte     : address = state->address + 0x1;
                          size = 'b';
                          break;
        case t_h_word   : address = state->address + 0x2;
                          size = 'h';
                          break;
        case t_word     : address = state->address + 0x4;
                          size = 'w';
                          break;
        case t_d_word   : address = state->address + 0x8;
                          size = 'd';
                          break;
        case t_4_word   : address = state->address + 0x10;
                          size = 'f';
                          break;
        case t_8_word   : address = state->address + 0x20;
                          size = 'e';
                          break;
        case t_16_word  : address = state->address + 0x40;
                          size = 's';
                          break;
        case t_32_word  : address = state->address + 0x80;
                          size = 't';
                          break;
      }
    burst = state->burst;
    }
  }
  if ((address >=  (state->kbboundary)) && (strcmp (trans, IDLE) != 0))
  {
   C("1KB BOUNDARY VIOLATED", "no tag"); 
  }
  else { 
   #ifdef TIF
     if (strcmp(trans, IDLE) == 0) {
       printf("; Idle cycle\n");
       printf("A %08X\n", address);
     }
     else {
       if (strcmp(trans, NSEQ) == 0) {
         printf("; Addressing location %08x\n", address);
         printf("A %08X\n", address);
         printf("; Reading. Expected: %08X. Mask %08X\n", expected2, mask2);
         printf("R %08X %08X\n", expected2, mask2);
         printf("A ZZZZZZZZ\n");
       }
       else {
         printf("; Reading. Expected: %08X. Mask %08X\n", expected2, mask2);
         printf("R %08X %08X\n", expected2, mask2);
         printf("A ZZZZZZZZ\n");
       }
     }
   #else
     printf("SR %08X%08X %08X%08X %08X %s %s %s %c %08X %08X %01X %08X %08X %08X %c %01X \"%s\"\n",
         expected1,expected2,mask1,mask2,address,trans,burst,response,size,
         limit,master_num,masterlock, num_cyc,idl_cyc,rs_limit,supp_msg,prot,
         tag);
   #endif
  state->transfer = s_read;
  state->burst = burst;
  if (strcmp(trans, BUSY) != 0){
  if (strcmp(burst, WRAP4) == 0)
    { switch (size){
        case 'b' : if ((address & 0x3) == 0x3) {
                   state->address = address - 0x4;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x6) == 0x6) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0xC) == 0xC) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x18) == 0x18) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x30)== 0x30) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x60) == 0x60) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0xC0) == 0xC0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x180) == 0x180) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP8) == 0) 
    { switch (size){
        case 'b' : if ((address & 0x7) == 0x7) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0xE) == 0xE) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x1C) == 0x1C) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x38) == 0x38) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x70)== 0x70) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0xE0) == 0xE0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x1C0) == 0x1C0) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP16) == 0)
    { switch (size){
        case 'b' : if ((address & 0xF) == 0xF) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x1E) == 0x1E) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x3C) == 0x3C) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x78) == 0x78) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0xF0)== 0xF0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x1E0) == 0x1E0) {
                   state->address = address - 0x1C0;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x3C0) == 0x3C0) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
  }
  else state->address = address;
  }
  } 
                       
  switch (size) {
    case 'b'  : state->size = t_byte;
                break;
    case 'h'  : state->size = t_h_word;
                break;
    case 'w'  : state->size = t_word;
                break;
    case 'd'  : state->size = t_d_word;
                break;
    case 'f'  : state->size = t_4_word;
                break;
    case 'e'  : state->size = t_8_word;
                break;
    case 's'  : state->size = t_16_word;
                break;
    case 't'  : state->size = t_32_word;
                break;
  }
  return;
}


void PO(int32 expected1,int32 expected2,int32 mask1,int32 mask2,int32 address,
        char* trans,char* burst,char* response,char size,int32 limit, 
        int32 master_num, int masterlock, int num_cyc,int32 idl_cyc,
        int32 rs_limit, char supp_msg,int prot, int32 time_out, char* tag) {
  if (strcmp(trans, NSEQ) == 0)
    state->kbboundary = address + 0x400;
  if (address == def_address && (strcmp (trans, IDLE) != 0)) {
    if (state->transfer == s_read) {
      switch (state->size) {
        case t_byte     : address = state->address + 0x1;
                          size = 'b';
                          break;
        case t_h_word   : address = state->address + 0x2;
                          size = 'h';
                          break;
        case t_word     : address = state->address + 0x4;
                          size = 'w';
                          break;
        case t_d_word   : address = state->address + 0x8;
                          size = 'd';
                          break;
        case t_4_word   : address = state->address + 0x10;
                          size = 'f';
                          break;
        case t_8_word   : address = state->address + 0x20;
                          size = 'e';
                          break;
        case t_16_word  : address = state->address + 0x40;
                          size = 's';
                          break;
        case t_32_word  : address = state->address + 0x80;
                          size = 't';
                          break;
      }
    burst = state->burst;
    }
  }
  if ((address >=  (state->kbboundary)) && (strcmp (trans, IDLE) != 0))
  {
   C("1KB BOUNDARY VIOLATED", "no tag"); 
  }
  else { 
  printf("PO %08X%08X %08X%08X %08X %s %s %s %c %08X %08X %01X %08X %08X %08X %c %01X %08X \"%s\"\n",
         expected1,expected2,mask1,mask2,address,trans,burst,response,size,
         limit,master_num,masterlock, num_cyc,idl_cyc,rs_limit,supp_msg,prot,
         time_out,tag);
  state->transfer = s_read;
  state->burst = burst;
  if (strcmp(trans, BUSY) != 0){
  if (strcmp(burst, WRAP4) == 0)
    { switch (size){
        case 'b' : if ((address & 0x3) == 0x3) {
                   state->address = address - 0x4;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x6) == 0x6) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0xC) == 0xC) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x18) == 0x18) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x30)== 0x30) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x60) == 0x60) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0xC0) == 0xC0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x180) == 0x180) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP8) == 0) 
    { switch (size){
        case 'b' : if ((address & 0x7) == 0x7) {
                   state->address = address - 0x8;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0xE) == 0xE) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x1C) == 0x1C) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x38) == 0x38) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0x70)== 0x70) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0xE0) == 0xE0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x1C0) == 0x1C0) {
                   state->address = address - 0x200;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
   }
  else if (strcmp(burst, WRAP16) == 0)
    { switch (size){
        case 'b' : if ((address & 0xF) == 0xF) {
                   state->address = address - 0x10;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'h' : if ((address & 0x1E) == 0x1E) {
                   state->address = address - 0x20;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'w' : if ((address & 0x3C) == 0x3C) {
                   state->address = address - 0x40;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'd' : if ((address & 0x78) == 0x78) {
                   state->address = address - 0x80;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'f' : if ((address & 0xF0)== 0xF0) {
                   state->address = address - 0x100;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 'e' : if ((address & 0x1E0) == 0x1E0) {
                   state->address = address - 0x1C0;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 's' : if ((address & 0x3C0) == 0x3C0) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
        case 't' : if ((address & 0x380) == 0x380) {
                   state->address = address - 0x400;
                   }
                   else {
                   state->address = address;
                   }
                   break;
                   }
  }
  else state->address = address;
  }
  } 
                       
  switch (size) {
    case 'b'  : state->size = t_byte;
                break;
    case 'h'  : state->size = t_h_word;
                break;
    case 'w'  : state->size = t_word;
                break;
    case 'd'  : state->size = t_d_word;
                break;
    case 'f'  : state->size = t_4_word;
                break;
    case 'e'  : state->size = t_8_word;
                break;
    case 's'  : state->size = t_16_word;
                break;
    case 't'  : state->size = t_32_word;
                break;
  }
  return;
}

void RES(char phase,int delay,int num_cyc) {
  #ifdef TIF
    printf("; RES\n");
  #else
    printf("RE %c %02X %02X\n",phase,delay,num_cyc);
  #endif
  return;
}

void VW(char* vrnum, int32 data, int32 mask, char phase, int delay) {
  printf("VW %s %08X %08X %c %02X\n",  vrnum, data, mask,  phase, delay);
return;
}

void VR(char* vrnum, int32 expdata, int32 mask, char edge, int delay, char* tag) {
  printf("VR %s %08X %08X %c %02X \"%s\"\n", vrnum, expdata, mask, edge, 
         delay, tag);
return;
}

void HSP(int exp_master, int num_cyc0, int num_cyc1, int num_cyc2, int num_cyc3, int num_cyc4, int num_cyc5, int num_cyc6, int num_cyc7, int num_cyc8, int num_cyc9, int num_cyc10, int num_cyc11, int num_cyc12, int num_cyc13, int num_cyc14, int num_cyc15, int limit) {
  printf("SP %04X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X %08X\n",exp_master,num_cyc0,num_cyc1,num_cyc2,num_cyc3,num_cyc4,num_cyc5,num_cyc6,num_cyc7,num_cyc8,num_cyc9,num_cyc10,num_cyc11,num_cyc12,num_cyc13,num_cyc14,num_cyc15,limit);
return;
}

void HSEN(char togendianness) {
  printf ("EN %c\n", togendianness);
return;
}
 
void TCV(int32 baseadd, char size, int incr, int locked, int prot) {
   #ifdef TIF
      int32 tcvaddress, tcvsize, tcvprot, tcven;
      int tcvproth, tcvprotl;
      tcven = 0x1;
      tcvproth = (prot & 0xC) >> 2;
      tcvprotl = prot & 0x3;
      switch (size) {
        case 'b' : tcvsize = 0x0; break; 
        case 'h' : tcvsize = 0x1; break; 
        case 'w' : tcvsize = 0x2; break; 
        case 'd' : tcvsize = 0x3; break; 
      }
      tcvaddress = (baseadd & 0xFFFFF000) | tcven | (tcvsize << 2) |
                   (locked << 4) | (tcvprotl << 5) | (incr << 7) |
                   (tcvproth << 9);
      printf("; Control Vector %08x\n", tcvaddress);
      printf("A %08X\n", tcvaddress);
      printf("A %08X\n", tcvaddress);
      printf("R %08X %08X\n", 00000000, 00000000);
      printf("A ZZZZZZZZ\n");
   #endif
return;
}

/******************************** End *****************************************/
