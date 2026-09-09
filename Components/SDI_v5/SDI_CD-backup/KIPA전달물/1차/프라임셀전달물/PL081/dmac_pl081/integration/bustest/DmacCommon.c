/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacCommon.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           This file contains global variables and common functions 
--           used by other tests.
-- 
-- --=========================================================================*/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/
#define Mem0  0xAAAAAAAA
#define Mem1  0xBBBBBBBB

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  retstr          - To concatenate 2 strings in the function strcat     ***/
/***  debugstr        - To issue the debug level messages during simulation ***/
/***  message         - To issue the informative messages during simulation ***/
/***  SrcPeripheral   - Source peripheral number (0 - 15)                   ***/
/***  DestPeripheral  - Destination peripheral number (0 - 15)              ***/
/***  SrcResponse     - This integer provides the combination of responses  ***/
/***                    to be programmed in the source memory/peripheral.   ***/
/***  DestResponse    - This integer provides the combination of responses  ***/
/***                    to be programmed in the destination                 ***/
/***                    memory/peripheral.                                  ***/
/***  Note :                                                                ***/
/***  The DMA controller supports only upto 16 peripherals. Therefore the   ***/
/***  SrcPeripheral/DestPeripheral values can only be between 0 and 15.     ***/
/***                                                                        ***/
/***  There are 5 AHB responses defined (OKAY, WAIT, RETRY, SPLIT and ERROR)***/
/***  Each one of them can be programmed or not. This gives 32 combination  ***/
/***  of responses (2^15). However atleast one response is to be programmed.***/
/***  Therefore SrcResponse/DestResponse can only be between 1 and 31.      ***/
/******************************************************************************/
char retstr[100];
char debugstr[500];
char message[200];
int SrcPeripheral = 0;
int DestPeripheral = 1;
int SrcResponse   = 1;
int DestResponse  = 1;

int SrcOkay, SrcWait, SrcRetry, SrcSplit, SrcError;
int DestOkay, DestWait, DestRetry, DestSplit, DestError;

int32 NA               = 0xFFFFFFFF;
int32 RANDOM           = 0x00000000;
int32 GRAYCODE         = 0x00000100;
int32 ADDRBASED        = 0x00000200;
int32 DATABASED        = 0x00000300;

int32 INCREMENT        = 0x00000000;
int32 DECREMENT        = 0x00000040;
int32 ONESCOMP         = 0x00000080;
int32 TWOSCOMP         = 0x000000C0;

int32 LLIADDRM1        = DMACTRMEM0BASE;
int32 LLIADDRM2        = DMACTRMEM1BASE;
int32 LLISlaveAddrM1   = DMACTRMEM0REGBASE | 0x00000200;
int32 LLISlaveAddrM2   = DMACTRMEM0REGBASE | 0x00000200;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ConstantList    - It contains the constant names and their values,    ***/
/***                    as defined in Dmac.h, as its elements. It is used   ***/
/***                    in the function strconst.                           ***/
/******************************************************************************/
struct ConstantList {
  char *ConstantName;
  int32 ConstantValue;
};

struct ChannelPara {
   int   Channel;
   int32 FlowControl;
   int   SrcWidth;
   int   DestWidth;
   int   SrcBurst;
   int   DestBurst;
   int32 TxSize;
   int   SrcMaster;
   int   DestMaster;
   int   NoOfLLI;
   int32 LLIAddr;
   int32 LLIMaster;
   int32 SrcPeriph;
   int32 DestPeriph;
   int32 SrcAHBResp;
   int32 DestAHBResp;
   int32 SrcWaitCyc;
   int32 DestWaitCyc;
   int32 PROT;
   int32 ChLOCK;
   int32 HALT;
   char* SrcIncr;
   char* DestIncr;
  };

struct RespPara{
   int32 PeriphValue;
   int32 ControlMethod;
   int32 Size;
   int32 ValidBits;
   int32 NoOfPrgmdSRResp;
   int32 ProgramedWaitCyc;
   int32 ProgramedResp;
   int32 AddrDataCount;
  };

