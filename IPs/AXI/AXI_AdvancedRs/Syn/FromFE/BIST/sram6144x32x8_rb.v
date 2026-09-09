 // ** FILE : SynTest SRAM BIST CONTROLLER file
 // ** NAME : sram6144x32x8_rb.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Wed Jul 19 01:22:32 2000


`timescale 1ns / 10ps

 module ST_MAG_sram6144x32x8 ( Tclk , BistMode , S0 , S1 ,
 S2 , S3 , S4 ) ;

 input Tclk ;
 input BistMode ;
 output [ 12 : 0 ] S0 ;
 input S1 ;
 output S2 ;
 output S3 ;
 input S4 ;

 reg [ 12 : 0 ] S5 ;
 reg [ 12 : 0 ] S6 ;

 assign S0 = S5 ;

 always @ ( negedge Tclk or negedge BistMode )
 begin
 if ( BistMode == 1'b0 ) begin
 S5 <= # 1 13'b0000000000000 ;
 end
 else begin
 S5 <= # 1 S6 ;
 end

 end

 always @ ( S4 or S1 or S5 )
 begin
 if ( S4 == 1'b1 ) begin
 if ( S1 == 1'b1 ) begin
 if ( S5 == 13'b1011111111111 )
 S6 = 13'b0000000000000 ;
 else
 S6 = S5 + 1 ;
 end
 else begin
 if ( S5 == 13'b0000000000000 )
 S6 = 13'b1011111111111 ;
 else
 S6 = S5 - 1 ;
 end
 end
 else
 S6 = S5 ;
 end

 assign S2 = ( S5 == 13'b1011111111111 ) ;
 assign S3 = ( S5 == 13'b0000000000000 ) ;

 endmodule

 module ST_MPG_sram6144x32x8 ( S7 , S8 , S9 ) ;
 output [ 31 : 0 ] S7 ;
 input S8 ;
 input S9 ;

 reg [ 31 : 0 ] S10 ;
 wire [ 1 : 0 ] S11 ;

 assign S7 = S10 ;
 assign S11 = { S8 , S9 } ;

 always @ ( S11 )
 case ( S11 )
 2'b00 : S10 = 32'h00000000 ;
 2'b01 : S10 = 32'hffffffff ;
 2'b10 : S10 = 32'h55555555 ;
 2'b11 : S10 = 32'haaaaaaaa ;
 default : S10 = 32'h00000000 ;
 endcase

 endmodule

 module ST_MAL_sram6144x32x8 ( Tclk , BistMode , BistFail , S12 , S13 ,
 S14 , ErrMap ) ;
 input Tclk ;
 input BistMode ;
 output BistFail ;
 input S12 ;
 input [ 31 : 0 ] S13 ;
 input [ 31 : 0 ] S14 ;
 output ErrMap ;


 reg S15 ;
 reg S16 ;
 reg S17 ;

 assign ErrMap = S16 ;
 assign BistFail = S17 ;

 always @ ( S13 or S14 )
 begin
 if ( S13 == S14 )
 S15 = 1'b0 ;
 else
 S15 = 1'b1 ;

 end

 always @ ( negedge Tclk or negedge BistMode )
 begin
 if ( BistMode == 1'b0 ) begin
 S16 <= # 1 1'b0 ;
 S17 <= # 1 1'b0 ;
 end
 else begin
 if ( S12 == 1'b1 )
 S16 <= # 1 S15 ;
 else
 S16 <= # 1 1'b0 ;

 if ( S16 == 1'b1 )
 S17 <= # 1 1'b1 ;
 end
 end

 endmodule

 module ST_MTC_sram6144x32x8 ( Tclk , S18 , S19 , S20 , S4 ,
 S2 , S3 , S1 , S8 ,
 S9 , BistMode , S12 , Finish ) ;

 input Tclk ;
 input BistMode ;
 output S18 ;
 output [ 3 : 0 ] S19 ;
 output S20 ;
 output S4 ;
 input S2 ;
 input S3 ;
 output S1 ;
 output S8 ;
 output S9 ;
 output S12 ;
 output Finish ;

 parameter
 S21 = 4'b0000 ,
 S22 = 4'b0001 ,
 S23 = 4'b0010 ,
 S24 = 4'b0011 ,
 S25 = 4'b0100 ,
 S26 = 4'b0101 ,
 S27 = 4'b0110 ,
 S28 = 4'b0111 ,
 S29 = 4'b1000 ,
 S30 = 4'b1001 ,
 S31 = 4'b1010 ,
 S32 = 4'b1011 ,
 S33 = 4'b1100 ,
 S34 = 4'b1101 ,
 S35 = 4'b1110 ,
 S36 = 4'b1111 ;

 reg [ 3 : 0 ] State , NextState ;

 reg S37 ;
 wire S38 ;
 reg S4 ;
 reg S1 ;
 reg S12 ;
 reg S9 ;
 reg Finish ;
 reg S39 ;
 reg S40 ;
 reg S41 ;

 always @ ( negedge Tclk or negedge BistMode )
 begin
 if ( BistMode == 1'b0 ) begin
 State <= # 1 S21 ;
 end
 else begin
 State <= # 1 NextState ;
 end
 end

 assign S8 = S37 ;
 assign S38 = S37 ;
 assign S18 = 1'b0 ;
 assign S19 = { ~ S40 , ~ S40 , ~ S40 , ~ S40 } ;
 assign S20 = ~ S41 ;

 always @ ( negedge Tclk or negedge BistMode )
 begin
 if ( BistMode == 1'b0 ) begin
 Finish <= # 1 1'b0 ;
 S37 <= # 1 1'b0 ;
 end
 else begin
 Finish <= # 1 S39 ;
 if ( State == S35 )
 S37 <= # 1 ~ S37 ;
 else
 S37 <= # 1 S37 ;
 end
 end

 always @ ( S2 or S3 or State or S38 )
 begin
 case ( State )

 S21 : begin
 NextState = S22 ;
 S4 = 1'b0 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S22 : begin
 NextState = ( S2 ) ? S23 : S22 ;
 S4 = 1'b1 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S23 : begin
 NextState = S24 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S24 : begin
 NextState = S25 ;
 S4 = 1'b0 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S25 : begin
 NextState = ( S2 ) ? S26 : S23 ;
 S4 = 1'b1 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S26 : begin
 NextState = S27 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S27 : begin
 NextState = S28 ;
 S4 = 1'b0 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S28 : begin
 NextState = ( S2 ) ? S29 : S26 ;
 S4 = ~ S2 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S29 : begin
 NextState = S30 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S30 : begin
 NextState = S31 ;
 S4 = 1'b0 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S31 : begin
 NextState = ( S3 ) ? S32 : S29 ;
 S4 = 1'b1 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S32 : begin
 NextState = S33 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S33 : begin
 NextState = S34 ;
 S4 = 1'b0 ;
 S40 = 1'b1 ;
 S41 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S34 : begin
 NextState = ( S3 ) ? S35 : S32 ;
 S4 = ~ S3 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S39 = 1'b0 ;
 end
 S35 : begin
 NextState = ( S38 ) ? S36 : S22 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 S36 : begin
 NextState = S36 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S39 = 1'b1 ;
 end
 default : begin
 NextState = S21 ;
 S4 = 1'b0 ;
 S40 = 1'b0 ;
 S41 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S39 = 1'b0 ;
 end
 endcase
 end

 endmodule

 module BistCtrl_sram6144x32x8 ( Tclk , BistMode , mem_ctrl , Q_i , bist_ctrl ,
 BistFail , ErrMap , Finish ) ;

 input Tclk ;
 input BistMode ;
 output [ 5 : 0 ] mem_ctrl ;
 input [ 31 : 0 ] Q_i ;
 output [ 45 : 0 ] bist_ctrl ;
 output BistFail ;
 output ErrMap ;
 output Finish ;

 wire [ 3 : 0 ] S42 ;
 wire [ 12 : 0 ] BIST_A ;
 wire [ 31 : 0 ] BIST_D ;
 wire S43 ;
 wire S44 ;
 wire S45 ;
 wire S46 ;
 wire S47 ;
 wire S48 ;
 wire S49 ;

 assign bist_ctrl [ 12 : 0 ] = BIST_A ;
 assign bist_ctrl [ 44 : 13 ] = BIST_D ;
 assign bist_ctrl [ 45 ] = BistMode ;
 assign mem_ctrl [ 3 : 0 ] = S42 ;

 ST_MAG_sram6144x32x8 S50 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .S0 ( BIST_A ) ,
 .S1 ( S43 ) ,
 .S2 ( S47 ) ,
 .S3 ( S48 ) ,
 .S4 ( S46 )
 ) ;

 ST_MPG_sram6144x32x8 ST_MPG_i0 (
 .S7 ( BIST_D ) ,
 .S8 ( S44 ) ,
 .S9 ( S45 )
 ) ;

 ST_MAL_sram6144x32x8 ST_MAL_i0 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .BistFail ( BistFail ) ,
 .S12 ( S49 ) ,
 .S13 ( BIST_D ) ,
 .S14 ( Q_i ) ,
 .ErrMap ( ErrMap )
 ) ;

 ST_MTC_sram6144x32x8 S51 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .S18 ( mem_ctrl [ 5 ] ) ,
 .S20 ( mem_ctrl [ 4 ] ) ,
 .S19 ( S42 ) ,
 .S4 ( S46 ) ,
 .S2 ( S47 ) ,
 .S3 ( S48 ) ,
 .S1 ( S43 ) ,
 .S8 ( S44 ) ,
 .S9 ( S45 ) ,
 .S12 ( S49 ) ,
 .Finish ( Finish )
 ) ;

 endmodule

