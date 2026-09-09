//----------------------------------------------------------------------
//
// Copyright (c) 1998-2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI Core 64/66
//
//  File          : pci_master32model.vhd
//
//  Dependencies  : pci64_package.vhd
//
//  Model Type:   : Simulation Model
//
//  Description   : PCI Master Component Simulation Model
//                  Master_PCI_ACC is a procedure which is used 
//                  for PCI Master entity simulation.
//                   - all CFG, I/O and Memory access commands support
//                   - single and burst data transfers
//                   - retry detection and transaction repeat 
//                     with adjustable limits
//                   - address parity error insertion (SERR# invoking)
//                   - data parity error insertion    (PERR# invoking)
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
module master64 (rstn_p, clk_p, exec, ad_p, cbe_p, par_p, par64_p, framen_p, req64n_p, irdyn_p, trdyn_p, devseln_p, ack64n_p, stopn_p, idsel_p, perrn_p, serrn_p, reqn_p, gntn_p, intan_p, serr_sig, perr_sig, done, master_params_Command, master_params_Address, master_params_BEn, master_params_BurstLength, master_params_Transfer_64, master_params_Data, master_params_IrdyWait, master_params_DataFileName, master_params_RetryLimit, master_params_RetryDelay, master_params_GenFastBack, master_params_GenPerr, master_params_GenPerr64, master_params_GenSerr, master_params_CheckResult, master_params_ResultOK, master_params_TermType, master_result_ResultOK, master_result_TermType, master_result_Data, end_sim);

   `include "pci64_params.v"


   input rstn_p; // Reset 
   input clk_p; // Clock 
   input exec;
   inout[DATA_WIDTH - 1:0] ad_p; // Address/Data Bus
   inout[CBE_WIDTH - 1:0] cbe_p; // Command/Byte Enable
   inout par_p; // parity
   inout par64_p; // 64-bit parity
   inout framen_p; // Transaction Frame
   inout req64n_p; // 64-bit Transaction Request
   inout irdyn_p; // Initiator Ready
   inout trdyn_p; // Target Ready
   inout devseln_p; // Device Select
   inout ack64n_p; // 64-bit Transaction Acknowledge
   inout stopn_p; // Stop transaction
   input idsel_p; // Chip Select
   inout perrn_p; // parity Error (s/t/s)
   inout serrn_p; // System Error (o/d)
   output reqn_p; // Bus Mastering Request 
   input gntn_p; // Bus Mastering Grant
   inout intan_p; 
   output serr_sig;
   output perr_sig;
   output done;
   input[3:0] master_params_Command;
   input[ADDR_WIDTH - 1:0] master_params_Address;
   input[CBE_WIDTH - 1:0] master_params_BEn;
   input[10:0] master_params_BurstLength;
   input master_params_Transfer_64;
   input[DATA_WIDTH - 1:0] master_params_Data;
   input[10:0] master_params_IrdyWait;
   input[1:(15)*8] master_params_DataFileName;
   input[10:0] master_params_RetryLimit;
   input[10:0] master_params_RetryDelay;
   input master_params_GenFastBack;
   input master_params_GenPerr;
   input master_params_GenPerr64;
   input master_params_GenSerr;
   input master_params_CheckResult;
   input master_params_ResultOK;
   input[2:0] master_params_TermType;
   output master_result_ResultOK;
   output[2:0] master_result_TermType;
   output[DATA_WIDTH - 1:0] master_result_Data;
   input end_sim;

   reg[DATA_WIDTH - 1:0] ad_p_reg;
   reg[CBE_WIDTH - 1:0] cbe_p_reg;
   reg par_p_reg;
   reg par64_p_reg;
   reg framen_p_reg;
   reg req64n_p_reg;
   reg irdyn_p_reg;
   reg trdyn_p_reg;
   reg devseln_p_reg;
   reg ack64n_p_reg;
   reg stopn_p_reg;
   reg perrn_p_reg;
   reg serrn_p_reg;
   reg reqn_p;
   reg intan_p_reg;
   reg serr_sig;
   reg perr_sig;
   reg done;
   reg[3:0] master_result_Command;
   reg[ADDR_WIDTH - 1:0] master_result_Address;
   reg[CBE_WIDTH - 1:0] master_result_BEn;
   integer master_result_BurstLength;
   reg master_result_Transfer_64;
   reg[DATA_WIDTH - 1:0] master_result_Data;
   integer master_result_IrdyWait;
   reg[1:(15)*8] master_result_DataFileName;
   integer master_result_RetryLimit;
   integer master_result_RetryDelay;
   reg master_result_GenFastBack;
   reg master_result_GenPerr;
   reg master_result_GenPerr64;
   reg master_result_GenSerr;
   reg master_result_CheckResult;
   reg master_result_ResultOK;
   reg[2:0] master_result_TermType;

   reg[3:0] masterpar_Command; 
   reg[31:0] masterpar_Address; 
   reg[7:0] masterpar_BEn; 
   integer masterpar_BurstLength; 
   reg masterpar_Transfer_64; 
   reg[63:0] masterpar_Data; 
   integer masterpar_IrdyWait; 
   reg[1:(15)*8] masterpar_DataFileName; 
   integer masterpar_RetryLimit; 
   integer masterpar_RetryDelay; 
   reg masterpar_GenFastBack; 
   reg masterpar_GenPerr; 
   reg masterpar_GenPerr64; 
   reg masterpar_GenSerr; 
   reg masterpar_CheckResult; 
   reg masterpar_ResultOK; 
   reg[2:0] masterpar_TermType; 

   wire (strong1, pull0) [DATA_WIDTH - 1:0] ad_p = ad_p_reg;
   wire[CBE_WIDTH - 1:0] cbe_p;
   wire framen_p;
   wire par64_p;
   wire req64n_p;
   wire irdyn_p;
   wire trdyn_p;
   wire devseln_p;
   wire ack64n_p;
   wire stopn_p;
   wire perrn_p;
   wire serrn_p;
   wire intan_p;
   wire par_p;


   // local signals
   reg framen_r; 
   reg lidsel; 
   reg stop_err; // protocol error on stop line

   reg[63:0] datafilemem [0:50];
   reg[63:0] ramvectmem [0:3*RAM_VEC_LINES-1];
   integer ramloc;
   reg[63:0] vectordata;
   //
   assign framen_p = framen_p_reg;
   assign irdyn_p = irdyn_p_reg;
   assign cbe_p = cbe_p_reg;
   assign par_p = par_p_reg;
   assign par64_p = par64_p_reg;
   assign req64n_p = req64n_p_reg;
   assign trdyn_p = trdyn_p_reg;
   assign devseln_p = devseln_p_reg;
   assign ack64n_p = ack64n_p_reg;
   assign stopn_p = stopn_p_reg;
   assign perrn_p = perrn_p_reg;
   assign serrn_p = serrn_p_reg;
   assign intan_p = intan_p_reg;

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
         begin : xhdl_1
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
   // procedure cwait
   //--------------------------------------------------------------------------
   // description:
   //    Wait specified number of clock cycles
   task cwait;
      input wtime; 
      integer wtime;

      integer wcyc; 
      begin
         wcyc = wtime;
         while (wcyc != 0)
         begin : wloop
            @(posedge clk_p); 
            wcyc = wcyc - 1; 
         end 
      end
   endtask

   // PCI parity Computation
   function [0:0] parity;
      input[31:0] D; 
      input[3:0] BEn; 
      input GenErr; 

      reg[9:0] P; 
      reg[1:(80)*8] Message; 
      reg par; 

      begin
         // PCI parity Computation, allows error insertion upon request
         // parity Tree
         P[0] = D[0] ^ D[1] ^ D[2] ^ D[3]; 
         P[1] = D[4] ^ D[5] ^ D[6] ^ D[7]; 
         P[2] = D[8] ^ D[9] ^ D[10] ^ D[11]; 
         P[3] = D[12] ^ D[13] ^ D[14] ^ D[15]; 
         P[4] = D[16] ^ D[17] ^ D[18] ^ D[19]; 
         P[5] = D[20] ^ D[21] ^ D[22] ^ D[23]; 
         P[6] = D[24] ^ D[25] ^ D[26] ^ D[27]; 
         P[7] = D[28] ^ D[29] ^ D[30] ^ D[31]; 
         P[8] = BEn[0] ^ BEn[1] ^ BEn[2] ^ BEn[3]; 
         P[9] = (P[0] ^ P[1] ^ P[2] ^ P[3] ^ P[4] ^ P[5] ^ P[6] ^ P[7] ^ P[8]); 
         if (GenErr)
         begin
            par = ~(P[9]); 
         end
         else
         begin
            par = P[9]; 
         end 
         parity = par; 
      end
   endfunction

   task Send_Command;
      output idsel; 

      reg RW; // Read, Write
      reg Enable64; 

      begin
         if (masterpar_Transfer_64 & (masterpar_Command == MRD_CODE | masterpar_Command == MWR_CODE | masterpar_Command == MWI_CODE | masterpar_Command == MRL_CODE | masterpar_Command == MRM_CODE))
         begin
            Enable64 = 1'b1; 
         end
         else
         begin
            Enable64 = 1'b0; 
         end 
         ad_p_reg[31:0] <= #CTO_dly masterpar_Address ; 
         ad_p_reg[63:32] = {32{1'b0}}; 
         cbe_p_reg[3:0] <= #CTO_dly masterpar_Command ; 
         cbe_p_reg[7:4] <= #CTO_dly 4'b0000 ; 
         framen_p_reg <= #CTO_dly 1'b0 ; 
         irdyn_p_reg <= #CTO_dly 1'b1 ; 
         if (Enable64)
         begin
            req64n_p_reg <= #CTO_dly 1'b0 ; 
         end
         else
         begin
            req64n_p_reg <= #CTO_dly 1'b1 ; 
         end 
         if (masterpar_Command[3:1] == 3'b101)
         begin
            idsel <= #CTO_dly 1'b1 ; 
         end 
         if ((masterpar_Command[0]) == 1'b1)
         begin
            RW = WRITE; 
         end
         else
         begin
            RW = READ; 
         end 
         // Transaction log.
         $fdisplay(logfile, "      ----------------------------"); 
         $fdisplay(logfile, "   ", $stime, " ns - Master Transaction start"); 
         $fdisplay(logfile, "                   Address: %hh", masterpar_Address, "  Command: %b", masterpar_Command); 
         @(posedge clk_p); 
         par_p_reg <= #CTO_dly parity(masterpar_Address, masterpar_Command, masterpar_GenSerr); 
         par64_p_reg <= #CTO_dly 1'b0 ; 
         idsel <= #CTO_dly 1'b0 ; 
         cbe_p_reg <= #CTO_dly masterpar_BEn ; 
      end
   endtask

   task Send_Data;
      input UseFileData; 
      inout masterabort; 
      inout targetabort; 
      inout targetlatency; 
      integer targetlatency;
      output idsel; 

      integer irdy_cnt; 
      integer IrdyWaitCnt; 
      integer TxDoneCnt; 
      reg RW; 
      reg[63:0] R_Data; 
      reg R_par; 
      reg Enable64; 

      begin
         IrdyWaitCnt = 0;
         Enable64 = 1'b0;

         if (masterpar_Transfer_64 & (masterpar_Command == MRD_CODE | masterpar_Command == MWR_CODE | masterpar_Command == MWI_CODE | masterpar_Command == MRL_CODE | masterpar_Command == MRM_CODE))
         begin
            Enable64 = 1'b1; 
         end
         else
         begin
            Enable64 = 1'b0; 
         end 
         TxDoneCnt = 0; 
         if ((masterpar_Command[0]) == 1'b1)
         begin
            RW = WRITE; 
         end
         else
         begin
            RW = READ; 
         end 
         // On PCI reads release AD bus and wait a cycle before asserting IRDY
         if (RW == READ)
         begin
            ad_p_reg <= #CTO_dly {64{1'bZ}}; 
            @(posedge clk_p); 
            IrdyWaitCnt = 1; 
            par_p_reg <= #CTO_dly 1'bZ ; 
            par64_p_reg <= #CTO_dly 1'bZ ; 
         end 
         while (masterpar_IrdyWait > IrdyWaitCnt)
         begin : WFI2
            @(posedge clk_p); 
            IrdyWaitCnt = IrdyWaitCnt + 1; 
         end 
         IrdyWaitCnt = 0; 
         // No burst => deassert FRAME#
         if (masterpar_BurstLength == 1)
         begin
            framen_p_reg <= #CTO_dly 1'b1 ; 
            req64n_p_reg <= #CTO_dly 1'b1 ; 
         end 
         // Assert IRDY#
         irdyn_p_reg <= #CTO_dly 1'b0 ; 
         begin : WFD
            while (masterpar_BurstLength > 0)
            begin : WFD_n
               if (RW == WRITE)
               begin
                  ad_p_reg <= #CTO_dly masterpar_Data ; // assign data
               end
               else
               begin
                  ad_p_reg <= #CTO_dly {64{1'bZ}}; // release bus
               end 
               @(posedge clk_p); // wait for Clock rising edge
               if (RW == WRITE)
               begin
                  par_p_reg <= #CTO_dly parity(masterpar_Data[31:0], masterpar_BEn[3:0], masterpar_GenPerr) ; 
                  par64_p_reg <= #CTO_dly parity(masterpar_Data[63:32], masterpar_BEn[7:4], masterpar_GenPerr64) ; 
               end 
               if (trdyn_p == 1'b0)
               begin
                  R_Data = ad_p; 
                  TxDoneCnt = TxDoneCnt + 1; 
                  if (RW == READ & masterpar_CheckResult)
                  begin
                     if (compare_vectors(R_Data[31:0], masterpar_Data[31:0]))
                     begin
                        $display("ADDR : %hh DATA : %hh - Read Data Match Expected result  (NOTE)", masterpar_Address, masterpar_Data); 
                        $fdisplay(logfile, "   ", $stime, " ns  %hh ", masterpar_Address, "  : %hh", R_Data, " - Read Data match expected result");
                     end
                     else
                     begin
                        $display("ADDR : %hh DATA : %hh - Read Data failed Expected result (WARNING)", masterpar_Address, R_Data); 
                        $fdisplay(logfile, "   ", $stime, " ns  %hh ", masterpar_Address, "  : %hh", R_Data, " - Read Data doesn't match expected result ( %hh", masterpar_Data, ")"); 
                        masterpar_ResultOK = 1'b0; 
                     end 
                  end
                  else
                  begin
                     $display("ADDR : %hh DATA : %hh - Write successful (NOTE)", masterpar_Address, masterpar_Data); 
                     $fdisplay(logfile, "   ", $stime, " ns  %hh ", masterpar_Address, "  : %hh", masterpar_Data, " - Write successful"); 
                  end 
                  masterpar_BurstLength = masterpar_BurstLength - 1; 
                  if (Enable64 & ack64n_p == 1'b0)
                  begin
                     masterpar_Address <= masterpar_Address + 8; // 64-bit access
                  end
                  else
                  begin
                     masterpar_Address <= masterpar_Address + 4; // 32-bit access
                  end 
                  // Read new data from test vector file
                  if (UseFileData && (ramloc < 3*RAM_VEC_LINES-1))
                  begin
                     read_data(vectordata, ramloc);
                     masterpar_Data = vectordata;
                     read_data(vectordata, ramloc);
                     masterpar_IrdyWait = vectordata[0];
                     read_data(vectordata, ramloc);
                  end
                  if (stopn_p == 1'b0)
                  begin
                     $display("MASTER_MODEL: Disconnect with data requested (NOTE)"); 
                     $fdisplay(logfile, "   ", $stime, " ns   %hh", masterpar_Address, "  Target Disconnect with data requested"); 
                     framen_p_reg <= #CTO_dly 1'b1 ; 
                     req64n_p_reg <= #CTO_dly 1'b1 ; 
                     masterpar_TermType = T_DISC_W_DATA; 
                     disable WFD; 
                  end 
                  IrdyWaitCnt = 0; 
                  irdyn_p_reg <= #CTO_dly 1'b1 ; 
                  while ((masterpar_IrdyWait > IrdyWaitCnt) && (masterpar_BurstLength >= 1))
                  begin : WFI4
                     @(posedge clk_p); 
                     IrdyWaitCnt = IrdyWaitCnt + 1; 
                  end 
                  irdyn_p_reg <= #CTO_dly 1'b0 ; 
                  IrdyWaitCnt = 0; 
                  if (masterpar_BurstLength == 1)
                  begin
                     framen_p_reg <= #CTO_dly 1'b1 ; 
                     req64n_p_reg <= #CTO_dly 1'b1 ; 
                  end 
               end
               else if (stopn_p == 1'b0)
               begin
                  if (devseln_p != 1'b0)
                  begin
                     $display("MASTER_MODEL: Target Abort Termination!! (WARNING)"); 
                     $fdisplay(logfile, "   ", $stime, " ns   %hh", masterpar_Address, "  Target Abort Termination"); 
                     masterpar_TermType = T_ABORT; 
                     masterpar_ResultOK = 1'b0; 
                     targetabort = 1'b1; 
                  end
                  else
                  begin
                     // abnormal termination
                     if (TxDoneCnt == 0)
                     begin
                        $display("MASTER_MODEL: Target Retry transaction termination (NOTE)"); 
                        $fdisplay(logfile, "   ", $stime, " ns  %hh ", masterpar_Address, "  Target Retry transaction termination"); 
                        masterpar_TermType = T_RETRY; 
                     end
                     else
                     begin
                        $display("MASTER_MODEL: Target Disconnect without data requested (NOTE)"); 
                        $fdisplay(logfile, "   ", $stime, " ns  %hh", masterpar_Address, "  Target Disconnect without data termination");
                        masterpar_TermType = T_DISC_WO_DATA; 
                     end 
                  end 
                  disable WFD; 
               end
               else if (devseln_p != 1'b0)
               begin
                  // waiting for target
                  targetlatency = targetlatency + 1; 
                  if (targetlatency == TARGETRESPONSELIMIT)
                  begin
                     $display("MASTER_MODEL: Master Abort - Target didn't respond within time limit (WARNING)"); 
                     $fdisplay(logfile, "   ", $stime, " ns - Master Abort - Target didn't respond within time limit"); 
                     masterpar_TermType = MASTER_ABORT; 
                     masterpar_ResultOK = 1'b0; 
                     masterabort = 1'b1; 
                     disable WFD; 
                  end 
               end
               else
               begin
                  targetlatency = targetlatency + 1; 
               end 
            end 
         end 
         if (masterpar_BurstLength == 0 & RW == READ)
         begin
            masterpar_Data = R_Data; 
         end 
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure pci_access
   //--------------------------------------------------------------------------
   // description:
   //    This procedure generates any PCI transaction
   //    Procedure used by master model and left for backward compatibility
   // parameters:
   //    params - transaction parameters
   // results:
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task pci_access;
      output idsel; 

      reg[0:0] RW; 
      reg[31:0] parData; 
      reg R_par; 
      reg UseFileData; 
      reg[31:0] InVector; 
      reg InLine; // pointer to string
      reg L_OUT; // pointer to string
      integer RetryCnt; 
      reg Retry; 
      integer TargetLatency; 
      reg TargetAbort; 
      reg MasterAbort; 
      integer IrdyWaitCnt; 
      integer TxDoneCnt; 
      reg fopen_status; 

      begin
         RetryCnt = masterpar_RetryLimit;
         Retry = 1'b0;
         TargetLatency = 0;
         TargetAbort = 1'b0;
         MasterAbort = 1'b0;
         IrdyWaitCnt = 0;

         masterpar_TermType = MASTER_END; 
         TxDoneCnt = 0; 
         masterpar_ResultOK = 1'b1; 
         if (masterpar_BurstLength == 0)
         begin
            // Bad parameter
            $display("Bad parameter - Burst lenght = 0 (WARNING)"); 
            disable pci_access; // pci_access = ; 
         end 
         if (masterpar_DataFileName[1:8] != "#")
         begin
            UseFileData = 1'b1; // enable data fetching from file
         end
         else
         begin
            UseFileData = 1'b0; // disable data fetching from file
         end 
         // Read data from test vector file
         if (UseFileData && (ramloc < 3*RAM_VEC_LINES-1))
         begin
            read_data(vectordata, ramloc);
            masterpar_Data = vectordata;
            read_data(vectordata, ramloc);
            masterpar_IrdyWait = vectordata[0];
            read_data(vectordata, ramloc);
         end
         while ((((RetryCnt > 0) && (masterpar_BurstLength > 0)) && ~(TargetAbort)) && ~(MasterAbort))
         begin : RETRY_REP
            TargetLatency = 0; 
            @(posedge clk_p); 

            // Send command to the PCI bus
            Send_Command(idsel); 

            // Send/Receive data
            Send_Data(UseFileData, MasterAbort, TargetAbort, TargetLatency, idsel); 

            // Terminate transaction
            if (masterpar_BurstLength >= 1 && (framen_p != 1'b1))
            begin
               // transaction terminated abnormaly
               framen_p_reg <= #CTO_dly 1'b1 ; // deassert FRAME# first
               req64n_p_reg <= #CTO_dly 1'b1 ; // deassert REQ64# first
               @(posedge clk_p); 
            end 
            irdyn_p_reg <= #CTO_dly 1'b1 ; // deassert IRDY#
            ad_p_reg <= #CTO_dly {1{1'bZ}} ; // release AD bus
            cbe_p_reg <= #CTO_dly {1{1'bZ}} ; // release C/BE#
            @(posedge clk_p); 
            par_p_reg <= #CTO_dly 1'bZ ; // release par
            par64_p_reg <= #CTO_dly 1'bZ ; // release par
            R_par <= par_p_reg; 
            framen_p_reg <= #CTO_dly 1'bZ ; // release FRAME#
            req64n_p_reg <= #CTO_dly 1'bZ ; // release REQ64# 
            irdyn_p_reg <= #CTO_dly 1'bZ ; // release IRDY#
            //  End of PCI Transaction
            if (masterpar_TermType == T_RETRY)
            begin
               RetryCnt = RetryCnt - 1; 
            end
            else
            begin
               RetryCnt = masterpar_RetryLimit; 
            end 
            if (RetryCnt == 0)
            begin
               $display("MASTER_MODEL: Retry Limit Exceeded - Transaction canceled (ERROR)"); 
            end 
            if ((masterpar_TermType == T_RETRY & RetryCnt > 0) | ((masterpar_TermType == T_DISC_W_DATA | masterpar_TermType == T_DISC_WO_DATA) & masterpar_BurstLength > 0))
            begin
               cwait(masterpar_RetryDelay); 
            end 
         end 
         $fdisplay(logfile, "   ", $stime, " ns - End of Master transaction"); 
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure master32_fba_ww
   //--------------------------------------------------------------------------
   // description:
   //    This procedure generates fast back-to-back write followed by read
   //    Procedure used by master model and left public for backward compatibility
   // parameters:
   //    params - transaction parameters
   // results:
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task master32_fba_ww;
      output idsel; 

      reg RW; 
      reg[31:0] parData; 
      reg R_par; 
      reg UseFileData; 
      reg[31:0] InVector; 
      integer RetryCnt; 
      reg Retry; 
      integer TargetLatency; 
      reg TargetAbort; 
      reg MasterAbort; 
      integer IrdyWaitCnt; 
      integer BLength; 
      reg fopen_status; 
      parameter CTO_dly = 11;

      begin
         RetryCnt = masterpar_RetryLimit;
         Retry = 1'b0;
         TargetLatency = 0;
         TargetAbort = 1'b0;
         MasterAbort = 1'b0;
         IrdyWaitCnt = 0;
         BLength = masterpar_BurstLength;

         if (masterpar_BurstLength == 0)
         begin
            // Bad parameter
            $display("Bad parameter - Burst lenght = 0 (WARNING)"); 
            disable master32_fba_ww; 
            // JS return master32_fba_ww = ; 
         end 
         if (masterpar_DataFileName[1] != "#")
         begin
            $display("Opening Data File :  %s  (ERROR)", masterpar_DataFileName); 
            // JS FILE_OPEN (fopen_status,DataFile, masterpar_DataFileName,READ_MODE);
            //case (fopen_status)
            //   open_ok :
            //            begin
            //               $display(" File open OK (NOTE)"); 
            //               UseFileData = 1'b1; // enable data fetching from file
            //            end
            //   default :
            //            begin
            //               $display(" %s - File open failed (FAILURE)", masterpar_DataFileName); 
            //               UseFileData = 1'b0; // disable data fetching from file
            //            end
            //endcase 
            $readmemh (masterpar_DataFileName, datafilemem);
            if (datafilemem[0] != {63{1'bX}})
            begin
               $display(" File open OK (NOTE)"); 
               UseFileData = 1'b1; // enable data fetching from file
            end
            else
            begin
               $display(" %s - File open failed (FAILURE)", masterpar_DataFileName); 
               UseFileData = 1'b0; // disable data fetching from file
            end
         end
         else
         begin
            UseFileData = 1'b0; // disable data fetching from file
         end 
         // Read data from test vector file
         if (UseFileData && (ramloc < 3*RAM_VEC_LINES-1))
         begin
            read_data(vectordata, ramloc);
            masterpar_Data = vectordata;
            read_data(vectordata, ramloc);
            masterpar_IrdyWait = vectordata[0];
            read_data(vectordata, ramloc);
         end
         while ((RetryCnt > 0) && (masterpar_BurstLength > 0) && ~(TargetAbort) && ~(MasterAbort))
         begin : RETRY_REP
            TargetLatency = 0; 
            masterpar_Command = 4'b0111; 
            @(posedge clk_p); 

            // Send command to the PCI bus
            Send_Command(idsel); 

            // Send/Receive data
            Send_Data(UseFileData, MasterAbort, TargetAbort, TargetLatency, idsel); 
            if (masterpar_BurstLength >= 1 & (framen_p != 1'b1))
            begin
               // transaction terminated abnormaly
               framen_p_reg <= #CTO_dly 1'b1 ; // deassert FRAME# first
               @(posedge clk_p); 
            end 
            irdyn_p_reg <= #CTO_dly 1'b1 ; // deassert IRDY#
            if (TargetAbort | MasterAbort)
            begin
               ad_p_reg <= #CTO_dly {32{1'b1}}; // release AD bus
               cbe_p_reg <= #CTO_dly {8{1'b1}}; // release C/BE#
               @(posedge clk_p); 
               par_p_reg <= #CTO_dly 1'b0 ; // release par
               R_par = par_p_reg; 
               framen_p_reg <= #CTO_dly 1'b1 ; // release FRAME#
               irdyn_p_reg <= #CTO_dly 1'b1 ; // release IRDY#
            end
            //  End of PCI Transaction 
            if (masterpar_TermType == T_RETRY)
            begin
               RetryCnt = RetryCnt - 1; 
            end
            else
            begin
               RetryCnt = masterpar_RetryLimit; 
            end 
            if (RetryCnt == 0)
            begin
               $display("MASTER_MODEL: Retry Limit Exceeded - Transaction canceled (ERROR)"); 
            end 
         end 
         // FAST-BACK-to_BACK Write
         if (~(TargetAbort | MasterAbort))
         begin
            masterpar_BurstLength = BLength; 
            masterpar_Command = 4'b0111; 

            // Send command to the PCI bus
            Send_Command(idsel); 

            // Send/Receive data
            Send_Data(UseFileData, MasterAbort, TargetAbort, TargetLatency, idsel); 

            // Terminate transaction
            if (masterpar_BurstLength >= 1 & (framen_p != 1'b1))
            begin
               // transaction terminated abnormaly
               framen_p_reg <= #CTO_dly 1'b1 ; // deassert FRAME# first
               @(posedge clk_p); 
            end 
            irdyn_p_reg <= #CTO_dly 1'b1 ; // deassert IRDY#
            ad_p_reg <= #CTO_dly {32{1'b1}}; // release AD bus
            cbe_p_reg <= #CTO_dly {8{1'b1}}; // release C/BE#
            @(posedge clk_p); 
            par_p_reg <= #CTO_dly 1'b0 ; // release par
            R_par = par_p_reg; 
            framen_p_reg <= #CTO_dly 1'b1 ; // release FRAME#
            irdyn_p_reg <= #CTO_dly 1'b1 ; // release IRDY#
         end
         //  End of PCI Transaction 
         $fdisplay(logfile, "   ", $stime, " ns - End of Master transaction"); 
      end
   endtask

   //--------------------------------------------------------------------------
   // procedure master32_fba_wr
   //--------------------------------------------------------------------------
   // description:
   //    This procedure generates fast back-to-back write followed by read
   //    Procedure used by master model and left public for backward compatibility
   // parameters:
   //    params - transaction parameters
   // results:
   //    params - returns udated transaction parameters
   //--------------------------------------------------------------------------
   task master32_fba_wr;
      output idsel; 

      reg[0:0] RW; 
      reg[31:0] parData; 
      reg R_par; 
      reg UseFileData; 
      reg[31:0] InVector; 
      integer RetryCnt; 
      reg Retry; 
      integer TargetLatency; 
      reg TargetAbort; 
      reg MasterAbort; 
      integer IrdyWaitCnt; 
      integer BLength; 
      reg fopen_status; 

      parameter CTO_dly = 11;

      begin
         RetryCnt = masterpar_RetryLimit;
         Retry = 1'b0;
         TargetLatency = 0;
         TargetAbort = 1'b0;
         MasterAbort = 1'b0;
         IrdyWaitCnt = 0;
         BLength = masterpar_BurstLength;

         if (masterpar_BurstLength == 0)
         begin
            // Bad parameter
            $display("Bad parameter - Burst lenght = 0 (WARNING)"); 
            disable master32_fba_wr; 
            // JS return master32_fba_wr = ; 
         end 
         if (masterpar_DataFileName[1] != "#")
         begin
            $display("Opening Data File :  %s  (ERROR)", masterpar_DataFileName); 
            //FILE_OPEN (fopen_status,DataFile, masterpar_DataFileName,READ_MODE);
            //case (fopen_status)
            //   open_ok :
            //            begin
            //               $display(" File open OK (NOTE)"); 
            //               UseFileData = 1'b1; // enable data fetching from file
            //            end
            //   default :
            //            begin
            //               $display(" %s - File open failed (FAILURE)", masterpar_DataFileName); 
            //               UseFileData = 1'b0; // disable data fetching from file
            //            end
            //endcase 
            $readmemh (masterpar_DataFileName, datafilemem);
            if (datafilemem[0] != {63{1'bX}})
            begin
               $display(" File open OK (NOTE)"); 
               UseFileData = 1'b1; // enable data fetching from file
            end
            else
            begin
               $display(" %s - File open failed (FAILURE)", masterpar_DataFileName); 
               UseFileData = 1'b0; // disable data fetching from file
            end
         end
         else
         begin
            UseFileData = 1'b0; // disable data fetching from file
         end 
         // Read data from test vector file
         if (UseFileData && (ramloc < 3*RAM_VEC_LINES-1))
         begin
            read_data(vectordata, ramloc);
            masterpar_Data = vectordata;
            read_data(vectordata, ramloc);
            masterpar_IrdyWait = vectordata[0];
            read_data(vectordata, ramloc);
         end
         while ((RetryCnt > 0) && (masterpar_BurstLength > 0) && ~(TargetAbort) && ~(MasterAbort))
         begin : RETRY_REP
            TargetLatency = 0; 
            masterpar_Command = 4'b0111; 
            @(posedge clk_p); 

            // Send command to the PCI bus
            Send_Command(idsel); 

            // Send/Receive data
            Send_Data(UseFileData, MasterAbort, TargetAbort, TargetLatency, idsel); 

            if (masterpar_BurstLength >= 1 & (framen_p != 1'b1))
            begin
               // transaction terminated abnormaly
               framen_p_reg <= #CTO_dly 1'b1 ; // deassert FRAME# first
               @(posedge clk_p); 
            end 
            irdyn_p_reg <= #CTO_dly 1'b1 ; // deassert IRDY#
            if (TargetAbort | MasterAbort)
            begin
               ad_p_reg <= #CTO_dly {32{1'b1}}; // release AD bus
               cbe_p_reg <= #CTO_dly {8{1'b1}}; // release C/BE#
               @(posedge clk_p); 
               par_p_reg <= #CTO_dly 1'b0 ; // release par
               R_par = par_p_reg; 
               framen_p_reg <= #CTO_dly 1'b1 ; // release FRAME#
               irdyn_p_reg <= #CTO_dly 1'b1 ; // release IRDY#
            end
            //  End of PCI Transaction 
            if (masterpar_TermType == T_RETRY)
            begin
               RetryCnt = RetryCnt - 1; 
            end
            else
            begin
               RetryCnt = masterpar_RetryLimit; 
            end 
            if (RetryCnt == 0)
            begin
               $display("MASTER_MODEL: Retry Limit Exceeded - Transaction canceled (ERROR)"); 
            end 
         end 
         // FAST-BACK-to_BACK Read
         if (~(TargetAbort | MasterAbort))
         begin
            masterpar_BurstLength = BLength; 
            masterpar_Command = 4'b0110; 

            // Send command to the PCI bus
            Send_Command(idsel); 

            // Send/Receive data
            Send_Data(UseFileData, MasterAbort, TargetAbort, TargetLatency, idsel); 

            // Terminate transaction
            if (masterpar_BurstLength >= 1 & (framen_p != 1'b1))
            begin
               // transaction terminated abnormaly
               framen_p_reg <= #CTO_dly 1'b1 ; // deassert FRAME# first
               @(posedge clk_p); 
            end 
            irdyn_p_reg <= #CTO_dly 1'b1 ; // deassert IRDY#
            ad_p_reg <= #CTO_dly {32{1'b1}}; // release AD bus
            cbe_p_reg <= #CTO_dly {8{1'b1}}; // release C/BE#
            @(posedge clk_p); 
            par_p_reg <= #CTO_dly 1'b0 ; // release par
            R_par = par_p_reg; 
            framen_p_reg <= #CTO_dly 1'b1 ; // release FRAME#
            irdyn_p_reg <= #CTO_dly 1'b1 ; // release IRDY#
         end

         //  End of PCI Transaction 
         $fdisplay(logfile, "   ", $stime, " ns - End of Master transaction"); 
      end
   endtask

   task read_data;
      output [63:0] vecdata;
      inout fieldnumber;
      integer fieldnumber;
   begin
      vecdata = ramvectmem[fieldnumber];
      fieldnumber = fieldnumber + 1;
   end
   endtask

   initial
   begin
      $readmemh ("ram_burst.vec", ramvectmem);
      logfile = $fopen("pci_m64.sim.log");
      ramloc = 0;
      done = 1'b0;
   end

   always 
   begin : pPCIACCESS

      ad_p_reg = {32{1'bZ}}; 
      cbe_p_reg = {8{1'bZ}}; 
      par_p_reg = 1'bZ ; 
      par64_p_reg = 1'bZ ; 
      framen_p_reg = 1'bZ ; 
      req64n_p_reg = 1'bZ ; 
      irdyn_p_reg = 1'bZ ; 
      trdyn_p_reg = 1'bZ ; 
      devseln_p_reg = 1'bZ ; 
      ack64n_p_reg = 1'bZ ; 
      stopn_p_reg = 1'bZ ; 
      perrn_p_reg = 1'bZ ; 
      serrn_p_reg = 1'bZ ; 
      reqn_p = 1'b1 ; 
      intan_p_reg = 1'bZ ; 

      @(exec); 
      if (exec == 1'b1)
      begin
         masterpar_Command = master_params_Command; 
         masterpar_Address = master_params_Address; 
         masterpar_BEn = master_params_BEn; 
         masterpar_BurstLength = master_params_BurstLength; 
         masterpar_Transfer_64 = master_params_Transfer_64; 
         masterpar_Data = master_params_Data; 
         masterpar_IrdyWait = master_params_IrdyWait; 
         masterpar_DataFileName = master_params_DataFileName; 
         masterpar_RetryLimit = master_params_RetryLimit; 
         masterpar_RetryDelay = master_params_RetryDelay; 
         masterpar_GenFastBack = master_params_GenFastBack; 
         masterpar_GenPerr = master_params_GenPerr; 
         masterpar_GenPerr64 = master_params_GenPerr64; 
         masterpar_GenSerr = master_params_GenSerr; 
         masterpar_CheckResult = master_params_CheckResult; 
         masterpar_ResultOK = master_params_ResultOK; 
         masterpar_TermType = master_params_TermType; 


         if (masterpar_GenFastBack)
         begin
            if (masterpar_Command == MWR_CODE)
            begin
               master32_fba_ww(lidsel); 
            end
            else
            begin
               master32_fba_wr(lidsel); 
            end 
         end
         else
         begin
            pci_access(lidsel); 
         end 
         done = 1'b1 ; 
         master_result_Command = masterpar_Command ; 
         master_result_Address = masterpar_Address ; 
         master_result_BEn = masterpar_BEn ; 
         master_result_BurstLength = masterpar_BurstLength ; 
         master_result_Transfer_64 = masterpar_Transfer_64 ; 
         master_result_Data = masterpar_Data ; 
         master_result_IrdyWait = masterpar_IrdyWait ; 
         master_result_DataFileName = masterpar_DataFileName ; 
         master_result_RetryLimit = masterpar_RetryLimit ; 
         master_result_RetryDelay = masterpar_RetryDelay ; 
         master_result_GenFastBack = masterpar_GenFastBack ; 
         master_result_GenPerr = masterpar_GenPerr ; 
         master_result_GenPerr64 = masterpar_GenPerr64 ; 
         master_result_GenSerr = masterpar_GenSerr ; 
         master_result_CheckResult = masterpar_CheckResult ; 
         master_result_ResultOK = masterpar_ResultOK ; 
         master_result_TermType = masterpar_TermType ; 
      end
      else
      begin
         ad_p_reg = {32{1'bZ}};
         cbe_p_reg = {8{1'bZ}};
         par_p_reg = 1'bZ ; 
         framen_p_reg = 1'bZ ; 
         irdyn_p_reg = 1'bZ ; 
         trdyn_p_reg = 1'bZ ; 
         devseln_p_reg = 1'bZ ; 
         stopn_p_reg = 1'bZ ; 
         perrn_p_reg = 1'bZ ; 
         serrn_p_reg = 1'bZ ; 
         reqn_p = 1'bZ ; 
         intan_p_reg = 1'bZ ; 
         done = 1'b0 ; 
      end 
   end 

   always @(clk_p or rstn_p)
   begin : pSIGSERR
      if (rstn_p == 1'b0)
      begin
         serr_sig = 1'b0 ; 
      end
      else if (clk_p == 1'b1)
      begin
         if (framen_p == 1'b0 & framen_r != 1'b0)
         begin
            serr_sig = 1'b0 ; 
         end
         else if (serrn_p == 1'b0)
         begin
            serr_sig = 1'b1 ; 
         end 
      end 
   end 

   always @(clk_p or rstn_p)
   begin : pSIGPERR
      if (rstn_p == 1'b0)
      begin
         perr_sig = 1'b0 ; 
      end
      else if (clk_p == 1'b1)
      begin
         if (framen_p == 1'b0 & framen_r != 1'b0)
         begin
            perr_sig = 1'b0 ; 
         end
         else if (perrn_p == 1'b0)
         begin
            perr_sig = 1'b1 ; 
         end 
      end 
   end 

   //stop_err
   always @(clk_p or rstn_p)
   begin : pSTOPERR
      reg lineout; 
      if (rstn_p == 1'b0)
      begin
         stop_err = 1'b0 ; 
      end
      else if (clk_p == 1'b1)
      begin
         if (framen_p == 1'b0 & framen_r != 1'b0)
         begin
            stop_err = 1'b0 ; 
         end
         else if (framen_p != 1'b0 & irdyn_p != 1'b0 & stopn_p == 1'b0)
         begin
            stop_err = 1'b1 ; 
            $fdisplay(logfile, "  ", $stime, " ns ERROR: PCI Protocol violation - STOP# asserted"); 
         end 
      end 
   end 

   //
   always @(clk_p or rstn_p)
   begin : pFRAMENR
      if (rstn_p == 1'b0)
      begin
         framen_r = 1'b1 ; 
      end
      else if (clk_p == 1'b1)
      begin
         framen_r = framen_p ; 
      end 
   end 

   always @(posedge end_sim)
   begin
      $fclose(logfile);
   end

endmodule