struct PrgmCases{
   char *TestNo;
   struct RespPara *PrgmRespPara;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ReadOnlyRegisters  - Contains the names of all the read-only          ***/
/***                       registers of DMAC. It is used in IsReadOnly      ***/
/***                       function.                                        ***/
/***  WriteOnlyRegisters - Contains the names of all the write-only         ***/
/***                       registers of DMAC. It is used in IsWriteOnly     ***/
/***                       function.                                        ***/
/***  DmacRegisters      - Contains the names of all the DMAC registers     ***/
/***                       in the ascending order of the address. It is     ***/
/***                       used in RegisterName/NextRegisterName/IsDmacReg  ***/
/***                       functions.                                       ***/
/******************************************************************************/
char *ReadOnlyRegisters[15] = {
                           "DMACIntStat",
                           "DMACIntTCStat",
                           "DMACIntErrStat",
                           "DMACRawIntTC",
                           "DMACRawIntErr",
                           "DMACEnbldChns",
                           "DMACPeriphId0",
                           "DMACPeriphId1",
                           "DMACPeriphId2",
                           "DMACPeriphId3",
                           "DMACPCellId0",
                           "DMACPCellId1",
                           "DMACPCellId2",
                           "DMACPCellId3",
                           "LASTREG"};

char *WriteOnlyRegisters[3] = {"DMACIntTCClr", "DMACIntErrClr", "LASTREG"};

char *DmacRegisters[67] = {"DMACIntStat",
                       "DMACIntTCStat",
                       "DMACIntTCClr",
                       "DMACIntErrStat",
                       "DMACIntErrClr",
                       "DMACRawIntTC",
                       "DMACRawIntErr",
                       "DMACEnbldChns",
                       "DMACConfig",
                       "DMACSync",
                       "DMACC0SrcAddr",
                       "DMACC0DestAddr",
                       "DMACC0LLIReg",
                       "DMACC0Control",
                       "DMACC0Config",
                       "DMACC1SrcAddr",
                       "DMACC1DestAddr",
                       "DMACC1LLIReg",
                       "DMACC1Control",
                       "DMACC1Config",
#ifdef MORETHAN2CHS
                       "DMACC2SrcAddr",
                       "DMACC2DestAddr",
                       "DMACC2LLIReg",
                       "DMACC2Control",
                       "DMACC2Config",
                       "DMACC3SrcAddr",
                       "DMACC3DestAddr",
                       "DMACC3LLIReg",
                       "DMACC3Control",
                       "DMACC3Config",
#endif MORETHAN2CHS
#ifdef MORETHAN4CHS
                       "DMACC4SrcAddr",
                       "DMACC4DestAddr",
                       "DMACC4LLIReg",
                       "DMACC4Control",
                       "DMACC4Config",
                       "DMACC5SrcAddr",
                       "DMACC5DestAddr",
                       "DMACC5LLIReg",
                       "DMACC5Control",
                       "DMACC5Config",
                       "DMACC6SrcAddr",
                       "DMACC6DestAddr",
                       "DMACC6LLIReg",
                       "DMACC6Control",
                       "DMACC6Config",
                       "DMACC7SrcAddr",
                       "DMACC7DestAddr",
                       "DMACC7LLIReg",
                       "DMACC7Control",
                       "DMACC7Config",
#endif MORETHAN4CHS
                       "DMACPeriphId0",
                       "DMACPeriphId1",
                       "DMACPeriphId2",
                       "DMACPeriphId3",
                       "DMACPCellId0",
                       "DMACPCellId1",
                       "DMACPCellId2",
                       "DMACPCellId3",
                       "LASTREG"};

struct ConstantList DmacConstants[300] = {
                       "DMACIntStat", DMACIntStat,
                       "DMACIntTCStat", DMACIntTCStat,
                       "DMACIntTCClr", DMACIntTCClr,
                       "DMACIntErrStat", DMACIntErrStat,
                       "DMACIntErrClr", DMACIntErrClr,
                       "DMACRawIntTC", DMACRawIntTC,
                       "DMACRawIntErr", DMACRawIntErr,
                       "DMACEnbldChns", DMACEnbldChns,
                       "DMACSoftBReq", DMACSoftBReq,
                       "DMACSoftSReq", DMACSoftSReq,
                       "DMACSoftLBReq", DMACSoftLBReq,
                       "DMACSoftLSReq", DMACSoftLSReq,
                       "DMACConfig", DMACConfig,
                       "DMACSync", DMACSync,
                       "DMACC0SrcAddr", DMACC0SrcAddr,
                       "DMACC0DestAddr", DMACC0DestAddr,
                       "DMACC0LLIReg", DMACC0LLIReg,
                       "DMACC0Control", DMACC0Control,
                       "DMACC0Config", DMACC0Config,
                       "DMACC1SrcAddr", DMACC1SrcAddr,
                       "DMACC1DestAddr", DMACC1DestAddr,
                       "DMACC1LLIReg", DMACC1LLIReg,
                       "DMACC1Control", DMACC1Control,
                       "DMACC1Config", DMACC1Config,
                       "DMACC2SrcAddr", DMACC2SrcAddr,
                       "DMACC2DestAddr", DMACC2DestAddr,
                       "DMACC2LLIReg", DMACC2LLIReg,
                       "DMACC2Control", DMACC2Control,
                       "DMACC2Config", DMACC2Config,
                       "DMACC3SrcAddr", DMACC3SrcAddr,
                       "DMACC3DestAddr", DMACC3DestAddr,
                       "DMACC3LLIReg", DMACC3LLIReg,
                       "DMACC3Control", DMACC3Control,
                       "DMACC3Config", DMACC3Config,
                       "DMACC4SrcAddr", DMACC4SrcAddr,
                       "DMACC4DestAddr", DMACC4DestAddr,
                       "DMACC4LLIReg", DMACC4LLIReg,
                       "DMACC4Control", DMACC4Control,
                       "DMACC4Config", DMACC4Config,
                       "DMACC5SrcAddr", DMACC5SrcAddr,
                       "DMACC5DestAddr", DMACC5DestAddr,
                       "DMACC5LLIReg", DMACC5LLIReg,
                       "DMACC5Control", DMACC5Control,
                       "DMACC5Config", DMACC5Config,
                       "DMACC6SrcAddr", DMACC6SrcAddr,
                       "DMACC6DestAddr", DMACC6DestAddr,
                       "DMACC6LLIReg", DMACC6LLIReg,
                       "DMACC6Control", DMACC6Control,
                       "DMACC6Config", DMACC6Config,
                       "DMACC7SrcAddr", DMACC7SrcAddr,
                       "DMACC7DestAddr", DMACC7DestAddr,
                       "DMACC7LLIReg", DMACC7LLIReg,
                       "DMACC7Control", DMACC7Control,
                       "DMACC7Config", DMACC7Config,
                       "DMACTCR", DMACTCR,
                       "DMACITOP1", DMACITOP1,
                       "DMACITOP2", DMACITOP2,
                       "DMACITOP3", DMACITOP3,
                       "DMACPeriphId0", DMACPeriphId0,
                       "DMACPeriphId1", DMACPeriphId1,
                       "DMACPeriphId2", DMACPeriphId2,
                       "DMACPeriphId3", DMACPeriphId3,
                       "DMACPCellId0", DMACPCellId0,
                       "DMACPCellId1", DMACPCellId1,
                       "DMACPCellId2", DMACPCellId2,
                       "DMACPCellId3", DMACPCellId3,
                       "DMAC_BASE", DMAC_BASE,
                       "DMAC_REGADDR_LIMIT",DMAC_REGADDR_LIMIT,
                       "ZERO", ZERO,
                       "NoMask", NoMask,
                       "MaskAll",MaskAll,
                       "RST_DMACIntStat", RST_DMACIntStat,
                       "RST_DMACIntTCStat", RST_DMACIntTCStat,
                       "RST_DMACIntTCClr", RST_DMACIntTCClr,
                       "RST_DMACIntErrStat", RST_DMACIntErrStat,
                       "RST_DMACIntErrClr", RST_DMACIntErrClr,
                       "RST_DMACRawIntTC", RST_DMACRawIntTC,
                       "RST_DMACRawIntErr", RST_DMACRawIntErr,
                       "RST_DMACEnbldChns", RST_DMACEnbldChns,
                       "RST_DMACSoftBReq", RST_DMACSoftBReq,
                       "RST_DMACSoftSReq", RST_DMACSoftSReq,
                       "RST_DMACSoftLBReq", RST_DMACSoftLBReq,
                       "RST_DMACSoftLSReq", RST_DMACSoftLSReq,
                       "RST_DMACConfig", RST_DMACConfig,
                       "RST_DMACSync", RST_DMACSync,
                       "RST_DMACC0SrcAddr", RST_DMACC0SrcAddr,
                       "RST_DMACC0DestAddr", RST_DMACC0DestAddr,
                       "RST_DMACC0LLIReg", RST_DMACC0LLIReg,
                       "RST_DMACC0Control", RST_DMACC0Control,
                       "RST_DMACC0Config", RST_DMACC0Config,
                       "RST_DMACC1SrcAddr", RST_DMACC1SrcAddr,
                       "RST_DMACC1DestAddr", RST_DMACC1DestAddr,
                       "RST_DMACC1LLIReg", RST_DMACC1LLIReg,
                       "RST_DMACC1Control", RST_DMACC1Control,
                       "RST_DMACC1Config", RST_DMACC1Config,
                       "RST_DMACC2SrcAddr", RST_DMACC2SrcAddr,
                       "RST_DMACC2DestAddr", RST_DMACC2DestAddr,
                       "RST_DMACC2LLIReg", RST_DMACC2LLIReg,
                       "RST_DMACC2Control", RST_DMACC2Control,
                       "RST_DMACC2Config", RST_DMACC2Config,
                       "RST_DMACC3SrcAddr", RST_DMACC3SrcAddr,
                       "RST_DMACC3DestAddr", RST_DMACC3DestAddr,
                       "RST_DMACC3LLIReg", RST_DMACC3LLIReg,
                       "RST_DMACC3Control", RST_DMACC3Control,
                       "RST_DMACC3Config", RST_DMACC3Config,
                       "RST_DMACC4SrcAddr", RST_DMACC4SrcAddr,
                       "RST_DMACC4DestAddr", RST_DMACC4DestAddr,
                       "RST_DMACC4LLIReg", RST_DMACC4LLIReg,
                       "RST_DMACC4Control", RST_DMACC4Control,
                       "RST_DMACC4Config", RST_DMACC4Config,
                       "RST_DMACC5SrcAddr", RST_DMACC5SrcAddr,
                       "RST_DMACC5DestAddr", RST_DMACC5DestAddr,
                       "RST_DMACC5LLIReg", RST_DMACC5LLIReg,
                       "RST_DMACC5Control", RST_DMACC5Control,
                       "RST_DMACC5Config", RST_DMACC5Config,
                       "RST_DMACC6SrcAddr", RST_DMACC6SrcAddr,
                       "RST_DMACC6DestAddr", RST_DMACC6DestAddr,
                       "RST_DMACC6LLIReg", RST_DMACC6LLIReg,
                       "RST_DMACC6Control", RST_DMACC6Control,
                       "RST_DMACC6Config", RST_DMACC6Config,
                       "RST_DMACC7SrcAddr", RST_DMACC7SrcAddr,
                       "RST_DMACC7DestAddr", RST_DMACC7DestAddr,
                       "RST_DMACC7LLIReg", RST_DMACC7LLIReg,
                       "RST_DMACC7Control", RST_DMACC7Control,
                       "RST_DMACC7Config", RST_DMACC7Config,
                       "RST_DMACTCR", RST_DMACTCR,
                       "RST_DMACITOP1", RST_DMACITOP1,
                       "RST_DMACITOP2", RST_DMACITOP2,
                       "RST_DMACITOP3", RST_DMACITOP3,
                       "RST_DMACPeriphId0", RST_DMACPeriphId0,
                       "RST_DMACPeriphId1", RST_DMACPeriphId1,
                       "RST_DMACPeriphId2", RST_DMACPeriphId2,
                       "RST_DMACPeriphId3", RST_DMACPeriphId3,
                       "RST_DMACPCellId0", RST_DMACPCellId0,
                       "RST_DMACPCellId1", RST_DMACPCellId1,
                       "RST_DMACPCellId2", RST_DMACPCellId2,
                       "RST_DMACPCellId3", RST_DMACPCellId3,
                       "RDO_DMACIntStat", RDO_DMACIntStat,
                       "RDO_DMACIntTCStat", RDO_DMACIntTCStat,
                       "RDO_DMACIntErrStat", RDO_DMACIntErrStat,
                       "RDO_DMACRawIntTC", RDO_DMACRawIntTC,
                       "RDO_DMACRawIntErr", RDO_DMACRawIntErr,
                       "RDO_DMACEnbldChns", RDO_DMACEnbldChns,
                       "RDO_DMACPeriphId0", RDO_DMACPeriphId0,
                       "RDO_DMACPeriphId1", RDO_DMACPeriphId1,
                       "RDO_DMACPeriphId2", RDO_DMACPeriphId2,
                       "RDO_DMACPeriphId3", RDO_DMACPeriphId3,
                       "RDO_DMACPCellId0", RDO_DMACPCellId0,
                       "RDO_DMACPCellId1", RDO_DMACPCellId1,
                       "RDO_DMACPCellId2", RDO_DMACPCellId2,
                       "RDO_DMACPCellId3", RDO_DMACPCellId3,
                       "MASK_DMACSoftBReq", MASK_DMACSoftBReq,
                       "MASK_DMACSoftSReq", MASK_DMACSoftSReq,
                       "MASK_DMACSoftLBReq", MASK_DMACSoftLBReq,
                       "MASK_DMACSoftLSReq", MASK_DMACSoftLSReq,
                       "MASK_DMACConfig", MASK_DMACConfig,
                       "MASK_DMACSync", MASK_DMACSync,
                       "MASK_DMACC0SrcAddr", MASK_DMACC0SrcAddr,
                       "MASK_DMACC0DestAddr", MASK_DMACC0DestAddr,
                       "MASK_DMACC0LLIReg", MASK_DMACC0LLIReg,
                       "MASK_DMACC0Control", MASK_DMACC0Control,
                       "MASK_DMACC0Config", MASK_DMACC0Config,
                       "MASK_DMACC1SrcAddr", MASK_DMACC1SrcAddr,
                       "MASK_DMACC1DestAddr", MASK_DMACC1DestAddr,
                       "MASK_DMACC1LLIReg", MASK_DMACC1LLIReg,
                       "MASK_DMACC1Control", MASK_DMACC1Control,
                       "MASK_DMACC1Config", MASK_DMACC1Config,
                       "MASK_DMACC2SrcAddr", MASK_DMACC2SrcAddr,
                       "MASK_DMACC2DestAddr", MASK_DMACC2DestAddr,
                       "MASK_DMACC2LLIReg", MASK_DMACC2LLIReg,
                       "MASK_DMACC2Control", MASK_DMACC2Control,
                       "MASK_DMACC2Config", MASK_DMACC2Config,
                       "MASK_DMACC3SrcAddr", MASK_DMACC3SrcAddr,
                       "MASK_DMACC3DestAddr", MASK_DMACC3DestAddr,
                       "MASK_DMACC3LLIReg", MASK_DMACC3LLIReg,
                       "MASK_DMACC3Control", MASK_DMACC3Control,
                       "MASK_DMACC3Config", MASK_DMACC3Config,
                       "MASK_DMACC4SrcAddr", MASK_DMACC4SrcAddr,
                       "MASK_DMACC4DestAddr", MASK_DMACC4DestAddr,
                       "MASK_DMACC4LLIReg", MASK_DMACC4LLIReg,
                       "MASK_DMACC4Control", MASK_DMACC4Control,
                       "MASK_DMACC4Config", MASK_DMACC4Config,
                       "MASK_DMACC5SrcAddr", MASK_DMACC5SrcAddr,
                       "MASK_DMACC5DestAddr", MASK_DMACC5DestAddr,
                       "MASK_DMACC5LLIReg", MASK_DMACC5LLIReg,
                       "MASK_DMACC5Control", MASK_DMACC5Control,
                       "MASK_DMACC5Config", MASK_DMACC5Config,
                       "MASK_DMACC6SrcAddr", MASK_DMACC6SrcAddr,
                       "MASK_DMACC6DestAddr", MASK_DMACC6DestAddr,
                       "MASK_DMACC6LLIReg", MASK_DMACC6LLIReg,
                       "MASK_DMACC6Control", MASK_DMACC6Control,
                       "MASK_DMACC6Config", MASK_DMACC6Config,
                       "MASK_DMACC7SrcAddr", MASK_DMACC7SrcAddr,
                       "MASK_DMACC7DestAddr", MASK_DMACC7DestAddr,
                       "MASK_DMACC7LLIReg", MASK_DMACC7LLIReg,
                       "MASK_DMACC7Control", MASK_DMACC7Control,
                       "MASK_DMACC7Config", MASK_DMACC7Config,
                       "MASK_DMACTCR", MASK_DMACTCR,
                       "MASK_DMACITOP1", MASK_DMACITOP1,
                       "MASK_DMACITOP2", MASK_DMACITOP2,
                       "MASK_DMACITOP3", MASK_DMACITOP3,
                       "LASTREG", 0xABCDEF01};

/* The following order of registers should not be changed.
   If it is changed, it affects the Channel configuration sequence */
 
int32 Channel0Regs[5] = {DMACC0SrcAddr, DMACC0DestAddr, DMACC0LLIReg,
                          DMACC0Control, DMACC0Config};
 
int32 Channel1Regs[5] = {DMACC1SrcAddr, DMACC1DestAddr, DMACC1LLIReg,
                          DMACC1Control, DMACC1Config};
 
int32 Channel2Regs[5] = {DMACC2SrcAddr, DMACC2DestAddr, DMACC2LLIReg,
                          DMACC2Control, DMACC2Config};
 
int32 Channel3Regs[5] = {DMACC3SrcAddr, DMACC3DestAddr, DMACC3LLIReg,
                          DMACC3Control, DMACC3Config};
 
int32 Channel4Regs[5] = {DMACC4SrcAddr, DMACC4DestAddr, DMACC4LLIReg,
                          DMACC4Control, DMACC4Config};
 
int32 Channel5Regs[5] = {DMACC5SrcAddr, DMACC5DestAddr, DMACC5LLIReg,
                          DMACC5Control, DMACC5Config};
 
int32 Channel6Regs[5] = {DMACC6SrcAddr, DMACC6DestAddr, DMACC6LLIReg,
                          DMACC6Control, DMACC6Config};
 
int32 Channel7Regs[5] = {DMACC7SrcAddr, DMACC7DestAddr, DMACC7LLIReg,
                          DMACC7Control, DMACC7Config};
 
int32 ConfigRegs[8]   = {DMACC0Config, DMACC1Config,
                         DMACC2Config, DMACC3Config,
                         DMACC4Config, DMACC5Config,
                         DMACC6Config, DMACC7Config};

/* The following are the configurable parameters of memory/peripheral */
  int32 DefaultWaitCycles[16] = {DEFWAIT0, DEFWAIT1, DEFWAIT2, DEFWAIT3,
                                 DEFWAIT4, DEFWAIT5, DEFWAIT6, DEFWAIT7,
                                 DEFWAIT8, DEFWAIT9, DEFWAIT10, DEFWAIT11,
                                 DEFWAIT12, DEFWAIT13, DEFWAIT14, DEFWAIT15};
 
/**********************************************************************/
/************************* Common Functions ***************************/
/**********************************************************************/

/**********************************************************************/
/***************************** Message   ******************************/
/**********************************************************************/

void msg_info(char *message)
{
#ifdef INFO
  C(message);
#endif
}

/**********************************************************************/
/*************************** Debug Message ****************************/
/**********************************************************************/

void debug_info(char *message)
{
#ifdef DEBUG
  C(message);
#endif
}

/**********************************************************************/
/***************************** Wait Loop ******************************/
/**********************************************************************/

void WaitLoop(int cyc)
{
  /*
     Summary: Inserts Wait Loops
     ===========================
     This function performs the following:
 
     o  Inserts programmed number of idle cycles.
  */
 
  int i;
 
  for (i = 0; i < cyc; i++)
  {
    HSA(ZERO, IDLE, INCR, , WRD);
    HSR( , ZERO, , MaskAll);
  }
}

/**********************************************************************/
/********************* String-Constant Conversion *********************/
/**********************************************************************/
int32 strconst (char *constname)
{
  /*
     Summary: Returns constants defined by the string
     ================================================
     This function performs the following:
 
     o  Any constant name that is defined in Dmac.h file
        can be passed on to this function and it returns the value of
        the constant.
  */

  char *prnstr;
  struct ConstantList *StrConstPtr;

  StrConstPtr = DmacConstants;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn strconst : Constant Name is %s",constname);
    C(debugstr);
  } */

