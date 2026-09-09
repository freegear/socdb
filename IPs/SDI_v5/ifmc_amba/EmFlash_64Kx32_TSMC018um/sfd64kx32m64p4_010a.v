

//*******************************************************************************
//*TSMC Library/IP Product
//*Filename: SFD64KX32M64P4_010a.v
//*Technology: CE018G
//*Product Type: EmbFlash Compiler
//*Product Name: SFD64KX32M64P4
//*Version: 010a
//*******************************************************************************
//*
//*STATEMENT OF USE
//*
//*This information contains confidential and proprietary information of TSMC.
//*No part of this information may be reproduced, transmitted, transcribed,
//*stored in a retrieval system, or translated into any human or computer
//*language, in any form or by any means, electronic, mechanical, magnetic,
//*optical, chemical, manual, or otherwise, without the prior written permission
//*of TSMC. This information was prepared for informational purpose and is for
//*use by TSMC's customers only. TSMC reserves the right to make changes in the
//*information at any time and without notice.
//*
//*******************************************************************************


//----------------------------------------------------------------------------
// Copyright (c) 2005 Taiwan Semiconductor Manufacturing Ltd.
// All Rights Reserved.
//
//----------------------------------------------------------------------------
// Model Name    : SFD64KX32M64P4
// Creation Date : 2006/02/13, 10:28:46
// Version       : 1.0
//
//----------------------------------------------------------------------------
// Ports
//        XADR : X Address input buffer
//        YADR : X Address input buffer
//        DIN  : data input bus
//        DOUT : data output bus
//        XE   : X address enable
//        YE   : Y address enable
//        SE   : sense amplifier enable        
//        ERASE: erase cycle
//        MAS1 : mass erase cycle
//        PROG : program cycle
//        NVSTR: non-volatile store cycle
//        IFREN: information block enable
//
// Test Ports
//        TMR, VPP, TM
//
//----------------------------------------------------------------------------
// Note:
//       This verilog model is designed for TSMC embbed flash. All user mode
//       and test mode, function and timing specs are inlcuded. When abnormal
//       function and timing violation occur, the whole memory will be set
//       unknown. If you want to turn off the unknown setting, use
//       +define+no_whole_flash_unknown in the simulation command.
//
//       For the function & timing accuracy, the constant timing is used. It
//       will cause some SDF back-annotation errors and you can bypass them.
//
//       In test mode, timing Trt,Tpt,Tdce,Tmprog,Trd,Twe,Tts,Ttol are not
//       implemented. Please check the datasheet to ensure the right conditions
//       for test mode.
//
//----------------------------------------------------------------------------
// Revision history:
// 
//----------------------------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module SFD64KX32M64P4 (XADR,YADR,DIN,DOUT,XE,YE,SE,ERASE,MAS1,
PROG,NVSTR,IFREN,TMR,VPP,TM);

//begin parameter
parameter numAddrX = 10;
parameter numAddrY = 6;
parameter numTM = 3;
parameter numOut = 32;
//end parameter

// IO ports
input XE, YE, SE, ERASE, MAS1, PROG, NVSTR, IFREN;
input [numAddrX-1:0] XADR;
input [numAddrY-1:0] YADR;
input [numOut-1:0] DIN;
output [numOut-1:0] DOUT;

// test mode IO ports
input TMR;
inout VPP;
inout [numTM-1:0] TM;

// IO buffer
wire [numAddrX-1:0] XADR_buf;
wire [numAddrY-1:0] YADR_buf;
wire [numOut-1:0] DIN_buf;
wire [numOut-1:0] DOUT_buf;
wire XE_buf;
wire YE_buf;
wire SE_buf;
wire ERASE_buf;
wire MAS1_buf;
wire PROG_buf;
wire NVSTR_buf;
wire IFREN_buf;

