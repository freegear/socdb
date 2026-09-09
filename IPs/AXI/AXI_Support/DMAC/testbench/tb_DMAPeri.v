/*****************************************************************
		         APB_DMAPeri testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module tb_DMAPeri;

parameter CLK_HALFPERIOD=15;
parameter APBDELAY=120;
parameter UNIT_DELAY=1;

reg         PCLK        ;     // APB system clock
reg         PRESETn     ;     // APB system reset
reg         PENABLE     ;     // Data valid strobe 
reg         PSEL        ;     // Module select signal
reg         PWRITE      ;     // Write/nRead signal
reg  [31:0] PADDR       ;     // Address (used bits only)
reg  [31:0] PWDATA      ;     // Read data
wire [31:0] PRDATA      ;     // Write data
wire [31:0] PRDATA0     ;     // Write data
wire [31:0] PRDATA1     ;     // Write data

assign PRDATA = (PADDR[3] == 0) ? PRDATA0 : PRDATA1;

reg  [31:0] READ_DATA;

reg  [31:0] INTERRUPT_SRC;
wire        nFIQ;
wire        nIRQ;
wire [7:0]  LEVEL_PM;
wire [7:0]  POLARITY_PM;
wire [7:0]  INTMSK_PM;

integer loop_count;
reg  [31:0] loop_mask;
reg  [31:0] loop_mask2;
reg  [31:0] inverted_loop_mask;
reg  [31:0] loop_vecaddr;
reg  [31:0] loop_vecaddr2;

`define ADDR_CONTROL 32'h00000000	// Control Register @ 0x00
`define ADDR_FIFO    32'h00000004	// FIFO             @ 0x01

always #CLK_HALFPERIOD	PCLK = ~PCLK;

initial
begin
	
  PCLK 		= 0;     // APB system clock
  PRESETn 	= 0;     // APB system reset
  PENABLE 	= 0;     // Data valid strobe 
  PSEL   	= 0;     // Module select signal
  PWRITE  	= 0;     // Write/nRead signal
  PADDR  	= 0;     // Address (used bits only)
  PWDATA  	= 0;     // Read data

  INTERRUPT_SRC = 32'h00000000;

  #APBDELAY PRESETn	= 1;

$display("****************************************************");
$display("APB DMA Peripheral Test bench                       ");
$display("****************************************************");

#APBDELAY	apb_write(32'h00000000 | `ADDR_CONTROL, 1);	// enable device
#APBDELAY	apb_write(32'h00000008 | `ADDR_CONTROL, 1);	// enable device

repeat(100) fifo_data_transfer;

$finish;
end

task fifo_data_transfer;
	begin
		wait_until_both_fifo_free;
		#APBDELAY apb_read(32'h00000000|`ADDR_FIFO);
		#APBDELAY apb_write(32'h00000008|`ADDR_FIFO, READ_DATA);
	end
endtask

task wait_until_both_fifo_free;
	while(DMAPeri0.FifoEmpty == 1 || DMAPeri1.FifoFull == 1)
		@(posedge PCLK);
endtask

task check; // read
		input true;
		begin
			if(!true)
			begin
				$display($time, " Check Failed");
				$stop;
			end
		end
endtask

// TASK for write and read 
task apb_write; // write
	input [31:0] reg_addr;
	input [31:0] reg_write;
		begin
			@(negedge PCLK);
			#UNIT_DELAY PENABLE = 1'b0;
			@(posedge PCLK);
			#UNIT_DELAY PSEL = 1'b1;
			PWRITE = 1'b1;
			PADDR = reg_addr;
			PWDATA = reg_write;
			@(posedge PCLK);
			#UNIT_DELAY	PENABLE = 1'b1;
			@(posedge PCLK)
				$display($time, " address [%h]      write data [%h]", reg_addr, reg_write);
			#UNIT_DELAY PENABLE = 1'b0;
			PSEL    = 1'b0;
			PWDATA  = 32'dz;
		end
endtask

task apb_read; // read
		input [31:0] reg_addr;
		begin
			@(negedge PCLK);
			#UNIT_DELAY PENABLE = 1'b0;
			@(posedge PCLK);
			#UNIT_DELAY PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK);
			#UNIT_DELAY 	PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			$display($time, " address [%h]      read  data [%h]", reg_addr, READ_DATA);
			#UNIT_DELAY PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

task apb_read_check; // read
		input [31:0] reg_addr;
		input [31:0] reg_data;
		begin
			@(negedge PCLK);
			#UNIT_DELAY PENABLE = 1'b0;
			@(posedge PCLK);
			#UNIT_DELAY PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK);
			#UNIT_DELAY 	PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			$display($time, " address [%h]      read  data [%h]", reg_addr, READ_DATA);
			if(READ_DATA != reg_data)
			begin
				$display($time, " Read Error : Read %h when %h expected ", READ_DATA, reg_data);
				$stop;
			end
			#UNIT_DELAY PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

DMAPeri #(.STREAM_SINK(0), .DATA_SIZE(2'b00)) DMAPeri0
(
//APB
	.PCLK(PCLK)         ,
	.PRESETn(PRESETn)   ,
	.PENABLE(PENABLE)   ,
	.PSEL(PSEL&(~PADDR[3])),
	.PWRITE(PWRITE)     ,
	.PADDR(PADDR[2])    ,
	.PWDATA(PWDATA)     ,
	.PRDATA(PRDATA0)     ,

// DMA Req/Ack
	.DMA_REQ(),
	.DMA_ACK(1'b0)
);

DMAPeri #(.STREAM_SINK(1), .DATA_SIZE(2'b00)) DMAPeri1
(
//APB
	.PCLK(PCLK)         ,
	.PRESETn(PRESETn)   ,
	.PENABLE(PENABLE)   ,
	.PSEL(PSEL&PADDR[3]),
	.PWRITE(PWRITE)     ,
	.PADDR(PADDR[2])    ,
	.PWDATA(PWDATA)     ,
	.PRDATA(PRDATA1)     ,

// DMA Req/Ack
	.DMA_REQ(),
	.DMA_ACK(1'b0)
);

endmodule

