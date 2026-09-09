module div
   (clk, 
	rst_p, 
	Load, 
	Dividend, 
	Divisor, 
	Quotient, 
	Remainder);
	input  clk, rst_p, Load;
	input  [7:0] Dividend;
	input  [7:0] Divisor;
	output [7:0] Quotient;
	output [7:0] Remainder;
	//FSM states
	parameter   ST_WaitLoad   = 0,
				ST_Shl_0      = 1,
			    ST_Subtract   = 2,
			    ST_Shl_1	  = 3,
			    ST_Overflow   = 4,
			    ST_Done       = 5;
	reg [2:0]	CurrentState, NextState;
	reg [5:0]	CurrentCount, NextCount;
	reg ShR, Sll_Zero, Sll_One, Subtract, ReSum, A_GE_B;
	reg [15:0]  RegA;
	reg [7:0]   RegB;
    reg [6:0]   RegA_minus_RegB;

	//----------------------------------------
	// FSM Controller with intergrated counter
	//----------------------------------------
	always @(A_GE_B or Load or CurrentCount or CurrentState) begin: FSM_COMB
		Sll_One   = 0;
		Sll_Zero  = 0;
		ReSum 	  = 0;
		Subtract  = 0;
		ShR 	  = 0;
		NextCount = CurrentCount;
		case (CurrentState)
			ST_WaitLoad: begin
					NextCount = 17;
					if(Load) NextState = ST_Shl_0;
					else NextState = ST_WaitLoad;
				    end	
			ST_Shl_0: begin
					NextCount = CurrentCount-1'b1;
					NextState = ST_Subtract;
					Sll_Zero = 1;
					end
			ST_Overflow: begin
					NextCount = CurrentCount-1'b1;
					ReSum = 1;
					NextState = ST_Subtract;
					end
			ST_Subtract: begin
					if (CurrentCount == 0)
						NextState = ST_Done;
					else begin
						NextCount = CurrentCount-1'b1;
						Subtract = 1;
						if (A_GE_B)	NextState = ST_Overflow;
						else NextState = ST_Shl_1;
						end
					end
			ST_Shl_1: begin
						NextCount = CurrentCount-1'b1;
						Sll_One = 1;
						NextState = ST_Subtract;
					end
			ST_Done: begin
						NextState = ST_WaitLoad;
						ShR = 1;
					end
			default: NextState = CurrentState;
		endcase
	end
	always @(posedge clk or posedge rst_p) 	
			if(rst_p) begin
					CurrentCount = 17;
//					CurrentCount = 16;
					CurrentState = ST_WaitLoad;
				    end
			else	begin
					CurrentCount = NextCount;
					CurrentState = NextState;
					end
	//------------------
	// 2:Rem = Rem - Div
	//------------------
		always @(RegA or RegB){A_GE_B,RegA_minus_RegB} <= RegA[15:8]-RegB;
	//---------------
	// Data registers
	//---------------
	always @(posedge clk or posedge rst_p) 
			//-------------------
			// Asynchronuou reset
			//-------------------
			if(rst_p)begin
			        RegA = 0;
			        RegB = 0;
					end
			//----------------------------
			// Load new data to be divided	 
			//----------------------------
			else if(Load)begin
                RegA = {8'b00000000,Dividend};
                RegB = Divisor;
				end
			//----------------------
			// 1, 3b:Shift Rem left1
			//----------------------
			else if(Sll_Zero)RegA = {RegA[14:0],1'b0};
			//------------------
			// 2:Rem = Rem - Div
			//------------------
			else if(Subtract)RegA[15:8] = {A_GE_B,RegA_minus_RegB};
			//-----------------------------
			// 3a:Rem >= 0 => sll R, R0 = 1
			//-----------------------------			
			else if(Sll_One)RegA={RegA[14:0],1'b1};
			//-------------------
			// 3b:Rem < 0 => +Div 
			//-------------------	
			else if(ReSum)begin
					RegA[15:8] = RegA[15:8] + RegB;
					RegA ={RegA[14:0],1'b0};
					end
			//------------------------------------
			// done:Shift left half of Rem right 1 
			//------------------------------------	
			else if(ShR)RegA[15:8]={1'b0,RegA[15:9]};
		
	assign Quotient  = RegA[7:0];
	assign Remainder = RegA[15:8];
	endmodule
