// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : CLTrCLCDIf.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Purpose : CLCD Trickbox CLCD Master AHB Port Interface
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module CLTrCLCDIf (
             HCLK,
             HRESETN,
             HADDR,
             HTRANS,
             HWRITE,
             HSIZE,
             HBURST,
             HRDATA,
             HREADY,
             HPROT,
             HLOCK,
             HRESP,
             HBUSREQ,
             HGRANT,
             CLTrEn,
             CLTrUPBASE,
             CLTrLPBASE,
             CLTrError,
             CLTrGrant,
             CLTrRand,
             CLTrPanel,
             Dual,
             PPL,
             LPP,
             BPP,
             DataAvail,
             SlaveState,
             ResetWritePtrs,
             CLTrBaseUpdate
            );
 
input             HCLK;           // AHB Bus Clock
input             HRESETN;        // AHB Reset
input  [31:0]     HADDR;          // AHB Address Bus
input  [1:0]      HTRANS;         // AHB Transfer Type
input             HWRITE;         // AHB Transfer Direction
input  [2:0]      HSIZE;          // AHB Transfer Size
input  [2:0]      HBURST;         // AHB Burst Type
output            HREADY;         // AHB Transfer Done
input  [3:0]      HPROT;          // AHB Protection Signal
input             HLOCK;          // AHB Lock mode
output [31:0]     HRDATA;         // AHB Read  Data Bus
input             HBUSREQ;        // AHB Bus Request from CLCD Master
output [1:0]      HRESP;          // AHB Transfer Response
output            HGRANT;         // AHB Bus Grant for CLCD Master
input             CLTrEn;         // CLCD Trickbox Enable
input  [31:0]     CLTrUPBASE;     // CLCD Data Base Address for Upper Panel 
input  [31:0]     CLTrLPBASE;     // CLCD Data Base Address for Lower Panel 
input             CLTrError;      // CLCD Trickbox ERROR Response bit
input             CLTrGrant;      // CLCD Trickbox Grant Control
input             CLTrRand;       // CLCD Trickbox responce Control
output            CLTrPanel;      // Indicates active panel
input             Dual;           // CLCD Dual Panel Mode Bit
input  [5:0]      PPL;            // Pixel Per Line
input  [9:0]      LPP;            // Line Per Panel
input  [2:0]      BPP;            // Bits per pixel
output            DataAvail;      // Indicate that Master is sampling data
output [2:0]      SlaveState;     // Slave condition to Reg Block for CLTrError
input             CLTrBaseUpdate; // CLCD Trickbox Base Update Request Signal
output            ResetWritePtrs; // Signal to reset the write pointers for datacheck

// -----------------------------------------------------------------------------
//                             CLTrCLCDIf
//                             ==========
// -----------------------------------------------------------------------------
// Overview:
// ========
// This module is to interface with CLCD Master Port. This module includes:
// - Image Uploading mechanism
// - Latching block of Address and Control Signals
// - Slave State Generation State m/c
// - Arbiter block
// - Data Generation block
// - HREADY, HRESP and DataAvail Signal generation block
// - AHB bus signal protocol checking
// - AHB Address Checking Block
// - CLTrPanel & DataAvail Signal Generation Blocks 
//
// Note: Two variable `define s are there:
// ----  o EXIT  : Indicates what to do on ERROR : Exit or Continue
//       o IMAGE : Indicates Image or random testing
// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
// Slave Response state m/c states (not HRESP) 
// -------------------------------------------
// Encoding of Slave State values are done in such a way that, 
// HRESP = SlaveState[1:0].
`define  S_OKAY      3'b000         // Slave can provide data
`define  S_BUSY      3'b100         // Slave is busy to prepare data
`define  S_RETRY     3'b010         // Slave gives a RETRY response
`define  S_SPLIT     3'b011         // Slave gives a SPLIT response
`define  S_ERROR     3'b101         // Slave gives a ERROR response

// Wait Numbers
// ------------
`define  SPLITNO     RandomReg[21:19]   
// Number of HCLKs for which Grant will be removed after a SPLIT response
`define  WaitNo      RandomReg[7:5]
// Number of HCLKs for which slave is busy to prepare data the master is 
// requesting for. After that the slave may provide it to the master with an
// OKAY response or may give RETRY or SPLIT response.

// What to do on ERROR : Exit or Continue
// --------------------------------------
`ifdef EXIT
  `define ERR_EXIT   $finish
`else
  `define ERR_EXIT   $display("Error Exit\n")
`endif

