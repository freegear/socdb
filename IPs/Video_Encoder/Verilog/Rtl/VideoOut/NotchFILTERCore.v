// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : NotchFILTERCore.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is Chrominance filter mul.
// ===================================================================

module NotchFILTERCore(

                CLK,
                RESETn,

                YFilterSel, //01 --> NTSC notch  10 --> PAL notch
                CFilterSel, //01 --> NTSC notch  10 --> PAL notch
                DataIn,
                DataOut
       );

    input   CLK;
    input   RESETn;
    input   [1:0]   YFilterSel;
    input   [1:0]   CFilterSel;
    input   [9:0]   DataIn;
    output  [9:0]   DataOut;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

reg [9:0] DataOut;
reg [9:0] Delay0;
reg [9:0] Delay1;
reg [9:0] Delay2;
reg [9:0] Delay3;
reg [9:0] Delay4;

wire  [10:0]  MUL134IN;
wire  [10:0]  MUL142IN;
wire  [10:0]  MUL307IN;
wire  [10:0]  MUL38IN;
wire  [10:0]  MUL39IN;
wire  [10:0]  MUL455IN;

wire  [19:0]  MUL134OUT;
wire  [19:0]  MUL142OUT;
wire  [19:0]  MUL307OUT;
wire  [19:0]  MUL38OUT;
wire  [19:0]  MUL39OUT;
wire  [19:0]  MUL455OUT;

reg  [19:0]  MUL134OUT_d;
reg  [19:0]  MUL142OUT_d;
reg  [19:0]  MUL307OUT_d;
reg  [19:0]  MUL38OUT_d;
reg  [19:0]  MUL39OUT_d;
reg  [19:0]  MUL455OUT_d;

reg  [10:0]  MUL134A;
reg  [10:0]  MUL142A;
reg  [10:0]  MUL307A;
reg  [10:0]  MUL38A;
reg  [10:0]  MUL39A;
reg  [10:0]  MUL455A;

reg  [10:0]  MUL134B;
reg  [10:0]  MUL307B;
reg  [10:0]  MUL38B;
reg  [10:0]  MUL455B;

reg  [21:0]  MULADDER_A;
reg  [21:0]  MULADDER_B;
reg  [21:0]  MULADDER_C;

wire [21:0] AdderOut;

always @(AdderOut or YFilterSel or Delay4 or Delay1 or CFilterSel) begin
        case(YFilterSel)// synopsys parallel_case
            2'b01: DataOut = AdderOut[19:10];
            2'b10: DataOut = AdderOut[19:10];
            default: begin
                        if(CFilterSel[1]) DataOut = Delay4;
                        else              DataOut = Delay1;
                     end
        endcase
end
// =======================================================================
// Adder Mux
// -----------------------------------------------------------------------

always @(Delay0 or Delay1 or Delay2 or Delay3 or Delay4  or 
        YFilterSel or
        MUL134OUT or
        MUL142OUT or
        MUL307OUT or
        MUL38OUT or
        MUL39OUT or
        MUL455OUT 
        ) begin

        case(YFilterSel)// synopsys parallel_case
            2'b01: begin //NTSC notch filter
                    MUL455A = {1'b0, Delay0};
                    MUL38A  = {1'b0, Delay1};
                    MUL39A  = {1'b0, Delay2};
                    MUL38B  = {1'b0, Delay3};
                    MUL455B = {1'b0, Delay4};

                    MUL307A = 0;
                    MUL134A = 0;
                    MUL142A = 0;
                    MUL134B = 0;
                    MUL307B = 0;

                    MULADDER_A = {2'd0, MUL455OUT};
                    MULADDER_B = {2'd0, MUL38OUT};
                    MULADDER_C = {2'd0, MUL39OUT};
                   end
            2'b10: begin //PAL notch filter
                    MUL455A = 0;
                    MUL38A  = 0;
                    MUL39A  = 0;
                    MUL38B  = 0;
                    MUL455B = 0;

                    MUL307A = {1'b0, Delay0};
                    MUL134A = {1'b0, Delay1};
                    MUL142A = {1'b0, Delay2};
                    MUL134B = {1'b0, Delay3};
                    MUL307B = {1'b0, Delay4};

                    MULADDER_A = {2'd0, MUL307OUT};
                    MULADDER_B = {2'd0, MUL134OUT};
                    MULADDER_C = {2'd0, MUL142OUT};
                   end
            default begin
                    MUL455A = 0;
                    MUL38A  = 0;
                    MUL39A  = 0;
                    MUL38B  = 0;
                    MUL455B = 0;

                    MUL307A = 0;
                    MUL134A = 0;
                    MUL142A = 0;
                    MUL134B = 0;
                    MUL307B = 0;

                    MULADDER_A = 0;
                    MULADDER_B = 0;
                    MULADDER_C = 0;
                    end
        endcase

end

// =======================================================================
// Adder 
// -----------------------------------------------------------------------

assign  MUL134IN = MUL134A + MUL134B;
assign  MUL142IN = MUL142A;
assign  MUL307IN = MUL307A + MUL307B;
assign  MUL38IN  = MUL38A + MUL38B;
assign  MUL39IN  = MUL39A; 
assign  MUL455IN = MUL455A + MUL455B;

assign  AdderOut = MULADDER_A + MULADDER_B + MULADDER_C;

// =======================================================================
// Multifly
// -----------------------------------------------------------------------

NotchMUL NotchMUL(

            .MUL134IN(MUL134IN),
            .MUL142IN(MUL142IN),
            .MUL307IN(MUL307IN),
            .MUL38IN(MUL38IN),
            .MUL39IN(MUL39IN),
            .MUL455IN(MUL455IN),

            .MUL134OUT(MUL134OUT),
            .MUL142OUT(MUL142OUT),
            .MUL307OUT(MUL307OUT),
            .MUL38OUT(MUL38OUT),
            .MUL39OUT(MUL39OUT),
            .MUL455OUT(MUL455OUT)

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

        MUL134OUT_d <= 0;
        MUL142OUT_d <= 0;
        MUL307OUT_d <= 0;
        MUL38OUT_d <= 0;
        MUL39OUT_d <= 0;
        MUL455OUT_d <= 0;

    end
    else begin
        Delay0 <= DataIn;
        Delay1 <= Delay0;
        Delay2 <= Delay1;
        Delay3 <= Delay2;
        Delay4 <= Delay3;

        MUL134OUT_d <= MUL134OUT;
        MUL142OUT_d <= MUL142OUT;
        MUL307OUT_d <= MUL307OUT;
        MUL38OUT_d <= MUL38OUT;
        MUL39OUT_d <= MUL39OUT;
        MUL455OUT_d <= MUL455OUT;
    end
end

endmodule