// test mode IO buffer
wire TMR_buf;
wire VPP_buf;
wire [numTM-1:0] TM_buf;
  buf (XADR_buf[0], XADR[0]);
  buf (XADR_buf[1], XADR[1]);
  buf (XADR_buf[2], XADR[2]);
  buf (XADR_buf[3], XADR[3]);
  buf (XADR_buf[4], XADR[4]);
  buf (XADR_buf[5], XADR[5]);
  buf (XADR_buf[6], XADR[6]);
  buf (XADR_buf[7], XADR[7]);
  buf (XADR_buf[8], XADR[8]);
  buf (XADR_buf[9], XADR[9]);
  buf (YADR_buf[0], YADR[0]);
  buf (YADR_buf[1], YADR[1]);
  buf (YADR_buf[2], YADR[2]);
  buf (YADR_buf[3], YADR[3]);
  buf (YADR_buf[4], YADR[4]);
  buf (YADR_buf[5], YADR[5]);
  buf (TM_buf[0], TM[0] );
  buf (TM_buf[1], TM[1] );
  buf (TM_buf[2], TM[2] );
  buf (DIN_buf[0], DIN[0]);
  buf (DIN_buf[1], DIN[1]);
  buf (DIN_buf[2], DIN[2]);
  buf (DIN_buf[3], DIN[3]);
  buf (DIN_buf[4], DIN[4]);
  buf (DIN_buf[5], DIN[5]);
  buf (DIN_buf[6], DIN[6]);
  buf (DIN_buf[7], DIN[7]);
  buf (DIN_buf[8], DIN[8]);
  buf (DIN_buf[9], DIN[9]);
  buf (DIN_buf[10], DIN[10]);
  buf (DIN_buf[11], DIN[11]);
  buf (DIN_buf[12], DIN[12]);
  buf (DIN_buf[13], DIN[13]);
  buf (DIN_buf[14], DIN[14]);
  buf (DIN_buf[15], DIN[15]);
  buf (DIN_buf[16], DIN[16]);
  buf (DIN_buf[17], DIN[17]);
  buf (DIN_buf[18], DIN[18]);
  buf (DIN_buf[19], DIN[19]);
  buf (DIN_buf[20], DIN[20]);
  buf (DIN_buf[21], DIN[21]);
  buf (DIN_buf[22], DIN[22]);
  buf (DIN_buf[23], DIN[23]);
  buf (DIN_buf[24], DIN[24]);
  buf (DIN_buf[25], DIN[25]);
  buf (DIN_buf[26], DIN[26]);
  buf (DIN_buf[27], DIN[27]);
  buf (DIN_buf[28], DIN[28]);
  buf (DIN_buf[29], DIN[29]);
  buf (DIN_buf[30], DIN[30]);
  buf (DIN_buf[31], DIN[31]);
  nmos (DOUT[0] ,DOUT_buf[0] ,1'b1 );
  nmos (DOUT[1] ,DOUT_buf[1] ,1'b1 );
  nmos (DOUT[2] ,DOUT_buf[2] ,1'b1 );
  nmos (DOUT[3] ,DOUT_buf[3] ,1'b1 );
  nmos (DOUT[4] ,DOUT_buf[4] ,1'b1 );
  nmos (DOUT[5] ,DOUT_buf[5] ,1'b1 );
  nmos (DOUT[6] ,DOUT_buf[6] ,1'b1 );
  nmos (DOUT[7] ,DOUT_buf[7] ,1'b1 );
  nmos (DOUT[8] ,DOUT_buf[8] ,1'b1 );
  nmos (DOUT[9] ,DOUT_buf[9] ,1'b1 );
  nmos (DOUT[10] ,DOUT_buf[10] ,1'b1 );
  nmos (DOUT[11] ,DOUT_buf[11] ,1'b1 );
  nmos (DOUT[12] ,DOUT_buf[12] ,1'b1 );
  nmos (DOUT[13] ,DOUT_buf[13] ,1'b1 );
  nmos (DOUT[14] ,DOUT_buf[14] ,1'b1 );
  nmos (DOUT[15] ,DOUT_buf[15] ,1'b1 );
  nmos (DOUT[16] ,DOUT_buf[16] ,1'b1 );
  nmos (DOUT[17] ,DOUT_buf[17] ,1'b1 );
  nmos (DOUT[18] ,DOUT_buf[18] ,1'b1 );
  nmos (DOUT[19] ,DOUT_buf[19] ,1'b1 );
  nmos (DOUT[20] ,DOUT_buf[20] ,1'b1 );
  nmos (DOUT[21] ,DOUT_buf[21] ,1'b1 );
  nmos (DOUT[22] ,DOUT_buf[22] ,1'b1 );
  nmos (DOUT[23] ,DOUT_buf[23] ,1'b1 );
  nmos (DOUT[24] ,DOUT_buf[24] ,1'b1 );
  nmos (DOUT[25] ,DOUT_buf[25] ,1'b1 );
  nmos (DOUT[26] ,DOUT_buf[26] ,1'b1 );
  nmos (DOUT[27] ,DOUT_buf[27] ,1'b1 );
  nmos (DOUT[28] ,DOUT_buf[28] ,1'b1 );
  nmos (DOUT[29] ,DOUT_buf[29] ,1'b1 );
  nmos (DOUT[30] ,DOUT_buf[30] ,1'b1 );
  nmos (DOUT[31] ,DOUT_buf[31] ,1'b1 );
  buf (XE_buf , XE );
  buf (YE_buf , YE );
  buf (SE_buf , SE );  
  buf (ERASE_buf , ERASE );
  buf (MAS1_buf , MAS1 );
  buf (PROG_buf , PROG );
  buf (NVSTR_buf , NVSTR );
  buf (IFREN_buf , IFREN );
  buf (TMR_buf , TMR );
  buf (VPP_buf , VPP );

  // core function
  SFD64KX32M64P4_i flash (
           .XADR ( XADR_buf ) ,
           .YADR ( YADR_buf ) ,
           .DIN  ( DIN_buf ) ,
           .DOUT ( DOUT_buf ) ,
           .XE   ( XE_buf ) ,
           .YE   ( YE_buf ) ,
           .SE   ( SE_buf ) ,           
           .ERASE( ERASE_buf ) ,
           .MAS1 ( MAS1_buf ) ,
           .PROG ( PROG_buf ) ,
           .NVSTR( NVSTR_buf ) ,
           .IFREN( IFREN_buf ) ,
           .TMR  ( TMR_buf ) ,
           .VPP  ( VPP_buf ) ,
           .TM   ( TM_buf )
         );

endmodule
`endcelldefine

`timescale 1ns/10ps
`celldefine
module SFD64KX32M64P4_i(XADR,YADR,DIN,DOUT,XE,YE,SE,ERASE,MAS1,
PROG,NVSTR,IFREN,TMR,VPP,TM);

//begin parameter
parameter numAddrX = 10;
parameter numAddrXif = 3;
parameter numAddrY = 6;
parameter numTM = 3;
parameter numOut = 32;
parameter wordDepth = 65536;
parameter numRow = 1024;
parameter numErasePage = 2;
parameter numRow1 = 8;
parameter wordDepth1 = 512;
parameter numErasePage1 = 2;
parameter Txa = 35.000000;
parameter Tya = 35.000000;
parameter Tnvs = 5000.000000;
parameter Tnvh = 5000.000000;
parameter Tnvh1 = 100000.000000;
parameter Tpgs = 10000.000000;
parameter Tpgh = 20.000000;
parameter Tprog = 20000.000000;
parameter Tprogmax = 40000.000000;
parameter Tads = 20.000000;
parameter Tadh = 20.000000;
parameter Trcv = 1000.000000;
parameter Thv = 8000000.000000;
parameter Terase = 20000000.000000;
parameter Terasemax = 40000000.000000;
parameter Tme = 20000000.000000;
parameter Tmemax = 40000000.000000;
parameter Ttmr = 20.000000;
parameter Trses = 10.000000;
parameter Tseds = 10.000000;
parameter Tlds = 10.000000;
parameter Tlpw = 20.000000;
parameter Tldh = 10.000000;
parameter Tdseh = 10.000000;
parameter Tdh = 0.000000;
//end parameter

// internal parameter
parameter numAddrXX = numAddrX-1;
parameter numAddrXXif = numAddrXif-1;

// IO ports
input XE, YE, SE, ERASE, MAS1, PROG, NVSTR, IFREN;
input [numAddrX-1:0] XADR;
input [numAddrY-1:0] YADR;
input [numOut-1:0] DIN;
output [numOut-1:0] DOUT;

// test mode IO ports
input TMR;
inout VPP;
inout [numTM-1:0] TM;

`protect

// Truth Table
wire read_enable = !PROG && !ERASE && !MAS1 && !NVSTR;
wire prog_enable = !SE && PROG && !ERASE && !MAS1 && NVSTR;
wire erase_enable = !YE && !SE && !PROG && ERASE && NVSTR;
wire prog_nvstr_flag = !SE && !ERASE && !MAS1 && NVSTR;
wire erase_nvstr_flag = !YE && !SE && !PROG && NVSTR;
wire write_flag = ((PROG || ERASE) && NVSTR) || (NVSTR);

wire main_en=~IFREN;
wire info_en=IFREN;

//-------------------------- 
// Read Cycle
//-------------------------- 

// data output buffer
reg [numOut-1:0] DOUT;

// memory array
reg [numOut-1:0] main_mem [wordDepth-1:0];
reg [1:0] main_mem_prog_num [wordDepth-1:0];
wire [numAddrX+numAddrY-1:0] main_addr = {XADR,YADR};
reg [numOut-1:0] info_mem [wordDepth1-1:0];
reg [1:0] info_mem_prog_num [wordDepth1-1:0];
wire [numAddrXif-1:0] info_xaddr = {XADR[2],XADR[1],XADR[0]};
wire [numAddrXif+numAddrY-1:0] info_addr = {XADR[2],XADR[1],XADR[0],YADR};
reg [numAddrX-1:0] XADR_tmp;   
reg [numAddrXif-1:0] info_XADR_tmp;


// test code
reg [4:0] code;
reg set_code;

real tx,ty,ttx,tty,dt;
event check_dout;

wire Txa_enable;
wire Tya_enable;
wire Tdh_enable;
event Txa_reset, Txa_dly;
event Tya_reset, Tya_dly;
event Tdh_reset, Tdh_dly;
reg Txa_valid;
reg Tya_valid;
reg Tdh_valid;

reg XE_YE_low_flag;
reg SE_low_flag;
reg addr_flag;
reg x_flag;
reg set_reg_flag;
reg tmr_pus_flag;

and (Txa_enable, XE, read_enable);
and (Tya_enable, YE, SE, read_enable);
and (Tdh_enable, !SE, read_enable);

reg [2:0] addr_err;

// Program && Erase  && Test Cycle

reg [numAddrX+numAddrY:0] i;

// signal timing record 
real pos_tXE,neg_tXE;
real pos_tYE,neg_tYE;
real pos_tSE,neg_tSE;
real pos_tPROG,neg_tPROG;
real pos_tNVSTR,neg_tNVSTR;
real pos_tERASE,neg_tERASE;
real pos_tMAS1,neg_tMAS1;
real tIFREN,tXADR,tYADR,tDIN;
real pos_tTMR,neg_tTMR;
real pos_tVPP,neg_tVPP;

// signal previous state
reg lastPROG;                      
reg lastNVSTR;                      
reg lastERASE;                      

// program high voltage record
real totalProgTime;
time main_HVtime [numRow-1:0];
time info_HVtime [numRow1-1:0];

reg [1:0] state; /* 0: NOP              */
                 /* 1: program cycle    */
                 /* 2: erase cycle      */
                 /* 3: mass erase cycle */
reg mem_err,code_err,nvstr_err;

//--------------------------
// initialization
//-------------------------- 
initial begin
   $readmemh ("./mem_block.dat",main_mem);
   $readmemh ("./info_block.dat",info_mem);
   
  Txa_valid = 0;
  Tya_valid = 0;
  Tdh_valid = 0;
  XE_YE_low_flag = 0;
  SE_low_flag = 0; 
  addr_flag = 0;
  x_flag = 0;
  set_reg_flag = 0;
  tmr_pus_flag = 0;
  ->Txa_reset;
  ->Tya_reset;
  if (Tdh > 0) begin 
   ->Tdh_reset;
  end
  // reset HVtime
  for (i = 0; i < numRow; i = i + 1)
      main_HVtime[i] = 0;
  for (i = 0; i < numRow1; i = i + 1)
      info_HVtime[i] = 0;
  pos_tXE=0;
  neg_tXE=0;
  pos_tYE=0;
  neg_tYE=0;
  pos_tPROG=0;
  neg_tPROG=0;
  pos_tNVSTR=0;
  neg_tNVSTR=0;
  pos_tERASE=0;
  neg_tERASE=0;
  pos_tMAS1=0;
  neg_tMAS1=0;
  tIFREN=0;
  tXADR=0;
  tYADR=0;
  tDIN=0;
  pos_tVPP=0;
  neg_tVPP=0;
  mem_err=0;
  code_err=0;
  nvstr_err=0;
  set_code=0;
  addr_err=0;
end

// Error Handling
`ifdef no_whole_flash_unknown
`else
always @(mem_err) begin
  if (mem_err) begin
     for (i = 0; i < wordDepth; i = i + 1)
       main_mem[i] = {numOut{1'bx}};
     for (i = 0; i < wordDepth1; i = i + 1)
       info_mem[i] = {numOut{1'bx}};
  end
end
`endif


`ifdef no_warning_for_invalid_address
`else
always @(addr_err) begin
  case (addr_err)
    3'b001:
     $display("%.2fns \tERROR! X address exceeds %d in read cycle for main block\n",$realtime,numRow-1);
    3'b010:
     $display("%.2fns \tERROR! X address exceeds %d in program cycle for main block\n",$realtime,numRow-1);
    3'b011:
     $display("%.2fns \tERROR! X address exceeds %d in erase cycle for main block\n",$realtime,numRow-1);
  endcase
  addr_err=0;
end
`endif


always @(IFREN) begin
  tIFREN=$realtime;
  if (prog_enable) begin
     $display("%.2fns %m#\nERROR! IFREN switch during program cycle",$realtime);
     mem_err=1;
  end
  if (erase_enable) begin  
     $display("%.2fns %m#\nERROR! IFREN switch during erase cycle",$realtime);
     mem_err=1;
  end
  if (!SE) begin
     case (state)
       2'b01:
          if (tIFREN-neg_tPROG < Tnvh) begin
             $display("%.2fns %m#\nERROR! Timing Violation: [neg PROG:%.2f] [IFREN:%.2f] [Tnvh:%.2f]",
                       $realtime,neg_tPROG,tIFREN,Tnvh);
             mem_err=1;
          end
       2'b10:
          if (tIFREN-neg_tERASE < Tnvh) begin
             $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [IFREN:%.2f] [Tnvh:%.2f]",
                       $realtime,neg_tERASE,tIFREN,Tnvh);
             mem_err=1;
          end
       2'b11:   
          if (tIFREN-neg_tERASE < Tnvh1) begin
             $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [IFREN:%.2f] [Tnvh1:%.2f]",
                       $realtime,neg_tERASE,tIFREN,Tnvh1);
             mem_err=1;
          end
     endcase
  end
  if (!TMR && NVSTR && SE) begin
     if (tIFREN-pos_tNVSTR < Tseds) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [IFREN:%.2f] [Tseds:%.2f]",
                  $realtime,pos_tNVSTR,tIFREN,Tseds);
        code_err=1;
     end         
     if (tIFREN-pos_tSE < Tseds) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos SE:%.2f] [IFREN:%.2f] [Tseds:%.2f]",
                  $realtime,pos_tSE,tIFREN,Tseds);
        code_err=1;
     end         
     if (tIFREN-neg_tTMR < Tldh) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg TMR:%.2f] [IFREN:%.2f] [Tldh:%.2f]",
                  $realtime,neg_tTMR,tIFREN,Tldh);
        code=5'bx;
     end
  end
end

always @(XADR) begin
  tXADR=$realtime;
  if (prog_enable) begin  
     $display("%.2fns %m#\nERROR! XADR switch during program cycle",$realtime);
     mem_err=1;
  end
  if (erase_enable) begin 
     $display("%.2fns %m#\nERROR! XADR switch during erase cycle",$realtime);
     mem_err=1;
  end
  case (state)
    2'b01:
       if (tXADR-neg_tPROG < Tnvh) begin
          $display("%.2fns %m#\nERROR! Timing Violation: [neg PROG:%.2f] [XADR:%.2f] [Tnvh:%.2f]",
                    $realtime,neg_tPROG,tXADR,Tnvh);
          mem_err=1;
       end
    2'b10:
       if (tXADR-neg_tERASE < Tnvh) begin
          $display("%.2fns %m#\nERROR! Timing Violation: page erase [neg ERASE:%.2f] [XADR:%.2f] [Tnvh:%.2f]",
                    $realtime,neg_tERASE,tXADR,Tnvh);
          mem_err=1;
       end
    2'b11:
       if (tXADR-neg_tERASE < Tnvh1) begin
          $display("%.2fns %m#\nERROR! Timing Violation: mass erase [neg ERASE:%.2f] [XADR:%.2f] [Tnvh1:%.2f]",
                    $realtime,neg_tERASE,tXADR,Tnvh1);
          mem_err=1;
       end
  endcase
end

always @(XE) begin
  if (XE) begin
     pos_tXE=$realtime;
     set_code=0;
     if (state!=0 && pos_tXE-neg_tNVSTR<Trcv) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg NVSTR:%.2f] [pos XE:%.2f] [Trcv:%.2f]",
                  $realtime,neg_tNVSTR,pos_tXE,Trcv);
        mem_err=1;
     end
     if (!TMR && NVSTR && SE) begin
        if (pos_tXE-pos_tNVSTR<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos NVSTR:%.2f] [pos XE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tNVSTR,pos_tXE,Tseds);
           code_err=1;
        end
        if (pos_tXE-pos_tSE<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos SE:%.2f] [pos XE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tSE,pos_tXE,Tseds);
           code_err=1;
        end
     end
  end
  else begin
     neg_tXE=$realtime;
  	if (prog_enable) begin   
     	$display("%.2fns %m#\nERROR! XE switch during program cycle",$realtime);
     	mem_err=1;
  	end
  	if (erase_enable) begin 
     	$display("%.2fns %m#\nERROR! XE switch during erase cycle",$realtime);
     	mem_err=1;
  	end
     if (!SE) begin
        case (state)
          2'b01:
             if (neg_tXE-neg_tPROG < Tnvh) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg PROG:%.2f] [neg XE:%.2f] [Tnvh:%.2f]",
                          $realtime,neg_tPROG,neg_tXE,Tnvh);
                mem_err=1;   
             end
          2'b10:
             if (neg_tXE-neg_tERASE < Tnvh) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg XE:%.2f] [Tnvh:%.2f]",
                          $realtime,neg_tERASE,neg_tXE,Tnvh);
                mem_err=1;
             end 
          2'b11:
             if (neg_tXE-neg_tERASE < Tnvh1) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg XE:%.2f] [Tnvh1:%.2f]",
                          $realtime,neg_tERASE,neg_tXE,Tnvh1);
                mem_err=1;
             end 
        endcase
     end
     if (!TMR && NVSTR && SE && neg_tXE-neg_tTMR<Tldh) begin
        $display("%.2fns %m\nERROR: Timing Violation: [neg TMR:%.2f] [neg XE:%.2f] [Tldh:%.2f]",
                  $realtime,neg_tTMR,$realtime,Tldh);
        code=5'bx;
     end
  end
end

always @(YADR) begin
  tYADR=$realtime;
  if (prog_enable && TMR) begin    
  	if (YE) begin
       $display("%.2fns %m#\nERROR! YADR switch during program cycle",$realtime);
       mem_err=1;
	end
  end
  if (prog_enable && tYADR-neg_tYE<Tadh) begin
     $display("%.2fns %m#\nERROR! Timing Violation: [neg YE:%.2f] [YADR:%.2f] [Tadh:%.2f]",
               $realtime,neg_tYE,tYADR,Tadh);
     mem_err=1;
  end
end

always @(YE) begin
  if (YE) begin
     pos_tYE=$realtime;
     if (prog_enable) begin
        if (pos_tYE-pos_tNVSTR < Tpgs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [pos YE:%.2f] [Tpgs:%.2f]",
                     $realtime,pos_tNVSTR,pos_tYE,Tpgs);
           nvstr_err=1;
        end
        if ((pos_tYE-tYADR < Tads)) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [YADR:%.2f] [pos YE:%.2f] [Tads:%.2f]",
                     $realtime,tYADR,pos_tYE,Tads);
           nvstr_err=1;
        end
        if (pos_tYE-tDIN < Tads) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [DIN:%.2f] [pos YE:%.2f] [Tads:%.2f]",
                     $realtime,tDIN,pos_tYE,Tads);
           nvstr_err=1;  
        end
        if (nvstr_err) mem_err=1;
        else if (TMR && |TM !==1) ProgramMemory; // program
        else if (TMR && |TM ===1) begin
           $display("%.2fns %m#\nERROR! TM must be connected to GND or floating in user mode",$realtime);
           mem_err=1;
        end
        else if (code==5'h1d) MassProgramMemory; // mass program
        else begin
           $display("%.2fns %m#\nERROR! Wrong code for programming(1D): %h",$realtime,code);
           mem_err=1;
        end
     end
     if (!TMR && NVSTR && SE) begin
        if (pos_tYE-pos_tNVSTR<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos NVSTR:%.2f] [pos YE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tNVSTR,pos_tYE,Tseds);
           code_err=1;
        end
        if (pos_tYE-pos_tSE<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos SE:%.2f] [pos YE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tSE,pos_tYE,Tseds);
           code_err=1;
        end
     end
  end
  else begin
     neg_tYE=$realtime;
     if (prog_enable && TMR) begin
        if (neg_tYE-pos_tYE<Tprog) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos YE:%.2f] [neg YE:%.2f] [Tprog min:%.2f]",
                     $realtime,pos_tYE,neg_tYE,Tprog);
           mem_err=1;
        end
        else if (neg_tYE-pos_tYE > Tprogmax) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos YE:%.2f] [neg YE:%.2f] [Tprog max:%.2f]",
                     $realtime,pos_tYE,neg_tYE,Tprogmax);
           mem_err=1;
        end
     end
     if (!TMR && NVSTR && SE && neg_tYE-neg_tTMR<Tldh) begin
        $display("%.2fns %m\nERROR: Timing Violation: [neg TMR:%.2f] [neg YE:%.2f] [Tldh:%.2f]",
                  $realtime,neg_tTMR,$realtime,Tldh);
        code=5'bx;
     end
  end
end
 
always @(DIN) begin
  tDIN=$realtime;
  if (prog_enable && TMR) begin  
  	if (YE) begin
       $display("%.2fns %m#\nERROR! DIN switch during program cycle",$realtime);
       mem_err=1;
	end
  end
  if (prog_enable && tDIN-neg_tYE<Tadh) begin
     $display("%.2fns %m#\nERROR! Timing Violation: [neg YE:%.2f] [DIN:%.2f] [Tadh:%.2f]",
               $realtime,neg_tYE,tDIN,Tadh);
     mem_err=1;
  end
end

always @(PROG) begin
  if (PROG) begin
     pos_tPROG=$realtime;
     if (prog_nvstr_flag) begin
        $display("%.2fns %m#\nERROR! Wrong condition: PROG high late after NVSTR",$realtime);
        mem_err=1;
     end      
     if (state!=0 && pos_tPROG-neg_tNVSTR<Trcv) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg NVSTR:%.2f] [pos PROG:%.2f] [Trcv:%.2f]",
                  $realtime,neg_tNVSTR,pos_tPROG,Trcv);
        mem_err=1;
     end
     state=0;
  end
  else begin
     neg_tPROG=$realtime;
     if (state==1) begin
        XADR_tmp=XADR;
        info_XADR_tmp = {XADR[2],XADR[1],XADR[0]};
     end
     if (state==1 && neg_tPROG-neg_tYE<Tpgh) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg YE:%.2f] [neg PROG:%.2f] [Tpgh:%.2f]",
                  $realtime,neg_tYE,neg_tPROG,Tpgh);
        mem_err=1;
     end
  end
end

always @(ERASE) begin
  if (ERASE) begin
     pos_tERASE=$realtime;
     if (erase_nvstr_flag) begin
        $display("%.2fns %m#\nERROR! Wrong condition: ERASE high late after NVSTR",$realtime);    
        mem_err=1;
     end
     if (state!=0 && pos_tERASE-neg_tNVSTR<Trcv) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg NVSTR:%.2f] [pos ERASE:%.2f] [Trcv:%.2f]",
                  $realtime,neg_tNVSTR,pos_tERASE,Trcv);
        mem_err=1;
     end
     if (!TMR && NVSTR && SE) begin
        if (pos_tERASE-pos_tNVSTR<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos NVSTR:%.2f] [pos ERASE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tNVSTR,pos_tERASE,Tseds);
           code_err=1;
        end
        if (pos_tERASE-pos_tSE<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos SE:%.2f] [pos ERASE:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tSE,pos_tERASE,Tseds);
           code_err=1;
        end
     end
     state=0;
  end
  else begin
     neg_tERASE=$realtime;
     // page erase
     if (NVSTR && !MAS1 && TMR && neg_tERASE-pos_tNVSTR<Terase) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [neg ERASE:%.2f] [Terase min:%.2f]",
                  $realtime,pos_tNVSTR,neg_tERASE,Terase);
        mem_err=1;
     end
     // page erase
     if (NVSTR && !MAS1 && TMR && neg_tERASE-pos_tNVSTR>Terasemax) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [neg ERASE:%.2f] [Terase max:%.2f]",
                  $realtime,pos_tNVSTR,neg_tERASE,Terasemax);
        mem_err=1;
     end
     // mass erase
     if (NVSTR && MAS1 && TMR && neg_tERASE-pos_tNVSTR<Tme) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [neg ERASE:%.2f] [Tme min:%.2f]",
                  $realtime,pos_tNVSTR,neg_tERASE,Tme);
        mem_err=1;
     end
     // mass erase
     if (NVSTR && MAS1 && TMR && neg_tERASE-pos_tNVSTR>Tmemax) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [pos NVSTR:%.2f] [neg ERASE:%.2f] [Tme max:%.2f]",
                  $realtime,pos_tNVSTR,neg_tERASE,Tmemax);
        mem_err=1;
     end
     if (!TMR && NVSTR && SE && neg_tERASE-neg_tTMR < Tldh) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg TMR:%.2f] [neg ERASE:%.2f] [Tldh:%.2f]",
                  $realtime,neg_tTMR,neg_tERASE,Tldh);
        code=5'bx;
     end
  end
end

always @(MAS1) begin
  if (erase_enable) begin
     $display("%.2fns %m#\nERROR! MAS1 switch during erase cycle",$realtime);
     mem_err=1;
  end        
  if (MAS1) begin
     pos_tMAS1=$realtime;
     if (!SE && pos_tMAS1-neg_tNVSTR<Trcv) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg NVSTR:%.2f] [pos MAS1:%.2f] [Trcv:%.2f]",
                  $realtime,neg_tNVSTR,pos_tMAS1,Trcv);
        mem_err=1;
     end
     if (!TMR && NVSTR && SE) begin
        if (pos_tMAS1-pos_tNVSTR<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos NVSTR:%.2f] [pos MAS1:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tNVSTR,pos_tMAS1,Tseds);
           code_err=1;
        end
        if (pos_tMAS1-pos_tSE<Tseds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos SE:%.2f] [pos MAS1:%.2f] [Tseds:%.2f]",
                     $realtime,pos_tSE,pos_tMAS1,Tseds);
           code_err=1;
        end
     end
  end  
  else begin
     neg_tMAS1=$realtime;
     if (neg_tMAS1-neg_tERASE<Tnvh1 && !SE && neg_tMAS1>0 && neg_tERASE>0) begin
        $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg MAS1:%.2f] [Tnvh1:%.2f]",
                  $realtime,neg_tERASE,neg_tMAS1,Tnvh1);
        mem_err=1;
     end
     if (!TMR && NVSTR && SE && neg_tMAS1-neg_tTMR<Tldh) begin
        $display("%.2fns %m\nERROR: Timing Violation: [neg TMR:%.2f] [neg MAS1:%.2f] [Tldh:%.2f]",
                  $realtime,neg_tTMR,neg_tMAS1,Tldh);
        code=5'bx;
     end
  end 
