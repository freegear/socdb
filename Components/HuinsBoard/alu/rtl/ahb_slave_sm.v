// Copyright (C) 1991-2001 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.

`include "ahb_slave_include.v"


//TOP MODULE

module ahb_slave_sm(HSEL, 
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
		    latch_bus,   	     
		    reg_rdata); 	     
// INPUTS
	input	     HSEL;			//Chip enable
	input [31:0] HADDRESS;                  //AHB Address signals
	input [31:0] HWDATA;			//Data lines
	input	     HWRITE;			//High = Write Low = Read
	input [1:0]  HTRANS;			//Transfer type. Only nonseq is supported
	input [1:0]  HSIZE;			//Size of data packet. Only 32 is supported
        input [2:0]  HBURST;			//Size of burst. Only 1 is supported
	input	     HRESETn;			//System reset. Active low
	input        HCLOCK;			//system clock
	input [31:0] reg_rdata;			//read data from register file
	
	    
// OUTPUTS	
	output [1:0]  HRESP;			//Slave response to status of xfer
        output [31:0] HRDATA;			//Read Data bus
	output [31:0] reg_address;		//address written to register file
	output 	      reg_write;		//register file write/read signal
	output [31:0] reg_wdata;		//Data written to register file
	output        HREADY;			//Insert wait states
	output 	      latch_bus;
//Internal Declarations
	reg [1:0]  HRESP;			//Statemachine output
	reg [31:0] reg_address;		        //Used to latch HADDRESS During Address phase
	reg 	   reg_write;		        //Used to latch HWRITE During Address phase
	reg [1:0]  slave_state;		        //State machine state
	reg	   HREADY;		        //Internal reg
	reg	   latch_bus;		        //latched data buses
//PARAMETERS

parameter ADDRESS_PHASE = 2'b00,                //State machine states
	  DATA_PHASE = 2'b10,
	  READ_WAIT_PHASE = 2'b11,
	  ERROR_PHASE = 2'b01;


//Main Code

assign HRDATA = HRESETn ? reg_rdata : 32'd0;    
assign reg_wdata = HRESETn ? HWDATA : 32'd0;

  
     
   always @(posedge HCLOCK or negedge HRESETn )
	begin
	    if(HRESETn == 1'b0) begin			//Async Reset
		  slave_state <= ADDRESS_PHASE;
		  HRESP <= `OKAY;
		  HREADY <= 1'b1;
		  latch_bus <= 1'b0;
		  reg_address <= 32'D0;
		  reg_write <= 1'b0;
	     end
	     
	   else begin
	   
	   case (slave_state)
	   	ADDRESS_PHASE : begin
		  	if(HSEL == 1'b0) begin				//Slave not selected
				slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		    		latch_bus <= 1'b0;
		  		reg_address <= 32'd0;
		  		reg_write <= 1'b0;        
		  	end                                  		
		  	else if(HTRANS == `IDLE)begin        		//No new transaction on this clock
		    		slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		    		latch_bus <= 1'b0;
		  		reg_address <= 32'd0;
		  		reg_write <= 1'b0;        
		   	end
		   	else if(HTRANS == `SEQ)begin   			 //Protocol violation
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		latch_bus <= 1'b0;
		    		reg_address <= 32'd0;
		  		reg_write <= 1'b0;     	     
		  	end
		  	else if(HSIZE != `AHB_WORD)begin    		//Only supports word transactions
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		latch_bus <= 1'b0;
		    		reg_address <= 32'd0;
		  		reg_write <= 1'b0;     	     
		  	end
			else if(HBURST > `INCR)begin        		//Only supports unspecfied INCR and single transactions
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		latch_bus <= 1'b0;
		    		reg_address <= 32'd0;
		  		reg_write <= 1'b0;     	     
		  	end
		  	else if(HADDRESS[4:0] > 20)begin		  //Highest address in reg file is 20
		   		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		latch_bus <= 1'b0;
		    		reg_address <= 32'd0;
		  		reg_write <= 1'b0;     
		  	end
		  	else if(HADDRESS[4:0] > 12 && HWRITE == 1'b1)begin  //address 16 and 20 are read only
		   		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		latch_bus <= 1'b0;
		    		reg_address <= 32'd0;
		  		reg_write <= 1'b0;     
		  	end
			else if(HTRANS == `NONSEQ)begin	  			//valid transaction
		    		if(HWRITE == `AHB_WRITE)begin
		    			slave_state <= DATA_PHASE;
		  			HRESP <= `OKAY;
		  			HREADY <= 1'b1;
		  			latch_bus <= 1'b1;
		  			reg_address <= HADDRESS;
		  			reg_write <= 1'b1;        
		    		end
		    		else begin
		    			slave_state <= READ_WAIT_PHASE;
		  			HRESP <= `OKAY;
		  			HREADY <= 1'b0;
		  			latch_bus <= 1'b1;
		  			reg_address <= HADDRESS;
		  			reg_write <= 1'b0;        
		    		end
		    		
		    	end
		    	else begin
		    		slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		  		latch_bus <= 1'b0;
		  		reg_address <= 32'd0;
		  		reg_write <= 1'b0;        
		    	end
		end
	     	READ_WAIT_PHASE: begin
	     									//should do some protocol checks but we'll pass
	     		slave_state <= DATA_PHASE;
			HRESP <= `OKAY;
			HREADY <= 1'b1;
			latch_bus <= 1'b1;
			reg_address <= reg_address;
			reg_write <= 1'b0;        
	     	end
	     ERROR_PHASE:begin
			slave_state <= ADDRESS_PHASE;
			HREADY <= 1'b1;
			HRESP <= `ERROR;
			latch_bus <= 1'b0;
			reg_address <= 32'd0;
			reg_write <= 1'b0;      
	     end
	     default: begin							//data phase
	     									//should do some protocol checks but we'll pass
	     	if(HTRANS == `BUSY)begin	  						
	      		slave_state <= DATA_PHASE;
		  	HRESP <= `OKAY;
		  	HREADY <= 1'b1;
		    	latch_bus <= 1'b0;
		 end
		 else if(HTRANS == `SEQ)begin
		 	if(HWRITE == `AHB_READ)begin
		 		slave_state <= READ_WAIT_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b0;
		   		latch_bus <= 1'b1;
		  		reg_address <= HADDRESS;
		  		reg_write <= 1'b0;    	
		 	end
		 	else begin	  
	      			slave_state <= DATA_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		   		latch_bus <= 1'b1;
		  		reg_address <= HADDRESS;
		  		reg_write <= 1'b1;        
		  	end
		 end
		 else begin						
	      		slave_state <= ADDRESS_PHASE;
		  	HRESP <= `OKAY;
		  	HREADY <= 1'b1;
		   	latch_bus <= 1'b0;
		  	reg_address <= HADDRESS;
		  	reg_write <= 1'b0;        
		 end	     				     		         
	    end
	   endcase
	 end
	end
endmodule


