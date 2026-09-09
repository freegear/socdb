//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash control
// module name : NFCtrl.v
// history     :
//
//************************************************

`timescale 1ns/10ps

//`define Page512

//`define dual

module Tb_NFTop();

reg         PCLK	    ;
reg         PRESETn     ;
reg [ 6:2]  EXT_SFR_ADDR;
reg         EXT_SFR_WR  ;

reg [7:0]   EXT_SFR_DOUT;
wire[7:0]   EXT_SFR_DIN ;

reg [7:0]   WDATA       ;    
wire[7:0]   RDATA       ;   
reg         We          ;    
reg         Oe          ;    

wire        NFDMAReqOut ;
wire        NFINTOut    ;

reg         NFBootPinIn;    
reg         IOWidthPinIn;   
reg         NandWidthPinIn;   
reg [ 1:0]  BootCfgPinIn;   
reg         OutDtmnPinIn;   

wire[11:0]  AddrCnt     ;

wire[15:0]  NFDataIn    ;
wire[15:0]  NFDataOut   ;
wire        NFDataOutEn ;
wire        CLE         ;
wire        ALE         ;
wire        nNFCE3      ;
wire        nNFCE2      ;
wire        nNFCE0      ;
wire        nNFCE1      ;
wire        nNFRE       ;
wire        nNFWE       ;

wire        RnB3        ;
wire        RnB2        ;
wire        RnB0        ;
wire        RnB1        ;



parameter   byte        =1'b0;
parameter   halfword    =1'b1;


parameter   cycle2      =2'b00;
parameter   cycle3      =2'b01;
parameter   cycle4      =2'b10;
parameter   cycle5      =2'b11;

parameter   NoOption    =2'b00;
parameter   RnBWait     =2'b01;
parameter   AutoRdStat  =2'b10;
parameter   Continue    =2'b11;


parameter   FIFOLEVEL   =3'd0; //FIFOLEVEL+1 => ½ÇÁ¦ level

pullup(RnB3);
pullup(RnB2);
pullup(RnB1);
pullup(RnB0);

// Instantiate Device

reg[11:0] PageSize;
wire[15:0]  NFIO;


