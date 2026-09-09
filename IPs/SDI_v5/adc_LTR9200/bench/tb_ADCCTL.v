/***********************************************************************
   
	Register setting address

	MCR             0x00(Write)
	DCH00	        0x04(Read)
	DCH01		0x08(Read)
	DCH02		0x0c(Read)
	DCH03		0x10(Read)
	DCH04		0x14(Read)
	DCH05		0x18(Read)
	
*************************************************************************/


`timescale 1 ns/ 100ps
`define	MCR_REG 32'b0111_1111_1000_0000_0000_0000_0000_0001

module tb_top_ADCCTL;

	reg	RSTb;
	reg	pclk;
	reg		CLK_ADCCLK;

	reg	[31:0] paddr;
	reg	[31:0] pwdata;

	reg		psel;
	reg 		pwrite;
	reg 		penable;
	reg	[5:0]	AIN;

	wire	INTb_ADCCTRL;
	wire	[31:0]	prdata;


	wire            dly_psel, dly_penable, dly_pwrite;
	wire   	[31:0]  dly_paddr, dly_pwdata;

	assign #5 dly_psel = psel;
	assign #5 dly_penable = penable;
	assign #5 dly_pwrite = pwrite;
	assign #5 dly_paddr = paddr;
	assign #5 dly_pwdata = pwdata;


	always 
		#10	pclk       = ~pclk;
	
	always 
		#500	CLK_ADCCLK = ~CLK_ADCCLK;

	initial begin 
		
	       	// define the intial value of the input data
		// setting the reset 

		pclk       = 1'b0;
		CLK_ADCCLK = 1'b0;
		penable	   = 1'b0;
		paddr	   = 0;
		pwdata	   = 0;
		psel	   = 0;
		pwrite	   = 0;
		AIN	   = 6'b101010;
		RSTb	   = 1;

		#100	RSTb = 0;
		#100	RSTb = 1;
		
		// register write & read
		
		apb_write(32'h00, `MCR_REG);
		
		end

	// Check intrrupt 
	//
	
	
	
	always	@(posedge pclk) begin

		if(!INTb_ADCCTRL) begin

			apb_write(32'h00,  32'b0000_0000_0000_0000_0000_0001_0000_0000);
			apb_read (32'h04);
			apb_read (32'h08);
			apb_read (32'h0C);
			apb_read (32'h10);
			apb_read (32'h14);
			apb_read (32'h18);
			
		end
	end

	// TASK for write and read 
	task apb_write; // write
		input [31:0] reg_addr;
		input [31:0] reg_write;
		begin
			@(negedge pclk);
				penable = 1'b0;
			@(posedge pclk);
				psel = 1'b1;
				pwrite = 1'b1;
				paddr = reg_addr;
				pwdata = reg_write;
			@(posedge pclk)
				penable = 1'b1;
			@(posedge pclk)
				$display($time, " << address [%h]      write data [%h] >> ", reg_addr, reg_write);
				penable = 1'b0;
				psel = 1'b0;
		end
	endtask	

	task apb_read; // read
		input [31:0] reg_addr;
		begin
			@(negedge pclk);
				penable = 1'b0;
			@(posedge pclk);
				psel = 1'b1;
				pwrite = 1'b0;
				paddr = reg_addr;
			@(posedge pclk)
				penable = 1'b1;
			@(posedge pclk)
				$display($time, " << address [%h]      read data [%h] >> ", reg_addr, prdata );
				penable = 1'b0;
				psel = 1'b0;
		end
	endtask	
	

	
endmodule