end

always @(NVSTR) begin
  if (NVSTR) begin
     pos_tNVSTR=$realtime;
     set_code=0;
     fork
     begin
       if (TMR) begin
         #0.01;
         if (SE)
          $display("%.2fns %m#\nWarning! NVSTR and SE are both high in user mode.",$realtime);
       end
     end
     begin
       if (!TMR) begin
         #0.01;
         if (SE)
           set_reg_flag=1;
       end
     end
     begin 
      if (PROG && ERASE) begin
          $display("%.2fns %m#\nERROR! Wrong conditions! PROG and ERASE is high when posedge NVSTR.",$realtime);
          mem_err=1;
      end
      else if (PROG || ERASE) begin
        if (pos_tNVSTR-tIFREN<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [IFREN:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,tIFREN,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end
        if (pos_tNVSTR-tXADR<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [XADR:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,tXADR,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end
        if (pos_tNVSTR-pos_tXE<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos XE:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,pos_tXE,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end
        if (pos_tNVSTR-pos_tPROG<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos PROG:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,pos_tPROG,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end
        if (pos_tNVSTR-pos_tERASE<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos ERASE:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,pos_tERASE,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end
        if (pos_tNVSTR-pos_tMAS1<Tnvs) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [pos MAS1:%.2f] [pos NVSTR:%.2f] [Tnvs:%.2f]",
                     $realtime,pos_tMAS1,pos_tNVSTR,Tnvs);
           nvstr_err=1;
        end        
        if (nvstr_err) mem_err=1;
        else if (!XE) begin
           $display("%.2fns %m#\nERROR! wrong condition for XE low while NVSTR high",$realtime);
           mem_err=1;
        end
        else if (PROG) begin
           state=1;
           if (!TMR && code!=5'h1D && code!=5'h1E) begin
              $display("%.2fns %m#\nERROR! Wrong code for program(1D/1E): %h",$realtime,code);
              nvstr_err=1;
           end
        end
        else if (YE || SE) begin
           $display("%.2fns %m#\nERROR! wrong condition  for erase cycle: XE:%b YE:%b SE:%b",
                    $realtime,XE,YE,SE);
           mem_err=1;
        end
        else begin
           if (MAS1) begin
              state=3;
              if (!TMR && code!=5'h1C) begin
                 $display("%.2fns %m#\nERROR! Wrong code for erase(1C): %h",$realtime,code);
                 mem_err=1;
              end
              else if (TMR && |TM !== 1) begin
                EraseWholeMemory;
              end
              else if (TMR && |TM === 1) begin
                $display("%.2fns %m#\nERROR! TM must be connected to GND or floating in user mode",$realtime);
                mem_err=1;
              end
           end
           else begin
             if (TMR && |TM !== 1) begin 
               state=2;
               ErasePageMemory;
             end
             else if (TMR && |TM === 1) begin
                $display("%.2fns %m#\nERROR! TM must be connected to GND or floating in user mode",$realtime);
                mem_err=1; 
             end 
           end
        end
     end
     else begin
        if (pos_tNVSTR-neg_tTMR<Trses && !TMR) begin
           $display("%.2fns %m\nERROR: Timing Violation: [neg TMR:%.2f] [pos NVSTR:%.2f] [Trses:%.2f]",
                     $realtime,neg_tTMR,pos_tNVSTR,Trses);
           code_err=1;
        end
        state=0;
     end
   end
   join
  end
  else begin
     neg_tNVSTR=$realtime;
     nvstr_err=0;
     if (!TMR && set_reg_flag) begin
        if (!tmr_pus_flag) begin
           $display("%.2fns %m\nWarning: TMR must be toggled during set register mode.",$realtime);
        end
        set_reg_flag=0;
        tmr_pus_flag=0;
     end
     if (PROG || ERASE) begin
        $display("%.2fns %m#\nERROR! Wrong conditions! PROG or ERASE is high when negedge NVSTR.",$realtime);
        mem_err=1;
     end
     else begin
        if (neg_tNVSTR-neg_tPROG<Tnvh && neg_tNVSTR>0 && neg_tPROG>0) begin
           $display("%.2fns %m#\nERROR! Timing Violation: [neg PROG:%.2f] [neg NVSTR:%.2f] [Tnvh:%.2f]",
                     $realtime,neg_tPROG,neg_tNVSTR,Tnvh);
           mem_err=1;
        end
        if (!SE) begin
           if (state==2 && neg_tNVSTR-neg_tERASE<Tnvh) begin // page erase
              $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg NVSTR:%.2f] [Tnvh:%.2f]",
                        $realtime,neg_tERASE,neg_tNVSTR,Tnvh);
              mem_err=1;
           end
           if (state==3 && neg_tNVSTR-neg_tERASE<Tnvh1) begin // mass erase
              $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg NVSTR:%.2f] [Tnvh1:%.2f]",
                        $realtime,neg_tERASE,neg_tNVSTR,Tnvh1);
              mem_err=1;
        end
        else if (!TMR && set_code) begin
           if (neg_tNVSTR-neg_tMAS1<Tdseh) begin
              $display("%.2fns %m\nERROR: Timing Violation: [neg MAS1:%.2f] [neg NVSTR:%.2f] [Tdseh:%.2f]",
                        $realtime,neg_tMAS1,neg_tNVSTR,Tdseh);
              code=5'bx;
           end
           if (neg_tNVSTR-tIFREN<Tdseh) begin
              $display("%.2fns %m\nERROR: Timing Violation: [IFREN:%.2f] [neg NVSTR:%.2f] [Tdseh:%.2f]",
                        $realtime,tIFREN,$realtime,Tdseh);
              code=5'bx;    
           end    
           if (neg_tNVSTR-neg_tXE<Tdseh) begin
              $display("%.2fns %m\nERROR: Timing Violation: [neg XE:%.2f] [neg NVSTR:%.2f] [Tdseh:%.2f]",
                        $realtime,neg_tXE,$realtime,Tdseh);
              code=5'bx;    
           end
           if (neg_tNVSTR-neg_tYE<Tdseh) begin
              $display("%.2fns %m\nERROR: Timing Violation: [neg YE:%.2f] [neg NVSTR:%.2f] [Tdseh:%.2f]",
                        $realtime,neg_tYE,$realtime,Tdseh);
              code=5'bx;    
           end
           if (neg_tNVSTR-neg_tERASE<Tdseh) begin
              $display("%.2fns %m\nERROR: Timing Violation: [neg ERASE:%.2f] [neg NVSTR:%.2f] [Tdseh:%.2f]",
                        $realtime,neg_tERASE,$realtime,Tdseh);
              code=5'bx;    
           end
        end
        if (state==1 && TMR) begin
           if (main_en) begin
              totalProgTime=main_HVtime[XADR_tmp]+$realtime-pos_tPROG;
              if (totalProgTime>Thv) begin
                 $display("%.2fns %m#\nERROR! PROGRAM HV TIME (%.2f) OF ROW %d IS TOO LONG [Thv:%.2f]!",
                           $realtime,totalProgTime,XADR_tmp,Thv);
                 mem_err=1;
              end
              main_HVtime[XADR_tmp]=totalProgTime;
           end
           else if (info_en) begin
              totalProgTime=info_HVtime[info_XADR_tmp]+$realtime-pos_tPROG; 
              if (totalProgTime>Thv) begin
                 $display("%.2fns %m#\nERROR! PROGRAM HV TIME (%.2f) OF ROW %d IS TOO LONG [Thv:%.2f]!",
                           $realtime,totalProgTime,info_XADR_tmp,Thv);
                 mem_err=1;
              end
              info_HVtime[info_XADR_tmp]=totalProgTime;
           end
        end
     end
  end
end
end

always @(TMR) begin
  if (TMR) begin
     pos_tTMR=$realtime;
     if (NVSTR && SE) begin
        set_code=1;
        if (pos_tTMR-pos_tMAS1<Tlds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos MAS1:%.2f] [pos TMR:%.2f] [Tlds:%.2f]",
                     $realtime,neg_tMAS1,pos_tTMR,Tlds);
           code_err=1;
        end
        if (pos_tTMR-tIFREN<Tlds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos IFREN:%.2f] [pos TMR:%.2f] [Tlds:%.2f]",
                     $realtime,tIFREN,pos_tTMR,Tlds);
           code_err=1;
        end
        if (pos_tTMR-pos_tXE<Tlds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos XE:%.2f] [pos TMR:%.2f] [Tlds:%.2f]",
                     $realtime,neg_tXE,pos_tTMR,Tlds);
           code_err=1;
        end
        if (pos_tTMR-pos_tYE<Tlds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos YE:%.2f] [pos TMR:%.2f] [Tlds:%.2f]",
                     $realtime,neg_tYE,pos_tTMR,Tlds);
           code_err=1;
        end
        if (pos_tTMR-pos_tERASE<Tlds) begin
           $display("%.2fns %m\nERROR: Timing Violation: [pos ERASE:%.2f] [pos TMR:%.2f] [Tlds:%.2f]",
                     $realtime,neg_tERASE,pos_tTMR,Tlds);
           code_err=1;
        end
        if (code_err) code=5'bx;
        else begin
           code={ERASE,YE,XE,IFREN,MAS1};
           $display("%.2fns %m\nINFO: set test code [%h]",$realtime,code);
        end
     end
     else code=5'b0;
  end
  else begin    
     neg_tTMR=$realtime;
     code_err=0;
     if (NVSTR && SE) begin
       if (neg_tTMR-pos_tTMR<Tlpw) begin
         $display("%.2fns %m#\nERROR! TMR pulse less than Tlpw",$realtime);
         code=5'bx;
       end
       else begin
         tmr_pus_flag=1;
       end
     end
  end      
