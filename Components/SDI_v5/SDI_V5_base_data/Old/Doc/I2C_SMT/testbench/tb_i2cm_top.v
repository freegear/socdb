//////////////////////////////////////////////////////////////////////////////////
// TITLE :                 I2C Master Core Testbench
// FILE NAME :             tb_i2cm_top.vhd
// AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
// ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
// CREATED :               December 14, 2002
// LAST UPDATED :          December 14, 2002
// PLATFORM :              MS Windows 2000 professional
// SIMULATOR :             ModelSim SE 5.5c
// SYNTHESIZER :           Synplify pro 7.0
// TARGET :                FPGA (ALTERA EPF10K10TC144-3)
// DISCRIPTION :           This module defines I2C Master Core Testbench
// REVISION NUMBER :       -
// VERSION NUMBER :        1.0
// DATE OF CHANGE :        -
// MODIFIEER :             -
// DESCRIPTION OF CHANGE : -
// NOTICE :                -
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// I2C Master Core Testbench
//////////////////////////////////////////////////////////////////////////////////
//
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns /10 ps


module tb_i2cm_top () ;

//////////////////////////////////////////////////////////////////////////////////
// 00_LocalWires&Regs ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

reg  clk_r ;
reg  rst_n_r ;

wire [31:0] addr_a ;
wire [ 7:0] dat_i_a ;
wire [ 7:0] dat_o_a ;
wire we_a ;
wire stb_a ;
wire cyc_a ;
wire ack_a ;
wire inta_a ;

reg [7:0] q_r ;
reg [7:0] qq_r ;

wire scl_a ;
wire scl_o_a ;
wire scl_oen_a ;
wire sda_a ;
wire sda_o_a ;
wire sda_oen_a ;  

parameter PRER_LO = 3'b000 ;
parameter PRER_HI = 3'b001 ;
parameter CTR     = 3'b010 ;
parameter RXR     = 3'b011 ;
parameter TXR     = 3'b011 ;
parameter CR      = 3'b100 ;
parameter SR      = 3'b100 ;

parameter TXR_R   = 3'b101 ; // undocumented / reserved output
parameter CR_R    = 3'b110 ; // undocumented / reserved output

	
//////////////////////////////////////////////////////////////////////////////////
// 01_Clock //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always #15 clk_r = ~clk_r ;


//////////////////////////////////////////////////////////////////////////////////
// 01_MircoProcessorModel ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

