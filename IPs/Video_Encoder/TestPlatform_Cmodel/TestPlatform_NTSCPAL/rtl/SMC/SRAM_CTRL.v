// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SRAM_CTRL.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : sram controller
//  -----------------------------------------------------------------------------  
//  Signal Description
//	TRANS_SIZE => transfer size (8bit == 2'b00, 16bit == 2'b01, 32bit == 2'b10)
//
//
//  ============================================================================= 
`timescale 1ns/10ps
`define	BANK_SIZE	4

module SRAM_CTRL(
	CLK       ,
	RSTb      ,
	ADDR      ,
	WRITE     ,
	READ	  ,
	WDATA     ,
	WBEB      ,
	TRANS_SIZE,		//transfer size(8bit, 16bit, 32bit)
	BANK_SEL  ,
	SRAM_START,
	ADDR_SETUP,
	ADDR_HOLD ,
	CS_SETUP  ,
	CS_HOLD   ,
	ACC_CYCLE ,
	BUS_WIDTH ,
	ADDR_SHIFT,
	READY     ,
	RDATA     ,

	EXT_ADDR  ,
	EXT_WDATA ,
	EXT_RDATA ,
	EXT_CSb   ,
	EXT_WEb   ,
	EXT_OEb   ,
	EXT_BEb   ,
	EXT_WBEb  ,
	EXT_BIDEN );

