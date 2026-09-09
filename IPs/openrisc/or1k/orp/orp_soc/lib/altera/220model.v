//------------------------------------------------------------------------
//   This Verilog file was developed by Altera Corporation.  It may be
// freely copied and/or distributed at no cost.  Any persons using this
// file for any purpose do so at their own risk, and are responsible for
// the results of such use.  Altera Corporation does not guarantee that
// this file is complete, correct, or fit for any particular purpose.
// NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
// accompany any copy of this file.
//
//------------------------------------------------------------------------
// LPM Synthesizable Models 
// These models are based on LPM version 220 (EIA-IS103 October 1998).
//-----------------------------------------------------------------------
// Version Quartus v2.0 (lpm 220)      Date 08/28/01
//
// 08/28/01: Support for non-pli flow for convert_hex2ver
//
//----------------------------------------------------------------------- 
// Version Quartus v1.1 (lpm 220)      Date 04/17/01
//
// 04/09/01: Fix 82832; inappropriate use of blocking assignments in
//           lpm_ram_dq, lpm_ram_io, lpm_ram_dp, lpm_rom.
// 04/09/01: Make dcfifo and lpm_fifo_dc models consistent.
// 04/05/01: Fix 82832; race condition in lpm_ram_dq with VerilogXL.
// 03/20/01: Fix SPR 82096; the memenab & outenab signals are not 
//           initialized for lpm_ram_io.
// 01/23/01: Adding use_eab=on support for lpm_ram_io, lpm_ram_dp and
//           lpm_ram_dq.
//------------------------------------------------------------------------
// Version Quartus v1.0 (lpm 220)      Date 12/8/00
//
// 12/8/00: Fix SPR78303. Remove use of blocking assignments in
//          lpm_fifo_dc
// 12/5/00: Changed lpm_ram_dp rdclken, and wrclken to connect to pull up
//          properly.
//------------------------------------------------------------------------
// Version 1.6 (lpm 220)      Date 10/2/00
//
// Changed the behaviour of LPM_FIFO_DC to match that of Quartus.
// Changed data port of LPM_LATCH to be initialized with 0.
// Fixed LPM_COUNTER, LPM_FF, LPM_SHIFTREG to output correctly after
//   aclr goes low but before any clock edge, and to output x's when
//   both aclr and aset are high.
// Changed q port of LPM_FF and LPM_SHIFTREG to be initialized with 0.
// Fixed underflow and overflow port of LPM_CLSHIFT in ROTATE mode.
// Added LPM_REMAINDERPOSITIVE parameter to LPM_DIVIDE.  This is a
//   non-LPM 220 standard parameter.  It defaults to TRUE for LPM 220
//   behaviour.
// Fixed LPM_MULT to output correctly.
// Changed default value of CIN port of LPM_ADD_SUB when subtract.
// Changed output pipelines of LPM_ADD_SUB to be initialized with 0's.
// Fixed overflow port of LPM_ADD_SUB for singned inputs.
// Added DATA port to the sensitivity list in LPM_COUNTER and LPM_FF.
//   Synthesis tools do not allow mixing of level and edge sensitive
//   signals, and hence DATA port was omitted from the list.
// Corrected the interpretation of CIN port of LPM_COUNTER.
// Fixed LPM_RAM_DP, LPM_RAM_DQ, and LPM_RAM_IO to write data at rising
//   clock edge and to output correctly.
// Fixed COUT port of LPM_COUNTER to go high when count is all 1's.
//
//------------------------------------------------------------------------
// Version 1.59 (lpm 220)     Date 5/4/00
//
// Corrected LPM_FIFO_DC rdempty flag.
// Updated comments in header about synthesis issues.
// Fixed error detection of LPM_DIRECTION and UPDOWN conflict in
//   LPM_COUNTER.
// Changed LPM_ROM to have no default name for initialization file.
//
//------------------------------------------------------------------------
// Version 1.5 (lpm 220)      Date 12/17/99
//
// Modified LPM_ADD_SUB and LPM_MULT to accomodate LPM_WIDTH = 1.
//   Default values for LPM_WIDTH* are changed back to 1.
// Added LPM_HINT to LPM_DIVIDE.
// Rewritten LPM_FIFO_DC to output correctly.
// Modified LPM_FIFO to output 0s before first read, output correct
//   values after aclr and sclr, and output LPM_NUMWORDS mod
//   exp(2, LPM_WIDTHU) when FIFO is full.
//
//------------------------------------------------------------------------
// Version 1.4.1 (lpm 220)    Date 10/29/99
//
// Default values for LPM_WIDTH* of LPM_ADD_SUB and LPM_MULT are changed
//   from 1 to 2.
//
//------------------------------------------------------------------------
// Version 1.4 (lpm 220)      Date 10/18/99
//
// Default values for each optional inputs for ALL modules are added.
// Some LPM_PVALUE implementations were missing, and now implemented.
//
//------------------------------------------------------------------------
// Version 1.3 (lpm 220)      Date 06/23/99
//
// Corrected LPM_FIFO and LPM_FIFO_DC cout and empty/full flags.
// Implemented LPM_COUNTER cin/cout, and LPM_MODULUS is now working.
//
//------------------------------------------------------------------------
// Version 1.2 (lpm 220)      Date 06/16/99
//
// Added LPM_RAM_DP, LPM_RAM_DQ, LPM_IO, LPM_ROM, LPM_FIFO, LPM_FIFO_DC.
// Parameters and ports are added/discarded according to the spec.
//
//------------------------------------------------------------------------
// Version 1.1 (lpm 220)      Date 02/05/99
//
// Added LPM_DIVIDE module.
//
//------------------------------------------------------------------------
// Version 1.0                Date 07/09/97
//
//------------------------------------------------------------------------
// Excluded Functions:
//
//  LPM_FSM and LPM_TTABLE.
//
//------------------------------------------------------------------------
// Assumptions:
//
// 1. The default value for LPM_SVALUE, LPM_AVALUE, LPM_PVALUE, and
//    LPM_STRENGTH is string UNUSED.
//
//------------------------------------------------------------------------
// Verilog Language Issues:
//
// Two dimensional ports are not supported. Modules with two dimensional
// ports are implemented as one dimensional signal of (LPM_SIZE * LPM_WIDTH)
// bits wide.
//
//------------------------------------------------------------------------


