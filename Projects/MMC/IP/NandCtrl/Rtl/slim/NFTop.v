//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash controller Top
// module name : NFTop.v
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFTop(
    PCLK	    ,
    PRESETn     ,
    EXT_SFR_ADDR,
    EXT_SFR_WR  ,

    EXT_SFR_DOUT,
    EXT_SFR_DIN ,

    CS          ,

    WDATA       ,
    RDATA       ,
    We          ,
    Oe          ,

    NFDMAReqOut ,
    NFINTOut    ,

//    NFBootPinIn,    
	/*
    IOWidthPinIn,  // 
    NandWidthPinIn,//   
    BootCfgPinIn,  // 
    OutDtmnPinIn,  // 
	*/
    NFDataIn    ,
    NFDataOut   ,
    NFDataOutEn ,
    CLE         ,
    ALE         ,
    nNFCE3      ,
    nNFCE2      ,
    nNFCE1      ,
    nNFCE0      ,
    nNFRE       ,
    nNFWE       ,
    RnB3        ,
    RnB2        ,
    RnB1        ,
    RnB0        );

// APB interface   
input           PCLK        ;
input           PRESETn     ;
input [7:0]     EXT_SFR_ADDR;
input           EXT_SFR_WR  ;
input [7:0]     EXT_SFR_DOUT;
output[7:0]     EXT_SFR_DIN ;

input           CS      ;

input [7:0]     WDATA   ;
output[7:0]     RDATA   ;
input           We      ;
input           Oe      ;


output          NFDMAReqOut;
output          NFINTOut;

//input           NFBootPinIn ;
/*
input           IOWidthPinIn ;
input           NandWidthPinIn ;
input [1:0]     BootCfgPinIn ;
input           OutDtmnPinIn ;
*/
// Nand Flash interface
input [15:0]    NFDataIn    ;
output[15:0]    NFDataOut   ;
output          NFDataOutEn ;
output          CLE         ;
output          ALE         ;

output          nNFCE0      ;
output          nNFCE1      ;
output          nNFCE2      ;
output          nNFCE3      ;

output          nNFRE       ;
output          nNFWE       ;
input           RnB0        ;
input           RnB1        ;
input           RnB2        ;
input           RnB3        ;
                
wire            NFStatValid ; 
wire[15:0]      NFStatus    ; 
wire            WrEnd       ; 
wire            RdEnd       ; 

wire            FIFOFlush   ;
wire[15:0]      FIFORdData  ; 
wire            FIFORdDataEn; 
wire[31:0]      FIFOWrData  ; 
wire            FIFOWrDataEn; 
wire            FIFOFull    ; 
wire            FIFOEmpty0  ; 
wire            FIFOEmpty1  ;

wire            NFOpRdEn    ; 
wire[31:0]      NFOp        ; 
wire[ 3:0]      QLevel      ; 

wire[7:0]      ControlOut0  ;
wire[7:0]      ControlOut1  ; 


wire[7:0]      ConfigOut0   ; 
wire[7:0]      ConfigOut1   ;
wire[7:0]      ConfigOut2   ;


wire[15:0]      NFDataIn    ; 
wire[15:0]      NFDataOut   ; 
wire            CLE         ; 
wire            ALE         ; 

wire            nNFCE3      ;
wire            nNFCE2      ;

wire            nNFCE1      ; 
wire            nNFCE0      ; 
wire            nNFRE       ; 
wire            nNFWE       ; 

wire            RnB0        ; 
wire            RnB1        ; 
wire            RnB2        ;
wire            RnB3        ;

wire[31:0]      BootOp      ;

wire[15:0]  Ecc;
wire        TransSize;

NFRnBFilter uNFRnBFilter(
   .Clk             (PCLK          ),    
   .nRst            (PRESETn       ), 
   .RnB3In          (RnB3          ),
   .RnB2In          (RnB2          ),
   .RnB1In          (RnB1          ),
   .RnB0In          (RnB0          ),
   .FiltRnB3Out     (FiltRnB3      ),
   .FiltRnB2Out     (FiltRnB2      ),
   .FiltRnB1Out     (FiltRnB1      ),    
   .FiltRnB0Out     (FiltRnB0      ));    