  sprintf(debugstr,"Fn strconst : Constant Name is %s",constname);
  debug_info(debugstr);

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn strconst : Comparing against %s",StrConstPtr->ConstantName);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn strconst : Comparing against %s",StrConstPtr->ConstantName);
  debug_info(debugstr);

  while (strcmp(constname,StrConstPtr->ConstantName) != 0)
  {
   StrConstPtr++;

    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn strconst : Comparing against %s",StrConstPtr->ConstantName);
      C(debugstr);
    } */
    sprintf(debugstr,"Fn strconst : Comparing against %s",StrConstPtr->ConstantName);
    debug_info(debugstr);

   if (StrConstPtr->ConstantName == "LASTREG")
   {
     /* if (DEBUG)
     {
       sprintf(debugstr,"Error : Constant %s Not found.\n",constname);
       C(debugstr);
     } */
     sprintf(debugstr,"Error : Constant %s Not found.\n",constname);
     debug_info(debugstr);

     return 0;
   }

  }

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn strconst : Constant Value is %X",StrConstPtr->ConstantValue);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn strconst : Constant Value is %X",StrConstPtr->ConstantValue);
  debug_info(debugstr);

  return StrConstPtr->ConstantValue;
}

/**********************************************************************/
/************************* Next register name *************************/
/**********************************************************************/
char *NextRegisterName (const char *currentregname)
{
  /*
     Summary: Returns constants defined by the string
     ================================================
     This function performs the following:
 
     o  Any constant name that is defined in Dmac.h file
        can be passed on to this function and it returns the value of
        the constant.
  */
  char **prnstr;
  prnstr = DmacRegisters;
  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn NextRegisterName : Current Register Name is %s",currentregname);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn NextRegisterName : Current Register Name is %s",currentregname);
  debug_info(debugstr);

  while ((strcmp(*prnstr,currentregname) != 0) &&
         (*prnstr != "LASTREG"))
  {
   prnstr++;
  }

  prnstr++;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn NextRegisterName : Next Register Name is %s",*prnstr);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn NextRegisterName : Next Register Name is %s",*prnstr);
  debug_info(debugstr);

  return *prnstr;
}

