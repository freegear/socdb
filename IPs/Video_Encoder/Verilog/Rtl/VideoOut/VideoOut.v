// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -----------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoOut.v
// File Revision       : 0.1
// -----------------------------------------------------------------
// Purpose            : This module is Video output module
// =================================================================

// Added Output control regster Feb.15.2007
// Added BT601-2 mode 

`timescale 1ns/10ps

module VideoOut
(
    //Input
    CLK,
    RESETn,
    LCDHSync,
    LCDVSync,
    LCDDataEn,
    Rin,
    Gin,
    Bin,

    MODE,
    LCDBPP,

    OUT_ENABLE,
    OUT_16BIT,
    INV_CbCr,
    INV_FIELD,
    INV_BLANK,
    INV_HSYNC,

    BT656Field,
    BT656VSync,
    BT601Blank,
    DmInitial,

    //Output
    VideoOutHSYNCn,
    VideoOutFIELD,
    VideoOutBLANKn,

    VideoOutY,
    VideoOutCbCr

);

parameter R_YPARA = 9'd153;
parameter G_YPARA = 9'd301;
parameter B_YPARA = 9'd58;

parameter R_CbPARA = 9'd88;
parameter G_CbPARA = 9'd174;
parameter B_CbPARA = 9'd261;

parameter R_CrPARA = 9'd261;
parameter G_CrPARA = 9'd219;
parameter B_CrPARA = 9'd42;

    input   CLK; //27Mhz Clock
    input   RESETn;
    input   LCDHSync;
    input   LCDVSync;
    input   LCDDataEn;

    input   [7:0]   Rin;
    input   [7:0]   Gin;
    input   [7:0]   Bin;
    input   MODE;

    input   [2:0]   LCDBPP;

    input   OUT_ENABLE;
    input   OUT_16BIT;
    input   INV_CbCr;
    input   INV_FIELD;
    input   INV_BLANK;
    input   INV_HSYNC;

    input   BT656Field;
    input   BT656VSync;
    input   BT601Blank;
    input   DmInitial;
    
    output  VideoOutHSYNCn;
    output  VideoOutFIELD;
    output  VideoOutBLANKn;

    output  [7:0]   VideoOutY;
    output  [7:0]   VideoOutCbCr;

    reg     [7:0]   VideoOutY;
    reg     [7:0]   VideoOutCbCr;

    wire  BT601   = (LCDBPP == 3'd5) ? 1'b1 : 1'b0;
    wire  BT656   = (LCDBPP == 3'd4) ? 1'b1 : 1'b0;
    wire  BT601_2 = (LCDBPP == 3'd6) ? 1'b1 : 1'b0; //Video Output mode add

    wire  NTSC_PAL =  (MODE) ? 1'b1 : 1'b0; // 1--> PAL
                                            // 0--> NTSC

// ===================================================================
// H Sync Generation    
// ___________________________________________________________________
// Internal counter

    reg DmInitial_d;

    wire    HSyncReset = DmInitial & !DmInitial_d;
    always @(posedge CLK or negedge RESETn) begin

        if(!RESETn) begin
            DmInitial_d <= 1'b0;
        end
        else begin
            DmInitial_d  <= DmInitial;
        end

    end

    reg     [10:0]  HCNT;
    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn) begin
            HCNT <= 10'd0;
        end
        else begin
            if(!OUT_ENABLE) begin
                HCNT <= 10'd0;
            end
            else if(HSyncReset) begin
                HCNT <= 10'd0;
            end
            else begin
                HCNT <= HCNT + 1;
            end
        end
    end

    reg EAV;
    reg SAV;
    reg SyncBurst;
    always @(HCNT or NTSC_PAL) begin

        if(HCNT >= 10'd1 && HCNT <5) begin
            EAV = 1'b1;
        end
        else begin
            EAV = 1'b0;
        end

        if(HCNT >= 10'd273 && HCNT <277 && !NTSC_PAL) begin
            SAV = 1'b1;
        end
        else if(HCNT >= 10'd285 && HCNT <289 && NTSC_PAL) begin
            SAV = 1'b1;
        end
        else begin
            SAV = 1'b0;
        end

        if(HCNT >= 10'd1 && HCNT <277 && !NTSC_PAL) begin
            SyncBurst = 1'b1;
        end
        else if(HCNT >= 10'd1 && HCNT <289 && NTSC_PAL) begin
            SyncBurst = 1'b1;
        end
        else begin
            SyncBurst = 1'b0;
        end
    end


// ===================================================================
// H Sync Generation    
// ___________________________________________________________________
// InterHSync 


    reg InterHSync;

    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn) InterHSync <= 1'b0;
        else if(OUT_ENABLE)begin
            if(BT656)       InterHSync <= !LCDHSync;
            else if(BT601)  InterHSync <= LCDHSync;
            else if(BT601_2)InterHSync <= !LCDHSync;
        end
        else begin
            InterHSync <= 1'b0;
        end
    end



// ===================================================================
// Field Generation    
// ___________________________________________________________________
// InterField == 1'b1 --> Even field
// InterField == 1'b0 --> Odd field

    reg     BT656Field_d;
    reg     InterField;
    reg     LCDV0d;
    reg     LCDV1d;
    wire #1 FieldChange = !BT656Field_d & BT656Field;

    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn) begin
            BT656Field_d <= 1'b0;
            LCDV0d <= 1'b0;
            LCDV1d <= 1'b0;
        end
        else if(OUT_ENABLE)begin
            BT656Field_d <= BT656Field ;
            LCDV0d <= FieldChange;
            LCDV1d <= LCDV0d;
        end
        else begin
            BT656Field_d <= 1'b0;
            LCDV0d <= 1'b0;
            LCDV1d <= 1'b0;
        end
    end

    always @(posedge CLK or negedge RESETn) begin

        if(!RESETn) begin
            InterField <= 1'b0;
        end
        else if(BT656) begin
            if( LCDV1d  & LCDVSync) begin
                InterField <= 1'b1; //Even field
            end
            else if((LCDV1d) & !LCDVSync) begin
                InterField <= 1'b0; //Odd field
            end
            else begin
                InterField <= InterField;
            end
        end
        else if(BT601) begin
            InterField <= LCDVSync;
        end
        else if(BT601_2) begin
            if( LCDV1d  & LCDVSync) begin
                InterField <= 1'b0; //Odd field
            end
            else if((LCDV1d) & !LCDVSync) begin
                InterField <= 1'b1; //Even field
            end
            else begin
                InterField <= InterField;
            end
        end

    end

// =======================================================================
// V Generation    
// _______________________________________________________________________
// InterV == 1'b1  --> unvalid area
// InterV == 1'b0  --> valid area
    
    reg InterV;
    reg V0d;
    reg V1d;

    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn) begin
            InterV <= 1'b0;
            V0d    <= 1'b0;
            V1d    <= 1'b0;
        end
        else if(OUT_ENABLE)begin
            V0d     <= ~BT656VSync;
            V1d     <= V0d;
            InterV  <= V1d;
        end
        else begin
            InterV <= 1'b0;
            V0d    <= 1'b0;
            V1d    <= 1'b0;
        end
    end

// ==================================================================
// Blank Generation    
// __________________________________________________________________
// InterBlank == 1'b1  --> valid YCbCr
// InterBlank == 1'b0  --> unvalid area

    reg InterBlank;
    reg B0d;
    reg B1d;

    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn)  begin
            B0d <= 1'b0;
            B1d <= 1'b0;
            InterBlank <= 1'b0;
        end
        else if(OUT_ENABLE)begin
            B0d <= BT601Blank;
            B1d <= B0d;
            InterBlank <= B1d;
        end
        else begin 
            B0d <= 1'b0;
            B1d <= 1'b0;
            InterBlank <= 1'b0;
        end
    end


// ==================================================================
// YCbCr Conversion  
// __________________________________________________________________
/*
        Y 601 = 0.299R+ 0.587G + 0.114B
        Cb    = -0.172R- 0.339G + 0.511B +128
        Cr    = 0.511R- 0.428G- 0.083B+128
*/

    reg [3:0] P;

    //BT656 P generation
    always @(VideoOutHSYNCn or VideoOutBLANKn  or VideoOutFIELD) begin
        case({VideoOutFIELD, VideoOutBLANKn, VideoOutHSYNCn}) // synopsys parallel_case
            3'd0: P = 4'b0000;
            3'd1: P = 4'b1101;
            3'd2: P = 4'b1011;
            3'd3: P = 4'b0110;
            3'd4: P = 4'b0111;
            3'd5: P = 4'b1010;
            3'd6: P = 4'b1100;
            3'd7: P = 4'b0001;
        endcase
    end

    reg  [8:0]  MUL_RA;
    reg  [8:0]  MUL_GA;
    reg  [8:0]  MUL_BA;
    reg  [18:0] Cin;
    reg  [7:0]  Y;

    reg  rCbCrFlag; 
    wire [7:0]  C;

    wire [7:0]  NorC;
    wire [7:0]  NorY;
    wire [18:0] Yin;

    assign  NorC = NormalC(Cin);
    assign  C    = NorC;

    wire    BT656ToT = BT656 | OUT_16BIT;
    wire    CbCrFlag = (BT656ToT) ? rCbCrFlag  :
                      ((INV_CbCr) ? ~rCbCrFlag : rCbCrFlag );

    always @(posedge CLK or negedge RESETn) begin

        if(!RESETn) begin
            rCbCrFlag <= 1'b0;
        end
        else begin
            if(!LCDHSync) begin
                rCbCrFlag <= 1'b0;
            end
            else if(BT656ToT & ((HCNT == 10'd276 && !NTSC_PAL) 
                             ||  (HCNT == 10'd288 &&  NTSC_PAL))
                             &  !INV_CbCr
                   ) begin
                //rCbCrFlag == 0 --> Cb convsion
                //rCbCrFlag == 1 --> Cr convsion
                rCbCrFlag <= 1'b0;
            end
            else if(BT656ToT & ((HCNT == 10'd276 && !NTSC_PAL) 
                            ||  (HCNT == 10'd288 &&  NTSC_PAL))
                             &  INV_CbCr
                   ) begin
                rCbCrFlag <= 1'b1;
            end
            else if(BT656ToT & !LCDDataEn) begin
                rCbCrFlag <= ~rCbCrFlag;
            end
            else if((BT601 | BT601_2) & OUT_16BIT & !BT656ToT) begin
                //rCbCrFlag == 0 --> Cb convsion
                //rCbCrFlag == 1 --> Cr convsion
                rCbCrFlag <= LCDDataEn;
            end
            else if((BT601 | BT601_2) & 
                     !OUT_16BIT & !BT656ToT &
                     LCDDataEn) begin
                rCbCrFlag <= ~rCbCrFlag ;
            end
        end
    end

    wire   [7:0]   wRin = (Rin > 235) ? (235) : ((Rin < 10) ? (10) : Rin);
    wire   [7:0]   wGin = (Gin > 235) ? (235) : ((Gin < 10) ? (10) : Gin);
    wire   [7:0]   wBin = (Bin > 235) ? (235) : ((Bin < 10) ? (10) : Bin);

    wire  [16:0] RC  = MUL_RA * Rin; 
    wire  [16:0] GC  = MUL_GA * Gin; 
    wire  [16:0] BC  = MUL_BA * Bin; 

    wire  [16:0] RY  = R_YPARA * Rin; 
    wire  [16:0] GY  = G_YPARA * Gin; 
    wire  [16:0] BY  = B_YPARA * Bin; 

    assign Yin  = RY + GY + BY;    
    assign NorY = NormalY(Yin);

    always @(BT656 or 
             VideoOutHSYNCn or 
             VideoOutBLANKn or 
             VideoOutFIELD  or
             EAV or SAV or HCNT or
             P or NorY or SyncBurst or V1d
            ) begin

            case({BT656, V1d, SyncBurst, SAV, EAV, HCNT[1:0]})

                7'b1010101: Y = 8'hff;  //1
                7'b1010110: Y = 8'h00;  //2
                7'b1010111: Y = 8'h00;  //3 
                7'b1010100: Y = {1'b1, VideoOutFIELD, 
                                 VideoOutBLANKn, VideoOutHSYNCn, 
                                 P}; //0

                7'b1011001: Y = 8'hff; //1
                7'b1011010: Y = 8'h00; //2
                7'b1011011: Y = 8'h00; //3
                7'b1011000: Y = {1'b1, VideoOutFIELD, 
                                 VideoOutBLANKn, VideoOutHSYNCn, 
                                 P}; //0

                7'b1110001: Y = 8'h80;  //1
                7'b1110010: Y = 8'h10;  //2
                7'b1110011: Y = 8'h80;  //3
                7'b1110000: Y = 8'h10;  //0

                7'b1010001: Y = 8'h80;  //1
                7'b1010010: Y = 8'h10;  //2
                7'b1010011: Y = 8'h80;  //3
                7'b1010000: Y = 8'h10;  //0

                7'b1100001: Y = 8'h80;  //1
                7'b1100010: Y = 8'h10;  //2
                7'b1100011: Y = 8'h80;  //3
                7'b1100000: Y = 8'h10;  //0

                7'b1110101: Y = 8'hff;  //1
                7'b1110110: Y = 8'h00;  //2
                7'b1110111: Y = 8'h00;  //3 
                7'b1110100: Y = {1'b1, VideoOutFIELD, 
                                 VideoOutBLANKn, VideoOutHSYNCn, 
                                 P}; //0

                7'b1111001: Y = 8'hff; //1
                7'b1111010: Y = 8'h00; //2
                7'b1111011: Y = 8'h00; //3
                7'b1111000: Y = {1'b1, VideoOutFIELD, 
                                 VideoOutBLANKn, VideoOutHSYNCn, 
                                 P};//0

                default: Y = NorY;
            endcase
    end
    
    always @(CbCrFlag or
             RC or
             GC or
             BC 
            ) begin

        //CbCrFlag == 0 --> Cb convsion
        //CbCrFlag == 1 --> Cr convsion
        if(!CbCrFlag) begin
            MUL_RA = R_CbPARA;
            MUL_GA = G_CbPARA;
            MUL_BA = B_CbPARA;
            Cin    = -RC - GC + BC + 18'h10000;
        end
        else begin
            MUL_RA = R_CrPARA;
            MUL_GA = G_CrPARA;
            MUL_BA = B_CrPARA;
            Cin    =  RC - GC - BC + 18'h10000;
        end
    end



    wire    BT601ToT = BT601 | BT601_2;
    always @(posedge CLK or negedge RESETn) begin
        if(!RESETn) begin
            VideoOutY    <= 8'd0;
            VideoOutCbCr <= 8'd0;
        end
        else begin

            case({BT656ToT, BT601ToT, LCDDataEn}) //synopsys parallel_case 
                3'b101: begin
                        VideoOutY    <= C;
                        VideoOutCbCr <= 8'd0;
                       end
                3'b100: begin
                        VideoOutY    <= Y;
                        VideoOutCbCr <= 8'd0;
                       end

                3'b111: begin
                        VideoOutY    <= C;
                        VideoOutCbCr <= 8'd0;
                       end
                3'b110: begin
                        VideoOutY    <= Y;
                        VideoOutCbCr <= 8'd0;
                       end
                3'b011: 
                       begin
                        if(B1d) begin
                            VideoOutY    <= Y;
                            VideoOutCbCr <= C;
                        end
                        else begin
                            VideoOutY    <= 8'd0;
                            VideoOutCbCr <= 8'd0;
                        end
                       end
                3'b010: 
                       begin
                        if(B1d) begin
                            VideoOutY    <= Y;
                            VideoOutCbCr <= C;
                        end
                        else begin
                            VideoOutY    <= 8'd0;
                            VideoOutCbCr <= 8'd0;
                        end
                       end
                default: 
                       begin
                        VideoOutY    <= 8'd0;
                        VideoOutCbCr <= 8'd0;
                       end
            endcase 
        end
    end

    
// ==================================================================
// Y normalize function
// __________________________________________________________________
    function [7:0] NormalY;
        input   [18:0] In;
        begin
            if(In[18:9] >= 235) begin
                NormalY = 8'd235;
            end
            else if(In[18:9] <= 16) begin
                NormalY = 8'd16;
            end
            else
                NormalY = In[16:9];
        end
    endfunction

// ==================================================================
// C normalize function
// __________________________________________________________________
    function [7:0] NormalC;
        input   [18:0] In;
        begin
            if(In[18]) begin  
                NormalC = 8'd16;
            end
            else if(In[17:9] >= 240) begin
                NormalC = 8'd240;
            end
            else if(In[17:9] <= 16) begin
                NormalC = 8'd16;
            end
            else
                NormalC = In[16:9];
        end
    endfunction

// ==================================================================
// Output Signal
// __________________________________________________________________

wire    TempBLANKn     = (BT656) ? InterV : ((BT601 | BT601_2) ? InterBlank : 1'b0);
assign  VideoOutHSYNCn = (INV_HSYNC) ? ~InterHSync : InterHSync;
assign  VideoOutBLANKn = (INV_BLANK) ? ~TempBLANKn : TempBLANKn;
assign  VideoOutFIELD  = (INV_FIELD) ? ~InterField : InterField;

endmodule
