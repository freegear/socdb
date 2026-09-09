// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2CSlave.v
// File Revision       : 1.0
// -----------------------------------------------------------------------------
// Purpose             : I2C AHB slave code.
// --=========================================================================--

`timescale 1ns/1ps
 
module I2CSlave (HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATA,
                   HSELRetry, HREADY, HRDATA, HREADYOUT, HRESP,
                   read_clear, write_clear, start_clear, stop_clear,
                   busy,// busy condition
                   mode,//enable signal
				   read,
				   write,
				   start,
				   stop,
				   tx_reg,
				   rx_reg,
				   add_reg,
				   ack_bit
				   );
                   
                   
        input         HCLK;
        input         HRESETn;
        input [31:0]  HADDR;
        input [1:0]   HTRANS;
        input         HWRITE;
        input [2:0]   HSIZE;
        input [31:0]  HWDATA;
        input         HSELRetry;
        input         HREADY;
        
        input         read_clear;
        input         write_clear;
        input         start_clear;
        input         stop_clear;
		input		  busy;
        input[15:0]   rx_reg;
        input		  ack_bit;

        output        mode;
        output        read;
        output        write;
        output        start;
        output        stop;
        output[7:0]   tx_reg;
        output[7:0]   add_reg;
        
        
        output [31:0] HRDATA;
        output        HREADYOUT;
        output [1:0]  HRESP;
  
      
        
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11
 
// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010
 
// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11
 
// Module Address Map:

// Read/write 32-bit registers:
// will be used register
// Address  Read        Write
// 0x00     I2C_CON     I2C_CON 
// 0x04     I2C_COM     I2C_COM
// 0x08     I2C_STA     I2C_STA
// 0x0C     I2C_TX      I2C_TX
// 0x10     I2C_RX      I2C_RX
// 0x14     I2C_ADR     I2C_ADR

// Read only 32-bit logical combinations of read/write registers:
// Address  Read
// 0x10     not R0
// 0x14     R0 and R1
// 0x18     R1 or  R2
// 0x1C     R2 xor R3
// 0x20     R0 and R1 and R2 and R3
// 0x24     R0 or  R1 or  R2 or  R3
// 0x28     R0 xor R1 xor R2 xor R3

// Response address mapping
// 31 - 14 = unused
// 13 - 12 = number of retry responses to insert (0 to 3)  (2 bits)
// 11 -  8 = number of wait states to insert     (1 to 15) (4 bits)
//  7 -  0 = unused

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        HCLK;
  wire        HRESETn;
  wire [31:0] HADDR;
  wire [1:0]  HTRANS;
  wire        HWRITE;
  wire [2:0]  HSIZE;
  wire [31:0] HWDATA;
  wire        HSELRetry;
  wire        HREADY;
  wire [31:0] HRDATA;
  wire        HREADYOUT;
  wire [1:0]  HRESP;

 // Internal Signals
  reg         HselReg;
  wire        Valid;        // Module is selected with valid transfer
  wire        ValidReg;     // Module was selected with valid transfer
  wire        ACRegEn;      // Enable for address and control registers
  reg  [31:0] HaddrReg;
  reg   [1:0] HtransReg;
  reg         HwriteReg;
  reg   [2:0] HsizeReg;

  wire [4:0]        HaddrReg_m  = {HaddrReg[31], HaddrReg[5:2]};

 // Internal write registers
 // will be used registers
  wire        I2C_CON_En;
  wire        I2C_COM_En;
  wire        I2C_STA_En;
  wire        I2C_TX_En;
  wire        I2C_RX_En;
  wire        I2C_ADR_En;
  
  wire        Clear_en;
 // wire [31:0]     I2C_CON_Next;
 // wire [31:0]     I2C_COM_Next;
 // wire [31:0]     I2C_STA_Next;
 // wire [31:0]     I2C_TX_Next ;
 // wire [31:0]     I2C_RX_Next ;
 // wire [31:0]     I2C_ADR_Next;
  reg [2:0]     I2C_CON;
  reg [4:0]     I2C_COM;
  reg [4:0]     I2C_STA;
  reg [7:0]     I2C_TX ;
  reg [7:0]     I2C_RX ;
  reg [7:0]     I2C_ADR;

// reg  [31:0] Mask;         // Write data mask

// Read location generated values
 /* wire [31:0] Read10;
  wire [31:0] Read14;
  wire [31:0] Read18;
  wire [31:0] Read1C;
  wire [31:0] Read20;
  wire [31:0] Read24;
  wire [31:0] Read28;
 */
// Wait state generation
  wire  [3:0] NextWait;     // Wait register input
  reg   [3:0] CurrentWait;  // Waits to be inserted

// Retry response generation
  wire  [1:0] NextRetry;    // Retry register input
  wire        RetryEn;      // Retry register enable
  reg   [1:0] CurrentRetry; // 

// Internal signals to drive output ports
  wire        HreadyNext;   // HREADYOUT reg input
  reg   [1:0] HrespNext;    // HRESP register input
 
  reg  [31:0] iHRDATA;
  reg   [1:0] iHRESP;
  reg         iHREADYOUT;
  assign       mode = I2C_CON[0];
  assign       read = I2C_COM[2];
  assign       write = I2C_COM[1];
  assign       start = I2C_COM[4];
  assign       stop = I2C_COM[3];
  assign       tx_reg = I2C_TX[7:0];  
  assign       add_reg = I2C_ADR[7:0];
  //assign       I2C_RX[15:0] = rx_reg[15:0];
  
  
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
		I2C_STA <= 6'd0;
    else
    begin      
		I2C_STA[3] <= ack_bit ;
		I2C_STA[0] <= busy;
	end
  end
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      HselReg <= 1'b0;
    else
    begin
      if (HREADY)
        HselReg <= HSELRetry;
    end
  end
 
// Valid AHB transfers only take place when a non-sequential or sequential
// transfer is shown on HTRANS - an idle or busy transfer should be ignored.

  assign Valid = (HSELRetry == 1'b1 && (HTRANS == `TRN_NONSEQ ||
                                        HTRANS == `TRN_SEQ) ? 1'b1 : 1'b0);

  assign ValidReg = (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ) ? 1'b1 : 1'b0);

//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
// phase for use in the data phase of the transfer.
// Only enabled when the HREADY input is HIGH and the module is addressed.

  assign ACRegEn = HSELRetry & HREADY;

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    begin
      HaddrReg  <= 32'h0000_0000;
      HtransReg <= 2'b00;
      HwriteReg <= 1'b0;
      HsizeReg  <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg  <= HADDR;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg  <= HSIZE;
      end
    end
  end
 
//------------------------------------------------------------------------------
// Write data mask generation
//------------------------------------------------------------------------------
// The data written to the registers depends on the transfer size setting.
// Unchanging bits of the write data are set HIGH in the mask.
// Changing   bits of the write data are set LOW  in the mask.
// The mask is used to allow the use of one set of size decoding logic for all
//  registers in the system.

// NOTE - this module is little endian, and must be modified for a big endian
//        system.

 /* always @(HsizeReg or HaddrReg)
  begin
    Mask = 32'hFFFF_FFFF;
    case (HsizeReg)

      `SZ_BYTE :                   // Byte Access
        case (HaddrReg[1:0])
          2'b00 :
            Mask[7:0] = 8'h00;
          2'b01 :
            Mask[15:8] = 8'h00;
          2'b10 :
            Mask[23:16] = 8'h00;
          2'b11 :
            Mask[31:24] = 8'h00;
          default  : ;
        endcase
 
      `SZ_HALF :                   // Halfword Access
        case (HaddrReg[1])
          1'b0 :
            Mask[15:0] = 16'h0000;
          1'b1 :
            Mask[31:16] = 16'h0000;
          default  : ;
        endcase
 
      default  :                   // Word Access
        Mask = 32'h0000_0000;

    endcase
  end
 */
//------------------------------------------------------------------------------
// Internal register address decoding
//------------------------------------------------------------------------------
// The enables are set when the register is addressed and HWRITE is set.

  assign I2C_CON_En = (( HaddrReg_m == 5'b10000 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0);    // address 0x00

  assign  I2C_COM_En= (( HaddrReg_m == 5'b10001 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0);  // address 0x04

  assign I2C_STA_En = (( HaddrReg_m == 5'b10010 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0); // address 0x08

  assign I2C_TX_En = (( HaddrReg_m == 5'b10011 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0);// address 0x0c
                
 /* assign I2C_RX_En = (( HaddrReg_m == 5'b10100 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0); //address 0x10 */// RX <== only read register

  assign I2C_ADR_En = (( HaddrReg_m == 5'b10101 && HwriteReg == 1'b1 &&
                  CurrentWait == 4'b0000 && CurrentRetry == 2'b00 &&
                  ValidReg == 1'b1) ? 1'b1 :
                1'b0);//address 0x14


//------------------------------------------------------------------------------
// Read/write registers
//------------------------------------------------------------------------------
// These registers hold their values when written to.
// The current register data has a mask applied that is set according to the
//  size of the current write transfer, and the masked bits are then set with
//  the input write data from HWDATA.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      //I2C_CON <= 32'h0000_0000;
      I2C_CON <= 3'd0;
    else
    begin
      if ((I2C_CON_En))
        I2C_CON <= {HWDATA[5:4],HWDATA[0]};
    end
  end
 
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      //I2C_COM <= 32'h0000_0000;
      I2C_COM <=5'd0;
    else
    begin
      if ((Clear_en))
        begin
        if (read_clear)
        I2C_COM <= (I2C_COM & 5'b11011); 
        else if (write_clear)
        I2C_COM <= (I2C_COM & 5'b11101);
        else if (start_clear)
        I2C_COM <= (I2C_COM & 5'b01111);
        else if (stop_clear)
        I2C_COM <= (I2C_COM & 5'b10111);
        end
      else if ((I2C_COM_En))
      //I2C_COM <= I2C_COM_Next;
        I2C_COM <= HWDATA[7:3];
    end
  end
 /*
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    //I2C_STA <= 32'h0000_0000;
      I2C_STA <= 5'd0;
    else
    begin
      if ((I2C_STA_En))
        I2C_STA <= HWDATA[7:3];
      else if((Clear_en))
        I2C_STA <= I2C_STA;
    end
  end*/
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      I2C_RX <= 15'd0;
    else
      I2C_RX <= rx_reg[15:0];
  end

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      I2C_TX <= 8'd0;
    else
    begin
      if ((I2C_TX_En))
        I2C_TX <= HWDATA[7:0];
    end
  end
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      I2C_ADR <= 8'd0;
    else
    begin
      if ((I2C_ADR_En))
        I2C_ADR <= HWDATA[7:0];
    end
  end
  
//------------------------------------------------------------------------------
// Read-only register values
//------------------------------------------------------------------------------
// These values are generated from the four read/write registers
/*
  assign Read10 =     ~R0;
  assign Read14 = R0 & R1;
  assign Read18 = R1 | R2;
  assign Read1C = R2 ^ R3;
  assign Read20 = R0 & R1 & R2 & R3;
  assign Read24 = R0 | R1 | R2 | R3;
  assign Read28 = R0 ^ R1 ^ R2 ^ R3;
*/
//------------------------------------------------------------------------------
// Wait state generation
//------------------------------------------------------------------------------
// The number of wait states to use for a transaction is read from the high
//  order lines of the address used for the transfer (HADDR(11:8)).

  assign NextWait = ((Valid == 1'b1 && HREADY == 1'b1) ? HADDR[11:8] :
                    (CurrentWait == 4'b0000 ? 4'b0000 :
                    CurrentWait - 1'b1));

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      CurrentWait <= 4'h0;
    else
      CurrentWait <= NextWait;
  end
 
//------------------------------------------------------------------------------
// Retry generation
//------------------------------------------------------------------------------
// The number of retry responses to use for a transaction is read from the high
//  order lines of the address used for the transfer (HADDR(13:12)).

  assign NextRetry = ((Valid == 1'b1 && HREADY == 1'b1 &&
                       CurrentRetry == 2'b00) ? HADDR[13:12] :
                     (CurrentRetry == 2'b00 ? 2'b00 :
                     CurrentRetry - 1'b1));

  assign RetryEn = ((HADDR[13:12] != 2'b00 && iHRESP == `RSP_OKAY &&
                     Valid == 1'b1 && HREADY == 1'b1) ? 1'b1 :
                   1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      CurrentRetry <= 2'b00;
    else
    begin
      if (RetryEn)
        CurrentRetry <= NextRetry;
    end
  end
 