i2cm_up_model #(8, 32) U0_I2CM_UP_MODEL (

  .clk   (clk_r),
  .rst_n (rst_n_r),
  .din   (dat_i_a),
  .ack   (ack_a),
  .err   (1'b0),
  .rty   (1'b0),

  .addr  (addr_a),
  .dout  (dat_o_a),
  .cyc   (cyc_a),
  .stb   (stb_a),
  .we    (we_a),
  .sel   ()

);
        

//////////////////////////////////////////////////////////////////////////////////
// 02_I2CMasterCore //////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

i2cm_top  U1_I2CM_TOP (

  .clk     (clk_r), 
  .rst_n   (rst_n_r), 
  .rst_sn  (1'b0),
  .addr    (addr_a [2:0]),
  .dat_i   (dat_o_a),                
  .we_i    (we_a), 
  .stb_i   (stb_a), 
  .cyc_i   (cyc_a),
  .scl_i   (scl_a),
  .sda_i   (sda_a), 
  
  .dat_o   (dat_i_a),                
  .ack_o   (ack_a), 
  .inta_o  (inta_a),
  .scl_o   (scl_o_a), 
  .scl_oen (scl_oen_a),                 
  .sda_o   (sda_o_a), 
  .sda_oen (sda_oen_a)

) ;


//////////////////////////////////////////////////////////////////////////////////
// 02_I2CSlaveModel //////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

i2cm_slave_model #(7'b1010_000) U2_I2CM_SLAVE_MODEL (

  .scl (scl_a),
  .sda (sda_a)

) ;


//////////////////////////////////////////////////////////////////////////////////
// 03_I2CLines ///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

assign scl_a = scl_oen_a ? 1'bz : scl_o_a ; // create tri-state buffer for i2c master scl line
assign sda_a = sda_oen_a ? 1'bz : sda_o_a ; // create tri-state buffer for i2c master sda line

pullup p1 (scl_a) ; // pullup scl line
pullup p2 (sda_a) ; // pullup sda line


//////////////////////////////////////////////////////////////////////////////////
// 04_Initial_Test ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

initial
begin
//force U2_I2CM_SLAVE_MODEL.debug_a = 1'b1; // enable  i2c_slave debug information
  force U2_I2CM_SLAVE_MODEL.debug_a = 1'b0; // disable i2c_slave debug information

  $display ("\nstatus: %t Testbench started\n\n", $time) ;

  $dumpfile ("tb_i2cm_top.vcd") ;
  $dumpvars (1, tb_i2cm_top) ;
  $dumpvars (1, tb_i2cm_top.U2_I2CM_SLAVE_MODEL) ;

  // initially values
  clk_r = 0 ;

  // reset system
  rst_n_r = 1'b1 ; // negate reset
  #2 ;
  rst_n_r = 1'b0 ; // assert reset
  repeat (20) @(posedge clk_r) ;
  rst_n_r = 1'b1 ; // negate reset

  $display ("status: %t done reset", $time) ;
			
  @(posedge clk_r) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_1_ProgramCore //////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  // program internal registers
  U0_I2CM_UP_MODEL.up_write (1, PRER_LO, 8'h3e) ; // load prescaler lo-byte
  U0_I2CM_UP_MODEL.up_write (1, PRER_HI, 8'h00) ; // load prescaler hi-byte

  $display ("status: %t programmed registers", $time) ;

  U0_I2CM_UP_MODEL.up_cmp (0, PRER_LO, 8'h3e) ; // verify prescaler lo-byte
  U0_I2CM_UP_MODEL.up_cmp (0, PRER_HI, 8'h00) ; // verify prescaler hi-byte

  $display ("status: %t verified registers", $time) ;

  U0_I2CM_UP_MODEL.up_write (1, CTR, 8'h80) ; // enable core

  $display ("status: %t enabled core", $time) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_2_AccessSlave(Write) ///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  // drive slave address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'ha0) ; // present slave address, set write-bit (== !read)
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h90) ; // set command (start, write)

  $display ("status: %t generate 'start', write cmd a0 (slave address+write)", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (0, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // send memory address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'h01) ; // present slave's memory address
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h10) ; // set command (write)

  $display ("status: %t write slave memory address 01", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (0, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // send memory contents
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'ha5) ; // present data
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h10) ; // set command (write)

  $display ("status: %t write data a5", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // send memory contents for next memory address (auto_inc)
  U0_I2CM_UP_MODEL.up_write(1, TXR, 8'h5a) ; // present data
  U0_I2CM_UP_MODEL.up_write(0, CR,  8'h50) ; // set command (stop, write)

  $display ("status: %t write next data 5a, generate 'stop'", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_3_Delay ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  #100000 ; // wait for 100us.

  $display ("status: %t wait 100us", $time) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_4_AccessSlave(Read) ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  // drive slave address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'ha0) ; // present slave address, set write-bit (== !read)
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h90) ; // set command (start, write)

  $display ("status: %t generate 'start', write cmd a0 (slave address+write)", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // send memory address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'h01) ; // present slave's memory address
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h10) ; // set command (write)

  $display ("status: %t write slave address 01", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // drive slave address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'ha1) ; // present slave's address, set read-bit
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h90) ; // set command (start, write)

  $display ("status: %t generate 'repeated start', write cmd a1 (slave address+read)", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // read data from slave
  U0_I2CM_UP_MODEL.up_write (1, CR, 8'h20) ; // set command (read, ack_read)

  $display ("status: %t read + ack", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // check data just received
  U0_I2CM_UP_MODEL.up_read (1, RXR, qq_r) ;
  if (qq_r !== 8'ha5)
    $display ("\nERROR: Expected a5, received %x at time %t", qq_r, $time) ;

  // read data from slave
  U0_I2CM_UP_MODEL.up_write (1, CR, 8'h20) ; // set command (read, ack_read)

  $display ("status: %t read + ack", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // check data just received
  U0_I2CM_UP_MODEL.up_read (1, RXR, qq_r) ;
  if (qq_r !== 8'h5a)
    $display ("\nERROR: Expected 5a, received %x at time %t", qq_r, $time) ;

  // read data from slave
  U0_I2CM_UP_MODEL.up_write (1, CR, 8'h20); // set command (read, ack_read)

  $display ("status: %t read + ack", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // check data just received
  U0_I2CM_UP_MODEL.up_read (1, RXR, qq_r) ;
  $display ("status: %t received %x from 3rd read address", $time, qq_r) ;

  // read data from slave
  U0_I2CM_UP_MODEL.up_write (1, CR,      8'h28) ; // set command (read, nack_read)
  $display ("status: %t read + nack", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // check data just received
  U0_I2CM_UP_MODEL.up_read (1, RXR, qq_r) ;
  $display ("status: %t received %x from 4th read address", $time, qq_r) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_5_CheckInvalidSlaveMemoryAddress ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  // drive slave address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'ha0) ; // present slave address, set write-bit (== !read)
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h90) ; // set command (start, write)

  $display ("status: %t generate 'start', write cmd a0 (slave address+write). Check invalid address", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // send memory address
  U0_I2CM_UP_MODEL.up_write (1, TXR, 8'h10) ; // present slave's memory address
  U0_I2CM_UP_MODEL.up_write (0, CR,  8'h10) ; // set command (write)

  $display ("status: %t write slave memory address 10", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;

  // slave should have send NACK
  $display ("status: %t Check for nack", $time) ;
  if (!q_r[7])
    $display ("\nERROR: Expected NACK, received ACK\n") ;

  // read data from slave
  U0_I2CM_UP_MODEL.up_write (1, CR, 8'h40) ; // set command (stop)

  $display ("status: %t generate 'stop'", $time) ;

  // check TIP(Transfer is In Progress) bit
  U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ;
  while (q_r[1])
    U0_I2CM_UP_MODEL.up_read (1, SR, q_r) ; // poll it until it is zero

  $display ("status: %t tip==0", $time) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_6_Delay ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  #25000 ; // wait 25us

  $display ("\n\nstatus: %t Testbench done", $time) ;

  $stop ;


end

endmodule


