// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : A7WrapSM.v,v
// File Revision       : 1.8
// 
// Release Information : CPU_AHB_Wrappers-RELv1r1
// 
// ---------------------------------------------------------------------
// Purpose             : State machine portion of the ARM7 AHB
//                       wrapper - converts core signals into a
//                       simplified version of AHB which assumes no
//                       split/retry responses and is always granted.
//                       Requires A7WrapMaster which interfaces the
//                       simplified AHB signals to the full AHB bus
//                       
// --=================================================================--
 
`timescale 1ns/1ps
 
module A7WrapSM (HCLK, HRESETn, MREADY, MERROR, MADDR, MTRANS, MWRITE,
                 MSIZE, MBURST, MPROT, MLOCK, ADDR, PROT, SIZE, TRANS,
                 WRITE, LOCK, CLKEN);
  
  input HCLK;
  input HRESETn;
  input MREADY;
  input MERROR;
  output [31:0] MADDR;
  output [1:0]  MTRANS;
  output        MWRITE;
  output [2:0]  MSIZE;
  output [2:0]  MBURST;
  output [3:0]  MPROT;
  output        MLOCK;
  input [31:0]  ADDR;
  input [1:0]   PROT;
  input [1:0]   SIZE;
  input [1:0]   TRANS;
  input         WRITE;
  input         LOCK;
  output        CLKEN;
  
  //--------------------------------------------------------------------
  // Internal Constants
  //--------------------------------------------------------------------
  // Transfer size encodings and associated address increments
  `define SZ_BYTE        2'b00
  `define SZ_HWORD       2'b01
  `define SZ_WORD        2'b10
  `define INC_BYTE       4'b0001
  `define INC_HWORD      4'b0010
  `define INC_WORD       4'b0100
  
  // Encoding for TRANS
  `define TR_IDLE        2'b00
  `define TR_COP         2'b01
  `define TR_NON         2'b10
  `define TR_SEQ         2'b11
  `define TR_IS  2'b01
  
  // Encoding for state machine
  `define ST_IDLE        3'b000
  `define ST_IS  3'b001
  `define ST_SEQ         3'b011
  `define ST_NON         3'b010
  `define ST_LOKI        3'b100
  `define ST_LOKR        3'b101
  `define ST_LOKW        3'b111
  
  // Address select
  `define ADDR_REG       1'b0
  `define ADDR_INC       1'b1

  //--------------------------------------------------------------------
  // Internal Signals
  //--------------------------------------------------------------------
  wire          iiCLKEN;
  wire          EndofPage;
  wire [31:0]   iMADDR;
  wire          LockStart;
  
  reg           iCLKEN;
  reg [1:0]     iMTRANS;
  reg           iMLOCK;
  reg           dWRITE;
  reg [1:0]     dPROT;
  reg           AddrSel;
  reg [2:0]     CurrentState;
  reg [2:0]     NextCurrentState;
  reg           NextAddrSel;
  reg [1:0]     NextdPROT;
  reg           NextMLOCK;
  reg           NextdWRITE;
  reg           NextiCLKEN;
  reg [1:0]     NextiMTRANS;
  reg [1:0]     dSIZE;
  reg           dLOCK;
  reg [31:0]    cAddrInc;
  reg [31:0]    dAddrInc;
  reg [31:0]    dADDR;
  reg [31:0]    iADDR;
  reg           Boundary;
  reg [1:0]     MTRANS;

  reg           ForceAdvance;
  wire          StateAdvance;

  //--------------------------------------------------------------------
  // Main Code
  //--------------------------------------------------------------------

  //--------------------------------------------------------------------
  // State machine to control all transaction conversions between
  // ARM7 i/f and AHB bus
  //--------------------------------------------------------------------
  // Sequential portion
  //--------------------------------------------------------------------
  assign StateAdvance = MREADY || ForceAdvance;

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        begin
          CurrentState <= `ST_IDLE;
          AddrSel <= `ADDR_REG;
          dPROT <= 2'b00;
          dWRITE <= 1'b0;
          iMLOCK <= 1'b0;
          iMTRANS <= `TR_IDLE;
          iCLKEN <= 1'b1;
        end // if (!HRESETn)
      else
        begin
          if (StateAdvance)
            begin
              CurrentState <= NextCurrentState;
              AddrSel <= NextAddrSel;
              dPROT <= NextdPROT;
              dWRITE <= NextdWRITE;
              iMLOCK <= NextMLOCK;
              iMTRANS <= NextiMTRANS;
              iCLKEN <= NextiCLKEN;
            end // if (MREADY)
        end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  assign MLOCK = iMLOCK;

  //--------------------------------------------------------------------
  // Combinatorial portion
  //--------------------------------------------------------------------
  always @(CurrentState or LockStart or TRANS or MERROR or iCLKEN)
    begin
      // Default assignments: if the following case statement does not
      // set a signal to a new value, then the old value should be kept.
      NextCurrentState = CurrentState;
      ForceAdvance = 1'b0;
      case (CurrentState)
        `ST_IDLE,`ST_IS :
          //--------------------------------------------------------------------
          // IDLE state
          // Default state, allows the core to be clocked until a bus
          // transaction is requested (N or S cycle)
          // The state ST_IS indicates that the ARM7 core is possibly
          // performing a merged I-S transfer: this is used later to indicate
          // that HTRANS should indicate a sequential access on the next cycle
          // if TRANS from the core does in fact continue with the I-S
          //--------------------------------------------------------------------
          if (LockStart)
            begin
              NextCurrentState = `ST_LOKI;
              ForceAdvance = 1'b0;
            end
          else
            case (TRANS)
              `TR_SEQ :
                //--------------------------------------------------------
                // Sequential: Must be a merged I-S cycle, therefore
                // this AHB cycle will be forced to non-sequential and
                // the next will be sequential
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_SEQ;
                  ForceAdvance = 1'b0;
                end
              `TR_NON :
                //--------------------------------------------------------
                // Non-sequential: insert IDLE cycle on AHB if
                // current transfer has not completed
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_NON;
                  ForceAdvance = 1'b1;
                end
              `TR_IDLE :
                //--------------------------------------------------------
                // Idle: assume a merged I-S cycle, which will result in the
                //       next AHB transaction being N.  If not, then
                //       HTRANS will be forced to the correct value
                //       combinatorily
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IS;
                  ForceAdvance = 1'b0;
                end
              `TR_COP :
                //--------------------------------------------------------
                // Co-proc cycles: AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
              default  :
                //--------------------------------------------------------
                // Other: This should never be reached.  AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
            endcase // case(TRANS)
        
        `ST_SEQ :
          //--------------------------------------------------------------------
          // SEQUENTIAL ACCESS state
          // A sequential burst is in progress: the AHB cycles occur
          // simultaneously with the core S cycles
          //--------------------------------------------------------------------
          // A sequential cycle on the AHB will be allowed only after a
          // non-sequential.  Merged core I-S cycles can be supported by
          // mapping the first core S cycle to an AHB non-sequential cycle.
          if (LockStart)
            begin
              NextCurrentState = `ST_LOKI;
              ForceAdvance = 1'b0;
            end
          else
            case (TRANS)
              `TR_SEQ :
                //--------------------------------------------------------
                // Sequential: assume that the next will also be sequential
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_SEQ;
                  ForceAdvance = 1'b0;
                end
              `TR_NON :
                //--------------------------------------------------------
                // Non-sequential: burst over; the current AHB cycle
                // will be forced to IDLE, allowing the next to be
                // non-sequential
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_NON;
                  ForceAdvance = 1'b1;
                end
              `TR_IDLE :
                //--------------------------------------------------------
                // Idle: burst over.  Assume merged I-S starting
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IS;
                  ForceAdvance = 1'b0;
                end
              `TR_COP :
                //--------------------------------------------------------
                // Co-proc cycles: AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
              default  :
                //--------------------------------------------------------
                // Other: This should never be reached.  AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
            endcase // case(TRANS)
        
        `ST_NON :
          //--------------------------------------------------------------------
          // NON-SEQUENTIAL ACCESS state
          //--------------------------------------------------------------------
          if (LockStart)
            begin
              NextCurrentState = `ST_LOKI;
              ForceAdvance = 1'b0;
            end
          else
            case (TRANS)
              `TR_SEQ :
                //--------------------------------------------------------
                // Sequential: the next AHB tranmsfer will be sequential,
                // following on from the current non-sequential
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_SEQ;
                  ForceAdvance = 1'b0;
                end
              `TR_NON :
                //--------------------------------------------------------
                // Non-sequential: if iCLKEN is 0 then it is known that
                // TRANS indicates the next transfer because the core has
                // already been stepped on.  If not, then assume that the
                // next cycle will be SEQ - if this is not the case then
                // HTRANS will be combinatorily forced to IDLE
                //--------------------------------------------------------
                begin
                  if (iCLKEN == 1'b0)
                    NextCurrentState = `ST_NON;
                  else
                    NextCurrentState = `ST_SEQ;
                  ForceAdvance = 1'b0;
                end
              `TR_IDLE :
                //--------------------------------------------------------
                // Idle: Assume merged I-S starting
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IS;
                  ForceAdvance = 1'b0;
                end
              `TR_COP :
                //--------------------------------------------------------
                // Co-proc cycles: AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
              default  :
                //--------------------------------------------------------
                // Other: This should never be reached.  AHB will be idle
                //--------------------------------------------------------
                begin
                  NextCurrentState = `ST_IDLE;
                  ForceAdvance = 1'b0;
                end
            endcase // case(TRANS)
        
        `ST_LOKI :
          //--------------------------------------------------------------------
          // LOCK INITIALISE state
          // Pauses the core and AHB for one cycle to enable HLOCK to
          // be asserted one cycle ahead of the address/control
          // information
          //--------------------------------------------------------------------
          // No need to trap MERROR here: only pre-fetch aborts can
          // occur on this cycle, which will not affect the current
          // SWP instruction
          begin
            NextCurrentState = `ST_LOKR;
            ForceAdvance = 1'b0;
          end
        `ST_LOKR :
          //--------------------------------------------------------------------
          // The only reason for LOCK to be asserted by the ARM7 is
          // when a SWP (swap) instruction is issued: this comprises a
          // read followed by a write
          // LOCK READ state
          //--------------------------------------------------------------------
          // An error on this cycle indicates a data abort, and so
          // the SWP will not continue to the write stage
          if (MERROR)
            begin
              NextCurrentState = `ST_IDLE;
              ForceAdvance = 1'b0;
            end
          else
            begin
              NextCurrentState = `ST_LOKW;
              ForceAdvance = 1'b0;
            end
        
        `ST_LOKW :
          //--------------------------------------------------------------------
          // LOCK WRITE state
          //--------------------------------------------------------------------
          // No need to trap MERROR here: whether there is an error
          // or not, the next cycle will be idle
          begin
            NextCurrentState = `ST_IDLE;
            ForceAdvance = 1'b0;
          end
        
        default  :
          //--------------------------------------------------------------------
          // Default state - this should never be reached during normal
          // operation
          //--------------------------------------------------------------------
          begin
            NextCurrentState = `ST_IDLE;
            ForceAdvance = 1'b0;
          end
      endcase // case(CurrentState)
    end // always @ (CurrentState or LockStart or TRANS or MERROR)
  
  //--------------------------------------------------------------------
  // Control signal generation
  // This has been split from the main state machine to aid readability
  //--------------------------------------------------------------------
  // Select the source of the address for the next transaction:
  // either registered from the core (ADDR_REG) for most
  // transactions, or from the local incrementer (ADDR_INC) for
  // sequential accesses
  always @(LockStart or TRANS or CurrentState or iCLKEN)
    begin
      if (LockStart)
        NextAddrSel = `ADDR_REG;
      else if ((TRANS == `TR_SEQ) ||
               ((CurrentState == `ST_NON) && (TRANS == `TR_NON)
                && (iCLKEN == 1'b1)))
        NextAddrSel = `ADDR_INC;
      else
        NextAddrSel = `ADDR_REG;
    end // always @ (LockStart or TRANS)
  
  // MPROT is usually taken directly from the core, but the ARM7
  // family can change PROT during a sequential burst: this is banned
  // on AHB and so a registered version is used
  always @(LockStart or TRANS or PROT or dPROT)
    begin
      if (LockStart)
        NextdPROT = PROT;
      else
        case (TRANS)
          `TR_IDLE :
            // The ARM7 family only perform merges I-S cycles when
            // fetching opcodes, however the value of PROT given during
            // the I cycle can be incorrect.  Therefore blank bit 0 to
            // indicate opcode fetch - if the I cycle is followed by an N
            // cycle then the correct value will ba taken from there.
            NextdPROT = {PROT[1] , 1'b0};
          `TR_SEQ :
            // Hold PROT value during burst
            NextdPROT = dPROT;
          `TR_NON,`TR_COP :
            // Otherwise, pass through value from core
            NextdPROT = PROT;
          default  :
            // Illegal states (X,Z,etc)
            NextdPROT = PROT;
        endcase // case(TRANS)
    end // always @ (LockStart or TRANS or PROT or dPROT)
  
  // Assery MLOCK from the start of a locked transfer and for the
  // duration of that transfer
  always @(LockStart or CurrentState)
    begin
      if ((CurrentState == `ST_LOKI || CurrentState == `ST_LOKR) || LockStart)
        NextMLOCK = 1'b1;
      else
        NextMLOCK = 1'b0;
    end // always @ (LockStart or CurrentState)
  
  // MWRITE is usually taken from the core except when starting a
  // SWP instruction, which comprises a read then a write.  In this
  // case the core is advanced to the address phase of the write
  // operation whilst an IDLE cycle is placed on the AHB, and so
  // directly registering WRITE causes MWRITE to show a write access
  // for the read transfer - therefore, hold the old value during the
  // Lock Initialise state (ST_LOKI)
  always @(CurrentState or dWRITE or WRITE)
    begin
      if (CurrentState == `ST_LOKI)
        NextdWRITE = dWRITE;
      else
        NextdWRITE = WRITE;
    end // always @ (CurrentState or dWRITE or WRITE)
  
  // Generation of MTRANS and CLKEN is closely linked to the states
  // of the state machine, but is split out here to avoid cluttering
  // the main state machine process
  always @(LockStart or TRANS or CurrentState or MERROR or iiCLKEN)
    begin
      if (LockStart)
        begin
          // Starting a SWP transfer: perform an idle cycle on the AHB
          // whilst stalling the core.  MLOCK will also be asserted
          // If the current cycle was stalled (CLKEN=0) then the next
          // core cycle must be enabled to advance from the read access
          // to the write access
          NextiMTRANS = `TR_IDLE;
          if (iiCLKEN == 1'b0)
            NextiCLKEN = 1'b1;
          else
            NextiCLKEN = 1'b0;
        end // if (LockStart)
      else
        case (CurrentState)
          `ST_IS,`ST_IDLE,`ST_SEQ :
            // The "normal" run states: these do not add wait states
            // after completion
            case (TRANS)
              `TR_SEQ :
                begin
                  // The core is indicating a sequential burst so assume
                  // that the next AHB cycle will continue the burst
                  NextiMTRANS = `TR_SEQ;
                  NextiCLKEN = 1'b1;
                end // case: `TR_SEQ
              `TR_NON :
                begin
                  // Add a wait state to allow the core and AHB to
                  // synchronise during non-sequential transfers
                  NextiMTRANS = `TR_NON;
                  if (iiCLKEN == 1'b0)
                    NextiCLKEN = 1'b1;
                  else
                    NextiCLKEN = 1'b0;
                end // case: `TR_NON
              `TR_IDLE :
                begin
                  // Assume that the idle cycle from the core is the
                  // start of a merged I-S cycle.  If not, then the next
                  // cycle will be combinatorily forced to idle
                  NextiMTRANS = `TR_NON;
                  NextiCLKEN = 1'b1;
                end // case: `TR_IDLE
              `TR_COP :
                begin
                  // Co-processor cycle: place an idle cycle on the AHB
                  // and allow the core to clock until it accesses the
                  // bus
                  NextiMTRANS = `TR_IDLE;
                  NextiCLKEN = 1'b1;
                end // case: `TR_COP
              default  :
                begin
                  // This should never be reached
                  NextiMTRANS = `TR_IDLE;
                  NextiCLKEN = 1'b1;
                end // case: default
            endcase // case(TRANS)
          
          `ST_NON :
            case (TRANS)
              `TR_SEQ :
                begin
                  // The current non-sequential access is the start of a
                  // burst
                  NextiMTRANS = `TR_SEQ;
                  NextiCLKEN = 1'b1;
                end // case: `TR_SEQ
              `TR_IDLE,`TR_COP :
                begin
                  NextiMTRANS = `TR_IDLE;
                  NextiCLKEN = 1'b1;
                end // case: `TR_IDLE,`TR_COP
              `TR_NON :
                begin
                  if (iiCLKEN == 1'b0)
                    NextiMTRANS = `TR_NON;
                  else
                    NextiMTRANS = `TR_SEQ;
                  NextiCLKEN = 1'b1;
                end // case: `TR_NON
              default  :
                begin
                  // This should never be reached
                  NextiMTRANS = `TR_IDLE;
                  NextiCLKEN = 1'b1;
                end // case: default
            endcase // case(TRANS)
          
          `ST_LOKI :
            begin
              NextiMTRANS = `TR_NON;
              NextiCLKEN = 1'b0;
            end // case: endcase...
          `ST_LOKR :
            if (MERROR)
              begin
                NextiMTRANS = `TR_IDLE;
                NextiCLKEN = 1'b1;
              end // if (MERROR)
            else
              begin
                NextiMTRANS = `TR_NON;
                NextiCLKEN = 1'b1;
              end // else: !if(MERROR)
          
          `ST_LOKW :
            begin
              NextiMTRANS = `TR_IDLE;
              NextiCLKEN = 1'b1;
            end // case: `ST_LOKW
          default  :
            begin
              // This should never be reached
              NextiMTRANS = `TR_IDLE;
              NextiCLKEN = 1'b1;
            end // case: default
        endcase // case(CurrentState)
    end // always @ (LockStart or TRANS or CurrentState or iiCLKEN or MREADY or...
  
  // Some address-class signals need to be latched for use in the
  // wrapper.  The full list of address-class signals is:
  //     ADDR(31:0)
  //     WRITE
  //     SIZE(1:0)
  //     PROT(1:0)
  //     LOCK
  //     CPTBIT
  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        dSIZE <= 2'b00;
      else
        dSIZE <= SIZE;
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  assign MSIZE = {1'b0 , dSIZE};
  assign MBURST = 3'b001;
  assign MWRITE = dWRITE;

  // The ARM7 core can change PROT during a sequential burst, but
  // this is not allowed on the AHB.  The chosen solution is to hold
  // the initial value of PROT for the entire burst on the AHB
  assign MPROT = {2'b00 , dPROT};

  // The HLOCK signal needs to be held during the address phases of
  // both the read and the write which comprise a SWAP instruction.
  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        dLOCK <= 1'b0;
      else
        begin
          if (MREADY)
            dLOCK <= LOCK;
        end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  // LockStart indicates that a locked operation is starting.  It is
  // held until the start of the next valid cycle, to ensure that the
  // state machine acts upon it.
  assign LockStart = LOCK &  (~ dLOCK) ;

  // Create a locally incremented address
  always @(dSIZE or iMADDR)
    begin
      case (dSIZE)
        `SZ_BYTE :
          cAddrInc = iMADDR + `INC_BYTE;
        `SZ_HWORD :
          cAddrInc = iMADDR + `INC_HWORD;
        default  :
          cAddrInc = iMADDR + `INC_WORD;
      endcase // case(dSIZE)
    end // always @ (dSIZE or iMADDR)
  
  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        dAddrInc <= 32'h0000_0000;
      else
        begin
          if (MREADY)
            dAddrInc <= cAddrInc;
        end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  // Latch the address from the ARM7 core directly and then mux
  // between this and the incremented version in the next cycle: this
  // is necessary because the address from the ARM7 arrives so late
  // in the cycle
  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        dADDR <= 32'h0000_0000;
      else
        dADDR <= ADDR;
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  // The bottom address bits need to be blanked appropriately when
  // performing WORD or HALFWORD accesses
  always @(dSIZE or dADDR)
    begin
      case (dSIZE)
        `SZ_WORD :
          iADDR = {dADDR[31:2] , 2'b00};
        `SZ_HWORD :
          iADDR = {dADDR[31:1] , 1'b0};
        default  :
          iADDR = dADDR;
      endcase // case(dSIZE)
    end // always @ (dSIZE or dADDR)
  
  
  // Select the locally incremented address instead of ADDR during
  // sequential bursts.  This allows the burst to run with no wait
  // states except the one after the initial non-seq access of the
  // burst, and one following the end of the burst
  assign iMADDR = (AddrSel == `ADDR_REG ? iADDR : dAddrInc);
  assign MADDR = iMADDR;

  // Wait states are also inserted to match those on the AHB bus
  // (indicated by HREADY).
  // This assumes that the version of HREADY passed to this function
  // only goes low when the A7 is controlling the AHB bus - i.e.
  // MREADY is high whenever the A7 is de-granted, else wait states
  // due to other master/slave accesses will cause wait states during
  // I and C cycles in the core
  assign iiCLKEN = iCLKEN & MREADY;
  assign CLKEN = iiCLKEN;

  // Boundary Detector
  // To avoid a critical path must look for the access to the last
  // word / halfword in a page, and regiser it. Do not need to cope
  // with the byte case, as the ARM cannot do bursts of Byte
  // accesses.
  assign EndofPage = (((dSIZE[1] == 1'b1 && iMADDR[9:2] == 8'b11111111) ||
		       (dSIZE[1] == 1'b0 && iMADDR[9:1] == 9'b111111111))
		      ? 1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
        Boundary <= 1'b0;
      else
        begin
          if (MREADY)
            Boundary <= EndofPage;
        end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  // Some combinatorial paths exist to HTRANS:
  // 1. If the previous cycle from the core was sequential or idle
  //    then this cycle is assumed to be sequential.  Force HTRANS to
  //    idle if this is not the case, as indicated by TRANS from the
  //    core
  // 2. The AHB spec states that a sequential transfer must not cross
  //    a 1KB boundary.  If a sequential access is indicated which
  //    would break this requirement then set HTRANS to indicate a
  //    non-sequential cycle instead
  always @(CurrentState or TRANS or Boundary or iMTRANS)
    begin
      if ((CurrentState == `ST_SEQ || CurrentState == `ST_IS) &&
	  TRANS != `TR_SEQ)
        MTRANS = `TR_IDLE;
      else if (CurrentState == `ST_SEQ && Boundary)
        MTRANS = `TR_NON;
      else
        MTRANS = iMTRANS;
    end // always @ (CurrentState or TRANS or Boundary or iMTRANS)
  
endmodule // A7WrapSM
