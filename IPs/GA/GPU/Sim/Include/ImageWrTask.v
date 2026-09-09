`define SIZE_BYTE	3'b000
`define SIZE_HWORD	3'b001
`define SIZE_WORD	3'b010
`define SIZE_DWORD	3'b011

// AWBURST/ARBURST
`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

integer i, j, k;

parameter WBS = 4;	// Image Write Burst Size

assign WLAST = (k==WBS-1);

reg ClrCBAddr;
reg IncCBAddr;
integer CBAddr;

always @(negedge nRST or posedge Clk)
   if 		(!nRST) CBAddr <= 0;
   else if (ClrCBAddr) CBAddr <= 0;
   else if (IncCBAddr & WREADY & WVALID)	
   					CBAddr <= CBAddr + 1;

task CmdBW;
begin
	ClrCBAddr = 0;
	IncCBAddr = 0;
	for(i=0;i<=((32)/WBS);i=i+1) begin
		awrite(1, RSA0+(CBAddr<<2), WBS, `SIZE_WORD, `BURST_INCR);
		for(k=0;k<WBS;k=k+1) begin
			IncCBAddr = 1;
			writedata(CBAddr, {(BB+1){1'b1}}, WBS-1);
		end
		k = 0;
		IncCBAddr = 0;
	end
	ClrCBAddr = 1;
	repeat(10) @(posedge Clk);
	ClrCBAddr = 0;

	for(i=0;i<=((16)/WBS);i=i+1) begin
		awrite(1, RSA1+(CBAddr<<2), WBS, `SIZE_WORD, `BURST_INCR);
		for(k=0;k<WBS;k=k+1) begin
			IncCBAddr = 1;
			writedata(CBAddr, {(BB+1){1'b1}}, WBS-1);
		end
		k = 0;
		IncCBAddr = 0;
	end
end
endtask
