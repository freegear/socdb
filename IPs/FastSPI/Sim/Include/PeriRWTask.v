// Register Interface

parameter DLY = 10;

initial begin
	PENABLE = 0;
	PSEL    = 0;
	PWRITE  = 0;
	PADDR   = 0;
	PWDATA  = 0;
end

task APBRead;
input [31:0] Addr;
begin
  #DLY PADDR   = Addr[9:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b0;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask

task APBWrite;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR   = Addr[9:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
       PWRITE  = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask
