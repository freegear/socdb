// Register Interface

initial begin
	PENABLE = 0;
	PSEL    = 0;
	PWRITE  = 0;
	PADDR   = 0;
	PWDATA  = 0;
end

task APBRead;
input [ 1:0] psel;
input [31:0] Addr;
begin
  #DLY PADDR   = Addr[9:2];
       PENABLE = 1'b0;
       PSEL    = psel;
       PWRITE  = 1'b0;
	repeat(2) @(posedge ACLK);
  #DLY PENABLE = 1'b1;
	repeat(2) @(posedge ACLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 2'b0;
	repeat(4) @(posedge ACLK);
end
endtask

task APBWrite;
input [ 1:0] psel;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR   = Addr[9:2];
       PENABLE = 1'b0;
       PSEL    = psel;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(2) @(posedge ACLK);
  #DLY PENABLE = 1'b1;
	repeat(2) @(posedge ACLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 2'b0;
       PWRITE  = 1'b0;
	repeat(4) @(posedge ACLK);
end
endtask
