//----------------------------------------------------------------------
//
// Copyright (c) 2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI-M64AHB
//
//  File          : pcim64ahbw_tb.v
//
//  Dependencies  : 
//
//  Model Type:   : Simulation Model
//
//  Description   : Testbench for 64-bit/66MHz PCI Master/Target - AMBA AHB interface
//                   
//
//  Designer      : AS
//
//  QA Engineer   :   
//
//  Creation Date : 1-October-2003
//
//  Last Update   : 23-July-2004
//
//  Version       : 1.0.2V
//----------------------------------------------------------------------
`timescale 1 ns / 1 ps
module pcim64ahbw_tb ();
   parameter TBDEBUG = 1'b1; // Testbench debug mode 
   `include "pci64_params.v"
   `include "ahb_params.v"
   // AHB Bus space allocation
   parameter SLAVE0_PRESENT = 1'b1;
   parameter SLAVE0_BASE    = 32'h00000000;
   parameter SLAVE0_SIZE    = 32'h10000000; // 256MB
   parameter SLAVE1_PRESENT = 1'b1;
   parameter SLAVE1_BASE    = 32'h20000000;
   parameter SLAVE1_SIZE    = 32'h10000000; // 256MB
   parameter SLAVE2_PRESENT = 1'b0;
   parameter SLAVE2_BASE    = 32'h40000000;
   parameter SLAVE2_SIZE    = 32'h10000000; // 256MB
   parameter SLAVE3_PRESENT = 1'b0;
   parameter SLAVE3_BASE    = 32'h60000000;
   parameter SLAVE3_SIZE    = 32'h10000000; // 256MB
   // Control register offsets
   // PCI->AHB control
   parameter PCIAHBOFFSET_ADDR = 32'h00000000;
   parameter PCIAHBERROR_ADDR  = 32'h00000008;
   parameter PCIAHBDISC_ADDR   = 32'h00000010;
   // DMA control
   parameter DMAPCIADDR_ADDR   = 32'h00000080;
   parameter DMAAHBADDR_ADDR   = 32'h00000088;
   parameter DMATXSIZE_ADDR    = 32'h00000090;
   parameter DMACTRL_ADDR      = 32'h00000098;
   parameter DMASTATUS_ADDR    = 32'h000000A0;
   // Interrupt control
   parameter INTSTATUS_ADDR    = 32'h00000100;
   parameter PCIINTMASK_ADDR   = 32'h00000108;
   parameter AHBINTMASK_ADDR   = 32'h00000110;
   // Mailboxes
   parameter PCIMBOX0_ADDR     = 32'h00000180;
   parameter PCIMBOX1_ADDR     = 32'h00000188;
   parameter PCIMBOX2_ADDR     = 32'h00000190;
   parameter PCIMBOX3_ADDR     = 32'h00000198;
   parameter AHBMBOX0_ADDR     = 32'h000001A0;
   parameter AHBMBOX1_ADDR     = 32'h000001A8;
   parameter AHBMBOX2_ADDR     = 32'h000001B0;
   parameter AHBMBOX3_ADDR     = 32'h000001B8;
   
   //------------------------------------------------------------------
   // local signals
   //------------------------------------------------------------------
   reg clk_p; 
   reg rstn_p; 
   reg [63:0] ad_p; 
   reg [7:0] cbe_p; 
   reg par_p; 
   reg par64_p; 
   reg framen_p; 
   reg irdyn_p; 
   reg trdyn_p; 
   reg devseln_p; 
   reg stopn_p; 
   reg idsel_p; 
   reg req64n_p; 
   reg ack64n_p; 
   reg perrn_p; 
   reg serrn_p; 
   reg intan_p; 
   //
   reg[1:0] reqn_p; 
   wire[1:0] gntn_p; 
   wire[1:0] idsel; 
   //
   integer testphase; 
   reg parkmaster; 
   //Signal used to stop clock signal generators
   reg end_sim; 
   // Target parameters
   reg targetparams; 

   reg[3:0] master_params_Command;
   reg[ADDR_WIDTH - 1:0] master_params_Address;
   reg[CBE_WIDTH - 1:0] master_params_BEn;
   integer master_params_BurstLength;
   reg master_params_Transfer_64;
   reg[DATA_WIDTH - 1:0] master_params_Data;
   integer master_params_IrdyWait;
   reg[1:(15)*8] master_params_DataFileName;
   integer master_params_RetryLimit;
   integer master_params_RetryDelay;
   reg master_params_GenFastBack;
   reg master_params_GenPerr;
   reg master_params_GenPerr64;
   reg master_params_GenSerr;
   reg master_params_CheckResult;
   reg master_params_ResultOK;
   reg[2:0] master_params_TermType;
   wire master_result_ResultOK;
   wire[2:0] master_result_TermType;
   wire[DATA_WIDTH - 1:0] master_result_Data;
   wire (strong1, pull0) [63:0] ad_p_net = ad_p; 
   wire (strong1, pull0) par_p_net = par_p; 
   wire (strong1, pull0) par64_p_net = par64_p; 
   wire (pull1, strong0) irdyn_p_net = irdyn_p; 
   wire (pull1, strong0) trdyn_p_net = trdyn_p; 
   wire (pull1, strong0) devseln_p_net = devseln_p; 
   wire (pull1, strong0) stopn_p_net = stopn_p; 
   wire (pull1, strong0) req64n_p_net = req64n_p; 
   wire (pull1, strong0) ack64n_p_net = ack64n_p; 
   wire (pull1, strong0) perrn_p_net = perrn_p; 
   wire (pull1, strong0) serrn_p_net = serrn_p; 
   wire (pull1, strong0) intan_p_net = intan_p; 
   wire (pull1, strong0) framen_p_net = framen_p; 
   wire (pull1, strong0) [7:0] cbe_p_net = cbe_p; 
   wire (pull1, strong0) [1:0] reqn_p_net = reqn_p; 

   wire serr_sig;
   wire perr_sig;
   wire done;
   reg exec;
   wire exec_net;
   wire[10:0] master_params_BurstLength_net;
   wire[10:0] master_params_IrdyWait_net;
   wire[10:0] master_params_RetryLimit_net;
   wire[10:0] master_params_RetryDelay_net;
   
   integer logfile;

   //------------------------------------------------------------------------------
   // AHB Bus 
   reg hclk;
   reg hresetn;
   reg hwrite;
   reg[1:0] htrans;
   reg[2:0] hsize;
   reg[3:0] hprot;
   reg[2:0] hburst;
   reg[31:0] haddr;
   reg[31:0] hwdata;
   reg[31:0] hrdata;
   reg[3:0] hmaster;
   reg hready;
   reg[1:0] hresp; 
   //
   reg[31:0] haddr_r;

   //
   // AHB Master outputs (up to 16 masters at AHB)
   reg [31:0]mhaddr [15:0];
   reg mhbusreq [15:0];
   reg mhgrant [15:0];
   reg mhlock [15:0];
   reg mhwrite [15:0];
   reg[1:0] mhtrans [15:0];
   reg[2:0] mhsize [15:0];
   reg[3:0] mhprot [15:0];
   reg[2:0] mhburst [15:0];
   reg[31:0] mhwdata [15:0];
   //
   // Slave selects (up to 16 slaves at AHB)
   reg hsel [15:0];
   //
   // Slave Outputs 
   wire shready_0; 
   wire shready_1; 
   wire shready_2; 
   wire shready_3; 
   wire[1:0] shresp_0; 
   wire[1:0] shresp_1; 
   wire[1:0] shresp_2; 
   wire[1:0] shresp_3; 
   wire[31:0] shrdata_0; 
   wire[31:0] shrdata_1; 
   wire[31:0] shrdata_2; 
   wire[31:0] shrdata_3; 
   //
   reg[31:0] ahbaddr; 
   reg[31:0] ahbdata; 
   reg[2:0] ahbhsize;
   reg[1:0] ahbresp; 
   integer retry_delay;
   reg retry_disable; 
   //   
   wire [31:0]mhaddr_uut;
   wire mhbusreq_uut;
//   wire mhgrant_uut;
   wire mhlock_uut;
   wire mhwrite_uut;
   wire[1:0] mhtrans_uut;
   wire[2:0] mhsize_uut;
   wire[3:0] mhprot_uut;
   wire[2:0] mhburst_uut;
   wire[31:0] mhwdata_uut;
   always@(mhaddr_uut)
   begin
      mhaddr[0] <= mhaddr_uut;
   end
   //------------------------------------------------------------------------------
   task ahb_master_single_write;
   //------------------------------------------------------------------------------
      input integer master;
      input[31:0] addr; 
      input[31:0] data; 
      input[2:0] transfersize; 
      input integer retry_delay;
      input retry_disable;
      input integer ahblogfile;
      output[1:0] response; 
      begin : RL
         while (1'b1)
         begin 
            @(posedge hclk); 
            $fdisplay(ahblogfile,$stime, " ns : AHB Master: Single Write Requested");
            $display($stime, " ns : AHB Master: Single Write Requested");
            mhbusreq[master] <= 1'b1 ; 
            // Wait until bys granted
            while (!((hready) & (mhgrant[master])))
            begin : WFI2
               @(posedge hclk); 
            end 
            $fdisplay(ahblogfile,$stime, " ns : AHB Master: AHB bus granted");
            $display($stime, " ns : AHB Master: AHB bus granted");
            mhaddr[master] <= addr ; 
            mhwrite[master] <= 1'b1 ; 
            mhtrans[master] <= HTRANS_NONSEQ ; // NONSEQ
            mhburst[master] <= HBURST_SINGLE ; // SINGLE
            mhsize[master]  <= transfersize ; 
            mhbusreq[master] <= 1'b0 ; 
            // Data phase
            @(posedge hclk); 
            mhaddr[master] <= {32{1'bx}} ; 
            mhwdata[master] <= data ; 
            mhtrans[master] <= HTRANS_IDLE ; // IDLE   
            mhwrite[master] <= 1'b0 ; 
            @(posedge hclk);
            // Wait until slave ready
            while (!hready)
               @(posedge hclk);
            response = hresp;
            case (hresp)
               HRESP_OKAY :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model Write - %hh :", addr, " %hh", data); 
                           $display($stime, " ns : AHB Master Model Write - %hh :", ahbaddr, " %hh", data); 
                           disable RL; 
                        end
               HRESP_ERROR :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model - Write at address %hh", addr, " terminated with ERROR "); 
                           $display($stime, " ns : AHB Master Model - Write at address %hh", addr, " terminated with ERROR "); 
                           disable RL; 
                        end
               HRESP_RETRY :
                        begin
                           $fdisplay(ahblogfile,$stime, " ns : AHB Master Model - Write at address %hh", addr, " terminated with RETRY "); 
                           #retry_delay; 
                           if (retry_disable)
                           begin
                              disable RL; 
                           end 
                        end
               HRESP_SPLIT :
                        begin
                           $fdisplay(ahblogfile,$stime, " ns : AHB Master Model - Write at address %hh", addr, " terminated with SPLIT "); 
                           #retry_delay; 
                           if (retry_disable)
                           begin
                              disable RL; 
                           end 
                        end
               default :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model - Invalid Slave response on HRESP signal"); 
                           $display($stime, " ns : AHB Master Model - Invalid Slave response on HRESP signal (ERROR)"); 
                           disable RL; 
                        end
            endcase 
         end
      end
   endtask 
//------------------------------------------------------------------------------
   task ahb_master_single_read;
//------------------------------------------------------------------------------
      input integer master;
      input[31:0] addr; 
      input[2:0] transfersize; 
      input integer retry_delay;
      input retry_disable;
      input integer ahblogfile; 
      output[31:0] data; 
      output[1:0] response;
      begin : RLSR
         while (1'b1)
         begin 
            @(posedge hclk); 
            $fdisplay(ahblogfile,$stime, " ns : AHB Master - Single Read Requested");
            $display($stime, " ns :  AHB Master - Single Read Requested");
            mhbusreq[master] <= 1'b1 ; 
            // Wait until bys granted
            while (!((hready) & (mhgrant[master])))
            begin : WFI2
               @(posedge hclk); 
            end 
            $fdisplay(ahblogfile,$stime, " ns : AHB Master : AHB bus granted");
            $display($stime, " ns : AHB Master : AHB bus granted");
            mhaddr[master]  <= addr ; 
            mhwrite[master] <= 1'b0 ; 
            mhtrans[master] <= HTRANS_NONSEQ ; // NONSEQ
            mhburst[master] <= HBURST_SINGLE ; // SINGLE
            mhsize[master]  <= transfersize ; 
            mhbusreq[master] <= 1'b0 ; 
            // Data phase
            @(posedge hclk); 
            mhaddr[master] <= {32{1'bx}} ; 
            mhtrans[master] <= HTRANS_IDLE ; // IDLE   
            mhwrite[master] <= 1'b0 ; 
            @(posedge hclk);
            // Wait until slave ready
            while (!hready)
               @(posedge hclk);
            $display($stime, " ns : AHB Master: Single Read finished");
            data = hrdata;
            response = hresp;
            case (hresp)
               HRESP_OKAY :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model Read - %hh :",addr, " %hh", hrdata); 
                           $display($stime, " ns : AHB Master Model Read - %hh :", addr, " %hh", hrdata); 
                           disable RLSR; 
                        end
               HRESP_ERROR :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model - Read at address %hh", addr, " terminated with ERROR "); 
                           $display($stime, " ns : AHB Master Model - Read at address %hh", addr, " terminated with ERROR "); 
                           disable RLSR; 
                        end
               HRESP_RETRY :
                        begin
                           $fdisplay(ahblogfile,$stime, " ns : AHB Master Model - Read at address %hh", addr, " terminated with RETRY "); 
                           #retry_delay; 
                           if (retry_disable)
                           begin
                              disable RLSR; 
                           end 
                        end
               HRESP_SPLIT :
                        begin
                           $fdisplay(ahblogfile,$stime, " ns : AHB Master Model - Read at address %hh", addr, " terminated with SPLIT "); 
                           #retry_delay; 
                           if (retry_disable)
                           begin
                              disable RLSR; 
                           end 
                        end
               default :
                        begin
                           $fdisplay(ahblogfile, $stime, " ns : AHB Master Model - Invalid Slave response on HRESP signal"); 
                           $display($stime, " ns : AHB Master Model - Invalid Slave response on HRESP signal (ERROR)"); 
                           disable RLSR; 
                        end
            endcase 
         end
      end
   endtask 
   wire hint;
   //
   //
   //
   assign exec_net = exec;

   assign master_params_BurstLength_net = master_params_BurstLength;
   assign master_params_IrdyWait_net = master_params_IrdyWait;
   assign master_params_RetryLimit_net = master_params_RetryLimit;
   assign master_params_RetryDelay_net = master_params_RetryDelay;

   //----------------------------------------------------------------
   // Function bar_setup_report
   //----------------------------------------------------------------
   // description:
   //    This procedure reports a setup of address space allocated by BAR
   // parameters:
   //    bar_data  - BAR cfg. space map information
   //               (BARx_MAP constant or value read from BAR)
   // results;
   //    logfile - report is written to the logfile
   //
   task bar_setup_report;
      input[31:0] bar_data; 

      integer space_size; 
      reg[1:0] mem_type; 
      reg[1:8*3] space_unit;

      begin
         space_size = 16;
         $fdisplay(logfile, "BAR parameters summary:"); 
         if ((bar_data[0]) == 1'b0)
         begin
            $fdisplay(logfile, "  - located in Memory space"); 
            mem_type = bar_data[1:0]; 
            case (mem_type)
               2'b00 :
                        begin
                           $fdisplay(logfile, "  - locate anywhere in 32-bit address space"); 
                        end
               2'b10 :
                        begin
                           $fdisplay(logfile, "  - locate anywhere in 64-bit address space"); 
                        end
               default :
                        begin
                           $fdisplay(logfile, "  - reserved combination !!!"); 
                        end
            endcase 
            if ((bar_data[3]) == 1'b1)
            begin
               $fdisplay(logfile, "  - prefetchable "); 
            end
            else
            begin
               $fdisplay(logfile, "  - non prefetchable "); 
            end 
         end
         else
         begin
            $fdisplay(logfile, "  - located in I/O space"); 
         end 
         begin : SU_L
            integer i;
            for(i = 4; i <= 31; i = i + 1)
            begin : SL
               if ((bar_data[i]) == 1'b1)
               begin
                  case (i)
                     4, 5, 6, 7, 8, 9 : space_unit = " B";
                     10, 11, 12, 13, 14, 15, 16, 17, 18, 19 : space_unit = " kB";
                     default : space_unit = " MB";
                  endcase 
                  $fdisplay(logfile, "  - allocated space :  %d", space_size, " %s", space_unit); 
                  disable SU_L;
               end
               else
               begin
                  space_size = space_size + space_size; 
                  if (i == 9)
                  begin
                     space_size = 1; // size in kB
                  end 
                  if (i == 19)
                  begin
                     space_size = 1; // size in MB
                  end 
               end 
            end
         end 
      end
   endtask

   //
   //--------------------------------------------------------------------------
   // function cfg_addr
   //--------------------------------------------------------------------------
   // description:
   //    Configuration space address - adds device number to address bits
   //    to generate DEVSEL signals on AD lines
   //    Function should be used on configuration space read/write transactions
   // parameters:
   //    device   - device number (0 to 7)
   //    address  - transaction address
   // results:
   //    new address with device number added
   //--------------------------------------------------------------------------
   function [31:0] cfg_addr;
      input device; 
      integer device;
      input[31:0] addr; 

      reg[31:0] address; 

      begin
         address = addr; 
         case (device)
            0 :
                     begin
                        address[14:12] = 3'b000; 
                     end
            1 :
                     begin
                        address[14:12] = 3'b001; 
                     end
            2 :
                     begin
                        address[14:12] = 3'b010; 
                     end
            3 :
                     begin
                        address[14:12] = 3'b011; 
                     end
            4 :
                     begin
                        address[14:12] = 3'b100; 
                     end
            5 :
                     begin
                        address[14:12] = 3'b101; 
                     end
            6 :
                     begin
                        address[14:12] = 3'b110; 
                     end
            7 :
                     begin
                        address[14:12] = 3'b111; 
                     end
            default :
                     begin
                        $display("Device number must be in range 0 to 7 --- FAILURE"); 
                     end
         endcase 
         cfg_addr = address; 
      end
   endfunction

   //--------------------------------------------------------------------------
   // procedure cfgrd_single
   //--------------------------------------------------------------------------
   // description:
   //    Configuration space read
   //
   // parameters:
   //    device   - device number (0 to 7)
   //    address  - transaction address
   //    data     - data
   //    ben      - byte enables (active low)
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------

   task cfgrd_single;
      input device; 
      integer device;
      input[31:0] address; 
      input[31:0] data; 
      input[3:0] ben; 

      begin
         master_params_Command = CFGRD_CODE ; 
         master_params_Address = cfg_addr(device, address) ; 
         master_params_BEn[3:0] = ben ; 
         master_params_BEn[7:4] = 4'b1111 ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'bX}}; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done) 
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ; 
         master_params_GenPerr64 = 1'b0 ; 
         master_params_GenSerr = 1'b0 ; 
         #1; 
      end
   endtask

   //-----------------------------------------------------------------------------
   // Wait for falling edge with timeout
   //-----------------------------------------------------------------------------
   task WaitForFallingEdge;
      input[1:8*15] IdentStr; 
      input ClkLimit; 
      integer ClkLimit;

      integer ClkCount; 
      reg UseLimit; 
      time EnterTime; 
      time LeaveTime; 
      time DeltaTime; 
      begin
         ClkCount = 0;
         UseLimit = 1'b1;
         $display(" %s  : Waiting for falling edge  --- Note", IdentStr); 
         EnterTime = $time; 
         if (ClkLimit > 0)
         begin : BL1
            // if wait time limit is zero, then unlimited wait allowed
            while (ClkCount != ClkLimit)
            begin : WL1
               @(clk_p, intan_p_net); 
               if (intan_p_net == 1'b0)
               begin
                  $display("Falling edge detected --- Note"); 
                  disable BL1; 
               end 
               if (clk_p == 1'b1)
               begin
                  ClkCount = ClkCount + 1; 
               end 
            end 
            LeaveTime = $time; 
            DeltaTime = LeaveTime - EnterTime; 
            if (ClkCount < ClkLimit)
            begin
               $display(" %s  : Falling Edge appeared after  %t  --- Note", IdentStr, DeltaTime); 
            end
            else
            begin
               $display(" %s  : Wait for falling edge exceeded time limit --- ERROR", IdentStr); 
            end 
         end
         else
         begin
            @(negedge intan_p_net); 
            LeaveTime = $time; 
            DeltaTime = LeaveTime - EnterTime; 
            $display(" %s  : Falling Edge appeared after  %t --- Note", IdentStr, DeltaTime); 
         end 
      end
   endtask

   //------------------------------------------------------------------
   // Procudures and functions from pcimaster_model_package package
   //------------------------------------------------------------------
   //--------------------------------------------------------------------------
   // procedure memwr_single
   //--------------------------------------------------------------------------
   // description:
   //    Memory space write single data
   //
   // parameters:
   //    address  - transaction address
   //    data     - data
   //    ben      - byte enables (active low)
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task memwr64_single;
      input[31:0] address; 
      input[63:0] data; 
      input[7:0] ben; 

      begin
         master_params_Command = MWR_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = ben ; 
         master_params_BurstLength = 1 ; 
         master_params_Data = data ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         master_params_Transfer_64 = 1'b1 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   task memwr32_single;
      input[31:0] address; 
      input[31:0] data; 
      input[3:0] ben; 

      begin
         master_params_Command = MWR_CODE ; 
         master_params_Address = address ; 
         master_params_BEn[3:0] = ben ; 
         master_params_BEn[7:4] = {4{1'b0}} ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'b0}} ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure memrd_single
   //--------------------------------------------------------------------------
   // description:
   //    Memory space read single data
   //
   // parameters:
   //    address  - transaction address
   //    data     - data
   //    ben      - byte enables (active low)
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task memrd64_single;
      input[31:0] address; 
      input[63:0] data; 
      input[7:0] ben; 

      begin
         master_params_Command = MRD_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = ben ; 
         master_params_BurstLength = 1 ; 
         master_params_Data = data ; 
         master_params_Transfer_64 = 1'b1 ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   task memrd32_single;
      input[31:0] address; 
      input[31:0] data; 
      input[3:0] ben; 

      begin
         master_params_Command = MRD_CODE ; 
         master_params_Address = address ; 
         master_params_BEn[3:0] = ben ; 
         master_params_BEn[7:4] = 4'b1111 ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'bX}} ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // description:
   //    Configuration space write
   //
   // parameters:
   //    device   - device number (0 to 7)
   //    address  - transaction address
   //    data     - data
   //    ben      - byte enables (active low)
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task cfgwr_single;
      input device; 
      integer device;
      input[31:0] address; 
      input[31:0] data; 
      input[3:0] ben; 

      begin
         master_params_Command = CFGWR_CODE ; 
         master_params_Address = cfg_addr(device, address) ; 
         master_params_BEn[3:0] = ben ; 
         master_params_BEn[7:4] = 4'b1111 ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'b0}} ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure memwr_blockfill
   //--------------------------------------------------------------------------
   // description:
   //    Memory write block - fills memory block with data
   //
   // parameters:
   //    address  - initial transaction address
   //    length   - length of each transaction
   //    data     - data
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task memwr64_blockfill;
      input[31:0] address; 
      input[31:0] data; 
      input length; 
      integer length;

      begin
         master_params_Command = MWR_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = {1{1'b0}} ; 
         master_params_BurstLength = length ; 
         master_params_Data = data ; 
         master_params_Transfer_64 = 1'b1 ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   task memwr32_blockfill;
      input[31:0] address; 
      input[31:0] data; 
      input length; 
      integer length;

      begin
         master_params_Command = MWR_CODE ; 
         master_params_Address = address ; 
         master_params_BEn[3:0] = {4{1'b0}} ; 
         master_params_BEn[7:4] = 4'b1111 ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'b0}} ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure memrd_block
   //--------------------------------------------------------------------------
   // description:
   //    Memory read block - read block of memory and check data
   //
   // parameters:
   //    address  - initial transaction address
   //    length   - length of each transaction
   //    data     - data
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task memrd64_block;
      input[31:0] address; 
      input[63:0] data; 
      input length; 
      integer length;

      begin
         master_params_Command = MRD_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = {1{1'b0}} ; 
         master_params_BurstLength = length ; 
         master_params_Data = data ; 
         master_params_Transfer_64 = 1'b1 ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //
   task memrd32_block;
      input[31:0] address; 
      input[31:0] data; 
      input length; 
      integer length;

      begin
         master_params_Command = MRD_CODE ; 
         master_params_Address = address ; 
         master_params_BEn[3:0] = 4'b0000 ; 
         master_params_BEn[7:4] = 4'b1111 ; 
         master_params_Transfer_64 = 1'b0 ; 
         master_params_BurstLength = 1 ; 
         master_params_Data[31:0] = data ; 
         master_params_Data[63:32] = {32{1'bX}} ; 
         master_params_DataFileName = "#NO_VECTOR_FILE" ; 
         master_params_GenFastBack = 1'b0 ; 
         exec = 1'b1 ; // begin pci transaction execution
         @(posedge done)
         exec = 1'b0 ; // end pci transaction execution
         master_params_GenPerr = 1'b0 ;
         master_params_GenPerr64 = 1'b0 ;
         master_params_GenSerr = 1'b0 ;
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure memwr_vectfile
   //--------------------------------------------------------------------------
   // description:
   //    Memory write transaction - data to written stored in vector file.
   //
   // parameters:
   //    address  - initial transaction address
   //    length   - length of each transaction
   //    vectfile - vector file
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------

   task memwr64_vectfile;
      input[31:0] address; 
      input length; 
      integer length;
      input vectfilename; 

      //reg fopen_status; 

      begin
         master_params_Command = MWR_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = {8{1'b0}}; 
         master_params_BurstLength = length ; 
         master_params_GenFastBack = 1'b0 ; 
         master_params_Transfer_64 = 1'b1 ; 
         //FILE_OPEN (fopen_status,datafile, vectfilename,READ_MODE); -- JS
         //if (fopen_status = 1'b1)
         //begin
            $display("File open OK --- NOTE"); 
            master_params_DataFileName[1:8] = "A" ; 
            exec = 1'b1 ; // begin pci transaction execution
            @(posedge done)
            exec = 1'b0 ; // end pci transaction execution
            master_params_GenPerr = 1'b0 ;
            master_params_GenPerr64 = 1'b0 ;
            master_params_GenSerr = 1'b0 ;
            master_params_DataFileName = "#NO_VECTOR_FILE"; 
         //end
         ////FILE_CLOSE(DataFile);   -- JS                  -- Close vector file
         //else
         //begin
         //   $display(" %s - File open failed -- FAILURE", vectfilename); 
         //end 
         #1;
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure memrd_vectfile
   //--------------------------------------------------------------------------
   // description:
   //    memory read transaction with read data compared to vectors in vector file
   //
   // parameters:
   //    address  - initial transaction address
   //    length   - length of each transaction
   //    vectfile - vector file
   //    done     - signal
   // results:
   //    exec   - signal - enables master transaction
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task memrd64_vectfile;
      input[31:0] address; 
      input length; 
      integer length;
      input vectfilename; 

      //reg fopen_status; 

      begin
         master_params_Command = MRD_CODE ; 
         master_params_Address = address ; 
         master_params_BEn = {8{1'b0}} ; 
         master_params_BurstLength = length ; 
         master_params_GenFastBack = 1'b0 ; 
         master_params_Transfer_64 = 1'b1 ; 
         //FILE_OPEN (fopen_status,datafile, vectfilename,READ_MODE); -- JS
         // JS How to get fopen_status in Verilog?
         //if (fopen_status == open_ok)
         //begin
            $display(" File open OK --- NOTE"); 
            master_params_DataFileName[1:8] = "A" ; 
            exec = 1'b1 ; // begin pci transaction execution
            @(posedge done)
            exec = 1'b0 ; // end pci transaction execution
            master_params_GenPerr = 1'b0 ;
            master_params_GenPerr64 = 1'b0 ;
            master_params_GenSerr = 1'b0 ;
            master_params_DataFileName = "#NO_VECTOR_FILE"; 
         //end
         ////FILE_CLOSE(DataFile);                     -- Close vector file JS
         //else
         //begin
         //   $display(" %s - File open failed --- FAILURE", vectfilename); 
         //end 
         #1;
      end
   endtask

   //----------------------------------------------------------------
   // procedure generate_perr
   //----------------------------------------------------------------
   // description:
   //    This procedure enables data parity error generating
   // parameters:
   //    none
   // results;
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task generate_perr;
      inout params_genperr; //
      begin
         params_genperr = 1'b1 ; 
      end
   endtask

   task generate_perr64;
      inout params_genperr64; 
      begin
         params_genperr64 = 1'b1 ; 
      end
   endtask

   //----------------------------------------------------------------
   // procedure generate_serr
   //----------------------------------------------------------------
   // description:
   //    This procedure enables address parity error generating
   // parameters:
   //    none
   // results;
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task generate_serr;
      inout params_genserr; 
      begin
         params_genserr = 1'b1 ; 
      end
   endtask

   //----------------------------------------------------------------
   // procedure Set_BAR
   //----------------------------------------------------------------
   // description:
   //    This procedure sets base address to the BAR in cards PCI configuration
   //    space register
   // parameters:
   //    device   - device number - used for IDSEL device selection (0 to 7)
   //    bar      - BAR cfg. space address (0x10 - 0x24,0x30)
   //    bar_map  - BAR configuration information(the value to be read after all \'1\' written to BAR)
   //    addr     - memory or I/O space address to be written to BAR
   // results;
   //    params_ResultOK - returns boolean value, which confirms successfull
   //                      BAR setup
   task set_bar;
      input device; 
      integer device;
      input[31:0] bar; 
      input[31:0] bar_map; 
      input[31:0] addr; 
      input results_ResultOK; 

      reg[31:0] address; 
      reg[7:0] bar_addr; 
      reg result_ok; 

      begin
         result_ok = 1'b1; 
         bar_addr = bar[7:0] & 'h3D; 
         case (bar_addr)
            'h10 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 0 Setup "); 
                     end
            'h14 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 1 Setup "); 
                     end
            'h18 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 2 Setup "); 
                     end
            'h1C :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 3 Setup "); 
                     end
            'h20 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 4 Setup "); 
                     end
            'h24 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Base Address Register 5 Setup "); 
                     end
            'h30 :
                     begin
                        $fdisplay(logfile, " "); 
                        $fdisplay(logfile, "Expansion ROM Base Address Register Setup "); 
                     end
            default :
                     begin
                        $display("Wrong BAR address --- ERROR"); 
                        result_ok = 1'b0; 
                     end
         endcase 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "Detect BAR settings "); 

         cfgwr_single(device, bar, 'hFFFFFFFF, 4'b0000); 
         #60; 

         // Read BAR  i.e. detect BAR size
         cfgrd_single(device, bar, bar_map, 4'b0000); 

         bar_setup_report(master_params_Data[31:0]); 
         #60; 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "Set BAR address "); 

         cfgwr_single(device, bar, addr, 4'b0000); 

         #60; 
         // Verify BAR
         address = {addr[31:4], bar_map[3:0]}; // set correct LSB value

         cfgrd_single(device, bar, address, 4'b0000); 

         if (results_ResultOK)
         begin
            $fdisplay(logfile, "BAR address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR address write error"); 
            $display("BAR address write error --- ERROR"); 
            result_ok = 1'b0; 
         end 
         master_params_ResultOK = result_ok ; 
      end
   endtask

   task verify_perr;
      input device; 
      integer device;
      output passed; 

      reg[31:0] data; 

      begin
         #30; 
         $fdisplay(logfile, "Verify data parity error reporting PERR#"); 
         passed = 1'b1; 
         if (perr_sig == 1'b1)
         begin
            $fdisplay(logfile, " - PERR# assertion OK");
         end
         else
         begin
            $fdisplay(logfile, " - PERR# assertion FAILED ");
            passed = 1'b0; 
         end 
         //verify status register bits
         data = {1'b1, 31'bX}; 

         cfgrd_single(device, STATR, data, STATR_BE); 

         if (master_result_ResultOK == 1'b1)
         begin
            $fdisplay(logfile, " - Status Bits 15 set correctly");
         end
         else
         begin
            $fdisplay(logfile, "  - ERROR: Status Bits 15 not set");
            $display("ERROR: - Status Bits 15 not set --- ERROR");
            passed = 1'b0; 
         end 
         // Clear parity error bits
         $fdisplay(logfile, " - Clear parity error bits");
         data = {1'b1, 31'b0}; 

         cfgwr_single(device, STATR, data, STATR_BE); 

         // Verify parity error bits clear in configuration space
         $fdisplay(logfile, " - Verify parity error bits clear");
         data = {1'b0, 31'bX}; 

         cfgrd_single(device, STATR, data, STATR_BE); 

         if (master_params_ResultOK == 1'b1)
         begin
            $fdisplay(logfile, " - Parity Status Bits reset OK");
         end
         else
         begin
            $fdisplay(logfile, "ERROR: - Status Bits 15 not clear");
            $display("ERROR: - Status Bits 15 not clear --- ERROR");
            passed = 1'b0; 
         end 
      end
   endtask

   task verify_serr;
      input device; 
      integer device;
      output passed; 

      reg[31:0] data; 

      begin
         #30; 
         $fdisplay(logfile, "Verify system error reporting --- SERR#"); 
         passed = 1'b1; 
         if (serr_sig == 1'b1)
         begin
            $fdisplay(logfile, " - SERR# assertion OK"); 
         end
         else
         begin
            $fdisplay(logfile, " - SERR# assertion FAILED"); 
            passed = 1'b0; 
         end 
         //verify status register bits
         data = {1'b1, 1'b1, 30'bX}; 

         cfgrd_single(device, STATR, data, STATR_BE); 

         if (master_result_ResultOK == 1'b1)
         begin
            $fdisplay(logfile, " - Status Bit 14 and Bit 15 set correctly"); 
         end
         else
         begin
            if ((master_result_Data[31]) != 1'b1)
            begin
               $fdisplay(logfile, "  - ERROR: Status Bits 15 not set"); 
               $display("ERROR: - Status Bits 15 not set --- ERROR"); 
            end 
            if ((master_result_Data[30]) != 1'b1)
            begin
               $fdisplay(logfile, "  - ERROR: Status Bits 14 not set"); 
               $display("ERROR: - Status Bits 14 not set --- ERROR"); 
            end 
            passed = 1'b0; 
         end 
         // Clear parity error bits
         $fdisplay(logfile, " - Clear parity error bits"); 
         data = {1'b1, 1'b1, {30{1'b0}}}; 

         cfgwr_single(device, STATR, data, STATR_BE); 

         // Verify parity error bits clear in configuration space
         $fdisplay(logfile, " - Verify parity error bits clear"); 
         data = {1'b0, 1'b0, {30{1'bX}}}; 

         cfgrd_single(device, STATR, data, STATR_BE); 

         if (master_params_ResultOK == 1'b1)
         begin
            $fdisplay(logfile, " - Parity Status Bits reset OK"); 
         end
         else
         begin
            if ((master_params_Data[31]) != 1'b0)
            begin
               $fdisplay(logfile, "ERROR: - Status Bits 15 not clear"); 
               $display("ERROR: - Status Bits 15 not clear --- ERROR"); 
            end 
            if ((master_params_Data[30]) != 1'b0)
            begin
               $fdisplay(logfile, "ERROR: - Status Bits 14 not clear"); 
               $display("ERROR: - Status Bits 14 not clear --- ERROR"); 
            end 
            passed = 1'b0; 
         end 
      end
   endtask
//
//-----------------------------------------------------------------------------
//  MAIN CODE
//
//
   initial
   begin
      parkmaster = 1'b0;
      end_sim = 1'b0;
      exec = 1'b0;
      targetparams = 1'b0;
      logfile = $fopen("pci_m64.sim.log");
      // PCI Master Initial parameters
      master_params_Command = MRD_CODE;
      master_params_Address = {32{1'b0}};
      master_params_BEn = {8{1'b0}};
      master_params_BurstLength = 1;
      master_params_Transfer_64 = 1'b1;
      master_params_Data = 64'h0;
      master_params_IrdyWait = 0;
      master_params_DataFileName = "#NO_VECTOR_FILE";
      master_params_RetryLimit = 512;
      master_params_RetryDelay = 25;
      master_params_GenFastBack = 1'b0;
      master_params_GenPerr = 1'b0;
      master_params_GenPerr64 = 1'b0;
      master_params_GenSerr = 1'b0;
      master_params_CheckResult = 1'b1;
      master_params_ResultOK = 1'b0;
      master_params_TermType = MASTER_END;
      // AHB Master model init
      mhtrans[1]  = HTRANS_IDLE;
      mhsize[1]   = HSIZE_1B;
      mhburst[1]  = HBURST_SINGLE;
      mhbusreq[1] = 1'b0;
      mhwrite[1]  = 1'b0;
      mhprot[1]   = 4'b0000;
      mhaddr[1]   = {32{1'bx}};
      mhwdata[1]  = {32{1'bx}};
   end


   // Unit Under Test port map
   //----------------------------------------------------------------
   pcim64ahbw UUT (.clk_p(clk_p), .rstn_p(rstn_p), .ad_p(ad_p_net), .cbe_p(cbe_p_net), .par_p(par_p_net), .par64_p(par64_p_net), .framen_p(framen_p_net), .irdyn_p(irdyn_p_net), .trdyn_p(trdyn_p_net), .devseln_p(devseln_p_net), .stopn_p(stopn_p_net), .idsel_p(idsel[DEVICE_NO]), .req64n_p(req64n_p_net), .ack64n_p(ack64n_p_net), .perrn_p(perrn_p_net), .serrn_p(serrn_p_net), .reqn_p(reqn_p_net[1]), .gntn_p(gntn_p[1]), .intan_p(intan_p_net),
      .hclk(hclk),
      .hresetn(hresetn),
      .mhaddr(mhaddr_uut),
      .mhbusreq(mhbusreq_uut),
      .mhlock(mhlock_uut),
      .mhgrant(mhgrant[0]),
      .mhwrite(mhwrite_uut),
      .mhtrans(mhtrans_uut),
      .mhsize(mhsize_uut),
      .mhprot(mhprot_uut),
      .mhburst(mhburst_uut),
      .mhready(hready),
      .mhresp(hresp),
      .mhrdata(hrdata),
      .mhwdata(mhwdata_uut),
      .shsel(hsel[1]),
      .shwrite(hwrite),
      .shtrans(htrans),
      .shsize(hsize),
      .shburst(hburst),
      .shaddr(haddr),
      .shready(shready_1),
      .shresp(shresp_1),
      .shrdata(shrdata_1),
      .shwdata(hwdata),
      .hint(hint)
      ); 
   
   always@(mhaddr_uut or mhbusreq_uut or mhlock_uut or mhwrite_uut or 
           mhtrans_uut or mhsize_uut or mhprot_uut or mhburst_uut or mhwdata_uut)
   begin
      mhaddr[0]   <= mhaddr_uut;
      mhbusreq[0] <= mhbusreq_uut;
      mhlock[0]   <= mhlock_uut;
      mhwrite[0]  <= mhwrite_uut;
      mhtrans[0]  <= mhtrans_uut;
      mhsize[0]   <= mhsize_uut;
      mhprot[0]   <= mhprot_uut;
      mhburst[0]  <= mhburst_uut;
      mhwdata[0]  <= mhwdata_uut;
   end

   //----------------------------------------------------------------
   // PCI Target model
   //----------------------------------------------------------------
   target64_model UM0(
      .rstn(rstn_p), 
      .clk(clk_p), 
      .adio(ad_p_net), 
      .cbe(cbe_p_net), 
      .par(par_p_net), 
      .par64(par64_p_net), 
      .idsel(idsel_p), 
      .framen(framen_p_net), 
      .req64n(req64n_p_net), 
      .irdyn(irdyn_p_net), 
      .trdyn(trdyn_p_net), 
      .devseln(devseln_p_net), 
      .ack64n(ack64n_p_net), 
      .stopn(stopn_p_net), 
      .perrn(perrn_p_net), 
      .serrn(serrn_p_net), 
      .params_enabled(targetparams), 
      .end_sim(end_sim)
      ); 
      defparam
         UM0.ENABLE64 = TARGET1_ENABLE64,
         UM0.VECT_FILENAME = TARGET1_VECTOR_FILENAME,
         UM0.LOG_FILENAME = TARGET1_LOG_FILENAME,
         UM0.DEC_SPEED = TARGET1_DEC_SPEED,
         UM0.BASE_ADDR = TARGET1_BASE_ADDR,
         UM0.SIZE = TARGET1_SIZE;

   //----------------------------------------------------------------
   // PCI Target model
   //----------------------------------------------------------------
   target64_model UM1(
      .rstn(rstn_p), 
      .clk(clk_p), 
      .adio(ad_p_net), 
      .cbe(cbe_p_net), 
      .par(par_p_net), 
      .par64(par64_p_net), 
      .idsel(idsel_p), 
      .framen(framen_p_net), 
      .req64n(req64n_p_net), 
      .irdyn(irdyn_p_net), 
      .trdyn(trdyn_p_net), 
      .devseln(devseln_p_net), 
      .ack64n(ack64n_p_net), 
      .stopn(stopn_p_net), 
      .perrn(perrn_p_net), 
      .serrn(serrn_p_net), 
      .params_enabled(targetparams), 
      .end_sim(end_sim)
      ); 
      defparam
         UM1.ENABLE64 = TARGET2_ENABLE64,
         UM1.VECT_FILENAME = TARGET2_VECTOR_FILENAME,
         UM1.LOG_FILENAME = TARGET2_LOG_FILENAME,
         UM1.DEC_SPEED = TARGET2_DEC_SPEED,
         UM1.BASE_ADDR = TARGET2_BASE_ADDR,
         UM1.SIZE = TARGET2_SIZE;

   //----------------------------------------------------------------
   // PCI Master simulation model
   //----------------------------------------------------------------
   master64 U_M64 (
      .rstn_p(rstn_p), 
      .clk_p(clk_p), 
      .exec(exec_net), 
      .ad_p(ad_p_net), 
      .cbe_p(cbe_p_net), 
      .par_p(par_p_net), 
      .par64_p(par64_p_net), 
      .framen_p(framen_p_net), 
      .req64n_p(req64n_p_net), 
      .irdyn_p(irdyn_p_net), 
      .trdyn_p(trdyn_p_net), 
      .devseln_p(devseln_p_net), 
      .ack64n_p(ack64n_p_net), 
      .stopn_p(stopn_p_net), 
      .idsel_p(idsel_p), 
      .perrn_p(perrn_p_net), 
      .serrn_p(serrn_p_net), 
      .reqn_p(reqn_p_net[0]), 
      .gntn_p(gntn_p[0]), 
      .intan_p(intan_p_net), 
      .serr_sig(serr_sig), 
      .perr_sig(perr_sig), 
      .done(done), 
      .master_params_Command(master_params_Command), 
      .master_params_Address(master_params_Address), 
      .master_params_BEn(master_params_BEn), 
      .master_params_BurstLength(master_params_BurstLength_net), 
      .master_params_Transfer_64(master_params_Transfer_64), 
      .master_params_Data(master_params_Data), 
      .master_params_IrdyWait(master_params_IrdyWait_net), 
      .master_params_DataFileName(master_params_DataFileName), 
      .master_params_RetryLimit(master_params_RetryLimit_net), 
      .master_params_RetryDelay(master_params_RetryDelay_net), 
      .master_params_GenFastBack(master_params_GenFastBack), 
      .master_params_GenPerr(master_params_GenPerr), 
      .master_params_GenPerr64(master_params_GenPerr64), 
      .master_params_GenSerr(master_params_GenSerr), 
      .master_params_CheckResult(master_params_CheckResult), 
      .master_params_ResultOK(master_params_ResultOK), 
      .master_params_TermType(master_params_TermType), 
      .master_result_ResultOK(master_result_ResultOK), 
      .master_result_TermType(master_result_TermType), 
      .master_result_Data(master_result_Data), 
      .end_sim(end_sim)
      ); 

   //----------------------------------------------------------------
   // PCI Arbiter model
   //----------------------------------------------------------------
   pci_arbiter_model U_ARBIT(
      .rstn(rstn_p), 
      .clk(clk_p), 
      .ad(ad_p_net[31:0]), 
      .cbe(cbe_p_net[3:0]), 
      .framen(framen_p_net), 
      .reqn(reqn_p_net), 
      .gntn(gntn_p), 
      .idsel(idsel)); 
      defparam
         U_ARBIT.MASTER_NO = ARBIT_MASTER_NO,
         U_ARBIT.TARGET_NO = ARBIT_TARGET_NO,
         U_ARBIT.LATENCY_LIMIT = 0;

   //----------------------------------------------------------------
   // PCI Bus monitor
   //----------------------------------------------------------------
   pci_busmonitor64 UBM64(
      .rstn(rstn_p), 
      .clk(clk_p), 
      .adio(ad_p_net), 
      .cbe(cbe_p_net), 
      .par(par_p_net), 
      .par64(par64_p_net), 
      .idsel(idsel[DEVICE_NO]), 
      .framen(framen_p_net), 
      .req64n(req64n_p_net), 
      .irdyn(irdyn_p_net), 
      .devseln(devseln_p_net), 
      .ack64n(ack64n_p_net), 
      .trdyn(trdyn_p_net), 
      .stopn(stopn_p_net), 
      .reqn(reqn_p_net[DEVICE_NO]), 
      .gntn(gntn_p[DEVICE_NO]), 
      .perrn(perrn_p_net), 
      .serrn(serrn_p_net), 
      .end_sim(end_sim)
      ); 
      defparam
         UBM64.NUM_MASTERS = 1;

   //----------------------------------------------------------------
   // AHB RAM Slave model
   // device number 0
   ahbslaveram_model AHBRAM (
      .hclk(hclk),
      .hresetn(hresetn),
      .shsel(hsel[0]),
      .shwrite(hwrite),
      .shreadyin(hready),
      .shtrans(htrans),
      .shsize(hsize),
      .shburst(hburst),
      .shaddr(haddr),
      .shwdata(hwdata),
      .shrdata(shrdata_0),
      .shreadyout(shready_0),
      .shresp(shresp_0)
      );

 
   // Clock Genetator
   always 
   begin : CLOCK_CLK
      if (end_sim == 1'b0)
      begin
         clk_p = 1'b1 ; 
         # (7.5); //0 ps
      end
      else
      begin
         forever #100000; 
      end 
      if (end_sim == 1'b0)
      begin
         clk_p = 1'b0 ; 
         # (7.5); //7.5 ns
      end
      else
      begin
         forever #100000; 
      end 
   end 
   // AHB clock
   always
   begin : CLOCK_hclk
	hclk = 1'b0;
	# 5; //0
	hclk = 1'b1;
	# 5; //10
   end
   // Initial Reset Pulse Generator
   always 
   begin : pRESET
      rstn_p = 1'b0 ; 
      #8; //8 ns
      rstn_p = 1'b1 ; 
      forever #100000; 
   end 
   // AHB reset
   always
   begin : RESETGEN
      hresetn = 1'b0 ; 
      #20; //20 ns
      hresetn = 1'b1 ; 
      forever #10; 
   end
   //
   // AHB bus address register
   //
   always @(posedge hclk or negedge hresetn)
   begin
      if (!hresetn)
      begin
         haddr_r <= {32{1'bx}}; 
      end
      else
      begin
         if (hready)
            haddr_r <= haddr; 
      end 
   end 
   //
   // simple AHB slave select decoder
   //
   always @(haddr)
      begin
         hsel[0] <= 1'b0;
         hsel[1] <= 1'b0;
         hsel[2] <= 1'b0;
         hsel[3] <= 1'b0;
         if (SLAVE0_PRESENT & (haddr >= SLAVE0_BASE) & (haddr < (SLAVE0_BASE + SLAVE0_SIZE)))
         begin
            hsel[0] <= 1'b1;
         end
         else if (SLAVE1_PRESENT & (haddr >= SLAVE1_BASE) & (haddr < (SLAVE1_BASE + SLAVE1_SIZE))) 
         begin
            hsel[1] <= 1'b1;
         end
         else if (SLAVE2_PRESENT & (haddr >= SLAVE2_BASE) & (haddr < (SLAVE2_BASE + SLAVE2_SIZE))) 
         begin
            hsel[2] <= 1'b1;
         end
         else if (SLAVE3_PRESENT & (haddr >= SLAVE2_BASE) & (haddr < (SLAVE2_BASE + SLAVE2_SIZE))) 
         begin
            hsel[2] <= 1'b1;
         end
         else  
         begin
            hsel[0] <= 1'b1;
         end
      end
   //
   // simple AHB slave mux
   //
   always @(haddr_r or 
            shrdata_0 or shready_0 or shresp_0 or shrdata_1 or shready_1 or shresp_1 or
            shrdata_2 or shready_2 or shresp_2 or shrdata_3 or shready_3 or shresp_3
           )
      begin
         if (SLAVE0_PRESENT & (haddr_r >= SLAVE0_BASE) & (haddr_r < (SLAVE0_BASE + SLAVE0_SIZE)))
         begin
            hrdata <= shrdata_0;
            hready <= shready_0;
            hresp  <= shresp_0;
         end
         else if (SLAVE1_PRESENT & (haddr_r >= SLAVE1_BASE) & (haddr_r < (SLAVE1_BASE + SLAVE1_SIZE))) 
         begin
            hrdata <= shrdata_1;
            hready <= shready_1;
            hresp  <= shresp_1;
         end
         else if (SLAVE2_PRESENT & (haddr_r >= SLAVE2_BASE) & (haddr_r < (SLAVE2_BASE + SLAVE2_SIZE))) 
         begin
            hrdata <= shrdata_2;
            hready <= shready_2;
            hresp  <= shresp_2;
         end
         else if (SLAVE3_PRESENT & (haddr_r >= SLAVE3_BASE) & (haddr_r < (SLAVE3_BASE + SLAVE3_SIZE))) 
         begin
            hrdata <= shrdata_3;
            hready <= shready_3;
            hresp  <= shresp_3;
         end
         else  
         begin
            hrdata <= shrdata_0;
            hready <= shready_0;
            hresp  <= shresp_0;
         end
      end
   //
   // simple AHB bus multiplexor substitution
   //
   always @(hmaster or 
            mhwrite[0] or mhtrans[0] or mhsize[0] or mhprot[0] or mhburst[0] or mhaddr[0] or mhwdata[0] or
            mhwrite[1] or mhtrans[1] or mhsize[1] or mhprot[1] or mhburst[1] or mhaddr[1] or mhwdata[1]
           )
      begin
         case (hmaster)
            4'b0000 :
               begin
                  hwrite <= mhwrite[0];
                  htrans <= mhtrans[0];
                  hsize  <= mhsize[0] ;
                  hprot  <= mhprot[0];
                  hburst <= mhburst[0];
                  haddr  <= mhaddr[0] ;
                  hwdata <= mhwdata[0];
               end
            4'b0001 :
               begin
                  hwrite <= mhwrite[1];
                  htrans <= mhtrans[1];
                  hsize  <= mhsize[1] ;
                  hprot  <= mhprot[1];
                  hburst <= mhburst[1];
                  haddr  <= mhaddr[1] ;
                  hwdata <= mhwdata[1];
               end
            default :
               begin
                  hwrite <= mhwrite[0];
                  htrans <= mhtrans[0];
                  hsize  <= mhsize[0] ;
                  hprot  <= mhprot[0];
                  hburst <= mhburst[0];
                  haddr  <= mhaddr[0] ;
                  hwdata <= mhwdata[0];
               end
         endcase
      end
   //
   // simple AHB arbiter substitution
   //                                    
   always @(posedge hclk or negedge hresetn)
      begin
         if (!hresetn)
         begin
            #1;
            hmaster <= 4'b0000;
            mhgrant[0] <= 1'b0; 
            mhgrant[1] <= 1'b0; 
         end
         else
         begin
            #1;
            if (mhbusreq[0])
            begin
              hmaster <= 4'b0000;
         	  mhgrant[0] <= 1'b1;
         	end  
         	else if (mhbusreq[1])
         	begin
               hmaster    <= 4'b0001;
               mhgrant[1] <= 1'b1; 
            end
         end
      end

   //
   // Main Stimulus process
   //
   always 
   begin : STIMULUS
      reg test_passed; 
      reg rpt_ok; 
      reg[31:0] address; 
      reg[63:0] data; 
      reg[7:0] ben; 
      reg[31:0] data32; 
      reg[3:0] ben32; 
      test_passed = 1'b1;
      rpt_ok = 1'b1;

      // of stimulus process
      ad_p = {64{1'b0}};
      cbe_p = {8{1'b1}}; 
      perrn_p = 1'b1 ; 
      par_p = 1'b0 ; 
      par64_p = 1'b0 ; 
      serrn_p = 1'b1 ; 
      idsel_p = 1'b0 ; 
      framen_p = 1'b1 ; 
      devseln_p = 1'b1 ; 
      irdyn_p = 1'b1 ; 
      trdyn_p = 1'b1 ; 
      stopn_p = 1'b1 ; 
      intan_p = 1'b1 ; 
      req64n_p = 1'b1 ; 
      ack64n_p = 1'b1 ; 
      reqn_p = 2'b11 ; 
      parkmaster = 1'b0 ; 

      #70; 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "*******************************************************************************"); 
      $fdisplay(logfile, "*                                                                             *"); 
      $fdisplay(logfile, "*                   PCIM64-AHB Testbench logfile                              *"); 
      $fdisplay(logfile, "*                   (c)2003 CAST Inc.                                         *"); 
      $fdisplay(logfile, "*                                                                             *"); 
      $fdisplay(logfile, "*******************************************************************************"); 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "--   PCI Config. Space Setup                                                --"); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, " "); 

      // Read Vedor ID and Device ID
      cfgrd_single(DEVICE_NO, VID, 'h6466ABCD, 4'b0000); 
      #60; 
      //-----------------------------------------------------------------------------
      //
      // Step 1. Target setup 
      //
      //-----------------------------------------------------------------------------
      //------------------------------------------------------
      // Setup BAR0 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.1 Base Address Register 0 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00101 ; 

      set_bar(DEVICE_NO, BAR0, BAR0_MAP, BAR0_ADDR, master_result_ResultOK); 

      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, "BAR0 address written correctly"); 
      end
      else
      begin
         $fdisplay(logfile, "BAR0 address write error"); 
         $display("BAR0 address write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //------------------------------------------------------
      // Setup BAR1 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.2 Base address register 1 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00102 ; 

      if (BAR1_PRESENT)
      begin
         set_bar(DEVICE_NO, BAR1, BAR1_MAP, BAR1_ADDR, master_result_ResultOK); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR1 address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR1 address write error"); 
            $display("BAR1 address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "BAR1 is not used in the application"); 
         $fdisplay(logfile, ""); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, BAR1, 'h00000000, 4'b0000); 

         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR1 = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR1 = 0  read failed"); 
            $display("BAR1 = 0 read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup BAR2 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.3 Base Address Register 2 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00103 ; 
      if (BAR2_PRESENT)
      begin
         set_bar(DEVICE_NO, BAR2, BAR2_MAP, BAR2_ADDR, master_result_ResultOK); 

         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR2 address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR2 address write error"); 
            $display("BAR2 address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "BAR2 is not used in the application"); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, BAR2, 'h00000000, 4'b0000); 

         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR2 = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR2 = 0  read failed"); 
            $display("BAR2 = 0  read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup BAR3 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.4 Base Address Register 3 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00104 ; 
      if (BAR3_PRESENT)
      begin
         set_bar(DEVICE_NO, BAR3, BAR3_MAP, BAR3_ADDR, master_result_ResultOK); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR3 address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR3 address write error"); 
            $display("BAR3 address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "BAR3 is not used in the application"); 
         $fdisplay(logfile, ""); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, BAR3, 'h00000000, 4'b0000); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR3 = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR3 = 0  read failed"); 
            $display("BAR3 = 0  read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup BAR4 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.5 Base Address Register 4 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00105 ; 
      if (BAR4_PRESENT)
      begin
         set_bar(DEVICE_NO, BAR4, BAR4_MAP, BAR4_ADDR, master_result_ResultOK); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR4 address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR4 address write error"); 
            $display("BAR4 address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "BAR4 is not used in the application"); 
         $fdisplay(logfile, ""); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, BAR4, 'h00000000, 4'b0000); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR4 = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR4 = 0  read failed"); 
            $display("BAR4 = 0  read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup BAR5 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.6 Base Address Register 5 setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00106 ; 
      if (BAR5_PRESENT)
      begin
         set_bar(DEVICE_NO, BAR5, BAR5_MAP, BAR5_ADDR, master_result_ResultOK); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR5 address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR5 address write error"); 
            $display("BAR5 address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "BAR5 is not used in the application"); 
         $fdisplay(logfile, ""); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, BAR5, 'h00000000, 4'b0000); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "BAR5 = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "BAR5 = 0  read failed"); 
            $display("BAR5 = 0  read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup EBAR 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.7 Expansion ROM Base Address Register setup "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00107 ; 
      if (EBAR_PRESENT)
      begin
         set_bar(DEVICE_NO, EBAR, EBAR_MAP, EBAR_ADDR + 1, master_result_ResultOK); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "EBAR address written correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "EBAR address write error"); 
            $display("EBAR address write error --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "Expansion ROM BAR is not used in the application"); 
         $fdisplay(logfile, ""); 
         // For unused BAR verify that is clear
         cfgrd_single(DEVICE_NO, EBAR, 'h00000000, 4'b0000); 
         if (master_result_ResultOK)
         begin
            $fdisplay(logfile, "EBAR = 0 read correctly"); 
         end
         else
         begin
            $fdisplay(logfile, "EBAR = 0  read failed"); 
            $display("EBAR = 0  read failed --- ERROR"); 
            test_passed = 1'b0; 
         end 
      end 
      //------------------------------------------------------
      // Setup Interrupt line register 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.8 Setup Interrupt line register "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      testphase = 00108 ; 
      data32 = {32{1'b0}}; 
      data32[7:0] = INT_LINE; 
      cfgwr_single(DEVICE_NO, INTLINE, data32, INTLINE_BE); 
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, "Interrupt line register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt line register write error"); 
         $display("Interrupt line register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      data32[7:0] = INT_LINE; 
      data32[31:7] = {25{1'bX}}; 
      cfgrd_single(DEVICE_NO, INTLINE, data32[31:0], INTLINE_BE); 
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, "Interrupt line register data written correctly"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt line register write error"); 
         $display("Interrupt line register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      #60; 
      //------------------------------------------------------
      // Setup Latency Timer & Cache Line Size Register 
      //------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "1.9 Latency Timer and Cache Line Size register "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      data32 = {32{1'b0}}; 
      data32[15:0] = {LAT_TIMER, CACHE_SIZE}; 
      cfgwr_single(DEVICE_NO, LATTIMER, data32, 4'b1100); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Latency Timer & Cache Line Size Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Latency Timer & Cache Line Size Register write error"); 
         $display("Latency Timer & Cache Line Size Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      data32 = {32{1'bX}}; 
      data32[15:0] = {LAT_TIMER, CACHE_SIZE}; 
      cfgrd_single(DEVICE_NO, LATTIMER, data32, INTLINE_BE); 
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, "Latency Timer & Cache Line Size Register data written correctly"); 
      end
      else
      begin
         $fdisplay(logfile, "Latency Timer & Cache Line Size Register write error"); 
         $display("Latency Timer & Cache Line Size Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      #60; 
      //-----------------------------------------------------------------------------
      //
      // Step 2. enable memory decoding and parity error reporting
      //
      //-----------------------------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2. Enable memory access and parity error reporting "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00200 ; 
      cfgwr_single(DEVICE_NO, CMDR, 'h00000143, CMDR_BE); 
      #60; 
      // verify written data
      data[31:16] = {16{1'bX}}; // do not compare results
      data[15:0] = 'h0143; 
      cfgrd_single(DEVICE_NO, CMDR, data[31:0], CMDR_BE); 
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, "Memory space enabled correctly"); 
      end
      else
      begin
         $fdisplay(logfile, "Memory space enable error"); 
         $display("Memory space enable error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      #60; 
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      // 2. Target access test                                                     --
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2. Target access test "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      //--------------------------------------------------------------------------
      // Write operands  
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.1 Write single 64-bit data"); 
      testphase = 00201 ; 
      ben = 8'b00000000; 
      data = 64'h0FEDCBA987654321; 
      memwr64_single(BAR1_ADDR, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Write error"); 
         $display("Write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
    
      //--------------------------------------------------------------------------
      // Read operands  
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.2 Read single 64-bit data"); 
      #60; 
      testphase = 00202 ; 
      ben = 8'b00000000; 
      data = 64'h0FEDCBA987654321; 
      memrd64_single(BAR1_ADDR, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 64-bit read access successfull"); 
      end
      else
      begin
         $display(" 64-bit read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 64-bit read access FAILED"); 
         test_passed = 1'b0; 
      end 
      //--------------------------------------------------------------------------
      // Write operands in burst 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.3 Write operands in burst"); 
      #60; 
      testphase = 00203 ; 
      memwr64_vectfile(BAR1_ADDR, 16, "ram_burst.vec"); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Burst write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Burst write error"); 
         $display("Burst write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //--------------------------------------------------------------------------
      // Read operands in burst 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.4 Read operands in burst"); 
      #60; 
      testphase = 00204 ; 
      memrd64_vectfile(BAR1_ADDR, 16, "ram_burst.vec"); 
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "### RAM 64-bit burst access successfull"); 
      end
      else
      begin
         $display("RAM 64-bit burst access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "### RAM 64-bit burst access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.5 Write single 32-bit data"); 
      testphase = 00205 ; 
      address = BAR1_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'h87654321; 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "32-bit write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "32-bit write error"); 
         $display("32-bit write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      address = BAR1_ADDR + 4;
      ben32 = 4'b0000; 
      data32 = 32'h0FEDCBA9; 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "32-bit write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "32-bit write error"); 
         $display("32-bit write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
    
      //--------------------------------------------------------------------------
      // Read operands  
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------------------------");
      $fdisplay(logfile, "2.6 Read single 32-bit data"); 
      #60; 
      testphase = 00206 ; 
      address = BAR1_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'h87654321; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 32-bit read access successfull"); 
      end
      else
      begin
         $display(" 32-bit read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 32-bit read access FAILED"); 
         test_passed = 1'b0; 
      end 
      address = BAR1_ADDR+4;
      ben32 = 4'b0000; 
      data32 = 32'h0FEDCBA9; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 32-bit read access successfull"); 
      end
      else
      begin
         $display(" 32-bit read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " 32-bit read access FAILED"); 
         test_passed = 1'b0; 
      end 
     //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      // 3. DMA Function Test                                                      --
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------  
      //*******************************************************************************
      //* 64-bit Master to 64-bit Target DMA Transfer Test                            *
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3. Master access test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3.1 64-bit Master to 64-bit Target DMA Read Transfer Test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00301 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_RDADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write DMA Write Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000020; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.4 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000FF0707; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.5 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MRD_CODE}; // enable 64-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      
      //
      // Setup Target Model Parameters
      targetparams = 1'b1 ; 
      // PCI CFG_Space : Enable Master + I/O & MEM space decoding
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.6 Enable Master in Config. Register"); 
      $fdisplay(logfile, " "); 
      address = 32'h00000004; 
      ben = 8'b11111100; 
      data32 = 32'h00000147; 
      cfgwr_single(DEVICE_NO, CMDR, data32, CMDR_BE); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Control register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Control register write error"); 
         $display("Control register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.1.7 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.8 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.9 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.1.10 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3.2 64-bit Master to 64-bit Target DMA Write Transfer Test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00302 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_WRADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write DMA Write Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000020; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.4 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MWR_CODE}; // enable 64-bit DMA Write
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.2.5 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.6 Set DMA_CTRL Register - Disable DMA controller"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.7 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.2.8 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      //  
      #30; 
      //*******************************************************************************
      //* 32-bit Master to 32-bit Target DMA Transfer Test                            *
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3.3 32-bit Master to 32-bit Target DMA Transfer Test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00303 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.1 Set DMA PCI Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_RDADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write DMA Write Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000010; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.4 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000000300; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.5 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b0,1'b1,MRD_CODE}; // enable 32-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.3.6 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.7 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b0,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.8 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.3.9 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      #60; 
      //*******************************************************************************
      //* 32-bit Master to 32-bit Target Write DMA Transfer Test                            *
      //*******************************************************************************
      
      $fdisplay(logfile, " "); 
      testphase = 00304 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_WRADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write DMA Write Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000010; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.4 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b0,1'b1,MWR_CODE}; // enable 32-bit DMA Write
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.4.5 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.6 Set DMA_CTRL Register - Disable DMA controller"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.7 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.4.8 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      //  
      #30; 
      //*******************************************************************************
      //* 64-bit Master to 64-bit Target Transfer - Target Retry Test                 *
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3.5 64-bit Master to 64-bit Target Transfer - Target Retry Test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00305 ; 
      $fdisplay(logfile, " "); 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_RDADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write AHB Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000008; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.4 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      address = BAR0_ADDR + 'h108; 
      ben = 8'b11110000; 
      data = 64'h0000000000000300; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.5 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MRD_CODE}; // enable 64-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      
      //
      // Setup Target Model Parameters
      targetparams = 1'b1 ; 
      // PCI CFG_Space : Enable Master + I/O & MEM space decoding
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.6 Enable Master in Config. Register"); 
      $fdisplay(logfile, " "); 
      address = 32'h00000004; 
      ben = 8'b11111100; 
      data32 = 32'h00000147; 
      cfgwr_single(DEVICE_NO, CMDR, data32, CMDR_BE); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Control register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Control register write error"); 
         $display("Control register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.5.7 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.8 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.9 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.5.10 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "3.6 64-bit Master to 64-bit Target DMA Write Transfer Test with target retry"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00306 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_WRADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write DMA AHB Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000008; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.4 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MWR_CODE}; // enable 64-bit DMA Write
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "3.6.5 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("DMA T64->M64", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active - 64M-to-64T DMA Read Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      // Memory Write to DMA_CTRL
      // Disable DMA controller
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.6 Set DMA_CTRL Register - Disable DMA controller"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // Disable DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.7 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0001}; // Transfer successfull
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "3.6.8 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0001}; // Transfer successfull
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify that INTA# line deasserted
      if (intan_p_net != 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line deasserted"); 
         $fdisplay(logfile, " "); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not deasserted"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not deasserted "); 
         test_passed = 1'b0; 
      end 
      
      $fdisplay(logfile, $stime, " ns - DMA Read Transfer finished"); 
      $fdisplay(logfile, " "); 
      //  
      #30; 
      //---------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------
      //-- 4. Target Abnormal situations
      //---------------------------------------------------------------------------------
      //---------------------------------------------------------------------------------
      //*******************************************************************************
      //* Address Parity error test
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "4.1 Address Parity Error Test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00401 ; 
      address = DMA_PCIPTR; 
      ben32 = 4'b0000; 
      data32 = VOID_SPACE; 
      generate_serr(master_params_GenSerr); 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify error reporting
      verify_serr(DEVICE_NO, rpt_ok); 
      if (rpt_ok)
      begin
         $fdisplay(logfile, " SERR# reported correctly"); 
      end
      else
      begin
         $fdisplay(logfile, " SERR# reporting FAILED"); 
         $display("Test 4.1 : SERR# reporting FAILED --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //*******************************************************************************
      //* Data Parity error test - lower 32-bits
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "4.2 Data Parity Error Test - lower 32-bits parity"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00402 ; 
      address = DMA_PCIPTR; 
      ben32 = 4'b0000; 
      data32 = VOID_SPACE; 
      generate_perr(master_params_GenPerr); 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      #30; 
      // verify error reporting
      verify_perr(DEVICE_NO, rpt_ok); 
      if (rpt_ok)
      begin
         $fdisplay(logfile, " PERR# reported correctly"); 
      end
      else
      begin
         $fdisplay(logfile, " PERR# reporting FAILED"); 
         $display("Test 4.2 : PERR# reporting FAILED --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //*******************************************************************************
      //* Data Parity error test - Upper 32-bits
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "4.3 Data Parity Error Test - upper 32-bits parity"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, " "); 
      testphase = 00403 ; 
      // DMA Read Pointer - Memory Write to addr. 0xB40000: 0D8000000h 
      address = DMA_PCIPTR; 
      ben = 8'b00000000; 
      data = {32'h00000000, VOID_SPACE}; 
      generate_perr64(master_params_GenPerr64); 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // verify error reporting
      verify_perr(DEVICE_NO, rpt_ok); 
      if (rpt_ok)
      begin
         $fdisplay(logfile, " PERR# reported correctly"); 
      end
      else
      begin
         $fdisplay(logfile, " PERR# reporting FAILED"); 
         $display("Test 4.2 : PERR# reporting FAILED --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //*******************************************************************************
      //* 4.4 Bad Burst order test
      //*******************************************************************************
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "4.4 Bad Burst order test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      testphase = 00404 ; 
      // write data with bad burst order
      address = BAR0_ADDR + 'h80 + 'h01; 
      data = {64{1'b0}}; 
      memwr64_blockfill(address, data, 2); 
      #60; 
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      // 5. Master Abnormal situations
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      //*******************************************************************************
      //* Master Abort termination test                                               *
      //*******************************************************************************
//#####
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "5.1 Master Abort termination test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      testphase = 00501 ; 
      // Set DMA Pointer Pointer 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.1 Set DMA Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = VOID_SPACE; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA PCI Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA PCI Pointer write error"); 
         $display("DMA PCI Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write AHB Pointer
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.2 Set DMA AHB Pointer"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben = 8'b11110000; 
      data[63:32] = {32{1'b0}}; 
      data[31:0] = UUT_DMA_AHBADDR; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Write Pointer write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA AHB Pointer write error"); 
         $display("DMA AHB Pointer write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  DMA Transfer Counter - Memory Write to addr. 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.3 Set DMA Transfer Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_TXCNT; 
      ben = 8'b11110000; 
      data = 64'h0000000000000008; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Transfer Counter write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Transfer Counter write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.4 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      address = INT_PCIMASK; 
      ben = 8'b11110000; 
      data = 64'h0000000000000300; 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         $display("DMA Transfer Counter write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // Memory Write to DMA_CTRL
      // Enable - DMA_READ& all interrupts
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.5 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MRD_CODE}; // enable 64-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
//
      $fdisplay(logfile, " ", $stime, " ns"); 
      $fdisplay(logfile, "5.1.6 Transfer initiated "); 
      $fdisplay(logfile, " "); 
      // Wait for interrupt event on INTA# line
      WaitForFallingEdge("Waiting for interrupt", 256); 
      // Interrupt asserted or time-out
      if (intan_p_net == 1'b0)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "INTA# interrupt line asserted - transfer finished"); 
         $fdisplay(logfile, " "); 
         $display("INTAn_p Interrupt Active -DMA Transaction finished --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, "ERROR: INTA# interrupt line not asserted - transfer failure"); 
         $fdisplay(logfile, " "); 
         $display("INTA# interrupt line not asserted - transfer failure --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, $stime, " ns - DMA Transfer finished"); 
      //
      // Memory Write to addr. 0xB40030 - DMA_CTRL
      // DISABLE - DMA_READ and WRITE
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.5 Set DMA_CTRL Register - Disable DMA"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL; 
      ben32 = 4'b0000; 
      data32 = 'h00000006; 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // PCI CFG_Space read
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.6 Verify status MABORT_SIG bit in Status register"); 
      $fdisplay(logfile, " "); 
      address = 'h00000004; 
      ben32 = 4'b0000; 
      data32 = {32{1'bX}}; // Verify MABORT_SIG bit
      data32[29] = 1'b1;
      cfgrd_single(DEVICE_NO, address, data32, ben32); 
      // check result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " - status MABORT_SIG bit in Status register OK"); 
      end
      else
      begin
         $fdisplay(logfile, " - ERROR: status MABORT_SIG bit not asserted!"); 
         test_passed = 1'b0; 
      end 
      // PCI CFG_Space write
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.7 Clear status MABORT_SIG bit in Status register"); 
      $fdisplay(logfile, " "); 
      address = 'h00000004; 
      ben32 = 4'b0011; 
      data32 = {32{1'b0}}; // Clear MABORT_SIG bit
      data32[29] = 1'b1;
      cfgwr_single(DEVICE_NO, address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
//
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.8 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0010}; // PCI TX Error detected
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.1.9 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0010}; // Clear PCI TX Error
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "5.2 Target Abort test"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      testphase = 00502 ; 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.1 Set DMA PCI Pointer "); 
      $fdisplay(logfile, " "); 
      address = DMA_PCIPTR; 
      ben32 = 4'b0000; 
      data32 = UUT_DMA_RDADDR; 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.2 Set DMA Read Counter"); 
      $fdisplay(logfile, " "); 
      address = DMA_AHBPTR; 
      ben32 = 4'b0000; 
      data32 = 'h00000008; 
      memwr32_single(address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.3 Set DMA_CTRL Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b1,MRD_CODE}; // enable 64-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //
      WaitForFallingEdge("DMA M64->T64", 256); 
      $display("INTAn_p Interrupt Active - DMA Transaction finished --- NOTE"); 
      // 
       
      #30; 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.4 Set DMA_CTRL Register "); 
      $fdisplay(logfile, " "); 
      address = DMA_CTRL;  
      ben = 8'b11110000; 
      data = {{58{1'b0}},1'b1,1'b0,MRD_CODE}; // disnable 64-bit DMA
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA_CTRL register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA_CTRL register write error"); 
         $display("DMA_CTRL register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // PCI CFG Space read
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.5 Verify status TABORT_DET bit set in Status register"); 
      $fdisplay(logfile, " "); 
      address = 'h00000004; 
      ben32 = 4'b0011; 
      data32 = {32{1'bX}}; // Verify TABORT_DET bit
      data32[28] = 1'b1;
      cfgrd_single(DEVICE_NO, address, data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " - status TABORT_DET bit in Status register OK"); 
      end
      else
      begin
         $fdisplay(logfile, " - ERROR: status TABORT_DET bit not asserted!"); 
         test_passed = 1'b0; 
      end 
      // PCI CFG_Space write
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.6 Clear status TABORT_DET bit in Status register"); 
      $fdisplay(logfile, " "); 
      address = 'h00000004; 
      ben32 = 4'b0011; 
      data32 = {32{1'b0}}; // Clear TABORT_DET bit
      data32[28] = 1'b1;
      cfgwr_single(DEVICE_NO, address, data32, ben32); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Register write error"); 
         $display("Register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      // PCI CFG Space read
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.7 Verify status TABORT_DET bit clear in Status register"); 
      $fdisplay(logfile, " "); 
      address = 'h00000004; 
      ben32 = 4'b0011; 
      data32 = {31{1'bX}}; // Verify TABORT_DET bit
      data32[28] = 1'b0;
      cfgrd_single(DEVICE_NO, address, data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " - status TABORT_DET bit in Status register OK"); 
      end
      else
      begin
         $fdisplay(logfile, " - ERROR: status TABORT_DET bit not clear!"); 
         test_passed = 1'b0; 
      end 
//
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.8 Read DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'bX}},4'b0010}; // PCI TX Error detected
      memrd64_single(address, data, ben); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read OK"); 
      end
      else
      begin
         $display(" Status Register read access FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " Status Register read access FAILED"); 
         test_passed = 1'b0; 
      end 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "5.2.9 Write DMA Status Register"); 
      $fdisplay(logfile, " "); 
      address = DMA_STATUS;  
      ben = 8'b11110000; 
      data = {{60{1'b0}},4'b0010}; // Clear PCI TX Error
      memwr64_single(address, data, ben); 
      // analyze result
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "DMA Status register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "DMA Status register write error"); 
         $display("DMA Status register write error --- ERROR"); 
         test_passed = 1'b0; 
      end 
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      // 6. PCI Mailbox tests
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "6. PCI Mailbox tests"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      testphase = 0060100 ;
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "6.1 PCI Mailbox 0 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("6.1 PCI Mailbox 0 Test"); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0060101 ;
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000010000;     // enable interrupt from Mailbox 0 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write PCI Mailbox 0
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.2 Write PCI Mailbox 0"); 
      $fdisplay(logfile, " "); 
      testphase = 0060102 ;
      ahbaddr = SLAVE1_BASE + PCIMBOX0_ADDR; 
      ahbdata = 32'h12345678; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_write(1,ahbaddr,ahbdata,ahbhsize,retry_delay,retry_disable,logfile,ahbresp);      
      if (!(ahbresp == HRESP_OKAY))
      begin
         $fdisplay(logfile, "AHB Write Error"); 
         $display("AHB Read Error"); 
         test_passed = 1'b0; 
      end  
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.3 Wait for PCI interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0060103 ;
      @(posedge clk_p);   
      while (intan_p_net != 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.4 Check Interrupt Status register - Mailbox 0 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0060104 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00010000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.5 Read Mailbox 0 from PCI bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0060105 ;
      address = BAR0_ADDR + PCIMBOX0_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'h12345678; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read passed"); 
      end
      else
      begin
         $display(" PCI Mailbox read FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read FAILED"); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.6 Check INTA# deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0060106 ;
      @(posedge clk_p);   
      while (intan_p_net == 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.1.7 Check Interrupt Status register - Mailbox 0 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0060107 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //----------------------------------------------------------------------- 
      // PCI Mailbox 1 test
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "6.2 PCI Mailbox 1 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("6.2 PCI Mailbox 1 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0060101 ;
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000020000;     // enable interrupt from Mailbox 0 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write PCI Mailbox 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.2 Write PCI Mailbox 1"); 
      $fdisplay(logfile, " "); 
      testphase = 0060202 ;
      ahbaddr = SLAVE1_BASE + PCIMBOX1_ADDR; 
      ahbdata = 32'hF0F0F0F0; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_write(1,ahbaddr,ahbdata,ahbhsize,retry_delay,retry_disable,logfile,ahbresp);      
      if (!(ahbresp == HRESP_OKAY))
      begin
         $fdisplay(logfile, "AHB Write Error"); 
         $display("AHB Read Error"); 
         test_passed = 1'b0; 
      end  
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.3 Wait for PCI interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0060203 ;
      @(posedge clk_p);   
      while (intan_p_net != 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.4 Check Interrupt Status register - Mailbox 1 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0060204 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00020000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.5 Read Mailbox 1 from PCI bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0060105 ;
      address = BAR0_ADDR + PCIMBOX1_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'hF0F0F0F0; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read passed"); 
      end
      else
      begin
         $display(" PCI Mailbox read FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read FAILED"); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.6 Check INTA# deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0060206 ;
      @(posedge clk_p);   
      while (intan_p_net == 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.2.7 Check Interrupt Status register - Mailbox 1 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0060207 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//------
      //----------------------------------------------------------------------- 
      // PCI Mailbox 2 test
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "6.3 PCI Mailbox 2 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("6.3 PCI Mailbox 2 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0060301 ;
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000040000;     // enable interrupt from Mailbox 2 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write PCI Mailbox 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.2 Write PCI Mailbox 2"); 
      $fdisplay(logfile, " "); 
      testphase = 0060302 ;
      ahbaddr = SLAVE1_BASE + PCIMBOX2_ADDR; 
      ahbdata = 32'h5555AAAA; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_write(1,ahbaddr,ahbdata,ahbhsize,retry_delay,retry_disable,logfile,ahbresp);      
      if (!(ahbresp == HRESP_OKAY))
      begin
         $fdisplay(logfile, "AHB Write Error"); 
         $display("AHB Read Error"); 
         test_passed = 1'b0; 
      end  
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.3 Wait for PCI interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0060303 ;
      @(posedge clk_p);   
      while (intan_p_net != 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.4 Check Interrupt Status register - Mailbox 2 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0060304 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00040000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.5 Read Mailbox 2 from PCI bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0060305 ;
      address = BAR0_ADDR + PCIMBOX2_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'h5555AAAA; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read passed"); 
      end
      else
      begin
         $display(" PCI Mailbox read FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read FAILED"); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.6 Check INTA# deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0060306 ;
      @(posedge clk_p);   
      while (intan_p_net == 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.3.7 Check Interrupt Status register - Mailbox 1 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0060307 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//------
      //----------------------------------------------------------------------- 
      // PCI Mailbox 3 test
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "6.4 PCI Mailbox 3 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("6.4 PCI Mailbox 3 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0060401 ;
      address = BAR0_ADDR + PCIINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000080000;     // enable interrupt from Mailbox 3 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write PCI Mailbox 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.2 Write PCI Mailbox 3"); 
      $fdisplay(logfile, " "); 
      testphase = 0060402 ;
      ahbaddr = SLAVE1_BASE + PCIMBOX3_ADDR; 
      ahbdata = 32'hCCCC3333; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_write(1,ahbaddr,ahbdata,ahbhsize,retry_delay,retry_disable,logfile,ahbresp);      
      if (!(ahbresp == HRESP_OKAY))
      begin
         $fdisplay(logfile, "AHB Write Error"); 
         $display("AHB Read Error"); 
         test_passed = 1'b0; 
      end  
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.3 Wait for PCI interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0060403 ;
      @(posedge clk_p);   
      while (intan_p_net != 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.4 Check Interrupt Status register - Mailbox 3 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0060404 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00080000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.5 Read Mailbox 3 from PCI bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0060405 ;
      address = BAR0_ADDR + PCIMBOX3_ADDR;
      ben32 = 4'b0000; 
      data32 = 32'hCCCC3333; 
      memrd32_single(address,data32, ben32); 
      // analyze result
      if (master_result_ResultOK)
      begin
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read passed"); 
      end
      else
      begin
         $display(" PCI Mailbox read FAILED --- ERROR"); 
         $fdisplay(logfile, " "); 
         $fdisplay(logfile, " PCI Mailbox read FAILED"); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.6 Check INTA# deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0060406 ;
      @(posedge clk_p);   
      while (intan_p_net == 1'b0)
            @(posedge clk_p);   
      $fdisplay(logfile, $stime, " ns : INTA# Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "6.4.7 Check Interrupt Status register - Mailbox 1 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0060407 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//---
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      // 7. AHB Mailbox tests
      //-------------------------------------------------------------------------------
      //-------------------------------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      $fdisplay(logfile, "7. AHB Mailbox tests"); 
      $fdisplay(logfile, "-----------------------------------------------------------------------");
      testphase = 0070100 ;
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "7.1 AHB Mailbox 0 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("7.1 AHB Mailbox 0 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0070101 ;
      address = BAR0_ADDR + AHBINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000100000;     // enable interrupt from Mailbox 0 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write AHB Mailbox 0
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.2 Write AHB Mailbox 0"); 
      $fdisplay(logfile, " "); 
      testphase = 0070102 ;
      address = BAR0_ADDR + AHBMBOX0_ADDR; 
      ben = 8'b00000000; 
      data = 64'h1234567890ABCDEF;
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "AHB Mailbox 0 write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "AHB Mailbox 0 write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.3 Wait for AHB interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0070103 ;
      @(posedge hclk);   
      while (hint != 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.4 Check Interrupt Status register - Mailbox 0 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0070104 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00100000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.5 Read Mailbox 0 from AHB bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0070105 ;
      ahbaddr = SLAVE1_BASE + AHBMBOX0_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h90ABCDEF))
      begin
         $fdisplay(logfile, "AHB Mailbox 0 Read Error : %hh",ahbdata); 
         $display("AHB Mailbox 0 Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.6 Check AHB Interrupt deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0070106 ;
      @(posedge hclk);   
      while (hint == 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.7 Check Interrupt Status register - AHB Mailbox 0 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0070107 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//
//
//
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "7.2 AHB Mailbox 1 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("7.2 AHB Mailbox 1 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0070201 ;
      address = BAR0_ADDR + AHBINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000200000;     // enable interrupt from Mailbox 0 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write AHB Mailbox 0
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.2 Write AHB Mailbox 1"); 
      $fdisplay(logfile, " "); 
      testphase = 0070202 ;
      address = BAR0_ADDR + AHBMBOX1_ADDR; 
      ben = 8'b00000000; 
      data = 64'h1234567890ABCDEF;
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "AHB Mailbox 1 write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "AHB Mailbox 1 write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.3 Wait for AHB interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0070203 ;
      @(posedge hclk);   
      while (hint != 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.4 Check Interrupt Status register - Mailbox 1 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0070204 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00200000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.5 Read Mailbox 1 from AHB bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0070205 ;
      ahbaddr = SLAVE1_BASE + AHBMBOX1_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h90ABCDEF))
      begin
         $fdisplay(logfile, "AHB Mailbox 0 Read Error : %hh",ahbdata); 
         $display("AHB Mailbox 0 Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.6 Check AHB Interrupt deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0070206 ;
      @(posedge hclk);   
      while (hint == 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.2.7 Check Interrupt Status register - AHB Mailbox 1 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0070207 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//
//
//
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "7.3 AHB Mailbox 2 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("7.3 AHB Mailbox 2 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0070301 ;
      address = BAR0_ADDR + AHBINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000400000;     // enable interrupt from Mailbox 2 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write AHB Mailbox 0
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.2 Write AHB Mailbox 2"); 
      $fdisplay(logfile, " "); 
      testphase = 0070302 ;
      address = BAR0_ADDR + AHBMBOX2_ADDR; 
      ben = 8'b00000000; 
      data = 64'h1234567890ABCDEF;
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "AHB Mailbox 2 write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "AHB Mailbox 2 write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.3 Wait for AHB interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0070303 ;
      @(posedge hclk);   
      while (hint != 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.4 Check Interrupt Status register - Mailbox 0 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0070304 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00400000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.5 Read Mailbox 0 from AHB bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0070305 ;
      ahbaddr = SLAVE1_BASE + AHBMBOX2_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h90ABCDEF))
      begin
         $fdisplay(logfile, "AHB Mailbox 2 Read Error : %hh",ahbdata); 
         $display("AHB Mailbox 2 Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.6 Check AHB Interrupt deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0070306 ;
      @(posedge hclk);   
      while (hint == 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.3.7 Check Interrupt Status register - AHB Mailbox 2 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0070107 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
//
//
//
      $fdisplay(logfile, "......................................."); 
      $fdisplay(logfile, "7.4 AHB Mailbox 3 Test"); 
      $fdisplay(logfile, " "); 
      if (TBDEBUG) $display("......................................."); 
      if (TBDEBUG) $display("7.4 AHB Mailbox 3 Test"); 
      if (TBDEBUG) $display("......................................."); 
      //  Set Interrupt Mask register 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.1 Set Interrupt Mask register"); 
      $fdisplay(logfile, " "); 
      testphase = 0070401 ;
      address = BAR0_ADDR + AHBINTMASK_ADDR; 
      ben = 8'b11110000; 
      data = 64'h0000000000800000;     // enable interrupt from Mailbox 0 
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "Interrupt Mask register write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "Interrupt Mask register write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Write AHB Mailbox 0
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.1.2 Write AHB Mailbox 3"); 
      $fdisplay(logfile, " "); 
      testphase = 0070402 ;
      address = BAR0_ADDR + AHBMBOX3_ADDR; 
      ben = 8'b00000000; 
      data = 64'h1234567890ABCDEF;
      memwr64_single(address, data, ben); 
      if (master_result_TermType != MASTER_ABORT & master_result_TermType != T_ABORT)
      begin
         $fdisplay(logfile, "AHB Mailbox 3 write passed OK"); 
      end
      else
      begin
         $fdisplay(logfile, "AHB Mailbox 3 write error"); 
         test_passed = 1'b0; 
      end 
      //
      // Wait for interrupt
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.3 Wait for AHB interrupt"); 
      $fdisplay(logfile, " "); 
      testphase = 0070403 ;
      @(posedge hclk);   
      while (hint != 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
         
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.4 Check Interrupt Status register - Mailbox 3 status"); 
      $fdisplay(logfile, " "); 
      testphase = 0070404 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00800000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      //  
      // Read Mailbox from PCI 
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.5 Read Mailbox 0 from AHB bus"); 
      $fdisplay(logfile, " "); 
      testphase = 0070405 ;
      ahbaddr = SLAVE1_BASE + AHBMBOX3_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h90ABCDEF))
      begin
         $fdisplay(logfile, "AHB Mailbox 3 Read Error : %hh",ahbdata); 
         $display("AHB Mailbox 3 Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      // Check INTA# deasserted
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.6 Check AHB Interrupt deasserted"); 
      $fdisplay(logfile, " "); 
      testphase = 0070406 ;
      @(posedge hclk);   
      while (hint == 1'b1)
            @(posedge hclk);   
      $fdisplay(logfile, $stime, " ns : AHB Interrupt line asserted"); 
      //
      // Read Interrupt Status register
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "7.4.7 Check Interrupt Status register - AHB Mailbox 3 status clear"); 
      $fdisplay(logfile, " "); 
      testphase = 0070407 ;
      ahbaddr = SLAVE1_BASE + INTSTATUS_ADDR; 
      ahbhsize = HSIZE_4B; 
      retry_delay = 1;
      retry_disable = 1'b0; 
      ahb_master_single_read(1,ahbaddr,ahbhsize,retry_delay,retry_disable,logfile,ahbdata,ahbresp);      
      if ((ahbresp !== HRESP_OKAY)|(ahbdata != 32'h00000000))
      begin
         $fdisplay(logfile, "Interrupt Status Read Error : %hh",ahbdata); 
         $display("Interrupt Status Read Error : %hh",ahbdata); 
         test_passed = 1'b0; 
      end 
      
//---
      //--------------------------------------------------------------------------
      //
      // Final report
      //
      //--------------------------------------------------------------------------
      $fdisplay(logfile, " "); 
      $fdisplay(logfile, "------------------------------------------------------------");
      $fdisplay(logfile, "--"); 
      if (test_passed)
      begin
         $fdisplay(logfile, "--  TEST FINAL REPORT: PASSED "); 
         $display("--  TEST FINAL REPORT: PASSED  --- NOTE"); 
      end
      else
      begin
         $fdisplay(logfile, "--  TEST FINAL REPORT: FAILED "); 
         $display("--  TEST FINAL REPORT: FAILED  --- ERROR"); 
      end 
      $fdisplay(logfile, "--"); 
      $fdisplay(logfile, "------------------------------------------------------------");
      #180; 
      end_sim = 1'b1 ; 

      $fclose(logfile);
      #1000 $stop;
   end 

endmodule