`ifdef x8
    `ifdef Page512
        NAND512R3A  uut0(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE0     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB0       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut1(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE1     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB1       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut2(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE2     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB2       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut3(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE3     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB3       ),
           .VDD  (1          ),
           .VSS  (0          ));

    `else
        nand_model_0 uut0(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut1(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE1     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB1       ));

        nand_model_0 uut2(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE2     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB2       ));

        nand_model_0 uut3(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE3     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB3       ));
    `endif
`endif



`ifdef x16
    `ifdef Page512

        NAND512R3A  uut0(
           .IO   (NFIO[15:0]  ),   
           .CE   (nNFCE0     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB0       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut1(
           .IO   (NFIO[15:0]  ),   
           .CE   (nNFCE1     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB1       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut2(
           .IO   (NFIO[15:0] ),   
           .CE   (nNFCE2     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB2       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut3(
           .IO   (NFIO[15:0]  ),   
           .CE   (nNFCE3     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB3       ),
           .VDD  (1          ),
           .VSS  (0          ));
   `else

        nand_model_0 uut0(
           .Io  (NFIO[15:0] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut1(
           .Io  (NFIO[15:0] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE1     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB1       ));

        nand_model_0 uut2(
           .Io  (NFIO[15:0] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE2     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB2       ));

        nand_model_0 uut3(
           .Io  (NFIO[15:0] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE3     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB3       ));
   `endif
   
`endif



`ifdef dual
    `ifdef Page512
        NAND512R3A  uut0(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE0     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB0       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut1(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE0     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB0       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut2(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE1     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB1       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut3(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE1     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB1       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut4(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE2     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB2       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut5(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE2     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB2       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut6(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE3     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB3       ),
           .VDD  (1          ),
           .VSS  (0          ));

        NAND512R3A  uut7(
           .IO   (NFIO[7:0]  ),   
           .CE   (nNFCE3     ),   
           .WE   (nNFWE      ),       
           .RE   (nNFRE      ),   
           .WP   (1'b1       ),
           .CLE  (CLE        ),    
           .ALE  (ALE        ),
           .RY_BY(RnB3       ),
           .VDD  (1          ),
           .VSS  (0          ));

   `else
        nand_model_0 uut0(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut1(
           .Io  (NFIO[15:8] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut2(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE1     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB1       ));

        nand_model_0 uut3(
           .Io  (NFIO[15:8] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE1     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB1       ));

        nand_model_0 uut4(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE2     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB2       ));

        nand_model_0 uut5(
           .Io  (NFIO[15:8] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE2     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB2       ));

        nand_model_0 uut6(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE3     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB3       ));

        nand_model_0 uut7(
           .Io  (NFIO[15:8] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE3     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB3       ));
    `endif
`endif


`ifdef mcp
nand_model_0 uut0(
   .Io  (NFIO[7:0]  ),        
   .Cle (CLE        ),
   .Ale (ALE        ),
   .Ce_n(nNFCE0     ),
   .We_n(nNFWE      ),
   .Re_n(nNFRE      ),
   .Wp_n(1'b1       ),
   .Pre (1'b1       ),
   .Rb_n(RnB0       ));

nand_model_1 uut1(
   .Io  (NFIO[7:0] ),        
   .Cle (CLE        ),
   .Ale (ALE        ),
   .Ce_n(nNFCE1     ),
   .We_n(nNFWE      ),
   .Re_n(nNFRE      ),
   .Wp_n(1'b1       ),
   .Pre (1'b1       ),
   .Rb_n(RnB1       ));
`endif

NFTop uNFTop(
   .PCLK	        (PCLK	     ),      
   .PRESETn         (PRESETn     ),
   .EXT_SFR_ADDR    (EXT_SFR_ADDR),
   .EXT_SFR_WR      (EXT_SFR_WR  ),
   .EXT_SFR_DOUT    (EXT_SFR_DOUT),
   .EXT_SFR_DIN     (EXT_SFR_DIN ),

   .WDATA       (WDATA       ),           
   .RDATA       (RDATA       ),    
   .We          (We          ),    
   .Oe          (Oe          ),    

 
   .NFDMAReqOut (NFDMAReqOut ),
   .NFINTOut    (NFINTOut    ),

   .NFBootPinIn (NFBootPinIn),  
   .IOWidthPinIn(IOWidthPinIn), 
   .NandWidthPinIn(NandWidthPinIn), 
   .BootCfgPinIn(BootCfgPinIn), 
   .OutDtmnPinIn(OutDtmnPinIn), 
   
   .AddrCnt     (AddrCnt     ),

   .NFDataIn    (NFDataIn    ),
   .NFDataOut   (NFDataOut   ),
   .NFDataOutEn (NFDataOutEn ),
   .CLE         (CLE         ),
   .ALE         (ALE         ),
   .nNFCE0      (nNFCE0      ),
   .nNFCE1      (nNFCE1      ),
   .nNFCE2      (nNFCE2      ),
   .nNFCE3      (nNFCE3      ),

   .nNFRE       (nNFRE       ),
   .nNFWE       (nNFWE       ),
   .RnB0        (RnB0        ),
   .RnB1        (RnB1        ),
   .RnB2        (RnB2        ),
   .RnB3        (RnB3        ));





// For Ecc simulation
//`define ECCERRTEST

`ifdef ECCERRTEST
    wire EccErr=1;
`else
    wire EccErr=0;
`endif

`define ECC512
wire Ecc512En = 1'b1; //enabel = 1'b1
wire Correctable=1;
wire[2:0] ErrBitNum=0;
reg[15:0] NandData;
reg[9:0]  BytePos=0;

    always @(EccErr or Correctable or ErrBitNum or NFIO or AddrCnt)
    begin
        if(EccErr) begin
            if(Correctable) begin
`ifdef ECC512                
                if(AddrCnt==(0+BytePos) || AddrCnt==(512+BytePos) || AddrCnt==(1024+BytePos) || AddrCnt==(1056+BytePos)) begin
`else //256ECC
                if(AddrCnt==(0+BytePos)    || AddrCnt==(256+BytePos)  || AddrCnt==(512+BytePos)  || AddrCnt==(768+BytePos) ||
                   AddrCnt==(1024+BytePos) || AddrCnt==(1280+BytePos) || AddrCnt==(1536+BytePos) || AddrCnt==(1792+BytePos)) begin
`endif
                    case(ErrBitNum)
                        3'b000  : NandData<={NFIO[15:1],~NFIO[0]}; 
                        3'b001  : NandData<={NFIO[15:2],~NFIO[1],NFIO[0]}; 
                        3'b010  : NandData<={NFIO[15:3],~NFIO[2],NFIO[1:0]}; 
                        3'b011  : NandData<={NFIO[15:4],~NFIO[3],NFIO[2:0]}; 
                        3'b100  : NandData<={NFIO[15:5],~NFIO[4],NFIO[3:0]}; 
                        3'b101  : NandData<={NFIO[15:6],~NFIO[5],NFIO[4:0]}; 
                        3'b110  : NandData<={NFIO[15:7],~NFIO[6],NFIO[5:0]}; 
                        default : NandData<={NFIO[15:8],~NFIO[7],NFIO[6:0]}; 
                    endcase
                end
                else NandData<=NFIO;
            end
            else begin
`ifdef ECC512                
                if(AddrCnt==(0+BytePos) || AddrCnt==(512+BytePos) || AddrCnt==(1024+BytePos) || AddrCnt==(1056+BytePos)) begin
`else //256ECC
                if(AddrCnt==(0+BytePos)    || AddrCnt==(256+BytePos)  || AddrCnt==(512+BytePos)  || AddrCnt==(768+BytePos) ||
                   AddrCnt==(1024+BytePos) || AddrCnt==(1280+BytePos) || AddrCnt==(1536+BytePos) || AddrCnt==(1792+BytePos)) begin
`endif
                    case(ErrBitNum)
                        3'b000  : NandData<={NFIO[15:1],NFIO[7:2],~NFIO[1:0]}; 
                        3'b001  : NandData<={NFIO[15:2],NFIO[7:3],~NFIO[2:1],NFIO[0]}; 
                        3'b010  : NandData<={NFIO[15:3],NFIO[7:4],~NFIO[3:2],NFIO[1:0]}; 
                        3'b011  : NandData<={NFIO[15:4],NFIO[7:5],~NFIO[4:3],NFIO[2:0]}; 
                        3'b100  : NandData<={NFIO[15:5],NFIO[7:6],~NFIO[5:4],NFIO[3:0]}; 
                        3'b101  : NandData<={NFIO[15:6],NFIO[7],~NFIO[6:5],NFIO[4:0]}; 
                        3'b110  : NandData<={NFIO[15:7],~NFIO[7:6],NFIO[5:0]}; 
                        default : NandData<={NFIO[15:8],NFIO[7:6],~NFIO[5],NFIO[4:2],~NFIO[1],NFIO[0]}; 
                    endcase
                end
                else NandData<=NFIO;
            end
        end
        else NandData<=NFIO;
    end


assign      NFIO = (NFDataOutEn==1'b0) ? NFDataOut : 16'hzz;
assign      NFDataIn = NandData;

integer write_file[10],read_file[20];

integer wnum,rnum,i;

initial begin
    
    read_file[0]  = $fopen("./rwdata/boot.dat");
    write_file[0] = $fopen("./rwdata/write0.dat");
    write_file[1] = $fopen("./rwdata/write1.dat");
    write_file[2] = $fopen("./rwdata/write2.dat");
    write_file[3] = $fopen("./rwdata/write3.dat");
    write_file[4] = $fopen("./rwdata/write4.dat");
    write_file[5] = $fopen("./rwdata/write5.dat");
    write_file[6] = $fopen("./rwdata/write6.dat");
    write_file[7] = $fopen("./rwdata/write7.dat");
    write_file[8] = $fopen("./rwdata/write8.dat");
    write_file[9] = $fopen("./rwdata/write9.dat");
    read_file[0]  = $fopen("./rwdata/boot0.dat");
    read_file[1]  = $fopen("./rwdata/boot1.dat");
    read_file[2]  = $fopen("./rwdata/boot2.dat");
    read_file[3]  = $fopen("./rwdata/boot3.dat");
    read_file[4]  = $fopen("./rwdata/boot4.dat");
    read_file[5]  = $fopen("./rwdata/boot5.dat");
    read_file[6]  = $fopen("./rwdata/boot6.dat");
    read_file[7]  = $fopen("./rwdata/boot7.dat");
    read_file[8]  = $fopen("./rwdata/boot8.dat");
    read_file[9]  = $fopen("./rwdata/boot9.dat");
    read_file[10] = $fopen("./rwdata/boot10.dat");
    read_file[11] = $fopen("./rwdata/boot11.dat");
    read_file[12] = $fopen("./rwdata/boot12.dat");
    read_file[13] = $fopen("./rwdata/boot13.dat");
    read_file[14] = $fopen("./rwdata/boot14.dat");
    read_file[15] = $fopen("./rwdata/boot15.dat");
    read_file[16] = $fopen("./rwdata/read0.dat");
    read_file[17] = $fopen("./rwdata/read1.dat");
    read_file[18] = $fopen("./rwdata/read2.dat");
    read_file[19] = $fopen("./rwdata/read3.dat");
    
end

always #10 PCLK <= ~PCLK;

task reg_write;
    input [4:0] addr;
    input [7:0] data;
    begin
        @(posedge PCLK) 
//        PSEL <= 1'b1;
        EXT_SFR_WR <= 1'b1;
        EXT_SFR_ADDR  <= addr;
        EXT_SFR_DOUT <= data;
//        PENABLE<= 1'b0;
//        @(posedge PCLK) 
//        PENABLE <= 1'b1;
        @(posedge PCLK) 
//        PSEL <=0;
        EXT_SFR_WR <= 1'b0;
//        PENABLE<= 1'b0;
        @(posedge PCLK);
    end
endtask

task reg_read;
    input [4:0] addr;
    output [7:0] rdata;
    begin
        @(posedge PCLK) 
//        PSEL <= 1'b1;
        EXT_SFR_WR <= 1'b0;
        EXT_SFR_ADDR  <= addr;
//        PENABLE<= 1'b0;
//        @(posedge PCLK) 
//        PENABLE<=1'b1;
        @(posedge PCLK) 
//        PSEL<=0;
        rdata<=EXT_SFR_DIN;
        EXT_SFR_WR<=1'b0;
//        PENABLE<=1'b0;
        @(posedge PCLK);
    end
endtask

task data_write;
    input [7:0] data;
    begin
        @(posedge PCLK) We <= 1'b0;
        WDATA <= data;
        @(posedge PCLK) We <= 1'b1;
        @(posedge PCLK) We <= 1'b0;
    end
endtask

task data_read;
    output[7:0] rdata;
    begin
        @(posedge PCLK) Oe <= 1'b1;
        @(posedge PCLK) Oe <= 1'b0;
        rdata <= RDATA;
        @(posedge PCLK);
    end
endtask

wire[4:0] fifo_level = FIFOLEVEL+1;

task write_data;
    input[11:0] data_size;
    input  trans_size;
    integer i,j;
    integer size;
    integer remain;

    reg[7:0]div;

    reg[7:0] byte1;
    reg[7:0] byte2;
    reg[7:0] byte3;
    reg[7:0] byte4;
    reg[7:0] status;
    reg[2:0] cnt;
    
    begin

        byte1=4;
        byte2=5;
        byte3=6;
        byte4=7;

        size = (data_size/fifo_level);
        remain = (data_size%fifo_level);

        reg_read(4'hA,status);



        while(!status[5]) reg_read(4'hA,status);

//        $display("**************************\n");

        for(i=0;i<size;i=i+1) begin
            for(j=0;j<fifo_level;j=j+1) begin
                byte1=+i;
                byte2=1+i;
                byte3=byte3+i;
                byte4=byte4+i;
                cnt=0;

                if(trans_size==byte) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    data_write(byte1);
                end
                else if(trans_size==halfword) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    data_write(byte1);
                    data_write(byte2);

                end
            end

            reg_read(4'hA,status);

            while(!status[5]) begin
                reg_read(4'hA,status);
            end
        end
 




        reg_read(4'hA,status);
        while(!status[5]) reg_read(4'hA,status);

        if(remain!=0) begin
            for(j=0;j<remain;j=j+1) begin
                byte1=i;
                byte2=1+i;
                byte3=byte3+j;
                byte4=byte4+j;

                if(trans_size==byte) begin
                    $fwite(write_file[wnum],"%h\n",byte1);
                    data_read(byte1);
 //                   reg_write(4'h4,8'h0);
 //                   reg_write(4'h4,8'h0);
 //                   reg_write(4'h4,8'h0);
                end
                else if(trans_size==halfword) begin
                    $fwirte(write_file[wnum],"%h\n",byte1);
 //                   $fwirte(write_file[wnum],"%h\n",byte2);
                    data_read(byte1);
 //                   reg_write(4'h4,byte2);
 //                   reg_write(4'h4,8'h0);
 //                   reg_write(4'h4,8'h0);
                end
                /*
                else if(trans_size==word) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    $fwrite(write_file[wnum],"%h\n",byte3);
                    $fwrite(write_file[wnum],"%h\n",byte4);
                    reg_write(4'h4,byte1);
                    reg_write(4'h4,byte2);
                    reg_write(4'h4,byte3);
                    reg_write(4'h4,byte4);
                end 
                */
            end
        end
    end
endtask

task RnB_Wait;
    input [1:0] chipsel;
    reg [7:0] status;
    begin

        reg_read(4'hD,status);
        if(chipsel==2'b00) begin
            while(status[0]) reg_read(4'hD,status);
            while(!status[0]) reg_read(4'hD,status);
        end
        else if(chipsel==2'b01)begin
            while(status[1]) reg_read(4'hD,status);
            while(!status[1]) reg_read(4'hD,status);
        end
        else if(chipsel==2'b10)begin
            while(status[2]) reg_read(4'hD,status);
            while(!status[2]) reg_read(4'hD,status);
        end
        else begin
            while(status[3]) reg_read(4'hD,status);
            while(!status[3]) reg_read(4'hD,status);
        end
    end
endtask

task Data_Read;
    input [11:0] data_size;
    input trans_size;
    reg [7:0] status;
    reg [7:0] read_data;
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;
    reg [7:0] byte4;
    reg [2:0] cnt;


    integer size;
    integer remain;
    integer i,j;
    begin
        byte1=0;
        byte2=0;
        byte3=0;
        byte4=0;
        cnt=0;
        

        size=(data_size/fifo_level);
        remain=data_size%fifo_level;

        for(i=0;i<size;i=i+1) begin
            reg_read(4'hA,status);
            while(!status[4]) reg_read(4'hA,status);
            reg_write(4'hA,8'hf0);
            reg_write(4'hB,8'hff);
            reg_write(4'hC,8'h00);
            reg_write(4'hD,8'hff);

            for(j=0;j<fifo_level;j=j+1) begin
//                reg_read(4'd4,read_data);
//                $fwrite(read_file[rnum],"%h\n",read_data);
                    /*
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    */

                if(trans_size==1'b0) begin
                    data_read(read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);

                end
                else if(trans_size==1'b1) begin
                    data_read(read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    data_read(read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);


                end
                /*
                else if(trans_size==2'b10) begin
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    reg_read(4'd4,read_data);
                    reg_read(4'd4,read_data);
                    reg_read(4'd4,read_data);
                end  
                */
            end             

        end

        if(remain!=0) begin
            for(j=0;j<remain;j=j+1) begin
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    /*
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                reg_read(4'd4,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
*/

                if(trans_size==2'b0) begin
                    $fwrite(read_file[rnum],"%h\n",read_data);
                end
                else if(trans_size==2'b1) begin
                    data_read(read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                end
                /*
                else if(trans_size==2'b10) begin
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data);
                end   
                */
            end
        end

        /*
        if(trans_size==word && PageSize==528) begin
            reg_read(4'hA,status);
            while(!status[4]) reg_read(4'hA,status);
            reg_write(4'hA,8'hff);
            reg_write(4'hB,8'hff);
            reg_write(4'hC,8'h00);
            reg_write(4'hD,8'h00);

            for(j=0;j<4;j=j+1) begin
                reg_read(4'h4,read_data);
                reg_read(4'h4,read_data);
                reg_read(4'h4,read_data);
                reg_read(4'h4,read_data);

                $fwirte(read_file[rnum],"%h\n",read_data[7:0]);
                $fwirte(read_file[rnum],"%h\n",read_data[15:8]);
                $fwirte(read_file[rnum],"%h\n",read_data[23:16]);
                $fwirte(read_file[rnum],"%h\n",read_data[31:24]);

                byte1<=byte1+j;
                byte2<=byte2+j;
                byte3<=byte3+j;
                byte4<=byte4+j;
/*
                `ifdef debug
                     if(read_data[31:0]!={byte4,byte3,byte2,byte1}) begin
                          $display($time,"i[%d] j[%d] :: write data[%h] :: read data[%h]",i,j,{byte4,byte3,byte2,byte1},read_data);
                          $display($time,":: Read DATA ERROR");
                          $stop;
                    end
                `endif
                
            end
        end
        */
    end
endtask

task Read_ID;
    input      trans_size;
    input[1:0] IDByte;
    reg [7:0] status;
    reg [7:0] ID;
    integer i,j,size;

begin

        $display("**************************",);
        $display("  ID READ START");
        $display("**************************",);
    if(IOWidthPinIn==0) begin
        if(trans_size!=1'b0) begin
            $display(" 16bit IO ID READ :: size half word!!");
            $stop;
        end
        if(IDByte==2'b00)      size<=2;
        else if(IDByte==2'b01) size<=3;
        else if(IDByte==2'b10) size<=4;
        else if(IDByte==2'b11) size<=5;
       
        reg_read(4'hA,status);
        while(!status[4]) reg_read(4'hA,status);
        reg_write(4'hA,8'hf0);
        reg_write(4'hB,8'hff);
        reg_write(4'hC,8'h00);
        reg_write(4'hD,8'hff);

        for(i=0;i<size;i=i+1) begin
//                $display(" ID Byte\n");

            data_read(ID);
                $display(" [%h]",ID);
/*            reg_read(4'h4,ID);
                $display(" [%h]",ID);
            reg_read(4'h4,ID);
                $display(" [%h]",ID);
            reg_read(4'h4,ID);
                $display(" [%h]\n",ID);
                $display("*****************");
*/
        end
    end
    else begin
        if(trans_size==1'b1) begin
            if(IDByte==2'b00) size<=2;
            else if(IDByte==2'b01) size<=3;
            else if(IDByte==2'b10) size<=4;
            else if(IDByte==2'b11) size<=5;
        end
        
        reg_read(4'hA,status);
        while(!status[4]) reg_read(4'hA,status);
            reg_write(4'hA,8'hf0);
            reg_write(4'hB,8'hff);
            reg_write(4'hC,8'h00);
            reg_write(4'hD,8'hff);
        for(i=0;i<size;i=i+1) begin
            data_read(ID);      
                $display(" ID Byte[%h]",ID);
            data_read(ID);      
                $display(" ID Byte[%h]",ID);
                /*
            reg_read(4'h4,ID);
                $display(" ID Byte[%h]",ID);
            reg_read(4'h4,ID);
                $display(" ID Byte[%h]",ID);
            reg_read(4'h4,ID);
                $display(" ID Byte[%h]",ID);
               */ 
        end
    end
        $display("**************************");
        $display("  ID READ End");
        $display("**************************");
    end
endtask


// first NFOPER
// NFOPER[21]/NFOPER[20]/NFOPER[19]/NFOPER[18:16]/NFOPER[15:13]/NFOPER[12:11]/NFOPER[10:8]/NFOPER[7:0] 
// CE        /RnbWait   /AutoRdStat/FIFOLevel    /OpMode       /TransferSize /TransferByte/CmdAddrFlag
// 0         /0         /0         /111          /000(RdData)  /10(WORD size)/            /

// second NFOPER
// DATASIZE[11:0]
// page read cmd test)
//
// OPMode 
// 000: read data  001: read status
// 010: read ID    011: write data
// 100: cell write Others: NOP
reg[7:0]  rddata;
reg[ 7:0]  wmem[4224:0];
reg[ 7:0]  rmem[4224:0];
reg[ 3:0] TransferByte;
integer num;
initial
begin
    PCLK        =1'b0;
    PRESETn     =1'b0;
    EXT_SFR_ADDR       =0;
//    PSEL        =0;
//    PENABLE     =0;
    EXT_SFR_DOUT      =0;
    EXT_SFR_WR      =0;

    WDATA       =0;
    We          =0;
    Oe          =0;

`ifdef BOOT
    NFBootPinIn=1'b1 ;  //NFBootEnable;  
`else
    NFBootPinIn=1'b0;   //NFBootDisable;
`endif
`ifdef x8
    IOWidthPinIn=1'b0 ;   
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef mcp  // used 2 chip_enable pin
    IOWidthPinIn=1'b0 ;   
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef dual
    IOWidthPinIn=1'b1 ;
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef x16
    IOWidthPinIn=1'b1 ;
    NandWidthPinIn=1'b1 ;   
`endif

`ifdef Page512
    PageSize=12'd528;
    BootCfgPinIn=2'b01;   //512page addr_4cycle
    TransferByte=4'd4;
`else
    PageSize=12'd2112;
    BootCfgPinIn=2'b11;   
    TransferByte=4'd7;
`endif

    OutDtmnPinIn=1'b1 ;       
    #100 PRESETn=1'b1;

    rddata<=0;
    wait(PRESETn);

`ifdef BOOT
    wait(BootEnd);
    $display("\n///// 8Kbyte Boot End /////\n");
`endif

$display("\n/////  NAND FLASH READ ID /////\n");
    //                   /NFCtrlRst/FIFOLevel/    /Ecc512En/AutoEccWr/DMAEn/WrEndIntEn/RdEndIntEn/EccErrIntEn/FIFOIntEn/RnBIntEn1/RnBIntEn0/
//    reg_write(4'd3,{18'd0,1'b0     ,3'b111   ,1'b0,1'b1   ,1'b1     ,1'b0 ,1'b0      ,1'b0      ,1'b0       ,1'b0     ,1'b0     ,1'b0});//NFCTRL

    reg_write(4'h8,8'b0000_0000);
    reg_write(4'h9,8'b0001_1101);


/*
`ifdef dual
    // READ ID
                    //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,NoOption ,12'h005 ,3'b010,halfword    ,4'b0010     ,8'b10001001});
    reg_write(4'd0,{8'h90,8'h00,8'h00,8'h90});
    Read_ID(halfword,cycle5);
`else
    // READ ID
                    //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,NoOption ,12'h005 ,3'b010,byte        ,4'b0010     ,8'b10001001});
    reg_write(4'd0,{8'h90,8'h00,8'h00,8'h90});
    Read_ID(byte,cycle5);
`endif
*/

`ifdef dual
    //READ ID
    
    reg_write(4'h0,8'b1000_1001);
    reg_write(4'h1,{3'b010,halfword,4'b0010});
    reg_write(4'h2,8'b0000_0101);
    reg_write(4'h3,{2'b00,NoOption,4'b0000});

    reg_write(4'h0,8'h90);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h90);

    reg_write(4'h0,8'h00);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h00);

    Read_ID(halfword,cycle5);
`endif

`ifdef x16
    //READ ID
    //ID Byte
    reg_write(4'h0,8'b1000_1001);
    reg_write(4'h1,{3'b010,halfword,4'b0010});
    reg_write(4'h2,8'b0000_0101);
    reg_write(4'h3,{2'b00,NoOption,4'b0000});

    reg_write(4'h0,8'h90);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h90);

    reg_write(4'h0,8'h00);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h00);

    Read_ID(halfword,cycle5);
`endif

`ifdef x8
    reg_write(4'h0,8'b1000_1001);
    reg_write(4'h1,{3'b010,byte,4'b0010});
    reg_write(4'h2,8'b0000_0101);
    reg_write(4'h3,{2'b00,NoOption,4'b0000});

    reg_write(4'h0,8'h90);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h90);
/*
    reg_write(4'h0,8'h00);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h00);
*/
    Read_ID(byte,cycle5);
`endif

    //********* reg setting *************
/*
reg_write(4'd2,{19'd0,4'b1111,3'b001,3'b001,3'b001});//NFCONF
//reg_write(4'd2,{19'd0,4'b1111,3'b000,3'b000,3'b000});//NFCONF
//                   /NFCtrlRst/FIFOLevel/    /Ecc512En/AutoEccWr/DMAEn/WrEndIntEn/RdEndIntEn/reserved/FIFOIntEn/RnBIntEn1/RnBIntEn0/
reg_write(4'd3,{18'd0,1'b0     ,FIFOLEVEL,1'b0,Ecc512En,1'b1     ,1'b1 ,1'b0      ,1'b0      ,1'b0    ,1'b1     ,1'b0     ,1'b0});//NFCTRL
    
reg_read (4'd2,rddata);
reg_read (4'd3,rddata);
*/


reg_write(4'h5,8'b0100_1001);
reg_write(4'h6,8'b0001_1110);
reg_write(4'h7,8'b0000_0000);

reg_write(4'h8,8'b1001_0000);
reg_write(4'h9,{3'b0,FIFOLEVEL,Ecc512En,1'b0});

reg_read(4'd5,rddata);
reg_read(4'd6,rddata);
reg_read(4'd7,rddata);

reg_read(4'd8,rddata);
reg_read(4'd9,rddata);

$display("\n/////  NAND FLASH RESET /////\n");

/*
    // nand flash reset
                    //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0010     ,8'b00000011});
    reg_write(4'd0,{8'haa,8'hbb,8'h70,8'hff});

    //RnB wait
    //RnB_Wait;
*/

    reg_write(4'h0,8'b0000_0011);
    reg_write(4'h1,8'b1111_0010);
    reg_write(4'h2,8'b0000_0000);
    reg_write(4'h3,{2'b00,AutoRdStat,4'b1000});

    reg_write(4'h0,8'hff);
    reg_write(4'h1,8'h70);
    reg_write(4'h2,8'hbb);
    reg_write(4'h3,8'haa);

$display("\n/////  NAND FLASH BLOCK ERASE /////\n");

/*
    // Block Erase
                    //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0110     ,8'b10010001});
//    reg_write(4'd0,{8'h60,8'h00,8'h00,8'h00});
//    reg_write(4'd0,{8'hd0,8'h70,8'h10,8'h70});    
    reg_write(4'd0,{8'h00,8'h00,8'h00,8'h60});
    reg_write(4'd0,{8'hd0,8'h70,8'h70,8'hd0});    
*/



    reg_write(4'h0,8'b1001_0001);
    reg_write(4'h1,8'b1111_0110);
    reg_write(4'h2,8'b0000_0000);
    reg_write(4'h3,{2'b00,AutoRdStat,4'b1000});

    reg_write(4'h0,8'h60);
    reg_write(4'h1,8'h00);
    reg_write(4'h2,8'h00);
    reg_write(4'h3,8'h00);

    reg_write(4'h0,8'hd0);
    reg_write(4'h1,8'h70);
    reg_write(4'h2,8'h70);
    reg_write(4'h3,8'hd0);

/*
`ifndef Page512 // 2048 page!!!!!!!!!!!!!
    $display("\n/////  NAND FLASH BLOCK ERASE /////\n");

        // Block Erase
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    //    reg_write(4'd0,{1'd0,NoOption,12'h800 ,3'b101,2'b10       ,4'b0100     ,8'b10010001});
        reg_write(4'd0,{1'd0,Continue,12'h800 ,3'b111,2'b10       ,4'b0100     ,8'b10010001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h60});
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0110     ,8'b10010001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h60});
        reg_write(4'd0,{8'hd0,8'h70,8'h70,8'hd0});    

        // wait for command Queue empty
        reg_read (4'd5,rddata);
        while(rddata[11:8]!=0) reg_read (4'd5,rddata);
        $display("\n/////  CMD Q Empty /////\n");
        repeat(2000) @(posedge PCLK); 
    $display("\n/////  NAND FLASH copy back /////\n");
                        //CE/Option /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,RnBWait,12'h800 ,3'b101,2'b10       ,4'b0111     ,8'b01000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h35,8'h00,8'h00});    
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b1000     ,8'b01000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h85});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});    

        // wait for command Queue empty
        reg_read (4'd5,rddata);
        while(rddata[11:8]!=0) reg_read (4'd5,rddata);
        $display("\n/////  CMD Q Empty /////\n");
        repeat(2000) @(posedge PCLK); 

        reg_write(4'd0,{1'd0,NoOption,12'h800 ,3'b101,2'b10       ,4'b0001     ,8'b01000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h31});
`endif
*/

`ifndef Page512 // 2048 page!!!!!!!!!!!!!
    $display("\n/////  NAND FLASH BLOCK ERASE /////\n");

        // Block Erase
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    //    reg_write(4'd0,{1'd0,NoOption,12'h800 ,3'b101,2'b10       ,4'b0100     ,8'b10010001});

        reg_write(4'd0,8'b1001_0001);
        reg_write(4'd1,8'b1111_0100);
        reg_write(4'h2,8'b0000_0000);
        reg_write(4'h3,{2'b00,Continue,4'b1000});

        reg_write(4'h0,8'h60);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'd0,8'b1001_0001);
        reg_write(4'd1,8'b1111_0110);
        reg_write(4'h2,8'b0000_0000);
        reg_write(4'h3,{2'b00,AutoRdStat,4'b1000});

        reg_write(4'h0,8'h60);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);
        
        reg_write(4'h0,8'hd0);
        reg_write(4'h1,8'h70);
        reg_write(4'h2,8'h70);
        reg_write(4'h3,8'hd0);

        reg_read(4'hF,rddata);

        while(rddata[3:0]!=0) reg_read(4'hF,rddata);


        $display("\n////    CMD Q Empty ////\n");

        repeat(2000) @(posedge PCLK);

        $display("\n////    NAND FLASH copy back ////\n");

        reg_write(4'h0,8'b0100_0001);
        reg_write(4'h1,8'b1011_0111);
        reg_write(4'h2,8'b0000_0000);
        reg_write(4'h3,{2'b00,RnBWait,4'b1000});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h35);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'b0100_0001);
        reg_write(4'h1,8'b1111_1000);
        reg_write(4'h2,8'b0000_0000);
        reg_write(4'h3,{2'b00,AutoRdStat,4'b1000});

        reg_write(4'h0,8'h85);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        reg_read(4'hF,rddata);
        while(rddata[3:0]!=0) reg_read(4'hF,rddata);

        $display("\n/////CMD Q Empty /////\n");

        repeat(2000) @(posedge PCLK);

        reg_write(4'h0,8'b0100_0001);
        reg_write(4'h1,8'b1011_0001);
        reg_write(4'h2,8'b0000_0000);
        reg_write(4'h3,{2'b00,NoOption,4'b1000});

        reg_write(4'h0,8'h31);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);
`endif


    /*******************************************************/
    //                  Nand Read Write                     /
    /*******************************************************/




`ifdef Page512

    `ifdef x8

        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag


        reg_write(4'h0,8'b1100_0011);
        reg_write(4'h1,{3'b011,byte,4'b0111});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h80);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;
        write_data(PageSize,byte);
        $display("           Byte Size Write data End");
        RnB_Wait(2'b00);
/*
        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1110_0001);
        reg_write(4'h1,{3'b011,halfword,4'b0111});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,AutoRdStat,PageSize[11:8]});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h80);
        reg_write(4'h2,8'h01);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h10);
        reg_write(4'h2,8'h70);
        reg_write(4'h3,8'h70);

        wnum=1;
        write_data(PageSize/2,halfword);
        $display("           HalfWord Size Write data End");
        RnB_Wait(2'b00);
/*
        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1110_0001);
        reg_write(4'h1,{2'b11,word,4'b0111});
        reg_write(4'h2,{PageSize[6:0],1'b0});
        reg_write(4'h3,{1'b0,AutoRdStat,PageSize[11:7]});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h80);
        reg_write(4'h2,8'h02);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h10);
        reg_write(4'h2,8'h70);
        reg_write(4'h3,8'h70);

        wnum=2;
        write_data(PageSize/4,word);
        $display("           Word Size Write data End");
        RnB_Wait(0);
*/



        repeat(100) @(posedge PCLK); 

        $display("*************Page Read*************\n");
        // page_read
        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b0000_0001);
        reg_write(4'h1,{3'b000,byte,4'b0101});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h01);
        reg_write(4'h2,8'h01);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);
        Data_Read(PageSize,byte);
        $display("           Byte Size Read End");
/*
        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,halfword,4'b0101});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h01);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=17;
        RnB_Wait(2'b00);
        Data_Read(PageSize/2,halfword);
        $display("           HalfWord Size Read End");
/*
        // page_read
        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,word,4'b0101});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h02);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=18;
        RnB_Wait(0);
        Data_Read(PageSize/4,word);
        $display("           Word Size Read End\n");
*/

        $display("*********8Bit IO Read Write Test End*********\n");
    `endif
    
    `ifdef x16


        $display("*************************************");
        $display(" 16bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");


        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag


        reg_write(4'h0,8'b1100_0011);
        reg_write(4'h1,{3'b011,halfword,4'b0111});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,AutoRdStat,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h80);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;
        write_data(PageSize,halfword);
        $display("           halfword Size Write data End");
        RnB_Wait(2'b00);



        repeat(100) @(posedge PCLK); 

        $display("*************Page Read*************\n");
        // page_read
        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b0000_0001);
        reg_write(4'h1,{3'b000,halfword,4'b0101});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h01);
        reg_write(4'h2,8'h01);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);
        Data_Read(PageSize,byte);
        $display("           halfword Size Read End");


        /*

        $display("*************************************");
        $display(" 16bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFla

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b011,halfword,4'b1000});
        reg_write(4'h2,8'b0010_0000);
        reg_write(4'h3,{2'b00,AutoRdStat,4'b0100});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;


        write_data(1056,halfword);



        $display($time,"           HalfWord Size Write data End");

        RnB_Wait(2'b00);



        $display("*************Page Read*************\n");

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,halfword,4'b0111});
        reg_write(4'h2,8'b0010_0000);
        reg_write(4'h3,{2'b00,NoOption,4'b0100});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);

        Data_Read(1056,halfword);

        $display($time,"           HalfWord Size Read End");
*/

    `endif


`else //page 2048

    /*******************************************************/
    //              8bit IO Nand Read Write                 /
    /*******************************************************/



    `ifdef x8

        $display("*************************************");
        $display(" 8bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
//        reg_write(4'd0,{1'd0,NoOption ,PageSize,3'b011,byte       ,4'b0111     ,8'b11000001});// word 

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b011,byte,4'b0111});
        reg_write(4'h2,8'b0011_1111);
        reg_write(4'h3,{2'b00,NoOption,4'b1000});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;



        write_data(2111,byte);

        $display("  Byte Size Write Data End");

        RnB_Wait(2'b00);




 /*  
        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b11,halfword,4'b1000});
        reg_write(4'h2,8'b1000_0000);
        reg_write(4'h3,{1'b0,AutoRdStat,5'b10000});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=1;
        write_data(PageSize/2,halfword);

        $display("  HalfWord Size Write Data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b11,word,4'b1000});
        reg_write(4'h2,8'b1000_0000);
        reg_write(4'h3,{1'b0,AutoRdStat,5'b10000});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h02);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=2;
        write_data(PageSize/4,word);
        $display("  Word Size Write Data End");
        RnB_Wait(0);



*/
 
        $display("*************Page Read*************\n");

        // page_read
        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
//        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,byte       ,4'b0111     ,8'b11000001});


        
        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,byte,4'b0111});
        reg_write(4'h2,8'b0011_1111);
        reg_write(4'h3,{2'b00,NoOption,4'b1000});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);

        Data_Read(12'd2111,byte);
        $display("      Byte Size Read End");

 
/*      
        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b00,halfword,4'b0111});
        reg_write(4'h2,8'b1000_0000);
        reg_write(4'h3,{1'b0,NoOption,5'b10000});


        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=17;

        RnB_Wait(0);
        Data_Read(PageSize/2,halfword);

        $display("  HalfWord Size Read End");

        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag



        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b00,word,4'b0111});
        reg_write(4'h2,8'b1000_0000);
        reg_write(4'h3,{1'b0,NoOption,5'b10000});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h02);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=18;
        RnB_Wait(0);
        Data_Read(PageSize/4,word);
        $display("  Word Size Read End\n");


        $display("********* 8bit IO Read Write Test End********");
        */
    `endif



    `ifdef x16

        $display("*************************************");
        $display(" 16bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFla

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b011,halfword,4'b1000});
        reg_write(4'h2,8'b0010_0000);
        reg_write(4'h3,{2'b00,AutoRdStat,4'b0100});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;


        write_data(1056,halfword);



        $display($time,"           HalfWord Size Write data End");

        RnB_Wait(2'b00);

/*
        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
                        
        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b11,word,4'b1000});
        reg_write(4'h2,8'b0100_0000);
        reg_write(4'h3,{1'b0,AutoRdStat,5'b01000});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=1;
        write_data(1056/2,word);
        $display($time,"           Word Size Write data End");
        RnB_Wait(0);
*/
        $display("*************Page Read*************\n");
        // page_read

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,halfword,4'b0111});
        reg_write(4'h2,8'b0010_0000);
        reg_write(4'h3,{2'b00,NoOption,4'b0100});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);

        Data_Read(1056,halfword);

        $display($time,"           HalfWord Size Read End");
/*
        // --------------Word Size Read-------------------
                         //CE/Option /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b00,word,4'b0111});
        reg_write(4'h2,8'b0100_0000);
        reg_write(4'h3,{1'b0,NoOption,5'b01000});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=17;
        RnB_Wait(0);
        Data_Read(1056/2,word);
        $display($time,"           Word Size Read End\n");
        $display("*********16Bit IO Read Write Test End*********\n");
*/
    `endif

    /*******************************************************/
    //        two 8bit_IO_Nand Read Write                   /
    /*******************************************************/
    `ifdef dual

        $display("*************************************");
        $display(" Two 8bit nand READ WRITE TEST !!!!");
        $display("*************************************");

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag


        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b011,halfword,4'b1000});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,AutoRdStat,PageSize[11:8]});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=0;
        write_data(PageSize,halfword);
        $display($time,"           HalfWord Size Write data End");
        RnB_Wait(2'b00);
/*
        // --------------Word Size Write-------------------
                       //CE/Option     /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b11,word,4'b1000});
        reg_write(4'h2,{PageSize[6:0],1'b0});
        reg_write(4'h3,{1'b0,AutoRdStat,PageSize[11:7]});

        reg_write(4'h0,8'h80);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h10);
        reg_write(4'h3,8'h70);

        wnum=1;
        write_data(PageSize/2,word);
        $display($time,"           Word Size Write data End");
        RnB_Wait(0);

        $display("*************Page Read*************\n");
        // page_read
*/
        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{3'b000,halfword,4'b0111});
        reg_write(4'h2,{PageSize[7:0]});
        reg_write(4'h3,{2'b00,NoOption,PageSize[11:8]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h00);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=16;
        RnB_Wait(2'b00);
        Data_Read(PageSize,halfword);
        $display($time,"           HalfWord Size Read End");
/*
        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag

        reg_write(4'h0,8'b1100_0001);
        reg_write(4'h1,{2'b00,word,4'b0111});
        reg_write(4'h2,{PageSize[6:0],1'b0});
        reg_write(4'h3,{1'b0,NoOption,PageSize[11:7]});

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h00);
        reg_write(4'h3,8'h01);

        reg_write(4'h0,8'h00);
        reg_write(4'h1,8'h00);
        reg_write(4'h2,8'h30);
        reg_write(4'h3,8'h00);

        rnum=17;
        RnB_Wait(0);
        Data_Read(PageSize/2,word);
        $display($time,"           Word Size Read End\n");
        $display("*********16Bit IO Read Write Test End*********\n");
*/
    `endif
`endif







        reg_read (5'd6,rddata);
        reg_read (5'd7,rddata);
        reg_read (5'd8,rddata);
        reg_read (5'd9,rddata);
        reg_read (5'd10,rddata);
        reg_read (5'd11,rddata);
        reg_read (5'd12,rddata);
        reg_read (5'd13,rddata);
        reg_read (5'd14,rddata);
        reg_read (5'd15,rddata);

  
`ifdef dual
    num=4224;
`else
    num=2112;
`endif

$readmemh ("./rwdata/write0.dat", wmem);
$readmemh ("./rwdata/read0.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 0",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end
$readmemh ("./rwdata/write1.dat", wmem);
$readmemh ("./rwdata/read1.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 1",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end

$readmemh ("./rwdata/write2.dat", wmem);
$readmemh ("./rwdata/read2.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 2",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end

$display("OK");
$stop;


end //initial begin



endmodule