`define NO_PLI

module lpm_constant ( result );

	parameter lpm_type = "lpm_constant";
	parameter lpm_width = 1;
	parameter lpm_cvalue = 0;
	parameter lpm_strength = "UNUSED";
	parameter lpm_hint = "UNUSED";

	output [lpm_width-1:0] result;

	assign result = lpm_cvalue;

endmodule // lpm_constant

//------------------------------------------------------------------------

module lpm_inv ( result, data );

	parameter lpm_type = "lpm_inv";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;

    always @(data)
        result = ~data;

endmodule // lpm_inv

//------------------------------------------------------------------------

module lpm_and ( result, data );

	parameter lpm_type = "lpm_and";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;
	integer i, j, k;

	always @(data)
	begin
		for (i=0; i<lpm_width; i=i+1)
		begin
			result[i] = data[i];
			for (j=1; j<lpm_size; j=j+1)
			begin
				k = j * lpm_width + i;
				result[i] = result[i] & data[k];
			end
		end
	end

endmodule // lpm_and

//------------------------------------------------------------------------

module lpm_or ( result, data );

    parameter lpm_type = "lpm_or";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint  = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;
	integer i, j, k;

	always @(data)
	begin
		for (i=0; i<lpm_width; i=i+1)
		begin
			result[i] = data[i];
			for (j=1; j<lpm_size; j=j+1)
			begin
				k = j * lpm_width + i;
				result[i] = result[i] | data[k];
			end
		end
	end

endmodule // lpm_or

//------------------------------------------------------------------------

module lpm_xor ( result, data );

	parameter lpm_type = "lpm_xor";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint  = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;
	integer i, j, k;

	always @(data)
	begin
		for (i=0; i<lpm_width; i=i+1)
		begin
			result[i] = data[i];
			for (j=1; j<lpm_size; j=j+1)
			begin
				k = j * lpm_width + i;
				result[i] = result[i] ^ data[k];
			end
		end
	end

endmodule // lpm_xor

//------------------------------------------------------------------------

module lpm_bustri ( result, tridata, data, enabledt, enabletr );

	parameter lpm_type = "lpm_bustri";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enabledt;
	input  enabletr;
	output [lpm_width-1:0] result;
	inout  [lpm_width-1:0] tridata;

	reg    [lpm_width-1:0] result;
	reg    [lpm_width-1:0] tmp_tridata;

	tri0  enabledt;
	tri0  enabletr;
	buf (i_enabledt, enabledt);
	buf (i_enabletr, enabletr);

	always @(data or tridata or i_enabletr or i_enabledt)
	begin
        if (i_enabledt == 0 && i_enabletr == 1)
		begin
			result = tridata;
			tmp_tridata = 'bz;
		end
        else if (i_enabledt == 1 && i_enabletr == 0)
		begin
			result = 'bz;
			tmp_tridata = data;
		end
        else if (i_enabledt == 1 && i_enabletr == 1)
		begin
			result = data;
			tmp_tridata = data;
		end
		else
		begin
			result = 'bz;
			tmp_tridata = 'bz;
		end
	end

	assign tridata = tmp_tridata;

endmodule // lpm_bustri

//------------------------------------------------------------------------

module lpm_mux ( result, clock, clken, data, aclr, sel );

	parameter lpm_type = "lpm_mux";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_widths = 1;
	parameter lpm_pipeline = 0;
	parameter lpm_hint  = "UNUSED";

	input [(lpm_size * lpm_width)-1:0] data;
	input aclr;
	input clock;
	input clken;
	input [lpm_widths-1:0] sel;
	output [lpm_width-1:0] result;

	reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_width-1:0] tmp_result;
    integer i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);

    always @(data or sel or i_aclr)
	begin
		if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
				tmp_result2[i] = 'b0;
        else
        begin
            tmp_result = 0;
            for (i = 0; i < lpm_width; i = i + 1)
                tmp_result[i] = data[sel * lpm_width + i];
            tmp_result2[lpm_pipeline] = tmp_result;
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_result2[i] <= tmp_result2[i+1];
	end

    assign result = tmp_result2[0];
endmodule // lpm_mux

//------------------------------------------------------------------------

module lpm_decode ( eq, data, enable, clock, clken, aclr );

	parameter lpm_type = "lpm_decode";
	parameter lpm_width = 1;
	parameter lpm_decodes = 1 << lpm_width;
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enable;
    input  clock;
	input  clken;
	input  aclr;
	output [lpm_decodes-1:0] eq;

    reg    [lpm_decodes-1:0] tmp_eq2 [lpm_pipeline:0];
    reg    [lpm_decodes-1:0] tmp_eq;
    integer i;

	tri0   clock;
	tri1   clken;
	tri0   aclr;
	tri1   enable;

	buf (i_clock, clock);
	buf (i_clken, clken);
	buf (i_aclr, aclr);
	buf (i_enable, enable);


    always @(data or i_enable or i_aclr)
	begin
        if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
                tmp_eq2[i] = 'b0;
        else
        begin
            tmp_eq = 0;
            if (i_enable)
                tmp_eq[data] = 1'b1;
            tmp_eq2[lpm_pipeline] = tmp_eq;
        end
	end
 
    always @(posedge i_clock)
	begin
        if (!i_aclr && clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                tmp_eq2[i] <= tmp_eq2[i+1];
	end

    assign eq = tmp_eq2[0];

endmodule // lpm_decode

//------------------------------------------------------------------------

module lpm_clshift ( result, overflow, underflow, data, direction, distance );

	parameter lpm_type = "lpm_clshift";
	parameter lpm_width = 1;
	parameter lpm_widthdist = 1;
	parameter lpm_shifttype = "LOGICAL";
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  [lpm_widthdist-1:0] distance;
	input  direction;
	output [lpm_width-1:0] result;
	output overflow;
	output underflow;

	reg    [lpm_width-1:0] ONES;
	reg    [lpm_width-1:0] result;
	reg    overflow, underflow;
	integer i;

	tri0  direction;

	buf (i_direction, direction);

//---------------------------------------------------------------//
	function [lpm_width+1:0] LogicShift;
		input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		reg   overflow, underflow;
				
		begin
			tmp_buf = data;
			overflow = 1'b0;
			underflow = 1'b0;
			if ((direction) && (dist > 0)) // shift right
			begin
				tmp_buf = data >> dist;
				if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
					underflow = 1'b1;
			end
			else if (dist > 0) // shift left
			begin
				tmp_buf = data << dist;
				if ((data != 0) && ((dist >= lpm_width)
					|| ((data >> (lpm_width-dist)) != 0)))
					overflow = 1'b1;
			end
			LogicShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
		end
	endfunction

//---------------------------------------------------------------//
	function [lpm_width+1:0] ArithShift;
		input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		reg   overflow, underflow;
		
		begin
			tmp_buf = data;
			overflow = 1'b0;
			underflow = 1'b0;

			if (direction && (dist > 0))   // shift right
			begin
				if (data[lpm_width-1] == 0) // positive number
				begin
					tmp_buf = data >> dist;
					if ((data != 0) && ((dist >= lpm_width) || (tmp_buf == 0)))
						underflow = 1'b1;
				end
				else // negative number
				begin
					tmp_buf = (data >> dist) | (ONES << (lpm_width - dist));
					if ((data != ONES) && ((dist >= lpm_width-1) || (tmp_buf == ONES)))
						underflow = 1'b1;
				end
			end
			else if (dist > 0) // shift left
			begin
				tmp_buf = data << dist;
				if (data[lpm_width-1] == 0) // positive number
				begin
					if ((data != 0) && ((dist >= lpm_width-1) 
					|| ((data >> (lpm_width-dist-1)) != 0)))
						overflow = 1'b1;
				end
				else // negative number
				begin
					if ((data != ONES) && ((dist >= lpm_width) 
					|| (((data >> (lpm_width-dist-1))|(ONES << (dist+1))) != ONES)))
						overflow = 1'b1;
				end
			end
			ArithShift = {overflow,underflow,tmp_buf[lpm_width-1:0]};
		end
	endfunction

//---------------------------------------------------------------//
    function [lpm_width+1:0] RotateShift;
        input [lpm_width-1:0] data;
		input [lpm_widthdist-1:0] dist;
		input direction;
		reg   [lpm_width-1:0] tmp_buf;
		
		begin
			tmp_buf = data;
			if ((direction) && (dist > 0)) // shift right
				tmp_buf = (data >> dist) | (data << (lpm_width - dist));
			else if (dist > 0) // shift left
				tmp_buf = (data << dist) | (data >> (lpm_width - dist));
            RotateShift = {2'bx, tmp_buf[lpm_width-1:0]};
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
        if (lpm_shifttype != "LOGICAL" &&
            lpm_shifttype != "ARITHMETIC" &&
            lpm_shifttype != "ROTATE" &&
            lpm_shifttype != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_SHIFTTYPE value must be \"LOGICAL\", \"ARITHMETIC\", or \"ROTATE\".");

		for (i=0; i < lpm_width; i=i+1)
			ONES[i] = 1'b1;
	end

	always @(data or i_direction or distance)
	begin
        if ((lpm_shifttype == "LOGICAL") || (lpm_shifttype == "UNUSED"))
            {overflow, underflow, result} = LogicShift(data, distance, i_direction);
		else if (lpm_shifttype == "ARITHMETIC")
            {overflow, underflow, result} = ArithShift(data, distance, i_direction);
		else if (lpm_shifttype == "ROTATE")
            {overflow, underflow, result} = RotateShift(data, distance, i_direction);
	end

endmodule // lpm_clshift

//------------------------------------------------------------------------

module lpm_add_sub ( result, cout, overflow,
					 add_sub, cin, dataa, datab, clock, clken, aclr );

	parameter lpm_type = "lpm_add_sub";
	parameter lpm_width = 1;
	parameter lpm_direction  = "UNUSED";
	parameter lpm_representation = "UNSIGNED";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  add_sub, cin;
	input  clock;
	input  clken;
	input  aclr;
	output [lpm_width-1:0] result;
	output cout, overflow;

    reg [lpm_width-1:0] tmp_result2 [lpm_pipeline:0];
    reg [lpm_pipeline:0] tmp_cout2;
    reg [lpm_pipeline:0] tmp_overflow2;
    reg [lpm_width-1:0] not_a, not_b, tmp_result;
    reg i_cin;
    integer dataa_int, datab_int, result_int, borrow, i; 

	tri0 aclr;
	tri0 clock;
	tri1 clken;
	tri1 add_sub;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);
	buf (i_add_sub, add_sub);


    initial
    begin
        if (lpm_direction != "ADD" &&
            lpm_direction != "SUB" &&
            lpm_direction != "UNUSED" &&            // non-LPM 220 standard
            lpm_direction != "DEFAULT")             // non-LPM 220 standard
            $display("Error!  LPM_DIRECTION value must be \"ADD\" or \"SUB\".");
        if (lpm_representation != "SIGNED" &&
            lpm_representation != "UNSIGNED")
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");

        for (i = 0; i <= lpm_pipeline; i = i + 1)
        begin
            tmp_result2[i] = 'b0;
            tmp_cout2[i] = 1'b0;
            tmp_overflow2[i] = 1'b0;
        end
    end

    always @(cin or dataa or datab or i_add_sub or i_aclr)
	begin
		if (i_aclr)
			for (i = 0; i <= lpm_pipeline; i = i + 1)
			begin
				tmp_result2[i] = 'b0;
				tmp_cout2[i] = 1'b0;
				tmp_overflow2[i] = 1'b0;
			end
        else
        begin
    
            // cout is the same for both signed and unsign representation.  
            if (lpm_direction == "ADD" || (i_add_sub == 1 &&
                (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
            begin
                i_cin = (cin === 1'bz) ? 0 : cin;
                {tmp_cout2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa + datab + i_cin;
                tmp_overflow2[lpm_pipeline] = tmp_cout2[lpm_pipeline];
            end
            else if (lpm_direction == "SUB" || (i_add_sub == 0 &&
                    (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
            begin
                i_cin = (cin === 1'bz) ? 1 : cin;
                borrow = (~i_cin) ? 1 : 0;
                {tmp_overflow2[lpm_pipeline], tmp_result2[lpm_pipeline]} = dataa - datab - borrow;
                tmp_cout2[lpm_pipeline] = (dataa >= (datab+borrow))?1:0;
            end
     
            if (lpm_representation == "SIGNED")
            begin
                not_a = ~dataa;
                not_b = ~datab;

                dataa_int = (dataa[lpm_width-1]) ? (not_a)*(-1)-1 : dataa;
                datab_int = (datab[lpm_width-1]) ? (not_b)*(-1)-1 : datab;
    
                // perform the addtion or subtraction operation
                if (lpm_direction == "ADD" || (i_add_sub == 1 &&
                    (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
                begin
                    i_cin = (cin === 1'bz) ? 0 : cin;
                    result_int = dataa_int + datab_int + i_cin;
                    tmp_result = result_int;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] == datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                else if (lpm_direction == "SUB" || (i_add_sub == 0 &&
                        (lpm_direction == "UNUSED" || lpm_direction == "DEFAULT") ))
                begin
                    i_cin = (cin === 1'bz) ? 1 : cin;
                    borrow = (~i_cin) ? 1 : 0;
                    result_int = dataa_int - datab_int - borrow;
                    tmp_result = result_int;
                    tmp_overflow2[lpm_pipeline] = ((dataa[lpm_width-1] != datab[lpm_width-1]) &&
                                                   (dataa[lpm_width-1] != tmp_result[lpm_width-1])) ?
                                                  1 : 0;
                end
                tmp_result2[lpm_pipeline] = result_int;
            end
        end
	end	

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
			begin
                tmp_result2[i] <= tmp_result2[i+1];
                tmp_cout2[i] <= tmp_cout2[i+1];
                tmp_overflow2[i] <= tmp_overflow2[i+1];
			end
	end

    assign result = tmp_result2[0];
    assign cout = tmp_cout2[0];
    assign overflow = tmp_overflow2[0];

endmodule // lpm_add_sub

//------------------------------------------------------------------------

module lpm_compare ( alb, aeb, agb, aleb, aneb, ageb, dataa, datab,
					 clock, clken, aclr );

	parameter lpm_type = "lpm_compare";
	parameter lpm_width = 1;
	parameter lpm_representation = "UNSIGNED";
    parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  clock;
	input  clken;
	input  aclr;
	output alb, aeb, agb, aleb, aneb, ageb;

    reg [lpm_pipeline:0] tmp_alb2, tmp_aeb2, tmp_agb2;
    reg [lpm_pipeline:0] tmp_aleb2, tmp_aneb2, tmp_ageb2;
    reg [lpm_width-1:0] not_a, not_b;
    integer dataa_int, datab_int, i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);

    initial
    begin
        if (lpm_representation != "SIGNED" &&
            lpm_representation != "UNSIGNED")
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
    end


    always @(dataa or datab or i_aclr)
	begin
		if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
			begin
                tmp_aeb2[i] = 'b0;
                tmp_agb2[i] = 'b0;
                tmp_alb2[i] = 'b0;
                tmp_aleb2[i] = 'b0;
                tmp_aneb2[i] = 'b0;
                tmp_ageb2[i] = 'b0;
			end
        else
        begin
            dataa_int = dataa;
            datab_int = datab;
            not_a = ~dataa;
            not_b = ~datab;
    
            if (lpm_representation == "SIGNED")
            begin
                if (dataa[lpm_width-1] == 1)
                    dataa_int = (not_a) * (-1) - 1;
                if (datab[lpm_width-1] == 1)
                    datab_int = (not_b) * (-1) - 1;
            end
    
            tmp_alb2[lpm_pipeline] = (dataa_int < datab_int);
            tmp_aeb2[lpm_pipeline] = (dataa_int == datab_int);
            tmp_agb2[lpm_pipeline] = (dataa_int > datab_int);
            tmp_aleb2[lpm_pipeline] = (dataa_int <= datab_int);
            tmp_aneb2[lpm_pipeline] = (dataa_int != datab_int);
            tmp_ageb2[lpm_pipeline] = (dataa_int >= datab_int);
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
            begin
                tmp_alb2[i] <= tmp_alb2[i+1];
                tmp_aeb2[i] <= tmp_aeb2[i+1];
                tmp_agb2[i] <= tmp_agb2[i+1];
                tmp_aleb2[i] <= tmp_aleb2[i+1];
                tmp_aneb2[i] <= tmp_aneb2[i+1];
                tmp_ageb2[i] <= tmp_ageb2[i+1];
            end
	end

    assign alb = tmp_alb2[0];
    assign aeb = tmp_aeb2[0];
    assign agb = tmp_agb2[0];
    assign aleb = tmp_aleb2[0];
    assign aneb = tmp_aneb2[0];
    assign ageb = tmp_ageb2[0];

endmodule // lpm_compare

//------------------------------------------------------------------------

module lpm_mult ( result, dataa, datab, sum, clock, clken, aclr );

	parameter lpm_type = "lpm_mult";
	parameter lpm_widtha = 1;
	parameter lpm_widthb = 1;
	parameter lpm_widths = 1;
	parameter lpm_widthp = 1;
	parameter lpm_representation  = "UNSIGNED";
	parameter lpm_pipeline  = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widtha-1:0] dataa;
	input  [lpm_widthb-1:0] datab;
	input  [lpm_widths-1:0] sum;
	output [lpm_widthp-1:0] result;

	// inernal reg
    reg [lpm_widthp-1:0] resulttmp [lpm_pipeline:0];
    reg [lpm_widthp-1:0] i_prod, t_p;
    reg [lpm_widths-1:0] i_prod_s, t_s;
    reg [lpm_widtha+lpm_widthb-1:0] i_prod_ab;
    reg [lpm_widtha-1:0] t_a;
    reg [lpm_widthb-1:0] t_b;
    reg sign_ab, sign_s;
    integer i;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);


	initial
	begin
        // check if lpm_widtha > 0
        if (lpm_widtha <= 0)
            $display("Error!  LPM_WIDTHA must be greater than 0.\n");
        // check if lpm_widthb > 0
        if (lpm_widthb <= 0)
            $display("Error!  LPM_WIDTHB must be greater than 0.\n");
        // check if lpm_widthp > 0
        if (lpm_widthp <= 0)
            $display("Error!  LPM_WIDTHP must be greater than 0.\n");
        // check for valid lpm_rep value
        if ((lpm_representation != "SIGNED") && (lpm_representation != "UNSIGNED"))
            $display("Error!  LPM_REPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".", $time);
	end

    always @(dataa or datab or sum or i_aclr)
	begin
        if (i_aclr)
            for (i = 0; i <= lpm_pipeline; i = i + 1)
                resulttmp[i] = 'b0;
        else
        begin
            t_a = dataa;
            t_b = datab;
            t_s = sum;
            sign_ab = 0;
            sign_s = 0;
    
            if (lpm_representation == "SIGNED")
            begin
                sign_ab = dataa[lpm_widtha-1] ^ datab[lpm_widthb-1];
                sign_s = sum[lpm_widths-1];

                if (dataa[lpm_widtha-1] == 1)
                    t_a = ~dataa + 1;
                if (datab[lpm_widthb-1] == 1)
                    t_b = ~datab + 1;
                if (sum[lpm_widths-1] == 1)
                    t_s = ~sum + 1;
            end
    
            if (sum === {lpm_widths{1'bz}})
            begin
                t_s = 0;
                sign_s = 0;
            end

            if (sign_ab == sign_s)
            begin
                i_prod = t_a * t_b + t_s;
                i_prod_s = t_a * t_b + t_s;
                i_prod_ab = t_a * t_b + t_s;
            end
            else
            begin
                i_prod = t_a * t_b - t_s;
                i_prod_s = t_a * t_b - t_s;
                i_prod_ab = t_a * t_b - t_s;
            end

            if (sign_ab)
            begin
                i_prod = ~i_prod + 1;
                i_prod_s = ~i_prod_s + 1;
                i_prod_ab = ~i_prod_ab + 1;
            end

            if (lpm_widthp < lpm_widths || lpm_widthp < lpm_widtha+lpm_widthb)
                for (i = 0; i < lpm_widthp; i = i + 1)
                    i_prod[lpm_widthp-1-i] = (lpm_widths > lpm_widtha+lpm_widthb)
                                             ? i_prod_s[lpm_widths-1-i]
                                             : i_prod_ab[lpm_widtha+lpm_widthb-1-i];
    
            resulttmp[lpm_pipeline] = i_prod;
        end
	end

    always @(posedge i_clock)
	begin
        if (!i_aclr && i_clken == 1)
            for (i = 0; i < lpm_pipeline; i = i + 1)
                resulttmp[i] <= resulttmp[i+1];
	end

    assign result = resulttmp[0];

endmodule // lpm_mult

//------------------------------------------------------------------------

module lpm_divide ( quotient, remain, numer, denom, clock, clken, aclr );

	parameter lpm_type = "lpm_divide";
	parameter lpm_widthn = 1;
	parameter lpm_widthd = 1;
	parameter lpm_nrepresentation = "UNSIGNED";
	parameter lpm_drepresentation = "UNSIGNED";
	parameter lpm_remainderpositive = "TRUE";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widthn-1:0] numer;
	input  [lpm_widthd-1:0] denom;
	output [lpm_widthn-1:0] quotient;
	output [lpm_widthd-1:0] remain;

	// inernal reg
    reg [lpm_widthn-1:0] tmp_quotient [lpm_pipeline:0];
    reg [lpm_widthd-1:0] tmp_remain [lpm_pipeline:0];
    reg [lpm_widthn-1:0] ONES, ZEROS, UNKNOWN, HiZ;
    reg [lpm_widthd-1:0] DZEROS, DUNKNOWN;
    reg [lpm_widthn-1:0] NUNKNOWN;
    reg [lpm_widthd-1:0] RZEROS;
    reg [lpm_widthn-1:0] not_numer, int_numer;
    reg [lpm_widthd-1:0] not_denom, int_denom;
	integer i;
	integer int_quotient, int_remain;

	tri0 aclr;
	tri0 clock;
	tri1 clken;

	buf (i_aclr, aclr);
	buf (i_clock, clock);
	buf (i_clken, clken);


	initial
	begin
        // check if lpm_widthn > 0
        if (lpm_widthn <= 0)
            $display("Error!  LPM_WIDTHN must be greater than 0.\n");
        // check if lpm_widthd > 0
        if (lpm_widthd <= 0)
            $display("Error!  LPM_WIDTHD must be greater than 0.\n");
        // check for valid lpm_nrep value
        if ((lpm_nrepresentation != "SIGNED") && (lpm_nrepresentation != "UNSIGNED"))
            $display("Error!  LPM_NREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
        // check for valid lpm_drep value
        if ((lpm_drepresentation != "SIGNED") && (lpm_drepresentation != "UNSIGNED"))
            $display("Error!  LPM_DREPRESENTATION value must be \"SIGNED\" or \"UNSIGNED\".");
        // check for valid lpm_remainderpositive value
        if ((lpm_remainderpositive != "TRUE") && (lpm_remainderpositive != "FALSE"))
            $display("Error!  LPM_REMAINDERPOSITIVE value must be \"TRUE\" or \"FALSE\".");
     
        for (i=0; i < lpm_widthn; i=i+1)
        begin
            ONES[i] = 1'b1;
            ZEROS[i] = 1'b0;
            UNKNOWN[i] = 1'bx;
            HiZ[i] = 1'bz;
        end
    
        for (i=0; i < lpm_widthd; i=i+1)
            DUNKNOWN[i] = 1'bx;
        for (i=0; i < lpm_widthn; i=i+1)
            NUNKNOWN[i] = 1'bx;
        for (i=0; i < lpm_widthd; i=i+1)
            RZEROS[i] = 1'b0;
	end

    always @(numer or denom or i_aclr)
	begin
		if (i_aclr)
		begin
			for (i = 0; i <= lpm_pipeline; i = i + 1)
				tmp_quotient[i] = ZEROS;
			tmp_remain[i] = RZEROS;
		end
        else
        begin
            int_numer = numer; 
            int_denom = denom;
            not_numer = ~numer;
            not_denom = ~denom;

            if (lpm_nrepresentation == "SIGNED")
                if (numer[lpm_widthn-1] == 1)
                    int_numer = (not_numer) * (-1) - 1;
            if (lpm_drepresentation == "SIGNED")
                if (denom[lpm_widthd-1] == 1)
                    int_denom = (not_denom) * (-1) - 1;
    
            int_quotient = int_numer / int_denom;
            int_remain = int_numer % int_denom;
    
            // LPM 220 standard
            if ((lpm_remainderpositive == "TRUE") && (int_remain < 0))
            begin
                int_quotient = int_quotient + ((int_denom < 0) ? 1 : (-1));
                int_remain = int_numer - int_quotient*int_denom;
            end
    
            tmp_quotient[lpm_pipeline] = int_quotient;
            tmp_remain[lpm_pipeline] = int_remain;
        end
	end

    always @(posedge i_clock)
    begin
        if (!i_aclr && i_clken)
            for (i = 0; i < lpm_pipeline; i = i + 1)
			begin
				tmp_quotient[i] <= tmp_quotient[i+1];
				tmp_remain[i] <= tmp_remain[i+1];
			end
	end

	assign quotient = tmp_quotient[0];
	assign remain = tmp_remain[0];

endmodule // lpm_divide

//------------------------------------------------------------------------

module lpm_abs ( result, overflow, data );

	parameter lpm_type = "lpm_abs";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	output [lpm_width-1:0] result;
	output overflow;

    reg [lpm_width-1:0] result, not_r;
    reg overflow;


	always @(data)
	begin
		overflow = 0;
        result = data;
        not_r = ~data;

		if (data[lpm_width-1] == 1)
		begin
            result = (not_r) + 1;
            overflow = (result == (1<<(lpm_width-1)));
		end
	end

endmodule // lpm_abs

//------------------------------------------------------------------------

module lpm_counter ( q, data, clock, cin, cout, clk_en, cnt_en, updown,
					 aset, aclr, aload, sset, sclr, sload );

	parameter lpm_type = "lpm_counter";
	parameter lpm_width = 1;
	parameter lpm_modulus = 0;
	parameter lpm_direction = "UNUSED";
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_hint = "UNUSED";

	output [lpm_width-1:0] q;
	output cout;
	input  cin;
	input  [lpm_width-1:0] data;
	input  clock, clk_en, cnt_en, updown;
	input  aset, aclr, aload;
	input  sset, sclr, sload;

    reg  [lpm_width-1:0] tmp_count;
    reg  prev_clock;
    reg  tmp_updown;
    reg  [lpm_width-1:0] ONES;
    integer tmp_modulus, i;

	tri1 clk_en;
	tri1 cnt_en;
	tri0 sload;
	tri0 sset;
	tri0 sclr;
	tri0 aload;
	tri0 aset;
	tri0 aclr;
    tri1 cin;
    tri1 updown;

	buf (i_clk_en, clk_en);
	buf (i_cnt_en, cnt_en);
	buf (i_sload, sload);
	buf (i_sset, sset);
	buf (i_sclr, sclr);
	buf (i_aload, aload);
	buf (i_aset, aset);
	buf (i_aclr, aclr);
	buf (i_cin, cin);
    buf (i_updown, updown);


//---------------------------------------------------------------//
//  function integer str_to_int;
//---------------------------------------------------------------//
	function integer str_to_int;
        input [8*16:1] s; 

		reg [8*16:1] reg_s;
		reg [8:1] digit;
		reg [8:1] tmp;
		integer m, ivalue;
		
		begin
			ivalue = 0;
			reg_s = s;
			for (m=1; m<=16; m=m+1)
			begin 
				tmp = reg_s[128:121];
				digit = tmp & 8'b00001111;
				reg_s = reg_s << 8; 
				ivalue = ivalue * 10 + digit; 
			end
			str_to_int = ivalue;
		end
	endfunction

//---------------------------------------------------------------//

	initial
	begin
		// check if lpm_modulus < 0
		if (lpm_modulus < 0)
            $display("Error!  LPM_MODULUS must be greater than 0.\n");
		// check if lpm_modulus > 1<<lpm_width
		if (lpm_modulus > 1<<lpm_width)
            $display("Error!  LPM_MODULUS must be less than or equal to 1<<LPM_WIDTH.\n");
        // check if lpm_direction valid
        if (lpm_direction != "UNUSED" && lpm_direction != "UP" && lpm_direction != "DOWN")
            $display("Error!  LPM_DIRECTION must be \"UP\" or \"DOWN\" if used.\n");
        else if (lpm_direction != "UNUSED" && ((updown == 1'b0) || (updown == 1'b1)))
            $display("Error!  LPM_DIRECTION and UPDOWN cannot be used at the same time.\n");

        for (i=0; i < lpm_width; i=i+1)
            ONES[i] = 1'b1;

        prev_clock = clock;

		tmp_modulus = (lpm_modulus == 0) ? (1 << lpm_width) : lpm_modulus;
		tmp_count = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
	end

    always @(i_aclr or i_aset or i_aload or data or clock or i_updown)
	begin :asyn_block

        tmp_updown = ((lpm_direction == "UNUSED" && i_updown == 1) || lpm_direction == "UP")
                     ? 1 : 0;
		if (i_aclr)
            tmp_count <= 0;
		else if (i_aset)
            tmp_count <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                                 : str_to_int(lpm_avalue);
		else if (i_aload)
            tmp_count <= data;
        else if (clock === 1 && prev_clock !== 1 && $time > 0)
		begin :syn_block
			if (i_clk_en)
			begin
				if (i_sclr)
                    tmp_count <= 0;
				else if (i_sset)
                    tmp_count <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                         : str_to_int(lpm_svalue);
				else if (i_sload)
                    tmp_count <= data;
                else if (i_cnt_en && i_cin)
                begin
                    if (tmp_updown == 1)
                        tmp_count <= (tmp_count == tmp_modulus-1) ? 0
                                                                 : tmp_count+1;
                    else
                        tmp_count <= (tmp_count == 0) ? tmp_modulus-1
                                                     : tmp_count-1;
                end
			end
		end

        prev_clock = clock;
	end

    assign q = tmp_count;
    assign cout = (i_cin && ((tmp_updown==0 && tmp_count==0) ||
                             (tmp_updown==1 && (tmp_count==tmp_modulus-1 ||
                                                tmp_count==ONES)) ))
                    ? 1 : 0;

endmodule // lpm_counter

//------------------------------------------------------------------------

module lpm_latch ( q, data, gate, aset, aclr );

  parameter lpm_type = "lpm_latch";
  parameter lpm_width = 1;
  parameter lpm_avalue = "UNUSED";
  parameter lpm_pvalue = "UNUSED";
  parameter lpm_hint = "UNUSED";

  input  [lpm_width-1:0] data;
  input  gate, aset, aclr;
  output [lpm_width-1:0] q;

  reg [lpm_width-1:0] q;
  reg [lpm_width-1:0] i_data;

  tri0 aset;
  tri0 aclr;

  buf (i_aset, aset);
  buf (i_aclr, aclr);

//---------------------------------------------------------------//
//  function integer str_to_int;
//---------------------------------------------------------------//
	function integer str_to_int;
        input [8*16:1] s; 
		
		reg [8*16:1] reg_s;
		reg [8:1] digit;
		reg [8:1] tmp;
        integer m, ivalue; 
		
		begin 
			ivalue = 0;
			reg_s = s;
			for (m=1; m<=16; m= m+1) 
			begin 
				tmp = reg_s[128:121];
				digit = tmp & 8'b00001111;
				reg_s = reg_s << 8; 
				ivalue = ivalue * 10 + digit; 
			end
			str_to_int = ivalue;
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
		if (lpm_pvalue != "UNUSED")
			q = str_to_int(lpm_pvalue);
        i_data = (data === {lpm_width{1'bz}}) ? 0 : data;
	end

    always @(data)
        i_data = data;

    always @(i_data or gate or i_aclr or i_aset)
	begin
		if (i_aclr)
			q = 'b0;
		else if (i_aset)
            q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                         : str_to_int(lpm_avalue);
		else if (gate)
            q = i_data;
	end

endmodule // lpm_latch

//------------------------------------------------------------------------

module lpm_ff ( q, data, clock, enable, aclr, aset,
				sclr, sset, aload, sload );

	parameter lpm_type = "lpm_ff";
	parameter lpm_width  = 1;
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_fftype = "DFF";
	parameter lpm_hint = "UNUSED";


	input  [lpm_width-1:0] data;
	input  clock, enable;
	input  aclr, aset;
	input  sclr, sset;
	input  aload, sload ;
	output [lpm_width-1:0] q;

    reg  [lpm_width-1:0] tmp_q;
    reg  prev_clock;
	integer i;

	tri1 enable;
	tri0 sload;
	tri0 sclr;
	tri0 sset;
	tri0 aload;
	tri0 aclr;
	tri0 aset;
	  
	buf (i_enable, enable);
	buf (i_sload, sload);
	buf (i_sclr, sclr);
	buf (i_sset, sset);
	buf (i_aload, aload);
	buf (i_aclr, aclr);
	buf (i_aset, aset);

//---------------------------------------------------------------//
//  function integer str_to_int;
//---------------------------------------------------------------//
	function integer str_to_int;
        input [8*16:1] s; 
		
		reg [8*16:1] reg_s;
        reg [8:1] digit;
		reg [8:1] tmp;
        integer m, ivalue; 
		
		begin
			ivalue = 0;
			reg_s = s;
			for (m=1; m<=16; m= m+1) 
			begin 
				tmp = reg_s[128:121];
				digit = tmp & 8'b00001111;
				reg_s = reg_s << 8; 
				ivalue = ivalue * 10 + digit; 
			end
			str_to_int = ivalue;
		end
	endfunction
//---------------------------------------------------------------//

	initial
    begin
        if (lpm_fftype != "DFF" &&
            lpm_fftype != "TFF" &&
            lpm_fftype != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_FFTYPE value must be \"DFF\" or \"TFF\".");

        tmp_q = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
        prev_clock = clock;
    end

    always @(i_aclr or i_aset or i_aload or data or clock)
	begin :asyn_block // Asynchronous process
		if (i_aclr)
            tmp_q = (i_aset) ? 'bx : 0;
        else if (i_aset)
            tmp_q = (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
		else if (i_aload)
            tmp_q = data;
        else if (clock === 1 && prev_clock !== 1 && $time > 0)
		begin :syn_block // Synchronous process
			if (i_enable)
			begin
				if (i_sclr)
					tmp_q <= 0;
				else if (i_sset)
                    tmp_q <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                     : str_to_int(lpm_svalue);
				else if (i_sload)  // Load data
					tmp_q <= data;
				else
				begin
                    if (lpm_fftype == "TFF") // toggle
					begin
						for (i = 0; i < lpm_width; i=i+1)
							if (data[i] == 1'b1) 
								tmp_q[i] <= ~tmp_q[i];
					end
                    else    // DFF, load data
                        tmp_q <= data;
				end
			end
		end
        prev_clock = clock;
	end

	assign q = tmp_q;
endmodule // lpm_ff
 
//------------------------------------------------------------------------

module lpm_shiftreg ( q, shiftout, data, clock, enable, aclr, aset, 
					  sclr, sset, shiftin, load );

	parameter lpm_type = "lpm_shiftreg";
	parameter lpm_width  = 1;
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_direction = "LEFT";
	parameter lpm_hint  = "UNUSED";

	input  [lpm_width-1:0] data;
	input  clock, enable;
	input  aclr, aset;
	input  sclr, sset;
	input  shiftin, load;
	output [lpm_width-1:0] q;
	output shiftout;

	reg  [lpm_width-1:0] tmp_q;
	reg  abit;
	integer i;

	wire tmp_shiftout;

	tri1 enable;
	tri1 shiftin;
	tri0 load;
	tri0 sclr;
	tri0 sset;
	tri0 aclr;
	tri0 aset;

	buf (i_enable, enable);
	buf (i_shiftin, shiftin);
	buf (i_load, load);
	buf (i_sclr, sclr);
	buf (i_sset, sset);
	buf (i_aclr, aclr);
	buf (i_aset, aset);


//---------------------------------------------------------------//
//  function integer str_to_int;
//---------------------------------------------------------------//
	function integer str_to_int;
        input [8*16:1] s; 

		reg [8*16:1] reg_s;
        reg [8:1] digit;
		reg [8:1] tmp;
        integer m, ivalue; 

		begin 
			ivalue = 0;
			reg_s = s;
			for (m=1; m<=16; m= m+1) 
			begin 
				tmp = reg_s[128:121];
				digit = tmp & 8'b00001111;
				reg_s = reg_s << 8; 
				ivalue = ivalue * 10 + digit; 
			end
			str_to_int = ivalue;
		end
	endfunction
//---------------------------------------------------------------//

	initial
    begin
        if (lpm_direction != "LEFT" &&
            lpm_direction != "RIGHT" &&
            lpm_direction != "UNUSED")          // non-LPM 220 standard
            $display("Error!  LPM_DIRECTION value must be \"LEFT\" or \"RIGHT\".");

        tmp_q = (lpm_pvalue == "UNUSED") ? 0 : str_to_int(lpm_pvalue);
    end

    always @(i_aclr or i_aset)
    begin
		if (i_aclr)
            tmp_q <= (i_aset) ? 'bx : 0;
		else if (i_aset)
            tmp_q <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
    end

    always @(posedge clock)
	begin :asyn_block // Asynchronous process
		if (i_aclr)
            tmp_q <= (i_aset) ? 'bx : 0;
		else if (i_aset)
            tmp_q <= (lpm_avalue == "UNUSED") ? {lpm_width{1'b1}}
                                             : str_to_int(lpm_avalue);
		else
		begin :syn_block // Synchronous process
			if (i_enable)
			begin
				if (i_sclr)
					tmp_q <= 0;
				else if (i_sset)
                    tmp_q <= (lpm_svalue == "UNUSED") ? {lpm_width{1'b1}}
                                                     : str_to_int(lpm_svalue);
				else if (i_load)  
					tmp_q <= data;
				else if (!i_load)
				begin
                    if (lpm_direction == "LEFT" || lpm_direction == "UNUSED")
						{abit,tmp_q} <= {tmp_q,i_shiftin};
                    else if (lpm_direction == "RIGHT")
						{tmp_q,abit} <= {i_shiftin,tmp_q};
				end
			end
		end
	end


    assign tmp_shiftout = (lpm_direction == "RIGHT") ? tmp_q[0]
                                                     : tmp_q[lpm_width-1];
	assign q = tmp_q;
	assign shiftout = tmp_shiftout;

endmodule // lpm_shiftreg
 
//------------------------------------------------------------------------

module lpm_ram_dq ( q, data, inclock, outclock, we, address );

  parameter lpm_type = "lpm_ram_dq";
  parameter lpm_width = 1;
  parameter lpm_widthad = 1;
  parameter lpm_numwords = 1 << lpm_widthad;
  parameter lpm_indata = "REGISTERED";
  parameter lpm_address_control = "REGISTERED";
  parameter lpm_outdata = "REGISTERED";
  parameter lpm_file = "UNUSED";
  parameter lpm_hint = "UNUSED";
  parameter use_eab = "OFF";
  parameter intended_device_family = "UNUSED";

  input  [lpm_width-1:0] data;
  input  [lpm_widthad-1:0] address;
  input  inclock, outclock, we;
  output [lpm_width-1:0] q;


  // internal reg 
  reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
  reg  [lpm_width-1:0] tmp_q;
  reg  [lpm_width-1:0] pdata;
  reg  [lpm_width-1:0] in_data;
  reg  [lpm_widthad-1:0] paddress;
  reg  pwe;
  reg  [lpm_width-1:0]  ZEROS, ONES, UNKNOWN;
  reg  [8*256:1] ram_initf;
  integer i;

  tri0 inclock;
  tri0 outclock;

  buf (i_inclock, inclock);
  buf (i_outclock, outclock);

//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;

		begin
			ValidAddress = 1'b0;
			if (^paddress ==='bx)
                            $display("%t:Error!  Invalid address.\n", $time);
			else if (paddress >= lpm_numwords)
                            $display("%t:Error!  Address out of bound on RAM.\n", $time);
			else
				ValidAddress = 1'b1;
		end
  endfunction
//---------------------------------------------------------------//
		
	initial
	begin

		// Initialize the internal data register.
		pdata = 0;
		paddress = 0;
		pwe = 0;

		if (lpm_width <= 0)
                    $display("Error!  LPM_WIDTH parameter must be greater than 0.");

		if (lpm_widthad <= 0)
                    $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");
		// check for number of words out of bound
		if ((lpm_numwords > (1 << lpm_widthad))
			||(lpm_numwords <= (1 << (lpm_widthad-1))))
                    $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
	 
                if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED"))
                    $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
                if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
                    $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");


		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			ONES[i] = 1'b1;
			UNKNOWN[i] = 1'bX;
		end 
		
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// load data to the RAM
		if (lpm_file != "UNUSED")
		begin
`ifdef NO_PLI
			$readmemh(lpm_file, mem_data);