end

always @(SE) begin
  if (SE) begin
     pos_tSE=$realtime;
     fork
     begin 
       if (TMR) begin
         #0.01;
         if (NVSTR)
          $display("%.2fns %m#\nWarning! NVSTR and SE are both high in user mode.",$realtime);
       end
     end
     begin
       if (!TMR) begin
         #0.01;
         if (NVSTR)
           set_reg_flag=1;
       end
     end
     begin     
       if (TMR && state!=0 && (pos_tSE-neg_tNVSTR<Trcv || write_flag)) begin
         $display("%.2fns %m#\nERROR! SE high during program/erase/mass erase cycle",$realtime);
         mem_err=1;           
       end
       if (!TMR && NVSTR && pos_tSE-neg_tTMR<Trses) begin
         $display("%.2fns %m\nERROR: Timing Violation: [neg TMR:%.2f] [pos SE:%.2f] [Trses:%.2f]",
                   $realtime,neg_tTMR,$realtime,Trses);
         code_err=1;
       end
     end
     join 
  end
  else begin
     neg_tSE=$realtime;
     if (!TMR && set_reg_flag) begin
       if (!tmr_pus_flag) begin
          $display("%.2fns %m\nWarning: TMR must be toggled during set register mode.",$realtime);
       end
       set_reg_flag=0;
       tmr_pus_flag=0;
     end    
     if (!TMR && set_code) begin
        if (neg_tSE-neg_tMAS1<Tdseh) begin
           $display("%.2fns %m\nERROR: Timing Violation: [neg MAS1:%.2f] [neg SE:%.2f] [Tdseh:%.2f]",
                     $realtime,neg_tMAS1,neg_tSE,Tdseh);
           code=5'bx;
        end
        if (neg_tSE-tIFREN<Tdseh) begin
           $display("%.2fns %m\nERROR: Timing Violation: [IFREN:%.2f] [neg SE:%.2f] [Tdseh:%.2f]",
                     $realtime,tIFREN,$realtime,Tdseh);
           code=5'bx;
        end
        if (neg_tSE-neg_tXE<Tdseh && !NVSTR) begin
           $display("%.2fns %m\nERROR: Timing Violation: [neg XE:%.2f] [neg SE:%.2f] [Tdseh:%.2f]",
                     $realtime,neg_tXE,$realtime,Tdseh);
           code=5'bx;
        end
        if (neg_tSE-neg_tYE<Tdseh && !NVSTR) begin
           $display("%.2fns %m\nERROR: Timing Violation: [neg YE:%.2f] [neg SE:%.2f] [Tdseh:%.2f]",
                     $realtime,neg_tYE,$realtime,Tdseh);
           code=5'bx;
        end
        if (neg_tSE-neg_tERASE<Tdseh) begin
           $display("%.2fns %m\nERROR: Timing Violation: [neg ERASE:%.2f] [neg SE:%.2f] [Tdseh:%.2f]",
                     $realtime,neg_tERASE,$realtime,Tdseh);
           code=5'bx;
        end
     end
  end
