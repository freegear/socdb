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
-- File Revision          : 1.5
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
/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  Mem0            - Indicates slave module is Memory module 0         ***/
/***  Mem1            - Indicates slave module is Memory module 1         ***/
/***  NA              - Indicates Not Applicable                           ***/
/******************************************************************************/
#define Mem0  0xAAAAAAAA
#define Mem1  0xBBBBBBBB
int32   NA  = 0xFFFFFFFF;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  retstr          - To concatenate 2 strings in the function stringcat  ***/
/***  debugstr        - To issue the debug level messages during simulation ***/
/***  message         - To issue the informative messages during simulation ***/
/***  SrcPeripheral   - Source peripheral number (0 - 15)                   ***/
/***  DestPeripheral  - Destination peripheral number (0 - 15)              ***/
/***  SrcResponse     - This integer provides the combination of responses  ***/
/***                    to be programmed in the source memory/peripheral.   ***/
/***  DestResponse    - This integer provides the combination of responses  ***/
/***                    to be programmed in the destination                 ***/
/***                    memory/peripheral.                                  ***/
/***  Endianness      - This indicates the endianness of the AHB bus.       ***/
/***                    '0' indicates little endianness.                    ***/
/***                    '1' indicates big endianness.                       ***/
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
int Endianness    = 0;

int SrcOkay, SrcWait, SrcRetry, SrcSplit, SrcError;
int DestOkay, DestWait, DestRetry, DestSplit, DestError;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  RANDOM          - Indicates RANDOM Data Generation Method             ***/
/***  GRAYCODE        - Indicates GRAYCODE Data Generation Method           ***/
/***  ADDRBASED       - Indicates Address based Data Generation Method      ***/
/***  DATABASED       - Indicates Databased Data Generation Method          ***/
/******************************************************************************/
int32 RANDOM          = 0x00000000;
int32 GRAYCODE        = 0x00000100;
int32 ADDRBASED       = 0x00000200;
int32 DATABASED       = 0x00000300;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  INCREMENT       - Indicates INCREMENT Data Method                    ***/
/***  DECREMENT       - Indicates DECREMENT Data Method                    ***/
/***  ONESCOMP        - Indicates One's Complement Data Method             ***/
/***  TWOSCOMP        - Indicates Two's Complement Data Method             ***/
/***  Note :                                                                ***/
/***    The above sub methods are used along with four data generation      ***/
/***  method. The above sub methods are only applicable to Address and Data ***/
/***  generation method.
/*** ---------------------------------------------------------------------- ***/
/*** |   DATA Generation Method  |  Sub Methods Applicable                | ***/
/*** ---------------------------------------------------------------------- ***/
/*** | RANDOM                    |          NA                            | ***/
/*** | GRAYCODE                  |          NA                            | ***/
/*** | ADDRBASED                 | INCREMENT, DECREMENT, ONESCOMP,TWOSCOMP|***/
/*** | DATABASED                 | INCREMENT, DECREMENT                   | ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
int32 INCREMENT       = 0x00000000;
int32 DECREMENT       = 0x00000040;
int32 ONESCOMP        = 0x00000080;
int32 TWOSCOMP        = 0x000000C0;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  GrantReqBased   - Indicates Request based Grant toggle              ***/
/***  Count7          - Indicates toggle count of 7                        ***/
/***  Count10         - Indicates toggle count of 10                       ***/
/***  Count12         - Indicates toggle count of 12                       ***/
/***  Count20         - Indicates toggle count of 20                       ***/
/******************************************************************************/
int32 GrantReqBased   = 0x00000800;
int32 Count7          = 0x00000007;
int32 Count10         = 0x0000000A;
int32 Count12         = 0x0000000C;
int32 Count20         = 0x00000014;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  LLIADDRM1       - Indicates Memory 0 LLI block start address         ***/
/***  LLIADDRM2       - Indicates Memory 1 LLI block start address         ***/
/***  LLISlaveAddrM1  - Indicates Memory 0 LLI block slave address         ***/
/***  LLISlaveAddrM2  - Indicates Memory 1 LLI block slave address         ***/
/******************************************************************************/
int32 LLIADDRM1       = DMACTRMEM0BASE;
int32 LLIADDRM2       = DMACTRMEM1BASE;
int32 LLISlaveAddrM1  = DMACTRMEM0REGBASE | 0x00000200;
int32 LLISlaveAddrM2  = DMACTRMEM0REGBASE | 0x00000200;

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ReqExpValue     - Indicates Mask for Peripheral                      ***/
/***  PeriphMasterSel - Indicates Memory or Peripheral Select              ***/
/***  Note :                                                                ***/
/***  The ReqExpValue variable is used to determine Mask/Expected value     ***/
/***    while polling the DMAC SoftReq register.                            ***/
/***  The PeriphMasterSel variable is used to configure DMACREQCONFIG reg.  ***/
/***    If Memory/Peripheral module is programmed for Master2, respective   ***/
/***    bit of DMACREQCONFIG register is set.                               ***/
/******************************************************************************/
int32 ReqExpValue[] = {0x00000001, 0x00000002, 0x00000004, 0x00000008,
                       0x00000010, 0x00000020, 0x00000040, 0x00000080,
                       0x00000100, 0x00000200, 0x00000400, 0x00000800,
                       0x00001000, 0x00002000, 0x00004000, 0x00008000};

int32 PeriphMasterSel[] = {0x00000001, 0x00000002, 0x00000004, 0x00000008,
                           0x00000010, 0x00000020, 0x00000040, 0x00000080,
                           0x00000100, 0x00000200, 0x00000400, 0x00000800,
                           0x00001000, 0x00002000, 0x00004000, 0x00008000,
                           0x00010000, 0x00020000};


