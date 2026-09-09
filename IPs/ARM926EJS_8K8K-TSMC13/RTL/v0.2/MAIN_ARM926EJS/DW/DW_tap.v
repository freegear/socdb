//-----------------------------------------------------------------------------
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1998 - 2004 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Bob Tong                   May 1, 1998           
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: 7f94c4d3
// DesignWare_release: V-2004.06-DWF_0406
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  TAP Controller
//
//
//    Parameters:       Valid Values
//    ==========        ============
//    width             [2 to 32]
//    id                [0 = not present,
//                        1 = present] 
//    version           [0 to 15]
//    part              [0 to 65535] 
//    man_num           [0 to 2047] 
//                      ( not equal to 127 ) 
//          
//    sync_mode         [0 = asynchronous,
//                        1 = synchrounous]    
//
//  Input Ports:    Size        Description
//  ===========     ====        ===========
//  tck              1 bit      Test clock 
//  trst_n           1 bit      Test reset, active low 
//  tms              1 bit      Test mode select 
//  tdi              1 bit      Test data in 
//  so               1 bit      Serial data from boundary scan 
//                                register and data registers 
//  bypass_sel       1 bit      Selects the bypass register 
//                         
//  sentinel_val    width - 1   User-defined status bits        
//                         
//  Output Ports    Size        Description
//  ============    ====        ===========
//  clock_dr         1 bit      Controls the boundary scan register     
//  shift_dr         1 bit      Controls the boundary scan register
//  update_dr        1 bit      Controls the boundary scan register
//  tdo              1 bit      Test data out
//  tdo_en           1 bit      Enable for tdo output buffer
//  tap_state       16 bit      Current state of the TAP 
//                                finite state machine
//  extest           1 bit      EXTEST decoded instruction
//  samp_load        1 bit      SAMPLE/PRELOAD decoded instruction
//  instructions    width       Instruction register output     
//
//
//
// MODIFIED:
//
//-----------------------------------------------------------------------
			  		
