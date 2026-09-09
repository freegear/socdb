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
    PADDR       ,
    PSEL        ,
    PENABLE     ,
    PWRITE      ,
    PWDATA      ,
    PRDATA      ,

    NFDMAReqOut ,
    NFINTOut    ,

    NFBootPinIn,    
    IOWidthPinIn,   
    NandWidthPinIn,   
    BootCfgPinIn,   
    OutDtmnPinIn,   
// synopsys translate_off
    AddrCnt     ,
// synopsys translate_on
    NFDataIn    ,
    NFDataOut   ,
    NFDataOutEn ,
    CLE         ,
    ALE         ,
    nNFCE1      ,
    nNFCE0      ,
    nNFRE       ,
    nNFWE       ,
    RnB1        ,
    RnB0        );

// APB interface   
input           PCLK    ;
input           PRESETn ;
input [ 6:2]    PADDR   ;
input           PSEL    ;
input           PENABLE ;
input           PWRITE  ;
input [31:0]    PWDATA  ;
output[31:0]    PRDATA  ;

output          NFDMAReqOut;
output          NFINTOut;

input           NFBootPinIn ;
input           IOWidthPinIn ;
input           NandWidthPinIn ;
input [1:0]     BootCfgPinIn ;
input           OutDtmnPinIn ;

// synopsys translate_off
output[11:0]    AddrCnt     ;
// synopsys translate_on

// Nand Flash interface
input [15:0]    NFDataIn    ;
output[15:0]    NFDataOut   ;
output          NFDataOutEn ;
output          CLE         ;
output          ALE         ;
output          nNFCE0      ;
output          nNFCE1      ;
output          nNFRE       ;
output          nNFWE       ;
input           RnB0        ;
input           RnB1        ;
                
wire            NFStatValid ; 
wire[15:0]      NFStatus    ; 
wire            WrEnd       ; 
wire            RdEnd       ; 

wire            FIFOFlush   ;
wire[31:0]      FIFORdData  ; 
wire            FIFORdDataEn; 
wire[31:0]      FIFOWrData  ; 
wire            FIFOWrDataEn; 
wire            FIFOFull    ; 
wire            FIFOEmpty0  ; 
wire            FIFOEmpty1  ;

wire            NFOpRdEn    ; 
wire[31:0]      NFOp        ; 
wire[ 3:0]      QLevel      ; 

wire[13:0]      Control     ;  
wire[18:0]      Config      ;  

wire[15:0]      NFDataIn    ; 
wire[15:0]      NFDataOut   ; 
wire            CLE         ; 
wire            ALE         ; 
wire            nNFCE1      ; 
wire            nNFCE0      ; 
wire            nNFRE       ; 
wire            nNFWE       ; 
wire            RnB0        ; 
wire            RnB1        ; 

wire[31:0]      BootOp      ;

// ECC
wire[11:0]  ColumnAddr      ;
wire[15:0]  EccData         ;   


wire[23:0]  ECCSECTOR0;  //offset 0x14
wire[23:0]  ECCSECTOR1;  //offset 0x18
wire[23:0]  ECCSECTOR2;  //offset 0x1c
wire[23:0]  ECCSECTOR3;  //offset 0x20
wire[23:0]  ECCSECTOR4;  //offset 0x24
wire[23:0]  ECCSECTOR5;  //offset 0x28
wire[23:0]  ECCSECTOR6;  //offset 0x2c
wire[23:0]  ECCSECTOR7;  //offset 0x30
wire[23:0]  ECCSECTOR8;  //offset 0x34
wire[23:0]  ECCSECTOR9;  //offset 0x38
wire[23:0]  ECCSECTOR10; //offset 0x3c
wire[23:0]  ECCSECTOR11; //offset 0x40
wire[23:0]  ECCSECTOR12; //offset 0x44
wire[23:0]  ECCSECTOR13; //offset 0x48
wire[23:0]  ECCSECTOR14; //offset 0x4c
wire[23:0]  ECCSECTOR15; //offset 0x50

wire[15:0]  SECCSECTOR0; //offset 0x54
wire[15:0]  SECCSECTOR1; //offset 0x58
wire[15:0]  SECCSECTOR2; //offset 0x5c
wire[15:0]  SECCSECTOR3; //offset 0x60
wire[15:0]  SECCSECTOR4; //offset 0x64
wire[15:0]  SECCSECTOR5; //offset 0x68
wire[15:0]  SECCSECTOR6; //offset 0x6c
wire[15:0]  SECCSECTOR7; //offset 0x70


