//////////////////////////////////////////////////////////////////////////////////
// TITLE :                 I2C Slave Model
// FILE NAME :             i2cm_slave_model.vhd
// AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
// ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
// CREATED :               December 14, 2002
// LAST UPDATED :          December 14, 2002
// PLATFORM :              MS Windows 2000 professional
// SIMULATOR :             ModelSim SE 5.5c
// SYNTHESIZER :           Synplify pro 7.0
// TARGET :                FPGA (ALTERA EPF10K10TC144-3)
// DISCRIPTION :           This module defines I2C Slave Model
// REVISION NUMBER :       -
// VERSION NUMBER :        1.0
// DATE OF CHANGE :        -
// MODIFIEER :             -
// DESCRIPTION OF CHANGE : -
// NOTICE :                -
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// I2C Slave Model
//////////////////////////////////////////////////////////////////////////////////
//
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns /10 ps


module i2cm_slave_model (scl, sda) ;

parameter I2CS_ADDR = 7'b001_0000 ;
	
input scl ;

inout sda ;


//////////////////////////////////////////////////////////////////////////////////
// 00_LocalWires&Regs ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

wire debug_a = 1'b1 ;

reg [7:0] mem_r [3:0] ; // memory
reg [7:0] mem_addr_r ;  // memory address
reg [7:0] mem_data_r ;  // memory data output

reg sta_r ;
reg sta_r_p1 ;          // delayed sta_r
reg sto_r ;
reg sto_r_p1 ;          // delayed sto_r

reg [7:0] shift_r ;     // 8bit shift register
reg       rw_r ;        // read/write direction (0 : write, 1 : read)

wire      my_addr_a ;   // my address called ??
wire      i2c_reset_a ; // i2c-statemachine reset
reg [2:0] bit_cnt_r ;   // 3bits downcounter
wire      acc_done_a ;  // access done signal, 8bits transfered
reg       load_r ;      // load downcounter

reg       sda_o_r ;     // sda-drive level

// statemachine declaration
parameter IDLE        = 3'b000 ;
parameter SLAVE_ACK   = 3'b001 ;
parameter GET_MEM_ADR = 3'b010 ;
parameter GMA_ACK     = 3'b011 ;
parameter DATA        = 3'b100 ;
parameter DATA_ACK    = 3'b101 ;

reg [2:0] state_r ;


//////////////////////////////////////////////////////////////////////////////////
// 01_Initial ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

initial
begin
  sda_o_r = 1'b1 ;
  state_r = IDLE ;
end


//////////////////////////////////////////////////////////////////////////////////
// 02_ShiftReg ///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(posedge scl)
  shift_r <= #1 {shift_r [6:0], sda} ;


//////////////////////////////////////////////////////////////////////////////////
// 03_DetectMyAddress ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

assign my_addr_a = (shift_r [7:1] == I2CS_ADDR) ;


//////////////////////////////////////////////////////////////////////////////////
// 04_BitCounter /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(posedge scl)
  if (load_r)
    bit_cnt_r <= #1 3'b111 ;
  else
    bit_cnt_r <= #1 bit_cnt_r - 3'h1 ;


//////////////////////////////////////////////////////////////////////////////////
// 05_AccessDoneSignal ///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

assign acc_done_a = !(|bit_cnt_r) ;


//////////////////////////////////////////////////////////////////////////////////
// 06_DetectStartCondition ///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(negedge sda)
  if (scl)
  begin
    sta_r <= #1 1'b1 ;
    if (debug_a)
      $display ("DEBUG i2cm_slave; start condition detected at %t", $time) ;
  end
  else
    sta_r <= #1 1'b0 ;

always @(posedge scl)
  sta_r_p1 <= #1 sta_r ;


//////////////////////////////////////////////////////////////////////////////////
// 07_DetectStopCondition ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(posedge sda)
  if (scl)
  begin
    sto_r <= #1 1'b1 ;
    if (debug_a)
      $display ("DEBUG i2cm_slave; stop condition detected at %t", $time) ;
  end
  else
    sto_r <= #1 1'b0 ;


//////////////////////////////////////////////////////////////////////////////////
// 08_I2C_ResetSignal ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

assign i2c_reset_a = sta_r || sto_r ;


