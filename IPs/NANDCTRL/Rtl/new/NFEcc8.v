//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Ecc Calculation
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFEcc8(
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
input [ 8:0]    DCntIn;
input           EccRstIn;
input           EccEnIn;
input           Ecc512EnIn;
input [ 7:0]    EccDataIn;
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

wire bit7;
wire bit6;
wire bit5;
wire bit4;
wire bit3;
wire bit2;
wire bit1;
wire bit0;

assign  bit7 = EccDataIn[7];
assign  bit6 = EccDataIn[6];
assign  bit5 = EccDataIn[5];
assign  bit4 = EccDataIn[4];
assign  bit3 = EccDataIn[3];
assign  bit2 = EccDataIn[2];
assign  bit1 = EccDataIn[1];
assign  bit0 = EccDataIn[0];

wire    LineParity;
assign  LineParity = bit7 ^ bit6 ^ bit5 ^ bit4 ^ bit3 ^ bit2 ^ bit1 ^ bit0;
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
            Parity1_0    <= bit0 ^ bit2 ^ bit4 ^ bit6 ^ Parity1_0 ;
            Parity1_1    <= bit1 ^ bit3 ^ bit5 ^ bit7 ^ Parity1_1 ;
            Parity2_0    <= bit0 ^ bit1 ^ bit4 ^ bit5 ^ Parity2_0 ;
            Parity2_1    <= bit2 ^ bit3 ^ bit6 ^ bit7 ^ Parity2_1 ;
            Parity4_0    <= bit0 ^ bit1 ^ bit2 ^ bit3 ^ Parity4_0 ;
            Parity4_1    <= bit4 ^ bit5 ^ bit6 ^ bit7 ^ Parity4_1 ;

            // LineParity Parity (byte position)
            Parity8_0    <= Parity8_0    ^ (LineParity & ~DCntIn[0]);
            Parity8_1    <= Parity8_1    ^ (LineParity &  DCntIn[0]);
            Parity16_0   <= Parity16_0   ^ (LineParity & ~DCntIn[1]);
            Parity16_1   <= Parity16_1   ^ (LineParity &  DCntIn[1]);
            Parity32_0   <= Parity32_0   ^ (LineParity & ~DCntIn[2]);
            Parity32_1   <= Parity32_1   ^ (LineParity &  DCntIn[2]);
            Parity64_0   <= Parity64_0   ^ (LineParity & ~DCntIn[3]);
            Parity64_1   <= Parity64_1   ^ (LineParity &  DCntIn[3]);
            Parity128_0  <= Parity128_0  ^ (LineParity & ~DCntIn[4]);
            Parity128_1  <= Parity128_1  ^ (LineParity &  DCntIn[4]);
            Parity256_0  <= Parity256_0  ^ (LineParity & ~DCntIn[5]);
            Parity256_1  <= Parity256_1  ^ (LineParity &  DCntIn[5]);
            Parity512_0  <= Parity512_0  ^ (LineParity & ~DCntIn[6]);
            Parity512_1  <= Parity512_1  ^ (LineParity &  DCntIn[6]);
            Parity1024_0 <= Parity1024_0 ^ (LineParity & ~DCntIn[7]);
            Parity1024_1 <= Parity1024_1 ^ (LineParity &  DCntIn[7]);
            Parity2048_0 <= Parity2048_0 ^ (LineParity & ~DCntIn[8]);
            Parity2048_1 <= Parity2048_1 ^ (LineParity &  DCntIn[8]);
        end
    end
end

assign Ecc2 =(Ecc512EnIn==1'b1) ?
                    {Parity4_1   ,Parity4_0   ,Parity2_1  ,Parity2_0  ,Parity1_1  ,Parity1_0  ,Parity2048_1,Parity2048_0} ://512Ecc
                    {Parity4_1   ,Parity4_0   ,Parity2_1  ,Parity2_0  ,Parity1_1  ,Parity1_0  ,1'b1        ,1'b1        } ;//256Ecc
assign Ecc1 ={Parity1024_1,Parity1024_0,Parity512_1 ,Parity512_0 ,Parity256_1,Parity256_0,Parity128_1,Parity128_0};//8bit nand
assign Ecc0 ={Parity64_1  ,Parity64_0  ,Parity32_1  ,Parity32_0  ,Parity16_1 ,Parity16_0 ,Parity8_1  ,Parity8_0  };//8bit nand

assign MainEccOut = {Ecc2,Ecc1,Ecc0}; 


//assign SEcc1 = {6'b111111 ,Parity4_1 ,Parity4_0  }; //8bit nand
assign SEcc1 = {Parity4_1 ,Parity4_0  }; //8bit nand
assign SEcc0 = {Parity2_1 ,Parity2_0 ,Parity1_1 ,Parity1_0, Parity16_1 ,Parity16_0 ,Parity8_1 ,Parity8_0 }; //8bit nand

assign SpareEccOut = {SEcc1,SEcc0}; 


endmodule
