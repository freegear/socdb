
module SmcProtChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      HADDR,
                      HTRANS,
                      HSIZE,
                      HWRITE,
                      HBURST,
                      HRDATA,
                      HWDATA,
                      HSELREG,
                      HREADYIN,
                      HSELSMC,
                      SMDATAOUT,
                      SMADDR,
                      SMCActLowCS,
                      SMCS,
                      nSMDATAEN,
                      nSMWEN,
                      nSMBLS,
                      nSMOEN,
                      SMDATAIN,
                      SMBUSREQ,
                      SMBUSGNT,
                      SMWAIT,
//                      CancelSMWAIT,
// Outputs            
                      HREADYOUTPr,
                      SMCSPr
                     );
 
// Inputs
input         HCLK;        // AHB Bus Clock
input         HRESETn;     // Bus Reset
input  [1:0]  HTRANS;      // HTRANS information
input  [31:0] HADDR;       // HADDR information
input  [2:0]  HBURST;      // HBURST information
input  [2:0]  HSIZE;       // HSIZE information
input         HWRITE;      // HWRITE indication wheter read or write xfer
input  [63:0] HRDATA;      // HRDATA linesa
input  [63:0] HWDATA;      // HWDATA lines
input         HSELREG;     // HSELREGISTER to be selected
input         HSELSMC;     // HSELSMC select signal
input         HREADYIN;    // HREADYIN signal
input  [31:0] SMDATAOUT;   // Memory Data Out from the SMC for
                           // checking 'X'es on it
input  [25:0] SMADDR;      // Memory Address from the SMC for checking
                           // 'X'es on it
input   [7:0] SMCActLowCS; // Active low Memory Bank Select
input   [7:0] SMCS;        // Memory Bank Select signals from the SMC
input   [3:0] nSMDATAEN;   // Data Bus enable signal
input         nSMWEN;      // Memory Write enable
input   [3:0] nSMBLS;      // Data Bus Lane Enable signal
input         nSMOEN;      // Memory read enable
input  [31:0] SMDATAIN;    // Data bus used to read data from memory
input         SMWAIT;      // Wait mode input from external memory controller
input         SMBUSREQ;    // BUSREQ signal
input         SMBUSGNT;    // SMBUSGN signal
//input         CANCELSMWAIT;// Signal to recover from external wait 
output        HREADYOUTPr; // MIRROR signal of HREADYOUT
output        SMCSPr;      // Mirror SIgnal of SMCS
// Inputs
  wire        HCLK;        // AHB Bus Clock

  wire [31:0] SMDATAOUT;   // Memory Data Out from the SMC for
                           // checking 'X'es on it
  wire [25:0] SMADDR;      // Memory Address from the SMC for checking
                           // 'X'es on it
  wire  [7:0] SMCActLowCS; // Active low Memory Bank Select
  wire  [7:0] SMCS;        // Memory Bank Select signals from the SMC
  wire  [3:0] nSMDATAEN;   // Data Bus enable signal
  wire        nSMWEN;      // Memory Write enable
  wire  [3:0] nSMBLS;      // Data Bus Lane Enable signal
  wire        nSMOEN;      // Memory read enable
  wire [31:0] SMDATAIN;    // Data bus used to read data from memory
  wire        SMBUSREQ;    // BUSREQ signal
  wire        SMBUSGNT;    // SMBUSGN signal

  wire        SMWAIT;      // Wait mode input from external memory controller
  wire        CANCELSMWAIT;// Signal to recover from external wait
  wire [1:0]  HTRANS;      // HTRANS information
  wire [31:0] HADDR;       // HADDR information
  wire [2:0]  HBURST;      // HBURST information
  wire [2:0]  HSIZE;       // HSIZE information
  wire        HWRITE;      // HWRITE indication wheter read or write xfer
  wire [63:0] HRDATA;      // HRDATA lines
  wire [63:0] HWDATA;      // HWDATA lines
 




// -----------------------------------------------------------------------------
//
//                                SmcTrProtChkr
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block performs the following operations:
//   - Captures non-AMBA, non-memory related signals from the SMC.
//   - Does the protocol checks on the SMC.
//
// ----------------------------------------------------------------------------




//    place for signals


// Wire declarations












// reg declarations
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg [3:0] SMBIDCYR0;
// register which store the IDCY VALUES

reg [4:0] SMBWST1R0;
// register which store the WST1 VALUES

reg [4:0] SMBWST2R0;
// register which store the WST2 VALUES

reg [3:0] SMBWSTOENR0;
// register which store the OUTPUT ENABLE VALUES

reg [3:0] SMBWSTWENR0;
// register which store the WRITE ENABLE VALUES

reg [7:0] SMBCR0;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR1;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R1;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R1;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR1;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR1;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR1;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR2;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R2;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R2;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR2;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR2;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR2;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR3;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R3;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R3;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR3;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR3;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR3;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR4;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R4;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R4;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR4;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR4;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR4;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR5;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R5;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R5;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR5;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR5;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR5;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR6;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R6;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R6;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR6;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR6;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR6;
// register which store the STATUS REGISRER values

reg [3:0] SMBIDCYR7;
// register which store the IDCY VALUES
 
reg [4:0] SMBWST1R7;
// register which store the WST1 VALUES
 
reg [4:0] SMBWST2R7;
// register which store the WST2 VALUES
 
reg [3:0] SMBWSTOENR7;
// register which store the OUTPUT ENABLE VALUES
 
reg [3:0] SMBWSTWENR7;
// register which store the WRITE ENABLE VALUES
 
reg [7:0] SMBCR7;
// register which store the STATUS REGISRER values








reg [4:0] WST1;
// WST1 field controls the number of wait states for read access

reg [4:0] WST2;
// WST2 field controls the number of wait states for read access

reg [3:0] WSTOEN;
//Output enable assertion delay from chip select assertion

reg [1:0] MW;
//Memory Width of each memory Bank

reg BM;
// Burst mode of memory enabled

reg [3:0] IDCY;
// indicates turn around cycles

// indicate output enable time

//reg [6:0] CountSMC;
// Counter to indicate for how many cycles chip selected should be asserted

//reg [6:0] CountSMOEN;
// Counter to indicate for how many clock cycles SMOEN should be asserted

reg [5:0] Beat1;
// Number of Increment  xfers to be done in a  burst

reg [5:0] Beat2;
// Number of wrapping   xfers to be done in a  burst

reg [5:0] HS;
// HSIZE value is stored in it

reg [5:0] MSIZE;
// MSIZE value is stored in it

reg       HREADYOUTPr;       
// mirror image of HREADYOUT signal

//reg       SMCSPr;
// mirror image of SMCS
       
reg [7:0] FrstReadCntEq;
// counter which makes HREAdYPr low till it expires

reg [7:0] FrstReadCntGt2;
// counter which makes HREAdYPr low till it expires

reg [7:0] FrstSubseqCntGt2;
// counter which makes HREAdYPr low till it expires

reg [7:0] FrstReadCntGt2_1;
// counter which makes HREAdYPr low till it expires

reg [7:0]  FastReadCntGt2_2;
// counter which makes HREAdYPr low till it expires

reg [7:0]  FastReadCntGt2_3;
// counter which makes HREAdYPr low till it expires(WST2)

reg [7:0]  FastReadCntGt2_4;
// counter which makes HREAdYPr low till it expires(WST1)



reg [7:0] FrstReadCntGt4_1;
// counter which makes HREAdYPr low till it expires

reg [7:0]  FastReadCntGt4_2;
// counter which makes HREAdYPr low till it expires

reg [7:0]  FastReadCntGt4_3;
// counter which makes HREAdYPr low till it expires

reg [7:0]  FastReadCntGt4_4;
// counter which makes HREAdYPr low till it expires


reg [7:0] FrstReadCntLt2;
// counter which makes HREAdYPr low till it expires

reg [7:0] FrstReadCntLt4;
// counter which makes HREAdYPr low till it expires


reg [1:0]     QuadBounCntEq;
// quadboundary counter when HSIZE = MSIZE

reg      QuadBounCntGt2;
// quadboundary counter when HSIZE >2MSIZE


reg  [1:0]     QuadBounCntLt2;
// quadboundary counter when MSIZE >2HSIZE

reg   [1:0]    QuadBounCntLt4;
// quadboundary counter when MSIZE >4HSIZE


//reg      LoopCnt;
// Counter to check for burts














reg [4:0] FastReadCntEq;
//    Counter for which HREADYOUTPr should be low when HSIZE =MSIZE and Seq 

reg [4:0] SlowReadCntEq;
//    Counter for which HREADYOUTPr should be low when HSIZE =MSIZE and Seq

reg [5:0] FastReadCntGt2; 
//    Counter for which HREADYOUTPr should be low when HSIZE =2MSIZE and Seq
 
reg [5:0] SlowReadCntGt2; 
//    Counter for which HREADYOUTPr should be low when HSIZE =2MSIZE and Seq
 
reg [6:0] OnlyReadCntGt4; 
//    Counter for which HREADYOUTPr should be low when HSIZE =4MSIZE and Seq


reg [5:0] FastReadCntLt2;
//    Counter for which HREADYOUTPr should be low when MSIZE =2HSIZE and Seq

reg [5:0] SlowReadCntLt2;
//    Counter for which HREADYOUTPr should be low when MSIZE =2HSIZE and Seq

reg [5:0] FastReadCntLt4;
//    Counter for which HREADYOUTPr should be low when MSIZE =4HSIZE and Seq

reg [5:0] SlowReadCntLt4;
//    Counter for which HREADYOUTPr should be low when MSIZE =4HSIZE and Seq
 

reg StartAddr00;
//  used for quad boundary conditions, tells the starting SMADDR

reg StartAddr01;
//  used for quad boundary conditions, tells the starting SMADDR

reg StartAddr10;
//  used for quad boundary conditions, tells the starting SMADDR

reg StartAddr11;
//  used for quad boundary conditions, tells the starting SMADDR

reg [1:0] StateFlag;
// Sort of State M/C which tells me what state the SMC is

reg NewBankFlag;
// used to check whter access is to new bank

reg [4:0] IDCYCnt;
// the time period during IDCY when HREADYOUTPr should be low

reg GntFlag;
// flag to indicate SMBUSREQ and SMBUSGNT is high

reg WaitFlag;
// flag to indicate SMWAIT condition









reg Flag;
// used to check that after NSEq and Seq all the counters r incremented properly


reg [2:0] ReadyCntHigh ;
// Counter to make HREADYOUTPr high after Nseq when HSIZE < MSIZE