`else
			$convert_hex2ver(lpm_file, lpm_width, ram_initf);
			$readmemh(ram_initf, mem_data);
`endif
		end 

                tmp_q = ZEROS;
	end

		
	always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
        begin
            if ((we) && ((use_eab == "OFF")  && ((lpm_hint == "USE_EAB=OFF") || (lpm_hint == "UNUSED")))) 
            begin
                if (lpm_indata == "REGISTERED")
                    mem_data[address] <= data;
                else
                    mem_data[address] <= pdata;
            end
            paddress <= address;
            pwe <= we;
        end
        if (lpm_indata == "REGISTERED")
            pdata <= data;
	end

	always @(data)
	begin
        if (lpm_indata == "UNREGISTERED")
            pdata <= data;
	end
	
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <= address;
	end
	
	always @(we)
	begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <= we;
	end
	
	always @(pdata or paddress or pwe)
	begin :unregistered_inclock
		if (ValidAddress(paddress))
		begin
                    if ((lpm_address_control == "UNREGISTERED") && (pwe))
                        mem_data[paddress] <= pdata;
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= UNKNOWN;
		end
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
		begin
			if (ValidAddress(paddress))
                            tmp_q <= mem_data[paddress];
			else
                            tmp_q <= UNKNOWN;
		end
	end
 
        always @(negedge i_inclock or pdata)
	begin
        if ((lpm_address_control == "REGISTERED") && (pwe))
            if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) 
            begin
                if (i_inclock == 0) mem_data[paddress] = pdata;
            end
	end

    assign q = (lpm_outdata == "UNREGISTERED") ? mem_data[paddress] : tmp_q;

