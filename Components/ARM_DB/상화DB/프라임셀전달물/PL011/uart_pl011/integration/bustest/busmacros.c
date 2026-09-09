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
-- File Name              : busmacros.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : Macro definitions to generate .tif and .bif vectors
--           from BusTalk Source code for APB Slaves.
--
-- --=================================================================*/

/**********************************************************************/
/*** Note : To generate .tif vectors, include the following #define ***/
/***        in the config.h file                                    ***/
/***                                                                ***/
/***        #define TIF                                             ***/
/***                                                                ***/
/***      : To generate .bif vectors (default) comment out the      ***/
/***        above #define in the config.h file                      ***/
/***                                                                ***/
/**********************************************************************/

/* 
  Wrapped vector implementations that use the global state variable
  implicitly to update the values needed for an P-TRAN calculation. 

  TestStart should be used as the first BusTalk command to ensure 
  correct set up and memory allocation.  This uses the default values
  for the first transfer.
 */

void TestStart() {
  state = (P_state*)malloc(sizeof(P_state));  /* This type must be */
                                              /* changed for each  */
                                              /* test bench        */
  if (state == (P_state*)NULL) {
    printf(";- Failed Allocation of State\n");
    exit();
  }
  #ifdef TIF 
    printf("; Test Start\n");
  #else
    printf(";- Starting test with defaults in place\n");
    PI(def_num_cyc,"TestStart");
  #endif
  return;
}

void TestEnd() {
  #ifdef TIF 
    printf("; Addressing cycle at end\n");
    printf("A 00000000\n");
    printf("A 00000000\n");
    printf("; Exiting Test Mode\n");
    printf("E ZZZZZZZZ\n");
  #else
    printf("TE\n");
  #endif
  return;
}

void C (char* string, char *tag) {
    size_t i;
    char *pS;
    char *pstring = string;
   
    
    pS = (char *) malloc(sizeof(char) * (strlen(string) + 1));

   /* Print out the string 'string', adding Control Character 
      whenever newlines are encountered.
   */

    while (*pstring != NULL) {
        i = strcspn (pstring, "\n");
        strncpy (pS, pstring, i);
        *(pS + i) = (char *) NULL;
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

/* Command line argument options for the Slave commands

   Address, Data, Mask, Expected are all 8 character Hex with the
   usual 0x prefix.
   Num_cyc is up to 2 hex characters - can omit the 0x prefix if
   not using A-F e.g. allowed : 1, 4, 9, 0xA, 10 (= 16 dec.), 0xAB
   r_w is read or write
   size is byte, half_word, word or reserved
   response is done, last, retract, error or wait
   prot is user_data, user_opcode, supervisor_data or supervisor_opcode
   tag is a string up to 20 characters
 */


void PNW(int32 data,int32 address,char* tag) {
  #ifdef TIF 
    printf("; PNW\n"); 
  #else
    printf("NW %08X %08X \"%s\"\n", data, address,tag);
  #endif
  
  return;
}

void PSW(int32 data,int32 address,char* tag) {
  #ifdef TIF 
    printf("; Addressing location %08x\n", address);
    printf("A %08X\n", address);
    printf("A %08X\n", address);
    printf("; Writing data %08X\n", data);
    printf("W %08X\n", data);
  #else
    address = address & 0xFFFFFFFC;
    printf("LW %08X %08X \"%s\"\n", data, address,tag);
  #endif
  
  return;
}

void PNR(int32 address,char* tag) {
  #ifdef TIF 
    printf("; PNR\n");
  #else
    address = address & 0xFFFFFFFC;
    printf("NR %08X \"%s\"\n", address,tag);
  #endif
  
  return;
}

void PSR(int32 expected, int32 mask ,int32 address,char* tag) {
  #ifdef TIF 
    printf("; Addressing location %08x\n", address);
    printf("A %08X\n", address);
    printf("A %08X\n", address);
    printf("; Reading. Expected: %08X. Mask %08X\n", expected, mask);
    printf("R %08X %08X\n", expected, mask);
    printf("A ZZZZZZZZ\n");
  #else
    address = address & 0xFFFFFFFC;
    printf("LR %08X %08X %08X \"%s\"\n", expected, mask, address,tag);
  #endif
  
  return;
}

void PO(int32 expected, int32 mask, int32 address, int32 limit,char* tag) {
    address = address & 0xFFFFFFFC;
    printf("PO %08X %08X %08X %08X \"%s\"\n", expected, mask, address,
           limit, tag);
  return;
}

void PI(int num_cyc,char* tag) {
  #ifdef TIF 
    printf("A 00000000\n");
    printf("A 00000000\n");
    printf("; Looping  for %d cycles\n", (num_cyc - 1));
    printf("L %d\n", (num_cyc - 1));
  #else
    printf("PI %02X \"%s\"\n", num_cyc,tag);
  #endif
  
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

/* --=========================== End ==============================-- */