module DW_tap (
    tck, trst_n, tms, tdi, so, bypass_sel, sentinel_val, 
    clock_dr, shift_dr, update_dr, tdo, tdo_en, tap_state, extest, samp_load, 
    instructions, sync_capture_en, sync_update_dr );


  parameter width = 2;
  parameter id = 0;
  parameter version = 0;
  parameter part = 0;
  parameter man_num = 0;
  parameter sync_mode = 0;
 
  input  tck;
  input  trst_n;
  input  tms;
  input  tdi;
  input  so;
  input  bypass_sel;
  input  [(width - 2):0] sentinel_val;
 
  output  clock_dr;
  output  shift_dr;
  output  update_dr;
  output  tdo;
  output  tdo_en;
  output  [15:0] tap_state;
  output  extest;
  output  samp_load;
  output  [(width - 1):0] instructions;
  output  sync_capture_en;
  output  sync_update_dr;
 
 
  wire clock_dr;
  reg shift_dr;
  wire update_dr;
  reg tdo;
  wire tdo_en;
  reg [15:0] tap_state;
  wire extest;
  wire samp_load;

  wire clock_ir;
  reg shift_ir;
  wire update_ir;

  wire tck_n;
  reg fsm_rst;
  wire instr_rst;

  wire capture_clk_dr;
  reg capture_dr;
  wire capture_en_dr;
  wire data_in_int;
  reg bypass_so;

  wire capture_reg_dr_msb;
  reg [32:0] capture_reg_dr;

  wire capture_clk_ir;
  wire update_clk_ir;
  wire capture_en_ir;

  wire capture_reg_ir_msb;
  reg [width:0] capture_reg_ir;
  reg [(width - 1):0] update_reg_ir;
  wire instr_so;

  reg update_reg_ir_temp;
  reg update_reg_ir_temp_n;
  reg update_reg_ir_temp_by;

  wire id_sel;
  wire bypass_int;
  reg tdo_temp;
  wire id_so;

  wire sync_capture_ir;
 
  reg [4:0] version_vec_cnst;
  reg [16:0] part_vec_cnst;
  reg [11:0] man_num_vec_cnst;
  wire [31:0] id_code_vec;
 
  reg last_capture_clk_dr;
  reg last_capture_clk_ir;
  reg last_update_clk_ir;
  reg last_tck;
  reg last_tck_n;

  wire[(width - 1):0] instructions;
  wire sync_capture_en;
  wire sync_update_dr;
 
  `define true  1'b1
  `define false 1'b0
  `define logic_one 1'b1
  `define logic_zero 1'b0
  `define version_vec  version 
  `define part_vec  part 
  `define man_num_vec  man_num 
  // synopsys translate_off

  assign  tck_n  = (~(tck));
  assign  tdo_en = (shift_dr | shift_ir );
  assign  sync_capture_en = (~(shift_dr | (tap_state [3] | tap_state [4])));
  assign  sync_capture_ir = (~(shift_ir | (tap_state [10] | tap_state [11])));
  assign  sync_update_dr = tap_state [8];
  assign  clock_dr = ((tck | (~(tck | (tap_state [3] | tap_state [4])))) 
                           | (~(tap_state [3] | tap_state [4])));
  assign  clock_ir = ((tck | (~(tck | (tap_state [10] | tap_state [11])))) 
                           | (~(tap_state [10] | tap_state [11])));
  assign  update_dr = (tck_n & tap_state [8]);
  assign  update_ir = (tck_n & tap_state [15]);
  assign  instr_rst = (fsm_rst | (~trst_n ));
  assign  data_in_int = (tdi & shift_dr );
  assign  id_code_vec = {version_vec_cnst [3 : 0],part_vec_cnst [15 : 0],
                         man_num_vec_cnst [10 : 0],1'b1 };
  assign  capture_reg_dr_msb = (tdi);
  assign  id_so  = capture_reg_dr [0];
  assign  capture_reg_ir_msb = (tdi);
  assign  instr_so  = capture_reg_ir [0];
  assign  instructions  = update_reg_ir;
  assign  id_sel  = ( (update_reg_ir [0] & (~update_reg_ir [1])) 
                      & (~update_reg_ir_temp_n) );
  assign  extest = ( ((~update_reg_ir [0]) & (~update_reg_ir [1])) 
                      & (~update_reg_ir_temp_n) );
  assign  bypass_int = ( update_reg_ir [0] & update_reg_ir [1] 
                         & update_reg_ir_temp_by );
  assign  samp_load = ( ((~update_reg_ir [0]) & update_reg_ir [1]) 
                         & (~update_reg_ir_temp) );
  assign capture_clk_dr = (
   (sync_mode === 0 ) ? clock_dr : (
   tck ));
  assign capture_en_dr = (
   (sync_mode === 0 ) ? `logic_zero : (
   clock_dr ));
  assign capture_clk_ir = (
   (sync_mode === 0 ) ? clock_ir : (
   tck ));
  assign capture_en_ir = (
   (sync_mode === 0 ) ? `logic_zero : (
   sync_capture_ir ));
  assign update_clk_ir = (
   (sync_mode === 0 ) ? update_ir : (
   tck_n ));
 
  always @ (posedge tck or negedge trst_n)
    begin : next_state_proc
      integer state_var;
      begin : for_275
        integer i;
        for (i = 15; i >= 0 ;i = i-1)
          begin 
            if ( (tap_state [i] === 1'b1) )
              begin 
                state_var = i;
              end 
          end
      end

      if ( (trst_n === 1'b0) | (trst_n === 1'bx) )
        begin 
          state_var  =  0;
        end
      else if ( tck === 1'b1 ) 
        begin
          if ( (tms === 1'b0) | (tms === 1'bx) )
            begin 
              case (state_var)
                0 : begin
                      state_var = 1;
                    end
                2 : begin
                      state_var = 3;
                    end
                3 : begin
                      state_var = 4;
                    end
                5 : begin
                      state_var = 6;
                    end
                7 : begin
                      state_var = 4;
                    end
                8 : begin
                      state_var = 1;
                    end
                9 : begin
                      state_var = 10;
                    end
               10 : begin
                      state_var = 11;
                    end
               12 : begin
                     state_var = 13;
                    end
               14 : begin
                     state_var = 11;
                    end
               15 : begin
                     state_var = 1;
                    end
              endcase
            end
          else if ( tms === 1'b1 )
            begin 
              case (state_var )
                1 : begin
                      state_var = 2;
                    end
                2 : begin
                      state_var = 9;
                    end
                3 : begin
                      state_var = 5;
                    end
                4 : begin
                      state_var = 5;
                    end
                5 : begin
                      state_var = 8;
                    end
                6 : begin
                      state_var = 7;
                    end
                7 : begin
                      state_var = 8;
                    end
                8 : begin
                      state_var = 2;
                    end
                9 : begin
                      state_var = 0;
                    end
                10 : begin
                      state_var = 12;
                     end
                11 : begin
                       state_var = 12;
                     end
                12 : begin
                        state_var = 15;
                     end
                13 : begin
                        state_var = 14;
                     end
                14 : begin
                        state_var = 15;
                     end
                15 : begin
                        state_var = 2;
                     end
              endcase
            end 
          end 

      begin : for_349
        integer i;
        for (i = 15; i >= 0; i = i-1)
          begin 
            if ( state_var === i )
              begin 
                tap_state [i] <= 1'b1;
              end
            else
              begin
                tap_state [i] <= 1'b0;
              end 
          end
      end
    end 
 
  always @ (tck_n or negedge trst_n)
    begin : output1_proc
      reg shift_dr_var;
      reg shift_ir_var;
      reg fsm_rst_var;
      integer state_var;
      integer i;
      last_tck_n <= #1 tck_n;

      if ((trst_n === 1'b0) | (trst_n === 1'bx) )
        begin 
          fsm_rst <= 1'b1;
          shift_dr <= 1'b0;
          shift_ir <= 1'b0;
        end
      else
        begin
          begin : for_367
            for (i = 15; i >= 0 ; i = i-1)
              begin 
                if ( (tap_state [i] === 1'b1) )
                  begin 
                    state_var  = i;
                  end 
              end
          end
    
          case (state_var)
            0 : begin
                  fsm_rst_var = 1'b1;
                  shift_dr_var = 1'b0;
                  shift_ir_var = 1'b0;
                  end
            4 : begin
                  fsm_rst_var = 1'b0;
                  shift_dr_var = 1'b1;
                  shift_ir_var = 1'b0;
                  end
           11 : begin
                  fsm_rst_var = 1'b0;
                  shift_dr_var = 1'b0;
                  shift_ir_var = 1'b1;
                  end
       default: begin
                  fsm_rst_var = 1'b0;
                  shift_dr_var = 1'b0;
                  shift_ir_var = 1'b0;
                  end
          endcase
    
          if ( (tck_n === 1'b1) | 
             ( (tck_n === 1'bx) & (last_tck_n === 1'b0) ) )
            begin 
              if ( (last_tck_n === 1'bx) | 
                 ( (tck_n === 1'bx) & (last_tck_n === 1'b0) ) )
                begin 
                  if ( fsm_rst_var !== fsm_rst )
                    begin 
                      fsm_rst <= 1'bx;
                    end 
        
                  if ( shift_dr_var !== shift_dr )
                    begin 
                      shift_dr <= 1'bx;
                    end 
                  if ( shift_ir_var !== shift_ir )
                    begin 
                      shift_ir <= 1'bx;
                    end 
                end
              else
                begin
                  fsm_rst <= fsm_rst_var;
                  shift_dr <= shift_dr_var;
                  shift_ir <= shift_ir_var;
                end 
            end 
        end
    end 
 
  always @ (capture_clk_dr)
    begin : bypass_seq1_proc
      last_capture_clk_dr <= #1 capture_clk_dr;
      capture_dr <= tap_state [3];

      if ( (capture_clk_dr === 1'b1) | 
         ( (capture_clk_dr === 1'bx) & 
 	(last_capture_clk_dr === 1'b0) ) )
        begin 
          if ( capture_dr === 1'b0 )
            begin 
              if ( capture_en_dr === 1'b0 )
                begin 
                  if ( (last_capture_clk_dr === 1'bx) | 
                     ( (capture_clk_dr === 1'bx) & 
                     (last_capture_clk_dr === 1'b0) ) )
                    begin 
                      if ( data_in_int !== bypass_so )
                        begin 
                          bypass_so <= 1'bx;
                        end 
                    end
                  else
                    begin
                      bypass_so <= data_in_int;
                    end 
                end
              else if ( capture_en_dr === 1'bx )
                begin 
                  if ( data_in_int !== bypass_so )
                    begin 
                      bypass_so <= 1'bx;
                    end 
                end 
            end
          else if ( capture_dr === 1'b1 )
            begin 
              if ( (last_capture_clk_dr === 1'bx) | 
                 ( (capture_clk_dr === 1'bx) & 
                 (last_capture_clk_dr === 1'b0) ) )
                begin 
                  if ( bypass_so !== 1'b0 )
                    begin 
                      bypass_so <= 1'bx;
                    end 
                end
              else
                begin
                  bypass_so <= 1'b0;
                end 
            end 
        end 
    end 
 
  always @ (capture_reg_dr_msb)
    begin 
      capture_reg_dr [32] = capture_reg_dr_msb;
    end
 
  always @ (capture_clk_dr)
    begin : idreg_seq1_proc
      last_capture_clk_dr <= #1 capture_clk_dr;

      begin : for_458
        integer i;
        for (i = 31; i >= 0 ; i = i-1)
          begin 
            if ( (capture_clk_dr === 1'b1) | 
               ( (capture_clk_dr === 1'bx) & 
               (last_capture_clk_dr === 1'b0) ) )
              begin 
                if ( capture_en_dr === 1'b0 )
                  begin 
                    if ( shift_dr === 1'b0 )
                      begin 
                        if ( (last_capture_clk_dr === 1'bx) | 
                           ( (capture_clk_dr === 1'bx) & 
                           (last_capture_clk_dr === 1'b0) ) )
                          begin 
                            if ( id_code_vec [i] !== capture_reg_dr [i] )
                              begin 
                                capture_reg_dr [i] <= 1'bx;
                              end 
                          end
                        else
                          begin
                            capture_reg_dr [i] <= id_code_vec [i];
                          end 
                      end
                    else if ( shift_dr === 1'b1 )
                      begin 
                        if ( (last_capture_clk_dr === 1'bx) | 
                           ( (capture_clk_dr === 1'bx) & 
                           (last_capture_clk_dr === 1'b0) ) )
                          begin 
                            if ( capture_reg_dr [(i+1)] 
 				  !== capture_reg_dr [i] )
                              begin 
                                capture_reg_dr [i] <= 1'bx;
                              end 
                          end
                        else
                          begin
                            capture_reg_dr [i] <= capture_reg_dr [(i+1)];
                          end 
                      end
                    else if ( capture_reg_dr [(i+1)] !== id_code_vec [i] )
                      begin 
                        capture_reg_dr [i] <= 1'bx;
                      end
                    else if ( (last_capture_clk_dr === 1'bx) | 
                            ( (capture_clk_dr === 1'bx) & 
                            (last_capture_clk_dr === 1'b0) ) )
                      begin 
                        if ( (capture_reg_dr [(i+1)] 
                           !== capture_reg_dr [i]))
                          begin 
                            capture_reg_dr [i] <= 1'bx;
                          end 
                      end
                    else
                      begin
                        capture_reg_dr [i] <= capture_reg_dr [(i+1)];
                      end 
                  end
                else if ( capture_en_dr === 1'bx )
                  begin 
                    if ( shift_dr === 1'b0 )
                      begin 
                        if ( id_code_vec [i] !== capture_reg_dr [i] )
                               begin 
                                 capture_reg_dr [i] <= 1'bx;
                               end 
                      end
                    else if ( shift_dr === 1'b1 )
                      begin 
                        if ( capture_reg_dr [(i+1)] 
                           !== capture_reg_dr [i] )
                          begin 
                            capture_reg_dr [i] <= 1'bx;
                          end 
                      end
                    else if ( capture_reg_dr [(i+1)] === id_code_vec [i] )
                      begin 
                        if ( capture_reg_dr [(i+1)] 
                           !== capture_reg_dr [i] )
                          begin 
                            capture_reg_dr [i] <= 1'bx;
                          end 
                      end
                    else
                      begin
                        capture_reg_dr [i] <= 1'bx;
                      end 
                  end 
              end 
          end
      end
    end 
 
  always @ (capture_reg_ir_msb)
    begin 
      capture_reg_ir [width] = capture_reg_ir_msb;
    end
 
  always @ (capture_clk_ir)
    begin : instrreg_seq1_proc
      reg[(width  -  1 ): 0] data_in_ir;
      last_capture_clk_ir <= #1 capture_clk_ir;

      begin : for_520
        integer i;
        for (i = (width-1); i >= 0 ; i = i-1)
          begin 
            if ( i > 1 )
              begin 
                data_in_ir [i] = sentinel_val [(i-2)];
              end
            else
              begin
                data_in_ir [1] = 1'b0;
                data_in_ir [0] = 1'b1;
              end 

            if ( (capture_clk_ir === 1'b1) | 
                 ( (capture_clk_ir === 1'bx) & 
                 (last_capture_clk_ir === 1'b0) ) )
              begin 
                if ( capture_en_ir === 1'b0 )
                  begin 
                    if ( shift_ir === 1'b0 )
                      begin 
                        if ( (last_capture_clk_ir === 1'bx ) | 
                           ( (capture_clk_ir === 1'bx ) & 
                           (last_capture_clk_ir === 1'b0) ) )
                          begin 
                            if ( data_in_ir [i] 
                                 !== capture_reg_ir [(i)] )
                              begin 
                                capture_reg_ir [i] <= 1'bx;
                              end 
                          end
                        else
                          begin
                            capture_reg_ir [i] <= data_in_ir [i];
                          end 
                      end
                    else if ( shift_ir === 1'b1 )
                      begin 
                        if ( (last_capture_clk_ir === 1'bx) | 
                             ( (capture_clk_ir === 1'bx) & 
                             (last_capture_clk_ir === 1'b0) ) )
                          begin 
                            if ( capture_reg_ir [(i+1)] 
                                 !== capture_reg_ir [i] )
                              begin 
                                capture_reg_ir [i] <= 1'bx;
                              end 
                          end
                        else
                          begin
                            capture_reg_ir [i] <= capture_reg_ir [(i+1)];
                          end 
                      end
                    else if ( capture_reg_ir [(i+1)] !== data_in_ir [i] )
                      begin 
                        capture_reg_ir [i] <= 1'bx;
                      end
                    else if ( (last_capture_clk_ir === 1'bx) | 
                            ( (capture_clk_ir === 1'bx) & 
                              (last_capture_clk_ir === 1'b0) ) )
                      begin 
                        if ( capture_reg_ir [(i+1)] 
                             !== capture_reg_ir [i] )
                          begin 
                            capture_reg_ir [i] <= 1'bx;
                          end 
                      end
                    else
                      begin
                        capture_reg_ir [i] <= capture_reg_ir [(i+1)];
                      end 
                  end
                else if ( capture_en_ir === 1'bx )
                  begin
                    if ( (capture_reg_ir [(i+1)] !== data_in_ir [i]))
                      begin 
                        capture_reg_ir [i] <= 1'bx;
                      end
                    else if ( capture_reg_ir [(i+1)] 
                              !== capture_reg_ir [i] )
                      begin 
                        capture_reg_ir [i] <= 1'bx;
                      end 
                  end 
              end 
          end
      end
    end 
 
  always @ (update_clk_ir or instr_rst)
    begin : instrreg_seq2_proc
      reg update_en_ir;

      if ( sync_mode === 0 )
        begin
          update_en_ir = `logic_one;
        end
      else
        begin
          update_en_ir = (tap_state [15] & tck_n);
        end

      if ( (instr_rst === 1'b0) | (instr_rst === 1'bx) )
        begin
          if ( instr_rst === 1'bx )
            begin
              if ( id === 0 )
                begin : for_399
                  integer i;
                  for (i = (width-1); i >= 0 ; i = i-1)
                    begin
                      if ( update_reg_ir [i] !== 1'b1 )
                        begin
                          update_reg_ir [i] <= 1'bx;
                        end
                    end
                end
              else if ( id === 1 )
                begin
                  if ( update_ir === 1'bx )
                    begin : for_490
                      integer i;
                      for (i = (width-1); i >= 1 ; i = i-1)
                        begin
                          if ( update_reg_ir [i] !== capture_reg_ir [i] )
                            begin
                              update_reg_ir [i] <= 1'bx;
                            end
                        end
                      if ( update_reg_ir [0] !== 1'b1 )
                            begin
                              update_reg_ir [i] <= 1'bx;
                            end
                    end
                  else
                    begin : for_499
                      integer i;
                      for (i = (width-1); i >= 1 ; i = i-1)
                        begin
                          if ( update_reg_ir [i] !== 1'b0 )
                            begin
                              update_reg_ir [i] <= 1'bx;
                            end
                        end
                      if ( update_reg_ir [0] !== 1'b1 )
                            begin
                              update_reg_ir [i] <= 1'bx;
                            end
                    end
                end
            end
          else
            begin
              last_update_clk_ir <= #1 update_clk_ir;
              begin : for_599
                integer i;
                for (i = (width-1); i >= 0 ; i = i-1)
                  begin
                    if ( (update_clk_ir === 1'b1) |
                       ( (update_clk_ir === 1'bx) &
                       (last_update_clk_ir === 1'b0) ) )
                      begin
                        if ( update_en_ir === 1'b1 )
                          begin
                            if ( (last_update_clk_ir === 1'bx) |
                               ( (update_clk_ir === 1'bx) &
                               (last_update_clk_ir === 1'b0) ) )
                              begin
                                if ( capture_reg_ir [i] !== update_reg_ir [i] )
                                  begin
                                    update_reg_ir [i] <= 1'bx;
                                  end
                              end
                            else
                              begin
                                update_reg_ir [i] <= capture_reg_ir [i];
                              end
                          end
                        else if ( update_en_ir === 1'bx )
                          begin
                            if ( capture_reg_ir [i] !== update_reg_ir [i] )
                              begin
                                update_reg_ir [i] <= 1'bx;
                              end
                          end
                      end
                  end
              end
            end
        end
      else if ( instr_rst === 1'b1 )
        begin
          if ( id === 0 ) 
            begin 
              update_reg_ir <= {width{1'b1}};
            end
          else if ( id === 1 ) 
            begin 
              update_reg_ir [(width-1): 1] <= {width{1'b0}};
              update_reg_ir [0] <= 1'b1;
            end 
        end
    end 
 
  always @ (bypass_sel or bypass_int or id_so or 
            id_sel or so or bypass_so)
    begin : tdo_combo1_proc
      if  ( (bypass_sel === 1'b1) | (bypass_int === 1'b1) )
        begin 
          tdo_temp = bypass_so;
        end
      else if ( (id ===  1) & (id_sel === 1'b1) )
        begin 
          tdo_temp = id_so;
        end
      else
        begin
          tdo_temp = so;
        end 
    end 
 
  always @ (update_reg_ir)
    begin : instr_decode1_proc
      reg update_reg_ir_temp_n_var;
      reg update_reg_ir_temp_var;
      reg update_reg_ir_temp_by_var;
      update_reg_ir_temp_n_var = update_reg_ir [(width - 1)];
      update_reg_ir_temp_var = update_reg_ir [(width - 1)];
      update_reg_ir_temp_by_var = update_reg_ir [(width - 1)];

      if ( width > 2 )
        begin 
          begin : for_651
            integer i;
            for (i = (width-1); i >= 2; i = i-1)
              begin 
                update_reg_ir_temp_var = (update_reg_ir_temp_var 
                    | update_reg_ir [i]);
                update_reg_ir_temp_n_var = (update_reg_ir_temp_n_var 
                    | update_reg_ir [i]);
                update_reg_ir_temp_by_var = (update_reg_ir_temp_by_var
                    & update_reg_ir [i]);
              end
          end
        end
      else
        begin
          update_reg_ir_temp_var = (~update_reg_ir [1]);
        end 

      update_reg_ir_temp_n  = update_reg_ir_temp_n_var;
      update_reg_ir_temp  = update_reg_ir_temp_var;
      update_reg_ir_temp_by = update_reg_ir_temp_by_var;
    end 

  always @ (tck_n)
    begin : select_seq1_proc
      last_tck_n <= #1 tck_n;
 
      if  ( (tck_n === 1'b1) | ( (tck_n === 1'bx) &
          (last_tck_n === 1'b0) ) )
        begin
          if ( tap_state [11] === 1'b0 )
            begin
              if ( (last_tck_n === 1'bx) | ( (tck_n === 1'bx) &
                 (last_tck_n === 1'b0) ) )
                begin
                  if ( tdo_temp !== tdo )
                    begin
                      tdo <= 1'bx;
                    end
                end
              else
                begin
                  tdo <= tdo_temp;
                end
            end
          else if ( tap_state [11] === 1'b1 )
            begin
              if ( (last_tck_n === 1'bx) | ( (tck_n === 1'bx) &
                 (last_tck_n === 1'b0) ) )
                begin
                  if ( instr_so !== tdo )
                    begin
                      tdo <= 1'bx;
                    end
                end
              else
                begin
                  tdo <= instr_so;
                end
            end
        end
    end
 
  initial
    begin 
      tap_state = 1'b0;
      update_reg_ir_temp = 1'b1;
      update_reg_ir_temp_n = 1'b0;
      update_reg_ir_temp_by = 1'b1;
      version_vec_cnst = version;
      part_vec_cnst = part;
      man_num_vec_cnst = man_num;
      output1_proc.shift_dr_var = 1'b0;
      output1_proc.shift_ir_var = 1'b0;
      output1_proc.fsm_rst_var = 1'b0;
    end
   // synopsys translate_on
 endmodule