//------------------------------------------------------------------------------
// HREADYOUT generation
//------------------------------------------------------------------------------
// HREADYOUT is generated from NextWait to allow it to be registered, improving
//  the output timing.

  assign HreadyNext = (NextWait != 4'b0000 ? 1'b0 : 1'b1);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHREADYOUT <= 1'b1;
    else
      iHREADYOUT <= HreadyNext;
  end
 
//------------------------------------------------------------------------------
// HRESP generation
//------------------------------------------------------------------------------
// HRESP is registered to improve the output timing, and allows a state machine
//  to be used to control its generation.

// RSP_RETRY is entered during the last wait cycle when there are retry cycles
//  still to perform, and is held until the first cycle that HREADY is set HIGH.
//  The output is then set back to RSP_OKAY until the next retry cycle.

  always @(iHRESP or NextWait or NextRetry or CurrentRetry or RetryEn or
           iHREADYOUT)
  begin
    case (iHRESP)

      `RSP_OKAY :
        if ((NextRetry != 2'b00 || (CurrentRetry == 2'b01 && RetryEn == 1'b0))
            && NextWait == 4'b0001)
          HrespNext = `RSP_RETRY;
        else
          HrespNext = `RSP_OKAY;
 
      `RSP_RETRY :
        if (!iHREADYOUT)
          HrespNext = `RSP_RETRY;
        else
          HrespNext = `RSP_OKAY;
 
      default  :
        HrespNext = `RSP_OKAY;

    endcase
  end
 
  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHRESP <= `RSP_OKAY;
    else
      iHRESP <= HrespNext;
  end
 
//------------------------------------------------------------------------------
// HRDATA generation
//------------------------------------------------------------------------------
// Generates the read data from the internal register values.
// Uses combinational logic to directly generate the output data from the
//  current data held in the registers rather than using a registered iHRDATA
//  to improve the output setup time.
// Using a register to hold iHRDATA would mean that either the output would be
//  the value of the internal registers in the previous cycle (if the HADDR and
//  HWRITE inputs were used directly), or a single wait state would have to be
//  added to ensure that the most recent data is driven onto the output (for
//  example a write transfer followed by a read from the same location would
//  require a single wait state to allow the iHRDATA register to pick up the
//  newly written value of the register).
 /*
  always @(ValidReg or HwriteReg or CurrentWait or CurrentRetry or HaddrReg or
           R0 or R1 or R2 or R3 or
           Read10 or Read14 or Read18 or Read1C or
           Read20 or Read24 or Read28)
   */        
           
 always @(ValidReg or HwriteReg or CurrentWait or CurrentRetry or HaddrReg or
           I2C_CON or I2C_COM or I2C_STA or I2C_TX or I2C_RX or I2C_ADR)
  begin
    if ((ValidReg && !HwriteReg && CurrentWait == 4'b0000 && CurrentRetry == 2'b00))
      case (HaddrReg_m)
       
        5'b10000 : iHRDATA = {22'd0, I2C_CON[2:1], 3'b000, I2C_CON[0]};
        5'b10001 : iHRDATA = {24'd0, I2C_COM[4:0], 3'b000};
        5'b10010 : iHRDATA = {24'd0, I2C_STA[5:0], 2'b00};
        5'b10011 : iHRDATA = {24'd0, I2C_TX[7:0]};
        5'b10000 : iHRDATA = {16'd0, I2C_RX[15:0]};
        5'b10001 : iHRDATA = {24'd0, I2C_ADR[7:0]};
        default : iHRDATA = 32'h0000_0000;
      endcase
    else
      iHRDATA = 32'h0000_0000;
  end
 
//------------------------------------------------------------------------------
// Output drivers
//------------------------------------------------------------------------------
// Drive the output ports with the internal versions.

  assign HRDATA    = iHRDATA;
  assign HREADYOUT = iHREADYOUT;
  assign HRESP     = iHRESP;


//------------------------------------------------------------------------------
// register clear logic
//------------------------------------------------------------------------------
// register clear


assign Clear_en = ((read_clear)|(write_clear)|(start_clear)|(stop_clear))? 1'b1 : 1'b0;




endmodule

// --================================= End ===================================--
