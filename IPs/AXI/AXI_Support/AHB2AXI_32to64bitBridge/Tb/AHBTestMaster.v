// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHBTestMaster.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            :
//  =============================================================================

`timescale 1ns/10ps

module AHBTestMaster 	// AHB-lite master
(
		HCLK     , 
		HRESETn  , 
		HADDR    ,
		HTRANS   ,
		HWRITE   ,
		HSIZE    ,
		HBURST   ,
		HPROT    ,
		HLOCK    ,	// same timing with HMASTLOCK
		HWDATA   ,
		HRDATA   ,
		HREADY   ,
		HRESP
);

parameter RANDOMIZE = 1;
parameter QUE_WIDTH = 4;	

//
// input/output port
//
input  HCLK;
input  HRESETn;

output [31:0]          HADDR;
output [ 1:0]          HTRANS;
output                 HWRITE;
output [2:0]           HSIZE;
output [2:0]           HBURST;
output [3:0]           HPROT;
output                 HLOCK;
output [31:0]          HWDATA;
input  [31:0]          HRDATA;
input                  HREADY;
input  [1:0]           HRESP;


`define HTRANS_NSEQ 2'b10
`define HTRANS_SEQ  2'b11
`define HTRANS_IDLE 2'b00
`define HTRANS_BUSY 2'b01

`define HRESP_OKAY  2'b00
`define HRESP_ERROR 2'b01

`define HBURST_SINGLE 3'b000
`define HBURST_INCR   3'b001
`define HBURST_WRAP4  3'b010
`define HBURST_INCR4  3'b011
`define HBURST_WRAP8  3'b100
`define HBURST_INCR8  3'b101
`define HBURST_WRAP16 3'b110
`define HBURST_INCR16 3'b111

`define HSIZE_BYTE  3'b000
`define HSIZE_HWORD 3'b001
`define HSIZE_WORD  3'b010

reg  [31:0]          HADDR;
reg  [ 1:0]          HTRANS;
reg                  HWRITE;
reg  [2:0]           HSIZE;
reg  [2:0]           HBURST;
reg  [3:0]           HPROT;
reg                  HLOCK;
reg  [31:0]          HWDATA;

// Que
//reg  [QUE_WIDTH-1:0]       QUE_RINDEX;
//reg  [QUE_WIDTH-1:0]       QUE_WINDEX;
reg  QUE_RINDEX;
reg  QUE_WINDEX;
reg  [31:0] HADDR_Q[1:0];
reg         HWRITE_Q[1:0];
reg  [3:0]  HSIZE_Q[1:0];
reg  [2:0]  HBURST_Q[1:0];
reg  [3:0]  BURSTLEN_Q[1:0];

wire QUE_empty = (QUE_RINDEX == QUE_WINDEX) ? 1'b1 : 1'b0;
function QUE_full;
	input dummy;
	QUE_full  = (QUE_RINDEX == ~QUE_WINDEX) ? 1'b1 : 1'b0;
endfunction

reg  [5:0]  DATAQUE_RINDEX;
reg  [5:0]  DATAQUE_WINDEX;
reg  [31:0] HDATA_Q[63:0];

wire [31:0] TestRDATA = HDATA_Q[DATAQUE_RINDEX];

reg  [31:0] NextHADDR;
reg  [31:0] HADDRMask;
always @(HBURST)
begin
	case(HBURST)
	3'b000: HADDRMask <= 32'h00000000; //Single
	3'b010: HADDRMask <= 32'hfffffffc; //WRAP4
	3'b100: HADDRMask <= 32'hfffffff8; //WRAP8
	3'b110: HADDRMask <= 32'hfffffff0; //WRAP16
    default:
	        HADDRMask <= 32'h00000000;
	endcase

    /*
	case(HBURST[2:1])
	2'b00: HADDRMask <= 32'h00000000;
	2'b01: HADDRMask <= 32'hfffffffc;
	2'b10: HADDRMask <= 32'hfffffff8;
	2'b10: HADDRMask <= 32'hfffffff0;
	endcase
    */
end