/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ConstantList    - It contains the constant names and their values,    ***/
/***                    as defined in Dmac.h, as its elements. It is used   ***/
/***                    to get the constant values, given their names.      ***/
/******************************************************************************/
struct ConstantList {
  char *ConstantName;
  int32 ConstantValue;
};

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ChannelPara     - It contains the definition of channel parameters.   ***/
/******************************************************************************/
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

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  FourChParameters - It contains the definition of channel parameters of***/
/***                     four channel. Also it contans the programmed       ***/
/***                     responses, Data generation method definition.      ***/
/******************************************************************************/
struct FourChParameters {
   struct ChannelPara *FirstChannel;
   struct ChannelPara *SecondChannel;
   struct ChannelPara *ThirdChannel;
   struct ChannelPara *FourthChannel;
   int    WhichChEnableFirst;
   int32  DataGenMethod;
   int32  DataMethod;
   int32  IsAnyPrgmResp;
   int32  NoOfPrgmResp;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  EightChPara     - It contains the definition of channel parameters of ***/
/***                    eight channel. Also it contans the programmed       ***/
/***                    responses, Data generation method definition.       ***/
/******************************************************************************/
struct EightChPara{
   struct ChannelPara *FirstChannel;
   struct ChannelPara *SecondChannel;
   struct ChannelPara *ThirdChannel;
   struct ChannelPara *FourthChannel;
   struct ChannelPara *FifthChannel;
   struct ChannelPara *SixthChannel;
   struct ChannelPara *SeventhChannel;
   struct ChannelPara *EighthChannel;
   int    WhichChEnableFirst;
   int32  DataGenMethod;
   int32  DataMethod;
   int32  IsAnyPrgmResp;
   int32  NoOfPrgmResp;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  FourChTotalCases - It contains the definition of Test name and        ***/
/***                     respective pointer to test parameters              ***/
/***                     responses, Data generation method definition.      ***/
/******************************************************************************/
struct FourChTotalCases {
   char *TestNo;
   struct FourChParameters *FourChData;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  EightChTotalCases - It contains the definition of Test name and       ***/
/***                      respective pointer to test parameters             ***/
/***                      responses, Data generation method definition.     ***/
/******************************************************************************/
struct EightChTotalCases {
   char *TestNo;
   struct EightChPara *EightChData;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  RespPara         - It contains the definition of programmed response  ***/
/***                     parameters.                                        ***/
/******************************************************************************/
struct RespPara{
   int32 PeriphValue;
   int32 ControlMethod;
   int32 Size;
   int32 ValidBits;
   int32 NoOfPrgmdSRResp;
   int32 ProgrammedWaitCyc;
   int32 ProgrammedResp;
   int32 AddrDataCount;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  DMAReq           - It contains the definition of number of DMA        ***/
/***                     requests to be asserted. It is used in two channel ***/
/***                     test cases.                                        ***/
/******************************************************************************/
struct DMAReq {
   int FirstChSrcSREQ;
   int FirstChSrcBREQ;
   int FirstChSrcLSREQ;
   int FirstChSrcLBREQ;
   int FirstChDestSREQ;
   int FirstChDestBREQ;
   int FirstChDestLSREQ;
   int FirstChDestLBREQ;
   int SecondChSrcSREQ;
   int SecondChSrcBREQ;
   int SecondChSrcLSREQ;
   int SecondChSrcLBREQ;
   int SecondChDestSREQ;
   int SecondChDestBREQ;
   int SecondChDestLSREQ;
   int SecondChDestLBREQ;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  PrgmCases        - It contains the definition of test number and its  ***/
/***                     programmed response parameters                     ***/
/******************************************************************************/
struct PrgmCases{
   char *TestNo;
   struct RespPara *PrgmRespPara;
  };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  PeriphReq        - It contains the definition of test number and its  ***/
/***                     number of DMA requests                             ***/
/******************************************************************************/
 struct PeriphReq {
    char *TestNo;
    struct DMAReq *Request;
   };
 
/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  ReadOnlyRegisters  - Contains the names of all the read-only          ***/
/***                       registers of DMAC. It is used to check whether   ***/
/***                       the given rgister name is a read-only register.  ***/
/***  WriteOnlyRegisters - Contains the names of all the write-only         ***/
/***                       registers of DMAC. It is used to check whether   ***/
/***                       the given rgister name is a write-only register. ***/
/***  DmacRegisters      - Contains the names of all the DMAC registers     ***/
/***                       in the ascending order of the address. It is     ***/
/***                       used in RegisterName/NextRegisterName/IsDmacReg  ***/
/***                       functions.                                       ***/
/*** DmacConstants       - Name and value of constants.                     ***/
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

/******************************************************************************/
/*** The channel specific registers are defined in an order for programming ***/
/*** The order of registers is :                                            ***/
/*** 1. DMACCxSrcAddr  - Source address register.                           ***/
/*** 2. DMACCxDestAddr - Destinatin address register.                       ***/
/*** 3. DMACCxLLIReg   - LLI address register.                              ***/
/*** 4. DMACCxControl  - Channel control register.                          ***/
/*** 5. DMACCxConfig   - Channel configuration register.                    ***/
/*** They are used while programming the channel for a dma transfer.        ***/
/******************************************************************************/
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
 
/******************************************************************************/
/*** Channel configuration registers are declared as an array.              ***/
/******************************************************************************/
int32 ConfigRegs[8]   = {DMACC0Config, DMACC1Config,
                         DMACC2Config, DMACC3Config,
                         DMACC4Config, DMACC5Config,
                         DMACC6Config, DMACC7Config};

/******************************************************************************/
/*** The base address for the 16 peripherals are declared as an array.      ***/
/******************************************************************************/
int32 PeriphRegBase[16] = {DMACTRP0REGBASE, DMACTRP1REGBASE, DMACTRP2REGBASE,
                           DMACTRP3REGBASE, DMACTRP4REGBASE, DMACTRP5REGBASE,
                           DMACTRP6REGBASE, DMACTRP7REGBASE, DMACTRP8REGBASE,
                           DMACTRP9REGBASE, DMACTRP10REGBASE, DMACTRP11REGBASE,
                           DMACTRP12REGBASE, DMACTRP13REGBASE, DMACTRP14REGBASE,
                           DMACTRP15REGBASE};

/******************************************************************************/
/*** The following are the control parameters to be programmed in the       ***/
/*** memory/peripheral models to return the programmed response during      ***/
/*** the dma transfer. For further details, please refer to the block       ***/
/*** verification document.                                                 ***/
/*** The following variables are used to program the number of wait/retry/  ***/
/*** split responses to be returned by the memory/peripheral models.        ***/
/******************************************************************************/
int32 DefaultWaitCycles[16] = {DEFWAIT0, DEFWAIT1, DEFWAIT2, DEFWAIT3,
                               DEFWAIT4, DEFWAIT5, DEFWAIT6, DEFWAIT7,
                               DEFWAIT8, DEFWAIT9, DEFWAIT10, DEFWAIT11,
                               DEFWAIT12, DEFWAIT13, DEFWAIT14, DEFWAIT15};
 
int32 DefaultRSCount[4]     = {DEFRSCOUNT0, DEFRSCOUNT1,
                               DEFRSCOUNT2, DEFRSCOUNT3};
 
int32 ValidLSB[16]          = {VALIDLSB0, VALIDLSB1, VALIDLSB2, VALIDLSB3,
                               VALIDLSB4, VALIDLSB5, VALIDLSB6, VALIDLSB7,
                               VALIDLSB8, VALIDLSB9, VALIDLSB10, VALIDLSB11,
                               VALIDLSB12, VALIDLSB13, VALIDLSB14, VALIDLSB15};
 
int32 ProgramRSCount[4]     = {PGMRSCOUNT0, PGMRSCOUNT1,
                               PGMRSCOUNT2, PGMRSCOUNT3};
 
int32 ProgramWaitCycles[16] = {PGMWAIT0, PGMWAIT1, PGMWAIT2, PGMWAIT3,
                               PGMWAIT4, PGMWAIT5, PGMWAIT6, PGMWAIT7,
                               PGMWAIT8, PGMWAIT9, PGMWAIT10, PGMWAIT11,
                               PGMWAIT12, PGMWAIT13, PGMWAIT14, PGMWAIT15};
 
/******************************************************************************/
/*** The following is a list of low and high address ranges of the          ***/
/*** 16 peripherals used in DMAC testing.                                   ***/
/******************************************************************************/
int32 PeriphLowAddress[16] = {P0LOWADDRRANGE, P1LOWADDRRANGE,
                              P2LOWADDRRANGE, P3LOWADDRRANGE,
                              P4LOWADDRRANGE, P5LOWADDRRANGE,
                              P6LOWADDRRANGE, P7LOWADDRRANGE,
                              P8LOWADDRRANGE, P9LOWADDRRANGE,
                              P10LOWADDRRANGE, P11LOWADDRRANGE,
                              P12LOWADDRRANGE, P13LOWADDRRANGE,
                              P14LOWADDRRANGE, P15LOWADDRRANGE};

int32 PeriphHighAddress[16] = {P0HIGHADDRRANGE, P1HIGHADDRRANGE,
                               P2HIGHADDRRANGE, P3HIGHADDRRANGE,
                               P4HIGHADDRRANGE, P5HIGHADDRRANGE,
                               P6HIGHADDRRANGE, P7HIGHADDRRANGE,
                               P8HIGHADDRRANGE, P9HIGHADDRRANGE,
                               P10HIGHADDRRANGE, P11HIGHADDRRANGE,
                               P12HIGHADDRRANGE, P13HIGHADDRRANGE,
                               P14HIGHADDRRANGE, P15HIGHADDRRANGE};

/******************************************************************************/
/********************************* Common Functions ***************************/
/******************************************************************************/

/******************************************************************************/
/************************************* Message   ******************************/
/******************************************************************************/

void msg_info(char *message)
{
  /* Summary:
     ========
     If the constant INFO is set to '1' in Dmac.h file, this will print
     informative messages during testing.
  */
  if (INFO == 1)
    C(message);
}

/******************************************************************************/
/*********************************** Debug Message ****************************/
/******************************************************************************/

void debug_info(char *message)
{
  /* Summary :
     =========
     If the constant DEBUG is set to '1' in Dmac.h file, this will print
     debugging related messages during testing. While using this, ensure
     that only one test case is simulated, as it will give too many messages.
  */
  if (DEBUG == 1)
    C(message);
}

/******************************************************************************/
/************************************* Wait Loop ******************************/
/******************************************************************************/

void WaitLoop(int cyc)
{
  /*
     Summary:
     ========
     o  Inserts programmed number of idle cycles.
  */
 
  int i;
 
  for (i = 0; i < cyc; i++)
  {
    HSA(ZERO, IDLE, INCR, , WRD);
    HSR( , ZERO, , MaskAll);
  }
}

/******************************************************************************/
/***************************** String-Constant Conversion *********************/
/******************************************************************************/
int32 strconst (char *constname)
{
  /*
     Summary:
     ========
     o  Any constant name that is defined in DmacConstants variable
        can be passed on to this function and it returns the value of
        the constant.
  */

  char *prnstr;
  struct ConstantList *StrConstPtr;

  StrConstPtr = DmacConstants;

  sprintf(debugstr,"Fn strconst : Constant Name is %s",constname);
  debug_info(debugstr);

  sprintf(debugstr,"Fn strconst : Comparing against %s",
            StrConstPtr->ConstantName);
  debug_info(debugstr);

  while (strcmp(constname,StrConstPtr->ConstantName) != 0)
  {
    StrConstPtr++;

    sprintf(debugstr,"Fn strconst : Comparing against %s",
              StrConstPtr->ConstantName);
    debug_info(debugstr);

    if (StrConstPtr->ConstantName == "LASTREG")
    {
      sprintf(debugstr,"Error : Constant %s Not found.\n",constname);
      debug_info(debugstr);

      return 0;
    }
  }

  sprintf(debugstr,"Fn strconst : Constant Value is %X",
            StrConstPtr->ConstantValue);
  debug_info(debugstr);

  return StrConstPtr->ConstantValue;
}

/******************************************************************************/
/********************************* Next register name *************************/
/******************************************************************************/
char *NextRegisterName (const char *currentregname)
{
  /*
     Summary:
     ========
     o  Given a register name of the Dma controller, as defined in Dmac.h file,
        this function will return the next register's name.
  */
  char **prnstr;
  prnstr = DmacRegisters;
  sprintf(debugstr,"Fn NextRegisterName : Current Register Name is %s",
            currentregname);
  debug_info(debugstr);

  while ((strcmp(*prnstr,currentregname) != 0) &&
         (*prnstr != "LASTREG"))
  {
    prnstr++;
  }

  prnstr++;

  sprintf(debugstr,"Fn NextRegisterName : Next Register Name is %s",*prnstr);
  debug_info(debugstr);

  return *prnstr;
}

/******************************************************************************/
/********************************* String Concatenation ***********************/
/******************************************************************************/
char *stringcat(char *string1, char *string2)
{
  /*
     Summary:
     ========
     o This will combine the given two strings, first string followed by the
       second one.
  */
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

/******************************************************************************/
/********************************** Read Only Register ************************/
/******************************************************************************/
int IsReadOnly(const int32 Address)
{
  /*
     Summary:
     ========
     o Given a register address, this funcation will return 1, if it is a
       read-only register of Dmac. Otherwise it returns 0.
  */
  char **RegisterList;
  RegisterList = ReadOnlyRegisters;

  sprintf(debugstr,"Fn IsReadOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsReadOnly : It is a Read Only Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsReadOnly : It is NOT a Read Only Register");
    debug_info(debugstr);

    return 0;
  }
}

/******************************************************************************/
/********************************** Write Only Register ***********************/
/******************************************************************************/
int IsWriteOnly(const int32 Address)
{
  /*
     Summary:
     ========
     o Given a register address, this funcation will return 1, if it is a
       write-only register of Dmac. Otherwise it returns 0.
  */
  char **RegisterList;
  RegisterList = WriteOnlyRegisters;

  sprintf(debugstr,"Fn IsWriteOnly : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsWriteOnly : It is a Write Only Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsWriteOnly : It is NOT a Write Only Register");
    debug_info(debugstr);

    return 0;
  }
}

/******************************************************************************/
/***************************** An element of the given array  *****************/
/******************************************************************************/
int IsElement(const int32 Address, const int32 *Array,
              const int ArraySize)
{
  /*
     Summary:
     ========
     o This function will find whether the given "Address" input is part of
       the given "Array" of addresses. The size of the array, i.e., number of
       elements in the array, should also be provided while calling this
       function.
  */
  int index = 0;

  sprintf(debugstr,"Function IsElement :");
  debug_info(debugstr);

  sprintf(debugstr,"Address is : %X",Address);
  debug_info(debugstr);

  sprintf(debugstr,"ArraySize is : %X",ArraySize);
  debug_info(debugstr);

  while ((Array[index] != Address) && (index < ArraySize))
  {
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

/******************************************************************************/
/********************************** All DMAC Registers ************************/
/******************************************************************************/
int IsDmacReg(const int32 Address)
{
  /*
     Summary:
     ========
     o Given a register address, this will find out whether it is a valid
       Dmac register address.
  */
  char **RegisterList;
  RegisterList = DmacRegisters;

  sprintf(debugstr,"Fn IsDmacReg : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn IsDmacReg : It is a Dmac Register");
    debug_info(debugstr);

    return 1;
  }
  else
  {
    sprintf(debugstr,"Fn IsDmacReg : It is NOT a Dmac Register");
    debug_info(debugstr);

    return 0;
  }
}

/******************************************************************************/
/********************************** Register Name *****************************/
/******************************************************************************/
char *RegisterName(int32 Address)
{
  /*
     Summary:
     ========
     o Given a Dmac register address, this will return the name of the register.
  */
  char **RegisterList;
  RegisterList = DmacRegisters;

  sprintf(debugstr,"Fn RegisterName : Address input is %X",Address);
  debug_info(debugstr);

  while ((strconst(*RegisterList) != Address) &&
         (*RegisterList != "LASTREG"))
  {
    RegisterList++;
  }

  if (strconst(*RegisterList) == Address)
  {
    sprintf(debugstr,"Fn RegisterName : Register Name is %s",*RegisterList);
    debug_info(debugstr);

    return *RegisterList;
  }
  else
  {
    sprintf(debugstr,"Fn RegisterName : Register Name is RESERVED");
    debug_info(debugstr);

    return ("RESERVED");
  }
}

/******************************************************************************/
/********************************* Write All Registers ************************/
/******************************************************************************/
void WriteAllReg(int32 data)
{
  /*
     Summary:
     ========
     o This function will write the given data, to all of the Dmac registers.
  */
  int i, j;
  int32 RegisterAddr;
  int32 WriteData = data;

  /* The address space of Dmac registers is 4KB, i.e., 0x000 - 0xFFF.
     The register write accesses will be initiated as an undefined
     increment (INCR) accesses on the AHB bus. There are four bursts
     of write accesses to avoid crossing the 1KB boundary.            */
  for (i=0; i<4; i++)
  {
    RegisterAddr = DMAC_BASE + (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE+4)/4));
    HSA(RegisterAddr, NSEQ, INCR, OK, WRD, 0x0, 0x0, , 0x0, , , );
    HSW( , data);
    HSA( , SEQ, INCR, OK, WRD, 0x0, 0x0, , 0x0, , , );

    /* As the registers are word-wide, there are 256 write accesses during
       each INCR burst access on the AHB bus.                              */
    for (j=0; j<((DMAC_REGADDR_LIMIT-DMAC_BASE)/16); j++)
    {
      /* (j+1) is taken as the condition here, because one command is issued
         with an NSEQ transactios before this loop is entered. */
      if (strconst("DMACConfig") ==
        (DMAC_BASE + (i * ((DMAC_REGADDR_LIMIT-DMAC_BASE)/16)) + ((j+1) * 4)))
      {
        /* Dmac is disabled during register tests. */
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
        /* All channels are disabled during register tests. */
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

/******************************************************************************/
/******************************* Write Group of Registers *********************/
/******************************************************************************/
void RegWrite(int32 data, int groupsize)
{
  /*
     Summary:
     ========
     o This function will write the given data into a group of Dmac registers.
       For example, if the "groupsize" is 2, then the given data will be
       written into registers 1-2, 5-6, 9-10 and so on. Please note that the
       sequence consists of valid Dmac registers only (Two successive Dmac
       registers need not be separated by a word address). Similarly if the
       "groupsize" is 4, then the given data will be written into registers
       1-4, 9-12, 17-20 and so on. Other registers will be written with
       1's compliment of the "data". Use the function RegRead() to read back
       all the "data" written into the Dmac registers.
  */
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

    sprintf(debugstr,"Register Name is %s",RegName);
    debug_info(debugstr);

    /* As this function is used during register tests, Dmac and all channel
       enable bits are reset.                                              */
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

/******************************************************************************/
/******************************* Read Group of Registers **********************/
/******************************************************************************/
void RegRead(int32 data, int groupsize)
{
  /*
     Summary:
     ========
     o This function will read the given data from a group of Dmac registers.
       For example, if the "groupsize" is 2, then the given data will be
       read from registers 1-2, 5-6, 9-10 and so on. Please note that the
       sequence consists of valid Dmac registers only (Two successive Dmac
       registers need not be separated by a word address). Similarly if the
       "groupsize" is 4, then the given data will be read from registers
       1-4, 9-12, 17-20 and so on. 1's compliment of the data will be
       read from other registers.
       Please note that this function should be called only if the registers
       are written using "RegWrite" function.
  */
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

    /* If the register is a read-only register, then its value should not be
       affected by a write access to that register.
       As this function is used during register tests, the Dmac and all channel
       enable bits are expected to be reset.                                 */
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

/******************************************************************************/
/************************************ Write access ****************************/
/******************************************************************************/
void Write(int32 address, int32 data)
{
  /*
     Summary:
     ========
     o AHB write access will be initiated. It is used for all register
       writes while programming the Dmac.
  */
  HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}

/******************************************************************************/
/******************************* Idle Write access ****************************/
/******************************************************************************/
void IdleWrite(int32 address, int32 data, char size)
{
  /*
     Summary:
     ========
     o Idle cycles will be intiated on the AHB bus, with the given data-size.
  */
  HSA(address, IDLE, WRAP4, OK, size, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}

/******************************************************************************/
/************************ Write access - Error response ***********************/
/******************************************************************************/
void WriteErr(int32 address, int32 data, char size)
{
  /*
     Summary:
     ========
     o AHB write access will be initiated, with the given data-size.
  */
  HSA(address, NSEQ, SINGLE, ERROR, size, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}

/******************************************************************************/
/************************************* Read access ****************************/
/******************************************************************************/
void Read(int32 address, int32 data, int32 mask)
  /*
     Summary:
     ========
     o AHB read access will be initiated. It is used for all register
       reads during Dmac testing.
  */
{
  HSA(address, NSEQ, SINGLE, OK, WRD, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}

/******************************************************************************/
/************************************* Read access ****************************/
/******************************************************************************/
void ReadErr (int32 address, int32 data, int32 mask, char size)
  /*
     Summary:
     ========
     o AHB read access will be initiated with the given data-size.
  */
{
  HSA(address, NSEQ, SINGLE, ERROR, size, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}

/******************************************************************************/
/*************************** Random Value Generator ***************************/
/******************************************************************************/
int32 Random()
{
  /*
     Summary:
     ========
     o Creates a random number of 32 bits wide.
  */
  int32 RandomValue;
  RandomValue = (rand() % 256)*16777216 +
                (rand() % 256)*65536    +
                (rand() % 256)*256      +
                (rand() % 256);
  return RandomValue;
}
 
/******************************************************************************/
/*************************** Random Address Generator *************************/
/******************************************************************************/
int32 AddrGen(const int32 LowAddress, const int32 HighAddress)
{
  /*
     Summary:
     ========
     o This funcation will generate a random address (byte-wide) that falls
       between the given "LowAddress" and "HighAddress" values.
  */
  int32 Address;
  int32 AddressRange = HighAddress - LowAddress;
  int32 Byte3 = ((AddressRange & 0xFF000000) >> 24);
  int32 Byte2 = ((AddressRange & 0x00FF0000) >> 16);
  int32 Byte1 = ((AddressRange & 0x0000FF00) >> 8);
  int32 Byte0 = (AddressRange & 0x000000FF);

  sprintf(debugstr,"LowerAddress : %8X", LowAddress);
  debug_info(debugstr);

  sprintf(debugstr,"HigherAddress : %8X", HighAddress);
  debug_info(debugstr);

  sprintf(debugstr,"Range : %8X", AddressRange);
  debug_info(debugstr);

  sprintf(debugstr,"Byte3 : %8X", Byte3);
  debug_info(debugstr);

  sprintf(debugstr,"Byte2 : %8X", Byte2);
  debug_info(debugstr);

  sprintf(debugstr,"Byte1 : %8X", Byte1);
  debug_info(debugstr);

  sprintf(debugstr,"Byte0 : %8X", Byte0);
  debug_info(debugstr);

  if (Byte3)
    Byte3 = rand() % Byte3;

  if (Byte2)
    Byte2 = rand() % Byte2;

  if (Byte1)
    Byte1 = rand() % Byte1;

  if (Byte0)
    Byte0 = rand() % Byte0;

  sprintf(debugstr,"Byte3 : %8X", Byte3);
  debug_info(debugstr);

  sprintf(debugstr,"Byte2 : %8X", Byte2);
  debug_info(debugstr);

  sprintf(debugstr,"Byte1 : %8X", Byte1);
  debug_info(debugstr);

  sprintf(debugstr,"Byte0 : %8X", Byte0);
  debug_info(debugstr);

  Address = LowAddress +
            ((Byte3 << 24) + (Byte2 << 16) + (Byte1 << 8) + Byte0);

  sprintf(debugstr,"Address Generated : %8X",Address);
  debug_info(debugstr);

  return Address;
}

/******************************************************************************/
/************************ Source Peripheral Generation ************************/
/******************************************************************************/
void SrcPeriphNo()
{
  /*
     Summary:
     ========
     o If the test is run in the "USER" defined mode, then the source peripheral
       value will be same as SPERIPH, as defined in Dmac.h file. Otherwise it
       will be changed during testing.
  */
  if (TESTCONFIGURATION == "USER")
  {
    SrcPeripheral = SPERIPH;
  }
  else
  {
    /* Dmac can handle upto a maximum of 16 peripherals. */
    SrcPeripheral = (SrcPeripheral + 1) % 16;
  }
}

/******************************************************************************/
/************************ Destination Peripheral Generation *******************/
/******************************************************************************/
void DestPeriphNo()
{
  /*
     Summary:
     ========
     o If the test is run in the "USER" defined mode, then the destination
       peripheral value will be same as DPERIPH, as defined in Dmac.h file.
       Otherwise it will be changed during testing.
  */
  if (TESTCONFIGURATION == "USER")
  {
    DestPeripheral = DPERIPH;
  }
  else
  {
    /* Dmac can handle upto a maximum of 16 peripherals. */
    DestPeripheral = (DestPeripheral + 1) % 16;

    /* The source and destination peripheral values cannot be same during a P2P
       Dma transfer. Therefore the Destination peripheral value will be
       incremented to the next peripheral number.                             */
    while (DestPeripheral == SrcPeripheral)
    {
      DestPeripheral = (DestPeripheral + 1) % 16;
    }
  }
}

/******************************************************************************/
/******************************* Channel Register Address *********************/
/******************************************************************************/
int32* ChannelRegisters(int ChannelNumber)
{
  /*
     Summary:
     ========
     o Given a channel number, between 0-7, this function will return a
       pointer to an array of channel registers.
  */
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

/******************************************************************************/
/************************************* Poll command ***************************/
/******************************************************************************/
void Poll(int32 address, int32 data, int32 mask)
{
  /*
     Summary:
     ========
     o This will initiate an AHB BusTalk Poll command.
  */
  HSA(address, NSEQ, SINGLE, OK, WRD, , 0x0, ,);
  HPO( , data, , mask, , 0xFFFFFFFF,POLLCOMMAND);

  /* Two successive poll commands cannot be issued continuously, according to
     the AHB BusTalk rules. The following idle cycle will avoid this.        */
  WaitLoop(1);
}

/******************************************************************************/
/**************************** Peripheral Registers ****************************/
/******************************************************************************/
int32 PeriphReg(int Peripheral, int32 Offset)
{
  /*
     Summary:
     ========
     o Given the Peripheral number (0-15) and the register offset, from the
       base address, of the peripheral registers, this will return the address
       of the register.
  */
  return (PeriphRegBase[Peripheral] + Offset);
}

/******************************************************************************/
/***************************** Source Peripheral ******************************/
/******************************************************************************/
int32 SpValue(int periphnum)
{
  /*
     Summary:
     ========
     o Given a source peripiheral number (0-15), this function will return the
       32 bit hex value to be written in the channel configuration register.
  */
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
    sprintf(debugstr,"Invalid Source Peripheral : %d",periphnum);
    debug_info(debugstr);
    return SrcPeriph0;
  }
}

/******************************************************************************/
/******************************** Destination Peripheral  *********************/
/******************************************************************************/
int32 DpValue(int periphnum)
{
  /*
     Summary:
     ========
     o Given a destination peripiheral number (0-15), this function will return
       the 32 bit hex value to be written in the channel configuration register.
  */
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
    sprintf(debugstr,"Invalid Destination Peripheral : %d",periphnum);
    debug_info(debugstr);
    return DestPeriph0;
  }
}

/******************************************************************************/
/************************************* SourceMaster ***************************/
/******************************************************************************/
int32 SmValue(int masternum)
{
  /*
     Summary:
     ========
     o Given a master port (0-1) of the source dma transfer, this function
       will return a 32 bit hex value to be written in the channel control
       register.
  */
  if (masternum == 0)
    return SMASTER0;
  else if (masternum == 1)
    return SMASTER1;
  else
  {
    sprintf(debugstr,"Invalid Source Master : %d",masternum);
    debug_info(debugstr);
    return SMASTER0;
  }
}

/******************************************************************************/
/*********************************** DestinationMaster ************************/
/******************************************************************************/
int32 DmValue(int masternum)
{
  /*
     Summary:
     ========
     o Given a master port (0-1) of the destination dma transfer, this function
       will return a 32 bit hex value to be written in the channel control
       register.
  */
  if (masternum == 0)
    return DMASTER0;
  else if (masternum == 1)
    return DMASTER1;
  else
  {
    sprintf(debugstr,"Invalid Destination Master : %d",masternum);
    debug_info(debugstr);
    return DMASTER0;
  }
}

/******************************************************************************/
/************************************* SourceWidth  ***************************/
/******************************************************************************/
int32 SwValue(int width)
{
  /*
     Summary:
     ========
     o Given the source width (8/16/32 bits) of the dma transfer, this function
       will return a 32 bit hex value to be written in the channel control
       register.
  */
  if (width == 8)
    return SWIDTH8;
  else if (width == 16)
    return SWIDTH16;
  else if (width == 32)
    return SWIDTH32;
  else
  {
    sprintf(debugstr,"Invalid Source Width : %d",width);
    debug_info(debugstr);
    return SWIDTH32;
  }
}

/******************************************************************************/
/*********************************** DestinationWidth  ************************/
/******************************************************************************/
int32 DwValue(int width)
{
  /*
     Summary:
     ========
     o Given the destination width (8/16/32 bits) of the dma transfer, this
       function will return a 32 bit hex value to be written in the channel
       control register.
  */
  if (width == 8)
    return DWIDTH8;
  else if (width == 16)
    return DWIDTH16;
  else if (width == 32)
    return DWIDTH32;
  else
  {
    sprintf(debugstr,"Invalid Destination Width : %d",width);
    debug_info(debugstr);
    return DWIDTH32;
  }
}

/******************************************************************************/
/************************************ SourceIncrement *************************/
/******************************************************************************/
int32 SiValue(const char *incr)
{
  /*
     Summary:
     ========
     o Given that the address of the source dma transfer to be incremented
       or not ("I"/"NI"), this function will return a 32 bit hex value to be
       written in the channel control register.
  */
  if (incr == "NI")
    return SNONINCR;
  else if (incr == "I")
    return SINCR;
  else
  {
    sprintf(debugstr,"Invalid Source Increment : %s",*incr);
    debug_info(debugstr);
    return SNONINCR;
  }
}

/******************************************************************************/
/********************************** DestinationIncrement **********************/
/******************************************************************************/
int32 DiValue(const char *incr)
{
  /*
     Summary:
     ========
     o Given that the address of the destination dma transfer to be incremented
       or not ("I"/"NI"), this function will return a 32 bit hex value to be
       written in the channel control register.
  */
  if (incr == "NI")
    return DNONINCR;
  else if (incr == "I")
    return DINCR;
  else
  {
    sprintf(debugstr,"Invalid Destination Increment : %s",*incr);
    debug_info(debugstr);
    return DNONINCR;
  }
}

/******************************************************************************/
/************************************* SourceBurst  ***************************/
/******************************************************************************/
int32 SbValue(int burst)
{
  /*
     Summary:
     ========
     o Given the source burst size of the dma transfer, this function will
       return a 32 bit hex value to be written in the channel control register.
  */
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
    sprintf(debugstr,"Invalid Source Master : %d",burst);
    debug_info(debugstr);
    return SBURST1;
  }
}

/******************************************************************************/
/*********************************** DestinationBurst  ************************/
/******************************************************************************/
int32 DbValue(int burst)
{
  /*
     Summary:
     ========
     o Given the destination burst size of the dma transfer, this function will
       return a 32 bit hex value to be written in the channel control register.
  */
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
    sprintf(debugstr,"Invalid Source Master : %d",burst);
    debug_info(debugstr);
    return DBURST1;
  }
}

/******************************************************************************/
/*********************************** Lock Transaction  ************************/
/******************************************************************************/
int32 LkValue(int lock)
{
  /*
     Summary:
     ========
     o Given that the dma transfer to be initiated as a lock transaction on 
       the AHB bus or not (1/0), this function will return a 32 bit hex value
       to be written in the channel control register.
  */
  if (lock == 0)
    return NONLOCK;
  else if (lock == 1)
    return LOCK;
  else
  {
    sprintf(debugstr,"Invalid Lock Value : %d",lock);
    debug_info(debugstr);
    return NONLOCK;
  }
}

/******************************************************************************/
/********************************** Interupt Error mask  **********************/
/******************************************************************************/
int32 IeValue(int IntErrMask)
{
  /*
     Summary:
     ========
     o Given that the error interrupt to be masked or not, for a dma transfer,
       this function will return a 32 bit hex value to be written in the
       channel configuration register.
  */
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
    sprintf(debugstr,"Invalid Interrupt Error Mask Value : %d",IntErrMask);
    debug_info(debugstr);
    return INTERRNOMASK;
  }
}

/******************************************************************************/
/*********************************** TC Interrupt Mask ************************/
/******************************************************************************/
int32 ItValue(int IntTCMask)
{
  /*
     Summary:
     ========
     o Given that the terminal count interrupt to be masked or not, for a dma
       transfer, this function will return a 32 bit hex value to be written in
       the channel configuration register.
  */
  if (IntTCMask == 0)
    return INTTCNOMASK;
  else if (IntTCMask == 1)
    return INTTCMASK;
  else
  {
    sprintf(debugstr,"Invalid TC Interrupt Mask Value : %d",IntTCMask);
    debug_info(debugstr);
    return INTTCNOMASK;
  }
}

/******************************************************************************/
/********************************** TC Interrupt Enable ***********************/
/******************************************************************************/
int32 TeValue(int IntTCEn)
{
  /*
     Summary:
     ========
     o Given that the terminal count interrupt to be enabled or not, for a dma
       transfer, this function will return a 32 bit hex value to be written in
       the channel control register.
  */
  if (IntTCEn == 0)
    return INTTCDI;
  else if (IntTCEn == 1)
    return INTTCEN;
  else
  {
    sprintf(debugstr,"Invalid TC Interrupt Enable : %d",IntTCEn);
    debug_info(debugstr);
    return INTTCDI;
  }
}

/******************************************************************************/
/********************************** Protection Control ************************/
/******************************************************************************/
int32 PtValue(int ProtBits)
{
  /*
     Summary:
     ========
     o Given the protection bits for a dma transfer, as a combination of
       "pbc/PBC", this function will return a 32 bit hex value to be written
       in the channel control register.
  */
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
    sprintf(debugstr,"Invalid Protection bits : %d",ProtBits);
    debug_info(debugstr);
    return Dmacpbc;
  }
}

/******************************************************************************/
/************************************ Channnel Setup **************************/
/***      Note : "IdleCycles" indicates the number of cycles between        ***/
/***      two writes to the channel registers                               ***/
/******************************************************************************/
void ChXSetup (const int   Channel,
               const int32 Halt,
               const int32 Lock,
               const int32 IntrErrorMask,
               const int32 IntrTCMask,
               const int32 FlowControl,
               const int32 DestinationPeripheral,
               const int32 SourcePeripheral,
               const int32 SourceAddress,
               const int32 DestinationAddress,
               const int32 LLIAddress,
               const int32 LLIMaster,
               const int32 IntrTCEnable,
               const int32 Protection,
               const int32 DestinationIncrement,
               const int32 SourceIncrement,
               const int32 DestinationMaster,
               const int32 SourceMaster,
               const int32 DestinationWidth,
               const int32 SourceWidth,
               const int32 DestinationBurst,
               const int32 SourceBurst,
               const int32 TransferSize,
               const int   IdleCycles)
{
  /*
     Summary:
     ========
     o This function will setup a channel for a Dma transfer. Given all the
       parameters required to program the channel, this will write into the
       channel registers to set it up for a Dma transfer.
       Note : The input "Channel" to this function should be passed as an
              integer between 0 and 7.
              The input "IdleCycles" indicates the number of clock cycles
              between the programming cycles of the channel. The following
              is the sequence of programming:
              1. Clear all the interrupt registers.
              2. Write into the channel source, destination and LLI address
                 registers.
              3. Wait for the amount of clock cycles, indicated by "IdleCycles".
              4. Write into the control register of the channel.
              5. Wait for the amount of clock cycles, indicated by "IdleCycles".
              6. Write into the configuration register (channel should still be
                 disabled), of the channel.
              7. Wait for the amount of clock cycles, indicated by "IdleCycles".
              8. Enable the channel. The other parameters of the configuration
                 register are not chaned during this write.
       The insertion of idle cycles is to provide a timing window between the
       steps indicated in the test-plan. The request from the peripheral model
       may be asserted in this timing window to ensure that the request is
       initiated as per the test plan.
  */
  int32 ControlData;
  int32 ConfigData;
  int32 LLIReg;
 
  int32 *ChannelRegAddr;
 
  if ((Channel < 0) || (Channel > 7))
  {
    sprintf(debugstr,"Invalid Channel Number %d",Channel);
    debug_info(debugstr);
  }
 
  ChannelRegAddr = ChannelRegisters(Channel);
 
  sprintf(debugstr,"DEBUG: Addr is %X",*ChannelRegAddr);
  debug_info(debugstr);
 
  /* Clear the Interrupt Status Registers */
  Write(DMACIntTCClr, 0xFFFFFFFF);
  Write(DMACIntErrClr, 0xFFFFFFFF);

  /* Check that the interrupt status registers are cleared */
  Read(DMACRawIntTC, 0x00000000, 0xFFFFFFFF);
  Read(DMACIntTCStat, 0x00000000, 0xFFFFFFFF);
  Read(DMACRawIntErr, 0x00000000, 0xFFFFFFFF);
  Read(DMACIntErrStat, 0x00000000, 0xFFFFFFFF);
  Read(DMACIntStat, 0x00000000, 0xFFFFFFFF);

  /* The Source register, Destination Register and LLI Registers are
     programmed                                                      */
 
  Write(*ChannelRegAddr++, SourceAddress);
  Write(*ChannelRegAddr++, DestinationAddress);
  LLIReg = LLIAddress | LLIMaster;
  Write(*ChannelRegAddr++, LLIReg);
  WaitLoop(IdleCycles);
 
  /* Channel's control register data is generated and programmed */
 
  sprintf(debugstr,"DEBUG: IntrTCEnable is %X",IntrTCEnable);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: Protection is %X",Protection);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: DestinationIncrement is %X",DestinationIncrement);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: SourceIncrement is %X",SourceIncrement);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: DestinationMaster is %X",DestinationMaster);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: SourceMaster is %X",SourceMaster);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: DestinationWidth is %X",DestinationWidth);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: SourceWidth is %X",SourceWidth);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: DestinationBurst is %X",DestinationBurst);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: SourceBurst is %X",SourceBurst);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: TransferSize is %X",TransferSize);
  debug_info(debugstr);

