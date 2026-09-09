 // ** FILE : SynTest SRAM BIST CONTROLLER file
 // ** NAME : SPSRAM256X8_rb.v
 // ** TOOL : srambist V1.2.0 r01 (05/30/01 09:35:47)
 // ** TIME : Tue Jul  3 15:05:48 2001


`timescale 1ns / 10ps

 module ST_MAG_SPSRAM256X8 ( Tclk , BistMode , S0 , S1 , S2 ,
 S3 , S4 ) ;

 input Tclk ;
 input BistMode ;
 output [ 7 : 0 ] S0 ;
 input S1 ;
 output S2 ;
 output S3 ;
 input S4 ;

 reg [ 7 : 0 ] S5 ;
 reg [ 7 : 0 ] S6 ;

 assign S0 = S5 ;

 always @ ( negedge Tclk )
 begin
 if ( BistMode == 1'b0 ) begin
 S5 <= # 1 8'b00000000 ;
 end
 else begin
 S5 <= # 1 S6 ;
 end

 end

 always @ ( S4 or S1 or S5 )
 begin
 if ( S4 == 1'b1 ) begin
 if ( S1 == 1'b1 ) begin
 S6 = S5 + 1 ;
 end
 else begin
 S6 = S5 - 1 ;
 end
 end
 else
 S6 = S5 ;
 end

 assign S2 = ( S5 == 8'b11111111 ) ;
 assign S3 = ( S5 == 8'b00000000 ) ;

 endmodule

 module ST_MPG_SPSRAM256X8 ( S7 , S8 , S9 ) ;
 output [ 7 : 0 ] S7 ;
 input S8 ;
 input S9 ;

 reg [ 7 : 0 ] S10 ;
 wire [ 1 : 0 ] S11 ;

 assign S7 = S10 ;
 assign S11 = { S8 , S9 } ;

 always @ ( S11 )
 case ( S11 )
 2'b00 : S10 = 8'h00 ;
 2'b01 : S10 = 8'hff ;
 2'b10 : S10 = 8'h55 ;
 2'b11 : S10 = 8'haa ;
 default : S10 = 8'h00 ;
 endcase

 endmodule

 module ST_MAL_SPSRAM256X8 ( Tclk , BistMode , BistFail , S12 , S13 ,
 S14 , ErrMap ) ;
 input Tclk ;
 input BistMode ;
 output BistFail ;
 input S12 ;
 input [ 7 : 0 ] S13 ;
 input [ 7 : 0 ] S14 ;
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

 always @ ( negedge Tclk )
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

 module ST_MTC_SPSRAM256X8 ( Tclk , S18 , S19 , S4 , S2 ,
 S3 , S1 , S8 , S9 ,
 BistMode , S12 , Finish ) ;

 input Tclk ;
 input BistMode ;
 output S18 ;
 output S19 ;
 output S4 ;
 input S2 ;
 input S3 ;
 output S1 ;
 output S8 ;
 output S9 ;
 output S12 ;
 output Finish ;

 parameter
 S20 = 4'b0000 ,
 S21 = 4'b0001 ,
 S22 = 4'b0010 ,
 S23 = 4'b0011 ,
 S24 = 4'b0100 ,
 S25 = 4'b0101 ,
 S26 = 4'b0110 ,
 S27 = 4'b0111 ,
 S28 = 4'b1000 ,
 S29 = 4'b1001 ,
 S30 = 4'b1010 ,
 S31 = 4'b1011 ,
 S32 = 4'b1100 ,
 S33 = 4'b1101 ,
 S34 = 4'b1110 ,
 S35 = 4'b1111 ;

 reg [ 3 : 0 ] State , NextState ;

 reg S36 ;
 wire S37 ;
 reg S4 ;
 reg S1 ;
 reg S12 ;
 reg S9 ;
 reg Finish ;
 reg S38 ;
 reg S39 ;

 always @ ( negedge Tclk )
 begin
 if ( BistMode == 1'b0 ) begin
 State <= # 1 S20 ;
 end
 else begin
 State <= # 1 NextState ;
 end
 end

 assign S8 = S36 ;
 assign S37 = S36 ;
 assign S18 = 1'b0 ;
 assign S19 = ~ S39 ;

 always @ ( negedge Tclk )
 begin
 if ( BistMode == 1'b0 ) begin
 Finish <= # 1 1'b0 ;
 S36 <= # 1 1'b0 ;
 end
 else begin
 Finish <= # 1 S38 ;
 if ( State == S34 )
 S36 <= # 1 ~ S36 ;
 else
 S36 <= # 1 S36 ;
 end
 end

 always @ ( S2 or S3 or State or S37 )
 begin
 case ( State )

 S20 : begin
 NextState = S21 ;
 S4 = 1'b0 ;
 S39 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S21 : begin
 NextState = ( S2 ) ? S22 : S21 ;
 S4 = 1'b1 ;
 S39 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S22 : begin
 NextState = S23 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S23 : begin
 NextState = S24 ;
 S4 = 1'b0 ;
 S39 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S24 : begin
 NextState = ( S2 ) ? S25 : S22 ;
 S4 = 1'b1 ;
 S39 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S25 : begin
 NextState = S26 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S26 : begin
 NextState = S27 ;
 S4 = 1'b0 ;
 S39 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S27 : begin
 NextState = ( S2 ) ? S28 : S25 ;
 S4 = ~ S2 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b1 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S28 : begin
 NextState = S29 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S29 : begin
 NextState = S30 ;
 S4 = 1'b0 ;
 S39 = 1'b1 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S30 : begin
 NextState = ( S3 ) ? S31 : S28 ;
 S4 = 1'b1 ;
 S39 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S31 : begin
 NextState = S32 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b1 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S32 : begin
 NextState = S33 ;
 S4 = 1'b0 ;
 S39 = 1'b1 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S33 : begin
 NextState = ( S3 ) ? S34 : S31 ;
 S4 = ~ S3 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b1 ;
 S38 = 1'b0 ;
 end
 S34 : begin
 NextState = ( S37 ) ? S35 : S21 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 S35 : begin
 NextState = S35 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S38 = 1'b1 ;
 end
 default : begin
 NextState = S20 ;
 S4 = 1'b0 ;
 S39 = 1'b0 ;
 S9 = 1'b0 ;
 S1 = 1'b0 ;
 S12 = 1'b0 ;
 S38 = 1'b0 ;
 end
 endcase
 end

 endmodule

 module BistCtrl_SPSRAM256X8 ( Tclk , BistMode , mem_ctrl , Q_i , bist_ctrl ,
 BistFail , ErrMap , Finish ) ;

 input Tclk ;
 input BistMode ;
 output [ 1 : 0 ] mem_ctrl ;
 input [ 7 : 0 ] Q_i ;
 output [ 16 : 0 ] bist_ctrl ;
 output BistFail ;
 output ErrMap ;
 output Finish ;

 wire S40 ;
 wire [ 7 : 0 ] BIST_A ;
 wire [ 7 : 0 ] BIST_D ;
 wire S41 ;
 wire S42 ;
 wire S43 ;
 wire S44 ;
 wire S45 ;
 wire S46 ;
 wire S47 ;

 assign bist_ctrl [ 7 : 0 ] = BIST_A ;
 assign bist_ctrl [ 15 : 8 ] = BIST_D ;
 assign bist_ctrl [ 16 ] = BistMode ;
 assign mem_ctrl [ 0 ] = S40 ;

 ST_MAG_SPSRAM256X8 S48 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .S0 ( BIST_A ) ,
 .S1 ( S41 ) ,
 .S2 ( S45 ) ,
 .S3 ( S46 ) ,
 .S4 ( S44 )
 ) ;

 ST_MPG_SPSRAM256X8 ST_MPG_i0 (
 .S7 ( BIST_D ) ,
 .S8 ( S42 ) ,
 .S9 ( S43 )
 ) ;

 ST_MAL_SPSRAM256X8 ST_MAL_i0 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .BistFail ( BistFail ) ,
 .S12 ( S47 ) ,
 .S13 ( BIST_D ) ,
 .S14 ( Q_i ) ,
 .ErrMap ( ErrMap )
 ) ;

 ST_MTC_SPSRAM256X8 S49 (
 .Tclk ( Tclk ) ,
 .BistMode ( BistMode ) ,
 .S18 ( mem_ctrl [ 1 ] ) ,
 .S19 ( S40 ) ,
 .S4 ( S44 ) ,
 .S2 ( S45 ) ,
 .S3 ( S46 ) ,
 .S1 ( S41 ) ,
 .S8 ( S42 ) ,
 .S9 ( S43 ) ,
 .S12 ( S47 ) ,
 .Finish ( Finish )
 ) ;

 endmodule