always @(HADDR or HSIZE or HADDRMask)
begin
	case(HSIZE)
	`HSIZE_BYTE:	// byte
		NextHADDR = (HADDR&HADDRMask)|((HADDR + 1)&(~HADDRMask));
	`HSIZE_HWORD:   // half word
		NextHADDR = (HADDR&(HADDRMask<<1))|((HADDR + 2)&(~(HADDRMask<<1)));
	`HSIZE_WORD:    // word
		NextHADDR = (HADDR&(HADDRMask<<2))|((HADDR + 4)&(~(HADDRMask<<2)));
	default:
	begin
		$display("Cannot support larger size than word");
		$stop;
	end
	endcase
end

reg  [3:0]  BURSTLEN;
reg  ReadDataCheck;
reg  RANDOMBit;
always @(posedge HCLK or negedge HRESETn)
begin
	if(!HRESETn)
	begin
		QUE_RINDEX <= 0;
		DATAQUE_RINDEX <= 0;
		HADDR <= 32'h00000000;
		HTRANS <= `HTRANS_IDLE;
		HSIZE <= 3'b010;	// always 32 bit transfer
		HPROT <= 0;
		HLOCK <= 0;
		HWDATA <= 32'h00000000;
		ReadDataCheck <= 1'b0;
		BURSTLEN <= 0;
	end
	else
	begin
		if(RANDOMIZE == 1)
			RANDOMBit = $random/16;

		if(HREADY == 1'b1 && ReadDataCheck == 1'b1)
		begin
			if(HRDATA !== HDATA_Q[DATAQUE_RINDEX])
			begin
				$display("Read Data(%h) is not expected value(%h)", HRDATA, HDATA_Q[DATAQUE_RINDEX]);
				$stop;
			end
			DATAQUE_RINDEX = DATAQUE_RINDEX + 1'b1;
		end

		if(HTRANS == `HTRANS_IDLE && HREADY == 1'b1)
		begin
			if(QUE_empty == 1'b0)
			begin
#1;
				HADDR <= HADDR_Q[QUE_RINDEX];
				HTRANS <= `HTRANS_NSEQ;
				HWRITE <= HWRITE_Q[QUE_RINDEX];
				HSIZE <= HSIZE_Q[QUE_RINDEX];
				HBURST <= HBURST_Q[QUE_RINDEX];
				BURSTLEN <= BURSTLEN_Q[QUE_RINDEX];
				QUE_RINDEX <= QUE_RINDEX + 1'b1;
			end
			ReadDataCheck <= 1'b0;
		end
		else
		begin
			if(HREADY == 1'b1)
			begin
				if(BURSTLEN != 0)
				begin
					if(RANDOMIZE == 0 || RANDOMBit == 0)
					begin
						HADDR <= NextHADDR;
						HTRANS <= `HTRANS_SEQ;
						BURSTLEN <= BURSTLEN - 1'b1;
					end
					else begin
						HTRANS <= `HTRANS_BUSY;
                    end
				end
				else if(QUE_empty == 1'b0 && (RANDOMIZE == 0 || RANDOMBit == 0))
				begin
					HADDR <= HADDR_Q[QUE_RINDEX];
					HTRANS <= `HTRANS_NSEQ;
					HWRITE <= HWRITE_Q[QUE_RINDEX];
					HSIZE <= HSIZE_Q[QUE_RINDEX];
					HBURST <= HBURST_Q[QUE_RINDEX];
					BURSTLEN <= BURSTLEN_Q[QUE_RINDEX];
					QUE_RINDEX <= QUE_RINDEX + 1'b1;
				end
				else
				begin
					HTRANS <= `HTRANS_IDLE;
				end

				if(HTRANS == `HTRANS_NSEQ || HTRANS == `HTRANS_SEQ)
				begin
					if(HWRITE == 1'b1)
					begin
						HWDATA <= HDATA_Q[DATAQUE_RINDEX];
						DATAQUE_RINDEX = DATAQUE_RINDEX + 1'b1;
						ReadDataCheck <= 1'b0;
					end
					else
                    begin
						ReadDataCheck <= 1'b1;
                    end
				end
				else
				begin
					HWDATA <= 32'hxxxxxxxx;
					ReadDataCheck <= 1'b0;
				end
			end
		end
	end
end

// Response Check
always @(posedge HCLK)
begin
	if(HRESETn == 1'b1 && HREADY == 1'b1 && HRESP != `HRESP_OKAY)
	begin
		$display("HRESP is not OKAY");
		$stop;
	end
end


task AHBTrans4;
	input [31:0] haddr;
	input        hwrite;
	input [3:0]  hsize;
	input [2:0]  hburst;
	input [31:0] hdata0;
	input [31:0] hdata1;
	input [31:0] hdata2;
	input [31:0] hdata3;
	begin
		while(QUE_full(0) == 1'b1) @(posedge HCLK);
		HADDR_Q[QUE_WINDEX] = haddr;
		HWRITE_Q[QUE_WINDEX] = hwrite;
		HSIZE_Q[QUE_WINDEX] = hsize;
		HBURST_Q[QUE_WINDEX] = hburst;
		BURSTLEN_Q[QUE_WINDEX] = 4'd3;
		QUE_WINDEX = QUE_WINDEX + 1'b1;
		
		HDATA_Q[DATAQUE_WINDEX] = hdata0;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata1;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata2;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata3;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
	end
endtask

function [31:0] ShiftAddr;
	input [3:0] Addr;
    input [3:0] Size;
    begin
        case(Addr[2:0])
            3'd0: begin
                    case(Size[2:0])
                        3'd0:   ShiftAddr = {24'd0, Addr}; //8bit
                        3'd1:   ShiftAddr = {16'd0, Addr+1, Addr}; //16bit
                        3'd2:   ShiftAddr = {Addr+3, Addr+2, Addr+1, Addr}; //16bit
                    endcase
                  end


        endcase
    end
endfunction

task AHBTransWord;
	input [31:0] haddr;
	input        hwrite;
	input [2:0]  hburst;
    input [4:0]  cntmax;
    integer i;
	reg    [7:0] ad_data0;
	reg    [7:0] ad_data1;
	reg    [7:0] ad_data2;
	reg    [7:0] ad_data3;
	reg   [31:0] ad_dataToT;
    reg   [31:0] mid0_i;
	begin
		while(QUE_full(0) == 1'b1) @(posedge HCLK);
		HADDR_Q[QUE_WINDEX] = haddr;
		HWRITE_Q[QUE_WINDEX] = hwrite;
		HSIZE_Q[QUE_WINDEX] = `HSIZE_WORD;
		HBURST_Q[QUE_WINDEX] = hburst;
		BURSTLEN_Q[QUE_WINDEX] = cntmax;
		QUE_WINDEX = QUE_WINDEX + 1'b1;

        ad_data0   = haddr[7:0] & 8'hFC;
        ad_data1   = (haddr[7:0] & 8'hFC)+1;
        ad_data2   = (haddr[7:0] & 8'hFC)+2;
        ad_data3   = (haddr[7:0] & 8'hFC)+3;
        ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};

        mid0_i = (32'h03 & (~(haddr))) >> 1; //16bit


        for(i=0; i <= cntmax; i=i+1) begin

		    HDATA_Q[DATAQUE_WINDEX] = ad_dataToT;
		    DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
            //if(i == mid0_i) begin
                //mid0_i = mid0_i + 2;
                case(hburst)
                    3'b010: //wrap4 burst
                    begin
                        case(ad_data0[3:2])
                            2'b00: ad_data0 = (ad_data0 & 8'hF0) | 8'h4; //0
                            2'b01: ad_data0 = (ad_data0 & 8'hF0) | 8'h8; //4
                            2'b10: ad_data0 = (ad_data0 & 8'hF0) | 8'hC; //8
                            2'b11: ad_data0 = (ad_data0 & 8'hF0) | 8'h0; //C
                        endcase
                    end
                    3'b100: //wrap8 burst
                    begin
                        if(ad_data0[4:0] == 5'h1C)  ad_data0 = ad_data0 & 8'hE0;
                        else                        ad_data0 = ad_data0 +4;
                    end
                    3'b110: //wrap16 burst
                    begin
                        if(ad_data0[5:0] == 8'h3C)  ad_data0 = ad_data0 & 8'hC0;
                        else                        ad_data0 = ad_data0 +4;
                    end
                    default:
                            ad_data0   = ad_data0 +4;

                endcase
                ad_data1   = ad_data0 +1;
                ad_data2   = ad_data0 +2;
                ad_data3   = ad_data0 +3;
                ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};
            //end
        end
	end
endtask


task AHBTransHalfWord;
	input [31:0] haddr;
	input        hwrite;
	input [2:0]  hburst;
    input [4:0]  cntmax;
    integer i;
	reg    [7:0] ad_data0;
	reg    [7:0] ad_data1;
	reg    [7:0] ad_data2;
	reg    [7:0] ad_data3;
	reg   [31:0] ad_dataToT;
    reg   [31:0] mid0_i;
	begin
		while(QUE_full(0) == 1'b1) @(posedge HCLK);
		HADDR_Q[QUE_WINDEX] = haddr;
		HWRITE_Q[QUE_WINDEX] = hwrite;
		HSIZE_Q[QUE_WINDEX] = `HSIZE_HWORD;
		HBURST_Q[QUE_WINDEX] = hburst;
		BURSTLEN_Q[QUE_WINDEX] = cntmax;
		QUE_WINDEX = QUE_WINDEX + 1'b1;

        ad_data0   = haddr[7:0] & 8'hFC;
        ad_data1   = (haddr[7:0] & 8'hFC)+1;
        ad_data2   = (haddr[7:0] & 8'hFC)+2;
        ad_data3   = (haddr[7:0] & 8'hFC)+3;
        ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};

        mid0_i = (32'h03 & (~(haddr))) >> 1; //16bit


        for(i=0; i <= cntmax; i=i+1) begin

		    HDATA_Q[DATAQUE_WINDEX] = ad_dataToT;
		    DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
            if(i == mid0_i) begin
                mid0_i = mid0_i + 2;
                case(hburst)
                    3'b010: //wrap4 burst
                    begin
                        case(ad_data0[3:2])
                            2'b00: ad_data0 = (ad_data0 & 8'hF0) | 8'h4; //0
                            2'b01: ad_data0 = (ad_data0 & 8'hF0) | 8'h0; //4
                            2'b10: ad_data0 = (ad_data0 & 8'hF0) | 8'hC; //8
                            2'b11: ad_data0 = (ad_data0 & 8'hF0) | 8'h8; //C
                        endcase
                    end
                    3'b100: //wrap8 burst
                    begin
                        case(ad_data0[3:2])
                            2'b00: ad_data0 = (ad_data0 & 8'hF0) | 8'h4; //0
                            2'b01: ad_data0 = (ad_data0 & 8'hF0) | 8'h8; //4
                            2'b10: ad_data0 = (ad_data0 & 8'hF0) | 8'hC; //8
                            2'b11: ad_data0 = (ad_data0 & 8'hF0) | 8'h0; //C
                        endcase
                    end
                    3'b110: //wrap16 burst
                    begin
                        if(ad_data0[4:0] == 5'h1C)  ad_data0 = ad_data0 & 8'hE0;
                        else                  ad_data0 = ad_data0 +4;
                    end
                    default:
                            ad_data0   = ad_data0 +4;

                endcase
                ad_data1   = ad_data0 +1;
                ad_data2   = ad_data0 +2;
                ad_data3   = ad_data0 +3;
                ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};
            end
        end
	end
endtask



task AHBTransByte;
	input [31:0] haddr;
	input        hwrite;
	input [2:0]  hburst;
    input [4:0]  cntmax;
    integer i;
	reg    [7:0] ad_data0;
	reg    [7:0] ad_data1;
	reg    [7:0] ad_data2;
	reg    [7:0] ad_data3;
	reg   [31:0] ad_dataToT;
    reg   [31:0] mid0_i;
	begin
		while(QUE_full(0) == 1'b1) @(posedge HCLK);
		HADDR_Q[QUE_WINDEX] = haddr;
		HWRITE_Q[QUE_WINDEX] = hwrite;
		HSIZE_Q[QUE_WINDEX] = `HSIZE_BYTE;
		HBURST_Q[QUE_WINDEX] = hburst;
		BURSTLEN_Q[QUE_WINDEX] = cntmax;
		QUE_WINDEX = QUE_WINDEX + 1'b1;

        ad_data0   = haddr[7:0] & 8'hFC;
        ad_data1   = (haddr[7:0] & 8'hFC)+1;
        ad_data2   = (haddr[7:0] & 8'hFC)+2;
        ad_data3   = (haddr[7:0] & 8'hFC)+3;
        ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};

        mid0_i = 32'h03 & (~(haddr));     //8bit


        for(i=0; i <= cntmax; i=i+1) begin
		    HDATA_Q[DATAQUE_WINDEX] = ad_dataToT;
		    DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
            if(i == mid0_i) begin
                mid0_i = mid0_i + 4;
                case(hburst)
                    3'b010: 
                    begin
                        case(ad_data0[3:2]) //wrap4 burst
                            2'b00: ad_data0 = (ad_data0 | 8'h0);  //0
                            2'b01: ad_data0 = (ad_data0 | 8'h04); //4
                            2'b10: ad_data0 = (ad_data0 | 8'h08); //8
                            2'b11: ad_data0 = (ad_data0 | 8'h0C); //C
                        endcase
                    end
                    3'b100: 
                    begin
                        case(ad_data0[3:2]) //wrap8 burst
                            2'b00: ad_data0 = (ad_data0 & 8'hF0) | 8'h04; //0
                            2'b01: ad_data0 = (ad_data0 & 8'hF0) | 8'h00; //4
                            2'b10: ad_data0 = (ad_data0 & 8'hF0) | 8'h0C; //8
                            2'b11: ad_data0 = (ad_data0 & 8'hF0) | 8'h08; //C
                        endcase
                    end
                    3'b110: //ad_data0   = haddr & 32'hFFFFFFF0; //wrap16 burst
                    begin
                        case(ad_data0[3:2])
                            2'b00: ad_data0 = (ad_data0 & 8'hF0) | 8'h04; //0
                            2'b01: ad_data0 = (ad_data0 & 8'hF0) | 8'h08; //4
                            2'b10: ad_data0 = (ad_data0 & 8'hF0) | 8'h0C; //8
                            2'b11: ad_data0 = (ad_data0 & 8'hF0) | 8'h00; //C
                        endcase
                    end
                    default:
                            ad_data0   = ad_data0 +4;
                endcase
                ad_data1   = ad_data0 +1;
                ad_data2   = ad_data0 +2;
                ad_data3   = ad_data0 +3;
                ad_dataToT = {ad_data3, ad_data2, ad_data1, ad_data0};
            end
        end

	end
