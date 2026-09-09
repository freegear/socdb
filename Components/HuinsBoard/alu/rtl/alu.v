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

module alu ( operand1, 
			 operand2,
			 operation, 
			 result_low,
			 result_high);
			
// INPUTS
	
input [31:0] operand1, operand2;     //ALU operands
input [1:0] operation;				 //Selects which results appear on the output

// OUTPUTS	
output [31:0] result_low, result_high;  //Result from computation


//Internal Declarations
reg [31:0]	result_low, result_high, add_result_high, add_result_low, sub_result_high, sub_result_low, mult_result_low , mult_result_high ;


//Main Code
    
    //Used to perform calculations
    always @(operand1 or operand2)
	begin
	     
		 {add_result_high, add_result_low} = operand1 + operand2;
		 {sub_result_high, sub_result_low} = operand1 - operand2;
	     {mult_result_high, mult_result_low} = operand1 * operand2;

	end
	//Mux to select the correct results 
	always @(operation)
	begin
		case (operation)
		`ADD  : begin
			  result_low = add_result_low;
			  result_high = add_result_high;
			  end
		`SUB  : begin
			  result_low = sub_result_low;
			  result_high = sub_result_high;
			  end
		`MULT :begin 
			result_low = mult_result_low;
			result_high = mult_result_high;
			end
		default :begin
			 result_low = 0;
			 result_high = 0;
			 end
		endcase
	end

endmodule