  ControlData = IntrTCEnable | Protection | DestinationIncrement |
                SourceIncrement | DestinationMaster | SourceMaster |
                DestinationWidth | SourceWidth | DestinationBurst |
                SourceBurst | TransferSize;
 
  sprintf(debugstr,"DEBUG: ControlData is %X",ControlData);
  debug_info(debugstr);

  Write(*ChannelRegAddr++, ControlData);
  WaitLoop(IdleCycles);

  /* Channel's configuration register is first configured without
  enabling the channel. After that the channel is enabled without changing
  any of the configuration parameters                                      */
 
  sprintf(debugstr,"DEBUG: Halt is %X",Halt);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: Lock is %X",Lock);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: IntrErrorMask is %X",IntrErrorMask);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: FlowControl is %X",FlowControl);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: DestinationPeripheral is %X",DestinationPeripheral);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: SourcePeripheral is %X",SourcePeripheral);
  debug_info(debugstr);

  sprintf(debugstr,"DEBUG: IntrTCMask is %X",IntrTCMask);
  debug_info(debugstr);

  ConfigData = Halt | Lock | IntrErrorMask | IntrTCMask |
               FlowControl | DestinationPeripheral | SourcePeripheral;
 
  Write(*ChannelRegAddr, ConfigData);
  WaitLoop(IdleCycles);
 
  ConfigData = ConfigData | CHXENABLE;
 
  Write(*ChannelRegAddr, ConfigData);
}

/******************************************************************************/
/**************************************** M2M DMA *****************************/
/******************************************************************************/
void M2MDma (const int Channel,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int SourceMaster,
             const int DestinationMaster,
             const int SourceWidth,
             const int DestinationWidth,
             const char *SourceIncrement,
             const char *DestinationIncrement,
             const int SourceBurst,
             const int DestinationBurst,
             const int TransferSize,
             const int LLIMaster,
             const int Protection,
             const int Lock,
             const int IntrTCEnable,
             const int IntrTCMask,
             const int IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an M2M transaction.
       Given all the parameters to set a channel for an M2M transaction, this
       will convert them into the hex values to be written into the relevant
       registers of the channel and will call the function ChXSetup to program
       the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* As there are no peripheral requests involved in an M2M transaction,
     there need not be any idle cycles while configuring the channel.   */
  int IdleCycles = 0;


  /* A message will be printed about all the M2M configuration parameters, if
     information is required during testing.                                 */

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"TEST PARAMETERS");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);

  sprintf(message,"Transfer Type                 : M2M");
  msg_info(message);

  sprintf(message,"Flow Controller               : DMAC");
  msg_info(message);

  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);

  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);

  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);

  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);

  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);

  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);

  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }

  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }

  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);

  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);

  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);

  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }

  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }

  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }

  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }

  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }

  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);

    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);

    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           M2MDMAC,
           rand() & DestPeriph15,
           rand() & SrcPeriph15,
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);

  /* Polling for the channel enable bit to go low.
     The channel enable going low indicates that the programmed DMA
     transfer has been completed or aborted.                        */
  Poll(ConfigRegs[Channel], 0x00000000, 0x00000001);
}

/******************************************************************************/
/**************************************** P2M DMA *****************************/
/******************************************************************************/
void P2MDma (const int   Channel,
             const int   SourcePeripheral,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int   SourceMaster,
             const int   DestinationMaster,
             const int   SourceWidth,
             const int   DestinationWidth,
             const char  *SourceIncrement,
             const char  *DestinationIncrement,
             const int   SourceBurst,
             const int   DestinationBurst,
             const int   TransferSize,
             const int   LLIMaster,
             const int   Protection,
             const int   Lock,
             const int   IntrTCEnable,
             const int   IntrTCMask,
             const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an P2M transaction
       with Dmac as the flow controller. Given all the parameters to set a
       channel for an P2M transaction, this will convert them into the hex
       values to be written into the relevant registers of the channel and will
       call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;
  int swidth, dwidth;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"TEST PARAMETERS");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);

  sprintf(message,"Transfer Type                 : P2M");
  msg_info(message);

  sprintf(message,"Flow Controller               : DMAC");
  msg_info(message);

  sprintf(message,"Source Peripheral             : %d",SourcePeripheral);
  msg_info(message);

  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);

  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);

  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);

  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);

  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);

  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);

  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }

  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }

  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);

  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);

  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);

  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }

  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }

  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }

  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }

  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }

  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);

    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);

    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           P2MDMAC,
           DpValue(rand() & DestPeriph15),
           SpValue(SourcePeripheral),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);
}

/******************************************************************************/
/**************************************** M2P DMA *****************************/
/******************************************************************************/
void M2PDma (const int   Channel,
             const int   DestinationPeripheral,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int   SourceMaster,
             const int   DestinationMaster,
             const int   SourceWidth,
             const int   DestinationWidth,
             const char  *SourceIncrement,
             const char  *DestinationIncrement,
             const int   SourceBurst,
             const int   DestinationBurst,
             const int   TransferSize,
             const int   LLIMaster,
             const int   Protection,
             const int   Lock,
             const int   IntrTCEnable,
             const int   IntrTCMask,
             const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an M2P transaction
       with Dmac as the flow controller. Given all the parameters to set a
       channel for an M2P transaction, this will convert them into the hex
       values to be written into the relevant registers of the channel and will
       call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;
  int swidth, dwidth;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"TEST PARAMETERS");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);
 
  sprintf(message,"Transfer Type                 : M2P");
  msg_info(message);
 
  sprintf(message,"Flow Controller               : DMAC");
  msg_info(message);
 
  sprintf(message,"Destination Peripheral        : %d",DestinationPeripheral);
  msg_info(message);
 
  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);
 
  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);
 
  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);
 
  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);
 
  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);
 
  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);
 
  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }
 
  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
 
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);
 
  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);
 
  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);
 
  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }
 
  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }
 
  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }
 
  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }
 
  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }
 
  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);
 
    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);
 
    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }
 
  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           M2PDMAC,
           DpValue(DestinationPeripheral),
           SpValue(rand() & SrcPeriph15),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);
}

/******************************************************************************/
/**************************************** M2P DP ******************************/
/******************************************************************************/
void M2PDp  (const int   Channel,
             const int   DestinationPeripheral,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int   SourceMaster,
             const int   DestinationMaster,
             const int   SourceWidth,
             const int   DestinationWidth,
             const char  *SourceIncrement,
             const char  *DestinationIncrement,
             const int   SourceBurst,
             const int   DestinationBurst,
             const int   LLIMaster,
             const int   Protection,
             const int   Lock,
             const int   IntrTCEnable,
             const int   IntrTCMask,
             const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an M2P transaction
       with the destination peripheral as the flow controller. Given all the
       parameters to set a channel for an M2P transaction, this will convert
       them into the hex values to be written into the relevant registers of
       the channel and will call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;
  int swidth, dwidth;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"TEST PARAMETERS");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);
 
  sprintf(message,"Transfer Type                 : M2P");
  msg_info(message);
 
  sprintf(message,"Flow Controller               : DESTINATION PERIPHERAL");
  msg_info(message);
 
  sprintf(message,"Destination Peripheral        : %d",DestinationPeripheral);
  msg_info(message);
 
  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);
 
  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);
 
  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);
 
  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);
 
  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);
 
  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);
 
  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }
 
  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
 
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);
 
  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);
 
  sprintf(message,"Transfer Size                 : NOT APPLICABLE");
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);
 
  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }
 
  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }
 
  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }
 
  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }
 
  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }
 
  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);
 
    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);
 
    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }
 
  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           M2PDP,
           DpValue(DestinationPeripheral),
           SpValue(rand() & SrcPeriph15),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           ((rand() % 4095) & 0x00000000),
           IdleCycles);
}

/******************************************************************************/
/**************************************** P2M SP ******************************/
/******************************************************************************/
void P2MSp  (const int   Channel,
             const int   SourcePeripheral,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int   SourceMaster,
             const int   DestinationMaster,
             const int   SourceWidth,
             const int   DestinationWidth,
             const char  *SourceIncrement,
             const char  *DestinationIncrement,
             const int   SourceBurst,
             const int   DestinationBurst,
             const int   LLIMaster,
             const int   Protection,
             const int   Lock,
             const int   IntrTCEnable,
             const int   IntrTCMask,
             const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an P2M transaction
       with the source peripheral as the flow controller. Given all the
       parameters to set a channel for an P2M transaction, this will convert
       them into the hex values to be written into the relevant registers of
       the channel and will call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;
  int swidth, dwidth;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"TEST PARAMETERS");
  msg_info(message);
 
  sprintf(message,"===============");
  msg_info(message);
 
  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);
 
  sprintf(message,"Transfer Type                 : P2M");
  msg_info(message);
 
  sprintf(message,"Flow Controller               : SOURCE PERIPHERAL");
  msg_info(message);
 
  sprintf(message,"Source Peripheral             : %d",SourcePeripheral);
  msg_info(message);
 
  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);
 
  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);
 
  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);
 
  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);
 
  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);
 
  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);
 
  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }
 
  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
 
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);
 
  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);
 
  sprintf(message,"Transfer Size                 : NOT APPLICABLE");
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);
 
  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }
 
  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }
 
  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }
 
  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }
 
  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }
 
  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);
 
    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);
 
    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }
 
  sprintf(message,"-------------------------------------------------");
  msg_info(message);
 

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           P2MSP,
           DpValue(rand() & DestPeriph15),
           SpValue(SourcePeripheral),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           (rand() % 4095),
           IdleCycles);
}

/******************************************************************************/
/**************************************** P2P DMA *****************************/
/******************************************************************************/
void P2PDma (const int Channel,
             const int32 SourceAddress,
             const int32 DestinationAddress,
             const int32 LLIAddress,
             const int   SourcePeripheral,
             const int   DestinationPeripheral,
             const int   SourceMaster,
             const int   DestinationMaster,
             const int   SourceWidth,
             const int   DestinationWidth,
             const char  *SourceIncrement,
             const char  *DestinationIncrement,
             const int   SourceBurst,
             const int   DestinationBurst,
             const int   TransferSize,
             const int   LLIMaster,
             const int   Protection,
             const int   Lock,
             const int   IntrTCEnable,
             const int   IntrTCMask,
             const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an P2P transaction
       with Dmac as the flow controller. Given all the parameters to set a
       channel for an P2P transaction, this will convert them into the hex
       values to be written into the relevant registers of the channel and will
       call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"TEST PARAMETERS");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);

  sprintf(message,"Transfer Type                 : P2P");
  msg_info(message);

  sprintf(message,"Flow Controller               : DMAC");
  msg_info(message);

  sprintf(message,"Source Peripheral             : %d",SourcePeripheral);
  msg_info(message);

  sprintf(message,"Destination Peripheral        : %d",DestinationPeripheral);
  msg_info(message);

  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);

  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);

  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);

  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);

  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);

  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);

  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }

  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);

  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);

  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);

  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }

  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }

  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }

  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }

  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }

  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);

    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);

    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           P2PDMAC,
           DpValue(DestinationPeripheral),
           SpValue(SourcePeripheral),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);
}

/******************************************************************************/
/**************************************** P2P-SP ******************************/
/******************************************************************************/
void P2PSp (const int Channel,
            const int32 SourceAddress,
            const int32 DestinationAddress,
            const int32 LLIAddress,
            const int   SourcePeripheral,
            const int   DestinationPeripheral,
            const int   SourceMaster,
            const int   DestinationMaster,
            const int   SourceWidth,
            const int   DestinationWidth,
            const char  *SourceIncrement,
            const char  *DestinationIncrement,
            const int   SourceBurst,
            const int   DestinationBurst,
            const int   TransferSize,
            const int   LLIMaster,
            const int   Protection,
            const int   Lock,
            const int   IntrTCEnable,
            const int   IntrTCMask,
            const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an P2P transaction
       with the source peripheral as the flow controller. Given all the
       parameters to set a channel for an P2P transaction, this will convert
       them into the hex values to be written into the relevant registers of
       the channel and will call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"TEST PARAMETERS");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);

  sprintf(message,"Transfer Type                 : P2P");
  msg_info(message);

  sprintf(message,"Flow Controller               : Source Peripheral");
  msg_info(message);

  sprintf(message,"Source Peripheral             : %d",SourcePeripheral);
  msg_info(message);

  sprintf(message,"Destination Peripheral        : %d",DestinationPeripheral);
  msg_info(message);

  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);

  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);

  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);

  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);

  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);

  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);

  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }

  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);

  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);

  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);

  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }

  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }

  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }

  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }

  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }

  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);

    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);

    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           P2PSP,
           DpValue(DestinationPeripheral),
           SpValue(SourcePeripheral),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);
}

/******************************************************************************/
/**************************************** P2P-DP ******************************/
/******************************************************************************/
void P2PDp (const int Channel,
            const int32 SourceAddress,
            const int32 DestinationAddress,
            const int32 LLIAddress,
            const int   SourcePeripheral,
            const int   DestinationPeripheral,
            const int   SourceMaster,
            const int   DestinationMaster,
            const int   SourceWidth,
            const int   DestinationWidth,
            const char  *SourceIncrement,
            const char  *DestinationIncrement,
            const int   SourceBurst,
            const int   DestinationBurst,
            const int   TransferSize,
            const int   LLIMaster,
            const int   Protection,
            const int   Lock,
            const int   IntrTCEnable,
            const int   IntrTCMask,
            const int   IntrErrorMask)
{
  /*
     Summary:
     ========
     o This function will setup a channel of the Dmac for an P2P transaction
       with the destination peripheral as the flow controller. Given all the
       parameters to set a channel for an P2P transaction, this will convert
       them into the hex values to be written into the relevant registers of
       the channel and will call the function ChXSetup to program the channel.
       The datatype of all the inputs are defined so as to use the constants
       defined in Dmac.h file.
  */

  /* There will be two clock cycles between the phases of enabling the channel,
     defined as multiple steps to program a channel, in the testplan.         */
  int IdleCycles = 2;

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"TEST PARAMETERS");
  msg_info(message);

  sprintf(message,"===============");
  msg_info(message);

  sprintf(message,"DMAC Channel                  : %d",Channel);
  msg_info(message);

  sprintf(message,"Transfer Type                 : P2P");
  msg_info(message);

  sprintf(message,"Flow Controller               : Destination Peripheral");
  msg_info(message);

  sprintf(message,"Source Peripheral             : %d",SourcePeripheral);
  msg_info(message);

  sprintf(message,"Destination Peripheral        : %d",DestinationPeripheral);
  msg_info(message);

  sprintf(message,"Source Address                : %X",SourceAddress);
  msg_info(message);

  sprintf(message,"Destination Address           : %X",DestinationAddress);
  msg_info(message);

  sprintf(message,"Source Master                 : %d",SourceMaster);
  msg_info(message);

  sprintf(message,"Destination Master            : %d",DestinationMaster);
  msg_info(message);

  sprintf(message,"Source Width                  : %d",SourceWidth);
  msg_info(message);

  sprintf(message,"Destination Width             : %d",DestinationWidth);
  msg_info(message);

  if (SourceIncrement == "I")
  {
    sprintf(message,"Source Address Increment      : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Source Address Increment      : NO");
    msg_info(message);
  }

  if (DestinationIncrement == "I")
  {
    sprintf(message,"Destination Address Increment : YES");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Destination Address Increment : NO");
    msg_info(message);
  }
  sprintf(message,"Source Burst size             : %d",SourceBurst);
  msg_info(message);

  sprintf(message,"Destination Burst size        : %d",DestinationBurst);
  msg_info(message);

  sprintf(message,"Transfer Size                 : %d",TransferSize);
  msg_info(message);
  sprintf(message,"  (in terms of source width)");
  msg_info(message);

  if (Protection == pbc)
  {
    sprintf(message,"Protection Control            : pbc");
    msg_info(message);
  }
  else if (Protection == pbC)
  {
    sprintf(message,"Protection Control            : pbC");
    msg_info(message);
  }
  else if (Protection == pBc)
  {
    sprintf(message,"Protection Control            : pBc");
    msg_info(message);
  }
  else if (Protection == pBC)
  {
    sprintf(message,"Protection Control            : pBC");
    msg_info(message);
  }
  else if (Protection == Pbc)
  {
    sprintf(message,"Protection Control            : Pbc");
    msg_info(message);
  }
  else if (Protection == PbC)
  {
    sprintf(message,"Protection Control            : PbC");
    msg_info(message);
  }
  else if (Protection == PBc)
  {
    sprintf(message,"Protection Control            : PBc");
    msg_info(message);
  }
  else if (Protection == PBC)
  {
    sprintf(message,"Protection Control            : PBC");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Protection Control            : INVALID");
    msg_info(message);
  }

  if (Lock == 1)
  {
    sprintf(message,"Lock Transaction              : YES");
    msg_info(message);
  }
  else if (Lock == 0)
  {
    sprintf(message,"Lock Transation               : NO");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Lock Transfer                 : INVALID");
    msg_info(message);
  }

  if (IntrTCEnable == 0)
  {
    sprintf(message,"Terminal Count Interrupt      : DISABLED");
    msg_info(message);
  }
  else if (IntrTCEnable == 1)
  {
    sprintf(message,"Terminal Count Interrupt      : ENABLED");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Terminal Count(TC) Interrupt  : INVALID");
    msg_info(message);
  }

  if (IntrTCMask == 0)
  {
    sprintf(message,"TC Interrupt Mask             : CLEAR");
    msg_info(message);
  }
  else if (IntrTCMask == 1)
  {
    sprintf(message,"TC Interrupt Mask             : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"TC Interrupt Mask             : INVALID");
    msg_info(message);
  }

  if (IntrErrorMask == 0)
  {
    sprintf(message,"Error Interrupt Mask          : CLEAR");
    msg_info(message);
  }
  else if (IntrErrorMask == 1)
  {
    sprintf(message,"Error Interrupt Mask          : SET");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Error Interrupt Mask          : INVALID");
    msg_info(message);
  }

  if ((LLIAddress & 0xFFFFFFFC) == 0x00000000)
  {
    sprintf(message,"Linked List Item(LLI)         : NULL");
    msg_info(message);
  }
  else
  {
    sprintf(message,"Linked List Item(LLI)         : YES");
    msg_info(message);

    sprintf(message,"  LLI Address                 : %X",
              (LLIAddress & 0xFFFFFFFC));
    msg_info(message);

    sprintf(message,"  LLI Master                  : %d", LLIMaster);
    msg_info(message);
  }

  sprintf(message,"-------------------------------------------------");
  msg_info(message);

  ChXSetup(Channel,
           0x00000000,
           LkValue(Lock),
           IeValue(IntrErrorMask),
           ItValue(IntrTCMask),
           P2PDP,
           DpValue(DestinationPeripheral),
           SpValue(SourcePeripheral),
           SourceAddress,
           DestinationAddress,
           LLIAddress & 0xFFFFFFFC,
           LLIMaster,
           TeValue(IntrTCEnable),
           PtValue(Protection),
           DiValue(DestinationIncrement),
           SiValue(SourceIncrement),
           DmValue(DestinationMaster),
           SmValue(SourceMaster),
           DwValue(DestinationWidth),
           SwValue(SourceWidth),
           DbValue(DestinationBurst),
           SbValue(SourceBurst),
           TransferSize,
           IdleCycles);
}

