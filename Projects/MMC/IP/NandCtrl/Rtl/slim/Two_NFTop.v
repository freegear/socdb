`timescale 1ns/10ps

module Two_NFTop(
    PCLK            ,
    PRESETn         ,

    EXT_SFR_ADDR    ,
    EXT_SFR_WR      ,
    EXT_SFR_DOUT    ,
    EXT_SFR_DIN_0   ,

    CS_0            ,

    WDATA_0         ,
    RDATA_0         ,
    We_0            ,
    Oe_0            ,

    NFDMAReqOut_0   ,
    NFINTOut_0      ,

//    AddrCnt         ,
/*
    NFBootPinIn     ,
    IOWidthPinIn    ,
    NandWidthPinIn  ,
    BootCfgPinIn    ,
    OutDtmnPinIn    ,
*/
    NFDataIn_0      ,
    NFDataOut_0     ,
    NFDataOutEn_0   ,
    CLE_0           ,
    ALE_0           ,

    nNFCE3_0        ,
    nNFCE2_0        ,
    nNFCE1_0        ,
    nNFCE0_0        ,

    nNFRE_0         ,
    nNFWE_0         ,

    RnB3_0          ,
    RnB2_0          ,
    RnB1_0          ,
    RnB0_0          ,

    EXT_SFR_DIN_1   ,
    CS_1            ,

    WDATA_1         ,
    RDATA_1         ,

    We_1            ,
    Oe_1            ,

    NFDMAReqOut_1   ,
    NFINTOut_1      ,

    NFDataIn_1      ,
    NFDataOut_1     ,
    NFDataOutEn_1   ,
    CLE_1           ,
    ALE_1           ,

    nNFCE3_1        ,
    nNFCE2_1        ,
    nNFCE1_1        ,
    nNFCE0_1        ,

    nNFRE_1         ,
    nNFWE_1         ,

    RnB3_1          ,
    RnB2_1          ,
    RnB1_1          ,
    RnB0_1          );

input           PCLK            ;
input           PRESETn         ;

input [3:0]     EXT_SFR_ADDR    ;
input           EXT_SFR_WR      ;
input [7:0]     EXT_SFR_DOUT    ;
output[7:0]     EXT_SFR_DIN_0   ;

input           CS_0            ;

input [7:0]     WDATA_0         ;
output[7:0]     RDATA_0         ;
input           We_0            ;
input           Oe_0            ;

input           NFDMAReqOut_0   ;
input           NFINTOut_0      ;
/*
input           NFBootPinIn     ;
input           IOWidthPinIn    ;
input           NandWidthPinIn  ;
input [1:0]     BootCfgPinIn    ;
input           OutDtmnPinIn    ;
*/
//input [11:0]    AddrCnt         ;

input [7:0]    NFDataIn_0      ;
output[7:0]    NFDataOut_0     ;
output          NFDataOutEn_0   ;
output          CLE_0           ;
output          ALE_0           ;

output          nNFCE0_0        ;
output          nNFCE1_0        ;
output          nNFCE2_0        ;
output          nNFCE3_0        ;

output          nNFRE_0         ;
output          nNFWE_0         ;

input           RnB0_0          ;
input           RnB1_0          ;
input           RnB2_0          ;
input           RnB3_0          ;

output[7:0]     EXT_SFR_DIN_1   ;
input           CS_1            ;

input [7:0]     WDATA_1         ;
output[7:0]     RDATA_1         ;

input           We_1            ;
input           Oe_1            ;
      
input           NFDMAReqOut_1   ;
input           NFINTOut_1      ;

input [7:0]     NFDataIn_1      ;
output[7:0]     NFDataOut_1     ;
output          NFDataOutEn_1   ;
output          CLE_1           ;
output          ALE_1           ;
                  
output          nNFCE3_1        ;
output          nNFCE2_1        ;
output          nNFCE1_1        ;
output          nNFCE0_1        ;
                               
output          nNFRE_1         ;
output          nNFWE_1         ;
                  
input           RnB3_1          ;
input           RnB2_1          ;
input           RnB1_1          ;
input           RnB0_1          ;


wire            We_0            ;
wire            Oe_0            ;

wire[7:0]       EXT_SFR_DIN_0   ;
wire            CS_0            ;

//wire[11:0]      AddrCnt         ;

//wire[7:0]      NFDataIn_0      ;

wire[15:0]      NFDataIn_0_Sel  ;
wire[15:0]      NFDataOut_0_Sel ;
wire            NFDataOutEn_0  ;

wire            CLE_0           ;
wire            ALE_0           ;

wire            nNFCE3_0        ;
wire            nNFCE2_0        ;
wire            nNFCE1_0        ;
wire            nNFCE0_0        ;

wire            nNFRE_0         ;
wire            nNFWE_0         ;

wire            RnB3_0          ;
wire            RnB2_0          ;
wire            RnB1_0          ;
wire            RnB0_0          ;

wire[7:0]       EXT_SFR_DIN_1   ;
wire            CS_1            ;

wire            We_1            ;
wire            Oe_1            ;

//wire[15:0]      NFDataIn_1  ;
wire[15:0]      NFDataOut_1_Sel ;
wire            NFDataOutEn_Sel ;

wire            CLE_1           ;
wire            ALE_1           ;

wire            nNFCE3_1        ;
wire            nNFCE2_1        ;
wire            nNFCE1_1        ;
wire            nNFCE0_1        ;

wire            nNFRE_1         ;
wire            nNFWE_1         ;

wire            RnB3_1          ;
wire            RnB2_1          ;
wire            RnB1_1          ;
wire            RnB0_1          ;


`ifdef x8
    parameter   IOWidthPinIn = 1'b0;
