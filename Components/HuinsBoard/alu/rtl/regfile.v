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

module regfile ( reset,
				 clock,
				 write,
				 clock_enb,
				 address,
				 read_data,
  				 operand1, 
			 	 operand2,
				 operation,
			     result_low,
				 result_high,
				 write_data);
			
// INPUTS
input reset;						  //Active low reset
input clock;						  //System Clock 
input write;						  //High write to reg file;Low read from
input clock_enb;					  //Latch in results from ALU
input [2:0]  address;	              //Selects location to write/read to/from
input [31:0] result_low, result_high; //Result from computation
input [31:0] write_data;			  //Data bus used to write data to reg file

// OUTPUTS	
output [31:0] operand1, operand2;     //ALU operands
output [31:0] read_data;              //Data bus used to read from reg file

output  [31:0]  operation;			  //Selects which results appear on the output

//Internal Declarations
reg [31:0]	operand1, operand2, read_data;
reg [31:0]   operation;


//Main Code

   always @(posedge clock or negedge reset)
	begin
	   if(~reset)
	   begin
		 operand1 <= 0;
		 operand2 <= 0; 
		 read_data <= 0;
		 operation <= 0;
		end
	   else	if (write && clock_enb)
		begin
		  case (address) //latch in data on the data bus into the appropate location
			`OP1  : begin
			        operand1  <= write_data;
				 
				    end
			`OP2  : begin
			        operand2  <= write_data;
				    
				    end
			`OPER : operation[31:0] <= write_data[31:0];
		     default : begin
		       operation <= operation;
		       operand1 <= operand1;
		       operand2 <= operand2;
		       read_data <= read_data;
		     end
	      endcase
	    end
        else if(write == 0 && clock_enb)  //if write = 0
	    begin
		  case(address) //read results in register file 
			`OP1  : begin
			        read_data  <= operand1;
				    
				    end
			`OP2  : begin
			        read_data  <= operand2;
				    
				    end
			`OPER : begin
			         read_data <= operation;
			           
			        end
			`RELOW : begin
			         read_data <= result_low;
					 
				     end
			`REHIG : begin 
			         read_data <= result_high;
			         
				     end
			 default : begin
			   operation <= operation;
		       operand1 <= operand1;
		       operand2 <= operand2;
		       read_data <= read_data;
			 end
		  endcase
		end
		
   end
  
endmodule	