//////////////////////////////////////////////////////////////////////////////////
// 09_StateMachine ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(negedge scl or posedge sto_r)
  if (sto_r || (sta_r && !sta_r_p1) )
  begin
    state_r <= #1 IDLE ; // reset statemachine

    sda_o_r <= #1 1'b1 ;
    load_r  <= #1 1'b1 ;
  end
  else
  begin
    // initial settings
    sda_o_r <= #1 1'b1 ;
    load_r  <= #1 1'b0 ;

    case (state_r) // synopsys full_case parallel_case
      // IDLE state //////////////////////////////////////////////////////////////
      IDLE :
        if (acc_done_a && my_addr_a)
        begin
          state_r <= #1 SLAVE_ACK ;
          rw_r    <= #1 shift_r [0] ;

          sda_o_r <= #1 1'b0 ; // generate i2c_ack

          #2 ;
          if (debug_a && rw_r)
            $display ("DEBUG i2cm_slave; command byte received (read) at %t", $time) ;
          if (debug_a && !rw_r)
            $display ("DEBUG i2cm_slave; command byte received (write) at %t", $time) ;

          if (rw_r)
          begin
            mem_data_r <= #1 mem_r [mem_addr_r] ;

            if (debug_a)
            begin
              #2 $display ("DEBUG i2cm_slave; data block read %x from address %x (1)", mem_data_r, mem_addr_r) ;
              #2 $display ("DEBUG i2cm_slave; memcheck [0]=%x, [1]=%x, [2]=%x", mem_r [4'h0], mem_r [4'h1], mem_r [4'h2]) ;
            end
          end
        end

        // SLAVE_ACK state /////////////////////////////////////////////////////////
        SLAVE_ACK :
        begin
          if (rw_r)
          begin
            state_r <= #1 DATA ;
            sda_o_r <= #1 mem_data_r [7] ;
          end
          else
            state_r <= #1 GET_MEM_ADR ;
            load_r  <= #1 1'b1 ;
        end

	// GET_MEM_ADR state ///////////////////////////////////////////////////////
        GET_MEM_ADR : // wait for memory address
        if (acc_done_a)
        begin
          state_r    <= #1 GMA_ACK ;
          mem_addr_r <= #1 shift_r ; // store memory address
          sda_o_r    <= #1 !(shift_r <= 15) ; // generate i2c_ack, for valid address

          if (debug_a)
            #1 $display ("DEBUG i2cm_slave; address received. adr=%x, ack=%b", shift_r, sda_o_r) ;
        end

	// GMA_ACK state ///////////////////////////////////////////////////////////
        GMA_ACK : 
        begin
          state_r <= #1 DATA ;
          load_r  <= #1 1'b1 ;
        end

	// DATA state //////////////////////////////////////////////////////////////
	DATA : // receive or drive data
        begin
          if (rw_r)
            sda_o_r <= #1 mem_data_r [7] ;

          if (acc_done_a)
          begin
            state_r    <= #1 DATA_ACK ;
            mem_addr_r <= #2 mem_addr_r + 8'h1 ;

            if (rw_r)
            begin
              #3 mem_data_r <= mem_r [mem_addr_r] ;

              if (debug_a)
                #5 $display ("DEBUG i2cm_slave; data block read %x from address %x (2)", mem_data_r, mem_addr_r) ;
            end

            if (!rw_r)
            begin
              mem_r [ mem_addr_r [3:0] ] <= #1 shift_r ; // store data in memory

              if (debug_a)
                #2 $display("DEBUG i2cm_slave; data block write %x to address %x", shift_r, mem_addr_r) ;
            end

            sda_o_r <= #1 (rw_r && (mem_addr_r <= 15) ) ; // send ack on write, receive ack on read
          end
        end

	// DATA_ACK state //////////////////////////////////////////////////////////
        DATA_ACK :
        begin
          load_r <= #1 1'b1 ;

          if (rw_r)
            if (sda) // read operation && master send NACK
            begin
              state_r <= #1 IDLE ;
              sda_o_r <= #1 1'b1 ;
            end
            else
            begin
              state_r <= #1 DATA ;
              sda_o_r <= #1 mem_data_r [7] ;
            end
          else
          begin
            state_r <= #1 DATA ;
            sda_o_r <= #1 1'b1 ;
          end
        end

    endcase
  end


//////////////////////////////////////////////////////////////////////////////////
// 10_ReadDataFromMemory /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

always @(posedge scl)
  if (!acc_done_a && rw_r)
    mem_data_r <= #1 {mem_data_r [6:0], 1'b1} ; // insert 1'b1 for host ack generation


//////////////////////////////////////////////////////////////////////////////////
// 11_TriStates //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
assign sda = sda_o_r ? 1'bz : 1'b0 ;


endmodule