reg [2:0] ReadyCntHighSeq ;
// Counter to make HREADYOUTPr high after Seq when HSIZE < MSIZ




 
//reg [4:0] BeatCount;
// stores the value of hburst used to calculate beat count








 reg      FlagEq;
// flag asserted when HSIZE =  MSIZE

 reg      FlagGt2;
// flag asserted when HSIZE >  MSIZE

 reg      FlagGt4;
// flag asserted when HSIZE >  MSIZE


 reg      FlagLt2;
// flag asserted when HSIZE <  MSIZE

 reg      FlagLt4;
// flag asserted when HSIZE <  MSIZE

//reg SMWaitFlag;
// SMwait flag

reg [2:0] LatchHADDR;
// latched version of HADDR[28:26]

reg ReadFlag;
// this flag is used to detect HWRITE going in between read xfers and to prevern// t futher reads

reg [9:0] HADDRQ;
// delayed version of HADDDR

reg  HTRANSQ;
// delayed version of HTRANS

reg HWRITEQ;
// delayed version of HWRITE

reg  HSELREGQ;
// delayed version of HSELREG

reg HREADYINQ;
// delayed version of HREADYIN

reg   [3:0] NextSMBIDCYR0;
// D-input of Idle cycle Control Register for Bank 0

reg   [4:0] NextSMBWST1R0;
// D-input of Wait State 1 Control Register for Bank

reg   [4:0] NextSMBWST2R0;
// D-input of Wait State 2 control Register for Bank 0

reg   [3:0] NextSMBWSTOENR0;
// D-input of OE Assertion Delay Control Register for Bank 0

reg   [3:0] NextSMBWSTWENR0;
// D-input of WE Assertion Delay Control Register for Bank 0

reg   [7:0] NextSMBCR0;
// D-input of Control Register for Bank 0

reg   [3:0] NextSMBIDCYR1;
// D-input of Idle cycle Control Register for Bank 1

reg   [4:0] NextSMBWST1R1;
// D-input of Wait State 1 Control Register for Bank 1

reg   [4:0] NextSMBWST2R1;
// D-input of Wait State 2 control Register for Bank 1

reg   [3:0] NextSMBWSTOENR1;
// D-input of OE Assertion Delay Control Register for Bank 1

reg   [3:0] NextSMBWSTWENR1;
// D-input of WE Assertion Delay Control Register for Bank 1

reg   [7:0] NextSMBCR1;
// D-input of Control Register for Bank 1

reg   [3:0] NextSMBIDCYR2;
// D-input of Idle cycle Control Register for Bank 2

reg   [4:0] NextSMBWST1R2;
// D-input of Wait State 1 Control Register for Bank 2

reg   [4:0] NextSMBWST2R2;
// D-input of Wait State 2 control Register for Bank 2

reg   [3:0] NextSMBWSTOENR2;
// D-input of OE Assertion Delay Control Register for Bank 2

reg   [3:0] NextSMBWSTWENR2;
// D-input of WE Assertion Delay Control Register for Bank 2

reg   [7:0] NextSMBCR2;
// D-input of Control Register for Bank 2

reg   [3:0] NextSMBIDCYR3;
// D-input of Idle cycle Control Register for Bank 3

reg   [4:0] NextSMBWST1R3;
// D-input of Wait State 1 Control Register for Bank 3

reg   [4:0] NextSMBWST2R3;
// D-input of Wait State 2 control Register for Bank 3

reg   [3:0] NextSMBWSTOENR3;
// D-input of OE Assertion Delay Control Register for Bank 3

reg   [3:0] NextSMBWSTWENR3;
// D-input of WE Assertion Delay Control Register for Bank 3

reg   [7:0] NextSMBCR3;
// D-input of Control Register for Bank 3

reg   [3:0] NextSMBIDCYR4;
// D-input of Idle cycle Control Register for Bank 4

reg   [4:0] NextSMBWST1R4;
// D-input of Wait State 1 Control Register for Bank 4

reg   [4:0] NextSMBWST2R4;
// D-input of Wait State 2 control Register for Bank 4

reg   [3:0] NextSMBWSTOENR4;
// D-input of OE Assertion Delay Control Register for Bank 4

reg   [3:0] NextSMBWSTWENR4;
// D-input of WE Assertion Delay Control Register for Bank 4

reg   [7:0] NextSMBCR4;
// D-input of Control Register for Bank 4

reg   [3:0] NextSMBIDCYR5;
// D-input of Idle cycle Control Register for Bank 5

reg   [4:0] NextSMBWST1R5;
// D-input of Wait State 1 Control Register for Bank 5

reg   [4:0] NextSMBWST2R5;
// D-input of Wait State 2 control Register for Bank 5

reg   [3:0] NextSMBWSTOENR5;
// D-input of OE Assertion Delay Control Register for Bank 5

reg   [3:0] NextSMBWSTWENR5;
// D-input of WE Assertion Delay Control Register for Bank 5

reg   [7:0] NextSMBCR5;
// D-input of Control Register for Bank 5

reg   [3:0] NextSMBIDCYR6;
// D-input of Idle cycle Control Register for Bank 6

reg   [4:0] NextSMBWST1R6;
// D-input of Wait State 1 Control Register for Bank 6

reg   [4:0] NextSMBWST2R6;
// D-input of Wait State 2 control Register for Bank 6

reg   [3:0] NextSMBWSTOENR6;
// D-input of OE Assertion Delay Control Register for Bank 6

reg   [3:0] NextSMBWSTWENR6;
// D-input of WE Assertion Delay Control Register for Bank 6

reg   [7:0] NextSMBCR6;
// D-input of Control Register for Bank 6

reg   [3:0] NextSMBIDCYR7;
// D-input of Idle cycle Control Register for Bank 7

reg   [4:0] NextSMBWST1R7;
// D-input of Wait State 1 Control Register for Bank 7

reg   [4:0] NextSMBWST2R7;
// D-input of Wait State 2 control Register for Bank 7

reg   [3:0] NextSMBWSTOENR7;
// D-input of OE Assertion Delay Control Register for Bank 7

reg   [3:0] NextSMBWSTWENR7;
// D-input of WE Assertion Delay Control Register for Bank 7

reg   [7:0] NextSMBCR7;
// D-input of Control Register for Bank 7

reg SMCFlag;
// the flag is used to test condition when HSELSMC is deassarted without the 
// current transaction being completed





