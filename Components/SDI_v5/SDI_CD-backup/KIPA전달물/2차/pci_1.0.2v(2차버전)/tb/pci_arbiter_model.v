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
//  File          : pci_arbiter_model.vhd 
//
//  Dependencies  : 
//
//  Model Type:   : simulation model
//
//  Description   : PCI central arbitter 
//                    - assigns IDSEL for target agents
//                    - performs bus grant arbitration
//                    - adjustable master grant time (latency timer)
//                    - adjustable no. of targets
//                    - adjustable no. of masters
//
//  Designer      : AS
//
//  QA Engineer   : NS 
//
//  Creation Date : 1-September-2000
//
//  Last Update   : 12-February-2002
//
//  Version       : 2.0
//----------------------------------------------------------------------
//           
`timescale 1 ns / 1 ps
module pci_arbiter_model (rstn, clk, ad, cbe, framen, reqn, gntn, idsel);

   parameter MASTER_NO  = 4;
   parameter TARGET_NO  = 4;
   parameter LATENCY_LIMIT  = 8;
   input rstn; 
   input clk; 
   input[31:0] ad; 
   input[3:0] cbe; 
   input framen; 
   input[MASTER_NO - 1:0] reqn; 
   output[MASTER_NO - 1:0] gntn; 
   reg[MASTER_NO - 1:0] gntn;
   output[TARGET_NO - 1:0] idsel; 
   reg[TARGET_NO - 1:0] idsel;

   task inc;
      inout num; 
      integer num;

      begin
         num = num + 1; 
      end
   endtask

   task incm;
      inout num; 
      integer num;
      input m; 
      integer m;

      begin
         num = (num + 1) % m; 
      end
   endtask

   always @(framen or ad or cbe)
   begin : passign_idsel
      integer sel; 
      sel = 0;
      if (framen == 1'b0 & cbe[3:1] == 3'b101 & ad[1:0] == 2'b00)
      begin
         sel = ad[14:12]; 
         //idsel <= {TARGET_NO - 1-(0)+1{1'b0}} ; 
         idsel <= 2'b0;
         if (sel < TARGET_NO)
         begin
            idsel[sel] <= 1'b1 ; 
         end 
      end
      else
      begin
         //idsel <= {TARGET_NO - 1-(0)+1{1'b0}} ; 
         idsel <= 2'b0;
      end 
   end 

   always @(posedge clk or negedge rstn)
   begin : request_queue
      reg[1:0] rdptr; 
      reg[1:0] wrptr; 
      reg[2:0] assigned; 
      reg[3:0] lat_cnt; 
      reg[2:0] req_queue[0:MASTER_NO - 1]; 
      reg gnt_requested[0:MASTER_NO - 1]; 
      if (rstn == 1'b0)
      begin
         begin : req_loop1
            integer k;
            for(k = 0; k <= MASTER_NO - 1; k = k + 1)
            begin
               gnt_requested[k] = 1'b0; 
            end
         end 
         gntn <= {MASTER_NO - 1-(0)+1{1'b1}} ; 
         rdptr = 0; 
         wrptr = 0; 
         assigned = MASTER_NO; 
         lat_cnt = 0; 
      end
      else
      begin
         begin : req_loop2
            integer k;
            for(k = 0; k <= MASTER_NO - 1; k = k + 1)
            begin
               if ((reqn[k]) == 1'b0 & ~gnt_requested[k])
               begin
                  gnt_requested[k] = 1'b1; 
                  req_queue[wrptr] = k; 
                  incm(wrptr, MASTER_NO); 
               end 
            end
         end 
         if (assigned != MASTER_NO)
         begin
            if ((lat_cnt >= LATENCY_LIMIT & LATENCY_LIMIT != 0) | (reqn[assigned]) != 1'b0)
            begin
               lat_cnt = 0; 
               gntn[assigned] <= 1'b1 ; 
               gnt_requested[assigned] = 1'b0; 
               assigned = MASTER_NO; 
               incm(rdptr, MASTER_NO); 
            end
            else if (LATENCY_LIMIT != 0)
            begin
               lat_cnt = lat_cnt + 1; 
            end 
         end 
         if (assigned == MASTER_NO)
         begin
            if (rdptr != wrptr)
            begin
               assigned = req_queue[rdptr]; 
               gntn[assigned] <= 1'b0 ; 
            end 
         end 
      end 
   end 
endmodule
