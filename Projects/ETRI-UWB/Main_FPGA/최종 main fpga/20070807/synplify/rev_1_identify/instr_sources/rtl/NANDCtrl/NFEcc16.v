//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Ecc Calculation
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFEcc16(
    Clk,
    nRst,
    DCntIn,
    EccRstIn,
    EccEnIn,
    Ecc512EnIn,
    EccDataIn,
    EccInitIn,
    MainEccOut,
    SpareEccOut);

        
input           Clk;    
input           nRst;
input [ 7:0]    DCntIn;
input           EccRstIn;
input           EccEnIn;
input           Ecc512EnIn;
input [15:0]    EccDataIn;
input           EccInitIn;

output[23:0]    MainEccOut;
//output[15:0]    SpareEccOut;//**3.8
output[9:0]    SpareEccOut;

reg     Parity1_0   , Parity1_1   ;
reg     Parity2_0   , Parity2_1   ;
reg     Parity4_0   , Parity4_1   ;
reg     Parity8_0   , Parity8_1   ;
reg     Parity16_0  , Parity16_1  ;
reg     Parity32_0  , Parity32_1  ;
reg     Parity64_0  , Parity64_1  ;
reg     Parity128_0 , Parity128_1 ;
reg     Parity256_0 , Parity256_1 ;
reg     Parity512_0 , Parity512_1 ;
reg     Parity1024_0, Parity1024_1;
reg     Parity2048_0, Parity2048_1;

wire[7:0]   Ecc0;
wire[7:0]   Ecc1;
wire[7:0]   Ecc2;

wire[7:0]   SEcc0;
//wire[7:0]   SEcc1;//**3.8
wire[1:0]   SEcc1;

//wire[8:0]   DCnt;

wire bit15;
wire bit14;
wire bit13;
wire bit12;
wire bit11;
wire bit10;
wire bit9 ;
wire bit8 ;

wire bit7 ;
wire bit6 ;
wire bit5 ;
wire bit4 ;
wire bit3 ;
wire bit2 ;
wire bit1 ;
wire bit0 ;

assign  bit15 = EccDataIn[15];
assign  bit14 = EccDataIn[14];
assign  bit13 = EccDataIn[13];
assign  bit12 = EccDataIn[12];
assign  bit11 = EccDataIn[11];
assign  bit10 = EccDataIn[10];
assign  bit9  = EccDataIn[ 9];
assign  bit8  = EccDataIn[ 8];

assign  bit7 = EccDataIn[7];
assign  bit6 = EccDataIn[6];
assign  bit5 = EccDataIn[5];
assign  bit4 = EccDataIn[4];
assign  bit3 = EccDataIn[3];
assign  bit2 = EccDataIn[2];
assign  bit1 = EccDataIn[1];
assign  bit0 = EccDataIn[0];

wire    LineParity;
assign  LineParity = bit15 ^ bit14 ^ bit13 ^ bit12 ^ bit11 ^ bit10 ^ bit9 ^ bit8 ^
                     bit7  ^ bit6  ^ bit5  ^ bit4  ^ bit3  ^ bit2  ^ bit1 ^ bit0 ;