// -----------------------------------------------------------------------------
// Reg declarations
// -----------------------------------------------------------------------------
wire              HCLK;           // (module input)
wire              HRESETN;        // (module input)
wire   [31:0]     HADDR;          // (module input)
wire   [1:0]      HTRANS;         // (module input)
wire              HWRITE;         // (module input)
wire   [2:0]      HSIZE;          // (module input)
wire   [2:0]      HBURST;         // (module input)
wire   [3:0]      HPROT;          // (module input)
wire              HLOCK;          // (module input)
wire              HBUSREQ;        // (module input)
wire   [1:0]      HRESP;          // (module output)
wire              CLTrEn;         // (module input)
wire   [31:0]     CLTrUPBASE;     // (module input)
wire   [31:0]     CLTrLPBASE;     // (module input)
wire              CLTrError;      // (module input)
wire              Dual;           // (module input)
wire   [5:0]      PPL;            // (module input)
wire   [9:0]      LPP;            // (module input)
wire   [2:0]      BPP;            // (module input)
wire              CLTrGrant;      // (module input)
wire              CLTrRand;       // (module input)
wire              DataAvail;      // (module output)
wire              CLTrBaseUpdate; // (module input)
wire              ResetWritePtrs; // (module output)

wire   [31:0]     ADDWindow;      // CLCD Address Window

// -----------------------------------------------------------------------------
// Reg declarations
// -----------------------------------------------------------------------------
 
// Internal versions of Address & Control Signals.
// -----------------------------------------------
reg     [31:0]    iHADDR;
reg     [1:0]     iHTRANS;
reg               iHWRITE;
reg     [2:0]     iHSIZE;
reg     [2:0]     iHBURST;
reg     [3:0]     iHPROT;
 
// Internal Registers
// ------------------
reg [31:0]     HRDATA;         
// AHB Read  Data Bus

reg            HREADY;
// HREADY Out pin for CLCD Master Port

reg            HGRANT;
// HGRANT Signal from built-in Arbiter

reg [2:0]      SlaveState;
// Slave condition

reg [2:0]      randomno;
// To hold Random No

reg [31:0]    RandomReg;
// Shift Register to generate Random No

reg            Wait1;
// To indicate that Retry / Split Response 1st phase 

reg [31:0]     UPADD;
// CLCD Upper Panel Address

reg [31:0]     LPADD;
// CLCD Lower Panel Address

reg [31:0]     NextUPADD;
// D Input to UPADD

reg [31:0]     NextLPADD;
// D Input to LPADD

reg            iBaseUpdate;
// Clocked version of CLTrBaseUpdate

reg [3:0]      BPPValue;
// Actual BPP value

reg            CLTrPanel;
// Panel Indicating Signal
//  0 : Data corresponds to CLCD Upper Panel
//  1 : Data corresponds to CLCD Lower Panel
//  0 : In Single Panel mode or Idle/Wait State

