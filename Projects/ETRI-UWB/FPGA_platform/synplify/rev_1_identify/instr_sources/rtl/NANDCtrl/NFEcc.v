//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Ecc Calculation
// history     :
//
//************************************************
`timescale 1ns/10ps
//`define NAND16
module NFEcc(
    Clk,
    nRst,

    AddrIn,
    AddrLoadEnIn,
    IOWidthIn,
    NandWidthIn,
    PageSizeIn,
    EccRstIn,
    Ecc512EnIn,
    AutoEccWr,
    AutoEccWrEnOut,

    EccOut,
    AddrCntOut,
    BoundaryOut,
    CST_RdataIn,
    CST_WdataIn,
    EccDataIn,
    EccDataEnIn,
    // to APBIF

    ECCSECTOR0, 
    ECCSECTOR1, 
    ECCSECTOR2, 
    ECCSECTOR3, 
    ECCSECTOR4, 
    ECCSECTOR5, 
    ECCSECTOR6, 
    ECCSECTOR7, 
    ECCSECTOR8, 
    ECCSECTOR9, 
    ECCSECTOR10, 
    ECCSECTOR11, 
    ECCSECTOR12, 
    ECCSECTOR13, 
    ECCSECTOR14, 
    ECCSECTOR15, 
                
    SECCSECTOR0,
    SECCSECTOR1,
    SECCSECTOR2,
    SECCSECTOR3,
    SECCSECTOR4,
    SECCSECTOR5,
    SECCSECTOR6,
    SECCSECTOR7
    );

input           Clk;
input           nRst;

input[11:0]     AddrIn;
input           AddrLoadEnIn;
input           IOWidthIn;
input           NandWidthIn;
input           PageSizeIn;
input           EccRstIn;
input           Ecc512EnIn;
input           AutoEccWr;
output          AutoEccWrEnOut;

output[15:0]    EccOut;
output[11:0]    AddrCntOut;
output          BoundaryOut;
input           CST_RdataIn;
input           CST_WdataIn;
input[15:0]     EccDataIn;
input           EccDataEnIn;
// to APBIF
output[23:0]     ECCSECTOR0;  //offset 0x14
output[23:0]     ECCSECTOR1;  //offset 0x18
output[23:0]     ECCSECTOR2;  //offset 0x1c
output[23:0]     ECCSECTOR3;  //offset 0x20
output[23:0]     ECCSECTOR4;  //offset 0x24
output[23:0]     ECCSECTOR5;  //offset 0x28
output[23:0]     ECCSECTOR6;  //offset 0x2c
output[23:0]     ECCSECTOR7;  //offset 0x30
output[23:0]     ECCSECTOR8;  //offset 0x34
output[23:0]     ECCSECTOR9;  //offset 0x38
output[23:0]     ECCSECTOR10; //offset 0x3c
output[23:0]     ECCSECTOR11; //offset 0x40
output[23:0]     ECCSECTOR12; //offset 0x44
output[23:0]     ECCSECTOR13; //offset 0x48
output[23:0]     ECCSECTOR14; //offset 0x4c
output[23:0]     ECCSECTOR15; //offset 0x50

output[15:0]     SECCSECTOR0; //offset 0x54
output[15:0]     SECCSECTOR1; //offset 0x58
output[15:0]     SECCSECTOR2; //offset 0x5c
output[15:0]     SECCSECTOR3; //offset 0x60
output[15:0]     SECCSECTOR4; //offset 0x64
output[15:0]     SECCSECTOR5; //offset 0x68
output[15:0]     SECCSECTOR6; //offset 0x6c
output[15:0]     SECCSECTOR7; //offset 0x70



parameter ST_IDLE = 6'b000001;
parameter ST_LSN  = 6'b000010;
parameter ST_ECCA = 6'b000100;
parameter ST_SECC = 6'b001000;
parameter ST_ECCB = 6'b010000;
parameter ST_WAIT = 6'b100000;


//wire[15:0]      MainData;
`ifdef NAND16
    wire[23:0]      MainEcc16;
    wire[ 9:0]      SpareEcc16;
//**3.8    
//    wire[15:0]      SpareEcc16;
`endif

wire[23:0]      MainEcc8_0;
wire[23:0]      MainEcc8_1;
wire[ 9:0]      SpareEcc8_0;
wire[ 9:0]      SpareEcc8_1;
//**3.8
/*
wire[15:0]      SpareEcc8_0;
wire[15:0]      SpareEcc8_1;
*/
reg             BoundaryOut;
reg [11:0]      AddrCnt;

// to APBIF

//reg[1:0]        MainRegNum;
wire[1:0]       MainRegNum_512;
wire[2:0]       MainRegNum_256;

reg [23:0]      ECCSECTOR0;  //offset 0x14
reg [23:0]      ECCSECTOR1;  //offset 0x18
reg [23:0]      ECCSECTOR2;  //offset 0x1c
reg [23:0]      ECCSECTOR3;  //offset 0x20
reg [23:0]      ECCSECTOR4;  //offset 0x24
reg [23:0]      ECCSECTOR5;  //offset 0x28
reg [23:0]      ECCSECTOR6;  //offset 0x2c
reg [23:0]      ECCSECTOR7;  //offset 0x30
reg [23:0]      ECCSECTOR8;  //offset 0x14
reg [23:0]      ECCSECTOR9;  //offset 0x18
reg [23:0]      ECCSECTOR10; //offset 0x1c
reg [23:0]      ECCSECTOR11; //offset 0x20
reg [23:0]      ECCSECTOR12; //offset 0x24
reg [23:0]      ECCSECTOR13; //offset 0x28
reg [23:0]      ECCSECTOR14; //offset 0x2c
reg [23:0]      ECCSECTOR15; //offset 0x30