NFAPBIF uNFAPBIF(
   .CLK		    (PCLK		   ),
   .RESETn 	    (PRESETn 	   ),
   .EXT_SFR_ADDR   	(EXT_SFR_ADDR[3:0]),
   .EXT_SFR_WR  	(EXT_SFR_WR    ),
   .EXT_SFR_DOUT  	(EXT_SFR_DOUT  ),
   .EXT_SFR_DIN  	(EXT_SFR_DIN   ),

   .CS              (CS            ),

   .WDATA           (WDATA         ),              
   .RDATA           (RDATA         ),
   .We              (We            ),  
   .Oe              (Oe            ),
   
   //External Configuration Pin input
  /* .NFBootPinIn     (1'b0),//(NFBootPinIn   ), // FIXED for ST_MMC
   .IOWidthPinIn    (IOWidthPinIn  ), 
   .NandWidthPinIn  (NandWidthPinIn), 
   .BootCfgPinIn    (BootCfgPinIn  ), 
   .OutDtmnPinIn    (OutDtmnPinIn  ), 
*/
   .IntReqOut       (NFINTOut      ),

   
   // Status input
   .NFCtrlBusyIn    (NFCtrlBusy    ),
   .NFStatValidIn   (NFStatValid   ),
   .NFStatusIn      (NFStatus      ),
   .WrEndIn         (WrEnd         ),
   .RdEndIn         (RdEnd         ),  
   .WrFIFOReadyIn   (WrFIFOReady   ),  
   .RdFIFOReadyIn   (RdFIFOReady   ),
   .FiltRnB3In      (FiltRnB3      ),
   .FiltRnB2In      (FiltRnB2      ),
   .FiltRnB1In      (FiltRnB1      ),
   .FiltRnB0In      (FiltRnB0      ),

   // Data FIFO R/W
   .FIFOFlushIn     (FIFOFlush     ), 
   .FIFORdDataOut   (FIFORdData    ), 
   .FIFORdDataEnIn  (FIFORdDataEn  ),
   .FIFOWrDataIn    (FIFOWrData[15:0]),
   .FIFOWrDataEnIn  (FIFOWrDataEn  ),

   .BeforeFullOut   (BeforeFull    ),
   .FIFORdReadyOut  (FIFORdReady   ),
   .FIFOFullOut     (FIFOFull      ),
   .FIFOHalfFullOut (FIFOHalfFull  ),
   .FIFOEmpty1Out   (FIFOEmpty0    ),
   .FIFOEmpty0Out   (FIFOEmpty1    ),
   .WrRdyOut        (WrRdy         ),
   .RdRdyOut        (RdRdy         ),

   //Operation Read
   .NFOpRdEnIn      (NFOpRdEn      ),
   .NFOpOut         (NFOp          ),
   .QLevelOut       (QLevel        ),
      
   //NFCTRL,NFCONF out
    .ControlOut0  (ControlOut0) ,
    .ControlOut1  (ControlOut1) ,
    .ConfigOut0   (ConfigOut0 ) ,
    .ConfigOut1   (ConfigOut1 ) ,
    .ConfigOut2   (ConfigOut2 ) ,

    .TransSize    (TransSize  ));


NFCtrl uNFCtrl(
   .Clk             (PCLK          ),
   .nRst            (PRESETn       ),
 
   .DMAReqOut       (NFDMAReqOut   ), 
                    
   //Status output  
   .NFCtrlBusyOut   (NFCtrlBusy    ),
   .NFStatValidOut  (NFStatValid   ),
   .NFStatusOut     (NFStatus      ),
   .WrEndOut        (WrEnd         ),
   .RdEndOut        (RdEnd         ),
   .WrFIFOReadyOut  (WrFIFOReady   ),
   .RdFIFOReadyOut  (RdFIFOReady   ),
                                   
   // Data FIFO R/W 
   .FIFOFlushOut    (FIFOFlush     ), 
   .FIFORdDataIn    ({16'h0000,FIFORdData}),
   .FIFORdDataEnOut (FIFORdDataEn  ),
   .FIFOWrDataOut   (FIFOWrData),
   .FIFOWrDataEnOut (FIFOWrDataEn  ),

   .BeforeFullIn    (BeforeFull    ),
   .FIFORdReadyIn   (FIFORdReady   ),
   .FIFOFullIn      (FIFOFull      ),
   .FIFOHalfFullIn  (FIFOHalfFull  ),
   .FIFOEmpty1In    (FIFOEmpty1    ),
   .FIFOEmpty0In    (FIFOEmpty0    ),
   .WrRdyIn         (WrRdy         ),
   .RdRdyIn         (RdRdy         ),
                                   
   //Operation Read
   .NFOpRdEnOut     (NFOpRdEn      ),
   .NFOpIn          (NFOp          ),
   .QLevelIn        (QLevel        ),
                                   
   .NFCTRL0In        (ControlOut0)   ,    
   .NFCTRL1In        (ControlOut1)   ,    
   .NFCONF0In        (ConfigOut0 )   ,    
   .NFCONF1In        (ConfigOut1 )   ,    
   .NFCONF2In        (ConfigOut2 )   ,

   // nand flash I/F
   .NFDataIn        (NFDataIn      ),
   .NFDataOut       (NFDataOut     ),
   .NFDataOutEnOut  (NFDataOutEn   ),
   .CLEOut          (CLE           ),
   .ALEOut          (ALE           ),
   .nNFCE3Out       (nNFCE3        ),
   .nNFCE2Out       (nNFCE2        ),
   .nNFCE1Out       (nNFCE1        ),
   .nNFCE0Out       (nNFCE0        ),
   .nNFREOut        (nNFRE         ),
   .nNFWEOut        (nNFWE         ),
   .FiltRnB3In      (FiltRnB3      ),
   .FiltRnB2In      (FiltRnB2      ),
   .FiltRnB1In      (FiltRnB1      ),
   .FiltRnB0In      (FiltRnB0      ),
   .TransSize       (TransSize     ));

endmodule