always @(posedge HCLK or negedge HRESETn)
begin
 if (HRESETn == 1'b0)
    begin
      HADDRQ    <= 10'b0;
      HTRANSQ   <= 1'b0;
      HWRITEQ   <= 1'b0;
      HSELREGQ  <= 1'b0;
      HREADYINQ <= 1'b0;
    end
 else
    begin
      HADDRQ    <= HADDR[11:2];
      HTRANSQ   <= HTRANS;
      HWRITEQ   <= HWRITE;
      HSELREGQ  <= HSELREG;
      HREADYINQ <= HREADYIN;
    end
end






always @(HWRITEQ or HSELREGQ or HREADYINQ or HADDRQ or HWDATA or HTRANSQ)


//always @(posedge HCLK )
begin
//      if (HWRITE == 1'b1 && HSELREG == 1'b1 && HREADYIN == 1'b1)

if (HWRITEQ == 1'b1 && HSELREGQ== 1'b1 && HREADYINQ == 1'b1 && HTRANS[1]==1'b1)
    
 begin



  NextSMBIDCYR0    = SMBIDCYR0;
  NextSMBWST1R0    = SMBWST1R0;
  NextSMBWST2R0    = SMBWST2R0;
  NextSMBWSTOENR0  = SMBWSTOENR0;
  NextSMBWSTWENR0  = SMBWSTWENR0;
  NextSMBCR0       = SMBCR0;
  NextSMBIDCYR1    = SMBIDCYR1;
  NextSMBWST1R1    = SMBWST1R1;
  NextSMBWST2R1    = SMBWST2R1;
  NextSMBWSTOENR1  = SMBWSTOENR1;
  NextSMBWSTWENR1  = SMBWSTWENR1;
  NextSMBCR1       = SMBCR1;
  NextSMBIDCYR2    = SMBIDCYR2;
  NextSMBWST1R2    = SMBWST1R2;
  NextSMBWST2R2    = SMBWST2R2;
  NextSMBWSTOENR2  = SMBWSTOENR2;
  NextSMBWSTWENR2  = SMBWSTWENR2;
  NextSMBCR2       = SMBCR2;
  NextSMBIDCYR3    = SMBIDCYR3;
  NextSMBWST1R3    = SMBWST1R3;
  NextSMBWST2R3    = SMBWST2R3;
  NextSMBWSTOENR3  = SMBWSTOENR3;
  NextSMBWSTWENR3  = SMBWSTWENR3;
  NextSMBCR3       = SMBCR3;
  NextSMBIDCYR4    = SMBIDCYR4;
  NextSMBWST1R4    = SMBWST1R4;
  NextSMBWST2R4    = SMBWST2R4;
  NextSMBWSTOENR4  = SMBWSTOENR4;
  NextSMBWSTWENR4  = SMBWSTWENR4;
  NextSMBCR4       = SMBCR4;
  NextSMBIDCYR5    = SMBIDCYR5;
  NextSMBWST1R5    = SMBWST1R5;
  NextSMBWST2R5    = SMBWST2R5;
  NextSMBWSTOENR5  = SMBWSTOENR5;
  NextSMBWSTWENR5  = SMBWSTWENR5;
  NextSMBCR5       = SMBCR5;
  NextSMBIDCYR6    = SMBIDCYR6;
  NextSMBWST1R6    = SMBWST1R6;
  NextSMBWST2R6    = SMBWST2R6;
  NextSMBWSTOENR6  = SMBWSTOENR6;
  NextSMBWSTWENR6  = SMBWSTWENR6;
  NextSMBCR6       = SMBCR6;
  NextSMBIDCYR7    = SMBIDCYR7;
  NextSMBWST1R7    = SMBWST1R7;
  NextSMBWST2R7    = SMBWST2R7;
  NextSMBWSTOENR7  = SMBWSTOENR7;
  NextSMBWSTWENR7  = SMBWSTWENR7;
  NextSMBCR7       = SMBCR7;







      case (HADDRQ)
        10'b0000000000 :
        begin
          NextSMBIDCYR0    = HWDATA[3:0];
        end

        10'b0000000001 :
        begin
          NextSMBWST1R0    = HWDATA[4:0];
        end

        10'b0000000010 :
        begin
          NextSMBWST2R0    = HWDATA[4:0];
        end

        10'b0000000011 :
        begin
          NextSMBWSTOENR0  = HWDATA[3:0];
        end

        10'b0000000100 :
        begin
          NextSMBWSTWENR0  = HWDATA[3:0];
        end

        10'b0000000101 :
        begin
          NextSMBCR0       = HWDATA[7:0];
        end

        10'b0000000111 :
        begin
          NextSMBIDCYR1    = HWDATA[3:0];
        end

        10'b0000001000 :
        begin
          NextSMBWST1R1    = HWDATA[4:0];
        end

        10'b0000001001 :
        begin
          NextSMBWST2R1    = HWDATA[4:0];
        end

        10'b0000001010 :
        begin
          NextSMBWSTOENR1  = HWDATA[3:0];
        end

        10'b0000001011 :
        begin
          NextSMBWSTWENR1  = HWDATA[3:0];
        end

        10'b0000001100 :
        begin 
          NextSMBCR1       = HWDATA[7:0];
        end

        10'b0000001110 :
        begin
          NextSMBIDCYR2    = HWDATA[3:0];
        end

        10'b0000001111 :
        begin
          NextSMBWST1R2    = HWDATA[4:0];
        end

        10'b0000010000 :
        begin
          NextSMBWST2R2    = HWDATA[4:0];
        end

        10'b0000010001 :
        begin
          NextSMBWSTOENR2  = HWDATA[3:0];
        end

        10'b0000010010 :
        begin
          NextSMBWSTWENR2  = HWDATA[3:0];
        end

        10'b0000010011 :
        begin
          NextSMBCR2       = HWDATA[7:0];
        end

        10'b0000010101 :
        begin
          NextSMBIDCYR3    = HWDATA[3:0];
        end

        10'b0000010110 :
        begin
          NextSMBWST1R3    = HWDATA[4:0];
        end

        10'b0000010111 :
        begin
          NextSMBWST2R3    = HWDATA[4:0];
        end

        10'b0000011000 :
        begin
          NextSMBWSTOENR3  = HWDATA[3:0];
        end

        10'b0000011001 :
        begin
          NextSMBWSTWENR3  = HWDATA[3:0];
        end

        10'b0000011010 :
        begin
          NextSMBCR3       = HWDATA[7:0];
        end

        10'b0000011100 :
        begin
          NextSMBIDCYR4    = HWDATA[3:0];
        end

        10'b0000011101 :
        begin
          NextSMBWST1R4    = HWDATA[4:0];
        end

        10'b0000011110 :
        begin
          NextSMBWST2R4    = HWDATA[4:0];
        end

        10'b0000011111 :
        begin
          NextSMBWSTOENR4  = HWDATA[3:0];
        end

        10'b0000100000 :
        begin
          NextSMBWSTWENR4  = HWDATA[3:0];
        end

        10'b0000100001 :
        begin
          NextSMBCR4       = HWDATA[7:0];
        end

        10'b0000100011 :
        begin
          NextSMBIDCYR5    = HWDATA[3:0];
        end

        10'b0000100100 :
        begin
          NextSMBWST1R5    = HWDATA[4:0];
        end

        10'b0000100101 :
        begin
          NextSMBWST2R5    = HWDATA[4:0];
        end

        10'b0000100110 :
        begin
          NextSMBWSTOENR5  = HWDATA[3:0];
        end

        10'b0000100111 :
        begin
          NextSMBWSTWENR5  = HWDATA[3:0];
        end

        10'b0000101000 :
        begin
          NextSMBCR5       = HWDATA[7:0];
        end

        10'b0000101010 :
        begin
          NextSMBIDCYR6    = HWDATA[3:0];
        end

        10'b0000101011 :
        begin
          NextSMBWST1R6    = HWDATA[4:0];
        end

        10'b0000101100 :
        begin
          NextSMBWST2R6    = HWDATA[4:0];
        end

        10'b0000101101 :
        begin
          NextSMBWSTOENR6  = HWDATA[3:0];
        end

        10'b0000101110 :
        begin
          NextSMBWSTWENR6  = HWDATA[3:0];
        end

        10'b0000101111 :
        begin
          NextSMBCR6       = HWDATA[7:0];
        end

        10'b0000110001 :
        begin
          NextSMBIDCYR7    = HWDATA[3:0];
        end

        10'b0000110010 :
        begin
          NextSMBWST1R7    = HWDATA[4:0];
        end

        10'b0000110011 :
        begin
          NextSMBWST2R7    = HWDATA[4:0];
        end

        10'b0000110100 :
        begin
          NextSMBWSTOENR7  = HWDATA[3:0];
        end

        10'b0000110101 :
        begin
          NextSMBWSTWENR7  = HWDATA[3:0];
        end

        10'b0000110110 :
        begin
          NextSMBCR7 = HWDATA[7:0];
        end

        default            : ;
      endcase
 end
end //of always block


always @(posedge HCLK or negedge HRESETn)
begin : p_RegWrSeq
  if (HRESETn == 1'b0)
    begin
      SMBIDCYR0        <= 4'b1111;
      SMBWST1R0        <= 5'b11111;
      SMBWST2R0        <= 5'b11111;
      SMBWSTOENR0      <= 4'b0000;
      SMBWSTWENR0      <= 4'b0001;
      SMBCR0           <= 8'b10000000;
      SMBIDCYR1        <= 4'b1111;
      SMBWST1R1        <= 5'b11111;
      SMBWST2R1        <= 5'b11111;
      SMBWSTOENR1      <= 4'b0000;
      SMBWSTWENR1      <= 4'b0001;
      SMBCR1           <= 8'b00000000;
      SMBIDCYR2        <= 4'b1111;
      SMBWST1R2        <= 5'b11111;
      SMBWST2R2        <= 5'b11111;
      SMBWSTOENR2      <= 4'b0000;
      SMBWSTWENR2      <= 4'b0001;
      SMBCR2           <= 8'b01000000;
      SMBIDCYR3        <= 4'b1111;
      SMBWST1R3        <= 5'b11111;
      SMBWST2R3        <= 5'b11111;
      SMBWSTOENR3      <= 4'b0000;
      SMBWSTWENR3      <= 4'b0001;
      SMBCR3           <= 8'b00000000;
      SMBIDCYR4        <= 4'b1111;
      SMBWST1R4        <= 5'b11111;
      SMBWST2R4        <= 5'b11111;
      SMBWSTOENR4      <= 4'b0000;
      SMBWSTWENR4      <= 4'b0001;
      SMBCR4           <= 8'b10000000;
      SMBIDCYR5        <= 4'b1111;
      SMBWST1R5        <= 5'b11111;
      SMBWST2R5        <= 5'b11111;
      SMBWSTOENR5      <= 4'b0000;
      SMBWSTWENR5      <= 4'b0001;
      SMBCR5           <= 8'b10000000;
      SMBIDCYR6        <= 4'b1111;
      SMBWST1R6        <= 5'b11111;
      SMBWST2R6        <= 5'b11111;
      SMBWSTOENR6      <= 4'b0000;
      SMBWSTWENR6      <= 4'b0001;
      SMBCR6           <= 8'b01000000;
      SMBIDCYR7        <= 4'b1111;
      SMBWST1R7        <= 5'b11111;
      SMBWST2R7        <= 5'b11111;
      SMBWSTOENR7      <= 4'b0000;
      SMBWSTWENR7      <= 4'b0001;
      SMBCR7           <= 8'b00000000;
    end
  else
begin
      SMBIDCYR0        <= NextSMBIDCYR0;
      SMBWST1R0        <= NextSMBWST1R0;
      SMBWST2R0        <= NextSMBWST2R0;
      SMBWSTOENR0      <= NextSMBWSTOENR0;
      SMBWSTWENR0      <= NextSMBWSTWENR0;
      SMBCR0           <= NextSMBCR0;
      SMBIDCYR1        <= NextSMBIDCYR1;
      SMBWST1R1        <= NextSMBWST1R1;
      SMBWST2R1        <= NextSMBWST2R1;
      SMBWSTOENR1      <= NextSMBWSTOENR1;
      SMBWSTWENR1      <= NextSMBWSTWENR1;
      SMBCR1           <= NextSMBCR1;
      SMBIDCYR2        <= NextSMBIDCYR2;
      SMBWST1R2        <= NextSMBWST1R2;
      SMBWST2R2        <= NextSMBWST2R2;
      SMBWSTOENR2      <= NextSMBWSTOENR2;
      SMBWSTWENR2      <= NextSMBWSTWENR2;
      SMBCR2           <= NextSMBCR2;
      SMBIDCYR3        <= NextSMBIDCYR3;
      SMBWST1R3        <= NextSMBWST1R3;
      SMBWST2R3        <= NextSMBWST2R3;
      SMBWSTOENR3      <= NextSMBWSTOENR3;
      SMBWSTWENR3      <= NextSMBWSTWENR3;
      SMBCR3           <= NextSMBCR3;
      SMBIDCYR4        <= NextSMBIDCYR4;
      SMBWST1R4        <= NextSMBWST1R4;
      SMBWST2R4        <= NextSMBWST2R4;
      SMBWSTOENR4      <= NextSMBWSTOENR4;
      SMBWSTWENR4      <= NextSMBWSTWENR4;
      SMBCR4           <= NextSMBCR4;
      SMBIDCYR5        <= NextSMBIDCYR5;
      SMBWST1R5        <= NextSMBWST1R5;
      SMBWST2R5        <= NextSMBWST2R5;
      SMBWSTOENR5      <= NextSMBWSTOENR5;
      SMBWSTWENR5      <= NextSMBWSTWENR5;
      SMBCR5           <= NextSMBCR5;
      SMBIDCYR6        <= NextSMBIDCYR6;
      SMBWST1R6        <= NextSMBWST1R6;
      SMBWST2R6        <= NextSMBWST2R6;
      SMBWSTOENR6      <= NextSMBWSTOENR6;
      SMBWSTWENR6      <= NextSMBWSTWENR6;
      SMBCR6           <= NextSMBCR6;
      SMBIDCYR7        <= NextSMBIDCYR7;
      SMBWST1R7        <= NextSMBWST1R7;
      SMBWST2R7        <= NextSMBWST2R7;
      SMBWSTOENR7      <= NextSMBWSTOENR7;
      SMBWSTWENR7      <= NextSMBWSTWENR7;
      SMBCR7           <= NextSMBCR7;
    end
end // p_RegWrSeq;



always @(posedge HCLK)
begin
if ((HWRITE == 1'b0) && (HSELSMC ==1'b1) && (HREADYIN == 1'b1))
  begin
    case (HADDR[28:26])

    3'b000 :
      begin
        WST1[4:0]     <= SMBWST1R0[4:0];
        WST2[4:0]     <= SMBWST2R0[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR0[3:0];
        MW[1:0]       <=SMBCR0[7:6];
        BM            <=SMBCR0[5];
      end

    3'b001 :
      begin
        WST1[4:0]     <= SMBWST1R1[4:0];
        WST2[4:0]     <= SMBWST2R1[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR1[3:0];
        MW[1:0]       <= SMBCR1[7:6];
        BM            <= SMBCR1[5];
      end

    3'b010 :
      begin
        WST1[4:0]     <= SMBWST1R2[4:0];
        WST2[4:0]     <= SMBWST2R2[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR2[3:0];
        MW[1:0]       <= SMBCR2[7:6];
        BM            <= SMBCR2[5];
      end

    3'b011 :
      begin
        WST1[4:0]     <= SMBWST1R3[4:0];
        WST2[4:0]     <= SMBWST2R3[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR3[3:0];
        MW[1:0]       <= SMBCR3[7:6];
        BM            <= SMBCR3[5];
      end

    3'b100 :
      begin
        WST1[4:0]     <= SMBWST1R4[4:0];
        WST2[4:0]     <= SMBWST2R4[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR4[3:0];
        MW[1:0]       <= SMBCR4[7:6];
        BM            <= SMBCR4[5];
      end

    3'b101 :
      begin
        WST1[4:0]     <= SMBWST1R5[4:0];
        WST2[4:0]     <= SMBWST2R5[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR5[3:0];
        MW[1:0]       <= SMBCR5[7:6];
        BM            <= SMBCR5[5];
      end

    3'b110 :
      begin
        WST1[4:0]     <= SMBWST1R6[4:0];
        WST2[4:0]     <= SMBWST2R6[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR6[3:0];
        MW[1:0]       <= SMBCR6[7:6];
        BM            <= SMBCR6[5];
      end
    3'b111 :
      begin
        WST1[4:0]     <= SMBWST1R7[4:0];
        WST2[4:0]     <= SMBWST2R7[4:0];
        WSTOEN[3:0]   <= SMBWSTOENR7[3:0];
        MW[1:0]       <= SMBCR7[7:6];
        BM            <= SMBCR7[5];
      end
    endcase
  end
end

always @(posedge HCLK)
begin
 if ((HWRITE == 1'b0) && (HSELSMC ==1'b1) && (HREADYIN == 1'b1))
  begin
    case (HADDR[28:26])

    3'b000 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR0[3:0];
      end

    3'b001 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR1[3:0];
      end

    3'b010 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR2[3:0];
      end

    3'b011 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR3[3:0];
      end

    3'b100 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR4[3:0];
      end

    3'b101 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR5[3:0];
      end

    3'b110 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR6[3:0];
      end

    3'b111 :
      begin
        wait(~HCLK);
        wait(HCLK);
        IDCY[3:0]     <= SMBIDCYR7[3:0];
      end

    endcase
  end
end









// Beat1 indicates incrementing type of burst
// Beat2 indicates wrapping type burst
/* this discrimnation is required cause there shall be cases where wrapping burst had to be taken care in READ Xfers because of Quad Boundary condition  . Take example of INCR4 and WRAP 4 burst starting from addr 10 . In this case it shall behave in different manner for both the cases . to be more elaborate in case of wrap 4 it shall wrap back to same boundary so there shall be wst1 followed by   WST2 but in case of INCR4 it shall be WST1 followed by WST2 ,WST1,WST2 */



// check wheter there isa  sighnal which tells that a burst is comming

always@(HBURST)
 begin

    case(HBURST[2:0])
    3'b000 :
      begin
       Beat1 = 5'b00001;
      end

    3'b001 :
      begin 
       Beat1 = 5'b00001;     
      end

    3'b010 :
      begin
       Beat2 = 5'b00100;
      end

    3'b011 :
      begin
       Beat1 = 5'b00100;
      end

    3'b100 :
      begin
       Beat2 = 5'b01000;
      end

    3'b101 :
      begin
       Beat1 = 5'b01000;
      end

    3'b110 :
      begin
       Beat2 = 5'b10000;
      end
 
    3'b111 :
      begin 
       Beat1 = 5'b10000;
      end
    endcase
 end



always@(HSIZE)
 begin
    
    case(HSIZE[2:0])
    3'b000 :
      begin
       HS= 6'b001000;
      end

    3'b001 :
      begin
       HS = 6'b010000;
      end

    3'b010 :
      begin
       HS = 6'b100000;
      end

    3'b011 :
      begin
       $display (" ERROR HSIZE value greater then 32 bits"); 
      end

    3'b100 :
      begin
       $display (" ERROR HSIZE value greater then 32 bits");
      end

    3'b101 :
      begin
       $display (" ERROR HSIZE value greater then 32 bits");
      end

    3'b110 :
      begin
       $display (" ERROR HSIZE value greater then 32 bits");
      end

    3'b111 :
      begin
       $display (" ERROR HSIZE value greater then 32 bits");
      end
    endcase
 end



always@(MW)
 begin
    case(MW[1:0])
    2'b00 :
      begin
       MSIZE= 6'b001000;
      end

    2'b01 :
      begin
       MSIZE = 6'b010000;
      end
 
    2'b10 :
      begin
       MSIZE = 6'b100000;
      end
 
    2'b11 :
      begin
       $display (" ERROR in Programing the Memory Size");
      end
    endcase
 end

// initial qualifiers defined here
    
   initial 
   begin
      HREADYOUTPr      <= 1'b1;
      NewBankFlag      <= 1'b0;

      SMBIDCYR0        <= 4'b1111;
      SMBWST1R0        <= 5'b11111;
      SMBWST2R0        <= 5'b11111;
      SMBWSTOENR0      <= 4'b0000;
      SMBWSTWENR0      <= 4'b0001;
      SMBCR0           <= 8'b10000000;
      SMBIDCYR1        <= 4'b1111;
      SMBWST1R1        <= 5'b11111;
      SMBWST2R1        <= 5'b11111;
      SMBWSTOENR1      <= 4'b0000;
      SMBWSTWENR1      <= 4'b0001;
      SMBCR1           <= 8'b00000000;
      SMBIDCYR2        <= 4'b1111;
      SMBWST1R2        <= 5'b11111;
      SMBWST2R2        <= 5'b11111;
      SMBWSTOENR2      <= 4'b0000;
      SMBWSTWENR2      <= 4'b0001;
      SMBCR2           <= 8'b01000000;
      SMBIDCYR3        <= 4'b1111;
      SMBWST1R3        <= 5'b11111;
      SMBWST2R3        <= 5'b11111;
      SMBWSTOENR3      <= 4'b0000;
      SMBWSTWENR3      <= 4'b0001;
      SMBCR3           <= 8'b00000000;
      SMBIDCYR4        <= 4'b1111;
      SMBWST1R4        <= 5'b11111;
      SMBWST2R4        <= 5'b11111;
      SMBWSTOENR4      <= 4'b0000;
      SMBWSTWENR4      <= 4'b0001;
      SMBCR4           <= 8'b10000000;
      SMBIDCYR5        <= 4'b1111;
      SMBWST1R5        <= 5'b11111;
      SMBWST2R5        <= 5'b11111;
      SMBWSTOENR5      <= 4'b0000;
      SMBWSTWENR5      <= 4'b0001;
      SMBCR5           <= 8'b10000000;
      SMBIDCYR6        <= 4'b1111;
      SMBWST1R6        <= 5'b11111;
      SMBWST2R6        <= 5'b11111;
      SMBWSTOENR6      <= 4'b0000;
      SMBWSTWENR6      <= 4'b0001;
      SMBCR6           <= 8'b01000000;
      SMBIDCYR7        <= 4'b1111;
      SMBWST1R7        <= 5'b11111;
      SMBWST2R7        <= 5'b11111;
      SMBWSTOENR7      <= 4'b0000;
      SMBWSTWENR7      <= 4'b0001;
      SMBCR7           <= 8'b00000000;
      LatchHADDR       <= 3'b000;

   end


/* this block is to take care basically of turn around cycles cause when ever there is a read xfer from write, turn around time is 2 by default . supposose IDCY and WST is zero and there is a transition from write to read then HREADY will remain low for 3 clk cycles but suppose there is a access to same bank in betweenburst reads and there also IDCY and WST are zero then there HREADY will go low for 2 clk cycles which is default low period . So in oder to take care of this i have taken the signal know as Flag which is given value 1 during read xfers so tthat nxt access is taken care of proper IDCY cnts . The signal NewBankFlag is used to indicate that there is a BANKCROSS OVER so that proper values of IDCY are loaded */






// still HSELSMC has been not tested under all possible cases

always @(posedge HWRITE or negedge HSELSMC)
begin
  if (HWRITE == 1'b1 ||  HSELSMC == 1'b0)
    begin
     Flag <= 1'b0;
     NewBankFlag <= 1'b0;
    end

end // end of always block



always @( posedge HCLK )
begin
   if ( HTRANS[1] == 1'b1 )
     LatchHADDR <= HADDR[28:26];
end // end of always block
    

always @ (HADDR [28:26] && HTRANS[1] == 1'b1)

begin
  if (HTRANS == 2'b10  && Flag == 1'b1  && LatchHADDR != HADDR[28:26]) 
     begin
       NewBankFlag = 1'b1;
     end
end // end of always block




/*  the logic behind this block is that if  NewBankFlag is set then only we shall know that there is a bankcrossover and IDCY bits have to be read . Flag = 0 indicates that request have come from write to read change so standard turnaround of 2 to be taken and if Flag is 1 then if acess to same bank i.e NewBankFlag is zero then IDCY bits have to be ignored */

always @ (HCLK)
begin
   if (HWRITE == 1'b0 && HTRANS == 2'b10 && HREADYOUTPr == 1'b1)
      begin
        if (NewBankFlag == 1'b1)
           begin
             IDCYCnt =  1'b1 + IDCY;
           end
        else if (NewBankFlag == 1'b0 && Flag == 1'b0)
           begin
             IDCYCnt = 1'b1;
           end
        else if (NewBankFlag == 1'b0 && Flag == 1'b1)
           begin
             IDCYCnt = 1'b0;
           end

      end
end


// this block was added bcoz i was facing trouble ahead when the hsize was chang
// ing in betwween when nseq was there in line but the transaction for seq was y// yet to be completed  so qualified this condition to be sampled only with stat// state flag condition

always @ (posedge HTRANS[1])
begin
  if (StateFlag == 2'b01 && HTRANS[1] == 1'b1)//change made here htrans mase seq
    begin
        if (HS == MSIZE)
            FlagEq = 1'b1;
        else if (HS == (2'b10 * MSIZE))
            FlagGt2 = 1'b1;
        else if (HS == (3'b100 * MSIZE))
            FlagGt4 = 1'b1;
        else if (MSIZE == (2'b10 * HS))
            FlagLt2 = 1'b1;
        else if (MSIZE == (3'b100 * HS))
            FlagLt4 = 1'b1;
   end
end






/* the basic idea of this block is that if SMWAIT goes low we know that HREADYOUTPrshall  maintain its state so when SMWAIT gets high flush the respective counters from values that was originally loaded (WST1 and WST2) and load it with 3 clock period cause that is the time after which HREADYOUTPr goes high . IN this idea of takin as default value of 3 is that it takes 2 clk pulse for SMWAIT to get sync up and on 3 clock edge read is done by SMC  */

/* For case when HSIZE = 4 MIZE i have defined 4 counters cause i needed to flush the individual counters when ever SMWAIT used to go low cause if i had taken asingle counter then it would have to be flushed  and after that only one read was possible where as i have to do 4 reads . therefore i have to take care that out of these 4 reads the read that was going on and SMWAIT goes low the counter in corrospondence with that read have to be flushed out . Moreever the counters r being checked in a when sync manner */


// here till now no use of WaitFlag is being done in code

always @ (HCLK)
begin
       if (IDCYCnt == 1'b0)
          begin
            if ( ( SMBUSGNT == 1'b1) && (SMBUSREQ == 1'b1))
                begin
                  GntFlag = 1'b1;
                    if (SMWAIT == 1'b1)
                         begin
                          WaitFlag = 1'b1;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagEq == 1'b1 && StateFlag == 2'b10)
                         begin
                          WaitFlag = 1'b0;
                          FrstReadCntEq  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagEq == 1'b1  && StateFlag == 2'b11)
                         begin
                          WaitFlag = 1'b0;
                          FastReadCntEq  = 2'b11;
                          SlowReadCntEq  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagLt2 == 1'b1 && StateFlag == 2'b10)
                         begin
                          WaitFlag = 1'b0;
                          FrstReadCntLt2  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagLt2 == 1'b1 && StateFlag == 2'b11)
                         begin
                          WaitFlag = 1'b0;
                          FastReadCntLt2  = 2'b11;
                          SlowReadCntLt2  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagLt4 == 1'b1 && StateFlag == 2'b10)
                         begin
                          WaitFlag = 1'b0;
                          FrstReadCntLt4  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagLt4 == 1'b1 && StateFlag == 2'b11)
                         begin
                          WaitFlag = 1'b0;
                          FastReadCntLt4  = 2'b11;
                          SlowReadCntLt4  = 2'b11;
                         end
                    else
                    if (SMWAIT == 1'b0 && FlagGt4 == 1'b1 && StateFlag == 2'b10)
                         begin
                          WaitFlag = 1'b0;
                           if ( FastReadCntGt4_3 == 1'b0 && FastReadCntGt4_2 ==                                 1'b0  && FrstReadCntGt4_1 == 1'b0)
                             begin
                               FastReadCntGt4_4     = (2'b11); 
                             end
                           
                           else 
                           if ( FastReadCntGt4_2 == 1'b0  && FrstReadCntGt4_1 ==                               1'b0)
                             begin
                               FastReadCntGt4_3     = (2'b11);
                             end

                           else 
                           if (  FrstReadCntGt4_1 == 1'b0)
                             begin
                               FastReadCntGt4_2     = (2'b11);
                             end


                           else
                             begin
                               FrstReadCntGt4_1     = (2'b11);
                             end
                       
                         end

                    else
                    if (SMWAIT == 1'b0 && FlagGt4 == 1'b1 && StateFlag == 2'b11)
                         begin
                          WaitFlag = 1'b0;
                           if ( FastReadCntGt4_3 == 1'b0 && FastReadCntGt4_2 ==                                 1'b0  && FrstReadCntGt4_1 == 1'b0)
                             begin
                               FastReadCntGt4_4     = (2'b11);
                             end
                           
                           else 
                           if ( FastReadCntGt4_2 == 1'b0  && FrstReadCntGt4_1 ==                               1'b0)
                             begin
                               FastReadCntGt4_3     = (2'b11);
                             end

                           else
                           if (  FrstReadCntGt4_1 == 1'b0)
                             begin
                               FastReadCntGt4_2     = (2'b11);
                             end
                    else
                    if (SMWAIT == 1'b0 && FlagGt2 == 1'b1 && StateFlag == 2'b10)
                         begin
                          WaitFlag = 1'b0;
                           if (  FrstReadCntGt2_1 == 1'b0)
                             begin
                               FastReadCntGt2_2     = (2'b11);
                             end


                           else
                             begin
                               FrstReadCntGt2_1     = (2'b11);
                             end

                         end
                    else
                    if (SMWAIT == 1'b0 && FlagGt2 == 1'b1 && StateFlag == 2'b11)
                         begin
                          WaitFlag = 1'b0;
                           if ( FastReadCntGt2_2 == 1'b0 )
                             begin
                               FastReadCntGt2_3     = (2'b11);
                               FastReadCntGt2_4     = (2'b11);
                             end

                           else
                             begin
                               FastReadCntGt2_2     = (2'b11);
                             end


                         end




                           else
                             begin
                               FrstReadCntGt4_1     = (2'b11);
                             end

                         end



                end
            else
                  GntFlag = 1'b0;
          end // end of condition for idcy cnt
end













// this block is mainly used to load the counters that shall be used to control //the operation of HREADYOUTPr which is the mirror signal of HREADYOUT
// different cases has been taken here to calculate the counters values
//actually the delay period for hready for burst devices mainly depends upon the// follwing factors
//HSIZE , MSIZE and QUADBOUNDARY Conditions which comes into picture for        // BURSTROM 
// let me try to explin the basic idea of taking different counters
//FrstReadCnt**: here ** are suffix indicating the case. this counter is used to//               calculate the period for which HREADYOUTPR should be low during//               NSEQ
//QuadBounCnt**:here ** are suffix indicating the case. This Counter keeps track//              of page cross over Condition and once page has crossed for BURST//              ROM it loads SLOW WAIT states for read operation
//ReadyCntHigh : This counter is used to Calculate the HREADyOUTPr period it    //              should be high after first nseq xfer. this counter is especially//              needed because for MSIZE > HSIZE HREADYOUT going first high     //              depends upon the starting address put on HADDR 
//FastReadCnt** :here ** are suffix indicating the case.it indicates that depend//              ing upon quad boundary WST2 is loaded to make HREADYOUTPr low
//SlowReadCnt** :here ** are suffix indicating the case.it indicates that depend
//              ing upon quad boundary WST1 is loaded to make HREADYOUTPr low
//ReadyCntHighSeq: used to make HREADYOUTPr high durning SEQ 's

/* these wait state counters for First read (FrstReadCnt**) are very much depended on HSIZE . for xample if hsize is twice the msize first read can start from memory location 00 or 10 and if HSIZE is 4times MSIZE then starting access can only be through location 00. */

/* StartAddr indicates the starting Addr for SMCS . this is basically requried  to know when we r hitting the quad boundaries */

/* When MSIZE > HSIZE we also require to know wat is the adress supplied by HADDR lines since if it not alligned to memory address that data would not be picked . for example let us take the case when msize is 4 times hsize . if hsize and msize are properly alligned ( by this i mean ADDRESS)  then HREADYOUT will he    high for clock cycles depending upon the HADDR  as it shall be picking 8 bit data evey clock cycles . there fore HREADYOUTPr also depends upon the HADDDR when MSIZE > HSIZE  */






/* here as soon as NSEQ is sampled when HREADYOUTPr is high evry counters are resetStateFlag = 2'b00 indicates that HWRITE has gone low and HREADYOUTPr should go low StateFlag = 2'b01 indicates the time for either TURNAROUND or FrstReadCnt** .   also since this StateFlag Condition is achieved only one clock later when HREADYOUTPr has gone low this stae is idle to sample the MSIZE , HSIZE , WST1 , WST2, and is therefore used to load Frst read counters in accordance with diff cases     StateFlag = 2'b10  indicates the the period when FrstReadCnt r decremented
StateFlag = 2'b11  indicates Seq Xfer */


/*ReadyCntHighSeq counter is loaded at time when Seq r going on and HREADY goes low . Also there is one more point to take care off . That is since HREADYOUTPr is going high for 2 clock cycles we need to re load our counters only during last clk cycle in which HREADY  is high therfore we have introduced  a delay of 1 clk to load the counters . This condition need to taken care off */










always @ (HTRANS or HREADYOUTPr or HWRITE or StateFlag)
begin
      if ((HTRANS == 2'b10) && (HWRITE ==1'b0) && (HREADYOUTPr == 1'b1)) //indic //     ating NSEQ
       begin
         StateFlag            <= 2'b00;
         StartAddr00          <= 1'b0;
         StartAddr01          <= 1'b0;
         StartAddr10          <= 1'b0;
         StartAddr11          <= 1'b0;
         FlagEq               <= 1'b0;
         FlagGt2              <= 1'b0;
         FlagGt4              <= 1'b0;
         FlagLt2              <= 1'b0;
         FlagLt4              <= 1'b0;
         ReadyCntHigh         <= 1'b0;
         ReadyCntHighSeq      <= 1'b0;
         FrstReadCntEq        <= 1'b0;
         FrstReadCntLt2       <= 1'b0;
         FrstReadCntLt4       <= 1'b0;
         FrstReadCntGt4_1     <= 1'b0;   
         FastReadCntGt4_2     <= 1'b0;
         FastReadCntGt4_3     <= 1'b0;
         FastReadCntGt4_4     <= 1'b0;
         FrstReadCntGt2_1     <= 1'b0;  
         FastReadCntGt2_2     <= 1'b0;
         FastReadCntGt2_3     <= 1'b0;
         FastReadCntGt2_4     <= 1'b0;


         FastReadCntEq        <= 1'b0; 
         SlowReadCntEq        <= 1'b0;
         FastReadCntLt2       <= 1'b0;
         SlowReadCntLt2       <= 1'b0;
         FastReadCntLt4       <= 1'b0;
         SlowReadCntLt4       <= 1'b0;
         QuadBounCntEq        <= 1'b0;
         QuadBounCntLt2       <= 1'b0; 
         QuadBounCntLt4       <= 1'b0;
         QuadBounCntGt2       <= 1'b0;


       end
      else if ( StateFlag == 2'b01 && HTRANS[1] == 1'b1)

       begin 
          wait (HCLK);
         if (HS == MSIZE) 
           begin
            FrstReadCntEq         <= (2'b01 + WST1);
           end
         else if (HS == (2'b10 * MSIZE))
           begin
             FrstReadCntGt2_1      <= (2'b01 + WST1);
             FastReadCntGt2_2      <= (1'b1  + WST2);
             QuadBounCntGt2        <= 1'b0;
           end 
         else if (HS == ( 3'b100 * MSIZE))
           begin
             FrstReadCntGt4_1     <= (2'b01 + WST1);
             FastReadCntGt4_2     <= (1'b1  + WST2);
             FastReadCntGt4_3     <= (1'b1  + WST2);
             FastReadCntGt4_4     <= (1'b1  + WST2);  
           end 
         else if (MSIZE == (2'b10 * HS ))
           begin
             FrstReadCntLt2       <= ((2'b01 + WST1));
                 
                if ( HS == 5'b01000 )
                   begin
                     if (HADDR [0] == 1'b0)
                        begin
                           ReadyCntHigh            <= 3'b001;
                        end
                     else if (HADDR [0] == 1'b1)
                        begin
                           ReadyCntHigh            <= 3'b010;
                        end
                   end
               else if ( HS == 5'b10000 )
                   begin
                     if (HADDR [1:0] == 2'b00)
                        begin
                           ReadyCntHigh            <= 3'b001;
                        end
                     else if (HADDR [1:0] == 2'b10)
                        begin 
                           ReadyCntHigh            <= 3'b010;
                        end
                   end
   
             end
         else if (MSIZE == ( 3'b100 * HS))
           begin
             FrstReadCntLt4       <= ((2'b10 + WST1));
               
                if ( HADDR [1:0] == 2'b00 )
                   begin
                     ReadyCntHigh                  <= 3'b001;
                   end
                else if (  HADDR [1:0] == 2'b01 )  
                   begin 
                     ReadyCntHigh                  <= 3'b100;
                   end
                else if (  HADDR [1:0] == 2'b10 ) 
                   begin
                     ReadyCntHigh                  <= 3'b011;
                   end
                else if (  HADDR [1:0] == 2'b11 ) 
                   begin
                     ReadyCntHigh                  <= 3'b010;
                   end 
           end

       end  // end of NSeq Conditions

      else
      if ((StateFlag == 2'b11) && (HREADYOUTPr ==1'b1)) //change done here
       begin

         if (MSIZE == HS) 
           begin 
            FastReadCntEq         <=  WST2;
            SlowReadCntEq         <=  WST1;
           end
         else if(HS == (2'b10 * MSIZE))
           begin
             FastReadCntGt2_2     <= (1'b1  + WST2);
             FastReadCntGt2_3     <= ( WST2);
             FastReadCntGt2_4     <= ( WST1);
           end
         else if (HS == ( 3'b100 * MSIZE))
           begin
             FrstReadCntGt4_1     <= (WST1);
             FastReadCntGt4_2     <= (1'b1  + WST2);
             FastReadCntGt4_3     <= (1'b1  + WST2);                           
             FastReadCntGt4_4     <= (1'b1  + WST2);
           end
         else if (MSIZE == (2'b10 * HS ) && ReadyCntHigh == 3'b000)
           begin
              FastReadCntLt2      <= ( 2'b10 + WST2);
              SlowReadCntLt2      <= ( 2'b10 + WST1);
           end
         else if (MSIZE == (2'b10 * HS ) && ReadyCntHighSeq == 3'b001)
           begin
              wait (~HCLK); 
              wait (HCLK);
              FastReadCntLt2      <= ( 2'b10 + WST2);
              SlowReadCntLt2      <= ( 2'b10 + WST1);
           end

         else if (MSIZE == (3'b100 * HS ) && ReadyCntHighSeq == 3'b001)
           begin
              wait (~HCLK); // yet to be tested may be it can be 3 clks also
              wait (HCLK); // yet to be  tested 
              FastReadCntLt4      <= ( 2'b10 + WST2); 
              SlowReadCntLt4      <= ( 2'b10 + WST1); 
           end

       end  // end of Seq Conditions

      else
      if ((StateFlag == 2'b11) && (HREADYOUTPr ==1'b0)) //change done here
       begin
         if (MSIZE == (2'b10 * HS ))
             ReadyCntHighSeq      =  3'b010;
         else if (MSIZE == (3'b100 * HS ))
              ReadyCntHighSeq      =  3'b100;
       end  // end of Seq Conditions

end   // end of always block

/* This ReadFlag was introduced bcoz there was a condition where HWRITE was    going high even though the current xfer was not complete so to take care of that Read Flag was intoduced  */


always @ ( HWRITE or HREADYOUTPr or HTRANS)
begin
  if (HWRITE == 1'b0 && HREADYOUTPr == 1'b1 && HTRANS ==2'b10 )
      ReadFlag <= 1'b1;
  else if (HWRITE == 1'b1 && HREADYOUTPr == 1'b1 && HTRANS == 2'b10)
      ReadFlag <= 1'b0;
end


/* this condition is still under test to take care of condition when HSELSMC has gone low and still the pending seq xfer is yet to be complete */
// i have removed htrans from this palce and till now everything seem to work
always @ ( HWRITE or HREADYOUTPr or HSELSMC)
begin
  if (HREADYOUTPr == 1'b1)
     begin
       if (HWRITE == 1'b0 && HSELSMC == 1'b1 && HTRANS[1] == 1'b1 )
        begin
          SMCFlag <= 1'b1;
        end
       else if (HWRITE == 1'b1 && HSELSMC == 1'b1 && HTRANS[1] == 1'b1)
        begin
          SMCFlag <= 1'b0;
        end
    end
end



/* the Read Xfer logic starts below . Most of the points have been explained buta quick recap of general idea. The StateFlag is sort of state machine which tellwhich state the SMC is. As soon a NSEQ is samples when HREADYOUTPr is high the  State Flag is reset at 00. Therfore sensing StateFlag as 00 the HREADYOUTPr  signals goes low and the state changes to 01. AS State Flag reaches state 01 lot of things are calculated . This is the state where we are sure that correct       information is given by SMC cause the SMCS does a prefetch for one clock extraa and this state is also achieved one clk after HREADYOUTPr has gone low so the basic idea of this state is to calculate the various information from  SMCS . the information captured in this state are WST1, WST2  , MW, BM . Also this is the  state where IDCY period should start. ONCE the IDCY period is over the StateFlagwill start decrement the FrstReadCnt which contain WST1 information and move thestate machine to 10 state . On expiry of FrstReadCnt HREADYOUTPr is pulled high and StartAddr** valus are calculated from SMADDR lines based on MW of SMCS. ThisStartAddr** are helpful in calculating the QuadBoundary Conditions. Also the    StateFlag is moved to 11 which indicates commencemet of SEQ Xfer .Also QuadBoundCnt is moved everytime HREADYOUTPr goes high. This QuadBounCnt also helps to    check when there is page cross over and slow wait states that is WST1 has to be taken. So once when we are in state 11 we are supposed to do tansfers for SEQS  and to take WST1(SlowReadCnt) or WST2 (FastReadCnt) according to the Quad       Boundary Conditions  */

 
/* Whenever SMWAIT comes the respective counters of that particular state are    flushed and if HREADYOUTPr is low it shall keep low till SMWAIT goes high and  since those counters which were flushed out are overwritten with value three theHREADYOUTPr goes high after 3 clk pulse */










// read xfers start new logic

always @ (posedge HCLK )
begin
// if ((HSELSMC ==1'b1) && HTRANS[1]== 1'b1 && ReadFlag == 1'b1)
if ((HSELSMC ==1'b1 || SMCFlag == 1'b1) && HTRANS[1]== 1'b1 && ReadFlag == 1'b1)
 begin

         if (StateFlag == 2'b00)
               begin
                 HREADYOUTPr <= 1'b0;
                 NewBankFlag <=1'b0; // intoroduced new
                 StateFlag <= 2'b01;
               end
         else if ( StateFlag == 2'b01 && IDCYCnt > 0) // change && HS == MSIZE)
               begin
                   HREADYOUTPr <= 1'b0;
                   IDCYCnt <= IDCYCnt - 1'b1;
                   Flag <= 1'b1;
               end
         else if (IDCYCnt == 0 && HREADYOUTPr == 1'b0 && SMBUSGNT == 1'b1                        && SMBUSREQ == 1'b1 && FlagEq == 1'b1  && StateFlag != 2'b11)
               begin
                       if (SMWAIT == 1'b1)
                         begin
                           if (FrstReadCntEq == 0)    
                            begin
                             if (StateFlag == 2'b10)
                              begin
                              HREADYOUTPr <= 1'b1;
                              QuadBounCntEq <=QuadBounCntEq + 1'b1 ;
                              StateFlag <= 2'b11;
                              if (( SMADDR[1:0]==2'b00) || ( SMADDR[2:1]==2'b00)                                 ||(SMADDR[3:2]==   2'b00))
                                    begin
                                      StartAddr00 <= 1'b1;
                                    end

                              if (( SMADDR[1:0]==2'b01) || ( SMADDR[2:1]==2'b01)                                 || (SMADDR[3:2]==   2'b01))
                                    begin
                                      StartAddr01 <= 1'b1;
                                    end


                             if (( SMADDR[1:0]==2'b10) || ( SMADDR[2:1]==2'b10)                                 || (SMADDR[3:2]==    2'b10))
                                    begin
                                      StartAddr10 <= 1'b1;
                                    end

                              if (( SMADDR[1:0]==2'b11) || ( SMADDR[2:1]==2'b11)                                 || (SMADDR[3:2]==   2'b11))
                                    begin
                                      StartAddr11 <= 1'b1;
                                    end
                              end // end of condition when stateflag = 2 
                            end // end of condition when first read Cnt
                           else // when frst read cnt is not zero
                            begin
                              HREADYOUTPr <= 1'b0;
                              FrstReadCntEq <= FrstReadCntEq - 1'b1;
                              StateFlag <= 2'b10;  // change made here
                            end
                         end // end of condition for SMWAIT = 1
                       else if (SMWAIT== 1'b0 )
                            begin
                              HREADYOUTPr <= 1'b0;
                            end
               end // end of nseq when hsize = msize

         else if(FrstReadCntEq == 0 && StateFlag == 2'b11  && BM ==1'b1                        && FlagEq == 1'b1 && GntFlag ==1'b1)
               begin
                 if (StartAddr00 == 1'b1)
                   begin
                     if (QuadBounCntEq == 2'b00)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntEq <= SlowReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq == 0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                   end // end of condition when starting address was 00

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 != 5'b00100))//not  wrap 4
                   begin
                     if (QuadBounCntEq == 2'b11)
                       begin  // quad bnd condition start
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntEq <= SlowReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                   end // end of condition when starting address was 01

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 == 5'b00100))//  wrap 4
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                   end // end of condition when starting address was 01


                 else
                 if (StartAddr10 == 1'b1 && (Beat2 != 5'b00100))//not  wrap 4
                   begin
                     if (QuadBounCntEq == 2'b10)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntEq <= SlowReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                   end // end of condition when starting address was 10

                 else
                 if (StartAddr10 == 1'b1 && (Beat2 == 5'b00100))//  wrap 4
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                   end // end of condition when starting address was 10


                 else
                 if (StartAddr11 == 1'b1 && (Beat2 != 5'b00100))//not  wrap 4
                   begin
                     if (QuadBounCntEq == 2'b01)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntEq <= SlowReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                   end // end of condition when starting address was 11

                 else
                 if (StartAddr11 == 1'b1 && (Beat2 == 5'b00100))//  wrap 4
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntEq ==1'b0)
                               begin
                                 HREADYOUTPr <= 1'b1;
                                 QuadBounCntEq  <=QuadBounCntEq + 1'b1;
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntEq <= FastReadCntEq - 1'b1;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end

                   end // end of condition when starting address was 11
               end // end of seq xfers for case when HSIZE = MSIZE





             // beggining of case when MSIZE = 2HSIZE and NSEQ

         else if (IDCYCnt == 0  && SMBUSGNT == 1'b1  && SMBUSREQ == 1'b1 &&                        FlagLt2 ==1'b1 && StateFlag != 2'b11)
               begin
                       if (SMWAIT == 1'b1)
                         begin
                          if (FrstReadCntLt2 == 0)
                            begin
                             if (StateFlag == 2'b10 && ReadyCntHigh > 0)
                              begin
                               HREADYOUTPr <= 1'b1;

                                if (ReadyCntHigh == 3'b001 && MW == 2'b10)
                                  begin
                                    QuadBounCntLt2 <=QuadBounCntLt2 + 1'b1 ;
                                    StateFlag    <= 2'b11;

                                      if (SMADDR[3:2]==  2'b00)
                                         begin
                                           StartAddr00 <= 1'b1;
                                         end

                                      if (SMADDR[3:2]== 2'b01)
                                         begin
                                           StartAddr01 <= 1'b1;
                                         end

  
                                      if (SMADDR[3:2]==  2'b10)
                                         begin
                                           StartAddr10 <= 1'b1;
                                         end
  
                                     if (SMADDR[3:2]==   2'b11)
                                        begin
                                          StartAddr11 <= 1'b1;
                                        end
                                  end // end of when readycnt high = 1

                                else
                                if (ReadyCntHigh == 3'b001 && MW == 2'b01)
                                  begin
                                    QuadBounCntLt2 <=QuadBounCntLt2 + 1'b1 ;
                                    StateFlag    <= 2'b11;

                                      if (SMADDR[2:1]==  2'b00)
                                         begin
                                           StartAddr00 <= 1'b1;
                                         end

                                      if (SMADDR[2:1]== 2'b01)
                                         begin
                                           StartAddr01 <= 1'b1;
                                         end

  
                                      if (SMADDR[2:1]==  2'b10)
                                         begin
                                           StartAddr10 <= 1'b1;
                                         end
  
                                     if (SMADDR[2:1]==   2'b11)
                                        begin
                                          StartAddr11 <= 1'b1;
                                        end
                                  end // end of when readycnt high = 1

                               ReadyCntHigh <= ReadyCntHigh - 1'b1;
                              end // end of condition when stateflag = 2

                            end // end of condition when first read Cnt is =0

                          else // when frst read cnt is not zero
                            begin
                               HREADYOUTPr <= 1'b0;
                               FrstReadCntLt2 <= FrstReadCntLt2 - 1'b1;
                               StateFlag <= 2'b10;  // change made here
                            end
                         end
                       else if (SMWAIT== 1'b0 )
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
               end // end of condition of nseq when when MSIZE = 2HSIZE

         else if(FrstReadCntLt2 == 1'b0 && StateFlag == 2'b11  && BM ==1'b1                        && FlagLt2 == 1'b1 && GntFlag ==1'b1)
               begin
                 if (StartAddr00 == 1'b1)
                   begin
                     if (QuadBounCntLt2 == 2'b00)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt2 <= SlowReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;// default value
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111; // default value
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111; // default value
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111; // default value
                               end
                       end
                   end // end of condition when starting address was 00

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 != 5'b01000 ))
                   begin
                     if (QuadBounCntLt2 == 2'b11)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt2 <= SlowReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 01

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 == 5'b01000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                   end // end of condition when starting address was 01


                 else
                 if (StartAddr10 == 1'b1 && (Beat2 != 5'b01000 ))
                   begin
                     if (QuadBounCntLt2 == 2'b10)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt2 <= SlowReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 0;
                               end
                       end
                   end // end of condition when starting address was 10

                 else
                 if (StartAddr10 == 1'b1 && (Beat2 == 5'b01000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                   end // end of condition when starting address was 10

                 else
                 if (StartAddr11 == 1'b1 && (Beat2 != 5'b01000 ))
                   begin
                     if (QuadBounCntLt2 == 2'b01)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt2 <= SlowReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 11

                 else
                 if (StartAddr11 == 1'b1 && (Beat2 == 5'b01000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt2 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt2  <=QuadBounCntLt2 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt2 <= FastReadCntLt2 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                   end // end of condition when starting address was 11

               end // end of condition for SEQS for MSIZE = 2HSIZE



   
          // beggining of case when MSIZE = 4 HSIZE and NSEQ

         else if (IDCYCnt == 0  && SMBUSGNT == 1'b1  && SMBUSREQ == 1'b1 &&                        FlagLt4 ==1'b1 && StateFlag != 2'b11)
               begin
                       if (SMWAIT == 1'b1)
                         begin
                          if (FrstReadCntLt4 == 0)
                            begin
                             if (StateFlag == 2'b10 && ReadyCntHigh > 0)
                              begin
                               HREADYOUTPr <= 1'b1;

                                if (ReadyCntHigh == 3'b001 && MW == 2'b11)
                                  begin
                                    QuadBounCntLt4 <=QuadBounCntLt4 + 1'b1 ;
                                    StateFlag    <= 2'b11;

                                      if (SMADDR[3:2]==  2'b00)
                                         begin
                                           StartAddr00 <= 1'b1;
                                         end

                                      if (SMADDR[3:2]== 2'b01)
                                         begin
                                           StartAddr01 <= 1'b1;
                                         end


                                      if (SMADDR[3:2]==  2'b10)
                                         begin
                                           StartAddr10 <= 1'b1;
                                         end

                                     if (SMADDR[3:2]==   2'b11)
                                        begin
                                          StartAddr11 <= 1'b1;
                                        end
                                  end // end of when readycnt high = 1

                               ReadyCntHigh <= ReadyCntHigh - 1'b1;
                              end // end of condition when stateflag = 2

                            end // end of condition when first read Cnt is =0

                          else // when frst read cnt is not zero
                            begin
                               HREADYOUTPr <= 1'b0;
                               FrstReadCntLt4 <= FrstReadCntLt4 - 1'b1;
                               StateFlag <= 2'b10;  // change made here
                            end
                         end
                       else if (SMWAIT== 1'b0 )
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
               end // end of condition of nseq when when Msize = 4 hsize

         else if(FrstReadCntLt4 == 1'b0 && StateFlag == 2'b11  && BM ==1'b1                        && FlagLt4 == 1'b1 && GntFlag ==1'b1)
               begin
                 if (StartAddr00 == 1'b1)
                   begin
                     if (QuadBounCntLt4 ==2'b00)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt4 <= SlowReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 00

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 != 5'b10000 ))
                   begin
                     if (QuadBounCntLt4 == 2'b11)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt4 <= SlowReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 0;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 0;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 01

                 else
                 if (StartAddr01 == 1'b1 && (Beat2 == 5'b10000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                   end // end of condition when starting address was 01


                 else
                 if (StartAddr10 == 1'b1 && (Beat2 != 5'b10000 ))
                   begin
                     if (QuadBounCntLt4 == 2'b10)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt4 <= SlowReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 10

                 else
                 if (StartAddr10 == 1'b1 && (Beat2 == 5'b10000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                   end // end of condition when starting address was 10


                 else
                 if (StartAddr11 == 1'b1 && (Beat2 != 5'b10000 ))
                   begin
                     if (QuadBounCntLt4 == 2'b01)
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (SlowReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 SlowReadCntLt4 <= SlowReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                     else  // when quad boundaries r not crossed
                       begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when SlowReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                       end
                   end // end of condition when starting address was 11


                 else
                 if (StartAddr11 == 1'b1 && (Beat2 == 5'b10000 ))
                   begin
                         if (SMWAIT == 1'b1)
                           begin
                             if (FastReadCntLt4 ==1'b0)
                               begin
                                 if ( ReadyCntHighSeq > 0 )
                                   begin
                                     HREADYOUTPr <= 1'b1;
                                     ReadyCntHighSeq <= ReadyCntHighSeq -1'b1;
                                       if (ReadyCntHighSeq == 3'b001)
                                        QuadBounCntLt4  <=QuadBounCntLt4 + 1'b1;
                                   end // end when ready cnt high seq ends
                               end
                             else // when FastReadCntEq is loaded
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 FastReadCntLt4 <= FastReadCntLt4 - 1'b1;
                                 ReadyCntHigh <= 3'b111;
                                 StateFlag <= 2'b11;  // change made here
                               end
                           end // end of condition when there was no smwait
                          else if (SMWAIT == 1'b0)
                               begin
                                 HREADYOUTPr <= 1'b0;
                                 ReadyCntHigh <= 3'b111;
                               end
                   end // end of condition when starting address was 11

               end // end of condition for SEQS for MSIZE = 4 HSIZE


          




          // NSEQ for Case HSIZE = 4 MSIZE starts here
          // the basic idea of taking four different counters for every NSEQ
          // or SEQ is to take care of SMWAIT condition . suppose SMWAIT goes             // low when SMC is reading second 8 bit data therefore WST2 or WST1             // corrosponding to that read should be flushed. therefore by taking            // four different counters each for seperate 8 bit read its easy to             // flush the counter corrosponding to SMWAIT going low . Once SMWAIT            // is high those counters are loaded with default value of three
          // so here counters r decremente din this faishon .
          // first FrstReadCntGt4_1 followed by FastReadCntGt4_2 ,       
          // FastReadCntGt4_3 , FastReadCntGt4_4
 
         else if (IDCYCnt == 0 && HREADYOUTPr == 1'b0 && SMBUSGNT == 1'b1                        && SMBUSREQ == 1'b1 && FlagGt4 ==1'b1 && StateFlag != 2'b11)
               begin
                 if (SMWAIT == 1'b1)
                   begin
                    if (FastReadCntGt4_4 == 1'b0 && FastReadCntGt4_3 ==1'b0 &&                          FastReadCntGt4_2 == 1'b0 && FrstReadCntGt4_1 == 1'b0)
                       begin
                         if (StateFlag == 2'b10)
                           begin
                              HREADYOUTPr <= 1'b1;
                              StateFlag <= 2'b11;
                           end
                       end
                    else if (FastReadCntGt4_3 ==1'b0 && FastReadCntGt4_2 == 1'b0                              && FrstReadCntGt4_1 == 1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FastReadCntGt4_4 <= FastReadCntGt4_4 - 1'b1;
                       end 

                    else if (FastReadCntGt4_2 ==1'b0 && FrstReadCntGt4_1 ==1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FastReadCntGt4_3 <= FastReadCntGt4_3 - 1'b1;
                       end

                    else if (FrstReadCntGt4_1 == 1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FastReadCntGt4_2 <= FastReadCntGt4_2 - 1'b1;
                       end


                    else 
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FrstReadCntGt4_1 <= FrstReadCntGt4_1 - 1'b1;
                       end
                   end  // end of condition for SMWAIT = 1'b1
                  else if (SMWAIT== 1'b0 )
                   begin
                       HREADYOUTPr <= 1'b0;
                   end 
               end // end of NSEQ for HSIZE = 4 MSIZE 

         else if( StateFlag == 2'b11  && BM ==1'b1 && FlagGt4 == 1'b1 &&                         GntFlag ==1'b1)
               begin

                 if (SMWAIT == 1'b1)
                   begin
                     if (FastReadCntGt4_4 == 1'b0 && FastReadCntGt4_3 ==1'b0 &&                          FastReadCntGt4_2 == 1'b0 && FrstReadCntGt4_1 == 1'b0)
                       begin
                         if (StateFlag == 2'b11)
                           begin
                              HREADYOUTPr <= 1'b1;
                              StateFlag <= 2'b11;
                           end
                       end
                    else if (FastReadCntGt4_3 ==1'b0 && FastReadCntGt4_2 == 1'b0                              && FrstReadCntGt4_1 == 1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt4_4 <= FastReadCntGt4_4 - 1'b1;
                       end

                    else if (FastReadCntGt4_2 ==1'b0 && FrstReadCntGt4_1 ==1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt4_3 <= FastReadCntGt4_3 - 1'b1;
                       end

                    else if (FrstReadCntGt4_1 == 1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt4_2 <= FastReadCntGt4_2 - 1'b1;
                       end


                    else
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FrstReadCntGt4_1 <= FrstReadCntGt4_1 - 1'b1;
                       end
                   end  // end of condition for SMWAIT = 1'b1
                  else if (SMWAIT== 1'b0 )
                   begin
                       HREADYOUTPr <= 1'b0;
                   end 

               end // end of SEQ when HSIZE = 4 MSIZE


          // case HSIZE = 2 MSIZE has not been tested yet 
          // above all case tested
        

          // NSEQ for Case HSIZE = 2 MSIZE starts here
          // the basic idea of taking two different counters for every NSEQ
          // or SEQ is to take care of SMWAIT condition . suppose SMWAIT goes
          // low when SMC is reading second 8 bit data therefore WST2 or WST1  
          // corrosponding to that read should be flushed. therefore by taking 
          // two different counters each for seperate 8 bit read its easy to
          // flush the counter corrosponding to SMWAIT going low . Once SMWAIT  
          // is high those counters are loaded with default value of three
          // so here counters r decremente din this faishon .
          // first FrstReadCntGt2_1 followed by FastReadCntGt2_2 

         else if (IDCYCnt == 0 && HREADYOUTPr == 1'b0 && SMBUSGNT == 1'b1                        && SMBUSREQ == 1'b1 && FlagGt2 ==1'b1 && StateFlag != 2'b11)
               begin
                 if (SMWAIT == 1'b1)
                   begin
                     if (FastReadCntGt2_2 == 1'b0 && FrstReadCntGt2_1 == 1'b0 &&                         MW == 2'b01)
                       begin
                         if (StateFlag == 2'b10)
                           begin
                              HREADYOUTPr <= 1'b1;
                              StateFlag <= 2'b11;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1 ;

                                      if (SMADDR[2:1] ==  2'b00)
                                         begin
                                           StartAddr00 <= 1'b1;
                                         end

                                      if (SMADDR[2:1] == 2'b01)
                                         begin
                                           StartAddr01 <= 1'b1;
                                         end


                                      if (SMADDR[2:1] ==  2'b10)
                                         begin
                                           StartAddr10 <= 1'b1;
                                         end

                                     if (SMADDR[2:1] ==   2'b11)
                                        begin
                                          StartAddr11 <= 1'b1;
                                        end

                           end
                       end // end of HREADYOUTPr high when MSIZE = 16

                     else
                     if (FastReadCntGt2_2 == 1'b0 && FrstReadCntGt2_1 == 1'b0 &&                         MW == 2'b00)
                       begin
                         if (StateFlag == 2'b10)
                           begin
                              HREADYOUTPr <= 1'b1;
                              StateFlag <= 2'b11;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1 ;

                                      if (SMADDR[1:0] ==  2'b00)
                                         begin
                                           StartAddr00 <= 1'b1;
                                         end

                                      if (SMADDR[1:0] == 2'b01)
                                         begin
                                           StartAddr01 <= 1'b1;
                                         end


                                      if (SMADDR[1:0] ==  2'b10)
                                         begin
                                           StartAddr10 <= 1'b1;
                                         end

                                     if (SMADDR[1:0] ==   2'b11)
                                        begin
                                          StartAddr11 <= 1'b1;
                                        end 

                           end
                       end // end of HREADYOUTPr high when MSIZE = 8


                    else if (FrstReadCntGt2_1 == 1'b0)
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FastReadCntGt2_2 <= FastReadCntGt2_2 - 1'b1;
                       end


                    else
                       begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b10;
                              FrstReadCntGt2_1 <= FrstReadCntGt2_1 - 1'b1;
                       end
                   end  // end of condition for SMWAIT = 1'b1
                  else if (SMWAIT== 1'b0 )
                   begin
                       HREADYOUTPr <= 1'b0;
                   end
               end // end of NSEQ for HSIZE = 2 MSIZE



          // SEQ for Case HSIZE = 2 MSIZE starts here
          // the basic idea of taking three different counters for every 
          // or SEQ is to take care of SMWAIT condition . suppose SMWAIT goes 
          // low when SMC is reading second 8 bit data therefore WST2 or WST1 
          // corrosponding to that read should be flushed. therefore by taking
          // three different counters each for seperate 8 bit read its easy to
          // flush the counter corrosponding to SMWAIT going low . Once SMWAIT
          // is high those counters are loaded with default value of three
          // so here counters r decremente din this faishon .
          // first  followed by FastReadCntGt2_2  and then either by 
          // FastReadCntGt2_3 or  FastReadCntGt2_4. To be more elaborate 
          // FastReadCntGt2_3 contains WST2 and  
          //FastReadCntGt2_4 contains WST1. thefore since here starting address
          // can be 00 or 10 of SMADDR therfore we have to also take care of 
          // QuadBoundaryConditions thefore i have taken 3 seperate counters 
          // each having values ( 1+ WST2 ) , (WST2 ) , (WST1 )


         else if( StateFlag == 2'b11  && BM ==1'b1 && FlagGt2 == 1'b1 &&                         GntFlag ==1'b1)
               begin
                if (StartAddr00 == 1'b1)
                  begin
                    if (SMWAIT == 1'b1)
                      begin
                       if (QuadBounCntGt2 ==1'b0)
                        begin
                         if (FastReadCntGt2_4== 1'b0 && FastReadCntGt2_2== 1'b0)
                           begin
                              HREADYOUTPr <= 1'b1;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1; 
                           end

                         else if (FastReadCntGt2_4 == 1'b0)
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_2 <= FastReadCntGt2_2 - 1'b1;
                           end

                         else
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_4 <= FastReadCntGt2_4 - 1'b1;
                           end
                        end  // end of Quad boundary condition
                       
                       else if (QuadBounCntGt2 ==1'b1)
                        begin
                         if (FastReadCntGt2_3== 1'b0 && FastReadCntGt2_2== 1'b0)
                           begin
                              HREADYOUTPr <= 1'b1;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1;
                           end

                         else if (FastReadCntGt2_3 == 1'b0)
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_2 <= FastReadCntGt2_2 - 1'b1;
                           end

                         else
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_3 <= FastReadCntGt2_3 - 1'b1;
                           end
                        end  // end of Quad boundary condition

                      end  // end of condition for SMWAIT = 1'b1
                    else if (SMWAIT== 1'b0 )
                      begin
                         HREADYOUTPr <= 1'b0;
                      end
                  end // end of condition for start address being 00
               
                else
                if (StartAddr10 == 1'b1)
                  begin
                    if (SMWAIT == 1'b1)
                      begin
                       if (QuadBounCntGt2 ==1'b1)
                        begin
                         if (FastReadCntGt2_4== 1'b0 && FastReadCntGt2_2== 1'b0)
                           begin
                              HREADYOUTPr <= 1'b1;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1;
                           end

                         else if (FastReadCntGt2_4 == 1'b0)
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_2 <= FastReadCntGt2_2 - 1'b1;
                           end

                         else
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_4 <= FastReadCntGt2_4 - 1'b1;
                           end
                        end  // end of Quad boundary condition

                       else if (QuadBounCntGt2 ==1'b0)
                        begin
                         if (FastReadCntGt2_3== 1'b0 && FastReadCntGt2_2== 1'b0)
                           begin
                              HREADYOUTPr <= 1'b1;
                              QuadBounCntGt2 <= QuadBounCntGt2 + 1'b1;
                           end

                         else if (FastReadCntGt2_3 == 1'b0)
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_2 <= FastReadCntGt2_2 - 1'b1;
                           end

                         else
                           begin
                              HREADYOUTPr <= 1'b0;
                              StateFlag <= 2'b11;
                              FastReadCntGt2_3 <= FastReadCntGt2_3 - 1'b1;
                           end
                        end  // end of Quad boundary condition

                      end  // end of condition for SMWAIT = 1'b1
                    else if (SMWAIT== 1'b0 )
                      begin
                         HREADYOUTPr <= 1'b0;
                      end
                  end // end of condition for start address being 10

               end // end of SEQ when HSIZE = 2 MSIZE




 end // end of condition for read xfer
end // end of always block


endmodule