endtask

// Real Test bench
initial
begin
	DATAQUE_WINDEX = 0;
	QUE_WINDEX = 0;
	@(posedge HCLK);
	while(HRESETn != 1'b1) @(posedge HCLK);

	AHBTrans4(32'h00000000, 1, `HSIZE_WORD, `HBURST_INCR4, 0<<2, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000010, 1, `HSIZE_WORD, `HBURST_INCR4, 4<<2, 5<<2, 6<<2, 7<<2);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 0<<2, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000010, 0, `HSIZE_WORD, `HBURST_INCR4, 4<<2, 5<<2, 6<<2, 7<<2);
	AHBTrans4(32'h0000001c, 0, `HSIZE_WORD, `HBURST_WRAP4, 7<<2, 4<<2, 5<<2, 6<<2);
	AHBTrans4(32'h00000008, 0, `HSIZE_WORD, `HBURST_INCR, 2<<2, 3<<2, 4<<2, 5<<2);
	AHBTrans4(32'h00000000, 1, `HSIZE_BYTE, `HBURST_INCR4, 0, 1<<8, 2<<16, 3<<24);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 32'h03020100, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000000, 1, `HSIZE_HWORD, `HBURST_INCR4, 0, 1<<16, 2, 3<<16);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 32'h00010000, 32'h00030002, 2<<2, 3<<2);


//Byte Test
    AHBTransByte(32'h0000010A, 1, `HBURST_WRAP8, 7);
    AHBTransByte(32'h0000010A, 0, `HBURST_WRAP8, 7);
    AHBTransByte(32'h00000114, 1, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000114, 0, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000000, 1, `HBURST_INCR4, 3);
    AHBTransByte(32'h00000001, 1, `HBURST_INCR4, 3);
    AHBTransByte(32'h00000000, 1, `HBURST_INCR16,15);
    AHBTransByte(32'h000000FF, 1, `HBURST_INCR8, 7);
    AHBTransByte(32'h000000C0, 1, `HBURST_INCR, 15);
    AHBTransByte(32'h000000DB, 1, `HBURST_SINGLE, 0);
    AHBTransByte(32'h00000004, 1, `HBURST_WRAP4, 3);
    AHBTransByte(32'h00000006, 1, `HBURST_WRAP8, 7);
    AHBTransByte(32'h00000002, 1, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000005, 1, `HBURST_WRAP4, 3);
    AHBTransByte(32'h000000FC, 1, `HBURST_INCR4, 3);
    AHBTransByte(32'h00000000, 0, `HBURST_INCR4, 3);
    AHBTransByte(32'h00000000, 0, `HBURST_INCR16,15);
    AHBTransByte(32'h00000005, 0, `HBURST_WRAP4, 3);
    AHBTransByte(32'h00000001, 0, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000002, 0, `HBURST_WRAP8, 7);
    AHBTransByte(32'h000000FF, 0, `HBURST_INCR, 2);
    AHBTransByte(32'h00000000, 1, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000000, 0, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000048, 1, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000048, 0, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000059, 1, `HBURST_WRAP16, 15);
    AHBTransByte(32'h00000059, 0, `HBURST_WRAP16, 15);

//Half Word Test
    AHBTransHalfWord(32'h00000100, 1, `HBURST_INCR4, 3);
    AHBTransHalfWord(32'h00000106, 1, `HBURST_INCR8, 7);
    AHBTransHalfWord(32'h0000010A, 1, `HBURST_INCR16,15);
    AHBTransHalfWord(32'h00000100, 0, `HBURST_INCR4, 3);
    AHBTransHalfWord(32'h00000108, 0, `HBURST_INCR,5);
    AHBTransHalfWord(32'h0000010C, 1, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h0000010C, 0, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000100, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000100, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000020A, 1, `HBURST_INCR,0);
    AHBTransHalfWord(32'h0000010A, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000100, 0, `HBURST_INCR4, 3);
    AHBTransHalfWord(32'h00000106, 1, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h00000106, 0, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h0000040A, 1, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h0000040A, 0, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h00000500, 1, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000500, 0, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000602, 1, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000602, 0, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000614, 1, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000614, 0, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000626, 1, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000626, 0, `HBURST_WRAP4, 3);
    AHBTransHalfWord(32'h00000130, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000130, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000142, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000142, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000144, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000144, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000156, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000156, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000168, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000168, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000017A, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000017A, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000018C, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000018C, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000018E, 1, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h0000018E, 0, `HBURST_WRAP8, 7);
    AHBTransHalfWord(32'h00000126, 1, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h00000120, 0, `HBURST_INCR16, 15);
    AHBTransHalfWord(32'h0000017A, 1, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h00000160, 0, `HBURST_INCR16, 15);
    AHBTransHalfWord(32'h000001FE, 1, `HBURST_WRAP16, 15);
    AHBTransHalfWord(32'h00000170, 0, `HBURST_INCR16, 15);

//Word Test
    AHBTransWord(32'h00001100, 1, `HBURST_INCR4, 3);
    AHBTransWord(32'h000011E4, 1, `HBURST_INCR4, 3);
    AHBTransWord(32'h00001100, 0, `HBURST_INCR4, 3);
    AHBTransWord(32'h000011E4, 0, `HBURST_INCR4, 3);
    AHBTransWord(32'h000011C0, 1, `HBURST_INCR8, 7);
    AHBTransWord(32'h000011C4, 0, `HBURST_WRAP8, 7);
    AHBTransWord(32'h000011F4, 1, `HBURST_INCR8, 7);
    AHBTransWord(32'h00001204, 0, `HBURST_INCR4, 3);
    AHBTransWord(32'h000011D4, 1, `HBURST_INCR4, 3);
    AHBTransWord(32'h000011D4, 0, `HBURST_INCR4, 3);
    AHBTransWord(32'h000012CC, 1, `HBURST_WRAP4, 3);
    AHBTransWord(32'h000012CC, 0, `HBURST_WRAP4, 3);
    AHBTransWord(32'h000011D8, 1, `HBURST_WRAP8, 7);
    AHBTransWord(32'h000011D8, 0, `HBURST_WRAP8, 7);
    AHBTransWord(32'h00001254, 1, `HBURST_WRAP8, 7);
    AHBTransWord(32'h00001240, 0, `HBURST_INCR8, 7);
    AHBTransWord(32'h000012B8, 1, `HBURST_WRAP16, 15);
    AHBTransWord(32'h00001280, 0, `HBURST_INCR16, 15);

    /*
	initial_data_write4;
	repeat(100000) random_read_write4;

	while(QUE_RINDEX != QUE_WINDEX || HTRANS != `HTRANS_IDLE)
		@(posedge HCLK);
    */

    initial_data_write_full;
	repeat(100000) random_read_write;
    initial_data_read_full;

    //while(1) random_read_write;

	while(QUE_RINDEX != QUE_WINDEX || HTRANS != `HTRANS_IDLE)
		@(posedge HCLK);

	$display("Simulation ended without error");
	$finish;
end

parameter ADDR_WIDTH = 10;
parameter MAX_ADDR = 1 << ADDR_WIDTH;

task initial_data_write4;
integer i;
integer j;
begin
	for(i = 0; i <= MAX_ADDR; i = i + 4)
		AHBTrans4(i<<2, 1, `HSIZE_WORD, `HBURST_INCR4, i<<2, (i+1)<<2, (i+2)<<2, (i+3)<<2);
end
endtask

task initial_data_write_full;
integer i;
integer j;
begin
	for(i = 0; i <= MAX_ADDR; i = i + 64)
		AHBTransWord(i, 1, `HBURST_INCR16, 15);
end
endtask

task initial_data_read_full;
integer i;
integer j;
begin
	for(i = 0; i <= MAX_ADDR; i = i + 64)
		AHBTransWord(i, 0, `HBURST_INCR16, 15);
end
endtask

task random_read_write4;
reg [ADDR_WIDTH-1:0] haddr;
reg  hwrite;
reg  incr4;
begin
	haddr = $random;
	hwrite = $random;
	incr4 = $random/16;
	haddr[1:0] = 0;

	if(incr4)
		AHBTrans4(haddr, hwrite, `HSIZE_WORD, `HBURST_INCR4, haddr, haddr+4, haddr+8, haddr+12);
	else
		AHBTrans4(haddr, hwrite, `HSIZE_WORD, `HBURST_INCR, haddr, haddr+4, haddr+8, haddr+12);
end
endtask

task random_read_write;
reg [ADDR_WIDTH-1:0] haddr;
reg  hwrite;
reg  [2:0] hsize;
reg  [2:0] hburst;
reg  [3:0] len;
begin

    hsize   = $random;

    while(hsize[2] == 1 | hsize == 3'b011) begin
        hsize   = $random;
    end

	haddr  = $random;
	hwrite = $random;
    hburst = $random;

    /*
    hsize  = `HSIZE_WORD;
    hburst = `HBURST_WRAP8;
	hwrite = 1;
    */

    case(hburst)
        `HBURST_SINGLE: len = 0; 
        `HBURST_INCR:   len = $random;
        `HBURST_WRAP4:  len = 3; 
        `HBURST_INCR4:  len = 3; 
        `HBURST_WRAP8:  len = 7; 
        `HBURST_INCR8:  len = 7; 
        `HBURST_WRAP16: len = 15;
        `HBURST_INCR16: len = 15;
    endcase

    case(hsize)
        `HSIZE_BYTE:  haddr = haddr;
        `HSIZE_HWORD: haddr = haddr & 32'hFFFFFFFE;
        `HSIZE_WORD:  haddr = haddr & 32'hFFFFFFFC;
    endcase

    $display("Ramdom test addr[%h] write/read[%h] hsize[%h] hburst[%h] len[%h]", haddr, hwrite, hsize, hburst, len);

    case(hsize)
        `HSIZE_BYTE:  AHBTransByte(haddr, hwrite, hburst, len);
        `HSIZE_HWORD: AHBTransHalfWord(haddr, hwrite, hburst, len);
        `HSIZE_WORD:  AHBTransWord(haddr, hwrite, hburst, len); 
    endcase
end
endtask

endmodule