end
 
always @(VPP) begin
  if (VPP) pos_tVPP=$realtime;
  else begin
     neg_tVPP=$realtime;
     if (!TMR) begin
        case (state)
          2'b01:
             if (neg_tVPP-neg_tPROG < Tnvh) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg PROG:%.2f] [neg VPP:%.2f] [Tnvh:%.2f]",
                          $realtime,neg_tPROG,neg_tVPP,Tnvh);
                mem_err=1;   
             end
          2'b10:
             if (neg_tVPP-neg_tERASE < Tnvh) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg VPP:%.2f] [Tnvh:%.2f]",
                          $realtime,neg_tERASE,neg_tVPP,Tnvh);
                mem_err=1;
             end 
          2'b11:
             if (neg_tVPP-neg_tERASE < Tnvh1) begin
                $display("%.2fns %m#\nERROR! Timing Violation: [neg ERASE:%.2f] [neg VPP:%.2f] [Tnvh1:%.2f]",
                          $realtime,neg_tERASE,neg_tVPP,Tnvh1);
                mem_err=1;
             end 
        endcase
     end
  end
end






always @(Txa_reset) begin
  disable Txa_delay;
  Txa_valid = 0;
  #0.01;
  if(Txa_enable) begin
    ->Txa_dly;
  end
