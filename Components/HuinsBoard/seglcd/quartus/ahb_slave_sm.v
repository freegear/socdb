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
         clk,    	     
		    HRESP,      	     
		    HREADY,     	     
		    enable,  	     
		    slave_address,	
		    write,     
		    data); 	    
 
// INPUTS
	input	          HSEL;	      		//Chip enable
	input [31:0]    HADDRESS;     //AHB Address signals
	input [31:0]    HWDATA;		    	//Data lines
	input	          HWRITE;    			//High = Write Low = Read
	input  [1:0]    HTRANS;	    		//Transfer type. Only nons eq is supported
	input  [1:0]    HSIZE;	     		//Size of data packet. Only 32 is supported
  input  [2:0]    HBURST;    			//Size of burst. Only 1 is supported
	input	          HRESETn;	   		//System reset. Active low
	input           HCLOCK;	    		//system clock
	    
// OUTPUTS	
	output [1:0]    HRESP;			     //Slave response to status of xfer
	output [9:2]    slave_address;		//address written to register file
	output 	        enable;		     //register file write/read signal
  output [31:0]   data;
	output          HREADY;			    //Insert wait states
  output          clk;
  output          write;

//Internal Declarations
	reg   [ 1:0]    HRESP;     			//Statemachine output
	reg   [ 9:2]    slave_address;  //Used to latch HADDRESS During Address phase
	reg 	           enable;		     //Used to latch HWRITE During Address phase
	reg   [ 1:0]    slave_state;  //State machine state
	reg	            HREADY;	      //Internal reg

//PARAMETERS

parameter ADDRESS_PHASE = 2'b00,                //State machine states
	      DATA_PHASE = 2'b10,
	      READ_WAIT_PHASE = 2'b11,
	      ERROR_PHASE = 2'b01;


//Main Code

assign clk      = HCLOCK;
assign write    = HWRITE;
assign data     = HWDATA;
     
  always @(posedge HCLOCK or negedge HRESETn )
	begin
	    if(HRESETn == 1'b0) begin			//Async Reset
		  slave_state <= ADDRESS_PHASE;
		  HRESP <= `OKAY;
		  HREADY <= 1'b1;
		  slave_address <= 8'D0;
		  enable <= 1'b1;
	     end
	     
	   else begin
	   
	   case (slave_state)
	   	ADDRESS_PHASE : begin
		  	if(HSEL == 1'b0) begin				//Slave not selected
				slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		  		slave_address <= 8'd0;
		  		enable <= 1'b1;        
		  	end                                  		
		  	else if(HTRANS == `IDLE)begin        		//No new transaction on this clock
		    	slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		  		slave_address <= 8'd0;
		  		enable <= 1'b1;        
		   	end
		   	else if(HTRANS == `SEQ)begin   			 //Protocol violation
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		slave_address <= 8'd0;
		  		enable <= 1'b1;     	     
		  	end
		  	else if(HSIZE != `AHB_WORD)begin    		//Only supports word transactions
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		slave_address <= 8'd0;
		  		enable <= 1'b1;     	     
		  	end
			else if(HBURST > `INCR)begin        		//Only supports unspecfied INCR and single transactions
		    		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		slave_address <= 8'd0;
		  		 enable <= 1'b1;     	     
		  	end
		  	else if(HADDRESS[9:0] > 512)begin		  //Highest address in reg file is 20
		   		slave_state <= ERROR_PHASE;
		    		HREADY <= 1'b0;
		    		HRESP <= `ERROR;
		    		slave_address <= 8'd0;
		  		enable <= 1'b1;     
		  	end
			else if(HTRANS == `NONSEQ)begin	  			//valid transaction
		    		if(HWRITE == `AHB_WRITE)begin
		    			slave_state <= DATA_PHASE;
		  			HRESP <= `OKAY;
		  			HREADY <= 1'b1;
		  			slave_address <= HADDRESS[9:2];
		  			enable <= 1'b0;        
		    		end
		    		else begin
		    			slave_state <= READ_WAIT_PHASE;
		  			HRESP <= `OKAY;
		  			HREADY <= 1'b0;
		  			slave_address <= HADDRESS[9:2];
		  			enable <= 1'b1;        
		    		end
		    		
		    	end
		    	else begin
		   		slave_state <= ADDRESS_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		  		slave_address <= 8'd0;
		  		enable <= 1'b1;        
		    	end
		end
	     	READ_WAIT_PHASE: begin
	     									//should do some protocol checks but we'll pass
	     		slave_state <= DATA_PHASE;
			HRESP <= `OKAY;
			HREADY <= 1'b1;
			slave_address <= slave_address;
			enable <= 1'b1;        
	     	end
	     ERROR_PHASE:begin
			slave_state <= ADDRESS_PHASE;
			HREADY <= 1'b1;
			HRESP <= `ERROR;
			slave_address <= 8'd0;
			enable <= 1'b1;      
	     end
	     default: begin							//data phase
	     									//should do some protocol checks but we'll pass
	     	if(HTRANS == `BUSY)begin	  						
	      		slave_state <= DATA_PHASE;
		  	HRESP <= `OKAY;
		  	HREADY <= 1'b1;
		 end
		 else if(HTRANS == `SEQ)begin
		 	if(HWRITE == `AHB_READ)begin
		 		slave_state <= READ_WAIT_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b0;
		  		slave_address <= HADDRESS[9:2];
		  		enable <= 1'b1;    	
		 	end
		 	else begin	  
      			slave_state <= DATA_PHASE;
		  		HRESP <= `OKAY;
		  		HREADY <= 1'b1;
		  		slave_address <= HADDRESS[9:2];
		  		enable <= 1'b0;        
		  	end
		 end
		 else begin						
      		slave_state <= ADDRESS_PHASE;
		  	HRESP <= `OKAY;
		  	HREADY <= 1'b1;
		  	slave_address <= HADDRESS[9:2];
		  	enable <= 1'b1;        
		 end	     				     		         
	    end
	   endcase
	 end
	end
endmodule