endmodule // lpm_ram_dq
 
//--------------------------------------------------------------------------

module lpm_ram_dp ( q, data, wraddress, rdaddress, rdclock, wrclock, rdclken, wrclken, rden, wren);

	parameter lpm_type = "lpm_ram_dp";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_rdaddress_control  = "REGISTERED";
	parameter lpm_wraddress_control  = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";
	parameter use_eab = "OFF";
	parameter intended_device_family = "UNUSED";
	parameter rden_used = "TRUE";

	input  [lpm_width-1:0] data;
	input  [lpm_widthad-1:0] rdaddress, wraddress;
	input  rdclock, wrclock, rdclken, wrclken, rden, wren;
	output [lpm_width-1:0] q;

    // internal reg
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthad)-1:0];
    reg [lpm_width-1:0] i_data_reg, i_data_tmp, i_q_reg, i_q_tmp;
    reg [lpm_width-1:0] ZEROS, ONES, UNKNOWN;
    reg [lpm_widthad-1:0] i_wraddress_reg, i_wraddress_tmp;
    reg [lpm_widthad-1:0] i_rdaddress_reg, i_rdaddress_tmp;
    reg [lpm_widthad-1:0] ZEROS_AD;
    reg i_wren_reg, i_wren_tmp, i_rden_reg, i_rden_tmp;
    reg [8*256:1] ram_initf;
    reg mem_updated;
    integer i, i_numwords;

    tri0 wrclock;
    tri1 wrclken;
    tri0 rdclock;
    tri1 rdclken;
    tri0 wren;
    tri1 rden;
			   
    buf (i_inclock, wrclock);
    buf (i_inclocken, wrclken);
    buf (i_outclock, rdclock);
    buf (i_outclocken, rdclken);
    buf (i_wren, wren);
    buf (i_rden, rden);

