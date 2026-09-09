// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : CFILTERCore.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is Chrominance filter mul.
// ===================================================================

module CFILTERCore(

                CLK,
                RESETn,

                FilterSel, //0 --> 13.5  1--> 0.67
                DataIn,
                DataOut
       );

    input   CLK;
    input   RESETn;
    input   FilterSel;
    input   [9:0]   DataIn;
    output  [9:0]   DataOut;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

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
reg [9:0] Delay11;
reg [9:0] Delay12;
reg [9:0] Delay13;
reg [9:0] Delay14;
reg [9:0] Delay15;
reg [9:0] Delay16;
reg [9:0] Delay17;
reg [9:0] Delay18;
reg [9:0] Delay19;
reg [9:0] Delay20;

wire  [10:0]  MUL33IN;
wire  [10:0]  MUL123IN;
wire  [10:0]  MUL131IN;
wire  [10:0]  MUL148IN;
wire  [10:0]  MUL70IN;
wire  [10:0]  MUL81IN;

wire  [19:0]  AdderOut0;
wire  [19:0]  AdderOut1;
wire  [19:0]  AdderOut2;
wire  [19:0]  AdderOut3;
wire  [19:0]  AdderOut4;

reg   [10:0]  MUL33A;
reg   [10:0]  MUL123A;
reg   [10:0]  MUL131A;
reg   [10:0]  MUL148A;
reg   [10:0]  MUL70A;
reg   [10:0]  MUL81A;

reg   [10:0]  MUL33B;
reg   [10:0]  MUL123B;
reg   [10:0]  MUL131B;
reg   [10:0]  MUL70B;
reg   [10:0]  MUL81B;

wire  [19:0]  MUL33OUT;
wire  [19:0]  MUL123OUT;
wire  [19:0]  MUL131OUT;
wire  [19:0]  MUL148OUT;
wire  [19:0]  MUL70OUT;
wire  [19:0]  MUL81OUT;

reg  [19:0]  MUL33OUT_d;
reg  [19:0]  MUL123OUT_d;
reg  [19:0]  MUL131OUT_d;
reg  [19:0]  MUL148OUT_d;
reg  [19:0]  MUL70OUT_d;
reg  [19:0]  MUL81OUT_d;


// =======================================================================
// Adder Mux
// -----------------------------------------------------------------------

always @(Delay0 or Delay1 or Delay2 or Delay3 or Delay4  or Delay5  or
        Delay6 or Delay7 or Delay8 or Delay9 or Delay10 or Delay11 or
        Delay12 or Delay13 or Delay14  or Delay15  or
        Delay16 or Delay17 or Delay18 or Delay19 or Delay20 or 
        FilterSel) begin

        if(FilterSel) begin // 1 --> 0.67Mhz
            MUL33A  <= {Delay0[9],  Delay0};
            MUL70A  <= {Delay2[9],  Delay2};
            MUL81A  <= {Delay4[9],  Delay4};
            MUL123A <= {Delay6[9],  Delay6};
            MUL131A <= {Delay8[9],  Delay8};
            MUL148A <= {Delay10[9], Delay10};
            MUL131B <= {Delay12[9], Delay12};
            MUL123B <= {Delay14[9], Delay14};
            MUL81B  <= {Delay16[9], Delay16};
            MUL70B  <= {Delay18[9], Delay18};
            MUL33B  <= {Delay20[9], Delay20};
        end
        else begin          // 0 --> 1.35Mhz
            MUL33A  <= {Delay0[9], Delay0};
            MUL70A  <= {Delay1[9], Delay1};
            MUL81A  <= {Delay2[9], Delay2};
            MUL123A <= {Delay3[9], Delay3};
            MUL131A <= {Delay4[9], Delay4};
            MUL148A <= {Delay5[9], Delay5};
            MUL131B <= {Delay6[9], Delay6};
            MUL123B <= {Delay7[9], Delay7};
            MUL81B  <= {Delay8[9], Delay8};
            MUL70B  <= {Delay9[9], Delay9};
            MUL33B  <= {Delay10[9],Delay10};
        end
end

// =======================================================================
// Adder 
// -----------------------------------------------------------------------
assign  MUL33IN  = MUL33A  + MUL33B;
assign  MUL123IN = MUL123A + MUL123B;
assign  MUL131IN = MUL131A + MUL131B;
assign  MUL148IN = MUL148A;
assign  MUL70IN  = MUL70A + MUL70B;
assign  MUL81IN  = MUL81A + MUL81B;

/*
assign  AdderOut0 = {{2{MUL33OUT_d[19] }}, MUL33OUT_d  + 
                     {2{MUL123OUT_d[19]}}, MUL123OUT_d};
*/

assign  AdderOut0 = MUL33OUT_d  + MUL123OUT_d;
assign  AdderOut1 = MUL131OUT_d + MUL148OUT_d; 
assign  AdderOut2 = MUL70OUT_d  + MUL81OUT_d;
assign  AdderOut3 = AdderOut0   + AdderOut1;
assign  AdderOut4 = AdderOut3   + AdderOut2; 
assign  DataOut   = AdderOut4[19:10];

// =======================================================================
// Multifly
// -----------------------------------------------------------------------

CMUL CMUL(
            .MUL33IN(MUL33IN),
            .MUL123IN(MUL123IN),
            .MUL131IN(MUL131IN),
            .MUL148IN(MUL148IN),
            .MUL70IN(MUL70IN),
            .MUL81IN(MUL81IN),

            .MUL33OUT(MUL33OUT),
            .MUL123OUT(MUL123OUT),
            .MUL131OUT(MUL131OUT),
            .MUL148OUT(MUL148OUT),
            .MUL70OUT(MUL70OUT),
            .MUL81OUT(MUL81OUT)
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
        Delay11 <= 0;
        Delay12 <= 0;
        Delay13 <= 0;
        Delay14 <= 0;
        Delay15 <= 0;
        Delay16 <= 0;
        Delay17 <= 0;
        Delay18 <= 0;
        Delay19 <= 0;
        Delay20 <= 0;

        MUL33OUT_d <= 0;
        MUL123OUT_d <= 0;
        MUL131OUT_d <= 0;
        MUL148OUT_d <= 0;
        MUL70OUT_d <= 0;
        MUL81OUT_d <= 0;

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
        Delay11 <= Delay10;
        Delay12 <= Delay11;
        Delay13 <= Delay12;
        Delay14 <= Delay13;
        Delay15 <= Delay14;
        Delay16 <= Delay15;
        Delay17 <= Delay16;
        Delay18 <= Delay17;
        Delay19 <= Delay18;
        Delay20 <= Delay19;

        MUL33OUT_d  <= MUL33OUT  ;
        MUL123OUT_d <= MUL123OUT ;
        MUL131OUT_d <= MUL131OUT ;
        MUL148OUT_d <= MUL148OUT ;
        MUL70OUT_d  <= MUL70OUT  ;
        MUL81OUT_d  <= MUL81OUT  ;
    end

end

endmodule