/**********************************************************************/
/************************* String Concatenation ***********************/
/**********************************************************************/
char *stringcat(char *string1, char *string2)
{
  int i;
  int j=0;

  for (i = 0; i < strlen(string1); i++)
  {
   retstr[j] = string1[i];
   j++;
  }

  for (i = 0; i < strlen(string2); i++)
  {
   retstr[j] = string2[i];
   j++;
  }

  retstr[j] = '\0';
  return (retstr);
}

/**********************************************************************/
/************************** Read Only Register ************************/
/**********************************************************************/
int IsReadOnly(const int32 Address)
{
  char **RegisterList;
  RegisterList = ReadOnlyRegisters;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn IsReadOnly : Address input is %X",Address);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn IsReadOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
   RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsReadOnly : It is a Read Only Register");
      C(debugstr);
    } */
    sprintf(debugstr,"Fn IsReadOnly : It is a Read Only Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsReadOnly : It is NOT a Read Only Register");
      C(debugstr);
    } */
    sprintf(debugstr,"Fn IsReadOnly : It is NOT a Read Only Register");
    debug_info(debugstr);

    return 0;
  }
}

/**********************************************************************/
/************************** Write Only Register ***********************/
/**********************************************************************/
int IsWriteOnly(const int32 Address)
{
  char **RegisterList;
  RegisterList = WriteOnlyRegisters;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn IsWriteOnly : Address input is %X",Address);
    debug_info(debugstr);
  } */
  sprintf(debugstr,"Fn IsWriteOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
   RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsWriteOnly : It is a Write Only Register");
      debug_info(debugstr);
    } */
    sprintf(debugstr,"Fn IsWriteOnly : It is a Write Only Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsWriteOnly : It is NOT a Write Only Register");
      C(debugstr);
    } */
    sprintf(debugstr,"Fn IsWriteOnly : It is NOT a Write Only Register");
    debug_info(debugstr);

    return 0;
  }
}