wire[11:0]  AddrCnt;
wire[15:0]  Ecc;

NFRnBFilter uNFRnBFilter(
   .Clk             (PCLK          ),    
   .nRst            (PRESETn       ),    
   .RnB1In          (RnB1          ),
   .RnB0In          (RnB0          ),    
   .FiltRnB1Out     (FiltRnB1      ),    
   .FiltRnB0Out     (FiltRnB0      ));    

NFAPBIF uNFAPBIF(
   .PCLK		    (PCLK		   ),
   .PRESETn 	    (PRESETn 	   ),
   .PADDR   	    (PADDR   	   ),
   .PSEL    	    (PSEL    	   ),
   .PENABLE 	    (PENABLE 	   ),
   .PWRITE  	    (PWRITE  	   ),
   .PWDATA  	    (PWDATA  	   ),
   .PRDATA  	    (PRDATA  	   ),
   
   //External Configuration Pin input
   .NFBootPinIn     (NFBootPinIn   ), 
   .IOWidthPinIn    (IOWidthPinIn  ), 
   .NandWidthPinIn  (NandWidthPinIn), 
   .BootCfgPinIn    (BootCfgPinIn  ), 
   .OutDtmnPinIn    (OutDtmnPinIn  ), 

   .IntReqOut       (NFINTOut      ),

   // ECC
   .ECCSECTOR0      (ECCSECTOR0    ),
   .ECCSECTOR1      (ECCSECTOR1    ),
   .ECCSECTOR2      (ECCSECTOR2    ),
   .ECCSECTOR3      (ECCSECTOR3    ),
   .ECCSECTOR4      (ECCSECTOR4    ),
   .ECCSECTOR5      (ECCSECTOR5    ),
   .ECCSECTOR6      (ECCSECTOR6    ),
   .ECCSECTOR7      (ECCSECTOR7    ),
   .ECCSECTOR8      (ECCSECTOR8    ),
   .ECCSECTOR9      (ECCSECTOR9    ),
   .ECCSECTOR10     (ECCSECTOR10   ),
   .ECCSECTOR11     (ECCSECTOR11   ),
   .ECCSECTOR12     (ECCSECTOR12   ),
   .ECCSECTOR13     (ECCSECTOR13   ),
   .ECCSECTOR14     (ECCSECTOR14   ),
   .ECCSECTOR15     (ECCSECTOR15   ),
               
   .SECCSECTOR0     (SECCSECTOR0   ),
   .SECCSECTOR1     (SECCSECTOR1   ),
   .SECCSECTOR2     (SECCSECTOR2   ),
   .SECCSECTOR3     (SECCSECTOR3   ),
   .SECCSECTOR4     (SECCSECTOR4   ),
   .SECCSECTOR5     (SECCSECTOR5   ),
   .SECCSECTOR6     (SECCSECTOR6   ),
   .SECCSECTOR7     (SECCSECTOR7   ),

   // Status input
   .NFCtrlBusyIn    (NFCtrlBusy    ),
   .NFStatValidIn   (NFStatValid   ),
   .NFStatusIn      (NFStatus      ),
   .WrEndIn         (WrEnd         ),
   .RdEndIn         (RdEnd         ),  
   .WrFIFOReadyIn   (WrFIFOReady   ),  
   .RdFIFOReadyIn   (RdFIFOReady   ),  
   .FiltRnB1In      (FiltRnB1      ),
   .FiltRnB0In      (FiltRnB0      ),

   // Data FIFO R/W
   .FIFOFlushIn     (FIFOFlush     ), 
   .FIFORdDataOut   (FIFORdData    ), 
   .FIFORdDataEnIn  (FIFORdDataEn  ),
   .FIFOWrDataIn    (FIFOWrData    ),
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
   .ControlOut      (Control       ),
   .ConfigOut       (Config        ));

NFBoot uNFboot(
   .Clk             (PCLK           ),
   .nRst            (PRESETn        ),    
   .NFBootIn        (Config[18]     ),
   .IOWidthIn       (Config[17]     ),
   .NandWidthIn     (Config[16]     ),
   .BootCfgIn       (Config[15:14]  ),
   .BootOpRdEnIn    (BootOpRdEn     ),
   .BootOpReadyOut  (BootOpReady    ),
   .BootOpOut       (BootOp         ),
   .BootEndOut      (BootEnd        ));  
    