//assign  DCnt = DCntIn;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        Parity1_0   <=1'b1;   Parity1_1   <=1'b1;    
        Parity2_0   <=1'b1;   Parity2_1   <=1'b1;
        Parity4_0   <=1'b1;   Parity4_1   <=1'b1;
        Parity8_0   <=1'b1;   Parity8_1   <=1'b1;
        Parity16_0  <=1'b1;   Parity16_1  <=1'b1;    
        Parity32_0  <=1'b1;   Parity32_1  <=1'b1;
        Parity64_0  <=1'b1;   Parity64_1  <=1'b1;
        Parity128_0 <=1'b1;   Parity128_1 <=1'b1;
        Parity256_0 <=1'b1;   Parity256_1 <=1'b1;    
        Parity512_0 <=1'b1;   Parity512_1 <=1'b1;
        Parity1024_0<=1'b1;   Parity1024_1<=1'b1;
        Parity2048_0<=1'b1;   Parity2048_1<=1'b1;
    end
    else begin
        if(EccRstIn || EccInitIn ) begin
            Parity1_0   <=1'b1;   Parity1_1   <=1'b1;    
            Parity2_0   <=1'b1;   Parity2_1   <=1'b1;
            Parity4_0   <=1'b1;   Parity4_1   <=1'b1;
            Parity8_0   <=1'b1;   Parity8_1   <=1'b1;
            Parity16_0  <=1'b1;   Parity16_1  <=1'b1;    
            Parity32_0  <=1'b1;   Parity32_1  <=1'b1;
            Parity64_0  <=1'b1;   Parity64_1  <=1'b1;
            Parity128_0 <=1'b1;   Parity128_1 <=1'b1;
            Parity256_0 <=1'b1;   Parity256_1 <=1'b1;    
            Parity512_0 <=1'b1;   Parity512_1 <=1'b1;
            Parity1024_0<=1'b1;   Parity1024_1<=1'b1;
            Parity2048_0<=1'b1;   Parity2048_1<=1'b1;
        end
        else if(EccEnIn) begin
            // column parity(bit position)
            Parity1_0    <= bit0 ^ bit2 ^ bit4  ^ bit6  ^ bit8  ^ bit10 ^ bit12 ^ bit14 ^ Parity1_0;
            Parity1_1    <= bit1 ^ bit3 ^ bit5  ^ bit7  ^ bit9  ^ bit11 ^ bit13 ^ bit15 ^ Parity1_1;
            Parity2_0    <= bit0 ^ bit1 ^ bit4  ^ bit5  ^ bit8  ^ bit9  ^ bit12 ^ bit13 ^ Parity2_0;
            Parity2_1    <= bit2 ^ bit3 ^ bit6  ^ bit7  ^ bit10 ^ bit11 ^ bit14 ^ bit15 ^ Parity2_1;
            Parity4_0    <= bit0 ^ bit1 ^ bit2  ^ bit3  ^ bit8  ^ bit9  ^ bit10 ^ bit11 ^ Parity4_0;
            Parity4_1    <= bit4 ^ bit5 ^ bit6  ^ bit7  ^ bit12 ^ bit13 ^ bit14 ^ bit15 ^ Parity4_1;
            Parity8_0    <= bit0 ^ bit1 ^ bit2  ^ bit3  ^ bit4  ^ bit5  ^ bit6  ^ bit7  ^ Parity8_0;
            Parity8_1    <= bit8 ^ bit9 ^ bit10 ^ bit11 ^ bit12 ^ bit13 ^ bit14 ^ bit15 ^ Parity8_1;

            Parity16_0   <= Parity16_0   ^ (LineParity & ~DCntIn[0]);
            Parity16_1   <= Parity16_1   ^ (LineParity &  DCntIn[0]);
            Parity32_0   <= Parity32_0   ^ (LineParity & ~DCntIn[1]);
            Parity32_1   <= Parity32_1   ^ (LineParity &  DCntIn[1]);
            Parity64_0   <= Parity64_0   ^ (LineParity & ~DCntIn[2]);
            Parity64_1   <= Parity64_1   ^ (LineParity &  DCntIn[2]);
            Parity128_0  <= Parity128_0  ^ (LineParity & ~DCntIn[3]);
            Parity128_1  <= Parity128_1  ^ (LineParity &  DCntIn[3]);
            Parity256_0  <= Parity256_0  ^ (LineParity & ~DCntIn[4]);
            Parity256_1  <= Parity256_1  ^ (LineParity &  DCntIn[4]);
            Parity512_0  <= Parity512_0  ^ (LineParity & ~DCntIn[5]);
            Parity512_1  <= Parity512_1  ^ (LineParity &  DCntIn[5]);
            Parity1024_0 <= Parity1024_0 ^ (LineParity & ~DCntIn[6]);
            Parity1024_1 <= Parity1024_1 ^ (LineParity &  DCntIn[6]);
            Parity2048_0 <= Parity2048_0 ^ (LineParity & ~DCntIn[7]);
            Parity2048_1 <= Parity2048_1 ^ (LineParity &  DCntIn[7]);
        end
    end
end

assign Ecc2 = {Parity8_1   ,Parity8_0   ,Parity4_1   ,Parity4_0   ,Parity2_1  ,Parity2_0  ,Parity1_1  ,Parity1_0  }; //16bit nand
assign Ecc1 = (Ecc512EnIn) ? 
                {Parity2048_1,Parity2048_0,Parity1024_1,Parity1024_0,Parity512_1,Parity512_0,Parity256_1,Parity256_0} : //16bit nand
                {        1'b1,        1'b1,Parity1024_1,Parity1024_0,Parity512_1,Parity512_0,Parity256_1,Parity256_0}; //16bit nand
assign Ecc0 = {Parity128_1 ,Parity128_0 ,Parity64_1  ,Parity64_0  ,Parity32_1 ,Parity32_0 ,Parity16_1 ,Parity16_0 }; //16bit nand

assign MainEccOut = {Ecc2,Ecc1,Ecc0}; 


//assign SEcc1 = {6'b111111 ,Parity8_1 ,Parity8_0  }; //16bit nand//**3.8
assign SEcc1 = {Parity8_1 ,Parity8_0  }; //16bit nand
assign SEcc0 = {Parity4_1 ,Parity4_0 ,Parity2_1 ,Parity2_0, Parity1_1 ,Parity1_0 ,Parity16_1 ,Parity16_0 }; //16bit nand

assign SpareEccOut = {SEcc1,SEcc0}; 


endmodule

