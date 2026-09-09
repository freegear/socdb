// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Converter64to32.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : 64bit AXI Master Interface to 32bit Converter
//                     : Not General One.
//                     : This module can only be used with graphic accel.
//                     : which generates 64bit/INCR request and no ID.
//  =============================================================================

`timescale 1ns/1ps

module Converter64to32 
(
//	AXI Interface
		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWADDR64 ,
		AWLEN64  ,
		AWSIZE64 ,
		AWBURST64,
		AWVALID64,
		AWREADY64,

		// Write Data Channel
		WDATA64  ,
		WSTRB64  ,
		WLAST64  ,
		WVALID64 ,
		WREADY64 ,

		// Write Response Channel
		BRESP64  ,
		BVALID64 ,
		BREADY64 ,

		// Read Address Channel
		ARADDR64 ,
		ARLEN64  ,
		ARSIZE64 ,
		ARBURST64,
		ARVALID64,
		ARREADY64,

		// Read Data Channel
		RDATA64  ,
		RRESP64  ,
		RLAST64  ,
		RVALID64 ,
		RREADY64 ,

		AWADDR32 ,
		AWLEN32  ,
		AWSIZE32 ,
		AWBURST32,
		AWVALID32,
		AWREADY32,

		// Write Data Channel
		WDATA32  ,
		WSTRB32  ,
		WLAST32  ,
		WVALID32 ,
		WREADY32 ,

		// Write Response Channel
		BRESP32  ,
		BVALID32 ,
		BREADY32 ,

		// Read Address Channel
		ARADDR32 ,
		ARLEN32  ,
		ARSIZE32 ,
		ARBURST32,
		ARVALID32,
		ARREADY32,

		// Read Data Channel
		RDATA32  ,
		RRESP32  ,
		RLAST32  ,
		RVALID32 ,
		RREADY32
);

`define RESP_OKAY	2'b00
`define RESP_ERROR	2'b01

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  [31:0]           AWADDR64;
input  [3:0]            AWLEN64;
input  [2:0]            AWSIZE64;
input  [1:0]            AWBURST64;
input                   AWVALID64;
output                  AWREADY64;

input  [63:0]           WDATA64;
input  [7:0]            WSTRB64;
input                   WLAST64;
input                   WVALID64;
output                  WREADY64;

output [1:0]            BRESP64;
output                  BVALID64;
input                   BREADY64;

input  [31:0]           ARADDR64;
input  [3:0]            ARLEN64;
input  [2:0]            ARSIZE64;
input  [1:0]            ARBURST64;
input                   ARVALID64;
output                  ARREADY64;

output [63:0]           RDATA64;
output [1:0]            RRESP64;
output                  RLAST64;
output                  RVALID64;
input                   RREADY64;

output [31:0]           AWADDR32;
output [3:0]            AWLEN32;
output [2:0]            AWSIZE32;
output [1:0]            AWBURST32;
output                  AWVALID32;
input                   AWREADY32;

output [31:0]           WDATA32;
output [3:0]            WSTRB32;
output                  WLAST32;
output                  WVALID32;
input                   WREADY32;

input  [1:0]            BRESP32;
input                   BVALID32;
output                  BREADY32;

output [31:0]           ARADDR32;
output [3:0]            ARLEN32;
output [2:0]            ARSIZE32;
output [1:0]            ARBURST32;
output                  ARVALID32;
input                   ARREADY32;

input  [31:0]           RDATA32;
input  [1:0]            RRESP32;
input                   RLAST32;
input                   RVALID32;
output                  RREADY32;

//
// Read Processing
//

// Read Request Channel
reg  [31:0] ARADDR32;
reg         ARVALID32;
reg  [3:0]  ARLEN32;
assign ARSIZE32 = 3'b010;		/* always WORD */
assign ARBURST32 = 2'b01;		/* always INCR */
reg    MoreReadRequest;
reg [2:0] ARLEN64_lower3bit;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		ARVALID32     <= 0;
		MoreReadRequest <= 0;
	end
	else
	begin
		if(ARVALID64 && ARREADY64)
		begin
			// Output First 32 bit Read Request
			ARVALID32 <= 1;
			ARADDR32  <= ARADDR64;
			ARLEN32   <= (ARLEN64[3]) ? 4'b1111 /* 16 */ : {ARLEN64[2:0], 1'b1};
			ARLEN64_lower3bit <= ARLEN64[2:0];
			MoreReadRequest <= ARLEN64[3];
		end
		else if(ARREADY32 && ARVALID32)
		begin
			if(MoreReadRequest)
			begin
				// Output Second 32 bit Read Request if needed
				ARVALID32 <= 1;
				ARADDR32  <= ARADDR32 + 32'd64;
				ARLEN32   <= {ARLEN64_lower3bit, 1'b1};
				MoreReadRequest <= 0;
			end
			else
				ARVALID32 <= 0;		// No more request
		end
	end
end

reg ReadRequestQueFull;
assign ARREADY64 = ((!ARVALID32) | (ARVALID32 == 1 && MoreReadRequest == 0 && ARREADY32 == 1)) && !ReadRequestQueFull;

// Read Data Channel
reg [63:0] read_data;
reg        read_counter;
reg        read_data_valid;
// Read Request Que : Only store information about splitted request.
reg        ReadRequestQueIndex;
reg        read_last_mask0;
reg        read_last_mask1;

reg        read_response;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		read_counter <= 0;
		read_response <= 0;
	end
	else
	begin
		if(RVALID32 & RREADY32)
			read_counter <= ~read_counter;

		if(RVALID32 & RREADY32)
		begin
			if(read_counter == 0)
			begin
				read_data[31:0]  <= RDATA32;
				if(RRESP32 != `RESP_OKAY)
					read_response <= 1;
				else
					read_response <= 0;
			end
			else
			begin
				read_data[63:32] <= RDATA32;
				if(RRESP32 != `RESP_OKAY)
					read_response <= 1;
			end
		end
	end
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		read_data_valid <= 0;
	else if(read_counter == 1 && RVALID32 && RREADY32)
		read_data_valid <= 1;
	else if(RREADY64 == 1'b1)
		read_data_valid <= 0;
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		ReadRequestQueIndex <= 0;
		ReadRequestQueFull <= 0;
		read_last_mask0 <= 1;
		read_last_mask1 <= 1;
	end
	else if(ARREADY64 && ARVALID64)
	begin
		if(ReadRequestQueIndex == 0)
		begin
			read_last_mask0 <= !ARLEN64[3];
			ReadRequestQueIndex <= 1;
		end
		else if(ReadRequestQueIndex == 1)
		begin
			if(RLAST32 && RVALID32 && RREADY32 && read_last_mask0 == 1)
			begin
				read_last_mask0 <= !ARLEN64[3];
			end
			else
			begin
				if(RLAST32 && RVALID32 && RREADY32)
					read_last_mask0 <= 1;

				read_last_mask1 <= !ARLEN64[3];
				ReadRequestQueFull <= 1;
			end
		end
	end
	else if(RLAST32 && RVALID32 && RREADY32)
	begin
		if(read_last_mask0 == 0)
			read_last_mask0 <= 1;
		else
		begin
			read_last_mask0 <= read_last_mask1;
			read_last_mask1 <= 1;

			if(!ReadRequestQueFull)
				ReadRequestQueIndex <= ~ReadRequestQueIndex;

			ReadRequestQueFull <= 0;
		end
	end
end

reg    RLAST64;
always @(posedge ACLK)
begin
	if(RVALID32 && RREADY32)
	begin
		RLAST64 <= RLAST32 & read_last_mask0;
	end
	else if(RREADY64)
		RLAST64 <= 1'b0;
end
assign RVALID64 = read_data_valid;
assign RDATA64  = read_data;
assign RRESP64  = (read_response) ? `RESP_ERROR : `RESP_OKAY;
//assign RLAST64  = RLAST32_ff & read_last_mask0;

assign RREADY32 = (~read_data_valid) | RREADY64;

//
// Write Processing
//

// Write Request Channel
reg  [31:0] AWADDR32;
reg         AWVALID32;
reg  [3:0]  AWLEN32;
assign AWSIZE32 = 3'b010;		/* always WORD */
assign AWBURST32 = 2'b01;		/* always INCR */
reg    MoreWriteRequest;
reg [2:0] AWLEN64_lower3bit;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AWVALID32     <= 0;
		MoreWriteRequest <= 0;
	end
	else
	begin
		if(AWVALID64 && AWREADY64)
		begin
			// Output First 32 bit Read Request
			AWVALID32 <= 1;
			AWADDR32  <= AWADDR64;
			AWLEN32   <= (AWLEN64[3]) ? 4'b1111 /* 16 */ : {AWLEN64[2:0], 1'b1};
			AWLEN64_lower3bit <= AWLEN64[2:0];
			MoreWriteRequest <= AWLEN64[3];
		end
		else if(AWREADY32 && AWVALID32)
		begin
			if(MoreWriteRequest)
			begin
				// Output Second 32 bit Read Request if needed
				AWVALID32 <= 1;
				AWADDR32  <= AWADDR32 + 32'd64;
				AWLEN32   <= {AWLEN64_lower3bit, 1'b1};
				MoreWriteRequest <= 0;
			end
			else
				AWVALID32 <= 0;		// No more request
		end
	end
end

reg WriteRequestQueFull;
assign AWREADY64 = ((!AWVALID32) | (AWVALID32 == 1 && MoreWriteRequest == 0 && AWREADY32 == 1)) && !WriteRequestQueFull;

// Write Data Channel
reg [63:0] write_data;
reg [7:0]  write_strb;
reg        write_last;
reg        write_counter;
reg [3:0]  wlast_counter;
reg        write_data_valid;

// Write Request Que : Only store information about splitted request.
reg        WriteRequestQueIndex;
reg        write_resp_mask0;
reg        write_resp_mask1;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		write_counter <= 0;
	end
	else
	begin
		if(WVALID32 && WREADY32)
			write_counter <= ~write_counter;
	end
end

assign WVALID32 = write_data_valid;
assign WDATA32  = (write_counter == 0) ? write_data[31:0] : write_data[63:32];
assign WSTRB32  = (write_counter == 0) ? write_strb[3:0]  : write_strb[7:4];
//assign WLAST32  = (write_counter == 1 && write_last) | ((wlast_counter == 4'b1111) && (write_resp_mask0 == 0));
assign WLAST32  = (write_counter == 1 && write_last) | (wlast_counter == 4'b1111);

assign WREADY64 = (!write_data_valid) | ((write_counter == 1) && WREADY32);

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		write_data_valid <= 0;
	else
	begin
		if(WVALID64 && WREADY64)
		begin
			write_data_valid <= 1;
			write_data <= WDATA64;
			write_strb <= WSTRB64;
			write_last <= WLAST64;
		end
		else if(write_counter == 1 && WREADY32)
			write_data_valid <= 0;
	end
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		wlast_counter <= 0;
	else
	begin
		if(WVALID32 && WREADY32)
		begin
			if(WLAST32)
				wlast_counter <= 0;
			else
				wlast_counter <= wlast_counter + 1'b1;
		end
	end
end

// Write Response Channel
reg    write_response;
assign BVALID64 = BVALID32 & write_resp_mask0;
assign BRESP64  = (write_response) ? `RESP_ERROR : BRESP32;

assign BREADY32 = (write_resp_mask0 == 0) | BREADY64;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		write_response <= 0;
	else
	begin
		if(write_resp_mask0 == 1 && BVALID64 && BREADY64)
			write_response <= 0;
		else if(BVALID32 && BREADY32)
		begin
			if(BRESP32 != `RESP_OKAY)
				write_response <= 1;
		end
	end
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		WriteRequestQueIndex <= 0;
		WriteRequestQueFull <= 0;
		write_resp_mask0 <= 1;
		write_resp_mask1 <= 1;
	end
	else if(AWREADY64 && AWVALID64)
	begin
		if(WriteRequestQueIndex == 0)
		begin
			write_resp_mask0 <= !AWLEN64[3];
			WriteRequestQueIndex <= 1;
		end
		else if(WriteRequestQueIndex == 1)
		begin
			if(BVALID64 && BREADY64)
			begin
				write_resp_mask0 <= !AWLEN64[3];
			end
			else
			begin
				if(BVALID32 && BREADY32 && write_resp_mask0 == 0)
					write_resp_mask0 <= 1;

				write_resp_mask1 <= !AWLEN64[3];
				WriteRequestQueFull <= 1;
			end
		end
	end
	else if(BVALID32 && BREADY32)
	begin
		if(write_resp_mask0 == 0)
			write_resp_mask0 <= 1;
		else
		begin
			write_resp_mask0 <= write_resp_mask1;
			write_resp_mask1 <= 1;

			if(!WriteRequestQueFull)
				WriteRequestQueIndex <= ~WriteRequestQueIndex;

			WriteRequestQueFull <= 0;
		end
	end
end

// synopsys translate_off
// Protocol Checker
always @(posedge ACLK)
begin
	if(ARVALID64 == 1)
	begin
		if(ARSIZE64 != 3'b011)
			$display("Request other than 64bit Request");
		if(ARBURST64 != 2'b01)
			$display("Not INCR Burst Request");
	end
end

always @(posedge ACLK)
begin
	if(AWVALID64 == 1)
	begin
		if(AWSIZE64 != 3'b011)
			$display("Request other than 64bit Request");
		if(AWBURST64 != 2'b01)
			$display("Not INCR Burst Request");
	end
end
// synopsys translate_on
endmodule