/******************************************************************************/
/********************************** Response Programming **********************/
/******************************************************************************/
void ProgramResponse (char *DmaType, int TransferSize,
                  int SourceWidth, int DestinationWidth)
{
  /*
     Summary:
     ========
     o This function will program the memory/peripheral models for the
       AHB responses to be returned for a Dma transfer initiated by the Dmac.
       The input to this function are the type of Dma transfer, Transfer size
       in terms of source width and source and destination widths of the Dma
       transfer.
       DmaType           - can be "M2M", "M2P", "P2M" or "P2P" only.
       TransferSize      - should be in terms of source width,
                           as programmed in the channel control register.
       SourceWidth       - source-width of the dma transfer.
                           This can be 8, 16 or 32 only.
       DestinationWidth  - destination-width of the dma transfer.
                           This can be 8, 16 or 32 only.

       This function will program the memory/peripheral for all possible
       AHB responses. i.e., OKAY, RETRY, SPLIT and ERROR. It can also
       program the memory/peripheral to insert WAIT responses.

       The responses are controlled by the constant TESTCONFIGURATION, defined
       in the Dmac.h file. If this is set to "USER", then the user can program
       the combination of responses to be returned by the memory/peripheral
       for a dma transfer. The memory/peripheral will return the programmed
       responses for all the test cases.

       The responses are controlled by the constants SOKAY, SRETRY, SSPLIT,
       SERROR and SWAIT for source dma transfers and DOKAY, DRETRY, DSPLIT,
       DERROR and DWAIT for destination dma transfers.

       All the testcases in M2M, M2P, P2M, P2P tests will be run with the
       given set of AHB responses. However, if the constant TESTCONFIGURATION
       is set to "DEFAULT", all the response combinations are internally
       generated by the test code and will change for every test-case.

       The memory/peripheral can be programmed to return a specific response
       for a particular address or data in a burst.Other data will be returned
       with a default response programmed in the models. Please refer to the
       block verification document for the details of programming them.

       However the specific address or data cannot be defined by the user. It
       is generated by this function. If only one type of response is set to 1,
       then all the data will be returned with that response, as it will be
       programmed as the default response. If more than one type response is
       to be programmed, then the address/data will be programmed such that
       one third of the total number of transfers will be returned with the
       programmed responses. Others will be returned with a default response.

       The constants are searched in the order of OKAY, RETRY, SPLIT and ERROR
       responses. Whichever constant is set to 1 first in the above order,
       will be defined as the default response as follows:
       ORSE (OKAY RETRY SPLIT ERROR)
       1XXX  - Default response will be OKAY.
       01XX  - Default response will be RETRY.
       001X  - Default response will be SPLIT.
       0001  - Default response will be ERROR.

       If WAIT is set to 1, then there will be a random number of wait cycles
       inserted before returning the responses.

       If the address is incremented during a dma transfer, the response
       programming will be controlled by the address. If the address is
       non-incremental during a Dma transfer, it will controlled by the
       number of data transfers in a burst. i.e., the memory/peripheral
       model will be programmed to return the specified response for the
       first, second, third...etc data of a Dma transfer.

       If a constant corresponding to a response is set, but it is not a               default response, then the control registers in the memory/peripheral
       model will be programmed to return this response for a given set of
       addresses or number of data transfers. The total number of such
       programmed responses are calculated from the one third data of the
       dma transfer. Out of the responses, OKAY cannot be a programmed
       response. If it is set to 1 it will be the default response, otherwise
       it will not be programmed as a default response. For other responses,
       i.e., RETRY/SPLIT/ERROR, the programmed responses are shared equally
       amongst them.
       i.e., if 2 out of 3 responses are set, then 1/6th of the total number
       of transfers will be programmed to return each of the responses.
       If all three are set, then each response will be returned for 1/9 of
       the total number of data transfers.
  */

  char *DefaultResponse;
  int j, k, OnethirdData, MaxValue;
  int CountLoop;
  int32 MasterConfig, RegWrAddr;
  int32 WaitCycles, Response, SeedData, RSCount;
  int32 VlsbCount, ControlBase, SourceTxSize, DestinationTxSize;
  int32 RetryResponses, SplitResponses, ErrorResponses;
  int32 AddrOrData, RegWrData;
  int32 AddrOrDataList[64];
  char report[100];

  /*=================================================================*/
  /* PROGRAMMING THE SOURCE MEMORY/PERIPHERAL FOR EXPECTED RESPONSES */
  /*=================================================================*/
  /* If the memory/peripheral is reset due to a previous transaction,
     the reset is cleared.                                    */
  if ((DmaType == "P2M") || (DmaType == "P2P"))
  {
    Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRSTCLR);
  }
  else
  {
    Write(DMACTrMemEn0, MEMORYRSTCLR);
  }

  sprintf(report,"Source Response is : %d",SrcResponse);
  debug_info(report);

  /* If the TESTCONFIGURATION is user defined responses, then the constants
     defined in Dmac.h file will be used to find the expected type of response
     for a dma transfer.
     Otherwise, the responses are internally changed, by using the variables
     SrcResponse and DestResponse. There are five types of responses, such as
     okay, retry, split, error and wait. Each can be set or reset, gives about
     32 combinations. Therefore the integers SrcResponse/DestResponse will be
     anything between 1-32 (All responses set to zero is excluded). By
     extracting each bit from these integers, the source and destination
     respnses for the dma transfer are derived.                               */
  if (TESTCONFIGURATION == "USER")
  {
    SrcOkay  = SOKAY;
    SrcWait  = SWAIT;
    SrcRetry = SRETRY;
    SrcSplit = SSPLIT;
    SrcError = SERROR;

    DestOkay  = DOKAY;
    DestWait  = DWAIT;
    DestRetry = DRETRY;
    DestSplit = DSPLIT;
    DestError = DERROR;
  }
  else
  {
    SrcOkay  = (SrcResponse/16) % 2;
    SrcWait  = (SrcResponse/8) % 2;
    SrcRetry = (SrcResponse/4) % 2;
    SrcSplit = (SrcResponse/2) % 2;
    SrcError = SrcResponse % 2;

    DestOkay  = (DestResponse/16) % 2;
    DestWait  = (DestResponse/8) % 2;
    DestRetry = (DestResponse/4) % 2;
    DestSplit = (DestResponse/2) % 2;
    DestError = DestResponse % 2;
  }

  /* If the TransferSize is less than 3, then the arithmetic will return 0.
     To avoid this, it is set to a minimum of one. Moreover there are only
     60 control registers in memory/peripherals that can be programmed for
     a specific response. Therefore maximum number of programmable responses
     should not be more than 60.                                             */
  if (TransferSize > 3)
  {
    OnethirdData = (((int) TransferSize/3) % 60) + 1;
  }
  else
  {
    OnethirdData = 1;
  }

  /* If a wait cycle inserted response is to be returned, a random number of
     wait cycles, between 1-15, will be programmed.                         */
  if (SrcWait == 1)
  {
    WaitCycles = DefaultWaitCycles[((rand() % 15) + 1)];
  }
  else
  {
    WaitCycles = DefaultWaitCycles[0];
  }

  /* Program the default response for the source transactions. If there is
     only one response programmed, it will be programmed as a default response
     for all the source transactions                                          */

  if (SrcOkay == 1)
  {
    DefaultResponse = "OKAY";
    Response = DEFOKAY;
    RSCount  = 0x00000000;
  }
  else if (SrcRetry == 1)
  {
    DefaultResponse = "RETRY";
    Response = DEFRETRY;
    /* Number of retry responses are programmed randomly */
    RSCount  = DefaultRSCount[(rand() % 4)];
  }
  else if (SrcSplit == 1)
  {
    DefaultResponse = "SPLIT";
    Response = DEFSPLIT;
    /* Number of split responses are programmed randomly */
    RSCount  = DefaultRSCount[(rand() % 4)];
  }
  else if (SrcError == 1)
  {
    DefaultResponse = "ERROR";
    Response = DEFERROR;
    RSCount  = 0x00000000;
  }
  else
  {
    sprintf(report,"Default Source Response is NOT defined");
    msg_info(report);
    sprintf(report,"Source Response will be OKAY only");
    msg_info(report);
    DefaultResponse = "OKAY";
    Response = DEFOKAY;
    RSCount  = 0x00000000;
  }

  /* If there is only one data to be programmed for the specified responses,
     and if error is one of the responses to be programmed, then it will be
     programmed as a default response, as there can be a case where there is
     only one data transfer taking place.                                    */
  if ((SrcError == 1) && (OnethirdData == 1))
  {
    DefaultResponse = "ERROR";
    Response = DEFERROR;
    RSCount  = 0x00000000;
  }

  /* If the source of the Dma transfer is a peripheral, program the peripheral.
     Otherwise program memory-0 which is used as a source for memory based
     Dma transfers.                                                           */
  if ((DmaType == "P2M") || (DmaType == "P2P"))
  {
    RegWrData = PERIPHENABLE | RSCount | WaitCycles | Response |
                (Endianness << 10);
    Write(PeriphReg(SrcPeripheral, PERIPHENREG), RegWrData);
  }
  else
  {
    RegWrData = MEMORYENABLE | RSCount | WaitCycles | Response |
                (Endianness << 10);
    Write(DMACTrMemEn0, RegWrData);
  }

  /* A seed to be provided for the pseudo random generator in the
     memory/peripheral models that will generate successive random data for
     Dma transfers. The same data will be written into the destination of
     Dma transfers for generating the expected data from Dmac.             */
  SeedData = ((rand() % 256) << 24) +
             ((rand() % 256) << 16) +
             ((rand() % 256) << 8) +
             (rand() % 256);

  if ((DmaType == "P2M") || (DmaType == "P2P"))
  {
    Write(PeriphReg(SrcPeripheral, PERIPHDATAREG), SeedData);
  }
  else
  {
    Write(DMACTrMemData0, SeedData);
  }

  /* Expected size of the data transfer is programmed. */
  if (SourceWidth == 8)
  {
    SourceTxSize = PGMBYTE;
  }
  else if (SourceWidth == 16)
  {
    SourceTxSize = PGMHWORD;
  }
  else
  {
    SourceTxSize = PGMWORD;
  }

  /* If the source address is non-incremental, then the data count will be
     used to program the response. Otherwise the address of the Dma transfer
     will be used to program the response.                                  */
  if (SINC == "NI")
    ControlBase = DATABASE;
  else
    ControlBase = ADDRBASE;

  if ((DmaType == "P2M") || (DmaType == "P2P"))
  {
    RegWrAddr = PeriphReg(SrcPeripheral, PERIPHCTRLREG);
  }
  else
  {
    RegWrAddr = DMACTrMemControl0;
  }

  k = 1;

  debug_info("Source Error Response");

  ErrorResponses = 0;
  RetryResponses = 0;
  SplitResponses = 0;

  if ((SrcError == 1) & (DefaultResponse != "ERROR"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    debug_info("Calculating Error Responses");

    ErrorResponses = (int) (OnethirdData * SrcError)/
                           (SrcRetry + SrcSplit + SrcError);
    debug_info("ErrorResponses calculated");

    sprintf(report,"ErrorResponses : %d",ErrorResponses);
    debug_info(report);

    j = 1;
    Response = PGMERROR;

    /* Atleast one error response should be programmed, if error is one of
       the defined responses.                                             */
    if (ErrorResponses == 0)
    {
      ErrorResponses = 1;
    }

    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return error responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (ErrorResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    sprintf(report,"ErrorResponses : %d",ErrorResponses);
    debug_info(report);

    /* Address / Data field in the register is a 16 bit value */
    AddrOrData = rand() % TransferSize;
    debug_info("First Error response is programmed");

    AddrOrDataList[k] = AddrOrData;
    k++;

    RSCount  = 0;

    /* Insert wait cycles */
    if (SrcWait == 1)
    {
      WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
    }
    else
    {
      WaitCycles = ProgramWaitCycles[0];
    }

    RegWrData = REGENABLE | ControlBase | SourceTxSize |
                ValidLSB[VlsbCount] | RSCount | WaitCycles |
                Response | AddrOrData;
    Write(RegWrAddr, RegWrData);
    RegWrAddr = RegWrAddr + 0x00000004;

    while (j++ < ErrorResponses)
    {
      sprintf(report,"Error Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Error Resp Count: %d",ErrorResponses);
      debug_info(report);

      sprintf(report,"Error Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Error Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */

      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }
      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = 0;

      /* Insert wait cycles */
      if (SrcWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | SourceTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  debug_info("Source Retry Response");

  if ((SrcRetry == 1) & (DefaultResponse != "RETRY"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    RetryResponses = (int) (OnethirdData * SrcRetry)/
                           (SrcRetry + SrcSplit + SrcError);
    j = 0;
    Response = PGMRETRY;

    /* Atleast one retry response should be programmed, if retry is one of
       the defined responses.                                             */
    if (RetryResponses == 0)
    {
      RetryResponses = 1 + ErrorResponses;
    }

    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return retry responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (RetryResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    while (j++ < RetryResponses)
    {
      sprintf(report,"Retry Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Retry Resp Count:  %d",RetryResponses);
      debug_info(report);

      sprintf(report,"Retry Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Retry Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */
      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }
      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = ProgramRSCount[(rand() % 4)];

      /* Insert wait cycles */
      if (SrcWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | SourceTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  debug_info("Source Split Response");

  if ((SrcSplit == 1) & (DefaultResponse != "SPLIT"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    SplitResponses = (int) (OnethirdData * SrcSplit)/
                           (SrcRetry + SrcSplit + SrcError);
    j = 0;
    Response = PGMSPLIT;

    /* Atleast one split response should be programmed, if split is one of
       the defined responses.                                             */
    if (SplitResponses == 0)
    {
      SplitResponses = 1 + RetryResponses;
    }
    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return split responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (SplitResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    while (j++ < SplitResponses)
    {
      sprintf(report,"Split Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Split Resp Count: %d",SplitResponses);
      debug_info(report);

      sprintf(report,"Split Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Split Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */
      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }
      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = ProgramRSCount[(rand() % 4)];

      /* Insert wait cycles */
      if (SrcWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | SourceTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  /*======================================================================*/
  /* PROGRAMMING THE DESTINATION MEMORY/PERIPHERAL FOR EXPECTED RESPONSES */
  /*======================================================================*/
  /* If the memory/peripheral is reset due to a previous transaction,
     the reset is cleared.                                    */
  if ((DmaType == "M2P") || (DmaType == "P2P"))
  {
    Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRSTCLR);
  }
  else
  {
    Write(DMACTrMemEn1, MEMORYRSTCLR);
  }

  /* As the total number of data transfers are indicated in terms of source
     width, the total number of destination data transfers are calculated.  */
  TransferSize = (int) ((TransferSize / SourceWidth)*DestinationWidth);

  /* If the source width is less than the destination width, the above
     calculation of TransferSize may return a zero, which actually means
     there is atleast one data transfer to the destination.               */
  if (TransferSize == 0)
  {
    TransferSize = 1;
  }

  /* If the TransferSize is less than 3, then the arithmetic will return 0.
     To avoid this, it is set to a minimum of one. Moreover there are only
     60 control registers in memory/peripherals that can be programmed for
     a specific response. Therefore maximum number of programmable responses
     should not be more than 60.                                             */
  if (TransferSize > 3)
  {
    OnethirdData = (((int) TransferSize/3) % 60) + 1;
  }
  else
  {
    OnethirdData = 1;
  }

  /* If a wait cycle inserted response is to be returned, a random number of
     wait cycles, between 1-15, will be programmed.                         */
  if (DestWait == 1)
  {
    WaitCycles = DefaultWaitCycles[((rand() % 15) + 1)];
  }
  else
  {
    WaitCycles = DefaultWaitCycles[0];
  }

  /* Program the default response for the destination transactions. If there is
     only one response programmed, it will be programmed as a default response
     for all the destination transactions.                                    */
  if (DestOkay == 1)
  {
    DefaultResponse = "OKAY";
    Response = DEFOKAY;
    RSCount  = 0x00000000;
  }
  else if (DestRetry == 1)
  {
    DefaultResponse = "RETRY";
    Response = DEFRETRY;
    /* Number of retry responses are programmed randomly */
    RSCount  = DefaultRSCount[(rand() % 4)];
  }
  else if (DestSplit == 1)
  {
    DefaultResponse = "SPLIT";
    Response = DEFSPLIT;
    /* Number of split responses are programmed randomly */
    RSCount  = DefaultRSCount[(rand() % 4)];
  }
  else if (DestError == 1)
  {
    DefaultResponse = "ERROR";
    Response = DEFERROR;
    RSCount  = 0x00000000;
  }
  else
  {
    sprintf(report,"Default Destination Response is NOT defined");
    msg_info(report);
    sprintf(report,"Destination Response will be OKAY only");
    msg_info(report);
    DefaultResponse = "OKAY";
    Response = DEFOKAY;
    RSCount  = 0x00000000;
  }

  /* If there is only one data to be programmed for the specified responses,
     and if error is one of the responses to be programmed, then it will be
     programmed as a default response, as there can be a case where there is
     only one data transfer taking place.                                    */
  if ((DestError == 1) && (OnethirdData == 1))
  {
    DefaultResponse = "ERROR";
    Response = DEFERROR;
    RSCount  = 0x00000000;
  }

  /* If the destination of the Dma transfer is a peripheral, program the
     peripheral.  Otherwise program memory-1 which is used as a destination
     for memory based Dma transfers. Also program the seed data.           */
  if ((DmaType == "M2P") || (DmaType == "P2P"))
  {
    RegWrData = PERIPHENABLE | RSCount | WaitCycles | Response |
                (Endianness << 10);
    Write(PeriphReg(DestPeripheral, PERIPHENREG), RegWrData);
    Write(PeriphReg(DestPeripheral, PERIPHDATAREG), SeedData);
  }
  else
  {
    RegWrData = MEMORYENABLE | RSCount | WaitCycles | Response |
                (Endianness << 10);
    Write(DMACTrMemEn1, RegWrData);
    Write(DMACTrMemData1, SeedData);
  }

  /* Expected size of the data transfer is programmed. */
  if (DestinationWidth == 8)
  {
    DestinationTxSize = PGMBYTE;
  }
  else if (DestinationWidth == 16)
  {
    DestinationTxSize = PGMHWORD;
  }
  else
  {
    DestinationTxSize = PGMWORD;
  }

  /* If the destination address is non-incremental, then the data count will be
     used to program the response. Otherwise the address of the Dma transfer
     will be used to program the response.                                  */
  if (DINC == "NI")
    ControlBase = DATABASE;
  else
    ControlBase = ADDRBASE;

  if ((DmaType == "M2P") || (DmaType == "P2P"))
  {
    RegWrAddr = PeriphReg(DestPeripheral, PERIPHCTRLREG);
  }
  else
  {
    RegWrAddr = DMACTrMemControl1;
  }

  k = 1;

  debug_info("Destination Error Response");

  if ((DestError == 1) & (DefaultResponse != "ERROR"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    ErrorResponses = (int) (OnethirdData * DestError)/
                           (DestRetry + DestSplit + DestError);
    j = 1;
    Response = PGMERROR;

    /* Atleast one error response should be programmed, if error is one of
       the defined responses.                                             */
    if (ErrorResponses == 0)
    {
      ErrorResponses = 1;
    }

    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return error responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (ErrorResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    /* Address / Data field in the register is a 16 bit value */
    AddrOrData = rand() % TransferSize;
    AddrOrDataList[k] = AddrOrData;
    k++;

    RSCount  = ProgramRSCount[(rand() % 4)];

    /* Insert wait cycles */
    if (DestWait == 1)
    {
      WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
    }
    else
    {
      WaitCycles = ProgramWaitCycles[0];
    }

    RegWrData = REGENABLE | ControlBase | DestinationTxSize |
                ValidLSB[VlsbCount] | RSCount | WaitCycles |
                Response | AddrOrData;
    Write(RegWrAddr, RegWrData);
    RegWrAddr = RegWrAddr + 0x00000004;

    while (j++ < ErrorResponses)
    {
      sprintf(report,"Error Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Error Resp Count: %d",ErrorResponses);
      debug_info(report);

      sprintf(report,"Error Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Error Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */
      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }

      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = 0;

      /* Insert wait cycles */
      if (DestWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | DestinationTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  debug_info("Destination Retry Response");

  if ((DestRetry == 1) & (DefaultResponse != "RETRY"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    RetryResponses = (int) (OnethirdData * DestRetry)/
                           (DestRetry + DestSplit + DestError);
    j = 0;
    Response = PGMRETRY;

    /* Atleast one retry response should be programmed, if retry is one of
       the defined responses.                                             */
    if (RetryResponses == 0)
    {
      RetryResponses = 1 + ErrorResponses;
    }

    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return retry responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (RetryResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    while (j++ < RetryResponses)
    {
      sprintf(report,"Retry Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Retry Resp Count: %d",RetryResponses);
      debug_info(report);

      sprintf(report,"Retry Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Retry Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */
      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }
      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = ProgramRSCount[(rand() % 4)];

      /* Insert wait cycles */
      if (DestWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | DestinationTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  debug_info("Destination Split Response");

  if ((DestSplit == 1) & (DefaultResponse != "SPLIT"))
  {
    /* One third of the total number of transfers will be programmed
       to return the defined responses.
       Out of this data (onethird of the total transfer), it is again
       equally shared by the responses defined.                       */
    SplitResponses = (int) (OnethirdData * DestSplit)/
                           (DestRetry + DestSplit + DestError);
    j = 0;
    Response = PGMSPLIT;

    /* Atleast one split response should be programmed, if split is one of
       the defined responses.                                             */
    if (SplitResponses == 0)
    {
      SplitResponses = 1 + RetryResponses;
    }

    /* Calculate the value of Valid lsb bits, based on the total number of
       data transfers to be programmed to return split responses.         */
    VlsbCount    = 15;
    MaxValue     = 0xFFFF;

    while (SplitResponses < MaxValue)
    {
      VlsbCount--;
      MaxValue = (int) MaxValue/2;
    }

    if (VlsbCount < 0)
    {
      VlsbCount = 0;
    }

    while (j++ < SplitResponses)
    {
      sprintf(report,"Split Resp: OnethirdData %d",OnethirdData);
      debug_info(report);

      sprintf(report,"Split Resp Count: %d",SplitResponses);
      debug_info(report);

      sprintf(report,"Split Resp: j %d",j);
      debug_info(report);

      sprintf(report,"Split Resp: k %d",k);
      debug_info(report);

      CountLoop = 0;

      /* The address or data value should not be the same as already
         programmed */
      while ((IsElement(AddrOrData, AddrOrDataList, k-1)) &&
             (k < OnethirdData) && (CountLoop++ < 60))
      {
        /* Address / Data field in the register is a 16 bit value */
        AddrOrData = rand() % TransferSize;
      }

      AddrOrDataList[k] = AddrOrData;
      k++;

      RSCount  = ProgramRSCount[(rand() % 4)];

      /* Insert wait cycles */
      if (DestWait == 1)
      {
        WaitCycles = ProgramWaitCycles[((rand() % 15) + 1)];
      }
      else
      {
        WaitCycles = ProgramWaitCycles[0];
      }

      RegWrData = REGENABLE | ControlBase | DestinationTxSize |
                  ValidLSB[VlsbCount] | RSCount | WaitCycles |
                  Response | AddrOrData;
      Write(RegWrAddr, RegWrData);
      RegWrAddr = RegWrAddr + 0x00000004;
    }
  }

  /* There can be only 31 response combinations. */
  if (SrcResponse == 31)
  {
    SrcResponse = 1;
    DestResponse++;
    if (DestResponse == 31)
    {
      DestResponse = 1;
    }
  }
  else
  {
    SrcResponse++;
  }
}

/******************************************************************************/
/********************************* Status register reads **********************/
/******************************************************************************/
void CheckStatus (int Channel)
{
  if ((TCENABLE == 1) && (SrcError == 0) && (DestError == 0))
  {
    Read(DMACRawIntTC, 0xFFFFFFFF, (0x00000001 << Channel));
    if (TCMASK == 1)
    {
      Read(DMACIntTCStat, 0xFFFFFFFF, (0x00000001 << Channel));
      Read(DMACIntStat, 0xFFFFFFFF, (0x00000001 << Channel));
    }
    else
    {
      Read(DMACIntTCStat, 0x00000000, (0x00000001 << Channel));
      Read(DMACIntStat, 0x00000000, (0x00000001 << Channel));
    }
  }
}

/******************************************************************************/
/********************************* MultiChannel Functions *********************/
/******************************************************************************/

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  Resp            - Initialization of Resp variable. It is initialized  ***/
/***                    to two channel tests programmed response parameters ***/
/******************************************************************************/
struct RespPara Resp[] = {
   2, DataControl, HWORDControl, 0x02000000, PGMRSRSP1, ZERO, PGMSPLIT,
      0x00000002,
   2, DataControl, WORDControl, 0x02000000, PGMRSRSP3, ZERO, PGMSPLIT,
      0x00000002,
   15, DataControl, WORDControl, 0x02000000, PGMRSRSP1, ZERO, 0x00020000,
      0x00000002,
   2, DataControl, HWORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMSPLIT,
      0x00000002,
   12, ZERO, WORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMSPLIT, 0x00000001,
   1, DataControl, WORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMSPLIT,
      0x00000002,
   Mem0, ZERO, BYTEControl, 0x0F000000, PGMRSRSP1, ZERO, PGMRETRY,
      0x00004608,
   12, DataControl, WORDControl, 0x02000000, ZERO, ZERO, PGMERROR,
      0x00000002,
   Mem0, DataControl, WORDControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00000004,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000DB0F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00003800,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000440F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000A700,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000C60F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00005900,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000C40F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00004E00,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000300F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00009000,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000590F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000E000,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000910F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00004D00,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000C80F,
   Mem0, ZERO, BYTEControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x0000CB00
};

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  FourChResp      - Initialization of FourChResp variable. It is        ***/
/***                    initialized to four channel tests programmed        ***/
/***                    response parameters.                                ***/
/******************************************************************************/
struct RespPara FourChResp[] = {
   2, DataControl, WORDControl, 0x01000000, ZERO, ZERO, PGMERROR, 0x00000001,
   10, DataControl, WORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMSPLIT,
     0x00000002,
   2, ZERO, WORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMRETRY, 0x00000002
};

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  EightChResp     - Initialization of EightChResp variable. It is       ***/
/***                    initialized to eight channel tests programmed       ***/
/***                    response parameters.                                ***/
/******************************************************************************/
struct RespPara EightChResp[] = {
   13, DataControl, WORDControl, 0x01000000, PGMRSRSP2, ZERO, PGMSPLIT,
     0x00000001,
   Mem1, ZERO, BYTEControl, 0x0F000000, PGMRSRSP1, ZERO, PGMRETRY, 0x00006308,
   4, ZERO, WORDControl, 0x02000000, ZERO, ZERO, PGMERROR, 0x00000002
};

/**********************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  TwoChDMAReq     - Initialization of TwoChDMAReq variable. It is       ***/
/***                    initialized to number of DMA requests for two       ***/
/***                    channel tests.                                      ***/
/******************************************************************************/
struct DMAReq TwoChDMAReq[] = {
  0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
  0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0,
  0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
  0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2,
  0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0,
  0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0,
  0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
  0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0
};

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  TwoChPrgmRespPar - Initialization of TwoChPrgmRespPar variable. It is ***/
/***                     initialized to two channel test numbers and its    ***/
/***                     programmed response parameters.                    ***/
/******************************************************************************/
struct PrgmCases TwoChPrgmRespPar[] = {
  "DMAC_2CH_3",  &Resp[0],
  "DMAC_2CH_5",  &Resp[1],
  "DMAC_2CH_5",  &Resp[2],
  "DMAC_2CH_9",  &Resp[3],
  "DMAC_2CH_13", &Resp[4],
  "DMAC_2CH_13", &Resp[5],
  "DMAC_2CH_14", &Resp[6],
  "DMAC_2CH_19", &Resp[7],
  "DMAC_2CH_25", &Resp[8],
  "DMAC_2CH_26", &Resp[9],
  "DMAC_2CH_27", &Resp[10],
  "DMAC_2CH_39", &Resp[11],
  "DMAC_2CH_40", &Resp[12],
  "DMAC_2CH_41", &Resp[13],
  "DMAC_2CH_42", &Resp[14],
  "DMAC_2CH_43", &Resp[15],
  "DMAC_2CH_44", &Resp[16],
  "DMAC_2CH_45", &Resp[17],
  "DMAC_2CH_46", &Resp[18],
  "DMAC_2CH_47", &Resp[19],
  "DMAC_2CH_48", &Resp[20],
  "DMAC_2CH_49", &Resp[21],
  "DMAC_2CH_50", &Resp[22],
  "EOFPRGMCASE", &Resp[0]
};

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  FourChPrgmRespPar - Initialization of FourChPrgmRespPar variable. It  ***/
/***                      is initialized to four channel test numbers  and  ***/
/***                      its programmed response parameters.               ***/
/******************************************************************************/
struct PrgmCases FourChPrgmRespPar[] = {
  "DMAC_4CH_5",  &FourChResp[0],
  "DMAC_4CH_5",  &FourChResp[1],
  "DMAC_4CH_6",  &FourChResp[2],
  "EOFPRGMCASE", &FourChResp[0]
 };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  EightChPrgmRespPar - Initialization of EightChPrgmRespPar variable.   ***/
/***                       It is initialized to eight channel test numbers  ***/
/***                       and its programmed response parameters.          ***/
/******************************************************************************/
struct PrgmCases EightChPrgmRespPar[] = {
  "DMAC_8CH_3",  &EightChResp[0],
  "DMAC_8CH_3",  &EightChResp[1],
  "DMAC_8CH_4",  &EightChResp[2],
  "EOFPRGMCASE", &EightChResp[0]
 };

/******************************************************************************/
/***      Variable         Description                                      ***/
/***------------------------------------------------------------------------***/
/***  PeriphReq         - Initialization of PeriphReq variable. It is       ***/
/***                      initialized to two channel test numbers and its   ***/
/***                      DMA Requests.                                     ***/
/******************************************************************************/
struct PeriphReq TwoChPeriphReq[] = {
  "DMAC_2CH_1",  &TwoChDMAReq[0],
  "DMAC_2CH_2",  &TwoChDMAReq[1],
  "DMAC_2CH_3",  &TwoChDMAReq[2],
  "DMAC_2CH_5",  &TwoChDMAReq[3],
  "DMAC_2CH_6",  &TwoChDMAReq[0],
  "DMAC_2CH_7",  &TwoChDMAReq[6],
  "DMAC_2CH_8",  &TwoChDMAReq[4],
  "DMAC_2CH_9",  &TwoChDMAReq[2],
  "DMAC_2CH_11", &TwoChDMAReq[5],
  "DMAC_2CH_12", &TwoChDMAReq[6],
  "DMAC_2CH_13", &TwoChDMAReq[7],
  "DMAC_2CH_16", &TwoChDMAReq[8],
  "DMAC_2CH_17", &TwoChDMAReq[9],
  "DMAC_2CH_18", &TwoChDMAReq[10],
  "DMAC_2CH_19", &TwoChDMAReq[11],
  "DMAC_2CH_20", &TwoChDMAReq[12],
  "DMAC_2CH_21", &TwoChDMAReq[6],
  "DMAC_2CH_22", &TwoChDMAReq[13],
  "DMAC_2CH_23", &TwoChDMAReq[14],
  "DMAC_2CH_24", &TwoChDMAReq[15],
  "DMAC_2CH_25", &TwoChDMAReq[16],
  "DMAC_2CH_31", &TwoChDMAReq[8],
  "DMAC_2CH_32", &TwoChDMAReq[8],
  "DMAC_2CH_33", &TwoChDMAReq[8],
  "DMAC_2CH_34", &TwoChDMAReq[8],
  "DMAC_2CH_35", &TwoChDMAReq[8],
  "DMAC_2CH_36", &TwoChDMAReq[8],
  "DMAC_2CH_37", &TwoChDMAReq[8],
  "DMAC_2CH_38", &TwoChDMAReq[8],
  "EOFREQCASE",  &TwoChDMAReq[0]
 };

/******************************************************************************/
/********************** Channel Register Programming **************************/
/******************************************************************************/
void ChannelPrgm(int Channel, int32 SrcAddr, int32 DestAddr, int32 LLIReg,
                 int32 CxControlRegData)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function programs DMACCxSrcAddr, DMACCxDestAddr, DMACCxLLIReg,
   DMACCxControl registers (x = 0 to 7) of given Channelx (x = 0 to 7). The 
   control parameters to be written in Channel registers (such as Source 
   address, Destination address, LLI address and Control register parameters)
   are passed as arguments along with channel to this function. This function
   first compares passed channel number is valid channel number (i.e. passed
   channel number lies in the range of 0 to 7. If passed channel number is
   valid number then this function program channel registers. This function
   calls ChannelRegisters function to find base address of channel registers.
   The ChannelRegisters returns pointer pointing to Channel regiter array.
   After each write in register, pointer is incremented by one. The pointer
   points to next register of channel.
 */

 int i = 0;
 char Message[100];
 int32 *ChRegAddr;

 /* Determine passed channel number is valid number */
 if ((Channel < 0) || (Channel > 7))
 {
   sprintf(Message,"Invalid Channel Number %d",Channel);
   C(Message);
 }
 else
 {
   /* Determine base address of channel registers */
   ChRegAddr = ChannelRegisters(Channel);

   /* Program Channel Source Address Register */
   Write(*ChRegAddr++, SrcAddr);

   /* Program Channel Destination Address Register */
   Write(*ChRegAddr++, DestAddr);
 
   /* Program Channel LLI Address Register */
   Write(*ChRegAddr++, LLIReg);

   /* Program Channel Control Register */
   Write(*ChRegAddr++, CxControlRegData);
 }
}

/******************************************************************************/
/************************** LLI Block Programming  ****************************/
/******************************************************************************/
void LLIPrgm(int NoOfLLI, int32 Addr, int32 SrcAddr, int32 DestAddr,
             int32 LLIAddr, int32 CxControlRegData, int32 SrcAddrMask,
             int32 DestAddrMask)
{
 /*
   Summary : LLIPrgm       
   =================       
   This function programs LLI block. The LLI block address, LLI parameters
   (such as Source address, Destination Address, LLI address, control register)
   and number of LLI are passed as function as arguments. This function uses 
   passed parameters for programming of first LLI. This function also evaluates 
   LLI parameters for consecutive LLI. For next LLI parameters, this function
   calls AddrGen function to generate Source Address and Destination Address.
   The LLI address is incremented to next LLI block(i.e. incremented by four 
   words) except for last LLI. For last LLI, LLI address is Null. Here the
   Control register parameters kept same for remaining LLI's.
 */
 int i;

 for (i = NoOfLLI; i > 0; i--)
 {
    /* If Last LLI, LLI Address is null */
    if ( i == 1 )
      LLIAddr   = 0x00000000;
 
    /* Writing LLI Source address parameter */
    Write(Addr, SrcAddr);

    /* Writing LLI Destination address parameter */
    Write(Addr + 0x00000004, DestAddr);

    /* Writing LLI starting address of next LLI */
    Write(Addr + 0x00000008, LLIAddr);

    /* Writing LLI Control register parameters */
    Write(Addr + 0x0000000C, CxControlRegData);

    /* Generate Next LLI Source Address */
    SrcAddr  = AddrGen(SrcAddr,  SrcAddr  | 0x0000FFFF) & SrcAddrMask;

    /* Generate Next LLI Destination Address */
    DestAddr = AddrGen(DestAddr, DestAddr | 0x0000FFFF) & DestAddrMask;

    /* Increment LLI address to next LLI block */
    LLIAddr  = LLIAddr  + 0x00000010;

    /* Increment LLI block slave address */
    Addr = Addr + 0x00000010;
 }
}

/******************************************************************************/
/**************************** Address Selection *******************************/
/******************************************************************************/
int32  AddressSelection(int PeriphNo)
{
 /*
   Summary : AddressSelection
   ==========================
   This function returns peripheral base address of peripheral. The peripheral
   number is passed as argument of function. This function is called while 
   programming the channel. This function is called for the determination of
   source or destination address depending on whether peripheral is used as
   source or destination peripheral respectively.
 */

 char Message [100];
 int32 Address;

 if (PeriphNo == 0)
   Address = DMACTRP0BASE;
 else if (PeriphNo == 1)
   Address = DMACTRP1BASE;
 else if (PeriphNo == 2)
   Address = DMACTRP2BASE;
 else if (PeriphNo == 3)
   Address = DMACTRP3BASE;
 else if (PeriphNo == 4)
   Address = DMACTRP4BASE;
 else if (PeriphNo == 5)
   Address = DMACTRP5BASE;
 else if (PeriphNo == 6)
   Address = DMACTRP6BASE;
 else if (PeriphNo == 7)
   Address = DMACTRP7BASE;
 else if (PeriphNo == 8)
   Address = DMACTRP8BASE;
 else if (PeriphNo == 9)
   Address = DMACTRP9BASE;
 else if (PeriphNo == 10)
   Address = DMACTRP10BASE;
 else if (PeriphNo == 11)
   Address = DMACTRP11BASE;
 else if (PeriphNo == 12)
   Address = DMACTRP12BASE;
 else if (PeriphNo == 13)
   Address = DMACTRP13BASE;
 else if (PeriphNo == 14)
   Address = DMACTRP14BASE;
 else if (PeriphNo == 15)
   Address = DMACTRP15BASE;
 else
 {
  sprintf(Message, "Invalid Peripheral Number : %d", PeriphNo);
  C(Message);
  return ;
 }
 return Address;
}

/******************************************************************************/
/**************************** Slave Address Selection *************************/
/******************************************************************************/
int32  SlaveAddrSelection(int PeriphNo)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function returns register base address of peripheral. The peripheral
   number is passed as argument of function. This function is called while 
   programming the peripheral.
 */

 int32 Address;
 char Message[100];
 if (PeriphNo == 0)
   Address = DMACTRP0REGBASE;
 else if (PeriphNo == 1)
   Address = DMACTRP1REGBASE;
 else if (PeriphNo == 2)
   Address = DMACTRP2REGBASE;
 else if (PeriphNo == 3)
   Address = DMACTRP3REGBASE;
 else if (PeriphNo == 4)
   Address = DMACTRP4REGBASE;
 else if (PeriphNo == 5)
   Address = DMACTRP5REGBASE;
 else if (PeriphNo == 6)
   Address = DMACTRP6REGBASE;
 else if (PeriphNo == 7)
   Address = DMACTRP7REGBASE;
 else if (PeriphNo == 8)
   Address = DMACTRP8REGBASE;
 else if (PeriphNo == 9)
   Address = DMACTRP9REGBASE;
 else if (PeriphNo == 10)
   Address = DMACTRP10REGBASE;
 else if (PeriphNo == 11)
   Address = DMACTRP11REGBASE;
 else if (PeriphNo == 12)
   Address = DMACTRP12REGBASE;
 else if (PeriphNo == 13)
   Address = DMACTRP13REGBASE;
 else if (PeriphNo == 14)
   Address = DMACTRP14REGBASE;
 else if (PeriphNo == 15)
   Address = DMACTRP15REGBASE;
 else
 {
  sprintf(Message, "Invalid Slave Peripheral Number % d", PeriphNo);
  C(Message);
  return ;
 }
 return Address;
}

/******************************************************************************/
/************************** Memory Block Programming **************************/
/******************************************************************************/
void MemoryPrgm(int32 MemoryNo, int32 ControlInfo, int32 DataMethod)
{
 /*
   Summary : MemoryPrgm   
   ====================   
   This function programs Memory Module. The memory module number is passed as
   argument to this function. The control information(such as default AHB
   response, Default Wait cycle, Number of Split or Retry response and Memory
   reset) and Data generation Method. This function programs DMACTrMemEnx (x =
   0, 1) and DMACTrMemDatax (x = 0, 1) register where x depends on Memory
   module to be programmed. If memory module 0 is to be programmed, function
   programs DMACTrMemEn0 and DMACTrMemData0. It programs DMACTrMemEn1 and
   DMACTrMemData1, if Memory module 1 is to be programmed.
 */
 if (MemoryNo == Mem0)
 {
  /* Programming DMACTrMemEn0 register */
  Write(DMACTrMemEn0, MEMORYENABLE | ControlInfo);
  /* Programming DMACTrMemData0 register */
  Write(DMACTrMemData0, 0xC2000003 | DataMethod);
 }
 else
 {
  /* Programming DMACTrMemEn1 register */
  Write(DMACTrMemEn1, MEMORYENABLE | ControlInfo);
  /* Programming DMACTrMemData1 register */
  Write(DMACTrMemData1, 0xC2000003 | DataMethod);
 }
}

/******************************************************************************/
/************************ Peripheral Block Programming ************************/
/******************************************************************************/
void PeriphPrgm (int PeriphNo, int32 ControlInfo, int32 DataMethod)
{
 /*
   Summary : PeriphPrgm   
   ====================   
   This function programs Peripheral Module. The peripheral module number is
   passed as argument to this function. The control information(such as default
   AHB response, Default Wait cycle, Number of Split or Retry response and
   Peripheral reset) and Data generation Method. This function programs
   DMACTrPeriphEnx (x = 0 to 15) and DMACTrPeriphDatax (x = 0 to 15) register
   where x depends on peripheral module to be programmed. If Peripheral module
   0 is to be programmed, function programs DMACTrPEriphEn0 and 
   DMACTrPeriphData0. It programs DMACTrPeriphEn1 and DMACTrPeriphData1, if
   Peripheral module 1 is to be programmed. This function calls
   SlaveAddrSelection function which returns peripheral register base address.
   This function uses this register base address for programming of the
   peripheral. The address of DMACTrPeriphEnx register is the register base
   address of that peripheral. The register base address is incremented by one
   word for the programming of DMACTrPeriphDatax register.
 */
  char Message[100];
  int32 RegAddr;
 
  /* Determine Register base address of the peripheral */ 
  RegAddr = SlaveAddrSelection(PeriphNo);

  /* Program DMACTrPeriphEnx register */
  Write (RegAddr, 0x80000000 | ControlInfo);

  /* Program DMACTrPeriphDatax register */
  Write (RegAddr + 4, 0xC2000003 | DataMethod);
}

/******************************************************************************/
/************************ Slave Peripheral Programming ************************/
/******************************************************************************/
void SlavePrgm(int32 FlowController, int SrcPeriph, int DestPeriph, 
               int32 SrcAHBResp, int32 DestAHBResp, int32 SrcWaitCyc,
               int32 DestWaitCyc, int32 DataGenMethod, int32 DataMethod,
               int32 SrcMaster, int32 DestMaster)
{
 /*
   Summary : SlavePrgm     
   ===================   
   This function  programs DMAC slave memory or peripheral modules depending on
   Flow controller type. The Flow Controller type is passed as argument of 
   function. The control information of Source and Destination slave module
   (such as Default AHB Response, Default Wait Cycle, Data Generation method,
    Sub Data method and  AHB Master)are passed as arguments of function. The
   function determines Source and Destination control information. The memory
   module is selected depending on AHB master. If Source Master or Destination
   Master is Master1 and if source or destination slave is Memory module then
   Memory module 0 is selected else Memory Module 1 is selected. This functions
   calls MemoryPrgm or PeriphPrgm for the programming of Memory or Peripheral
   module respectively.
 */

 int32 SrcInfo;
 int32 DestInfo;

 /* Evaluate Control information of Source slave module */ 
 SrcInfo  = SrcAHBResp | SrcWaitCyc | DataGenMethod;
 /* Evaluate Control information of Destination slave module */ 
 DestInfo = DestAHBResp | DestWaitCyc | DataGenMethod;

 switch (FlowController){
   case M2MDMAC    :
                      /* If the Source AHB Master is Master 1, Program Memory
                         Module 0 as Source Slave module else program Memory
                         module 1 as Source slave module.
                      */
                      if (SrcMaster == MASTER1)
                        MemoryPrgm(Mem0, SrcInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, SrcInfo, DataMethod);

                      /* If the Destination AHB Master is Master 1, Program
                         Memory Module 0 as Source Slave module else program
                         Memory module 1 as Source slave module.
                      */
                      if (DestMaster == MASTER1)
                        MemoryPrgm(Mem0, DestInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, DestInfo, DataMethod);

                      break;

   case M2PDMAC    :
                      /* If the Source AHB Master is Master 1, Program Memory
                         Module 0 as Source Slave module else program Memory
                         module 1 as Source slave module.
                      */
                      if (SrcMaster == MASTER1)
                        MemoryPrgm(Mem0, SrcInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, SrcInfo, DataMethod);

                      /* Program Destination Slave Peripheral */
                      PeriphPrgm(DestPeriph, DestInfo, DataMethod);
                      break;

   case P2MDMAC    :
                      /* Program Source Slave Peripheral */
                      PeriphPrgm(SrcPeriph, SrcInfo, DataMethod);

                      /* If the Destination AHB Master is Master 1, Program
                         Memory Module 0 as Source Slave module else program
                         Memory module 1 as Source slave module.
                      */
                      if (DestMaster == MASTER1)
                        MemoryPrgm(Mem0, DestInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, DestInfo, DataMethod);

                      break;

   case P2PDMAC    :
                      /* Program Source Slave Peripheral */
                      PeriphPrgm(SrcPeriph, SrcInfo, DataMethod);
                      /* Program Destination Slave Peripheral */
                      PeriphPrgm(DestPeriph, DestInfo, DataMethod);

                      break;

   case P2PDP      :
                      /* Program Source Slave Peripheral */
                      PeriphPrgm(SrcPeriph, SrcInfo, DataMethod);
                      /* Program Destination Slave Peripheral */
                      PeriphPrgm(DestPeriph, DestInfo, DataMethod);

                      break;

   case M2PDP      :
                      /* If the Source AHB Master is Master 1, Program Memory
                         Module 0 as Source Slave module else program Memory
                         module 1 as Source slave module.
                      */
                      if (SrcMaster == MASTER1)
                        MemoryPrgm(Mem0, SrcInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, SrcInfo, DataMethod);

                      /* Program Destination Slave Peripheral */
                      PeriphPrgm(DestPeriph, DestInfo, DataMethod);

                      break;

   case P2MSP      :
                      /* Program Source Slave Peripheral */
                      PeriphPrgm(SrcPeriph, SrcInfo, DataMethod);

                      /* If the Destination AHB Master is Master 1, Program
                         Memory Module 0 as Source Slave module else program
                         Memory module 1 as Source slave module.
                      */
                      if (DestMaster == MASTER1)
                        MemoryPrgm(Mem0, DestInfo, DataMethod);
                      else
                        MemoryPrgm(Mem1, DestInfo, DataMethod);

                      break;

   case P2PSP      :
                      /* Program Source Slave Peripheral */
                      PeriphPrgm(SrcPeriph, SrcInfo, DataMethod);
                      /* Program Destination Slave Peripheral */
                      PeriphPrgm(DestPeriph, DestInfo, DataMethod);

                      break;

   Default         :
                      C("Invalid Flow Controller");
 }
}

/******************************************************************************/
/******************** Programming Slave for Programmed  Response **************/
/******************************************************************************/
void SlaveRespPrgm(struct PrgmCases *RespCases, char* TestNo, int NoOfResp)
{
 /*
   Summary : SlaveRespPrgm 
   ======================= 
   This function programs control registers of memory or peripheral slave module
   for its programmed responses. The programmed responses and number of
   programmed response are passed as arguments of function. The programmed
   responses are passed as in structure format. The function compares TestNo,
   passed as argument of function, with TestNo pointed by pointer RespCases. If
   TestNo matches, function extracts all control information (such as
   Peripheral number, control method, HSIZE, Number of valid bits, number of
   Split or Retry responses, Address/Data Count). After extracting the control 
   information, it determines register base address of memory/peripheral module
   to be programmed. After programming slave module, it increments Count by one.
   Count indicates number of programmed response programmed. The RespCases
   pointer is incremented to point to next Test No of the programmed structure.
   It repeats above procedure until TestNo pointed by RespCases pointer is
   "EOFPRGMCASE". After programming all programmed responses, Count is compared
   With NoOfPrgmResp (number of programmed responses passed as function 
   argument). If Count and NoOfPrgmResp is not equal than function flags
   message of Mismatch in Number of Programmed responses and actual responses
   programmed and its value.
 */

 char  Message[100];
 int32 Periph;
 int32 ControlMethod;
 int32 Size;
 int32 ValidBits;
 int32 NoOfPrgmdSRResp;
 int32 ProgrammedWaitCyc;
 int32 ProgrammedResp;
 int32 AddrDataCount;
 int32 Count = 0;
 int32 Addr;
 int32 ControlInfo;
 int32 Offset;

 msg_info("Programming Slave module for Programmed Response");
 while (RespCases->TestNo != "EOFPRGMCASE") 
 {
  if (RespCases->TestNo == TestNo)
   {
    /* Extract Peripheral value */
    Periph           = RespCases->PrgmRespPara->PeriphValue;

    /* Extract Control method */
    ControlMethod    = RespCases->PrgmRespPara->ControlMethod;

    /* Extract HSIZE */
    Size             = RespCases->PrgmRespPara->Size;

    /* Extract Number of Valid bits */
    ValidBits        = RespCases->PrgmRespPara->ValidBits;

    /* Extract Number of Programmed Split/Retry Response */
    NoOfPrgmdSRResp  = RespCases->PrgmRespPara->NoOfPrgmdSRResp;

    /* Extract Number of Programmed Wait cycles response */
    ProgrammedWaitCyc = RespCases->PrgmRespPara->ProgrammedWaitCyc;

    /* Extract Type of Programmed response */
    ProgrammedResp    = RespCases->PrgmRespPara->ProgrammedResp;

    /* Extract Address/Data Count */
    AddrDataCount    = RespCases->PrgmRespPara->AddrDataCount;
  
    /* Determine Memory/Peripheral Register Base Address */
    if (Periph == Mem1 || Periph == Mem0 || Periph == NA) 
    {
      if (Periph == Mem0 || Periph == NA)
        Addr = DMACTRMEM0REGBASE;
      else 
        Addr = DMACTRMEM1REGBASE;
        Offset = 0x00000008; 
    }
    else
    {
      Addr = SlaveAddrSelection(Periph);
      Offset = 0x0000001C; 
    }

    /* Address is incremented to Next Control Register */
    Addr = Addr + Offset + 4 * Count;

    /* Generating control information to be written in to Control Reg */ 
    ControlInfo = ControlMethod | Size | ValidBits | NoOfPrgmdSRResp | 
                  ProgrammedWaitCyc | ProgrammedResp | AddrDataCount |
                  0x80000000;
    Write(Addr, ControlInfo);

    /* Increment Count by 1 to indicate number of programmed response 
       programmed.
    */
    Count = Count + 1;
 
    if (Count == NoOfResp)
    {
     msg_info("Peripheral is programmed for all responses");
     break;
    }
   }
   RespCases++;
  } 
  if (Count != NoOfResp)
  {
   sprintf(Message, "Mismatch in Number of Programmed Response and Actual"
                   " Number of Resp. Number of Programmed Resp : %d "
                   " Actual Number of Resp : %d", NoOfResp, Count);
   msg_info(Message);
  }   
}

/******************************************************************************/
/******************** DMAC Last Single/Burst Request Assertion ****************/
/******************************************************************************/
void DMALastReq(int Channel, int32 FlowControl, int32 SrcPeriph,
                int32 *SrcLSREQ, int32 *SrcLBREQ, int32 DestPeriph,
                int32 *DestBREQ)
{
 /*
   Summary : DMALastReq    
   ====================   
   This function programs DMAC Source Last Burst/Single request, Destination  
   Burst request. This function is used in two channel test cases. This 
   function is called when Flow controller is P2MSP or P2PSP. The Flow
   controller type is passed along with number of Source/Destination requests
   and Source/Destination peripheral as arguments of function. This function
   initially poll DMAC Last single request(DMACLSBREQ)/ DMAC Last Burst request
   (DMACLBREQ) going low for Source peripheral. Once DMACLSREQ/DMACLBREQ goes
   low, function decrements SrcLSREQ(Source Last single) / SrcLBREQ(Source Last
   Burst) request count. If the Flow Controller is P2PSP, function polls for 
   Destination Burst request going low as DMACBREQ is only valid for Destination
   peripheral in P2PSP Flow Controller. It decrements DestBREQ (Destination
   Burst request)count. The function asserts DMAC Last single/Last Burst
   request. It also asserts Destination DMAC Burst requests. The function
   repeats above procedure until all DMAC requests are asserted and cleared
   (i.e. when SrcLSREQ/SrcLBREQ and DestBREQ becomes zero).
 */
  char Message[100];
  int32 MaskValue = 0x00000000;
  int32 Addr;

  while (*SrcLSREQ || *SrcLBREQ || *DestBREQ)
  {
     /* If both LSREQ and LBREQ to be asserted then poll only One Register */
     /* Poll DMACSoftLBReq register when both DMACLSREQ and DMACLBREQ are
        asserted or only DMACLBREQ is asserted  */
     if ((*SrcLSREQ && *SrcLBREQ) || (*SrcLBREQ))
     {
       /* Determine Mask value and Poll DMACSoftLBReq Register */
       MaskValue = ReqExpValue[SrcPeriph];
       Poll(DMACSoftLBReq, 0x0, MaskValue);
       WaitLoop(1);
       if (*SrcLSREQ && *SrcLBREQ)
       {
         /* Decrement Source Last Single and Last Burst request count */
         *SrcLSREQ = *SrcLSREQ - 1;
         *SrcLBREQ = *SrcLBREQ - 1;

         sprintf(Message,"Source DMACLSREQ & DMACLBREQ of CH %d are cleared",
                 Channel);
         msg_info(Message);
       }
       else
       {
         /* Decrement Source Last Burst request count */
         *SrcLBREQ = *SrcLBREQ - 1;

         sprintf(Message,"Source DMACLBREQ of CH %d is cleared", Channel);
         msg_info(Message);
       }
     }
     else if (*SrcLSREQ)
     {
       /* If only Source Last Single request is asserted, poll DMACSoftLSReq 
          register */
       /* Determine Mask value and Poll DMACSoftLSReq Register */
       MaskValue = ReqExpValue[SrcPeriph];
       Poll(DMACSoftLSReq, 0x0, MaskValue);
       WaitLoop(1);

       /* Decrement Source Last Burst request count */
       *SrcLSREQ = *SrcLSREQ - 1;

       sprintf(Message,"Source DMACLSREQ of CH %d is cleared", Channel);
       msg_info(Message);
     }
     if (FlowControl == P2PSP)
     {
       /* Determine expected mask and Poll DMACSoftBReq Register */
       MaskValue = ReqExpValue[DestPeriph];
       Poll(DMACSoftBReq, 0x0, MaskValue);
       WaitLoop(1);

       /* Decrement Destination Burst request count */
       *DestBREQ = *DestBREQ - 1;

       sprintf(Message,"Destination DMACBREQ of CH %d are cleared", Channel);
       msg_info(Message);
     }
     /* Assert Source DMACLS/DMACLB request if any */
     if (*SrcLSREQ && *SrcLBREQ)
     {
       /* Determine Source peripheral register base address */
       Addr = SlaveAddrSelection(SrcPeriph);
       /* Assert Source DMACLSReq request and DMACLBReq request */
       Write(Addr + PERIPHREQREG, 0x02020000);

       sprintf(Message,"Source DMACLSREQ & DMACLBREQ of CH %d are asserted",
               Channel);
       msg_info(Message);
     }
     else if (*SrcLBREQ)
     {
       /* Determine Source peripheral register base address */
       Addr = SlaveAddrSelection(SrcPeriph);
       /* Assert Source DMACLBReq request */
       Write(Addr + PERIPHREQREG, 0x02000000);

       sprintf(Message,"Source DMACBREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
     else if (*SrcLSREQ)
     {
       /* Determine Source peripheral register base address */
       Addr = SlaveAddrSelection(SrcPeriph);
       /* Assert Source DMACLSReq request */
       Write(Addr + PERIPHREQREG, 0x00020000);

       sprintf(Message,"Source DMACBREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
     /* Assert Destination DMAC Burst request if any */ 
     if (*DestBREQ)
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMACBReq request */
       Write(Addr + PERIPHREQREG, 0x00000200);

       sprintf(Message,"Destination DMACBREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
  }
}

/******************************************************************************/
/***************************** DMAC Request Assertion *************************/
/******************************************************************************/
void DMAREQSET (int Channel, int32 SrcPeriph, int32 *SrcSREQ, int32 *SrcBREQ,
                int32 *SrcLSREQ, int32 *SrcLBREQ, int32 DestPeriph,
                int32 *DestSREQ, int32 *DestBREQ, int32 *DestLSREQ, 
                int32 *DestLBREQ, int32 FlowControl)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function programs Source and Destination Peripheral requests. This 
   function is called when Flow controller is P2PSP, P2PSP, P2PDMAC, P2MDMAC,
   and P2MSP. This function is used in two channel test cases. The Flow
   controller type is passed along with number of Source/Destination requests
   and Source/Destination peripheral as arguments of function. This function
   initially poll DMAC Single request(DMACSBREQ)/ DMAC Burst request (DMACLBREQ)
   going low for Source peripheral. Once DMACSREQ/DMACBREQ goes low, function
   decrements SrcSREQ(Source single)/SrcBREQ(Source Burst) request count.
   If the Flow Controller is P2PSP or P2PDP or P2PDMAC, function polls for
   Destination Single/Burst/Last Single/Last Burst request going low as
   DMACBREQ is only valid for Destination peripheral. It decrements DestSREQ/
   DestBREQ/DestLSREQ/DestLBREQ (Destination Single/Burst/Last Single/Last Burst
   request)count. The function asserts Source and Destination DMA request if
   any. The function calls SlaveAddrSelection function to determine register
   base address of peripheral for the assertion DMA requests.
 */
  char Message[100]; 
  int32 MaskValue = 0x00000000;
  int32 Addr;

   /* If both SREQ and BREQ to be asserted then poll only One Register */
   /* Poll DMACSoftBReq register when both DMACSREQ and DMACBREQ are
      asserted or only DMACBREQ is asserted  */
  if (((*SrcSREQ) && (*SrcBREQ)) || (*SrcBREQ))
  {
    /* Determine expected mask and poll DMACSoftBReq register */ 
    MaskValue = ReqExpValue[SrcPeriph];
    Poll(DMACSoftBReq, 0x0, MaskValue);
    WaitLoop(1);

    if ((*SrcSREQ) && (*SrcBREQ))
    {
      /* Decrement Source Single and Burst request count */
      *SrcSREQ = *SrcSREQ - 1;
      *SrcBREQ = *SrcBREQ - 1;

      sprintf(Message,"Source DMACSREQ & DMACBREQ of CH %d are cleared",
              Channel);
      msg_info(Message);
    }
    else
    {
      /* Decrement Source Burst request count */
      *SrcBREQ = *SrcBREQ - 1;

      sprintf(Message,"Source DMACBREQ of CH %d is cleared", Channel);
      msg_info(Message);
    }
  }
  else if (*SrcSREQ)
  {
    /* Determine expected mask value and poll DMACSoftSReq Register */
    MaskValue = ReqExpValue[SrcPeriph];
    Poll(DMACSoftSReq, 0x0, MaskValue);
    WaitLoop(1);

    /* Decrement Source Single request count */
    *SrcSREQ = *SrcSREQ - 1;
    sprintf(Message,"Source DMACSREQ of CH %d is cleared", Channel);
    msg_info(Message);
  } 
  /* Generating next Source DMAC requests if Any */
  if ((*SrcSREQ) && (*SrcBREQ))
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACSReq and DMACBReq request */
    Write(Addr + PERIPHREQREG, 0x00000202);

    sprintf(Message,"Source DMACSREQ & DMACBREQ of CH %d are asserted",
            Channel);
    msg_info(Message);
  }
  else if (*SrcBREQ)
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACBReq request */
    Write(Addr + PERIPHREQREG, 0x00000200);

    sprintf(Message,"Source DMACBREQ of CH %d is asserted", Channel);
    msg_info(Message);
  }
  else if (*SrcSREQ)
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACSReq request */
    Write(Addr + PERIPHREQREG, 0x00000002);

    sprintf(Message,"Source DMACSREQ of CH %d is asserted", Channel);
    msg_info(Message);
  }
  else if (*SrcLSREQ && *SrcLBREQ)
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACLSReq and DMACLBReq request */
    Write(Addr + PERIPHREQREG, 0x02020000);

    sprintf(Message,"Source DMACLSREQ and DMACLBREQ of CH %d are asserted",
            Channel);
    msg_info(Message);
  }   
  else if (*SrcLSREQ)
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACLSReq request */
    Write(Addr + PERIPHREQREG, 0x00020000);
    sprintf(Message,"Source DMACLSREQ of CH %d is asserted", Channel);
    msg_info(Message);
  }
  else if (*SrcLBREQ)
  {
    /* Determine Source peripheral register base address */
    Addr = SlaveAddrSelection(SrcPeriph);
    /* Assert Source DMACLBReq request */
    Write(Addr + PERIPHREQREG, 0x02000000);

    sprintf(Message,"Source DMACLBREQ of CH %d is asserted", Channel);
    msg_info(Message);
  }
  /* Wait for Destination Request to be cleared and assert Destination request
     if any */
  if (FlowControl == P2PSP || FlowControl == P2PDP || FlowControl == P2PDMAC)
  {
     /* If both LSREQ and LBREQ to be asserted then poll only one Register */
     /* Poll DMACSoftLBReq register when both DMACLSREQ and DMACLBREQ are
        asserted or only DMACLBREQ is asserted  */
    if (((*DestBREQ) && (*DestSREQ)) || (*DestBREQ))
    {
      /* Determine expected mask value and poll DMACSoftBReq Register */
      MaskValue = ReqExpValue[DestPeriph];
      Poll(DMACSoftBReq, 0x0, MaskValue);
      WaitLoop(1);

      if ((*DestBREQ) && (*DestSREQ))
      {
        /* Decrement Destination Single and Burst request count */
        *DestSREQ = *DestSREQ - 1;
        *DestBREQ = *DestBREQ - 1;

        sprintf(Message,"Destination DMACSREQ and DMACBREQ of CH %d are"
                        " cleared", Channel);
        msg_info(Message);
      }
      else
      {
        /* Decrement Destination Burst request count */
        *DestBREQ = *DestBREQ - 1;

        sprintf(Message,"Destination DMACBREQ of CH %d is cleared", Channel);
        msg_info(Message);
      }
     }
     else if (*DestSREQ)
     {
       /* Determine expected mask and poll DMACSoftSReq Register */
       MaskValue = ReqExpValue[DestPeriph];
       Poll(DMACSoftSReq, 0x0, MaskValue);
       WaitLoop(1);

       /* Decrement Destination Burst request count */
       *DestSREQ = *DestSREQ - 1;

       sprintf(Message,"Destination DMACSREQ of CH %d is cleared", Channel);
       msg_info(Message);
     }
     else if (((*DestLBREQ) && (*DestLSREQ)) || (*DestLBREQ))
     {
       /* If both LSREQ and LBREQ to be asserted then poll only One Register */
       /* Poll DMACSoftLBReq register when both DMACLSREQ and DMACLBREQ are
          asserted or only DMACLBREQ is asserted  */
       MaskValue = ReqExpValue[DestPeriph];
       Poll(DMACSoftLBReq, 0x0, MaskValue);
       WaitLoop(1);

       if ((*DestLBREQ) && (*DestLSREQ))
       {
         /* Decrement Destination Last Single and Last Burst request count */
         *DestLSREQ = *DestLSREQ - 1;
         *DestLBREQ = *DestLBREQ - 1;

         sprintf(Message,"Destination DMACLSREQ and DMACLBREQ of CH %d are"
                         " cleared", Channel);
         msg_info(Message);
       }
       else
       {
         /* Decrement Destination Last Burst request count */
         *DestLBREQ = *DestLBREQ - 1;

         sprintf(Message,"Destination DMACLBREQ of CH %d is cleared", Channel);
         msg_info(Message);
       }
     }
     else if (*DestLSREQ)
     {
       /* Determine expected mask and poll DMACSoftLSReq Register */
       MaskValue = ReqExpValue[DestPeriph];
       Poll(DMACSoftLSReq, 0x0, MaskValue);
       WaitLoop(1);

       /* Decrement Destination Last Single request count */
       *DestLSREQ = *DestLSREQ - 1;
       sprintf(Message,"Destination DMACLSREQ of CH %d is cleared", Channel);
       msg_info(Message);
     }

     /* Generating Next Destination DMA REQUEST if any */
     if ((*DestSREQ) && (*DestBREQ))
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMACSReq and DMABReq request */
       Write(Addr + PERIPHREQREG, 0x00000202);

       sprintf(Message,"Destination DMACSREQ & DMACBREQ of CH %d are asserted",
               Channel);
       msg_info(Message);
     }
     else if (*DestBREQ)
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMABReq request */
       Write(Addr + PERIPHREQREG, 0x00000200);

       sprintf(Message,"Destination DMACBREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
     else if (*DestSREQ)
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMASReq request */
       Write(Addr + PERIPHREQREG, 0x00000002);
       sprintf(Message,"Destination DMACSREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
     else if ((*DestLSREQ) && (*DestLBREQ))
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMACLSReq and DMALBReq request */
       Write(Addr + PERIPHREQREG, 0x02020000);

       sprintf(Message,"Destination DMACLSREQ and DMACLBREQ of CH %d are"
                      " asserted", Channel);
       msg_info(Message);
     }
     else if (*DestLSREQ)
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMACLSReq request */
       Write(Addr + PERIPHREQREG, 0x00020000);

       sprintf(Message,"Destination DMACLSREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
     else if (*DestLBREQ)
     {
       /* Determine Destination peripheral register base address */
       Addr = SlaveAddrSelection(DestPeriph);
       /* Assert Destination DMACLBReq request */
       Write(Addr + PERIPHREQREG, 0x02000000);
       sprintf(Message,"Destination DMACLBREQ of CH %d is asserted", Channel);
       msg_info(Message);
     }
  }
}

/******************************************************************************/
/***************************** DMAC Request Assertion *************************/
/******************************************************************************/
void SingleChReq (int Channel, int32 FlowControl, int32 DestPeriph,
                  int32 *DestSREQ, int32 *DestBREQ, int32 *DestLBREQ,
                  int32 *DestLSREQ) 
{
 /*
   Summary : SingleChReq   
   =====================
   This function programs DMAC Destination Single/Burst/Last Single/Last Burst
   request. This function is used in two channel test cases. This function is
   called when Flow controller is M2PDMAC or M2PDP. The Flow controller type is
   passed along with number of Destination requests and Destination peripheral
   as arguments of function. This function initially poll DMAC Single/Burst/Last
   single/Last Burst request(DMACSREQ/DMACBREQ/DMACLSBREQ/DMACLBREQ) going
   low for Destination peripheral. Once DAMCSREQ/DAMCBREQ/DMACLSREQ/DMACLBREQ
   goes low, function decrements Destination Single/Burst/Last Single/Last
   Burst(DestSREQ/DestBREQ/DestLBREQ/DestLSREQ)request count. The function
   asserts Destination DMA request if any. The function calls
   SlaveAddrSelection function to determine register base address of peripheral
   for the assertion DMA requests.
 */
  int32 MaskValue = 0x00000000, Addr;
  char Message[100];
  while (*DestSREQ || *DestBREQ || *DestLBREQ || *DestLSREQ)
  {
    if (FlowControl != M2MDMAC)
    {
      if ((FlowControl == M2PDMAC) || (FlowControl == M2PDP))
      {
        /* Wait For Destination Request to be cleared */
        if (FlowControl == M2PDMAC)
        {
          /* In case of M2PDMAC flow controller, the Destination 
             DMABREQ is only valid */
          if (*DestBREQ)
          {
            /* Determine expected Mask and poll DMACSoftBReq register */
            MaskValue = ReqExpValue[DestPeriph];
            Poll(DMACSoftBReq, 0x0, MaskValue);
            WaitLoop(1);

            /* Decrement Destination Burst request count */
            *DestBREQ = *DestBREQ - 1;

            sprintf(Message,"Destination DMACBREQ of CH %d is"
                    " cleared", Channel);
            msg_info(Message);
          }
        }
        else
        {
          /* If both DAMCSREQ and DAMCBREQ to be asserted then poll only one
             register */
          /* Poll DMACSoftBReq register when both DMACSREQ and DMACBREQ are
             asserted or only DMACBREQ is asserted  */
          if ((*DestBREQ && *DestSREQ) || *DestBREQ)
          {
            /* Determine expected mask value and poll DMACSoftBReq Register */
            MaskValue = ReqExpValue[DestPeriph];
            Poll(DMACSoftBReq, 0x0, MaskValue);
            WaitLoop(1);

            if (DestBREQ && DestSREQ)
            {
              /* Decrement Destination Single and Burst request count */
              *DestBREQ = *DestBREQ - 1;
              *DestSREQ = *DestSREQ - 1;

              sprintf(Message,"Destination DMACBREQ and DMACSREQ of CH %d is"
                      " cleared", Channel);
              msg_info(Message);
            }
            else
            {
              /* Decrement Destination Burst request count */
              *DestBREQ = *DestBREQ - 1;
              sprintf(Message,"Destination DMACBREQ of CH %d is cleared",
                      Channel);
              msg_info(Message);
            }
          }
          else if (*DestSREQ)
          {
            /* Determine expected mask value and poll DMACSoftSReq Register */
            MaskValue = ReqExpValue[DestPeriph];
            Poll(DMACSoftSReq, 0x0, MaskValue);
            WaitLoop(1);

            /* Decrement Destination Single request count */
            *DestSREQ = *DestSREQ - 1;
            sprintf(Message,"Destination DMACSREQ of CH %d is "
                            " cleared", Channel);
            msg_info(Message);
          }
          if ((*DestLBREQ && *DestLSREQ) || *DestLBREQ)
          {
            /* If both DAMCLSREQ and DAMCLBREQ to be asserted then poll only one
               register */
            /* Poll DMACSoftLBReq register when both DMACLSREQ and DMACLBREQ are
               asserted or only DMACLBREQ is asserted  */

            MaskValue = ReqExpValue[DestPeriph];
            Poll(DMACSoftLBReq, 0x0, MaskValue);
            WaitLoop(1);

            if (*DestLBREQ && *DestLSREQ)
            {
              /* Decrement Destination Last Single and Last Burst request
                 count*/
              *DestLBREQ = *DestLBREQ - 1;
              *DestLSREQ = *DestLSREQ - 1;

              sprintf(Message,"Destination DMACLBREQ and DMACLSREQ of CH %d is"
                      " cleared", Channel);
              msg_info(Message);
            }
            else
            {
              /* Decrement Destination Last Burst request count*/
              *DestLBREQ = *DestLBREQ - 1;

              sprintf(Message,"Destination DMACLBREQ of CH %d is cleared",
                      Channel);
              msg_info(Message);
            }
          }
          else if (*DestLSREQ)
          {
            /* Determine expected Mask and poll DMACSoftLSReq register */
            MaskValue = ReqExpValue[DestPeriph];
            Poll(DMACSoftLSReq, 0x0, MaskValue);
            WaitLoop(1);

            /* Decrement Destination Last Single request count*/
            *DestLSREQ = *DestLSREQ - 1;
            sprintf(Message,"Destination DMACLSREQ of CH %d is"
                            " cleared", Channel);
            msg_info(Message);
          }
        }
        /* Generating next Destination DMA REQUEST if any */
        if ((*DestSREQ) && (*DestBREQ))
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMACSReq and DMABReq request */
          Write(Addr + PERIPHREQREG, 0x00000202);

          sprintf(Message,"Destination DMACSREQ & DMACBREQ of CH %d are "
                          " asserted", Channel);
          msg_info(Message);
        }
        else if (*DestBREQ)
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMABReq request */
          Write(Addr + PERIPHREQREG, 0x00000200);

          sprintf(Message,"Destination DMACBREQ of CH %d is asserted", Channel);
          msg_info(Message);
        }
        else if (*DestSREQ)
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMASReq request */
          Write(Addr + PERIPHREQREG, 0x00000002);
          sprintf(Message,"Destination DMACSREQ of CH %d is asserted", Channel);
          msg_info(Message);
        }
        else if ((*DestLSREQ) && (*DestLBREQ))
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMACLSReq and DMALBReq request */
          Write(Addr + PERIPHREQREG, 0x02020000);

          sprintf(Message,"Destination DMACLSREQ and DMACLBREQ of CH %d are"
                         " asserted", Channel);
          msg_info(Message);
        }
        else if (*DestLSREQ)
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMACLSReq request */
          Write(Addr + PERIPHREQREG, 0x00020000);

          sprintf(Message,"Destination DMACLSREQ of CH %d is asserted",
                  Channel);
          msg_info(Message);
        }
        else if (*DestLBREQ)
        {
          /* Determine Destination peripheral register base address */
          Addr = SlaveAddrSelection(DestPeriph);
          /* Assert Destination DMACLBReq request */
          Write(Addr + PERIPHREQREG, 0x02000000);

          sprintf(Message,"Destination DMACLBREQ of CH %d is asserted",
                  Channel);
          msg_info(Message);
        }        
      }
    }
  }
}

/******************************************************************************/
/***************************** Channel Programming ****************************/
/******************************************************************************/
void ChannelSetup(struct ChannelPara *ChSetupPara, int32 DataGenMethod, 
                  int32 DataMethod)
{
 /*
   Summary : ChannelSetup  
   ======================  
   This function programs Channel registers. The channel parameters are passed
   as a arguments of function. The Data generation method and its sub method
   are also passed as function arguments. This function is used in Four Channel
   and Eight Channel test cases. The function determines Source address and
   Destination address by calling AddrGen function. In case of any Memory
   transaction, if AHB master is Master1 then Memory Module 0 is selected as
   slave module.  If AHB master is Master2 then Memory Module 1 is selected.
   The function also determines LLI address if there is any LLI operation. The
   function also determines Control Register information. It calls function
   ChannelPrgm which writes channel register. The function passes Source
   Address( SrcAddr), Destination Address(DestAddr), LLI Address(CxLLIRegData)
   and Control Register Data(CxControlRegData) as arguments to ChannelPrgm
   function. The function also programs LLI block by calling LLIPrgm function.
   The arguments passed to LLIPrgm are number of LLI(NoOfLLI), LLI block slave
   address(LLIAddr), Source address(SrcAddr), Destination address(DestAddr),
   LLI address(CxLLIRegData), Control register data(CxControlRegData), Source
   address mask(SrcAddrMask) and Destination Address mask(DestAddrMask). Finally
   it programs the slave Memory and Peripheral module by calling SlavePrgm
   function. The type of Flow controller, Source/Destination peripheral number
   and its AHB Master/Response, Data generation method are passed as function
   arguments to SlavePrgm function.
 */ 

  int32 SrcAddrMask, DestAddrMask;
  int32 Addr, CxLLIRegData, CxControlRegData;
  char  Message[100];
  int32 SrcAddr, DestAddr, LLIAddr;

  /* Define Source and Destination Address Mask */
  SrcAddrMask  = 0xFFFFFF00;
  DestAddrMask = 0xFFFFFF00;
  
  sprintf(Message,"Programming Channel %d ", ChSetupPara->Channel);
  msg_info(Message);

  /* Source Address Selection */
  if (ChSetupPara->SrcPeriph == NA)
  {
    if (ChSetupPara->SrcMaster == MASTER1)
    {
      msg_info("Selcting Memory Module 0 as Source slave Peripheral");
      SrcAddr   = AddrGen(DMACTRMEM0BASE | 0x00000100, M0HIGHADDRRANGE) &
                  SrcAddrMask;
    }
    else
    {
      msg_info("Selcting Memory Module1 as Source slave Periph");
      SrcAddr   = AddrGen(DMACTRMEM1BASE | 0x00000100, M1HIGHADDRRANGE) &
                  SrcAddrMask;
    }
  }
  else
  {
    Addr  = AddressSelection(ChSetupPara->SrcPeriph);
    SrcAddr  = AddrGen(Addr, Addr | 0x0000FFFF) & SrcAddrMask;
    sprintf(Message,"Source Peripheral : %d ", ChSetupPara->SrcPeriph);
    msg_info(Message);
  }

  /*  Destination Address Selection */
  if (ChSetupPara->DestPeriph == NA)
  {
    if (ChSetupPara->DestMaster == MASTER1)
    {
      msg_info("Selcting Memory Module 0 as Destination slave Peripheral");
      DestAddr   = AddrGen(DMACTRMEM0BASE | 0x00000100, M0HIGHADDRRANGE) &
                   DestAddrMask;
    }
    else
    {
      msg_info("Selcting Memory Module1 as Destination slave Periph");
      DestAddr   = AddrGen(DMACTRMEM1BASE | 0x00000100, M1HIGHADDRRANGE) &
                   DestAddrMask;
    }
  }
  else
  {
    Addr  = AddressSelection(ChSetupPara->DestPeriph);
    DestAddr = AddrGen(Addr, Addr | 0x0000FFFF) & DestAddrMask;
    sprintf(Message,"Destination Peripheral : %d ", ChSetupPara->DestPeriph);
    msg_info(Message);
  }

  /* Generation of CxLLIAddr Address. The LLI block slave address is used for
     generation of CxLLIAddr. If LLI AHB Master is Master1 then Memory Module 0
     is selected else Memory Module 1 is selected for LLI load. For the
     generation of CxLLIAddr, LLI Base Address of Memory Module 0/1 is ORed
     with LLI block slave address. */
  LLIAddr   = ChSetupPara->LLIAddr;
  if (ChSetupPara->NoOfLLI > 0)
  {  
    if (ChSetupPara->DestMaster == MASTER1)
    {
      CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM1;
    }
    else 
      CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM2 | 0x00000001;
  }
  else
      CxLLIRegData = 0x00000000;

  /* Determine Cx Control Register Information */
  CxControlRegData =
                     ChSetupPara->TxSize             |
                     SbValue(ChSetupPara->SrcBurst)  |
                     DbValue(ChSetupPara->DestBurst) |
                     SwValue(ChSetupPara->SrcWidth)  |
                     DwValue(ChSetupPara->DestWidth) |
                     SmValue(ChSetupPara->SrcMaster) |
                     DmValue(ChSetupPara->DestMaster)|
                     SiValue(ChSetupPara->SrcIncr)   |
                     DiValue(ChSetupPara->DestIncr);  
 
  /* Programming Source, Destination, LLI and Control reg */
  ChannelPrgm(ChSetupPara->Channel, SrcAddr, DestAddr, CxLLIRegData,
              CxControlRegData);


  /* LLI Programming */
  if (ChSetupPara->NoOfLLI > 0)
  {
    /* Generate Source Address for Next LLI block parameters */
    SrcAddr   = AddrGen(SrcAddr,  SrcAddr  | 0x0000FFFF) & SrcAddrMask;
    /* Generate Destination Address for Next LLI block parameters */
    DestAddr  = AddrGen(DestAddr, DestAddr | 0x0000FFFF) & DestAddrMask;
    /* Generate LLI address of next block. It is generated by adding 4 words. */
    CxLLIRegData = CxLLIRegData + 0x00000010;
    /* Call function LLIPrgm to write next LLI block parameters in LLI block */ 
    LLIPrgm (ChSetupPara->NoOfLLI, LLIAddr, SrcAddr, DestAddr,
             CxLLIRegData,  CxControlRegData, SrcAddrMask, DestAddrMask);
  }

  /* Slave Module Programming */
  SlavePrgm(
            ChSetupPara->FlowControl,
            ChSetupPara->SrcPeriph,
            ChSetupPara->DestPeriph,
            ChSetupPara->SrcAHBResp,
            ChSetupPara->DestAHBResp,
            ChSetupPara->SrcWaitCyc,
            ChSetupPara->DestWaitCyc,
            DataGenMethod,
            DataMethod,
            ChSetupPara->SrcMaster,
            ChSetupPara->DestMaster
           );

}

/******************************************************************************/
/********************* DMACREQCONFIG Register Programming *********************/
/******************************************************************************/
void ReqRegConfig4(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : ReqRegConfig4 
   ======================= 
   This function program DMACREQCONFIG register. This function is called in 
   Four channel test cases. The control information of all 4 Channels are passed
   as function argument. The DMACREQCONFIG register indicates that given memory/
   Peripheral module is configured to Master 1 or Master 2. If Memory/Peripheral
   module is configured to Master 2 then Memory/Peripheral bit is set in 
   DMACREQCONFIG register. The function extracts all four channel control
   information. The function compares First Channel Source AHB Master for 
   Master 2. If First Channel Source Master is Master2 then it sets Source
   Peripheral bit in DMACREQCONFIG register. It compares Destination Master for
   Master 2. If First Channel Destination Master is Master 2 then it sets
   Memory/Peripheral bit in DMACREQCONFIG register. For the programming of 
   DMACREQCONFIG register, TempPerpMaster variable is used. It indicates
   peripheral to be connected to Master 2. The above procedure is repeated for
   remained three channels.
 */   
 
  int32 TempPerpMaster = 0x00000000;

  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;
  
  msg_info("Programming DMACREQCONFIG Register");

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel1->SrcMaster == MASTER2)
    if (Channel1->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel1->SrcPeriph) +2];

  /* Compare Channel 1 Destination Master for Master2. If Channel 1 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel1->DestMaster == MASTER2)
    if (Channel1->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel1->DestPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel2->SrcMaster == MASTER2)
    if (Channel2->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel2->SrcPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel2->DestMaster == MASTER2)
    if (Channel2->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                         PeriphMasterSel[(Channel2->DestPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel3->SrcMaster == MASTER2)
    if (Channel3->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel3->SrcPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel3->DestMaster == MASTER2)
    if (Channel3->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel3->DestPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel4->SrcMaster == MASTER2)
    if (Channel4->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel4->SrcPeriph) +2];

  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */ 
  if (Channel4->DestMaster == MASTER2)
    if (Channel4->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel4->DestPeriph) +2];

  Write(DMACREQCONFIG, TempPerpMaster);

}

/******************************************************************************/
/********************* DMACREQCONFIG Register Programming *********************/
/******************************************************************************/
void ReqRegConfig8 (struct EightChTotalCases *ChReqPara)
{
 /*
   Summary : ReqRegConfig8   
   =======================
   This function  program DMACREQCONFIG register. This function is called in
   Eight channel test cases. The control information of all 8 Channels are
   passed as function argument. The DMACREQCONFIG register indicates that given
   Memory/Peripheral module is configured to Master 1 or Master 2. If Memory/
   Peripheral module is configured to Master 2 then Memory/Peripheral bit is set
   in DMACREQCONFIG register. The function extracts all Eight channel control
   information. The function compares First Channel Source AHB Master for
   Master 2. If First Channel Source Master is Master2 then it sets Source
   Peripheral bit in DMACREQCONFIG register. It compares Destination Master for
   Master 2. If First Channel Destination Master is Master 2 then it sets
   Memory/Peripheral bit in DMACREQCONFIG register. For the programming of
   DMACREQCONFIG register, TempPerpMaster variable is used. It indicates
   peripheral to be connected to Master 2. The above procedure is repeated for
   remained Seven channels chaneel. 
 */
  int32 TempPerpMaster = 0x00000000;
  
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->EightChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->EightChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->EightChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->EightChData->FourthChannel;
  struct ChannelPara *Channel5 = ChReqPara->EightChData->FifthChannel;
  struct ChannelPara *Channel6 = ChReqPara->EightChData->SixthChannel;
  struct ChannelPara *Channel7 = ChReqPara->EightChData->SeventhChannel;
  struct ChannelPara *Channel8 = ChReqPara->EightChData->EighthChannel;

  msg_info("Programming DMACREQCONFIG Register");
  
  /* Compare Channel 1 Source Master for Master2. If Channel 1 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel1->SrcMaster == MASTER2)
    if (Channel1->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel1->SrcPeriph) +2];

  /* Compare Channel 1 Destination Master for Master2. If Channel 1 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel1->DestMaster == MASTER2)
    if (Channel1->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel1->DestPeriph) +2];

  /* Compare Channel 2 Source Master for Master2. If Channel 2 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel2->SrcMaster == MASTER2)
    if (Channel2->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel2->SrcPeriph) +2];
  /* Compare Channel 2 Destination Master for Master2. If Channel 2 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
 if (Channel2->DestMaster == MASTER2)
    if (Channel2->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                         PeriphMasterSel[(Channel2->DestPeriph) +2];

  /* Compare Channel 3 Source Master for Master2. If Channel 3 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel3->SrcMaster == MASTER2)
    if (Channel3->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel3->SrcPeriph) +2];

  /* Compare Channel 3 Destination Master for Master2. If Channel 3 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel3->DestMaster == MASTER2)
    if (Channel3->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel3->DestPeriph) +2];

  /* Compare Channel 4 Source Master for Master2. If Channel 4 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel4->SrcMaster == MASTER2)
    if (Channel4->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel4->SrcPeriph) +2];

  /* Compare Channel 4 Destination Master for Master2. If Channel 4 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel4->DestMaster == MASTER2)
    if (Channel4->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel4->DestPeriph) +2];

  /* Compare Channel 5 Source Master for Master2. If Channel 5 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel5->SrcMaster == MASTER2)
    if (Channel5->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel5->SrcPeriph) +2];

  /* Compare Channel 5 Destination Master for Master2. If Channel 5 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel5->DestMaster == MASTER2)
    if (Channel5->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel5->DestPeriph) +2];

  /* Compare Channel 6 Source Master for Master2. If Channel 6 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel6->SrcMaster == MASTER2)
    if (Channel6->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel6->SrcPeriph) +2];

  /* Compare Channel 6 Destination Master for Master2. If Channel 6 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel6->DestMaster == MASTER2)
    if (Channel6->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel6->DestPeriph) +2];

  /* Compare Channel 7 Source Master for Master2. If Channel 7 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel7->SrcMaster == MASTER2)
    if (Channel3->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel7->SrcPeriph) +2];
  /* Compare Channel 7 Destination Master for Master2. If Channel 7 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */

  if (Channel7->DestMaster == MASTER2)
    if (Channel3->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel7->DestPeriph) +2];

  /* Compare Channel 8 Source Master for Master2. If Channel 8 Source Master is
     Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel8->SrcMaster == MASTER2)
    if (Channel4->SrcPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel8->SrcPeriph) +2];

  /* Compare Channel 8 Destination Master for Master2. If Channel 8 Destination
     Master is Master2, set Memory/Peripheral bit in TempPerpMaster variable */
  if (Channel8->DestMaster == MASTER2)
    if (Channel4->DestPeriph == NA)
      TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
    else
      TempPerpMaster = TempPerpMaster |
                       PeriphMasterSel[(Channel8->DestPeriph) +2]; 

  Write(DMACREQCONFIG, TempPerpMaster);
}

/******************************************************************************/
/********************* DMACCxConfig Register Programming **********************/
/******************************************************************************/
void ConfigRegPrgm4 (struct FourChTotalCases *ChConfigRegPara)
{
 /*
   Summary : ConfigRegPrgm4
   ========================
   This function programs DMACCxConfig registers. This function is called in
   Four channel test cases. The function extracts all channel control
   information. It evaluates Config register data for all channel. The function 
   programs channel indicated by WhichChEnableFirst and then it programs
   remaining three DMACxConfig registers.
 */
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChConfigRegPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChConfigRegPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChConfigRegPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChConfigRegPara->FourChData->FourthChannel;
  
  int32 C1ConfigData, C2ConfigData, C3ConfigData, C4ConfigData;
  int32 SrcPeriphValue, DestPeriphValue;
  int32 *RegAddr;
  char Message[100]; 

  /* Determine Source Memory/Peripheral value of First Channel*/
  if (Channel1->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel1->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of First Channel*/
  if (Channel1->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel1->DestPeriph);

  /* Evaluate First Channel Config register Data. */ 
  C1ConfigData =
                 SrcPeriphValue                 |
                 DestPeriphValue                |
                 Channel1->FlowControl          |
                 Channel1->ChLOCK               |
                 Channel1->HALT                 |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Second Channel*/
  if (Channel2->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel2->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Second Channel*/
  if (Channel2->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel2->DestPeriph);

  /* Evaluate Second Channel Config register Data. */ 
  C2ConfigData =
                 SrcPeriphValue                 |
                 DestPeriphValue                |
                 Channel2->FlowControl          |
                 Channel2->ChLOCK               |
                 Channel2->HALT                 |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Third Channel*/
  if (Channel3->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel3->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Third Channel*/
  if (Channel3->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel3->DestPeriph);

  /* Evaluate Third Channel Config register Data. */ 
  C3ConfigData =
                 SrcPeriphValue                 |
                 DestPeriphValue                |
                 Channel3->FlowControl          |
                 Channel3->ChLOCK               |
                 Channel3->HALT                 |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Fourth Channel*/
  if (Channel4->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel4->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Fourth Channel*/
  if (Channel4->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel4->DestPeriph);

  /* Evaluate Fourth Channel Config register Data. */ 
  C4ConfigData =
                 SrcPeriphValue                 |
                 DestPeriphValue                |
                 Channel4->FlowControl          |
                 Channel4->ChLOCK               |
                 Channel4->HALT                 |
                 CHXENABLE;


  sprintf (Message,"Programming DMAC%dConfig, DMAC%dConfig, DMAC%dConfig and "
                   " DMAC%dConfig register",
                    Channel1->Channel,  
                    Channel2->Channel,  
                    Channel3->Channel,  
                    Channel4->Channel);
  msg_info(Message);  

  /* Programm Channel indicated by WhichChEnableFirst and then enable remaining
     three channel */ 
  if (ChConfigRegPara->FourChData->WhichChEnableFirst == Channel1->Channel)
  {
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
  }
  else if (ChConfigRegPara->FourChData->WhichChEnableFirst ==
                                                   Channel2->Channel)
  {
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
  }
  else if (ChConfigRegPara->FourChData->WhichChEnableFirst == 
                                                   Channel3->Channel)
  {
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
  }
  else if (ChConfigRegPara->FourChData->WhichChEnableFirst ==
                                                   Channel4->Channel)
  {
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
  }
}

/******************************************************************************/
/********************* DMACCxConfig Register Programming **********************/
/******************************************************************************/
void ConfigRegPrgm8 (struct EightChTotalCases *ChConfigRegPara)
{
 /*
   Summary : ConfigRegPrgm8
   ========================
   This function programs DMACCxConfig registers. This function is called in
   Eight channel test cases. The function extracts all channel control
   information. It evaluates Config register data for all channel. The function
   programs channel indicated by WhichChEnableFirst and then it programs
   remaining Seven DMACxConfig registers.   
 */

  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChConfigRegPara->EightChData->FirstChannel;
  struct ChannelPara *Channel2 = ChConfigRegPara->EightChData->SecondChannel;
  struct ChannelPara *Channel3 = ChConfigRegPara->EightChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChConfigRegPara->EightChData->FourthChannel;
  struct ChannelPara *Channel5 = ChConfigRegPara->EightChData->FifthChannel;
  struct ChannelPara *Channel6 = ChConfigRegPara->EightChData->SixthChannel;
  struct ChannelPara *Channel7 = ChConfigRegPara->EightChData->SeventhChannel;
  struct ChannelPara *Channel8 = ChConfigRegPara->EightChData->EighthChannel;

  int32 C1ConfigData = 0x0, C2ConfigData = 0x0, C3ConfigData = 0x0,
        C4ConfigData = 0x0, C5ConfigData = 0x0, C6ConfigData = 0x0,
        C7ConfigData = 0x0, C8ConfigData = 0x0;
  int32 SrcPeriphValue, DestPeriphValue;
  int32 *RegAddr;
  char Message[100];

  /* Determine Source Memory/Peripheral value of First Channel */
  if (Channel1->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel1->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of First Channel */
  if (Channel1->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel1->DestPeriph);
 
  /* Evaluate First Channel Config register Data. */
  C1ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel1->FlowControl |
                 Channel1->ChLOCK      |
                 Channel1->HALT        |
                 CHXENABLE;
 
  /* Determine Source Memory/Peripheral value of Second Channel */
  if (Channel2->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel2->SrcPeriph);
 
  /* Determine Destination Memory/Peripheral value of Second Channel */
  if (Channel2->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel2->DestPeriph);
 
  /* Evaluate Second Channel Config register Data. */
  C2ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel2->FlowControl |
                 Channel2->ChLOCK      |
                 Channel2->HALT        |
                 CHXENABLE;
 
  /* Determine Source Memory/Peripheral value of Third Channel */
  if (Channel3->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel3->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Third Channel */
  if (Channel3->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel3->DestPeriph);

  /* Evaluate Third Channel Config register Data. */
  C3ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel3->FlowControl |
                 Channel3->ChLOCK      |
                 Channel3->HALT        |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Fourth Channel */
  if (Channel4->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel4->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Fourth Channel */
  if (Channel4->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel4->DestPeriph);

  /* Evaluate Fourth Channel Config register Data. */
  C4ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel4->FlowControl |
                 Channel4->ChLOCK      |
                 Channel4->HALT        |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Five Channel */
  if (Channel5->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel5->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Five Channel */
  if (Channel5->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel5->DestPeriph);

  /* Evaluate Five Channel Config register Data. */
  C5ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel5->FlowControl |
                 Channel5->ChLOCK      |
                 Channel5->HALT        |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Sixth Channel */
  if (Channel6->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel6->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Sixth Channel */
  if (Channel6->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel6->DestPeriph);

  /* Evaluate Sixth Channel Config register Data. */
  C6ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel6->FlowControl |
                 Channel6->ChLOCK      |
                 Channel6->HALT        |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Seventh Channel */
  if (Channel7->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel7->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Seventh Channel */
  if (Channel7->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel7->DestPeriph);

  /* Evaluate Seventh Channel Config register Data. */
  C7ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel7->FlowControl |
                 Channel7->ChLOCK      |
                 Channel7->HALT        |
                 CHXENABLE;

  /* Determine Source Memory/Peripheral value of Eighth Channel */
  if (Channel8->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel8->SrcPeriph);

  /* Determine Destination Memory/Peripheral value of Eighth Channel */
  if (Channel8->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel8->DestPeriph);

  /* Evaluate Eighth Channel Config register Data. */
  C8ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel8->FlowControl |
                 Channel8->ChLOCK      |
                 Channel8->HALT        |
                 CHXENABLE;
  /* Programm Channel indicated by WhichChEnableFirst and then enable remaining
     three channel */

  if (ChConfigRegPara->EightChData->WhichChEnableFirst == Channel1->Channel)
  {
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
  else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel2->Channel)
  {
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
  else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel3->Channel)
  {
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
 else if (ChConfigRegPara->EightChData->WhichChEnableFirst == Channel4->Channel)
  {
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
 else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel5->Channel)
  {
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
 else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel6->Channel)
  {
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
 else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel7->Channel)
  {
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
  }
 else if (ChConfigRegPara->EightChData->WhichChEnableFirst ==
                                                   Channel8->Channel)
  {
    RegAddr = ChannelRegisters(Channel8->Channel);
    Write (*RegAddr + 0x00000010, C8ConfigData);
    RegAddr = ChannelRegisters(Channel1->Channel);
    Write (*RegAddr + 0x00000010, C1ConfigData);
    RegAddr = ChannelRegisters(Channel2->Channel);
    Write (*RegAddr + 0x00000010, C2ConfigData);
    RegAddr = ChannelRegisters(Channel3->Channel);
    Write (*RegAddr + 0x00000010, C3ConfigData);
    RegAddr = ChannelRegisters(Channel4->Channel);
    Write (*RegAddr + 0x00000010, C4ConfigData);
    RegAddr = ChannelRegisters(Channel5->Channel);
    Write (*RegAddr + 0x00000010, C5ConfigData);
    RegAddr = ChannelRegisters(Channel6->Channel);
    Write (*RegAddr + 0x00000010, C6ConfigData);
    RegAddr = ChannelRegisters(Channel7->Channel);
    Write (*RegAddr + 0x00000010, C7ConfigData);
  }
}

/******************************************************************************/
/********************* Four Channel Test Case No 1 ****************************/
/******************************************************************************/
void FourChTest1(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : FourChTest1   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 1 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.   
 */

  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Second Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
           "Peripheral %d ", Channel2->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

 /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of 
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     of Second Channel going low  */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);
  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Four Channel Test Case No 2 ****************************/
/******************************************************************************/
void FourChTest2(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : FourChTest2   
   =====================
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 2 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.   
 */
 
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming Fourth Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel4->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Fourth Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel4->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

 /* Programming Fourth Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
                  " Peripheral %d ", Channel4->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Fourth Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel4->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Second Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                        Channel2->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel2->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
                  " Peripheral %d ", Channel3->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel3->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Fourth Channel going low */
  MaskValue = ReqExpValue[Channel4->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Programming Second Channel Destination DMA Request*/
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
                  " Peripheral %d ", Channel2->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Second Channel going low */
  MaskValue = ReqExpValue[Channel2->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination 
     Peripheral of Second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination 
     Peripheral of Third Channel going low */
  MaskValue = ReqExpValue[Channel3->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination 
     Peripheral of Fourth Channel going low */
  MaskValue = ReqExpValue[Channel4->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);
  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Four Channel Test Case No 4 ****************************/
/******************************************************************************/
void FourChTest4(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : FourChTest4   
   =====================
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 1 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */
 
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming First Channel Source DMA Request*/
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);
 
  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Programming Second Channel Destination DMA Request*/
  sprintf(Message,"Programming DMA Last Burst Request of Destination 
                   Peripheral %d ", Channel2->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     Of second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);
  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Four Channel Test Case No 5 ****************************/
/******************************************************************************/
void FourChTest5(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : FourChTest5   
   =====================
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 5 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */
  /* Extract Channel information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100]; 

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel3->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel3->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling Channel Enable bit of Channel 6 */
  Poll(ConfigRegs[6], 0x00000000, CHXENABLE);
  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);
  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);

}

/******************************************************************************/
/********************* Four Channel Test Case No 6 ****************************/
/******************************************************************************/
void FourChTest6(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 6 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */

  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming Fourth Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel4->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Fourth Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel4->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Fourth Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
                  " Peripheral %d ", Channel4->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Fourth Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel4->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                        Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Second Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel2->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel2->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination "
                  " Peripheral %d ", Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination "
                  " Peripheral %d ", Channel3->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel3->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Fourth Channel going low */
  MaskValue = ReqExpValue[Channel4->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Programming Second Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
                  " Peripheral %d ", Channel2->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Second Channel going low */
  MaskValue = ReqExpValue[Channel2->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination
     Peripheral of Second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination
     Peripheral of Third Channel going low */
  MaskValue = ReqExpValue[Channel3->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination
     Peripheral of Fourth Channel going low */
  MaskValue = ReqExpValue[Channel4->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);
  WaitLoop(1);

  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Four Channel Test Case No 6 ****************************/
/******************************************************************************/
void FourChTest7(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function tests Halt functionality of DMAC in Multi-Channel case. This
   function is called of Four Channel test No 7. The function waits till first
   channel data transfer gets over. It polls First Channel enable bit going low.
   Once Second channel starts data transfer, it Halts Second Channel by Setting
   Halt bit. The function waits till all data transfer of remaining channel is
   gets over. The function clears Halt bit of Second channel and waits for DMAC
   to finnish remaining AHB transaction of Second channel. It polls Channel
   Enable bit of Second Channel going low.
 */
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  int32 *RegAddr, C2ConfigData;
  int32 SrcPeriphValue, DestPeriphValue;
  char  Message[100];

  /* Polling Channel Enable bit of First Channel  */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel1->Channel], 0x00000000, MaskValue);

  /* Halting Second Channel by setting Halt bit of Second Channel */ 
  msg_info("Halting Second Channel");
  if (Channel2->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel2->SrcPeriph);

  if (Channel2->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel2->DestPeriph);

  C2ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel2->FlowControl |
                 Channel2->ChLOCK      |
                 DMACHALT              |
                 CHXENABLE;

  /* Determine register base address of Second Channel */ 
  RegAddr = ChannelRegisters(Channel2->Channel);
  Write (*RegAddr + 0x00000010, C2ConfigData); 

  MaskValue  = 0x00000001;
  /* Polling Channel Enable bit of Channel 5 */
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);

  /* Clearing Halt bit of Second Channel */
  C2ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel2->FlowControl |
                 Channel2->ChLOCK      |
                 CHXENABLE;


  /* Determine register base address of Second Channel */ 
  RegAddr = ChannelRegisters(Channel2->Channel);
  Write (*RegAddr + 0x00000010, C2ConfigData);

  WaitLoop(10);
  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  /* Polling Channel Enable bit of Second Channel 5 */
  MaskValue  = 0x00000001;
  Poll(ConfigRegs[Channel2->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Four Channel Test Case No 8 ****************************/
/******************************************************************************/
void FourChTest8(struct FourChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Four Channel test No 8 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */
  struct ChannelPara *Channel1 = ChReqPara->FourChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->FourChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->FourChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->FourChData->FourthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming First Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Single Request of Source "
                  " Peripheral %d ", Channel1->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00020000);

  /* Programming First Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
                   Channel1->DestPeriph);
  msg_info(Message);
  /* Determine register base address of First Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Second Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel2->DestPeriph);
  msg_info(Message);
  /* Determine register base address of Second Channel Destination Peripheral */
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source "
                  " Peripheral %d ", Channel3->SrcPeriph);
  msg_info(Message);
  /* Determine register base address of Third Channel Source Peripheral */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftLSReq Register to check DMALSREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLSReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     of Second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);
  WaitLoop(1);

  /* Determine expected mask value and Poll Channel Enable bit of Channel 4
     going Low */
  MaskValue = 0x00000001;
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Eight Channel Test Case No 1 ***************************/
/******************************************************************************/
void EightChTest1 (struct EightChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Eight Channel test No 1 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->EightChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->EightChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->EightChData->ThirdChannel;
  struct ChannelPara *Channel5 = ChReqPara->EightChData->FifthChannel;
  struct ChannelPara *Channel6 = ChReqPara->EightChData->SixthChannel;
  struct ChannelPara *Channel7 = ChReqPara->EightChData->SeventhChannel;
  struct ChannelPara *Channel8 = ChReqPara->EightChData->EighthChannel;

  int32 Addr, MaskValue;
  char  Message[100]; 

  /* Programming First Channel Source DMA Requests */
  sprintf(Message,"Programming DMA Last Single Request of Source"
                  "Peripheral %d ", Channel1->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00020000);

  /* Programming First Channel Destination DMA Requests */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel1->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Fifth Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
           "Peripheral %d ", Channel5->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Fifth Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel5->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Seventh Channel Source DMA Requests */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                        Channel7->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel7->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

 /* Programming Second Channel Destination DMA Requests */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel2->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Sixth Channel Destination DMA Requests */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel6->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel6->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftLSReq Register to check DMALSREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLSReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Second Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue); 

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     of Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Sixth Channel going low */
  MaskValue = ReqExpValue[Channel6->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Seventh Channel going low */
  MaskValue = ReqExpValue[Channel7->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  MaskValue = 0x00000001;
  WaitLoop(1);
  Poll(ConfigRegs[Channel8->Channel], 0x00000000, MaskValue);
  WaitLoop(10);
}

/******************************************************************************/
/********************* Eight Channel Test Case No 4 ***************************/
/******************************************************************************/
void EightChTest4 (struct EightChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Eight Channel test No 4 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA requests.
 */
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->EightChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->EightChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->EightChData->ThirdChannel;
  struct ChannelPara *Channel4 = ChReqPara->EightChData->FourthChannel;
  struct ChannelPara *Channel5 = ChReqPara->EightChData->FifthChannel;
  struct ChannelPara *Channel6 = ChReqPara->EightChData->SixthChannel;
  struct ChannelPara *Channel7 = ChReqPara->EightChData->SeventhChannel;
  struct ChannelPara *Channel8 = ChReqPara->EightChData->EighthChannel;

  int32 Addr, MaskValue;
  int32 *RegAddr, C5ConfigData;
  int32 SrcPeriphValue, DestPeriphValue;
  char  Message[100];

  /* Programming First Channel Source DMA Requests */
  sprintf(Message,"Programming DMA Last Single Request of Source"
                  "Peripheral %d ", Channel1->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00020000);

  /* Programming First Channel Destination DMA Requests */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel1->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

 /* Programming Fifth Channel Destination DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
           "Peripheral %d ", Channel5->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Fifth Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel5->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Seventh Channel Source DMA Requests */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel7->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel7->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Second Channel Destination DMA Requests*/
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel2->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Sixth Channel Destination DMA Requests */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel6->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel6->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftLSReq Register to check DMALSREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLSReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Second Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  /* Verify Fourth Channel completes Data transfer and Fifth Channel starts
     Data transfer */
  MaskValue = 0x00000001;
  WaitLoop(1);
  Poll(ConfigRegs[Channel4->Channel], 0x00000000, MaskValue);
  WaitLoop(2);

  msg_info("Halting Fifth Channel");
  if (Channel5->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel5->SrcPeriph);

  if (Channel5->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel5->DestPeriph);

  C5ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel5->FlowControl |
                 Channel5->ChLOCK      |
                 DMACHALT              |
                 CHXENABLE;

  RegAddr = ChannelRegisters(Channel5->Channel);
  Write (*RegAddr + 0x00000010, C5ConfigData);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Sixth Channel going low */
  MaskValue = ReqExpValue[Channel6->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Seventh Channel going low */
  MaskValue = ReqExpValue[Channel7->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);
  
  /* Wait till 8th Channel Perform Source and Destination Data Transfer */
  MaskValue = 0x00000001;
  WaitLoop(1);
  Poll(ConfigRegs[Channel8->Channel], 0x00000000, MaskValue);

  msg_info("Clearing Halt Bit Of Channel5 ");

  if (Channel5->SrcPeriph == NA)
    SrcPeriphValue = 0x00000000;
  else
    SrcPeriphValue = SpValue(Channel5->SrcPeriph);

  if (Channel5->DestPeriph == NA)
    DestPeriphValue = 0x00000000;
  else
    DestPeriphValue = DpValue(Channel5->DestPeriph);

  C5ConfigData =
                 SrcPeriphValue        |
                 DestPeriphValue       |
                 Channel5->FlowControl |
                 Channel5->ChLOCK      |
                 CHXENABLE;

  RegAddr = ChannelRegisters(Channel5->Channel);
  Write (*RegAddr + 0x00000010, C5ConfigData);
  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
    Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     of Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->DestPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);
     
  MaskValue = 0x00000001;
  WaitLoop(1);
  Poll(ConfigRegs[Channel5->Channel], 0x00000000, MaskValue);
  WaitLoop(5);

  /* Assert PeriphRest of Src Peripheral  of Channel 3 */
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr, MEMORYRESET);
  /* Clear Periph Reset Bit of Source Peripheral of Channel 3 */ 
  Write(Addr, MEMORYRSTCLR);
}

/******************************************************************************/
/********************* Eight Channel Test Case No 5 ***************************/
/******************************************************************************/
void EightChTest5 (struct EightChTotalCases *ChReqPara)
{
 /*
   Summary : ChannelPrgm   
   =====================   
   This function  programs DMAC Requests. This function programs peripherals
   of Eight Channel test No 5 and polls respective requests going low.
   This function calls SlaveAddrSelection function to determine register base
   address of peripheral for the programming of DMA request.
 */
  /* Extract Channel Information */
  struct ChannelPara *Channel1 = ChReqPara->EightChData->FirstChannel;
  struct ChannelPara *Channel2 = ChReqPara->EightChData->SecondChannel;
  struct ChannelPara *Channel3 = ChReqPara->EightChData->ThirdChannel;
  struct ChannelPara *Channel5 = ChReqPara->EightChData->FifthChannel;
  struct ChannelPara *Channel6 = ChReqPara->EightChData->SixthChannel;
  struct ChannelPara *Channel7 = ChReqPara->EightChData->SeventhChannel;
  struct ChannelPara *Channel8 = ChReqPara->EightChData->EighthChannel;

  int32 Addr, MaskValue;
  char  Message[100];

  /* Programming First Channel Source DMA request */
  sprintf(Message,"Programming DMA Last Single Request of Source"
                  "Peripheral %d ", Channel1->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->SrcPeriph);
  Write(Addr + 0x00000008, 0x00020000);

  /* Programming First Channel Destination DMA request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel1->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel1->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Fifth Channel Destination DMA request */
  sprintf(Message,"Programming DMA Last Burst Request of Destination "
           "Peripheral %d ", Channel5->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->DestPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Fifth Channel Source DMA Request */
  sprintf(Message,"Programming DMA Burst Request of Source Peripheral %d ",
                   Channel5->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel5->SrcPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel3->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Seventh Channel Source DMA request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                   Channel7->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel7->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Programming Second Channel Destination DMA request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel2->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Programming Sixth Channel Destination DMA request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel6->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel6->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftLSReq Register to check DMALSREQ of Source Peripheral of
     First Channel going low */
  MaskValue = ReqExpValue[Channel1->SrcPeriph];
  Poll(DMACSoftLSReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of First Channel going low */
  MaskValue = ReqExpValue[Channel1->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  /* Wait to LLI to get loaded and Second Channel starts Data Transfer */
  WaitLoop(5);

  /* Programming Second Channel Destination DMA request */
  sprintf(Message,"Programming DMA Burst Request of Destination Peripheral %d ",
          Channel2->DestPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel2->DestPeriph);
  Write(Addr + 0x00000008, 0x00000200);

  /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
    of Second Channel going low */
  MaskValue = ReqExpValue[Channel2->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  /* Wait For LLI Load */
  WaitLoop(8);

  /* Programming Third Channel Source DMA Request */
  sprintf(Message,"Programming DMA Last Burst Request of Source Peripheral %d ",
                        Channel3->SrcPeriph);
  msg_info(Message);
  Addr = SlaveAddrSelection(Channel3->SrcPeriph);
  Write(Addr + 0x00000008, 0x02000000);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Third Channel going low */
  MaskValue = ReqExpValue[Channel3->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftBReq Register to check DMABREQ of Source Peripheral of
     Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->SrcPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Destination Peripheral
     of Fifth Channel going low */
  MaskValue = ReqExpValue[Channel5->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  WaitLoop(1);

   /* Polling DMACSoftBReq Register to check DMABREQ of Destination Peripheral
     of Sixth Channel going low */
  MaskValue = ReqExpValue[Channel6->DestPeriph];
  Poll(DMACSoftBReq, 0x0, MaskValue);

  WaitLoop(1);

  /* Polling DMACSoftLBReq Register to check DMALBREQ of Source Peripheral of
     Seventh Channel going low */
  MaskValue = ReqExpValue[Channel7->SrcPeriph];
  Poll(DMACSoftLBReq, 0x0, MaskValue);

  MaskValue = 0x00000001;
  WaitLoop(1);
  Poll(ConfigRegs[Channel8->Channel], 0x00000000, MaskValue);
  WaitLoop(5);
}
/*********************************** End **************************************/
