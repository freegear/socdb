// Register Interface

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
  #DLY PADDR[13:2]   = Addr;
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b0;
	repeat(1) @(posedge MCK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge MCK);
	while(!PREADY) @(posedge MCK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
	repeat(3) @(posedge MCK);
end
endtask

task APBWrite;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR[13:2]   = Addr;
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(1) @(posedge MCK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge MCK);
	while(!PREADY) @(posedge MCK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
       PWRITE  = 1'b0;
	repeat(3) @(posedge MCK);
end
endtask