/*
reg [15:0]      SECCSECTOR0; //offset 0x34
reg [15:0]      SECCSECTOR1; //offset 0x38
reg [15:0]      SECCSECTOR2; //offset 0x3c
reg [15:0]      SECCSECTOR3; //offset 0x40
reg [15:0]      SECCSECTOR4; //offset 0x44
reg [15:0]      SECCSECTOR5; //offset 0x48
reg [15:0]      SECCSECTOR6; //offset 0x4c
reg [15:0]      SECCSECTOR7; //offset 0x50
*/

reg [9:0]      SpareEcc0; //offset 0x34
reg [9:0]      SpareEcc1; //offset 0x38
reg [9:0]      SpareEcc2; //offset 0x3c
reg [9:0]      SpareEcc3; //offset 0x40
reg [9:0]      SpareEcc4; //offset 0x44
reg [9:0]      SpareEcc5; //offset 0x48
reg [9:0]      SpareEcc6; //offset 0x4c
reg [9:0]      SpareEcc7; //offset 0x50


reg[1:0] LoopCnt;
wire[3:0] LocCnt;

wire SpareLoc;

wire EccEn16;
wire[8:0] DataCnt;
wire Two8BitNand;
wire LsnLoc;

reg  AddrCntBit10_Dly;
reg  AddrCntBit9_Dly;
reg  AddrCntBit8_Dly;
reg  AddrCntBit7_Dly;
wire Ecc512Init;
wire Ecc256Init;
wire Ecc128Init;

wire MEccInit8;
wire MEccInit16;
wire SEccInit;
wire EccInit8;
wire EccInit16;
wire MainEccValid;

wire[23:0]  MainEcc8_H;
//wire[15:0]  SpareEcc8_H;//**3.8
wire[9:0]  SpareEcc8_H;

wire Nand_512 ;
wire Nand_2048;
wire Nand_256 ;
wire Nand_1024;
wire RWState;
wire SpareLoc512;
wire SpareLoc2048;
wire SpareLoc256;
wire SpareLoc1024;

//wire LsnLoc;
//reg[3:0] LocCnt;

wire      Ecc_a_LastLoc;
wire      Ecc_b_LastLoc;

wire      SEccLastLoc;
wire[3:0] LsnLoc_CompValue;
wire[3:0] Ecc_a_CompValue;
wire[3:0] Ecc_b_CompValue;
wire[3:0] SEcc_CompValue;
reg [1:0] LsnCnt;


wire LsnLastLoc;

wire EccEn8_L;
wire EccEn8_H;
wire      SpareEccValid;

assign RWState = CST_RdataIn | CST_WdataIn;

assign AddrCntOut = AddrCnt; // ouput assign

//**3.8
assign SECCSECTOR0={6'b111111,SpareEcc0};  
assign SECCSECTOR1={6'b111111,SpareEcc1};
assign SECCSECTOR2={6'b111111,SpareEcc2};
assign SECCSECTOR3={6'b111111,SpareEcc3};
assign SECCSECTOR4={6'b111111,SpareEcc4};
assign SECCSECTOR5={6'b111111,SpareEcc5};
assign SECCSECTOR6={6'b111111,SpareEcc6};
assign SECCSECTOR7={6'b111111,SpareEcc7};
//**3.8



//******** NAND FLASH Memory ±¸ºÐ ***************
//`ifdef NAND16
    assign Nand_256  = (PageSizeIn==1'b0 && NandWidthIn==1'b1) ? 1'b1 : 1'b0;
    assign Nand_1024 = (PageSizeIn==1'b1 && NandWidthIn==1'b1) ? 1'b1 : 1'b0;
//`endif

assign Nand_512  = (PageSizeIn==1'b0 && NandWidthIn==1'b0) ? 1'b1 : 1'b0;
assign Nand_2048 = (PageSizeIn==1'b1 && NandWidthIn==1'b0) ? 1'b1 : 1'b0;

assign Two8BitNand = (NandWidthIn==1'b0 && IOWidthIn==1'b1) ? 1'b1 : 1'b0;
//-----------------------------------------------------------------------



//********* Ecc Calculation Part Combination Logic **************
assign Ecc512Init = ( (AddrCnt[9]==1'b1 && AddrCntBit9_Dly==1'b0) || 
                      (AddrCnt[9]==1'b0 && AddrCntBit9_Dly==1'b1) ) ? 1'b1 : 1'b0;
assign Ecc256Init = ( (AddrCnt[8]==1'b1 && AddrCntBit8_Dly==1'b0) || 
                      (AddrCnt[8]==1'b0 && AddrCntBit8_Dly==1'b1) ) ? 1'b1 : 1'b0;
assign Ecc128Init = ( (AddrCnt[7]==1'b1 && AddrCntBit7_Dly==1'b0) ||
                      (AddrCnt[7]==1'b0 && AddrCntBit7_Dly==1'b1) ) ? 1'b1 : 1'b0;

assign MEccInit8  = (Ecc512EnIn==1'b1) ? Ecc512Init : Ecc256Init;
assign MEccInit16 = (Ecc512EnIn==1'b1) ? Ecc256Init : Ecc128Init;
assign SEccInit = (SpareLoc==1'b1 && 
                   ((Nand_1024==1'b1 && LocCnt==4'd0) || (Nand_2048==1'b1 && LocCnt==4'd1)) 
                  ) ? 1'b1 : 1'b0;
assign EccInit8 = MEccInit8 | SEccInit | ~RWState;
assign EccInit16 = MEccInit16 | SEccInit | ~RWState;

assign MainEcc8_1  = (Two8BitNand==1'b1) ? MainEcc8_H  : 24'd0;
//assign SpareEcc8_1 = (Two8BitNand==1'b1) ? SpareEcc8_H : 15'd0;
assign SpareEcc8_1 = (Two8BitNand==1'b1) ? SpareEcc8_H : 10'd0;

assign DataCnt = (SpareLoc==1'b1) ? {7'd0,LsnCnt} : AddrCnt[8:0];


assign EccEn8_L = ~NandWidthIn & EccDataEnIn;
assign EccEn8_H = Two8BitNand & EccDataEnIn;
assign EccEn16 = NandWidthIn & EccDataEnIn;

//-----------------------------------------------------------------------

//********* Ecc Register Number **************

assign MainEccValid = (NandWidthIn==1'b0) ? MEccInit8 : MEccInit16;
assign MainRegNum_512 = (NandWidthIn==1'b0) ? {AddrCntBit10_Dly,AddrCntBit9_Dly} : {AddrCntBit9_Dly,AddrCntBit8_Dly};
assign MainRegNum_256 = (NandWidthIn==1'b0) ? {AddrCntBit10_Dly,AddrCntBit9_Dly,AddrCntBit8_Dly} :
                                              { AddrCntBit9_Dly,AddrCntBit8_Dly,AddrCntBit7_Dly};

assign SpareEccValid = (LocCnt==LsnLoc_CompValue) ? 1'b1 : 1'b0;
//-----------------------------------------------------------------------



//********* Ecc Location Part **************
assign LocCnt = (SpareLoc==1'b1 && NandWidthIn==1'b0) ? AddrCnt[3:0] : 
                (SpareLoc==1'b1 && NandWidthIn==1'b1) ? {1'b0,AddrCnt[2:0]} : 4'd0;

assign LsnLoc_CompValue = (Nand_256 ==1'b1) ? 4'd2 :
                          (Nand_1024==1'b1 || Nand_512==1'b1) ? 4'd3 : 4'd5;
assign Ecc_a_CompValue = (Nand_256 ==1'b1) ? 4'd4 :
                         (Nand_1024==1'b1) ? 4'd5 :
                         (Nand_512 ==1'b1) ? 4'd8 : 4'd10;
assign Ecc_b_CompValue = (Nand_256 ==1'b1 || Nand_1024==1'b1) ? 4'd7 :
                                            (Nand_512 ==1'b1) ? 4'd13 : 4'd15;
assign SEcc_CompValue = (Nand_256 ==1'b1) ? 4'd5 :
                        (Nand_1024==1'b1) ? 4'd6 :
                        (Nand_512 ==1'b1) ? 4'd10 : 4'd12;
                    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
assign LsnLastLoc    = (LocCnt==LsnLoc_CompValue) ? 1'b1 : 1'b0;
assign Ecc_a_LastLoc = (LocCnt==Ecc_a_CompValue) ? 1'b1 : 1'b0;
assign Ecc_b_LastLoc = (LocCnt==Ecc_b_CompValue) ? 1'b1 : 1'b0;
assign SEccLastLoc   = (LocCnt==SEcc_CompValue) ? 1'b1 : 1'b0;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*
assign LsnLastLoc  = (Nand_256 ==1'b1 && LocCnt==4'd2) ? 1'b1 :
                     (Nand_1024==1'b1 && LocCnt==4'd3) ? 1'b1 :
                     (Nand_512 ==1'b1 && LocCnt==4'd3) ? 1'b1 : 
                     (Nand_2048==1'b1 && LocCnt==4'd5) ? 1'b1 : 1'b0;
assign SEccLastLoc = (Nand_256 ==1'b1 && LocCnt==4'd5 ) ? 1'b1 :
                     (Nand_1024==1'b1 && LocCnt==4'd6 ) ? 1'b1 :
                     (Nand_512 ==1'b1 && LocCnt==4'd10) ? 1'b1 : 
                     (Nand_2048==1'b1 && LocCnt==4'd12) ? 1'b1 : 1'b0;                
assign Ecc_a_LastLoc = (Nand_256 ==1'b1 && LocCnt==4'd4 ) ? 1'b1 :
                       (Nand_1024==1'b1 && LocCnt==4'd5 ) ? 1'b1 :
                       (Nand_512 ==1'b1 && LocCnt==4'd8 ) ? 1'b1 : 
                       (Nand_2048==1'b1 && LocCnt==4'd10) ? 1'b1 : 1'b0;                
assign Ecc_b_LastLoc = (Nand_256 ==1'b1 && LocCnt==4'd7 ) ? 1'b1 :
                       (Nand_1024==1'b1 && LocCnt==4'd7 ) ? 1'b1 :
                       (Nand_512 ==1'b1 && LocCnt==4'd13) ? 1'b1 : 
                       (Nand_2048==1'b1 && LocCnt==4'd14) ? 1'b1 : 1'b0;                
*/





//`ifdef NAND16
    assign SpareLoc256  = (AddrCnt[8]==1'b1 && Nand_256==1'b1) ? 1'b1 : 1'b0;
    assign SpareLoc1024 = (AddrCnt[10]==1'b1 && Nand_1024==1'b1) ? 1'b1 : 1'b0;
//`endif
assign SpareLoc512  = (AddrCnt[9]==1'b1 && Nand_512==1'b1) ? 1'b1 : 1'b0;
assign SpareLoc2048 = (AddrCnt[11]==1'b1 && Nand_2048==1'b1) ? 1'b1 : 1'b0;

assign SpareLoc = SpareLoc256 | SpareLoc1024 | SpareLoc512 | SpareLoc2048 ;

assign LsnLoc = (Nand_256 ==1'b1 && LocCnt>=4'd0 && LocCnt<=4'd1) ? 1'b1 :
                (Nand_1024==1'b1 && LocCnt>=4'd1 && LocCnt<=4'd2) ? 1'b1 :
                (Nand_512 ==1'b1 && LocCnt>=4'd0 && LocCnt<=4'd2) ? 1'b1 :
                (Nand_2048==1'b1 && LocCnt>=4'd2 && LocCnt<=4'd4) ? 1'b1 : 1'b0;
         
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        LsnCnt<={2{1'b0}};   
    end
    else begin
        if(LsnLoc) begin
            if(EccDataEnIn) LsnCnt<=LsnCnt+1'b1;
        end
        else LsnCnt<=0;
    end
end
//-----------------------------------------------------------------------


// LoopCnt
wire LoopCntMsb;
reg  LoopCntMsb_Dly;
assign LoopCntMsb = (NandWidthIn==1'b0) ? LocCnt[3] : LocCnt[2];

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        LoopCnt<=0;   
        LoopCntMsb_Dly<=0;
    end
    else begin
        LoopCntMsb_Dly<=LoopCntMsb;
        if(PageSizeIn==1'b1) begin // Lage Page(1024,2048page)
            if(LoopCntMsb_Dly==1'b1 && LoopCntMsb==1'b0) LoopCnt<=LoopCnt+1'b1;
            else if(RWState==1'b0) LoopCnt<=0;
        end
    end
end       


always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        AddrCnt<=12'd0;   
    end
    else begin
        if(AddrLoadEnIn) begin
            AddrCnt<=AddrIn;
        end
        else if(RWState==1'b1) begin 
            if(EccDataEnIn) AddrCnt<=AddrCnt+1;
        end
        else AddrCnt<=12'd0;
    end
end

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        AddrCntBit7_Dly <=0;
        AddrCntBit8_Dly <=0;
        AddrCntBit9_Dly <=0;
        AddrCntBit10_Dly<=0;
    end
    else begin
        AddrCntBit7_Dly <=AddrCnt[7];
        AddrCntBit8_Dly <=AddrCnt[8];
        AddrCntBit9_Dly <=AddrCnt[9];
        AddrCntBit10_Dly<=AddrCnt[10];
    end
end

//******************************************
//          ECC Reg Control
//******************************************

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        ECCSECTOR0 <=0; ECCSECTOR1 <=0; ECCSECTOR2 <=0; ECCSECTOR3 <=0;
        ECCSECTOR4 <=0; ECCSECTOR5 <=0; ECCSECTOR6 <=0; ECCSECTOR7 <=0;
        ECCSECTOR8 <=0; ECCSECTOR9 <=0; ECCSECTOR10<=0; ECCSECTOR11<=0;
        ECCSECTOR12<=0; ECCSECTOR13<=0; ECCSECTOR14<=0; ECCSECTOR15<=0;
    end
    else begin
        if(MainEccValid) begin
            if(Ecc512EnIn) begin //512byte ECC
`ifdef NAND16                
                if(NandWidthIn==1'b0) begin //8bit nand
`endif                    
                    case(MainRegNum_512) // synopsys parallel_case
                        2'b00   : begin ECCSECTOR0<=MainEcc8_0; ECCSECTOR4<=MainEcc8_1; end
                        2'b01   : begin ECCSECTOR1<=MainEcc8_0; ECCSECTOR5<=MainEcc8_1; end
                        2'b10   : begin ECCSECTOR2<=MainEcc8_0; ECCSECTOR6<=MainEcc8_1; end
                        default : begin ECCSECTOR3<=MainEcc8_0; ECCSECTOR7<=MainEcc8_1; end
                    endcase 
`ifdef NAND16                
                end
                else begin //16bit nand
                    case(MainRegNum_512) // synopsys parallel_case
                        2'b00   : ECCSECTOR0<=MainEcc16; 
                        2'b01   : ECCSECTOR1<=MainEcc16; 
                        2'b10   : ECCSECTOR2<=MainEcc16; 
                        default : ECCSECTOR3<=MainEcc16; 
                    endcase 
                end
`endif
            end
            else begin // 256byte ECC
`ifdef NAND16                
                if(NandWidthIn==1'b0) begin //8bit nand
`endif                    
                    case(MainRegNum_256) // synopsys parallel_case 
                        3'b000  : begin ECCSECTOR0 <=MainEcc8_0; ECCSECTOR8 <=MainEcc8_1; end
                        3'b001  : begin ECCSECTOR1 <=MainEcc8_0; ECCSECTOR9 <=MainEcc8_1; end
                        3'b010  : begin ECCSECTOR2 <=MainEcc8_0; ECCSECTOR10<=MainEcc8_1; end
                        3'b011  : begin ECCSECTOR3 <=MainEcc8_0; ECCSECTOR11<=MainEcc8_1; end
                        3'b100  : begin ECCSECTOR4 <=MainEcc8_0; ECCSECTOR12<=MainEcc8_1; end
                        3'b101  : begin ECCSECTOR5 <=MainEcc8_0; ECCSECTOR13<=MainEcc8_1; end
                        3'b110  : begin ECCSECTOR6 <=MainEcc8_0; ECCSECTOR14<=MainEcc8_1; end
                        default : begin ECCSECTOR7 <=MainEcc8_0; ECCSECTOR15<=MainEcc8_1; end
                    endcase
`ifdef NAND16                
                end
                else begin //16bit nand
                    case(MainRegNum_256) // synopsys parallel_case 
                        3'b000  : ECCSECTOR0<=MainEcc16; 
                        3'b001  : ECCSECTOR1<=MainEcc16; 
                        3'b010  : ECCSECTOR2<=MainEcc16; 
                        3'b011  : ECCSECTOR3<=MainEcc16; 
                        3'b100  : ECCSECTOR4<=MainEcc16; 
                        3'b101  : ECCSECTOR5<=MainEcc16; 
                        3'b110  : ECCSECTOR6<=MainEcc16; 
                        default : ECCSECTOR7<=MainEcc16; 
                    endcase
                end
`endif
            end
        end
    end
end
// Spare area Ecc Register
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
       SpareEcc0<=0; SpareEcc1<=0; SpareEcc2<=0; SpareEcc3<=0;
       SpareEcc4<=0; SpareEcc5<=0; SpareEcc6<=0; SpareEcc7<=0;
    end
    else begin
        if(SpareEccValid) begin
`ifdef NAND16                
            if(NandWidthIn==1'b0) begin //8bit nand
`endif
                case(LoopCnt) // synopsys parallel_case
                    2'b00   : begin SpareEcc0<=SpareEcc8_0; SpareEcc4<=SpareEcc8_1; end
                    2'b01   : begin SpareEcc1<=SpareEcc8_0; SpareEcc5<=SpareEcc8_1; end
                    2'b10   : begin SpareEcc2<=SpareEcc8_0; SpareEcc6<=SpareEcc8_1; end
                    default : begin SpareEcc3<=SpareEcc8_0; SpareEcc7<=SpareEcc8_1; end
                endcase
`ifdef NAND16            
            end
            else begin //16bit nand
                case(LoopCnt) // synopsys parallel_case
                    2'b00   : SpareEcc0<=SpareEcc16; 
                    2'b01   : SpareEcc1<=SpareEcc16; 
                    2'b10   : SpareEcc2<=SpareEcc16; 
                    default : SpareEcc3<=SpareEcc16; 
                endcase
            end
`endif            
        end
    end
end
/*
// Spare area Ecc Register
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
       SECCSECTOR0<=0; SECCSECTOR1<=0; SECCSECTOR2<=0; SECCSECTOR3<=0;
       SECCSECTOR4<=0; SECCSECTOR5<=0; SECCSECTOR6<=0; SECCSECTOR7<=0;
    end
    else begin
        if(SpareEccValid) begin
`ifdef NAND16                
            if(NandWidthIn==1'b0) begin //8bit nand
`endif
                case(LoopCnt) // synopsys parallel_case
                    2'b00   : begin SECCSECTOR0<=SpareEcc8_0; SECCSECTOR4<=SpareEcc8_1; end
                    2'b01   : begin SECCSECTOR1<=SpareEcc8_0; SECCSECTOR5<=SpareEcc8_1; end
                    2'b10   : begin SECCSECTOR2<=SpareEcc8_0; SECCSECTOR6<=SpareEcc8_1; end
                    default : begin SECCSECTOR3<=SpareEcc8_0; SECCSECTOR7<=SpareEcc8_1; end
                endcase
`ifdef NAND16            
            end
            else begin //16bit nand
                case(LoopCnt) // synopsys parallel_case
                    2'b00   : SECCSECTOR0<=SpareEcc16; 
                    2'b01   : SECCSECTOR1<=SpareEcc16; 
                    2'b10   : SECCSECTOR2<=SpareEcc16; 
                    default : SECCSECTOR3<=SpareEcc16; 
                endcase
            end
`endif            
        end
    end
end
*/


// Auto Ecc Write 
reg[15:0]   EccOut;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        EccOut<=0;   
        BoundaryOut<=0;
    end
    else begin
        if(EccDataEnIn) begin // address cnt enable
`ifdef NAND16            
            if(NandWidthIn==1'b0) begin// 8bit nand
`endif
                BoundaryOut<=0;
                if(PageSizeIn==1'b0) begin//512
                    if(Ecc512EnIn) begin //512Byte Ecc
                        if(LocCnt==4'd5)      EccOut<={ECCSECTOR4[ 7:0 ] ,ECCSECTOR0[ 7:0 ]};
                        else if(LocCnt==4'd6) EccOut<={ECCSECTOR4[15:8 ] ,ECCSECTOR0[15:8 ]};
                        else if(LocCnt==4'd7) EccOut<={ECCSECTOR4[23:16] ,ECCSECTOR0[23:16]};
                        else if(LocCnt==4'd8) EccOut<={SECCSECTOR4[7:0 ] ,SECCSECTOR0[7:0 ]};
                        else if(LocCnt==4'd9) EccOut<={SECCSECTOR4[15:8] ,SECCSECTOR0[15:8]};
                        else EccOut<={12{1'b0}};
                    end
                    else begin //256Byte Ecc
                        if(LocCnt==4'd5)      EccOut<={ECCSECTOR8[ 7:0 ] ,ECCSECTOR0[ 7:0 ]};
                        else if(LocCnt==4'd6) EccOut<={ECCSECTOR8[15:8 ] ,ECCSECTOR0[15:8 ]};
                        else if(LocCnt==4'd7) EccOut<={ECCSECTOR8[23:16] ,ECCSECTOR0[23:16]};
                        else if(LocCnt==4'd8) EccOut<={SECCSECTOR4[7:0 ] ,SECCSECTOR0[7:0 ]};
                        else if(LocCnt==4'd9) EccOut<={SECCSECTOR4[15:8] ,SECCSECTOR0[15:8]};
                        else if(LocCnt==4'd10) EccOut<={ECCSECTOR9[ 7:0 ] ,ECCSECTOR1[ 7:0 ]};
                        else if(LocCnt==4'd11) EccOut<={ECCSECTOR9[15:8 ] ,ECCSECTOR1[15:8 ]};
                        else if(LocCnt==4'd12) EccOut<={ECCSECTOR9[23:16] ,ECCSECTOR1[23:16]};
                        else EccOut<={12{1'b0}};
                    end
                end
                else begin //2048
                    if(Ecc512EnIn) begin //512byte Ecc
                        if(LoopCnt==2'b00 ) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR4[ 7:0 ] ,ECCSECTOR0[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR4[15:8 ] ,ECCSECTOR0[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR4[23:16] ,ECCSECTOR0[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR4[7:0 ] ,SECCSECTOR0[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR4[15:8] ,SECCSECTOR0[15:8]};
                        end 
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR5[ 7:0 ] ,ECCSECTOR1[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR5[15:8 ] ,ECCSECTOR1[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR5[23:16] ,ECCSECTOR1[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR5[7:0 ] ,SECCSECTOR1[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR5[15:8] ,SECCSECTOR1[15:8]};
                        end 
                        else if(LoopCnt==2'b10) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR6[ 7:0 ] ,ECCSECTOR2[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR6[15:8 ] ,ECCSECTOR2[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR6[23:16] ,ECCSECTOR2[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR6[7:0 ] ,SECCSECTOR2[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR6[15:8] ,SECCSECTOR2[15:8]};
                        end 
                        else begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR7[ 7:0 ] ,ECCSECTOR3[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR7[15:8 ] ,ECCSECTOR3[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR7[23:16] ,ECCSECTOR3[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR7[7:0 ] ,SECCSECTOR3[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR7[15:8] ,SECCSECTOR3[15:8]};
                            else EccOut<={12{1'b0}};                        
                        end
                    end
                    else begin //256byte ECC
                        if(LoopCnt==2'b00) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR8[ 7:0 ]  ,ECCSECTOR0[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR8[15:8 ]  ,ECCSECTOR0[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR8[23:16]  ,ECCSECTOR0[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR4[7:0 ]  ,SECCSECTOR0[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR4[15:8]  ,SECCSECTOR0[15:8]};
                            else if(LocCnt==4'd12) EccOut<={ECCSECTOR9[ 7:0 ]  ,ECCSECTOR1[ 7:0 ]};
                            else if(LocCnt==4'd13) EccOut<={ECCSECTOR9[15:8 ]  ,ECCSECTOR1[15:8 ]};
                            else if(LocCnt==4'd14) EccOut<={ECCSECTOR9[23:16]  ,ECCSECTOR1[23:16]};
                            else EccOut<={12{1'b0}};
                        end
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR10[ 7:0 ] ,ECCSECTOR2[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR10[15:8 ] ,ECCSECTOR2[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR10[23:16] ,ECCSECTOR2[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR5[ 7:0 ] ,SECCSECTOR1[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR5[15:8 ] ,SECCSECTOR1[15:8]};
                            else if(LocCnt==4'd12) EccOut<={ECCSECTOR11[ 7:0 ] ,ECCSECTOR3[ 7:0 ]};
                            else if(LocCnt==4'd13) EccOut<={ECCSECTOR11[15:8 ] ,ECCSECTOR3[15:8 ]};
                            else if(LocCnt==4'd14) EccOut<={ECCSECTOR11[23:16] ,ECCSECTOR3[23:16]};
                            else EccOut<={12{1'b0}};
                        end
                        else if(LoopCnt==2'b10) begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR12[ 7:0 ] ,ECCSECTOR4[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR12[15:8 ] ,ECCSECTOR4[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR12[23:16] ,ECCSECTOR4[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR6[ 7:0 ] ,SECCSECTOR2[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR6[15:8 ] ,SECCSECTOR2[15:8]};
                            else if(LocCnt==4'd12) EccOut<={ECCSECTOR13[ 7:0 ] ,ECCSECTOR5[ 7:0 ]};
                            else if(LocCnt==4'd13) EccOut<={ECCSECTOR13[15:8 ] ,ECCSECTOR5[15:8 ]};
                            else if(LocCnt==4'd14) EccOut<={ECCSECTOR13[23:16] ,ECCSECTOR5[23:16]};
                            else EccOut<={12{1'b0}};
                        end
                        else begin
                                 if(LocCnt==4'd7 ) EccOut<={ECCSECTOR14[ 7:0 ] ,ECCSECTOR6[ 7:0 ]};
                            else if(LocCnt==4'd8 ) EccOut<={ECCSECTOR14[15:8 ] ,ECCSECTOR6[15:8 ]};
                            else if(LocCnt==4'd9 ) EccOut<={ECCSECTOR14[23:16] ,ECCSECTOR6[23:16]};
                            else if(LocCnt==4'd10) EccOut<={SECCSECTOR7[ 7:0 ] ,SECCSECTOR3[7:0 ]};
                            else if(LocCnt==4'd11) EccOut<={SECCSECTOR7[15:8 ] ,SECCSECTOR3[15:8]};
                            else if(LocCnt==4'd12) EccOut<={ECCSECTOR15[ 7:0 ] ,ECCSECTOR7[ 7:0 ]};
                            else if(LocCnt==4'd13) EccOut<={ECCSECTOR15[15:8 ] ,ECCSECTOR7[15:8 ]};
                            else if(LocCnt==4'd14) EccOut<={ECCSECTOR15[23:16] ,ECCSECTOR7[23:16]};
                            else EccOut<={12{1'b0}};
                        end
                    end
                end
`ifdef NAND16
            end
            else begin//16bit nand
                if(PageSizeIn==1'b0) begin//256page
                    if(Ecc512EnIn) begin //512byte Ecc
                             if(LocCnt==4'd2) EccOut<={ECCSECTOR0[15:8 ] ,ECCSECTOR0[ 7:0 ]};
                        else if(LocCnt==4'd3) EccOut<={SECCSECTOR0[ 7:0] ,ECCSECTOR0[23:16]};
                        else if(LocCnt==4'd4) EccOut<={8'd0              ,SECCSECTOR0[15:8]};
                        else EccOut<={12{1'b0}};
                    end
                    else begin //256byte Ecc
                             if(LocCnt==4'd2) EccOut<={ECCSECTOR0[15:8 ] ,ECCSECTOR0[ 7:0 ]};
                        else if(LocCnt==4'd3) EccOut<={SECCSECTOR0[ 7:0] ,ECCSECTOR0[23:16]};
                        else if(LocCnt==4'd4) EccOut<={8'd0              ,SECCSECTOR0[15:8]}; 
                        else if(LocCnt==4'd5) EccOut<={ECCSECTOR1[15:8 ] ,ECCSECTOR1[ 7:0 ]};
                        else if(LocCnt==4'd6) EccOut<={8'd0              ,ECCSECTOR1[23:16]};
                        else EccOut<={12{1'b0}};
                    end
                    if(LocCnt==12'd260) BoundaryOut<=1'b1;
                    else BoundaryOut<=1'b0;
                end
                else begin //1024Page
                    if(Ecc512EnIn) begin //512Byte ECC
                        if(LoopCnt==2'b00) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR0[15:8 ] ,ECCSECTOR0[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR0[7:0 ] ,ECCSECTOR0[23:16]};
                            else if(LocCnt==4'd5) EccOut<={8'd0              ,SECCSECTOR0[15:8]};
                            else EccOut<={12{1'b0}};
                        end 
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR1[15:8 ] ,ECCSECTOR1[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR1[7:0 ] ,ECCSECTOR1[23:16]};
                            else if(LocCnt==4'd5) EccOut<={8'd0              ,SECCSECTOR1[15:8]};
                            else EccOut<={12{1'b0}};
                        end
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR2[15:8 ] ,ECCSECTOR2[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR2[7:0 ] ,ECCSECTOR2[23:16]};
                            else if(LocCnt==4'd5) EccOut<={8'd0              ,SECCSECTOR2[15:8]};
                            else EccOut<={12{1'b0}};
                        end
                        else begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR3[15:8 ] ,ECCSECTOR3[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR3[7:0 ] ,ECCSECTOR3[23:16]};
                            else if(LocCnt==4'd5) EccOut<={8'd0              ,SECCSECTOR3[15:8]};
                            else EccOut<={12{1'b0}};
                        end
                        if(LocCnt==4'd5) BoundaryOut<=1'b1;
                        else BoundaryOut<=1'b0;
                    end
                    else begin // 256byte ECC
                        if(LoopCnt==2'b00) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR0[15:8 ] ,ECCSECTOR0[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR0[7:0 ] ,ECCSECTOR0[23:16]};
                            else if(LocCnt==4'd5) EccOut<={ECCSECTOR1[ 7:0 ] ,SECCSECTOR0[15:8]};
                            else if(LocCnt==4'd6) EccOut<={ECCSECTOR1[23:16] ,ECCSECTOR1[15:8 ]};
                            else EccOut<={12{1'b0}};
                        end
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR2[15:8 ] ,ECCSECTOR2[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR1[7:0 ] ,ECCSECTOR2[23:16]};
                            else if(LocCnt==4'd5) EccOut<={ECCSECTOR3[ 7:0 ] ,SECCSECTOR1[15:8]};
                            else if(LocCnt==4'd6) EccOut<={ECCSECTOR3[23:16] ,ECCSECTOR3[15:8 ]};
                            else EccOut<={12{1'b0}};
                        end
                        else if(LoopCnt==2'b01) begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR4[15:8 ] ,ECCSECTOR4[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR2[7:0 ] ,ECCSECTOR4[23:16]};
                            else if(LocCnt==4'd5) EccOut<={ECCSECTOR5[ 7:0 ] ,SECCSECTOR2[15:8]};
                            else if(LocCnt==4'd6) EccOut<={ECCSECTOR5[23:16] ,ECCSECTOR5[15:8 ]};
                            else EccOut<={12{1'b0}};
                        end
                        else begin
                                 if(LocCnt==4'd3) EccOut<={ECCSECTOR6[15:8 ] ,ECCSECTOR6[ 7:0 ]};
                            else if(LocCnt==4'd4) EccOut<={SECCSECTOR3[7:0 ] ,ECCSECTOR6[23:16]};
                            else if(LocCnt==4'd5) EccOut<={ECCSECTOR7[ 7:0 ] ,SECCSECTOR3[15:8]};
                            else if(LocCnt==4'd6) EccOut<={ECCSECTOR7[23:16] ,ECCSECTOR7[15:8 ]};
                            else EccOut<={12{1'b0}};
                        end
                    end
                end
            end
`endif
        end
    end
end

//-----------------------------------------------------------------

//AutoEccWrite enable signal generate
reg AutoEccWrEnOut;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        AutoEccWrEnOut<=0;   
    end
    else begin
        if(EccDataEnIn==1'b1 && AutoEccWr==1'b1 && CST_WdataIn==1'b1 && SpareLoc==1'b1) begin
`ifdef NAND16            
           if(NandWidthIn==1'b0) begin//8bit nand
`endif                
                case({PageSizeIn,Ecc512EnIn})
                    2'b00   : begin //512 page ,256Ecc
                        if(4'd4<LocCnt && LocCnt<4'd13) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    2'b01   : begin //512 page ,512Ecc
                        if(4'd4<LocCnt && LocCnt<4'd10) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    2'b10   : begin //2048 page,256Ecc
                        if(4'd6<LocCnt && LocCnt<4'd15) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    default : begin //2048 page,512Ecc
                        if(4'd6<LocCnt && LocCnt<4'd12) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                endcase
`ifdef NAND16            
            end
            else begin //16bit nand
                case({PageSizeIn,Ecc512EnIn})
                    2'b00   : begin //256 page ,256Ecc
                        if(4'd1<LocCnt && LocCnt<4'd7) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    2'b01   : begin //256 page ,512Ecc
                        if(4'd1<LocCnt && LocCnt<4'd5) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    2'b10   : begin //1024 page,256Ecc
                        if(4'd2<LocCnt && LocCnt<4'd7) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                    default : begin //1024 page,512Ecc
                        if(4'd2<LocCnt && LocCnt<4'd6) AutoEccWrEnOut<=1'b1;
                        else AutoEccWrEnOut<=1'b0;
                    end
                endcase
            end
`endif            
        end
        else if(SpareLoc==1'b0) AutoEccWrEnOut<=1'b0;
    end
end



    NFEcc8 U0Ecc8(
        .Clk        (Clk            ),    
        .nRst       (nRst           ),
        .DCntIn     (DataCnt        ),
        .EccRstIn   (EccRstIn       ),
        .EccEnIn    (EccEn8_L      ),
        .Ecc512EnIn (Ecc512EnIn     ),
        .EccDataIn  (EccDataIn[7:0] ),
        .EccInitIn  (EccInit8       ),
        .MainEccOut (MainEcc8_0     ),
        .SpareEccOut(SpareEcc8_0    ));

    NFEcc8 U1Ecc8(
        .Clk        (Clk            ),    
        .nRst       (nRst           ),
        .DCntIn     (DataCnt        ),
        .EccRstIn   (EccRstIn       ),
        .EccEnIn    (EccEn8_H      ),
        .Ecc512EnIn (Ecc512EnIn     ),
        .EccDataIn  (EccDataIn[15:8]),
        .EccInitIn  (EccInit8       ),
        .MainEccOut (MainEcc8_H     ),
        .SpareEccOut(SpareEcc8_H    ));

    `ifdef NAND16
    NFEcc16 U1Ecc16(
        .Clk        (Clk            ),    
        .nRst       (nRst           ),
        .DCntIn     (DataCnt[7:0]   ),
        .EccRstIn   (EccRstIn       ),
        .EccEnIn    (EccEn16        ),
        .Ecc512EnIn (Ecc512EnIn     ),
        .EccDataIn  (EccDataIn      ),
        .EccInitIn  (EccInit16      ),
        .MainEccOut (MainEcc16      ),
        .SpareEccOut(SpareEcc16     ));
    `endif

endmodule