/**********************************************************************/
/********************* An element of the given array  *****************/
/**********************************************************************/
int IsElement(const int32 Address, const int32 *Array,
              const int ArraySize)
{
  int index = 0;

  sprintf(debugstr,"Function IsElement :");
  debug_info(debugstr);

  sprintf(debugstr,"Address is : %X",Address);
  debug_info(debugstr);

  sprintf(debugstr,"ArraySize is : %X",ArraySize);
  debug_info(debugstr);

  while ((Array[index] != Address) && (index < ArraySize))
  {
    /* AddressList++; */
    index++;
  }

  if (Array[index] == Address)
  {
    sprintf(debugstr,"Index is : %d",index);
    debug_info(debugstr);

    sprintf(debugstr,"ArrayElement at Index is : %X",Array[index]);
    debug_info(debugstr);

    return 1;
  }
  else
  {
    debug_info("Address is not part of the Array");

    return 0;
  }
}

/**********************************************************************/
/************************** All DMAC Registers ************************/
/**********************************************************************/
int IsDmacReg(const int32 Address)
{
  char **RegisterList;
  RegisterList = DmacRegisters;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn IsDmacReg : Address input is %X",Address);
    debug_info(debugstr);
  } */
  sprintf(debugstr,"Fn IsDmacReg : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
   RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsDmacReg : It is a Dmac Register");
      debug_info(debugstr);
    } */
    sprintf(debugstr,"Fn IsDmacReg : It is a Dmac Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn IsDmacReg : It is NOT a Dmac Register");
      C(debugstr);
    } */
    sprintf(debugstr,"Fn IsDmacReg : It is NOT a Dmac Register");
    debug_info(debugstr);

    return 0;
  }
}

