// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : LuFILTERCore.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is Luminance filter core.
// ===================================================================

module LuFILTERCore(

                CLK,
                RESETn,

                FilterSel, //01 --> NTSC notch  10 --> PAL notch
                DataIn,
                DataOut
       );

    input   CLK;
    input   RESETn;
    input   [1:0]   FilterSel;
    input   [9:0]   DataIn;
    output  [11:0]   DataOut;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

reg [11:0] DataOut;
reg [9:0] Delay0;
reg [9:0] Delay1;
reg [9:0] Delay2;
reg [9:0] Delay3;
reg [9:0] Delay4;
reg [9:0] Delay5;
reg [9:0] Delay6;
reg [9:0] Delay7;
reg [9:0] Delay8;
reg [9:0] Delay9;
reg [9:0] Delay10;

wire  [10:0]  MUL37IN;
wire  [10:0]  MULM50IN;
wire  [10:0]  MULM70IN;
wire  [10:0]  MUL298IN;
wire  [10:0]  MUL593IN;

wire  [20:0]  MUL37OUT;
wire  [20:0]  MULM50OUT;
wire  [20:0]  MULM70OUT;
wire  [20:0]  MUL298OUT;
wire  [20:0]  MUL593OUT;

reg  [20:0]  MUL37OUT_d;
reg  [20:0]  MULM50OUT_d;
reg  [20:0]  MULM70OUT_d;
reg  [20:0]  MUL298OUT_d;
reg  [20:0]  MUL593OUT_d;

reg  [10:0]  MUL37A;
reg  [10:0]  MULM50A;
reg  [10:0]  MULM70A;
reg  [10:0]  MUL298A;
reg  [10:0]  MUL593A;
reg  [10:0]  MUL37B;
reg  [10:0]  MULM50B;
reg  [10:0]  MULM70B;
reg  [10:0]  MUL298B;

wire [21:0] AdderOut;
wire [11:0] ByPass;
assign      ByPass = {3'd0,Delay4[9:1]} + {3'd0, Delay5[9:1]};

always @(AdderOut or FilterSel or ByPass) begin
        case(FilterSel)// synopsys parallel_case
            2'b00: DataOut = AdderOut[21:10];
            2'b01: DataOut = AdderOut[21:10];
            2'b10: DataOut = AdderOut[21:10];
            default DataOut = ByPass[11:0];
        endcase
end
// =======================================================================
// Adder Mux
// -----------------------------------------------------------------------

always @(Delay0 or Delay1 or Delay2 or Delay3 or Delay4  or 
         Delay5 or Delay6 or Delay7 or Delay8 or Delay9  or 
         Delay10 or
         FilterSel 
        ) begin

        case(FilterSel)// synopsys parallel_case
            2'b11: begin //Bypass mode
                    MUL37A  <= 0;
                    MULM50A <= 0;
                    MULM70A <= 0;
                    MUL298A <= 0;
                    MUL593A <= 0;
                    MUL298B <= 0;
                    MULM70B <= 0;
                    MULM50B <= 0;
                    MUL37B  <= 0;
                   end
            default begin
                    MUL37A  <= {1'b0, Delay1};
                    MULM50A <= {1'b0, Delay2};
                    MULM70A <= {1'b0, Delay3};
                    MUL298A <= {1'b0, Delay4};
                    MUL593A <= {1'b0, Delay5};
                    MUL298B <= {1'b0, Delay6};
                    MULM70B <= {1'b0, Delay7};
                    MULM50B <= {1'b0, Delay8};
                    MUL37B  <= {1'b0, Delay9};
                    end
        endcase
end

// =======================================================================
// Adder 
// -----------------------------------------------------------------------
assign MUL37IN   = MUL37A + MUL37B;
assign MULM50IN  = MULM50A + MULM50B;
assign MULM70IN  = MULM70A + MULM70B;
assign MUL298IN  = MUL298A + MUL298B;
assign MUL593IN  = MUL593A;

assign AdderOut = {1'b0, MUL37OUT_d }+
                  {1'b0, MULM50OUT_d}+
                  {1'b0, MULM70OUT_d}+
                  {1'b0, MUL298OUT_d}+
                  {1'b0, MUL593OUT_d};

// =======================================================================
// Multifly
// -----------------------------------------------------------------------

LuMUL LuMUL(
            .MUL37IN(MUL37IN),
            .MULM50IN(MULM50IN),
            .MULM70IN(MULM70IN),
            .MUL298IN(MUL298IN),
            .MUL593IN(MUL593IN),

            .MUL37OUT(MUL37OUT),
            .MULM50OUT(MULM50OUT),
            .MULM70OUT(MULM70OUT),
            .MUL298OUT(MUL298OUT),
            .MUL593OUT(MUL593OUT)
           );

// =======================================================================
// Delay
// -----------------------------------------------------------------------
always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        Delay0 <= 0;
        Delay1 <= 0;
        Delay2 <= 0;
        Delay3 <= 0;
        Delay4 <= 0;
        Delay5 <= 0;
        Delay6 <= 0;
        Delay7 <= 0;
        Delay8 <= 0;
        Delay9 <= 0;
        Delay10 <= 0;

        MUL37OUT_d  <=0;
        MULM50OUT_d <=0;
        MULM70OUT_d <=0;
        MUL298OUT_d <=0;
        MUL593OUT_d <=0;

    end
    else begin
        Delay0 <= DataIn;
        Delay1 <= Delay0;
        Delay2 <= Delay1;
        Delay3 <= Delay2;
        Delay4 <= Delay3;
        Delay5 <= Delay4;
        Delay6 <= Delay5;
        Delay7 <= Delay6;
        Delay8 <= Delay7;
        Delay9 <= Delay8;
        Delay10 <= Delay9;

        MUL37OUT_d  <= MUL37OUT;
        MULM50OUT_d <= MULM50OUT;
        MULM70OUT_d <= MULM70OUT;
        MUL298OUT_d <= MUL298OUT;
        MUL593OUT_d <= MUL593OUT;
    end
end

// -----------------------------------------------------------------------
endmodule
