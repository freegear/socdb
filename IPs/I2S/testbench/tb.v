/*****************************************************************
		         APB_vic testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module tb;

parameter I2S_RFIFO_DEPTH=5;
parameter I2S_TFIFO_DEPTH=5;

parameter SCLK_HALFPERIOD=1;
parameter PCLK_HALFPERIOD=11;
parameter APBDELAY=44;

reg         SYS_CLK     ;     // system clock

reg         PCLK        ;     // APB system clock
reg         PRESETn     ;     // APB system reset
reg         PENABLE     ;     // Data valid strobe 
reg         PSEL        ;     // Module select signal
reg         PWRITE      ;     // Write/nRead signal
reg  [31:0] PADDR       ;     // Address (used bits only)
reg  [31:0] PWDATA      ;     // Read data
wire [31:0] PRDATA      ;     // Write data

reg  [31:0] READ_DATA;

`define WL_8bit  2'b00
`define WL_16bit 2'b01
`define WL_24bit 2'b10
`define WL_32bit 2'b11

parameter LRClkInv    = 1'b0;
parameter DTORatio    = {2'b00, 16'h1000};
parameter MClkOn      = 1'b1;
parameter MClkOE      = 1'b1;
parameter MasterSlave = 1'b0;

parameter TxEn          = 1'b1;
parameter TxWordLen     = `WL_8bit;
parameter TxLeftJust    = 1'b1;
parameter TxFifoURIntEn = 1'b1;
parameter TxDMAIntEn    = 1'b1;

parameter RxEn          = 1'b1;
parameter RxWordLen     = `WL_8bit;
parameter RxLeftJust    = 1'b1;
parameter RxFifoORIntEn = 1'b1;
parameter RxDMAIntEn    = 1'b1;

`define ADDR_CLKCTRL   32'h00000000
`define ADDR_CTRL      32'h00000004
`define ADDR_STATUS    32'h00000008
`define ADDR_DATA      32'h0000000C

always #PCLK_HALFPERIOD	PCLK = ~PCLK;
always #SCLK_HALFPERIOD	SYS_CLK = ~SYS_CLK;

reg [31:0] RandomData;
initial
begin
	
  SYS_CLK   = 0;
  PCLK 		= 0;     // APB system clock
  PRESETn 	= 0;     // APB system reset
  PENABLE 	= 0;     // Data valid strobe 
  PSEL   	= 0;     // Module select signal
  PWRITE  	= 0;     // Write/nRead signal
  PADDR  	= 0;     // Address (used bits only)
  PWDATA  	= 0;     // Read data


  #(APBDELAY*10) PRESETn	= 1;

$display("****************************************************");
$display(" I2S Controller                                     ");
$display("****************************************************");

  #APBDELAY apb_write(`ADDR_CLKCTRL, {~MasterSlave, LRClkInv, 2'b00, 8'h00, MClkOE, MClkOn, DTORatio});
  #APBDELAY write_randomdata;
  if(TxWordLen[1] == 1)
	  #APBDELAY write_randomdata;
  #APBDELAY apb_write(`ADDR_CTRL, {RxEn, 1'b0, RxDMAIntEn, RxFifoORIntEn, 1'b0, RxWordLen, RxLeftJust, 2'b00, 6'b000000, TxEn,1'b0,TxDMAIntEn, TxFifoURIntEn, 1'b0, TxWordLen, TxLeftJust, 2'b00, 6'b000000});

  while(1)
  begin
	#APBDELAY apb_read(`ADDR_STATUS);
`ifdef SINGLE_WRITE
	if(READ_DATA[I2S_TFIFO_DEPTH:0] == 0)
`else
	if(!(READ_DATA[I2S_TFIFO_DEPTH]))
`endif
	begin
		#APBDELAY write_randomdata;
		if(TxWordLen[1] == 1)
			#APBDELAY write_randomdata;
	end
	if(READ_DATA[16+I2S_RFIFO_DEPTH:16] != 0)
	begin
		#APBDELAY apb_read(`ADDR_DATA);
		$display($time, "Reading FIFO data %h", READ_DATA);
	end
  end
$display("*** End of Simulation");
$finish;

end

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
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b1;
			PADDR = reg_addr;
			PWDATA = reg_write;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				;
			PENABLE = 1'b0;
			PSEL    = 1'b0;
			PWDATA  = 32'dz;
		end
endtask

task write_randomdata;
	begin
		RandomData = $random;
		$display($time, "Writing random data[%h] into FIFO", RandomData);
		apb_write(`ADDR_DATA, RandomData);
	end
endtask

task apb_read; // read
		input [31:0] reg_addr;
		begin
			@(negedge PCLK);
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

task apb_read_check; // read
		input [31:0] reg_addr;
		input [31:0] reg_data;
		begin
			@(negedge PCLK);
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			if(READ_DATA != reg_data)
			begin
				$display($time, " Read Error : Read %h when %h expected ", READ_DATA, reg_data);
				$stop;
			end
			PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

wire Interrupt;
wire TxDMAReq;
wire RxDMAReq;
wire MCLK;
tri  BCLK;
tri  LRCLK;
wire SDIN;
wire SDOUT;

I2S_tbtop #(I2S_RFIFO_DEPTH, I2S_TFIFO_DEPTH) I2SCore
(
		.SYS_CLK(SYS_CLK),

		.PCLK(PCLK),
		.PRESETn(PRESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL),
		.PWRITE(PWRITE),
		.PADDR(PADDR[3:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA),

		.Interrupt(Interrupt),

		.TxDMAReq(TxDMAReq),
		.RxDMAReq(RxDMAReq),

		.MCLK(MCLK),
		.BCLK(BCLK),
		.LRCLK(LRCLK),
		.SDIN(SDIN),
		.SDOUT(SDOUT)
);

I2S_DAC DAC
(
		.MASTER(MasterSlave),
//		.WORD_LEN(TxWordLen),
		.WORD_LEN(`WL_32bit),
		.LJUST(TxLeftJust),

		.MCLK(MCLK),
		.BCLK(BCLK),
		.LRCLK(LRCLK),
		.SDIN(SDOUT)
);

I2S_ADC ADC
(
		.MASTER(MasterSlave),
//		.WORD_LEN(RxWordLen),
		.WORD_LEN(`WL_32bit),
		.LJUST(RxLeftJust),

		.MCLK(MCLK),
		.BCLK(BCLK),
		.LRCLK(LRCLK),
		.SDOUT(SDIN)
);

endmodule

