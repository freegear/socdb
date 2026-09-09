
//TestDM testbench

//`define P480
//`define P720
`define I1080

module tb;

parameter PERIOD1=20.83;	// 24MHz
parameter PHASETIME1=(PERIOD1 / 2);
parameter SDLY=2;

reg Clock;
reg RESETn;
reg Enable;

`ifdef P480
wire  [1:0]  HD_MODE = 2'b00;
wire  [11:0] LCD_HSW = 12'd126-1;
wire  [11:0] LCD_HBP = 12'd118-1;
wire  [11:0] LCD_ACTPIXEL = 12'd1440-1;
wire  [11:0] LCD_HFP = 12'd32-1;

wire  [11:0] LCD_VSW = 12'd3-1;
wire  [11:0] LCD_VBP = 12'd41-1;
wire  [11:0] LCD_ACTLINE = 12'd480-1;
wire  [11:0] LCD_VFP = 12'd1-1;
`endif


`ifdef P720
wire  [1:0]  HD_MODE = 2'b01;
wire  [11:0] LCD_HSW = 12'd40;
wire  [11:0] LCD_HBP = 12'd330;
wire  [11:0] LCD_ACTPIXEL = 12'd1280;
wire  [11:0] LCD_HFP = 12'd70;

wire  [11:0] LCD_VSW = 12'd3;
wire  [11:0] LCD_VBP = 12'd23;
wire  [11:0] LCD_ACTLINE = 12'd720;
wire  [11:0] LCD_VFP = 12'd4;
`endif

`ifdef I1080
wire  [1:0]  HD_MODE = 2'b10;
wire  [11:0] LCD_HSW = 12'd44;
wire  [11:0] LCD_HBP = 12'd192;
wire  [11:0] LCD_ACTPIXEL = 12'd1920;
wire  [11:0] LCD_HFP = 12'd44;

wire  [11:0] LCD_VSW = 12'd3;
wire  [11:0] LCD_VBP = 12'd20;
wire  [11:0] LCD_ACTLINE = 12'd940;
wire  [11:0] LCD_VFP = 12'd2;
`endif

always #PHASETIME1 Clock     = ~Clock;

initial
begin
	RESETn = 1'b0;
    Clock  = 1'b0;
    Enable = 1'b0;

	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;
	#(SDLY) Enable = 1'b1;
end


TestDM TestDM(

        .CLK(Clock),
        .RESETn(RESETn),

        .Enable(Enable),
        .HD_MODE(HD_MODE),

        .LCD_HSW(LCD_HSW),
        .LCD_HBP(LCD_HBP),
        .LCD_ACTPIXEL(LCD_ACTPIXEL),
        .LCD_HFP(LCD_HFP),

        .LCD_VSW(LCD_VSW),
        .LCD_VBP(LCD_VBP),
        .LCD_ACTLINE(LCD_ACTLINE),
        .LCD_VFP(LCD_VFP),

        .RqDATA(),
        .DATAin(24'd0),

        .HSYNCn(),
        .VSYNCn(),
        .BLANKn(),
        .Rout(),
        .Gout(),
        .Bout()
        );

initial begin
  $shm_open("./TestDM.shm");
  $shm_probe("AS");
end

endmodule