//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;
	
		begin
			ValidAddress = 1'b0;
            if (^paddress === 'bx)
                $display("%t:Error!  Invalid address.\n", $time);
			else if (paddress >= lpm_numwords)
                $display("%t:Error!  Address out of bound on RAM.\n", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//

	initial
	begin
        // Check for invalid parameters
        if (lpm_width < 1)
            $display("Error! lpm_width parameter must be greater than 0.");
        if (lpm_widthad < 1)
            $display("Error! lpm_widthad parameter must be greater than 0.");

        if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED"))
            $display("Error! lpm_indata must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
            $display("Error! lpm_outdata must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_wraddress_control != "REGISTERED") && (lpm_wraddress_control != "UNREGISTERED"))
            $display("Error! lpm_wraddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
        if ((lpm_rdaddress_control != "REGISTERED") && (lpm_rdaddress_control != "UNREGISTERED"))
            $display("Error! lpm_rdaddress_control must be \"REGISTERED\" or \"UNREGISTERED\".");
				
        // Initialize constants
        for (i=0; i<lpm_width; i=i+1)
        begin
	    ZEROS[i] = 1'b0;
            ONES[i] = 1'b1;
            UNKNOWN[i] = 1'bx;
        end
        for (i=0; i<lpm_widthad; i=i+1)
            ZEROS_AD[i] = 1'b0;
				
        // Initialize mem_data
        i_numwords = (lpm_numwords) ? lpm_numwords : 1<<lpm_widthad;
        if (lpm_file == "UNUSED")
            for (i=0; i<i_numwords; i=i+1)
                mem_data[i] = ZEROS;
        else
		begin
`ifdef NO_PLI
			$readmemh(lpm_file, mem_data);
`else
            $convert_hex2ver(lpm_file, lpm_width, ram_initf);
		    $readmemh(ram_initf, mem_data);
`endif
		end

        mem_updated = 0;

        // Initialize registers
        i_data_reg <= ZEROS;
        i_wraddress_reg <= ZEROS_AD;
        i_rdaddress_reg <= ZEROS_AD;
        i_wren_reg <= 0;
        if (rden_used == "TRUE")
            i_rden_reg <= 0;
        else
            i_rden_reg <= 1;

        // Initialize output
        i_q_reg = ZEROS;
        if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
        begin
            if (intended_device_family == "APEX20K")
                i_q_tmp = ZEROS;
            else
                i_q_tmp = ONES;
        end
        else i_q_tmp = ZEROS;


	end


    //=========
    // Clocks
    //=========

    always @(posedge i_inclock)
	begin
        if (lpm_indata == "REGISTERED")
            if (i_inclocken == 1 && $time > 0)
                i_data_reg <= data;

        if (lpm_wraddress_control == "REGISTERED")
            if (i_inclocken == 1 && $time > 0)
            begin
                i_wraddress_reg <= wraddress;
                i_wren_reg <= i_wren;
            end

    end

    always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
            if (i_outclocken == 1 && $time > 0)
            begin
                i_q_reg <= i_q_tmp;
            end

        if (lpm_rdaddress_control == "REGISTERED")
            if (i_outclocken == 1 && $time > 0)
            begin
                i_rdaddress_reg <= rdaddress;
                i_rden_reg <= i_rden;
            end
    end


    //=========
    // Memory
    //=========

    always @(i_data_tmp or i_wren_tmp or i_wraddress_tmp or negedge i_inclock)
	begin
        if (i_wren_tmp == 1)
            if (ValidAddress(i_wraddress_tmp))
            begin
                if (((use_eab == "ON") || (lpm_hint == "USE_EAB=ON")) && (lpm_wraddress_control == "REGISTERED"))
                begin
                    if (i_inclock == 0)
                    begin
                        mem_data[i_wraddress_tmp] = i_data_tmp;
                        mem_updated <= ~mem_updated;
                    end
                end
                else
                begin
                        mem_data[i_wraddress_tmp] = i_data_tmp;
                        mem_updated <= ~mem_updated;
                end
            end
	end

    always @(i_rden_tmp or i_rdaddress_tmp or mem_updated)
	begin
        if (i_rden_tmp == 1)
                    i_q_tmp = (ValidAddress(i_rdaddress_tmp))
                        ? mem_data[i_rdaddress_tmp]
                        : UNKNOWN;
        else if ((intended_device_family == "APEX20K") && ((use_eab == "ON")  || (lpm_hint == "USE_EAB=ON")))
            i_q_tmp = 0;

	end


    //=======
    // Sync
    //=======

    always @(wraddress or i_wraddress_reg)
            i_wraddress_tmp = (lpm_wraddress_control == "REGISTERED")
                            ? i_wraddress_reg
                            : wraddress;
    always @(rdaddress or i_rdaddress_reg)
        i_rdaddress_tmp = (lpm_rdaddress_control == "REGISTERED")
                            ? i_rdaddress_reg
                            : rdaddress;
    always @(i_wren or i_wren_reg)
        i_wren_tmp = (lpm_wraddress_control == "REGISTERED")
                       ? i_wren_reg
                       : i_wren;
    always @(i_rden or i_rden_reg)
        i_rden_tmp = (lpm_rdaddress_control == "REGISTERED")
                       ? i_rden_reg
                       : i_rden;
    always @(data or i_data_reg)
        i_data_tmp = (lpm_indata == "REGISTERED")
                       ? i_data_reg
                       : data;

    assign q = (lpm_outdata == "REGISTERED") ? i_q_reg : i_q_tmp;

endmodule // lpm_ram_dp

//------------------------------------------------------------------------

module lpm_ram_io ( dio, inclock, outclock, we, memenab, outenab, address );

	parameter lpm_type = "lpm_ram_io";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";
	parameter use_eab = "OFF";
	parameter intended_device_family = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock, we;
	input  memenab;
	input  outenab;
	inout  [lpm_width-1:0] dio;


	// inernal reg 
	reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg  [lpm_width-1:0] tmp_io;
	reg  [lpm_width-1:0] tmp_q;
	reg  [lpm_width-1:0] pdio;
	reg  [lpm_widthad-1:0] paddress;
	reg  pwe;
	reg  [lpm_width-1:0] ZEROS, ONES, UNKNOWN, HiZ;
	reg  [8*256:1] ram_initf;
	integer i;

	tri0 inclock;
	tri0 outclock;
        tri1 memenab;
        tri1 outenab;
			   
	  
	buf (i_inclock, inclock);
	buf (i_outclock, outclock);
	buf (i_memenab, memenab);
	buf (i_outenab, outenab);


//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] paddress;
		
		begin
			ValidAddress = 1'b0;
			if (^paddress ==='bx)
                             $display("%t:Error:  Invalid address.", $time);
                         else if (paddress >= lpm_numwords)
                             $display("%t:Error:  Address out of bound on RAM.", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//
		
	initial
	begin

		if (lpm_width <= 0)
                    $display("Error!  LPM_WIDTH parameter must be greater than 0.");

		if (lpm_widthad <= 0)
                    $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");

		// check for number of words out of bound
		if ((lpm_numwords > (1 << lpm_widthad))
			||(lpm_numwords <= (1 << (lpm_widthad-1))))
		begin
                    $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");
		end

                if ((lpm_indata != "REGISTERED") && (lpm_indata != "UNREGISTERED")) 
                    $display("Error!  LPM_INDATA must be \"REGISTERED\" or \"UNREGISTERED\".");
			
                if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED")) 
                    $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");
			
                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED")) 
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");


		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			ONES[i] = 1'b1;
			UNKNOWN[i] = 1'bX;
			HiZ[i] = 1'bZ;
		end 
			
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// Initialize input/output 
		pwe <= 0;
		pdio <= 0;
		paddress <= 0;
		tmp_io = 0;
		tmp_q <= ZEROS;

		// load data to the RAM
		if (lpm_file != "UNUSED")
		begin
`ifdef NO_PLI
			$readmemh(lpm_file, mem_data);
`else
			$convert_hex2ver(lpm_file, lpm_width, ram_initf);
			$readmemh(ram_initf, mem_data);
`endif
		end
	end


	always @(dio)
	begin
        if (lpm_indata == "UNREGISTERED")
            pdio <=  dio;
	end
		
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;
	end
		
		
	always @(we)
	begin
        if (lpm_address_control == "UNREGISTERED")
            pwe <=  we;
	end
	
	always @(posedge i_inclock)
	begin
        if (lpm_indata == "REGISTERED")
            pdio <=  dio;

        if (lpm_address_control == "REGISTERED")
		begin
                    paddress <=  address;
                    pwe <=  we;
		end
	end

	always @(pdio or paddress or pwe or i_memenab)
	begin :block_a
		if (ValidAddress(paddress))
		begin
                    if (lpm_address_control == "UNREGISTERED")
		        if (pwe && i_memenab)
                            mem_data[paddress] <= pdio;

                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= mem_data[paddress];
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q <= UNKNOWN;
		end
	end

        always @(negedge i_inclock or pdio)
	begin
        if (lpm_address_control == "REGISTERED")
                if ((use_eab == "ON") || (lpm_hint == "USE_EAB=ON"))
			if (pwe && i_memenab && (i_inclock == 0))
                            mem_data[paddress] = pdio;
	end

        always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
                if ((use_eab == "OFF") && pwe && i_memenab)
                            mem_data[paddress] <= pdio;
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
            tmp_q <= mem_data[paddress];
	end

	always @(i_memenab or i_outenab or tmp_q)
	begin
		if (i_memenab && i_outenab)
                    tmp_io = tmp_q;
		else if (!i_memenab || (i_memenab && !i_outenab))
                    tmp_io = HiZ;
	end
 
	assign dio =  tmp_io;

endmodule // lpm_ram_io
 
//------------------------------------------------------------------------

module lpm_rom ( q, inclock, outclock, memenab, address );

	parameter lpm_type = "lpm_rom";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
        parameter lpm_numwords = 1 << lpm_widthad;
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
        parameter lpm_file = "";
	parameter lpm_hint = "UNUSED";
	parameter intended_device_family = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock;
	input  memenab;
	output [lpm_width-1:0] q;

	// inernal reg 
	reg  [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg  [lpm_widthad-1:0] paddress;
	reg  [lpm_width-1:0] tmp_q;
	reg  [lpm_width-1:0] tmp_q_reg;
	reg  [lpm_width-1:0] ZEROS, UNKNOWN, HiZ;
	reg  [8*256:1] rom_initf;
	integer i;

	tri0 inclock;
	tri0 outclock;
	tri1 memenab;

	buf (i_inclock, inclock);
	buf (i_outclock, outclock);
	buf (i_memenab, memenab);


//---------------------------------------------------------------//
	function ValidAddress;
		input [lpm_widthad-1:0] address;
		begin
			ValidAddress = 1'b0;
			if (^address =='bx)
                            $display("%d:Error:  Invalid address.", $time);
			else if (address >= lpm_numwords)
                            $display("%d:Error:  Address out of bound on ROM.", $time);
			else
				ValidAddress = 1'b1;
		end
	endfunction
//---------------------------------------------------------------//
		
	initial     
	begin
		// Initialize output
		tmp_q <= 0;
		tmp_q_reg <= 0;
		paddress <= 0;
 
		if (lpm_width <= 0)
                    $display("Error!  LPM_WIDTH parameter must be greater than 0.");
	 
		if (lpm_widthad <= 0)
                    $display("Error!  LPM_WIDTHAD parameter must be greater than 0.");        
		 
		// check for number of words out of bound
		if ((lpm_numwords > (1 << lpm_widthad))
			||(lpm_numwords <= (1 << (lpm_widthad-1))))
                    $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD.");

                if ((lpm_address_control != "REGISTERED") && (lpm_address_control != "UNREGISTERED"))
                    $display("Error!  LPM_ADDRESS_CONTROL must be \"REGISTERED\" or \"UNREGISTERED\".");

                if ((lpm_outdata != "REGISTERED") && (lpm_outdata != "UNREGISTERED"))
                    $display("Error!  LPM_OUTDATA must be \"REGISTERED\" or \"UNREGISTERED\".");

		 
		for (i=0; i < lpm_width; i=i+1)
		begin
			ZEROS[i] = 1'b0;
			UNKNOWN[i] = 1'bX;
			HiZ[i] = 1'bZ;
		end 
			
		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		// load data to the ROM
                if (lpm_file == "" || lpm_file == "UNUSED")
                    $display("Warning:  LPM_ROM must have data file for initialization.\n");
                else
		begin
`ifdef NO_PLI
			$readmemh(lpm_file, mem_data);
`else
			$convert_hex2ver(lpm_file, lpm_width, rom_initf);
			$readmemh(rom_initf, mem_data);
`endif
		end
	end

	always @(posedge i_inclock)
	begin
        if (lpm_address_control == "REGISTERED")
            paddress <=  address;
	end
 
	always @(address)
	begin
        if (lpm_address_control == "UNREGISTERED")
            paddress <=  address;
	end
				   
	always @(paddress)
	begin 
		if (ValidAddress(paddress))
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q_reg <=  mem_data[paddress];
		end
		else
		begin
                    if (lpm_outdata == "UNREGISTERED")
                        tmp_q_reg <= UNKNOWN;
		end
	end

	always @(posedge i_outclock)
	begin
        if (lpm_outdata == "REGISTERED")
		begin
			if (ValidAddress(paddress))
                            tmp_q_reg <=  mem_data[paddress];
			else
                            tmp_q_reg <= UNKNOWN;
		end
	end
 
	
	always @(i_memenab or tmp_q_reg)
        begin
            tmp_q <= (i_memenab) ? tmp_q_reg : HiZ;
        end
	 
	assign q = tmp_q;

endmodule // lpm_rom
 
//------------------------------------------------------------------------

module lpm_fifo ( data, clock, wrreq, rdreq, aclr, sclr, q, usedw, full, empty );

	parameter lpm_type = "lpm_fifo";
	parameter lpm_width  = 1;
	parameter lpm_widthu  = 1;
    parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "UNUSED";

    input  [lpm_width-1:0] data;
    input  clock;
    input  wrreq;
    input  rdreq;
    input  aclr;
    input  sclr;
	output [lpm_width-1:0] q;
	output [lpm_widthu-1:0] usedw;
	output full;
	output empty;


	// internal reg
	reg [lpm_width-1:0] mem_data [lpm_numwords-1:0];
	reg [lpm_width-1:0] tmp_q;
	reg [lpm_width-1:0] ZEROS;
	reg [lpm_widthu+1:0] count_id;
	reg [lpm_widthu-1:0] write_id;
	reg [lpm_widthu-1:0] read_id;
	reg empty_flag;
	reg full_flag;
	integer i;

	// VCS fix
	reg [lpm_widthu+1:0] usedw_tmp;
	
	tri0 aclr;
	tri0 sclr;

	buf (i_aclr, aclr);
	buf (i_sclr, sclr);


	initial
	begin
        if (lpm_width <= 0)
            $display("Error!  LPM_WIDTH must be greater than 0.");

        if (lpm_numwords < 1)
            $display("Error!  LPM_NUMWORDS must be greater than 0.");

		// check for number of words out of bound
        if ((lpm_widthu != 1) && (lpm_numwords > (1 << lpm_widthu)))
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHU.");
        if (lpm_numwords <= (1 << (lpm_widthu-1)) && lpm_numwords > 1)
            $display("Error!  The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHU.");

        if (lpm_showahead != "ON" && lpm_showahead != "OFF")
            $display("Error!  LPM_SHOWAHEAD must be \"ON\" or \"OFF\".");


		for (i=0; i < lpm_width; i=i+1)
			ZEROS[i] = 1'b0;

		for (i = 0; i < lpm_numwords; i=i+1)
			mem_data[i] = ZEROS;

		full_flag = 0;
		empty_flag = 1;
		read_id = 0;
		write_id = 0;
		count_id = 0;
		usedw_tmp = 0;
		tmp_q = ZEROS;
	end

    always @(posedge clock or posedge i_aclr)
	begin
		if (i_aclr)
		begin
			tmp_q = ZEROS;
			full_flag = 0;
			empty_flag = 1;
			read_id = 0;
			write_id = 0;
			count_id = 0;
			if (lpm_showahead == "ON")
				tmp_q = mem_data[0];
		end
		else if (clock)
		begin
			if (i_sclr)
			begin
				tmp_q <= mem_data[read_id];
				full_flag <= 0;
				empty_flag <= 1;
				read_id = 0;
				write_id = 0;
				count_id = 0;
				if (lpm_showahead == "ON")
					tmp_q <= mem_data[0];
			end
			else
			begin
				// both WRITE and READ
				if ((wrreq && !full_flag) && (rdreq && !empty_flag))
				begin
					mem_data[write_id] = data;
					if (write_id >= lpm_numwords-1)
						write_id = 0;
					else
						write_id = write_id + 1;

					tmp_q <= mem_data[read_id];
					if (read_id >= lpm_numwords-1)
						read_id = 0;
					else
						read_id = read_id + 1;
					if (lpm_showahead == "ON")
						tmp_q <= mem_data[read_id];
				end

				// WRITE
				else if (wrreq && !full_flag)
				begin
					mem_data[write_id] = data;
					if (lpm_showahead == "ON")
					begin
						// changed by M.Singal :
						// showahead should show current
						// write data
//						tmp_q <= mem_data[read_id];
						tmp_q <= data;
					end
					count_id = count_id + 1;
					empty_flag <= 0;
					if (count_id >= lpm_numwords)
					begin
						full_flag <= 1;
						count_id = lpm_numwords;
					end
					if (write_id >= lpm_numwords-1)
						write_id = 0;
					else
						write_id = write_id + 1;
				end
							
				// READ
				else if (rdreq && !empty_flag)
				begin
					tmp_q <= mem_data[read_id];
					count_id = count_id - 1;
					full_flag <= 0;
					if (count_id <= 0)
					begin
						empty_flag <= 1;
						count_id = 0;
					end
					if (read_id >= lpm_numwords-1)
						read_id = 0;
					else
						read_id = read_id + 1;
					if (lpm_showahead == "ON")
						tmp_q <= mem_data[read_id];
				end
			end
		end
		usedw_tmp <= count_id;
	end

	assign q = tmp_q;
	assign full = full_flag;
	assign empty = empty_flag;
//	assign usedw = count_id;
	assign usedw = usedw_tmp;

endmodule // lpm_fifo

//------------------------------------------------------------------------

module lpm_fifo_dc_dffpipe ( d, q, clock, aclr );

    parameter lpm_delay = 1;
    parameter lpm_width = 128;

    input [lpm_width-1:0] d;
    input clock;
    input aclr;
    output [lpm_width-1:0] q;    

	// internal reg
    reg [lpm_width-1:0] dffpipe [lpm_delay:0];
    reg [lpm_width-1:0] i_q;
    integer delay, i;

    initial
    begin
        delay = lpm_delay-1;
        for (i=0; i<lpm_delay; i=i+1)
            dffpipe[i] = 0;
        i_q = 0;
    end

    always @(d)
    begin
        if (lpm_delay == 0 && !aclr)
            i_q <= (aclr) ? 0 : d;
    end

    always @(aclr)
    begin
        if (aclr)
        begin
            for (i=0; i<lpm_delay; i=i+1)
                dffpipe[i] = 0;
            i_q <= 0;
        end
    end

    always @(posedge clock)
    begin
        if (!aclr && lpm_delay > 0 && $time > 0)
        begin
            if (delay > 0)
                for (i=delay; i>0; i=i-1)
                    dffpipe[i] = dffpipe[i-1];
            dffpipe[0] = d;
            i_q <= dffpipe[delay];
        end
    end

    assign q = i_q;

endmodule // lpm_fifo_dc_dffpipe

//------------------------------------------------------------------------

module lpm_fifo_dc_fefifo ( usedw_in, wreq, rreq, empty, full, clock, aclr );

    parameter lpm_widthad = 1;
    parameter lpm_numwords = 1;
    parameter lpm_mode = "READ";
    parameter underflow_checking = "ON"; 
    parameter overflow_checking = "ON"; 

    input [lpm_widthad-1:0] usedw_in;
    input wreq, rreq;
    output empty, full;
    input clock;
    input aclr;

	// internal reg
    reg [1:0] sm_empty;
    reg i_empty;
    reg lrreq;
    reg valid_rreq;
    reg i_full;
    integer almostfull;

    initial
    begin
        if (lpm_mode != "READ" && lpm_mode != "WRITE")
            $display("Error!  LPM_MODE must be \"READ\" or \"WRITE\".");
        if(underflow_checking != "ON" && underflow_checking != "OFF")
            $display("Error! underflow_checking must be ON or OFF.");
        if(overflow_checking != "ON" && overflow_checking != "OFF")
            $display("Error! overflow_checking must be ON or OFF.");

        sm_empty = 2'b00;
        i_empty = 1'b1;
        lrreq = 1'b0;
        i_full = 1'b0;
        almostfull = (lpm_numwords >= 3) ? lpm_numwords-3 : 0;
    end

    always @(rreq or i_empty)
        valid_rreq = (underflow_checking == "OFF") ? rreq
                                                   : rreq && !i_empty;

    always @(posedge clock or posedge aclr)
    begin
        if (aclr)
        begin
            sm_empty = 2'b00;
            lrreq <= 1'b0;
        end
        else // if ($time > 0)
        begin
            lrreq <= valid_rreq;
            if (lpm_mode == "READ")
            begin
               casex (sm_empty)
                    2'b00:                          // state_empty
                        if (usedw_in != 0)
                            sm_empty = 2'b01;
                    2'b01:                          // state_non_empty
                        if (rreq && ((usedw_in==1 && !lrreq) || (usedw_in==2 && lrreq)))
                            sm_empty = 2'b10;
                    2'b10:                          // state_emptywait
                        if (usedw_in > 1) sm_empty = 2'b01;
                        else sm_empty = 2'b00;
                endcase
            end
            else if (lpm_mode == "WRITE")
            begin
                casex (sm_empty)
                    2'b00:                          // state_empty
                        if (wreq)
                            sm_empty = 2'b01;
                    2'b01:                          // state_one
                        if (!wreq)
                            sm_empty = 2'b11;
                    2'b11:                          // state_non_empty
                        if (wreq)
                            sm_empty = 2'b01;
                        else if (usedw_in == 0)
                            sm_empty = 2'b00;
                endcase
            end
        end

        i_empty <= !sm_empty[0];
        i_full <= (!aclr && $time>0 && usedw_in>=almostfull) ? 1'b1 : 1'b0;
    end

    assign empty = i_empty;
    assign full = i_full;

endmodule // lpm_fifo_dc_fefifo

//------------------------------------------------------------------------
//------------------------------------------------------------------------
module lpm_fifo_dc ( data, rdclock, wrclock, aclr, rdreq, wrreq, rdfull,
                      wrfull, rdempty, wrempty, rdusedw, wrusedw, q );

	parameter lpm_type = "lpm_fifo_dc";
	parameter lpm_width = 1;
	parameter lpm_widthu = 1;
        parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "USE_EAB=ON"; 
	parameter underflow_checking = "ON"; 
	parameter overflow_checking = "ON"; 
        parameter delay_rdusedw = 1;
        parameter delay_wrusedw = 1;
        parameter rdsync_delaypipe = 3;
        parameter wrsync_delaypipe = 3;

	input [lpm_width-1:0] data;
        input rdclock;
        input wrclock;
	input wrreq;
	input rdreq;
	input aclr;
	output rdfull;
	output wrfull;
	output rdempty;
	output wrempty;
	output [lpm_widthu-1:0] rdusedw;
	output [lpm_widthu-1:0] wrusedw;
	output [lpm_width-1:0] q;

	// internal reg
    reg [lpm_width-1:0] mem_data [(1<<lpm_widthu)-1:0];
    reg [lpm_widthu-1:0] i_rdptr, i_wrptr;
    wire [lpm_widthu-1:0] w_rdptrrg, w_wrdelaycycle;
    wire [lpm_widthu-1:0] w_ws_nbrp, w_rs_nbwp, w_ws_dbrp, w_rs_dbwp;
    wire [lpm_widthu-1:0] w_wr_dbuw, w_rd_dbuw, w_rdusedw, w_wrusedw;
    reg [lpm_widthu-1:0] i_wr_udwn, i_rd_udwn;
    wire w_rdempty, w_wrempty, wrdfull, w_wrfull;
    reg i_rdempty, i_wrempty;
    reg i_rdfull, i_wrfull;
    reg i_rden, i_wren, i_rdenclock;
    reg [lpm_width-1:0] i_q;
    integer i;

    reg [lpm_width-1:0] i_data_tmp, i_data_reg;
    reg [lpm_width-1:0] i_q_tmp, i_q_reg;
    reg [lpm_widthu-1:0] i_rdptr_tmp, i_wrptr_tmp, i_wrptr_reg;
    reg i_wren_tmp, i_wren_reg;

	tri0 aclr;
	buf (i_aclr, aclr);


    initial
    begin
        if(lpm_showahead != "ON" && lpm_showahead != "OFF")
            $display("Error! lpm_showahead must be ON or OFF.");
        if(underflow_checking != "ON" && underflow_checking != "OFF")
            $display("Error! underflow_checking must be ON or OFF.");
        if(overflow_checking != "ON" && overflow_checking != "OFF")
            $display("Error! overflow_checking must be ON or OFF.");

        i_rdptr = 0;
        i_wrptr = 0;
        i_rdempty = 1;
        i_wrempty = 1;
        i_rdfull = 0;
        i_wrfull = 0;
        i_rden = 0;
        i_rdenclock = 0;
        i_wren = 0;
        i_q = 0;

        i_data_tmp = 0;
        i_data_reg = 0;
        i_q_tmp = 0;
        i_q_reg = 0;
        i_rdptr_tmp = 0;
        i_wrptr_tmp = 0;
        i_wrptr_reg = 0;
        i_wren_tmp = 0;
        i_wren_reg = 0;
        i_wr_udwn = 0;
        i_rd_udwn = 0;

        for (i=0; i<(1<<lpm_widthu); i=i+1)
            mem_data[i] = 0;
    end


    //--------
    // FIFOram
    //--------

    always @(rdreq or i_rdempty)
        i_rden = (underflow_checking == "OFF") ? rdreq
                                               : rdreq && !i_rdempty;
    always @(wrreq or i_wrfull)
        i_wren = (overflow_checking == "OFF") ? wrreq
                                              : wrreq && !i_wrfull;

    // FIFOram_sync
    always @(i_data_reg or i_q_tmp or i_q_reg or i_aclr or
             i_rdptr or i_wren_reg or i_wrptr_reg)
    begin
        if (i_aclr)
        begin
            i_wrptr_tmp <= 0;
            i_rdptr_tmp <= 0;
            i_wren_tmp <= 0;
            i_data_tmp <= 0;
            i_q <= (lpm_showahead == "ON") ? i_q_tmp : 0;
        end
        else
        begin
            i_wrptr_tmp <= i_wrptr_reg;
            i_rdptr_tmp <= i_rdptr;
            i_wren_tmp <= i_wren_reg;
            i_data_tmp <= i_data_reg;
            i_q <= (lpm_showahead == "ON") ? i_q_tmp : i_q_reg;
        end
    end

    // FIFOram_aclr
    always @(i_aclr)
    begin
        if (i_aclr)
        begin
            i_data_reg <= 0;
            i_wrptr_reg <= 0;
            i_wren_reg <= 0;
            i_q_reg <= 0;
        end
    end

    // FIFOram_wrclock
    always @(posedge wrclock)
    begin
        if (!i_aclr && $time > 0)
        begin
            i_data_reg <= data;
            i_wrptr_reg <= i_wrptr;
            i_wren_reg <= i_wren;
        end
    end

    // FIFOram_rdclock
    always @(posedge rdclock)
    begin
        if (!i_aclr && i_rden && $time > 0)
            i_q_reg <= i_q_tmp;
    end

    // FIFOram_memory_read
    always @(i_rdptr_tmp)
        i_q_tmp <= mem_data[i_rdptr_tmp];

    // FIFOram_memory_write_eab
    always @(negedge wrclock)
    begin
        if (lpm_hint == "USE_EAB=ON")
        begin
            if (i_wren_tmp)
                mem_data[i_wrptr_tmp] = i_data_tmp;
            i_q_tmp = mem_data[i_rdptr_tmp];
        end
    end

    // FIFOram_memory_write_lcell
    always @(posedge wrclock)
    begin
        if (lpm_hint != "USE_EAB=ON")
        begin
            if (i_wren_tmp)
                mem_data[i_wrptr_tmp] = i_data_tmp;
            i_q_tmp = mem_data[i_rdptr_tmp];
        end
    end


    //---------
    // Counters
    //---------

    // rdptr
    always @(i_aclr)
        if (i_aclr)
            i_rdptr <= 0;
    always @(posedge rdclock)
        if (!i_aclr && i_rden && $time > 0)
            i_rdptr <= ((i_rdptr < (1<<lpm_widthu)-1) || (underflow_checking == "OFF"))
                        ? i_rdptr+1 : 0;

    // wrptr
    always @(i_aclr)
        if (i_aclr)
            i_wrptr <= 0;
    always @(posedge wrclock)
        if (!i_aclr && i_wren && $time > 0)
            i_wrptr <= ((i_wrptr < (1<<lpm_widthu)-1) || (overflow_checking == "OFF"))
                        ? i_wrptr+1 : 0;

    //-------------------
    // Delays & DFF Pipes
    //-------------------

    always @(negedge rdclock)  i_rdenclock <= 0;
    always @(posedge rdclock)  if (i_rden) i_rdenclock <= 1;

    lpm_fifo_dc_dffpipe RDPTR_D ( .d (i_rdptr), .q (w_rdptrrg),
                             .clock (i_rdenclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WRPTR_D ( .d (i_wrptr), .q (w_wrdelaycycle),
                             .clock (wrclock), .aclr (i_aclr) );
    defparam
        RDPTR_D.lpm_delay = 0,
        RDPTR_D.lpm_width = lpm_widthu,
        WRPTR_D.lpm_delay = 1,
        WRPTR_D.lpm_width = lpm_widthu;

    lpm_fifo_dc_dffpipe WS_NBRP ( .d (w_rdptrrg), .q (w_ws_nbrp),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RS_NBWP ( .d (w_wrdelaycycle), .q (w_rs_nbwp),
                             .clock (rdclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WS_DBRP ( .d (w_ws_nbrp), .q (w_ws_dbrp),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RS_DBWP ( .d (w_rs_nbwp), .q (w_rs_dbwp),
                             .clock (rdclock), .aclr (i_aclr) );   
    defparam
        WS_NBRP.lpm_delay = wrsync_delaypipe,
        WS_NBRP.lpm_width = lpm_widthu,
        RS_NBWP.lpm_delay = rdsync_delaypipe,
        RS_NBWP.lpm_width = lpm_widthu,
        WS_DBRP.lpm_delay = 1,              // gray_delaypipe
        WS_DBRP.lpm_width = lpm_widthu,
        RS_DBWP.lpm_delay = 1,              // gray_delaypipe
        RS_DBWP.lpm_width = lpm_widthu;

    always @(i_wrptr or w_ws_dbrp)
        i_wr_udwn = i_wrptr - w_ws_dbrp;

    always @(i_rdptr or w_rs_dbwp)
        i_rd_udwn = w_rs_dbwp - i_rdptr;

    lpm_fifo_dc_dffpipe WRUSEDW ( .d (i_wr_udwn), .q (w_wrusedw),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RDUSEDW ( .d (i_rd_udwn), .q (w_rdusedw),
                             .clock (rdclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe WR_DBUW ( .d (i_wr_udwn), .q (w_wr_dbuw),
                             .clock (wrclock), .aclr (i_aclr) );
    lpm_fifo_dc_dffpipe RD_DBUW ( .d (i_rd_udwn), .q (w_rd_dbuw),
                             .clock (rdclock), .aclr (i_aclr) );
    defparam
        WRUSEDW.lpm_delay = delay_wrusedw,
        WRUSEDW.lpm_width = lpm_widthu,
        RDUSEDW.lpm_delay = delay_rdusedw,
        RDUSEDW.lpm_width = lpm_widthu,
        WR_DBUW.lpm_delay = 1,              // wrusedw_delaypipe
        WR_DBUW.lpm_width = lpm_widthu,
        RD_DBUW.lpm_delay = 1,              // rdusedw_delaypipe
        RD_DBUW.lpm_width = lpm_widthu;


    //-----------
    // Full/Empty
    //-----------

    lpm_fifo_dc_fefifo WR_FE ( .usedw_in (w_wr_dbuw), .wreq (wrreq), .rreq (rdreq),
                          .clock (wrclock), .aclr (i_aclr),
                          .empty (w_wrempty), .full (w_wrfull) );
    lpm_fifo_dc_fefifo RD_FE ( .usedw_in (w_rd_dbuw), .rreq (rdreq), .wreq(wrreq),
                          .clock (rdclock), .aclr (i_aclr),
                          .empty (w_rdempty), .full (w_rdfull) );

    defparam
        WR_FE.lpm_widthad = lpm_widthu,
        WR_FE.lpm_numwords = lpm_numwords,
        WR_FE.underflow_checking = underflow_checking,
        WR_FE.overflow_checking = overflow_checking,
        WR_FE.lpm_mode = "WRITE",
        RD_FE.lpm_widthad = lpm_widthu,
        RD_FE.lpm_numwords = lpm_numwords,
        RD_FE.underflow_checking = underflow_checking,
        RD_FE.overflow_checking = overflow_checking,
        RD_FE.lpm_mode = "READ";

    always @(w_wrfull)  i_wrfull = w_wrfull;
    always @(w_rdfull)  i_rdfull = w_rdfull;
    always @(w_wrempty)  i_wrempty = w_wrempty;
    always @(w_rdempty)  i_rdempty = w_rdempty;


    //--------
    // Outputs
    //--------

    assign q = i_q;
    assign wrfull = i_wrfull;
    assign rdfull = i_rdfull;
    assign wrempty = i_wrempty;
    assign rdempty = i_rdempty;
    assign wrusedw = w_wrusedw;
    assign rdusedw = w_rdusedw;

endmodule // lpm_fifo_dc

//------------------------------------------------------------------------

module lpm_inpad ( result, pad );

	parameter lpm_type = "lpm_inpad";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] pad;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;

	always @(pad)
	begin
		result = pad;
	end

endmodule // lpm_inpad

//------------------------------------------------------------------------

module lpm_outpad ( data, pad );

	parameter lpm_type = "lpm_outpad";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

    input  [lpm_width-1:0] data;
    output [lpm_width-1:0] pad;

    reg    [lpm_width-1:0] pad;

	always @(data)
	begin
		pad = data;
	end

endmodule // lpm_outpad

//------------------------------------------------------------------------

module lpm_bipad ( result, pad, data, enable );

	parameter lpm_type = "lpm_bipad";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enable;
	inout  [lpm_width-1:0] pad;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] tmp_pad;
	reg    [lpm_width-1:0] result;

	always @(data or pad or enable)
	begin
		if (enable == 1)
		begin
			tmp_pad = data;
			result = 'bz;
		end
		else if (enable == 0)
		begin
			result = pad;
			tmp_pad = 'bz;
		end
	end

	assign pad = tmp_pad;

endmodule // lpm_bipad
