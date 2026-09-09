task nop;
  reg nop_during;
begin
  nop_during = 1'b1;

  @(posedge HCLK) #6;
  HBUSREQ = 1'b0;
  HADDR_i = 32'h00000000;
  HTRANS_i = 2'b00;
  HBURST_i = 3'b000;
  HWRITE_i = 1'b0;
  HSIZE_i = 2'b00;
  HWDATA_i = 32'h00000000;

  nop_during = 1'b0;
end
endtask

task read;
  input  [31:0]  addr;
  output [31:0]  rdata;
  input  [1:0]   size;
  reg read_during;
begin
  read_during = 1'b1;

  @(posedge HCLK) #6;
  HBUSREQ = 1'b1;

  while (~MASTER) @(posedge HCLK) #6;

  HADDR_i = addr;
  HTRANS_i = 2'b10;
  HBURST_i = 3'b000;
  HWRITE_i = 1'b0;
  HSIZE_i = 2'b10;
  HWDATA_i = 32'h00000000;
  
  while (~HREADY) @(posedge HCLK) #6;
  @(posedge HCLK) #6;

  HTRANS_i = 2'b00;

  while (~HREADY) @(posedge HCLK) #6;

  HBUSREQ = 1'b0;
  rdata = HDATA;

  @(posedge HCLK) #6;

  read_during = 1'b0;
end
endtask

task write;
  input  [31:0]  addr;
  input  [31:0]  wdata;
  input  [1:0]   size;
  reg write_during;
begin
  write_during = 1'b1;

  @(posedge HCLK) #6;
  HBUSREQ = 1'b1;

  while (~MASTER) @(posedge HCLK) #6;

  HADDR_i = addr; 
  HTRANS_i = 2'b10;
  HBURST_i = 3'b000;
  HWRITE_i = 1'b1;
  HSIZE_i = 2'b10;
  
  while (~HREADY) @(posedge HCLK) #6;
  @(posedge HCLK) #6;

  HTRANS_i = 2'b00;
  HWDATA_i = wdata;

  while (~HREADY) @(posedge HCLK) #6;

  HBUSREQ = 1'b0;

  @(posedge HCLK) #6;

  write_during = 1'b0;
end
endtask

