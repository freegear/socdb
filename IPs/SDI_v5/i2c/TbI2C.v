
`timescale 1ns/10ps

module TbI2C;

parameter CKP1 = 5;
parameter DLY  = 1;

reg         PClk;
reg         RSTb;

// Register
reg         PENABLE     ;     // Data valid strobe 
reg         PSEL        ;     // Module select signal
reg         PWRITE      ;     // Write/nRead signal
reg  [ 7:2] PADDR       ;     // Address (used bits only)
reg  [31:0] PWDATA      ;     // Read data

wire [ 1:0] I2cInt;
//------------------------------------------------------
tri  [ 1:0] SCL;
tri  [ 1:0] SDA;

wire [ 1:0] OSCL;
wire [ 1:0] OSDA;

// create i2c lines --> pseudo open drain
assign #3 SCL[0] = OSCL[0] ? 1'bz : 1'b0;
assign #3 SDA[0] = OSDA[0] ? 1'bz : 1'b0;

assign #3 SCL[1] = OSCL[1] ? 1'bz : 1'b0;
assign #3 SDA[1] = OSDA[1] ? 1'bz : 1'b0;
 
pullup (SCL[1]);
pullup (SCL[0]); 
pullup (SDA[1]);
pullup (SDA[0]); // pullup i2c line
//------------------------------------------------------
i2c_slave_model i2c_slave_model0(
            .scl		(SCL[0]),
            .sda		(SDA[0])
);

i2c_slave_model i2c_slave_model1 (
            .scl		(SCL[1]),
            .sda		(SDA[1])
);
//------------------------------------------------------
I2C I2C(
            .Clk		(PClk),                      
            .nRst		(RSTb),                    

		.PENABLE      (PENABLE), 
		.PSEL         (PSEL), 
		.PWRITE       (PWRITE), 
		.PADDR        (PADDR), 
		.PWDATA       (PWDATA),
		
	    	.ISCL		(SCL),
	    	.ISDA		(SDA),
	    	.OSCL		(OSCL),
	    	.OSDA		(OSDA),
	    
            .I2cInt		(I2cInt)
);
//------------------------------------------------------
always #CKP1 PClk = ~PClk;

task APBRead;
input [31:0] Addr;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b0;
	repeat(1) @(posedge PClk);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PClk);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
	repeat(3) @(posedge PClk);
end
endtask

task APBWrite;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(1) @(posedge PClk);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PClk);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
       PWRITE  = 1'b0;
	repeat(3) @(posedge PClk);
end
endtask
//------------------------------------------------------
`include "./Include/i2c_task.v"
//------------------------------------------------------
always @(posedge I2cInt[0]) begin
  #100; APBWrite(8'h00, 8'h20); // Interrupt Flag Clear
  $display ("I2C Channel 0 Interrupt Occurs");
end

always @(posedge I2cInt[1]) begin
  #100; APBWrite(8'h80, 8'h20);
  $display ("I2C Channel 1 Interrupt Occurs");
end
//------------------------------------------------------
// Initialize
initial begin
  RSTb   = 0;
  PClk   = 0;

  PADDR  = 0;
  PWDATA = 0;
  PENABLE = 1'b0;
  PSEL    = 1'b0;
  PWRITE  = 1'b0;
end
//------------------------------------------------------
// Main Routine
initial begin
  repeat(18) @(posedge PClk);
  #(DLY) RSTb = 1'b1;
  $display ("Reset Disabled, Simulation Start NOW >>>");

  repeat(10) @(posedge PClk);

  i2c_task;

  repeat(3000) @(posedge PClk);

 $finish;
end
//------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../syn/I2C.sdf", I2C);
`endif
//------------------------------------------------------
initial begin
  $shm_open("TbI2C.shm");
  $shm_probe("ASC");
end
//------------------------------------------------------
endmodule
