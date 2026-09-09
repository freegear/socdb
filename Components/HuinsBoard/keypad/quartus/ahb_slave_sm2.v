`include "ahb_slave_include.v"

//TOP MODULE
module ahb_slave_sm2( HSEL, 
			 HCLOCK,
			 HADDRESS,
			 HWRITE,
			 HTRANS,
			 HSIZE,
			 HBURST,
			 HRESETn,
			 HWDATA,
			 HRDATA,
			 HRESP,
			 HREADY,
			 reg_write,
			 reg_address,
			 reg_wdata,
			 wait_sig,
			 reg_rdata);

// INPUTS
	input		 HSEL;		//Chip enable
	input [31:0] HADDRESS;          //AHB Address signals
	input [31:0] HWDATA;		//Data lines
	input		 HWRITE;	//High = Write Low = Read
	input [1:0]  HTRANS;		//Transfer type. Only nonseq is supported
	input [1:0]  HSIZE;		//Size of data packet. Only 32 is supported
        input [2:0]  HBURST;		//Size of burst. Only 1 is supported
	input		 HRESETn;	//System reset. Active low
	input        HCLOCK;		//system clock
	input [31:0] reg_rdata;		//read data from register file
	input		 wait_sig;	//signals that the slave should wait
	    
// OUTPUTS	
	output [1:0]  HRESP;		//Slave response to status of xfer
        output [31:0] HRDATA;		//Read Data bus
	output [31:0] reg_address;	//address written to register file
	output 	      reg_write;	//register file write/read signal
	output [31:0] reg_wdata;	//Data written to register file
	output        HREADY;		//Insert wait states

//Internal Declarations
	reg [1:0]  HRESP;		//Statemachine output
	reg [31:0] haddress_r;		//Used to latch HADDRESS During Address phase
	reg 	   hwrite_r;		//Used to latch HWRITE During Address phase
	reg [1:0]  slave_state;		//State machine state
	reg	   HREADY_r;		//Internal reg
	reg	   HREADY;		//HREADY output
	reg	   latch_bus;		//latched data buses
	reg	[31:0] reg_wdata;       //write data to register file

//PARAMETERS
parameter ADDRESS_PHASE = 2'b00, 	//State machine states
	  DATA_PHASE = 2'b10,
	  BURST_PHASE = 2'b11,
	  ERROR_PHASE = 2'b01;


//Main Code
assign HRDATA = reg_rdata ;    
assign reg_address = haddress_r;
assign reg_write = hwrite_r; 

	always @(posedge HCLOCK or negedge HRESETn ) begin
		if(HRESETn == 1'b0) begin			//Async Reset
			slave_state <= ADDRESS_PHASE;
			HRESP <= `OKAY;
			HREADY_r <= 1'b1;
			latch_bus <= 1'b0;
			HRESP <= 2'b00;
    			haddress_r <= 0;
			hwrite_r <= 0;
	    end
		else begin
			case (slave_state)
				ADDRESS_PHASE : begin
					if(HSEL == 1'b0) begin	//Slave not selected
						slave_state <= ADDRESS_PHASE;
						HREADY_r <= 1'b1;
						HRESP <= `OKAY;
				    	latch_bus <= 1'b0;
					end
					else if(HTRANS == `IDLE)begin
				    	slave_state <= ADDRESS_PHASE;
				    	HREADY_r <= 1'b1;
				    	HRESP <= `OKAY;
				    	latch_bus <= 1'b0;
					end
					else if(HTRANS == `NONSEQ)begin	  //Single transaction						
				    	haddress_r <= HADDRESS;		  //latch in address and control
				    	hwrite_r <= HWRITE;
				    	slave_state <= DATA_PHASE;
				    	HRESP <= `OKAY;
				    	latch_bus <= 1'b1;
					end
				end
        
				BURST_PHASE: begin
					if(HTRANS == `SEQ) begin
						haddress_r <= HADDRESS;
						hwrite_r <= HWRITE;
						slave_state <= BURST_PHASE;
						HRESP <= `OKAY;
						HREADY_r <= 1'b1;
						latch_bus <= 1'b1;
					end
					else if(HTRANS == `BUSY)begin
			    		HRESP <= `OKAY;
						HREADY_r <= 1'b1;
						slave_state <= BURST_PHASE;
						latch_bus <= 1'b0;
					end
			    	else begin
						slave_state <= ADDRESS_PHASE;
						HRESP <= `OKAY;
			    		HREADY_r <= 1'b1;
						latch_bus <= 1'b0;
					end
		    	end

				ERROR_PHASE:begin
					slave_state <= ADDRESS_PHASE;
					HREADY_r <= 1'b0;
					HRESP <= `ERROR;
					latch_bus <= 1'b0;
		     	end

				default: begin	//Data phase
					if (wait_sig == 0)begin
						slave_state <= DATA_PHASE;
						HREADY_r <= 1'b1;
						HRESP <= `OKAY;
						latch_bus <= 1'b1;
						haddress_r <= HADDRESS;
					end
					else if(HTRANS == `IDLE)begin
						slave_state <= ADDRESS_PHASE;
						HREADY_r <= 1'b1;
						HRESP <= `OKAY;
						latch_bus <= 1'b0;
					end
					else if(HTRANS == `BUSY)begin
						haddress_r <= HADDRESS;
						HRESP <= `OKAY;
						HREADY_r <= 1'b1;
						slave_state <= BURST_PHASE;
						latch_bus <= 1'b1;	  
					end
					else if(HTRANS == `SEQ)begin
						haddress_r <= HADDRESS;
						hwrite_r <= HWRITE;
						HRESP <= `OKAY;
						HREADY_r <= 1'b1;
						slave_state <= BURST_PHASE;
						latch_bus <= 1'b1;
					end
					else if(HTRANS != `NONSEQ) begin
						slave_state <= ADDRESS_PHASE;
						HREADY_r <= 1'b1;
						HRESP <= `OKAY;
						latch_bus <= 1'b0;
					end
					else begin
						HREADY_r <= 1'b1;
						HRESP <= `OKAY;
						latch_bus <= 1'b0;
					end
				end
			endcase
		end
	end
	
	always@(wait_sig or HREADY_r)begin
	      if ( wait_sig == 1'b0 )
	        HREADY <= 1'b0 ;
	   else	HREADY <= HREADY_r;
	end
		
	always @(negedge HCLOCK or negedge HRESETn) begin   //Used to latch HWDATA bus to reg_wdata at the right time
		if(HRESETn == 1'b0)begin
			reg_wdata <= 0;
		end
		else if(latch_bus && hwrite_r)begin
			reg_wdata <= HWDATA;
		end
	end
endmodule


