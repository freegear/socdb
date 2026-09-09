//----------------------------------------------------------------------
//
// Copyright (c) 2000-2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI Core 64/66
//
//  File          : pci_target64model.vhd
//
//  Dependencies  : pci64_package.vhd
//
//  Model Type:   : Simulation Model
//
//  Description   : 64-bit Target_Model
//
//  Designer      : AS
//
//  QA Engineer   :  NS 
//
//  Creation Date : 1-September-2000
//
//  Last Update   : 30-July-2003
//
//  Version       : 2.0
//----------------------------------------------------------------------
`timescale 1 ns / 1 ps
module target64_model (rstn, clk, adio, cbe, par, par64, idsel, framen, req64n, irdyn, trdyn, devseln, ack64n, stopn, perrn, serrn, params_enabled, end_sim);

   parameter ENABLE64 = 1'b1;
   parameter DEC_SPEED = 1;
   parameter VECT_FILENAME = "VECT_FILENAME";
   parameter LOG_FILENAME = "LOG_FILENAME";
   parameter BASE_ADDR = 32'hD8000000;
   parameter SIZE = 32'h00001000;

   `include "pci64_params.v"

   input rstn; // Reset	
   input clk; // Clock	
   inout[63:0] adio; // Address/Data Bus
   wire[63:0] adio;
   reg[63:0] adio_net;
   input[7:0] cbe; // Command/Byte Enable
   inout par; // paro
   wire par;
   reg par_net;
   inout par64; // paro
   wire par64;
   reg par64_net;
   input idsel; // Chip Select
   input framen; // Transaction Frame
   input req64n; // Transaction Frame
   input irdyn; // Initiator Ready
   output trdyn; // Target Ready
   wire trdyn;
   output devseln; // Device Select
   wire devseln;
   output ack64n; // Device Select
   wire ack64n;
   output stopn; // Stop transaction
   wire stopn;
   inout perrn; // paro Error (s/t/s)
   wire perrn;
   wire perrn_net;
   inout serrn; // System Error (o/d) 
   wire serrn;
   wire serrn_net;
   input params_enabled; 
   input end_sim; 

   parameter CLK_Period = 15; // 66MHz timing 
   parameter CTO_Delay = 6; // Clock-to-Out delay
   parameter TRDY_DLY = 1; 
   parameter TM_IDLE = 0; 
   parameter TM_CMD = 1; 
   parameter TM_DATA = 2; 
   parameter TM_TURNAR = 3; 
   reg[1:0] target_state; 
   reg bar_hit; // card address space hit
   reg framen_q; // registered framen
   wire req64n_q; // registered 
   reg irdyn_q; // registered 
   reg trdyn_q; // registered 
   reg stopn_q; // registered 
   reg oe_ctrl; 
   reg devselno; // devseln output
   reg trdyno; // trdyn output
   reg stopno; // stopn output
   reg ack64no; // ack64n output
   reg[63:0] adi; // AD input bus
   reg[63:0] ado; 
   reg[31:0] addr_reg; // address register/counter
   reg[3:0] cmd_reg; // command register 
   reg oe_data; // AD output bus
   integer access_count; 
   integer DataCyc; 
   reg oepar; //
   reg oepar64; //
   reg paro; // output par (before tristate buffer)
   reg cparo; // computed par (before error insertion)
   reg par64o; // output par64(before tristate buffer)        
   reg cpar64o; // computed par64 (before error insertion)
   reg width64_q; // master requsted 64-bit transaction 
   reg[31:0] cyc_params_addr; 
   reg[3:0] cyc_params_cmd; 
   reg[7:0] cyc_params_ben; 
   reg[63:0] cyc_params_data; 
   integer cyc_params_wscyc; 
   reg cyc_params_genperr; 
   reg cyc_params_genperr64; 
   reg[2:0] cyc_params_term; 
   integer cyc_per_cnt; // target clock period count in a cycle

   integer vect_out_file;

   reg[63:0] cpmem [0:8*TARGET_VEC_LINES-1];
   reg[63:0] targetvecdata;

   // 
   //file vect_out_file : TEXT;-- open WRITE_MODE is LOG_FILENAME;
   //file cyc_file : TEXT;-- open READ_MODE is VECT_FILENAME;
   //-----------------------------------------------------
   // Procedures and Functions from SIM_TOOLS package
   //-----------------------------------------------------
   //-----------------------------------------------------------------------------
   // function compare_vectors
   //-----------------------------------------------------------------------------
   // parameters:
   //    rv : std_logic_vector - result vector
   //    ev : std_logic_vector - expected vector
   // return: boolean - TRUE when equal
   // description:
   //    compares rv to ev bits with exception of ev\'s don\'t care bits (\'X\')
   //-----------------------------------------------------------------------------
   function [0:0] compare_vectors;
      input[31:0] rv; 
      input[31:0] ev; 
      reg equal; 
      begin
         equal = 1'b1;
         begin : equal_l1
            integer i;
            for(i = 31; i >= 0; i = i - 1)
            begin
               if (rv[i] != ev[i] & (ev[i] != 1'bx))
               begin
                  equal = 1'b0; 
               end 
            end
         end 
         compare_vectors = equal; 
      end
   endfunction

   //--------------------------------------------------------------------------
   //  Procedure GenParity
   //--------------------------------------------------------------------------
   task gen_pci_parity;
      input[31:0] D; 
      input[3:0] BEn; 
      inout Par; 
      reg[8:0] P; 
      begin
         // paro Tree
         P[0] = D[0] ^ D[1] ^ D[2] ^ D[3]; 
         P[1] = D[4] ^ D[5] ^ D[6] ^ D[7]; 
         P[2] = D[8] ^ D[9] ^ D[10] ^ D[11]; 
         P[3] = D[12] ^ D[13] ^ D[14] ^ D[15]; 
         P[4] = D[16] ^ D[17] ^ D[18] ^ D[19]; 
         P[5] = D[20] ^ D[21] ^ D[22] ^ D[23]; 
         P[6] = D[24] ^ D[25] ^ D[26] ^ D[27]; 
         P[7] = D[28] ^ D[29] ^ D[30] ^ D[31]; 
         P[8] = BEn[0] ^ BEn[1] ^ BEn[2] ^ BEn[3]; 
         Par = (P[0] ^ P[1] ^ P[2] ^ P[3] ^ P[4] ^ P[5] ^ P[6] ^ P[7] ^ P[8]) ; 
      end
   endtask

   assign adio = adio_net;
   assign par = par_net;
   assign par64 = par64_net;
   assign perrn = perrn_net;
   assign serrn = serrn_net;

   //--------------------------------------------------------------------------
   //  Procedure fetch_cparams
   //--------------------------------------------------------------------------
   // parameters:
   //    file parfile :text ; --the parameter file - must be open in READ_MODE
   //    params : tTARGET64_CYCLE; -- model\'s transaction parameter
   // description:
   //    reads data from the parameter file, converts to the target cycle 
   //    parameters 
   //  addr cmd ben data wscyc term
   //--------------------------------------------------------------------------
   task fetch_cparams;
      inout[31:0] params_addr;
      inout[3:0] params_cmd;
      inout[7:0] params_ben;
      inout[63:0] params_data;
      inout params_wscyc;
      integer params_wscyc;
      inout params_genperr;
      inout params_genperr64;
      inout[2:0] params_term;
      inout loc;
      integer loc;
      begin
         begin : read_targetvec
               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_addr = targetvecdata[31:0]; // read address in hex format (8 chars)

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_cmd = targetvecdata[3:0]; // read command in hex        (1 char)

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_ben = targetvecdata[7:0]; // read byte enables in hex   (2 chars)

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_data = targetvecdata[63:0]; // read data in hex format    (16 chars)

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_wscyc = targetvecdata[3:0]; // read data in int format    (1-2 chars)

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_genperr = targetvecdata[0]; // read data in boolean format

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_genperr64 = targetvecdata[0]; // read data in boolean format

               if (loc > 8*TARGET_VEC_LINES-1) disable read_targetvec;
               read_data(targetvecdata, loc);
               params_term = targetvecdata[2:0]; // read data in hex format
               case (params_term)
                  3'b000: begin
                            $display("** Note: T_CONTINUE");
                         end
                  3'b001: begin
                            $display("** Note: T_ABORT");
                         end
                  3'b010: begin
                            $display("** Note: T_RETRY");
                         end
                  3'b011: begin
                            $display("** Note: T_DISC_W_DATA");
                         end
                  3'b100: begin
                            $display("** Note: T_DISC_WO_DATA");
                         end
                  3'b101: begin
                            $display("** Note: MASTER_END");
                         end
                  default: begin
                            $display("** Note: Invalid Terminate Type");
                         end
               endcase
         end
      end
   endtask

   task read_data;
      output [63:0] vecdata;
      inout fieldnumber;
      integer fieldnumber;
      begin
        vecdata = cpmem[fieldnumber];
        fieldnumber = fieldnumber + 1;
      end
   endtask


   //--------------------------------------------------------------------------
   //  main code
   //--------------------------------------------------------------------------
   assign par = 1'bZ ; 
   assign perrn = 1'bZ ; 
   assign serrn = 1'bZ ; 
   assign devseln = (oe_ctrl == 1'b1) ? devselno : 1'bZ ; 
   assign trdyn = (oe_ctrl == 1'b1) ? trdyno : 1'bZ ; 
   assign stopn = (oe_ctrl == 1'b1) ? stopno : 1'bZ ; 
   assign ack64n = (oe_ctrl == 1'b1) ? ack64no : 1'bZ ; 

   initial
   begin
      $readmemh (VECT_FILENAME, cpmem);
      vect_out_file = $fopen(LOG_FILENAME);
   end


   always @(posedge clk or negedge rstn)
   begin : pIrdyReg
      if (rstn == 1'b0)
      begin
         irdyn_q <= 1'b1 ; 
      end
      else
      begin
         irdyn_q <= irdyn ; 
      end 
   end 

   always @(posedge clk or negedge rstn)
   begin : pTrdyReg
      if (rstn == 1'b0)
      begin
         trdyn_q <= 1'b1 ; 
      end
      else
      begin
         trdyn_q <= trdyno ; 
      end 
   end 

   always @(posedge clk or negedge rstn)
   begin : pStopReg
      if (rstn == 1'b0)
      begin
         stopn_q <= 1'b1 ; 
      end
      else
      begin
         stopn_q <= stopno ; 
      end 
   end 

   // width 64 decoding
   always @(posedge clk or negedge rstn)
   begin : pwidth64
      if (rstn == 1'b0)
      begin
         width64_q <= 1'b0 ; 
      end
      else
      begin
         if (framen_q != 1'b0 & framen == 1'b0)
         begin
            if (req64n == 1'b0)
            begin
               width64_q <= 1'b1 ; 
            end
            else
            begin
               width64_q <= 1'b0 ; 
            end 
         end 
      end 
   end 

   // addr_reg Comparator
   always @(adio or framen or framen_q)
   begin : AdrCmp
      if (framen == 1'b0 & framen_q != 1'b0)
      begin
         if ((adio[31:0] >= BASE_ADDR) & (adio[31:0] < BASE_ADDR + SIZE))
         begin
            bar_hit = 1'b1 ; 
         end
         else
         begin
            bar_hit = 1'b0 ; 
         end 
      end
      else
      begin
         bar_hit = 1'b0 ; 
      end 
   end 

   // Input Address/Data Register
   always @(posedge clk or negedge rstn)
   begin : ADiReg
      if (rstn == 1'b0)
      begin
         adi <= {64{1'b0}} ; 
      end
      else
      begin
         adi <= adio ; 
      end 
   end 

   // cmd_reg Register
   always @(posedge clk or negedge rstn)
   begin : pCmdReg
      if (rstn == 1'b0)
      begin
         cmd_reg <= 4'b0000 ; 
      end
      else
      begin
         if (target_state == TM_IDLE & framen == 1'b0 & framen_q != 1'b0)
         begin
            cmd_reg <= cbe[3:0] ; 
         end 
      end 
   end 

   // addr_reg Counter
   always @(posedge clk or negedge rstn)
   begin : pAddressReg
      if (rstn == 1'b0)
      begin
         addr_reg <= {32{1'b0}} ; 
      end
      else
      begin
         if (target_state == TM_IDLE & framen == 1'b0 & framen_q != 1'b0)
         begin
            addr_reg <= adio[31:0] ; 
         end
         else if ((target_state == TM_DATA) & (irdyn == 1'b0) & (trdyno == 1'b0))
         begin
            if (ack64no == 1'b0)
            begin
               addr_reg <= addr_reg + 8 ; 
            end
            else
            begin
               addr_reg <= addr_reg + 4 ; 
            end 
         end 
      end 
   end 

   //
   always @(posedge clk or negedge rstn)
   begin : scs
      if (rstn == 1'b0)
      begin
         //asynchronous RESET 
         cyc_per_cnt <= 0 ; 
      end
      else
      begin
         if (target_state == TM_DATA)
         begin
            //CLK rising edge
            if (irdyn == 1'b0 & trdyno == 1'b0)
            begin
               cyc_per_cnt <= 0 ; 
            end
            else
            begin
               cyc_per_cnt <= cyc_per_cnt + 1 ; 
            end 
         end
         else
         begin
            cyc_per_cnt <= 0 ; 
         end 
      end 
   end 

   // Output Buffer stearing for PCI control pins
   always @(target_state)
   begin : pOECTRL
      if (target_state != TM_IDLE)
      begin
         oe_ctrl = 1'b1 ; 
      end
      else
      begin
         oe_ctrl = 1'b0 ; 
      end 
   end 

   // devseln pin control
   always @(target_state or DataCyc or cyc_params_term or cyc_params_wscyc or 
            cyc_per_cnt)
   begin : pDEVSELno
      if (target_state == TM_DATA)
      begin
         if ((cyc_params_term == T_ABORT) & (cyc_per_cnt >= cyc_params_wscyc))
         begin
            devselno <= #CTO_Delay 1'b1 ; // Target Abort
         end
         else
         begin
            devselno <= #CTO_Delay 1'b0 ; 
         end 
      end
      else
      begin
         devselno <= #CTO_Delay 1'b1 ; 
      end 
   end 

   // ack64n pin control
   always @(target_state or DataCyc or req64n or cyc_params_term or cyc_params_wscyc or 
            cyc_per_cnt)
   begin : pACK64no
      if (target_state == TM_DATA)
      begin
         if ((cyc_params_term == T_ABORT) & (cyc_per_cnt >= cyc_params_wscyc))
         begin
            ack64no <= #CTO_Delay 1'b1 ; 
         end
         else if ((width64_q == 1'b1) & ENABLE64)
         begin
            ack64no <= #CTO_Delay 1'b0 ; 
         end
         else
         begin
            ack64no <= #CTO_Delay 1'b1 ; 
         end 
      end
      else
      begin
         ack64no <= #CTO_Delay 1'b1 ; 
      end 
   end 

   // trdyn pin control
   always @(target_state or cyc_per_cnt or cyc_params_term or cyc_params_wscyc or 
            stopn_q or irdyn_q)
   begin : pTRDYno
      if ((target_state == TM_DATA) & (cyc_per_cnt >= cyc_params_wscyc) & (cyc_params_term != T_RETRY) & (cyc_params_term != T_DISC_WO_DATA) & (cyc_params_term != T_ABORT) & (~(cyc_params_term == T_DISC_W_DATA & stopn_q == 1'b0 & irdyn_q == 1'b0)))
      begin
         trdyno <= #CTO_Delay 1'b0 ; 
      end
      else
      begin
         trdyno <= #CTO_Delay 1'b1 ; 
      end 
   end 

   // stopn pin control
   always @(target_state or cyc_params_term or cyc_params_wscyc or cyc_per_cnt)
   begin : pSTOPno
      if ((target_state == TM_DATA) & (cyc_per_cnt >= cyc_params_wscyc) & (cyc_params_term == T_RETRY | cyc_params_term == T_DISC_WO_DATA | cyc_params_term == T_DISC_W_DATA | cyc_params_term == T_ABORT))
      begin
         stopno <= #CTO_Delay 1'b0 ; 
      end
      else
      begin
         stopno <= #CTO_Delay 1'b1 ; 
      end 
   end 

   //  AD control
   always @(target_state or cmd_reg or ado)
   begin : pDATA
      if (target_state == TM_DATA & (cmd_reg[0]) == 1'b0)
      begin
         adio_net = ado ; 
         oe_data = 1'b1 ; 
      end
      else
      begin
         adio_net = {64{1'bZ}} ; 
         oe_data = 1'b0 ; 
      end 
   end 

   // paro computation
   always @(ado or cbe)
   begin : pGPAR
      gen_pci_parity(ado[31:0], cbe[3:0], cparo); 
   end 

   // paro error insertion
   //
   always @(posedge clk or negedge rstn)
   begin : pParreg
      if (rstn == 1'b0)
      begin
         //asynchronous RESET 
         paro <= 1'b0 ; 
      end
      else
      begin
         //CLK rising edge
         if (cyc_params_genperr)
         begin
            paro <= ~(cparo) ; 
         end
         else
         begin
            paro <= (cparo) ; 
         end 
      end 
   end 

   //
   always @(posedge clk or negedge rstn)
   begin : pOePar
      if (rstn == 1'b0)
      begin
         //asynchronous RESET 
         oepar <= 1'b0 ; 
      end
      else
      begin
         //CLK rising edge
         if (target_state == TM_DATA & (cmd_reg[0]) == 1'b0)
         begin
            oepar <= 1'b1 ; 
         end
         else
         begin
            oepar <= 1'b0 ; 
         end 
      end 
   end 

   // paro output control
   always @(paro or oepar)
   begin : pPAR
      if (oepar == 1'b1)
      begin
         par_net <= #CTO_Delay paro ; 
      end
      else
      begin
         par_net <= #CTO_Delay 1'bZ ; 
      end 
   end 

   // 64-bit paro computation
   always @(ado or cbe)
   begin : pGPAR64
      gen_pci_parity(ado[63:32], cbe[7:4], cpar64o); 
   end 

   // 64-bit paro register with error insertion
   always @(posedge clk or negedge rstn)
   begin : pPar64reg
      if (rstn == 1'b0)
      begin
         //asynchronous RESET 
         par64o <= 1'b0 ; 
      end
      else
      begin
         //CLK rising edge
         if (cyc_params_genperr64)
         begin
            par64o <= ~(cpar64o) ; 
         end
         else
         begin
            par64o <= (cpar64o) ; 
         end 
      end 
   end 

   always @(posedge clk or negedge rstn)
   begin : pOePar64
      if (rstn == 1'b0)
      begin
         //asynchronous RESET 
         oepar64 <= 1'b0 ; 
      end
      else
      begin
         //CLK rising edge
         if (target_state == TM_DATA & (cmd_reg[0]) == 1'b0 & width64_q == 1'b1 & ENABLE64)
         begin
            oepar64 <= 1'b1 ; 
         end
         else
         begin
            oepar64 <= 1'b0 ; 
         end 
      end 
   end 

   // 64-bit paro output control
   always @(par64o or oepar64)
   begin : pPAR64
      if (oepar64 == 1'b1)
      begin
         par64_net <= #CTO_Delay par64o ; 
      end
      else
      begin
         par64_net <= #CTO_Delay 1'bZ ; 
      end 
   end 

   // access phase count
   always @(posedge clk or negedge rstn)
   begin : pACNT
      if (rstn == 1'b0 | target_state == TM_IDLE)
      begin
         access_count <= 0 ; 
      end
      else
      begin
         if (target_state == TM_TURNAR)
         begin
            access_count <= 0 ; 
         end
         else
         begin
            access_count <= access_count + 1 ; 
         end 
      end 
   end 

   //
   always @(posedge clk or negedge rstn)
   begin : pDataCyc
      if (rstn == 1'b0 | target_state == TM_IDLE)
      begin
         DataCyc <= 0 ; 
      end
      else
      begin
         if (target_state == TM_DATA)
         begin
            DataCyc <= DataCyc + 1 ; 
         end
         else
         begin
            DataCyc <= 0 ; 
         end 
      end 
   end 

   // TM_DATA Update
   always @(posedge clk or negedge rstn)
   begin : pDataUpdate
      reg InitDone; 
      reg[31:0] cp_addr; 
      reg[3:0] cp_cmd; 
      reg[7:0] cp_ben; 
      reg[63:0] cp_data; 
      integer cp_wscyc; 
      reg cp_genperr; 
      reg cp_genperr64; 
      reg[2:0] cp_term; 
      integer lnum; 

      InitDone = 1'b0;
      if (rstn == 1'b0 & ~InitDone)
      begin
         lnum = 0; 
         cyc_params_addr <= {32{1'b0}} ; 
         cyc_params_cmd <= {4{1'b0}} ; 
         cyc_params_ben <= {8{1'b0}} ; 
         cyc_params_data <= {64{1'b0}} ; 
         cyc_params_wscyc <= 0 ; 
         cyc_params_genperr <= 1'b0 ; 
         cyc_params_genperr64 <= 1'b0 ; 
         cyc_params_term <= T_CONTINUE ; 
         ado <= cp_data ; 

         //FILE_OPEN (fopen_status,cyc_file, VECT_FILENAME, READ_MODE);
         //case (fopen_status)
         //   open_ok :
         //            begin
         //               $display(" %d - File open OK (NOTE)", VECT_FILENAME); 
         //            end
         //   default :
         //            begin
         //               $display(" %d - File open failed (FAILURE)", VECT_FILENAME); 
         //            end
         //endcase 

         //FILE_OPEN (fopen_status,vect_out_file, LOG_FILENAME, WRITE_MODE);
         //case (fopen_status)
         //   open_ok :
         //            begin
         //               $display(" %d - File open OK (NOTE)", LOG_FILENAME); 
         //            end
         //   default :
         //            begin
         //               $display(" %d - File open failed (FAILURE)", LOG_FILENAME); 
         //            end
         //endcase 
         if (vect_out_file != 0)
         begin
             $display(" %s - File open OK (NOTE)", LOG_FILENAME); 
         end
         else
         begin
             $display(" %s - File open failed (FAILURE)", LOG_FILENAME); 
         end
         
         InitDone = 1'b1; 
      end
      else
      begin
         if ((target_state == TM_IDLE & framen == 1'b0 & framen_q != 1'b0 & bar_hit == 1'b1) | (target_state == TM_DATA & irdyn == 1'b0 & trdyno == 1'b0 & framen == 1'b0 & cyc_params_term != T_DISC_W_DATA & cyc_params_term != T_DISC_WO_DATA))
         begin
            fetch_cparams(cp_addr,cp_cmd,cp_ben,cp_data,cp_wscyc,cp_genperr,cp_genperr64,cp_term,lnum);
            if (target_state == TM_IDLE & DEC_SPEED == FAST & (cbe[0]) == 1'b0 & cp_wscyc < 1)
            begin
               cp_wscyc = 1; 
            end 
            if (target_state == TM_IDLE & cp_wscyc < 1 & cp_term == T_ABORT)
            begin
               cp_wscyc = 1; 
            end 
            cyc_params_addr <= cp_addr ; 
            cyc_params_cmd <= cp_cmd ; 
            cyc_params_ben <= cp_ben ; 
            cyc_params_data <= cp_data ; 
            cyc_params_wscyc <= cp_wscyc ; 
            cyc_params_genperr <= cp_genperr ; 
            cyc_params_genperr64 <= cp_genperr64 ; 
            cyc_params_term <= cp_term ; 
            ado <= cp_data ; 
         end 
      end 
   end 

   //  Target State Machine 
   always @(posedge clk or negedge rstn)
   begin : FSM
      if (rstn == 1'b0)
      begin
         target_state <= TM_IDLE ; 
      end
      else
      begin
         case (target_state)
            TM_IDLE :
                     begin
                        if (params_enabled == 1'b1 & framen == 1'b0 & framen_q != 1'b0 & bar_hit == 1'b1)
                        begin
                           if (DEC_SPEED == FAST)
                           begin
                              target_state <= TM_DATA ; 
                           end
                           else
                           begin
                              target_state <= TM_CMD ; 
                           end 
                        end 
                     end
            TM_CMD :
                     begin
                        case (DEC_SPEED)
                           FAST :
                                    begin
                                       if (access_count >= 0)
                                       begin
                                          target_state <= TM_DATA ; 
                                       end 
                                    end
                           MEDIUM :
                                    begin
                                       if (access_count >= 0)
                                       begin
                                          target_state <= TM_DATA ; 
                                       end 
                                    end
                           SLOW :
                                    begin
                                       if (access_count >= 1)
                                       begin
                                          target_state <= TM_DATA ; 
                                       end 
                                    end
                           SUB :
                                    begin
                                       if (access_count >= 2)
                                       begin
                                          target_state <= TM_DATA ; 
                                       end 
                                    end
                        endcase 
                     end
            TM_DATA :
                     begin
                        if (framen == 1'b1 & irdyn == 1'b0 & (trdyno == 1'b0 | stopno == 1'b0))
                        begin
                           target_state <= TM_TURNAR ; 
                        end 
                     end
            TM_TURNAR :
                     begin
                        target_state <= TM_IDLE ; 
                     end
         endcase 
      end 
   end 

   // framen input FF
   always @(posedge clk or negedge rstn)
   begin : pFrameReg
      if (rstn == 1'b0)
      begin
         framen_q <= 1'b1 ; 
      end
      else
      begin
         framen_q <= framen ; 
      end 
   end 

   // data recorder
   always @(posedge clk or negedge rstn)
   begin : pDataRecord
      reg equal; 
      if (rstn == 1'b0)
      begin
      end
      else 
      begin
         if (target_state == TM_DATA & irdyn == 1'b0 & trdyno == 1'b0)
         begin
            if (stopno == 1'b0)
            begin
               $fdisplay(vect_out_file, $stime," ns   %h  %h  %h  - Transaction Disconnected", cmd_reg, addr_reg, adio);
            end
            else if (framen == 1'b1)
               begin
                  $fdisplay(vect_out_file, $stime," ns   %h  %h  %h  - Transaction terminated normaly by Master", cmd_reg, addr_reg, adio);
               end
               else
                  $fdisplay(vect_out_file, $stime, " ns   %h  %h  %h ", cmd_reg, addr_reg, adio);
                
            if ((cmd_reg[0]) == 1'b1)
            begin
               // write command => compare to expected data
               equal = compare_vectors(adio[31:0], cyc_params_data[31:0]); 
               if (width64_q == 1'b1 & ENABLE64)
               begin
                  equal = equal & compare_vectors(adio[31:0], cyc_params_data[31:0]); 
               end 
               if (equal)
               begin
                  $display("TARGET64MODEL: Written data match expected result (NOTE)"); 
               end
               else
               begin
                  $display("TARGET64MODEL: Written data does not match expected result (WARNING)"); 
               end 
            end 
         end
      end 
   end 

   // end logfile records
   //always @(params_enabled)
   //begin : pCloseLogFile
   //   if (params_enabled == 1'b0)
   //   begin
   //      $fclose(vect_out_file);
   //      //file_close(cyc_file); 
   //   end 
   //end 
   
   //always @(posedge end_sim)
   //begin
   //   $fclose(vect_out_file);
   //end


   // *************************************************************************
   // *                         Protocol Checker                              *
   // *************************************************************************
   //
   // 8 Clock Rule Checker
   // Initiator must assert irdyn within 8 clock cycles after framen assertion
   //
   always @(posedge clk)
   begin : C8_Rule
      integer count; 
      if (framen == 1'b0 & irdyn == 1'b1)
      begin
         count = count + 1; 
      end
      else
      begin
         count = 0; 
      end 
      // JS if (~(count <= 8)) $display("PCI protocol violation: Initiator 8'clock rule violation %d  %d Must must assert IRDY# within 8 clock cycles (ERROR)", CR, LF);  
   end 

   //
   // 16 Clock Rule Checker 
   // Target must deliver/receive data within 16 clock cycles after irdyn assertion
   //
   always @(posedge clk)
   begin : C16_Rule
      integer data_latency_cnt; 
      if (irdyn == 1'b0 & trdyno == 1'b1 & target_state == TM_DATA)
      begin
         data_latency_cnt = data_latency_cnt + 1; 
      end
      else
      begin
         data_latency_cnt = 0; 
      end 
      // JS if (~(data_latency_cnt = 16)) $display("PCI protocol violation: Target 16'clock rule violation %d  %d Target must send data or disconnect within 16 clock cycles (ERROR)", CR, LF);  
   end 
endmodule