end

always @(Txa_dly) begin: Txa_delay
  #(Txa-0.01) Txa_valid = 1;
end


always @(Tya_reset) begin
  disable Tya_delay;
  Tya_valid = 0;
  #0.01;
  if(Tya_enable) begin
    ->Tya_dly;
  end
end


always @(Tya_dly) begin: Tya_delay
  #(Tya-0.01) Tya_valid = 1;
end


always @(Tdh_reset) begin
  disable Tdh_delay;
  Tdh_valid = 0;
  #0.01;
  if(Tdh_enable) begin
    ->Tdh_dly;
  end
end

always @(Tdh_dly) begin: Tdh_delay
  #(Tdh-0.01) Tdh_valid = 1; 
end


always @(Txa_valid or Tya_valid) begin
 if (Txa_valid && Tya_valid) begin   
     if (!TMR && code!=5'h09 && code!=5'h0A) begin
       $display("%.2fns %m#\nERROR! Wrong code for read (09/0A): %h",$realtime,code);
       DOUT={numOut{1'bx}};
     end
     else if (TMR && |TM === 1) begin
       $display("%.2fns %m#\nERROR! TM must be connected to GND or floating in user mode",$realtime);
       DOUT={numOut{1'bx}};      
     end 
     else begin
        ReadMem;
        x_flag=0;
     end   
 end
end

always @(Tdh_valid) begin
 if (Tdh_valid) begin
   DOUT={numOut{1'b0}};
 end
end

always @(XE) begin
  ->Txa_reset;
end

always @(XE) begin
 if (Tdh>0) begin
    if (XE) begin
       ->check_dout;
    end
 end
 else begin
    ->check_dout;
 end  
 if (XE) begin
   tx=$realtime;
 end
 if (!XE) begin
    if (Tdh > 0) begin
      if (!XE_YE_low_flag && !SE_low_flag && !addr_flag) begin
        fork 
        begin
          #0.01 XE_YE_low_flag = 1;
        end
        begin
          #Tdh; 
	  if (!SE)     
           DOUT={numOut{1'b0}};
	  else 
	   DOUT={numOut{1'bx}};
          XE_YE_low_flag = 0;
          x_flag = 1;
        end
        join
      end
    end 
 end    
end

always @(XADR) begin
->Txa_reset;
end

always @(XADR) begin
  if (^XADR !== 1'bx) begin
    tx=$realtime;
  end  
  if (Tdh == 0)
   ->check_dout;
  else begin
    if (!SE_low_flag && !XE_YE_low_flag && !addr_flag) begin
      fork 
      begin
        #0.01 addr_flag = 1;
      end
      begin 
       #Tdh; 
       if (!SE)
        DOUT={numOut{1'b0}};
       else 
        DOUT={numOut{1'bx}};	        
       addr_flag = 0;
       x_flag = 1;
      end
      join   
    end   
  end 
end

always @(YADR) begin
 ->Tya_reset;
end

always @(YADR) begin
 if (^YADR !== 1'bx) begin
   ty=$realtime;
 end
 if (Tdh == 0)
  ->check_dout;
 else begin
    if (!SE_low_flag && !XE_YE_low_flag && !addr_flag) begin
      fork 
      begin
        #0.01 addr_flag = 1;
      end
      begin 
       #Tdh; 
       if (!SE)
        DOUT={numOut{1'b0}};
       else 
        DOUT={numOut{1'bx}};	        
       addr_flag = 0;
       x_flag = 1;
      end
      join   
    end   
  end   
end

always @(IFREN) begin
 ->Txa_reset;
end

always @(IFREN) begin
 if (^IFREN !== 1'bx) begin
   tx=$realtime;
 end 
 if (Tdh == 0)
  ->check_dout;
 else begin
    if (!SE_low_flag && !XE_YE_low_flag && !addr_flag) begin
      fork 
      begin
        #0.01 addr_flag = 1;
      end
      begin 
       #Tdh; 
       if (!SE)
        DOUT={numOut{1'b0}};
       else 
        DOUT={numOut{1'bx}};	        
       addr_flag = 0;
       x_flag = 1;
      end
      join   
    end   
 end 
end

always @(YE) begin
 ->Tya_reset;
end

always @(YE) begin  
  if (Tdh>0) begin
    if (YE) begin
       ->check_dout;
    end
  end
  else begin
    ->check_dout;
  end
  if (YE) begin
    ty=$realtime;
  end
  if (!YE) begin
    if (Tdh > 0) begin
      if (!XE_YE_low_flag && !SE_low_flag && !addr_flag) begin
        fork 
        begin
          #0.01 XE_YE_low_flag = 1;
        end
        begin
          #Tdh; 
	 if (!SE)      
          DOUT={numOut{1'b0}};
	 else 
	  DOUT={numOut{1'bx}};
         XE_YE_low_flag = 0;
         x_flag = 1;
        end
        join
      end
    end 
  end 
end

always @(SE) begin
 ->Tya_reset;
end

always @(SE) begin 
 if (Tdh>0) begin
    if (SE) begin
       ->check_dout;
    end
 end
 else begin
    ->check_dout;
 end
 if (SE) begin
   ty=$realtime;
 end
 if (!SE) begin
   if (Tdh > 0) begin
    if (x_flag) begin
      DOUT={numOut{1'b0}};
    end
    else if (!SE_low_flag && !XE_YE_low_flag && !addr_flag) begin
      fork 
      begin
        #0.01 SE_low_flag=1;
      end
      begin 
       #Tdh; 
       DOUT={numOut{1'b0}};
       SE_low_flag=0;
      end
      join   
    end
   end
   else begin
    DOUT={numOut{1'b0}};
   end
 end   
end

// check output data
always @(check_dout) begin
  if ((XE_YE_low_flag || SE_low_flag || addr_flag) && Tdh > 0) begin  
  end  
  else if (SE==0) begin
    if (Tdh == 0) begin
      DOUT={numOut{1'b0}};
    end
  end 
  else if (!read_enable) DOUT={numOut{1'bx}};
  else if (XE && YE && SE) begin
    if (!TMR && code!=5'h09 && code!=5'h0A) begin
      $display("%.2fns %m#\nERROR! Wrong code for read (09/0A): %h",$realtime,code);
      DOUT={numOut{1'bx}};
    end
    else begin      
      DOUT={numOut{1'bx}};
    end
  end
  else DOUT={numOut{1'bx}};
end

task ReadMem;
  if (main_en) begin
    if(XADR>=numRow) begin
      DOUT = {numOut{1'bx}};
      addr_err=1;
    end
    else begin
      DOUT=main_mem[main_addr];
    end
  end
  else if (info_en) begin    
      DOUT=info_mem[info_addr];
  end
  else DOUT={numOut{1'bx}};
endtask

task ProgramMemory;
reg [numOut-1:0] progData;
begin
  if (main_en) begin
     // non_fully_decode_handling_begin
     if(XADR>=numRow && XE && PROG && NVSTR) begin
       addr_err=2;
     end
     // non_fully_decode_handling_end
     else if (^main_addr === 1'bx) begin
        $display("%.2fns %m#\nERROR! address unknown when programming.", $realtime);
        mem_err=1;
     end
     else if (main_mem_prog_num[main_addr] > 1) begin
       $display("%.2fns %m$\nERROR! unerased main cell [%h] is reprogrammed more than twice.",
                     $realtime,main_addr);
       main_mem[main_addr]={numOut{1'bx}};
     end
     else begin
       progData = main_mem[main_addr] & DIN; // MUST BE PRE-ERASED
       main_mem[main_addr]=progData;
       main_mem_prog_num[main_addr]=main_mem_prog_num[main_addr]+1;
       mem_err=0;
     end
  end
  else if (info_en) begin     
     if (^info_addr === 1'bx) begin
        $display("%.2fns %m#\nERROR! address unknown when programming.", $realtime);
        mem_err=1;
     end
     else if (info_mem_prog_num[info_addr] > 1) begin
        $display("%.2fns %m$\nERROR! unerased info cell [%h] is reprogrammed more than twice.",
                     $realtime,info_addr);
        info_mem[info_addr]={numOut{1'bx}};
     end
     else begin
       progData = info_mem[info_addr] & DIN; // MUST BE PRE-ERASED
       info_mem[info_addr]=progData;
       info_mem_prog_num[info_addr]=info_mem_prog_num[info_addr]+1;
       mem_err=0;
     end
  end
end
endtask


task ErasePageMemory;
reg [numAddrX+numAddrY:0] i;
reg [numAddrXif+numAddrY:0] j;
begin  
    if (main_en) begin
      // non_fully_decode_handling_begin
      if (XADR >= numRow && XE && !YE && !SE && !MAS1) begin
        addr_err=3;
      end
      // non_fully_decode_handling_end
      else if (^XADR === 1'bx) begin
        $display("%.2fns %m#\nERROR! X address unknown when erasing.", $realtime);
        mem_err=1;
      end
      else begin
        for (i = {XADR>>numErasePage,{numErasePage{1'b0}},{numAddrY{1'b0}}};
             i <= {XADR>>numErasePage,{numErasePage{1'b1}},{numAddrY{1'b1}}}; i=i+1) begin
            main_mem[i]={numOut{1'b1}};
            main_mem_prog_num[i]=0;
        end
        for (i = {XADR>>numErasePage,{numErasePage{1'b0}}};
             i <= {XADR>>numErasePage,{numErasePage{1'b1}}}; i=i+1)
            main_HVtime[i]=0;
        mem_err=0;
      end
    end
    else if (info_en) begin       
       if (^info_xaddr === 1'bx) begin
           $display("%.2fns %m#\nERROR! X address unknown when erasing.", $realtime);
           mem_err=1;
       end
       else begin       
         for (j = {info_xaddr>>numErasePage1,{numErasePage1{1'b0}},{numAddrY{1'b0}}};
               j <= {info_xaddr>>numErasePage1,{numErasePage1{1'b1}},{numAddrY{1'b1}}}; j=j+1) begin
              info_mem[j] = {numOut{1'b1}};
              info_mem_prog_num[j] = 0;
         end
         for (j = {info_xaddr>>numErasePage1,{numErasePage1{1'b0}}};
              j <= {info_xaddr>>numErasePage1,{numErasePage1{1'b1}}}; j=j+1)
              info_HVtime[j] = 0;
         mem_err=0;
       end
    end  
    else begin
       $display("%.2fns %m#\nWARNING! No block selected during page erase!",$realtime);
    end      
end      
endtask  


task EraseWholeMemory;
reg [numAddrX+numAddrY:0] i;
begin
  for (i = 0; i < wordDepth; i = i + 1) begin
    main_mem[i] = {numOut{1'b1}};
    main_mem_prog_num[i] = 0;
  end
  for (i = 0; i < numRow; i = i + 1)
    main_HVtime[i] = 0;
  mem_err=0;
  if (IFREN) begin
     for (i = 0; i < wordDepth1; i = i + 1) begin
       info_mem[i] = {numOut{1'b1}};
       info_mem_prog_num[i] = 0;
     end
     for (i = 0; i < numRow1; i = i + 1)
       info_HVtime[i] = 0;
  end
end
endtask


task MassProgramMemory;
reg [numAddrX+numAddrY:0] i;
reg [numAddrXif+numAddrY:0] j;
reg [numAddrX-1:0] wordi;
reg [numAddrXif-1:0] wordj;
reg [numOut-1:0] progData;
begin
  for (wordi = {numAddrXX{1'b0}};
       wordi <= {numAddrXX{1'b1}}; wordi=wordi+1) begin
    i={wordi,XADR[0],YADR};
    if (main_mem_prog_num[i] > 1) begin
       $display("%.2fns %m$\nERROR! unerased main cell [%h] is reprogrammed more than twice.",
               $realtime,i);
       main_mem[i]={numOut{1'bx}};
    end
    else begin
       progData = main_mem[i] & DIN; // MUST BE PRE-ERASED
       main_mem[i]=progData;
       main_mem_prog_num[i]=main_mem_prog_num[i]+1;
       mem_err=0;
    end
  end
  if (IFREN) begin
    for (wordj = {numAddrXXif{1'b0}};
         wordj <= {numAddrXXif{1'b1}}; wordj=wordj+1) begin
       j={wordj,XADR[0],YADR};
       if (info_mem_prog_num[j] > 1) begin
         $display("%.2fns %m$\nERROR! unerased info cell [%h] is reprogrammed more than twice.",
                 $realtime,j);
         info_mem[j]={numOut{1'bx}};
       end
       else begin
         progData = info_mem[j] & DIN; // MUST BE PRE-ERASED
         info_mem[j]=progData;
         info_mem_prog_num[j]=info_mem_prog_num[j]+1;
         mem_err=0;
       end
    end
  end
end
endtask


`endprotect

endmodule
`endcelldefine