input					CLK        	;  			
input           		RSTb       	; 
input[25:0]     		ADDR       	; 
input           		WRITE      	; 
input					READ	   	; 
input[31:0]     		WDATA      	; 
input[3:0]	     		WBEB      	; 
input[ 2:0]     		TRANS_SIZE 	; 
input[`BANK_SIZE-1:0]	BANK_SEL   	; 
input           		SRAM_START  ; 
input[ 2:0]     		ADDR_SETUP 	; 
input[ 2:0]     		ADDR_HOLD  	; 
input[ 2:0]     		CS_SETUP   	; 
input[ 2:0]     		CS_HOLD    	; 
input[ 3:0]     		ACC_CYCLE  	; 
input[ 1:0]     		BUS_WIDTH  	; 
input[ 1:0]     		ADDR_SHIFT 	; 
output          		READY      	; 
output[31:0]    		RDATA      	; 

                		           	  
output[25:0]    		EXT_ADDR   	; 
output[31:0]    		EXT_WDATA  	; 
input [31:0]    		EXT_RDATA  	; 
output[ 3:0]       		EXT_CSb    	; 
output          		EXT_WEb    	; 
output          		EXT_OEb    	; 
output[ 3:0]    		EXT_BEb    	; 
output[ 3:0]    		EXT_WBEb   	; 
output          		EXT_BIDEN	; 



parameter	IDLE = 7'b0000001;
parameter	TAS  = 7'b0000010;
parameter	TCSS = 7'b0000100;
parameter	TACC = 7'b0001000;
parameter	TCSH = 7'b0010000;	
parameter	TAH  = 7'b0100000; 
parameter	CONT = 7'b1000000;

reg[25:0]	i_addr;
reg[31:0] 	i_wdata;
reg[31:0]	RDATA;
reg[31:0]	EXT_WDATA;
                   
reg[6:0]	ns;
reg[6:0] 	cs;
reg[3:0]	timing_cnt;
reg[1:0]	repeat_cnt;
reg[1:0]	repeat_cnt_val;
reg[3:0]	beb;
reg[3:0]	pre_beb;
reg[3:0]    r_beb;
reg			READY;


wire		go_tas ;
wire		go_tcss;
wire		go_tacc;
wire		go_tcsh;
wire		go_tah ;
wire		go_cont;
wire		go_idle;
wire		go_next;
		
wire		cont_tas;
wire		cont_tcss;
wire		cont_tacc;

wire		timing_cnt_en;
wire		repeat_end;

//  ============================================
//			control logic
//  ============================================
assign	repeat_end=  ~(|repeat_cnt);
assign	cont_tas  =  ~repeat_end & SRAM_START & go_next &  (|ADDR_SETUP) ; 
assign 	cont_tcss =  ~repeat_end & SRAM_START & go_next & ~(|ADDR_SETUP) &  (|CS_SETUP);
assign  cont_tacc =  ~repeat_end & SRAM_START & go_next & ~(|ADDR_SETUP) & ~(|CS_SETUP);

assign	go_idle   = repeat_end;
assign	go_tas    = SRAM_START & go_next &  (|ADDR_SETUP);
assign	go_tcss   = SRAM_START & go_next & ~(|ADDR_SETUP) &  (|CS_SETUP);
assign	go_tacc   = SRAM_START & go_next & ~(|ADDR_SETUP) & ~(|CS_SETUP); 
assign	go_tcsh   = SRAM_START & go_next &  (|ADDR_HOLD ); 
assign	go_tah    = SRAM_START & go_next & ~(|ADDR_HOLD ) &  (|CS_HOLD );
assign	go_cont   = SRAM_START & go_next & ~(|ADDR_HOLD ) & ~(|CS_HOLD );
assign  go_next   = ~(|timing_cnt);

//  ============================================
//			current_state
//  ============================================
always @(posedge CLK or negedge RSTb)
begin
	if(!RSTb) cs<=IDLE;
	else cs<=ns;
end

//  ============================================
//			next_state
//  ============================================
always @(go_tas or go_tcss or go_tacc or go_tcsh or go_tah or go_idle or
		 go_cont or go_next or cont_tas or cont_tcss or cont_tacc or cs)
begin
	case(cs) 
		IDLE    :
			if(go_tas) ns<=TAS;
			else if(go_tcss) ns<=TCSS;
			else if(go_tacc) ns<=TACC;
			else ns<=IDLE;
		TAS     :
			if(go_next) ns<=TCSS;
			else if(go_tacc) ns<=TACC;
			else ns<=TAS;
		TCSS    :
			if(go_next) ns<=TACC;
			else ns<=TCSS;
		TACC    :
			if(go_tcsh) ns<=TCSH;
			else if(go_tah) ns<=TAH;
			else if(go_cont) ns<=CONT;
			else ns<=TACC;
		TCSH    :
			if(go_next) ns<=TAH;
			else if(go_cont) ns<=CONT;
			else ns<=TCSH;
		TAH     :
			if(go_next) ns<=CONT;
			else ns<=TAH;
		CONT    :
			if(go_idle) ns<=IDLE;
			else if(cont_tas) ns<=TAS;
			else if(cont_tcss) ns<=TCSS;
			else ns<=TACC;
		default : 
			ns<=IDLE;
	endcase
end
		 
//  ============================================
//			Timing counter
//  ============================================
assign timing_cnt_en = (ns == IDLE || ns == CONT ) ? 0 : 1;

always @(posedge CLK or negedge RSTb)
begin
	if(!RSTb) begin
		timing_cnt<=0;
	end
	else begin 
		if(ns == TAS && cs!= TAS)
			timing_cnt<=ADDR_SETUP - 1;
		else if(ns == TCSS && cs!=TCSS)
			timing_cnt<=CS_SETUP - 1;
		else if(ns == TACC && cs!=TACC)
			timing_cnt<=ACC_CYCLE;
		else if(ns==TCSH && cs!=TCSH)
			timing_cnt<=CS_HOLD - 1;
		else if(ns==TAH && cs!=TAH)
			timing_cnt<=ADDR_HOLD - 1;
		else if(timing_cnt_en)
			timing_cnt<=timing_cnt - 1;
		else
			timing_cnt<=timing_cnt;
	end
end

//  ============================================
//					Repeat counter			
//  ============================================
always @(posedge CLK or negedge RSTb)
begin
	if(!RSTb)
		repeat_cnt<=0;
	else begin
		if(cs == IDLE)
			repeat_cnt<=repeat_cnt_val;
		else if(cs == CONT)
			if(repeat_cnt != 2'b00)
				repeat_cnt<=repeat_cnt - 1;
			else
				repeat_cnt<=repeat_cnt;
		else
			repeat_cnt<=repeat_cnt;
	end
end

//	*****************************************************************************
//				repeat_cnt_val, ibeb generator
//	*****************************************************************************
//  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  					--------------------------------------------------------------
//    					||			External SRAM BUS Width							||
//  ----------------------------------------------------------------------------------
//  ||	Transfer SIZE	||	8bit			|	16bit			|	32bit			|| 
//  ----------------------------------------------------------------------------------
//  ||					||  beb = 4'b1110	|	beb = 4'b1110	|	beb = 4'b1110	||	
//  ||					||					|   beb = 4'b1101	|	beb = 4'b1101	||
//	||					||					|					|	beb = 4'b1011	||
//	||					||					|					|	beb = 4'b0111	||
//  ||					||------------------------------------------------------------
//  ||		8bit		||  data_beb4'b1110 |  data_beb4'b1110  |	data_beb4'b1110	||	
//  ||					||	data_beb4'b1101 |  data_beb4'b1101  |	data_beb4'b1101	||
//	||					||	data_beb4'b1011 |  data_beb4'b1011  |	data_beb4'b1011	||
//	||					||	data_beb4'b0111 |  data_beb4'b0111  |	data_beb4'b0111	||
//  ||					||------------------------------------------------------------
//	||					|| repeat_cnt_val 0 | repeat_cnt_val 0	|  repeat_cnt_val 0 ||
//  ----------------------------------------------------------------------------------		
//	||					||	beb4'b1110 		|	beb == 4'b1100	|	beb = 4'b1100	||
//  ||					||					|   				|	beb = 4'b0011	||
//  ||					||------------------------------------------------------------
//  ||		16bit		||  data_beb4'b1110	|   data_beb4'b1100	|   data_beb4'b1100 ||		
//  ||					||  data_beb4'b1101 | 	data_beb4'b0011 |   data_beb4'b0011 ||
//  ||                  ||	data_beb4'b1011	|					|					||	
//  ||                  ||	data_beb4'b0111	|					|					||	
//  ||					||------------------------------------------------------------
//  ||					|| repeat_cnt_val 1	| repeat_cnt_val 0	| repeat_cnt_val 0	||
//  ----------------------------------------------------------------------------------
//	||					||	beb4'b1110 		|	beb4'b1100		|	beb4'b0000		||
//  ||					||------------------------------------------------------------
//  ||		32bit		||  data_beb4'b1110	|   data_beb4'b1100	|   data_beb4'b0000 ||
//  ||                  ||	data_beb4'b1101	|   data_beb4'b0011	|					||	
//  ||                  ||	data_beb4'b1011	|					|					||	
//  ||                  ||	data_beb4'b0111	|					|					||	
//  ||					||------------------------------------------------------------
//  ||                  || repeat_cnt_val 3	| repeat_cnt_val 1	| repeat_cnt_val 0	||	
//  ----------------------------------------------------------------------------------
//	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
assign size8   = (TRANS_SIZE == 2'b00) ? 1 : 0;
assign size16  = (TRANS_SIZE == 2'b01) ? 1 : 0; 
assign size32  = (TRANS_SIZE == 2'b10) ? 1 : 0; 
assign width8  = (BUS_WIDTH  == 2'b00) ? 1 : 0;
assign width16 = (BUS_WIDTH  == 2'b01) ? 1 : 0;
assign width32 = (BUS_WIDTH  == 2'b10) ? 1 : 0; 
//repeat count value
always @(size8 or size16 or size32 or width8 or width16 or width32)
begin
	if     (size16 & width8) repeat_cnt_val <= 2'h1;
	else if(size32 & width8) repeat_cnt_val <= 2'h3;
	else if(size32 & width16) repeat_cnt_val <= 2'h1;
    else repeat_cnt_val <=2'b00;
end
// read byte enable 
always @(size8 or size16 or size32 or width8 or width16 or width32 or i_addr)
begin
	if(size32 & width32) r_beb <= 4'b0000;
	else if( (size32 & width16) || (size16 & width16) || (size16 & width32) )begin
		if(i_addr[1]==0) r_beb <= 4'b1100;
		else r_beb <=4'b0011;
	end
	else begin
		case(i_addr[1:0])
			2'b00   : r_beb <= 4'b1110;
			2'b01   : r_beb <= 4'b1101; 
			2'b10   : r_beb <= 4'b1011; 
			2'b11   : r_beb <= 4'b0111; 
			default : r_beb <= 4'b1111; 
		endcase
 	end
end

wire [3:0] wbeb_at_write;
assign wbeb_at_write = (WRITE == 1) ? WBEB : 4'b0000;

always @(TRANS_SIZE or i_addr or wbeb_at_write)
begin
	case(TRANS_SIZE)
		2'b00   : 
			case(i_addr[1:0])
				2'b00   : pre_beb <= 4'b1110 | wbeb_at_write;
				2'b01   : pre_beb <= 4'b1101 | wbeb_at_write; 
				2'b10   : pre_beb <= 4'b1011 | wbeb_at_write; 
				2'b11   : pre_beb <= 4'b0111 | wbeb_at_write; 
				default : pre_beb <= 4'b1111; 
			endcase
		2'b01   : if(i_addr[1]==0) pre_beb <= 4'b1100 | wbeb_at_write;
				  else             pre_beb <= 4'b0011 | wbeb_at_write;
		2'b10   : pre_beb <= 4'b0000 | wbeb_at_write;
		default : pre_beb <= 4'b1111;
	endcase
end
// byte enable 
always @(BUS_WIDTH or pre_beb or i_addr)
begin
	case(BUS_WIDTH)
		2'b00   : 
				case(i_addr[1:0])
				2'b00: beb<={3'b111, pre_beb[0]};
				2'b01: beb<={3'b111, pre_beb[1]};
				2'b10: beb<={3'b111, pre_beb[2]};
				2'b11: beb<={3'b111, pre_beb[3]};
				endcase
		2'b01   : if(i_addr[1]==0) beb<={2'b11,pre_beb[1:0]};
				  else             beb<={2'b11,pre_beb[3:2]};
		2'b10   : beb <= pre_beb;
		default : beb <= 4'b1111;
	endcase
end
//  ============================================
//					ADDRESS 			
//  ============================================

assign inc01 = (cs==CONT) & ~repeat_end & (BUS_WIDTH==2'b00);
assign inc02 = (cs==CONT) & ~repeat_end & (BUS_WIDTH==2'b01);

always @(posedge CLK or negedge RSTb)
begin
	if(!RSTb) begin
		i_addr<=25'd0;
		i_wdata<=32'd0;
	end
	else begin
		i_wdata<=WDATA;
		if(cs==IDLE)   i_addr <= ADDR;
		else if(inc01) i_addr <= i_addr + 1'b1;
		else if(inc02) i_addr <= i_addr + 2'b10;
		else 		   i_addr <= i_addr;
	end		
end
//  ============================================
//					Ouput Logic			
//  ============================================
always @(i_addr or i_wdata or BUS_WIDTH)
begin
	case(BUS_WIDTH)
		2'b00   : 
			case(i_addr[1:0])
				2'b00   : 	 EXT_WDATA <= {24'b0,i_wdata[ 7:0 ]};
				2'b01   : 	 EXT_WDATA <= {24'b0,i_wdata[15:8 ]}; 
				2'b10   : 	 EXT_WDATA <= {24'b0,i_wdata[23:16]}; 
				default : 	 EXT_WDATA <= {24'b0,i_wdata[31:24]}; 
			endcase          
		2'b01   :            
			if(i_addr[1]==0) EXT_WDATA <= {16'b0,i_wdata[15:0 ]};
			else             EXT_WDATA <= {16'b0,i_wdata[31:16]};
		2'b10   : 			 EXT_WDATA <= i_wdata;
		default : 			 EXT_WDATA <= 32'b0;  
	endcase
end

always @(posedge CLK or negedge RSTb)
begin
	if(!RSTb) RDATA<=32'd0;
	else begin
		if(cs == TACC && READ == 1'b1 &&( ns == TAH || ns == TCSH || ns == CONT)) begin
			case(BUS_WIDTH)
				2'b00   :
					case(r_beb)
						4'b1110 : RDATA[ 7:0 ] <= EXT_RDATA[ 7:0 ];
						4'b1101 : RDATA[15:8 ] <= EXT_RDATA[ 7:0 ];
						4'b1011 : RDATA[23:16] <= EXT_RDATA[ 7:0 ];
						4'b0111 : RDATA[31:24] <= EXT_RDATA[ 7:0 ];
						default : RDATA[31: 0] <= 32'd0;				
					endcase
				2'b01   :
					case(r_beb)
						4'b1110 : RDATA[ 7:0 ] <= EXT_RDATA[ 7:0 ];
						4'b1101 : RDATA[15:8 ] <= EXT_RDATA[15:8 ];
						4'b1011 : RDATA[23:16] <= EXT_RDATA[ 7:0 ];
						4'b0111 : RDATA[31:24] <= EXT_RDATA[15:8 ];
						4'b1100 : RDATA[15:0 ] <= EXT_RDATA[15:0 ];
						4'b0011 : RDATA[31:16] <= EXT_RDATA[15:0 ];
						default : RDATA[31: 0] <= 32'd0;				
					endcase
				2'b10   :
					case(r_beb)
						4'b1110 : RDATA[ 7:0 ] <= EXT_RDATA[ 7:0 ];
						4'b1101 : RDATA[15:8 ] <= EXT_RDATA[15:8 ];
						4'b1011 : RDATA[23:16] <= EXT_RDATA[23:16];
						4'b0111 : RDATA[31:24] <= EXT_RDATA[31:24];
						4'b1100 : RDATA[15:0 ] <= EXT_RDATA[15:0 ];
						4'b0011 : RDATA[31:16] <= EXT_RDATA[31:16];
						4'b0000 : RDATA[31: 0] <= EXT_RDATA[31:0 ];
					    default : RDATA[31: 0] <= 32'd0;				
					endcase
				default : RDATA[31: 0] <= 32'd0;
			endcase
		end 
		else RDATA<=RDATA;
	end
end

always @(cs or ns or repeat_cnt)
begin
	if(cs==IDLE) begin
		if(ns==IDLE)READY <= 1'b1;
		else		READY <= 1'b0;
	end
	else if(cs==CONT) begin
		if(repeat_cnt==2'b00) 	READY <= 1'b1;
		else					READY <= 1'b0;
	end
	else READY <= 1'b0;
end

assign csb		 = (cs==TCSS || cs==TACC || cs==TCSH) ? 0 : 1;
assign web 	     = (cs==TACC && WRITE)  ? 0 : 1;
                 
assign EXT_CSb	 = (csb) ? 4'hf : ~BANK_SEL; 
assign EXT_WEb 	 = web;
assign EXT_OEb   = (cs==TACC && ~WRITE) ? 0 : 1;
assign EXT_BEb   = (cs == IDLE || csb ==1'b1) ? 4'b1111 : beb;
assign EXT_WBEb	 = (web == 1'b1) ? 4'b1111 : beb;
assign EXT_BIDEN = (cs != IDLE) ? WRITE : 1'b0;
                 
assign EXT_ADDR  = (ADDR_SHIFT == 2'b00) ? i_addr : 
				   (ADDR_SHIFT == 2'b01) ? {1'b0,i_addr[25:1]} : 
				   (ADDR_SHIFT == 2'b10) ? {2'b0,i_addr[25:2]} : 32'd0;

endmodule