/**********************************************************************/
/************************** Register Name *****************************/
/**********************************************************************/
char *RegisterName(int32 Address)
{
  char **RegisterList;
  RegisterList = DmacRegisters;

  /* if (DEBUG)
  {
    sprintf(debugstr,"Fn RegisterName : Address input is %X",Address);
    C(debugstr);
  } */
  sprintf(debugstr,"Fn RegisterName : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
   RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn RegisterName : Register Name is %s",*RegisterList);
      C(debugstr);
    } */
    sprintf(debugstr,"Fn RegisterName : Register Name is %s",*RegisterList);
    debug_info(debugstr);

    return *RegisterList;
  }
  else
  {
    /* if (DEBUG)
    {
      sprintf(debugstr,"Fn RegisterName : Register Name is RESERVED");
      C(debugstr);
    } */
    sprintf(debugstr,"Fn RegisterName : Register Name is RESERVED");
    debug_info(debugstr);

    return ("RESERVED");
  }
}

/**********************************************************************/
/************************* Write All Registers ************************/
/**********************************************************************/
void WriteAllReg(int32 data)
{
  int i, j;
  int32 RegisterAddr;
  int32 WriteData = data;

  for (i=0; i<4; i++)
  {
    RegisterAddr = DMAC_BASE + (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE+4)/4));
    HSA(RegisterAddr, NSEQ, INCR, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSW( , data);
    HSA( , SEQ, INCR, OK, WRD, 0x0, 0x0, , 0x0, , , );
    for (j=0; j<((DMAC_REGADDR_LIMIT-DMAC_BASE)/16); j++)
    {
      /* (j+1) is taken as the condition here, because one command is issued
         with an NSEQ transactios before this loop is entered. */
      if (strconst("DMACConfig") ==
        (DMAC_BASE + (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4)))
        {
         WriteData = data & DMACDISABLE;
        }
      else if (strconst("DMACTCR") ==
        (DMAC_BASE + (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4)))
        {
          WriteData = data & (~TESTMODE);
        }
      else if ((strconst("DMACC0Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC1Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC2Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC3Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC4Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC5Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC6Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))) ||
                 (strconst("DMACC7Config") == (DMAC_BASE +
                 (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4))))
        {
          WriteData = data & CHXDISABLE;
        }
      else
        {
         WriteData = data;
        }
      HSW( , WriteData);
    }
  }
}

/**********************************************************************/
/*********************** Write Group of Registers *********************/
/**********************************************************************/
void RegWrite(int32 data, int groupsize)
{
  int i, j, k;
  int32 RegisterAddr;
  int32 WriteData;
  char *RegName = "DMACIntStat";

  k = 0;
  while (RegName != "LASTREG")
  {
    if (!(k%groupsize))
    {
      data = ~data;
    }
    RegisterAddr = strconst(RegName);

    /* sprintf(debugstr,"Register Name is %s",RegName);
    C(debugstr); */
    sprintf(debugstr,"Register Name is %s",RegName);
    debug_info(debugstr);

    if (RegName == "DMACConfig")
    {
      WriteData = data & DMACDISABLE;
    }
    else if (RegName == "DMACTCR")
    {
      WriteData = data & (~TESTMODE);
    }
    else if ((RegName == "DMACC0Config") || (RegName == "DMACC1Config") ||
             (RegName == "DMACC2Config") || (RegName == "DMACC3Config") ||
             (RegName == "DMACC4Config") || (RegName == "DMACC5Config") ||
             (RegName == "DMACC6Config") || (RegName == "DMACC7Config"))
    {
      WriteData = data & CHXDISABLE;
    }
    else
    {
      WriteData = data;
    }

    HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSW( , WriteData);
    k++;
    RegName = NextRegisterName(RegName);
  }
}

/**********************************************************************/
/*********************** Read Group of Registers **********************/
/**********************************************************************/
void RegRead(int32 data, int groupsize)
{
  int i, j, k;
  int32 RegisterAddr;
  int32 ExpData;
  char *RegName = "DMACIntStat";

  k = 0;
  while (RegName != "LASTREG")
  {
    if (!(k%groupsize))
    {
      data = ~data;
    }
    RegisterAddr = strconst(RegName);
    if (IsReadOnly(RegisterAddr) == 1)
    {
     ExpData = strconst(stringcat("RDO_",RegName));
    }
    else if (IsWriteOnly(RegisterAddr) == 1)
    {
      ExpData = 0x00000000;
    }
    else
    {
      ExpData = strconst(stringcat("MASK_",RegName)) & (data);
      if (RegName == "DMACConfig")
      {
       ExpData = ExpData & DMACDISABLE;
      }
      else if (RegName == "DMACTCR")
      {
        ExpData = ExpData & (~TESTMODE);
      }
      else if ((RegName == "DMACC0Config") || (RegName == "DMACC1Config") ||
               (RegName == "DMACC2Config") || (RegName == "DMACC3Config") ||
               (RegName == "DMACC4Config") || (RegName == "DMACC5Config") ||
               (RegName == "DMACC6Config") || (RegName == "DMACC7Config"))
      {
        ExpData = ExpData & CHXDISABLE;
      }
    }

    HSA(RegisterAddr, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSR( , ExpData, , NoMask, ,DMA_REG_RW);
    k++;
    RegName = NextRegisterName(RegName);
  }
}

/**********************************************************************/
/**************************** Write access ****************************/
/**********************************************************************/
void Write(int32 address, int32 data)
{
    HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSW( , data);
}

/**********************************************************************/
/***************************** Read access ****************************/
/**********************************************************************/
void Read(int32 address, int32 data, int32 mask)
{
  HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}

/**********************************************************************/
/*********************** Random Value   Generator *********************/
/**********************************************************************/
int32 Random()
{
 int32 RandomValue;
 RandomValue = (rand() % 256)*16777216 +
               (rand() % 256)*65536    +
               (rand() % 256)*256      +
               (rand() % 256);
 return RandomValue;
}
 
/**********************************************************************/
/*********************** Channel Register Address *********************/
/**********************************************************************/
int32* ChannelRegisters(int ChannelNumber)
{
  if (ChannelNumber == 0)
  {
    return Channel0Regs;
  }
  else if (ChannelNumber == 1)
  {
    return Channel1Regs;
  }
  else if (ChannelNumber == 2)
  {
    return Channel2Regs;
  }
  else if (ChannelNumber == 3)
  {
    return Channel3Regs;
  }
  else if (ChannelNumber == 4)
  {
    return  Channel4Regs;
  }
  else if (ChannelNumber == 5)
  {
    return Channel5Regs;
  }
  else if (ChannelNumber == 6)
  {
    return Channel6Regs;
  }
  else if (ChannelNumber == 7)
  {
    return Channel7Regs;
  }
  else
  {
    C("Invalid Channel Number");
    return 0;
  }
}


/**********************************************************************/
/*************************** Source Peripheral  ************************/
/**********************************************************************/
int32 SpValue(int periphnum)
{
  if (periphnum == 0)
    return SrcPeriph0;
  else if (periphnum == 1)
    return SrcPeriph1;
  else if (periphnum == 2)
    return SrcPeriph2;
  else if (periphnum == 3)
    return SrcPeriph3;
  else if (periphnum == 4)
    return SrcPeriph4;
  else if (periphnum == 5)
    return SrcPeriph5;
  else if (periphnum == 6)
    return SrcPeriph6;
  else if (periphnum == 7)
    return SrcPeriph7;
  else if (periphnum == 8)
    return SrcPeriph8;
  else if (periphnum == 9)
    return SrcPeriph9;
  else if (periphnum == 10)
    return SrcPeriph10;
  else if (periphnum == 11)
    return SrcPeriph11;
  else if (periphnum == 12)
    return SrcPeriph12;
  else if (periphnum == 13)
    return SrcPeriph13;
  else if (periphnum == 14)
    return SrcPeriph14;
  else if (periphnum == 15)
    return SrcPeriph15;
  else
  {
    /* sprintf(debugstr,"Invalid Source Peripheral : %d",periphnum);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Peripheral : %d",periphnum);
    debug_info(debugstr);
    return SrcPeriph0;
  }
}

/**********************************************************************/
/************************ Destination Peripheral  *********************/
/**********************************************************************/
int32 DpValue(int periphnum)
{
  if (periphnum == 0)
    return DestPeriph0;
  else if (periphnum == 1)
    return DestPeriph1;
  else if (periphnum == 2)
    return DestPeriph2;
  else if (periphnum == 3)
    return DestPeriph3;
  else if (periphnum == 4)
    return DestPeriph4;
  else if (periphnum == 5)
    return DestPeriph5;
  else if (periphnum == 6)
    return DestPeriph6;
  else if (periphnum == 7)
    return DestPeriph7;
  else if (periphnum == 8)
    return DestPeriph8;
  else if (periphnum == 9)
    return DestPeriph9;
  else if (periphnum == 10)
    return DestPeriph10;
  else if (periphnum == 11)
    return DestPeriph11;
  else if (periphnum == 12)
    return DestPeriph12;
  else if (periphnum == 13)
    return DestPeriph13;
  else if (periphnum == 14)
    return DestPeriph14;
  else if (periphnum == 15)
    return DestPeriph15;
  else
  {
    /* sprintf(debugstr,"Invalid Destination Peripheral : %d",periphnum);
    C(debugstr); */
    sprintf(debugstr,"Invalid Destination Peripheral : %d",periphnum);
    debug_info(debugstr);
    return DestPeriph0;
  }
}

/**********************************************************************/
/***************************** SourceMaster ***************************/
/**********************************************************************/
int32 SmValue(int masternum)
{
  if (masternum == 0)
    return SMASTER0;
  else if (masternum == 1)
    return SMASTER1;
  else
  {
    /* sprintf(debugstr,"Invalid Source Master : %d",masternum);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Master : %d",masternum);
    debug_info(debugstr);
    return SMASTER0;
  }
}

/**********************************************************************/
/*************************** DestinationMaster ************************/
/**********************************************************************/
int32 DmValue(int masternum)
{
  if (masternum == 0)
    return DMASTER0;
  else if (masternum == 1)
    return DMASTER1;
  else
  {
    /* sprintf(debugstr,"Invalid Destination Master : %d",masternum);
    C(debugstr); */
    sprintf(debugstr,"Invalid Destination Master : %d",masternum);
    debug_info(debugstr);
    return DMASTER0;
  }
}

/**********************************************************************/
/***************************** SourceWidth  ***************************/
/**********************************************************************/
int32 SwValue(int width)
{
  if (width == 8)
    return SWIDTH8;
  else if (width == 16)
    return SWIDTH16;
  else if (width == 32)
    return SWIDTH32;
  else
  {
    /* sprintf(debugstr,"Invalid Source Width : %d",width);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Width : %d",width);
    debug_info(debugstr);
    return SWIDTH32;
  }
}

/**********************************************************************/
/*************************** DestinationWidth  ************************/
/**********************************************************************/
int32 DwValue(int width)
{
  if (width == 8)
    return DWIDTH8;
  else if (width == 16)
    return DWIDTH16;
  else if (width == 32)
    return DWIDTH32;
  else
  {
    /* sprintf(debugstr,"Invalid Destination Width : %d",width);
    C(debugstr); */
    sprintf(debugstr,"Invalid Destination Width : %d",width);
    debug_info(debugstr);
    return DWIDTH32;
  }
}

/**********************************************************************/
/**************************** SourceIncrement *************************/
/**********************************************************************/
int32 SiValue(const char *incr)
{
  if (incr == "NI")
    return SNONINCR;
  else if (incr == "I")
    return SINCR;
  else
  {
    /* sprintf(debugstr,"Invalid Source Increment : %s",*incr);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Increment : %s",*incr);
    debug_info(debugstr);
    return SNONINCR;
  }
}

/**********************************************************************/
/************************** DestinationIncrement **********************/
/**********************************************************************/
int32 DiValue(const char *incr)
{
  if (incr == "NI")
    return DNONINCR;
  else if (incr == "I")
    return DINCR;
  else
  {
    /* sprintf(debugstr,"Invalid Destination Increment : %s",*incr);
    C(debugstr); */
    sprintf(debugstr,"Invalid Destination Increment : %s",*incr);
    debug_info(debugstr);
    return DNONINCR;
  }
}

/**********************************************************************/
/***************************** SourceBurst  ***************************/
/**********************************************************************/
int32 SbValue(int burst)
{
  if (burst == 1)
    return SBURST1;
  else if (burst == 4)
    return SBURST4;
  else if (burst == 8)
    return SBURST8;
  else if (burst == 16)
    return SBURST16;
  else if (burst == 32)
    return SBURST32;
  else if (burst == 64)
    return SBURST64;
  else if (burst == 128)
    return SBURST128;
  else if (burst == 256)
    return SBURST256;
  else
  {
    /* sprintf(debugstr,"Invalid Source Master : %d",burst);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Master : %d",burst);
    debug_info(debugstr);
    return SBURST1;
  }
}

/**********************************************************************/
/*************************** DestinationBurst  ************************/
/**********************************************************************/
int32 DbValue(int burst)
{
  if (burst == 1)
    return DBURST1;
  else if (burst == 4)
    return DBURST4;
  else if (burst == 8)
    return DBURST8;
  else if (burst == 16)
    return DBURST16;
  else if (burst == 32)
    return DBURST32;
  else if (burst == 64)
    return DBURST64;
  else if (burst == 128)
    return DBURST128;
  else if (burst == 256)
    return DBURST256;
  else
  {
    /* sprintf(debugstr,"Invalid Source Master : %d",burst);
    C(debugstr); */
    sprintf(debugstr,"Invalid Source Master : %d",burst);
    debug_info(debugstr);
    return DBURST1;
  }
}

/**********************************************************************/
/*************************** Lock Transaction  ************************/
/**********************************************************************/
int32 LkValue(int lock)
{
  if (lock == 0)
    return NONLOCK;
  else if (lock == 1)
    return LOCK;
  else
  {
    /* sprintf(debugstr,"Invalid Lock Value : %d",lock);
    C(debugstr); */
    sprintf(debugstr,"Invalid Lock Value : %d",lock);
    debug_info(debugstr);
    return NONLOCK;
  }
}

/**********************************************************************/
/************************** Interupt Error mask  **********************/
/**********************************************************************/
int32 IeValue(int IntErrMask)
{
  sprintf(debugstr,"Function Name : IeValue\n");
  msg_info(debugstr);

  sprintf(debugstr,"Input IntErrMask : %d",IntErrMask);
  msg_info(debugstr);

  if (IntErrMask == 0)
  {
    sprintf(debugstr,"Output returned : %X",INTERRNOMASK);
    msg_info(debugstr);
    return INTERRNOMASK;
  }
  else if (IntErrMask == 1)
  {
    sprintf(debugstr,"Output returned : %X",INTERRMASK);
    msg_info(debugstr);
    return INTERRMASK;
  }
  else
  {
    /* sprintf(debugstr,"Invalid Interrupt Error Mask Value : %d",IntErrMask);
    C(debugstr); */
    sprintf(debugstr,"Invalid Interrupt Error Mask Value : %d",IntErrMask);
    debug_info(debugstr);
    return INTERRNOMASK;
  }
}

/**********************************************************************/
/*************************** TC Interrupt Mask ************************/
/**********************************************************************/
int32 ItValue(int IntTCMask)
{
  if (IntTCMask == 0)
    return INTTCNOMASK;
  else if (IntTCMask == 1)
    return INTTCMASK;
  else
  {
    /* sprintf(debugstr,"Invalid TC Interrupt Mask Value : %d",IntTCMask);
    C(debugstr); */
    sprintf(debugstr,"Invalid TC Interrupt Mask Value : %d",IntTCMask);
    debug_info(debugstr);
    return INTTCNOMASK;
  }
}

/**********************************************************************/
/************************** TC Interrupt Enable ***********************/
/**********************************************************************/
int32 TeValue(int IntTCEn)
{
  if (IntTCEn == 0)
    return INTTCDI;
  else if (IntTCEn == 1)
    return INTTCEN;
  else
  {
    /* sprintf(debugstr,"Invalid TC Interrupt Enable : %d",IntTCEn);
    C(debugstr); */
    sprintf(debugstr,"Invalid TC Interrupt Enable : %d",IntTCEn);
    debug_info(debugstr);
    return INTTCDI;
  }
}

/**********************************************************************/
/************************** Protection Control ************************/
/**********************************************************************/
int32 PtValue(int ProtBits)
{
  if (ProtBits == pbc)
  {
    return Dmacpbc;
  }
  else if (ProtBits == pbC)
  {
    return DmacpbC;
  }
  else if (ProtBits == pBc)
  {
    return DmacpBc;
  }
  else if (ProtBits == pBC)
  {
    return DmacpBC;
  }
  else if (ProtBits == Pbc)
  {
    return DmacPbc;
  }
  else if (ProtBits == PbC)
  {
    return DmacPbC;
  }
  else if (ProtBits == PBc)
  {
    return DmacPBc;
  }
  else if (ProtBits == PBC)
  {
    return DmacPBC;
  }
  else
  {
    /* sprintf(debugstr,"Invalid Protection bits : %d",ProtBits);
    C(message); */
    sprintf(debugstr,"Invalid Protection bits : %d",ProtBits);
    debug_info(debugstr);
    return Dmacpbc;
  }
}

void ChannelPrgm(int Channel, int32 SrcAddr, int32 DestAddr, int32 LLIReg,
                 int32 CxControlRegData)
{
 int i = 0;
 char Message[100];
 int32 *ChRegAddr;

 if ((Channel < 0) || (Channel > 7))
  {
    sprintf(Message,"Invalid Channel Number %d",Channel);
    C(Message);
  }

  ChRegAddr = ChannelRegisters(Channel);

  /* Programm Channel Source Address Register */
  Write(*ChRegAddr++, SrcAddr);

  /* Programm Channel Destination Address Register */
  Write(*ChRegAddr++, DestAddr);

  /* Programm Channel LLI Address Register */
  Write(*ChRegAddr++, LLIReg);

  /* Programm Channel Control Register */
  Write(*ChRegAddr++, CxControlRegData);
}

/*********************************** End **************************************/
