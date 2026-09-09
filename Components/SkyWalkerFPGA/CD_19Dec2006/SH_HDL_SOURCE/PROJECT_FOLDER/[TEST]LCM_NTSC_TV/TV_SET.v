module TV_SET(
input iclock_27,
input iclock_50,
input [7:0]itv_data ,

input itv_hs,
input itv_vs,
input SW,
output otv_hs,
output otv_vs,

output orst_i3c,
output orst_i2c,
output orst_lcm,
output orst_tvdecoder,
output [7:0]otv_data

);



///////////RESET & LCM VH Timing GENERATER/////////
wire [7:0]Ym,Cbm,Crm;
wire [1:0]COUNTER;
wire STARTm;
wire VSm;
reg [10:0]L_COUNTER;
reg [10:0]RL_COUNTER;
reg [7:0]delay;
wire res=((delay ==10) && (RL_COUNTER[10:0]!=11'h120))?0:1;

always @(posedge itv_vs or posedge itv_hs) begin
if (itv_vs) L_COUNTER=0;		  
			else L_COUNTER=L_COUNTER+1;
end			

always @(posedge itv_vs) begin
		RL_COUNTER=L_COUNTER;
end	

always @(posedge itv_vs) begin
	delay=delay+1;
	end

reg     [7:0] Fcnt;
assign	orst_i2c	=	res;
assign	orst_lcm	=	(Fcnt<=20)? 1'b0:1'b1;
assign  orst_i3c    =   (Fcnt<=30)? 1'b0:1'b1;


reg [7:0] syst;
always@(posedge iclock_50) begin
if (syst<125)
	syst=syst+1;
	end

assign	orst_tvdecoder	=	(syst<=10)? 1'b0:1'b1;

reg [10:0]h_c;
wire [10:0]off=0;
assign  otv_hs=((h_c >= (36+off)) && (h_c <=(39+off)))?0:1; 		
assign	otv_vs	    =	(Fcnt<100)?1'b1:~VSm;

always @(posedge iclock_27) begin
if (!STARTm)
	h_c=0;
	else 
	h_c=h_c+1;
end

always@(negedge orst_tvdecoder or posedge itv_vs) begin
if(!orst_tvdecoder)
Fcnt=0;
else
if (Fcnt<250) 
Fcnt=Fcnt+1;
end

////////Test pattern generater//////////////
reg [8:0]vvv;
reg [10:0]hhh;
wire [7:0]YL=(({vvv[8:4],4'b0000}) <= hhh[10:2])?{vvv[8:4],3'b000}:8'h70;

always @(posedge iclock_27)begin 
if (STARTm) hhh=0;
else hhh=hhh+1;
end

always @(posedge STARTm)begin
if (VSm) vvv=0;
else vvv=vvv+1;
end
////////////////////////TV DATA OUTPUT//////////

wire [7:0]YY=(Ym>=8'h30)?Ym[7:0]-8'h30:0;
wire [7:0]Yt= (!SW)?YY[7:0]:YL[7:0];
wire [8:0]WW=Yt[7:0]+32;

wire [7:0]Cr=(!SW)?Crm[7:0] :8'h80;
wire [7:0]Cb=(!SW)?Cbm[7:0] :8'h80;


wire [7:0]Y=(WW[8:0]>=238)?238:WW[7:0];
	

			
assign	otv_data[7:0]=( 
						  ((STARTm==0) && (COUNTER[1:0]==0))?Cr[7:0]:(
						  ((STARTm==0) && (COUNTER[1:0]==2))?Cb[7:0]:Y[7:0]
						 )
						 );						


///////////////////////////////////

decode_656 decoMAIN(
	.TD_D (itv_data[7:0]),
	.CLOCK(iclock_27),
	.START(STARTm),
	.VS   (VSm)
);
YUV422TO444 yuv1(
.START(STARTm),
.TD_D(itv_data[7:0]),
.CLOCK(iclock_27),
.Y(Ym),
.Cb(Cbm),
.Cr(Crm),
.COUNTER(COUNTER)
);

endmodule