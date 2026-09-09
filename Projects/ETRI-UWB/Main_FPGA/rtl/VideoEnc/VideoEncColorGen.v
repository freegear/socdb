// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncColorGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------
// Purpose            : This module is for generating color bar 
// =================================================================

`timescale 1ns/10ps

module VideoEncColorGen(

    CLK,
    RESETn,

    ACT_DISPLAY_INTER,
    COLOR_PATTERN_MODE,
    EN_SQPIXEL,
    NTSC_PAL,
    EN_INTERNAL_PATTERN,

    Rgen,
    Ggen,
    Bgen
);
parameter ACTIVE_TOTAL_PIXEL_NTSC     = 1440; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_PAL      = 1440; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_NTSC  = 1280; /* Active 640 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_PAL   = 1536; /* Active 768 Lines */

parameter ACTIVE_STEP_NTSC     = 205; /* Active 720 Lines */
parameter ACTIVE_STEP_PAL      = 205; /* Active 720 Lines */
parameter ACTIVE_STEP_SQ_NTSC  = 182; /* Active 640 Lines */
parameter ACTIVE_STEP_SQ_PAL   = 219; /* Active 768 Lines */

input   CLK;
input   RESETn;

input   ACT_DISPLAY_INTER;
input   [2:0] COLOR_PATTERN_MODE;
input   EN_SQPIXEL;
input   EN_INTERNAL_PATTERN;
input   NTSC_PAL;

output   [7:0]   Rgen;
output   [7:0]   Ggen;
output   [7:0]   Bgen;

reg [7:0] R;
reg [7:0] G;
reg [7:0] B;

reg [7:0] RLim;
reg [7:0] GLim;
reg [7:0] BLim;

// =================================================================
// Counting for generation pattern
// -----------------------------------------------------------------

reg     [7:0]  BarCnt;
reg     [7:0]  MaxCnt;

always @( NTSC_PAL or EN_SQPIXEL or COLOR_PATTERN_MODE ) begin

    case({NTSC_PAL, EN_SQPIXEL, COLOR_PATTERN_MODE[1:0]}) 

        4'b0000: begin // NTSC mode normal Color == 2'b00 // 
                    MaxCnt = ACTIVE_STEP_NTSC;
                 end
        4'b0001: begin // NTSC mode normal Color == 2'b01 // 
                    MaxCnt = 8'd6;
                 end
        4'b0010: begin // NTSC mode normal Color == 2'b10 // 
                    MaxCnt = 8'd6;
                 end
        4'b0011: begin // NTSC mode normal Color == 2'b11 // 
                    MaxCnt = 8'd6;
                 end
        4'b0100: begin // NTSC mode square Color == 2'b00 // 
                    MaxCnt = ACTIVE_STEP_SQ_NTSC;
                 end
        4'b0101: begin // NTSC mode square Color == 2'b01 // 
                    MaxCnt = 8'd6;
                 end
        4'b0110: begin // NTSC mode square Color == 2'b10 // 
                    MaxCnt = 8'd6;
                 end
        4'b0111: begin // NTSC mode square Color == 2'b11 // 
                    MaxCnt = 8'd6;
                 end
        4'b1000: begin // PAL mode normal Color == 2'b00 // 
                    MaxCnt = ACTIVE_STEP_PAL;
                 end
        4'b1001: begin // PAL mode normal Color == 2'b01 // 
                    MaxCnt = 8'd6;
                 end
        4'b1010: begin // PAL mode normal Color == 2'b10 // 
                    MaxCnt = 8'd6;
                 end
        4'b1011: begin // PAL mode normal Color == 2'b11 // 
                    MaxCnt = 8'd6;
                 end
        4'b1100: begin // PAL mode square Color == 2'b00 // 
                    MaxCnt = ACTIVE_STEP_SQ_PAL;
                 end
        4'b1101: begin // PAL mode square Color == 2'b01 // 
                    MaxCnt = 8'd6;
                 end
        4'b1110: begin // PAL mode square Color == 2'b10 // 
                    MaxCnt = 8'd6;
                 end
        4'b1111: begin // PAL mode square Color == 2'b11 // 
                    MaxCnt = 8'd6;
                 end
    endcase

end


wire [7:0] NxBarCnt;
assign  NxBarCnt = BarCnt + 8'd1;
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        BarCnt <= 8'd0;
    end
    else begin
        if(ACT_DISPLAY_INTER && (NxBarCnt == MaxCnt)) begin
            BarCnt <= 8'd0;
        end
        else if(ACT_DISPLAY_INTER) begin
            BarCnt <= NxBarCnt;
        end
        else begin
            BarCnt <= 8'd0;
        end
    end
end

reg  [7:0] ColorCnt;
wire [7:0] NxColorCnt = ColorCnt + 8'd1;
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ColorCnt <= 8'd0;
    end 
    else begin
        if(!EN_INTERNAL_PATTERN)
            ColorCnt <= 8'd0;
        else if(!COLOR_PATTERN_MODE[1] & !COLOR_PATTERN_MODE[0])  begin
            //Colorbar mode
            if(ACT_DISPLAY_INTER && (BarCnt == 8'd0))
                ColorCnt <= NxColorCnt;
            else if(ACT_DISPLAY_INTER)
                ColorCnt <= ColorCnt;
            else 
                ColorCnt <= 8'd0;
        end
        else begin
            //Lamp mode
            if(ACT_DISPLAY_INTER && (BarCnt == 8'd0))
                ColorCnt <= NxColorCnt;
            else if(ACT_DISPLAY_INTER)
                ColorCnt <= ColorCnt;
            else 
                ColorCnt <= 8'h00;
        end
    end
end

// =================================================================
// ColorBar generation
// -----------------------------------------------------------------

reg ACT_DISPLAY_INTER_d;
reg ColorBar_R;
reg ColorBar_G;
reg ColorBar_B;

wire ResetColorbar = !ACT_DISPLAY_INTER_d & ACT_DISPLAY_INTER; 
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ACT_DISPLAY_INTER_d <= 1'b0;
    end
    else
        ACT_DISPLAY_INTER_d <= ACT_DISPLAY_INTER; 
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ColorBar_R <= 1'b0;
        ColorBar_G <= 1'b0;
        ColorBar_B <= 1'b0;
    end
    else begin
        if(ACT_DISPLAY_INTER) begin
            if(ResetColorbar) begin
                ColorBar_B <= 1'b1;
            end
            else if(BarCnt == 8'd0) begin
                ColorBar_B <= ~ColorBar_B;
            end

            if(ResetColorbar) begin
                ColorBar_R <= 1'b1;
            end
            else if((!ColorCnt[0]) && (BarCnt == 8'd0)) begin
                ColorBar_R <= ~ColorBar_R;
            end

            if(ResetColorbar) begin
                ColorBar_G <= 1'b1;
            end
            else if((ColorCnt[1] == 1'b0) && 
                    (ColorCnt[0] == 1'b0) && (BarCnt == 8'd0)) begin

                ColorBar_G <= ~ColorBar_G;
            end
        end
        else begin
            ColorBar_R <= 1'b1;
            ColorBar_G <= 1'b1;
            ColorBar_B <= 1'b1;
        end
    end
end

// =================================================================
// output pattern generation
// -----------------------------------------------------------------

always @( R or G or B or COLOR_PATTERN_MODE[2] or NTSC_PAL ) begin

    if(COLOR_PATTERN_MODE[2] && 
      (R == 8'd191) &&
      (G == 8'd191) &&
      (B == 8'd191) && NTSC_PAL) begin 
        RLim = 8'hff;
        GLim = 8'hff;
        BLim = 8'hff;
      end
      else begin
        RLim = R;
        GLim = G;
        BLim = B;
      end
end

always @( COLOR_PATTERN_MODE or
          EN_INTERNAL_PATTERN or
          ColorBar_R  or
          ColorBar_G  or
          ColorBar_B  or
          ColorCnt
        ) begin

    case( {!EN_INTERNAL_PATTERN, COLOR_PATTERN_MODE} ) 
        4'b0000: begin //Colorbar generation 100% colorbar

                    if(ColorBar_R) 
                        R = 8'hff;
                    else
                        R = 8'h00;

                    if(ColorBar_G) 
                        G = 8'hff;
                    else
                        G = 8'h00;

                    if(ColorBar_B) 
                        B = 8'hff;
                    else
                        B = 8'h00;

                end

        4'b0100: begin //Colorbar generation 75% colorbar

                    if(ColorBar_R) 
                        R = 8'd191;
                    else
                        R = 8'd00;

                    if(ColorBar_G) 
                        G = 8'd191;
                    else
                        G = 8'd00;

                    if(ColorBar_B) 
                        B = 8'd191;
                    else
                        B = 8'd00;

                end


        4'b0001: begin //R Lamp generation 
                    R= ColorCnt;
                    G= 8'h00;
                    B= 8'h00;
                end

        4'b0010: begin //G Lamp generation 
                    R= 8'h00;
                    G= ColorCnt;
                    B= 8'h00;
                end

        4'b0011: begin //B Lamp generation 
                    R= 8'h00;
                    G= 8'h00;
                    B= ColorCnt;
                end
        default: begin
                    R= 8'h00;
                    G= 8'h00;
                    B= 8'h00;
                end
    endcase

end

assign Rgen = (ACT_DISPLAY_INTER) ? RLim : 8'd0;
assign Ggen = (ACT_DISPLAY_INTER) ? GLim : 8'd0;
assign Bgen = (ACT_DISPLAY_INTER) ? BLim : 8'd0;

endmodule
