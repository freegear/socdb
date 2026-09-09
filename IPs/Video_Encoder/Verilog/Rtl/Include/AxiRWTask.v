
reg  [31:0]           READErr;

initial
begin
	
	READErr		= 0;

	AWVALID     = 0;
	WVALID      = 0;
	BREADY      = 1;	// always high
	
//	ARVALID     = 0;
//	RREADY      = 1;	// always high
end
//--------------------------------------------------
// TASK for write and read 
task awrite; // address write channel start
	input [II:0] wid;
	input [31:0] awaddr;
	input [3:0]  len;
	input [2:0]  awsize;
	input [1:0]  awburst;
		begin
			@(negedge ACLK);
			AWID = wid;
			AWADDR = awaddr;
			AWLEN = len-1;
			AWSIZE = awsize;
			AWBURST = awburst;
			AWVALID = 1'b1;
			@(posedge ACLK);
			while(AWREADY == 1'b0) @(posedge ACLK);
			#1 AWVALID = 1'b0;
		end
endtask

task writedata;	// write data channel
	input [DD:0] wdata;
	input [BB:0] wstrb;
	input [3:0] length;
		begin
			@(negedge ACLK);
			WDATA = wdata;
			WSTRB = wstrb;
			WVALID = 1'b1;
			@(posedge ACLK);
			while(WREADY == 1'b0) @(posedge ACLK);
			#1 WVALID = 1'b0;
/*
			for (j=0;j<length+1;j=j+1) begin
				WLAST  = (length==j);
			 	if(WREADY) @(posedge ACLK);
	 			else while(!WREADY) @(posedge ACLK);
			 	#1 WDATA  = wdata;
			 	   WVALID = 1'b0;
			end
*/
		end
endtask

/*
task aread; // address read channel start
	input [II:0] rid;
	input [31:0] araddr;
	input [3:0]  len;
	input [2:0]  arsize;
	input [1:0]  arburst;
		begin
			@(negedge ACLK);
			ARID = rid;
			ARADDR = araddr;
			ARLEN = len-1;
			ARSIZE = arsize;
			ARBURST = arburst;
			ARVALID = 1'b1;
			@(posedge ACLK);
			while(ARREADY == 1'b0) @(posedge ACLK);
			#1 ARVALID = 1'b0;
		end
endtask

reg [DD:0] READ_DATA;
task readdata_check;	// write data channel
	input [DD:0] rdata;
		begin
			@(posedge ACLK);
			while(RVALID == 1'b0) @(posedge ACLK);
			if(RDATA != rdata)
			begin
				READErr = READErr + 1'b1;
				$display($time; " Read Error : Read %h when %h expected "; RDATA; rdata);
			end
			#1;
		end
endtask
*/
//--------------------------------------------------