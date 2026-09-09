//----------------------------------------------------------------------
//
// Copyright (c) 2001-2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI Core
//
//  File          : pci64_busmonitor.vhd
//
//  Dependencies  : 
//
//  Model Type:   : simulation model
//
//  Description   : PCI bus monitor and protocol checker
//
//  Designer      : AS
//
//  QA Engineer   : NS
//
//  Creation Date : 16-August-2001
//
//  Last Update   : 25-August-2003
//
//  Version       : 2.0
//----------------------------------------------------------------------
//
module pci_busmonitor64 (rstn, clk, adio, cbe, par, par64, idsel, framen, req64n, irdyn, devseln, ack64n, trdyn, stopn, reqn, gntn, perrn, serrn, end_sim);

   parameter NUM_MASTERS  = 1;
   parameter TCTO  = 11;
   parameter TSU  = 7;
   `include "./pci64_params.v"

   input rstn; // Reset	
   input clk; // Clock	
   input[63:0] adio; // Address/Data Bus
   input[7:0] cbe; // Command/Byte Enable
   input par; // paro
   input par64; // paro
   input idsel; // Chip Select
   input framen; // Transaction Frame
   input req64n; // 64-bit acccess request
   input irdyn; // Initiator Ready
   input devseln; // Device Select
   input ack64n; // 64-bit access acknowledge
   input trdyn; // Target Ready
   input stopn; // Stop transaction 
   input reqn; 
   input gntn; 
   input perrn; // paro Error (s/t/s)
   input serrn; // System Error (o/d) 
   input end_sim; 

   //
   parameter[2:0] BUS_IDLE = 0; 
   parameter[2:0] BUS_CMD = 1; 
   parameter[2:0] BUS_DATA = 2; 
   parameter[2:0] BUS_TURNAR = 3; 
   parameter[2:0] BUS_PARK = 4; 
   reg[2:0] bus_state; 
   integer access_count; 
   integer DataCyc; 
   reg framen_r; 
   reg irdyn_r; 
   reg devseln_r; 
   reg trdyn_r; 
   reg stopn_r; 
   reg par_r; 
   reg perrn_r; 
   reg serrn_r; 
   reg[3:0] cmd_r; 
   reg[63:0] addr_reg; 
   reg[63:0] ad_r; 
   reg[7:0] cbe_r; 
   reg tp1_failed; 
   reg tp2_failed; 
   reg tp5_failed; 
   reg tp6_failed; 
   reg tp7_failed; 
   reg tp8_failed; 
   reg tp9_failed; 
   reg tp10_failed; 
   reg tp11_failed; 
   reg tp12_failed; 
   //
   reg tp17_failed; 
   //
   reg tp19_failed; 
   reg tp20_failed; 
   reg tp22_failed; 
   reg tp23_failed; 
   reg tp24_failed; 
   reg tp25_failed; 
   reg tp26_failed; 
   //
   reg tp28_failed; 
   reg tp29_failed; 
   reg tp30_failed; 
   reg tp31_failed; 
   reg tp32_failed; 
   //
   reg tp34_failed; 
   //
   reg data_phase_completed; 
   reg cmd_phase; 

   integer buslogfile;

   //--------------------------------------------------------------------------
   //  Procedure GenParity
   //--------------------------------------------------------------------------
   task gen_pci_parity;
      input[31:0] D; 
      input[3:0] BEn; 
      output Par; 

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
         Par = (P[0] ^ P[1] ^ P[2] ^ P[3] ^ P[4] ^ P[5] ^ P[6] ^ P[7] ^ P[8]); 
      end
   endtask

   //--------------------------------------------------------------------------
   //  Procedure TP1_Eval
   //--------------------------------------------------------------------------
   task TP1_Eval;
      input sig; 
      input sig_r; 
      input sigstr; 
      input f; 
      integer f;
      inout passed; 
      begin
         if (sig_r == 1'b0 & sig != 1'b1 & sig != 1'b0)
         begin
            $fdisplay(f, $stime, " ns", TP1_ERR_MSG1, sigstr, TP1_ERR_MSG2); 
            passed = 1'b0; 
         end 
      end
   endtask

   //--------------------------------------------------------------------------
   //  function cmd2str
   //--------------------------------------------------------------------------
   function [8*25:1] cmd2str;
      input[3:0] cmd; 

      begin
         case (cmd)
            IACK_CODE :
                     begin
                        cmd2str = "Interrupt Acknowledge"; 
                     end
            // Special Cycle
            SCYC_CODE :
                     begin
                        cmd2str = "Special Cycle"; 
                     end
            // I/O Read
            IORD_CODE :
                     begin
                        cmd2str = "I/O Read"; 
                     end
            // I/O Write
            IOWR_CODE :
                     begin
                        cmd2str = "I/O Write"; 
                     end
            // Reserved
            RES4_CODE :
                     begin
                        cmd2str = "Reserved Command"; 
                     end
            // Reserved
            RES5_CODE :
                     begin
                        cmd2str = "Reserved Command"; 
                     end
            // Memory Read
            MRD_CODE :
                     begin
                        cmd2str = "Memory Read"; 
                     end
            // Memory Write
            MWR_CODE :
                     begin
                        cmd2str = "Memory Write"; 
                     end
            // Reserved
            RES8_CODE :
                     begin
                        cmd2str = "Reserved Command"; 
                     end
            // Reserved
            RES9_CODE :
                     begin
                        cmd2str = "Reserved Command"; 
                     end
            // Configuration Read
            CFGRD_CODE :
                     begin
                        cmd2str = "Configuration Read"; 
                     end
            // Configuration Write
            CFGWR_CODE :
                     begin
                        cmd2str = "Configuration Write"; 
                     end
            // Memory Read Multiple
            MRM_CODE :
                     begin
                        cmd2str = "Memory Read Multiple"; 
                     end
            // Dual Address Cycle
            DUAL_CODE :
                     begin
                        cmd2str = "Dual Address Cycle"; 
                     end
            // Memory Read Line
            MRL_CODE :
                     begin
                        cmd2str = "Memory Read Line"; 
                     end
            // Memory Write and Invalidate
            MWI_CODE :
                     begin
                        cmd2str = "Memory Write & Invalidate"; 
                     end
            default :
                     begin
                        cmd2str = "Bad command code"; 
                     end
         endcase 
      end
   endfunction

   initial
   begin
      tp1_failed <= 1'b0;
      tp2_failed <= 1'b0;
      tp5_failed <= 1'b0;
      tp6_failed <= 1'b0;
      tp7_failed <= 1'b0;
      tp8_failed <= 1'b0;
      tp9_failed <= 1'b0;
      tp10_failed <= 1'b0;
      tp11_failed <= 1'b0;
      tp12_failed <= 1'b0;
      tp17_failed <= 1'b0;
      tp19_failed <= 1'b0;
      tp20_failed <= 1'b0;
      tp22_failed <= 1'b0;
      tp23_failed <= 1'b0;
      tp24_failed <= 1'b0;
      tp25_failed <= 1'b0;
      tp26_failed <= 1'b0;
      tp28_failed <= 1'b0;
      tp29_failed <= 1'b0;
      tp30_failed <= 1'b0;
      tp31_failed <= 1'b0;
      tp32_failed <= 1'b0;
      tp34_failed <= 1'b0;
      buslogfile = $fopen("bus_monitor.log");
   end

   //--------------------------------------------------------------------------
   //  main code
   //--------------------------------------------------------------------------
   // iff regs
   always @(clk or rstn)
   begin : piffregs
      if (rstn == 1'b0)
      begin
         framen_r <= 1'b1 ; 
         irdyn_r <= 1'b1 ; 
         devseln_r <= 1'b1 ; 
         trdyn_r <= 1'b1 ; 
         stopn_r <= 1'b1 ; 
         par_r <= 1'b1 ; 
         perrn_r <= 1'b1 ; 
         serrn_r <= 1'b1 ; 
         ad_r <= {64{1'b0}} ; 
         cbe_r <= {8{1'b0}} ; 
      end
      else if (clk == 1'b1)
      begin
         framen_r <= framen ; 
         irdyn_r <= irdyn ; 
         devseln_r <= devseln ; 
         trdyn_r <= trdyn ; 
         stopn_r <= stopn ; 
         par_r <= par ; 
         perrn_r <= perrn ; 
         serrn_r <= serrn ; 
         ad_r <= adio ; 
         cbe_r <= cbe ; 
      end 
   end 

   // cmd_r Register
   always @(clk or rstn)
   begin : pCmdReg
      if (rstn == 1'b0)
      begin
         cmd_r <= RES4_CODE ; 
      end
      else if (clk == 1'b1)
      begin
         if (framen == 1'b0 & framen_r != 1'b0)
         begin
            cmd_r <= cbe[3:0] ; 
         end
         else if (cmd_r == DUAL_CODE)
         begin
            cmd_r <= cbe[3:0] ; 
         end 
      end 
   end 

   // addr_reg Counter
   always @(clk or rstn)
   begin : pAddressReg
      if (rstn == 1'b0)
      begin
         addr_reg <= {64{1'b0}} ; 
      end
      else if (clk == 1'b1)
      begin
         case (bus_state)
            BUS_IDLE :
                     begin
                        if (framen == 1'b0 & framen_r != 1'b0)
                        begin
                           addr_reg[31:0] <= adio[31:0] ; 
                           addr_reg[63:32] <= {32{1'b0}} ; 
                        end 
                     end
            BUS_CMD :
                     begin
                        if (cmd_r == DUAL_CODE)
                        begin
                           addr_reg[63:32] <= adio[31:0] ; 
                        end 
                     end
            BUS_DATA :
                     begin
                        if ((irdyn == 1'b0) & (trdyn == 1'b0))
                        begin
                           addr_reg <= addr_reg + 4 ; 
                        end 
                     end
            BUS_TURNAR :
                     begin
                        addr_reg <= {64{1'b0}} ; 
                     end
         endcase 
      end 
   end 

   //  Target State Machine 
   always @(clk or rstn)
   begin : FSM
      reg[1:(8)*4] adrstr;
      reg[1:(16)*4] datastr;
      reg retry; 
      reg retry_wait; 
      integer retry_cnt; 
      reg[63:0] retry_addr; 
      if (rstn == 1'b0)
      begin
         bus_state <= BUS_IDLE ; 
         retry = 1'b1; 
         retry_wait = 1'b0; 
      end
      else if (clk == 1'b1)
      begin
         if (retry_wait)
         begin
            retry_cnt = retry_cnt + 1; 
         end
         else
         begin
            retry_cnt = 0; 
         end 
         case (bus_state)
            BUS_IDLE :
                     begin
                        if (framen == 1'b0 & framen_r != 1'b0)
                        begin
                           bus_state <= BUS_CMD ; 
                           adrstr = (adio[31:0]); 
                           $fdisplay(buslogfile, "_______________________________________________________________________"); 
                           $fdisplay(buslogfile, $stime, " ns : %hh", adrstr, " - PCI transaction start - %s", cmd2str(cbe[3:0])); 
                           retry = 1'b1; 
                        end 
                     end
            BUS_CMD :
                     begin
                        bus_state <= BUS_DATA ; 
                     end
            BUS_DATA :
                     begin
                        adrstr = (addr_reg[31:0]); 
                        datastr = adio; 
                        if (irdyn == 1'b0 & trdyn == 1'b0)
                        begin
                           $fdisplay(buslogfile, $stime, " ns : %hh : %hh - successfull data transfer", adrstr, datastr);
                           retry = 1'b0; 
                           if (retry_addr == addr_reg)
                           begin
                              retry_wait = 1'b0; 
                              retry_cnt = 0; 
                           end 
                        end 
                        if (framen != 1'b0 & irdyn == 1'b0 & (trdyn == 1'b0 | stopn == 1'b0))
                        begin
                           bus_state <= BUS_TURNAR ; 
                           if (devseln != 1'b0)
                           begin
                              // target abort
                              $fdisplay(buslogfile, $stime, " ns - PCI transaction end - Target Abort termination"); 
                           end
                           else if (stopn == 1'b0)
                           begin
                              if (trdyn == 1'b0)
                              begin
                                 // disconnect with data
                                 $fdisplay(buslogfile, $stime, " ns - PCI transaction end - Target Disconnect with Data termination"); 
                              end
                              else if (retry)
                              begin
                                 // retry
                                 $fdisplay(buslogfile, $stime, " ns - PCI transaction end - Target Retry termination"); 
                                 if (retry_wait)
                                 begin
                                    if (retry_cnt > RETRY_CLK_LIMIT & retry_addr == addr_reg)
                                    begin
                                       $fdisplay(buslogfile, $stime, " ns", TP34_ERR_MSG); 
                                       tp34_failed <= 1'b1 ; 
                                    end 
                                 end
                                 else
                                 begin
                                    retry_wait = 1'b1; 
                                    retry_addr = addr_reg; 
                                 end 
                              end
                              else
                              begin
                                 // disconnect without data
                                 $fdisplay(buslogfile, $stime, " ns - PCI transaction end - Target Disconnect without Data termination"); 
                              end 
                           end
                           else
                           begin
                              // last data transfer
                              $fdisplay(buslogfile, $stime, " ns - PCI transaction end - last data transfer successed"); 
                           end 
                        end
                        else if (framen != 1'b0 & irdyn != 1'b0)
                        begin
                           bus_state <= BUS_TURNAR ; 
                           $fdisplay(buslogfile, $stime, " ns - PCI transaction end - Master Abort Termination"); 
                        end 
                     end
            BUS_TURNAR :
                     begin
                        bus_state <= BUS_IDLE ; 
                     end
         endcase 
      end 
   end 

   // *************************************************************************
   // *                         Protocol Checker                              *
   // *************************************************************************  
   // General protocol checklist for Target
   //--------------------------------------------------------------------------   
   // TP1: All Sustained Tri-State signals are driven high for one clock before being Tri-Stated.
   // 
   always @(clk or rstn)
   begin : pTP1
      reg passed; 
      reg[1:(10)*8] signal_str; 
      if (rstn == 1'b0)
      begin
         tp1_failed <= 1'b0 ; 
      end
      else if (clk == 1'b1)
      begin
         passed = 1'b1; 
         // check rule TP1 
         TP1_Eval(framen, framen_r, "FRAME#", buslogfile, passed); 
         TP1_Eval(irdyn, irdyn_r, "IRDY#", buslogfile, passed); 
         TP1_Eval(devseln, devseln_r, "DEVSEL#", buslogfile, passed); 
         TP1_Eval(trdyn, trdyn_r, "TRDY#", buslogfile, passed); 
         TP1_Eval(stopn, stopn_r, "STOP#", buslogfile, passed); 
         TP1_Eval(perrn, perrn_r, "PERR#", buslogfile, passed); 
         if (~passed)
         begin
            tp1_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP2: IUT never reports PERR# until it has claimed the cycle and completed a data phase
   // 
   always @(clk or rstn)
   begin : pDSENT
      if (rstn == 1'b0)
      begin
         data_phase_completed <= 1'b0 ; 
      end
      else if (clk == 1'b1)
      begin
         if (bus_state == BUS_IDLE)
         begin
            data_phase_completed <= 1'b0 ; 
         end
         else if (irdyn == 1'b0 & trdyn == 1'b0 & devseln == 1'b0)
         begin
            data_phase_completed <= 1'b1 ; 
         end 
      end 
   end 

   always @(clk)
   begin : pTP2
      if (clk == 1'b1)
      begin
         if (perrn == 1'b0 & ~data_phase_completed)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP2_ERR_MSG); 
            tp2_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP3: IUT never aliases reserved commands with other commands.
   //      N/A - this test is covered by target test scenario 2.5
   //
   //--------------------------------------------------------------------------   
   // TP4: 32-bit addressable IUT treats DUAL command as reserved.
   //      N/A - this test is covered by target test scenario 2.5 
   //    
   //--------------------------------------------------------------------------   
   // TP5: Once IUT has asserted TRDY# it never changes TRDY# until the data phase completes
   //      
   //    
   always @(clk or rstn)
   begin : pTP5
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if (trdyn != 1'b0 & trdyn_r == 1'b0 & irdyn_r != 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP5_ERR_MSG); 
            tp5_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP6: Once IUT has asserted TRDY# it never changes DEVSEL# until the data phase completes
   //      
   //    
   always @(clk or rstn)
   begin : pTP6
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if (devseln != 1'b0 & devseln_r == 1'b0 & trdyn_r == 1'b0 & irdyn_r != 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP6_ERR_MSG); 
            tp6_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP7: Once IUT has asserted TRDY# it never changes STOP# until the data phase completes
   //      
   //    
   always @(clk or rstn)
   begin : pTP7
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((stopn != stopn_r) & (trdyn_r == 1'b0) & (irdyn_r != 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP7_ERR_MSG); 
            tp7_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP8: Once IUT has asserted STOP# it never changes STOP# until the data phase completes
   //      
   //    
   always @(clk or rstn)
   begin : pTP8
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((stopn != 1'b0) & (stopn_r == 1'b0) & irdyn_r != 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP8_ERR_MSG); 
            tp8_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP9: Once IUT has asserted STOP# it never changes TRDY# until the data phase completes. 
   //      
   //    
   always @(clk or rstn)
   begin : pTP9
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((trdyn != trdyn_r) & (stopn_r == 1'b0) & (irdyn_r != 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP9_ERR_MSG); 
            tp9_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP10: Once IUT has asserted STOP# it never changes DEVSEL# until the data phase completes
   //      
   //    
   always @(clk or rstn)
   begin : pTP10
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((devseln != devseln_r) & (stopn_r == 1'b0) & (irdyn_r != 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP10_ERR_MSG); 
            tp10_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP11: IUT only transfers data when both IRDY# and TRDY# are asserted on the same rising clock edge. 
   //      
   //    
   always @(clk or rstn)
   begin : pTP11
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((adio != ad_r) & (devseln == 1'b0) & ((cmd_r[0]) == 1'b0 & irdyn_r != 1'b0 & trdyn_r == 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP11_ERR_MSG); 
            tp11_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP12: IUT always asserts TRDY# when data is valid on a read cycle
   //      
   //
   always @(clk or rstn)
   begin : pTP12
      reg datavalid; 
      if (clk == 1'b1)
      begin
         datavalid = 1'b1; 
         begin : xhdl_34
            integer i;
            for(i = 0; i <= 31; i = i + 1)
            begin
               if ((adio[i]) != 1'b1 & (adio[i]) != 1'b0)
               begin
                  datavalid = 1'b0; 
               end 
            end
         end 
         if ((~datavalid) & (devseln == 1'b0) & ((cmd_r[0]) == 1'b0) & (trdyn == 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP12_ERR_MSG); 
            tp12_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP13: IUT always signals target-abort when unable to complete 
   //       the entire IO access as defined by the byte enables. 
   //   
   // Verified by test scenario 2.4
   //
   //--------------------------------------------------------------------------   
   // TP14: IUT never responds to reserved encodings.
   //      
   // Verified by test scenario 2.5
   //    
   //--------------------------------------------------------------------------   
   // TP15: IUT always ignores configuration command unless IDSEL 
   //       is asserted and AD[1::0] are \"00\". 
   //      
   // Verified by test scenario 2.6
   //    
   //--------------------------------------------------------------------------   
   // TP16: IUT always disconnects after the first data phase 
   //       when reserved burst mode is detected
   //      
   // Verified by test scenario 2.9
   //    
   //--------------------------------------------------------------------------   
   // TP17: The IUT\'s  AD lines are driven to stable values during every 
   //       address and data phase. 
   //      
   always @(clk or rstn)
   begin : pTP17
      reg datavalid; 
      if (clk == 1'b1)
      begin
         datavalid = 1'b1; 
         begin : xhdl_37
            integer i;
            for(i = 0; i <= 31; i = i + 1)
            begin
               if ((adio[i]) != 1'b1 & (adio[i]) != 1'b0)
               begin
                  datavalid = 1'b0; 
               end 
            end
         end 
         if ((~datavalid) & framen == 1'b0 & framen_r != 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP17A_ERR_MSG); 
            tp17_failed <= 1'b1 ; 
         end 
         if ((~datavalid) & (((devseln == 1'b0) & ((cmd_r[0]) == 1'b0) & (trdyn == 1'b0)) | (((cmd_r[0]) == 1'b1) & (irdyn == 1'b0))))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP17D_ERR_MSG); 
            tp17_failed <= 1'b1 ; 
         end 
      end 
   end 

   //    
   //--------------------------------------------------------------------------   
   // TP18: removed from checklist
   //      
   //    
   //--------------------------------------------------------------------------   
   // TP19: IUT never asserts TRDY# during turnaround cycle on a read. 
   //      
   // 
   always @(clk or rstn)
   begin : pTP19_ACC_START
      if (rstn == 1'b0)
      begin
         cmd_phase <= 1'b1 ; 
      end
      else if (clk == 1'b1)
      begin
         if (framen == 1'b0 & framen_r != 1'b0)
         begin
            cmd_phase <= 1'b1 ; 
         end
         else
         begin
            cmd_phase <= 1'b0 ; 
         end 
      end 
   end 

   always @(clk or rstn)
   begin : pTP19
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if (cmd_phase == 1'b1 & (cbe_r[0]) == 1'b0 & trdyn == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP19_ERR_MSG); 
            tp19_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP20: IUT always deasserts TRDY#,STOP#, and DEVSEL# the clock following 
   //       the completion of the last data phase
   //      
   always @(clk or rstn)
   begin : pTP20
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if (framen_r != 1'b0 & irdyn_r == 1'b0 & (trdyn_r == 1'b0 | stopn_r == 1'b0))
         begin
            if (devseln == 1'b0)
            begin
               $fdisplay(buslogfile, $stime, " ns", TP20_ERR_MSG1, "DEVSEL# ", TP20_ERR_MSG2); 
               tp20_failed <= 1'b1 ; 
            end 
            if (trdyn == 1'b0)
            begin
               $fdisplay(buslogfile, $stime, " ns", TP20_ERR_MSG1, "TRDY# ", TP20_ERR_MSG2); 
               tp20_failed <= 1'b1 ; 
            end 
            if (stopn == 1'b0)
            begin
               $fdisplay(buslogfile, $stime, " ns", TP20_ERR_MSG1, "STOP# ", TP20_ERR_MSG2); 
               tp20_failed <= 1'b1 ; 
            end 
         end 
      end 
   end 

   //    
   //--------------------------------------------------------------------------   
   // TP21: IUT always signals disconnect when burst crosses resource boundary. 
   //      
   // Verified by test scenario 2.9
   //    
   //--------------------------------------------------------------------------   
   // TP22: IUT always deasserts STOP# the cycle immediately following FRAME# 
   //       being dessaerted
   //      
   always @(clk or rstn)
   begin : pTP22
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if (stopn == 1'b0 & framen_r == 1'b1 & irdyn_r == 1'b0 & stopn_r == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP22_ERR_MSG); 
            tp22_failed <= 1'b1 ; 
         end 
      end 
   end 

   //    
   //--------------------------------------------------------------------------   
   // TP23: Once the IUT has asserted STOP# it never deasserts STOP# until FRAME# is negated. 
   //      
   always @(clk)
   begin : pTP23
      if (clk == 1'b1)
      begin
         if (stopn != 1'b0 & stopn_r == 1'b0 & framen_r == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP23_ERR_MSG); 
            tp23_failed <= 1'b1 ; 
         end 
      end 
   end 

   //    
   //--------------------------------------------------------------------------   
   // TP24: IUT always deasserts TRDY# before signaling target-abort. 
   //      
   // 
   always @(clk)
   begin : pTP24
      if (clk == 1'b1)
      begin
         if (stopn == 1'b0 & devseln != 1'b0 & trdyn == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP24_ERR_MSG); 
            tp24_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP25: IUT never deasserts STOP# and continues the transaction. 
   //      
   //    
   always @(clk)
   begin : pTP25
      if (clk == 1'b1)
      begin
         if (stopn != 1'b0 & stopn_r == 1'b0 & devseln == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP25_ERR_MSG); 
            tp25_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP26: IUT always completes initial data phase within 16 clocks if system 
   //       is operating in run-time
   //      
   //    
   always @(posedge clk)
   begin : pTP26
      integer data_latency_reg; 
      reg initial_xhdl53; 
      if (bus_state == BUS_IDLE | trdyn == 1'b0)
      begin
         data_latency_reg = 0; 
      end
      else
      begin
         data_latency_reg = data_latency_reg + 1; 
      end 
      if (bus_state == BUS_IDLE)
      begin
         initial_xhdl53 = 1'b1; 
      end
      else if (trdyn == 1'b0)
      begin
         initial_xhdl53 = 1'b0; 
      end 
      if (data_latency_reg == 16 & initial_xhdl53)
      begin
         $fdisplay(buslogfile, $stime, " ns", TP26_ERR_MSG); 
         tp26_failed <= 1'b1 ; 
      end  
   end 

   //--------------------------------------------------------------------------   
   // TP27: 
   //      
   // Not defined   
   //--------------------------------------------------------------------------   
   // TP28: IUT always issues DEVSEL# before any other response
   //      
   // 
   always @(clk or rstn)
   begin : pTP28
      reg devassert; 
      if (rstn == 1'b0)
      begin
         devassert = 1'b0; 
      end
      else if (clk == 1'b1)
      begin
         if (devseln == 1'b0)
         begin
            devassert = 1'b1; 
         end
         else if (framen != 1'b0 & irdyn != 1'b0)
         begin
            devassert = 1'b0; 
         end 
         if ((~devassert) & (trdyn == 1'b0 | stopn == 1'b0))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP28_ERR_MSG); 
            tp28_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP29: Once IUT has asserted DEVSEL# it never deasserts DEVSEL# until 
   //       the last data phase has competed except to signal target-abort
   //      
   //    
   always @(clk)
   begin : pTP29
      if (clk == 1'b1)
      begin
         if (devseln != 1'b0 & devseln_r == 1'b0 & ~(stopn == 1'b0 | (irdyn_r == 1'b0 & framen_r != 1'b0 & (trdyn_r == 1'b0 | stopn_r == 1'b0))))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP29_ERR_MSG); 
            tp29_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP30: IUT never responds to special cycles 
   //      
   //
   always @(clk)
   begin : pTP30
      if (clk == 1'b1)
      begin
         if (cmd_r == SCYC_CODE & (framen == 1'b0 | irdyn == 1'b0) & devseln == 1'b0)
         begin
            $fdisplay(buslogfile, $stime, " ns", TP30_ERR_MSG); 
            tp30_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP31: IUT always drives PAR within one clock of AD being driven
   //      
   // 
   always @(clk or rstn)
   begin : pTP31
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         if ((devseln_r == 1'b0) & ((cmd_r[0]) == 1'b0) & (trdyn_r == 1'b0) & (par != 1'b0) & (par != 1'b1))
         begin
            $fdisplay(buslogfile, $stime, " ns", TP31_ERR_MSG); 
            tp31_failed <= 1'b1 ; 
         end 
      end 
   end 

   //--------------------------------------------------------------------------   
   // TP32: IUT always drives PAR such that the number of \"1\"s 
   //       on AD[31::0],C/BE[3:0], and PAR equals an even number. 
   //      
   always @(clk or rstn)
   begin : pTP32
      reg cpar; 
      reg cpar64; 
      if (rstn == 1'b0)
      begin
      end
      else if (clk == 1'b1)
      begin
         gen_pci_parity(ad_r[31:0], cbe_r[3:0], cpar); 
         gen_pci_parity(ad_r[63:32], cbe_r[7:4], cpar64); 
         if ((devseln_r == 1'b0) & ((cmd_r[0]) == 1'b0) & (trdyn_r == 1'b0))
         begin
            if (par != cpar)
            begin
               $fdisplay(buslogfile, $stime, " ns", TP32_ERR_MSG); 
               tp32_failed <= 1'b1 ; 
            end 
            if (ack64n == 1'b0 & par64 != cpar64)
            begin
               $fdisplay(buslogfile, $stime, " ns", TP32_ERR_MSG, " 64-bit"); 
               tp32_failed <= 1'b1 ; 
            end 
         end 
      end 
   end 

   //    
   //--------------------------------------------------------------------------   
   // TP33:If IUT is accessed during initialization-time (time from RST# is deasserted 
   //      and 2**25 clocks later), IUT responds to the access by:  (3.5.1.1)
   //      (1)Completing the initial data phase within 16 clocks:
   //      (2)Ignoring the access
   //      (3)Claim the access and hold in wait states (completing within 2**25 clocks)
   //      (4)Claim the access and terminate with Retry
   //      
   //    
   //--------------------------------------------------------------------------   
   // TP34: After terminating a memory write transaction with Retry, IUT will be ready 
   //      to complete  at least one data phase of a memory write within 334 clocks 
   //      for 33MHz devices and 668 clocks for 66MHz devices.
   //      
   //    
   //--------------------------------------------------------------------------   
   //
   // 8 Clock Rule Checker
   // Initiator must assert irdyn within 8 clock cycles after framen assertion
   //
   always @(posedge clk)
   begin : C8_Rule
      integer count; 
      if (framen == 1'b0 & irdyn != 1'b0)
      begin
         count = count + 1; 
      end
      else
      begin
         count = 0; 
      end 
      //JS if (~(count <= 8))
      //    $display("PCI Bus Monitor: Protocol violation - Initiator 8'clock rule violation %d  %d                  Master must assert IRDY# within 8 clock cycles (ERROR)", CR, LF);  
   end 

   // Logfile header generator
   always 
   begin : xhdl_66
      // open PCI bus monitor report file
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      $fdisplay(buslogfile, "- PCI BUS MONITOR LOGFILE                                                     -"); 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      @(posedge end_sim); 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      $fdisplay(buslogfile, "- ", $stime, " ns  - End of simulation                                          -"); 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      $fdisplay(buslogfile, "--                                                                           --"); 
      $fdisplay(buslogfile, "-- General Components Protocol Checlist                                      --"); 
      $fdisplay(buslogfile, "--                                                                           --"); 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      $fdisplay(buslogfile, " "); 
      if (tp1_failed)
      begin
         $fdisplay(buslogfile, "TP1 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP1 - Passed "); 
      end 
      $fdisplay(buslogfile, " "); 
      if (tp2_failed)
      begin
         $fdisplay(buslogfile, "TP2 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP2 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP3 - tested in test scenario 2.5 "); 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP4 - tested in test scenario 2.5 "); 
      //
      $fdisplay(buslogfile, " "); 
      if (tp5_failed)
      begin
         $fdisplay(buslogfile, "TP5 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP5 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp6_failed)
      begin
         $fdisplay(buslogfile, "TP6 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP6 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp7_failed)
      begin
         $fdisplay(buslogfile, "TP7 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP7 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp8_failed)
      begin
         $fdisplay(buslogfile, "TP8 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP8 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp9_failed)
      begin
         $fdisplay(buslogfile, "TP9 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP9 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp10_failed)
      begin
         $fdisplay(buslogfile, "TP10 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP10 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp11_failed)
      begin
         $fdisplay(buslogfile, "TP11 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP11 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp12_failed)
      begin
         $fdisplay(buslogfile, "TP12 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP12 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP13 - tested in PCISIG test scenario 2.4 "); 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP14 - tested in PCISIG test scenario 2.5 "); 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP15 - tested in PCISIG test scenario 2.6 "); 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP16 - tested in PCISIG test scenario 2.9 "); 
      //
      $fdisplay(buslogfile, " "); 
      if (tp17_failed)
      begin
         $fdisplay(buslogfile, "TP17 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP17 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP18 - removed from checklist "); 
      //
      $fdisplay(buslogfile, " "); 
      if (tp19_failed)
      begin
         $fdisplay(buslogfile, "TP19 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP19 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp20_failed)
      begin
         $fdisplay(buslogfile, "TP20 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP20 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP21 - tested in PCISIG test scenario 2.9 "); 
      //
      $fdisplay(buslogfile, " "); 
      if (tp22_failed)
      begin
         $fdisplay(buslogfile, "TP22 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP22 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp23_failed)
      begin
         $fdisplay(buslogfile, "TP23 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP23 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp24_failed)
      begin
         $fdisplay(buslogfile, "TP24 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP24 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp25_failed)
      begin
         $fdisplay(buslogfile, "TP25 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP25 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp26_failed)
      begin
         $fdisplay(buslogfile, "TP26 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP26 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      $fdisplay(buslogfile, "TP27 - rule not defined"); 
      //
      $fdisplay(buslogfile, " "); 
      if (tp28_failed)
      begin
         $fdisplay(buslogfile, "TP28 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP28 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp29_failed)
      begin
         $fdisplay(buslogfile, "TP29 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP29 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp30_failed)
      begin
         $fdisplay(buslogfile, "TP30 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP30 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp31_failed)
      begin
         $fdisplay(buslogfile, "TP31 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP31 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp32_failed)
      begin
         $fdisplay(buslogfile, "TP32 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP32 - Passed "); 
      end 
      //
      $fdisplay(buslogfile, " "); 
      if (tp34_failed)
      begin
         $fdisplay(buslogfile, "TP34 - Failed "); 
      end
      else
      begin
         $fdisplay(buslogfile, "TP34 - Passed "); 
      end 
      $fdisplay(buslogfile, "-------------------------------------------------------------------------------"); 
      //
      $fclose(buslogfile); // close PCI Bus monitor report file
      forever #100000; 
   end 
endmodule