`ifdef IMAGE
reg [393215:0]   ImageMem[31:0];
// Memory for Image Data : To be loaded from file : Image.dat
`endif

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Random Generator:
// ----------------
// One 32 bit Shift Register, RandomReg is shifted by one bit every time the 
// function is called. The input bit serial bit is XOR of some bits of 
// RandomReg.
// -----------------------------------------------------------------------------
task    Randomaize;
reg     LSBit;
begin
  LSBit     = RandomReg[0] ^ RandomReg[3] ^ RandomReg[5] ^ RandomReg[24];
  RandomReg = (RandomReg << 1) | {31'b0,LSBit};
end
endtask

// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Image Memory Upload from File : Image.dat
// -----------------------------------------------------------------------------
`ifdef IMAGE
initial
begin : p_ImageLoad
  // Loading Image data from file Image.dat to Memory ImageMem
  $readmemh("Image.dat",ImageMem);
end
`endif

// -----------------------------------------------------------------------------
// Latching of Address & Control Signals.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETN)
begin : p_LatchSeq
  if (!HRESETN)
    begin
      iHADDR    <= 32'b0;
      iHTRANS   <= 2'b0;
      iHWRITE   <= 1'b0;
      iHSIZE    <= 3'b010;
      iHBURST   <= 3'b0;
      iHPROT    <= 4'b0001;
    end
  else
    begin
      if (HREADY)
        begin
          iHADDR    <= HADDR;
          iHTRANS   <= HTRANS;
          iHWRITE   <= HWRITE;
          iHSIZE    <= HSIZE;
          iHBURST   <= HBURST;
          iHPROT    <= HPROT;
        end
    end
end
 
// -----------------------------------------------------------------------------
// Slave State Generation:
// ----------------------
// It denotes the state of slave on which HREADY and HRESP signals will be 
// generated. For generating the RETRY, SPLIT and Wait State randomly, a
// random no. is generated that may vary from 0, 1, 2, ... 7. To increase the
// probability of OKAY State compared to RETRY, SPLIT and Busy State, the states
// will be mapped on the random numbers as follows:
//   Random number            State
//   -------------            -----
//   0, 1, ... 4              OKAY
//        5                   RETRY
//        6                   SPLIT
//        7                   BUSY
// Note: ERROR State will come in an deterministic manner depending on CLTrERROR
// bit. And BUSY state denotes that Slave is busy in processing and will be     
// indicated by setting the HREADY low.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETN)
begin : p_SlaveState
  if (!HRESETN)
    begin
      // Default Slave State
      SlaveState = `S_OKAY;
      Wait1      = 1'b0;
      // Initialize the Shift Register in Randomaize function
      RandomReg  = 32'b101010000;
    end
  else
    begin
      `ifdef IMAGE
         // If IMAGE option is set, we should not invoke random responses.
         randomno = 3'b0;
      `else
         // Update RandomReg by a new random number
         Randomaize;
         if (CLTrRand) 
           randomno = RandomReg[2:0];  
         else
           randomno = 3'b0; 
      `endif

      // If Wait1 = 1 it will extend the Slave state by one HCLK
      if (Wait1)
        Wait1 = 1'b0;
      else if (CLTrError && HTRANS[1] && HGRANT) // Not iHTRANS[1]
        begin
          SlaveState = `S_ERROR;
          // To extend the Slave state by one HCLK
          Wait1 = 1'b1;
        end
      else if (randomno == 3'b101 && HTRANS[1])
        begin
          SlaveState = `S_RETRY;
          // To extend the Slave state by one HCLK
          Wait1 = 1'b1;
        end
      else if (randomno == 3'b110 && HTRANS[1])
        begin
          SlaveState = `S_SPLIT;
          // To extend the Slave state by one HCLK
          Wait1 = 1'b1;
        end
      else
        begin
          // Default Slave State
          SlaveState = `S_OKAY;
        end
    end
end

// -----------------------------------------------------------------------------
// HREADY Generation:
// -----------------
// For OKAY State, it will be High.
// For Wait State in BUSY mode it will be Low.
// For RETRY, SPLIT and ERROR State, for the 1st HCLK it will be low and for the
// next HCLK it will be high to indicate end of transfer.
// -----------------------------------------------------------------------------
always @(SlaveState or Wait1)
begin : p_CombHREADY
  case (SlaveState)
    `S_OKAY :                      HREADY = 1'b1;
    `S_RETRY, `S_SPLIT, `S_ERROR : HREADY = ~Wait1;
    `S_BUSY :                      HREADY = 1'b0;
  endcase
end

// -----------------------------------------------------------------------------
// HRESP Generation:
// ----------------
// HRESP will reflect the Slave state. The Slave State is so formed so 
// that HRESP = SlaveState[1:0].
// -----------------------------------------------------------------------------
assign HRESP = SlaveState[1:0];

// -----------------------------------------------------------------------------
// Arbiter Block:
// -------------
// This block is going to generate HGRANT depending on HBUSREQ and SPLIT 
// response from the slave.
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK or SlaveState or HBUSREQ or 
         CLTrGrant or HREADY)
begin : p_Arbiter
  if (!HRESETN || !CLTrGrant)
    // Condition to remove the Grant
    begin
      HGRANT = 1'b0;
    end
  // Remove the grant at the 2nd phase of Split Response, i.e. when HREADY = 1
  else if (SlaveState == `S_SPLIT && HREADY)
    begin
      // Remove the Grant in SPLIT for a number of HCLKs
      HGRANT = 1'b0;
      repeat (`SPLITNO) @ (posedge HCLK);
    end
  else if (HBUSREQ && HREADY)
    // Grant will come after 2 HCLK on request by a Master
    // As after split no signal will change, so in the sensitivity list,
    // positive edge of HCLK should be added.
    begin
      @ (posedge HCLK);
      @ (posedge HCLK);
      HGRANT = 1'b1;
    end
  else if (!HBUSREQ)
    begin
      // Remove the Grant when HBUSREQ goes low after one HCLK
      @ (posedge HCLK);
      // Randomise the Grant
      HGRANT    = RandomReg[20]; 
    end
end

// -----------------------------------------------------------------------------
// Data Generation Block:
// ---------------------
// Depending on the Rand, this block is going to generate HRDATA in a 
// random manner or from an image file.
// -----------------------------------------------------------------------------
always @(negedge HRESETN or CLTrEn or iHADDR or DataAvail or RandomReg)
begin : p_AHBIF
  if (!HRESETN || !CLTrEn)
    begin
      HRDATA = 32'bx;
      CLTrPanel = 1'bx;
    end
  else if (DataAvail)
    begin
      `ifdef IMAGE
        HRDATA = ImageMem[iHADDR];
      `else
        HRDATA = RandomReg;
      `endif
    end   
  else
    HRDATA = 32'bx;
end

// -----------------------------------------------------------------------------
// Data Avaiable Signal Generation
// -----------------------------------------------------------------------------
assign DataAvail = HRESETN && CLTrEn && iHTRANS[1] && 
                   HREADY && (SlaveState == `S_OKAY);
// -----------------------------------------------------------------------------
//  Assignment of BPP value
// -----------------------------------------------------------------------------
always@(BPP)
begin : p_BPPAssign
  case (BPP)
    0 : BPPValue = 1;
    1 : BPPValue = 2;
    2 : BPPValue = 4;
    3 : BPPValue = 8;
    4 : BPPValue = 16;
    default : BPPValue = 0;           
  endcase
end   

// CLCD Address Window Value Genration:
// -----------------------------------------------------------------------------
assign ADDWindow = ((16 * (PPL + 1) * (LPP + 1) * BPPValue) / 32);

// -----------------------------------------------------------------------------
// Address Checkup Block:-
// -----------------------
// This block will check up the HADDR for satisfying the following condtions:
//   o HADDR should increment properly.
//   o HADDR should be bounded by the maximum offset.
//   o Last HADDR is corresponding to the last data of the image or not.
//   o After each frame it should be loaded by the Base Addrss registers.
//   Checking is to be done for both the panels in STN Dual Panel mode.
// This block is also responsible for generating a signal - CLTrPanel,
// indicating the panel in STN Dual panel mode. This block is also 
// responsible for Base Address check up.
// -----------------------------------------------------------------------------
always @(HRESETN or CLTrEn or CLTrBaseUpdate or iBaseUpdate or Dual or UPADD or
         LPADD or ADDWindow or DataAvail or iHADDR)

begin : p_AddCheck
  if (!HRESETN || !CLTrEn)
    begin
      // Reset value
      CLTrPanel = 1'bx;
    end
  else if (CLTrBaseUpdate && !iBaseUpdate)
    // --------------------------------------------------------
    // Load Address Counters by their respective base address
    //                      __    __    __    __    __    __ 
    //  HCLK           : __1  |__1  |__1  |__1  |__1  |__1  |__
    //                              ___________________________
    //  CLTrBaseUpdate : __________|
    //                                  _______________________
    //  iBaseUpdate    : ______________|
    //                              ___
    //  Logic          : __________|   |_______________________
    //                                 ^ Address Counters will
    //                                   get upadated here.
    // --------------------------------------------------------
    begin
      if ((UPADD < ADDWindow) || Dual && (LPADD < ADDWindow))
        // If Address hasn't crossed the Address Window (i.e.
        // Full Image is not taken for display), Error.
        begin
          $display($time," : ERROR : Full Image is not taken for display \n");
          `ERR_EXIT;
        end 

      // Next base Address Update
      NextUPADD = CLTrUPBASE;
      NextLPADD = CLTrLPBASE;
    end
  else if (DataAvail)
    // Check when HRDATA is valid
    begin
      if (iHADDR == UPADD)
        begin
          NextUPADD = UPADD + 4;
          CLTrPanel = 1'b0;
        end
      else if (Dual && iHADDR == LPADD)
        begin
          NextLPADD = LPADD + 4;
          CLTrPanel = 1'b1;
        end
    end  
end

// -----------------------------------------------------------------------------
// Clocking of UPADD and LPADD
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_SeqADD
  if (!HRESETN || !CLTrEn)
    begin
      UPADD       = 32'b0;
      LPADD       = 32'b0;
      iBaseUpdate = 1'b0;
    end
  else
    begin
      UPADD       = NextUPADD;
      LPADD       = NextLPADD;
      iBaseUpdate = CLTrBaseUpdate;
    end
end

// -----------------------------------------------------------------------------
// Assigning the position for write pointers to initialise 
// -----------------------------------------------------------------------------
assign ResetWritePtrs = (CLTrUPBASE == HADDR);
                     
// -----------------------------------------------------------------------------
// Check HSIZE, HPROT, HBURST
// -----------------------------------------------------------------------------
always @(iHSIZE or iHPROT or iHBURST or iHWRITE)
begin : p_Check
  if (iHSIZE != 3'b010)
    begin
      $display($time," : ERROR : HSIZE is not 32 bit\n");
      `ERR_EXIT;
    end
  if (iHPROT != 4'b0001)
    begin
      $display($time," : ERROR : HPROT is not in USER DATA ACCESS mode\n");
      `ERR_EXIT;
    end
  if (iHWRITE)
    begin
      $display($time," : ERROR : Write request from CLCD Master\n");
      `ERR_EXIT;
    end
end

endmodule
 
// --================================== End ==================================--

