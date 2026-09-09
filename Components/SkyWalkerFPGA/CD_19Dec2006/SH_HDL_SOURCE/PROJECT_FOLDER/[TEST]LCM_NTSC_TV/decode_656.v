module decode_656 (
TD_D,
CLOCK,
START,
Field,
VS,
STATUS,
Y_check
);
input [7:0]TD_D;
input CLOCK;
output START;
output Field;
output VS;
output [7:0]STATUS;
output Y_check;

reg  [7:0]R1,R2,R3;
reg  [7:0]RR1,RR2,RR3;
	
wire  Y_check=( (R3==8'hff) && (R2==8'h00) && (R1==8'h00) )?1:0;	
   always @(posedge CLOCK) begin
	   RR1=TD_D;
	   RR2=R1;
	   RR3=R2;
	end
	
	always @(negedge CLOCK) begin
	    R1=RR1;
	    R2=RR2;
	    R3=RR3;
	end
	
	reg START,Field,VS;	
	reg [7:0]STATUS;
	always @(posedge CLOCK) begin
	if (Y_check==1)
	begin
	    START= TD_D[4];
		VS=    TD_D[5];
		Field= TD_D[6];
		STATUS[7:0]=TD_D[7:0];
	end	
	end
	
endmodule