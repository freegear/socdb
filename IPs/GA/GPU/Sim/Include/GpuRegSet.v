
`include "GpuPara.v"

integer d;
reg [31:0]	DDAT [0:2047];

initial begin
	$readmemh("./Rom/program.rom", DDAT);
end

task GpuRegSet;
begin
	// Download Control
	APBWrite(2'b10, QDCON, {6'b0, 11'b0, 4'b0, DL, DE});
	
	for(d=0;d<2048;d=d+1) begin
		APBWrite(2'b10, QDDAT, DDAT[d]);
	end

	// Read Download Data
	for(d=0;d<2048;d=d+1) begin
		APBRead(2'b10, QDDAT);
	end

	APBWrite(2'b10, QDCON, {6'b0, 11'b0, 4'b0, DL, 1'b0}); // Clear Download Enable

	repeat(100) @(posedge Clk);

	// Command Queue Control
	APBWrite(2'b10, CQCON, {26'b0, ECI, EEI, EDI, 2'b0, SF});
	APBWrite(2'b10, CQDAT, RSA0); // After Status Check
	APBWrite(2'b10, CQDAT, RSA1);
	APBWrite(2'b10, CQDAT, RSA2);
	APBWrite(2'b10, CQDAT, RSA3);
end
endtask
