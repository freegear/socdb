/*****************************************************************
		         Part of I2S Controller testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module MCLKFreqCheck
(
		ENABLE,
		SAMPLING_FREQ,

		MCLK,		// 256*Fs
		BCLK,
		LRCLK
);

input         ENABLE;
input [2:0]   SAMPLING_FREQ;	// 48KHz=5, 44.1=4, 32=3, 22.05=2, 16=1, 8=0
input         MCLK;
inout         BCLK;
inout         LRCLK;

time MCLK_RisingEdge;
time MCLK_FallingEdge;

time BCLK_RisingEdge;
time BCLK_FallingEdge;

time LRCLK_RisingEdge;
time LRCLK_FallingEdge;

initial
begin
	MCLK_RisingEdge = 0;
	MCLK_FallingEdge = 0;
	BCLK_RisingEdge = 0;
	BCLK_FallingEdge = 0;
	LRCLK_RisingEdge = 0;
	LRCLK_FallingEdge = 0;
end

always @(ENABLE)
begin
	if(ENABLE == 0)
	begin
		MCLK_RisingEdge = 0;
		MCLK_FallingEdge = 0;
		BCLK_RisingEdge = 0;
		BCLK_FallingEdge = 0;
		LRCLK_RisingEdge = 0;
		LRCLK_FallingEdge = 0;
	end
end

always @(posedge MCLK)
begin
	if(MCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/8000.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/8000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/16000.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/16000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/22500.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/22500.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/32000.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/32000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/44100.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/44100.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/48000.0/256.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/48000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		endcase
	end
`ifdef MCLK_BOTHEDGE
	if(MCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/8000.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/8000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/16000.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/16000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/22500.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/22500.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/32000.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/32000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/44100.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/44100.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/48000.0/256.0/2.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/48000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		endcase
	end
`endif
	if(MCLK === 1 && ENABLE == 1)
		MCLK_RisingEdge = $time;
end

always @(negedge MCLK)
begin
	if(MCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/8000.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/8000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/16000.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/16000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/22500.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/22500.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/32000.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/32000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/44100.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/44100.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - MCLK_FallingEdge) < (950000000.0/48000.0/256.0)
				|| ($time - MCLK_FallingEdge) > (1050000000.0/48000.0/256.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		endcase
	end
`ifdef MCLK_BOTHEDGE
	if(MCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/8000.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/8000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/16000.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/16000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/22500.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/22500.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/32000.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/32000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/44100.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/44100.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - MCLK_RisingEdge) < (950000000.0/48000.0/256.0/2.0)
				|| ($time - MCLK_RisingEdge) > (1050000000.0/48000.0/256.0/2.0))
			begin
				$display($time, "MCLK Frequency differs");
				$stop;
			end
		endcase
	end
`endif
	if(MCLK === 1 && ENABLE == 1)
		MCLK_FallingEdge = $time;
end

always @(posedge BCLK)
begin
	if(BCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/8000.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/8000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/16000.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/16000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/22500.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/22500.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/32000.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/32000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/44100.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/44100.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/48000.0/64.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/48000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(BCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/8000.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/8000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/16000.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/16000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/22500.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/22500.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/32000.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/32000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/44100.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/44100.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/48000.0/64.0/2.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/48000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(BCLK === 1 && ENABLE == 1)
		BCLK_RisingEdge = $time;
end

always @(negedge BCLK)
begin
	if(BCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/8000.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/8000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/16000.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/16000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/22500.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/22500.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/32000.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/32000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/44100.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/44100.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - BCLK_FallingEdge) < (950000000.0/48000.0/64.0)
				|| ($time - BCLK_FallingEdge) > (1050000000.0/48000.0/64.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(BCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/8000.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/8000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/16000.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/16000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/22500.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/22500.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/32000.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/32000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/44100.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/44100.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - BCLK_RisingEdge) < (950000000.0/48000.0/64.0/2.0)
				|| ($time - BCLK_RisingEdge) > (1050000000.0/48000.0/64.0/2.0))
			begin
				$display($time, "BCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(BCLK === 1 && ENABLE == 1)
		BCLK_FallingEdge = $time;
end


always @(posedge LRCLK)
begin
	if(LRCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/8000.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/8000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/16000.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/16000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/22500.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/22500.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/32000.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/32000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/44100.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/44100.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/48000.0/1.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/48000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(LRCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/8000.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/8000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/16000.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/16000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/22500.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/22500.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/32000.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/32000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/44100.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/44100.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/48000.0/1.0/2.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/48000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(LRCLK === 1 && ENABLE == 1)
		LRCLK_RisingEdge = $time;
end

always @(negedge LRCLK)
begin
	if(LRCLK_FallingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/8000.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/8000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/16000.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/16000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/22500.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/22500.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/32000.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/32000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/44100.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/44100.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - LRCLK_FallingEdge) < (950000000.0/48000.0/1.0)
				|| ($time - LRCLK_FallingEdge) > (1050000000.0/48000.0/1.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(LRCLK_RisingEdge != 0)
	begin
		case(SAMPLING_FREQ)
		3'b000:	// 8 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/8000.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/8000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b001:	// 16 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/16000.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/16000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b010:	// 22.05 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/22500.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/22500.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 32 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/32000.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/32000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b011:	// 44.1 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/44100.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/44100.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		3'b101:	// 48 KHz
			if(($time - LRCLK_RisingEdge) < (950000000.0/48000.0/1.0/2.0)
				|| ($time - LRCLK_RisingEdge) > (1050000000.0/48000.0/1.0/2.0))
			begin
				$display($time, "LRCLK Frequency differs");
				$stop;
			end
		endcase
	end
	if(LRCLK === 1 && ENABLE == 1)
		LRCLK_FallingEdge = $time;
end

endmodule