NFCtrl uNFCtrl(
   .Clk             (PCLK          ),
   .nRst            (PRESETn       ),
 
   .DMAReqOut       (NFDMAReqOut   ), 

   // nand boot module
   .BootOpRdEnOut   (BootOpRdEn    ),
   .BootOpReadyIn   (BootOpReady   ),
   .BootOpIn        (BootOp        ),
   .BootEndIn       (BootEnd       ),
                    
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
   .FIFORdDataIn    (FIFORdData    ),
   .FIFORdDataEnOut (FIFORdDataEn  ),
   .FIFOWrDataOut   (FIFOWrData    ),
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
                                   
   //NFCTRL,NFCONF 
   .NFCTRLIn        (Control       ),
   .NFCONFIn        (Config        ),
   
   //ECC
   .EccIn           (Ecc           ),
   .AutoEccWrEnIn   (AutoEccWrEn   ),
   .BoundaryIn      (Boundary      ),
   .NST_RdataOut    (NST_Rdata     ),
   .CST_RdataOut    (CST_Rdata     ),
   .CST_WdataOut    (CST_Wdata     ),
   .EccDataOut      (EccData       ),
   .EccDataEnOut    (EccDataEn     ),
   .AddrValidOut    (AddrValid     ),
   .ColumnAddrOut   (ColumnAddr    ),

   // nand flash I/F
   .NFDataIn        (NFDataIn      ),
   .NFDataOut       (NFDataOut     ),
   .NFDataOutEnOut  (NFDataOutEn   ),
   .CLEOut          (CLE           ),
   .ALEOut          (ALE           ),
   .nNFCE1Out       (nNFCE1        ),
   .nNFCE0Out       (nNFCE0        ),
   .nNFREOut        (nNFRE         ),
   .nNFWEOut        (nNFWE         ),
   .FiltRnB1In      (FiltRnB1      ),
   .FiltRnB0In      (FiltRnB0      ));

NFEcc uNFEcc(
   .Clk             (PCLK          ),          
   .nRst            (PRESETn       ),           
 
   .AddrIn          (ColumnAddr    ),
   .AddrLoadEnIn    (AddrValid     ),
   .IOWidthIn       (Config[17]    ),                  
   .NandWidthIn     (Config[16]    ), 
   .PageSizeIn      (Config[15]    ),
   .EccRstIn        (Control[13]   ), 
   .Ecc512EnIn      (Control[8]    ),
   .AutoEccWr       (Control[7]    ),
   .AutoEccWrEnOut  (AutoEccWrEn   ),
   
   .EccOut          (Ecc           ),
   .AddrCntOut      (AddrCnt       ),
   .BoundaryOut     (Boundary      ),
   .CST_RdataIn     (CST_Rdata     ),
   .CST_WdataIn     (CST_Wdata     ),
   .EccDataIn       (EccData       ),
   .EccDataEnIn     (EccDataEn     ), 

   .ECCSECTOR0      (ECCSECTOR0    ),
   .ECCSECTOR1      (ECCSECTOR1    ),
   .ECCSECTOR2      (ECCSECTOR2    ),
   .ECCSECTOR3      (ECCSECTOR3    ),
   .ECCSECTOR4      (ECCSECTOR4    ),
   .ECCSECTOR5      (ECCSECTOR5    ),
   .ECCSECTOR6      (ECCSECTOR6    ),
   .ECCSECTOR7      (ECCSECTOR7    ),
   .ECCSECTOR8      (ECCSECTOR8    ),
   .ECCSECTOR9      (ECCSECTOR9    ),
   .ECCSECTOR10     (ECCSECTOR10   ),
   .ECCSECTOR11     (ECCSECTOR11   ),
   .ECCSECTOR12     (ECCSECTOR12   ),
   .ECCSECTOR13     (ECCSECTOR13   ),
   .ECCSECTOR14     (ECCSECTOR14   ),
   .ECCSECTOR15     (ECCSECTOR15   ),
               
   .SECCSECTOR0     (SECCSECTOR0   ),
   .SECCSECTOR1     (SECCSECTOR1   ),
   .SECCSECTOR2     (SECCSECTOR2   ),
   .SECCSECTOR3     (SECCSECTOR3   ),
   .SECCSECTOR4     (SECCSECTOR4   ),
   .SECCSECTOR5     (SECCSECTOR5   ),
   .SECCSECTOR6     (SECCSECTOR6   ),
   .SECCSECTOR7     (SECCSECTOR7   ));














endmodule