`else
    parameter   IOWidthPinIn = 1'b1;
`endif

/*
assign NFDataOut_1      = (IOWidthPinIn) ? {NFDataOut_0[15:8],NFDataOut_0[15:8]} : NFDataOut_1_Sel ; 
assign NFDataIn_0_Sel   = (IOWidthPinIn) ? {NFDataIn_1[7:0],NFDataIn_0[7:0]} : NFDataIn_0 ;
assign NFDataOutEn_1    = (IOWidthPinIn) ? NFDataOutEn_0 : NFDataOutEn_Sel ; 
*/



assign NFDataOut_0      = NFDataOut_0_Sel[7:0] ;
assign NFDataOut_1      = (IOWidthPinIn) ? NFDataOut_0_Sel[15:8] : NFDataOut_1_Sel ; 
assign NFDataIn_0_Sel   = (IOWidthPinIn) ? {NFDataIn_1,NFDataIn_0} : NFDataIn_0 ;
assign NFDataOutEn_1    = (IOWidthPinIn) ? NFDataOutEn_0 : NFDataOutEn_Sel ; 


NFTop   NFTop_0(
           .PCLK	          (PCLK	        ),    
           .PRESETn           (PRESETn      ),
           .EXT_SFR_ADDR      (EXT_SFR_ADDR ),
           .EXT_SFR_WR        (EXT_SFR_WR   ),

           .EXT_SFR_DOUT      (EXT_SFR_DOUT ),
           .EXT_SFR_DIN       (EXT_SFR_DIN_0),

           .CS                (CS_0         ),

           .WDATA             (WDATA_0      ),
           .RDATA             (RDATA_0      ),
           .We                (We_0         ),
           .Oe                (Oe_0         ),

           .NFDMAReqOut       (NFDMAReqOut_0),
           .NFINTOut          (NFINTOut_0   ),

//           .AddrCnt           (AddrCnt      ),
/*
           .NFBootPinIn       (NFBootPinIn  ),
           .IOWidthPinIn      (IOWidthPinIn ),
           .NandWidthPinIn    (NandWidthPinIn),
           .BootCfgPinIn      (BootCfgPinIn ),
           .OutDtmnPinIn      (OutDtmnPinIn ),
*/
           .NFDataIn          (NFDataIn_0_Sel),
           .NFDataOut         (NFDataOut_0_Sel),
           .NFDataOutEn       (NFDataOutEn_0),
           .CLE               (CLE_0        ),
           .ALE               (ALE_0        ),
           .nNFCE3            (nNFCE3_0     ),
           .nNFCE2            (nNFCE2_0     ),
           .nNFCE1            (nNFCE1_0     ),
           .nNFCE0            (nNFCE0_0     ),
           .nNFRE             (nNFRE_0      ),
           .nNFWE             (nNFWE_0      ),
           .RnB3              (RnB3_0       ),
           .RnB2              (RnB2_0       ),
           .RnB1              (RnB1_0       ),
           .RnB0              (RnB0_0       ));


NFTop   NFTop_1(
           .PCLK	          (PCLK	        ),    
           .PRESETn           (PRESETn      ),
           .EXT_SFR_ADDR      (EXT_SFR_ADDR ),
           .EXT_SFR_WR        (EXT_SFR_WR   ),

           .EXT_SFR_DOUT      (EXT_SFR_DOUT ),
           .EXT_SFR_DIN       (EXT_SFR_DIN_1),

           .CS                (CS_1         ),

           .WDATA             (WDATA_1      ),
           .RDATA             (RDATA_1      ),
           .We                (We_1         ),
           .Oe                (Oe_1         ),

           .NFDMAReqOut       (NFDMAReqOut_1),
           .NFINTOut          (NFINTOut_1   ),

//           .AddrCnt           (AddrCnt      ),
/*
           .NFBootPinIn       (NFBootPinIn  ),
           .IOWidthPinIn      (IOWidthPinIn ),
           .NandWidthPinIn    (NandWidthPinIn),
           .BootCfgPinIn      (BootCfgPinIn ),
           .OutDtmnPinIn      (OutDtmnPinIn ),
*/
           .NFDataIn          (NFDataIn_1),
           .NFDataOut         (NFDataOut_1_Sel),
           .NFDataOutEn       (NFDataOutEn_Sel),
           .CLE               (CLE_1        ),
           .ALE               (ALE_1        ),
           .nNFCE3            (nNFCE3_1     ),
           .nNFCE2            (nNFCE2_1     ),
           .nNFCE1            (nNFCE1_1     ),
           .nNFCE0            (nNFCE0_1     ),
           .nNFRE             (nNFRE_1      ),
           .nNFWE             (nNFWE_1      ),
           .RnB3              (RnB3_1       ),
           .RnB2              (RnB2_1       ),
           .RnB1              (RnB1_1       ),
           .RnB0              (RnB0_1       ));

       endmodule
